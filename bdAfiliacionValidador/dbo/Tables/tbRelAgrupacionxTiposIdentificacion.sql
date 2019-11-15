CREATE TABLE [dbo].[tbRelAgrupacionxTiposIdentificacion] (
    [cnsctvo_agrpcn_tpo_idntfccn]      [dbo].[udtConsecutivo] NOT NULL,
    [fcha_crcn]                        DATETIME               NOT NULL,
    [usro_crcn]                        [dbo].[udtUsuario]     NOT NULL,
    [cnsctvo_cdgo_agrpdr_tpo_idntfccn] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_tpo_idntfccn]        [dbo].[udtConsecutivo] NOT NULL,
    CONSTRAINT [PK_tbRelAgrupacionxTiposIdentificacion] PRIMARY KEY CLUSTERED ([cnsctvo_agrpcn_tpo_idntfccn] ASC)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Desarrollo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxTiposIdentificacion] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];

