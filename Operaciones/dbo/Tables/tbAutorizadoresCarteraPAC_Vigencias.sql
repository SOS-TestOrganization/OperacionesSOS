CREATE TABLE [dbo].[tbAutorizadoresCarteraPAC_Vigencias] (
    [cnsctvo_vgnca_atrzdr_nta] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_atrzdr_nta]  [dbo].[udtConsecutivo] NULL,
    [cdgo_atrzdr_nta]          [dbo].[udtCodigo]      NULL,
    [dscrpcn_atrzdr_nta]       [dbo].[udtDescripcion] NULL,
    [inco_vgnca]               DATETIME               NULL,
    [fn_vgnca]                 DATETIME               NULL,
    [fcha_crcn]                DATETIME               NULL,
    [usro_crcn]                [dbo].[udtUsuario]     NULL,
    [obsrvcns]                 [dbo].[udtObservacion] NULL,
    [vsble_usro]               [dbo].[udtLogico]      NULL,
    [tme_stmp]                 ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbAutorizadoresCarteraPAC_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_atrzdr_nta] ASC),
    CONSTRAINT [FK_tbAutorizadoresCarteraPAC_Vigencias_tbAutorizadoresCarteraPAC] FOREIGN KEY ([cnsctvo_cdgo_atrzdr_nta]) REFERENCES [dbo].[tbAutorizadoresCarteraPAC] ([cnsctvo_cdgo_atrzdr_nta])
);

