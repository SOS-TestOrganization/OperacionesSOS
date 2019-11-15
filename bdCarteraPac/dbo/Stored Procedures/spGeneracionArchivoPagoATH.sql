

/*---------------------------------------------------------------------------------
* Metodo o PRG		: spGeneracionArchivoPagoATH
* Desarrollado por  : <\A Ing. Maria Janeth Barrera									A\>
* Descripcion		: <\D Este procedimiento genera la información de los estados 
						 de cuenta que son enviados para pago por cajeros ATH		D\>
* Observaciones		: <\O                O\>
* Parametros		: <\P  @lnPeriodo    P\>
* Variables			: <\V                V\>
* Fecha Creacion	: <\FC 2008/06/19   FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
SAU Analista Descripcion
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[spGeneracionArchivoPagoATH]

As
Declare 
@ltFechaLiquidacion datetime,
@lnPeriodoEvaluar	int 

Set nocount on


Set	@lnPeriodoEvaluar	= 0

Select	@lnPeriodoEvaluar	= Convert(Int,vlr)
From	#tbCriteriosTmp
Where 	cdgo_cmpo		= 'fcha_incl_prdo_lqdcn'

select @ltFechaLiquidacion = bdRecaudos.dbo.fnConviertePeriodoFecha(@lnPeriodoEvaluar,1)

-- drop table #tmpLiquidaciones
-- drop table #tmpEstadosCuenta

create table #tmpLiquidaciones
(cnsctvo_cdgo_lqdcn  int,
fcha_pgo datetime)

create table #tmpEstadosCuenta
(nmro_estdo_cnta	varchar(15),
ttl_pgr				int,
nombre				varchar(22),
nmro_idntfccn		char(30),
nmro_unco_idntfccn_empldr	int,
prdo_evlr			int,
fcha_pgo            datetime)


insert into #tmpLiquidaciones
select l.cnsctvo_cdgo_lqdcn, fcha_pgo
from dbo.tbLiquidaciones l inner join tbPeriodosliquidacion p
on l.cnsctvo_cdgo_prdo_lqdcn = p.cnsctvo_cdgo_prdo_lqdcn
inner join tbPeriodosliquidacion_vigencias pv
on pv.cnsctvo_cdgo_prdo_lqdcn = p.cnsctvo_cdgo_prdo_lqdcn
where pv.fcha_incl_prdo_lqdcn = @ltFechaLiquidacion
and l.cnsctvo_cdgo_estdo_lqdcn = 3


insert into #tmpEstadosCuenta
select e.nmro_estdo_cnta, e.ttl_pgr, space(22) as nombre, space(30) as nmro_idntfccn, nmro_unco_idntfccn_empldr, @lnPeriodoEvaluar,fcha_pgo
from #tmpLiquidaciones l inner join dbo.tbEstadosCuenta e
on l.cnsctvo_cdgo_lqdcn = e.cnsctvo_cdgo_lqdcn
where cnsctvo_cdgo_estdo_estdo_cnta in (1,2)

update #tmpEstadosCuenta set nmro_idntfccn = v.nmro_idntfccn
from #tmpEstadosCuenta e inner join bdAfiliacion.dbo.tbVinculados v
on e.nmro_unco_idntfccn_empldr = v.nmro_unco_idntfccn

update #tmpEstadosCuenta set nombre = substring(rtrim(ltrim(prmr_nmbre))+' '+ rtrim(ltrim(prmr_aplldo)),1,22)
from #tmpEstadosCuenta e inner join bdAfiliacion.dbo.tbPersonas p
on e.nmro_unco_idntfccn_empldr = p.nmro_unco_idntfccn

update #tmpEstadosCuenta set nombre = substring(rtrim(ltrim(rzn_scl)),1,22)
from #tmpEstadosCuenta e inner join bdAfiliacion.dbo.tbEmpresas p
on e.nmro_unco_idntfccn_empldr = p.nmro_unco_idntfccn
where e.nombre = ''

select * from #tmpEstadosCuenta




