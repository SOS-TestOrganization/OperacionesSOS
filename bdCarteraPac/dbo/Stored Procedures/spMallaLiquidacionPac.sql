
/*--------------------------------------------------------------------------------- 
* Metodo o PRG 			: spMallaLiquidacionPac
* Desarrollado por		: <\A Ing.Fernando Valencia Echeverry						A\> 
* Descripcion			: <\D Permite generar la extraccion con el log de los contratos que presenta una causa
                        por la cual no se pueden facturar.D\> 
* Observaciones			: <\O  											O\> 
* Parametros			: <\P  Recibe el periodo de liquidacion que posteriormente se convierte a fecha 
                         usando la funcion fnconvierteperiodofecha, con el primer dia del mes para ese 
												 periodo P\> 
*				: <\P 											P\> 
*				: <\P 							 				P\> 
* Variables			: <\V  											V\> 
* Fecha Creacion		: <\FC 2008/06/20									FC\> 
*--------------------------------------------------------------------------------- 
* DATOS DE MODIFICACION 
*--------------------------------------------------------------------------------- 
Sau	Analista		Descripción 

*---------------------------------------------------------------------------------*/
CREATE PROCEDURE dbo.spMallaLiquidacionPac    
As

Declare @lnPeriodoLiquidacion int,
@ltFechaLiquidacion datetime

set nocount on

--set @ltFechaLiquidacion = '20080701'

-- drop table #tmpLog
Create table #tmpLog
(nmro_cntrto							char(15)	, 
 cnsctvo_cdgo_tpo_cntrto				int	, 
 cnsctvo_bnfcro							int,
 exste 									int,
 csa									varchar(200))

--drop table #tmpContratosLiquidar
create table #tmpContratosLiquidar
(nmro_cntrto					char(15), 
 cnsctvo_cdgo_tpo_cntrto		int, 
 cnsctvo_bnfcro					int,
 exste							int)

-- drop table #tmpBeneficiariosLiquidar
create table #tmpBeneficiariosLiquidar
(nmro_cntrto					char(15), 
 cnsctvo_cdgo_tpo_cntrto		int, 
 cnsctvo_bnfcro					int,
 exste							int)
 
 
 

If Exists (	Select	1 
		From	#tbCriteriosTmp  
		Where 	cdgo_cmpo = 'prdo_lqdcn' ) 
Begin 
	Select	@lnPeriodoLiquidacion	= 	vlr 
	From	#tbCriteriosTmp  
	Where 	cdgo_cmpo 	= 	'prdo_lqdcn' 
	
	select @ltFechaLiquidacion = bdrecaudos.dbo.fnConviertePeriodoFecha(@lnPeriodoLiquidacion,1)
End  

/******************************************************************
	                           CONTRATOS
******************************************************************/

--drop table  #tmpContratosLiquidar
insert into #tmpContratosLiquidar
select c.nmro_cntrto, c.cnsctvo_cdgo_tpo_cntrto, 0 as cnsctvo_bnfcro,
  0 as exste
from bdAfiliacion.dbo.tbContratos c inner join bdAfiliacion.dbo.tbVigenciasContrato vc
on c.cnsctvo_cdgo_tpo_cntrto = vc.cnsctvo_cdgo_tpo_cntrto
and c.nmro_cntrto = vc.nmro_cntrto
where c.cnsctvo_cdgo_tpo_cntrto = 2
and   c.estdo_cntrto = 'A'
and @ltFechaLiquidacion between vc.inco_vgnca_estdo_cntrto and vc.fn_vgnca_estdo_cntrto
and vc.estdo_rgstro ='S'

-- 5 CONTRATO SIN CUOTA VIGENTE  

update #tmpContratosLiquidar set exste = 0
 
