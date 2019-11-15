CREATE TABLE [dbo].[tbItemCapitacion_Vigencias] (
    [cnsctvo_vgnca_itm_cptcn] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_itm_cptcn]  [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_itm_cptcn]          CHAR (3)               NOT NULL,
    [dscrpcn_itm_cptcn]       [dbo].[udtDescripcion] NOT NULL,
    [inco_vgnca]              DATETIME               NOT NULL,
    [fn_vgnca]                DATETIME               NOT NULL,
    [fcha_crcn]               DATETIME               NOT NULL,
    [usro_crcn]               [dbo].[udtUsuario]     NOT NULL,
    [obsrvcns]                [dbo].[udtObservacion] NOT NULL,
    [vsble_usro]              [dbo].[udtLogico]      NOT NULL,
    [cnsctvo_cdgo_nvl]        [dbo].[udtConsecutivo] NOT NULL,
    CONSTRAINT [PK_tbItemCapitacion_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_itm_cptcn] ASC)
);

