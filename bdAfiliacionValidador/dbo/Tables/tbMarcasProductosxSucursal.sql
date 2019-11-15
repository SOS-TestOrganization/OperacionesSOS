CREATE TABLE [dbo].[tbMarcasProductosxSucursal] (
    [cnsctvo_scrsl]             [dbo].[udtConsecutivo] NOT NULL,
    [nmro_unco_idntfccn_empldr] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_clse_aprtnte] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_mrca_espcl]   [dbo].[udtConsecutivo] NOT NULL,
    [vlr_mrca_espcl]            [dbo].[udtLogico]      NOT NULL,
    [fcha_crcn]                 DATETIME               NOT NULL,
    [usro_crcn]                 [dbo].[udtUsuario]     NOT NULL,
    [tme_stmp]                  ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbMarcasProductosxSucursal] PRIMARY KEY CLUSTERED ([cnsctvo_scrsl] ASC, [nmro_unco_idntfccn_empldr] ASC, [cnsctvo_cdgo_clse_aprtnte] ASC, [cnsctvo_cdgo_mrca_espcl] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tbMarcasProductosxSucursal_tbSucursalesAportante] FOREIGN KEY ([cnsctvo_scrsl], [nmro_unco_idntfccn_empldr], [cnsctvo_cdgo_clse_aprtnte]) REFERENCES [dbo].[tbSucursalesAportante] ([cnsctvo_scrsl], [nmro_unco_idntfccn_empldr], [cnsctvo_cdgo_clse_aprtnte])
);


GO
CREATE NONCLUSTERED INDEX [idx_cnsctvo_mrca_espcl]
    ON [dbo].[tbMarcasProductosxSucursal]([cnsctvo_cdgo_mrca_espcl] ASC)
    INCLUDE([nmro_unco_idntfccn_empldr])
    ON [FG_INDEXES];


GO
CREATE NONCLUSTERED INDEX [idx_nui_empleador]
    ON [dbo].[tbMarcasProductosxSucursal]([nmro_unco_idntfccn_empldr] ASC);


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbMarcasProductosxSucursal] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbMarcasProductosxSucursal] TO [autsalud_rol]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbMarcasProductosxSucursal] TO [autsalud_rol]
    AS [dbo];

