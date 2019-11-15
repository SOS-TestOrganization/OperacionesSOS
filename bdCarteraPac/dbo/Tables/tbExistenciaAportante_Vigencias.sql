CREATE TABLE [dbo].[tbExistenciaAportante_Vigencias] (
    [cnsctvo_vgnca_exstnca_aprtnte] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_exstnca_aprtnte]  [dbo].[udtConsecutivo] NULL,
    [cdgo_exstnca_aprtnte]          [dbo].[udtCodigo]      NULL,
    [dscrpcn_exstnca_aprtnte]       [dbo].[udtDescripcion] NULL,
    [inco_vgnca]                    DATETIME               NULL,
    [fn_vgnca]                      DATETIME               NULL,
    [fcha_crcn]                     DATETIME               NULL,
    [usro_crcn]                     [dbo].[udtUsuario]     NULL,
    [obsrvcns]                      [dbo].[udtObservacion] NULL,
    [vsble_usro]                    [dbo].[udtLogico]      NULL,
    [tme_stmp]                      ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbExistenciaAportante_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_exstnca_aprtnte] ASC),
    CONSTRAINT [FK_tbExistenciaAportante_Vigencias_tbExistenciaAportante] FOREIGN KEY ([cnsctvo_cdgo_exstnca_aprtnte]) REFERENCES [dbo].[tbExistenciaAportante] ([cnsctvo_cdgo_exstnca_aprtnte])
);

