CREATE TABLE [dbo].[tbEstadosxNota] (
    [cnsctvo_estdo_nta]      [dbo].[udtConsecutivo] NOT NULL,
    [nmro_nta]               VARCHAR (15)           NOT NULL,
    [cnsctvo_cdgo_tpo_nta]   [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_estdo_nta] [dbo].[udtConsecutivo] NOT NULL,
    [vlr_nta]                [dbo].[udtValorGrande] NOT NULL,
    [vlr_iva]                [dbo].[udtValorGrande] NOT NULL,
    [sldo_nta]               [dbo].[udtValorGrande] NOT NULL,
    [fcha_cmbo_estdo]        DATETIME               NOT NULL,
    [usro_cmbo_estdo]        [dbo].[udtUsuario]     NOT NULL,
    [tme_stmp]               ROWVERSION             NOT NULL,
    CONSTRAINT [PK_TbEstadosxNota] PRIMARY KEY CLUSTERED ([cnsctvo_estdo_nta] ASC),
    CONSTRAINT [FK_tbEstadosxNota_tbEstadosNota] FOREIGN KEY ([cnsctvo_cdgo_estdo_nta]) REFERENCES [dbo].[tbEstadosNota] ([cnsctvo_cdgo_estdo_nta]),
    CONSTRAINT [FK_tbEstadosxNota_tbNotasPac] FOREIGN KEY ([nmro_nta], [cnsctvo_cdgo_tpo_nta]) REFERENCES [dbo].[tbNotasPac] ([nmro_nta], [cnsctvo_cdgo_tpo_nta])
);

