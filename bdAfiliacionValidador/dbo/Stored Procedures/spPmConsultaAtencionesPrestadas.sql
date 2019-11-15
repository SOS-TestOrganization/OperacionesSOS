/*------------------------------------------------------------------------------------------------------------------------------------------------------------  
* Metodo o PRG   : spPmConsultaAtencionesPrestadas  
* Desarrollado por  : <\Analista Alexander Lopez Arboleda  
* Descripcion   : <\Permite Consultar todas las ordenes de servicios ingresadas x usuario en todos los planes  
* Fecha Creacion  : <\FC 2004/08/09  
*------------------------------------------------------------------------------------------------------------------------------------------------------------  
* DATOS DE MODIFICACION :   
*------------------------------------------------------------------------------------------------------------------------------------------------------------*/  
--exec sppmconsultaAtencionesPrestadas 01,1,'2337352'
CREATE procedure [dbo].[spPmConsultaAtencionesPrestadas]  
@nmro_unco_idntfccn  		Int,   
@cnsctvo_cdgo_pln		Int,   
@cnsctvo_cdgo_tpo_idntfccn  	UdtConsecutivo = NULL,  		--Para buscar afiliados de Famisanar y especiales  
@nmro_idntfccn   		UdtNumeroIdentificacion = NULL 	--Para buscar afiliados de Famisanar y especiales  
AS  
/*
DECLARE @nuam   	numeric,  
 @cnsctvo_cdgo_ofcna  int,   
 @cdgo_prstcn  		char(11),  
 @punto   		int,  
 @antes   		numeric,  
 @antes1  		char(3),  
 @cdgo_cta_mrbldd   	char(5),  
 @vlr_acmldo    		numeric(9),  
 @tpe_csto           	numeric(9),  
 @ds_acmlds_mrbldd      int,  
 @nui_espcl   		int  
  
set nocount on  
  
DECLARE @tbConsultaAtenciones table   
(cnsctvo_cdgo_ofcna   		int,   
dscrpcn_ofcna   		varchar(150),
dscrpcn_sde     			varchar(150),   
nuam    				int,   
nmro_atncn   			int,   
cnsctvo_cdgo_tpo_atncn 	int,   
dscrpcn_tpo_atncn  		varchar(150),   
fcha_expdcn   			datetime,   
cnsctvo_cdgo_estdo_atncn 	int,   
dscrpcn_estdo_atncn  		varchar(150),   
cnsctvo_cdgo_cntngnca  	int, 
dscrpcn_cntngnca  		varchar(150),   
cnsctvo_cdgo_mrbldd  		int,   
dscrpcn_mrbldd   		varchar(150),   
vlr_acmldo_atncn  		int,    
vlr_acmldo   			int,   
tpe_mrbldd  			int,    
usro_ultma_mdfccn  		Char(30),   
nmro_unco_idntfccn_afldo 	int,   
fcha_entrga   			datetime,   
cnsctvo_cdgo_clse_atncn 	int,   
cnsctvo_cdgo_frma_atncn 	int,   
nmro_unco_idntfccn_mdco 	int,   
obsrvcn    			char(150),   
hra_dgta   			char(10),   
ultmo_cncpto   			decimal(5),   
fcha_imprsn   			datetime,   
cnsctvo_imprsn   		decimal(5),   
cnsctvo_cdgo_no_cpgo  	int,   
usro_ingrsa   			Char(30),   
fcha_ultma_mdfccn  		datetime,   
cnsctvo_cdgo_dgnstco  		int,   
cnsctvo_cdgo_ofcna_atncn 	int,   
cnsctvo_cdgo_pln  		int,   
nmro_unco_idntfccn_ips  	int,   
dscrpcn_dgnstco  		varchar(150),   
rcbro    				char(1),   
cnsctvo_cdgo_rcbro  		int,     
dscrpcn_rcbro   			varchar(150),   
cdgo_cta_mrbldd  		decimal(5),   
cdgo_intrno   			varchar(10),
dscrpcn_pln   			varchar(150),   
fcha_slctd_mdco  		datetime,   
fcha_accdnt_trnsto  		datetime,   
fcha_enfrmdd_prfsnl  		datetime,   
cnsctvo_cdgo_ptlga  		int,   
ds_acmlds_mrbldd  		int,   
dscrpcn_clse_atncn  		varchar(150) ,   
cnsctvo_cdgo_tpo_prstcn  	int,   
cnsctvo_cdgo_tpo_idntfccn 	int,   
nmro_idntfccn   			varchar(20),
cdgo_dgnstco  			varchar(10),     
cdgo_mrbldd  			varchar(5),
cnsctvo_cdgo_estdo_prcso 	int,
cdgo_ofcna   			varchar(5),
cnsctvo_cdgo_tpo_cdfccn	int)   
  
-------------------------------------------------------------------------------------------------------------------------------  
-- Si el usuario es de SOS Debe traer relacionado el Nuip de lo contrario es de Famisanar o Especial --  
-------------------------------------------------------------------------------------------------------------------------------  
if  @nmro_unco_idntfccn !=0
begin  
 -- realizo insercion en la tabla temporal de los reg encontrados con el nuip recibibo de validador  
 insert into @tbConsultaAtenciones  
 select cnsctvo_cdgo_ofcna, '' as dscrpcn_ofcna,'' dscrpcn_sde, nuam, nmro_atncn, cnsctvo_cdgo_tpo_atncn, '' as dscrpcn_tpo_atncn, fcha_expdcn, cnsctvo_cdgo_estdo,   
 '' as dscrpcn_estdo_atncn, cnsctvo_cdgo_cntngnca, '' as dscrpcn_cntngnca, cnsctvo_cdgo_mrbldd, '' as dscrpcn_mrbldd, 0, 0, 0, usro_ultma_mdfccn,    
 nmro_unco_idntfccn_afldo, '' as fcha_entrga, cnsctvo_cdgo_clse_atncn, cnsctvo_cdgo_frma_atncn, nmro_unco_idntfccn_mdco, obsrvcn, hra_dgta, ultmo_cncpto,   
 fcha_imprsn, cnsctvo_imprsn, cnsctvo_cdgo_no_cpgo, usro_ingrsa, fcha_ultma_mdfccn, cnsctvo_cdgo_dgnstco, cnsctvo_cdgo_ofcna_atncn, cnsctvo_cdgo_pln,   
 nmro_unco_idntfccn_ips, '' as dscrpcn_dgnstco, rcbro, cnsctvo_cdgo_rcbro,
 '' as dscrpcn_rcbro, 0, cdgo_intrno, '' as dscrpcn_pln, fcha_slctd_mdco, fcha_accdnt_trnsto,   fcha_enfrmdd_prfsnl,
 cnsctvo_cdgo_ptlga, 0, '' as dscrpcn_clse_atncn,  cnsctvo_cdgo_tpo_cdfccn as cnsctvo_cdgo_tpo_prstcn,
0, '' as nmro_idntfccn,'','',cnsctvo_cdgo_estdo_prcso,'',cnsctvo_cdgo_tpo_cdfccn
from  tbAtencionOps a   (Index = IX_tbAtencionOps)
where  nmro_unco_idntfccn_afldo =  @nmro_unco_idntfccn  
and a.cnsctvo_cdgo_pln = @cnsctvo_cdgo_pln
end   
 --------------------------------------------------------------------------------------------------------------------------------------------------------  
 -- si el usuario es especial o de famisanar no tiene nuip y se debe buscar por el tipo y numero de Id del usuario en Tbactua --  
 --------------------------------------------------------------------------------------------------------------------------------------------------------  
 if @nmro_idntfccn IS not null and @cnsctvo_cdgo_tpo_idntfccn is not null  
 begin   
  declare @tmpOpsATrabajar table   
  (cnsctvo_cdgo_ofcna_b int,  
  nuam_b    numeric )  
   
  insert into @tmpOpsATrabajar  
  select a.cnsctvo_cdgo_ofcna,  a.nuam  
  from  bdSISalud..tbActua a (index = IX_tbActuaTipideNumide) -- tenia antes ix_tbActuaIdentificacion  
  where  a.cnsctvo_cdgo_tpo_idntfccn =  @cnsctvo_cdgo_tpo_idntfccn  
  and  a.nmro_idntfccn  =  @nmro_idntfccn  
   
  insert into @tbConsultaAtenciones  
  select cnsctvo_cdgo_ofcna   , '' as dscrpcn_ofcna_a,'' as dscrpcn_sde, nuam , nmro_atncn, cnsctvo_cdgo_tpo_atncn, '' as dscrpcn_tpo_atncn, fcha_expdcn, cnsctvo_cdgo_estdo,   
  '' as dscrpcn_estdo_atncn, cnsctvo_cdgo_cntngnca, '' as dscrpcn_cntngnca, cnsctvo_cdgo_mrbldd, '' as dscrpcn_mrbldd, 0, 0, 0, usro_ultma_mdfccn,    
  nmro_unco_idntfccn_afldo, '' as fcha_entrga, cnsctvo_cdgo_clse_atncn, cnsctvo_cdgo_frma_atncn, nmro_unco_idntfccn_mdco, obsrvcn, hra_dgta, ultmo_cncpto,   
  fcha_imprsn, cnsctvo_imprsn, cnsctvo_cdgo_no_cpgo, usro_ingrsa, fcha_ultma_mdfccn, cnsctvo_cdgo_dgnstco, cnsctvo_cdgo_ofcna_atncn, cnsctvo_cdgo_pln,   
  nmro_unco_idntfccn_ips, '' as dscrpcn_dgnstco, rcbro, cnsctvo_cdgo_rcbro, '' as dscrpcn_rcbro, 0, 0, '' as dscrpcn_pln, fcha_slctd_mdco, fcha_accdnt_trnsto, fcha_enfrmdd_prfsnl,  
  cnsctvo_cdgo_ptlga, 0, '' as dscrpcn_clse_atncn,   cnsctvo_cdgo_tpo_cdfccn as cnsctvo_cdgo_tpo_prstcn,0, '' as nmro_idntfccn,'','',a.cnsctvo_cdgo_estdo_prcso ,'',cnsctvo_cdgo_tpo_cdfccn  
 from  bdSISalud..tbAtencionOps a (index=PK_tbatencionops) , 
	@tmpOpsATrabajar b    
  where  a.cnsctvo_cdgo_ofcna  =  b.cnsctvo_cdgo_ofcna_b  
  and  a.nuam    =  b.nuam_b  
   
  
 end  
  
----------------------------------------------------------------------------  
-- Se completa el resto de campos de @tbConsultaAtenciones --  
----------------------------------------------------------------------------  
update  @tbConsultaAtenciones   
set  dscrpcn_ofcna  = i.dscrpcn_ofcna  ,
      cdgo_ofcna=i.cdgo_ofcna,
     dscrpcn_sde=c.dscrpcn_sde
from  BdAfiliacionValidador.. tbOficinas_Vigencias i inner join @tbConsultaAtenciones b
on  i.cnsctvo_cdgo_ofcna = b.cnsctvo_cdgo_ofcna  
inner join  BdAfiliacionValidador.. tbsedes_Vigencias c on
c.cnsctvo_cdgo_sde=i.cnsctvo_cdgo_sde
  
update  @tbConsultaAtenciones   
set  dscrpcn_tpo_atncn  = i.dscrpcn_tpo_atncn  
from   bdSisalud..tbtiposatencion i inner join @tbConsultaAtenciones b  
on  i.cnsctvo_cdgo_tpo_atncn = b.cnsctvo_cdgo_tpo_atncn  
  
update  @tbConsultaAtenciones   
set  dscrpcn_estdo_atncn  = i.dscrpcn_estdo_atncn  
from   bdSisalud..tbestadosatencion i inner join @tbConsultaAtenciones b  
on  i.cnsctvo_cdgo_estdo_atncn = b.cnsctvo_cdgo_estdo_atncn  

update  @tbConsultaAtenciones   
set  dscrpcn_cntngnca = i.dscrpcn_cntngnca  
from   bdSisalud..tbcontingencias i inner join @tbConsultaAtenciones b  
on  i.cnsctvo_cdgo_cntngnca = b.cnsctvo_cdgo_cntngnca  
  
update  @tbConsultaAtenciones   
set  dscrpcn_mrbldd = i.dscrpcn_mrbldd  ,
  cdgo_mrbldd    = i.cdgo_mrbldd
from   bdSisalud..tbMorbilidades i inner join @tbConsultaAtenciones b  
on  i.cnsctvo_cdgo_mrbldd = b.cnsctvo_cdgo_mrbldd  
  
update  @tbConsultaAtenciones   
set  dscrpcn_dgnstco = i.dscrpcn_dgnstco  ,
 cdgo_dgnstco=i.cdgo_dgnstco
from   bdSisalud..tbdiagnosticos i inner join @tbConsultaAtenciones b  
on  i.cnsctvo_cdgo_dgnstco = b.cnsctvo_cdgo_dgnstco  
  
update  @tbConsultaAtenciones   
set  dscrpcn_rcbro = i.dscrpcn_rcbro  
from   bdSisalud..tbrecobros i inner join @tbConsultaAtenciones b  
on  i.cnsctvo_cdgo_rcbro = b.cnsctvo_cdgo_rcbro   
  
update  @tbConsultaAtenciones   
set  dscrpcn_clse_atncn = i.dscrpcn_clse_atncn  
from   bdSisalud..tbclasesatencion i inner join @tbConsultaAtenciones b  
on  i.cnsctvo_cdgo_clse_atncn = b.cnsctvo_cdgo_clse_atncn  
  
update  @tbConsultaAtenciones   
set  dscrpcn_pln = i.dscrpcn_pln  
from   bdafiliacionValidador..tbplanes i inner join @tbConsultaAtenciones b  
on  i.cnsctvo_cdgo_pln = b.cnsctvo_cdgo_pln  
  
  
SELECT   ltrim(rtrim(a.dscrpcn_ofcna)) as dscrpcn_ofcna,  
a.nuam,  
a.nmro_atncn,  
ltrim(rtrim(a.dscrpcn_tpo_atncn)) as dscrpcn_tpo_atncn,  
convert(varchar(11), a.fcha_expdcn, 120) as fcha_expdcn,  
ltrim(rtrim(a.dscrpcn_estdo_atncn)) as dscrpcn_estdo_atncn,  
a.dscrpcn_cntngnca,  
a.cnsctvo_cdgo_mrbldd,   
a.dscrpcn_mrbldd,  
a.usro_ultma_mdfccn,  
isnull(a.vlr_acmldo,0) as vlr_acmldo,   
isnull(a.vlr_acmldo_atncn,0) as  vlr_acmldo2 ,  
a.tpe_mrbldd    as vlr_tpe,  
a.nmro_unco_idntfccn_afldo,  
a.cnsctvo_cdgo_cntngnca,  
a.cnsctvo_cdgo_tpo_atncn,  
a.fcha_entrga,  
a.cnsctvo_cdgo_clse_atncn,  
a.cnsctvo_cdgo_frma_atncn,  
a.nmro_unco_idntfccn_mdco,  
a.obsrvcn,  
a.hra_dgta,  
a.ultmo_cncpto,  
isnull(a.fcha_imprsn,'') as fcha_imprsn,
a.cnsctvo_imprsn,  
a.cnsctvo_cdgo_no_cpgo,  
a.usro_ingrsa,  
a.fcha_ultma_mdfccn,  
a.cnsctvo_cdgo_dgnstco,  
a.cnsctvo_cdgo_ofcna_atncn,  
a.cnsctvo_cdgo_pln,  
a.nmro_unco_idntfccn_ips,  
a.cnsctvo_cdgo_ofcna,  
a.dscrpcn_dgnstco,  
a.rcbro,  
a.cnsctvo_cdgo_rcbro,    
isnull(a.dscrpcn_rcbro,'') as dscrpcn_rcbro ,  
a.cdgo_cta_mrbldd,  
a.cdgo_intrno,  
a.dscrpcn_pln,  
a.fcha_slctd_mdco,  
a.fcha_accdnt_trnsto,  a.fcha_enfrmdd_prfsnl as fcha_enfrmdd,
a.cnsctvo_cdgo_ptlga,  
a.cnsctvo_cdgo_estdo_atncn,  
0 as ds_acmlds_mrbldd,  
a.dscrpcn_clse_atncn,  
a.cnsctvo_cdgo_tpo_prstcn ,  
b.cnsctvo_cdgo_tpo_idntfccn,  
b.nmro_idntfccn , a.cdgo_dgnstco, a.cdgo_mrbldd,
a.cnsctvo_cdgo_estdo_prcso,dscrpcn_sde,cdgo_ofcna, cnsctvo_cdgo_tpo_cdfccn
from bDSisalud..tbActua b inner join @tbConsultaAtenciones a  on
a.cnsctvo_cdgo_ofcna = b.cnsctvo_cdgo_ofcna  
and a.nuam = b.nuam  
order by fcha_expdcn desc
*/
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAtencionesPrestadas] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAtencionesPrestadas] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAtencionesPrestadas] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAtencionesPrestadas] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAtencionesPrestadas] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAtencionesPrestadas] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAtencionesPrestadas] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAtencionesPrestadas] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAtencionesPrestadas] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAtencionesPrestadas] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAtencionesPrestadas] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAtencionesPrestadas] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAtencionesPrestadas] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAtencionesPrestadas] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAtencionesPrestadas] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAtencionesPrestadas] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAtencionesPrestadas] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAtencionesPrestadas] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