update #tmpContratosLiquidar set exste = 1
from #tmpContratosLiquidar cl inner join bdAfiliacion.dbo.tbCobranzas b
on cl.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto
and cl.nmro_cntrto = b.nmro_cntrto
inner join bdAfiliacion.dbo.tbVigenciasCobranzas vc
on b.cnsctvo_cdgo_tpo_cntrto = vc.cnsctvo_cdgo_tpo_cntrto
and b.nmro_cntrto = vc.nmro_cntrto
and b.cnsctvo_cbrnza = vc.cnsctvo_cbrnza
where @ltFechaLiquidacion between vc.inco_vgnca_cbrnza and vc.fn_vgnca_cbrnza
and vc.estdo_rgstro ='S'

insert into #tmpLog
select * , 'Contrato sin cuota vigente'
from  #tmpContratosLiquidar where exste = 0
  

-- 7 CONTRATOS SIN BENEFICIARIOS ACTIVOS
 
-- Valido que cada contrato tenga por lo menos un beneficiario activo

update #tmpContratosLiquidar set exste = 0

update #tmpContratosLiquidar set exste = 1
from #tmpContratosLiquidar cl inner join bdAfiliacion.dbo.tbBeneficiarios b
on cl.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto
and cl.nmro_cntrto = b.nmro_cntrto
inner join bdAfiliacion.dbo.tbVigenciasBeneficiarios vb
on b.cnsctvo_cdgo_tpo_cntrto = vb.cnsctvo_cdgo_tpo_cntrto
and b.nmro_cntrto = vb.nmro_cntrto
and b.cnsctvo_bnfcro = vb.cnsctvo_bnfcro
where @ltFechaLiquidacion between vb.inco_vgnca_estdo_bnfcro and vb.fn_vgnca_estdo_bnfcro
and vb.estdo_rgstro ='S'

 insert into #tmpLog
 select * , 'Contrato sin Beneficiarios activos'
 from  #tmpContratosLiquidar where exste = 0



/******************************************************************
	                          BENEFICIARIOS
******************************************************************/

-- drop table #tmpBeneficiariosLiquidar
insert into #tmpBeneficiariosLiquidar
select c.nmro_cntrto, c.cnsctvo_cdgo_tpo_cntrto, b.cnsctvo_bnfcro,
  0 as exste
from #tmpContratosLiquidar c inner join bdAfiliacion.dbo.tbBeneficiarios b
on c.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto
and c.nmro_cntrto = b.nmro_cntrto
inner join bdAfiliacion.dbo.tbVigenciasBeneficiarios vb
on b.cnsctvo_cdgo_tpo_cntrto = vb.cnsctvo_cdgo_tpo_cntrto
and b.nmro_cntrto = vb.nmro_cntrto
and b.cnsctvo_bnfcro = vb.cnsctvo_bnfcro
where @ltFechaLiquidacion between vb.inco_vgnca_estdo_bnfcro and vb.fn_vgnca_estdo_bnfcro
and vb.estdo_rgstro ='S'

-- 1. BENEFICIARIO SIN CUOTA


update #tmpBeneficiariosLiquidar set exste =0

update #tmpBeneficiariosLiquidar set exste =1
from #tmpBeneficiariosLiquidar b inner join bdAfiliacion.dbo.tbDetBeneficiarioAdicional da
on b.cnsctvo_cdgo_tpo_cntrto = da.cnsctvo_cdgo_tpo_cntrto
and b.nmro_cntrto = da.nmro_cntrto
and b.cnsctvo_bnfcro = da.cnsctvo_bnfcro

insert into #tmpLog
select *,'Beneficiario sin cuota'
from #tmpBeneficiariosLiquidar where exste =0


-- 2. BENEFICIARIO SIN CUOTA VIGENTE

update #tmpBeneficiariosLiquidar set exste =0

update #tmpBeneficiariosLiquidar set exste =1
from #tmpBeneficiariosLiquidar b inner join bdAfiliacion.dbo.tbDetBeneficiarioAdicional da
on b.cnsctvo_cdgo_tpo_cntrto = da.cnsctvo_cdgo_tpo_cntrto
and b.nmro_cntrto = da.nmro_cntrto
and b.cnsctvo_bnfcro = da.cnsctvo_bnfcro
where @ltFechaLiquidacion between da.inco_vgnca and da.fn_vgnca

