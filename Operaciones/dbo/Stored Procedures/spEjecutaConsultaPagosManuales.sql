


/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spEjecutaConsultaPagosManuales
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento arma y ejecuta la cadena donde se tiene los criterios para seleccionar los pagos  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003/02/10											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[spEjecutaConsultaPagosManuales]

As

Declare
@tbla				varchar(128),
@cdgo_cmpo	 		varchar(128),
@oprdr 				varchar(2),
@vlr 				varchar(250),
@cmpo_rlcn 			varchar(128),
@cmpo_rlcn_prmtro 		varchar(128),
@cnsctvo			Numeric(4),
@IcInstruccion			Nvarchar(4000),
@IcInstruccion1			Nvarchar(4000),
@IcInstruccion2			Nvarchar(4000),
@ldfechaSistema		datetime,
@lcAlias			char(2),
@lnContador			Int,
@cnsctvo_cdgo_estdo_pgo	int,
@fcha_rcdo_ini			Datetime,
@fcha_rcdo_fn			Datetime,
@cnsctvo_cdgo_pgo		int,
@nmro_dcmnto			int,
@nmro_unco_idntfccn_empldr	int,
@cnsctvo_cdgo_clse_aprtnte	int,
@cnsctvo_scrsl			int,
@usro_crcn			int	


Set Nocount On

Select 	@fcha_rcdo_ini 	 =	vlr	+' 00:00:00' 
From 	#tbCriteriosTmp
Where 	cmpo_rlcn 	 = 	'fcha_rcdo' 
And	oprdr	   	 = 	'>='


Select @fcha_rcdo_fn 	=	vlr	+' 23:59:59' 
From #tbCriteriosTmp
Where 	cmpo_rlcn 		= 	'fcha_rcdo' 
And	oprdr	    		= 	'<='


Select 	@cnsctvo_cdgo_estdo_pgo =	vlr
From 	#tbCriteriosTmp
Where 	cmpo_rlcn = 'cnsctvo_cdgo_estdo_pgo' 



Select 	@cnsctvo_cdgo_pgo	 =	vlr
From 	#tbCriteriosTmp
Where 	cmpo_rlcn = 'cnsctvo_cdgo_pgo' 

Select 	@nmro_unco_idntfccn_empldr	 =	vlr
From 	#tbCriteriosTmp
Where 	cmpo_rlcn = 'nmro_unco_idntfccn_empldr' 

Select 	@cnsctvo_cdgo_clse_aprtnte	 =	vlr
From 	#tbCriteriosTmp
Where 	cmpo_rlcn = 'cnsctvo_cdgo_clse_aprtnte' 


Select 	@cnsctvo_scrsl	 =	vlr
From 	#tbCriteriosTmp
Where 	cmpo_rlcn = 'cnsctvo_scrsl' 



Select 	@nmro_dcmnto	 =	vlr
From 	#tbCriteriosTmp
Where 	cmpo_rlcn = 'nmro_dcmnto' 


Select 	@usro_crcn	 =	vlr
From 	#tbCriteriosTmp
Where 	cmpo_rlcn = 'usro_crcn' 


Set	@ldfechaSistema	=	getdate()
	-- Contador de condiciones
Select @lnContador = 1
	
SELECT         a.cnsctvo_cdgo_pgo,			 e.dscrpcn_estdo_pgo,		t.dscrpcn_tpo_pgo,
	         b.tpo_idntfccn  cdgo_tpo_idntfccn, 			b.nmro_idntfccn   nmro_idntfccn, 			space(30)   dscrpcn_clse_aprtnte,
	         b.rzn_scl	nmbre_scrsl,	 			 a.vlr_dcmnto, 			a.fcha_rcdo,
	          a.nmro_unco_idntfccn_empldr, 		 a.cnsctvo_scrsl, 		a.cnsctvo_cdgo_clse_aprtnte,
	          space(30)   dscrpcn_tpo_idntfccn, 
                      b.rzn_scl AS rzn_scl, 			0	cnsctvo_cdgo_tpo_idntfccn, 
	         a.cnsctvo_cdgo_estdo_pgo,
	         a.cnsctvo_cdgo_tpo_pgo,
	         0	dgto_vrfccn,
	         a.nmro_rmsa,
	         a.nmro_lna,
	         a.nmro_dcmnto,	
	         a.usro_crcn,
	         a.sldo_pgo,
	         a.fcha_aplccn	
	  
into	         #tmp1	 
FROM           tbpagos	 a  INNER JOIN  
                      bdadmonrecaudo.dbo.tbrecaudoconciliado  b 	ON 	a.cnsctvo_rcdo_cncldo 	= b.cnsctvo_rcdo_cncldo  INNER JOIN
                      tbestadospago e 				ON 	a.cnsctvo_cdgo_estdo_pgo 	= e.cnsctvo_cdgo_estdo_pgo  INNER JOIN
	        tbTipospago      T				ON	a.cnsctvo_cdgo_tpo_pgo		= t.cnsctvo_cdgo_tpo_pgo	
