CREATE TABLE [dbo].[tbdetproductos20111004] (
    [cnsctvo_prdcto]         [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_mdlo]           [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_clse_mdlo] [dbo].[udtConsecutivo] NOT NULL,
    [inco_vgnca_asccn]       DATETIME               NOT NULL,
    [fn_vgnca_asccn]         DATETIME               NOT NULL,
    [fcha_asccn]             DATETIME               NOT NULL,
    [usro_asccn]             CHAR (30)              NOT NULL,
    [fcha_uso_mdlo]          DATETIME               NULL,
    [tme_stmp]               ROWVERSION             NOT NULL
);

