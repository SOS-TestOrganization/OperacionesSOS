/*---------------------------------------------------------------------------------
* Metodo o PRG 		:  SpTraerContratosResponsableXPlan
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

CREATE PROCEDURE SpTraerContratosResponsableXPlan
	@lnConsecutivoClaseAportante	udtconsecutivo,
	@lnNumeroInicoIdentificacion	udtConsecutivo,
	@lnConsecutivoSucursal		udtConsecutivo,
	@lnconsecutivoCodigoPlan	udtConsecutivo

As	Declare
@ldFechaSistema	Datetime


Set Nocount On
Select 	@ldFechaSistema	=	Getdate()

--Primero traer los contratos activos

Select cnsctvo_cdgo_tpo_cntrto, nmro_cntrto  ,   cnsctvo_bnfcro, nmro_unco_idntfccn_bnfcro, inco_vgnca_bnfcro  ,
       fn_vgnca_bnfcro
Into #tmpBeneficiarios                        
from bdafiliacion..tbBeneficiarios
Where cnsctvo_cdgo_tpo_cntrto = 2

Select  cnsctvo_cdgo_tpo_cntrto , nmro_cntrto  ,   cnsctvo_bnfcro,
	nmro_unco_idntfccn_bnfcro,  cnsctvo_cdgo_estdo_bfcro
Into #tmpHistoricoEstadosBeneficiario 
from  bdafiliacion..tbHistoricoEstadosBeneficiario
Where cnsctvo_cdgo_tpo_cntrto = 2
and ( cnsctvo_cdgo_estdo_bfcro = 1 or cnsctvo_cdgo_estdo_bfcro  = 5 )





Select    cnsctvo_cdgo_tpo_cntrto  , nmro_cntrto
into #tmpContratos
From bdafiliacion..tbcontratos
Where cnsctvo_cdgo_tpo_cntrto 		=	2
And	@ldFechaSistema	  between  inco_vgnca_cntrto	  and 	 fn_vgnca_cntrto



Select  a.cnsctvo_cdgo_tpo_cntrto,	 a.nmro_cntrto
into   #tmpContratosActivospac
From   #tmpHistoricoEstadosBeneficiario a,  #tmpBeneficiarios b  , #tmpContratos c
Where 	a.cnsctvo_cdgo_tpo_cntrto	 = b.cnsctvo_cdgo_tpo_cntrto
AND	 a.nmro_cntrto = b.nmro_cntrto
And	a.cnsctvo_bnfcro	=	b.cnsctvo_bnfcro
And     a.cnsctvo_cdgo_tpo_cntrto	 = c.cnsctvo_cdgo_tpo_cntrto
AND	 a.nmro_cntrto = c.nmro_cntrto
Group by a.cnsctvo_cdgo_tpo_cntrto,	 a.nmro_cntrto

/*
SELECT    	 a.cnsctvo_cdgo_tpo_cntrto,	 a.nmro_cntrto
into  #tmpContratosActivospac
FROM       	 bdafiliacion..tbContratos a INNER JOIN  bdafiliacion..tbBeneficiarios b 
						ON	a.cnsctvo_cdgo_tpo_cntrto	 = b.cnsctvo_cdgo_tpo_cntrto AND a.nmro_cntrto = b.nmro_cntrto
					 INNER JOIN  bdafiliacion..tbHistoricoEstadosBeneficiario c 
						ON 	b.cnsctvo_cdgo_tpo_cntrto	 = c.cnsctvo_cdgo_tpo_cntrto AND b.nmro_cntrto = c.nmro_cntrto AND 
						              b.cnsctvo_bnfcro		 = c.cnsctvo_bnfcro
WHERE     (@ldFechaSistema	 BETWEEN c.inco_vgnca_estdo_bnfcro AND c.fn_vgnca_estdo_bnfcro) AND (a.cnsctvo_cdgo_tpo_cntrto = 2)
And	    b.cnsctvo_bnfcro	=	1  -- se compara con el consecutivo  del beneficiario 1
And	    (c.cnsctvo_cdgo_estdo_bfcro = 1 or c.cnsctvo_cdgo_estdo_bfcro  = 5 )  -- Consecutivo del estado del beneficiario (Activo o suspedido)
GROUP BY a.cnsctvo_cdgo_tpo_cntrto, 		a.nmro_cntrto
 */

Select   cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	cnsctvo_cdgo_pln,
	cnsctvo_cdgo_tpo_aflcn,
	inco_vgnca_cntrto,
	fn_vgnca_cntrto,
	estdo_cntrto,
	cnsctvo_cdgo_tpo_frmlro,
	nmro_frmlro,
	nmro_unco_idntfccn_afldo
