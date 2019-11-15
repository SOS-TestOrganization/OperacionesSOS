CREATE TABLE [dbo].[tbdetmodeloTecnicasBonificacion20111004] (
    [cnsctvo_dtlle_mdlo_tcncs_bnfccn] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_mdlo]                    [dbo].[udtConsecutivo] NOT NULL,
    [Cnsctvo_cdgo_itm_bnfccn]         [dbo].[udtConsecutivo] NOT NULL,
    [Cnsctvo_cdgo_rngo_slrl]          [dbo].[udtConsecutivo] NOT NULL,
    [Cnsctvo_cdgo_tps_entdd_prstdr]   [dbo].[udtConsecutivo] NOT NULL,
    [Cnsctvo_cdgo_tpo_afldo]          [dbo].[udtConsecutivo] NOT NULL,
    [Bnfcro_adcnl]                    [dbo].[udtLogico]      NOT NULL,
    [Cnsctvo_cdgo_frma_atncn]         [dbo].[udtConsecutivo] NOT NULL,
    [Cnsctvo_cdgo_tcnca_lqdcn]        [dbo].[udtConsecutivo] NOT NULL,
    [Vlr_tcnca_lqdcn]                 NUMERIC (12, 2)        NULL,
    [Nmro_actvdds]                    INT                    NOT NULL,
    [Cnsctvo_cdgo_frma_rcbro]         [dbo].[udtConsecutivo] NULL,
    [Cnsctvo_cdgo_tpo_rcbro]          [dbo].[udtConsecutivo] NULL,
    [Vlr_frma_rcbro]                  NUMERIC (12, 2)        NULL,
    [Usro_crcn]                       [dbo].[udtUsuario]     NOT NULL,
    [fcha_crcn]                       DATETIME               NOT NULL,
    [Usro_ultma_mdfccn]               [dbo].[udtUsuario]     NULL,
    [Fcha_ultma_mdfccn]               DATETIME               NULL,
    [tme_stmp]                        ROWVERSION             NULL
);

