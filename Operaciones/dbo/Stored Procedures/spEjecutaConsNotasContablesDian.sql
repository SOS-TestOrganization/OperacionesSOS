
/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spEjecutaConsNotasContablesdIAN
* Desarrollado por		: <\A Fernnado Valencia Echeverry							A\>
* Descripcion			: <\D Este procedimiento para generar Notas debito a la DIAN		 	D\>
* Observaciones		: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2006/05/10											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[spEjecutaConsNotasContablesDian]

As

Declare
@tbla				varchar(128),
@cdgo_cmpo 			varchar(128),
@oprdr 			varchar(2),
@vlr 				varchar(250),
@cmpo_rlcn 			varchar(128),
@cmpo_rlcn_prmtro 		varchar(128),
@cnsctvo			Numeric(4),
@IcInstruccion			Nvarchar(4000),
@IcInstruccion1		Nvarchar(4000),
@IcInstruccion2		Nvarchar(4000),
@lcAlias			char(2),
@lnContador			Int,
@ldFechaSistema		Datetime,
@Fecha_Corte			Datetime,
@Fecha_Caracter		varchar(15),
@Fecha_minima		datetime,
@Fecha_maxima		datetime,
@fcha_crcn_ini			Datetime,
@fcha_crcn_fn			Datetime,
@cnsctvo_cdgo_sde		int,
@cnsctvo_cdgo_tpo_nta	int,
@cnsctvo_cdgo_pln		int,
@nmro_nta_ini			varchar(15),
@nmro_nta_fn			Varchar(15)	
	

Set Nocount On

Set	@fcha_crcn_ini			= NULL
Set	@fcha_crcn_fn			=NULL
Set	@cnsctvo_cdgo_sde		=NULL
Set	@cnsctvo_cdgo_tpo_nta	=NULL
Set	@cnsctvo_cdgo_pln		=NULL
Set	@nmro_nta_ini			=NULL
Set	@nmro_nta_fn			=NULL

Select	@ldFechaSistema	=	Getdate()


Select 	@fcha_crcn_ini 	 =	vlr	+' 00:00:00' 
From 	#tbCriteriosTmp
Where 	cmpo_rlcn 	 = 	'fcha_crcn' 
And	oprdr	   	 = 	'>='


Select	@fcha_crcn_fn 	=	vlr	+' 23:59:59' 
From 	#tbCriteriosTmp
Where 	cmpo_rlcn 		= 	'fcha_crcn' 
And	oprdr	    		= 	'<='

Select 	@nmro_nta_ini 	 =	vlr	
From 	#tbCriteriosTmp
Where 	cdgo_cmpo 	 = 	'nmro_nta' 
And	oprdr	   	 = 	'>='

Select	@nmro_nta_fn 	=	vlr	
From 	#tbCriteriosTmp
Where 	cdgo_cmpo 		= 	'nmro_nta' 
And	oprdr	    		= 	'<='


Select 	@cnsctvo_cdgo_sde =	vlr
From 	#tbCriteriosTmp
Where 	cmpo_rlcn = 'cnsctvo_cdgo_sde' 

Select 	@cnsctvo_cdgo_tpo_nta =	vlr
From 	#tbCriteriosTmp
Where 	cmpo_rlcn = 'cnsctvo_cdgo_tpo_nta' 



Select 	@cnsctvo_cdgo_pln 	=	vlr
From 	#tbCriteriosTmp
Where 	cmpo_rlcn 		= 'cnsctvo_cdgo_pln' 
						   			


--Se cruzan los contratos asociados a las sucursales y se traer las sucursales finales para liquidar



 
-- Contador de condiciones
Select @lnContador = 1

-- se crea la tabla temporal con la infromacion de las sucursales que s epuedan liquidar
				
						
-- primero se hace para estados de cuenta
select  a.nmro_nta,
	c.vlr , c.vlr_iva , (c.vlr + c.vlr_iva) total,
	a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte,
	a.usro_crcn, 
	a.fcha_crcn_nta,
	nmbre_scrsl,
	s.cnsctvo_cdgo_sde,
	s.dscrpcn_sde,
	a.cnsctvo_cdgo_tpo_nta,
	space(3) TIempresa,
	space(15) NIempresa,
	0	cnsctvo_cdgo_tpo_idntfccn_empresa,
	space(3) TICotizante,
	space(15) NIcotizante,
	0	cnsctvo_cdgo_tpo_idntfccn_cotizante,
	ct.nmro_unco_idntfccn_afldo,
	p.dscrpcn_pln,
	p.cnsctvo_cdgo_pln,
	space(50) prmr_aplldo,
	space(50) sgndo_aplldo,
	space(50) prmr_nmbre,	
	space(50) sgndo_nmbre,
	d.dscrpcn_tpo_nta,
	c.nmro_cntrto,
	c.cnsctvo_nta_cntrto,
	0	Cnsctvo_nta_cncpto,
	0	cnsctvo_cdgo_cncpto_lqdcn,
	space(200)	dscrpcn_cncpto_lqdcn
