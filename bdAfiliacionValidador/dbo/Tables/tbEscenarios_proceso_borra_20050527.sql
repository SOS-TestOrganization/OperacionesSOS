CREATE TABLE [dbo].[tbEscenarios_proceso_borra_20050527] (
    [cnsctvo_cdgo_mdlo_cnvno]            [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_mdlo_cptcn_escnro]     [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_cdd]                   [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_itm_cptcn]             [dbo].[udtConsecutivo] NOT NULL,
    [fcha_dsde]                          DATETIME               NOT NULL,
    [fcha_hsta]                          DATETIME               NOT NULL,
    [tsa_uso]                            FLOAT (53)             NULL,
    [cnsctvo_cdgo_nvl]                   [dbo].[udtConsecutivo] NOT NULL,
    [instrccn_whre]                      VARCHAR (300)          NULL,
    [cnsctvo_prcso_crcn]                 [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_prcso_actcn]                [dbo].[udtConsecutivo] NULL,
    [fcha_fd]                            DATETIME               NULL,
    [fcha_mdfccn]                        DATETIME               NOT NULL,
    [cntdd_usrs]                         INT                    NULL,
    [cnsctvo_cdgo_mdlo_cnvno_cptcn_trfa] [dbo].[udtConsecutivo] NULL,
    [tsa_cdd]                            FLOAT (53)             NULL,
    [vlr_bse]                            FLOAT (53)             NULL,
    [prcntje]                            FLOAT (53)             NULL,
    [dscrpcn_nvl]                        [dbo].[udtDescripcion] NULL,
    [dscrpcn_itm_cptcn]                  [dbo].[udtDescripcion] NULL,
    [dscrpcn_cdd]                        [dbo].[udtDescripcion] NULL,
    [dscrpcn_cnvno]                      [dbo].[udtDescripcion] NULL,
    [dscrpcn_tpo_escnro]                 [dbo].[udtDescripcion] NULL,
    CONSTRAINT [PK_tbEscenarios_proceso] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_mdlo_cnvno] ASC, [cnsctvo_cdgo_mdlo_cptcn_escnro] ASC, [cnsctvo_cdgo_cdd] ASC, [cnsctvo_cdgo_itm_cptcn] ASC, [fcha_dsde] ASC)
);


GO
CREATE STATISTICS [cnsctvo_cdgo_mdlo_cptcn_escnro]
    ON [dbo].[tbEscenarios_proceso_borra_20050527]([cnsctvo_cdgo_mdlo_cptcn_escnro], [cnsctvo_cdgo_mdlo_cnvno], [cnsctvo_cdgo_cdd], [cnsctvo_cdgo_itm_cptcn], [fcha_dsde]);


GO
CREATE STATISTICS [cnsctvo_cdgo_cdd]
    ON [dbo].[tbEscenarios_proceso_borra_20050527]([cnsctvo_cdgo_cdd], [cnsctvo_cdgo_mdlo_cnvno], [cnsctvo_cdgo_mdlo_cptcn_escnro], [cnsctvo_cdgo_itm_cptcn], [fcha_dsde]);


GO
CREATE STATISTICS [cnsctvo_cdgo_itm_cptcn]
    ON [dbo].[tbEscenarios_proceso_borra_20050527]([cnsctvo_cdgo_itm_cptcn], [cnsctvo_cdgo_mdlo_cnvno], [cnsctvo_cdgo_mdlo_cptcn_escnro], [cnsctvo_cdgo_cdd], [fcha_dsde]);


GO
CREATE STATISTICS [fcha_dsde]
    ON [dbo].[tbEscenarios_proceso_borra_20050527]([fcha_dsde], [cnsctvo_cdgo_mdlo_cnvno], [cnsctvo_cdgo_mdlo_cptcn_escnro], [cnsctvo_cdgo_cdd], [cnsctvo_cdgo_itm_cptcn]);


GO
CREATE STATISTICS [fcha_hsta]
    ON [dbo].[tbEscenarios_proceso_borra_20050527]([fcha_hsta], [cnsctvo_cdgo_mdlo_cnvno], [cnsctvo_cdgo_mdlo_cptcn_escnro], [cnsctvo_cdgo_cdd], [cnsctvo_cdgo_itm_cptcn], [fcha_dsde]);


GO
CREATE STATISTICS [tsa_uso]
    ON [dbo].[tbEscenarios_proceso_borra_20050527]([tsa_uso], [cnsctvo_cdgo_mdlo_cnvno], [cnsctvo_cdgo_mdlo_cptcn_escnro], [cnsctvo_cdgo_cdd], [cnsctvo_cdgo_itm_cptcn], [fcha_dsde]);


GO
CREATE STATISTICS [cnsctvo_cdgo_nvl]
    ON [dbo].[tbEscenarios_proceso_borra_20050527]([cnsctvo_cdgo_nvl], [cnsctvo_cdgo_mdlo_cnvno], [cnsctvo_cdgo_mdlo_cptcn_escnro], [cnsctvo_cdgo_cdd], [cnsctvo_cdgo_itm_cptcn], [fcha_dsde]);


GO
CREATE STATISTICS [instrccn_whre]
    ON [dbo].[tbEscenarios_proceso_borra_20050527]([instrccn_whre], [cnsctvo_cdgo_mdlo_cnvno], [cnsctvo_cdgo_mdlo_cptcn_escnro], [cnsctvo_cdgo_cdd], [cnsctvo_cdgo_itm_cptcn], [fcha_dsde]);


GO
CREATE STATISTICS [cnsctvo_prcso_crcn]
    ON [dbo].[tbEscenarios_proceso_borra_20050527]([cnsctvo_prcso_crcn], [cnsctvo_cdgo_mdlo_cnvno], [cnsctvo_cdgo_mdlo_cptcn_escnro], [cnsctvo_cdgo_cdd], [cnsctvo_cdgo_itm_cptcn], [fcha_dsde]);


