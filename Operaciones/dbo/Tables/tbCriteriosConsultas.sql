CREATE TABLE [dbo].[tbCriteriosConsultas] (
    [cnsctvo_cdgo_crtro_cnslta] [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_crtro_cnslta]         CHAR (4)               NOT NULL,
    [dscrpcn_crtro_cnslta]      [dbo].[udtDescripcion] NOT NULL,
    [fcha_crcn]                 DATETIME               NOT NULL,
    [usro_crcn]                 [dbo].[udtUsuario]     NOT NULL,
    [vsble_usro]                [dbo].[udtLogico]      NOT NULL,
    CONSTRAINT [PK_tbCriteriosConsultas] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_crtro_cnslta] ASC)
);


GO
CREATE STATISTICS [cdgo_crtro_cnslta]
    ON [dbo].[tbCriteriosConsultas]([cdgo_crtro_cnslta], [cnsctvo_cdgo_crtro_cnslta]);


GO
CREATE STATISTICS [dscrpcn_crtro_cnslta]
    ON [dbo].[tbCriteriosConsultas]([dscrpcn_crtro_cnslta], [cnsctvo_cdgo_crtro_cnslta]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbCriteriosConsultas]([fcha_crcn], [cnsctvo_cdgo_crtro_cnslta]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbCriteriosConsultas]([usro_crcn], [cnsctvo_cdgo_crtro_cnslta]);


GO
CREATE STATISTICS [vsble_usro]
    ON [dbo].[tbCriteriosConsultas]([vsble_usro], [cnsctvo_cdgo_crtro_cnslta]);

