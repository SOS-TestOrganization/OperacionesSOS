
/*---------------------------------------------------------------------------------    
* Metodo o PRG    : spExtraccionRetirosPlanes    
* Desarrollado por  : <\A Ing. Diana Lorena Gomez Betancourt  A\>    
* Descripcion   : <\D  Permite conocer los contratos con sus beneficiarios que de un mes a otro se desafilian dependiendo del plan D\>    
* Observaciones   : <\O  O\>    
* Parametros   : <\P P\>    
* Variables    : <\V   V\>    
* Fecha Creacion  : <\FC 2009/08/31 FC\>    
*---------------------------------------------------------------------------------    
SAU  Analista Descripcion    
*---------------------------------------------------------------------------------*/    
CREATE PROCEDURE [dbo].[spExtraccionRetirosPlanes]      
as     
Declare @ldFechaSistema  Datetime,    
@lnPeriodoEvaluarDesde Int,    
@lnPeriodoEvaluarHasta Int,    
 @lnConsecutivoPlan int    
    
    
Set Nocount On    
    
create table #tmpInformeFinal (  
nmro_cntrto int,  
 dscrpcn_pln varchar(250),   
cdgo_sde varchar(50),  
dscrpcn_sde varchar(250),  
nmro_unco_idntfccn_empldr int,  
 nmro_unco_idntfccn_bnfcro int ,  
 nmbre varchar(250),  
 nmro_unco_idntfccn_cntrtnte int,  
 drccn  varchar(250),  
 tlfno udttelefono,  
 ciudad  varchar(250),  
 nmbreB varchar(250),  
 drccnB  varchar(250),  
 tlfnoB udttelefono,  
 ciudadB  varchar(250),  
 nmbreR varchar(250),  
 drccnR  varchar(250),  
 tlfnoR udttelefono,  
 ciudadR  varchar(250),  
 TI char(3),  
 NI  varchar(15),  
 TI_B char(3),  
 NI_B  varchar(15),  
 TI_R char(3),  
 NI_R  varchar(15),  
cnsctvo_cdgo_tpo_cntrto int,   
cnsctvo_cdgo_csa_nvdd int,  
 cnsctvo_cdgo_tpo_nvdd int,  
dscrpcn_tpo_nvdd_lrga varchar(250),  
 cnsctvo_nvdd char(15),  
 dscrpcn_csa_nvdd_lrga varchar(250),  
 fcha_aplcn_nvdd_cntrto datetime  
  
)  
    
--select * from bdplanbeneficios.dbo.tbPlanes    
    
Select @ldFechaSistema  = Getdate()    
Select  @lnPeriodoEvaluarDesde = 0    
Select @lnPeriodoEvaluarHasta = 0    
Select  @lnConsecutivoPlan = 0    
    
/* Set @lnPeriodoEvaluarDesde =200908    
 Set @lnPeriodoEvaluarHasta = 200909    
 Set  @lnConsecutivoPlan = 2 */    
    
Select @lnPeriodoEvaluarDesde = Convert(Int,vlr)    
From #tbCriteriosTmp    
Where  cdgo_cmpo  = 'prdo_lqdcn'    
and oprdr ='>='    
    
Select @lnPeriodoEvaluarHasta = Convert(Int,vlr)    
From #tbCriteriosTmp    
Where  cdgo_cmpo  = 'prdo_lqdcn'    
and oprdr ='<='    
    
Select @lnConsecutivoPlan= Convert(Int,vlr)    
From  #tbCriteriosTmp    
Where  cdgo_cmpo  = 'cnsctvo_cdgo_pln'    
    
--Se traen las liquidaciones finalizadas    
    
Select bdrecaudos.dbo.fnCalculaPeriodo (a.fcha_incl_prdo_lqdcn)  fcha_incl_prdo_lqdcn,    
 cnsctvo_cdgo_lqdcn    
Into #tmpLiquidacionesFinalizadas    
From bdCarteraPac.dbo.tbPeriodosliquidacion_Vigencias a, bdCarteraPac.dbo.tbLiquidaciones b    
Where   a.cnsctvo_cdgo_prdo_lqdcn = b.cnsctvo_cdgo_prdo_lqdcn    
And b.cnsctvo_cdgo_estdo_lqdcn = 3    
    
    
    
