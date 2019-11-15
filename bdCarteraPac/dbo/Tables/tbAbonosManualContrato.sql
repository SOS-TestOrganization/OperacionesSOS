CREATE TABLE [dbo].[tbAbonosManualContrato] (
    [cnsctvo_cdgo_pgo]         [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cnta_mnls_cntrto] [dbo].[udtConsecutivo] NOT NULL,
    [Vlr_abno_cta]             [dbo].[udtValorGrande] NOT NULL,
    [Vlr_abno_iva]             [dbo].[udtValorGrande] NOT NULL,
    [tme_stmp]                 ROWVERSION             NOT NULL,
    CONSTRAINT [PK_TbAbonosManualContrato] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_pgo] ASC, [cnsctvo_cnta_mnls_cntrto] ASC),
    CONSTRAINT [FK_tbAbonosManualContrato_tbCuentasManualesContrato] FOREIGN KEY ([cnsctvo_cnta_mnls_cntrto]) REFERENCES [dbo].[tbCuentasManualesContrato] ([cnsctvo_cnta_mnls_cntrto]),
    CONSTRAINT [FK_tbAbonosManualContrato_tbPagos] FOREIGN KEY ([cnsctvo_cdgo_pgo]) REFERENCES [dbo].[tbPagos] ([cnsctvo_cdgo_pgo])
);


GO
CREATE STATISTICS [cnsctvo_cnta_mnls_cntrto]
    ON [dbo].[tbAbonosManualContrato]([cnsctvo_cnta_mnls_cntrto], [cnsctvo_cdgo_pgo]);


GO
CREATE STATISTICS [Vlr_abno_cta]
    ON [dbo].[tbAbonosManualContrato]([Vlr_abno_cta], [cnsctvo_cdgo_pgo], [cnsctvo_cnta_mnls_cntrto]);


GO
CREATE STATISTICS [Vlr_abno_iva]
    ON [dbo].[tbAbonosManualContrato]([Vlr_abno_iva], [cnsctvo_cdgo_pgo], [cnsctvo_cnta_mnls_cntrto]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbAbonosManualContrato]([tme_stmp]);