into	#tmpNotasPac
from	tbnotasPac 				a,	
	bdafiliacion..tbSedes 			s ,
	bdAfiliacion..tbSucursalesAportante 	b  ,
	tbnotasContrato  			c,
	tbtiposNotas	 			d ,
	bdAfiliacion..tbcontratos		ct,
	tbEstadosxtiponota			en,
	bdplanbeneficios..tbplanes		p 
	 
where	 1	=	2


Insert	into	#tmpNotasPac
SELECT  a.nmro_nta,
	  c.vlr , c.vlr_iva , (c.vlr + c.vlr_iva) total,
	  a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte,
	  a.usro_crcn, 
	  a.fcha_crcn_nta,
	  nmbre_scrsl,
	  s.cnsctvo_cdgo_sde,
	  s.dscrpcn_sde,
	  a.cnsctvo_cdgo_tpo_nta,
	  space(3) TIempresa,
	  space(15) NIempresa,
	  0	cnsctvo_cdgo_tpo_idntfccn_empresa,
	  space(3) TICotizante,
	  space(15) NIcotizante,
	  0	cnsctvo_cdgo_tpo_idntfccn_cotizante,
	  ct.nmro_unco_idntfccn_afldo,
	  p.dscrpcn_pln,
	  p.cnsctvo_cdgo_pln,
	  space(50) prmr_aplldo,
	  space(50) sgndo_aplldo,
	  space(50) prmr_nmbre,	
	  space(50) sgndo_nmbre,
	  d.dscrpcn_tpo_nta ,
	  c.nmro_cntrto ,
	  c.cnsctvo_nta_cntrto,	 0 , 0 , space(200) 
FROM     tbnotasPac 				a,	
	  bdafiliacion..tbSedes 			s ,
	  bdAfiliacion..tbSucursalesAportante 	b  ,
	  tbnotasContrato  			c,
	  tbtiposNotas	 			d ,
	  bdAfiliacion..tbcontratos		ct,
	  tbEstadosxtiponota			en,
	  bdplanbeneficios..tbplanes		p 
Where 	  a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr		 
And	  a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte  
And	  a.cnsctvo_scrsl		=	b.cnsctvo_scrsl     
And	  b.sde_crtra_pc			=	s.cnsctvo_cdgo_sde  
And	  a.nmro_nta			=	c.nmro_nta  
And	  a.cnsctvo_cdgo_tpo_nta	=	c.cnsctvo_cdgo_tpo_nta  
And	  c.cnsctvo_cdgo_tpo_cntrto	=	ct.cnsctvo_cdgo_tpo_cntrto  
And	  c.nmro_cntrto			=	ct.nmro_cntrto 
And	  a.cnsctvo_cdgo_tpo_nta	=	d.cnsctvo_cdgo_tpo_nta  
And	  p.cnsctvo_cdgo_pln		=	ct.cnsctvo_cdgo_pln  
And	  a.cnsctvo_cdgo_tpo_nta	=	en.cnsctvo_cdgo_tpo_nta  
And	  a.cnsctvo_cdgo_estdo_nta	=	en.cnsctvo_cdgo_estdo_nta 
And	  en.cnsctvo_cdgo_estdo_nta	!=	6  
And	  en.cnsctvo_cdgo_estdo_nta	!=	5  
And    	(@fcha_crcn_ini is null or (@fcha_crcn_ini is not null and a.fcha_crcn_nta  between @fcha_crcn_ini and @fcha_crcn_fn))
And	(@cnsctvo_cdgo_sde is null or (@cnsctvo_cdgo_sde is not null and s.cnsctvo_cdgo_sde = @cnsctvo_cdgo_sde))
And	(@cnsctvo_cdgo_tpo_nta is null or ( @cnsctvo_cdgo_tpo_nta is not null and d.cnsctvo_cdgo_tpo_nta = @cnsctvo_cdgo_tpo_nta))
And	(@cnsctvo_cdgo_pln is null or (@cnsctvo_cdgo_pln is not null and p.cnsctvo_cdgo_pln = @cnsctvo_cdgo_pln))
And    	(@nmro_nta_ini is null or (@nmro_nta_ini is not null and convert(int,a.nmro_nta)  between convert(int,@nmro_nta_ini) and convert(int,@nmro_nta_fn)))

 				 

