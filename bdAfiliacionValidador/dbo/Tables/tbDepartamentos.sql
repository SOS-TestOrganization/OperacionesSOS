CREATE TABLE [dbo].[tbDepartamentos] (
    [cnsctvo_cdgo_dprtmnto] INT           NOT NULL,
    [cdgo_dprtmnto]         CHAR (3)      NOT NULL,
    [dscrpcn_dprtmnto]      VARCHAR (150) NOT NULL,
    [fcha_crcn]             DATETIME      NOT NULL,
    [usro_crcn]             CHAR (30)     NOT NULL,
    [vsble_usro]            CHAR (1)      NOT NULL,
    CONSTRAINT [PK_tbDepartamentos] PRIMARY KEY NONCLUSTERED ([cnsctvo_cdgo_dprtmnto] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_cdgo_dprtmnto]
    ON [dbo].[tbDepartamentos]([cdgo_dprtmnto] ASC);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO PUBLIC
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [900011 Consultor Administrador]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [900014 Consultor Auditor]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbDepartamentos] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [cna_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbDepartamentos] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [ServicioClientePortal]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [900001 Consultor Administrativo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Consultor Administrativo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbDepartamentos] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Consultor Auxiliar Sedes Red Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Aprendiz Red de Servicios Red Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Coordinador Parametros RedSalud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Consultor Cuentas Medicas Red Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auditor Interno Red Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auxiliar Parametros Red Salud]
    AS [dbo];


GO
GRANT ALTER
    ON OBJECT::[dbo].[tbDepartamentos] TO [aut_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbDepartamentos] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [aut_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbDepartamentos] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auxiliar Contable]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbDepartamentos] TO [cargaarchivos_app]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [cargaarchivos_app]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbDepartamentos] TO [cargaarchivos_app]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbDepartamentos] TO [ctp_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbDepartamentos] TO [ctp_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [ctp_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbDepartamentos] TO [ctp_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Glosas Devoluciones]
    AS [dbo];


GO
GRANT ALTER
    ON OBJECT::[dbo].[tbDepartamentos] TO [portal_rol]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbDepartamentos] TO [portal_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [portal_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Desarrollo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbDepartamentos] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbDepartamentos] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbDepartamentos] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Consultor Salud]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbDepartamentos] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbDepartamentos] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auxiliar Parametros Convenios Vision Salud]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auxiliar Parametros Convenios Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auxiliar Parametros Convenios Vision Salud]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auxiliar Parametros Convenios Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Consultor Administrador]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDepartamentos] TO [Consultor Auditor]
    AS [dbo];

