CREATE TABLE [dbo].[tbCausasHistoricoEstadosBeneficiarios] (
    [cnsctvo_csa_hstrco]         [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_hstrco_estdo]       [dbo].[udtConsecutivo] NOT NULL,
    [nmro_unco_idntfccn_aprtnte] [dbo].[udtCodigo]      NOT NULL,
    [cnsctvo_cdgo_clse_aprtnte]  [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cbrnza]             [dbo].[udtConsecutivo] NOT NULL,
    [inco_vgnca_csa]             DATETIME               NOT NULL,
    [fn_vgnca_csa]               DATETIME               NOT NULL,
    [cnsctvo_cdgo_tpo_nvdd]      [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_csa_nvdd]      [dbo].[udtConsecutivo] NOT NULL,
    [tme_stmp]                   ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbCausasHistoricoEstadosBeneficiarios] PRIMARY KEY CLUSTERED ([cnsctvo_csa_hstrco] ASC, [cnsctvo_hstrco_estdo] ASC) WITH (FILLFACTOR = 95)
);


GO
CREATE STATISTICS [cnsctvo_hstrco_estdo]
    ON [dbo].[tbCausasHistoricoEstadosBeneficiarios]([cnsctvo_hstrco_estdo], [cnsctvo_csa_hstrco]);


GO
CREATE STATISTICS [nmro_unco_idntfccn_aprtnte]
    ON [dbo].[tbCausasHistoricoEstadosBeneficiarios]([nmro_unco_idntfccn_aprtnte], [cnsctvo_csa_hstrco], [cnsctvo_hstrco_estdo]);


GO
CREATE STATISTICS [cnsctvo_cdgo_clse_aprtnte]
    ON [dbo].[tbCausasHistoricoEstadosBeneficiarios]([cnsctvo_cdgo_clse_aprtnte], [cnsctvo_csa_hstrco], [cnsctvo_hstrco_estdo]);


GO
CREATE STATISTICS [cnsctvo_cbrnza]
    ON [dbo].[tbCausasHistoricoEstadosBeneficiarios]([cnsctvo_cbrnza], [cnsctvo_csa_hstrco], [cnsctvo_hstrco_estdo]);


GO
CREATE STATISTICS [inco_vgnca_csa]
    ON [dbo].[tbCausasHistoricoEstadosBeneficiarios]([inco_vgnca_csa], [cnsctvo_csa_hstrco], [cnsctvo_hstrco_estdo]);


GO
CREATE STATISTICS [fn_vgnca_csa]
    ON [dbo].[tbCausasHistoricoEstadosBeneficiarios]([fn_vgnca_csa], [cnsctvo_csa_hstrco], [cnsctvo_hstrco_estdo]);


GO
CREATE STATISTICS [cnsctvo_cdgo_tpo_nvdd]
    ON [dbo].[tbCausasHistoricoEstadosBeneficiarios]([cnsctvo_cdgo_tpo_nvdd], [cnsctvo_csa_hstrco], [cnsctvo_hstrco_estdo]);


GO
CREATE STATISTICS [cnsctvo_cdgo_csa_nvdd]
    ON [dbo].[tbCausasHistoricoEstadosBeneficiarios]([cnsctvo_cdgo_csa_nvdd], [cnsctvo_csa_hstrco], [cnsctvo_hstrco_estdo]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbCausasHistoricoEstadosBeneficiarios]([tme_stmp]);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCausasHistoricoEstadosBeneficiarios] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];

