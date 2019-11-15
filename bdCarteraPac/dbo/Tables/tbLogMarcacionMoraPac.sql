CREATE TABLE [dbo].[tbLogMarcacionMoraPac] (
    [cnsctvo_mrccn_mra_pc]      INT                         NOT NULL,
    [cnsctvo_prcso]             [dbo].[udtConsecutivo]      NULL,
    [cnsctvo_cdgo_tpo_nvdd]     [dbo].[udtConsecutivo]      NULL,
    [cnsctvo_cdgo_csa_nvdd]     [dbo].[udtConsecutivo]      NULL,
    [fcha_nvdd]                 DATETIME                    NULL,
    [cnsctvo_nvdd]              [dbo].[udtNumeroFormulario] NULL,
    [cnsctvo_prcso_nvdd]        [dbo].[udtConsecutivo]      NULL,
    [cnsctvo_cdgo_tpo_cntrto]   [dbo].[udtConsecutivo]      NULL,
    [nmro_cntrto]               [dbo].[udtNumeroFormulario] NULL,
    [nmro_unco_idntfccn_bnfcro] [dbo].[udtConsecutivo]      NULL,
    [cnsctvo_bnfcro]            TINYINT                     NULL,
    [Estdo]                     CHAR (1)                    NULL,
    [cnsctvo_prcss_pc]          [dbo].[udtConsecutivo]      NULL,
    [nmro_unco_idntfccn_empldr] [dbo].[udtConsecutivo]      NULL,
    [cnsctvo_scrsl]             [dbo].[udtConsecutivo]      NULL,
    [cnsctvo_cdgo_clse_aprtnte] [dbo].[udtConsecutivo]      NULL,
    CONSTRAINT [PK_tbLogMarcacionMoraPac] PRIMARY KEY CLUSTERED ([cnsctvo_mrccn_mra_pc] ASC)
);


GO
CREATE STATISTICS [cnsctvo_prcso]
    ON [dbo].[tbLogMarcacionMoraPac]([cnsctvo_prcso], [cnsctvo_mrccn_mra_pc]);


GO
CREATE STATISTICS [cnsctvo_cdgo_tpo_nvdd]
    ON [dbo].[tbLogMarcacionMoraPac]([cnsctvo_cdgo_tpo_nvdd], [cnsctvo_mrccn_mra_pc]);


GO
CREATE STATISTICS [cnsctvo_cdgo_csa_nvdd]
    ON [dbo].[tbLogMarcacionMoraPac]([cnsctvo_cdgo_csa_nvdd], [cnsctvo_mrccn_mra_pc]);


GO
CREATE STATISTICS [cnsctvo_nvdd]
    ON [dbo].[tbLogMarcacionMoraPac]([cnsctvo_nvdd], [cnsctvo_mrccn_mra_pc]);


GO
CREATE STATISTICS [cnsctvo_prcso_nvdd]
    ON [dbo].[tbLogMarcacionMoraPac]([cnsctvo_prcso_nvdd], [cnsctvo_mrccn_mra_pc]);


GO
CREATE STATISTICS [cnsctvo_cdgo_tpo_cntrto]
    ON [dbo].[tbLogMarcacionMoraPac]([cnsctvo_cdgo_tpo_cntrto], [cnsctvo_mrccn_mra_pc]);


GO
CREATE STATISTICS [nmro_unco_idntfccn_bnfcro]
    ON [dbo].[tbLogMarcacionMoraPac]([nmro_unco_idntfccn_bnfcro], [cnsctvo_mrccn_mra_pc]);


GO
CREATE STATISTICS [cnsctvo_bnfcro]
    ON [dbo].[tbLogMarcacionMoraPac]([cnsctvo_bnfcro], [cnsctvo_mrccn_mra_pc]);


GO
CREATE STATISTICS [Estdo]
    ON [dbo].[tbLogMarcacionMoraPac]([Estdo], [cnsctvo_mrccn_mra_pc]);


GO
CREATE STATISTICS [cnsctvo_prcss_pc]
    ON [dbo].[tbLogMarcacionMoraPac]([cnsctvo_prcss_pc], [cnsctvo_mrccn_mra_pc]);


GO
CREATE STATISTICS [nmro_unco_idntfccn_empldr]
    ON [dbo].[tbLogMarcacionMoraPac]([nmro_unco_idntfccn_empldr], [cnsctvo_mrccn_mra_pc]);


GO
CREATE STATISTICS [cnsctvo_scrsl]
    ON [dbo].[tbLogMarcacionMoraPac]([cnsctvo_scrsl], [cnsctvo_mrccn_mra_pc]);


GO
CREATE STATISTICS [cnsctvo_cdgo_clse_aprtnte]
    ON [dbo].[tbLogMarcacionMoraPac]([cnsctvo_cdgo_clse_aprtnte], [cnsctvo_mrccn_mra_pc]);

