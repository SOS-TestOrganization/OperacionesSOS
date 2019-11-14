CREATE TABLE [dbo].[tbExistenciaAportante] (
    [cnsctvo_cdgo_exstnca_aprtnte] [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_exstnca_aprtnte]         [dbo].[udtCodigo]      NULL,
    [dscrpcn_exstnca_aprtnte]      [dbo].[udtDescripcion] NULL,
    [fcha_crcn]                    DATETIME               NULL,
    [usro_crcn]                    [dbo].[udtUsuario]     NULL,
    [vsble_usro]                   [dbo].[udtLogico]      NULL,
    CONSTRAINT [PK_tbExistenciaAportante] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_exstnca_aprtnte] ASC)
);

