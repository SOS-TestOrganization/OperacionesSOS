CREATE TABLE [dbo].[TbAbonosNotasContrato] (
    [cnsctvo_cdgo_pgo]        [dbo].[udtConsecutivo] NULL,
    [cnsctvo_nta_cntrto]      [dbo].[udtConsecutivo] NOT NULL,
    [vlr_nta_cta]             [dbo].[udtValorGrande] NULL,
    [vlr_nta_iva]             [dbo].[udtValorGrande] NULL,
    [Pgdo_Cmsn]               [dbo].[udtLogico]      NULL,
    [tme_stmp]                ROWVERSION             NULL,
    [cnsctvo_abno_nta_cntrto] [dbo].[udtConsecutivo] IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_tbAbonosNotasContrato] PRIMARY KEY CLUSTERED ([cnsctvo_abno_nta_cntrto] ASC),
    CONSTRAINT [FK_TbAbonosNotasContrato_tbNotasContrato] FOREIGN KEY ([cnsctvo_nta_cntrto]) REFERENCES [dbo].[tbNotasContrato] ([cnsctvo_nta_cntrto]),
    CONSTRAINT [FK_TbAbonosNotasContrato_tbPagos] FOREIGN KEY ([cnsctvo_cdgo_pgo]) REFERENCES [dbo].[tbPagos] ([cnsctvo_cdgo_pgo])
);

