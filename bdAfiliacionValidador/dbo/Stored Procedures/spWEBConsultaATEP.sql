

/*
*---------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------------------------------------------------------------
* Procedimiento:	: spWEBConsultaATEP
* Modificado Por	: <\AM  Angela Patricia Sandoval		AM\>
* Descripción		: <\DM  Selecciona los ATEP 							DM\>
* 					: <\DM							DM\>
* Nuevos Parámetros	: <\PM  @lcTipoIdAfiliado	
                            @lcnm
roidntfccn
                            @fcha_dsde
                            @fcha_hsta
                            @evnto
                            @usro
                            @cnsctvo_ntfccn
							Estados Notificación: CONFIRMADO     ,ACEPTADO
							Estados de Calificación: TRAMITE ARP, ACEPTADO ATEP, ACEPTADO EG
					PM>
* Nuevas Variables	: <\VM  						VM\>
* Fecha Modificación: <\FM  03/08/2010				FM\>
*-----------------------------------------------------------------------------------------------------------------------------------
*/ -- exec spWEBConsultaATEP 'CC','16278373','20000101','20100802',null,null
--exec spWEBConsultaATEP 'CC','6436794','20000101','20110202',null,null
--16617322
CREATE  PROCEDURE [dbo].[spWEBConsultaATEP]
(
 	@lcTipoIdAfiliado 	varchar(3)  	= NULL, 
	@lcnmroidntfccn	varchar(23) 	= NULL, 	--udtNumeroIdentificacion,
	@fcha_dsde	datetime		= NULL,   -- fecha desde puede ser vacia cuando se requieren todos los ateps vigentes
    @fcha_hsta  datetime		= NULL,  -- fecha hasta puede ser vacia cuando se requieren todos los ateps vigentes
    @evnto  int      = null,  -- si es 4 Accidente de Trabajo o 5 Enfermedad Profesional, si se va a consultar por los dos se envia vacio
    @usro   char(10),
    @cnsctvo_ntfccn int =null, -- campo que se utiliza solo cuando se consulta por consecutivo de notificacion
    @cdgo_ofcna_ntfccn char(5) =null -- campo que se utiliza solo cuando se consulta por consecutivo de notificacion y codgio de oficina

--select * from tbclasificacioneventosnotificacion
)
AS

SET NOCOUNT ON
--declare @fechaActual datetime
declare @cnsctvo_cdgo_ofcna int

	declare @tmpWebatep table(
       prmr_aplldo char(50),
       sgndo_aplldo       char(50),
       prmr_nmbre          char(20),
       sgndo_nmbre         char(20),
       fcha_ntfccn         datetime,
       cnsctvo_cdgo_cntngnca int,
       dscrpcn_cntngnca  varchar(150),
       cnsctvo_ntfccn      int,
       cnsctvo_cdgo_ofcna  int,
       tne_soat            varchar(1),
       cnsctvo_cdgo_ltrldd int,
       dscrpcn_ltrldd      varchar(150),
       cdgo_ltrldd         varchar(2),
       fcha_acptcn         datetime,
       cnsctvo_cdgo_estdo_ntfccn int,
       dscrpcn_estdo_ntfccn    varchar(150),
       cnsctvo_cdgo_entdd_arp  int,
       dscrpcn_arp    varchar(250),
       fcha_estdo_ntfccn   datetime,
       fcha_ultma_mdfccn   datetime,
       cnsctvo_cdgo_estdo_clfccn int,
       dscrpcn_estdo_clfccn     varchar(150),
       fcha_estdo_clfccn    datetime ,
       cdgo_ofcna         varchar(5),
       cnsctvo_cdgo_clsfccn_evnto int,
       dscrpcn_clsfccn_evnto  varchar(150),
       cnsctvo_cdgo_dgnstco  int,
       cdgo_dgnstco      varchar(5),
       dscrpcn_dgnstco      varchar(150)
	)

