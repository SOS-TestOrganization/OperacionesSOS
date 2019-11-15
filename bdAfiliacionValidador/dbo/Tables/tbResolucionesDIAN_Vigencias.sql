CREATE TABLE [dbo].[tbResolucionesDIAN_Vigencias] (
    [cnsctvo_vgnca_rslcn_dn]  [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_rslcn_dn]   [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_rslcn_dn]           [dbo].[udtCodigo]      NOT NULL,
    [dscrpcn_rslcn_dn]        [dbo].[udtDescripcion] NOT NULL,
    [inco_vgnca]              DATETIME               NOT NULL,
    [fn_vgnca]                DATETIME               NOT NULL,
    [fcha_crcn]               DATETIME               NOT NULL,
    [usro_crcn]               [dbo].[udtUsuario]     NOT NULL,
    [obsrvcns]                [dbo].[udtObservacion] NOT NULL,
    [vsble_usro]              [dbo].[udtLogico]      NOT NULL,
    [txto_rslcn]              VARCHAR (MAX)          NULL,
    [txto_adcnl_rslcn]        VARCHAR (MAX)          NULL,
    [nmro_atrzcn_fctrcn]      VARCHAR (25)           NULL,
    [fcha_inco_atrzn_fctrcn]  DATETIME               NULL,
    [fcha_fn_atrzcn_fctrcn]   DATETIME               NULL,
    [prfjo_atrzdo_fctrcn]     VARCHAR (10)           NULL,
    [rngo_inco_atrzdo_fctrcn] VARCHAR (10)           NULL,
    [rngo_fn_atrzdo_fctrcn]   VARCHAR (10)           NULL,
    [clve_tcnca_dn]           VARCHAR (200)          NOT NULL,
    CONSTRAINT [PK_tbResolucionesDIANVigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_rslcn_dn] ASC)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbResolucionesDIAN_Vigencias] TO [portal_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbResolucionesDIAN_Vigencias] TO [quick_webusr]
    AS [dbo];

