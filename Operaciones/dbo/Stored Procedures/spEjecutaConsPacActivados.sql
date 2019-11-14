
------------------



/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spEjecutaConsPacActivados
* Desarrollado por		: <\A Ing. Fernando Valencia E								A\>
* Descripcion			: <\D Este procedimiento para generar archivo con  registros activados Pac			 	D\>
* Observaciones		: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2006/06/06											FC\>
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

CREATE PROCEDURE spEjecutaConsPacActivados

As



Declare @fcha_crcn_ini 	datetime,
	@fcha_crcn_fn		datetime
	
set nocount on
 
Select 	@fcha_crcn_ini 	 =	vlr	+' 00:00:00' 
From 	#tbCriteriosTmp
Where 	cmpo_rlcn 	 = 	'fcha_crcn' 
And	oprdr	   	 = 	'>='


Select	@fcha_crcn_fn 	=	vlr	+' 23:59:59' 
From 	#tbCriteriosTmp
Where 	cmpo_rlcn 		= 	'fcha_crcn' 
And	oprdr	    		= 	'<='


select 	a.cnsctvo_cdgo_tpo_cntrto,
 	a.nmro_cntrto, 
	a.nmro_unco_idntfccn_bnfcro, 
	a.cnsctvo_bnfcro, 
	a.nmro_unco_idntfccn_empldr,
	a.cnsctvo_scrsl, 
	space(15)        afiliado,
	a.cnsctvo_cdgo_clse_aprtnte, 
	convert(char(10),a.fcha_crcn,111) as fcha_actvcn,
	space(50)  	prmr_aplldo,
	space(50) 	sgndo_aplldo,
	space(50) 	prmr_nmbre,	
	space(50) 	sgndo_nmbre,
	space(3) 	TIempresa,
	space(15) 	NIempresa,
	space(100) 	nmbre_emprsa,
	0		cnsctvo_cdgo_tpo_idntfccn_empresa,
	space(3) 	TI_Afiliado,
	space(15) 	NI_Afiliado,
	0		cnsctvo_cdgo_tpo_idntfccn_cotizante, 
	0		cnsctvo_cdgo_cdd_rsdnca,
	0		cnsctvo_sde_inflnca,
	0		cnsctvo_cdgo_pln,
	space(2)	cdgo_pln,
	space(20)	dscrpcn_pln,--
	space(3)	cdgo_sde,
	space(25)	dscrpcn_sde
into     #tmpactivados
from 	tbLogActivacionMoraPac a
where 	1=2

--drop table #tmpactivados
insert into #tmpactivados
	(cnsctvo_cdgo_tpo_cntrto,
 	nmro_cntrto, 
	nmro_unco_idntfccn_bnfcro, 
	cnsctvo_bnfcro, 
	nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl, 
	cnsctvo_cdgo_clse_aprtnte, 
	fcha_actvcn,
	cnsctvo_cdgo_tpo_idntfccn_empresa,
	cnsctvo_cdgo_tpo_idntfccn_cotizante,
	cnsctvo_cdgo_cdd_rsdnca,
	cnsctvo_sde_inflnca,
	cnsctvo_cdgo_pln)
select cnsctvo_cdgo_tpo_cntrto,
 	nmro_cntrto, 
	nmro_unco_idntfccn_bnfcro, 
	cnsctvo_bnfcro, 
	nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl, 
	cnsctvo_cdgo_clse_aprtnte, 
	convert(char(10),fcha_crcn,111),
	0,
	0,
	0,
	0,	
	0 
from 	tbLogActivacionMoraPac
where  	(@fcha_crcn_ini is not null and fcha_crcn  between @fcha_crcn_ini and @fcha_crcn_fn)
and 	estdo='A'



select b.nmro_cntrto, a.cnsctvo_cdgo_tpo_cntrto, b.nmro_unco_idntfccn_afldo, a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte,  space(1) ctznte
into #tmpCotizantes
from #tmpactivados a 		inner join  bdAfiliacion.dbo.tbcontratos b
On  a.cnsctvo_cdgo_tpo_cntrto		=b.cnsctvo_cdgo_tpo_cntrto
and a.nmro_cntrto			=b.nmro_cntrto
group by  b.nmro_cntrto, a.cnsctvo_cdgo_tpo_cntrto, b.nmro_unco_idntfccn_afldo, a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte
order by 1,2

--se marcan todos como no encontrados
update #tmpCotizantes
set ctznte='N'

--se marcan los que si  estan con cotizante
update a
set ctznte='S'
from #tmpCotizantes a inner join #tmpactivados b
On 	a.cnsctvo_cdgo_tpo_cntrto 	=  	b.cnsctvo_cdgo_tpo_cntrto
and 	a.nmro_cntrto			=	b.nmro_cntrto
and 	a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn_bnfcro	
and 	b.cnsctvo_bnfcro		=	1


--se insertan los registos de los cotizantes que faltan
insert into #tmpactivados
	(cnsctvo_cdgo_tpo_cntrto,
 	nmro_cntrto, 
	nmro_unco_idntfccn_bnfcro, 
	cnsctvo_bnfcro, 
	nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl, 
	cnsctvo_cdgo_clse_aprtnte, 
	fcha_actvcn,
	cnsctvo_cdgo_tpo_idntfccn_empresa,
	cnsctvo_cdgo_tpo_idntfccn_cotizante,
	cnsctvo_cdgo_cdd_rsdnca,
	cnsctvo_sde_inflnca,
	cnsctvo_cdgo_pln)
