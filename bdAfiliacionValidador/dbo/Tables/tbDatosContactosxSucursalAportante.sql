CREATE TABLE [dbo].[tbDatosContactosxSucursalAportante] (
    [cnsctvo_cntcto_scrsl]      [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_scrsl]             [dbo].[udtConsecutivo] NOT NULL,
    [nmro_unco_idntfccn_empldr] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_clse_aprtnte] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_tpo_cntcto]   [dbo].[udtConsecutivo] NOT NULL,
    [drccn]                     [dbo].[udtDireccion]   NOT NULL,
    [tlfno]                     [dbo].[udtTelefono]    NOT NULL,
    [eml]                       [dbo].[udtEmail]       NOT NULL,
    [inco_vgnca]                DATETIME               NOT NULL,
    [fn_vgnca]                  DATETIME               NOT NULL,
    [vldo]                      [dbo].[udtLogico]      NOT NULL,
    [fcha_crcn]                 DATETIME               NOT NULL,
    [usro_crcn]                 [dbo].[udtUsuario]     NOT NULL,
    [fcha_ultma_mdfccn]         DATETIME               NOT NULL,
    [usro_ultma_mdfccn]         [dbo].[udtUsuario]     NOT NULL,
    CONSTRAINT [PK_tbDatosContactosxSucursalAportante] PRIMARY KEY CLUSTERED ([cnsctvo_cntcto_scrsl] ASC) WITH (FILLFACTOR = 80)
);

