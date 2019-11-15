CREATE TABLE [dbo].[tbRelAgrupacionxParametrosProgramacion] (
    [cnsctvo_agrpcn_tpo_prmtro_prgrmcn]  [dbo].[udtConsecutivo] NOT NULL,
    [brrdo]                              [dbo].[udtLogico]      NOT NULL,
    [inco_vgnca]                         DATETIME               NOT NULL,
    [fn_vgnca]                           DATETIME               NOT NULL,
    [fcha_crcn]                          DATETIME               NOT NULL,
    [usro_crcn]                          [dbo].[udtUsuario]     NOT NULL,
    [cnsctvo_cdgo_agrpdr_prmtro_prgrmcn] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_prmtro_prgrmcn]        [dbo].[udtConsecutivo] NOT NULL,
    [tme_stmp]                           ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbRelAgrupacionxParametrosProgramacion] PRIMARY KEY CLUSTERED ([cnsctvo_agrpcn_tpo_prmtro_prgrmcn] ASC),
    CONSTRAINT [CKFinVigenciaMayorInicioVigencia_tbRelAgrupacionxParametrosProgramacion] CHECK NOT FOR REPLICATION ([fn_vgnca] >= [inco_vgnca]),
    CONSTRAINT [FK_tbRelAgrupacionxParametrosProgramacion_tbAgrupadoresparametrosProgramacion] FOREIGN KEY ([cnsctvo_cdgo_agrpdr_prmtro_prgrmcn]) REFERENCES [dbo].[tbAgrupadoresParametrosProgramacion] ([cnsctvo_cdgo_agrpdr_prmtro_prgrmcn]),
    CONSTRAINT [FK_tbRelAgrupacionxParametrosProgramacion_tbParametrosProgramacion] FOREIGN KEY ([cnsctvo_cdgo_prmtro_prgrmcn]) REFERENCES [dbo].[tbParametrosProgramacion] ([cnsctvo_cdgo_prmtro_prgrmcn])
);


GO
CREATE STATISTICS [brrdo]
    ON [dbo].[tbRelAgrupacionxParametrosProgramacion]([brrdo], [cnsctvo_agrpcn_tpo_prmtro_prgrmcn]);


GO
CREATE STATISTICS [inco_vgnca]
    ON [dbo].[tbRelAgrupacionxParametrosProgramacion]([inco_vgnca], [cnsctvo_agrpcn_tpo_prmtro_prgrmcn]);


GO
CREATE STATISTICS [fn_vgnca]
    ON [dbo].[tbRelAgrupacionxParametrosProgramacion]([fn_vgnca], [cnsctvo_agrpcn_tpo_prmtro_prgrmcn]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbRelAgrupacionxParametrosProgramacion]([fcha_crcn], [cnsctvo_agrpcn_tpo_prmtro_prgrmcn]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbRelAgrupacionxParametrosProgramacion]([usro_crcn], [cnsctvo_agrpcn_tpo_prmtro_prgrmcn]);


GO
CREATE STATISTICS [cnsctvo_cdgo_agrpdr_prmtro_prgrmcn]
    ON [dbo].[tbRelAgrupacionxParametrosProgramacion]([cnsctvo_cdgo_agrpdr_prmtro_prgrmcn], [cnsctvo_agrpcn_tpo_prmtro_prgrmcn]);


GO
CREATE STATISTICS [cnsctvo_cdgo_prmtro_prgrmcn]
    ON [dbo].[tbRelAgrupacionxParametrosProgramacion]([cnsctvo_cdgo_prmtro_prgrmcn], [cnsctvo_agrpcn_tpo_prmtro_prgrmcn]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbRelAgrupacionxParametrosProgramacion]([tme_stmp]);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Desarrollo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbRelAgrupacionxParametrosProgramacion] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];

