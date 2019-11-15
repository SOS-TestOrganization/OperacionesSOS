CREATE TABLE [dbo].[tbNotasConceptos] (
    [Cnsctvo_nta_cncpto]        [dbo].[udtConsecutivo] NOT NULL,
    [nmro_nta]                  VARCHAR (15)           NOT NULL,
    [cnsctvo_cdgo_tpo_nta]      [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_cncpto_lqdcn] [dbo].[udtConsecutivo] NOT NULL,
    [vlr_nta]                   [dbo].[udtValorGrande] NOT NULL,
    [tme_stmp]                  ROWVERSION             NOT NULL,
    CONSTRAINT [PK_TbNotasConceptos] PRIMARY KEY CLUSTERED ([Cnsctvo_nta_cncpto] ASC),
    CONSTRAINT [FK_tbNotasConceptos_tbConceptosliquidacion] FOREIGN KEY ([cnsctvo_cdgo_cncpto_lqdcn]) REFERENCES [dbo].[tbConceptosLiquidacion] ([cnsctvo_cdgo_cncpto_lqdcn]),
    CONSTRAINT [FK_tbNotasConceptos_tbNotasPac] FOREIGN KEY ([nmro_nta], [cnsctvo_cdgo_tpo_nta]) REFERENCES [dbo].[tbNotasPac] ([nmro_nta], [cnsctvo_cdgo_tpo_nta]),
    CONSTRAINT [FK_tbNotasConceptos_tbTiposNotas] FOREIGN KEY ([cnsctvo_cdgo_tpo_nta]) REFERENCES [dbo].[tbTiposNotas] ([cnsctvo_cdgo_tpo_nta])
);

