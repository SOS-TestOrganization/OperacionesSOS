CREATE TABLE [dbo].[tbCiudades_Vigencias] (
    [cnsctvo_vgnca_cdd]           INT               NOT NULL,
    [cnsctvo_cdgo_cdd]            INT               NOT NULL,
    [cdgo_cdd]                    CHAR (8)          NOT NULL,
    [dscrpcn_cdd]                 VARCHAR (150)     NOT NULL,
    [inco_vgnca]                  DATETIME          NOT NULL,
    [fn_vgnca]                    DATETIME          NOT NULL,
    [fcha_crcn]                   DATETIME          NOT NULL,
    [usro_crcn]                   CHAR (30)         NOT NULL,
    [obsrvcns]                    VARCHAR (250)     NOT NULL,
    [vsble_usro]                  CHAR (1)          NOT NULL,
    [cnsctvo_cdgo_dprtmnto]       INT               NOT NULL,
    [cnsctvo_cdgo_zna]            INT               NOT NULL,
    [zna_espcl]                   INT               NULL,
    [cnsctvo_sde_inflnca]         INT               NOT NULL,
    [cnsctvo_cdgo_clsfccn_ggrfca] INT               NOT NULL,
    [pse_brrs]                    CHAR (1)          NULL,
    [indctvo]                     CHAR (3)          NULL,
    [cnsctvo_cbcra_mncpl]         INT               NULL,
    [mrca_drccnto_mga]            [dbo].[udtLogico] DEFAULT ('N') NULL,
    [tme_stmp]                    ROWVERSION        NOT NULL,
    CONSTRAINT [PK_tbCiudades_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_cdd] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tbCiudades_Vigencias]
    ON [dbo].[tbCiudades_Vigencias]([cnsctvo_cdgo_cdd] ASC)
    INCLUDE([inco_vgnca], [fn_vgnca], [dscrpcn_cdd], [cnsctvo_cdgo_dprtmnto], [indctvo]) WITH (FILLFACTOR = 70);


GO
CREATE NONCLUSTERED INDEX [idx_vigencias]
    ON [dbo].[tbCiudades_Vigencias]([inco_vgnca] ASC, [fn_vgnca] ASC)
    INCLUDE([cnsctvo_cdgo_cdd], [cdgo_cdd], [dscrpcn_cdd], [cnsctvo_cdgo_dprtmnto], [cnsctvo_sde_inflnca]) WITH (FILLFACTOR = 80);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [900002 Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [900011 Consultor Administrador]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [900014 Consultor Auditor]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Prestaciones Economicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [cna_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [vafss_role]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [ServicioClientePortal]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [900001 Consultor Administrativo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Consultor Administrativo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [900008 Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Consultor Auxiliar Sedes Red Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Aprendiz Red de Servicios Red Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Coordinador Parametros RedSalud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Consultor Cuentas Medicas Red Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auditor Interno Red Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auxiliar Parametros Red Salud]
    AS [dbo];


GO
GRANT ALTER
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [aut_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [aut_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [330009 Gestor de Alistamiento]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Gestor de Alistamiento]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auxiliar Contable]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [cna_espusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [cargaarchivos_app]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [cargaarchivos_app]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [cargaarchivos_app]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [ctp_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [ctp_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [ctp_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [ctp_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [suit_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Glosas Devoluciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [ctc_webusr]
    AS [dbo];


GO
GRANT ALTER
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [portal_rol]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [portal_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [portal_rol]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [proceso3047_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [proceso3047_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [proceso3047_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [autsalud_rol]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Desarrollo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auxiliar Parametros Convenios Vision Salud]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auxiliar Parametros Convenios Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auxiliar Parametros Convenios Vision Salud]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auxiliar Parametros Convenios Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Consultor Administrador]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCiudades_Vigencias] TO [Consultor Auditor]
    AS [dbo];

