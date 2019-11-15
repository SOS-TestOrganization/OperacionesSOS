CREATE TABLE [dbo].[tbTiemposAfiliacion] (
    [cnsctvo_tmpo_aflcn]        [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_clsfccn_tmpo] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_pln]          [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_tpo_afldo]    [dbo].[udtConsecutivo] NULL,
    [nmro_unco_idntfccn_afldo]  [dbo].[udtConsecutivo] NOT NULL,
    [inco_vgnca_tmpo]           DATETIME               NOT NULL,
    [fn_vgnca_tmpo]             DATETIME               NOT NULL,
    [ds_rngo]                   NUMERIC (18)           NOT NULL,
    [ttl_ds_rngo]               INT                    NOT NULL,
    [cnsctvo_cdgo_orgn_tmpo]    [dbo].[udtConsecutivo] NOT NULL,
    [estdo_rgstro]              [dbo].[udtLogico]      NOT NULL,
    [inco_drcn_rgstro]          DATETIME               NOT NULL,
    [fn_drcn_rgstro]            DATETIME               NOT NULL,
    [fcha_ultma_mdfccn]         DATETIME               NOT NULL,
    [tme_stmp]                  ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbTiemposAfiliacion] PRIMARY KEY CLUSTERED ([cnsctvo_tmpo_aflcn] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_nmro_unco_idntfccn]
    ON [dbo].[tbTiemposAfiliacion]([nmro_unco_idntfccn_afldo] ASC);

