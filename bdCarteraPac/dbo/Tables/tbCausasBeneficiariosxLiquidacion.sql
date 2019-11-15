CREATE TABLE [dbo].[tbCausasBeneficiariosxLiquidacion] (
    [cnsctvo_csa_bnfcro_lqdcn]  INT        NOT NULL,
    [nmro_unco_idntfccn_bnfcro] INT        NULL,
    [cnsctvo_cdgo_tpo_cntrto]   INT        NULL,
    [nmro_cntrto]               CHAR (15)  NULL,
    [nmro_unco_idntfccn_empldr] INT        NULL,
    [cnsctvo_scrsl]             INT        NULL,
    [cnsctvo_cdgo_clse_aprtnte] INT        NULL,
    [cnsctvo_bnfcro]            INT        NULL,
    [cnsctvo_cdgo_csa]          INT        NULL,
    [cnsctvo_cdgo_lqdcn]        INT        NULL,
    [tme_stmp]                  ROWVERSION NULL,
    CONSTRAINT [Pk_tbCausasBeneficiariosxLiquidacion] PRIMARY KEY CLUSTERED ([cnsctvo_csa_bnfcro_lqdcn] ASC)
);


GO
CREATE STATISTICS [cnsctvo_csa_bnfcro_lqdcn]
    ON [dbo].[tbCausasBeneficiariosxLiquidacion]([cnsctvo_csa_bnfcro_lqdcn]);


GO
CREATE STATISTICS [nmro_unco_idntfccn_bnfcro]
    ON [dbo].[tbCausasBeneficiariosxLiquidacion]([nmro_unco_idntfccn_bnfcro]);


GO
CREATE STATISTICS [cnsctvo_cdgo_tpo_cntrto]
    ON [dbo].[tbCausasBeneficiariosxLiquidacion]([cnsctvo_cdgo_tpo_cntrto]);


GO
CREATE STATISTICS [nmro_cntrto]
    ON [dbo].[tbCausasBeneficiariosxLiquidacion]([nmro_cntrto]);


GO
CREATE STATISTICS [nmro_unco_idntfccn_empldr]
    ON [dbo].[tbCausasBeneficiariosxLiquidacion]([nmro_unco_idntfccn_empldr]);


GO
CREATE STATISTICS [cnsctvo_scrsl]
    ON [dbo].[tbCausasBeneficiariosxLiquidacion]([cnsctvo_scrsl]);


GO
CREATE STATISTICS [cnsctvo_cdgo_clse_aprtnte]
    ON [dbo].[tbCausasBeneficiariosxLiquidacion]([cnsctvo_cdgo_clse_aprtnte]);


GO
CREATE STATISTICS [cnsctvo_bnfcro]
    ON [dbo].[tbCausasBeneficiariosxLiquidacion]([cnsctvo_bnfcro]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbCausasBeneficiariosxLiquidacion]([tme_stmp]);

