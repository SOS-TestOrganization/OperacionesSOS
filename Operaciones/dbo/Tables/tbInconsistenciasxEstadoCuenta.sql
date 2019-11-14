CREATE TABLE [dbo].[tbInconsistenciasxEstadoCuenta] (
    [cnsctvo_incnsstnca_x_estdo_cnta] [dbo].[udtConsecutivo]  IDENTITY (1, 1) NOT NULL,
    [cnsctvo_estdo_cnta]              [dbo].[udtConsecutivo]  NOT NULL,
    [nmbre_cmpo]                      [dbo].[udtNombreObjeto] NOT NULL,
    [nmbre_tbla]                      [dbo].[udtNombreObjeto] NOT NULL,
    [cnsctvo_cdgo_tpo_incnsstnca_fe]  [dbo].[udtConsecutivo]  NOT NULL,
    [cnsctvo_prcso]                   [dbo].[udtConsecutivo]  NULL,
    [cnsctvo_cdgo_tpo_prcso]          [dbo].[udtConsecutivo]  NULL,
    [fcha_crcn]                       DATETIME                NOT NULL,
    [usro_crcn]                       [dbo].[udtUsuario]      NOT NULL,
    CONSTRAINT [PK_tbInconsistenciasxEstadoCuenta] PRIMARY KEY CLUSTERED ([cnsctvo_incnsstnca_x_estdo_cnta] ASC),
    CONSTRAINT [FK_tbInconsistenciasxEstadoCuenta_tbEstadosCuenta] FOREIGN KEY ([cnsctvo_estdo_cnta]) REFERENCES [dbo].[tbEstadosCuenta] ([cnsctvo_estdo_cnta]),
    CONSTRAINT [FK_tbInconsistenciasxEstadoCuenta_tbTiposInconsistenciaFE] FOREIGN KEY ([cnsctvo_cdgo_tpo_incnsstnca_fe]) REFERENCES [dbo].[tbTiposInconsistenciaFE] ([cnsctvo_cdgo_tpo_incnsstnca_fe])
);

