CREATE TABLE [dbo].[tbTiposServicio_Vigencias] (
    [cnsctvo_vgnca_cdgo_tpo_srvco] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_tpo_srvco]       [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_tpo_srvco]               CHAR (3)               NOT NULL,
    [dscrpcn_tpo_srvco]            [dbo].[udtDescripcion] NOT NULL,
    [inco_vgnca]                   DATETIME               NOT NULL,
    [fn_vgnca]                     DATETIME               NOT NULL,
    [fcha_crcn]                    DATETIME               NOT NULL,
    [usro_crcn]                    [dbo].[udtUsuario]     NOT NULL,
    [obsrvcns]                     [dbo].[udtObservacion] NOT NULL,
    [vsble_usro]                   [dbo].[udtLogico]      NOT NULL,
    [cnsctvo_cdgo_tpo_pln]         [dbo].[udtConsecutivo] NOT NULL,
    [tme_stmp]                     ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbTiposServicio_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_cdgo_tpo_srvco] ASC)
);