if @cdgo_ofcna_ntfccn is not null
	select @cnsctvo_cdgo_ofcna=@cnsctvo_cdgo_ofcna from bdafiliacionvalidador..tboficinas 
	where cdgo_ofcna=@cdgo_ofcna_ntfccn



 insert into @tmpWebatep (prmr_aplldo,sgndo_aplldo,prmr_nmbre,sgndo_nmbre,fcha_ntfccn,
             cnsctvo_cdgo_cntngnca,cnsctvo_ntfccn,cnsctvo_cdgo_ofcna,
             cnsctvo_cdgo_ltrldd,fcha_acptcn,cnsctvo_cdgo_estdo_ntfccn,cnsctvo_cdgo_entdd_arp,
             fcha_ultma_mdfccn,cnsctvo_cdgo_estdo_clfccn, cnsctvo_cdgo_clsfccn_evnto, cnsctvo_cdgo_dgnstco)
 select prmr_aplldo,                          sgndo_aplldo,                           prmr_nmbre,
        sgndo_nmbre,                          a.fcha_ntfccn,                          a.cnsctvo_cdgo_cntngnca,
        a.cnsctvo_ntfccn,                     a.cnsctvo_cdgo_ofcna,                   e.cnsctvo_cdgo_ltrldd,
        e.fcha_acptcn,                        a.cnsctvo_cdgo_estdo_ntfccn,            e.cnsctvo_cdgo_entdd_arp, a.fcha_ultma_mdfccn, e.cnsctvo_cdgo_estdo_dgnstco,
        a.cnsctvo_cdgo_clsfccn_evnto,         a.cnsctvo_cdgo_dgnstco
 from  bdIpsTransaccional.dbo.tbafiliadosmarcados a inner join  bdIpsTransaccional.dbo.tbactuanotificacion b               
           on   a.cnsctvo_ntfccn    =  b.cnsctvo_ntfccn                
           and  a.cnsctvo_cdgo_ofcna =  b.cnsctvo_cdgo_ofcna                
       inner join bdIpsTransaccional.dbo.tbatep e   on   
                a.cnsctvo_ntfccn    =  e.cnsctvo_ntfccn                
           and  a.cnsctvo_cdgo_ofcna =  e.cnsctvo_cdgo_ofcna                
       inner join bdafiliacionvalidador..tbtiposidentificacion d on
                b.cnsctvo_cdgo_tpo_idntfccn=d.cnsctvo_cdgo_tpo_idntfccn
  where  (d.cdgo_tpo_idntfccn = @lcTipoIdAfiliado    or @lcTipoIdAfiliado is null)          
      and (b.nmro_idntfccn     = @lcnmroidntfccn     or @lcnmroidntfccn is null)        
      and a.cnsctvo_cdgo_estdo_ntfccn in (7,11,130,131)  -- confirmado, cerrado, aceptado
      and e.cnsctvo_cdgo_estdo_dgnstco in (3,10,9)  --  TRAMITE ARP, ACEPTADO ATEP, ACEPTADO EG
      and ((@evnto=4  and a.cnsctvo_cdgo_clsfccn_evnto=4  ) or  --4 accidente de trabajo
      (@evnto=5  and a.cnsctvo_cdgo_clsfccn_evnto=5 ) or @evnto is null)  -- 5 enfermedad profesional
      and (a.fcha_ntfccn between @fcha_dsde and @fcha_hsta or @fcha_dsde is null or @fcha_hsta is null)
      and (a.cnsctvo_ntfccn=@cnsctvo_ntfccn or @cnsctvo_ntfccn is null)
      and (a.cnsctvo_cdgo_ofcna=@cnsctvo_cdgo_ofcna or @cnsctvo_cdgo_ofcna is null) 


-- select * from tbestadosnotificacion_vigencias where cnsctvo_cdgo_clsfccn_evnto_ntfccn in (4,5,27)
-- select * from tbclasificacioneventosnotificacion where cnsctvo_cdgo_clsfccn_evnto_ntfccn in (4,5)
update @tmpWebatep set dscrpcn_clsfccn_evnto=b.dscrpcn_clsfccn_evnto
from @tmpWebatep a inner join bdIpsTransaccional.dbo.tbclasificacioneventosnotificacion b           
on a.cnsctvo_cdgo_clsfccn_evnto=b.cnsctvo_cdgo_clsfccn_evnto          

update @tmpWebatep set dscrpcn_dgnstco=b.dscrpcn_dgnstco, cdgo_dgnstco=b.cdgo_dgnstco
from @tmpWebatep a inner join bdIpsTransaccional.dbo.tbdiagnosticos b           
on a.cnsctvo_cdgo_dgnstco=b.cnsctvo_cdgo_dgnstco          


update @tmpWebatep set dscrpcn_estdo_ntfccn=b.dscrpcn_estdo_ntfccn          
from @tmpWebatep a inner join bdIpsTransaccional.dbo.tbestadosnotificacion b           
on a.cnsctvo_cdgo_estdo_ntfccn=b.cnsctvo_cdgo_estdo_ntfccn          

