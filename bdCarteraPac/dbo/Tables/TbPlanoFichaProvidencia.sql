CREATE TABLE [dbo].[TbPlanoFichaProvidencia] (
    [cnsctvo_plno_fcha_prvdnca] INT                         NOT NULL,
    [nmro_fcha]                 CHAR (20)                   NULL,
    [nmro_unco_idntfccn]        INT                         NULL,
    [tpo_empldo]                CHAR (1)                    NULL,
    [nmro_unco_idntfccn_empldr] INT                         NULL,
    [cnsctvo_cdgo_clse_aprtnte] INT                         NULL,
    [cnsctvo_scrsl]             INT                         NULL,
    [cnsctvo_cdgo_tpo_cntrto]   INT                         NULL,
    [nmro_cntrto]               [dbo].[udtNumeroFormulario] NULL,
    [cdgo_aprtnte]              CHAR (20)                   NULL,
    [tme_stmp]                  ROWVERSION                  NULL,
    CONSTRAINT [Pk_TbPlanoFichaProvidencia] PRIMARY KEY CLUSTERED ([cnsctvo_plno_fcha_prvdnca] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE STATISTICS [cnsctvo_plno_fcha_prvdnca]
    ON [dbo].[TbPlanoFichaProvidencia]([cnsctvo_plno_fcha_prvdnca]);


GO
CREATE STATISTICS [nmro_fcha]
    ON [dbo].[TbPlanoFichaProvidencia]([nmro_fcha]);


GO
CREATE STATISTICS [tpo_empldo]
    ON [dbo].[TbPlanoFichaProvidencia]([tpo_empldo]);


GO
CREATE STATISTICS [cnsctvo_cdgo_clse_aprtnte]
    ON [dbo].[TbPlanoFichaProvidencia]([cnsctvo_cdgo_clse_aprtnte]);


GO
CREATE STATISTICS [cnsctvo_scrsl]
    ON [dbo].[TbPlanoFichaProvidencia]([cnsctvo_scrsl]);


GO
CREATE STATISTICS [cnsctvo_cdgo_tpo_cntrto]
    ON [dbo].[TbPlanoFichaProvidencia]([cnsctvo_cdgo_tpo_cntrto]);


GO
CREATE STATISTICS [nmro_cntrto]
    ON [dbo].[TbPlanoFichaProvidencia]([nmro_cntrto]);


GO
CREATE STATISTICS [cdgo_aprtnte]
    ON [dbo].[TbPlanoFichaProvidencia]([cdgo_aprtnte]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[TbPlanoFichaProvidencia]([tme_stmp]);

