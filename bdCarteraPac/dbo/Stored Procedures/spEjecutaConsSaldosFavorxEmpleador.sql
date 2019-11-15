


/*---------------------------------------------------------------------------------
* Metodo o PRG		:  spEjecutaConsSaldosFavorxcontrato
* Desarrollado por	: <\A Ing. Fernando Valencia E 				A\>
* Descripcion		: <\D Este procedimiento  permite listar saldos a favor por contrato de un periodo		D\>
* Observaciones		: <\O  								O\>
* Parametros		: <\P								P\>
* Variables		: <\V  								V\>
* Fecha Creacion	: <\FC 2008/01/10						FC\>
**---------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[spEjecutaConsSaldosFavorxEmpleador]

as 
declare @cnsctvo_prdo int,
		@prdo_lqdcn				int,
		@fcha_rcdo_ms_antrr		char(10) 

Set Nocount On

Select	 @cnsctvo_prdo	=  vlr
From	 #tbCriteriosTmp
Where    cdgo_cmpo	=  'cnsctvo_cdgo_prdo_lqdcn'

select
--a.cnsctvo_cdgo_lqdcn, 
nmro_estdo_cnta,
space(15)	  Numero_id_Empleador ,
Space(3)	  Tipo_id_empleador, 
space(100)	nombre_empleador,
a.nmro_unco_idntfccn_empldr,
a.cnsctvo_cdgo_clse_aprtnte,
a.cnsctvo_scrsl,
sum(convert(bigint,e.sldo)*-1)sldo_fvr,
--sum(convert(bigint,e.sldo)*-1)+ sum(convert(bigint,e.sldo_fvr)) sldo_fvr,
space(20) fcha_aplccn ,  
space(20) fcha_rcdo,
e.cnsctvo_estdo_cnta_cntrto,
0 nmro_pgo,
0 vlr_pgo
into #tmpSaldoaFavorContratos
from tbestadoscuenta a inner join tbliquidaciones c 
on 	a.cnsctvo_cdgo_lqdcn = c.cnsctvo_cdgo_lqdcn
inner 	join tbperiodosliquidacion d 
on 	d.cnsctvo_cdgo_prdo_lqdcn=c.cnsctvo_cdgo_prdo_lqdcn
inner join tbestadoscuentaContratos e
on a.cnsctvo_estdo_cnta=e.cnsctvo_estdo_cnta
and	e.sldo_fvr 				> 0 
and a.sldo_estdo_cnta < 0
where 	d.cnsctvo_cdgo_prdo_lqdcn = @cnsctvo_prdo
group by nmro_estdo_cnta, a.nmro_unco_idntfccn_empldr,a.cnsctvo_cdgo_clse_aprtnte, a.cnsctvo_scrsl,cnsctvo_estdo_cnta_cntrto
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

set @fcha_rcdo_ms_antrr=(SELECT  convert(char(10),dbo.fnCalculaFechaFinalPeriodo (@prdo_lqdcn),111))



select	nmro_estdo_cnta,
		Numero_id_Empleador, 
		tipo_id_empleador, 
		nombre_empleador, 
		sldo_fvr,
		fcha_aplccn ,  
		fcha_rcdo,
		nmro_pgo,
		vlr_pgo
	    from #tmpSaldoaFavorContratos
		where fcha_rcdo < = @fcha_rcdo_ms_antrr
		and sldo_fvr > 0
	





