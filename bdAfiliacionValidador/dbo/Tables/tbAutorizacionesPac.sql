CREATE TABLE [dbo].[tbAutorizacionesPac] (
    [nmro_atrzcn]               NUMERIC (18)           NOT NULL,
    [nmro_idntfccn_usro]        VARCHAR (20)           NOT NULL,
    [cnsctvo_usro]              INT                    NOT NULL,
    [fcha_atrzcn]               DATETIME               NOT NULL,
    [autrzcn_espcl]             CHAR (1)               NULL,
    [cdgo_pln]                  CHAR (3)               NULL,
    [estdo]                     INT                    NULL,
    [nmro_unco_idntfccn_bnfcro] [dbo].[udtConsecutivo] NULL,
    [cnsctvo_cdgo_pln]          [dbo].[udtConsecutivo] NULL,
    [tpo_srvco]                 INT                    NULL,
    [nmro_idntfccn_prstdr]      VARCHAR (20)           NULL,
    [cnsctvo]                   [dbo].[udtConsecutivo] IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    CONSTRAINT [PK_tbAutorizacionesPac] PRIMARY KEY CLUSTERED ([cnsctvo] ASC)
);


GO
CREATE STATISTICS [tpo_srvco]
    ON [dbo].[tbAutorizacionesPac]([tpo_srvco]);


GO
CREATE STATISTICS [nmro_idntfccn_prstdr]
    ON [dbo].[tbAutorizacionesPac]([nmro_idntfccn_prstdr]);


GO
DENY DELETE
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO PUBLIC
    AS [dbo];


GO
DENY INSERT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO PUBLIC
    AS [dbo];


GO
DENY SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO PUBLIC
    AS [dbo];


GO
DENY UPDATE
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO PUBLIC
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Analistas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [330004 Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [330004 Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [330001 Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [330001 Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [330007 Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [330007 Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Consultor Administrativo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [outbts01]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [SOS\330008 Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [SOS\330008 Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Autorizadora Notificacion]
    AS [dbo];


GO
DENY DELETE
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Audiorespuesta]
    AS [dbo];


GO
DENY UPDATE
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Consultor Administrador]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAutorizacionesPac] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];

