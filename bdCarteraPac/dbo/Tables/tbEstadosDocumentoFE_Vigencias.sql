CREATE TABLE [dbo].[tbEstadosDocumentoFE_Vigencias] (
    [cnsctvo_vgnca_estdo_dcmnto_fe] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_estdo_dcmnto_fe]  [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_estdo_dcmnto_fe]          [dbo].[udtCodigo]      NOT NULL,
    [dscrpcn_estdo_dcmnto_fe]       [dbo].[udtDescripcion] NOT NULL,
    [inco_vgnca]                    DATETIME               NOT NULL,
    [fn_vgnca]                      DATETIME               NOT NULL,
    [fcha_crcn]                     DATETIME               NOT NULL,
    [usro_crcn]                     [dbo].[udtUsuario]     NOT NULL,
    [obsrvcns]                      [dbo].[udtObservacion] NOT NULL,
    [vsble_usro]                    [dbo].[udtLogico]      NOT NULL,
    [tme_stmp]                      ROWVERSION             NOT NULL,
    [fcha_ultma_mdfccn]             DATETIME               NULL,
    [usro_ultma_mdfccn]             [dbo].[udtUsuario]     NULL,
    CONSTRAINT [PK_tbEstadosDocumento_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_estdo_dcmnto_fe] ASC),
    CONSTRAINT [FK_tbEstadosDocumento_Vigencias_tbEstadosDocumento] FOREIGN KEY ([cnsctvo_cdgo_estdo_dcmnto_fe]) REFERENCES [dbo].[tbEstadosDocumentoFE] ([cnsctvo_cdgo_estdo_dcmnto_fe])
);

