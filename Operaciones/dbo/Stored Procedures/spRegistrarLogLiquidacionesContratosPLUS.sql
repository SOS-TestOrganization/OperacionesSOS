
/*------------------------------------------------------------------------------------------------------------------------------------------
* Método o PRG		:		spRegistrarLogLiquidacionesContratosPLUS							
* Desarrollado por	: <\A	Carlos Vela - Qvision	A\>	
* Descripción		: <\D	Registra en log, a los beneficiarios de la sucursal que quedaron por fuera del proceso de liquidacion D\>
* Observaciones		: <\O 	O\>	
* Parámetros		: <\P 	P\>	
* Variables			: <\V	V\>	
* Fecha Creación	: <\FC	2019/05/24	FC\>
*------------------------------------------------------------------------------------------------------------------------------------------*/

CREATE Procedure [dbo].[spRegistrarLogLiquidacionesContratosPLUS]
	@ldfechaCorte			datetime,
	@lnTipoContrato			int,
	@lnConsecutivoCodigoLiquidacion udtConsecutivo,
	@lnConceptoLiquidacion	udtConsecutivo,
	@lnConsCodigoPlan		udtConsecutivo,
	@mnsje_slda				varchar(750)	Output,
	@cdgo_slda				udtCodigo		Output	
As
Begin
	Set Nocount On
	Declare @ADICIONAL smallint=4,
			@CONTRATO_NO_VIGENTE varchar(50)='CONTRATO NO VIGENTE',
			@BENEFICIARIO_NO_VIGENTE varchar(50)='BENEFICIARIO NO VIGENTE',
			@BENEFICIARIO_ADICIONAL  varchar(50)='BENEFICIARIO ADICIONAL',
			@BENEFICIARIO_YA_FACTURADO varchar(50)='BENEFICIARIO YA FACTURADO',
			@filasAfectadas int=0,
			@VALIDO char(1) = 'S',
			@ACTIVO char(1) = 'A'

	Begin Try 
	
		Set @mnsje_slda	= '';
		Set @cdgo_slda = 0;

		Insert into #tmpContratosYaLiquidados
		Select distinct cnsctvo_cdgo_tpo_cntrto, 
			nmro_cntrto				 
		from  #tmpContratosLiqConceptoPlus cl 


		Insert Into #tmpContratosNoValidos
		Select 
			c.cnsctvo_cdgo_tpo_cntrto,	
			c.nmro_cntrto, 
			sp.nmro_unco_idntfccn_empldr,
			sp.cnsctvo_scrsl,
			sp.cnsctvo_cdgo_clse_aprtnte,
			@CONTRATO_NO_VIGENTE causa 		
		From #tmpSucursalesProducto sp 
			inner join bdAfiliacion.[dbo].[tbCobranzas] c With (NoLock) 
			on c.nmro_unco_idntfccn_aprtnte = sp.nmro_unco_idntfccn_empldr
			and sp.cnsctvo_cdgo_clse_aprtnte = c.cnsctvo_cdgo_clse_aprtnte
			inner join bdAfiliacion.[dbo].[tbVigenciasCobranzas] vc With (NoLock)
			on c.cnsctvo_cdgo_tpo_cntrto = vc.cnsctvo_cdgo_tpo_cntrto
			and c.nmro_cntrto = vc.nmro_cntrto
			and c.cnsctvo_cbrnza = vc.cnsctvo_cbrnza
			and vc.cnsctvo_scrsl_ctznte = sp.cnsctvo_scrsl
			inner join	[bdAfiliacion].dbo.tbProductosCobranza					pc With (Nolock)
			on	c.cnsctvo_cdgo_tpo_cntrto	= pc.cnsctvo_cdgo_tpo_cntrto
			and c.nmro_cntrto				= pc.nmro_cntrto
			and c.cnsctvo_cbrnza			= pc.cnsctvo_cbrnza
			and sp.cnsctvo_prdcto_scrsl		= pc.cnsctvo_prdcto_scrsl
			and sp.cnsctvo_prdcto			= pc.cnsctvo_prdcto
			inner join BdAfiliacion.dbo.tbContratos cn With(NoLock) 
			on cn.cnsctvo_cdgo_tpo_cntrto = c.cnsctvo_cdgo_tpo_cntrto
			and cn.nmro_cntrto = c.nmro_cntrto
		Where @ldfechaCorte  between vc.inco_vgnca_cbrnza and vc.fn_vgnca_cbrnza
			and c.cnsctvo_cdgo_tpo_cntrto = @lnTipoContrato -- 1 para PBS PLUS  2  - para PAC PLUS
			and cn.cnsctvo_cdgo_pln  = @lnConsCodigoPlan
			and vc.estdo_rgstro=@VALIDO
			and cn.estdo_cntrto <> @ACTIVO
		group by 
			c.cnsctvo_cdgo_tpo_cntrto,	
			c.nmro_cntrto,
			sp.nmro_unco_idntfccn_empldr,
			sp.cnsctvo_scrsl,
			sp.cnsctvo_cdgo_clse_aprtnte

		--Determinamos que contratos que tienen producto PLUS y son plan Bienestar, y estan vigentes
		Insert Into #tmpContratosValidos
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

		--Determinamos que beneficiarios no son validos
		Insert into #tmpBeneficiariosNoValidos
		select 
			c.cnsctvo_cdgo_tpo_cntrto, c.nmro_cntrto, 
			b.cnsctvo_bnfcro, b.nmro_unco_idntfccn_bnfcro,
			b.cnsctvo_cdgo_tpo_afldo, v.nmro_unco_idntfccn, 
			@BENEFICIARIO_NO_VIGENTE causa 		
		from #tmpContratosValidos c With (NoLock) 
			Inner join 
				bdAfiliacion.dbo.tbVigenciasBeneficiarios vb With (NoLock)
				On vb.cnsctvo_cdgo_tpo_cntrto = c.cnsctvo_cdgo_tpo_cntrto
				and vb.nmro_cntrto = c.nmro_cntrto
			Inner join bdAfiliacion.dbo.tbBeneficiarios b With (NoLock)
				On vb.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto
				and vb.nmro_cntrto = b.nmro_cntrto
				and vb.cnsctvo_bnfcro = b.cnsctvo_bnfcro
			Inner join bdAfiliacion.dbo.tbVinculados v With (NoLock)
				On b.nmro_unco_idntfccn_bnfcro  = v.nmro_unco_idntfccn
			Inner Join bdAfiliacion.dbo.tbTiposIdentificacion ti With (NoLock)
				On ti.cnsctvo_cdgo_tpo_idntfccn	= v.cnsctvo_cdgo_tpo_idntfccn
			Inner Join bdAfiliacion.dbo.tbTiposAfiliado ta With (NoLock)
				On b.cnsctvo_cdgo_tpo_afldo = ta.cnsctvo_cdgo_tpo_afldo
		where vb.estdo_rgstro=@VALIDO
			and b.estdo <> @ACTIVO
			--and b.cnsctvo_cdgo_tpo_afldo != @ADICIONAL, Comentado por solicitud de Comercial


		/* --Comentado por solicitud de Comercial
		insert into #tmpBeneficiariosNoValidos
		select 
		c.cnsctvo_cdgo_tpo_cntrto, c.nmro_cntrto, 
		b.cnsctvo_bnfcro, b.nmro_unco_idntfccn_bnfcro,
		b.cnsctvo_cdgo_tpo_afldo, v.nmro_unco_idntfccn, 
		@BENEFICIARIO_ADICIONAL causa 
		from #tmpContratosValidos c With (NoLock) inner join 
		bdAfiliacion.dbo.tbVigenciasBeneficiarios vb With (NoLock)
		on vb.cnsctvo_cdgo_tpo_cntrto = c.cnsctvo_cdgo_tpo_cntrto
		and vb.nmro_cntrto = c.nmro_cntrto
		inner join bdAfiliacion.dbo.tbBeneficiarios b With (NoLock)
		on vb.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto
		and vb.nmro_cntrto = b.nmro_cntrto
		and vb.cnsctvo_bnfcro = b.cnsctvo_bnfcro
		inner join bdAfiliacion.dbo.tbVinculados v With (NoLock)
		on b.nmro_unco_idntfccn_bnfcro  = v.nmro_unco_idntfccn
		Inner Join bdAfiliacion.dbo.tbTiposIdentificacion ti With (NoLock)
		On ti.cnsctvo_cdgo_tpo_idntfccn	= v.cnsctvo_cdgo_tpo_idntfccn
		Inner Join bdAfiliacion.dbo.tbTiposAfiliado ta With (NoLock)
		On b.cnsctvo_cdgo_tpo_afldo = ta.cnsctvo_cdgo_tpo_afldo
		where  b.cnsctvo_cdgo_tpo_afldo = @ADICIONAL -- Adicional
			and vb.estdo_rgstro=@VALIDO 
			and b.estdo = @ACTIVO 
       */

		--Contratos  validos que ya fueron facturados
		Insert into	#tmpResultadosLogFinal
		Select	 	a.nmro_cntrto,	
					f.cdgo_tpo_idntfccn,	
					e.nmro_idntfccn,
					ltrim(rtrim(d.prmr_aplldo)) + ' ' + ltrim(rtrim(d.sgndo_aplldo)) + ' ' + ltrim(rtrim(d.prmr_nmbre)) + ' ' +ltrim(rtrim(sgndo_nmbre)) nombre,
					a.cnsctvo_cdgo_pln,		
					a.inco_vgnca_cntrto,	
					a.fn_vgnca_cntrto,	
					a.nmro_unco_idntfccn_afldo,
					p.cdgo_pln,	
					p. dscrpcn_pln,	
					@BENEFICIARIO_YA_FACTURADO,
					b.nmro_unco_idntfccn_empldr,
					b.cnsctvo_scrsl,
					b.cnsctvo_cdgo_clse_aprtnte,
					space(200)	nmbre_scrsl,
					space(100)	dscrpcn_clse_aprtnte,
					space(3)	tpo_idntfccn_scrsl,
					space(20)	nmro_idntfccn_scrsl,
					right(replicate('0',20)+ltrim(rtrim(b.nmro_unco_idntfccn_empldr)),20) + right(replicate('0',2)+ltrim(rtrim(b.cnsctvo_scrsl)),2) + right(replicate('0',2)+ltrim(rtrim(b.cnsctvo_cdgo_clse_aprtnte)),2)	Responsable,
					@lnConsecutivoCodigoLiquidacion cnsctvo_cdgo_lqdcn,
					bn.nmro_unco_idntfccn_bnfcro
		From 		#tmpContratosValidos  b With(NoLock)
		Inner Join	bdafiliacion.dbo.tbcontratos a 
			On		(a.cnsctvo_cdgo_tpo_cntrto 	=	 b.cnsctvo_cdgo_tpo_cntrto
			And 	a.nmro_cntrto		  	= 	 b.nmro_cntrto) 
		Inner Join  #tmpContratosYaLiquidados cl 
			On cl.cnsctvo_cdgo_tpo_cntrto=b.cnsctvo_cdgo_tpo_cntrto 
				And cl.nmro_cntrto=b.nmro_cntrto 
		Inner Join BDAfiliacion.dbo.tbVigenciasBeneficiarios vb With(NoLock)
			On vb.cnsctvo_cdgo_tpo_cntrto = cl.cnsctvo_cdgo_tpo_cntrto
				And vb.nmro_cntrto = cl.nmro_cntrto
		inner join BDAfiliacion.dbo.tbBeneficiarios bn
			On vb.cnsctvo_cdgo_tpo_cntrto = bn.cnsctvo_cdgo_tpo_cntrto
				And vb.nmro_cntrto = bn.nmro_cntrto
				And vb.cnsctvo_bnfcro = bn.cnsctvo_bnfcro 
		Inner Join	bdafiliacion.dbo.tbpersonas d  With(NoLock)
			On		(bn.nmro_unco_idntfccn_bnfcro  =	d.nmro_unco_idntfccn)
		Inner Join	bdafiliacion.dbo.tbvinculados  e With(NoLock)
			On		(d.nmro_unco_idntfccn		=	e.nmro_unco_idntfccn)
		Inner Join	bdafiliacion.dbo.tbtiposidentificacion f With(NoLock)
			On		(e.cnsctvo_cdgo_tpo_idntfccn	=	f.cnsctvo_cdgo_tpo_idntfccn)
		Inner Join	bdplanbeneficios.dbo.tbplanes	p With(NoLock)
			On		(a.cnsctvo_cdgo_pln		=	p.cnsctvo_cdgo_pln)
		Where @ldfechaCorte  between vb.inco_vgnca_estdo_bnfcro and vb.fn_vgnca_estdo_bnfcro 
			--and bn.cnsctvo_cdgo_tpo_afldo != @ADICIONAL, Comentado por solicitud de Comercial
			and e.vldo = @VALIDO 
			and vb.estdo_rgstro=@VALIDO
			and bn.estdo=@ACTIVO 
		Order By	d.prmr_aplldo ,d.sgndo_aplldo,d.prmr_nmbre,d.sgndo_nmbre


	    --Insertamos en el log temporal los contratos NO VIGENTES
		Insert into	#tmpResultadosLogFinal
		Select		a.nmro_cntrto,	
					'' cdgo_tpo_idntfccn,	
					'' nmro_idntfccn,
					'' nombre,
					a.cnsctvo_cdgo_pln,		
					a.inco_vgnca_cntrto,	
					a.fn_vgnca_cntrto,	
					a.nmro_unco_idntfccn_afldo,
					'' cdgo_pln,	
					'' dscrpcn_pln,	
					b.causa,
					b.nmro_unco_idntfccn_empldr,
					b.cnsctvo_scrsl,
					b.cnsctvo_cdgo_clse_aprtnte,
					space(200)	nmbre_scrsl,
					space(100)	dscrpcn_clse_aprtnte,
					space(3)	tpo_idntfccn_scrsl,
					space(20)	nmro_idntfccn_scrsl,
					right(replicate('0',20)+ltrim(rtrim(b.nmro_unco_idntfccn_empldr)),20) + right(replicate('0',2)+ltrim(rtrim(b.cnsctvo_scrsl)),2) + right(replicate('0',2)+ltrim(rtrim(b.cnsctvo_cdgo_clse_aprtnte)),2)	Responsable,
					@lnConsecutivoCodigoLiquidacion cnsctvo_cdgo_lqdcn,
					bn.nmro_unco_idntfccn_bnfcro
		From 		#tmpContratosNoValidos  b  With(NoLock)
		Inner Join	bdafiliacion.dbo.tbcontratos a 
			On		(a.cnsctvo_cdgo_tpo_cntrto 	=	 b.cnsctvo_cdgo_tpo_cntrto
			And 	a.nmro_cntrto		  	= 	 b.nmro_cntrto)
		Inner Join BDAfiliacion.dbo.tbVigenciasBeneficiarios vb With(NoLock)
			On vb.cnsctvo_cdgo_tpo_cntrto = a.cnsctvo_cdgo_tpo_cntrto
				And vb.nmro_cntrto = a.nmro_cntrto
		inner join BDAfiliacion.dbo.tbBeneficiarios bn With(NoLock)
			On vb.cnsctvo_cdgo_tpo_cntrto = bn.cnsctvo_cdgo_tpo_cntrto
				And vb.nmro_cntrto = bn.nmro_cntrto
				And vb.cnsctvo_bnfcro = bn.cnsctvo_bnfcro 

		-- Informacion del beneficiario
		Update  a 
		Set 
			cdgo_tpo_idntfccn=f.cdgo_tpo_idntfccn,	
			nmro_idntfccn=e.nmro_idntfccn,
			nombre=ltrim(rtrim(d.prmr_aplldo)) + ' ' + ltrim(rtrim(d.sgndo_aplldo)) + ' ' + ltrim(rtrim(d.prmr_nmbre)) + ' ' +ltrim(rtrim(sgndo_nmbre)),
			cdgo_pln=p.cdgo_pln,	
			dscrpcn_pln=p. dscrpcn_pln,
			nmro_unco_idntfccn_bnfcro=0
		From #tmpResultadosLogFinal a			
		Inner Join	bdafiliacion.dbo.tbpersonas d  With(NoLock)
			On		(a.nmro_unco_idntfccn_bnfcro  =	d.nmro_unco_idntfccn)
		Inner Join	bdafiliacion.dbo.tbvinculados  e With(NoLock)
			On		(d.nmro_unco_idntfccn		=	e.nmro_unco_idntfccn)
		Inner Join	bdafiliacion.dbo.tbtiposidentificacion f With(NoLock)
			On		(e.cnsctvo_cdgo_tpo_idntfccn	=	f.cnsctvo_cdgo_tpo_idntfccn)
		Inner Join	bdplanbeneficios.dbo.tbplanes	p With(NoLock)
			On		(a.cnsctvo_cdgo_pln		=	p.cnsctvo_cdgo_pln)	
		Where e.vldo = @VALIDO

		--Insertamos los beneficiarios NO VIGENTES y ADICIONALES en el log				

		insert into #tmpResultadosLogFinal 
		Select		a.nmro_cntrto,	
					'' cdgo_tpo_idntfccn,	
					'' nmro_idntfccn,
					'' nombre,
					a.cnsctvo_cdgo_pln,		
					a.inco_vgnca_cntrto,	
					a.fn_vgnca_cntrto,	
					a.nmro_unco_idntfccn_afldo,
					'' cdgo_pln,	
					'' dscrpcn_pln,	
					bn.causa,
					b.nmro_unco_idntfccn_empldr,
					b.cnsctvo_scrsl,
					b.cnsctvo_cdgo_clse_aprtnte,
					space(200)	nmbre_scrsl,
					space(100)	dscrpcn_clse_aprtnte,
					space(3)	tpo_idntfccn_scrsl,
					space(20)	nmro_idntfccn_scrsl,
					right(replicate('0',20)+ltrim(rtrim(b.nmro_unco_idntfccn_empldr)),20) + right(replicate('0',2)+ltrim(rtrim(b.cnsctvo_scrsl)),2) + right(replicate('0',2)+ltrim(rtrim(b.cnsctvo_cdgo_clse_aprtnte)),2)	Responsable,
					@lnConsecutivoCodigoLiquidacion cnsctvo_cdgo_lqdcn,
					bn.nmro_unco_idntfccn_bnfcro
		From 		#tmpContratosValidos  b  With(NoLock)
		Inner Join	bdafiliacion.dbo.tbcontratos a 
			On		(a.cnsctvo_cdgo_tpo_cntrto 	=	 b.cnsctvo_cdgo_tpo_cntrto
			And 	a.nmro_cntrto		  	= 	 b.nmro_cntrto)
		Inner Join  #tmpBeneficiariosNoValidos bn 
		On		(a.cnsctvo_cdgo_tpo_cntrto 	=	 bn.cnsctvo_cdgo_tpo_cntrto
			And 	a.nmro_cntrto		  	= 	 bn.nmro_cntrto)

		-- Informacion del beneficiario
		Update  a 
		Set 
			cdgo_tpo_idntfccn=f.cdgo_tpo_idntfccn,	
			nmro_idntfccn=e.nmro_idntfccn,
			nombre=ltrim(rtrim(d.prmr_aplldo)) + ' ' + ltrim(rtrim(d.sgndo_aplldo)) + ' ' + ltrim(rtrim(d.prmr_nmbre)) + ' ' +ltrim(rtrim(sgndo_nmbre)),
			cdgo_pln=p.cdgo_pln,	
			dscrpcn_pln=p. dscrpcn_pln
		From #tmpResultadosLogFinal a			
		Inner Join	bdafiliacion.dbo.tbpersonas d  With(NoLock)
			On		(a.nmro_unco_idntfccn_bnfcro  =	d.nmro_unco_idntfccn)
		Inner Join	bdafiliacion.dbo.tbvinculados  e With(NoLock)
			On		(d.nmro_unco_idntfccn		=	e.nmro_unco_idntfccn)
		Inner Join	bdafiliacion.dbo.tbtiposidentificacion f With(NoLock)
			On		(e.cnsctvo_cdgo_tpo_idntfccn	=	f.cnsctvo_cdgo_tpo_idntfccn)
		Inner Join	bdplanbeneficios.dbo.tbplanes	p With(NoLock)
			On		(a.cnsctvo_cdgo_pln		=	p.cnsctvo_cdgo_pln)	
		Where e.vldo = @VALIDO

		-- Informacion de sucursal

		Update		a
		Set			nmbre_scrsl				=	s.nmbre_scrsl,
					dscrpcn_clse_aprtnte	=	c.dscrpcn_clse_aprtnte,
					tpo_idntfccn_scrsl		=	t.cdgo_tpo_idntfccn,
					nmro_idntfccn_scrsl		=	v.nmro_idntfccn
		From		#tmpResultadosLogFinal a 
		Inner Join	bdafiliacion.dbo.tbsucursalesaportante s With(NoLock)
			On		(a.nmro_unco_idntfccn_empldr	= s.nmro_unco_idntfccn_empldr
			And		a.cnsctvo_scrsl					= s.cnsctvo_scrsl 
			And		a.cnsctvo_cdgo_clse_aprtnte		= s.cnsctvo_cdgo_clse_aprtnte)
		Inner Join  bdafiliacion.dbo.tbvinculados v With(NoLock)
			On		(s.nmro_unco_idntfccn_empldr	=	v.nmro_unco_idntfccn)
		Inner Join	bdafiliacion.dbo.tbtiposidentificacion  t With(NoLock)
			On		(t.cnsctvo_cdgo_tpo_idntfccn	=	v.cnsctvo_cdgo_tpo_idntfccn)	
		Inner Join  bdafiliacion.dbo.tbclasesaportantes c With(NoLock)
			On		(a.cnsctvo_cdgo_clse_aprtnte	=	c.cnsctvo_cdgo_clse_aprtnte)

			
		Insert into dbo.tbLogLiquidacionesContratos (
			nmro_cntrto,
			cdgo_tpo_idntfccn,
			nmro_idntfccn,
			nombre,
			cnsctvo_cdgo_pln,
			inco_vgnca_cntrto,
			fn_vgnca_cntrto,
			nmro_unco_idntfccn_afldo,
			cdgo_pln,
			dscrpcn_pln,
			causa,
			nmro_unco_idntfccn_aprtnte,
			cnsctvo_scrsl_ctznte,
			cnsctvo_cdgo_clse_aprtnte,
			nmbre_scrsl,
			dscrpcn_clse_aprtnte,
			tpo_idntfccn_scrsl,
			nmro_idntfccn_scrsl,
			Responsable,
			cnsctvo_cdgo_lqdcn		
		)
		select 
			nmro_cntrto,
			cdgo_tpo_idntfccn,
			nmro_idntfccn,
			substring(trim(nombre),1,30) as nombre1, 
			cnsctvo_cdgo_pln,
			inco_vgnca_cntrto,
			fn_vgnca_cntrto,
			nmro_unco_idntfccn_afldo,
			cdgo_pln,
			dscrpcn_pln,
			causa,
			nmro_unco_idntfccn_empldr,
			cnsctvo_scrsl,
			cnsctvo_cdgo_clse_aprtnte,
			substring(trim(nmbre_scrsl),1,30) nmbre_suc2 ,
			substring(trim(dscrpcn_clse_aprtnte),1,150) descrp2,
			tpo_idntfccn_scrsl,
			nmro_idntfccn_scrsl,
			Responsable,
			cnsctvo_cdgo_lqdcn	
		 from #tmpResultadosLogFinal;


		SET @filasAfectadas=@@ROWCOUNT
		Set @mnsje_slda	= 'Se crearon '+cast(@filasAfectadas as varchar(10))+' registros en el log liquidaciones contrato.';

	End Try
	Begin Catch
		Set @mnsje_slda	= ERROR_PROCEDURE()+' '+Concat(ERROR_MESSAGE(), ' ', ERROR_PROCEDURE(), ' ', ERROR_LINE());
		Set @cdgo_slda	= 1;
	End Catch
	
End
