CREATE TABLE [dbo].[tbEstadosxPromotor] (
    [cnsctvo_estdo_prmtr]      [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_prmtr]       [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_estdo_prmtr] [dbo].[udtConsecutivo] NOT NULL,
    [fcha_cmbo_estdo]          DATETIME               NOT NULL,
    [usro_cmbo_estdo]          [dbo].[udtUsuario]     NOT NULL,
    [tme_stmp]                 ROWVERSION             NOT NULL,
    CONSTRAINT [PK_TbEstadosxPromotor] PRIMARY KEY CLUSTERED ([cnsctvo_estdo_prmtr] ASC),
    CONSTRAINT [FK_tbEstadosxPromotor_tbEstadosPromotor] FOREIGN KEY ([cnsctvo_cdgo_estdo_prmtr]) REFERENCES [dbo].[tbEstadosPromotor] ([cnsctvo_cdgo_estdo_prmtr])
);


GO
CREATE STATISTICS [cnsctvo_cdgo_prmtr]
    ON [dbo].[tbEstadosxPromotor]([cnsctvo_cdgo_prmtr], [cnsctvo_estdo_prmtr]);


GO
CREATE STATISTICS [cnsctvo_cdgo_estdo_prmtr]
    ON [dbo].[tbEstadosxPromotor]([cnsctvo_cdgo_estdo_prmtr], [cnsctvo_estdo_prmtr]);


GO
CREATE STATISTICS [fcha_cmbo_estdo]
    ON [dbo].[tbEstadosxPromotor]([fcha_cmbo_estdo], [cnsctvo_estdo_prmtr]);


GO
CREATE STATISTICS [usro_cmbo_estdo]
    ON [dbo].[tbEstadosxPromotor]([usro_cmbo_estdo], [cnsctvo_estdo_prmtr]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbEstadosxPromotor]([tme_stmp]);

