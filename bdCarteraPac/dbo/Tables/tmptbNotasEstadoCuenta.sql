CREATE TABLE [dbo].[tmptbNotasEstadoCuenta] (
    [nmro_nta]             VARCHAR (15)           NOT NULL,
    [cnsctvo_cdgo_tpo_nta] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_estdo_cnta]   [dbo].[udtConsecutivo] NOT NULL,
    [vlr]                  [dbo].[udtValorGrande] NOT NULL,
    [fcha_aplccn]          DATETIME               NOT NULL,
    [usro_aplccn]          [dbo].[udtUsuario]     NOT NULL,
    [tme_stmp]             ROWVERSION             NOT NULL
);

