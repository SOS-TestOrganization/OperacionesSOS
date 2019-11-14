CREATE TABLE [dbo].[tbPasosLiquidacion] (
    [cnsctvo_lqdcn]     INT        NULL,
    [dscrpcn]           CHAR (100) NULL,
    [fcha]              DATETIME   NULL,
    [cnsctvo_pso_lqdcn] INT        IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [pk_tbPasosLiquidacion] PRIMARY KEY CLUSTERED ([cnsctvo_pso_lqdcn] ASC)
);


GO
CREATE STATISTICS [dscrpcn]
    ON [dbo].[tbPasosLiquidacion]([dscrpcn]);


GO
CREATE STATISTICS [fcha]
    ON [dbo].[tbPasosLiquidacion]([fcha]);

