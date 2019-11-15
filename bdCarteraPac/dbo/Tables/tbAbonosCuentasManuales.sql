CREATE TABLE [dbo].[tbAbonosCuentasManuales] (
    [cnsctvo_cdgo_pgo] [dbo].[udtConsecutivo] NOT NULL,
    [nmro_estdo_cnta]  VARCHAR (15)           NOT NULL,
    [vlr_abno_cta]     [dbo].[udtValorGrande] NOT NULL,
    [vlr_abno_iva]     [dbo].[udtValorGrande] NOT NULL,
    [tme_stmp]         ROWVERSION             NOT NULL,
    CONSTRAINT [PK_TbAbonosCuentasManuales] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_pgo] ASC, [nmro_estdo_cnta] ASC),
    CONSTRAINT [FK_tbAbonosCuentasManuales_tbCuentasManuales] FOREIGN KEY ([nmro_estdo_cnta]) REFERENCES [dbo].[tbCuentasManuales] ([nmro_estdo_cnta]),
    CONSTRAINT [FK_tbAbonosCuentasManuales_tbPagos] FOREIGN KEY ([cnsctvo_cdgo_pgo]) REFERENCES [dbo].[tbPagos] ([cnsctvo_cdgo_pgo])
);


GO
CREATE STATISTICS [nmro_estdo_cnta]
    ON [dbo].[tbAbonosCuentasManuales]([nmro_estdo_cnta], [cnsctvo_cdgo_pgo]);


GO
CREATE STATISTICS [vlr_abno_cta]
    ON [dbo].[tbAbonosCuentasManuales]([vlr_abno_cta], [cnsctvo_cdgo_pgo], [nmro_estdo_cnta]);


GO
CREATE STATISTICS [vlr_abno_iva]
    ON [dbo].[tbAbonosCuentasManuales]([vlr_abno_iva], [cnsctvo_cdgo_pgo], [nmro_estdo_cnta]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbAbonosCuentasManuales]([tme_stmp]);

