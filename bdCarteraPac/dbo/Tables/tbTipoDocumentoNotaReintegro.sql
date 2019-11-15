CREATE TABLE [dbo].[tbTipoDocumentoNotaReintegro] (
    [cnsctvo_cdgo_dcmnto_nta] [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_dcmnto_nta]         [dbo].[udtCodigo]      NULL,
    [dscrpcn_dcmnto_nta]      [dbo].[udtDescripcion] NULL,
    [fcha_crcn]               DATETIME               NULL,
    [usro_crcn]               [dbo].[udtUsuario]     NULL,
    [vsble_usro]              [dbo].[udtLogico]      NULL,
    CONSTRAINT [PK_tbTipoDocumentoNotaReintegro] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_dcmnto_nta] ASC)
);

