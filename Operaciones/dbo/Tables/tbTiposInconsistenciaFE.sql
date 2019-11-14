CREATE TABLE [dbo].[tbTiposInconsistenciaFE] (
    [cnsctvo_cdgo_tpo_incnsstnca_fe] [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_tpo_incnsstnca_fe]         [dbo].[udtCodigo]      NOT NULL,
    [dscrpcn_tpo_incnsstnca_fe]      [dbo].[udtDescripcion] NOT NULL,
    [fcha_crcn]                      DATETIME               NOT NULL,
    [usro_crcn]                      [dbo].[udtUsuario]     NOT NULL,
    [vsble_usro]                     [dbo].[udtLogico]      NOT NULL,
    CONSTRAINT [PK_tbTiposInconsistenciaFE] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_tpo_incnsstnca_fe] ASC)
);

