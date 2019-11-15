CREATE TABLE [dbo].[tbCodigosDIAN_Vigencias] (
    [cnsctvo_vgnca_cdgo_dn]    [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_cdgo_dn]     [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_dn]                  VARCHAR (MAX)          NOT NULL,
    [dscrpcn_cdgo_dn]          [dbo].[udtDescripcion] NOT NULL,
    [inco_vgnca]               DATETIME               NOT NULL,
    [fn_vgnca]                 DATETIME               NOT NULL,
    [fcha_crcn]                DATETIME               NOT NULL,
    [usro_crcn]                [dbo].[udtUsuario]     NOT NULL,
    [obsrvcns]                 [dbo].[udtObservacion] NOT NULL,
    [vsble_usro]               [dbo].[udtLogico]      NOT NULL,
    [tme_stmp]                 ROWVERSION             NOT NULL,
    [cnsctvo_cdgo_llve_sos]    [dbo].[udtConsecutivo] NULL,
    [cnsctvo_cdgo_tpo_cdgo_dn] [dbo].[udtConsecutivo] NULL,
    CONSTRAINT [PK_tbCodigosDIANVigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_cdgo_dn] ASC),
    CONSTRAINT [FK_tbCodigosDIAN_Vigencias_tbCodigosDIAN] FOREIGN KEY ([cnsctvo_cdgo_cdgo_dn]) REFERENCES [dbo].[tbCodigosDIAN] ([cnsctvo_cdgo_cdgo_dn]),
    CONSTRAINT [FK_tbCodigosDIAN_Vigencias_tbTiposCodigosDIAN] FOREIGN KEY ([cnsctvo_cdgo_tpo_cdgo_dn]) REFERENCES [dbo].[tbTiposCodigosDIAN] ([cnsctvo_cdgo_tpo_cdgo_dn])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Vigencias de la tabla tbCodigosDIAN', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbCodigosDIAN_Vigencias';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Llave primaria de la tabla', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbCodigosDIAN_Vigencias', @level2type = N'COLUMN', @level2name = N'cnsctvo_vgnca_cdgo_dn';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Llave primaria de la tabla tbCodigosDIAN', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbCodigosDIAN_Vigencias', @level2type = N'COLUMN', @level2name = N'cnsctvo_cdgo_cdgo_dn';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codigo del codigo dian', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbCodigosDIAN_Vigencias', @level2type = N'COLUMN', @level2name = N'cdgo_dn';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descripcion del codigo dian', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbCodigosDIAN_Vigencias', @level2type = N'COLUMN', @level2name = N'dscrpcn_cdgo_dn';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inicio de vigencia del registro', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbCodigosDIAN_Vigencias', @level2type = N'COLUMN', @level2name = N'inco_vgnca';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fin de vigencia del registro', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbCodigosDIAN_Vigencias', @level2type = N'COLUMN', @level2name = N'fn_vgnca';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha de creacion del registro', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbCodigosDIAN_Vigencias', @level2type = N'COLUMN', @level2name = N'fcha_crcn';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Usuario de creacion del registro', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbCodigosDIAN_Vigencias', @level2type = N'COLUMN', @level2name = N'usro_crcn';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Observaciones', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbCodigosDIAN_Vigencias', @level2type = N'COLUMN', @level2name = N'obsrvcns';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica si el registro es visible para seleccion al usuario', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbCodigosDIAN_Vigencias', @level2type = N'COLUMN', @level2name = N'vsble_usro';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Time Stamp', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbCodigosDIAN_Vigencias', @level2type = N'COLUMN', @level2name = N'tme_stmp';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Llave del mismo consecutivo en las tablas de SOS.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tbCodigosDIAN_Vigencias', @level2type = N'COLUMN', @level2name = N'cnsctvo_cdgo_llve_sos';

