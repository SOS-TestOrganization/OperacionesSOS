CREATE TABLE [dbo].[tbItemCapitacion] (
    [cdgo_itm_cptcn]    CHAR (3)               NOT NULL,
    [dscrpcn_itm_cptcn] [dbo].[udtDescripcion] NOT NULL,
    [cdgo_nvl]          [dbo].[udtCodigo]      NOT NULL,
    [estdo]             CHAR (1)               NOT NULL,
    [fcha_crcn]         DATETIME               NOT NULL,
    [fcha_ultma_mdfccn] DATETIME               NOT NULL,
    [usro_ultma_mdfccn] [dbo].[udtUsuario]     NOT NULL,
    CONSTRAINT [PK_tbItemCapitacion] PRIMARY KEY CLUSTERED ([cdgo_itm_cptcn] ASC)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbItemCapitacion] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbItemCapitacion] TO [Consultor Administrativo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbItemCapitacion] TO [Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbItemCapitacion] TO [Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbItemCapitacion] TO [Consultor Coordinador Comercial]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbItemCapitacion] TO [Consultor General Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbItemCapitacion] TO [Consultor Comercial Privilegiado]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbItemCapitacion] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbItemCapitacion] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbItemCapitacion] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbItemCapitacion] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbItemCapitacion] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbItemCapitacion] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbItemCapitacion] TO [Consultor Administrador]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbItemCapitacion] TO [Consultor Auditor]
    AS [dbo];

