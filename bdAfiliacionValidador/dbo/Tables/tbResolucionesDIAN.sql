CREATE TABLE [dbo].[tbResolucionesDIAN] (
    [cnsctvo_cdgo_rslcn_dn] [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_rslcn_dn]         [dbo].[udtCodigo]      NOT NULL,
    [dscrpcn_rslcn_dn]      [dbo].[udtDescripcion] NOT NULL,
    [fcha_crcn]             DATETIME               NOT NULL,
    [usro_crcn]             [dbo].[udtUsuario]     NOT NULL,
    [vsble_usro]            [dbo].[udtLogico]      NOT NULL,
    CONSTRAINT [PK_tbResolucionesDIAN] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_rslcn_dn] ASC)
);

