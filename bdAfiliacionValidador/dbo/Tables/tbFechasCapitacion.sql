CREATE TABLE [dbo].[tbFechasCapitacion] (
    [fcha_prcso]            DATETIME               NOT NULL,
    [tpo_prcso]             CHAR (1)               NOT NULL,
    [hbltdo]                [dbo].[udtLogico]      NOT NULL,
    [obsrvcn]               [dbo].[udtObservacion] NOT NULL,
    [fcha_inco_cptcn]       INT                    NULL,
    [cnsctvo_cdgo_tpo_mdlo] [dbo].[udtConsecutivo] NOT NULL,
    CONSTRAINT [pk_fcha_prcso_pk_cnsctvo_cdgo_tpo_mdlo] PRIMARY KEY CLUSTERED ([fcha_prcso] ASC, [cnsctvo_cdgo_tpo_mdlo] ASC)
);

