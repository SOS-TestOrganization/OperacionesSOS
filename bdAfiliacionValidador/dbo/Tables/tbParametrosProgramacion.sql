CREATE TABLE [dbo].[tbParametrosProgramacion] (
    [cnsctvo_cdgo_prmtro_prgrmcn] [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_prmtro_prgrmcn]         [dbo].[udtCodigo]      NOT NULL,
    [dscrpcn_prmtro_prgrmcn]      [dbo].[udtDescripcion] NOT NULL,
    [brrdo]                       [dbo].[udtLogico]      NOT NULL,
    [inco_vgnca]                  DATETIME               NOT NULL,
    [fn_vgnca]                    DATETIME               NOT NULL,
    [fcha_Crcn]                   DATETIME               NOT NULL,
    [usro_crcn]                   [dbo].[udtUsuario]     NOT NULL,
    [obsrvcns]                    [dbo].[udtObservacion] NOT NULL,
    [vsble_usro]                  [dbo].[udtLogico]      NOT NULL,
    [tme_stmp]                    ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbParametrosProgramacion] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_prmtro_prgrmcn] ASC),
    CONSTRAINT [CKFinVigenciaMayorInicioVigencia_tbParametrosProgramacion] CHECK NOT FOR REPLICATION ([fn_vgnca] >= [inco_vgnca])
);


GO
CREATE STATISTICS [cdgo_prmtro_prgrmcn]
    ON [dbo].[tbParametrosProgramacion]([cdgo_prmtro_prgrmcn], [cnsctvo_cdgo_prmtro_prgrmcn]);


GO
CREATE STATISTICS [dscrpcn_prmtro_prgrmcn]
    ON [dbo].[tbParametrosProgramacion]([dscrpcn_prmtro_prgrmcn], [cnsctvo_cdgo_prmtro_prgrmcn]);


GO
CREATE STATISTICS [brrdo]
    ON [dbo].[tbParametrosProgramacion]([brrdo], [cnsctvo_cdgo_prmtro_prgrmcn]);


GO
CREATE STATISTICS [inco_vgnca]
    ON [dbo].[tbParametrosProgramacion]([inco_vgnca], [cnsctvo_cdgo_prmtro_prgrmcn]);


GO
CREATE STATISTICS [fn_vgnca]
    ON [dbo].[tbParametrosProgramacion]([fn_vgnca], [cnsctvo_cdgo_prmtro_prgrmcn]);


GO
CREATE STATISTICS [fcha_Crcn]
    ON [dbo].[tbParametrosProgramacion]([fcha_Crcn], [cnsctvo_cdgo_prmtro_prgrmcn]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbParametrosProgramacion]([usro_crcn], [cnsctvo_cdgo_prmtro_prgrmcn]);


GO
CREATE STATISTICS [obsrvcns]
    ON [dbo].[tbParametrosProgramacion]([obsrvcns], [cnsctvo_cdgo_prmtro_prgrmcn]);


GO
CREATE STATISTICS [vsble_usro]
    ON [dbo].[tbParametrosProgramacion]([vsble_usro], [cnsctvo_cdgo_prmtro_prgrmcn]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbParametrosProgramacion]([tme_stmp]);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Desarrollo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbParametrosProgramacion] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];

