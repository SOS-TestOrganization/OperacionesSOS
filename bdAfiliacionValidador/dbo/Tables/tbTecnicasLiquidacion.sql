CREATE TABLE [dbo].[tbTecnicasLiquidacion] (
    [cnsctvo_cdgo_tcnca_lqdcn] INT           NOT NULL,
    [cdgo_tcnca_lqdcn]         CHAR (2)      NOT NULL,
    [dscrpcn_tcnca_lqdcn]      VARCHAR (150) NOT NULL,
    [fcha_crcn]                DATETIME      NOT NULL,
    [usro_crcn]                CHAR (30)     NOT NULL,
    [vsble_usro]               CHAR (1)      NOT NULL,
    CONSTRAINT [PK_tbTecnicasLiquidacion] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_tcnca_lqdcn] ASC)
);


GO
CREATE STATISTICS [cdgo_tcnca_lqdcn]
    ON [dbo].[tbTecnicasLiquidacion]([cdgo_tcnca_lqdcn], [cnsctvo_cdgo_tcnca_lqdcn]);


GO
CREATE STATISTICS [dscrpcn_tcnca_lqdcn]
    ON [dbo].[tbTecnicasLiquidacion]([dscrpcn_tcnca_lqdcn], [cnsctvo_cdgo_tcnca_lqdcn]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbTecnicasLiquidacion]([fcha_crcn], [cnsctvo_cdgo_tcnca_lqdcn]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbTecnicasLiquidacion]([usro_crcn], [cnsctvo_cdgo_tcnca_lqdcn]);


GO
CREATE STATISTICS [vsble_usro]
    ON [dbo].[tbTecnicasLiquidacion]([vsble_usro], [cnsctvo_cdgo_tcnca_lqdcn]);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTecnicasLiquidacion] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTecnicasLiquidacion] TO [310014 Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTecnicasLiquidacion] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTecnicasLiquidacion] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTecnicasLiquidacion] TO [autsalud_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTecnicasLiquidacion] TO [autsalud_rol]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTecnicasLiquidacion] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTecnicasLiquidacion] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTecnicasLiquidacion] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTecnicasLiquidacion] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTecnicasLiquidacion] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTecnicasLiquidacion] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTecnicasLiquidacion] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTecnicasLiquidacion] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTecnicasLiquidacion] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTecnicasLiquidacion] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTecnicasLiquidacion] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTecnicasLiquidacion] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTecnicasLiquidacion] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTecnicasLiquidacion] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTecnicasLiquidacion] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTecnicasLiquidacion] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

