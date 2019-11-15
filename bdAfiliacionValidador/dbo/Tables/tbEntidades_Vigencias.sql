CREATE TABLE [dbo].[tbEntidades_Vigencias] (
    [cnsctvo_vgnca_entdd]      [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_entdd]       [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_entdd]               CHAR (8)               NOT NULL,
    [dscrpcn_entdd]            [dbo].[udtDescripcion] NOT NULL,
    [inco_vgnca]               DATETIME               NOT NULL,
    [fn_vgnca]                 DATETIME               NOT NULL,
    [fcha_crcn]                DATETIME               NOT NULL,
    [usro_crcn]                [dbo].[udtUsuario]     NOT NULL,
    [obsrvcns]                 [dbo].[udtObservacion] NOT NULL,
    [vsble_usro]               [dbo].[udtLogico]      NOT NULL,
    [nmro_unco_idntfccn_entdd] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_tpo_entdd]   [dbo].[udtConsecutivo] NOT NULL,
    [tlfno_entdd]              [dbo].[udtTelefono]    NOT NULL,
    [fx_entdd]                 [dbo].[udtTelefono]    NOT NULL,
    [drccn_entdd]              [dbo].[udtDireccion]   NOT NULL,
    [eml]                      [dbo].[udtEmail]       NOT NULL,
    [cnsctvo_cdgo_cdd]         [dbo].[udtConsecutivo] NOT NULL,
    [prmr_aplldo]              [dbo].[udtApellido]    NOT NULL,
    [sgndo_aplldo]             [dbo].[udtApellido]    NOT NULL,
    [prmr_nmbre]               [dbo].[udtNombre]      NOT NULL,
    [sgndo_nmbre]              [dbo].[udtNombre]      NOT NULL,
    [cnsctvo_cdgo_crgo]        [dbo].[udtConsecutivo] NOT NULL,
    [tme_stmp]                 ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbEntidades_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_entdd] ASC) WITH (FILLFACTOR = 98)
);


GO
CREATE NONCLUSTERED INDEX [idx_inco_vgnca]
    ON [dbo].[tbEntidades_Vigencias]([inco_vgnca] ASC, [fn_vgnca] ASC)
    INCLUDE([cnsctvo_cdgo_entdd], [cdgo_entdd])
    ON [FG_INDEXES];


GO
CREATE NONCLUSTERED INDEX [idx_cnsctvo_cdgo_entdd]
    ON [dbo].[tbEntidades_Vigencias]([cnsctvo_cdgo_entdd] ASC)
    INCLUDE([cdgo_entdd], [inco_vgnca], [fn_vgnca]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbEntidades_Vigencias]([fcha_crcn], [cnsctvo_vgnca_entdd]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbEntidades_Vigencias]([usro_crcn], [cnsctvo_vgnca_entdd]);


GO
CREATE STATISTICS [obsrvcns]
    ON [dbo].[tbEntidades_Vigencias]([obsrvcns], [cnsctvo_vgnca_entdd]);


GO
CREATE STATISTICS [tlfno_entdd]
    ON [dbo].[tbEntidades_Vigencias]([tlfno_entdd], [cnsctvo_vgnca_entdd]);


GO
CREATE STATISTICS [fx_entdd]
    ON [dbo].[tbEntidades_Vigencias]([fx_entdd], [cnsctvo_vgnca_entdd]);


GO
CREATE STATISTICS [drccn_entdd]
    ON [dbo].[tbEntidades_Vigencias]([drccn_entdd], [cnsctvo_vgnca_entdd]);


GO
CREATE STATISTICS [eml]
    ON [dbo].[tbEntidades_Vigencias]([eml], [cnsctvo_vgnca_entdd]);


GO
CREATE STATISTICS [cnsctvo_cdgo_cdd]
    ON [dbo].[tbEntidades_Vigencias]([cnsctvo_cdgo_cdd], [cnsctvo_vgnca_entdd]);


GO
CREATE STATISTICS [prmr_aplldo]
    ON [dbo].[tbEntidades_Vigencias]([prmr_aplldo], [cnsctvo_vgnca_entdd]);


GO
CREATE STATISTICS [sgndo_aplldo]
    ON [dbo].[tbEntidades_Vigencias]([sgndo_aplldo], [cnsctvo_vgnca_entdd]);


GO
CREATE STATISTICS [prmr_nmbre]
    ON [dbo].[tbEntidades_Vigencias]([prmr_nmbre], [cnsctvo_vgnca_entdd]);


GO
CREATE STATISTICS [sgndo_nmbre]
    ON [dbo].[tbEntidades_Vigencias]([sgndo_nmbre], [cnsctvo_vgnca_entdd]);


GO
CREATE STATISTICS [cnsctvo_cdgo_crgo]
    ON [dbo].[tbEntidades_Vigencias]([cnsctvo_cdgo_crgo], [cnsctvo_vgnca_entdd]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbEntidades_Vigencias]([tme_stmp]);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Analistas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [300004 Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [300004 Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [300004 Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [300001 Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [300001 Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [300001 Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [ServicioClientePortal]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Consultor Auxiliar Sedes Red Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Aprendiz Red de Servicios Red Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Coordinador Parametros RedSalud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Consultor Cuentas Medicas Red Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Auditor Interno Red Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Auxiliar Parametros Red Salud]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [aut_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [ctc_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Desarrollo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbEntidades_Vigencias] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];

