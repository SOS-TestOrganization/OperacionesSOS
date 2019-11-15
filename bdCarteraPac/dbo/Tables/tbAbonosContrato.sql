CREATE TABLE [dbo].[tbAbonosContrato] (
    [cnsctvo_cdgo_pgo]          [dbo].[udtConsecutivo] NULL,
    [cnsctvo_estdo_cnta_cntrto] [dbo].[udtConsecutivo] NOT NULL,
    [vlr_abno_cta]              [dbo].[udtValorGrande] NOT NULL,
    [vlr_abno_iva]              [dbo].[udtValorGrande] NOT NULL,
    [Pgdo_Cmsn]                 [dbo].[udtLogico]      NULL,
    [tme_stmp]                  ROWVERSION             NOT NULL,
    [vlr_abno_rtfnte]           [dbo].[udtValorGrande] NULL,
    [vlr_abno_rtca]             [dbo].[udtValorGrande] NULL,
    [vlr_abno_estmpllas]        [dbo].[udtValorGrande] NULL,
    [vlr_abno_otrs]             [dbo].[udtValorGrande] NULL,
    [cnsctvo_abno_cntrto]       [dbo].[udtConsecutivo] IDENTITY (1, 1) NOT NULL,
    [cnsctvo_abno]              [dbo].[udtConsecutivo] NULL,
    [fcha_crcn]                 DATETIME               CONSTRAINT [DF_tbAbonosContrato_fcha_crcn] DEFAULT (getdate()) NULL,
    CONSTRAINT [pk_tbAbonosContrato_cnsctvo_abno_cntrto] PRIMARY KEY CLUSTERED ([cnsctvo_abno_cntrto] ASC),
    CONSTRAINT [FK_tbAbonosContrato_tbAbonos] FOREIGN KEY ([cnsctvo_abno]) REFERENCES [dbo].[tbAbonos] ([cnsctvo_abno]),
    CONSTRAINT [FK_tbAbonosContrato_tbEstadosCuentaContratos] FOREIGN KEY ([cnsctvo_estdo_cnta_cntrto]) REFERENCES [dbo].[tbEstadosCuentaContratos] ([cnsctvo_estdo_cnta_cntrto]),
    CONSTRAINT [FK_tbAbonosContrato_tbPagos] FOREIGN KEY ([cnsctvo_cdgo_pgo]) REFERENCES [dbo].[tbPagos] ([cnsctvo_cdgo_pgo])
);


GO
CREATE NONCLUSTERED INDEX [ix_EstadoCuentaContratos]
    ON [dbo].[tbAbonosContrato]([cnsctvo_estdo_cnta_cntrto] ASC);

