CREATE TABLE [dbo].[tbConceptosDIAN] (
    [cnsctvo_cdgo_cncpto_dn] [dbo].[udtConsecutivo] IDENTITY (1, 1) NOT NULL,
    [cdgo_cncpto_dn]         [dbo].[udtCodigo]      NULL,
    [dscrpcn_cncpto_dn]      [dbo].[udtDescripcion] NULL,
    [fcha_crcn]              DATETIME               NULL,
    [usro_crcn]              [dbo].[udtUsuario]     NULL,
    [vsble_usro]             [dbo].[udtLogico]      NULL,
    CONSTRAINT [PK_tbConceptosDIAN] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_cncpto_dn] ASC)
);

