CREATE TABLE [dbo].[TbPagosConceptos] (
    [cnsctvo_pgo_cncpto]        [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_cncpto_lqdcn] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_pgo]          [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_estdo_cnta_cncpto] [dbo].[udtConsecutivo] NULL,
    [vlr_pgo]                   [dbo].[udtValorGrande] NOT NULL,
    [tme_stmp]                  ROWVERSION             NOT NULL,
    [fcha_crcn]                 DATETIME               CONSTRAINT [DF_tbPagosConceptos_fcha_crcn] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_TbPagosConceptos] PRIMARY KEY CLUSTERED ([cnsctvo_pgo_cncpto] ASC),
    CONSTRAINT [FK_TbPagosConceptos_tbConceptosLiquidacion] FOREIGN KEY ([cnsctvo_cdgo_cncpto_lqdcn]) REFERENCES [dbo].[tbConceptosLiquidacion] ([cnsctvo_cdgo_cncpto_lqdcn]),
    CONSTRAINT [FK_TbPagosConceptos_tbPagos] FOREIGN KEY ([cnsctvo_cdgo_pgo]) REFERENCES [dbo].[tbPagos] ([cnsctvo_cdgo_pgo])
);


GO
CREATE NONCLUSTERED INDEX [ix_EstadoCuenta]
    ON [dbo].[TbPagosConceptos]([cnsctvo_estdo_cnta_cncpto] ASC);

