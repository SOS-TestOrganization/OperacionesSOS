




/*---------------------------------------------------------------------------------

* Metodo o PRG                 :   spCUbuscavalidacionCaja

* Desarrollado por   :  <\A   Cesar Garcia   A\>

* Descripcion    :  <\D Muetra la información básica del afiliado encontrado en las Base de Datos bdPrestamedicas y bdCuentasMedicas   D\>

* Descripcion    :  <\D       D\>

* Observaciones                :  <\O     O\>

* Parametros    :  <\P        P\>

                                   :  <\P                      P\>

                                                      :  <\P        P\>

* Variables    :  <\V     V\>

* Fecha Creacion   :  <\FC 20040125               FC\>

*  

*---------------------------------------------------------------------------------

* DATOS DE MODIFICACION 

*---------------------------------------------------------------------------------  

* Modificado Por                : <\AM   AM\>

* Descripcion    : <\DM   DM\>

* Nuevos Parametros    : <\PM   PM\>

* Nuevas Variables   : <\VM   VM\>

* Fecha Modificacion   : <\FM   FM\>

*---------------------------------------------------------------------------------*/

Create Procedure [dbo].[spCUbuscavalidacionCaja]

@lcCodigoOficina char(5),

@NumeroVerificacion numeric

--@lnTipoId  udtTipoIdentificacion,

--@lnNumeroId  varchar(20)



AS





/*

Declare

@lcCodigoOficina char(5),

@NumeroVerificacion numeric



Set @lcCodigoOficina  = '01'

Set @NumeroVerificacion  = 1548

--Set @lnTipoId   = 1

--Set @lnNumeroId   = '66914487'

*/

  



Set Nocount On





Create Table #tmpLog

 (

  tpo_idntfccn_aprtnte char(150),

  nmro_idntfccn_aprtnte  udtNumeroIdentificacionLargo,

  rzn_scl    varchar(200),

  prmr_aplldo   char(50),

  sgndo_aplldo   char(50),

  prmr_nmbre   char(15),

  sgndo_nmbre   char(15),        

  edd    Int,

  dscrpcn_tpo_undd  udtDescripcion,

  Sexo    udtCodigo,

  dscrpcn_prntsco   udtDescripcion,

  dscrpcn_rngo_slrl  udtDescripcion,

  dscrpcn_pln   udtDescripcion,

  dscrpcn_pln_cmplmntro  udtDescripcion, 

  inco_vgnca_bnfcro  Datetime,

  fn_vgnca_bnfcro   Datetime,

  smns_ctzds_ss_ps  Int,

  smns_ctzds_eps_ps  Int,

  smns_ctzds_ss_pc  Int,

  smns_ctzds_eps_pc  Int,

  dscrpcn_ips_prmra  char(100),

  estdo_afldo   char(150),

  dscrpcn_tpo_afldo  char(100),

  fcha_vldcn   Datetime,

  drcho    udtDescripcion,  

  nmro_vrfccn   numeric,   

  cnsctvo_cdgo_tpo_afldo  udtConsecutivo,

  cnsctvo_cdgo_sxo  udtConsecutivo,

  cnsctvo_cdgo_tpo_idntfccn udtConsecutivo,

  nmro_idntfccn   varchar(20),

  cnsctvo_cdgo_prntscs  udtConsecutivo,

  cnsctvo_cdgo_rngo_slrl  udtConsecutivo,

  cnsctvo_cdgo_pln  udtConsecutivo,

  cdgo_ips_prmra   char(8),

  cnsctvo_cdgo_pln_pc  udtConsecutivo,

  cnsctvo_cdgo_estdo_afldo udtConsecutivo,

  cnsctvo_cdgo_tpo_undd  udtConsecutivo,

  cnsctvo_cdgo_ofcna  udtConsecutivo,

  cnsctvo_cdgo_tpo_cntrto udtConsecutivo,

  nmro_cntrto   udtNumeroFormulario,

  nmro_unco_idntfccn_aprtnte udtConsecutivo,

  tpo_idntfccn   char(3),

  orgn    char(1),

  cnsctvo_cdgo_sde  udtConsecutivo,

  dscrpcn_sde_ips_prmra  Char(150)   

 )

Declare

@lcCodigoOficinaReal udtconsecutivo

select @lcCodigoOficinaReal  = cnsctvo_cdgo_ofcna

From bdAfiliacionValidador.dbo.tbOficinas

Where cdgo_ofcna   = @lcCodigoOficina





---Información tomada de la tabla tblog base de datos Prestamedicas