select  cnsctvo_cdgo_tpo_cntrto,
 	nmro_cntrto, 
	nmro_unco_idntfccn_afldo, 
	1, 
	nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl, 
	cnsctvo_cdgo_clse_aprtnte,
	 convert(char(10),getdate(),111),
	0,
	0,
	0,
	0,	
	0 
from    #tmpCotizantes  b
where  ctznte  ='N'

Update a 
Set	NIempresa				=	convert(varchar(11),b.nmro_idntfccn),
	cnsctvo_cdgo_tpo_idntfccn_empresa	=	b.cnsctvo_cdgo_tpo_idntfccn
From	#tmpactivados a, bdAfiliacion.dbo.tbvinculados b
Where 	a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn


Update a
Set	NI_Afiliado				=	convert(varchar(11),b.nmro_idntfccn),
	cnsctvo_cdgo_tpo_idntfccn_cotizante	=	b.cnsctvo_cdgo_tpo_idntfccn
From	#tmpactivados a,  bdAfiliacion.dbo.tbvinculados b
Where 	a.nmro_unco_idntfccn_bnfcro		=	b.nmro_unco_idntfccn


update  a
Set	TIempresa	=	b.cdgo_tpo_idntfccn
From	#tmpactivados a , bdafiliacion..tbtiposidentificacion b
Where   a.cnsctvo_cdgo_tpo_idntfccn_empresa	=	b.cnsctvo_cdgo_tpo_idntfccn


update  a
Set	TI_Afiliado	=	b.cdgo_tpo_idntfccn
From	#tmpactivados a , bdafiliacion..tbtiposidentificacion b
Where   a.cnsctvo_cdgo_tpo_idntfccn_cotizante	=	b.cnsctvo_cdgo_tpo_idntfccn


Update  a
Set	prmr_nmbre			=	  ltrim(rtrim(b.prmr_nmbre))  
From	#tmpactivados a , bdAfiliacion.dbo.tbpersonas b
Where   a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn

Update  a
Set	sgndo_nmbre		=	  ltrim(rtrim(b.sgndo_nmbre))  
From	#tmpactivados a , bdAfiliacion..tbpersonas b
Where   a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn

Update  a
Set	prmr_aplldo		=	  ltrim(rtrim(b.prmr_aplldo))  
From	#tmpactivados a , bdAfiliacion..tbpersonas b
Where   a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn

Update  a
Set	sgndo_aplldo		=	  ltrim(rtrim(b.sgndo_aplldo))  
From	#tmpactivados a , bdAfiliacion..tbpersonas b
Where   a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn


Update  a
Set	nmbre_emprsa			=	  ltrim(rtrim(b.nmbre_scrsl))  
From	#tmpactivados a , bdAfiliacion.dbo.tbSucursalesAportante b
Where   a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
and 	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl

Update  a
Set	cnsctvo_cdgo_pln			=	  b.cnsctvo_cdgo_pln
From	#tmpactivados a , bdAfiliacion.dbo.tbContratos b
Where   a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
and 	a.nmro_cntrto			=	b.nmro_cntrto

Update  a
Set	cdgo_pln	=  	b.cdgo_pln,
	dscrpcn_pln	=	ltrim(rtrim(b.dscrpcn_pln))			
From	#tmpactivados a, bdPlanBeneficios.dbo.tbPlanes b
Where   a.cnsctvo_cdgo_pln	=	b.cnsctvo_cdgo_pln


Update	a
Set	cnsctvo_cdgo_cdd_rsdnca		= b.cnsctvo_cdgo_cdd_rsdnca
From	#tmpactivados a, 	bdafiliacion.dbo.tbpersonas b
Where	a.nmro_unco_idntfccn_bnfcro	= b.nmro_unco_idntfccn


Update	a
Set	cnsctvo_sde_inflnca		= b.cnsctvo_sde_inflnca
From	#tmpactivados a, bdafiliacion.dbo.tbciudades_vigencias b
Where	a.cnsctvo_cdgo_cdd_rsdnca	= b.cnsctvo_cdgo_cdd

Update	a
Set	dscrpcn_sde	= ltrim(rtrim(s.dscrpcn_sde)),
	cdgo_sde	= s.cdgo_sde
From	#tmpactivados a,     bdafiliacion.dbo.tbSedes s
Where	a.cnsctvo_sde_inflnca		= s.cnsctvo_cdgo_sde



update #tmpactivados
set afiliado='COTIZANTE'
where cnsctvo_bnfcro=1

update #tmpactivados
set afiliado='BENEFICIARIO'
where cnsctvo_bnfcro<>1


select  	TI_Afiliado,
 	NI_Afiliado, 
	nmro_cntrto, 
	cdgo_pln, 
	dscrpcn_pln, 
	prmr_aplldo, 
	sgndo_aplldo,
	prmr_nmbre,
	sgndo_nmbre,
	cnsctvo_bnfcro,
	afiliado,
	TIempresa,
	NIempresa,
	nmbre_emprsa,
	cnsctvo_cdgo_clse_aprtnte,
	cdgo_sde,
	dscrpcn_sde,
	fcha_actvcn	
from #tmpactivados
order by 3,10
