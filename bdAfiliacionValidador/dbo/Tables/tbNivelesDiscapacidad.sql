CREATE TABLE [dbo].[tbNivelesDiscapacidad] (
    [cnsctvo_cdgo_nvl_dscpcdd] [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_nvl_dscpcdd]         CHAR (3)               NOT NULL,
    [dscrpcn_nvl_dscpcdd]      [dbo].[udtDescripcion] NOT NULL,
    [fcha_crcn]                DATETIME               NOT NULL,
    [usro_crcn]                [dbo].[udtUsuario]     NOT NULL,
    [vsble_usro]               [dbo].[udtLogico]      NOT NULL,
    CONSTRAINT [PK_TbNivelesDiscapacidad] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_nvl_dscpcdd] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_cdgo_nvl_dscpcdd]
    ON [dbo].[tbNivelesDiscapacidad]([cdgo_nvl_dscpcdd] ASC);


GO
CREATE STATISTICS [dscrpcn_nvl_dscpcdd]
    ON [dbo].[tbNivelesDiscapacidad]([dscrpcn_nvl_dscpcdd], [cnsctvo_cdgo_nvl_dscpcdd]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbNivelesDiscapacidad]([fcha_crcn], [cnsctvo_cdgo_nvl_dscpcdd]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbNivelesDiscapacidad]([usro_crcn], [cnsctvo_cdgo_nvl_dscpcdd]);


GO
CREATE STATISTICS [vsble_usro]
    ON [dbo].[tbNivelesDiscapacidad]([vsble_usro], [cnsctvo_cdgo_nvl_dscpcdd]);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [300202 Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [900002 Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [310013 Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [310014 Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [SOS\310015 Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [310002 Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [310004 Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [310007 Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [310008 Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [310003 Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [310001 Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [330003 Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [310009 Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [310010 Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [310011 Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [SOS\BO_CNA]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [cna_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [ServicioClientePortal]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [900008 Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [300006 Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [cpw_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [ctp_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [suit_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [ctc_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Desarrollo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];

