CREATE TABLE [dbo].[tbTiposIdentificacion_Vigencias] (
    [cnsctvo_vgnca_tpo_idntfccn] INT             NOT NULL,
    [cnsctvo_cdgo_tpo_idntfccn]  INT             NOT NULL,
    [cdgo_tpo_idntfccn]          CHAR (3)        NOT NULL,
    [dscrpcn_tpo_idntfccn]       VARCHAR (150)   NOT NULL,
    [inco_vgnca]                 DATETIME        NOT NULL,
    [fn_vgnca]                   DATETIME        NOT NULL,
    [fcha_crcn]                  DATETIME        NOT NULL,
    [usro_crcn]                  CHAR (30)       NOT NULL,
    [obsrvcns]                   VARCHAR (250)   NOT NULL,
    [vsble_usro]                 CHAR (1)        NOT NULL,
    [rngo_sprr]                  NUMERIC (20, 2) NOT NULL,
    [rngo_infrr]                 NUMERIC (20, 2) NOT NULL,
    [edd_sprr]                   INT             NOT NULL,
    [edd_infrr]                  INT             NOT NULL,
    [cdgo_tpo_idntfccn_dn]       INT             NULL,
    [tme_stmp]                   BINARY (8)      NOT NULL,
    CONSTRAINT [PK_tbTiposIdentificacion_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_tpo_idntfccn] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_vigencias]
    ON [dbo].[tbTiposIdentificacion_Vigencias]([inco_vgnca] ASC, [fn_vgnca] ASC)
    INCLUDE([cnsctvo_cdgo_tpo_idntfccn], [cdgo_tpo_idntfccn], [dscrpcn_tpo_idntfccn]);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [900011 Consultor Administrador]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [320001 Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Provisiones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [900014 Consultor Auditor]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [cna_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [vafss_role]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [ServicioClientePortal]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [900001 Consultor Administrativo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Consultor Administrativo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Usuario3047]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [aut_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [cna_espusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [cargaarchivos_app]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [cargaarchivos_app]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [cargaarchivos_app]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [ctp_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [ctp_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [ctp_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [ctp_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Glosas Devoluciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [ctc_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [portal_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [proceso3047_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [proceso3047_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [proceso3047_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [autsalud_rol]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [autsalud_rol]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [procesope_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [procesope_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [procesope_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [procesope_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Auditor Tesoreria]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Desarrollo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Consultor Administrador]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposIdentificacion_Vigencias] TO [Consultor Auditor]
    AS [dbo];

