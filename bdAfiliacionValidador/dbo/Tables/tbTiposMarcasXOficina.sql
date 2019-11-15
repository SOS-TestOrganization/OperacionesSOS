CREATE TABLE [dbo].[tbTiposMarcasXOficina] (
    [cnsctvo_cdgo_tpo_mrca_x_ofcna] [dbo].[udtConsecutivo] IDENTITY (1, 1) NOT NULL,
    [cnsctvo_cdgo_tpo_mrca_ofcna]   [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_ofcna]            [dbo].[udtConsecutivo] NOT NULL,
    [inco_vgnca]                    DATETIME               NOT NULL,
    [fn_vgnca]                      DATETIME               NOT NULL,
    [fcha_crcn]                     DATETIME               NOT NULL,
    [usro_crcn]                     [dbo].[udtUsuario]     NOT NULL,
    [fcha_ultma_mdfccn]             DATETIME               NOT NULL,
    [usro_ultm_mdfccn]              [dbo].[udtUsuario]     NOT NULL,
    [tme_stmp]                      ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbTiposMarcasXOficina] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_tpo_mrca_x_ofcna] ASC),
    CONSTRAINT [FK_tbTiposMarcasXOficina_tbOficinas] FOREIGN KEY ([cnsctvo_cdgo_ofcna]) REFERENCES [dbo].[tbOficinas] ([cnsctvo_cdgo_ofcna]),
    CONSTRAINT [FK_tbTiposMarcasXOficina_tbTiposMarcasOficina] FOREIGN KEY ([cnsctvo_cdgo_tpo_mrca_ofcna]) REFERENCES [dbo].[tbTiposMarcasOficina] ([cnsctvo_cdgo_tpo_mrca_ofcna])
);


GO
CREATE NONCLUSTERED INDEX [IXFK_tbTiposMarcasXOficina_tbOficinas]
    ON [dbo].[tbTiposMarcasXOficina]([cnsctvo_cdgo_ofcna] ASC);


GO
CREATE NONCLUSTERED INDEX [IXFK_tbTiposMarcasXOficina_tbTiposMarcasOficina]
    ON [dbo].[tbTiposMarcasXOficina]([cnsctvo_cdgo_tpo_mrca_ofcna] ASC);


GO
CREATE NONCLUSTERED INDEX [IXFK_tbTiposMarcasXOficina_tbTiposMarcasOficina_02]
    ON [dbo].[tbTiposMarcasXOficina]([cnsctvo_cdgo_tpo_mrca_ofcna] ASC);


GO
CREATE NONCLUSTERED INDEX [IXFK_tbTiposMarcasXOficina_tbTiposMarcasOficina_Vigencias]
    ON [dbo].[tbTiposMarcasXOficina]([cnsctvo_cdgo_tpo_mrca_ofcna] ASC);