insert into #tmpLog
select *,'Beneficiario sin cuota vigente'
from #tmpBeneficiariosLiquidar where exste =0


--  3. BENEFICIARIO DUPLICADO EN CONTRATO

update #tmpBeneficiariosLiquidar set exste =0

update #tmpBeneficiariosLiquidar set exste =(select count(*)
											from bdAfiliacion.dbo.tbBeneficiarios b with (nolock),
												bdAfiliacion.dbo.tbBeneficiarios b2 with (nolock),
												bdAfiliacion.dbo.tbVigenciasBeneficiarios vb with (nolock),
												bdAfiliacion.dbo.tbcontratos c
											where	bl.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
											and		bl.nmro_cntrto				= b.nmro_cntrto
											and		bl.cnsctvo_bnfcro			= b.cnsctvo_bnfcro
											and		b.nmro_unco_idntfccn_bnfcro = b2.nmro_unco_idntfccn_bnfcro
											and		b2.cnsctvo_cdgo_tpo_cntrto	= 2
											and		b2.cnsctvo_cdgo_tpo_cntrto	= c.cnsctvo_cdgo_tpo_cntrto
											and		b2.nmro_cntrto				= c.nmro_cntrto
											--and     c.estdo_cntrto = 'A'
											and		b2.cnsctvo_cdgo_tpo_cntrto	= vb.cnsctvo_cdgo_tpo_cntrto
											and		b2.nmro_cntrto				= vb.nmro_cntrto
											and		b2.cnsctvo_bnfcro			= vb.cnsctvo_bnfcro
											and		@ltFechaLiquidacion between vb.inco_vgnca_estdo_bnfcro and vb.fn_vgnca_estdo_bnfcro
											and		vb.estdo_rgstro ='S')
from #tmpBeneficiariosLiquidar bl


insert into #tmpLog
select *,'Beneficiario Duplicado en contrato'
from #tmpBeneficiariosLiquidar where exste > 1


--  5b. BENEFICIARIO SIN PRODUCTO ASOCIADO
/*
drop index IX_tbProductosxBeneficiario on tbProductosxBeneficiario

create index IX_tbProductosxBeneficiario on tbProductosxBeneficiario (cnsctvo_cdgo_tpo_cntrto,nmro_cntrto,cnsctvo_bnfcro)
5min
*/


update #tmpBeneficiariosLiquidar set exste =0
update #tmpBeneficiariosLiquidar set exste =(Select count(pb.cnsctvo_prdcto_bnfcro)
											from bdAfiliacion.dbo.tbProductosxBeneficiario pb
											where bl.cnsctvo_cdgo_tpo_cntrto = pb.cnsctvo_cdgo_tpo_cntrto
											and bl.nmro_cntrto = pb.nmro_cntrto
											and bl.cnsctvo_bnfcro = pb.cnsctvo_bnfcro
											and pb.estdo_rgstro = 'S')
from #tmpBeneficiariosLiquidar bl

insert into #tmpLog
select *,'Beneficiario sin producto asociado'
from #tmpBeneficiariosLiquidar 
where exste = 0

-- 6B. BENEFICIARIO ASOCIADO A UN PRODUCTO CON MODELO NO VIGENTE

-- Se asume que los que tienen exste > 0 tienen producto asociado
update #tmpBeneficiariosLiquidar set exste =(Select count(p.cnsctvo_prdcto)
											from bdAfiliacion.dbo.tbProductosxBeneficiario pb, bdAfiliacion.dbo.tbProductosCobranza pc,
											bdPlanBeneficios.dbo.tbProductos p, 
											bdPlanBeneficios.dbo.tbDetProductos dp
											where bl.cnsctvo_cdgo_tpo_cntrto = pb.cnsctvo_cdgo_tpo_cntrto
											and bl.nmro_cntrto				 = pb.nmro_cntrto
											and bl.cnsctvo_bnfcro			 = pb.cnsctvo_bnfcro
											and @ltFechaLiquidacion between pb.inco_vgnca and pb.fn_vgnca
											and pb.estdo_rgstro				 = 'S'
											and pb.cnsctvo_cdgo_tpo_cntrto	 = pc.cnsctvo_cdgo_tpo_cntrto
											and pb.nmro_cntrto				 = pc.nmro_cntrto
											and pb.cnsctvo_cbrnza			 = pc.cnsctvo_cbrnza
											and @ltFechaLiquidacion between pc.inco_vgnca and pc.fn_vgnca
											and pc.estdo_rgstro = 'S'
											and pc.cnsctvo_prdcto = p.cnsctvo_prdcto
											and p.cnsctvo_prdcto = dp.cnsctvo_prdcto
											and @ltFechaLiquidacion between dp.inco_vgnca_asccn and dp.fn_vgnca_asccn
											and dp.cnsctvo_cdgo_clse_mdlo = 6)
