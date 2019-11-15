
              
/*---------------------------------------------------------------------------------------------------------------------------------------                                        
* Procedimiento  :  dbo.SpMNConsultaTutelasWeb              
* Desarrollado por  : <\A Ing. Angela Patricia Sandoval.    A\>                                        
* Descripción  : <\D Se esta solicitando un SP que consulta la informacion de la tutela        
                           pendientes, y el resuelve, para servicio al cliente, este mensaje se desplegara en responde    
                       se define que a las IPS solo se les mostraran las tutelas de medicamentos POS y no pos y de procedimientos POS y NO POS    
                            D\>                                        
* Observaciones  : <\O         O\>                                        
* Parámetros  : <\P                                           
* Fecha Creación : <\FC 2010/08/03         FC\>              
*---------------------------------------------------------------------------------------------------------------------------------------                                        
* DATOS DE MODIFICACION              
*---------------------------------------------------------------------------------                              
* Modificado Por   : <\AM  AM\>                                        
* Descripción    : <\DM  DM\>                                        
* Nuevos Parámetros   : <\PM  PM\>                                        
* Nuevas Variables   : <\VM  VM\>                                        
* Fecha Modificación   : <\FM FM\>                                        
*-------------------------------------------------------------------------------------------------------------------------------------*/                                   
/*exec SpMNConsultaTutelasWeb 'RC','98102554736','20010101','20110201','SISAPS01'    
exec SpMNConsultaTutelasWeb 'CC','16466992','20010101','20101101','SISAPS01'   
update bdIpsTransaccional..tbafiliadosmarcados set  cnsctvo_cdgo_dgnstco=6900 where cnsctvo_ntfccn=727691
delete tbDetalleDiagnosticoNotificacion where cnsctvo_ntfccn=727691
select * from bdIpsTransaccional..tbdiagnosticos where cnsctvo_cdgo_dgnstco=6900
--PRUEBAS exec SpMNConsultaTutelasWeb 'CC','25108750','20010101','20101101','SISAPS01'    
PRUEBAS exec SpMNConsultaTutelasWeb 'CC','16360888','20010101','20101101','SISAPS01'  
*/              
              
CREATE procedure  [dbo].SpMNConsultaTutelasWeb                         
@lnTipoIdAfiliado    VARCHAR(3),                                
@lnNmroIdAfiliado    varchar(20),                                
@fcha_inco                 datetime =null,    
@fcha_fn                 datetime  =null,    
@usro                    varchar(10)    
    
as              
              
set nocount on          
            
