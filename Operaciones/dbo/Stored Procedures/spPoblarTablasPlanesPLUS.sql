
/*------------------------------------------------------------------------------------------------------------------------------------------
* Método o PRG		:		spPoblarTablasPlanesPLUS							
* Desarrollado por	: <\A	Carlos Vela - Qvision	A\>	
* Descripción		: <\D	Pobla las tablas temporales base D\>
* Observaciones		: <\O 	O\>	
* Parámetros		: <\P 	P\>	
* Variables			: <\V	V\>	
* Fecha Creación	: <\FC	2019/05/22	FC\>
*------------------------------------------------------------------------------------------------------------------------------------------*/

CREATE Procedure [dbo].[spPoblarTablasPlanesPLUS]
	@ldfechaCorte			datetime,
	@lnTipoContrato			int,
	@lnConsecutivoCodigoLiquidacion udtConsecutivo,
	@lnConceptoLiquidacion	udtConsecutivo,
	@lnConsCodigoPeriodoLiq  udtConsecutivo,
	@lnConsCodigoPlan		udtConsecutivo,
	@mnsje_slda				varchar(750)	Output,
	@cdgo_slda				udtCodigo		Output	
As
Begin
	Set Nocount On
	Declare @ADICIONAL smallint=4,
			@VALIDO char(1) = 'S',
			@ACTIVO char(1) = 'A'

	Begin Try 
	
		Set @mnsje_slda	= '';
		Set @cdgo_slda = 0;

		--Se identifican los usuarios a facturar en PAC PLUS Y PBS PLUS 

			INSERT INTO #tmpSucursalesProducto
			Select	distinct 
				ROW_NUMBER() OVER(ORDER BY c.nmro_idntfccn ASC) AS nmro_rgstro,
				e.cdgo_tpo_idntfccn,	
				c.nmro_idntfccn,	
				b.nmbre_scrsl,	
				a.cnsctvo_scrsl,
				a.nmro_unco_idntfccn_empldr, 
				a.cnsctvo_cdgo_clse_aprtnte,  
				b.sde_crtra_pc as cnsctvo_cdgo_sde, 
				a.cnsctvo_prdcto_scrsl,
				a.cnsctvo_prdcto
			From	bdAfiliacion.dbo.tbProductosxAportantes a With(NoLock) 
			Inner Join #tmpProductosLiq f
			ON a.cnsctvo_prdcto = f.cnsctvo_prdcto 
			Inner Join	bdAfiliacion.dbo.tbSucursalesAportante b With(NoLock)
			On	b.cnsctvo_scrsl	= a.cnsctvo_scrsl
			And b.nmro_unco_idntfccn_empldr	= a.nmro_unco_idntfccn_empldr
			And b.cnsctvo_cdgo_clse_aprtnte = a.cnsctvo_cdgo_clse_aprtnte
			Inner Join	bdAfiliacion.dbo.tbVinculados c With(NoLock)
			On	c.nmro_unco_idntfccn	= a.nmro_unco_idntfccn_empldr
			Inner Join	bdAfiliacion.dbo.tbTiposIdentificacion e With(NoLock)
			On	e.cnsctvo_cdgo_tpo_idntfccn	= c.cnsctvo_cdgo_tpo_idntfccn
			Where	 c.vldo	= @VALIDO
			and	@ldFechaCorte between inco_vgnca_asccn and fn_vgnca_asccn
			Order by b.nmbre_scrsl, a.cnsctvo_scrsl

			--Se seleccionan los contratos vigentes asociados a las sucursales consultadas
			INSERT INTO #tmpContratosVigentes
			select 
				c.cnsctvo_cdgo_tpo_cntrto,	
				c.nmro_cntrto,
				sp.nmro_unco_idntfccn_empldr,
				sp.cnsctvo_cdgo_clse_aprtnte,
				sp.cnsctvo_scrsl  
			from	#tmpSucursalesProducto										sp 
			inner join [BDAfiliacion].dbo.[tbCobranzas]							c With (Nolock) 
				on  sp.nmro_unco_idntfccn_empldr = c.nmro_unco_idntfccn_aprtnte  
				and sp.cnsctvo_cdgo_clse_aprtnte = c.cnsctvo_cdgo_clse_aprtnte
			inner join [BDAfiliacion].dbo.[tbVigenciasCobranzas]				vc With (Nolock)
				on	c.cnsctvo_cdgo_tpo_cntrto	= vc.cnsctvo_cdgo_tpo_cntrto
				and c.nmro_cntrto				= vc.nmro_cntrto
				and c.cnsctvo_cbrnza			= vc.cnsctvo_cbrnza
				and vc.cnsctvo_scrsl_ctznte		= sp.cnsctvo_scrsl
			inner join	[bdAfiliacion].dbo.tbProductosCobranza					pc With (Nolock)
				on	c.cnsctvo_cdgo_tpo_cntrto	= pc.cnsctvo_cdgo_tpo_cntrto
				and c.nmro_cntrto				= pc.nmro_cntrto
				and c.cnsctvo_cbrnza			= pc.cnsctvo_cbrnza
				and sp.cnsctvo_prdcto_scrsl		= pc.cnsctvo_prdcto_scrsl
				and sp.cnsctvo_prdcto			= pc.cnsctvo_prdcto
			inner join BdAfiliacion.dbo.tbContratos								cn With(NoLock)
				on cn.cnsctvo_cdgo_tpo_cntrto	= c.cnsctvo_cdgo_tpo_cntrto
				and cn.nmro_cntrto				= c.nmro_cntrto
			where	c.cnsctvo_cdgo_tpo_cntrto	= @lnTipoContrato		-- (1) PBS PLUS, (2) PAC PLUS
			and		c.estdo						= @ACTIVO 
			and		vc.estdo_rgstro				= @VALIDO
			and		@ldFechaCorte  between vc.inco_vgnca_cbrnza			and vc.fn_vgnca_cbrnza
			and		pc.estdo_rgstro				= @VALIDO
			and		@ldFechaCorte  between pc.inco_vgnca				and pc.fn_vgnca
			and		cn.cnsctvo_cdgo_pln			= @lnConsCodigoPlan		--BIENESTAR     solo aplica para PAC PLUS			
			and		cn.estdo_cntrto				= @ACTIVO
			group by 
			c.cnsctvo_cdgo_tpo_cntrto,	
			c.nmro_cntrto,
			sp.nmro_unco_idntfccn_empldr,
			sp.cnsctvo_cdgo_clse_aprtnte,
			sp.cnsctvo_scrsl;

			--Seleccionamos los beneficiarios de los contratos vigentes
			insert into #tmpBeneficiarios
			select 
				c.cnsctvo_cdgo_tpo_cntrto, 
				c.nmro_cntrto, 
				b.cnsctvo_bnfcro, 
				b.nmro_unco_idntfccn_bnfcro,
				c.nmro_unco_idntfccn_empldr,
				c.cnsctvo_cdgo_clse_aprtnte,
				c.cnsctvo_scrsl,
				CAST (0.0 AS numeric(12,0)) vlr,
				CAST (0.0 AS numeric(12,0)) iva			
			from #tmpContratosVigentes c 
			inner join bdAfiliacion.dbo.tbVigenciasBeneficiarios vb With(NoLock)
			on vb.cnsctvo_cdgo_tpo_cntrto = c.cnsctvo_cdgo_tpo_cntrto
			and vb.nmro_cntrto = c.nmro_cntrto
			inner join bdAfiliacion.dbo.tbBeneficiarios b With(NoLock)
			on vb.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto
			and vb.nmro_cntrto = b.nmro_cntrto
			and vb.cnsctvo_bnfcro = b.cnsctvo_bnfcro
			inner join bdAfiliacion.dbo.tbVinculados v With(NoLock)
			on b.nmro_unco_idntfccn_bnfcro  = v.nmro_unco_idntfccn
			Inner Join bdAfiliacion.dbo.tbTiposIdentificacion ti With(NoLock)
			On ti.cnsctvo_cdgo_tpo_idntfccn	= v.cnsctvo_cdgo_tpo_idntfccn
			Inner Join bdAfiliacion.dbo.tbTiposAfiliado ta With(NoLock) 
			On b.cnsctvo_cdgo_tpo_afldo = ta.cnsctvo_cdgo_tpo_afldo
			where @ldFechaCorte  between vb.inco_vgnca_estdo_bnfcro and vb.fn_vgnca_estdo_bnfcro
			--and b.cnsctvo_cdgo_tpo_afldo != @ADICIONAL -- Adicionales, Comentado por solicitud de Comercial
			and vb.estdo_rgstro=@VALIDO
			and b.estdo=@ACTIVO 

			--Identificamos las liquidaciones que se han realizado para el periodo activo con el concepto PLUS
			insert into #tmpContratosLiqConceptoPlus
			Select 
				a.cnsctvo_cdgo_lqdcn,
				a.cnsctvo_cdgo_prdo_lqdcn,
				b.cnsctvo_estdo_cnta, 
				c.cnsctvo_cdgo_tpo_cntrto,
				c.nmro_cntrto,
				d.cnsctvo_cdgo_cncpto_lqdcn
			from tbLiquidaciones a With(NoLock)
			inner join tbEstadosCuenta b With(NoLock)
			on a.cnsctvo_cdgo_lqdcn=b.cnsctvo_cdgo_lqdcn 
			inner join tbEstadosCuentaContratos c With(NoLock)
			on b.cnsctvo_estdo_cnta=c.cnsctvo_estdo_cnta 
			inner join tbEstadosCuentaConceptos d With(NoLock)
			On d.cnsctvo_estdo_cnta=b.cnsctvo_estdo_cnta 
			where a.cnsctvo_cdgo_prdo_lqdcn=@lnConsCodigoPeriodoLiq 
			and d.cnsctvo_cdgo_cncpto_lqdcn=@lnConceptoLiquidacion


			--Extraemos las sucursales que tiene contratos pendientes por liquidar
			insert into #tmpSucuralesNoLiqPlus
			Select  
				distinct 
				c.nmro_unco_idntfccn_empldr,
				c.cnsctvo_cdgo_clse_aprtnte,
				c.cnsctvo_scrsl			
			from #tmpContratosVigentes c 
				Left Join #tmpContratosLiqConceptoPlus d 
				On d.cnsctvo_cdgo_tpo_cntrto=c.cnsctvo_cdgo_tpo_cntrto 
				And d.nmro_cntrto=c.nmro_cntrto
				Where d.nmro_cntrto is null


			--Se saca la tarifa del producto (PLUS) para la sucursal		
			insert into #tmpTarifaSucursal 
			Select distinct 
				 ROW_NUMBER() OVER(ORDER BY nmro_unco_idntfccn_rspnsble ASC) nm_rgstro,
				 nmro_unco_idntfccn_rspnsble, 
				 cnsctvo_cdgo_clse_aprtnte_rspnsble,  
				 cnsctvo_scrsl_rspnsble, 
				 vlr_trfa,
				 (@lnConsecutivoCodigoLiquidacion  + 1) cnsctvo_cdgo_crtro_lqdcn,
				 b.nmro_unco_idntfccn_empldr,
				 b.cnsctvo_cdgo_clse_aprtnte_empldr,
				 b.cnsctvo_scrsl_empldr
			from #tmpSucursalesProducto a    
				Inner join BDAfiliacion.dbo.tbTarifasConceptosPorSucursal  b With(NoLock)
				on  a.nmro_unco_idntfccn_empldr  = b.nmro_unco_idntfccn_empldr	
					and a.cnsctvo_cdgo_clse_aprtnte = b.cnsctvo_cdgo_clse_aprtnte_empldr
					and a.cnsctvo_scrsl = b.cnsctvo_scrsl_empldr 
				Inner Join #tmpSucuralesNoLiqPlus c 
				On b.nmro_unco_idntfccn_empldr=c.nmro_unco_idntfccn_empldr
				   And   b.cnsctvo_cdgo_clse_aprtnte_empldr = c.cnsctvo_cdgo_clse_aprtnte
				   And	 b.cnsctvo_scrsl_empldr = c.cnsctvo_scrsl
			where @ldFechaCorte between b.inco_vgnca and b.fn_vgnca
			
			--Con esto aseguramos que si una sucursal ya tiene liquidado el contrato por conceptos plus, 
			--esta no se incluya.

			Set @mnsje_slda	= 'Se poblaron las tablas temporales base, exitosamente.';


	End Try
	Begin Catch
		Set @mnsje_slda	= ERROR_PROCEDURE()+' '+Concat(ERROR_MESSAGE(), ' ', ERROR_PROCEDURE(), ' ', ERROR_LINE());
		Set @cdgo_slda	= 1;
	End Catch
	
End
