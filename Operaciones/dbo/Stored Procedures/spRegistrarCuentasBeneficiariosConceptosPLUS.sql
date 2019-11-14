
/*------------------------------------------------------------------------------------------------------------------------------------------
* MÃ©todo o PRG		:		spRegistrarCuentasBeneficiariosConceptosPLUS							
* Desarrollado por	: <\A	Carlos Vela - Qvision	A\>	
* DescripciÃ³n		: <\D	Calcula el valor del concepto y del iva  D\>
* Observaciones		: <\O 	O\>	
* ParÃ¡metros		: <\P 	P\>	
* Variables			: <\V	V\>	
* Fecha CreaciÃ³n	: <\FC	2019/05/23	FC\>
*------------------------------------------------------------------------------------------------------------------------------------------*/
CREATE Procedure [dbo].[spRegistrarCuentasBeneficiariosConceptosPLUS]
	@lnConceptoLiquidacion	udtConsecutivo  Output,
	@mnsje_slda				udtObservacion	Output,
	@cdgo_slda				udtCodigo		Output	
As
Begin
	Set Nocount On

	--Obtenemos el IVA
	Declare @PorcentajeIVA udtValorDecimales =0,
			@filasAfectadas int,
			@CONCEPTO_IVA INT=3

	Begin Try 
		Set @mnsje_slda	= '';
		Set @cdgo_slda = 0;

		select @PorcentajeIVA=prcntje/100
		From       bdcarteraPac.dbo.tbconceptosliquidacion_vigencias 
		where cnsctvo_cdgo_cncpto_lqdcn = @CONCEPTO_IVA
		and getdate() between inco_vgnca and fn_vgnca


		--Registramos el valor del concepto 
		Insert into dbo.tbCuentasBeneficiariosConceptos(
			cnsctvo_estdo_cnta_cntrto_bnfcro,
			cnsctvo_cdgo_cncpto_lqdcn,
			vlr
		)
		select 
			cnsctvo_estdo_cnta_cntrto_bnfcro,
			@lnConceptoLiquidacion,
			sum(vlr_trfa)  vlr
		from #tmpCuentasContratosBeneficiarios
		group by cnsctvo_estdo_cnta_cntrto_bnfcro;
		
		set @filasAfectadas=@@ROWCOUNT

		--Registramos el IVA del concepto 
		Insert into dbo.tbCuentasBeneficiariosConceptos(
			cnsctvo_estdo_cnta_cntrto_bnfcro,
			cnsctvo_cdgo_cncpto_lqdcn,
			vlr
		)
		select 
			cnsctvo_estdo_cnta_cntrto_bnfcro,
			@CONCEPTO_IVA,
			sum(vlr_trfa)*@PorcentajeIVA
		from #tmpCuentasContratosBeneficiarios
		group by cnsctvo_estdo_cnta_cntrto_bnfcro; 

		set @filasAfectadas=@@ROWCOUNT+@filasAfectadas
		Set @mnsje_slda	= 'Se crearon '+CAST(@filasAfectadas AS VARCHAR(12))+ ' valorizaciones en cuentas beneficiarios concepto.'; 

	End Try
	Begin Catch
		Set @mnsje_slda	= ERROR_PROCEDURE()+' '+Concat(ERROR_MESSAGE(), ' ', ERROR_PROCEDURE(), ' ', ERROR_LINE());
		Set @cdgo_slda	= 1;
	End Catch
	
End