from #tmpBeneficiariosLiquidar bl
where exste > 0

insert into #tmpLog
select *,'Beneficiario asociado a un producto con modelo no vigente'
from #tmpBeneficiariosLiquidar 
where exste = 0


--  5a. BENEFICIARIO CON PRODUCTO NO VIGENTE



update #tmpBeneficiariosLiquidar set exste =0

update #tmpBeneficiariosLiquidar set exste =(Select count(distinct(pc.cnsctvo_prdcto))
											from bdAfiliacion.dbo.tbProductosxBeneficiario pb,
											bdAfiliacion.dbo.tbProductosCobranza pc
											where bl.cnsctvo_cdgo_tpo_cntrto = pb.cnsctvo_cdgo_tpo_cntrto
											and bl.nmro_cntrto = pb.nmro_cntrto
											and bl.cnsctvo_bnfcro = pb.cnsctvo_bnfcro
											and @ltFechaLiquidacion between pb.inco_vgnca and pb.fn_vgnca
											and pb.estdo_rgstro = 'S'
											and pb.cnsctvo_prdcto_cbrnza = pc.cnsctvo_prdcto_cbrnza)
from #tmpBeneficiariosLiquidar bl

insert into #tmpLog
select *,'Beneficiario con producto no vigente'
from #tmpBeneficiariosLiquidar 
where exste = 0


-- 5e. BENEFICIARIO CON MAS DE UN PRODUCTO ASOCIADO

insert into #tmpLog
select *,'Beneficiario con mas de un producto vigente'
from #tmpBeneficiariosLiquidar 
where exste > 1


--  5c. BENEFICIARIO CON PRODUCTO VIGENTE ASOCIADO A UN APORTANTE NO VIGENTE


-- se asume que los que tienen exste > 0 tienen al menos un producto vigente
update #tmpBeneficiariosLiquidar set exste =(Select count(pb.cnsctvo_prdcto_bnfcro)
											from bdAfiliacion.dbo.tbProductosxBeneficiario pb, bdAfiliacion.dbo.tbProductosCobranza pc
											where bl.cnsctvo_cdgo_tpo_cntrto = pb.cnsctvo_cdgo_tpo_cntrto
											and bl.nmro_cntrto = pb.nmro_cntrto
											and bl.cnsctvo_bnfcro = pb.cnsctvo_bnfcro
											and @ltFechaLiquidacion between pb.inco_vgnca and pb.fn_vgnca
											and pb.estdo_rgstro = 'S'
											and pb.cnsctvo_cdgo_tpo_cntrto = pc.cnsctvo_cdgo_tpo_cntrto
											and pb.nmro_cntrto = pc.nmro_cntrto
											and pb.cnsctvo_cbrnza = pc.cnsctvo_cbrnza
											and @ltFechaLiquidacion between pc.inco_vgnca and pc.fn_vgnca
											and pc.estdo_rgstro = 'S')
from #tmpBeneficiariosLiquidar bl
where exste > 0

insert into #tmpLog
select *,'Beneficiario con Producto vigente asociado a un aportante no vigente'
from #tmpBeneficiariosLiquidar 
where exste = 0



--  5d. BENEFICIARIO CON PRODUCTO ASOCIADO A UN EMPLEADOR QUE NO ES RESPONSABLE DE PAGO