update @tmpWebatep set dscrpcn_ltrldd=b.dscrpcn_ltrldd, cdgo_ltrldd=b.cdgo_ltrldd
from @tmpWebatep a inner join bdIpsTransaccional.dbo.tblateralidades b           
on a.cnsctvo_cdgo_ltrldd=b.cnsctvo_cdgo_ltrldd          

update @tmpWebatep set dscrpcn_cntngnca=b.dscrpcn_cntngnca          
from @tmpWebatep a inner join bdIpsTransaccional.dbo.tbcontingencias b           
on a.cnsctvo_cdgo_cntngnca=b.cnsctvo_cdgo_cntngnca          


update @tmpWebatep set fcha_estdo_ntfccn=b.fcha_estdo          
from @tmpWebatep a inner join bdIpsTransaccional.dbo.tbDetalleEstadoNotificacion b           
on a.cnsctvo_ntfccn=b.cnsctvo_ntfccn and
a.cnsctvo_cdgo_ofcna=b.cnsctvo_cdgo_ofcna and
a.cnsctvo_cdgo_estdo_ntfccn=b.cnsctvo_cdgo_estdo_ntfccn          
--select * from tbDetalleEstadoNotificacion

update @tmpWebatep set dscrpcn_arp=b.dscrpcn_cbro_empldr          
from @tmpWebatep a inner join bdIpsTransaccional.dbo.tbcobrosempleador b           
on a.cnsctvo_cdgo_cntngnca=b.cnsctvo_cdgo_cbro_empldr         


update @tmpWebatep set dscrpcn_estdo_clfccn=b.dscrpcn_estdo_dgnstco          
from @tmpWebatep a inner join bdIpsTransaccional.dbo.tbMNEstadoDiagnostico_Vigencias b           
on a.cnsctvo_cdgo_estdo_clfccn=b.cnsctvo_cdgo_estdo_dgnstco          


update @tmpWebatep set cdgo_ofcna=b.cdgo_ofcna         
from @tmpWebatep a inner join bdafiliacionvalidador..tboficinas  b           
on a.cnsctvo_cdgo_ofcna=b.cnsctvo_cdgo_ofcna          


-- el consecutivo de la notificacion esta con la oficina  por el historico de casos
select @lcTipoIdAfiliado cdgo_tpo_idntfccn,@lcnmroidntfccn nmro_idntfccn   ,prmr_aplldo ,       sgndo_aplldo,        prmr_nmbre   ,
       sgndo_nmbre ,       fcha_ntfccn as fcha_evnto,        
       dscrpcn_cntngnca   , isnull(tne_soat,'N') AS tne_soat,            isnull(b.dscrpcn_ltrldd,'NO APLICA') ltrldd ,   
       ltrim(rtrim(convert(char(10),b.cnsctvo_ntfccn)))+'-'+ltrim(rtrim(cdgo_ofcna)) cnsctvo_ntfccn ,isnull(fcha_estdo_ntfccn,b.fcha_ultma_mdfccn) as fcha_estdo_ntfccn,   
       isnull(fcha_acptcn,'')  fcha_acptcn      , 
       dscrpcn_estdo_ntfccn       , isnull(c.cdgo_dgnstco,b.cdgo_dgnstco) as cdgo_dgnstco,
       case  prncpl
       WHEN NULL THEN 'S'            
	   when 1  then 'S' else 'N' end as prncpl , 
       dscrpcn_arp  ,
       dscrpcn_estdo_clfccn   , fcha_estdo_clfccn,
       isnull(c.dscrpcn_dgnstco,b.dscrpcn_dgnstco) as dscrpcn_dgnstco, dscrpcn_clsfccn_evnto
from   @tmpWebatep b left outer join bdIpsTransaccional.dbo.tbDetalleDiagnosticoNotificacion a
  on   a.cnsctvo_ntfccn    =  b.cnsctvo_ntfccn                
  and  a.cnsctvo_cdgo_ofcna =  b.cnsctvo_cdgo_ofcna  
  left outer join bdIpsTransaccional.dbo.tbdiagnosticos c on 
  a.cnsctvo_cdgo_dgnstco=c.cnsctvo_cdgo_dgnstco 
where b.dscrpcn_dgnstco is not null or c.dscrpcn_dgnstco is not null


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spWEBConsultaATEP] TO [webusr]
    AS [dbo];

