CREATE TABLE [dbo].[tbRelacionNotasCreditoReiNotasReintegro] (
    [cnstvo_rlcn_nts_crdt_ri_nts_rntgro] [dbo].[udtConsecutivo] IDENTITY (1, 1) NOT NULL,
    [nmro_nta_ri]                        VARCHAR (15)           NOT NULL,
    [cnsctvo_cdgo_tpo_nta_ri]            [dbo].[udtConsecutivo] NOT NULL,
    [nmro_nta_rntgro]                    VARCHAR (15)           NOT NULL,
    [cnsctvo_cdgo_tpo_nta_rntgro]        [dbo].[udtConsecutivo] NOT NULL,
    [rntgro_aplcdo]                      [dbo].[udtLogico]      NULL,
    [fcha_crcn]                          DATETIME               NOT NULL,
    [usro_crcn]                          [dbo].[udtUsuario]     NOT NULL,
    CONSTRAINT [PK_tbRelacionNotasCreditoReiNotasReintegro] PRIMARY KEY CLUSTERED ([cnstvo_rlcn_nts_crdt_ri_nts_rntgro] ASC)
);

