CREATE TABLE [dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] (
    [cnsctvo_vgnca_agrpdr_prmtro_prgrmcn] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_agrpdr_prmtro_prgrmcn]  [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_agrpdr_prmtro_prgrmcn]          [dbo].[udtCodigo]      NOT NULL,
    [dscrpcn_agrpdr_prmtro_prgrmcn]       [dbo].[udtDescripcion] NOT NULL,
    [inco_vgnca]                          DATETIME               NOT NULL,
    [fn_vgnca]                            DATETIME               NOT NULL,
    [fcha_Crcn]                           DATETIME               NOT NULL,
    [usro_crcn]                           [dbo].[udtUsuario]     NOT NULL,
    [obsrvcns]                            [dbo].[udtObservacion] NOT NULL,
    [vsble_usro]                          [dbo].[udtLogico]      NOT NULL,
    [tme_stmp]                            ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbAgrupadoresParametrosProgramacion_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_agrpdr_prmtro_prgrmcn] ASC),
    CONSTRAINT [CKFinicioVgncaMayor_InicioVigencia_tbAgrupadoresParametrosProgramacion_Vigencias] CHECK ([fn_vgnca] >= [inco_vgnca]),
    CONSTRAINT [FK_tbAgrupadoresParametrosProgramacion_Vigencias_tbAgrupadoresParametrosProgramacion] FOREIGN KEY ([cnsctvo_cdgo_agrpdr_prmtro_prgrmcn]) REFERENCES [dbo].[tbAgrupadoresParametrosProgramacion] ([cnsctvo_cdgo_agrpdr_prmtro_prgrmcn])
);


GO
CREATE STATISTICS [cnsctvo_cdgo_agrpdr_prmtro_prgrmcn]
    ON [dbo].[tbAgrupadoresParametrosProgramacion_Vigencias]([cnsctvo_cdgo_agrpdr_prmtro_prgrmcn], [cnsctvo_vgnca_agrpdr_prmtro_prgrmcn]);


GO
CREATE STATISTICS [cdgo_agrpdr_prmtro_prgrmcn]
    ON [dbo].[tbAgrupadoresParametrosProgramacion_Vigencias]([cdgo_agrpdr_prmtro_prgrmcn], [cnsctvo_vgnca_agrpdr_prmtro_prgrmcn]);


GO
CREATE STATISTICS [dscrpcn_agrpdr_prmtro_prgrmcn]
    ON [dbo].[tbAgrupadoresParametrosProgramacion_Vigencias]([dscrpcn_agrpdr_prmtro_prgrmcn], [cnsctvo_vgnca_agrpdr_prmtro_prgrmcn]);


GO
CREATE STATISTICS [inco_vgnca]
    ON [dbo].[tbAgrupadoresParametrosProgramacion_Vigencias]([inco_vgnca], [cnsctvo_vgnca_agrpdr_prmtro_prgrmcn]);


GO
CREATE STATISTICS [fn_vgnca]
    ON [dbo].[tbAgrupadoresParametrosProgramacion_Vigencias]([fn_vgnca], [cnsctvo_vgnca_agrpdr_prmtro_prgrmcn]);


GO
CREATE STATISTICS [fcha_Crcn]
    ON [dbo].[tbAgrupadoresParametrosProgramacion_Vigencias]([fcha_Crcn], [cnsctvo_vgnca_agrpdr_prmtro_prgrmcn]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbAgrupadoresParametrosProgramacion_Vigencias]([usro_crcn], [cnsctvo_vgnca_agrpdr_prmtro_prgrmcn]);


GO
CREATE STATISTICS [obsrvcns]
    ON [dbo].[tbAgrupadoresParametrosProgramacion_Vigencias]([obsrvcns], [cnsctvo_vgnca_agrpdr_prmtro_prgrmcn]);


GO
CREATE STATISTICS [vsble_usro]
    ON [dbo].[tbAgrupadoresParametrosProgramacion_Vigencias]([vsble_usro], [cnsctvo_vgnca_agrpdr_prmtro_prgrmcn]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbAgrupadoresParametrosProgramacion_Vigencias]([tme_stmp]);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Desarrollo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresParametrosProgramacion_Vigencias] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];