Insert Into #tmpLog  (nmro_idntfccn_aprtnte,  rzn_scl,    prmr_aplldo,   sgndo_aplldo,  prmr_nmbre,  sgndo_nmbre,

   edd,    inco_vgnca_bnfcro,  fn_vgnca_bnfcro,  smns_ctzds_ss_ps,

   smns_ctzds_eps_ps,  smns_ctzds_ss_pc,  smns_ctzds_eps_pc,  fcha_vldcn,  drcho, nmro_vrfccn,

   cnsctvo_cdgo_tpo_afldo,  cnsctvo_cdgo_sxo,  cnsctvo_cdgo_tpo_idntfccn, nmro_idntfccn,  cnsctvo_cdgo_prntscs,

   cnsctvo_cdgo_rngo_slrl,  cnsctvo_cdgo_pln,  cdgo_ips_prmra,   cnsctvo_cdgo_pln_pc, cnsctvo_cdgo_estdo_afldo,

   cnsctvo_cdgo_tpo_undd,  cnsctvo_cdgo_ofcna,  cnsctvo_cdgo_tpo_cntrto, nmro_cntrto,  nmro_unco_idntfccn_aprtnte,

   orgn

   )

select a.nmro_idntfccn_aprtnte,  a.rzn_scl,    a.prmr_aplldo,    a.sgndo_aplldo,    a.prmr_nmbre,  a.sgndo_nmbre,

 a.edd,     a.inco_vgnca_bnfcro,   a.fn_vgnca_bnfcro,    0 as smns_ctzds_ss_ps,

 a.ds_ctzds as smns_ctzds_eps_ps, 0 as smns_ctzds_ss_pc,   a.ds_ctzds_pc as smns_ctzds_eps_pc,

 a.fcha_vldcn,    a.drcho,     a.nmro_vrfccn,    a.cnsctvo_cdgo_tpo_afldo,

 a.cnsctvo_cdgo_sxo,   a.cnsctvo_cdgo_tpo_idntfccn,  a.nmro_idntfccn, a.cnsctvo_cdgo_prntscs,

 a.cnsctvo_cdgo_rngo_slrl,  a.cnsctvo_cdgo_pln,   a.cdgo_ips_prmra,   a.cnsctvo_cdgo_pln_pc,

 a.cnsctvo_cdgo_estdo_afldo,  a.cnsctvo_cdgo_tpo_undd,  a.cnsctvo_cdgo_ofcna,   a.cnsctvo_cdgo_tpo_cntrto,  a.nmro_cntrto,  a.nmro_unco_idntfccn_aprtnte,

 a.orgn



--from  [Newton].bdPrestaMedicas.dbo.tblog a   --(index=IX_Nmro_idntfccn) 

from  bdSisalud.dbo.tblog a   --(index=IX_Nmro_idntfccn) 

Where ((a.nmro_vrfccn    = @NumeroVerificacion and  a.cnsctvo_cdgo_ofcna = @lcCodigoOficinaReal) Or  (@NumeroVerificacion Is Null and @lcCodigoOficinaReal is null))

--And (a.cnsctvo_cdgo_tpo_idntfccn  = @lnTipoId   Or @lnTipoId   Is Null)

--And (a.nmro_idntfccn   = @lnNumeroId   Or @lnNumeroId   Is Null)



--Se comentare este código ya que con la nueva estructura de salud solo existirá una tabla tbLog (confirmados por maria Fernanada Giraldo)



---Información de la tomada de la tabla tblog base de datos bdCuentasMedicas

Insert Into #tmpLog  (nmro_idntfccn_aprtnte,  rzn_scl,   prmr_aplldo,   sgndo_aplldo,  prmr_nmbre,  sgndo_nmbre,

   edd,    inco_vgnca_bnfcro, fn_vgnca_bnfcro,  smns_ctzds_ss_ps,

   smns_ctzds_eps_ps,  smns_ctzds_ss_pc, smns_ctzds_eps_pc,  fcha_vldcn,  drcho, nmro_vrfccn,

   cnsctvo_cdgo_tpo_afldo, cnsctvo_cdgo_sxo, cnsctvo_cdgo_tpo_idntfccn, nmro_idntfccn,  cnsctvo_cdgo_prntscs,

   cnsctvo_cdgo_rngo_slrl,  cnsctvo_cdgo_pln, cdgo_ips_prmra,   cnsctvo_cdgo_pln_pc, cnsctvo_cdgo_estdo_afldo,

   cnsctvo_cdgo_tpo_undd, cnsctvo_cdgo_ofcna, cnsctvo_cdgo_tpo_cntrto, nmro_cntrto,  nmro_unco_idntfccn_aprtnte,

   orgn

   )

select a.nmro_idntfccn_aprtnte,   a.rzn_scl,    a.prmr_aplldo,    a.sgndo_aplldo, a.prmr_nmbre,  a.sgndo_nmbre,

 a.edd,     a.inco_vgnca_bnfcro,   a.fn_vgnca_bnfcro,    0 as smns_ctzds_ss_ps,

 a.ds_ctzds as smns_ctzds_eps_ps, 0 as smns_ctzds_ss_pc,   a.ds_ctzds_pc as smns_ctzds_eps_pc,

 a.fcha_vldcn,    a.drcho,     a.nmro_vrfccn,    a.cnsctvo_cdgo_tpo_afldo,

 a.cnsctvo_cdgo_sxo,   a.cnsctvo_cdgo_tpo_idntfccn,  a.nmro_idntfccn,    a.cnsctvo_cdgo_prntscs,

 a.cnsctvo_cdgo_rngo_slrl,  a.cnsctvo_cdgo_pln,   a.cdgo_ips_prmra,   a.cnsctvo_cdgo_pln_pc,

 a.cnsctvo_cdgo_estdo_afldo,  a.cnsctvo_cdgo_tpo_undd,  a.cnsctvo_cdgo_ofcna,   a.cnsctvo_cdgo_tpo_cntrto,  a.nmro_cntrto,  a.nmro_unco_idntfccn_aprtnte,

 a.orgn

