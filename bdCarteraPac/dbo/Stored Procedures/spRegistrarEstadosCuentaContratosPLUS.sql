CREATE Procedure [dbo].[spRegistrarEstadosCuentaContratosPLUS]
	@lnNuevoConsCodigoLiquidacion udtConsecutivo,
	@mnsje_slda				udtObservacion	Output,
	@cdgo_slda				udtCodigo		Output	
As
Begin
	Set Nocount On

	-- Insertamos los estados de cuenta por empresa
	Declare	@lnMaximoConsecutivoContratoEstadoCuenta	udtConsecutivo=1,
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


		insert into #tmpTotalEstadoCuenta
		Select 		
				@lnMaximoConsecutivoContratoEstadoCuenta cnsctvo_estdo_cnta_cntrto_tmp,
				c.cnsctvo_estdo_cnta,
				a.cnsctvo_cdgo_tpo_cntrto,
				a.nmro_cntrto,
				sum(b.vlr_trfa+(b.vlr_trfa*@PorcentajeIVA)) vlr_cbrdo, -- vlr_cbrdo
				sum(b.vlr_trfa+(b.vlr_trfa*@PorcentajeIVA)) sldo, --sldo
				0 sldo_fvr, --Sldo_fvr  del contrato
				count(1) cntdd_bnfcrs, --cntdd_bnfcrs
				getdate() fcha_ultma_mdfccn,
				null usro_ultma_mdfccn,
				sum(b.vlr_trfa) vlr_trfa,
				sum(b.vlr_trfa*@PorcentajeIVA) vlr_iva
		From #tmpBeneficiarios a
		inner join #tmpTarifaSucursal b
			on b.nmro_unco_idntfccn_empldr=a.nmro_unco_idntfccn_empldr
			AND b.cnsctvo_cdgo_clse_aprtnte_empldr=a.cnsctvo_cdgo_clse_aprtnte
			AND b.cnsctvo_scrsl_empldr=a.cnsctvo_scrsl 
		inner join #tmpEstadosCuentaPlus c
			on 	b.nmro_unco_idntfccn_rspnsble=c.nmro_unco_idntfccn_empldr
			AND b.cnsctvo_cdgo_clse_aprtnte_rspnsble=c.cnsctvo_cdgo_clse_aprtnte
			AND b.cnsctvo_scrsl_rspnsble=c.cnsctvo_scrsl 
        left join #tmpContratosLiqConceptoPlus d --tabla que tiene los contratos liquidados para el concepto PLUS 
			On d.cnsctvo_cdgo_tpo_cntrto=a.cnsctvo_cdgo_tpo_cntrto 
			And d.nmro_cntrto=a.nmro_cntrto  
		Where d.nmro_cntrto is null --Seleccionamos los contratos que no se les hayan liquidado el concepto plus	 
		group by c.cnsctvo_estdo_cnta, a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto

		insert into #tmpResumenEstadoCuenta
		Select 
			cnsctvo_estdo_cnta, 
			sum(vlr_trfa) ttl_fctrdo, 
			sum(vlr_iva)  vlr_iva,
			sum(vlr_trfa)+sum(vlr_iva) ttl_pgr,
			sum(vlr_trfa)+sum(vlr_iva) sldo_estdo_cnta
		From  #tmpTotalEstadoCuenta 
		group by cnsctvo_estdo_cnta 

		
		-- Actualizamos el total que se debe pagar por cuenta
		update a 
			Set a.ttl_fctrdo=b.ttl_fctrdo,
				a.vlr_iva=b.vlr_iva,
				a.ttl_pgr=b.ttl_pgr,
				a.sldo_estdo_cnta=b.sldo_estdo_cnta 
			from dbo.tbEstadosCuenta a
			inner join #tmpResumenEstadoCuenta b
			on a.cnsctvo_estdo_cnta=b.cnsctvo_estdo_cnta

		Select	@lnMaximoConsecutivoContratoEstadoCuenta = isnull(max(cnsctvo_estdo_cnta_cntrto) ,0)
		From	dbo.TbEstadosCuentaContratos;

		Insert into	dbo.TbEstadosCuentaContratos
		(
			cnsctvo_estdo_cnta_cntrto,
			cnsctvo_estdo_cnta,
			cnsctvo_cdgo_tpo_cntrto,
			nmro_cntrto,
			vlr_cbrdo,
			sldo,
			sldo_fvr,
			cntdd_bnfcrs,
			fcha_ultma_mdfccn,
			usro_ultma_mdfccn
		)
		select 
			ROW_NUMBER() OVER(ORDER BY cnsctvo_estdo_cnta ASC)  + @lnMaximoConsecutivoContratoEstadoCuenta,
			cnsctvo_estdo_cnta,
			cnsctvo_cdgo_tpo_cntrto,
			nmro_cntrto,
			vlr_cbrdo,
			sldo,
			sldo_fvr,
			cntdd_bnfcrs,
			fcha_ultma_mdfccn,
			usro_ultma_mdfccn
		From #tmpTotalEstadoCuenta 

		--Recuperamos los estados de cuentas contratos que se acaban de insertar
		insert into #tmpEstadosCuentaContratos
		Select 
			a.cnsctvo_estdo_cnta_cntrto,
			a.cnsctvo_estdo_cnta,
			a.cnsctvo_cdgo_tpo_cntrto,
			a.nmro_cntrto,
			a.vlr_cbrdo,
			a.sldo,
			a.sldo_fvr,
			a.cntdd_bnfcrs,
			a.fcha_ultma_mdfccn,
			a.usro_ultma_mdfccn
		From dbo.TbEstadosCuentaContratos a With(NoLock) 
			inner join dbo.tbEstadosCuenta b 
			on a.cnsctvo_estdo_cnta=b.cnsctvo_estdo_cnta
		Where cnsctvo_estdo_cnta_cntrto> @lnMaximoConsecutivoContratoEstadoCuenta
		and b.cnsctvo_cdgo_lqdcn=@lnNuevoConsCodigoLiquidacion 
		;

		set @filasAfectadas=@@ROWCOUNT
		Set @mnsje_slda	= 'Se crearon '+CAST(@filasAfectadas AS VARCHAR(12))+ ' estados de cuenta contrato.'; 

	End Try
	Begin Catch
		Set @mnsje_slda	= ERROR_PROCEDURE()+' '+Concat(ERROR_MESSAGE(), ' ', ERROR_PROCEDURE(), ' ', ERROR_LINE());
		Set @cdgo_slda	= 1;
	End Catch
	
End
