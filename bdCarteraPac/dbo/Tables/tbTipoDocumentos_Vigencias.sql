CREATE TABLE [dbo].[tbTipoDocumentos_Vigencias] (
    [cnsctvo_vgnca_tpo_dcmnto] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_tpo_dcmnto]  [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_tpo_dcmnto]          [dbo].[udtCodigo]      NOT NULL,
    [dscrpcn_tpo_dcmnto]       [dbo].[udtDescripcion] NOT NULL,
    [inco_vgnca]               DATETIME               NOT NULL,
    [fn_vgnca]                 DATETIME               NOT NULL,
    [fcha_crcn]                DATETIME               NOT NULL,
    [usro_crcn]                [dbo].[udtUsuario]     NOT NULL,
    [obsrvcns]                 [dbo].[udtObservacion] NOT NULL,
    [vsble_usro]               [dbo].[udtLogico]      NOT NULL,
    [tme_stmp]                 ROWVERSION             NOT NULL,
    CONSTRAINT [Pk_tbTipoDocumentos_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_tpo_dcmnto] ASC)
);

