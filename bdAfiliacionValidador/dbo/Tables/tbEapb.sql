CREATE TABLE [dbo].[tbEapb] (
    [cnsctvo_cdgo_tpo_idntfccn_bnfcro] [dbo].[udtConsecutivo]          NOT NULL,
    [nmro_idntfccn_bnfcro]             [dbo].[udtNumeroIdentificacion] NOT NULL,
    [cdgo_eapb]                        VARCHAR (3)                     NOT NULL,
    [cnsctvo_cdgo_pln]                 [dbo].[udtConsecutivo]          NOT NULL,
    [fcha_dsde]                        DATETIME                        NOT NULL,
    [fcha_hsta]                        DATETIME                        NOT NULL,
    [prmr_aplldo_bnfcro]               [dbo].[udtApellido]             NULL,
    [sgndo_aplldo_bnfcro]              [dbo].[udtApellido]             NULL,
    [prmr_nmbre_bnfcro]                [dbo].[udtNombre]               NULL,
    [sgndo_nmbre_bnfcro]               [dbo].[udtNombre]               NULL,
    [cnsctvo_bnfcro]                   [dbo].[udtConsecutivo]          NULL,
    [fcha_ncmnto]                      DATETIME                        NULL,
    [sxo]                              [dbo].[udtCodigo]               NULL,
    [rngo_slrl]                        [dbo].[udtCodigo]               NULL,
    [prntsco]                          [dbo].[udtCodigo]               NULL,
    [tpo_aprtnte]                      [dbo].[udtCodigo]               NULL,
    [smns_ctzds]                       [dbo].[udtConsecutivo]          NULL,
    [cdd_rsdnca]                       CHAR (8)                        NULL,
    [dpto_rsdnca]                      CHAR (2)                        NULL,
    [drccn]                            [dbo].[udtDireccion]            NULL,
    [tlfno]                            [dbo].[udtTelefono]             NULL,
    [ips]                              [dbo].[udtCodigoIps]            NULL,
    [ctza]                             [dbo].[udtLogico]               NULL,
    [adcnl]                            [dbo].[udtLogico]               NULL,
    [tpo_afldo]                        [dbo].[udtCodigo]               NULL,
    [inco_vgnca]                       DATETIME                        NULL,
    [fn_vgnca]                         DATETIME                        NULL,
    [tpo_idnfccn_ctznte]               [dbo].[udtTipoIdentificacion]   NULL,
    [nmro_idntfccn_ctznte]             [dbo].[udtNumeroIdentificacion] NULL,
    [prmr_aplldo_ctznte]               [dbo].[udtApellido]             NULL,
    [sgndo_aplldo_ctznte]              [dbo].[udtApellido]             NULL,
    [prmr_nmbre_ctznte]                [dbo].[udtNombre]               NULL,
    [sgndo_nmbre_ctznte]               [dbo].[udtNombre]               NULL,
    [tpo_idntfccn_emprsa]              [dbo].[udtTipoIdentificacion]   NULL,
    [nmro_idntfccn_emprsa]             [dbo].[udtNumeroIdentificacion] NULL,
    [estdo]                            CHAR (2)                        NULL,
    [emprsa]                           CHAR (40)                       NULL,
    [usro_ultma_mdfccn]                [dbo].[udtUsuario]              NULL,
    [fcha_ultma_mdfccn]                DATETIME                        NULL,
    [cdgo_pln]                         CHAR (3)                        NULL,
    [dscpcdd]                          [dbo].[udtLogico]               NULL,
    [usro_crga]                        [dbo].[udtUsuario]              NULL,
    [mqna_crga]                        [dbo].[udtUsuario]              NULL,
    [tpo_idntfccn_bnfcro]              [dbo].[udtTipoIdentificacion]   NOT NULL,
    [cnsctvo_cdgo_tpo_idnfccn_ctznte]  [dbo].[udtConsecutivo]          NULL,
    [cnsctvo_cdgo_tpo_idntfccn_emprsa] [dbo].[udtConsecutivo]          NULL,
    [cnsctvo_cdgo_sxo]                 [dbo].[udtConsecutivo]          NULL,
    [cnsctvo_cdgo_rngo_slrl]           [dbo].[udtConsecutivo]          NULL,
    [cnsctvo_cdgo_prntscs]             [dbo].[udtConsecutivo]          NULL,
    [cnsctvo_cdgo_tpo_aprtnte]         [dbo].[udtConsecutivo]          NULL,
    [cnsctvo_cdd_rsdnca]               [dbo].[udtConsecutivo]          NULL,
    [cnsctvo_cdgo_tpo_afldo]           [dbo].[udtConsecutivo]          NULL,
    [cnsctvo_cdgo_estdo]               [dbo].[udtConsecutivo]          NULL,
    CONSTRAINT [PK_tbEapb] PRIMARY KEY NONCLUSTERED ([cnsctvo_cdgo_tpo_idntfccn_bnfcro] ASC, [nmro_idntfccn_bnfcro] ASC, [cdgo_eapb] ASC, [cnsctvo_cdgo_pln] ASC, [fcha_dsde] ASC)
);