Select fcha_incl_prdo_lqdcn,    
 cnsctvo_cdgo_tpo_cntrto,    
 nmro_cntrto,    
 nmro_unco_idntfccn_empldr,    
 cnsctvo_cdgo_clse_aprtnte,    
 cnsctvo_scrsl,    
 0 cnsctvo_sde_inflnca,    
 Space(50) dscrpcn_sde,    
 Space(10) cdgo_sde,    
 0  nmro_unco_idntfccn_bnfcro,    
 0 Grupo,    
 0 cnsctvo_cdgo_cdd_rsdnca,    
 0 cnsctvo_cdgo_pln,    
 Space(30) dscrpcn_pln    
Into #tmpPeriodoInicial    
From bdCarteraPac.dbo.TbestadosCuenta a,    
 bdCarteraPac.dbo.TbEstadosCuentaContratos  c,    
 #tmpLiquidacionesFinalizadas  d    
Where a.cnsctvo_estdo_cnta = c.cnsctvo_estdo_cnta    
And a.cnsctvo_cdgo_lqdcn = d.cnsctvo_cdgo_lqdcn    
And 1   = 2    
    
-- Se inserta el primer periodo digitado    
Insert Into #tmpPeriodoInicial    
Select fcha_incl_prdo_lqdcn,    
 cnsctvo_cdgo_tpo_cntrto,    
 nmro_cntrto,    
 a.nmro_unco_idntfccn_empldr,    
 a.cnsctvo_cdgo_clse_aprtnte,    
 a.cnsctvo_scrsl,    
 0,    
 '',    
  '',    
 nmro_unco_idntfccn_bnfcro,    
 0,    
 0,    
 0,    
 ''    
 From bdCarteraPac.dbo.tbEstadosCuenta a,    
 bdCarteraPac.dbo.tbEstadosCuentaContratos  c,    
 #tmpLiquidacionesFinalizadas d,    
 bdCarteraPac.dbo.tbCuentasContratosBeneficiarios t    
Where a.cnsctvo_estdo_cnta  = c.cnsctvo_estdo_cnta      
And a.cnsctvo_cdgo_lqdcn  = d.cnsctvo_cdgo_lqdcn      
And a.cnsctvo_cdgo_estdo_estdo_cnta != 4    
And t.cnsctvo_estdo_cnta_cntrto  = c.cnsctvo_estdo_cnta_cntrto    
And fcha_incl_prdo_lqdcn  = @lnPeriodoEvaluarDesde    
    
Update a    
Set a.cnsctvo_cdgo_cdd_rsdnca  = b.cnsctvo_cdgo_cdd_rsdnca    
From #tmpPeriodoInicial a,  bdafiliacion.dbo.tbpersonas b    
Where a.nmro_unco_idntfccn_bnfcro = b.nmro_unco_idntfccn    
    
Update a    
Set a.cnsctvo_sde_inflnca  = b.cnsctvo_sde_inflnca    
From #tmpPeriodoInicial a, bdafiliacion.dbo.tbciudades_vigencias b    
Where a.cnsctvo_cdgo_cdd_rsdnca = b.cnsctvo_cdgo_cdd    
    
Update a    
Set a.dscrpcn_sde = s.dscrpcn_sde,    
 a.cdgo_sde = s.cdgo_sde    
From #tmpPeriodoInicial a,     bdafiliacion.dbo.tbSedes s    
Where a.cnsctvo_sde_inflnca  = s.cnsctvo_cdgo_sde    
    
Update a    
Set a.cnsctvo_cdgo_pln  = b.cnsctvo_cdgo_pln    
From #tmpPeriodoInicial  a,  bdAfiliacion.dbo.tbcontratos b    
Where a.nmro_cntrto   = b.nmro_cntrto    
And a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto    
    
Update a    
Set a.dscrpcn_pln   = b.dscrpcn_pln    
From #tmpPeriodoInicial  a, bdplanbeneficios.dbo.tbplanes  b    
Where a.cnsctvo_cdgo_pln  = b.cnsctvo_cdgo_pln    
    