from  bdSiSalud.dbo.tblog_cuentas a --(index=IX_Nmro_idntfccn)

Where ((a.nmro_vrfccn    = @NumeroVerificacion and  a.cnsctvo_cdgo_ofcna = @lcCodigoOficinaReal) Or  (@NumeroVerificacion Is Null and @lcCodigoOficinaReal is null))

--And (a.cnsctvo_cdgo_tpo_idntfccn  = @lnTipoId   Or @lnTipoId   Is Null)

--And (a.nmro_idntfccn   = @lnNumeroId   Or @lnNumeroId   Is Null)









Update #tmpLog

Set tpo_idntfccn   = b.cdgo_tpo_idntfccn

From bdAfiliacionValidador.dbo.tbTiposIdentificacion b, #tmpLog a

Where a.cnsctvo_cdgo_tpo_idntfccn = b.cnsctvo_cdgo_tpo_idntfccn



--Muestra el Parentesco

Update #tmpLog

Set dscrpcn_prntsco   = b.dscrpcn_prntsco

From bdAfiliacionValidador.dbo.tbParentescos b, #tmpLog a

Where b.cnsctvo_cdgo_prntscs  = a.cnsctvo_cdgo_prntscs



Update #tmpLog

Set estdo_afldo   = b.dscrpcn_estdo_drcho

From bdAfiliacionValidador.dbo.tbEstadosDerechoValidador b, #tmpLog a

Where a.cnsctvo_cdgo_estdo_afldo = b.cnsctvo_cdgo_estdo_drcho



Update #tmpLog

Set dscrpcn_pln   = b.dscrpcn_pln

From bdAfiliacionValidador.dbo.tbPlanes b, #tmpLog a

Where a.cnsctvo_cdgo_pln  = b.cnsctvo_cdgo_pln





update  #tmpLog

set  dscrpcn_ips_prmra   = a.nmbre_scrsl,

 cnsctvo_cdgo_sde  = a.cnsctvo_cdgo_sde  

from  bdSisalud.dbo.tbDireccionesPrestador a

where  #tmpLog.cdgo_ips_prmra   = a.cdgo_intrno COLLATE SQL_Latin1_General_CP1_CI_AS



Update  #tmpLog

Set dscrpcn_sde_ips_prmra = b.dscrpcn_sde

From bdAfiliacionValidador.dbo.tbSedes b,  #tmpLog a

Where a.cnsctvo_cdgo_sde = b.cnsctvo_cdgo_sde 



/*

update  #tmpLog

set  dscrpcn_pln_cmplmntro = a.dscrpcn_pln

from  bdplanbeneficios.dbo.tbplanes  a

where  #tmpLog.cnsctvo_cdgo_pln_pc = a.cnsctvo_cdgo_pln

*/



update  #tmpLog

set  dscrpcn_tpo_undd = a.dscrpcn_tpo_undd

from  bdAfiliacionValidador.dbo.tbTiposUnidades  a

where  #tmpLog.cnsctvo_cdgo_tpo_undd = a.cnsctvo_cdgo_tpo_undd



-- Muestra el tipo de afiliado

update  #tmpLog

set  dscrpcn_tpo_afldo = a.dscrpcn

from  bdAfiliacionValidador.dbo.tbTiposAfiliado  a

where  #tmpLog.cnsctvo_cdgo_tpo_afldo = a.cnsctvo_cdgo_tpo_afldo



update  #tmpLog

set  Sexo = a.cdgo_sxo

from  bdAfiliacionValidador.dbo.tbSexos  a

where  #tmpLog.cnsctvo_cdgo_sxo = a.cnsctvo_cdgo_sxo



update  #tmpLog

set  dscrpcn_rngo_slrl = a.dscrpcn_rngo_slrl

from  bdAfiliacionValidador.dbo.tbRangosSalariales  a

where  #tmpLog.cnsctvo_cdgo_rngo_slrl = a.cnsctvo_cdgo_rngo_slrl





select  * from #tmpLog

Drop table #tmpLog



----------------------------------------------------------------------------





set ANSI_NULLS ON

set QUOTED_IDENTIFIER ON


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscavalidacionCaja] TO [310010 Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscavalidacionCaja] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscavalidacionCaja] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscavalidacionCaja] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscavalidacionCaja] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscavalidacionCaja] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscavalidacionCaja] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscavalidacionCaja] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscavalidacionCaja] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscavalidacionCaja] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscavalidacionCaja] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscavalidacionCaja] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscavalidacionCaja] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscavalidacionCaja] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUbuscavalidacionCaja] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