/*
Declare @ltFechaLiquidacion datetime
set @ltFechaLiquidacion = '20080601'

update #tmpBeneficiariosLiquidar set exste =0

update #tmpBeneficiariosLiquidar set exste =(Select count(pb.cnsctvo_prdcto_bnfcro)
											from bdAfiliacion.dbo.tbProductosxBeneficiario pb, bdAfiliacion.dbo.tbProductosCobranza pc,
											bdAfiliacion.dbo.tbCobranzas c
											where bl.cnsctvo_cdgo_tpo_cntrto = pb.cnsctvo_cdgo_tpo_cntrto
											and bl.nmro_cntrto = pb.nmro_cntrto
											and bl.cnsctvo_bnfcro = pb.cnsctvo_bnfcro
											and @ltFechaLiquidacion between pb.inco_vgnca and pb.fn_vgnca
											and pb.estdo_rgstro = 'S'
											and pb.cnsctvo_cdgo_tpo_cntrto = pc.cnsctvo_cdgo_tpo_cntrto
											and pb.nmro_cntrto = pc.nmro_cntrto
											and pb.cnsctvo_cbrnza = pc.cnsctvo_cbrnza
											and @ltFechaLiquidacion between pc.inco_vgnca and pc.fn_vgnca
											and pc.estdo_rgstro = 'S'
											and pc.cnsctvo_cdgo_tpo_cntrto = c.cnsctvo_cdgo_tpo_cntrto
											and pc.nmro_cntrto = c.nmro_cntrto
											and pc.cnsctvo_cbrnza = c.cnsctvo_cbrnza
											)
from #tmpBeneficiariosLiquidar bl
where exste > 0


insert into #tmpLog
select *,'Beneficiario con producto asociado a un empleador que no es reponsable de pago'
from #tmpBeneficiariosLiquidar 
where exste = 0
*/



-- BENEFICARIO CON  PRODUCTO DE DIFERENTE PLAN

update #tmpBeneficiariosLiquidar set exste =0

update #tmpBeneficiariosLiquidar set exste =(Select count(p.cnsctvo_prdcto)
											from bdAfiliacion.dbo.tbProductosxBeneficiario pb, bdAfiliacion.dbo.tbProductosCobranza pc,
											bdPlanBeneficios.dbo.tbProductos p, bdAfiliacion.dbo.tbContratos c
											where bl.cnsctvo_cdgo_tpo_cntrto = pb.cnsctvo_cdgo_tpo_cntrto
											and bl.nmro_cntrto = pb.nmro_cntrto
											and bl.cnsctvo_bnfcro = pb.cnsctvo_bnfcro
											and @ltFechaLiquidacion between pb.inco_vgnca and pb.fn_vgnca
											and pb.estdo_rgstro = 'S'
											and pb.cnsctvo_cdgo_tpo_cntrto = pc.cnsctvo_cdgo_tpo_cntrto
											and pb.nmro_cntrto = pc.nmro_cntrto
											and pb.cnsctvo_cbrnza = pc.cnsctvo_cbrnza
											and @ltFechaLiquidacion between pc.inco_vgnca and pc.fn_vgnca
											and pc.estdo_rgstro = 'S'
											and pc.cnsctvo_prdcto = p.cnsctvo_prdcto
											and pb.cnsctvo_cdgo_tpo_cntrto = c.cnsctvo_cdgo_tpo_cntrto
											and pb.nmro_cntrto = c.nmro_cntrto
											and c.cnsctvo_cdgo_pln != p.cnsctvo_cdgo_pln)
from #tmpBeneficiariosLiquidar bl


insert into #tmpLog
select *,'Beneficiario con Producto de diferente plan'
from #tmpBeneficiariosLiquidar 
where exste > 0



-- BENEFICARIO CON  MODELO DE DIFERENTE PLAN


update #tmpBeneficiariosLiquidar set exste =0

