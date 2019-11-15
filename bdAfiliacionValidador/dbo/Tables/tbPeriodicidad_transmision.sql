CREATE TABLE [dbo].[tbPeriodicidad_transmision] (
    [prdcdd]   [dbo].[udtDescripcion] NOT NULL,
    [cntdd_ds] INT                    NOT NULL,
    [archvo]   CHAR (20)              NULL,
    [cnsctvo]  INT                    IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    CONSTRAINT [PK_tbPeriodicidad_transmision] PRIMARY KEY CLUSTERED ([cnsctvo] ASC)
);


GO
CREATE STATISTICS [prdcdd]
    ON [dbo].[tbPeriodicidad_transmision]([prdcdd]);


GO
CREATE STATISTICS [cntdd_ds]
    ON [dbo].[tbPeriodicidad_transmision]([cntdd_ds]);


GO
CREATE STATISTICS [archvo]
    ON [dbo].[tbPeriodicidad_transmision]([archvo]);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPeriodicidad_transmision] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPeriodicidad_transmision] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPeriodicidad_transmision] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPeriodicidad_transmision] TO [Consulta]
    AS [dbo];