GO
CREATE STATISTICS [cnsctvo_prcso_actcn]
    ON [dbo].[tbEscenarios_proceso_borra_20050527]([cnsctvo_prcso_actcn], [cnsctvo_cdgo_mdlo_cnvno], [cnsctvo_cdgo_mdlo_cptcn_escnro], [cnsctvo_cdgo_cdd], [cnsctvo_cdgo_itm_cptcn], [fcha_dsde]);


GO
CREATE STATISTICS [fcha_fd]
    ON [dbo].[tbEscenarios_proceso_borra_20050527]([fcha_fd], [cnsctvo_cdgo_mdlo_cnvno], [cnsctvo_cdgo_mdlo_cptcn_escnro], [cnsctvo_cdgo_cdd], [cnsctvo_cdgo_itm_cptcn], [fcha_dsde]);


GO
CREATE STATISTICS [fcha_mdfccn]
    ON [dbo].[tbEscenarios_proceso_borra_20050527]([fcha_mdfccn], [cnsctvo_cdgo_mdlo_cnvno], [cnsctvo_cdgo_mdlo_cptcn_escnro], [cnsctvo_cdgo_cdd], [cnsctvo_cdgo_itm_cptcn], [fcha_dsde]);


GO
CREATE STATISTICS [cntdd_usrs]
    ON [dbo].[tbEscenarios_proceso_borra_20050527]([cntdd_usrs], [cnsctvo_cdgo_mdlo_cnvno], [cnsctvo_cdgo_mdlo_cptcn_escnro], [cnsctvo_cdgo_cdd], [cnsctvo_cdgo_itm_cptcn], [fcha_dsde]);


GO
CREATE STATISTICS [cnsctvo_cdgo_mdlo_cnvno_cptcn_trfa]
    ON [dbo].[tbEscenarios_proceso_borra_20050527]([cnsctvo_cdgo_mdlo_cnvno_cptcn_trfa], [cnsctvo_cdgo_mdlo_cnvno], [cnsctvo_cdgo_mdlo_cptcn_escnro], [cnsctvo_cdgo_cdd], [cnsctvo_cdgo_itm_cptcn], [fcha_dsde]);


GO
CREATE STATISTICS [tsa_cdd]
    ON [dbo].[tbEscenarios_proceso_borra_20050527]([tsa_cdd], [cnsctvo_cdgo_mdlo_cnvno], [cnsctvo_cdgo_mdlo_cptcn_escnro], [cnsctvo_cdgo_cdd], [cnsctvo_cdgo_itm_cptcn], [fcha_dsde]);


GO
CREATE STATISTICS [vlr_bse]
    ON [dbo].[tbEscenarios_proceso_borra_20050527]([vlr_bse], [cnsctvo_cdgo_mdlo_cnvno], [cnsctvo_cdgo_mdlo_cptcn_escnro], [cnsctvo_cdgo_cdd], [cnsctvo_cdgo_itm_cptcn], [fcha_dsde]);


GO
CREATE STATISTICS [prcntje]
    ON [dbo].[tbEscenarios_proceso_borra_20050527]([prcntje], [cnsctvo_cdgo_mdlo_cnvno], [cnsctvo_cdgo_mdlo_cptcn_escnro], [cnsctvo_cdgo_cdd], [cnsctvo_cdgo_itm_cptcn], [fcha_dsde]);


GO
CREATE STATISTICS [dscrpcn_nvl]
    ON [dbo].[tbEscenarios_proceso_borra_20050527]([dscrpcn_nvl], [cnsctvo_cdgo_mdlo_cnvno], [cnsctvo_cdgo_mdlo_cptcn_escnro], [cnsctvo_cdgo_cdd], [cnsctvo_cdgo_itm_cptcn], [fcha_dsde]);


GO
CREATE STATISTICS [dscrpcn_itm_cptcn]
    ON [dbo].[tbEscenarios_proceso_borra_20050527]([dscrpcn_itm_cptcn], [cnsctvo_cdgo_mdlo_cnvno], [cnsctvo_cdgo_mdlo_cptcn_escnro], [cnsctvo_cdgo_cdd], [cnsctvo_cdgo_itm_cptcn], [fcha_dsde]);


GO
CREATE STATISTICS [dscrpcn_cdd]
    ON [dbo].[tbEscenarios_proceso_borra_20050527]([dscrpcn_cdd], [cnsctvo_cdgo_mdlo_cnvno], [cnsctvo_cdgo_mdlo_cptcn_escnro], [cnsctvo_cdgo_cdd], [cnsctvo_cdgo_itm_cptcn], [fcha_dsde]);


GO
CREATE STATISTICS [dscrpcn_cnvno]
    ON [dbo].[tbEscenarios_proceso_borra_20050527]([dscrpcn_cnvno], [cnsctvo_cdgo_mdlo_cnvno], [cnsctvo_cdgo_mdlo_cptcn_escnro], [cnsctvo_cdgo_cdd], [cnsctvo_cdgo_itm_cptcn], [fcha_dsde]);


GO
CREATE STATISTICS [dscrpcn_tpo_escnro]
    ON [dbo].[tbEscenarios_proceso_borra_20050527]([dscrpcn_tpo_escnro], [cnsctvo_cdgo_mdlo_cnvno], [cnsctvo_cdgo_mdlo_cptcn_escnro], [cnsctvo_cdgo_cdd], [cnsctvo_cdgo_itm_cptcn], [fcha_dsde]);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_proceso_borra_20050527] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_proceso_borra_20050527] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_proceso_borra_20050527] TO [Consulta]
    AS [dbo];

