CREATE TABLE [dbo].[tbInconsistenciasxNotasPAC] (
    [cnsctvo_incnsstnca_x_nta_pc]    [dbo].[udtConsecutivo]  IDENTITY (1, 1) NOT NULL,
    [nmro_nta]                       VARCHAR (50)            NOT NULL,
    [cnsctvo_cdgo_tpo_nta]           [dbo].[udtConsecutivo]  NOT NULL,
    [nmbre_cmpo]                     [dbo].[udtNombreObjeto] NULL,
    [nmbre_tbla]                     [dbo].[udtNombreObjeto] NULL,
    [cnsctvo_cdgo_tpo_incnsstnca_fe] [dbo].[udtConsecutivo]  NOT NULL,
    [cnsctvo_prcso]                  [dbo].[udtConsecutivo]  NULL,
    [cnsctvo_cdgo_tpo_prcso]         [dbo].[udtConsecutivo]  NULL,
    [fcha_crcn]                      DATETIME                NOT NULL,
    [usro_crcn]                      [dbo].[udtUsuario]      NOT NULL,
    CONSTRAINT [PK_tbInconsistenciasxNotasPAC] PRIMARY KEY CLUSTERED ([cnsctvo_incnsstnca_x_nta_pc] ASC),
    CONSTRAINT [FK_tbInconsistenciasxNotasPAC_tbTiposInconsistenciaFE] FOREIGN KEY ([cnsctvo_cdgo_tpo_incnsstnca_fe]) REFERENCES [dbo].[tbTiposInconsistenciaFE] ([cnsctvo_cdgo_tpo_incnsstnca_fe]),
    CONSTRAINT [FK_tbInconsistenciasxNotasPAC_tbTiposNotas] FOREIGN KEY ([cnsctvo_cdgo_tpo_nta]) REFERENCES [dbo].[tbTiposNotas] ([cnsctvo_cdgo_tpo_nta])
);

