﻿CREATE TABLE [dbo].[tbEmpleadores] (
    [nmro_unco_idntfccn]                      [dbo].[udtConsecutivo]               NOT NULL,
    [cnsctvo_cdgo_clse_aprtnte]               [dbo].[udtConsecutivo]               NOT NULL,
    [nmbre_grnte]                             [dbo].[udtDescripcion]               NOT NULL,
    [jfe_rcrss_hmns]                          [dbo].[udtDescripcion]               NOT NULL,
    [nmbre_rprsntnte_lgl]                     [dbo].[udtDescripcion]               NOT NULL,
    [cnsctvo_cdgo_crgo_rprsntnte_lgl]         [dbo].[udtConsecutivo]               NOT NULL,
    [nmro_emplds]                             INT                                  NOT NULL,
    [obsrvcns]                                [dbo].[udtObservacion]               NOT NULL,
    [cntdd_scrsls]                            INT                                  NOT NULL,
    [cnsctvo_cdgo_clse_empldr]                [dbo].[udtConsecutivo]               NOT NULL,
    [cnsctvo_cdgo_tpo_aprtnte]                [dbo].[udtConsecutivo]               NOT NULL,
    [cnsctvo_cdgo_dclrcn_aprts]               [dbo].[udtConsecutivo]               NOT NULL,
    [cnsctvo_cdgo_tpo_emprsa]                 [dbo].[udtConsecutivo]               NOT NULL,
    [cnsctvo_cdgo_actvdd_ecnmca]              [dbo].[udtConsecutivo]               NOT NULL,
    [exprnca_lbrl_añs_indpndnte]              INT                                  NOT NULL,
    [exprnca_lbrl_mss_indpndnte]              INT                                  NOT NULL,
    [cnsctvo_cdgo_pscn_ocpcnl]                [dbo].[udtConsecutivo]               NOT NULL,
    [prdccn_agrpcra_indpndnte]                [dbo].[udtLogico]                    NOT NULL,
    [ultmo_ano_aprbdo_indpndnte]              [dbo].[udtConsecutivo]               NOT NULL,
    [cnsctvo_cdgo_nvl_edctvo]                 [dbo].[udtConsecutivo]               NOT NULL,
    [cnsctvo_cdgo_entdd_agrpdra]              [dbo].[udtConsecutivo]               NOT NULL,
    [cnsctvo_cdgo_grpo_ecnmco]                [dbo].[udtConsecutivo]               NOT NULL,
    [tme_stmp]                                ROWVERSION                           NOT NULL,
    [cnsctvo_cdgo_actvdd_ecnmca_indpndnte]    [dbo].[udtConsecutivo]               NOT NULL,
    [cnsctvo_cdgo_tpo_vvnda]                  [dbo].[udtConsecutivo]               NOT NULL,
    [cnsctvo_cdgo_tpo_idntfccn_rprsntnte_lgl] [dbo].[udtConsecutivo]               NOT NULL,
    [nmro_idntfccn_rprsntnte_lgl]             [dbo].[udtNumeroIdentificacionLargo] NOT NULL,
    CONSTRAINT [PK_tbEmpleadores] PRIMARY KEY NONCLUSTERED ([nmro_unco_idntfccn] ASC, [cnsctvo_cdgo_clse_aprtnte] ASC) WITH (FILLFACTOR = 90)
);