update #tmpBeneficiariosLiquidar set exste =(Select count(p.cnsctvo_prdcto)
											from bdAfiliacion.dbo.tbProductosxBeneficiario pb, bdAfiliacion.dbo.tbProductosCobranza pc,
											bdPlanBeneficios.dbo.tbProductos p, bdAfiliacion.dbo.tbContratos c,
											bdPlanBeneficios.dbo.tbDetProductos dp, bdPlanBeneficios.dbo.tbModelos m
											where bl.cnsctvo_cdgo_tpo_cntrto = pb.cnsctvo_cdgo_tpo_cntrto
											and bl.nmro_cntrto = pb.nmro_cntrto
											and bl.cnsctvo_bnfcro = pb.cnsctvo_bnfcro
											and @ltFechaLiquidacion between pb.inco_vgnca and pb.fn_vgnca
											and pb.estdo_rgstro = 'S'
											and pb.cnsctvo_cdgo_tpo_cntrto = pc.cnsctvo_cdgo_tpo_cntrto
											and pb.nmro_cntrto = pc.nmro_cntrto
											and pb.cnsctvo_cbrnza = pc.cnsctvo_cbrnza
											and @ltFechaLiquidacion between pc.inco_vgnca and pc.fn_vgnca
											and pc.estdo_rgstro = 'S'
											and pc.cnsctvo_prdcto = p.cnsctvo_prdcto
											and p.cnsctvo_prdcto = dp.cnsctvo_prdcto
											and @ltFechaLiquidacion between dp.inco_vgnca_asccn and dp.fn_vgnca_asccn
											and dp.cnsctvo_cdgo_clse_mdlo = 6
											and dp.cnsctvo_mdlo = m.cnsctvo_mdlo
											and pb.cnsctvo_cdgo_tpo_cntrto = c.cnsctvo_cdgo_tpo_cntrto
											and pb.nmro_cntrto = c.nmro_cntrto
											and c.cnsctvo_cdgo_pln != m.cnsctvo_cdgo_pln)
from #tmpBeneficiariosLiquidar bl


      

insert into #tmpLog
select *,'Beneficiario con modelo de diferente plan'
from #tmpBeneficiariosLiquidar 
where exste > 0


-- 6A. BENEFICIARIO CON PRODUCTO SIN MODELO ASOCIADO
update #tmpBeneficiariosLiquidar set exste =0
update #tmpBeneficiariosLiquidar set exste =(Select count(pb.cnsctvo_prdcto_bnfcro)
											from bdAfiliacion.dbo.tbProductosxBeneficiario pb
											where bl.cnsctvo_cdgo_tpo_cntrto = pb.cnsctvo_cdgo_tpo_cntrto
											and bl.nmro_cntrto = pb.nmro_cntrto
											and bl.cnsctvo_bnfcro = pb.cnsctvo_bnfcro
											and pb.estdo_rgstro = 'S')
from #tmpBeneficiariosLiquidar bl

insert into #tmpLog
select *,'Beneficiario Con Producto Sin Modelo asociado'
from #tmpBeneficiariosLiquidar 
where exste = 0

select l.nmro_cntrto as Numero_Contrato, 
l.cnsctvo_bnfcro as Consecutivo_Beneficiario, 
t.cdgo_tpo_idntfccn as Tipo_Identificacion, 
v.nmro_idntfccn as Numero_Identificacion, 
ltrim(rtrim(l.csa)) as Causa
from #tmpLog l inner join bdAfiliacion.dbo.tbBeneficiarios b
on l.nmro_cntrto = b.nmro_cntrto
and l.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto
and l.cnsctvo_bnfcro = b.cnsctvo_bnfcro
inner join bdAfiliacion.dbo.tbVinculados v
on b.nmro_unco_idntfccn_bnfcro = v.nmro_unco_idntfccn
inner join bdAfiliacion.dbo.tbTiposIdentificacion t
on v.cnsctvo_cdgo_tpo_idntfccn = t.cnsctvo_cdgo_tpo_idntfccn
order by l.nmro_cntrto,l.cnsctvo_bnfcro, v.nmro_idntfccn, l.csa 


