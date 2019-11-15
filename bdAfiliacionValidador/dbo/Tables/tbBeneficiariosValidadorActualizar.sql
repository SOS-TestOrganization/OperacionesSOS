CREATE TABLE [dbo].[tbBeneficiariosValidadorActualizar] (
    [cnsctvo_cdgo_tpo_cntrto]     INT           NOT NULL,
    [nmro_cntrto]                 CHAR (15)     NOT NULL,
    [cnsctvo_bnfcro]              INT           NOT NULL,
    [nmro_unco_idntfccn_afldo]    INT           NOT NULL,
    [cnsctvo_cdgo_tpo_idntfccn]   INT           NOT NULL,
    [nmro_idntfccn]               VARCHAR (20)  NOT NULL,
    [inco_vgnca_bnfcro]           DATETIME      NOT NULL,
    [fn_vgnca_bnfcro]             DATETIME      NOT NULL,
    [cnsctvo_cdgo_tpo_afldo]      INT           NOT NULL,
    [cnsctvo_cdgo_prntsco]        INT           NOT NULL,
    [estdo]                       CHAR (1)      NOT NULL,
    [prmr_aplldo]                 CHAR (50)     NOT NULL,
    [sgndo_aplldo]                CHAR (50)     NOT NULL,
    [prmr_nmbre]                  CHAR (20)     NOT NULL,
    [sgndo_nmbre]                 CHAR (20)     NOT NULL,
    [smns_ctzds]                  INT           NOT NULL,
    [smns_ctzds_antrr_eps]        INT           NOT NULL,
    [tlfno_rsdnca]                CHAR (30)     NOT NULL,
    [drccn_rsdnca]                VARCHAR (80)  NOT NULL,
    [cnsctvo_cdgo_cdd_rsdnca]     INT           NOT NULL,
    [cdgo_intrno]                 CHAR (8)      NOT NULL,
    [cnsctvo_cdgo_sxo]            INT           NOT NULL,
    [cnsctvo_cdgo_estdo_cvl]      INT           NOT NULL,
    [fcha_ncmnto]                 DATETIME      NOT NULL,
    [cnsctvo_cdgo_brro]           INT           NOT NULL,
    [cnsctvo_cdgo_estrto_sccnmco] INT           NOT NULL,
    [smns_aflcn]                  INT           NOT NULL,
    [smns_aflcn_antrr_eps]        INT           NOT NULL,
    [eml]                         VARCHAR (50)  NULL,
    [cmpo_actlzdo]                VARCHAR (100) NOT NULL,
    CONSTRAINT [PK_tbBeneficiariosValidadorActualizar] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_tpo_cntrto] ASC, [nmro_cntrto] ASC, [cnsctvo_bnfcro] ASC, [cmpo_actlzdo] ASC)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidadorActualizar] TO [Analistas]
    AS [dbo];

