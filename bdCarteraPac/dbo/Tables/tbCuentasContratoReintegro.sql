CREATE TABLE [dbo].[tbCuentasContratoReintegro] (
    [cnsctvo_nta_cntrto]        [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_nta_cncpto]        [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_estdo_cnta_cntrto] [dbo].[udtConsecutivo] NOT NULL,
    [vlr_rntgro]                [dbo].[udtValorGrande] NOT NULL,
    [tme_stmp]                  ROWVERSION             NULL,
    [cnsctvo_cdgo_tpo_dcmnto]   [dbo].[udtConsecutivo] NULL,
    CONSTRAINT [PK_tbCuentasContratoReintegro] PRIMARY KEY CLUSTERED ([cnsctvo_nta_cntrto] ASC, [cnsctvo_nta_cncpto] ASC, [cnsctvo_estdo_cnta_cntrto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tbCuentasContratoReintegro_tbEstadosCuentaContratos] FOREIGN KEY ([cnsctvo_estdo_cnta_cntrto]) REFERENCES [dbo].[tbEstadosCuentaContratos] ([cnsctvo_estdo_cnta_cntrto]),
    CONSTRAINT [FK_tbCuentasContratoReintegro_tbNotasContratoxConcepto] FOREIGN KEY ([cnsctvo_nta_cntrto], [cnsctvo_nta_cncpto]) REFERENCES [dbo].[tbNotasContratoxConcepto] ([cnsctvo_nta_cntrto], [cnsctvo_nta_cncpto])
);


GO
ALTER TABLE [dbo].[tbCuentasContratoReintegro] NOCHECK CONSTRAINT [FK_tbCuentasContratoReintegro_tbEstadosCuentaContratos];


GO
CREATE NONCLUSTERED INDEX [ix_EstadoCuentaContratos]
    ON [dbo].[tbCuentasContratoReintegro]([cnsctvo_nta_cntrto] ASC, [cnsctvo_nta_cncpto] ASC) WITH (FILLFACTOR = 90);

