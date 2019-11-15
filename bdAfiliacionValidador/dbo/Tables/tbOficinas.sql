CREATE TABLE [dbo].[tbOficinas] (
    [cnsctvo_cdgo_ofcna] INT           NOT NULL,
    [cdgo_ofcna]         CHAR (5)      NOT NULL,
    [dscrpcn_ofcna]      VARCHAR (150) NOT NULL,
    [fcha_crcn]          DATETIME      NOT NULL,
    [usro_crcn]          CHAR (30)     NOT NULL,
    [vsble_usro]         CHAR (1)      NOT NULL,
    CONSTRAINT [PK_tbOficinas] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_ofcna] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_cdgo_ofcna]
    ON [dbo].[tbOficinas]([cdgo_ofcna] ASC);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO PUBLIC
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [900011 Consultor Administrador]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [310007 Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [310009 Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [900014 Consultor Auditor]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Prestaciones Economicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbOficinas] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [cna_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbOficinas] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [ServicioClientePortal]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [900001 Consultor Administrativo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Consultor Administrativo]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbOficinas] TO [Atep_Soa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Atep_Soa]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbOficinas] TO [Atep_Soa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [380001 Coordinador Parametros RedSalud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Consultor Auxiliar Sedes Red Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Aprendiz Red de Servicios Red Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Coordinador Parametros RedSalud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Consultor Cuentas Medicas Red Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Auditor Interno Red Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Auxiliar Parametros Red Salud]
    AS [dbo];


GO
GRANT ALTER
    ON OBJECT::[dbo].[tbOficinas] TO [aut_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbOficinas] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [aut_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbOficinas] TO [aut_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbOficinas] TO [330009 Gestor de Alistamiento]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [330009 Gestor de Alistamiento]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbOficinas] TO [Gestor de Alistamiento]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Gestor de Alistamiento]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Auxiliar Contable]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT ALTER
    ON OBJECT::[dbo].[tbOficinas] TO [portal_rol]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbOficinas] TO [portal_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [portal_rol]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbOficinas] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [autsalud_rol]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbOficinas] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [bdua_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [atep_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Desarrollo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Consultor Administrador]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbOficinas] TO [Consultor Auditor]
    AS [dbo];

