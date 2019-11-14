CREATE TABLE [dbo].[tbLogliquidacionesContratos] (
    [cnsctvo_cdgo_lqdcn]         [dbo].[udtConsecutivo]          NULL,
    [nmro_cntrto]                [dbo].[udtConsecutivo]          NULL,
    [cdgo_tpo_idntfccn]          [dbo].[udtTipoIdentificacion]   NULL,
    [nmro_idntfccn]              [dbo].[udtNumeroIdentificacion] NULL,
    [nombre]                     [dbo].[udtNombre]               NULL,
    [cnsctvo_cdgo_pln]           [dbo].[udtCodigo]               NULL,
    [inco_vgnca_cntrto]          DATETIME                        NULL,
    [fn_vgnca_cntrto]            DATETIME                        NULL,
    [nmro_unco_idntfccn_afldo]   [dbo].[udtConsecutivo]          NULL,
    [cdgo_pln]                   [dbo].[udtCodigo]               NULL,
    [dscrpcn_pln]                [dbo].[udtDescripcion]          NULL,
    [causa]                      CHAR (50)                       NULL,
    [nmro_unco_idntfccn_aprtnte] [dbo].[udtConsecutivo]          NULL,
    [cnsctvo_scrsl_ctznte]       [dbo].[udtConsecutivo]          NULL,
    [cnsctvo_cdgo_clse_aprtnte]  [dbo].[udtConsecutivo]          NULL,
    [nmbre_scrsl]                [dbo].[udtNombre]               NULL,
    [dscrpcn_clse_aprtnte]       [dbo].[udtDescripcion]          NULL,
    [tpo_idntfccn_scrsl]         [dbo].[udtTipoIdentificacion]   NULL,
    [nmro_idntfccn_scrsl]        [dbo].[udtNumeroIdentificacion] NULL,
    [cdgo_sde]                   [dbo].[udtCodigo]               NULL,
    [dscrpcn_sde]                [dbo].[udtDescripcion]          NULL,
    [Responsable]                CHAR (50)                       NULL,
    [cnsctvo_cdgo_lg_lqdcn]      INT                             IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [pk_tbLogliquidacionesContratos] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_lg_lqdcn] ASC)
);


GO
CREATE STATISTICS [cnsctvo_cdgo_lqdcn]
    ON [dbo].[tbLogliquidacionesContratos]([cnsctvo_cdgo_lqdcn]);


GO
CREATE STATISTICS [nmro_cntrto]
    ON [dbo].[tbLogliquidacionesContratos]([nmro_cntrto]);


GO
CREATE STATISTICS [cdgo_tpo_idntfccn]
    ON [dbo].[tbLogliquidacionesContratos]([cdgo_tpo_idntfccn]);


GO
CREATE STATISTICS [nmro_idntfccn]
    ON [dbo].[tbLogliquidacionesContratos]([nmro_idntfccn]);


GO
CREATE STATISTICS [nombre]
    ON [dbo].[tbLogliquidacionesContratos]([nombre]);


GO
CREATE STATISTICS [cnsctvo_cdgo_pln]
    ON [dbo].[tbLogliquidacionesContratos]([cnsctvo_cdgo_pln]);


GO
CREATE STATISTICS [inco_vgnca_cntrto]
    ON [dbo].[tbLogliquidacionesContratos]([inco_vgnca_cntrto]);


GO
CREATE STATISTICS [fn_vgnca_cntrto]
    ON [dbo].[tbLogliquidacionesContratos]([fn_vgnca_cntrto]);


GO
CREATE STATISTICS [nmro_unco_idntfccn_afldo]
    ON [dbo].[tbLogliquidacionesContratos]([nmro_unco_idntfccn_afldo]);


GO
CREATE STATISTICS [cdgo_pln]
    ON [dbo].[tbLogliquidacionesContratos]([cdgo_pln]);


GO
CREATE STATISTICS [dscrpcn_pln]
    ON [dbo].[tbLogliquidacionesContratos]([dscrpcn_pln]);


GO
CREATE STATISTICS [causa]
    ON [dbo].[tbLogliquidacionesContratos]([causa]);


GO
CREATE STATISTICS [nmro_unco_idntfccn_aprtnte]
    ON [dbo].[tbLogliquidacionesContratos]([nmro_unco_idntfccn_aprtnte]);


GO
CREATE STATISTICS [cnsctvo_scrsl_ctznte]
    ON [dbo].[tbLogliquidacionesContratos]([cnsctvo_scrsl_ctznte]);


GO
CREATE STATISTICS [cnsctvo_cdgo_clse_aprtnte]
    ON [dbo].[tbLogliquidacionesContratos]([cnsctvo_cdgo_clse_aprtnte]);


GO
CREATE STATISTICS [nmbre_scrsl]
    ON [dbo].[tbLogliquidacionesContratos]([nmbre_scrsl]);


GO
CREATE STATISTICS [dscrpcn_clse_aprtnte]
    ON [dbo].[tbLogliquidacionesContratos]([dscrpcn_clse_aprtnte]);


GO
CREATE STATISTICS [tpo_idntfccn_scrsl]
    ON [dbo].[tbLogliquidacionesContratos]([tpo_idntfccn_scrsl]);


GO
CREATE STATISTICS [nmro_idntfccn_scrsl]
    ON [dbo].[tbLogliquidacionesContratos]([nmro_idntfccn_scrsl]);


GO
CREATE STATISTICS [cdgo_sde]
    ON [dbo].[tbLogliquidacionesContratos]([cdgo_sde]);


GO
CREATE STATISTICS [dscrpcn_sde]
    ON [dbo].[tbLogliquidacionesContratos]([dscrpcn_sde]);


GO
CREATE STATISTICS [Responsable]
    ON [dbo].[tbLogliquidacionesContratos]([Responsable]);

