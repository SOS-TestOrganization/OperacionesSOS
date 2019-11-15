CREATE TABLE [dbo].[tbTiposMarcasOficina] (
    [cnsctvo_cdgo_tpo_mrca_ofcna] [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_tpo_mrca_ofcna]         [dbo].[udtCodigo]      NOT NULL,
    [dscrpcn_tpo_mrca_ofcna]      [dbo].[udtDescripcion] NOT NULL,
    [fcha_crcn]                   DATETIME               NOT NULL,
    [usro_crcn]                   [dbo].[udtUsuario]     NOT NULL,
    [vsble_usro]                  [dbo].[udtLogico]      NOT NULL,
    CONSTRAINT [PK_tbTiposMarcasOficina] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_tpo_mrca_ofcna] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Tabla que administra los parametros correspondientes a Tipo Marca Oficina', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbTiposMarcasOficina';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Llave primaria de la tabla', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbTiposMarcasOficina', @level2type = N'COLUMN', @level2name = N'cnsctvo_cdgo_tpo_mrca_ofcna';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Codigo del tipo marca oficina', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbTiposMarcasOficina', @level2type = N'COLUMN', @level2name = N'cdgo_tpo_mrca_ofcna';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Descripcion del tipo marca oficina', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbTiposMarcasOficina', @level2type = N'COLUMN', @level2name = N'dscrpcn_tpo_mrca_ofcna';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Fecha de creacion del registro', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbTiposMarcasOficina', @level2type = N'COLUMN', @level2name = N'fcha_crcn';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Usuario de creacion del registro', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbTiposMarcasOficina', @level2type = N'COLUMN', @level2name = N'usro_crcn';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Indica si el registro es visible para seleccion al usuario', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbTiposMarcasOficina', @level2type = N'COLUMN', @level2name = N'vsble_usro';