where	          	(@fcha_rcdo_ini is null or (@fcha_rcdo_ini is not null and a.fcha_rcdo between @fcha_rcdo_ini and @fcha_rcdo_fn))
And	(@cnsctvo_cdgo_pgo is null or (@cnsctvo_cdgo_pgo is not null and a.cnsctvo_cdgo_pgo = @cnsctvo_cdgo_pgo))
And	(@cnsctvo_cdgo_estdo_pgo is null or ( @cnsctvo_cdgo_estdo_pgo is not null and a.cnsctvo_cdgo_estdo_pgo = @cnsctvo_cdgo_estdo_pgo))
And	(@nmro_unco_idntfccn_empldr is null or (@nmro_unco_idntfccn_empldr is not null and a.nmro_unco_idntfccn_empldr = @nmro_unco_idntfccn_empldr))
And	(@cnsctvo_cdgo_clse_aprtnte is null or (@cnsctvo_cdgo_clse_aprtnte is not null and a.cnsctvo_cdgo_clse_aprtnte = @cnsctvo_cdgo_clse_aprtnte))
And	(@cnsctvo_scrsl is null or (@cnsctvo_scrsl is not null and a.cnsctvo_scrsl = @cnsctvo_scrsl))
And	(@nmro_dcmnto is null or (@nmro_dcmnto is not null and a.nmro_dcmnto = @nmro_dcmnto))
And	(@usro_crcn is null or (@usro_crcn is not null and a.usro_crcn = @usro_crcn))
and	b.cnsctvo_cdgo_tps_dcmnto	=	2

update #tmp1
Set	nmbre_scrsl	=	b.nmbre_scrsl
From	#tmp1 a,  bdAfiliacion.dbo.tbSucursalesAportante b
Where 	a.nmro_unco_idntfccn_empldr 	= b.nmro_unco_idntfccn_empldr 
AND a.cnsctvo_scrsl = b.cnsctvo_scrsl 
AND  a.cnsctvo_cdgo_clse_aprtnte 	= b.cnsctvo_cdgo_clse_aprtnte

update  #tmp1
Set	 cdgo_tpo_idntfccn	=	f.cdgo_tpo_idntfccn ,
	 nmro_idntfccn		=	d.nmro_idntfccn,
	 dscrpcn_clse_aprtnte	=	i.dscrpcn_clse_aprtnte,
	 cnsctvo_cdgo_tpo_idntfccn	=	f.cnsctvo_cdgo_tpo_idntfccn	
From	#tmp1 a,         bdAfiliacion.dbo.tbVinculados d 	,      bdAfiliacion.dbo.tbTiposIdentificacion f 	,  	   bdAfiliacion.dbo.tbClasesAportantes i 	
Where  	a.nmro_unco_idntfccn_empldr 	= d.nmro_unco_idntfccn 
And	d.cnsctvo_cdgo_tpo_idntfccn 	= f.cnsctvo_cdgo_tpo_idntfccn 
And	a.cnsctvo_cdgo_clse_aprtnte 	= i.cnsctvo_cdgo_clse_aprtnte



Select    a.cnsctvo_cdgo_pgo,	 	a.cdgo_tpo_idntfccn, 	a.nmro_idntfccn, 
	a.dscrpcn_clse_aprtnte,			a.nmbre_scrsl, 				vlr_dcmnto ,
	convert(char(20),replace(convert(char(20),a.fcha_rcdo,120), '-' , '/'  )) fcha_rcdo, 
	
	a.nmro_dcmnto,		a.dscrpcn_estdo_pgo,		' Pago '	Tipo_documento,	a.usro_crcn,
	a.dscrpcn_tpo_pgo , 		
	a.nmro_rmsa,	a.nmro_lna,				
	a.cnsctvo_cdgo_estdo_pgo,
	a.cnsctvo_cdgo_tpo_pgo,
             a.nmro_unco_idntfccn_empldr, 	a.cnsctvo_scrsl, 			a.cnsctvo_cdgo_clse_aprtnte, 	  	dgto_vrfccn,
	a.sldo_pgo,
	a.rzn_scl,
	a.fcha_aplccn	
into	#tmp2
From	 #tmp1 a  




Update 	#tmp2
Set	 rzn_scl	 =  c.rzn_scl
From 	#tmp2	 a	,bdafiliacion..tbempleadores b,	bdafiliacion..tbempresas c --,	tbclasesempleador d
Where	a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte 
And	a.nmro_unco_idntfccn_empldr		=	c.nmro_unco_idntfccn
--And	a.vldo				=	'S'


Update 	#tmp2
Set	 rzn_scl	 =   ltrim(rtrim(isnull(prmr_aplldo,'')))  + ' ' + ltrim(rtrim(isnull(sgndo_aplldo,''))) + ' ' + ltrim(rtrim(isnull(prmr_nmbre,''))) + ' ' + ltrim(rtrim(isnull(sgndo_nmbre,'')))
From 	#tmp2	 a	, bdafiliacion..tbempleadores b,	bdAfiliacion..tbpersonas c
Where	a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte 
And	a.nmro_unco_idntfccn_empldr		=	c.nmro_unco_idntfccn
And	rzn_scl=''


Select	*
from 	#tmp2


