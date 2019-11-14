CREATE TABLE [dbo].[tbcontratosdesafiliadosXmoraPac] (
    [Cnsctvo_cntrto_dsfldo_mra_pac] INT                         NOT NULL,
    [nmro_cntrto]                   [dbo].[udtNumeroFormulario] NULL,
    [cnsctvo_cdgo_tpo_cntrto]       INT                         NULL,
    [cnsctvo_cbrnza]                INT                         NULL,
    [nmro_unco_idntfccn_empldr]     INT                         NULL,
    [cnsctvo_scrsl]                 INT                         NULL,
    [cnsctvo_cdgo_clse_aprtnte]     INT                         NULL,
    [cnsctvo_cdgo_lqdcn]            INT                         NULL,
    [estdo]                         CHAR (1)                    NULL,
    [fcha_nvdd]                     DATETIME                    NULL,
    [dsfldo]                        CHAR (1)                    NULL,
    CONSTRAINT [PK_tbcontratosdesafiliadosXmoraPac] PRIMARY KEY CLUSTERED ([Cnsctvo_cntrto_dsfldo_mra_pac] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE STATISTICS [estdo]
    ON [dbo].[tbcontratosdesafiliadosXmoraPac]([estdo], [Cnsctvo_cntrto_dsfldo_mra_pac]);


GO
CREATE STATISTICS [fcha_nvdd]
    ON [dbo].[tbcontratosdesafiliadosXmoraPac]([fcha_nvdd], [Cnsctvo_cntrto_dsfldo_mra_pac]);