declare  @tutelas table              
(cnsctvo_ntfccn               int,              
cnsctvo_cdgo_ofcna            int,              
cdgo_tpo_idntfccn             varchar(3),              
nmro_idntfccn                 varchar(20),              
dscrpcn_ttla                  varchar(8000),              
rslve                         varchar(6400),              
obsrvcns                      nvarchar(1200),              
dscrpcn_estdo_ttla            varchar(150),              
dscrpcn_estdo_fllo            varchar(150),              
cnsctvo_cdgo_estdo_ttla       int,              
cnsctvo_cdgo_estdo_fllo       int,              
pndnte_dcmnto_sprte           varchar(1),              
cnsctvo_cdgo_csa_impgncn      int,              
rslve_fnl                     varchar(6400),      
cnsctvo_cdgo_csa_estdo_ntfccn int,    
pga_cta_mdrdra                varchar(1),    
pga_cpgo                      varchar(1),    
cnsctvo_cdgo_cta_rcprcn_ttla  int,    
dscrpcn_cta_rcprcn_ttla       varchar(10),    
fcha_evnto                    datetime,    
cnsctvo_cdgo_ptlga_ctstrfca   int,    
descrpcn_ptlga_ctstrfca       varchar(150),
cnsctvo_cdgo_dgnstco          int,    
cdgo_dgnstco                  varchar(5),    
dscrpcn_dgnstco              varchar(150)
)              
              
              
insert into @tutelas              
(cdgo_tpo_idntfccn ,nmro_idntfccn,dscrpcn_ttla,cnsctvo_cdgo_estdo_ttla,              
pndnte_dcmnto_sprte,rslve,cnsctvo_cdgo_estdo_fllo,cnsctvo_ntfccn,cnsctvo_cdgo_ofcna,obsrvcns,rslve_fnl,fcha_evnto,    
cnsctvo_cdgo_cta_rcprcn_ttla,cnsctvo_cdgo_ptlga_ctstrfca,cnsctvo_cdgo_dgnstco)              
select ltrim(rtrim(e.cdgo_tpo_idntfccn)),b.nmro_idntfccn,              
prtncn,d.cnsctvo_cdgo_estdo_ntfccn,'N','NO TIENE',0,a.cnsctvo_ntfccn,a.cnsctvo_cdgo_ofcna,d.obsrvcns,'NO TIENE',    
fcha_ntfccn          ,cnsctvo_cdgo_cta_rcprcn_ttla,d.cnsctvo_cdgo_ptlga_ctstrfca   , d.cnsctvo_cdgo_dgnstco 
from bdIpsTransaccional.dbo.tbtutela1  a inner join bdIpsTransaccional.dbo.tbactuanotificacion b on              
a.cnsctvo_ntfccn=b.cnsctvo_ntfccn and a.cnsctvo_cdgo_ofcna=b.cnsctvo_cdgo_ofcna              
inner join bdIpsTransaccional.dbo.tbafiliadosmarcados d on              
a.cnsctvo_ntfccn=d.cnsctvo_ntfccn and a.cnsctvo_cdgo_ofcna=d.cnsctvo_cdgo_ofcna              
INNER JOIN bdafiliacionvalidador..tbtiposidentificacion e on    
b.cnsctvo_cdgo_tpo_idntfccn=e.cnsctvo_cdgo_tpo_idntfccn    
inner join bdIpsTransaccional.dbo.tbtutela f on    
a.cnsctvo_ntfccn=f.cnsctvo_ntfccn and a.cnsctvo_cdgo_ofcna=f.cnsctvo_cdgo_ofcna        
where d.cnsctvo_cdgo_estdo_ntfccn!=55 and d.cnsctvo_cdgo_estdo_ntfccn!=21 -- excluyen los anulados y cerrados               
and (nmro_idntfccn= @lnNmroIdAfiliado and e.cdgo_tpo_idntfccn=@lnTipoIdAfiliado)        
and (getdate() between fcha_fllo and fcha_vncmnto or     
  fcha_vncmnto is null or fcha_vncmnto='19000101')         
    
     
update @tutelas set rslve_fnl=c.dscrpcn_fllo,cnsctvo_cdgo_estdo_fllo=c.cnsctvo_cdgo_estdo_ntfccn,              
cnsctvo_cdgo_csa_impgncn=c.cnsctvo_cdgo_csa_impgncn,      
cnsctvo_cdgo_csa_estdo_ntfccn = c.cnsctvo_cdgo_csa_estdo_ntfccn              
from @tutelas a               
left outer join bdIpsTransaccional.dbo.tbfallos c on              
a.cnsctvo_ntfccn=c.cnsctvo_ttla and a.cnsctvo_cdgo_ofcna=c.cnsctvo_cdgo_ofcna              
where c.cnsctvo_ttla is not null              
and cnsctvo_cdgo_tpo_fllo= (select max(cnsctvo_cdgo_tpo_fllo) from bdIpsTransaccional.dbo.tbfallos d where               
a.cnsctvo_ntfccn=d.cnsctvo_ttla and a.cnsctvo_cdgo_ofcna=d.cnsctvo_cdgo_ofcna)              
    
    
update @tutelas set dscrpcn_cta_rcprcn_ttla=b.dscrpcn_cta_rcprcn_ttla            
from @tutelas a inner join bdIpsTransaccional.dbo.tbMNCuotaRecuperacionTutelas_vigencias b               
on a.cnsctvo_cdgo_cta_rcprcn_ttla=b.cnsctvo_cdgo_cta_rcprcn_ttla           

