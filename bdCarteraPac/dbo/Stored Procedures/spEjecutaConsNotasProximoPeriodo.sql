

/*---------------------------------------------------------------------------------
* Metodo o PRG 			: spEjecutaConsNotasProximoPeriodo
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento para generar el reporte de la cartera vebcida		 	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2008/01/10											FC\>
*
*---------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[spEjecutaConsNotasProximoPeriodo]

AS

Declare
@tbla    	varchar(128),
@cdgo_cmpo    	varchar(128),
@oprdr     	varchar(2),
@vlr     varchar(250),
@cmpo_rlcn    varchar(128),
@cmpo_rlcn_prmtro   varchar(128),
@cnsctvo   Numeric(4),
@ldFechaSistema  Datetime,
@cnsctvo_cdgo_tpo_idntfccn_empldr int,
@fcha_crcn_ini   Datetime,
@fcha_crcn_fn   Datetime,
@cnsctvo_scrsl	  int,
@cnsctvo_cdgo_clse_aprtnte int, 
@nmro_unco_idntfccn_empldr int,
@nmro_nta_ini   varchar(15),
@nmro_nta_fn   Varchar(15),
@Valor_Porcentaje_Iva int
 

Set Nocount On

Set 	@fcha_crcn_ini   			=NULL
Set 	@fcha_crcn_fn   			=NULL

Set 	@cnsctvo_scrsl  			=NULL
Set 	@cnsctvo_cdgo_clse_aprtnte  		=NULL
SET 	@nmro_unco_idntfccn_empldr		=NULL

Set 	@nmro_nta_fn   				=NULL
Set 	@nmro_nta_ini   			=NULL

Select @ldFechaSistema = Getdate()



Select  @fcha_crcn_ini   = vlr +' 00:00:00' 
From  #tbCriteriosTmp
Where  cmpo_rlcn   =  'fcha_crcn' 
And oprdr      =  '>='

Select @fcha_crcn_fn  = vlr +' 23:59:59' 
From  #tbCriteriosTmp
Where  cmpo_rlcn   =  'fcha_crcn' 
And oprdr       =  '<='

Select  @nmro_nta_ini   = vlr 
From  #tbCriteriosTmp
Where  cdgo_cmpo   =  'nmro_nta' 
And oprdr      =  '>='

Select @nmro_nta_fn  = vlr 
From  #tbCriteriosTmp
Where  cdgo_cmpo   =  'nmro_nta' 
And oprdr       =  '<='

Select @cnsctvo_scrsl  = vlr 
From  #tbCriteriosTmp
Where  cdgo_cmpo   =  'cnsctvo_scrsl' 
And oprdr       =  '='
   
Select @cnsctvo_cdgo_clse_aprtnte   = vlr 
From  #tbCriteriosTmp
Where  cdgo_cmpo   =  'cnsctvo_cdgo_clse_aprtnte ' 
And oprdr       =  '='
     
     
Select @nmro_unco_idntfccn_empldr   = vlr 
From  #tbCriteriosTmp
Where  cdgo_cmpo   =  'nmro_unco_idntfccn_empldr' 
And oprdr       =  '='

Select	@Valor_Porcentaje_Iva	= prcntje
From	bdCarteraPac.dbo.tbConceptosLiquidacion_Vigencias
Where	cnsctvo_cdgo_cncpto_lqdcn	= 3
And	@ldFechaSistema	Between inco_vgnca And 	fn_vgnca


select 	a.nmro_nta, 
	c.vlr_nta, 
	Convert(Numeric(12,0),c.vlr_nta *@Valor_Porcentaje_Iva/100) Vlr_iva,
	a.fcha_crcn_nta,
	space(3) Ti_Responsable,
  space(15) Ni_Responsable,
	space(100) nombre_Responsable,
	a.nmro_unco_idntfccn_empldr,
	a.cnsctvo_cdgo_clse_aprtnte,
	a.cnsctvo_scrsl,
	0 cnsctvo_cdgo_tpo_idntfccn_empldr,
	a.usro_crcn,
	d.cdgo_cncpto_lqdcn,
  d.dscrpcn_cncpto_lqdcn,
	a.obsrvcns
into    #tbNotasProxPeriodo
from 	tbnotasPac     a, 
        bdAfiliacion..tbSucursalesAportante  b,
				tbNotasConceptos c,
				tbConceptosLiquidacion d 
where   a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn_empldr   
	And 	a.cnsctvo_cdgo_clse_aprtnte = b.cnsctvo_cdgo_clse_aprtnte  
	And	a.cnsctvo_scrsl  							= b.cnsctvo_scrsl 
	And c.cnsctvo_cdgo_tpo_nta 				= a.cnsctvo_cdgo_tpo_nta
	And c.nmro_nta										=a.nmro_nta
	And d.cnsctvo_cdgo_cncpto_lqdcn=c.cnsctvo_cdgo_cncpto_lqdcn
	And   	(@fcha_crcn_ini is null or (@fcha_crcn_ini is not null and fcha_crcn_nta  between @fcha_crcn_ini and @fcha_crcn_fn))
	And     (@nmro_nta_ini  is null or (@nmro_nta_ini is not null and convert(int,a.nmro_nta)  between convert(int,@nmro_nta_ini) and convert(int,@nmro_nta_fn)))
	And	(@cnsctvo_scrsl is null or (@cnsctvo_scrsl is not null and convert(int,a.cnsctvo_scrsl)  between convert(int,@cnsctvo_scrsl) and convert(int,@cnsctvo_scrsl)))
	And	(@cnsctvo_cdgo_clse_aprtnte 		is null or (@cnsctvo_cdgo_clse_aprtnte is not null and convert(int,a.cnsctvo_cdgo_clse_aprtnte)  between convert(int,@cnsctvo_cdgo_clse_aprtnte) and convert(int,@cnsctvo_cdgo_clse_aprtnte)))
	And	(@nmro_unco_idntfccn_empldr is null or (@nmro_unco_idntfccn_empldr is not null and convert(int,a.nmro_unco_idntfccn_empldr)  between convert(int,@nmro_unco_idntfccn_empldr) and convert(int,@nmro_unco_idntfccn_empldr)))

	And 	a.cnsctvo_cdgo_tpo_nta 					= 2
	And 	a.cnsctvo_cdgo_tpo_aplccn_nta		= 2	
	And   a.cnsctvo_cdgo_estdo_nta			 	<> 6



 Update #tbNotasProxPeriodo
 Set Ni_Responsable    = convert(varchar(11),b.nmro_idntfccn),
 cnsctvo_cdgo_tpo_idntfccn_empldr = b.cnsctvo_cdgo_tpo_idntfccn
 From #tbNotasProxPeriodo a,   bdAfiliacion..tbvinculados b
 Where  a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn

 update  #tbNotasProxPeriodo
 Set Ti_Responsable = b.cdgo_tpo_idntfccn
 From #tbNotasProxPeriodo a , bdafiliacion..tbtiposidentificacion b
 Where   a.cnsctvo_cdgo_tpo_idntfccn_empldr = b.cnsctvo_cdgo_tpo_idntfccn


 Update  #tbNotasProxPeriodo
 Set nombre_responsable  =   ltrim(rtrim(prmr_nmbre))  + ' ' + ltrim(rtrim(sgndo_nmbre)) + ' ' + ltrim(rtrim(prmr_aplldo)) + ' '+ ltrim(rtrim(sgndo_aplldo))
 From #tbNotasProxPeriodo a , bdAfiliacion..tbpersonas b
 Where   a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn



Update  a 
Set nombre_responsable  =   ltrim(rtrim(nmbre_scrsl))
From #tbNotasProxPeriodo a , bdAfiliacion..tbSucursalesaportante b
Where   a.nmro_unco_idntfccn_empldr 	= 	b.nmro_unco_idntfccn_empldr
and 	a.cnsctvo_cdgo_clse_aprtnte 	= 	b.cnsctvo_cdgo_clse_aprtnte
and     a.cnsctvo_scrsl			=	b.cnsctvo_scrsl	


select 	nmro_nta, vlr_nta, vlr_iva, (vlr_nta+vlr_iva) as total, fcha_crcn_nta,usro_crcn, cdgo_cncpto_lqdcn,dscrpcn_cncpto_lqdcn,  Ti_Responsable, Ni_Responsable, nombre_Responsable, obsrvcns
from #tbNotasProxPeriodo



