CREATE TABLE [dbo].[TbMatrizDerechosValidador] (
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
    CONSTRAINT [PK_TbMatrizDerechosValidador] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_tpo_cntrto] ASC, [nmro_cntrto] ASC, [cnsctvo_bnfcro] ASC, [cnsctvo_cdgo_estdo_drcho] ASC, [inco_vgnca_estdo_drcho] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_TbMatrizDerechosValidador_inco_fin_v]
    ON [dbo].[TbMatrizDerechosValidador]([cnsctvo_cdgo_tpo_cntrto] ASC, [nmro_cntrto] ASC, [cnsctvo_bnfcro] ASC, [inco_vgnca_estdo_drcho] ASC, [fn_vgnca_estdo_drcho] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_EstadoDerecho]
    ON [dbo].[TbMatrizDerechosValidador]([cnsctvo_cdgo_tpo_cntrto] ASC, [nmro_cntrto] ASC, [cnsctvo_bnfcro] ASC, [cnsctvo_cdgo_estdo_drcho] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_nmro_unco_idntfccn_bnfcro]
    ON [dbo].[TbMatrizDerechosValidador]([nmro_unco_idntfccn_bnfcro] ASC)
    INCLUDE([actvo]) WITH (FILLFACTOR = 80)
    ON [FG_INDEXES];


GO
CREATE NONCLUSTERED INDEX [idx_vgncs]
    ON [dbo].[TbMatrizDerechosValidador]([inco_vgnca_estdo_drcho] ASC, [fn_vgnca_estdo_drcho] ASC)
    INCLUDE([cnsctvo_cdgo_tpo_cntrto], [nmro_cntrto], [cnsctvo_bnfcro], [cnsctvo_cdgo_estdo_drcho]);


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [pe_soa]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [cna_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [AccesoRegistroInforme_Lectura]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [ServicioClientePortal]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Consultor Administrativo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT ALTER
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [aut_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [aut_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [900004 Consultor Coordinador Comercial]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [970004 Consultor General Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [portal_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [proceso3047_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [TecnicosBasesDatos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [OperadoresBasesDatos]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [autsalud_rol]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [quick_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Consultor Administrador]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TbMatrizDerechosValidador] TO [Consultor Auditor]
    AS [dbo];

