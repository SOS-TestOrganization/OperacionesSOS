
/*------------------------------------------------------------------------------------------------------------------------------------------
* MÃ©todo o PRG		:		spRegistrarCuentasContratosBeneficiariosPLUS							
* Desarrollado por	: <\A	Carlos Vela - Qvision	A\>	
* DescripciÃ³n		: <\D	Crea los beneficiarios incluidos en el estado de cuenta  D\>
* Observaciones		: <\O 	O\>	
* ParÃ¡metros		: <\P 	P\>	
* Variables			: <\V	V\>	
* Fecha CreaciÃ³n	: <\FC	2019/05/23	FC\>
*------------------------------------------------------------------------------------------------------------------------------------------*/
CREATE Procedure [dbo].[spRegistrarCuentasContratosBeneficiariosPLUS]
	@mnsje_slda				varchar(750)	Output,
	@cdgo_slda				udtCodigo		Output	
As
Begin
	Set Nocount On

	Declare	@lnMaximoConsecutivoCuentaContsBeneficiarios udtConsecutivo,
			@filasAfectadas int,
			@PorcentajeIVA udtValorDecimales =0,
			@CONCEPTO_IVA INT=3

	Begin Try 
		Set @mnsje_slda	= '';
		Set @cdgo_slda = 0;

		select @PorcentajeIVA=prcntje/100
		From       bdcarteraPac.dbo.tbconceptosliquidacion_vigencias 
		where cnsctvo_cdgo_cncpto_lqdcn = @CONCEPTO_IVA
		and getdate() between inco_vgnca and fn_vgnca

		Select	@lnMaximoConsecutivoCuentaContsBeneficiarios = isnull(max(cnsctvo_estdo_cnta_cntrto_bnfcro) ,0)
		From	dbo.tbCuentasContratosBeneficiarios

		-- Identificamos los estados de cuenta de los beneficiarios
		insert into #tmpCuentasContratosBeneficiarios
		Select 		
				ROW_NUMBER() OVER(ORDER BY e.cnsctvo_estdo_cnta_cntrto ASC)+@lnMaximoConsecutivoCuentaContsBeneficiarios  cnsctvo_estdo_cnta_cntrto_bnfcro,
				e.cnsctvo_estdo_cnta_cntrto,
				a.cnsctvo_bnfcro,
				a.nmro_unco_idntfccn_bnfcro, 
				b.vlr_trfa+ (b.vlr_trfa * @PorcentajeIVA) vlr,
				b.vlr_trfa
		From #tmpBeneficiarios a
		inner join #tmpTarifaSucursal b
			on b.nmro_unco_idntfccn_empldr=a.nmro_unco_idntfccn_empldr
			AND b.cnsctvo_cdgo_clse_aprtnte_empldr=a.cnsctvo_cdgo_clse_aprtnte
			AND b.cnsctvo_scrsl_empldr=a.cnsctvo_scrsl 
		inner join #tmpEstadosCuentaPlus c
			on 	b.nmro_unco_idntfccn_rspnsble=c.nmro_unco_idntfccn_empldr
			AND b.cnsctvo_cdgo_clse_aprtnte_rspnsble=c.cnsctvo_cdgo_clse_aprtnte
			AND b.cnsctvo_scrsl_rspnsble=c.cnsctvo_scrsl 
		inner join #tmpEstadosCuentaContratos e With(NoLock) 
		on  e.cnsctvo_estdo_cnta=c.cnsctvo_estdo_cnta 
		and e.cnsctvo_cdgo_tpo_cntrto=a.cnsctvo_cdgo_tpo_cntrto
		and	e.nmro_cntrto=a.nmro_cntrto


		Insert into dbo.tbCuentasContratosBeneficiarios (
				cnsctvo_estdo_cnta_cntrto_bnfcro,
				cnsctvo_estdo_cnta_cntrto,
				cnsctvo_bnfcro,
				nmro_unco_idntfccn_bnfcro, 
				vlr 
		)
		Select 
				cnsctvo_estdo_cnta_cntrto_bnfcro,
				cnsctvo_estdo_cnta_cntrto,
				cnsctvo_bnfcro,
				nmro_unco_idntfccn_bnfcro, 
				vlr 
		from #tmpCuentasContratosBeneficiarios


		set @filasAfectadas=@@ROWCOUNT
		Set @mnsje_slda	= 'Se crearon '+CAST(@filasAfectadas AS VARCHAR(12))+ ' cuentas contrato beneficiarios.'; 

	End Try
	Begin Catch
		Set @mnsje_slda	= ERROR_PROCEDURE()+' '+Concat(ERROR_MESSAGE(), ' ', ERROR_PROCEDURE(), ' ', ERROR_LINE());
		Set @cdgo_slda	= 1;
	End Catch
	
End