delete from #tmpPeriodoInicial  where cnsctvo_cdgo_pln != @lnConsecutivoPlan    
    
    
Select fcha_incl_prdo_lqdcn,    
 cnsctvo_cdgo_tpo_cntrto,    
 nmro_cntrto,    
 nmro_unco_idntfccn_empldr,    
 cnsctvo_cdgo_clse_aprtnte,    
 cnsctvo_scrsl,    
 0 cnsctvo_sde_inflnca,    
 Space(50) dscrpcn_sde,    
 Space(10) cdgo_sde,    
 0  nmro_unco_idntfccn_bnfcro,    
 0 Grupo,    
 0 cnsctvo_cdgo_cdd_rsdnca,    
 0 cnsctvo_cdgo_pln,    
 Space(30) dscrpcn_pln    
Into #tmpPeriodoFinal    
From bdCarteraPac.dbo.TbestadosCuenta a,    
 bdCarteraPac.dbo.TbEstadosCuentaContratos  c,    
 #tmpLiquidacionesFinalizadas  d    
Where a.cnsctvo_estdo_cnta = c.cnsctvo_estdo_cnta    
And a.cnsctvo_cdgo_lqdcn = d.cnsctvo_cdgo_lqdcn    
And 1   = 2    
    
-- Se insertan los datos correspondientes al periodo final digitado    
Insert Into #tmpPeriodoFinal    
Select fcha_incl_prdo_lqdcn,    
 cnsctvo_cdgo_tpo_cntrto,    
 nmro_cntrto,    
 a.nmro_unco_idntfccn_empldr,    
 a.cnsctvo_cdgo_clse_aprtnte,    
 a.cnsctvo_scrsl,    
 0,    
 '',    
    '',    
 nmro_unco_idntfccn_bnfcro,    
 0,    
 0,    
  0,    
 ''    
From bdCarteraPac.dbo.tbEstadosCuenta a,    
 bdCarteraPac.dbo.tbEstadosCuentaContratos  c,    
 #tmpLiquidacionesFinalizadas d,    
 bdCarteraPac.dbo.tbCuentasContratosBeneficiarios t    
Where a.cnsctvo_estdo_cnta  = c.cnsctvo_estdo_cnta      
And a.cnsctvo_cdgo_lqdcn  = d.cnsctvo_cdgo_lqdcn      
And a.cnsctvo_cdgo_estdo_estdo_cnta != 4    
And t.cnsctvo_estdo_cnta_cntrto  = c.cnsctvo_estdo_cnta_cntrto    
And fcha_incl_prdo_lqdcn  = @lnPeriodoEvaluarHasta    
    
    
Update a    
Set a.cnsctvo_cdgo_cdd_rsdnca  = b.cnsctvo_cdgo_cdd_rsdnca    
From #tmpPeriodoFinal a,  bdafiliacion.dbo.tbpersonas b    
Where a.nmro_unco_idntfccn_bnfcro = b.nmro_unco_idntfccn    
    
Update a    
Set a.cnsctvo_sde_inflnca  = b.cnsctvo_sde_inflnca    
From #tmpPeriodoFinal a, bdafiliacion.dbo.tbciudades_vigencias b    
Where a.cnsctvo_cdgo_cdd_rsdnca = b.cnsctvo_cdgo_cdd    
    
Update  a    
Set a.dscrpcn_sde = s.dscrpcn_sde,    
 a.cdgo_sde = s.cdgo_sde    
From #tmpPeriodoFinal a,     bdafiliacion.dbo.tbSedes s    
Where a.cnsctvo_sde_inflnca  = s.cnsctvo_cdgo_sde    
    
Update a     
Set a.cnsctvo_cdgo_pln  = b.cnsctvo_cdgo_pln    
From #tmpPeriodoFinal  a,  bdAfiliacion.dbo.tbcontratos b    
Where a.nmro_cntrto   = b.nmro_cntrto    
And a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto    
    
Update a    
Set a.dscrpcn_pln   = b.dscrpcn_pln    
From #tmpPeriodoFinal  a, bdplanbeneficios.dbo.tbplanes  b    
Where a.cnsctvo_cdgo_pln  = b.cnsctvo_cdgo_pln    
    
    
delete from #tmpPeriodoFinal  where cnsctvo_cdgo_pln !=  @lnConsecutivoPlan    
    
