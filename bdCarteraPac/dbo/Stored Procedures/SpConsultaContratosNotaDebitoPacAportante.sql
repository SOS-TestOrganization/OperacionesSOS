/*---------------------------------------------------------------------------------
* Metodo o PRG 		:  SpConsultaContratosNotaDebitoPacAportante
* Desarrollado por		: <\A Ing. Rolando simbaqueva lasso									A\>
* Descripcion			: <\D Este procedimiento realiza una busqueda de loscontratos del responsable			  	D\>
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

CREATE      PROCEDURE SpConsultaContratosNotaDebitoPacAportante
	@lnConsecutivoClaseAportante	udtconsecutivo,
	@lnNumeroInicoIdentificacion	udtConsecutivo,
	@lnConsecutivoSucursal		udtConsecutivo

As	Declare
@ldFechaSistema	Datetime


Set Nocount On
Select 	@ldFechaSistema	=	Getdate()


-- SE TRAE LOS CONTRATOS PAC DEL APORTANTE DEL PARAMETRO Y SIN IMPORTANTE SI ESTAN VIGENTES
select  	* 
into 	#tmpCobranzas
From	bdafiliacion..tbCobranzas
where 	 nmro_unco_idntfccn_aprtnte	 = 	@lnNumeroInicoIdentificacion
and 	cnsctvo_cdgo_clse_aprtnte 	 = 	@lnConsecutivoClaseAportante
And	cnsctvo_cdgo_tpo_cntrto	 =	2

-- SE AGRUPA PARA TRAER TODOS LOS CONTRATOS 

Select 	 cnsctvo_cdgo_tpo_cntrto,	 nmro_cntrto
into	 #tmpContratosCobranzas
From	#tmpCobranzas
Group by cnsctvo_cdgo_tpo_cntrto, 	nmro_cntrto


-- SE CREA LA TABLA TEMPORAL CON TODA LA INFORMACION DE LOS CONTRATOS 
Select    a.nmro_cntrto,			a.cnsctvo_cdgo_tpo_cntrto, 		a.cnsctvo_cdgo_pln,		
         	 a.inco_vgnca_cntrto,		a.fn_vgnca_cntrto,			a.nmro_unco_idntfccn_afldo,
	 0	cnsctvo_cbrnza,
	 1	cnsctvo_vgnca_cbrnza,
	 1	cnsctvo_cdgo_prdcdd_prpgo,
	 a.inco_vgnca_cntrto		inco_vgnca_cbrnza,
	 a.fn_vgnca_cntrto		fn_vgnca_cbrnza,
	 0				cta_mnsl
into       #tmpContratos
From bdafiliacion..tbcontratos  a ,  #tmpContratosCobranzas  b
Where 	a.cnsctvo_cdgo_tpo_cntrto 		=	2
and	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto

-- SE ACTUALIZA LA COBRANZA
Update #tmpContratos
Set	cnsctvo_cbrnza			=	b.cnsctvo_cbrnza
From	#tmpContratos a, #tmpCobranzas b
where   a.nmro_cntrto			=	b.nmro_cntrto
And	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto


-- Se traer los contratos asociados al responsable
Select  a.nmro_cntrto,	f.cdgo_tpo_idntfccn,	e.nmro_idntfccn,
	ltrim(rtrim(d.prmr_aplldo)) + ' ' + ltrim(rtrim(d.sgndo_aplldo)) + ' ' + ltrim(rtrim(d.prmr_nmbre)) + ' ' +ltrim(rtrim(sgndo_nmbre)) nombre,p. dscrpcn_pln  , 
	'NO SELECCIONADO'	accn,
	a.cnsctvo_cdgo_tpo_cntrto,	a.cnsctvo_cdgo_pln,		a.inco_vgnca_cntrto,	a.fn_vgnca_cntrto,	a.nmro_unco_idntfccn_afldo,
	a.cnsctvo_cbrnza,		@lnNumeroInicoIdentificacion	 nmro_unco_idntfccn_aprtnte,	
	a.cnsctvo_vgnca_cbrnza,	@lnConsecutivoSucursal		 cnsctvo_scrsl_ctznte,
	a.inco_vgnca_cbrnza,		a.fn_vgnca_cbrnza,		a.cta_mnsl,
	a.cnsctvo_cdgo_prdcdd_prpgo,	p.cdgo_pln	
From 	#tmpContratos   a,			bdafiliacion..tbpersonas d,
	bdafiliacion..tbvinculados  e, 	bdafiliacion..tbtiposidentificacion f		,
	bdplanbeneficios..tbplanes	p
Where   a.nmro_unco_idntfccn_afldo	=	d.nmro_unco_idntfccn
And	d.nmro_unco_idntfccn		=	e.nmro_unco_idntfccn
And	e.cnsctvo_cdgo_tpo_idntfccn	=	f.cnsctvo_cdgo_tpo_idntfccn
And	a.cnsctvo_cdgo_pln		=	p.cnsctvo_cdgo_pln