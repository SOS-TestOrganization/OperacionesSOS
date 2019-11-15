CREATE TABLE [dbo].[TbMatrizDerechosValidador_at] (
    [cnsctvo_cdgo_tpo_cntrto]   [dbo].[udtConsecutivo]      NOT NULL,
    [nmro_cntrto]               [dbo].[udtNumeroFormulario] NOT NULL,
    [cnsctvo_bnfcro]            [dbo].[udtConsecutivo]      NOT NULL,
    [nmro_unco_idntfccn_bnfcro] [dbo].[udtConsecutivo]      NOT NULL,
    [cnsctvo_cdgo_estdo_drcho]  [dbo].[udtConsecutivo]      NOT NULL,
    [cnsctvo_cdgo_csa_drcho]    [dbo].[udtConsecutivo]      NULL,
    [inco_vgnca_estdo_drcho]    DATETIME                    NOT NULL,
    [fn_vgnca_estdo_drcho]      DATETIME                    NOT NULL,
    [fcha_ultma_mdfccn]         DATETIME                    NOT NULL,
    [actvo]                     [dbo].[udtLogico]           NULL,
    CONSTRAINT [PK_TbMatrizDerechosValidador_at] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_tpo_cntrto] ASC, [nmro_cntrto] ASC, [cnsctvo_bnfcro] ASC, [cnsctvo_cdgo_estdo_drcho] ASC, [inco_vgnca_estdo_drcho] ASC) WITH (FILLFACTOR = 80)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [aut_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [aut_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [portal_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [portal_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [portal_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [portal_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [proceso3047_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador_at] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];

