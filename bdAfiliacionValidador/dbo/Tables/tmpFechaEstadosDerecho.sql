CREATE TABLE [dbo].[tmpFechaEstadosDerecho] (
    [cnsctvo_cdgo_tpo_cntrto]   INT       NULL,
    [nmro_cntrto]               CHAR (15) NULL,
    [cnsctvo_bnfcro]            INT       NULL,
    [nmro_unco_idntfccn_bnfcro] INT       NULL,
    [cnsctvo_cdgo_estdo_drcho]  INT       NULL,
    [cnsctvo_cdgo_csa_drcho]    INT       NULL,
    [inco_vgnca_estdo_drcho]    DATETIME  NULL,
    [fn_vgnca_estdo_drcho]      DATETIME  NULL,
    [cnsctvo]                   INT       IDENTITY (1, 1) NOT NULL,
    [grpo]                      INT       NULL,
    [nvo_grpo]                  INT       NULL,
    [fcha_ultma_mdfccn]         DATETIME  NULL
);

