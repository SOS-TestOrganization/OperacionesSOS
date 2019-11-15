CREATE TABLE [dbo].[tbDetalleEapb_Vigencias] (
    [cnsctvo_vgnca]     [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_eapb] [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_eapb]         VARCHAR (3)            NOT NULL,
    [dscrpcn_eapb]      [dbo].[udtDescripcion] NOT NULL,
    [inco_vgnca]        DATETIME               NOT NULL,
    [fn_vgnca]          DATETIME               NOT NULL,
    [fcha_crcn]         DATETIME               NOT NULL,
    [usro_crcn]         [dbo].[udtUsuario]     NOT NULL,
    [obsrvcns]          [dbo].[udtObservacion] NULL,
    [vsble_usro]        [dbo].[udtLogico]      NOT NULL,
    [cdgo_intrno]       [dbo].[udtCodigoIps]   NULL,
    [vsble_vlddr]       [dbo].[udtLogico]      NULL,
    [tme_stmp]          ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbDetalleEapb_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca] ASC)
);


GO
CREATE STATISTICS [cnsctvo_cdgo_eapb]
    ON [dbo].[tbDetalleEapb_Vigencias]([cnsctvo_cdgo_eapb]);


GO
CREATE STATISTICS [dscrpcn_eapb]
    ON [dbo].[tbDetalleEapb_Vigencias]([dscrpcn_eapb]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbDetalleEapb_Vigencias]([fcha_crcn]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbDetalleEapb_Vigencias]([usro_crcn]);


GO
CREATE STATISTICS [obsrvcns]
    ON [dbo].[tbDetalleEapb_Vigencias]([obsrvcns]);


GO
CREATE STATISTICS [vsble_usro]
    ON [dbo].[tbDetalleEapb_Vigencias]([vsble_usro]);


GO
CREATE STATISTICS [cdgo_intrno]
    ON [dbo].[tbDetalleEapb_Vigencias]([cdgo_intrno]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbDetalleEapb_Vigencias]([tme_stmp]);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetalleEapb_Vigencias] TO [Analistas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbDetalleEapb_Vigencias] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetalleEapb_Vigencias] TO [aut_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbDetalleEapb_Vigencias] TO [aut_webusr]
    AS [dbo];