update #tmpNotasPac
Set	cnsctvo_nta_cncpto	=	b.cnsctvo_nta_cncpto
From	#tmpNotasPac a,  tbNotasContratoxConcepto b
Where	a.cnsctvo_nta_cntrto	=	b.cnsctvo_nta_cntrto

update #tmpNotasPac
Set	cnsctvo_cdgo_cncpto_lqdcn	=	b.cnsctvo_cdgo_cncpto_lqdcn
From	#tmpNotasPac a,  	tbNotasConceptos b
Where	a.Cnsctvo_nta_cncpto	=	b.Cnsctvo_nta_cncpto


update  #tmpNotasPac
Set	dscrpcn_cncpto_lqdcn	= b.dscrpcn_cncpto_lqdcn
From	#tmpNotasPac a,  tbconceptosliquidacion b
Where	a.cnsctvo_cdgo_cncpto_lqdcn	=	b.cnsctvo_cdgo_cncpto_lqdcn

Select	@Fecha_minima		=min(fcha_crcn_nta)
From	#tmpNotasPac

Select	@Fecha_maxima	=max(fcha_crcn_nta)
From	#tmpNotasPac


Update #tmpNotasPac
Set	NIempresa				=	convert(varchar(11),b.nmro_idntfccn),
	cnsctvo_cdgo_tpo_idntfccn_empresa	=	b.cnsctvo_cdgo_tpo_idntfccn
From	#tmpNotasPac a,		 bdAfiliacion..tbvinculados b
Where 	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn


Update #tmpNotasPac
Set	NIcotizante				=	convert(varchar(11),b.nmro_idntfccn),
	cnsctvo_cdgo_tpo_idntfccn_cotizante	=	b.cnsctvo_cdgo_tpo_idntfccn
From	#tmpNotasPac a,		 bdAfiliacion..tbvinculados b
Where 	a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn


update  #tmpNotasPac
Set	TIempresa	=	b.cdgo_tpo_idntfccn
From	#tmpNotasPac a , bdafiliacion..tbtiposidentificacion b
Where   a.cnsctvo_cdgo_tpo_idntfccn_empresa	=	b.cnsctvo_cdgo_tpo_idntfccn


update  #tmpNotasPac
Set	TICotizante	=	b.cdgo_tpo_idntfccn
From	#tmpNotasPac a , bdafiliacion..tbtiposidentificacion b
Where   a.cnsctvo_cdgo_tpo_idntfccn_cotizante	=	b.cnsctvo_cdgo_tpo_idntfccn



Update  #tmpNotasPac
Set	prmr_nmbre		=	  ltrim(rtrim(b.prmr_nmbre))  
From	#tmpNotasPac a , bdAfiliacion..tbpersonas b
Where   a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn

Update  #tmpNotasPac
Set	sgndo_nmbre		=	  ltrim(rtrim(b.sgndo_nmbre))  
From	#tmpNotasPac a , bdAfiliacion..tbpersonas b
Where   a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn

Update  #tmpNotasPac
Set	prmr_aplldo		=	  ltrim(rtrim(b.prmr_aplldo))  
From	#tmpNotasPac a , bdAfiliacion..tbpersonas b
Where   a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn

Update  #tmpNotasPac
Set	sgndo_aplldo		=	  ltrim(rtrim(b.sgndo_aplldo))  
From	#tmpNotasPac a , bdAfiliacion..tbpersonas b
Where   a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn


Select	a.*  , @Fecha_minima 	fecha_minima	,@Fecha_maxima  Fecha_Maxima
From #tmpNotasPac a
Order by 	cnsctvo_cdgo_sde,	cnsctvo_cdgo_pln,	fcha_crcn_nta,	cnsctvo_cdgo_tpo_nta,
		nmro_nta




