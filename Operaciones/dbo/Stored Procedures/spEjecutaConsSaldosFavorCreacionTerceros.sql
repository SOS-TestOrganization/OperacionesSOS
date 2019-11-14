



/*---------------------------------------------------------------------------------
* Metodo o PRG		:  spEjecutaConsSaldosFavorCreacionTerceros
* Desarrollado por	: <\A Ing. Diana Lorena Gomez Betancourt			A\>
* Descripcion		: <\D Este procedimiento  permite listar saldos a favor para creacion de terceros solicitado por contabilidad		D\>
* Observaciones		: <\O  								O\>
* Parametros		: <\P								P\>
* Variables		: <\V  								V\>
* Fecha Creacion	: <\FC 2010/04/15						FC\>
**---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[spEjecutaConsSaldosFavorCreacionTerceros]

as 
declare @cnsctvo_prdo			int, 
		@prdo_lqdcn				int,
		@fcha_rcdo_ms_antrr		char(10)




Set Nocount On

Select	 @cnsctvo_prdo	=  vlr
From	 #tbCriteriosTmp
Where    cdgo_cmpo	=  'cnsctvo_cdgo_prdo_lqdcn'

select
--a.cnsctvo_cdgo_lqdcn, 
nmro_estdo_cnta,
space(15)	NI,
Space(3)	TI, 
space(100)	nombre_afiliado,
space(100)	prmr_aplldo,
space(100)	sgndo_aplldo,
space(100)	prmr_nmbre,
space(100)	sgndo_nmbre,
0			nmro_unco_idntfccn_afldo,
nmro_cntrto,
cnsctvo_cdgo_tpo_cntrto,
space(15)	Numero_id_Empleador ,
Space(3)	Tipo_id_empleador, 
space(100)	nombre_empleador,
a.nmro_unco_idntfccn_empldr,
a.cnsctvo_cdgo_clse_aprtnte,
a.cnsctvo_scrsl,
--convert(bigint,e.sldo_fvr) sldo_fvr,
(e.sldo *-1)  sldo_fvr,  --+convert(bigint,e.sldo_fvr)  sldo_fvr,
space(20) fcha_aplccn ,  
space(20) fcha_rcdo,
e.cnsctvo_estdo_cnta_cntrto,
0 nmro_pgo,
0 vlr_pgo,
space(150) as drccn,
space(150) as cdd_rsdnca,
space(150) as tlfno,
space(5) as cdgo_cdd
into #tmpSaldoaFavorContratos
from tbestadoscuenta a inner join tbliquidaciones c 
on 	a.cnsctvo_cdgo_lqdcn = c.cnsctvo_cdgo_lqdcn
inner 	join tbperiodosliquidacion d 
on 	d.cnsctvo_cdgo_prdo_lqdcn=c.cnsctvo_cdgo_prdo_lqdcn
inner join tbestadoscuentaContratos e
on a.cnsctvo_estdo_cnta=e.cnsctvo_estdo_cnta
and	e.sldo_fvr > 0 
and a.sldo_estdo_cnta < 0
where 	d.cnsctvo_cdgo_prdo_lqdcn =  @cnsctvo_prdo
order by 1
	

-----------------------------------------------------------------

Select	bdrecaudos.dbo.fnCalculaPeriodo (a.fcha_incl_prdo_lqdcn) 	fcha_incl_prdo_lqdcn, 	 b.cnsctvo_cdgo_prdo_lqdcn
Into	#tmpLiquidacion
From	bdCarteraPac.dbo.tbPeriodosliquidacion_Vigencias a, bdCarteraPac.dbo.tbLiquidaciones b
Where   a.cnsctvo_cdgo_prdo_lqdcn	=	b.cnsctvo_cdgo_prdo_lqdcn
And	b.cnsctvo_cdgo_estdo_lqdcn	=	3
and b.cnsctvo_cdgo_prdo_lqdcn = @cnsctvo_prdo
group by a.fcha_incl_prdo_lqdcn, b.cnsctvo_cdgo_prdo_lqdcn


set @prdo_lqdcn=(select fcha_incl_prdo_lqdcn from #tmpLiquidacion)

select max(c.cnsctvo_cdgo_pgo) cnsctvo_cdgo_pgo , b.cnsctvo_estdo_cnta_cntrto
into #tbPagos
from bdCarteraPac.dbo.tbAbonosContrato a inner join #tmpSaldoaFavorContratos b 
on a.cnsctvo_estdo_cnta_cntrto	= b.cnsctvo_estdo_cnta_cntrto
inner join  bdCarteraPac.dbo.tbPagos c 
on c.cnsctvo_cdgo_pgo			= a.cnsctvo_cdgo_pgo
group by b.cnsctvo_estdo_cnta_cntrto

--se actualiza el numero del pago 
update a  
set nmro_pgo=cnsctvo_cdgo_pgo 
from #tmpSaldoaFavorContratos a inner join #tbPagos b 
on a.cnsctvo_estdo_cnta_cntrto  = b.cnsctvo_estdo_cnta_cntrto

--se actualiza la fecha del  pago
update a
set fcha_aplccn = convert(char(20),b.fcha_aplccn,120),
	fcha_rcdo   = convert(char(20),b.fcha_rcdo,120),
	vlr_pgo = vlr_dcmnto
from #tmpSaldoaFavorContratos a inner join  bdCarteraPac.dbo.tbPagos  b 
on b.cnsctvo_cdgo_pgo=a.nmro_pgo

----------------------------------------------------------

update a 
set nmro_unco_idntfccn_afldo= b.nmro_unco_idntfccn_afldo
from #tmpSaldoaFavorContratos a inner join bdAfiliacion.dbo.tbContratos b 
on a.nmro_cntrto=b.nmro_cntrto
and a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto

Update 	a
Set	NI 	=	v.nmro_idntfccn,
	TI 	=	f.cdgo_tpo_idntfccn
From	#tmpSaldoaFavorContratos  a, bdAfiliacion.dbo.tbVinculados v, 
	bdAfiliacion.dbo.tbTiposIdentificacion f
Where   a.nmro_unco_idntfccn_afldo 	= 	v.nmro_unco_idntfccn	 
AND	   v.cnsctvo_cdgo_tpo_idntfccn 	=	f.cnsctvo_cdgo_tpo_idntfccn

Update  a 
Set nombre_afiliado  =   ltrim(rtrim(b.prmr_nmbre))  + ' ' + ltrim(rtrim(b.sgndo_nmbre)) + ' ' + ltrim(rtrim(b.prmr_aplldo)) + ' '+ ltrim(rtrim(b.sgndo_aplldo)),
prmr_aplldo = ltrim(rtrim(b.prmr_aplldo)),
sgndo_aplldo =ltrim(rtrim(b.sgndo_aplldo))  ,
prmr_nmbre =  ltrim(rtrim(b.prmr_nmbre)) ,
sgndo_nmbre= ltrim(rtrim(b.sgndo_nmbre)) ,
drccn = ltrim(rtrim(b.drccn_rsdnca)),
cdd_rsdnca = ltrim(rtrim(c.dscrpcn_cdd)),
cdgo_cdd = substring(c.cdgo_cdd,1,5) ,
tlfno = isnull(b.tlfno_rsdnca, ' ')
From #tmpSaldoaFavorContratos a inner join bdAfiliacion..tbpersonas b
on a.nmro_unco_idntfccn_afldo = b.nmro_unco_idntfccn
inner join bdafiliacion..tbciudades c
on b.cnsctvo_cdgo_cdd_rsdnca = c.cnsctvo_cdgo_cdd


Update  a 
Set drccn = ltrim(rtrim(b.drccn_crrspndnca))
From #tmpSaldoaFavorContratos a inner join bdAfiliacion..tbpersonas b
on a.nmro_unco_idntfccn_afldo = b.nmro_unco_idntfccn
where a.drccn = ' ' and b.drccn_crrspndnca != ' '


Update  a 
Set tlfno = ltrim(rtrim(b.tlfno_crrspndnca))
From #tmpSaldoaFavorContratos a inner join bdAfiliacion..tbpersonas b
on a.nmro_unco_idntfccn_afldo = b.nmro_unco_idntfccn
where a.tlfno = ' ' and b.tlfno_crrspndnca != ' '

Update  a 
Set tlfno = ltrim(rtrim(b.tlfno_adcnl))
From #tmpSaldoaFavorContratos a inner join bdAfiliacion..tbpersonas b
on a.nmro_unco_idntfccn_afldo = b.nmro_unco_idntfccn
where a.tlfno = ' ' and b.tlfno_adcnl is not null or b.tlfno_adcnl != '0'

Update  a 
Set tlfno = ltrim(rtrim(b.tlfno_crrspndnca))
From #tmpSaldoaFavorContratos a inner join bdAfiliacion..tbpersonas b
on a.nmro_unco_idntfccn_afldo = b.nmro_unco_idntfccn
where a.tlfno = ' ' and b.tlfno_crrspndnca != ' '


Update 	a
Set	Numero_id_Empleador 	=	v.nmro_idntfccn,
	  tipo_id_Empleador 	=	f.cdgo_tpo_idntfccn
From	#tmpSaldoaFavorContratos  a, bdAfiliacion.dbo.tbVinculados v, 
	bdAfiliacion.dbo.tbTiposIdentificacion f
Where   a.nmro_unco_idntfccn_empldr 	= 	v.nmro_unco_idntfccn	 
AND	   v.cnsctvo_cdgo_tpo_idntfccn 	=	f.cnsctvo_cdgo_tpo_idntfccn


Update  a 
Set nombre_empleador  =   ltrim(rtrim(nmbre_scrsl))
From #tmpSaldoaFavorContratos a , bdAfiliacion..tbSucursalesaportante b
Where   a.nmro_unco_idntfccn_empldr 	= 	b.nmro_unco_idntfccn_empldr
and 	a.cnsctvo_cdgo_clse_aprtnte 	= 	b.cnsctvo_cdgo_clse_aprtnte
and     a.cnsctvo_scrsl			=	b.cnsctvo_scrsl	

--Para identificar  el ultimo dia del mes a cerrar 
set @fcha_rcdo_ms_antrr=(SELECT  convert(char(10),dbo.fnCalculaFechaFinalPeriodo (@prdo_lqdcn),111))



select	TI as [Tipo_Id], 
NI as [Numero_Id], 
nombre_afiliado as [Nombre_Contratante],
tlfno as [Telefono],
cdgo_cdd as [Codigo_Ciudad],
drccn as [Direccion],
cdd_rsdnca as [Ciudad_Residencia],
prmr_aplldo as [Primer_Apellido],
sgndo_aplldo  as [Segundo_Apellido],
prmr_nmbre as [Primer_Nombre],
sgndo_nmbre as [Segundo_Nombre]
from #tmpSaldoaFavorContratos
where fcha_rcdo < = @fcha_rcdo_ms_antrr
and sldo_fvr > 0



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON







