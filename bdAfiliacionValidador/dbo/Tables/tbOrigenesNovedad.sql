CREATE TABLE [dbo].[tbOrigenesNovedad] (
    [cnsctvo_cdgo_orgn] [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_orgn_nvdd]    [dbo].[udtCodigo]      NOT NULL,
    [dscrpcn_orgn_nvdd] [dbo].[udtDescripcion] NOT NULL,
    [brrdo]             [dbo].[udtLogico]      NOT NULL,
    [inco_vgnca]        DATETIME               NOT NULL,
    [fn_vgnca]          DATETIME               NOT NULL,
    [fcha_crcn]         DATETIME               NOT NULL,
    [usro_crcn]         [dbo].[udtUsuario]     NOT NULL,
    [obsrvcns]          [dbo].[udtObservacion] NOT NULL,
    [vsble_usro]        [dbo].[udtLogico]      NOT NULL,
    [tme_stmp]          ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbOrigenesNovedad] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_orgn] ASC)
);

