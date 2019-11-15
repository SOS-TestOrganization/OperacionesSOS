CREATE TABLE [dbo].[tbTiposMarcasOficina_Vigencias] (
    [cnsctvo_vgnca_tpo_mrca_ofcna] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_tpo_mrca_ofcna]  [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_tpo_mrca_ofcna]          [dbo].[udtCodigo]      NOT NULL,
    [dscrpcn_tpo_mrca_ofcna]       [dbo].[udtDescripcion] NOT NULL,
    [inco_vgnca]                   DATETIME               NOT NULL,
    [fn_vgnca]                     DATETIME               NOT NULL,
    [fcha_crcn]                    DATETIME               NOT NULL,
    [usro_crcn]                    [dbo].[udtUsuario]     NOT NULL,
    [obsrvcns]                     [dbo].[udtObservacion] NOT NULL,
    [vsble_usro]                   [dbo].[udtLogico]      NOT NULL,
    [tme_stmp]                     ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbTiposMarcasOficinaVigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_tpo_mrca_ofcna] ASC),
    CONSTRAINT [FK_tbTiposMarcasOficina_Vigencias_tbTiposMarcasOficina] FOREIGN KEY ([cnsctvo_cdgo_tpo_mrca_ofcna]) REFERENCES [dbo].[tbTiposMarcasOficina] ([cnsctvo_cdgo_tpo_mrca_ofcna])
);


GO
CREATE NONCLUSTERED INDEX [IXFK_tbTiposMarcasOficina_Vigencias_tbTiposMarcasOficina]
    ON [dbo].[tbTiposMarcasOficina_Vigencias]([cnsctvo_cdgo_tpo_mrca_ofcna] ASC);


GO
CREATE NONCLUSTERED INDEX [IXFK_tbTiposMarcasOficina_Vigencias_tbTiposMarcasXOficina]
    ON [dbo].[tbTiposMarcasOficina_Vigencias]([cnsctvo_cdgo_tpo_mrca_ofcna] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Vigencias de la tabla tbTiposMarcasOficina', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbTiposMarcasOficina_Vigencias';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Llave primaria de la tabla', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbTiposMarcasOficina_Vigencias', @level2type = N'COLUMN', @level2name = N'cnsctvo_vgnca_tpo_mrca_ofcna';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Llave primaria de la tabla tbTiposMarcasOficina', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbTiposMarcasOficina_Vigencias', @level2type = N'COLUMN', @level2name = N'cnsctvo_cdgo_tpo_mrca_ofcna';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Codigo del tipo marca oficina', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbTiposMarcasOficina_Vigencias', @level2type = N'COLUMN', @level2name = N'cdgo_tpo_mrca_ofcna';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Descripcion del tipo marca oficina', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbTiposMarcasOficina_Vigencias', @level2type = N'COLUMN', @level2name = N'dscrpcn_tpo_mrca_ofcna';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Inicio de vigencia del registro', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbTiposMarcasOficina_Vigencias', @level2type = N'COLUMN', @level2name = N'inco_vgnca';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Fin de vigencia del registro', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbTiposMarcasOficina_Vigencias', @level2type = N'COLUMN', @level2name = N'fn_vgnca';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Fecha de creacion del registro', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbTiposMarcasOficina_Vigencias', @level2type = N'COLUMN', @level2name = N'fcha_crcn';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Usuario de creacion del registro', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbTiposMarcasOficina_Vigencias', @level2type = N'COLUMN', @level2name = N'usro_crcn';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Observaciones', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbTiposMarcasOficina_Vigencias', @level2type = N'COLUMN', @level2name = N'obsrvcns';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Indica si el registro es visible para seleccion al usuario', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbTiposMarcasOficina_Vigencias', @level2type = N'COLUMN', @level2name = N'vsble_usro';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Time Stamp', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbTiposMarcasOficina_Vigencias', @level2type = N'COLUMN', @level2name = N'tme_stmp';

