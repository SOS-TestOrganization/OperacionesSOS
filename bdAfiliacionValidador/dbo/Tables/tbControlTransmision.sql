CREATE TABLE [dbo].[tbControlTransmision] (
    [fcha_cntrl]    DATETIME                NOT NULL,
    [fcha_crga]     DATETIME                NULL,
    [nmbre_tbla]    [dbo].[udtNombreObjeto] NULL,
    [estdo]         TINYINT                 NULL,
    [obsrvcns]      [dbo].[udtObservacion]  NULL,
    [cntdd_rgstrs]  INT                     NULL,
    [cnsctvo_cntrl] INT                     IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    CONSTRAINT [PK_tbControlTransmision] PRIMARY KEY CLUSTERED ([cnsctvo_cntrl] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_nmbre_tbla]
    ON [dbo].[tbControlTransmision]([nmbre_tbla] ASC, [estdo] ASC)
    INCLUDE([fcha_cntrl])
    ON [FG_INDEXES];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbControlTransmision] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbControlTransmision] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbControlTransmision] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbControlTransmision] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbControlTransmision] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbControlTransmision] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbControlTransmision] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbControlTransmision] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbControlTransmision] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbControlTransmision] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbControlTransmision] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbControlTransmision] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbControlTransmision] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbControlTransmision] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbControlTransmision] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbControlTransmision] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbControlTransmision] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbControlTransmision] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

