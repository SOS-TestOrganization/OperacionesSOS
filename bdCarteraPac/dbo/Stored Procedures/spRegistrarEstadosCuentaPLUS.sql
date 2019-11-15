
/*------------------------------------------------------------------------------------------------------------------------------------------
* MÃ©todo o PRG		:		spRegistrarEstadosCuentaPLUS							
* Desarrollado por	: <\A	Carlos Vela - Qvision	A\>	
* DescripciÃ³n		: <\D	Crea los estados de cuenta D\>
* Observaciones		: <\O 	O\>	
* ParÃ¡metros		: <\P 	P\>	
* Variables			: <\V	V\>	
* Fecha CreaciÃ³n	: <\FC	2019/05/23	FC\>
*------------------------------------------------------------------------------------------------------------------------------------------*/
CREATE Procedure [dbo].[spRegistrarEstadosCuentaPLUS]
	@lnNuevoConsCodigoLiquidacion udtConsecutivo,
	@lcUsuario				udtUsuario,
	@lnNumEstadosCuentaCreados int Output,
	@mnsje_slda				varchar(750)	Output,
	@cdgo_slda				udtCodigo		Output	
As
Begin
	Set Nocount On

	Declare @lnMaximoConsecutivoEstadoCuenta int,
			@consecutivoEstadoDocumentoIngresado int=1,
			@vlr_actl							int,
			@vlr_antrr							int,
			@CONSECUTIVO_COD_ESTADO_CUENTA		tinyint=1,
			@lnConsCodigoResolucionDIAN	int = 2, -- PAC
			@lnConsCodigoTipoDocumento	int =6, -- Factura
			@INMEDIATO varchar(10) = 'INMEDIATO',
			@lcMensaje	varchar(500),
			@lnCodigo	int


	Create table #TmpEstadoCuentaNum
	(
		ID_Num						int IDENTITY(1,1), 
		cnsctvo_estdo_cnta			int,
		nmro_estdo_cnta				varchar(15)
	)

	Begin Try 
	
		Set @mnsje_slda	= '';
		Set @cdgo_slda = 0;

		Select	@lnMaximoConsecutivoEstadoCuenta = isnull(max(cnsctvo_estdo_cnta) ,0)
		From	dbo.tbEstadosCuenta

		Insert into	dbo.tbEstadosCuenta
		(
			cnsctvo_estdo_cnta,
			cnsctvo_cdgo_lqdcn,
			fcha_gnrcn,
			nmro_unco_idntfccn_empldr,
			cnsctvo_scrsl,
			cnsctvo_cdgo_clse_aprtnte,
			ttl_fctrdo,
			vlr_iva,
			sldo_fvr,
			ttl_pgr,
			sldo_estdo_cnta,
			sldo_antrr,
			Cts_Cnclr,
			Cts_sn_Cnclr,
			nmro_estdo_cnta,
			cnsctvo_cdgo_estdo_estdo_cnta,
			usro_crcn,
			Fcha_crcn,
			fcha_imprsn,
			cnsctvo_cdgo_prdcdd_prpgo,
			dgto_chqo,
			imprso,
			usro_imprsn,
			cnsctvo_cdgo_estdo_dcmnto_fe,
			txto_vncmnto,
			cnsctvo_cdgo_rslcn_dn,
			cnsctvo_cdgo_tpo_dcmnto
		)
		Select 		
				nm_rgstro +  @lnMaximoConsecutivoEstadoCuenta ,
				@lnNuevoConsCodigoLiquidacion,
				getdate(),  --fcha_gnrcn,
				nmro_unco_idntfccn_rspnsble,
				cnsctvo_scrsl_rspnsble,
				cnsctvo_cdgo_clse_aprtnte_rspnsble,
				0,--ttl_fctrdo
				0,--vlr_iva
				0,--sldo_fvr
				0,--ttl_pgr
				0,--sldo_estdo_cnta
				0,--sldo_antrr
				1,--Cts_Cnclr
				0,--Cts_sn_Cnclr
				0,--nmro_estdo_cnta
				0,--cnsctvo_cdgo_estdo_estdo_cta
				@lcUsuario, --usro_crcn
				getdate(),--Fcha_crcn
				null, --fcha_imprsn
				1,
				null,		--digito de chequeo
				'N',		--Impreso
				NULL,		--Usuario de creacion
				@consecutivoEstadoDocumentoIngresado,
				null,
				@lnConsCodigoResolucionDIAN,
				@lnConsCodigoTipoDocumento			
		From	#tmpTarifaSucursal

		--Estados de cuenta creados
		SET @lnNumEstadosCuentaCreados= @@ROWCOUNT

		Insert Into	#TmpEstadoCuentaNum
		Select 		cnsctvo_estdo_cnta,
					Convert(varchar(15),'0')	nmro_estdo_cnta
		From		dbo.tbEstadosCuenta With(NoLock)
		Where 		cnsctvo_cdgo_lqdcn 	=	 @lnNuevoConsCodigoLiquidacion
	

		insert into #tmpEstadosCuentaPlus
		Select 
			cnsctvo_estdo_cnta,
			cnsctvo_cdgo_lqdcn,
			fcha_gnrcn,
			nmro_unco_idntfccn_empldr,
			cnsctvo_scrsl,
			cnsctvo_cdgo_clse_aprtnte,
			ttl_fctrdo,
			vlr_iva,
			sldo_fvr,
			ttl_pgr,
			sldo_estdo_cnta,
			sldo_antrr,
			Cts_Cnclr,
			Cts_sn_Cnclr,
			nmro_estdo_cnta,
			cnsctvo_cdgo_estdo_dcmnto_fe,
			txto_vncmnto
			from dbo.tbEstadosCuenta
		where cnsctvo_cdgo_lqdcn=@lnNuevoConsCodigoLiquidacion;

		--set @lnNumEstadosCuentaCreados=@@ROWCOUNT
		Set @mnsje_slda	= 'Se crearon '+CAST(@lnNumEstadosCuentaCreados AS VARCHAR(12))+ ' estados de cuenta.'; 

	End Try
	Begin Catch
		Set @mnsje_slda	= OBJECT_NAME(@@PROCID)+' '+Concat(ERROR_MESSAGE(), ' ', ERROR_PROCEDURE(), ' ', ERROR_LINE());
		Set @cdgo_slda	= 1;
	End Catch

	DROP TABLE #TmpEstadoCuentaNum;
	
End
