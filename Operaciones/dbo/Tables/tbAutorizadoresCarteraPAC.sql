CREATE TABLE [dbo].[tbAutorizadoresCarteraPAC] (
    [cnsctvo_cdgo_atrzdr_nta] [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_atrzdr_nta]         [dbo].[udtCodigo]      NULL,
    [dscrpcn_atrzdr_nta]      [dbo].[udtDescripcion] NULL,
    [fcha_crcn]               DATETIME               NULL,
    [usro_crcn]               [dbo].[udtUsuario]     NULL,
    [vsble_usro]              [dbo].[udtLogico]      NULL,
    CONSTRAINT [PK_ttbAutorizadoresCarteraPAC] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_atrzdr_nta] ASC)
);

