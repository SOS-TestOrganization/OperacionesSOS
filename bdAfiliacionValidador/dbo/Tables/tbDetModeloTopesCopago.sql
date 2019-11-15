CREATE TABLE [dbo].[tbDetModeloTopesCopago] (
    [cnsctvo_dtlle_mdlo_tps_cpgo] INT             NOT NULL,
    [cnsctvo_mdlo]                INT             NOT NULL,
    [cnsctvo_cdgo_rngo_slrl]      INT             NOT NULL,
    [cnsctvo_cdgo_tpo_tpe]        INT             NOT NULL,
    [prcntje_slro_mnmo]           NUMERIC (12, 3) NOT NULL,
    [usro_crcn]                   CHAR (30)       NOT NULL,
    [fcha_crcn]                   DATETIME        NOT NULL,
    [usro_ultma_mdfccn]           CHAR (30)       NULL,
    [fcha_ultma_mdfccn]           DATETIME        NULL,
    [tme_stmp]                    BINARY (8)      NOT NULL,
    CONSTRAINT [PK_tbDetModeloTopesCopago] PRIMARY KEY CLUSTERED ([cnsctvo_dtlle_mdlo_tps_cpgo] ASC, [cnsctvo_mdlo] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_cnsctvo_tpo_tpe]
    ON [dbo].[tbDetModeloTopesCopago]([cnsctvo_cdgo_tpo_tpe] ASC)
    INCLUDE([cnsctvo_mdlo], [cnsctvo_cdgo_rngo_slrl], [prcntje_slro_mnmo], [cnsctvo_dtlle_mdlo_tps_cpgo]);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesCopago] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesCopago] TO [310014 Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesCopago] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesCopago] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbDetModeloTopesCopago] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesCopago] TO [autsalud_rol]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbDetModeloTopesCopago] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesCopago] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesCopago] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesCopago] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesCopago] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesCopago] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesCopago] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesCopago] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesCopago] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesCopago] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesCopago] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesCopago] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesCopago] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesCopago] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesCopago] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesCopago] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

