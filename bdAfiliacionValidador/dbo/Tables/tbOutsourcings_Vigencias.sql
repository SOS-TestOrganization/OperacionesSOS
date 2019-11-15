CREATE TABLE [dbo].[tbOutsourcings_Vigencias] (
    [cnsctvo_vgnca_otsrcng] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_otsrcng]  [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_otsrcng]          [dbo].[udtCodigo]      NOT NULL,
    [dscrpcn_otsrcng]       [dbo].[udtDescripcion] NOT NULL,
    [inco_vgnca]            DATETIME               NOT NULL,
    [fn_vgnca]              DATETIME               NOT NULL,
    [fcha_crcn]             DATETIME               NOT NULL,
    [usro_crcn]             [dbo].[udtUsuario]     NOT NULL,
    [obsrvcns]              [dbo].[udtObservacion] NOT NULL,
    [vsble_usro]            [dbo].[udtLogico]      NOT NULL,
    [rta_cps]               [dbo].[udtDescripcion] NOT NULL,
    [asgnr_frmlrs]          [dbo].[udtLogico]      NOT NULL,
    [tme_stmp]              ROWVERSION             NOT NULL
);

