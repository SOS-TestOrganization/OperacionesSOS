CREATE TABLE [dbo].[tbSalariosMinimos] (
    [cnsctvo_cdgo_slro_mnmo] INT           NOT NULL,
    [cdgo_slro_mnmo]         CHAR (2)      NOT NULL,
    [dscrpcn_rngo_slrl]      VARCHAR (150) NOT NULL,
    [fcha_crcn]              DATETIME      NOT NULL,
    [usro_crcn]              CHAR (30)     NOT NULL,
    [vsble_usro]             CHAR (1)      NOT NULL,
    CONSTRAINT [PK_TbSalariosMinimos] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_slro_mnmo] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_cdgo_slro_mnmo]
    ON [dbo].[tbSalariosMinimos]([cdgo_slro_mnmo] ASC);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO PUBLIC
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [900002 Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [900011 Consultor Administrador]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [900014 Consultor Auditor]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [900001 Consultor Administrativo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Consultor Administrativo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [900008 Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Inteligencia]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Inteligencia]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Consultor Administrador]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSalariosMinimos] TO [Consultor Auditor]
    AS [dbo];

