CREATE TABLE [dbo].[tbVinculadosEntidades] (
    [nmro_unco_idntfccn]        [dbo].[udtConsecutivo]               NOT NULL,
    [cnsctvo_cdgo_tpo_idntfccn] [dbo].[udtConsecutivo]               NOT NULL,
    [nmro_idntfccn]             [dbo].[udtNumeroIdentificacionLargo] NOT NULL,
    [dgto_vrfccn]               INT                                  NOT NULL,
    [vldo]                      [dbo].[udtLogico]                    NOT NULL,
    [fcha_ultma_mdfccn]         DATETIME                             NOT NULL,
    CONSTRAINT [PK_tbVinculadosEntidades] PRIMARY KEY CLUSTERED ([nmro_unco_idntfccn] ASC) WITH (FILLFACTOR = 90)
);

