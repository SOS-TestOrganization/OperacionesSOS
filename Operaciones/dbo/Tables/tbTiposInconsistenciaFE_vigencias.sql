CREATE TABLE [dbo].[tbTiposInconsistenciaFE_vigencias] (
    [cnsctvo_vgnca_tpo_incnsstnca_fe] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_tpo_incnsstnca_fe]  [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_tpo_incnsstnca_fe]          [dbo].[udtCodigo]      NOT NULL,
    [dscrpcn_tpo_incnsstnca_fe]       [dbo].[udtDescripcion] NOT NULL,
    [inco_vgnca]                      DATETIME               NOT NULL,
    [fn_vgnca]                        DATETIME               NOT NULL,
    [fcha_crcn]                       DATETIME               NOT NULL,
    [usro_crcn]                       [dbo].[udtUsuario]     NOT NULL,
    [obsrvcns]                        [dbo].[udtObservacion] NOT NULL,
    [vsble_usro]                      [dbo].[udtLogico]      NOT NULL,
    [fcha_ultma_mdfccn]               DATETIME               NULL,
    [usro_ultma_mdfccn]               [dbo].[udtUsuario]     NULL,
    CONSTRAINT [PK_tbTiposInconsistenciaFE_vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_tpo_incnsstnca_fe] ASC),
    CONSTRAINT [FK_tbTiposInconsistenciaFE_Vigencias_tbTiposInconsistenciaFE] FOREIGN KEY ([cnsctvo_cdgo_tpo_incnsstnca_fe]) REFERENCES [dbo].[tbTiposInconsistenciaFE] ([cnsctvo_cdgo_tpo_incnsstnca_fe])
);

