CREATE TABLE [dbo].[tbRelacionNotasXNotaDebito] (
    [cnstvo_rlcn_nts_nta_dbto] [dbo].[udtConsecutivo] IDENTITY (1, 1) NOT NULL,
    [nmro_nta]                 VARCHAR (15)           NOT NULL,
    [cnsctvo_cdgo_tpo_nta]     [dbo].[udtConsecutivo] NOT NULL,
    [nmro_nta_dbto]            [dbo].[udtConsecutivo] NOT NULL,
    [cnstvo_cdgo_tpo_nta_dbto] [dbo].[udtConsecutivo] NOT NULL,
    [vlr]                      [dbo].[udtValorGrande] NOT NULL,
    [vlr_iva]                  [dbo].[udtValorGrande] NOT NULL,
    [fcha_aplccn]              DATETIME               NOT NULL,
    [usro_aplccn]              [dbo].[udtUsuario]     NOT NULL,
    CONSTRAINT [PK_tbRelacionNotasXNotaDebito] PRIMARY KEY CLUSTERED ([cnstvo_rlcn_nts_nta_dbto] ASC)
);

