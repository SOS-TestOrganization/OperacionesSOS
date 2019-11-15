CREATE TABLE [dbo].[tbParametrosEliminados] (
    [cnsctvo_brrdo]        [dbo].[udtConsecutivo]  NOT NULL,
    [bse_dts]              [dbo].[udtNombreObjeto] NOT NULL,
    [nmbre_tbla]           [dbo].[udtNombreObjeto] NOT NULL,
    [usro]                 [dbo].[udtUsuario]      NOT NULL,
    [fcha_elmncn]          DATETIME                NOT NULL,
    [cnsctvo_prmtro]       [dbo].[udtConsecutivo]  NOT NULL,
    [cdgo_rgstro_brrdo]    CHAR (10)               NOT NULL,
    [dscrpcn_rgstro_brrdo] [dbo].[udtDescripcion]  NOT NULL,
    [tme_stmp]             ROWVERSION              NOT NULL,
    CONSTRAINT [PK_tbParametrosEliminados] PRIMARY KEY CLUSTERED ([cnsctvo_brrdo] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE STATISTICS [bse_dts]
    ON [dbo].[tbParametrosEliminados]([bse_dts], [cnsctvo_brrdo]);


GO
CREATE STATISTICS [nmbre_tbla]
    ON [dbo].[tbParametrosEliminados]([nmbre_tbla], [cnsctvo_brrdo]);


GO
CREATE STATISTICS [usro]
    ON [dbo].[tbParametrosEliminados]([usro], [cnsctvo_brrdo]);


GO
CREATE STATISTICS [fcha_elmncn]
    ON [dbo].[tbParametrosEliminados]([fcha_elmncn], [cnsctvo_brrdo]);


GO
CREATE STATISTICS [cnsctvo_prmtro]
    ON [dbo].[tbParametrosEliminados]([cnsctvo_prmtro], [cnsctvo_brrdo]);


GO
CREATE STATISTICS [cdgo_rgstro_brrdo]
    ON [dbo].[tbParametrosEliminados]([cdgo_rgstro_brrdo], [cnsctvo_brrdo]);


GO
CREATE STATISTICS [dscrpcn_rgstro_brrdo]
    ON [dbo].[tbParametrosEliminados]([dscrpcn_rgstro_brrdo], [cnsctvo_brrdo]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbParametrosEliminados]([tme_stmp]);

