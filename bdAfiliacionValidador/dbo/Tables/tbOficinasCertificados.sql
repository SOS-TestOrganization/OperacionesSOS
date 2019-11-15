CREATE TABLE [dbo].[tbOficinasCertificados] (
    [cnsctvo_cdgo_ofcna] INT        NOT NULL,
    [fcha_ultma_mdfccn]  DATETIME   NOT NULL,
    [usro_ultma_mdfccn]  CHAR (30)  NOT NULL,
    [estdo]              CHAR (1)   NOT NULL,
    [time_stmp]          BINARY (8) NULL,
    CONSTRAINT [PK_tbOficinasCertificados] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_ofcna] ASC)
);

