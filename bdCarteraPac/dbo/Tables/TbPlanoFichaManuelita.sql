CREATE TABLE [dbo].[TbPlanoFichaManuelita] (
    [cnsctvo_plno_fcha_mnlta]   INT                         NOT NULL,
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
    CONSTRAINT [PK_TbPlanoFichaManuelita] PRIMARY KEY CLUSTERED ([cnsctvo_plno_fcha_mnlta] ASC)
);


GO
CREATE STATISTICS [nmro_fcha]
    ON [dbo].[TbPlanoFichaManuelita]([nmro_fcha], [cnsctvo_plno_fcha_mnlta]);


GO
CREATE STATISTICS [tpo_empldo]
    ON [dbo].[TbPlanoFichaManuelita]([tpo_empldo], [cnsctvo_plno_fcha_mnlta]);


GO
CREATE STATISTICS [cnsctvo_cdgo_tpo_cntrto]
    ON [dbo].[TbPlanoFichaManuelita]([cnsctvo_cdgo_tpo_cntrto], [cnsctvo_plno_fcha_mnlta]);


GO
CREATE STATISTICS [nmro_cntrto]
    ON [dbo].[TbPlanoFichaManuelita]([nmro_cntrto], [cnsctvo_plno_fcha_mnlta]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[TbPlanoFichaManuelita]([tme_stmp]);

