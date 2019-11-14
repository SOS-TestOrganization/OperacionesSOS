CREATE TABLE [dbo].[tbTipoDocumentoNotaReintegro_Vigencias] (
    [cnsctvo_vgnca_dcmnto_nta] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_dcmnto_nta]  [dbo].[udtConsecutivo] NULL,
    [cdgo_dcmnto_nta]          [dbo].[udtCodigo]      NULL,
    [dscrpcn_dcmnto_nta]       [dbo].[udtDescripcion] NULL,
    [inco_vgnca]               DATETIME               NULL,
    [fn_vgnca]                 DATETIME               NULL,
    [fcha_crcn]                DATETIME               NULL,
    [usro_crcn]                [dbo].[udtUsuario]     NULL,
    [obsrvcns]                 [dbo].[udtObservacion] NULL,
    [vsble_usro]               [dbo].[udtLogico]      NULL,
    [tme_stmp]                 ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbTipoDocumentoNotaReintegro_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_dcmnto_nta] ASC),
    CONSTRAINT [FK_tbTipoDocumentoNotaReintegro_Vigencias_tbTipoDocumentoNotaReintegro] FOREIGN KEY ([cnsctvo_cdgo_dcmnto_nta]) REFERENCES [dbo].[tbTipoDocumentoNotaReintegro] ([cnsctvo_cdgo_dcmnto_nta])
);

