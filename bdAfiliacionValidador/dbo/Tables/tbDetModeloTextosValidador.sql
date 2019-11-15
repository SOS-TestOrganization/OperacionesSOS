CREATE TABLE [dbo].[tbDetModeloTextosValidador] (
    [cnsctvo_mdlo]                 INT           NOT NULL,
    [cnsctvo_dtlle_mdlo_txto]      INT           NOT NULL,
    [cnsctvo_cdgo_tpo_afldo]       INT           NOT NULL,
    [cnsctvo_cdgo_rngo_slrl]       INT           NOT NULL,
    [cnsctvo_cdgo_txto_cpgo]       INT           NOT NULL,
    [cnsctvo_cdgo_txto_cta_mdrdra] INT           NOT NULL,
    [dscrpcn_txto_cpgo]            VARCHAR (150) NOT NULL,
    [dscrpcn_cdgo_txto_cta_mdrdra] VARCHAR (150) NOT NULL,
    [fcha_ultma_mdfccn]            DATETIME      NOT NULL,
    [txto_adcnl]                   VARCHAR (150) NULL,
    CONSTRAINT [PK_tbDetModeloTextosValidador] PRIMARY KEY CLUSTERED ([cnsctvo_mdlo] ASC, [cnsctvo_dtlle_mdlo_txto] ASC)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTextosValidador] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTextosValidador] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTextosValidador] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTextosValidador] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTextosValidador] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTextosValidador] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTextosValidador] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTextosValidador] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTextosValidador] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTextosValidador] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTextosValidador] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTextosValidador] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

