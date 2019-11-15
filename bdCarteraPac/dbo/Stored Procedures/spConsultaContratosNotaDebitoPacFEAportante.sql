/*---------------------------------------------------------------------------------
* Metodo o PRG 		:  spConsultaContratosNotaDebitoPacFEAportante
* Desarrollado por	: <\A 	Francisco E. Riaño L. - Qvision S.A		A\>
* Descripcion		: <\D Este procedimiento realiza una busqueda de loscontratos del responsable
							Para notas debito de facturacion electronica			  	D\>
* Observaciones		: <\O  	O\>
* Parametros		: <\P  @lnNumeroEstadoCuenta equivalente al numero de estado de cuenta consultado	P\>
* Variables			: <\V  	V\>
* Fecha Creacion	: <\FC 2019/08/20 FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion	: <\FM  FM\>
*---------------------------------------------------------------------------------
EXEC bdcarterapac.dbo.SpConsultaContratosNotaDebitoPacFEAportante 3144404
*/

CREATE	PROCEDURE [dbo].[spConsultaContratosNotaDebitoPacFEAportante] (
	 @lnNumeroEstadoCuenta		Varchar(15)
)
As
Begin

	Set NoCount On;
	
	Declare		@ldFechaSistema							Datetime = Getdate(),
				@lnConsecutivoTipoContratoPAC			udtConsecutivo = 2,
				@lnConsecutivoEstadoCuentaAnulada		udtConsecutivo = 4,
				@lnConsecutivoEstadoCuentaPrueba		udtConsecutivo = 5,
				@lnSaldo_estdo_cnta						numeric(12,0),
				@lnConsecutivoClaseAportante			udtconsecutivo ,
				@lnNumeroInicoIdentificacion			udtConsecutivo,
				@lnConsecutivoSucursal					udtConsecutivo,
				@lncnsctvo_cdgo_estdo_estdo_cnta		udtConsecutivo,
				@lncnsctvo_cdgo_clse_aprtnte			udtConsecutivo,
				@lnttl_fctrdo							udtValorGrande,
				@lnvlr_iva								udtValorGrande,
				@lndgto_vrfccn							udtConsecutivo,
				@lnrzn_scl								VARCHAR(200),
				@lndscrpcn_prdo_lqdcn					VARCHAR(200),
				@lnsldo_estdo_cnta						udtValorGrande,
				@lnnmbre_scrsl							VARCHAR(200),
				@lncnsctvo_cdgo_tpo_idntfccn_Empldr		udtConsecutivo,
				@lncnsctvo_cdgo_prdo_lqdcn				udtConsecutivo,
				@lncnsctvo_estdo_cnta					udtConsecutivo;

	Create Table #tmpCobranzas 
	(
		cnsctvo_cdgo_tpo_cntrto		udtConsecutivo,
		nmro_cntrto					udtNumeroFormulario,
		cnsctvo_cbrnza				udtConsecutivo,
		nmro_unco_idntfccn_aprtnte	udtConsecutivo,
		cnsctvo_cdgo_clse_aprtnte	udtConsecutivo,
		cnsctvo_cdgo_tpo_cbrnza		udtConsecutivo,
		prncpl						udtLogico,
		slro_vrble					udtLogico,
		cnsctvo_cdgo_fmra_aflcn		udtConsecutivo,
		cnsctvo_cdgo_tpo_ctznte		udtConsecutivo,
		cnsctvo_cdgo_frma_cbro		udtConsecutivo,
		cnsctvo_cdgo_prdcdd_prpgo	udtConsecutivo,
		cnsctvo_cdgo_crgo_empldo	udtConsecutivo,
		fcha_ingrso_lbrr			datetime,
		estdo						udtLogico,
		fcha_ultma_mdfccn			datetime
	)

	Create Table #tmpContratosCobranzas 
	(
		cnsctvo_cdgo_tpo_cntrto udtConsecutivo,	 
		nmro_cntrto				udtNumeroFormulario
	)

	Create Table #tmpContratos
	(
		nmro_cntrto					udtNumeroFormulario,			
		cnsctvo_cdgo_tpo_cntrto		udtConsecutivo, 		
		cnsctvo_cdgo_pln			udtConsecutivo,		
		inco_vgnca_cntrto			datetime,		
		fn_vgnca_cntrto				datetime,			
		nmro_unco_idntfccn_afldo	udtConsecutivo,
		cnsctvo_cbrnza				udtConsecutivo,
		cnsctvo_vgnca_cbrnza		udtConsecutivo,
		cnsctvo_cdgo_prdcdd_prpgo	udtConsecutivo,
		inco_vgnca_cbrnza			datetime,
		fn_vgnca_cbrnza				datetime,
		cta_mnsl					int
	)

	Create table #tmpEstadosCuenta
	(
		cnsctvo_estdo_cnta					udtConsecutivo,
		nmro_unco_idntfccn_empldr			udtConsecutivo,
		cnsctvo_scrsl						udtConsecutivo,
		cnsctvo_cdgo_clse_aprtnte			udtConsecutivo,
		ttl_fctrdo							udtValorGrande,
		vlr_iva								udtValorGrande,
		ttl_pgr								udtValorGrande,
		nmro_estdo_cnta						varchar(15),
		nmbre_scrsl							varchar(200),
		rzn_scl								varchar(200),
		dgto_vrfccn							int,
		nmro_idntfccn_empldr				varchar(20),
		cdgo_tpo_idntfccn_empldr			varchar(3),
		cnsctvo_cdgo_tpo_idntfccn_Empldr	int,	
		cnsctvo_cdgo_estdo_estdo_cnta		udtConsecutivo,
		sldo_estdo_cnta						udtValorGrande,		
		fcha_crcn_nta						datetime,
		dscrpcn_prdo_lqdcn					udtDescripcion,
		cnsctvo_cdgo_prdo_lqdcn				udtConsecutivo
	)

	Insert into #tmpEstadosCuenta
	select		a.cnsctvo_estdo_cnta,		
				a.nmro_unco_idntfccn_empldr,		
				a.cnsctvo_scrsl,
				a.cnsctvo_cdgo_clse_aprtnte,	
				a.ttl_fctrdo,				
				a.vlr_iva,
				a.ttl_pgr,			
				a.nmro_estdo_cnta ,
				space(200) 			nmbre_scrsl,
				space(200) 			rzn_scl,
				0					dgto_vrfccn,
				space(20)  			nmro_idntfccn_empldr,
				space(3)			cdgo_tpo_idntfccn_empldr,
				0					cnsctvo_cdgo_tpo_idntfccn_Empldr, 
				a.cnsctvo_cdgo_estdo_estdo_cnta,
				a.sldo_estdo_cnta,
				a.fcha_gnrcn,
				h.dscrpcn_prdo_lqdcn,
				h.cnsctvo_cdgo_prdo_lqdcn
	FROM		dbo.tbEstadosCuenta				a with(nolock)
	Inner Join  dbo.tbLiquidaciones				g with(nolock)
		On		a.cnsctvo_cdgo_lqdcn = g.cnsctvo_cdgo_lqdcn
	Inner Join	dbo.tbPeriodosliquidacion_Vigencias h with(nolock)
		On		g.cnsctvo_cdgo_prdo_lqdcn = h.cnsctvo_cdgo_prdo_lqdcn
	where       @ldFechaSistema between h.inco_vgnca and h.fn_vgnca
	And			a.nmro_estdo_cnta = @lnNumeroEstadoCuenta

	Update	#tmpEstadosCuenta
	Set		cnsctvo_cdgo_estdo_estdo_cnta	=	2
	where	sldo_estdo_cnta	>	0
	And     cnsctvo_cdgo_estdo_estdo_cnta not in (@lnConsecutivoEstadoCuentaAnulada,@lnConsecutivoEstadoCuentaPrueba) --No incluye anuladas y de prueba 

	-- se actualiza los datos basicos del responsable pago
	Update		#tmpEstadosCuenta
	Set			nmro_idntfccn_empldr				=	b.nmro_idntfccn,
				dgto_vrfccn							=	b.dgto_vrfccn,
				cnsctvo_cdgo_tpo_idntfccn_Empldr	=	b.cnsctvo_cdgo_tpo_idntfccn
	From		#tmpEstadosCuenta a 
	Inner join  bdafiliacion.dbo.tbVinculados	b With(Nolock)
		On   	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn
		
	Update		#tmpEstadosCuenta
	Set			cdgo_tpo_idntfccn_empldr	=	b.cdgo_tpo_idntfccn
	From		#tmpEstadosCuenta a 
	Inner join	bdafiliacion.dbo.tbtiposIdentificacion b With(NoLock)
		On 		a.cnsctvo_cdgo_tpo_idntfccn_Empldr	=	b.cnsctvo_cdgo_tpo_idntfccn

	-- actualiza la razon social
	Update 		#tmpEstadosCuenta
	Set			rzn_scl	 =  c.rzn_scl
	FROM		#tmpEstadosCuenta a 
	INNER JOIN  bdAfiliacion.dbo.tbEmpleadores b With(NoLock)
		ON 		a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn 
		AND     a.cnsctvo_cdgo_clse_aprtnte = b.cnsctvo_cdgo_clse_aprtnte 
	INNER JOIN  bdAfiliacion.dbo.tbEmpresas c With(NoLock)
		ON 		a.nmro_unco_idntfccn_empldr = c.nmro_unco_idntfccn

	Update		#tmpEstadosCuenta
	Set			rzn_scl	 =   ltrim(rtrim(isnull(prmr_aplldo,'')))  + ' ' + ltrim(rtrim(isnull(sgndo_aplldo,''))) + ' ' + ltrim(rtrim(isnull(prmr_nmbre,''))) + ' ' + ltrim(rtrim(isnull(sgndo_nmbre,'')))
	FROM		#tmpEstadosCuenta a 
	INNER JOIN  bdAfiliacion.dbo.tbEmpleadores b With(NoLock)
		ON 		a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn 
		AND     a.cnsctvo_cdgo_clse_aprtnte = b.cnsctvo_cdgo_clse_aprtnte 
	INNER JOIN  bdAfiliacion.dbo.tbPersonas c With(NoLock)
		ON 		a.nmro_unco_idntfccn_empldr = c.nmro_unco_idntfccn
	WHERE		a.rzn_scl = ''

	--actualiza el nombre de la sucursal
	Update		#tmpEstadosCuenta
	Set 		nmbre_scrsl	=	b.nmbre_scrsl
	FROM		#tmpEstadosCuenta a 
	INNER JOIN	bdAfiliacion.dbo.tbSucursalesAportante b With(NoLock)
		ON 		a.cnsctvo_scrsl = b.cnsctvo_scrsl 
		AND 	a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn_empldr 
		AND     a.cnsctvo_cdgo_clse_aprtnte = b.cnsctvo_cdgo_clse_aprtnte
	
	select		
				@lnNumeroInicoIdentificacion = a.nmro_unco_idntfccn_empldr,
				@lnConsecutivoClaseAportante = a.cnsctvo_cdgo_clse_aprtnte,
				@lnConsecutivoSucursal = a.cnsctvo_scrsl,
				@lncnsctvo_cdgo_estdo_estdo_cnta = a.cnsctvo_cdgo_estdo_estdo_cnta,
				@lncnsctvo_cdgo_clse_aprtnte = a.cnsctvo_cdgo_clse_aprtnte,
				@lnttl_fctrdo = a.ttl_fctrdo,
				@lnvlr_iva = a.vlr_iva,
				@lndgto_vrfccn = a.dgto_vrfccn,
				@lnrzn_scl = a.rzn_scl,
				@lndscrpcn_prdo_lqdcn = a.dscrpcn_prdo_lqdcn,
				@lnsldo_estdo_cnta = a.sldo_estdo_cnta,
				@lnnmbre_scrsl = a.nmbre_scrsl,
				@lncnsctvo_cdgo_tpo_idntfccn_Empldr = a.cnsctvo_cdgo_tpo_idntfccn_Empldr,
				@lncnsctvo_cdgo_prdo_lqdcn = a.cnsctvo_cdgo_prdo_lqdcn,
				@lncnsctvo_estdo_cnta = a.cnsctvo_estdo_cnta
	FROM		#tmpEstadosCuenta	a 

	-- SE TRAE LOS CONTRATOS PAC DEL APORTANTE DEL PARAMETRO Y SIN IMPORTANTE SI ESTAN VIGENTES
	Insert Into #tmpCobranzas
	Select  
				a.cnsctvo_cdgo_tpo_cntrto,
				a.nmro_cntrto,
				a.cnsctvo_cbrnza,
				a.nmro_unco_idntfccn_aprtnte,
				a.cnsctvo_cdgo_clse_aprtnte,
				a.cnsctvo_cdgo_tpo_cbrnza,
				a.prncpl,
				a.slro_vrble,
				a.cnsctvo_cdgo_fmra_aflcn,
				a.cnsctvo_cdgo_tpo_ctznte,
				a.cnsctvo_cdgo_frma_cbro,
				a.cnsctvo_cdgo_prdcdd_prpgo,
				a.cnsctvo_cdgo_crgo_empldo,
				a.fcha_ingrso_lbrr,
				a.estdo,
				a.fcha_ultma_mdfccn
	From		bdafiliacion.dbo.tbCobranzas a with(nolock)	
	Where 		a.cnsctvo_cdgo_tpo_cntrto		= @lnConsecutivoTipoContratoPAC
	And			a.nmro_unco_idntfccn_aprtnte = @lnNumeroInicoIdentificacion
	And			a.cnsctvo_cdgo_clse_aprtnte = @lnConsecutivoClaseAportante

	-- SE AGRUPA PARA TRAER TODOS LOS CONTRATOS 
	Insert into	#tmpContratosCobranzas
	Select 	
			a.cnsctvo_cdgo_tpo_cntrto,	 
			a.nmro_cntrto
	From	#tmpCobranzas a
	Group by a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto


	-- SE CREA LA TABLA TEMPORAL CON TODA LA INFORMACION DE LOS CONTRATOS 
	Insert into	#tmpContratos
	Select  
				a.nmro_cntrto,			
				a.cnsctvo_cdgo_tpo_cntrto, 		
				a.cnsctvo_cdgo_pln,		
				a.inco_vgnca_cntrto,		
				a.fn_vgnca_cntrto,			
				a.nmro_unco_idntfccn_afldo,
				0						cnsctvo_cbrnza,
				1						cnsctvo_vgnca_cbrnza,
				1						cnsctvo_cdgo_prdcdd_prpgo,
				a.inco_vgnca_cntrto		inco_vgnca_cbrnza,
				a.fn_vgnca_cntrto		fn_vgnca_cbrnza,
				0						cta_mnsl	
	From		bdafiliacion.dbo.tbcontratos	a  With(nolock)
	Inner join	#tmpContratosCobranzas			b
		on		a.cnsctvo_cdgo_tpo_cntrto		=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto					=	b.nmro_cntrto
	Where 		a.cnsctvo_cdgo_tpo_cntrto 		=	@lnConsecutivoTipoContratoPAC		
	
	-- SE ACTUALIZA LA COBRANZA
	Update		a
	Set			cnsctvo_cbrnza	=	b.cnsctvo_cbrnza
	From		#tmpContratos a
	inner join	#tmpCobranzas b
		on		a.nmro_cntrto				=	b.nmro_cntrto
		And		a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto

		
	-- Se traer los contratos asociados al responsable
	Select		a.nmro_cntrto,	
				d.cdgo_tpo_idntfccn,	
				e.nmro_idntfccn AS nmro_idntfccn_empldr,
				ltrim(rtrim(f.prmr_aplldo)) + ' ' + ltrim(rtrim(f.sgndo_aplldo)) + ' ' + ltrim(rtrim(f.prmr_nmbre)) + ' ' +ltrim(rtrim(f.sgndo_nmbre))  as nombre,
				p.dscrpcn_pln, 
				'NO SELECCIONADO' as accn,
				a.cnsctvo_cdgo_tpo_cntrto,	
				a.cnsctvo_cdgo_pln,		
				a.inco_vgnca_cntrto,	
				a.fn_vgnca_cntrto,	
				a.nmro_unco_idntfccn_afldo,
				a.cnsctvo_cbrnza,		
				@lnNumeroInicoIdentificacion as nmro_unco_idntfccn_aprtnte,	
				a.cnsctvo_vgnca_cbrnza,	
				@lnConsecutivoSucursal as cnsctvo_scrsl_ctznte,
				a.inco_vgnca_cbrnza,		
				a.fn_vgnca_cbrnza,		
				a.cta_mnsl,
				a.cnsctvo_cdgo_prdcdd_prpgo,	
				p.cdgo_pln,
				@lncnsctvo_cdgo_estdo_estdo_cnta AS cnsctvo_cdgo_estdo_estdo_cnta,
				@lncnsctvo_cdgo_clse_aprtnte AS cnsctvo_cdgo_clse_aprtnte,
				@lnttl_fctrdo AS ttl_fctrdo,
				@lnvlr_iva AS vlr_iva,
				@lndgto_vrfccn AS dgto_vrfccn,
				@lnrzn_scl AS rzn_scl,
				@lndscrpcn_prdo_lqdcn AS dscrpcn_prdo_lqdcn,
				@lnsldo_estdo_cnta AS sldo_estdo_cnta,
				@lnnmbre_scrsl AS nmbre_scrsl,
				@lncnsctvo_cdgo_tpo_idntfccn_Empldr AS cnsctvo_cdgo_tpo_idntfccn_Empldr,
				@lncnsctvo_cdgo_prdo_lqdcn AS cnsctvo_cdgo_prdo_lqdcn,
				@lncnsctvo_estdo_cnta AS cnsctvo_estdo_cnta
	From 		#tmpContratos   a
	Inner Join	bdAfiliacion.dbo.tbPersonas		f with(nolock)
		On		a.nmro_unco_idntfccn_afldo	=	f.nmro_unco_idntfccn 
	Inner Join  bdAfiliacion.dbo.tbVinculados	e with(nolock)
		On 		a.nmro_unco_idntfccn_afldo 	= e.nmro_unco_idntfccn 
	Inner Join  bdAfiliacion.dbo.tbTiposIdentificacion d with(nolock)
		On 		e.cnsctvo_cdgo_tpo_idntfccn = d.cnsctvo_cdgo_tpo_idntfccn 
	Inner Join	bdplanbeneficios.dbo.tbplanes	p	With(Nolock)
		On		a.cnsctvo_cdgo_pln		=	p.cnsctvo_cdgo_pln
	
 End