CREATE TABLE [dbo].[tbPagosNotas] (
    [nmro_nta]                 VARCHAR (15)           NOT NULL,
    [cnsctvo_cdgo_tpo_nta]     [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_pgo]         [dbo].[udtConsecutivo] NULL,
    [vlr]                      [dbo].[udtValorGrande] NOT NULL,
    [tme_stmp]                 ROWVERSION             NOT NULL,
    [cnsctvo_pgo_nta]          [dbo].[udtConsecutivo] IDENTITY (1, 1) NOT NULL,
    [cnsctvo_tpo_dcmtno]       [dbo].[udtConsecutivo] NULL,
    [cnsctvo_cdgo_tpo_dcmnto]  [dbo].[udtConsecutivo] NULL,
    [cnsctvo_cdgo_tpo_nta_pgo] [dbo].[udtConsecutivo] NULL,
    [nmro_nta_pgo]             VARCHAR (15)           NULL,
    [cnsctvo_slctd_pgo]        [dbo].[udtConsecutivo] NULL,
    CONSTRAINT [pk_tbPagosNotas_cnsctvo_pgo_nta] PRIMARY KEY CLUSTERED ([cnsctvo_pgo_nta] ASC),
    CONSTRAINT [FK_tbPagosNotas_tbNotasPac] FOREIGN KEY ([nmro_nta], [cnsctvo_cdgo_tpo_nta]) REFERENCES [dbo].[tbNotasPac] ([nmro_nta], [cnsctvo_cdgo_tpo_nta]),
    CONSTRAINT [FK_tbPagosNotas_tbNotasPac_Pagos] FOREIGN KEY ([nmro_nta_pgo], [cnsctvo_cdgo_tpo_nta_pgo]) REFERENCES [dbo].[tbNotasPac] ([nmro_nta], [cnsctvo_cdgo_tpo_nta]),
    CONSTRAINT [FK_tbPagosNotas_tbPagos] FOREIGN KEY ([cnsctvo_cdgo_pgo]) REFERENCES [dbo].[tbPagos] ([cnsctvo_cdgo_pgo]),
    CONSTRAINT [FK_tbPagosNotas_tbTipoDocumentos] FOREIGN KEY ([cnsctvo_cdgo_tpo_dcmnto]) REFERENCES [dbo].[tbTipoDocumentos] ([cnsctvo_cdgo_tpo_dcmnto]),
    CONSTRAINT [FK_tbPagosNotas_tbTiposNotas] FOREIGN KEY ([cnsctvo_cdgo_tpo_nta]) REFERENCES [dbo].[tbTiposNotas] ([cnsctvo_cdgo_tpo_nta])
);


GO
CREATE STATISTICS [vlr]
    ON [dbo].[tbPagosNotas]([vlr], [nmro_nta], [cnsctvo_cdgo_tpo_nta], [cnsctvo_cdgo_pgo]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbPagosNotas]([tme_stmp]);

