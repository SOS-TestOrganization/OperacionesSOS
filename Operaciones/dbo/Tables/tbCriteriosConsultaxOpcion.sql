CREATE TABLE [dbo].[tbCriteriosConsultaxOpcion] (
    [cnsctvo_cdgo_cnslta_opcn]  [dbo].[udtConsecutivo] NOT NULL,
    [fcha_crcn]                 DATETIME               NOT NULL,
    [usro_crcn]                 [dbo].[udtUsuario]     NOT NULL,
    [cnsctvo_cdgo_crtro_cnslta] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_opcn]         [dbo].[udtConsecutivo] NOT NULL,
    CONSTRAINT [PK_tbCriteriosConsultaxOpcion] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_cnslta_opcn] ASC)
);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbCriteriosConsultaxOpcion]([fcha_crcn], [cnsctvo_cdgo_cnslta_opcn]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbCriteriosConsultaxOpcion]([usro_crcn], [cnsctvo_cdgo_cnslta_opcn]);


GO
CREATE STATISTICS [cnsctvo_cdgo_crtro_cnslta]
    ON [dbo].[tbCriteriosConsultaxOpcion]([cnsctvo_cdgo_crtro_cnslta], [cnsctvo_cdgo_cnslta_opcn]);


GO
CREATE STATISTICS [cnsctvo_cdgo_opcn]
    ON [dbo].[tbCriteriosConsultaxOpcion]([cnsctvo_cdgo_opcn], [cnsctvo_cdgo_cnslta_opcn]);

