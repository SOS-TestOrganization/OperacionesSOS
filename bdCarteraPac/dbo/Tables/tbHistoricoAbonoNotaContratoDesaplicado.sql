CREATE TABLE [dbo].[tbHistoricoAbonoNotaContratoDesaplicado] (
    [cnsctvo_hstrco_abno_nta_cntrto_dsplcdo] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_pgo]                       [dbo].[udtConsecutivo] NULL,
    [cnsctvo_nta_cntrto]                     [dbo].[udtConsecutivo] NULL,
    [vlr_nta_cta]                            [dbo].[udtValorGrande] NULL,
    [vlr_nta_iva]                            [dbo].[udtValorGrande] NULL,
    [fcha_crcn]                              DATETIME               NULL,
    [usro_crcn]                              [dbo].[udtUsuario]     NULL,
    [tme_stmp]                               ROWVERSION             NULL,
    CONSTRAINT [Pk_tbHistoricoAbonoNotaContratoDesaplicado] PRIMARY KEY CLUSTERED ([cnsctvo_hstrco_abno_nta_cntrto_dsplcdo] ASC)
);


GO
CREATE STATISTICS [cnsctvo_hstrco_abno_nta_cntrto_dsplcdo]
    ON [dbo].[tbHistoricoAbonoNotaContratoDesaplicado]([cnsctvo_hstrco_abno_nta_cntrto_dsplcdo]);


GO
CREATE STATISTICS [cnsctvo_cdgo_pgo]
    ON [dbo].[tbHistoricoAbonoNotaContratoDesaplicado]([cnsctvo_cdgo_pgo]);


GO
CREATE STATISTICS [cnsctvo_nta_cntrto]
    ON [dbo].[tbHistoricoAbonoNotaContratoDesaplicado]([cnsctvo_nta_cntrto]);


GO
CREATE STATISTICS [vlr_nta_cta]
    ON [dbo].[tbHistoricoAbonoNotaContratoDesaplicado]([vlr_nta_cta]);


GO
CREATE STATISTICS [vlr_nta_iva]
    ON [dbo].[tbHistoricoAbonoNotaContratoDesaplicado]([vlr_nta_iva]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbHistoricoAbonoNotaContratoDesaplicado]([fcha_crcn]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbHistoricoAbonoNotaContratoDesaplicado]([usro_crcn]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbHistoricoAbonoNotaContratoDesaplicado]([tme_stmp]);

