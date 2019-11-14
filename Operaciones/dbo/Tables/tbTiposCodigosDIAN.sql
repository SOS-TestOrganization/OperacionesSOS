CREATE TABLE [dbo].[tbTiposCodigosDIAN] (
    [cnsctvo_cdgo_tpo_cdgo_dn] [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_tpo_cdgo_dn]         VARCHAR (3)            NULL,
    [dscrpcn_tpo_cdgo_dn]      [dbo].[udtDescripcion] NOT NULL,
    [fcha_crcn]                DATETIME               NOT NULL,
    [usro_crcn]                [dbo].[udtUsuario]     NOT NULL,
    [vsble_usro]               [dbo].[udtLogico]      NOT NULL,
    CONSTRAINT [PK_tbTiposCodigosDIAN] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_tpo_cdgo_dn] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tabla que administra los parametros correspondientes a Tipo Codigo Dian', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbTiposCodigosDIAN';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Llave primaria de la tabla', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbTiposCodigosDIAN', @level2type = N'COLUMN', @level2name = N'cnsctvo_cdgo_tpo_cdgo_dn';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codigo del tipo codigo dian', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbTiposCodigosDIAN', @level2type = N'COLUMN', @level2name = N'cdgo_tpo_cdgo_dn';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descripcion del tipo codigo dian', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbTiposCodigosDIAN', @level2type = N'COLUMN', @level2name = N'dscrpcn_tpo_cdgo_dn';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha de creacion del registro', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbTiposCodigosDIAN', @level2type = N'COLUMN', @level2name = N'fcha_crcn';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Usuario de creacion del registro', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbTiposCodigosDIAN', @level2type = N'COLUMN', @level2name = N'usro_crcn';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica si el registro es visible para seleccion al usuario', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbTiposCodigosDIAN', @level2type = N'COLUMN', @level2name = N'vsble_usro';