--Se hace el comparativo contra los que se encuentran en el primer periodo y no en el segundo    
Insert into   #tmpInformeFinal (nmro_cntrto, dscrpcn_pln, cdgo_sde,dscrpcn_sde,nmro_unco_idntfccn_empldr, nmro_unco_idntfccn_bnfcro,cnsctvo_cdgo_tpo_cntrto)    
select nmro_cntrto, dscrpcn_pln, cdgo_sde,dscrpcn_sde,nmro_unco_idntfccn_empldr, nmro_unco_idntfccn_bnfcro,cnsctvo_cdgo_tpo_cntrto  
from   #tmpPeriodoInicial where nmro_unco_idntfccn_bnfcro     
not in (select nmro_unco_idntfccn_bnfcro from  #tmpPeriodoFinal group by nmro_unco_idntfccn_bnfcro)    
    
update a    
set a.nmro_unco_idntfccn_cntrtnte = c.nmro_unco_idntfccn_afldo    
from bdafiliacion.dbo.tbContratos c    
inner join #tmpInformeFinal a on a.nmro_cntrto = c.nmro_cntrto     
where c.cnsctvo_cdgo_tpo_cntrto = 2    
    
update a    
set a.nmbreB  =  ltrim(rtrim(pp.prmr_nmbre)) + ' ' + ltrim(rtrim(pp.sgndo_nmbre)) + ' ' + ltrim(rtrim(pp.prmr_aplldo)) + ' ' + ltrim(rtrim(pp.sgndo_aplldo)),    
a.drccnB  = pp.drccn_rsdnca,    
 a.tlfnoB  = pp.tlfno_rsdnca,    
 a.ciudadB = c.dscrpcn_cdd    
from #tmpInformeFinal a inner join bdafiliacion.dbo.tbPersonas pp    
on a.nmro_unco_idntfccn_bnfcro = pp.nmro_unco_idntfccn    
inner join bdafiliacion.dbo.tbCiudades c    
on pp.cnsctvo_cdgo_cdd_rsdnca = c.cnsctvo_cdgo_cdd    
    
update a    
set a.nmbre  =  ltrim(rtrim(pp.prmr_nmbre)) + ' ' + ltrim(rtrim(pp.sgndo_nmbre)) + ' ' + ltrim(rtrim(pp.prmr_aplldo)) + ' ' + ltrim(rtrim(pp.sgndo_aplldo)),    
a.drccn  = pp.drccn_rsdnca,    
 a.tlfno  = pp.tlfno_rsdnca,    
 a.ciudad = c.dscrpcn_cdd    
from #tmpInformeFinal a inner join bdafiliacion.dbo.tbPersonas pp    
on a.nmro_unco_idntfccn_cntrtnte = pp.nmro_unco_idntfccn    
inner join bdafiliacion.dbo.tbCiudades c    
on pp.cnsctvo_cdgo_cdd_rsdnca = c.cnsctvo_cdgo_cdd    
    
update a    
set a.nmbreR  = sa.nmbre_scrsl,    
a.drccnR  = sa.drccn,    
 a.tlfnoR  = sa.tlfno,    
 a.ciudadR = c.dscrpcn_cdd    
from #tmpInformeFinal a inner join bdafiliacion.dbo.tbSucursalesAportante sa    
on a.nmro_unco_idntfccn_empldr =sa.nmro_unco_idntfccn_empldr    
inner join bdafiliacion.dbo.tbCiudades c    
on sa.cnsctvo_cdgo_cdd = c.cnsctvo_cdgo_cdd    
    
update a    
set  a.TI = ti.cdgo_tpo_idntfccn,    
a.NI = v.nmro_idntfccn    
from #tmpInformeFinal a inner join bdafiliacion.dbo.tbVinculados v    
on a.nmro_unco_idntfccn_cntrtnte =v.nmro_unco_idntfccn    
inner join bdafiliacion.dbo.tbTiposIdentificacion ti    
on v.cnsctvo_cdgo_tpo_idntfccn = ti.cnsctvo_cdgo_tpo_idntfccn    
    
update a    
set  a.TI_B = ti.cdgo_tpo_idntfccn,    
a.NI_B = v.nmro_idntfccn    
from #tmpInformeFinal a inner join bdafiliacion.dbo.tbVinculados v    
on a.nmro_unco_idntfccn_bnfcro =v.nmro_unco_idntfccn    
inner join bdafiliacion.dbo.tbTiposIdentificacion ti    
on v.cnsctvo_cdgo_tpo_idntfccn = ti.cnsctvo_cdgo_tpo_idntfccn    
    
update a    
set  a.TI_R = ti.cdgo_tpo_idntfccn,    
a.NI_R = v.nmro_idntfccn    
from #tmpInformeFinal a inner join bdafiliacion.dbo.tbVinculados v    
on a.nmro_unco_idntfccn_empldr =v.nmro_unco_idntfccn    
inner join bdafiliacion.dbo.tbTiposIdentificacion ti    
on v.cnsctvo_cdgo_tpo_idntfccn = ti.cnsctvo_cdgo_tpo_idntfccn    
  
  
  
Update  a  
set   cnsctvo_cdgo_csa_nvdd = b.cnsctvo_cdgo_csa_nvdd ,  
   cnsctvo_cdgo_tpo_nvdd = b.cnsctvo_cdgo_tpo_nvdd ,  
   cnsctvo_nvdd   = b.cnsctvo_nvdd,  
   fcha_aplcn_nvdd_cntrto  = c.fcha_aplcn_nvdd_cntrto  
--Select  *  
from  #tmpInformeFinal a  
Inner Join bdhistoriconovedades.dbo.tbdetallesnovedad_Aplicada  b  
   on  b.cnsctvo_cdgo_tpo_cntrto  =  a.cnsctvo_cdgo_tpo_cntrto  
   and b.nmro_cntrto =  a.nmro_cntrto  
   --and b.nmro_unco_idntfccn= a.nmro_unco_idntfccn_bnfcro  
Inner Join bdhistoriconovedades.dbo.tbconceptosafectados_Aplicados  c  
   On  b.cnsctvo_dtlle_nvdd_gnrda  =  c.cnsctvo_dtlle_nvdd_gnrda    
   And    b.cnsctvo_dtlle_nvdd  =  c.cnsctvo_dtlle_nvdd  
   And  b.cnsctvo_nvdd    =  c.cnsctvo_nvdd  
Where b.cnsctvo_cdgo_tpo_nvdd  in( 4,8,10,15,24)   
and   convert(varchar(6),c.fcha_ultma_mdfccn, 112) between   
convert(varchar(6),(dateadd(month,-1,convert(varchar(6),@lnPeriodoEvaluarDesde)+ '01')), 112)
and convert(varchar(6),@lnPeriodoEvaluarHasta)
  
  
  
-- convert(varchar(6),getdate(),112)  
update  b  
set   dscrpcn_csa_nvdd_lrga = cn.dscrpcn_csa_nvdd_lrga  
from  #tmpInformeFinal b  
Inner Join bdAfiliacion.dbo.tbCausasNovedad cn  
   on cn.cnsctvo_cdgo_csa_nvdd = b.cnsctvo_cdgo_csa_nvdd  
  
  
update  b  
set   dscrpcn_tpo_nvdd_lrga = cn.dscrpcn_tpo_nvdd_lrga  
from  #tmpInformeFinal b  
Inner Join bdAfiliacion.dbo.tbTiposNovedad cn  
   on cn.cnsctvo_cdgo_tpo_nvdd = b.cnsctvo_cdgo_tpo_nvdd  
  
  
select   
nmro_cntrto as [Contrato],   
dscrpcn_pln as [Plan],  
cdgo_sde as [Codigo_Sede],  
dscrpcn_sde as [Sede],  
TI as [TI_Contratante],   
NI as  [NI_Contratante],   
nmbre as [Nombre_Contratante],   
drccn as [Direccion_Contratante],   
tlfno as [Telefono_Contratante],   
ciudad as [Ciudad_Contratante],   
TI_B as [TI_Beneficiario],   
NI_B as [NI_Beneficiario],  
nmbreB as [Nombre_Beneficiario],   
drccnB as [Direccion_Beneficiario],  
tlfnoB as [Telefono_Beneficiario],   
ciudadB as [Ciudad_Beneficiario],  
TI_R as [TI_Responsable],   
NI_R as [NI_Responsable],   
nmbreR as [Nombre_Responsable],   
drccnR as [Direccion_Responsable],   
tlfnoR as [Telefono_Responsable],   
ciudadR as [Ciudad_Responsable],  
cnsctvo_nvdd as [Consecutivo_Novedad],  
dscrpcn_csa_nvdd_lrga  as [Causa_Novedad],  
dscrpcn_tpo_nvdd_lrga as [TIPO_Novedad],  
 fcha_aplcn_nvdd_cntrto as [Fecha_Novedad]
from #tmpInformeFinal   


