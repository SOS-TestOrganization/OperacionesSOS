CREATE TABLE [dbo].[tbDetModeloTopesEventosQx] (
    [cnsctvo_dtlle_mdlo_tps_evnts_qrrgcs] INT        NOT NULL,
    [cnsctvo_mdlo]                        INT        NOT NULL,
    [cnsctvo_cdgo_tpo_tpe_pln]            INT        NOT NULL,
    [tpe_csto]                            INT        NOT NULL,
    [tpe_actvdd]                          INT        NOT NULL,
    [usro_crcn]                           CHAR (30)  NOT NULL,
    [fcha_crcn]                           DATETIME   NOT NULL,
    [usro_ultma_mdfccn]                   CHAR (30)  NULL,
    [fcha_ultma_mdfccn]                   DATETIME   NULL,
    [tme_stmp]                            BINARY (8) NOT NULL,
    CONSTRAINT [PK_TbDetModeloTopesEventosQx] PRIMARY KEY CLUSTERED ([cnsctvo_dtlle_mdlo_tps_evnts_qrrgcs] ASC, [cnsctvo_mdlo] ASC)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesEventosQx] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesEventosQx] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesEventosQx] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesEventosQx] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesEventosQx] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesEventosQx] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesEventosQx] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesEventosQx] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesEventosQx] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesEventosQx] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesEventosQx] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesEventosQx] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesEventosQx] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesEventosQx] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesEventosQx] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesEventosQx] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesEventosQx] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesEventosQx] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

