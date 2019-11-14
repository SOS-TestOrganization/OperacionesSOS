CREATE TABLE [dbo].[tbCodigosDIAN] (
    [cnsctvo_cdgo_cdgo_dn] [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_cdgo_dn]         VARCHAR (MAX)          NOT NULL,
    [dscrpcn_cdgo_dn]      [dbo].[udtDescripcion] NOT NULL,
    [fcha_crcn]            DATETIME               NOT NULL,
    [usro_crcn]            [dbo].[udtUsuario]     NOT NULL,
    [vsble_usro]           [dbo].[udtLogico]      NOT NULL,
    CONSTRAINT [PK_tbCodigosDIAN] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_cdgo_dn] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tabla que administra los parámetros correspondientes a Código Dian', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbCodigosDIAN';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Llave primaria de la tabla', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbCodigosDIAN', @level2type = N'COLUMN', @level2name = N'cnsctvo_cdgo_cdgo_dn';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codigo del codigo dian', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbCodigosDIAN', @level2type = N'COLUMN', @level2name = N'cdgo_cdgo_dn';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descripcion del codigo dian', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbCodigosDIAN', @level2type = N'COLUMN', @level2name = N'dscrpcn_cdgo_dn';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha de creacion del registro', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbCodigosDIAN', @level2type = N'COLUMN', @level2name = N'fcha_crcn';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Usuario de creacion del registro', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbCodigosDIAN', @level2type = N'COLUMN', @level2name = N'usro_crcn';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica si el registro es visible para seleccion al usuario', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbCodigosDIAN', @level2type = N'COLUMN', @level2name = N'vsble_usro';

