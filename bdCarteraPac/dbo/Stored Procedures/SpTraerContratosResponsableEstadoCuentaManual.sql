/*---------------------------------------------------------------------------------
* Metodo o PRG 		:  SpTraerContratosResponsableEstadoCuentaManual
* Desarrollado por		: <\A Ing. Rolando simbaqueva lasso									A\>
* Descripcion			: <\D Este procedimiento realiza una busqueda de loscontratos del responsable de un estado de cuenta donde ya existe el contrato			  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P  													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003/02/05 											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  Rolando Simbaqueva LassoAM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM 2003/03/25	 FM\>
*---------------------------------------------------------------------------------*/

CREATE PROCEDURE SpTraerContratosResponsableEstadoCuentaManual
	@lnNumeroEstadoCuenta	Varchar(15)

As	

Set Nocount On


Select  cnsctvo_cnta_mnls_cntrto,
        nmro_estdo_cnta,
        cnsctvo_cdgo_tpo_cntrto,
        nmro_cntrto,
        vlr_cbrdo,
        sldo,
        cntdd_bnfcrs
        cnsctvo_cdgo_pln,
        usro_crcn,
        fcha_crcn
into    #tmpContratosEstadoCuenta
From     TbCuentasManualesContrato
Where 	nmro_estdo_cnta 		=	@lnNumeroEstadoCuenta


Select  a.*
into #Tmpcontratos 
From	bdafiliacion..tbcontratos a , #tmpContratosEstadoCuenta b
where	a.cnsctvo_cdgo_tpo_cntrto 	=	 b.cnsctvo_cdgo_tpo_cntrto
And 	a.nmro_cntrto		  	= 	 b.nmro_cntrto


Select  a.*
into   #tmpcobranzas
From	bdafiliacion..tbcobranzas a	,#tmpContratosEstadoCuenta b
where	a.cnsctvo_cdgo_tpo_cntrto 	=	 b.cnsctvo_cdgo_tpo_cntrto
And 	a.nmro_cntrto		  	= 	 b.nmro_cntrto




Select  a.*
into	 #TmpVigenciasCobranzas
From	bdafiliacion..tbVigenciasCobranzas a ,#tmpContratosEstadoCuenta b
where	a.cnsctvo_cdgo_tpo_cntrto 	=	 b.cnsctvo_cdgo_tpo_cntrto
And 	a.nmro_cntrto		  	= 	 b.nmro_cntrto



Select  a.nmro_cntrto,	f.cdgo_tpo_idntfccn,	e.nmro_idntfccn,
	ltrim(rtrim(d.prmr_aplldo)) + ' ' + ltrim(rtrim(d.sgndo_aplldo)) + ' ' + ltrim(rtrim(d.prmr_nmbre)) + ' ' +ltrim(rtrim(sgndo_nmbre)) nombre, p. dscrpcn_pln   ,

	'NO SELECCIONADO'	accn,
	a.cnsctvo_cdgo_tpo_cntrto,	a.cnsctvo_cdgo_pln,		a.inco_vgnca_cntrto,	a.fn_vgnca_cntrto,	a.nmro_unco_idntfccn_afldo,
	b.cnsctvo_cbrnza,		b.nmro_unco_idntfccn_aprtnte,	
	c.cnsctvo_vgnca_cbrnza,		c.cnsctvo_scrsl_ctznte,		c.inco_vgnca_cbrnza,	c.fn_vgnca_cbrnza,	c.cta_mnsl,
	b.cnsctvo_cdgo_prdcdd_prpgo	,p.cdgo_pln	
From 	#Tmpcontratos a,		#tmpcobranzas b , 	#TmpVigenciasCobranzas c,	
	bdafiliacion..tbpersonas d,
	bdafiliacion..tbvinculados  e, 		
	bdplanbeneficios..tbplanes	p,
	bdafiliacion..tbtiposidentificacion f	
Where   a.cnsctvo_cdgo_tpo_cntrto 	=	 b.cnsctvo_cdgo_tpo_cntrto
And 	a.nmro_cntrto		  	= 	 b.nmro_cntrto
And	c.cnsctvo_cdgo_tpo_cntrto 	=	 b.cnsctvo_cdgo_tpo_cntrto
And	c.nmro_cntrto		  	=	 b.nmro_cntrto
And	c.cnsctvo_cbrnza	  	=	 b.cnsctvo_cbrnza
And	a.nmro_unco_idntfccn_afldo	=	d.nmro_unco_idntfccn
And	d.nmro_unco_idntfccn		=	e.nmro_unco_idntfccn
And	a.cnsctvo_cdgo_pln		=	p.cnsctvo_cdgo_pln
And	e.cnsctvo_cdgo_tpo_idntfccn	=	f.cnsctvo_cdgo_tpo_idntfccn
and	getdate()	between c.inco_vgnca_cbrnza and	c.fn_vgnca_cbrnza