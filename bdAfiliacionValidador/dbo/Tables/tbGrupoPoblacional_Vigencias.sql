CREATE TABLE [dbo].[tbGrupoPoblacional_Vigencias] (
    [cnsctvo_vgnca_grpo_pblcnl] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_grpo_pblcnl]  [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_grpo_pblcnl]          CHAR (4)               NOT NULL,
    [dscrpcn_grpo_pblcnl]       [dbo].[udtDescripcion] NOT NULL,
    [inco_vgnca]                DATETIME               NOT NULL,
    [fn_vgnca]                  DATETIME               NOT NULL,
    [fcha_crcn]                 DATETIME               NOT NULL,
    [usro_crcn]                 [dbo].[udtUsuario]     NOT NULL,
    [obsrvcns]                  [dbo].[udtObservacion] NOT NULL,
    [vsble_usro]                [dbo].[udtLogico]      NOT NULL,
    [tme_stmp]                  ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbGrupoPoblacional_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_grpo_pblcnl] ASC)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [300202 Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [900002 Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [900011 Consultor Administrador]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [340010 Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [Prestaciones Economicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [cna_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [vafss_role]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [900001 Consultor Administrativo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [900008 Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [outbts01]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [900007 Consultor Administrativo Novedades]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [900003 Consultor Asesor Cartera]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [900005 Consultor Asesor Comercial]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [900004 Consultor Coordinador Comercial]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [970004 Consultor General Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [900006 Consultor Comercial Privilegiado]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [970003 Consultor Jefaturas Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [970005 Consultor Web Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [970006 Consultor Kiosko Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGrupoPoblacional_Vigencias] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

