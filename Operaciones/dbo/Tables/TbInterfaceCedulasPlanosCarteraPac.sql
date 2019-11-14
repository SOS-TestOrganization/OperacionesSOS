CREATE TABLE [dbo].[TbInterfaceCedulasPlanosCarteraPac] (
    [numero]                             CHAR (20) NULL,
    [TI]                                 CHAR (10) NULL,
    [NI]                                 CHAR (20) NULL,
    [Tpo_Empldo]                         CHAR (1)  NULL,
    [cnsctvo_intrfce_cdla_plns_crtra_pc] INT       IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [pk_TbInterfaceCedulasPlanosCarteraPac] PRIMARY KEY CLUSTERED ([cnsctvo_intrfce_cdla_plns_crtra_pc] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE STATISTICS [numero]
    ON [dbo].[TbInterfaceCedulasPlanosCarteraPac]([numero]);


GO
CREATE STATISTICS [TI]
    ON [dbo].[TbInterfaceCedulasPlanosCarteraPac]([TI]);


GO
CREATE STATISTICS [NI]
    ON [dbo].[TbInterfaceCedulasPlanosCarteraPac]([NI]);


GO
CREATE STATISTICS [Tpo_Empldo]
    ON [dbo].[TbInterfaceCedulasPlanosCarteraPac]([Tpo_Empldo]);

