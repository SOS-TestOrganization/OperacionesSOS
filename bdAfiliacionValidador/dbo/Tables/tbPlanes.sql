CREATE TABLE [dbo].[tbPlanes] (
    [cnsctvo_cdgo_pln] INT           NOT NULL,
    [cdgo_pln]         CHAR (2)      NOT NULL,
    [dscrpcn_pln]      VARCHAR (150) NOT NULL,
    [fcha_crcn]        DATETIME      NOT NULL,
    [usro_crcn]        CHAR (30)     NOT NULL,
    [vsble_usro]       CHAR (1)      NOT NULL,
    CONSTRAINT [PK_tbPlanes] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_pln] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_cdgo_pln]
    ON [dbo].[tbPlanes]([cdgo_pln] ASC);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Analistas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbPlanes] TO [330004 Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [330004 Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbPlanes] TO [330001 Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [330001 Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbPlanes] TO [330007 Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [330007 Liquidador Facturas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbPlanes] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [cna_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbPlanes] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [ServicioClientePortal]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Consultor Auxiliar Sedes Red Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Aprendiz Red de Servicios Red Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Coordinador Parametros RedSalud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Consultor Cuentas Medicas Red Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Auditor Interno Red Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Auxiliar Parametros Red Salud]
    AS [dbo];


GO
GRANT ALTER
    ON OBJECT::[dbo].[tbPlanes] TO [aut_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbPlanes] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [aut_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbPlanes] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [330009 Gestor de Alistamiento]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Gestor de Alistamiento]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Auxiliar Contable]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [cna_espusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbPlanes] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbPlanes] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbPlanes] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbPlanes] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbPlanes] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbPlanes] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT ALTER
    ON OBJECT::[dbo].[tbPlanes] TO [ctp_webusr]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbPlanes] TO [ctp_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbPlanes] TO [ctp_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [ctp_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbPlanes] TO [ctp_webusr]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbPlanes] TO [suit_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbPlanes] TO [suit_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [suit_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbPlanes] TO [suit_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [ctc_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbPlanes] TO [SOS\330008 Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [SOS\330008 Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT ALTER
    ON OBJECT::[dbo].[tbPlanes] TO [portal_rol]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbPlanes] TO [portal_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [portal_rol]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbPlanes] TO [proceso3047_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [proceso3047_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbPlanes] TO [proceso3047_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Auditor Tesoreria]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [quick_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Desarrollo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbPlanes] TO [Consultor Auditor]
    AS [dbo];

