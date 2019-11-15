CREATE TABLE [dbo].[tbNotasAplicadas] (
    [cnsctvo_nta_aplcda]          [dbo].[udtConsecutivo] NOT NULL,
    [nmro_nta]                    VARCHAR (15)           NOT NULL,
    [cnsctvo_cdgo_tpo_nta]        [dbo].[udtConsecutivo] NOT NULL,
    [nmro_nta_aplcda]             VARCHAR (15)           NOT NULL,
    [cnsctvo_cdgo_tpo_nta_aplcda] [dbo].[udtConsecutivo] NOT NULL,
    [vlr_aplcdo]                  [dbo].[udtValorGrande] NOT NULL,
    [fcha_crcn]                   DATETIME               NOT NULL,
    [usro_crcn]                   [dbo].[udtUsuario]     NOT NULL,
    [tme_stmp]                    ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbNotasAplicadas] PRIMARY KEY CLUSTERED ([cnsctvo_nta_aplcda] ASC),
    CONSTRAINT [FK_tbNotasAplicadas_tbNotasPac] FOREIGN KEY ([nmro_nta], [cnsctvo_cdgo_tpo_nta]) REFERENCES [dbo].[tbNotasPac] ([nmro_nta], [cnsctvo_cdgo_tpo_nta]),
    CONSTRAINT [FK_tbNotasAplicadas_tbNotasPac1] FOREIGN KEY ([nmro_nta_aplcda], [cnsctvo_cdgo_tpo_nta_aplcda]) REFERENCES [dbo].[tbNotasPac] ([nmro_nta], [cnsctvo_cdgo_tpo_nta])
);

