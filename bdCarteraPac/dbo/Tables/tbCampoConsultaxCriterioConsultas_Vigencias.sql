CREATE TABLE [dbo].[tbCampoConsultaxCriterioConsultas_Vigencias] (
    [cnsctvo_vgnca_cdgo_cnslta_cmpo_crtro] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_cnslta_cmpo_crtro]       [dbo].[udtConsecutivo] NOT NULL,
    [inco_vgnca]                           DATETIME               NOT NULL,
    [fn_vgnca]                             DATETIME               NOT NULL,
    [fcha_crcn]                            DATETIME               NOT NULL,
    [usro_crcn]                            [dbo].[udtUsuario]     NOT NULL,
    [cnsctvo_cdgo_crtro_cnslta]            [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_cnslta_cmpo]             [dbo].[udtConsecutivo] NOT NULL,
    [ordn_cmps]                            TINYINT                NULL,
    [tme_stmp]                             ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbCampoConsultaxCriterioConsultas_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_cdgo_cnslta_cmpo_crtro] ASC),
    CONSTRAINT [CKFinicioVgncaMayor_InicioVigencia_tbCampoConsultaxCriterioConsultas_Vigencias] CHECK ([fn_vgnca] >= [inco_vgnca]),
    CONSTRAINT [FK_tbCampoConsultaxCriterioConsultas_Vigencias_tbCampoConsultaxCriterioConsultas] FOREIGN KEY ([cnsctvo_cdgo_cnslta_cmpo_crtro]) REFERENCES [dbo].[tbCampoConsultaxCriterioConsultas] ([cnsctvo_cdgo_cnslta_cmpo_crtro]) ON DELETE CASCADE
);


GO
CREATE STATISTICS [cnsctvo_cdgo_cnslta_cmpo_crtro]
    ON [dbo].[tbCampoConsultaxCriterioConsultas_Vigencias]([cnsctvo_cdgo_cnslta_cmpo_crtro], [cnsctvo_vgnca_cdgo_cnslta_cmpo_crtro]);


GO
CREATE STATISTICS [inco_vgnca]
    ON [dbo].[tbCampoConsultaxCriterioConsultas_Vigencias]([inco_vgnca], [cnsctvo_vgnca_cdgo_cnslta_cmpo_crtro]);


GO
CREATE STATISTICS [fn_vgnca]
    ON [dbo].[tbCampoConsultaxCriterioConsultas_Vigencias]([fn_vgnca], [cnsctvo_vgnca_cdgo_cnslta_cmpo_crtro]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbCampoConsultaxCriterioConsultas_Vigencias]([fcha_crcn], [cnsctvo_vgnca_cdgo_cnslta_cmpo_crtro]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbCampoConsultaxCriterioConsultas_Vigencias]([usro_crcn], [cnsctvo_vgnca_cdgo_cnslta_cmpo_crtro]);


GO
CREATE STATISTICS [cnsctvo_cdgo_crtro_cnslta]
    ON [dbo].[tbCampoConsultaxCriterioConsultas_Vigencias]([cnsctvo_cdgo_crtro_cnslta], [cnsctvo_vgnca_cdgo_cnslta_cmpo_crtro]);


GO
CREATE STATISTICS [cnsctvo_cdgo_cnslta_cmpo]
    ON [dbo].[tbCampoConsultaxCriterioConsultas_Vigencias]([cnsctvo_cdgo_cnslta_cmpo], [cnsctvo_vgnca_cdgo_cnslta_cmpo_crtro]);


GO
CREATE STATISTICS [ordn_cmps]
    ON [dbo].[tbCampoConsultaxCriterioConsultas_Vigencias]([ordn_cmps], [cnsctvo_vgnca_cdgo_cnslta_cmpo_crtro]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbCampoConsultaxCriterioConsultas_Vigencias]([tme_stmp]);

