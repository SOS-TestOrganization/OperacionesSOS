CREATE TABLE [dbo].[tbParametrosGenerales_Vigencias] (
    [cnsctvo_vgnca_prmtro_gnrl] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_prmtro_gnrl]  [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_prmtro_gnrl]          [dbo].[udtCodigo]      NOT NULL,
    [dscrpcn_prmtro_gnrl]       [dbo].[udtDescripcion] NOT NULL,
    [inco_vgnca]                DATETIME               NOT NULL,
    [fn_vgnca]                  DATETIME               NOT NULL,
    [fcha_crcn]                 DATETIME               NOT NULL,
    [usro_crcn]                 [dbo].[udtUsuario]     NOT NULL,
    [obsrvcns]                  [dbo].[udtObservacion] NOT NULL,
    [vsble_usro]                [dbo].[udtLogico]      NOT NULL,
    [tpo_dto_prmtro]            CHAR (1)               NOT NULL,
    [vlr_prmtro_nmrco]          DECIMAL (18, 2)        NULL,
    [vlr_prmtro_crctr]          VARCHAR (100)          NULL,
    [vlr_prmtro_fcha]           DATETIME               NULL,
    [tme_stmp]                  ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbParametrosGenerales_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_prmtro_gnrl] ASC),
    CONSTRAINT [FK_tbParametrosGenerales_Vigencias_tbParametrosGenerales] FOREIGN KEY ([cnsctvo_cdgo_prmtro_gnrl]) REFERENCES [dbo].[tbParametrosGenerales] ([cnsctvo_cdgo_prmtro_gnrl]) ON DELETE CASCADE
);


GO
CREATE STATISTICS [cnsctvo_cdgo_prmtro_gnrl]
    ON [dbo].[tbParametrosGenerales_Vigencias]([cnsctvo_cdgo_prmtro_gnrl]);


GO
CREATE STATISTICS [cdgo_prmtro_gnrl]
    ON [dbo].[tbParametrosGenerales_Vigencias]([cdgo_prmtro_gnrl]);


GO
CREATE STATISTICS [dscrpcn_prmtro_gnrl]
    ON [dbo].[tbParametrosGenerales_Vigencias]([dscrpcn_prmtro_gnrl]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbParametrosGenerales_Vigencias]([fcha_crcn]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbParametrosGenerales_Vigencias]([usro_crcn]);


GO
CREATE STATISTICS [obsrvcns]
    ON [dbo].[tbParametrosGenerales_Vigencias]([obsrvcns]);


GO
CREATE STATISTICS [vsble_usro]
    ON [dbo].[tbParametrosGenerales_Vigencias]([vsble_usro]);


GO
CREATE STATISTICS [tpo_dto_prmtro]
    ON [dbo].[tbParametrosGenerales_Vigencias]([tpo_dto_prmtro]);


GO
CREATE STATISTICS [vlr_prmtro_nmrco]
    ON [dbo].[tbParametrosGenerales_Vigencias]([vlr_prmtro_nmrco]);


GO
CREATE STATISTICS [vlr_prmtro_crctr]
    ON [dbo].[tbParametrosGenerales_Vigencias]([vlr_prmtro_crctr]);


GO
CREATE STATISTICS [vlr_prmtro_fcha]
    ON [dbo].[tbParametrosGenerales_Vigencias]([vlr_prmtro_fcha]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbParametrosGenerales_Vigencias]([tme_stmp]);

