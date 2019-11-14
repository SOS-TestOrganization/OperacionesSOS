CREATE TABLE [dbo].[tbCriteriosConsultas_Vigencias] (
    [cnsctvo_vgnca_crtro_cnslta] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_crtro_cnslta]  [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_crtro_cnslta]          CHAR (4)               NOT NULL,
    [dscrpcn_crtro_cnslta]       [dbo].[udtDescripcion] NOT NULL,
    [inco_vgnca]                 DATETIME               NOT NULL,
    [fn_vgnca]                   DATETIME               NOT NULL,
    [fcha_crcn]                  DATETIME               NOT NULL,
    [usro_crcn]                  [dbo].[udtUsuario]     NOT NULL,
    [obsrvcns]                   [dbo].[udtObservacion] NOT NULL,
    [vsble_usro]                 [dbo].[udtLogico]      NOT NULL,
    [tme_stmp]                   ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbCriteriosConsultas_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_crtro_cnslta] ASC),
    CONSTRAINT [CKFinicioVgncaMayor_InicioVigencia_tbCriteriosConsultas_Vigencias] CHECK ([fn_vgnca] >= [inco_vgnca]),
    CONSTRAINT [FK_tbCriteriosConsultas_Vigencias_tbCriteriosConsultas] FOREIGN KEY ([cnsctvo_cdgo_crtro_cnslta]) REFERENCES [dbo].[tbCriteriosConsultas] ([cnsctvo_cdgo_crtro_cnslta]) ON DELETE CASCADE
);


GO
CREATE STATISTICS [cnsctvo_cdgo_crtro_cnslta]
    ON [dbo].[tbCriteriosConsultas_Vigencias]([cnsctvo_cdgo_crtro_cnslta], [cnsctvo_vgnca_crtro_cnslta]);


GO
CREATE STATISTICS [cdgo_crtro_cnslta]
    ON [dbo].[tbCriteriosConsultas_Vigencias]([cdgo_crtro_cnslta], [cnsctvo_vgnca_crtro_cnslta]);


GO
CREATE STATISTICS [dscrpcn_crtro_cnslta]
    ON [dbo].[tbCriteriosConsultas_Vigencias]([dscrpcn_crtro_cnslta], [cnsctvo_vgnca_crtro_cnslta]);


GO
CREATE STATISTICS [inco_vgnca]
    ON [dbo].[tbCriteriosConsultas_Vigencias]([inco_vgnca], [cnsctvo_vgnca_crtro_cnslta]);


GO
CREATE STATISTICS [fn_vgnca]
    ON [dbo].[tbCriteriosConsultas_Vigencias]([fn_vgnca], [cnsctvo_vgnca_crtro_cnslta]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbCriteriosConsultas_Vigencias]([fcha_crcn], [cnsctvo_vgnca_crtro_cnslta]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbCriteriosConsultas_Vigencias]([usro_crcn], [cnsctvo_vgnca_crtro_cnslta]);


GO
CREATE STATISTICS [obsrvcns]
    ON [dbo].[tbCriteriosConsultas_Vigencias]([obsrvcns], [cnsctvo_vgnca_crtro_cnslta]);


GO
CREATE STATISTICS [vsble_usro]
    ON [dbo].[tbCriteriosConsultas_Vigencias]([vsble_usro], [cnsctvo_vgnca_crtro_cnslta]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbCriteriosConsultas_Vigencias]([tme_stmp]);

