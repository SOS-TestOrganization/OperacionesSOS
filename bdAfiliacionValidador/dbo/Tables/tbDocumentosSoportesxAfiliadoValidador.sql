CREATE TABLE [dbo].[tbDocumentosSoportesxAfiliadoValidador] (
    [cnsctvo_dcmnto]            [dbo].[udtConsecutivo]      NOT NULL,
    [nmro_unco_idntfccn_afldo]  [dbo].[udtConsecutivo]      NOT NULL,
    [nmro_unco_idntfccn_bnfcro] [dbo].[udtConsecutivo]      NOT NULL,
    [cnsctvo_cdgo_tpo_dcmnto]   [dbo].[udtConsecutivo]      NOT NULL,
    [inco_vgnca_dcmnto]         DATETIME                    NOT NULL,
    [fn_vgnca_dcmnto]           DATETIME                    NOT NULL,
    [cnsctvo_cdgo_tpo_frmlro]   [dbo].[udtConsecutivo]      NOT NULL,
    [nmro_frmlro]               [dbo].[udtNumeroFormulario] NOT NULL,
    [estdo_rgstro]              [dbo].[udtLogico]           NOT NULL,
    [inco_drcn_rgstro]          DATETIME                    NOT NULL,
    [fn_drcn_rgstro]            DATETIME                    NOT NULL,
    [fcha_ultma_mdfccn]         DATETIME                    NOT NULL,
    [usro_mdfccn]               [dbo].[udtUsuario]          NULL,
    [trspsdo]                   [dbo].[udtLogico]           NOT NULL,
    [tme_stmp]                  ROWVERSION                  NOT NULL,
    CONSTRAINT [PK_tbDocumentosSoportesxAfiliado] PRIMARY KEY CLUSTERED ([cnsctvo_dcmnto] ASC, [nmro_unco_idntfccn_bnfcro] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_ContratoBeneficiario]
    ON [dbo].[tbDocumentosSoportesxAfiliadoValidador]([nmro_unco_idntfccn_bnfcro] ASC);


GO
CREATE NONCLUSTERED INDEX [_dba_idx_tbDocumentosSoportesxAfiliado_01]
    ON [dbo].[tbDocumentosSoportesxAfiliadoValidador]([nmro_unco_idntfccn_bnfcro] ASC, [cnsctvo_dcmnto] ASC, [cnsctvo_cdgo_tpo_dcmnto] ASC)
    INCLUDE([inco_vgnca_dcmnto], [fn_vgnca_dcmnto], [estdo_rgstro]);


GO
CREATE NONCLUSTERED INDEX [idx_cnsctvo_cdgo_tpo_dcmnto]
    ON [dbo].[tbDocumentosSoportesxAfiliadoValidador]([cnsctvo_cdgo_tpo_dcmnto] ASC, [inco_vgnca_dcmnto] ASC, [fn_vgnca_dcmnto] ASC)
    INCLUDE([nmro_unco_idntfccn_afldo]) WITH (FILLFACTOR = 80)
    ON [FG_INDEXES];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbDocumentosSoportesxAfiliadoValidador] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDocumentosSoportesxAfiliadoValidador] TO [autsalud_rol]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbDocumentosSoportesxAfiliadoValidador] TO [autsalud_rol]
    AS [dbo];

