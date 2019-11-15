CREATE TABLE [dbo].[tbDetModeloTopesHabitacion] (
    [cnsctvo_dtlle_mdlo_tps_hbtcn] INT             NOT NULL,
    [cnsctvo_mdlo]                 INT             NOT NULL,
    [cnsctvo_cdgo_clse_hbtcn]      INT             NOT NULL,
    [cnsctvo_cdgo_tpo_estnca]      INT             NOT NULL,
    [cnsctvo_cdgo_tpo_dstrbcn]     INT             NOT NULL,
    [vlr_asmdo_ss]                 NUMERIC (12, 2) NOT NULL,
    [nmro_ds_estnca]               INT             NOT NULL,
    [usro_crcn]                    CHAR (30)       NOT NULL,
    [fcha_crcn]                    DATETIME        NOT NULL,
    [usro_ultma_mdfccn]            CHAR (30)       NULL,
    [fcha_ultma_mdfccn]            DATETIME        NULL,
    [tme_stmp]                     BINARY (8)      NOT NULL,
    CONSTRAINT [PK_TbDetModeloTopesHabitacion] PRIMARY KEY CLUSTERED ([cnsctvo_dtlle_mdlo_tps_hbtcn] ASC, [cnsctvo_mdlo] ASC)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesHabitacion] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesHabitacion] TO [310014 Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesHabitacion] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesHabitacion] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesHabitacion] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesHabitacion] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesHabitacion] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesHabitacion] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesHabitacion] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesHabitacion] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesHabitacion] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesHabitacion] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesHabitacion] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

