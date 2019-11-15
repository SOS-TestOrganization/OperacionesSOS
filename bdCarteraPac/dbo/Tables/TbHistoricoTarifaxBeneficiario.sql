CREATE TABLE [dbo].[TbHistoricoTarifaxBeneficiario] (
    [cnsctvo_hstrco_trfa_bnfcro] INT                         NOT NULL,
    [cnsctvo_vgnca_cbrnza]       INT                         NULL,
    [cnsctvo_cdgo_tpo_cntrto]    INT                         NULL,
    [nmro_cntrto]                [dbo].[udtNumeroFormulario] NULL,
    [cnsctvo_cbrnza]             INT                         NULL,
    [cnsctvo_bnfcro]             INT                         NULL,
    [nmro_unco_idntfccn_bnfcro]  INT                         NULL,
    [nmro_unco_idntfccn_afldo]   INT                         NULL,
    [nmro_unco_idntfccn_empldr]  INT                         NULL,
    [cnsctvo_cdgo_clse_aprtnte]  INT                         NULL,
    [cnsctvo_scrsl]              INT                         NULL,
    [cnsctvo_cdgo_lqdcn]         INT                         NULL,
    [vlr_upc_antrr]              [dbo].[udtValorGrande]      NULL,
    [vlr_upc_nvo]                [dbo].[udtValorGrande]      NULL,
    [vlr_rl_pgo_antrr]           [dbo].[udtValorGrande]      NULL,
    [vlr_rl_pgo_nvo]             [dbo].[udtValorGrande]      NULL,
    [fcha_crcn]                  DATETIME                    NULL,
    [usro_crcn]                  [dbo].[udtUsuario]          NULL,
    [tme_stmp]                   ROWVERSION                  NULL,
    CONSTRAINT [PK_TbHistoricoTarifaxBeneficiario] PRIMARY KEY CLUSTERED ([cnsctvo_hstrco_trfa_bnfcro] ASC)
);


GO
CREATE STATISTICS [cnsctvo_vgnca_cbrnza]
    ON [dbo].[TbHistoricoTarifaxBeneficiario]([cnsctvo_vgnca_cbrnza], [cnsctvo_hstrco_trfa_bnfcro]);


GO
CREATE STATISTICS [cnsctvo_cdgo_tpo_cntrto]
    ON [dbo].[TbHistoricoTarifaxBeneficiario]([cnsctvo_cdgo_tpo_cntrto], [cnsctvo_hstrco_trfa_bnfcro]);


GO
CREATE STATISTICS [nmro_cntrto]
    ON [dbo].[TbHistoricoTarifaxBeneficiario]([nmro_cntrto], [cnsctvo_hstrco_trfa_bnfcro]);


GO
CREATE STATISTICS [cnsctvo_cbrnza]
    ON [dbo].[TbHistoricoTarifaxBeneficiario]([cnsctvo_cbrnza], [cnsctvo_hstrco_trfa_bnfcro]);


GO
CREATE STATISTICS [cnsctvo_bnfcro]
    ON [dbo].[TbHistoricoTarifaxBeneficiario]([cnsctvo_bnfcro], [cnsctvo_hstrco_trfa_bnfcro]);


GO
CREATE STATISTICS [nmro_unco_idntfccn_bnfcro]
    ON [dbo].[TbHistoricoTarifaxBeneficiario]([nmro_unco_idntfccn_bnfcro], [cnsctvo_hstrco_trfa_bnfcro]);


GO
CREATE STATISTICS [nmro_unco_idntfccn_afldo]
    ON [dbo].[TbHistoricoTarifaxBeneficiario]([nmro_unco_idntfccn_afldo], [cnsctvo_hstrco_trfa_bnfcro]);


GO
CREATE STATISTICS [vlr_upc_antrr]
    ON [dbo].[TbHistoricoTarifaxBeneficiario]([vlr_upc_antrr], [cnsctvo_hstrco_trfa_bnfcro]);


GO
CREATE STATISTICS [vlr_upc_nvo]
    ON [dbo].[TbHistoricoTarifaxBeneficiario]([vlr_upc_nvo], [cnsctvo_hstrco_trfa_bnfcro]);


GO
CREATE STATISTICS [vlr_rl_pgo_antrr]
    ON [dbo].[TbHistoricoTarifaxBeneficiario]([vlr_rl_pgo_antrr], [cnsctvo_hstrco_trfa_bnfcro]);


GO
CREATE STATISTICS [vlr_rl_pgo_nvo]
    ON [dbo].[TbHistoricoTarifaxBeneficiario]([vlr_rl_pgo_nvo], [cnsctvo_hstrco_trfa_bnfcro]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[TbHistoricoTarifaxBeneficiario]([usro_crcn], [cnsctvo_hstrco_trfa_bnfcro]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[TbHistoricoTarifaxBeneficiario]([tme_stmp]);

