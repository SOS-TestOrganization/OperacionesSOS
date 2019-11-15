CREATE TABLE [dbo].[tbNotasEstadoCuenta] (
    [nmro_nta]             VARCHAR (15)           NOT NULL,
    [cnsctvo_cdgo_tpo_nta] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_estdo_cnta]   [dbo].[udtConsecutivo] NOT NULL,
    [vlr]                  [dbo].[udtValorGrande] NOT NULL,
    [fcha_aplccn]          DATETIME               NOT NULL,
    [usro_aplccn]          [dbo].[udtUsuario]     NOT NULL,
    [tme_stmp]             ROWVERSION             NOT NULL,
    CONSTRAINT [PK_TbNotasEstadoCuenta] PRIMARY KEY CLUSTERED ([nmro_nta] ASC, [cnsctvo_cdgo_tpo_nta] ASC, [cnsctvo_estdo_cnta] ASC),
    CONSTRAINT [FK_tbNotasEstadoCuenta_tbEstadosCuenta] FOREIGN KEY ([cnsctvo_estdo_cnta]) REFERENCES [dbo].[tbEstadosCuenta] ([cnsctvo_estdo_cnta]),
    CONSTRAINT [FK_tbNotasEstadoCuenta_tbNotasPac] FOREIGN KEY ([nmro_nta], [cnsctvo_cdgo_tpo_nta]) REFERENCES [dbo].[tbNotasPac] ([nmro_nta], [cnsctvo_cdgo_tpo_nta]),
    CONSTRAINT [FK_tbNotasEstadoCuenta_tbTiposNotas] FOREIGN KEY ([cnsctvo_cdgo_tpo_nta]) REFERENCES [dbo].[tbTiposNotas] ([cnsctvo_cdgo_tpo_nta])
);


GO
CREATE NONCLUSTERED INDEX [ix_EstadoCuenta]
    ON [dbo].[tbNotasEstadoCuenta]([cnsctvo_estdo_cnta] ASC);


GO
CREATE STATISTICS [vlr]
    ON [dbo].[tbNotasEstadoCuenta]([vlr], [nmro_nta], [cnsctvo_cdgo_tpo_nta], [cnsctvo_estdo_cnta]);


GO
CREATE STATISTICS [fcha_aplccn]
    ON [dbo].[tbNotasEstadoCuenta]([fcha_aplccn], [nmro_nta], [cnsctvo_cdgo_tpo_nta], [cnsctvo_estdo_cnta]);


GO
CREATE STATISTICS [usro_aplccn]
    ON [dbo].[tbNotasEstadoCuenta]([usro_aplccn], [nmro_nta], [cnsctvo_cdgo_tpo_nta], [cnsctvo_estdo_cnta]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbNotasEstadoCuenta]([tme_stmp]);

