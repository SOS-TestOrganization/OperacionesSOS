CREATE TABLE [dbo].[tbConceptosDIAN_Vigencias] (
    [cnsctvo_vgnca_cncpto_dn] [dbo].[udtConsecutivo] IDENTITY (1, 1) NOT NULL,
    [cnsctvo_cdgo_cncpto_dn]  [dbo].[udtConsecutivo] NULL,
    [cdgo_cncpto_dn]          [dbo].[udtCodigo]      NULL,
    [dscrpcn_cncpto_dn]       [dbo].[udtDescripcion] NULL,
    [inco_vgnca]              DATETIME               NULL,
    [fn_vgnca]                DATETIME               NULL,
    [fcha_crcn]               DATETIME               NULL,
    [usro_crcn]               [dbo].[udtUsuario]     NULL,
    [obsrvcns]                [dbo].[udtObservacion] NULL,
    [vsble_usro]              [dbo].[udtLogico]      NULL,
    [fcha_ultma_mdfccn]       DATETIME               NULL,
    [usro_ultma_mdfccn]       [dbo].[udtUsuario]     NULL,
    [cnsctvo_cdgo_tpo_nta]    [dbo].[udtConsecutivo] NULL,
    CONSTRAINT [PK_tbConceptosDIAN_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_cncpto_dn] ASC),
    CONSTRAINT [FK_tbConceptosDIAN_Vigencias_tbConceptosDIAN] FOREIGN KEY ([cnsctvo_cdgo_cncpto_dn]) REFERENCES [dbo].[tbConceptosDIAN] ([cnsctvo_cdgo_cncpto_dn]),
    CONSTRAINT [FK_tbConceptosDIAN_Vigencias_tbTiposNotas] FOREIGN KEY ([cnsctvo_cdgo_tpo_nta]) REFERENCES [dbo].[tbTiposNotas] ([cnsctvo_cdgo_tpo_nta])
);

