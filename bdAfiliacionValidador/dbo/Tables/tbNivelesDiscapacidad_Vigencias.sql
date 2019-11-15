CREATE TABLE [dbo].[tbNivelesDiscapacidad_Vigencias] (
    [cnsctvo_vgnca_nvl_dscpcdd] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_nvl_dscpcdd]  [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_nvl_dscpcdd]          CHAR (3)               NOT NULL,
    [dscrpcn_nvl_dscpcdd]       [dbo].[udtDescripcion] NOT NULL,
    [inco_vgnca]                DATETIME               NOT NULL,
    [fn_vgnca]                  DATETIME               NOT NULL,
    [fcha_crcn]                 DATETIME               NOT NULL,
    [usro_crcn]                 [dbo].[udtUsuario]     NOT NULL,
    [obsrvcns]                  [dbo].[udtObservacion] NOT NULL,
    [vsble_usro]                [dbo].[udtLogico]      NOT NULL,
    [prcntje_sprr]              NUMERIC (10, 2)        NOT NULL,
    [prcntje_infrr]             NUMERIC (10, 2)        NOT NULL,
    [tme_stmp]                  ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbNivelesDiscapacidad_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_nvl_dscpcdd] ASC),
    CONSTRAINT [CKFinicioVgncaMayor_InicioVigencia_tbNivelesDiscapacidad_Vigencias] CHECK ([fn_vgnca]>=[inco_vgnca]),
    CONSTRAINT [FK_tbNivelesDiscapacidad_Vigencias_tbNivelesDiscapacidad] FOREIGN KEY ([cnsctvo_cdgo_nvl_dscpcdd]) REFERENCES [dbo].[tbNivelesDiscapacidad] ([cnsctvo_cdgo_nvl_dscpcdd]) ON DELETE CASCADE
);


GO
CREATE STATISTICS [cdgo_nvl_dscpcdd]
    ON [dbo].[tbNivelesDiscapacidad_Vigencias]([cdgo_nvl_dscpcdd], [cnsctvo_vgnca_nvl_dscpcdd]);


GO
CREATE STATISTICS [dscrpcn_nvl_dscpcdd]
    ON [dbo].[tbNivelesDiscapacidad_Vigencias]([dscrpcn_nvl_dscpcdd], [cnsctvo_vgnca_nvl_dscpcdd]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbNivelesDiscapacidad_Vigencias]([fcha_crcn], [cnsctvo_vgnca_nvl_dscpcdd]);


GO
CREATE STATISTICS [obsrvcns]
    ON [dbo].[tbNivelesDiscapacidad_Vigencias]([obsrvcns], [cnsctvo_vgnca_nvl_dscpcdd]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbNivelesDiscapacidad_Vigencias]([tme_stmp]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbNivelesDiscapacidad_Vigencias]([usro_crcn], [cnsctvo_vgnca_nvl_dscpcdd]);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [300202 Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [900002 Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [310013 Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [310014 Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [SOS\310015 Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [310002 Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [310004 Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [310007 Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [310008 Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [310003 Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [310001 Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [330003 Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [310009 Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [310010 Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [310011 Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [SOS\BO_CNA]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [cna_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [ServicioClientePortal]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [900008 Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [300006 Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [cpw_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [ctp_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [suit_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [ctc_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Desarrollo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbNivelesDiscapacidad_Vigencias] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];

