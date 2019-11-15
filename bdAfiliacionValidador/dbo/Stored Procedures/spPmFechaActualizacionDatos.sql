


/*---------------------------------------------------------------------------------------------------------------------------------------
* Procedimiento			: spPmConsultaAfiliado 
* Desarrollado por		: <\A Ing. Samuel Muñoz							A\>
* Descripción			: <\D									D\>
* Observaciones			: <\O									O\>
* Parámetros			: <\P  									P\>
* Variables			: <\V  									V\>
* Fecha Creación		: <\FC 2003/00/00  							FC\>
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
CREATE procedure  spPmFechaActualizacionDatos
@lfFechaReferencia		varchar(10) output
AS
Set dateformat ymd

Declare
@f	datetime
Set @f = Cast(0 as datetime)
Select	@f = Max(fcha_cntrl)
From	tbControlTransmision
Where	estdo		= 1
And	nmbre_tbla	Is Null

Select	@lfFechaReferencia = convert(varchar(10),@f,111)





GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmFechaActualizacionDatos] TO [310014 Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmFechaActualizacionDatos] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmFechaActualizacionDatos] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmFechaActualizacionDatos] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmFechaActualizacionDatos] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmFechaActualizacionDatos] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmFechaActualizacionDatos] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmFechaActualizacionDatos] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmFechaActualizacionDatos] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmFechaActualizacionDatos] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmFechaActualizacionDatos] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmFechaActualizacionDatos] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmFechaActualizacionDatos] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmFechaActualizacionDatos] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmFechaActualizacionDatos] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmFechaActualizacionDatos] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmFechaActualizacionDatos] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmFechaActualizacionDatos] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmFechaActualizacionDatos] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmFechaActualizacionDatos] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmFechaActualizacionDatos] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmFechaActualizacionDatos] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmFechaActualizacionDatos] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

