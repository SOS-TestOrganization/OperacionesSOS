CREATE TABLE [dbo].[tbHistoricoTarificacionXProceso] (
    [cnsctvo_hstrco_prcso_lqdcn] INT         NOT NULL,
    [nmro_unco_idntfccn]         INT         NULL,
    [edd_bnfcro]                 INT         NULL,
    [cnsctvo_cdgo_pln]           INT         NULL,
    [ps_ss]                      VARCHAR (1) NULL,
    [fcha_aflcn_pc]              DATETIME    NULL,
    [cnsctvo_cdgo_prntsco]       INT         NULL,
    [cnsctvo_cdgo_tpo_afldo]     INT         NULL,
    [Dscpctdo]                   VARCHAR (1) NULL,
    [Estdnte]                    VARCHAR (1) NULL,
    [Antgdd_hcu]                 VARCHAR (1) NULL,
    [Atrzdo_sn_Ps]               VARCHAR (1) NULL,
    [grpo_bsco]                  VARCHAR (1) NULL,
    [cnsctvo_cdgo_tpo_cntrto]    INT         NULL,
    [nmro_cntrto]                CHAR (15)   NULL,
    [cnsctvo_bnfcro]             INT         NULL,
    [cnsctvo_cbrnza]             INT         NULL,
    [grupo]                      INT         NULL,
    [cnsctvo_prdcto]             INT         NULL,
    [cnsctvo_mdlo]               INT         NULL,
    [vlr_upc]                    INT         NULL,
    [vlr_rl_pgo]                 INT         NULL,
    [cnsctvo_cdgo_tps_cbro]      INT         NULL,
    [Cobranza_Con_producto]      INT         NULL,
    [Beneficiario_Con_producto]  INT         NULL,
    [Con_Modelo]                 INT         NULL,
    [grupo_tarificacion]         INT         NULL,
    [igual_plan]                 INT         NULL,
    [grupo_modelo]               INT         NULL,
    [nmro_unco_idntfccn_empldr]  INT         NULL,
    [cnsctvo_scrsl]              INT         NULL,
    [cnsctvo_cdgo_clse_aprtnte]  INT         NULL,
    [cnsctvo_cdgo_lqdcn]         INT         NULL,
    [inco_vgnca_cntrto]          DATETIME    NULL,
    [fcha_incl_prdo_lqdcn]       DATETIME    NULL,
    [bnfcdo_pc]                  CHAR (1)    NULL,
    [tmp_stmp]                   ROWVERSION  NULL,
    CONSTRAINT [PK_tbHistoricoTarificacionXProceso] PRIMARY KEY CLUSTERED ([cnsctvo_hstrco_prcso_lqdcn] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ix_tbhistoricotarificacionxproceso]
    ON [dbo].[tbHistoricoTarificacionXProceso]([nmro_cntrto] ASC, [cnsctvo_cdgo_tpo_cntrto] ASC, [cnsctvo_bnfcro] ASC, [nmro_unco_idntfccn] ASC, [cnsctvo_cdgo_lqdcn] ASC) WITH (FILLFACTOR = 90);


GO
CREATE STATISTICS [edd_bnfcro]
    ON [dbo].[tbHistoricoTarificacionXProceso]([edd_bnfcro], [cnsctvo_hstrco_prcso_lqdcn]);


GO
CREATE STATISTICS [cnsctvo_cdgo_pln]
    ON [dbo].[tbHistoricoTarificacionXProceso]([cnsctvo_cdgo_pln], [cnsctvo_hstrco_prcso_lqdcn]);


GO
CREATE STATISTICS [fcha_aflcn_pc]
    ON [dbo].[tbHistoricoTarificacionXProceso]([fcha_aflcn_pc], [cnsctvo_hstrco_prcso_lqdcn]);


GO
CREATE STATISTICS [cnsctvo_cdgo_prntsco]
    ON [dbo].[tbHistoricoTarificacionXProceso]([cnsctvo_cdgo_prntsco], [cnsctvo_hstrco_prcso_lqdcn]);


GO
CREATE STATISTICS [cnsctvo_cdgo_tpo_afldo]
    ON [dbo].[tbHistoricoTarificacionXProceso]([cnsctvo_cdgo_tpo_afldo], [cnsctvo_hstrco_prcso_lqdcn]);


GO
CREATE STATISTICS [Dscpctdo]
    ON [dbo].[tbHistoricoTarificacionXProceso]([Dscpctdo], [cnsctvo_hstrco_prcso_lqdcn]);


GO
CREATE STATISTICS [Estdnte]
    ON [dbo].[tbHistoricoTarificacionXProceso]([Estdnte], [cnsctvo_hstrco_prcso_lqdcn]);


GO
CREATE STATISTICS [Antgdd_hcu]
    ON [dbo].[tbHistoricoTarificacionXProceso]([Antgdd_hcu], [cnsctvo_hstrco_prcso_lqdcn]);


GO
CREATE STATISTICS [grpo_bsco]
    ON [dbo].[tbHistoricoTarificacionXProceso]([grpo_bsco], [cnsctvo_hstrco_prcso_lqdcn]);


GO
CREATE STATISTICS [cnsctvo_cbrnza]
    ON [dbo].[tbHistoricoTarificacionXProceso]([cnsctvo_cbrnza], [cnsctvo_hstrco_prcso_lqdcn]);


GO
CREATE STATISTICS [cnsctvo_mdlo]
    ON [dbo].[tbHistoricoTarificacionXProceso]([cnsctvo_mdlo], [cnsctvo_hstrco_prcso_lqdcn]);


GO
CREATE STATISTICS [vlr_upc]
    ON [dbo].[tbHistoricoTarificacionXProceso]([vlr_upc], [cnsctvo_hstrco_prcso_lqdcn]);


GO
CREATE STATISTICS [Cobranza_Con_producto]
    ON [dbo].[tbHistoricoTarificacionXProceso]([Cobranza_Con_producto], [cnsctvo_hstrco_prcso_lqdcn]);


GO
CREATE STATISTICS [Beneficiario_Con_producto]
    ON [dbo].[tbHistoricoTarificacionXProceso]([Beneficiario_Con_producto], [cnsctvo_hstrco_prcso_lqdcn]);


GO
CREATE STATISTICS [Con_Modelo]
    ON [dbo].[tbHistoricoTarificacionXProceso]([Con_Modelo], [cnsctvo_hstrco_prcso_lqdcn]);


GO
CREATE STATISTICS [grupo_tarificacion]
    ON [dbo].[tbHistoricoTarificacionXProceso]([grupo_tarificacion], [cnsctvo_hstrco_prcso_lqdcn]);


GO
CREATE STATISTICS [igual_plan]
    ON [dbo].[tbHistoricoTarificacionXProceso]([igual_plan], [cnsctvo_hstrco_prcso_lqdcn]);


GO
CREATE STATISTICS [grupo_modelo]
    ON [dbo].[tbHistoricoTarificacionXProceso]([grupo_modelo], [cnsctvo_hstrco_prcso_lqdcn]);


GO
CREATE STATISTICS [cnsctvo_scrsl]
    ON [dbo].[tbHistoricoTarificacionXProceso]([cnsctvo_scrsl], [cnsctvo_hstrco_prcso_lqdcn]);


GO
CREATE STATISTICS [cnsctvo_cdgo_clse_aprtnte]
    ON [dbo].[tbHistoricoTarificacionXProceso]([cnsctvo_cdgo_clse_aprtnte], [cnsctvo_hstrco_prcso_lqdcn]);


GO
CREATE STATISTICS [inco_vgnca_cntrto]
    ON [dbo].[tbHistoricoTarificacionXProceso]([inco_vgnca_cntrto], [cnsctvo_hstrco_prcso_lqdcn]);


GO
CREATE STATISTICS [bnfcdo_pc]
    ON [dbo].[tbHistoricoTarificacionXProceso]([bnfcdo_pc], [cnsctvo_hstrco_prcso_lqdcn]);


GO
CREATE STATISTICS [tmp_stmp]
    ON [dbo].[tbHistoricoTarificacionXProceso]([tmp_stmp]);

