CREATE TABLE [dbo].[tbAbonos] (
    [cnsctvo_cdgo_pgo]        [dbo].[udtConsecutivo] NULL,
    [cnsctvo_estdo_cnta]      [dbo].[udtConsecutivo] NOT NULL,
    [vlr_abno]                [dbo].[udtValorGrande] NOT NULL,
    [extmprno]                [dbo].[udtLogico]      NULL,
    [tme_stmp]                ROWVERSION             NOT NULL,
    [cnsctvo_abno]            [dbo].[udtConsecutivo] IDENTITY (1, 1) NOT NULL,
    [cnsctvo_cdgo_tpo_nta]    [dbo].[udtConsecutivo] NULL,
    [nmro_nta]                VARCHAR (15)           NULL,
    [fcha_crcn]               DATETIME               CONSTRAINT [DF_tbAbonos_fcha_crcn] DEFAULT (getdate()) NULL,
    [cnsctvo_cdgo_tpo_dcmnto] [dbo].[udtConsecutivo] NULL,
    CONSTRAINT [pk_tbAbonos_cnsctvo_abno] PRIMARY KEY CLUSTERED ([cnsctvo_abno] ASC),
    CONSTRAINT [FK_tbAbonos_tbEstadosCuenta] FOREIGN KEY ([cnsctvo_estdo_cnta]) REFERENCES [dbo].[tbEstadosCuenta] ([cnsctvo_estdo_cnta]),
    CONSTRAINT [FK_tbAbonos_tbPagos] FOREIGN KEY ([cnsctvo_cdgo_pgo]) REFERENCES [dbo].[tbPagos] ([cnsctvo_cdgo_pgo])
);


GO
CREATE NONCLUSTERED INDEX [ix_EstadoCuenta]
    ON [dbo].[tbAbonos]([cnsctvo_estdo_cnta] ASC);


GO
CREATE STATISTICS [vlr_abno]
    ON [dbo].[tbAbonos]([vlr_abno], [cnsctvo_cdgo_pgo], [cnsctvo_estdo_cnta]);


GO
CREATE STATISTICS [extmprno]
    ON [dbo].[tbAbonos]([extmprno], [cnsctvo_cdgo_pgo], [cnsctvo_estdo_cnta]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbAbonos]([tme_stmp]);

