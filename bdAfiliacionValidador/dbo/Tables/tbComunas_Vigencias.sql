CREATE TABLE [dbo].[tbComunas_Vigencias] (
    [cnsctvo_vgnca_cmna] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_cmna]  [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_cmna]          CHAR (4)               NOT NULL,
    [dscrpcn_cmna]       [dbo].[udtDescripcion] NOT NULL,
    [inco_vgnca]         DATETIME               NOT NULL,
    [fn_vgnca]           DATETIME               NOT NULL,
    [fcha_crcn]          DATETIME               NOT NULL,
    [usro_crcn]          [dbo].[udtUsuario]     NOT NULL,
    [obsrvcns]           [dbo].[udtObservacion] NOT NULL,
    [vsble_usro]         [dbo].[udtLogico]      NOT NULL,
    [tme_stmp]           ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbComunas_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_cmna] ASC),
    CONSTRAINT [CKFinicioVgncaMayor_InicioVigencia_tbComunas_Vigencias] CHECK ([fn_vgnca]>=[inco_vgnca]),
    CONSTRAINT [FK_tbComunas_Vigencias_tbComunas] FOREIGN KEY ([cnsctvo_cdgo_cmna]) REFERENCES [dbo].[tbComunas] ([cnsctvo_cdgo_cmna]) ON DELETE CASCADE
);


GO
CREATE STATISTICS [cnsctvo_cdgo_cmna]
    ON [dbo].[tbComunas_Vigencias]([cnsctvo_cdgo_cmna]);


GO
CREATE STATISTICS [cdgo_cmna]
    ON [dbo].[tbComunas_Vigencias]([cdgo_cmna]);


GO
CREATE STATISTICS [dscrpcn_cmna]
    ON [dbo].[tbComunas_Vigencias]([dscrpcn_cmna]);


GO
CREATE STATISTICS [inco_vgnca]
    ON [dbo].[tbComunas_Vigencias]([inco_vgnca]);


GO
CREATE STATISTICS [fn_vgnca]
    ON [dbo].[tbComunas_Vigencias]([fn_vgnca]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbComunas_Vigencias]([fcha_crcn]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbComunas_Vigencias]([usro_crcn]);


GO
CREATE STATISTICS [obsrvcns]
    ON [dbo].[tbComunas_Vigencias]([obsrvcns]);


GO
CREATE STATISTICS [vsble_usro]
    ON [dbo].[tbComunas_Vigencias]([vsble_usro]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbComunas_Vigencias]([tme_stmp]);

