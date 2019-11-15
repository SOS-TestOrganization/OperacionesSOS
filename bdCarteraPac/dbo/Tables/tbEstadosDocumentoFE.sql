CREATE TABLE [dbo].[tbEstadosDocumentoFE] (
    [cnsctvo_cdgo_estdo_dcmnto_fe] [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_estdo_dcmnto_fe]         [dbo].[udtCodigo]      NOT NULL,
    [dscrpcn_estdo_dcmnto_fe]      [dbo].[udtDescripcion] NOT NULL,
    [fcha_crcn]                    DATETIME               NOT NULL,
    [usro_crcn]                    [dbo].[udtUsuario]     NOT NULL,
    [vsble_usro]                   [dbo].[udtLogico]      NOT NULL,
    CONSTRAINT [PK_tbEstadosDocumento] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_estdo_dcmnto_fe] ASC)
);

