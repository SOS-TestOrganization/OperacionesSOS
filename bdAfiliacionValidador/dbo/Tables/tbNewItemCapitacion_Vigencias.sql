CREATE TABLE [dbo].[tbNewItemCapitacion_Vigencias] (
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
    [cnsctvo_prcso]           [dbo].[udtConsecutivo] NOT NULL,
    CONSTRAINT [PK_tbNewItemCapitacion_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_itm_cptcn] ASC, [cnsctvo_prcso] ASC)
);


GO
CREATE STATISTICS [cnsctvo_cdgo_itm_cptcn]
    ON [dbo].[tbNewItemCapitacion_Vigencias]([cnsctvo_cdgo_itm_cptcn], [cnsctvo_vgnca_itm_cptcn], [cnsctvo_prcso]);


GO
CREATE STATISTICS [cdgo_itm_cptcn]
    ON [dbo].[tbNewItemCapitacion_Vigencias]([cdgo_itm_cptcn], [cnsctvo_vgnca_itm_cptcn], [cnsctvo_prcso]);


GO
CREATE STATISTICS [dscrpcn_itm_cptcn]
    ON [dbo].[tbNewItemCapitacion_Vigencias]([dscrpcn_itm_cptcn], [cnsctvo_vgnca_itm_cptcn], [cnsctvo_prcso]);


GO
CREATE STATISTICS [inco_vgnca]
    ON [dbo].[tbNewItemCapitacion_Vigencias]([inco_vgnca], [cnsctvo_vgnca_itm_cptcn], [cnsctvo_prcso]);


GO
CREATE STATISTICS [fn_vgnca]
    ON [dbo].[tbNewItemCapitacion_Vigencias]([fn_vgnca], [cnsctvo_vgnca_itm_cptcn], [cnsctvo_prcso]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbNewItemCapitacion_Vigencias]([fcha_crcn], [cnsctvo_vgnca_itm_cptcn], [cnsctvo_prcso]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbNewItemCapitacion_Vigencias]([usro_crcn], [cnsctvo_vgnca_itm_cptcn], [cnsctvo_prcso]);


GO
CREATE STATISTICS [obsrvcns]
    ON [dbo].[tbNewItemCapitacion_Vigencias]([obsrvcns], [cnsctvo_vgnca_itm_cptcn], [cnsctvo_prcso]);


GO
CREATE STATISTICS [vsble_usro]
    ON [dbo].[tbNewItemCapitacion_Vigencias]([vsble_usro], [cnsctvo_vgnca_itm_cptcn], [cnsctvo_prcso]);


GO
CREATE STATISTICS [cnsctvo_cdgo_nvl]
    ON [dbo].[tbNewItemCapitacion_Vigencias]([cnsctvo_cdgo_nvl], [cnsctvo_vgnca_itm_cptcn], [cnsctvo_prcso]);


GO
CREATE STATISTICS [cnsctvo_prcso]
    ON [dbo].[tbNewItemCapitacion_Vigencias]([cnsctvo_prcso], [cnsctvo_vgnca_itm_cptcn]);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNewItemCapitacion_Vigencias] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNewItemCapitacion_Vigencias] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNewItemCapitacion_Vigencias] TO [Consulta]
    AS [dbo];

