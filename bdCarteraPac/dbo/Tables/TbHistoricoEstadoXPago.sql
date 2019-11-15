CREATE TABLE [dbo].[TbHistoricoEstadoXPago] (
    [cnsctvo_hstrco_estdo_pgo]  [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_estdo_pgo]    [dbo].[udtConsecutivo] NULL,
    [cnsctvo_cdgo_pgo]          [dbo].[udtConsecutivo] NULL,
    [sldo_pgo]                  [dbo].[udtValorGrande] NULL,
    [nmro_unco_idntfccn_empldr] [dbo].[udtConsecutivo] NULL,
    [cnsctvo_scrsl]             [dbo].[udtConsecutivo] NULL,
    [cnsctvo_cdgo_clse_aprtnte] [dbo].[udtConsecutivo] NULL,
    [usro_crcn]                 [dbo].[udtUsuario]     NULL,
    [fcha_crcn]                 DATETIME               NULL,
    [tme_stmp]                  ROWVERSION             NULL,
    CONSTRAINT [Pk_TbHistoricoEstadoXPago] PRIMARY KEY CLUSTERED ([cnsctvo_hstrco_estdo_pgo] ASC)
);


GO
CREATE STATISTICS [cnsctvo_hstrco_estdo_pgo]
    ON [dbo].[TbHistoricoEstadoXPago]([cnsctvo_hstrco_estdo_pgo]);


GO
CREATE STATISTICS [cnsctvo_cdgo_estdo_pgo]
    ON [dbo].[TbHistoricoEstadoXPago]([cnsctvo_cdgo_estdo_pgo]);


GO
CREATE STATISTICS [sldo_pgo]
    ON [dbo].[TbHistoricoEstadoXPago]([sldo_pgo]);


GO
CREATE STATISTICS [nmro_unco_idntfccn_empldr]
    ON [dbo].[TbHistoricoEstadoXPago]([nmro_unco_idntfccn_empldr]);


GO
CREATE STATISTICS [cnsctvo_scrsl]
    ON [dbo].[TbHistoricoEstadoXPago]([cnsctvo_scrsl]);


GO
CREATE STATISTICS [cnsctvo_cdgo_clse_aprtnte]
    ON [dbo].[TbHistoricoEstadoXPago]([cnsctvo_cdgo_clse_aprtnte]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[TbHistoricoEstadoXPago]([usro_crcn]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[TbHistoricoEstadoXPago]([fcha_crcn]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[TbHistoricoEstadoXPago]([tme_stmp]);

