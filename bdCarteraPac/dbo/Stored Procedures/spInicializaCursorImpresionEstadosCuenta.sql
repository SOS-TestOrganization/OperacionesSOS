/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spIniclaizaCursorImpresionEstadosCuenta
* Desarrollado por		: <\A Ing. ROLANDO SIMBAQUEVA LASSO								A\>
* Descripcion			: <\D Este procedimiento realiza la inicializacion del cursor de los estados de cuenta			  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P 													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/02 											FC\>
**/

CREATE PROCEDURE [dbo].[spInicializaCursorImpresionEstadosCuenta]
As  

Set Nocount On





SELECT	a.nmro_estdo_cnta,		f.cdgo_tpo_idntfccn, 		d.nmro_idntfccn, 		 i.dscrpcn_clse_aprtnte,
		b.nmbre_scrsl,			a.ttl_fctrdo, 			a.usro_crcn,		a.cnsctvo_cdgo_lqdcn, 	
		'NO SELECCIONADO'  		accn,
		a.cnsctvo_estdo_cnta, 			a.fcha_gnrcn, 		a.nmro_unco_idntfccn_empldr, 	a.cnsctvo_scrsl, 	
		a.cnsctvo_cdgo_clse_aprtnte,        b.sde_crtra_pc 			 cnsctvo_cdgo_sde, 			a.vlr_iva, 		a.sldo_fvr, 
		a.ttl_pgr, 			a.Cts_Cnclr, 			a.Cts_sn_Cnclr,	 	c.cdgo_cdd, 			c.dscrpcn_cdd, 
		e.dscrpcn_prdo, 		e.cdgo_prdo,                  		f.dscrpcn_tpo_idntfccn, 		
		b.drccn, b.tlfno, 			h.cnsctvo_cdgo_prdo_lqdcn, 	h.fcha_incl_prdo_lqdcn		 fcha_incl_fctrcn  ,		 h.fcha_fnl_prdo_lqdcn	fcha_fnl_fctrcn, 
	              h.fcha_mxma_pgo, 		a.sldo_antrr,			space(200)		rzn_scl,
		d.cnsctvo_cdgo_tpo_idntfccn	
Into		#TmpImpresionEstadosCuenta
FROM		tbEstadosCuenta a INNER JOIN
		bdAfiliacion.dbo.tbSucursalesAportante b   ON a.nmro_unco_idntfccn_empldr 	=	b.nmro_unco_idntfccn_empldr AND a.cnsctvo_scrsl = b.cnsctvo_scrsl AND
							      a.cnsctvo_cdgo_clse_aprtnte 		= 	b.cnsctvo_cdgo_clse_aprtnte	INNER JOIN
		bdAfiliacion.dbo.tbCiudades c 		ON b.cnsctvo_cdgo_cdd			=	c.cnsctvo_cdgo_cdd 		INNER JOIN
		bdAfiliacion.dbo.tbPeriodos e 		ON a.cnsctvo_cdgo_prdcdd_prpgo 	= 	e.cnsctvo_cdgo_prdo		INNER JOIN
		bdAfiliacion.dbo.tbVinculados d 		ON a.nmro_unco_idntfccn_empldr 	= 	d.nmro_unco_idntfccn		INNER JOIN
		bdAfiliacion.dbo.tbTiposIdentificacion f	ON d.cnsctvo_cdgo_tpo_idntfccn 		=	f.cnsctvo_cdgo_tpo_idntfccn	INNER JOIN
		tbliquidaciones g 			ON a.cnsctvo_cdgo_lqdcn 		= 	g.cnsctvo_cdgo_lqdcn 		INNER JOIN
		tbPeriodosliquidacion_Vigencias h 	ON g.cnsctvo_cdgo_prdo_lqdcn 		=	h.cnsctvo_cdgo_prdo_lqdcn	INNER JOIN
	             bdAfiliacion.dbo.tbClasesAportantes i 	ON b.cnsctvo_cdgo_clse_aprtnte 		=	 i.cnsctvo_cdgo_clse_aprtnte
Where 		a.cnsctvo_cdgo_estdo_estdo_cnta	=	1  --El estado de cuenta este en estado ingresada
And		a.ttl_pgr					>	0	-- que el estado de cuenta tenga un valor a pagar mayor a cero
and		1=2






