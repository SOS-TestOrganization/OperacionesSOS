CREATE TABLE [dbo].[tmppagosautomaticosPAC] (
    [nmro_rgstro]               INT          NULL,
    [cnsctvo_rcdo_cncldo]       INT          NULL,
    [nmro_dcmnto]               VARCHAR (15) NULL,
    [fcha_rcdo]                 DATETIME     NULL,
    [vlr_dcmnto]                NUMERIC (12) NULL,
    [nmro_lna]                  INT          NULL,
    [nmro_rmsa]                 INT          NULL,
    [prdo_rmsa]                 INT          NULL,
    [cnsctvo_cdgo_estdo_pgo]    INT          NULL,
    [cnsctvo_cdgo_tpo_pgo]      INT          NULL,
    [cnsctvo_cdgo_pgo]          INT          NULL,
    [sldo_pgo]                  NUMERIC (12) NULL,
    [cnsctvo_cdgo_tpo_prsntcn]  INT          NULL,
    [nmro_unco_idntfccn_empldr] INT          NULL,
    [cnsctvo_scrsl]             INT          NULL,
    [cnsctvo_cdgo_clse_aprtnte] INT          NULL,
    [Automatico]                INT          NULL
);


GO
CREATE STATISTICS [cnsctvo_rcdo_cncldo]
    ON [dbo].[tmppagosautomaticosPAC]([cnsctvo_rcdo_cncldo]);


GO
CREATE STATISTICS [fcha_rcdo]
    ON [dbo].[tmppagosautomaticosPAC]([fcha_rcdo]);


GO
CREATE STATISTICS [vlr_dcmnto]
    ON [dbo].[tmppagosautomaticosPAC]([vlr_dcmnto]);


GO
CREATE STATISTICS [nmro_lna]
    ON [dbo].[tmppagosautomaticosPAC]([nmro_lna]);


GO
CREATE STATISTICS [nmro_rmsa]
    ON [dbo].[tmppagosautomaticosPAC]([nmro_rmsa]);


GO
CREATE STATISTICS [prdo_rmsa]
    ON [dbo].[tmppagosautomaticosPAC]([prdo_rmsa]);


GO
CREATE STATISTICS [cnsctvo_cdgo_estdo_pgo]
    ON [dbo].[tmppagosautomaticosPAC]([cnsctvo_cdgo_estdo_pgo]);


GO
CREATE STATISTICS [cnsctvo_cdgo_tpo_pgo]
    ON [dbo].[tmppagosautomaticosPAC]([cnsctvo_cdgo_tpo_pgo]);


GO
CREATE STATISTICS [sldo_pgo]
    ON [dbo].[tmppagosautomaticosPAC]([sldo_pgo]);


GO
CREATE STATISTICS [cnsctvo_cdgo_tpo_prsntcn]
    ON [dbo].[tmppagosautomaticosPAC]([cnsctvo_cdgo_tpo_prsntcn]);


GO
CREATE STATISTICS [nmro_unco_idntfccn_empldr]
    ON [dbo].[tmppagosautomaticosPAC]([nmro_unco_idntfccn_empldr]);


GO
CREATE STATISTICS [cnsctvo_scrsl]
    ON [dbo].[tmppagosautomaticosPAC]([cnsctvo_scrsl]);


GO
CREATE STATISTICS [cnsctvo_cdgo_clse_aprtnte]
    ON [dbo].[tmppagosautomaticosPAC]([cnsctvo_cdgo_clse_aprtnte]);


GO
CREATE STATISTICS [Automatico]
    ON [dbo].[tmppagosautomaticosPAC]([Automatico]);

