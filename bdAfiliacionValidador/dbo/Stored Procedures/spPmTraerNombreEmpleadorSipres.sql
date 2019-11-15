/*---------------------------------------------------------------------------------
* Metodo o PRG : spPmTraerNombreEmpleador
* Desarrollado por : <\A Ing. Maria Liliana Prieto A\>
* Descripcion : <\D Este procedimiento realiza una busqueda de un empleador en la estructura definitiva de empresa. D\>
* Observaciones : <\O O\>
* Parametros : <\P Consecutivo tipo Identificacion Empresa P\>
<\P Numero Identificacion Empresa P\>
<\P Clase empleador P\>
<\P Descripcion P\>
<\P Digito Verficacion P\>
<\P Numero Unico de Identificacion P\>
* Variables : <\V V\>
* Fecha Creacion : <\FC 2002/07/02 FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por : <\AM Rolando Simbaqueva LassoAM\>
* Descripcion : <\DM DM\>
* Nuevos Parametros : <\PM PM\>
* Nuevas Variables : <\VM VM\>
* Fecha Modificacion : <\FM 2002/09/10 FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[spPmTraerNombreEmpleadorSipres]
@lcConsecutivoTipoIdentificacion UdtConsecutivo = Null,
@lnNumeroIdentificacion UdtNumeroIdentificacion = Null,
@lcDescripcion Varchar(200) = Null
As
Set Nocount On
-- Inicializacion de variables
Declare
@lnDigitoVerificacion Int,
@lnNui UdtConsecutivo,
@lcCodigoActividadEconomica Char(4),
@lcCodigoClaseEmpleador UdtCodigo
Select @lnDigitoVerificacion = NULL,
@lnNui = NULL
--Sp_help tbTiposIdentificacion
Declare @empleador table(
cdgo_tpo_idntfccn_empldr char(3),
nmro_idntfccn_empldr varchar(23),
rzn_scl varchar(200),
cnsctvo_cdgo_tpo_idntfccn_empldr int,
cnsctvo_cdgo_actvdd_ecnmca int,
dgto_vrfccn int,
nmro_unco_idntfccn_aprtnte int,
cdgo_actvdd_ecnmca char(4) ,
dscrpcn_actvdd_ecnmca CHAR(150)
)
If @lnNumeroIdentificacion is Not Null
Begin
insert Into @empleador(
nmro_idntfccn_empldr,
cnsctvo_cdgo_tpo_idntfccn_empldr,
cnsctvo_cdgo_actvdd_ecnmca,
dgto_vrfccn,
nmro_unco_idntfccn_aprtnte,
rzn_scl,
cdgo_actvdd_ecnmca ,
dscrpcn_actvdd_ecnmca
)
Select a.nmro_idntfccn_empldr,a.cnsctvo_cdgo_tpo_idntfccn_empldr,a.cnsctvo_cdgo_actvdd_ecnmca,
BdSisalud.dbo.fnCalcularDigitoVerificacion(a.nmro_idntfccn_empldr) as dgto_vrfccn,
a.nmro_unco_idntfccn_aprtnte, a.rzn_scl, e.cdgo_actvdd_ecnmca, E.dscrpcn_actvdd_ecnmca--,cnsctvo_cdgo_tpo_emprsa
From dbo.tbAportanteValidador a,dbo.tbActividadesEconomicas e
Where a.cnsctvo_cdgo_tpo_idntfccn_empldr = @lcConsecutivoTipoIdentificacion
And a.nmro_idntfccn_empldr = @lnNumeroIdentificacion
And a.cnsctvo_cdgo_actvdd_ecnmca = e.cnsctvo_cdgo_actvdd_ecnmca
End
Else
Begin
insert Into @empleador(
nmro_idntfccn_empldr,
cnsctvo_cdgo_tpo_idntfccn_empldr,
cnsctvo_cdgo_actvdd_ecnmca,
dgto_vrfccn,
nmro_unco_idntfccn_aprtnte,
rzn_scl,
cdgo_actvdd_ecnmca ,
dscrpcn_actvdd_ecnmca
)
Select a.nmro_idntfccn_empldr,a.cnsctvo_cdgo_tpo_idntfccn_empldr,a.cnsctvo_cdgo_actvdd_ecnmca,
BdSisalud.dbo.fnCalcularDigitoVerificacion(a.nmro_idntfccn_empldr) as dgto_vrfccn,
a.nmro_unco_idntfccn_aprtnte, a.rzn_scl, e.cdgo_actvdd_ecnmca, E.dscrpcn_actvdd_ecnmca--,cnsctvo_cdgo_tpo_emprsa
From dbo.tbAportanteValidador a inner Join dbo.tbActividadesEconomicas e
On a.cnsctvo_cdgo_actvdd_ecnmca = e.cnsctvo_cdgo_actvdd_ecnmca
Where a.rzn_scl like '%' + @lcDescripcion + '%'
End
Update @empleador
Set cdgo_tpo_idntfccn_empldr = i.cdgo_tpo_idntfccn
From @empleador e, tbTiposIdentificacion i
Where i.cnsctvo_cdgo_tpo_idntfccn = e.cnsctvo_cdgo_tpo_idntfccn_empldr
Select *
from @empleador

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleadorSipres] TO [310004 Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleadorSipres] TO [310001 Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleadorSipres] TO [310010 Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleadorSipres] TO [pe_soa]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleadorSipres] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleadorSipres] TO [Atep_Soa]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleadorSipres] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleadorSipres] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleadorSipres] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleadorSipres] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleadorSipres] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleadorSipres] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleadorSipres] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleadorSipres] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleadorSipres] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleadorSipres] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleadorSipres] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleadorSipres] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleadorSipres] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleadorSipres] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleadorSipres] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleadorSipres] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleadorSipres] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleadorSipres] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleadorSipres] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleadorSipres] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

