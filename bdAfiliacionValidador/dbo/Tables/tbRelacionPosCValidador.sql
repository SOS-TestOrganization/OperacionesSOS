CREATE TABLE [dbo].[tbRelacionPosCValidador] (
    [cnsctvo_cdgo_tpo_cntrto] INT       NOT NULL,
    [nmro_cntrto]             CHAR (15) NOT NULL,
    [cnsctvo_cntrto_psc]      INT       NOT NULL,
    [cdgo_tpo_cntrto_psc]     INT       NOT NULL,
    [nmro_cntrto_psc]         CHAR (15) NOT NULL,
    [inco_vgnca_rlcn_psc]     DATETIME  NOT NULL,
    [fn_vgnca_rlcn_psc]       DATETIME  NOT NULL,
    [cntrto_psc]              CHAR (1)  NOT NULL,
    [inco_vgnca_rlcn]         DATETIME  NOT NULL,
    [fn_vgnca_rlcn]           DATETIME  NOT NULL,
    [estdo_rgstro]            CHAR (1)  NULL,
    [inco_drcn_rgstro]        DATETIME  NULL,
    [fn_drcn_rgstro]          DATETIME  NULL,
    [fcha_ultma_mdfccn]       DATETIME  NULL,
    CONSTRAINT [PK_tbRelacionPosCValidador] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_tpo_cntrto] ASC, [nmro_cntrto] ASC, [cnsctvo_cntrto_psc] ASC)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelacionPosCValidador] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];

