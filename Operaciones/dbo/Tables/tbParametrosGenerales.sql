CREATE TABLE [dbo].[tbParametrosGenerales] (
    [cnsctvo_cdgo_prmtro_gnrl] [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_prmtro_gnrl]         [dbo].[udtCodigo]      NOT NULL,
    [dscrpcn_prmtro_gnrl]      [dbo].[udtDescripcion] NOT NULL,
    [fcha_crcn]                DATETIME               NOT NULL,
    [usro_crcn]                [dbo].[udtUsuario]     NOT NULL,
    [vsble_usro]               [dbo].[udtLogico]      NOT NULL,
    CONSTRAINT [PK_tbParametrosGeneralesCarteraPac] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_prmtro_gnrl] ASC),
    CONSTRAINT [IX_tbParametrosGenerales] UNIQUE NONCLUSTERED ([cdgo_prmtro_gnrl] ASC)
);


GO
CREATE STATISTICS [dscrpcn_prmtro_gnrl]
    ON [dbo].[tbParametrosGenerales]([dscrpcn_prmtro_gnrl]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbParametrosGenerales]([fcha_crcn]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbParametrosGenerales]([usro_crcn]);


GO
CREATE STATISTICS [vsble_usro]
    ON [dbo].[tbParametrosGenerales]([vsble_usro]);

