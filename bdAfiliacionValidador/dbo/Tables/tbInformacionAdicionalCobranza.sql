CREATE TABLE [dbo].[tbInformacionAdicionalCobranza] (
    [cnsctvo_infrmcn]            INT          NOT NULL,
    [cnsctvo_cdgo_tpo_cntrto]    INT          NOT NULL,
    [nmro_cntrto]                CHAR (15)    NOT NULL,
    [cnsctvo_cbrnza]             INT          NOT NULL,
    [nmro_unco_idntfccn_aprtnte] INT          NOT NULL,
    [cnsctvo_cdgo_clse_aprtnte]  INT          NOT NULL,
    [cnsctvo_scrsl]              INT          NOT NULL,
    [inco_vgnca_infrmcn]         DATETIME     NOT NULL,
    [fn_vgnca_infrmcn]           DATETIME     NOT NULL,
    [estdo_rgstro]               CHAR (1)     NOT NULL,
    [inco_drcn_rgstro]           DATETIME     NOT NULL,
    [fn_drcn_rgstro]             DATETIME     NOT NULL,
    [fcha_ultma_mdfccn]          DATETIME     NOT NULL,
    [tme_stmp]                   BINARY (8)   NOT NULL,
    [cnsctvo_cdgo_tpo_idntfccn]  INT          NOT NULL,
    [nmro_idntfccn]              VARCHAR (23) NOT NULL,
    [prmr_aplldo]                CHAR (50)    NOT NULL,
    [sgndo_aplldo]               CHAR (50)    NOT NULL,
    [prmr_nmbre]                 CHAR (30)    NOT NULL,
    [sgndo_nmbre]                CHAR (30)    NOT NULL,
    CONSTRAINT [PK_tbInformacionAdicionalCobranza] PRIMARY KEY CLUSTERED ([cnsctvo_infrmcn] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tbInformacionAdicionalCobranza]
    ON [dbo].[tbInformacionAdicionalCobranza]([cnsctvo_cdgo_tpo_cntrto] ASC, [nmro_cntrto] ASC, [nmro_unco_idntfccn_aprtnte] ASC);


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Analistas]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [900002 Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [900011 Consultor Administrador]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [900014 Consultor Auditor]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [900001 Consultor Administrativo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Consultor Administrativo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [900008 Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [aut_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Consultor Administrador]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbInformacionAdicionalCobranza] TO [Consultor Auditor]
    AS [dbo];

