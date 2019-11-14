CREATE TABLE [dbo].[tbCriteriosConsultaxOpcion_Vigencias] (
    [cnsctvo_vgnca_cdgo_cnslta_opcn] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_cnslta_opcn]       [dbo].[udtConsecutivo] NOT NULL,
    [inco_vgnca]                     DATETIME               NOT NULL,
    [fn_vgnca]                       DATETIME               NOT NULL,
    [fcha_crcn]                      DATETIME               NOT NULL,
    [usro_crcn]                      [dbo].[udtUsuario]     NOT NULL,
    [cnsctvo_cdgo_crtro_cnslta]      [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_opcn]              [dbo].[udtConsecutivo] NOT NULL,
    [nmbre_sp_ejcn]                  [dbo].[udtDescripcion] NULL,
    [prmtrs_adcnls]                  [dbo].[udtDescripcion] NULL,
    [tpo_cnxn]                       CHAR (10)              NULL,
    [tme_stmp]                       ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbCriteriosConsultaxOpcion_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_cdgo_cnslta_opcn] ASC),
    CONSTRAINT [CKFinicioVgncaMayor_InicioVigencia_tbCriteriosConsultaxOpcion_Vigencias] CHECK ([fn_vgnca] >= [inco_vgnca]),
    CONSTRAINT [FK_tbCriteriosConsultaxOpcion_Vigencias_tbCriteriosConsultaxOpcion] FOREIGN KEY ([cnsctvo_cdgo_cnslta_opcn]) REFERENCES [dbo].[tbCriteriosConsultaxOpcion] ([cnsctvo_cdgo_cnslta_opcn]) ON DELETE CASCADE
);


GO
CREATE STATISTICS [cnsctvo_cdgo_cnslta_opcn]
    ON [dbo].[tbCriteriosConsultaxOpcion_Vigencias]([cnsctvo_cdgo_cnslta_opcn], [cnsctvo_vgnca_cdgo_cnslta_opcn]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbCriteriosConsultaxOpcion_Vigencias]([fcha_crcn], [cnsctvo_vgnca_cdgo_cnslta_opcn]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbCriteriosConsultaxOpcion_Vigencias]([usro_crcn], [cnsctvo_vgnca_cdgo_cnslta_opcn]);


GO
CREATE STATISTICS [nmbre_sp_ejcn]
    ON [dbo].[tbCriteriosConsultaxOpcion_Vigencias]([nmbre_sp_ejcn], [cnsctvo_vgnca_cdgo_cnslta_opcn]);


GO
CREATE STATISTICS [prmtrs_adcnls]
    ON [dbo].[tbCriteriosConsultaxOpcion_Vigencias]([prmtrs_adcnls], [cnsctvo_vgnca_cdgo_cnslta_opcn]);


GO
CREATE STATISTICS [tpo_cnxn]
    ON [dbo].[tbCriteriosConsultaxOpcion_Vigencias]([tpo_cnxn], [cnsctvo_vgnca_cdgo_cnslta_opcn]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbCriteriosConsultaxOpcion_Vigencias]([tme_stmp]);

