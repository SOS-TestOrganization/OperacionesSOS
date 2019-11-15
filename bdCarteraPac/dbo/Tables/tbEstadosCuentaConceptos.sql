CREATE TABLE [dbo].[tbEstadosCuentaConceptos] (
    [cnsctvo_estdo_cnta_cncpto] [dbo].[udtConsecutivo]  NOT NULL,
    [cnsctvo_estdo_cnta]        [dbo].[udtConsecutivo]  NOT NULL,
    [cnsctvo_cdgo_cncpto_lqdcn] [dbo].[udtConsecutivo]  NOT NULL,
    [vlr_cbrdo]                 [dbo].[udtValorGrande]  NOT NULL,
    [sldo]                      NUMERIC (12)            NOT NULL,
    [cntdd]                     [dbo].[udtValorPequeno] NOT NULL,
    [tme_stmp]                  ROWVERSION              NOT NULL,
    CONSTRAINT [PK_TbEstadosCuentaConceptos] PRIMARY KEY CLUSTERED ([cnsctvo_estdo_cnta_cncpto] ASC),
    CONSTRAINT [FK_tbEstadosCuentaConceptos_tbConceptosliquidacion] FOREIGN KEY ([cnsctvo_cdgo_cncpto_lqdcn]) REFERENCES [dbo].[tbConceptosLiquidacion] ([cnsctvo_cdgo_cncpto_lqdcn]),
    CONSTRAINT [FK_tbEstadosCuentaConceptos_tbEstadosCuenta] FOREIGN KEY ([cnsctvo_estdo_cnta]) REFERENCES [dbo].[tbEstadosCuenta] ([cnsctvo_estdo_cnta])
);


GO
CREATE NONCLUSTERED INDEX [ix_EstadoCuenta]
    ON [dbo].[tbEstadosCuentaConceptos]([cnsctvo_estdo_cnta] ASC);

