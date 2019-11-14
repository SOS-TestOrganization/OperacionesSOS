


/*---------------------------------------------------------------------------------
* Metodo o PRG		: spPlanoMunicipioCali
* Desarrollado por	: <\A Ing. Rolando simbaqueva Lasso						A\>
* Descripcion		: <\D Este procedimiento crea la informacion del archivo del municipio  	D\>
* Observaciones		: <\O  										O\>
* Parametros		: <\P										P\>
* Variables		: <\V  										V\>
* Fecha Creacion	: <\FC 2006/02/20								FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por	: <\AM  AM\>
* Descripcion		: <\DM  DM\>
* Nuevos Parametros	: <\PM  PM\>
* Nuevas Variables	: <\VM  VM\>
* Fecha Modificacion	: <\FM  FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[spPlanoAcuavalle]
@lcMensaje			Char(200) = ''

As

Declare @ldfechaSistema		Datetime,
						@Nmro_estdo_cnta	Varchar(15),
						@lnPeriodoEvaluar int,
						@Valor_Porcentaje_Iva int

Set Nocount On

Set	@lnPeriodoEvaluar = 0
Set	@ldfechaSistema	=	Getdate()


Select	@Valor_Porcentaje_Iva	=  convert(int,prcntje)
From	bdCarteraPac.dbo.tbConceptosLiquidacion_Vigencias
Where	cnsctvo_cdgo_cncpto_lqdcn	= 3
And	getdate()	Between inco_vgnca And 	fn_vgnca



Select 	@Nmro_estdo_cnta =	vlr
From 	#tbCriteriosTmp
Where 	cmpo_rlcn	 = 	'nmro_estdo_cnta'

Select	@lnPeriodoEvaluar	= Convert(Int,vlr)
From	#tbCriteriosTmp
Where 	cdgo_cmpo		= 'prdo_lqdcn'



Create	Table #tmp1
	(tpo_idntfccn_bnfcro Char(3),			
	nmro_idntfccn_bnfcro Varchar(23),
	 nmbre_bnfcro Varchar(100),			
	 nmro_cntrto Char(15),
	 cnsctvo_cdgo_tpo_cntrto Int,			
	 cnsctvo_bnfcro Int,
	 nmro_unco_idntfccn_bnfcro udtConsecutivo,	
	 nui_ctznte udtConsecutivo,
	 prntsco Int,		
	 vlr_bse udtValorGrande,
	 vlr_iva udtValorGrande,
	 Vlr udtValorGrande, 
	 cntdd_bnfcrs Int,				
	 cnsctvo_cdgo_pln Int,
	 cdgo_pln Char(2),
	 cdd_rsdnca varchar(100),
	 cnsctvo_scrsl int )


IF @lnPeriodoEvaluar  != 0
BEGIN

Select	cnsctvo_cdgo_lqdcn
Into	#tmpLiquidacionesFinalizadas
From	bdCarteraPac.dbo.tbPeriodosliquidacion_Vigencias a, bdCarteraPac.dbo.tbLiquidaciones b
Where   a.cnsctvo_cdgo_prdo_lqdcn	=	b.cnsctvo_cdgo_prdo_lqdcn
And	b.cnsctvo_cdgo_estdo_lqdcn	=	3
And bdrecaudos.dbo.fnCalculaPeriodo (a.fcha_incl_prdo_lqdcn)	=  	@lnPeriodoEvaluar


Insert	Into #tmp1
	(tpo_idntfccn_bnfcro,		nmro_idntfccn_bnfcro,
	 nmbre_bnfcro,			nmro_cntrto,
	 cnsctvo_cdgo_tpo_cntrto,	cnsctvo_bnfcro,
	 nmro_unco_idntfccn_bnfcro,	nui_ctznte,
	 prntsco,		
	vlr_bse,
	 vlr_iva ,
	 Vlr,
	 cntdd_bnfcrs,			cnsctvo_cdgo_pln,
	 cdgo_pln,
	 cdd_rsdnca,
	 cnsctvo_scrsl)
Select  '',				'',
	'',				b.nmro_cntrto,
	b.cnsctvo_cdgo_tpo_cntrto,	c.cnsctvo_bnfcro,
	c.nmro_unco_idntfccn_bnfcro,	0,
	0,			
	 0,
	 0,
	 c.Vlr,
	b.cntdd_bnfcrs,			0,
	'',
	'',
	a.cnsctvo_scrsl
From	 	#tmpLiquidacionesFinalizadas  l
inner join bdCarteraPac.dbo.tbEstadosCuenta a
on l.cnsctvo_cdgo_lqdcn = a.cnsctvo_cdgo_lqdcn
Inner Join 	bdCarteraPac.dbo.tbEstadosCuentaContratos b
On	a.cnsctvo_estdo_cnta 	    = b.cnsctvo_estdo_cnta Inner Join
	bdCarteraPac.dbo.tbCuentasContratosBeneficiarios c
On	b.cnsctvo_estdo_cnta_cntrto = c.cnsctvo_estdo_cnta_cntrto
where a.cnsctvo_cdgo_estdo_estdo_cnta  ! = 4
END
ELSE
BEGIN

Insert	Into #tmp1
	(tpo_idntfccn_bnfcro,		nmro_idntfccn_bnfcro,
	 nmbre_bnfcro,			nmro_cntrto,
	 cnsctvo_cdgo_tpo_cntrto,	cnsctvo_bnfcro,
	 nmro_unco_idntfccn_bnfcro,	nui_ctznte,
	 prntsco,		
	vlr_bse,
	 vlr_iva ,
	 Vlr,
	 cntdd_bnfcrs,			cnsctvo_cdgo_pln,
	 cdgo_pln,
	 cdd_rsdnca,
	 cnsctvo_scrsl)
Select  '',				'',
	'',				b.nmro_cntrto,
	b.cnsctvo_cdgo_tpo_cntrto,	c.cnsctvo_bnfcro,
	c.nmro_unco_idntfccn_bnfcro,	0,
	0,			
	 0,
	 0,
	 c.Vlr,
	b.cntdd_bnfcrs,			0,
	'',
	'',
	a.cnsctvo_scrsl
From	 	bdCarteraPac.dbo.tbLiquidaciones  l
inner join bdCarteraPac.dbo.tbEstadosCuenta a
on l.cnsctvo_cdgo_lqdcn = a.cnsctvo_cdgo_lqdcn
Inner Join 	bdCarteraPac.dbo.tbEstadosCuentaContratos b
On	a.cnsctvo_estdo_cnta 	    = b.cnsctvo_estdo_cnta Inner Join
	bdCarteraPac.dbo.tbCuentasContratosBeneficiarios c
On	b.cnsctvo_estdo_cnta_cntrto = c.cnsctvo_estdo_cnta_cntrto
Where	a.nmro_estdo_cnta	=	@Nmro_estdo_cnta
and l.cnsctvo_cdgo_estdo_lqdcn	=	3
END

update  #tmp1
set  	vlr_bse = vlr / 1.05

update  #tmp1
set  	vlr_iva = vlr - vlr_bse


--update  #tmp1
--set  	vlr_bse = vlr /1.1,
--	 			vlr_iva  = ((vlr /1.1) *0.10 ) 

Update	#tmp1
Set	prntsco = x.cnsctvo_cdgo_prntsco 
From	#tmp1 a Inner Join
	bdafiliacion.dbo.tbBeneficiarios x
On	a.cnsctvo_bnfcro =  x.cnsctvo_bnfcro
And	a.nmro_cntrto = x.nmro_cntrto
And	a.cnsctvo_cdgo_tpo_cntrto = x.cnsctvo_cdgo_tpo_cntrto

Update	#tmp1
Set	nui_ctznte = z.nmro_unco_idntfccn_afldo,
	cnsctvo_cdgo_pln = z.cnsctvo_cdgo_pln
From	#tmp1 a Inner Join
	bdafiliacion.dbo.tbcontratos z
On	a.nmro_cntrto = z.nmro_cntrto
And	a.cnsctvo_cdgo_tpo_cntrto = z.cnsctvo_cdgo_tpo_cntrto

Update	#tmp1
Set	cdgo_pln = p.cdgo_pln
From	#tmp1 a Inner Join
	bdPlanBeneficios.dbo.tbplanes p
On	a.cnsctvo_cdgo_pln = p.cnsctvo_cdgo_pln

Update	#tmp1
Set	tpo_idntfccn_bnfcro = ti.cdgo_tpo_idntfccn,
	nmro_idntfccn_bnfcro = v.nmro_idntfccn
From	#tmp1 a Inner Join
	bdafiliacion.dbo.tbVinculados v
On	a.nui_ctznte = v.nmro_unco_idntfccn Inner Join
	bdAfiliacion.dbo.tbTiposIdentificacion ti
On	v.cnsctvo_cdgo_tpo_idntfccn = ti.cnsctvo_cdgo_tpo_idntfccn

Update	#tmp1
Set	nmbre_bnfcro	= Convert(Varchar(50),Ltrim(Rtrim(prmr_aplldo)) + ' ' + Ltrim(Rtrim(sgndo_aplldo)) + ' ' + Ltrim(Rtrim(prmr_nmbre)) + ' '  + Ltrim(Rtrim(sgndo_nmbre)))
From	#tmp1 a Inner Join
	bdafiliacion.dbo.tbPersonas b
On	a.nui_ctznte	=	b.nmro_unco_idntfccn


Update  a
Set	  	a.cdd_rsdnca			=	  ltrim(Rtrim(c.dscrpcn_cdd))
From	#tmp1 a inner join bdAfiliacion.dbo.tbPersonas b on
  a.nui_ctznte	=	b.nmro_unco_idntfccn
	inner join bdAfiliacion.dbo.tbCiudades c
on 	b.cnsctvo_cdgo_cdd_rsdnca		=	c.cnsctvo_cdgo_cdd

Update  a
Set	  	a.cdd_rsdnca			=	  ltrim(Rtrim(c.dscrpcn_cdd))
From	#tmp1 a inner join bdAfiliacion.dbo.tbPersonas b on
  a.nui_ctznte	=	b.nmro_unco_idntfccn
	inner join bdAfiliacion.dbo.tbCiudades c
on 	b.cnsctvo_cdgo_cdd_crrspndnca		=	c.cnsctvo_cdgo_cdd
where cdd_rsdnca = ' '


select  tpo_idntfccn_bnfcro ,
nmro_idntfccn_bnfcro    ,    
nmbre_bnfcro ,
cdd_rsdnca ,
nmro_cntrto ,
cdgo_pln ,
vlr_bse ,
vlr_iva   ,
Vlr  ,
prntsco,
cnsctvo_scrsl,
cntdd_bnfcrs
from #tmp1
Order By  nmro_cntrto



