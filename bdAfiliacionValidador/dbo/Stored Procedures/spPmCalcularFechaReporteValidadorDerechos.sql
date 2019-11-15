/*---------------------------------------------------------------------------------------------------------------------------------------
* Procedimiento			: spPmCalcularFechaReporteValidadorDerechos 
* Desarrollado por		: <\A Ing. AlvAro Zapata						A\>
* Descripción			: <\D									D\>
* Observaciones			: <\O									O\>
* Parámetros			: <\P  									P\>
* Variables			: <\V  									V\>
* Fecha Creación		: <\FC 2006/02/25  							FC\>
*
*---------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------------------------------------------------------------
* Modificado Por			: <\AM 				*					AM\>
* Descripción			: <\DM									DM\>
* 				: <\DM									DM\>
* Nuevos Parámetros		: <\PM  							>
* Nuevas Variables		: <\VM  									VM\>
* Fecha Modificación		: <\FM									FM\>
*-----------------------------------------------------------------------------------------------------------------------------------*/
CREATE	procedure spPmCalcularFechaReporteValidadorDerechos
As
Set Nocount ON

Declare
@fcha_vldccn		datetime,
@fcha_mxma_rprte	datetime


Set @fcha_vldccn = getDate()

Select @fcha_mxma_rprte = bdAfiliacionValidador.dbo.fnCalcularFechaReporteValidadorDerechos(@fcha_vldccn)

select	@fcha_mxma_rprte as fcha_mxma_rprte


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Inteligencia]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmCalcularFechaReporteValidadorDerechos] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];