Select   nmro_estdo_cnta,		cdgo_tpo_idntfccn, 		nmro_idntfccn, 		dscrpcn_clse_aprtnte,
	nmbre_scrsl,			rzn_scl,				ttl_fctrdo, 		usro_crcn,		cnsctvo_cdgo_lqdcn	 ,
	accn	,		
	cnsctvo_estdo_cnta, 		fcha_gnrcn, 		nmro_unco_idntfccn_empldr,
 	cnsctvo_scrsl, 			cnsctvo_cdgo_clse_aprtnte,       	cnsctvo_cdgo_sde,	vlr_iva, 
	sldo_fvr, 			ttl_pgr,	 			Cts_Cnclr, 		Cts_sn_Cnclr,
 	cdgo_cdd, 			dscrpcn_cdd, 			dscrpcn_prdo, 		cdgo_prdo,
	dscrpcn_tpo_idntfccn, 		drccn, 				tlfno, 			cnsctvo_cdgo_prdo_lqdcn,
 	fcha_incl_fctrcn,		 	fcha_fnl_fctrcn, 	              	fcha_mxma_pgo, 	sldo_antrr,	
	cnsctvo_cdgo_tpo_idntfccn
into 	#TmpImpresionEstadosCuenta_aux
From  #TmpImpresionEstadosCuenta
Where 1  =  2

-- se crea la tabla temporal con la informacion de los estados de cuenta que se van a imprimir
Select   nmro_estdo_cnta,		cdgo_tpo_idntfccn, 		nmro_idntfccn, 		dscrpcn_clse_aprtnte,
	nmbre_scrsl,			rzn_scl,				ttl_fctrdo, 		usro_crcn,		
	cnsctvo_cdgo_lqdcn	 ,
	accn	,		
	cnsctvo_estdo_cnta, 		fcha_gnrcn, 		nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl, 			cnsctvo_cdgo_clse_aprtnte,       	cnsctvo_cdgo_sde,	vlr_iva, 
	sldo_fvr, 			ttl_pgr,	 			Cts_Cnclr, 		Cts_sn_Cnclr,
	cdgo_cdd, 			dscrpcn_cdd, 			dscrpcn_prdo, 		cdgo_prdo,
	dscrpcn_tpo_idntfccn, 		drccn, 				tlfno, 			cnsctvo_cdgo_prdo_lqdcn,
	 fcha_incl_fctrcn,		 	fcha_fnl_fctrcn, 	              	fcha_mxma_pgo, 	sldo_antrr,	
	cnsctvo_cdgo_tpo_idntfccn,	
	 space(1000)  descripcion_concepto,
	 space(1000)  cantidad_Concepto,
	 space(1000)  valor_Concepto,
	 space(1000)  descripcion_concepto1,
	 space(1000)  cantidad_Concepto1,
	 space(1000)  valor_Concepto1
into 	#tmpReporteEstadocuenta		
From	#TmpImpresionEstadosCuenta_aux



-- se crea un atbla temporal con los campos de contratos que aparecen en el detalle del estado de cuenta
select 	space(500)  numero_identificacion,
	space(2000) nombre_cotizante,
	space(500) numero_afiliacion,
	space(150) codigo_plan,
	space(500) valor_contrato,
	space(100) cantidad_beneficiarios,
	space(500)  numero_identificacion1,
	space(2000) nombre_cotizante1,
	space(500) numero_afiliacion1,
	space(150) codigo_plan1,
	space(500) valor_contrato1,
	space(100) cantidad_beneficiarios1,
	nmro_estdo_cnta	  
into    #tmpContratos
From 	#tmpReporteEstadocuenta






Select b.nmro_cntrto,
       a.cntdd_bnfcrs,
       f.cdgo_pln,
       f.dscrpcn_pln,
       f.cnsctvo_cdgo_pln,
       a.vlr_cbrdo,
       a.cnsctvo_estdo_cnta_cntrto,
       g.nmro_estdo_cnta,
       d.cdgo_tpo_idntfccn,
       c.nmro_idntfccn,
       e.prmr_Nmbre ,
       e.sgndo_nmbre,
       e.prmr_aplldo,
       e.sgndo_aplldo,
       ltrim(rtrim(e.prmr_aplldo))  + ' ' + ltrim(rtrim(e.sgndo_aplldo)) + ' ' + ltrim(rtrim(e.sgndo_nmbre)) + ' ' + ltrim(rtrim(e.prmr_Nmbre)) nombre
