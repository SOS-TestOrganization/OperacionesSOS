CREATE TABLE [dbo].[tbCampoConsultaxCriterioConsultas] (
    [cnsctvo_cdgo_cnslta_cmpo_crtro] [dbo].[udtConsecutivo] NOT NULL,
    [fcha_crcn]                      DATETIME               NOT NULL,
    [usro_crcn]                      [dbo].[udtUsuario]     NOT NULL,
    [cnsctvo_cdgo_crtro_cnslta]      [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_cnslta_cmpo]       [dbo].[udtConsecutivo] NOT NULL,
    CONSTRAINT [PK_tbCampoConsultaxCriterioConsultas] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_cnslta_cmpo_crtro] ASC)
);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbCampoConsultaxCriterioConsultas]([fcha_crcn], [cnsctvo_cdgo_cnslta_cmpo_crtro]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbCampoConsultaxCriterioConsultas]([usro_crcn], [cnsctvo_cdgo_cnslta_cmpo_crtro]);


GO
CREATE STATISTICS [cnsctvo_cdgo_crtro_cnslta]
    ON [dbo].[tbCampoConsultaxCriterioConsultas]([cnsctvo_cdgo_crtro_cnslta], [cnsctvo_cdgo_cnslta_cmpo_crtro]);


GO
CREATE STATISTICS [cnsctvo_cdgo_cnslta_cmpo]
    ON [dbo].[tbCampoConsultaxCriterioConsultas]([cnsctvo_cdgo_cnslta_cmpo], [cnsctvo_cdgo_cnslta_cmpo_crtro]);

