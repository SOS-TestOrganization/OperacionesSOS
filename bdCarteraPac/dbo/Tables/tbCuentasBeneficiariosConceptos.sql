CREATE TABLE [dbo].[tbCuentasBeneficiariosConceptos] (
    [cnsctvo_estdo_cnta_cntrto_bnfcro] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_cncpto_lqdcn]        [dbo].[udtConsecutivo] NOT NULL,
    [vlr]                              [dbo].[udtValorGrande] NOT NULL,
    [tme_stmp]                         ROWVERSION             NOT NULL,
    CONSTRAINT [PK_TbCuentasBeneficiariosConceptos] PRIMARY KEY CLUSTERED ([cnsctvo_estdo_cnta_cntrto_bnfcro] ASC, [cnsctvo_cdgo_cncpto_lqdcn] ASC),
    CONSTRAINT [FK_tbCuentasBeneficiariosConceptos_tbConceptosliquidacion] FOREIGN KEY ([cnsctvo_cdgo_cncpto_lqdcn]) REFERENCES [dbo].[tbConceptosLiquidacion] ([cnsctvo_cdgo_cncpto_lqdcn]),
    CONSTRAINT [FK_tbCuentasBeneficiariosConceptos_tbCuentasContratosBeneficiarios] FOREIGN KEY ([cnsctvo_estdo_cnta_cntrto_bnfcro]) REFERENCES [dbo].[tbCuentasContratosBeneficiarios] ([cnsctvo_estdo_cnta_cntrto_bnfcro])
);


GO
CREATE NONCLUSTERED INDEX [ix_EstadoCuentaBeneficiarioConcepto]
    ON [dbo].[tbCuentasBeneficiariosConceptos]([cnsctvo_estdo_cnta_cntrto_bnfcro] ASC);

