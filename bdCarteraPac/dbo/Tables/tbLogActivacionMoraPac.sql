CREATE TABLE [dbo].[tbLogActivacionMoraPac] (
    [cnsctvo_actvcn_mra_pc]     INT                         NOT NULL,
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
    [nmro_unco_idntfccn_empldr] [dbo].[udtConsecutivo]      NULL,
    [cnsctvo_scrsl]             [dbo].[udtConsecutivo]      NULL,
    [cnsctvo_cdgo_clse_aprtnte] [dbo].[udtConsecutivo]      NULL,
    [fcha_crcn]                 DATETIME                    NULL,
    CONSTRAINT [PK_tbLogActivacionMoraPac] PRIMARY KEY CLUSTERED ([cnsctvo_actvcn_mra_pc] ASC)
);


GO
CREATE STATISTICS [cnsctvo_prcso]
    ON [dbo].[tbLogActivacionMoraPac]([cnsctvo_prcso], [cnsctvo_actvcn_mra_pc]);


GO
CREATE STATISTICS [cnsctvo_cdgo_tpo_nvdd]
    ON [dbo].[tbLogActivacionMoraPac]([cnsctvo_cdgo_tpo_nvdd], [cnsctvo_actvcn_mra_pc]);


GO
CREATE STATISTICS [cnsctvo_cdgo_csa_nvdd]
    ON [dbo].[tbLogActivacionMoraPac]([cnsctvo_cdgo_csa_nvdd], [cnsctvo_actvcn_mra_pc]);


GO
CREATE STATISTICS [cnsctvo_nvdd]
    ON [dbo].[tbLogActivacionMoraPac]([cnsctvo_nvdd], [cnsctvo_actvcn_mra_pc]);


GO
CREATE STATISTICS [cnsctvo_prcso_nvdd]
    ON [dbo].[tbLogActivacionMoraPac]([cnsctvo_prcso_nvdd], [cnsctvo_actvcn_mra_pc]);


GO
CREATE STATISTICS [cnsctvo_cdgo_tpo_cntrto]
    ON [dbo].[tbLogActivacionMoraPac]([cnsctvo_cdgo_tpo_cntrto], [cnsctvo_actvcn_mra_pc]);


GO
CREATE STATISTICS [nmro_unco_idntfccn_bnfcro]
    ON [dbo].[tbLogActivacionMoraPac]([nmro_unco_idntfccn_bnfcro], [cnsctvo_actvcn_mra_pc]);


GO
CREATE STATISTICS [cnsctvo_bnfcro]
    ON [dbo].[tbLogActivacionMoraPac]([cnsctvo_bnfcro], [cnsctvo_actvcn_mra_pc]);


GO
CREATE STATISTICS [nmro_unco_idntfccn_empldr]
    ON [dbo].[tbLogActivacionMoraPac]([nmro_unco_idntfccn_empldr], [cnsctvo_actvcn_mra_pc]);


GO
CREATE STATISTICS [cnsctvo_scrsl]
    ON [dbo].[tbLogActivacionMoraPac]([cnsctvo_scrsl], [cnsctvo_actvcn_mra_pc]);


GO
CREATE STATISTICS [cnsctvo_cdgo_clse_aprtnte]
    ON [dbo].[tbLogActivacionMoraPac]([cnsctvo_cdgo_clse_aprtnte], [cnsctvo_actvcn_mra_pc]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbLogActivacionMoraPac]([fcha_crcn], [cnsctvo_actvcn_mra_pc]);

