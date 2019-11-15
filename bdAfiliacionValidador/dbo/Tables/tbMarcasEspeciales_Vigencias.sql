CREATE TABLE [dbo].[tbMarcasEspeciales_Vigencias] (
    [cnsctvo_vgnca_mrca_espcl] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_mrca_espcl]       [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_mrca_espcl]          [dbo].[udtCodigo]      NOT NULL,
    [dscrpcn_mrca_espcl]       [dbo].[udtDescripcion] NOT NULL,
    [inco_vgnca]               DATETIME               NOT NULL,
    [fn_vgnca]                 DATETIME               NOT NULL,
    [fcha_crcn]                DATETIME               NOT NULL,
    [usro_crcn]                [dbo].[udtUsuario]     NOT NULL,
    [obsrvcns]                 [dbo].[udtObservacion] NOT NULL,
    [vsble_usro]               [dbo].[udtLogico]      NOT NULL,
    [tme_stmp]                 ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbMarcasEspeciales_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_mrca_espcl] ASC)
);


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbMarcasEspeciales_Vigencias] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbMarcasEspeciales_Vigencias] TO [autsalud_rol]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbMarcasEspeciales_Vigencias] TO [autsalud_rol]
    AS [dbo];

