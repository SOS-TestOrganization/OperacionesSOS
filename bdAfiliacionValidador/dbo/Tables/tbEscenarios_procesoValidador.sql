CREATE TABLE [dbo].[tbEscenarios_procesoValidador] (
    [cdgo_cnvno]          NUMERIC (18)           NOT NULL,
    [cdgo_tpo_escnro]     CHAR (3)               NOT NULL,
    [cnsctvo_cdgo_cdd]    [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_itm_cptcn]      CHAR (3)               NOT NULL,
    [fcha_dsde]           DATETIME               NOT NULL,
    [fcha_hsta]           DATETIME               NOT NULL,
    [tsa_uso]             FLOAT (53)             NULL,
    [cdgo_nvl]            [dbo].[udtCodigo]      NOT NULL,
    [instrccn_whre]       VARCHAR (300)          NULL,
    [cnsctvo_prcso_crcn]  [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_prcso_actcn] [dbo].[udtConsecutivo] NULL,
    [fcha_fd]             DATETIME               NULL,
    [fcha_mdfccn]         DATETIME               NOT NULL,
    [cntdd_usrs]          INT                    NULL,
    [cdgo_trfa_cptcn]     NUMERIC (18)           NULL,
    [tsa_cdd]             FLOAT (53)             NULL,
    [vlr_bse]             FLOAT (53)             NULL,
    [prcntje]             FLOAT (53)             NULL,
    [dscrpcn_nvl]         [dbo].[udtDescripcion] NULL,
    [dscrpcn_itm_cptcn]   [dbo].[udtDescripcion] NULL,
    [dscrpcn_cdd]         [dbo].[udtDescripcion] NULL,
    [dscrpcn_cnvno]       [dbo].[udtDescripcion] NULL,
    [dscrpcn_tpo_escnro]  [dbo].[udtDescripcion] NULL,
    CONSTRAINT [PK_tbEscenarios_procesoValidador1] PRIMARY KEY CLUSTERED ([cdgo_cnvno] ASC, [cdgo_tpo_escnro] ASC, [cnsctvo_cdgo_cdd] ASC, [cdgo_itm_cptcn] ASC, [fcha_dsde] ASC)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [330004 Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [330001 Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [330007 Liquidador Facturas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [cna_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [aut_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [cpw_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [SOS\330008 Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT ALTER
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [portal_rol]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [portal_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [portal_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [proceso3047_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [autsalud_rol]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEscenarios_procesoValidador] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];