into 	#tmpContratospac
From 	bdafiliacion..tbcontratos
where 	cnsctvo_cdgo_tpo_cntrto 	= 	2


Select    cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	cnsctvo_cbrnza,
	nmro_unco_idntfccn_aprtnte,
	cnsctvo_cdgo_clse_aprtnte,
	cnsctvo_cdgo_tpo_cbrnza,
	prncpl,
	slro_vrble,
	cnsctvo_cdgo_fmra_aflcn,
	cnsctvo_cdgo_tpo_ctznte,
	cnsctvo_cdgo_frma_cbro,
	cnsctvo_cdgo_prdcdd_prpgo,
	cnsctvo_cdgo_crgo_empldo,
	fcha_ingrso_lbrr,
	estdo
into 	#tmpcobranzas
From	bdafiliacion..tbcobranzas
where cnsctvo_cdgo_tpo_cntrto = 2


Select   cnsctvo_vgnca_cbrnza,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	cnsctvo_cbrnza,
	cnsctvo_scrsl_ctznte,
	inco_vgnca_cbrnza,
	fn_vgnca_cbrnza,
	ingrso_bse,
	ingrso_bse_ps,
	cta_mnsl,
	vlr_msda_pnsnl,
	estdo_rgstro,
	inco_drcn_rgstro,
	fn_drcn_rgstro
into #tmpVigenciasCobranzas
From	bdafiliacion..tbVigenciasCobranzas
where cnsctvo_cdgo_tpo_cntrto = 2


-- Se traer los contratos asociados al responsable
Select  a.nmro_cntrto,	f.cdgo_tpo_idntfccn,	e.nmro_idntfccn,
	ltrim(rtrim(d.prmr_aplldo)) + ' ' + ltrim(rtrim(d.sgndo_aplldo)) + ' ' + ltrim(rtrim(d.prmr_nmbre)) + ' ' +ltrim(rtrim(sgndo_nmbre)) nombre, convert (numeric(12,0),0)  valor ,
	'NO SELECCIONADO'	accn,
	a.cnsctvo_cdgo_tpo_cntrto,	a.cnsctvo_cdgo_pln,		a.inco_vgnca_cntrto,	a.fn_vgnca_cntrto,	a.nmro_unco_idntfccn_afldo,
	b.cnsctvo_cbrnza,		b.nmro_unco_idntfccn_aprtnte,	
	c.cnsctvo_vgnca_cbrnza,		c.cnsctvo_scrsl_ctznte,		c.inco_vgnca_cbrnza,	c.fn_vgnca_cbrnza,	c.cta_mnsl,
	b.cnsctvo_cdgo_prdcdd_prpgo	,p.cdgo_pln,	p. dscrpcn_pln   
From 	#tmpContratosPac  a,		#tmpcobranzas   b , 	#tmpVigenciasCobranzas  c,	bdafiliacion..tbpersonas d,
	bdafiliacion..tbvinculados  e, 	bdafiliacion..tbtiposidentificacion f	,	#tmpContratosActivospac h,
	bdplanbeneficios..tbplanes	p
Where   a.cnsctvo_cdgo_tpo_cntrto 	=	 b.cnsctvo_cdgo_tpo_cntrto
And 	a.nmro_cntrto		  	= 	 b.nmro_cntrto
And	a.cnsctvo_cdgo_tpo_cntrto 	= 	 h.cnsctvo_cdgo_tpo_cntrto
And 	a.nmro_cntrto		  	= 	 h.nmro_cntrto				
And	c.cnsctvo_cdgo_tpo_cntrto 	=	 b.cnsctvo_cdgo_tpo_cntrto
And	c.nmro_cntrto		  	=	 b.nmro_cntrto
And	c.cnsctvo_cbrnza	  	=	 b.cnsctvo_cbrnza
And	@ldFechaSistema	 between	  inco_vgnca_cbrnza 	and	 fn_vgnca_cbrnza
And	a.nmro_unco_idntfccn_afldo	=	d.nmro_unco_idntfccn
And	d.nmro_unco_idntfccn		=	e.nmro_unco_idntfccn
And	e.cnsctvo_cdgo_tpo_idntfccn	=	f.cnsctvo_cdgo_tpo_idntfccn
And	b.cnsctvo_cdgo_clse_aprtnte	=	@lnConsecutivoClaseAportante	
And	b.nmro_unco_idntfccn_aprtnte	=	@lnNumeroInicoIdentificacion
And	c.cnsctvo_scrsl_ctznte		=	@lnConsecutivoSucursal
And	a.cnsctvo_cdgo_pln		=	p.cnsctvo_cdgo_pln
and	a.cnsctvo_cdgo_pln		=	@lnconsecutivoCodigoPlan