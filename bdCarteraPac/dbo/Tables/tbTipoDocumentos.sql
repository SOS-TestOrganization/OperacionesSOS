CREATE TABLE [dbo].[tbTipoDocumentos] (
    [cnsctvo_cdgo_tpo_dcmnto] [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_tpo_dcmto]          [dbo].[udtCodigo]      NOT NULL,
    [dscrpcn_tpo_dcmnto]      [dbo].[udtDescripcion] NOT NULL,
    [fcha_crcn]               DATETIME               NOT NULL,
    [usro_crcn]               [dbo].[udtUsuario]     NOT NULL,
    [vsble_usro]              [dbo].[udtLogico]      NOT NULL,
    CONSTRAINT [PK_tbTipoDocumentos] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_tpo_dcmnto] ASC)
);


GO
CREATE STATISTICS [cdgo_tpo_dcmto]
    ON [dbo].[tbTipoDocumentos]([cdgo_tpo_dcmto], [cnsctvo_cdgo_tpo_dcmnto]);


GO
CREATE STATISTICS [dscrpcn_tpo_dcmnto]
    ON [dbo].[tbTipoDocumentos]([dscrpcn_tpo_dcmnto], [cnsctvo_cdgo_tpo_dcmnto]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbTipoDocumentos]([fcha_crcn], [cnsctvo_cdgo_tpo_dcmnto]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbTipoDocumentos]([usro_crcn], [cnsctvo_cdgo_tpo_dcmnto]);


GO
CREATE STATISTICS [vsble_usro]
    ON [dbo].[tbTipoDocumentos]([vsble_usro], [cnsctvo_cdgo_tpo_dcmnto]);

