

/*------------------------------------------------------------------------------------------------------------------------------------------
* MÃ©todo o PRG		:		spHistoricoEstadoLiquidacion							
* Desarrollado por	: <\A	Carlos Vela - Qvision	A\>	
* DescripciÃ³n		: <\D	Se encarga de registrar en el historico el total de la liquidacion y #contratos incluidos D\>
* Observaciones		: <\O 	O\>	
* ParÃ¡metros		: <\P 	P\>	
* Variables			: <\V	V\>	
* Fecha CreaciÃ³n	: <\FC	2019/05/23	FC\>
*------------------------------------------------------------------------------------------------------------------------------------------*/
CREATE Procedure [dbo].[spRegistrarHistoricoEstadoLiquidacionPLUS]
	@lnNuevoConsCodigoLiquidacion udtConsecutivo,
	@lnConceptoLiquidacion  udtConsecutivo,
	@lcUsuario				udtUsuario,
	@mnsje_slda				varchar(750)	Output,
	@cdgo_slda				udtCodigo		Output	
As
Begin
	Set Nocount On

	--Obtenemos el IVA
	Declare @ldValorLiquidado udtValorDecimales =0,
	    @lnNumEstadosCuenta int=0,
		@lnNumContratos int=0,
        @lnMaximoHistoricoEstadoLiquidacion	udtConsecutivo,
		@filasAfectadas int=0,
		@ESTADO_LIQU_FINALIZADA int=3,
		@lcMensaje	varchar(500),
		@lnCodigo	int 

	Begin Try 
		Set @mnsje_slda	= '';
		Set @cdgo_slda = 0;

		--Valor Liquidado
		Select 
			@ldValorLiquidado = sum(vlr_cbrdo),
			@lnNumEstadosCuenta = count(cnsctvo_estdo_cnta) 
		from #tmpEstadosCuentaConceptos 
		where cnsctvo_cdgo_cncpto_lqdcn=@lnConceptoLiquidacion;


		--Totalizamos la cantidad de contratos afectados
		Select 
			 @lnNumContratos=count(b.nmro_cntrto) 	
		from dbo.tbEstadosCuenta a With(NoLock) 
		inner join dbo.tbEstadosCuentaContratos b With(NoLock) 
		on a.cnsctvo_estdo_cnta=b.cnsctvo_estdo_cnta 
		where a.cnsctvo_cdgo_lqdcn=@lnNuevoConsCodigoLiquidacion

		Select	@lnMaximoHistoricoEstadoLiquidacion = isnull(max(cnsctvo_hstrco_estdo_lqdcn) ,0)
			From	dbo.tbHistoricoEstadoLiquidacion With(NoLock) 

	    --Actualizamos la liquidacion con los valores calculados
		Update dbo.tbLiquidaciones 
			set nmro_estds_cnta=@lnNumEstadosCuenta,
				vlr_lqddo=@ldValorLiquidado,
				nmro_cntrts=@lnNumContratos,
				cnsctvo_cdgo_estdo_lqdcn=@ESTADO_LIQU_FINALIZADA
		Where cnsctvo_cdgo_lqdcn=@lnNuevoConsCodigoLiquidacion;

		--Si se liquidaron contratos plus, se registra la información de facturación electronica
		If 	@lnNumContratos > 0
		Begin 

			EXEC [dbo].[spRegistrarInfoFEPLUS] 
											@lnNuevoConsCodigoLiquidacion, 
											@lcMensaje Output,
											@lnCodigo Output
		End	

		--Registro el historico de la liquidacion
		INSERT INTO dbo.tbHistoricoEstadoLiquidacion
				   (cnsctvo_hstrco_estdo_lqdcn
				   ,cnsctvo_cdgo_estdo_lqdcn
				   ,cnsctvo_cdgo_lqdcn
				   ,nmro_estds_cnta
				   ,vlr_lqddo
				   ,nmro_cntrts
				   ,usro_crcn
				   ,fcha_crcn)
		select (@lnMaximoHistoricoEstadoLiquidacion+1),
			   @ESTADO_LIQU_FINALIZADA,
			   @lnNuevoConsCodigoLiquidacion,
			   @lnNumEstadosCuenta,
			   @ldValorLiquidado,
			   @lnNumContratos,
			   @lcUsuario,
			   getdate()

		set @filasAfectadas=@@ROWCOUNT
		Set @mnsje_slda	= 'Se registro en el historico de liquidaciones, '+CAST(@filasAfectadas AS VARCHAR(12))+ ' liquidacion.'; 

		if @lnCodigo <>0 
			BEGIN
				SET @mnsje_slda=@mnsje_slda+' ERROR: '+@lcMensaje;
				SET @cdgo_slda=1;
			END
			

	End Try
	Begin Catch
		Set @mnsje_slda	= ERROR_PROCEDURE()+' '+Concat(ERROR_MESSAGE(), ' ', ERROR_PROCEDURE(), ' ', ERROR_LINE());
		Set @cdgo_slda	= 1;
	End Catch
	
End