GO
CREATE CLUSTERED INDEX [IX_NuiBeneficiario]
    ON [dbo].[tbEapb]([cnsctvo_cdgo_tpo_idntfccn_bnfcro] ASC, [nmro_idntfccn_bnfcro] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_fcha_hsta]
    ON [dbo].[tbEapb]([fcha_hsta] ASC)
    INCLUDE([cnsctvo_cdgo_tpo_idntfccn_bnfcro], [nmro_idntfccn_bnfcro], [cnsctvo_cdgo_pln], [prmr_aplldo_bnfcro], [sgndo_aplldo_bnfcro], [prmr_nmbre_bnfcro], [sgndo_nmbre_bnfcro], [fcha_ncmnto], [prntsco], [inco_vgnca], [fn_vgnca], [cnsctvo_cdgo_tpo_afldo])
    ON [FG_INDEXES];


GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
    ON [dbo].[tbEapb]([cnsctvo_cdgo_pln] ASC, [fcha_hsta] ASC, [prmr_nmbre_bnfcro] ASC, [sgndo_nmbre_bnfcro] ASC)
    ON [FG_INDEXES];


GO
CREATE NONCLUSTERED INDEX [idx_cnsctvo_cdgo_pln]
    ON [dbo].[tbEapb]([cnsctvo_cdgo_pln] ASC, [fcha_hsta] ASC, [prmr_aplldo_bnfcro] ASC, [prmr_nmbre_bnfcro] ASC)
    ON [FG_INDEXES];


GO
CREATE STATISTICS [prmr_aplldo_bnfcro]
    ON [dbo].[tbEapb]([prmr_aplldo_bnfcro]);


GO
CREATE STATISTICS [sgndo_aplldo_bnfcro]
    ON [dbo].[tbEapb]([sgndo_aplldo_bnfcro]);


GO
CREATE STATISTICS [prmr_nmbre_bnfcro]
    ON [dbo].[tbEapb]([prmr_nmbre_bnfcro]);


GO
CREATE STATISTICS [sgndo_nmbre_bnfcro]
    ON [dbo].[tbEapb]([sgndo_nmbre_bnfcro]);


GO
CREATE STATISTICS [cnsctvo_bnfcro]
    ON [dbo].[tbEapb]([cnsctvo_bnfcro]);


GO
CREATE STATISTICS [fcha_ncmnto]
    ON [dbo].[tbEapb]([fcha_ncmnto]);


GO
CREATE STATISTICS [sxo]
    ON [dbo].[tbEapb]([sxo]);


GO
CREATE STATISTICS [rngo_slrl]
    ON [dbo].[tbEapb]([rngo_slrl]);


GO
CREATE STATISTICS [prntsco]
    ON [dbo].[tbEapb]([prntsco]);


GO
CREATE STATISTICS [tpo_aprtnte]
    ON [dbo].[tbEapb]([tpo_aprtnte]);


GO
CREATE STATISTICS [smns_ctzds]
    ON [dbo].[tbEapb]([smns_ctzds]);


GO
CREATE STATISTICS [cdd_rsdnca]
    ON [dbo].[tbEapb]([cdd_rsdnca]);


GO
CREATE STATISTICS [dpto_rsdnca]
    ON [dbo].[tbEapb]([dpto_rsdnca]);


GO
CREATE STATISTICS [drccn]
    ON [dbo].[tbEapb]([drccn]);


GO
CREATE STATISTICS [tlfno]
    ON [dbo].[tbEapb]([tlfno]);


GO
CREATE STATISTICS [ips]
    ON [dbo].[tbEapb]([ips]);


GO
CREATE STATISTICS [ctza]
    ON [dbo].[tbEapb]([ctza]);


