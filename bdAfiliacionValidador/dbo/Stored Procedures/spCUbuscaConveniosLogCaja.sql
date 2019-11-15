





/*---------------------------------------------------------------------------------

* Metodo o PRG                 :   spCUbuscaConveniosLogCaja

* Desarrollado por   :  <\A   Cesar García   A\>

* Descripcion    :  <\D    D\>

* Descripcion    :  <\D       D\>

* Observaciones                :  <\O     O\>

* Parametros    :  <\P        P\>

                                   :  <\P                      P\>

                                                      :  <\P        P\>

* Variables    :  <\V     V\>

* Fecha Creacion   :  <\FC 20070903               FC\>

*  

*---------------------------------------------------------------------------------

* DATOS DE MODIFICACION 

*---------------------------------------------------------------------------------  

* Modificado Por   : <\AM  Se modifcia para incluir consultas a los convenios AM\>

* Descripcion    : <\DM   DM\>

* Nuevos Parametros    : <\PM   PM\>

* Nuevas Variables   : <\VM   VM\>

* Fecha Modificacion   : <\FM   FM\>

*---------------------------------------------------------------------------------*/

Create Procedure [dbo].[spCUbuscaConveniosLogCaja]

@cnsctvo_cdgo_ofcna  char(5), 

@nmro_vrfccn   numeric



As   



Set Nocount On







/*

Declare

@cnsctvo_cdgo_ofcna  char(5), 

@nmro_vrfccn   numeric



Set @cnsctvo_cdgo_ofcna = '05'

Set @nmro_vrfccn  = 80307



*/





Declare

@lcCodigoOficinaReal udtconsecutivo



select @lcCodigoOficinaReal  = cnsctvo_cdgo_ofcna

From bdAfiliacionValidador.dbo.tbOficinas

Where cdgo_ofcna   = @cnsctvo_cdgo_ofcna





CREATE  Table  #tmpCapitacionLog ( 

dscrpcn_mdlo_cnvno_cptcn UdtDescripcion null, 

cdgo_mdlo_cnvno_cptcn  UdtCodigo null, 

estado    varchar(20) not null, 

capitado   UdtLogico not null, 

fcha_crte   datetime null, 

fcha_dsde   datetime null, 

fcha_hsta   datetime null, 

cnsctvo_cdgo_ips_cptcn  char(8)  NULL , 

dscrpcn_cdd   UdtDescripcion null, 

dscrpcn_ips   UdtDescripcion null,

cnsctvo_cdgo_ofcna  UdtConsecutivo null,

nmro_vrfccn   numeric null,

cnsctvo_cdgo_cdd  UdtConsecutivo null,

cnsctvo_cdgo_cnvno  Numeric null )



insert  into #tmpCapitacionLog 

 (dscrpcn_mdlo_cnvno_cptcn, 

  cdgo_mdlo_cnvno_cptcn,  

  estado, 

  capitado, 

  cnsctvo_cdgo_ips_cptcn, 

  cnsctvo_cdgo_ofcna, 

  nmro_vrfccn,

  cnsctvo_cdgo_cnvno)



Select  c.dscrpcn_mdlo_cnvno_cptcn,

 c.cdgo_mdlo_cnvno_cptcn, 

 CASE WHEN b.estdo_cptcn in(1,2,'S') THEN 'CAPITA' ELSE 'NO CAPITA' END as estado,

 b.estdo_cptcn  as capitado,

 b.cnsctvo_cdgo_ips_cptcn ,

 b.cnsctvo_cdgo_ofcna,

 b.nmro_vrfccn,

 b.cnsctvo_cdgo_cnvno 

from  bdSiSalud.dbo.tbLog a,

  bdSiSalud.dbo.tbConveniosLog b, 

  bdSiSalud.dbo.tbModeloConveniosCapitacion c

where  a.cnsctvo_cdgo_ofcna   = b.cnsctvo_cdgo_ofcna

and a.nmro_vrfccn    = b.nmro_vrfccn

And b.cnsctvo_cdgo_cnvno   = c.cnsctvo_cdgo_mdlo_cnvno_cptcn

And b.cnsctvo_cdgo_ofcna   = @lcCodigoOficinaReal   

and b.nmro_vrfccn    = @nmro_vrfccn  

Union

Select  c.dscrpcn_mdlo_cnvno_cptcn,

 c.cdgo_mdlo_cnvno_cptcn, 

 CASE WHEN b.estdo_cptcn in(1,2,'S') THEN 'CAPITA' ELSE 'NO CAPITA' END as estado,

 b.estdo_cptcn  as capitado,

 b.cnsctvo_cdgo_ips_cptcn ,

 b.cnsctvo_cdgo_ofcna,

 b.nmro_vrfccn,

 b.cnsctvo_cdgo_cnvno 

from  bdSiSalud.dbo.tbLog_cuentas a,

  bdSiSalud.dbo.tbConveniosLog_Cuentas b, 

  bdSiSalud.dbo.tbModeloConveniosCapitacion c

where  a.cnsctvo_cdgo_ofcna   = b.cnsctvo_cdgo_ofcna

and a.nmro_vrfccn    = b.nmro_vrfccn

And b.cnsctvo_cdgo_cnvno   = c.cnsctvo_cdgo_mdlo_cnvno_cptcn

And b.cnsctvo_cdgo_ofcna   = @lcCodigoOficinaReal   

and b.nmro_vrfccn    = @nmro_vrfccn  





IF @@ROWCOUNT = 0

Begin 



 insert into #tmpCapitacionLog ( estado, capitado ) values (  'NO CAPITA', 'N')

End

ELSE

 update  #tmpCapitacionLog 

 set  dscrpcn_ips = a.nmbre_scrsl

 from  bdSisalud.dbo.tbIpsPrimarias_Vigencias  a 

 where  #tmpCapitacionLog.cnsctvo_cdgo_ips_cptcn  = a.cdgo_intrno COLLATE SQL_Latin1_General_CP1_CI_AS



SELECT ISNULL(dscrpcn_mdlo_cnvno_cptcn, '')  as dscrpcn_mdlo_cnvno_cptcn,

        estado,

 ISNULL(dscrpcn_ips,'') as dscrpcn_ips,

      cdgo_mdlo_cnvno_cptcn ,

 cnsctvo_cdgo_ofcna,

 nmro_vrfccn,

 cnsctvo_cdgo_cnvno

FROM #tmpCapitacionLog

drop table #tmpCapitacionLog



-------------------------------------------------------------------------------------------------------------



set ANSI_NULLS ON

set QUOTED_IDENTIFIER ON


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscaConveniosLogCaja] TO [900011 Consultor Administrador]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscaConveniosLogCaja] TO [310010 Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscaConveniosLogCaja] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscaConveniosLogCaja] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscaConveniosLogCaja] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscaConveniosLogCaja] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscaConveniosLogCaja] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscaConveniosLogCaja] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscaConveniosLogCaja] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscaConveniosLogCaja] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscaConveniosLogCaja] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscaConveniosLogCaja] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscaConveniosLogCaja] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscaConveniosLogCaja] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscaConveniosLogCaja] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscaConveniosLogCaja] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

