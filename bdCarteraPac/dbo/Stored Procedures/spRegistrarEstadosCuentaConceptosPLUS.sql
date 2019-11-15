
/*------------------------------------------------------------------------------------------------------------------------------------------
* MÃ©todo o PRG		:		spRegistrarEstadosCuentaConceptosPLUS							
* Desarrollado por	: <\A	Carlos Vela - Qvision	A\>	
* DescripciÃ³n		: <\D	Totaliza la cuenta por concepto  D\>
* Observaciones		: <\O 	O\>	
* ParÃ¡metros		: <\P 	P\>	
* Variables			: <\V	V\>	
* Fecha CreaciÃ³n	: <\FC	2019/05/23	FC\>
*------------------------------------------------------------------------------------------------------------------------------------------*/
CREATE Procedure [dbo].[spRegistrarEstadosCuentaConceptosPLUS]
	@lnNuevoConsCodigoLiquidacion udtConsecutivo,
	@mnsje_slda				udtObservacion	Output,
	@cdgo_slda				udtCodigo		Output	
As
Begin
	Set Nocount On

	--Obtenemos el IVA
	Declare @lnMaximoEstadosCuentaConceptos	udtConsecutivo,
			@filasAfectadas int

	Begin Try 
		Set @mnsje_slda	= '';
		Set @cdgo_slda = 0;

		insert into #tmpEstadosCuentaConceptos
		Select 
				@lnMaximoEstadosCuentaConceptos cnsctvo_estdo_cnta_cncpto_tmp,
				a.cnsctvo_estdo_cnta,
				d.cnsctvo_cdgo_cncpto_lqdcn,
				sum(d.vlr) vlr_cbrdo, --vlr_cbrdo
				sum(d.vlr) sldo, --sldo
				count(a.cnsctvo_estdo_cnta) cntdd -- cntdd 
		from dbo.tbEstadosCuenta a With(NoLock) 
		inner join dbo.tbEstadosCuentaContratos b With(NoLock) 
		on a.cnsctvo_estdo_cnta=b.cnsctvo_estdo_cnta 
		inner join dbo.tbCuentasContratosBeneficiarios c With(NoLock)
		on c.cnsctvo_estdo_cnta_cntrto=b.cnsctvo_estdo_cnta_cntrto 
		inner join dbo.tbCuentasBeneficiariosConceptos d With(NoLock)
		on d.cnsctvo_estdo_cnta_cntrto_bnfcro=c.cnsctvo_estdo_cnta_cntrto_bnfcro
		where a.cnsctvo_cdgo_lqdcn=@lnNuevoConsCodigoLiquidacion
		group by a.cnsctvo_estdo_cnta,d.cnsctvo_cdgo_cncpto_lqdcn

		Select	@lnMaximoEstadosCuentaConceptos = isnull(max(cnsctvo_estdo_cnta_cncpto) ,0)
		From	dbo.tbEstadosCuentaConceptos

		-- Totalizamos la cuenta por concepto 
		INSERT INTO dbo.tbEstadosCuentaConceptos
					(cnsctvo_estdo_cnta_cncpto
					,cnsctvo_estdo_cnta
					,cnsctvo_cdgo_cncpto_lqdcn
					,vlr_cbrdo
					,sldo
					,cntdd)
		Select
					@lnMaximoEstadosCuentaConceptos+ROW_NUMBER() OVER(ORDER BY cnsctvo_estdo_cnta_cncpto_tmp ASC)
					,cnsctvo_estdo_cnta
					,cnsctvo_cdgo_cncpto_lqdcn
					,vlr_cbrdo
					,sldo
					,cntdd
		from #tmpEstadosCuentaConceptos

		set @filasAfectadas=@@ROWCOUNT
		Set @mnsje_slda	= 'Se totalizaron '+CAST(@filasAfectadas AS VARCHAR(12))+ ' estados de cuenta por concepto.'; 

	End Try
	Begin Catch
		Set @mnsje_slda	= ERROR_PROCEDURE()+' '+Concat(ERROR_MESSAGE(), ' ', ERROR_PROCEDURE(), ' ', ERROR_LINE());
		Set @cdgo_slda	= 1;
	End Catch
	
End
