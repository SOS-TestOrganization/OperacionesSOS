CREATE TABLE [dbo].[tbHistoricoAbonoContratoDesaplicado] (
    [cnsctvo_hstrco_abno_cntrto_dsplcdo] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_pgo]                   [dbo].[udtConsecutivo] NULL,
    [cnsctvo_estdo_cnta_cntrto]          [dbo].[udtConsecutivo] NULL,
    [vlr_abno_cta]                       [dbo].[udtValorGrande] NULL,
    [vlr_abno_iva]                       [dbo].[udtValorGrande] NULL,
    [fcha_crcn]                          DATETIME               NULL,
    [usro_crcn]                          [dbo].[udtUsuario]     NULL,
    [tme_stmp]                           ROWVERSION             NULL,
    CONSTRAINT [Pk_tbHistoricoAbonoContratoDesaplicado] PRIMARY KEY CLUSTERED ([cnsctvo_hstrco_abno_cntrto_dsplcdo] ASC)
);


GO
CREATE STATISTICS [cnsctvo_hstrco_abno_cntrto_dsplcdo]
    ON [dbo].[tbHistoricoAbonoContratoDesaplicado]([cnsctvo_hstrco_abno_cntrto_dsplcdo]);


GO
CREATE STATISTICS [cnsctvo_cdgo_pgo]
    ON [dbo].[tbHistoricoAbonoContratoDesaplicado]([cnsctvo_cdgo_pgo]);


GO
CREATE STATISTICS [cnsctvo_estdo_cnta_cntrto]
    ON [dbo].[tbHistoricoAbonoContratoDesaplicado]([cnsctvo_estdo_cnta_cntrto]);


GO
CREATE STATISTICS [vlr_abno_cta]
    ON [dbo].[tbHistoricoAbonoContratoDesaplicado]([vlr_abno_cta]);


GO
CREATE STATISTICS [vlr_abno_iva]
    ON [dbo].[tbHistoricoAbonoContratoDesaplicado]([vlr_abno_iva]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbHistoricoAbonoContratoDesaplicado]([fcha_crcn]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbHistoricoAbonoContratoDesaplicado]([usro_crcn]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbHistoricoAbonoContratoDesaplicado]([tme_stmp]);

