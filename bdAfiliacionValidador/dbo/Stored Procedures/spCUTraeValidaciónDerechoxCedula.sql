


/*---------------------------------------------------------------------------------

* Metodo o PRG                 :   spCUTraeValidaci¢nDerechoxCedula

* Desarrollado por   :  <\A   Alvaro Zapata   A\>

* Descripcion    :  <\D    D\>

* Descripcion    :  <\D       D\>

* Observaciones                :  <\O     O\>

* Parametros    :  <\P        P\>

                                   :  <\P                      P\>

                                                      :  <\P        P\>

* Variables    :  <\V     V\>

* Fecha Creacion   :  <\FC 20040124               FC\>

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

Create Procedure [dbo].[spCUTraeValidaciónDerechoxCedula]

@lnTipoId  udtTipoIdentificacion,

@lnNumeroId  varchar(20)



As   



Set Nocount On



/*

--spCUTraeValidaci¢nDerechoxCedula

declare

@lnTipoId  udtTipoIdentificacion,

@lnNumeroId  varchar(20)



Set @lnTipoId   = 1

Set @lnNumeroId   = '66914487'

*/



SELECT     Convert(char(10), a.nmro_vrfccn)  nmro_vrfccn, b.dscrpcn_ofcna, a.fcha_vldcn, a.nmro_cntrto, ltrim(rtrim(Isnull(a.prmr_aplldo,'')))+' '+ltrim(rtrim(Isnull(a.sgndo_aplldo,'')))+' '+ltrim(rtrim(Isnull(a.prmr_nmbre,'')))+' '+ltrim(rtrim(Isnull(a.sgndo_nmbre,''))) as afldo,

  b.cdgo_ofcna

FROM         bdSisalud.dbo.tblog a INNER JOIN

             bdAfiliacionValidador.dbo.tbOficinas b ON a.cnsctvo_cdgo_ofcna = b.cnsctvo_cdgo_ofcna

WHERE     (a.cnsctvo_cdgo_tpo_idntfccn = @lnTipoId) AND (a.nmro_idntfccn = @lnNumeroId)



UNION



SELECT     Convert(char(10), a.nmro_vrfccn)  nmro_vrfccn, b.dscrpcn_ofcna, a.fcha_vldcn, a.nmro_cntrto,ltrim(rtrim(Isnull(a.prmr_aplldo,'')))+' '+ltrim(rtrim(Isnull(a.sgndo_aplldo,'')))+' '+ltrim(rtrim(Isnull(a.prmr_nmbre,'')))+' '+ltrim(rtrim(Isnull(a.sgndo_nmbre,''))) as afldo,

  b.cdgo_ofcna

FROM         bdSiSalud.dbo.tblog_cuentas a INNER JOIN

             bdAfiliacionValidador.dbo.tbOficinas b ON a.cnsctvo_cdgo_ofcna = b.cnsctvo_cdgo_ofcna

WHERE     (a.cnsctvo_cdgo_tpo_idntfccn = @lnTipoId) AND (a.nmro_idntfccn = @lnNumeroId)















GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTraeValidaciónDerechoxCedula] TO [900011 Consultor Administrador]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTraeValidaciónDerechoxCedula] TO [310010 Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTraeValidaciónDerechoxCedula] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTraeValidaciónDerechoxCedula] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTraeValidaciónDerechoxCedula] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTraeValidaciónDerechoxCedula] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTraeValidaciónDerechoxCedula] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTraeValidaciónDerechoxCedula] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTraeValidaciónDerechoxCedula] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTraeValidaciónDerechoxCedula] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTraeValidaciónDerechoxCedula] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTraeValidaciónDerechoxCedula] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTraeValidaciónDerechoxCedula] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTraeValidaciónDerechoxCedula] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTraeValidaciónDerechoxCedula] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTraeValidaciónDerechoxCedula] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