into #tmpContratosEstadosCuenta_aux
From   TbEstadosCuentaContratos a , bdafiliacion..tbcontratos b ,  bdafiliacion..tbvinculados c,
	bdafiliacion..tbtiposidentificacion   d    , 	bdafiliacion..tbpersonas e , bdplanbeneficios..tbplanes f, #tmpReporteEstadocuenta g
Where  a.cnsctvo_cdgo_tpo_cntrto  	=    b.cnsctvo_cdgo_tpo_cntrto
And    a.nmro_cntrto		   	=    b.nmro_cntrto	 	
And    b.nmro_unco_idntfccn_afldo  	=    c.nmro_unco_idntfccn
And    c.cnsctvo_cdgo_tpo_idntfccn 	=    d.cnsctvo_cdgo_tpo_idntfccn
And    b.nmro_unco_idntfccn_afldo	=    e.nmro_unco_idntfccn
And    b.cnsctvo_cdgo_pln		=    f.cnsctvo_cdgo_pln	
And    g.cnsctvo_estdo_cnta		=   a.cnsctvo_estdo_cnta
And	1=2		
		


--Consulta final del reporte del estado de cuenta
		
Select 	a.*, b.		numero_identificacion,	 b.nombre_cotizante, 	b.numero_afiliacion,
	b.codigo_plan,	b.valor_contrato,		b.cantidad_beneficiarios,
	b.numero_identificacion1, 		b.nombre_cotizante1, 	b.numero_afiliacion1,
	b.codigo_plan1,	b.valor_contrato1,	b.cantidad_beneficiarios1,
	ltrim(rtrim(c.idntfcdor_aplccn)) + ltrim(rtrim(c.cdgo_ps)) + ltrim(rtrim(c.cdgo_emprsa_iac)) + ltrim(rtrim(c.idntfccn_tpo_rcdo)) + ltrim(rtrim(c.dgto_cntrl))  +
	ltrim(rtrim(c.idntfcdor_aplccn_usro)) + ltrim(rtrim(a.nmro_idntfccn)) + ltrim(rtrim(a.nmro_estdo_cnta))+ 
	ltrim(rtrim(c.idntfcdor_aplccn_usro_ia1))  +  ltrim(rtrim(convert(varchar(12),ttl_pgr)))  +
	ltrim(rtrim(c.idntfcdor_aplccn_usro_ia2)) +
	convert(varchar(10),a.fcha_mxma_pgo,112)      Codigo_barras,
	'(' + LTRIM(RTRIM(c.idntfcdor_aplccn)) + ')' +  ltrim(rtrim(c.cdgo_ps)) + ltrim(rtrim(c.cdgo_emprsa_iac)) + ltrim(rtrim(c.idntfccn_tpo_rcdo)) + ltrim(rtrim(c.dgto_cntrl))  +
	'(' + ltrim(rtrim(c.idntfcdor_aplccn_usro)) + ')'  +  ltrim(rtrim(a.nmro_idntfccn)) +  ltrim(rtrim(a.nmro_estdo_cnta)) + '(' + ltrim(rtrim(c.idntfcdor_aplccn_usro_ia1))  + ')' +
	 ltrim(rtrim(convert(varchar(12),ttl_pgr)))  + '(' + ltrim(rtrim(c.idntfcdor_aplccn_usro_ia2)) + ')' + convert(varchar(10),a.fcha_mxma_pgo,112)      Valor_Codigo_barras
From 	#tmpReporteEstadocuenta  a, #tmpContratos b ,  TbEstructuraCodigoBarras_vigencias  c
Where 	a.nmro_estdo_cnta= b.nmro_estdo_cnta
And	getdate() 	between 	c.inco_vgnca 	and 	c. fn_vgnca
And	cnsctvo_vgnca_estrctra_cdgo_brrs = 1    -- consecutivo del  codigo de barras