update @tutelas set dscrpcn_dgnstco=b.dscrpcn_dgnstco ,       cdgo_dgnstco=b.cdgo_dgnstco     
from @tutelas a inner join bdIpsTransaccional.dbo.tbdiagnosticos b               
on a.cnsctvo_cdgo_dgnstco=b.cnsctvo_cdgo_dgnstco  

update @tutelas set descrpcn_ptlga_ctstrfca=b.dscrpcn_ptlgs_ctstrfcs            
from @tutelas d inner join bdIpsTransaccional.dbo.tbpatologiasxevento_vigencias a     
on   d.cnsctvo_cdgo_ptlga_ctstrfca=a.cnsctvo_cdgo_ptlgs_ctstrfcs             
INNER JOIN  bdIpsTransaccional.dbo.tbPatologiasCatastroficas_vigencias  b                
on  a.cnsctvo_cdgo_ptlgs_ctstrfcs=b.cnsctvo_cdgo_ptlgs_ctstrfcs              
where a.cnsctvo_cdgo_clsfccn_evnto=8             
And   (b.Vsble_Usro  = 'S' )       
--and   getdate() between a.inco_vgnca and a.fn_vgnca               
           
              
update @tutelas set dscrpcn_estdo_fllo=b.dscrpcn_estdo_ntfccn              
from @tutelas a inner join bdIpsTransaccional.dbo.tbestadosnotificacion b               
on a.cnsctvo_cdgo_estdo_fllo=b.cnsctvo_cdgo_estdo_ntfccn              
              
update @tutelas set dscrpcn_estdo_ttla=b.dscrpcn_estdo_ntfccn              
from @tutelas a inner join bdIpsTransaccional.dbo.tbestadosnotificacion b               
on a.cnsctvo_cdgo_estdo_ttla=b.cnsctvo_cdgo_estdo_ntfccn              
              
              
    
--2008/10/20 si esta el fallo en estado no ejecutoriado (145) y tiene estas causas      
--106 FALLO SIMPLE ST 760 - 107 AUTENTICO - 27 CORTE no se debe mostrar      
--143 PROBABLE - 144 NOTIFICADO - 145 NO EJECUTORIADO - 146 CONFIRMADO- 150 CERRADO-160 DEVOLUCION      
              
      
              
update @tutelas set rslve=case                
when rslve_fnl!='NO TIENE'  then rslve_fnl              
when rslve_fnl='NO TIENE' and dscrpcn_ttla is not null then dscrpcn_ttla              
when rslve_fnl='NO TIENE'  then obsrvcns              
else rslve end    
from @tutelas a               
    
select a.cnsctvo_ntfccn,a.cnsctvo_cdgo_ofcna,cdgo_tpo_idntfccn,nmro_idntfccn,    
dscrpcn_ttla ,rslve_fnl, fcha_evnto,isnull(pga_cta_mdrdra,'N') pga_cta_mdrdra,    
pga_cpgo = CASE when cnsctvo_cdgo_cta_rcprcn_ttla=3 then 'S'  else 'N' end    
,isnull(c.cdgo_dgnstco,a.cdgo_dgnstco) as cdgo_dgnstco,isnull(c.dscrpcn_dgnstco,a.dscrpcn_dgnstco)  as dscrpcn_dgnstco ,prncpl =  
      CASE prncpl  
         WHEN NULL THEN 'S'  
         WHEN 0 THEN 'N'  
         ELSE 'S'  
      END  
,   descrpcn_ptlga_ctstrfca AS descripcionTutela  
from @tutelas a left outer join 
bdIpsTransaccional.dbo.tbDetalleDiagnosticoNotificacion b on a.cnsctvo_ntfccn=b.cnsctvo_ntfccn and    
a.cnsctvo_cdgo_ofcna=b.cnsctvo_cdgo_ofcna 
left outer join bdIpsTransaccional.dbo.tbdiagnosticos c on    
b.cnsctvo_cdgo_dgnstco=c.cnsctvo_cdgo_dgnstco   
--where  a.dscrpcn_dgnstco is not null or c.dscrpcn_dgnstco is not null

-- esta condicion se pone debido a que si el diagnostico es vacio el web service se revienta
    

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpMNConsultaTutelasWeb] TO [webusr]
    AS [dbo];