GO
CREATE STATISTICS [adcnl]
    ON [dbo].[tbEapb]([adcnl]);


GO
CREATE STATISTICS [tpo_afldo]
    ON [dbo].[tbEapb]([tpo_afldo]);


GO
CREATE STATISTICS [inco_vgnca]
    ON [dbo].[tbEapb]([inco_vgnca]);


GO
CREATE STATISTICS [fn_vgnca]
    ON [dbo].[tbEapb]([fn_vgnca]);


GO
CREATE STATISTICS [tpo_idnfccn_ctznte]
    ON [dbo].[tbEapb]([tpo_idnfccn_ctznte]);


GO
CREATE STATISTICS [nmro_idntfccn_ctznte]
    ON [dbo].[tbEapb]([nmro_idntfccn_ctznte]);


GO
CREATE STATISTICS [prmr_aplldo_ctznte]
    ON [dbo].[tbEapb]([prmr_aplldo_ctznte]);


GO
CREATE STATISTICS [sgndo_aplldo_ctznte]
    ON [dbo].[tbEapb]([sgndo_aplldo_ctznte]);


GO
CREATE STATISTICS [prmr_nmbre_ctznte]
    ON [dbo].[tbEapb]([prmr_nmbre_ctznte]);


GO
CREATE STATISTICS [sgndo_nmbre_ctznte]
    ON [dbo].[tbEapb]([sgndo_nmbre_ctznte]);


GO
CREATE STATISTICS [tpo_idntfccn_emprsa]
    ON [dbo].[tbEapb]([tpo_idntfccn_emprsa]);


GO
CREATE STATISTICS [estdo]
    ON [dbo].[tbEapb]([estdo]);


GO
CREATE STATISTICS [emprsa]
    ON [dbo].[tbEapb]([emprsa]);


GO
CREATE STATISTICS [usro_ultma_mdfccn]
    ON [dbo].[tbEapb]([usro_ultma_mdfccn]);


GO
CREATE STATISTICS [fcha_ultma_mdfccn]
    ON [dbo].[tbEapb]([fcha_ultma_mdfccn]);


GO
CREATE STATISTICS [cdgo_pln]
    ON [dbo].[tbEapb]([cdgo_pln]);


GO
CREATE STATISTICS [dscpcdd]
    ON [dbo].[tbEapb]([dscpcdd]);


GO
CREATE STATISTICS [usro_crga]
    ON [dbo].[tbEapb]([usro_crga]);


GO
CREATE STATISTICS [mqna_crga]
    ON [dbo].[tbEapb]([mqna_crga]);


GO
CREATE STATISTICS [tpo_idntfccn_bnfcro]
    ON [dbo].[tbEapb]([tpo_idntfccn_bnfcro]);


GO
CREATE STATISTICS [cnsctvo_cdgo_tpo_idnfccn_ctznte]
    ON [dbo].[tbEapb]([cnsctvo_cdgo_tpo_idnfccn_ctznte]);


GO
CREATE STATISTICS [cnsctvo_cdgo_sxo]
    ON [dbo].[tbEapb]([cnsctvo_cdgo_sxo]);


GO
CREATE STATISTICS [cnsctvo_cdgo_rngo_slrl]
    ON [dbo].[tbEapb]([cnsctvo_cdgo_rngo_slrl]);


GO
CREATE STATISTICS [cnsctvo_cdgo_prntscs]
    ON [dbo].[tbEapb]([cnsctvo_cdgo_prntscs]);


GO
CREATE STATISTICS [cnsctvo_cdgo_tpo_aprtnte]
    ON [dbo].[tbEapb]([cnsctvo_cdgo_tpo_aprtnte]);


GO
CREATE STATISTICS [cnsctvo_cdd_rsdnca]
    ON [dbo].[tbEapb]([cnsctvo_cdd_rsdnca]);


GO
CREATE STATISTICS [cnsctvo_cdgo_tpo_afldo]
    ON [dbo].[tbEapb]([cnsctvo_cdgo_tpo_afldo]);


GO
CREATE STATISTICS [cnsctvo_cdgo_estdo]
    ON [dbo].[tbEapb]([cnsctvo_cdgo_estdo]);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEapb] TO [Analistas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbEapb] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEapb] TO [aut_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbEapb] TO [aut_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbEapb] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEapb] TO [autsalud_rol]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbEapb] TO [autsalud_rol]
    AS [dbo];

