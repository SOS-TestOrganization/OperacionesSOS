CREATE TABLE [dbo].[tbCobranzasValidador] (
    [cnsctvo_hstrco_estdo]       [dbo].[udtConsecutivo]      NOT NULL,
    [cnsctvo_cdgo_tpo_cntrto]    [dbo].[udtConsecutivo]      NOT NULL,
    [nmro_cntrto]                [dbo].[udtNumeroFormulario] NOT NULL,
    [cnsctvo_cbrnza]             [dbo].[udtConsecutivo]      NOT NULL,
    [nmro_unco_idntfccn_aprtnte] [dbo].[udtConsecutivo]      NOT NULL,
    [inco_vgnca_cbrnza]          DATETIME                    NOT NULL,
    [fn_vgnca_cbrnza]            DATETIME                    NOT NULL,
    [cnsctvo_cdgo_clse_aprtnte]  [dbo].[udtConsecutivo]      NOT NULL,
    [cnsctvo_cdgo_tpo_cbrnza]    [dbo].[udtConsecutivo]      NOT NULL,
    [prncpl]                     [dbo].[udtLogico]           NOT NULL,
    [cnsctvo_cdgo_tpo_ctznte]    [dbo].[udtConsecutivo]      NOT NULL,
    [cnsctvo_cdgo_crgo_empldo]   [dbo].[udtConsecutivo]      NOT NULL,
    [fcha_ingrso_lbrl]           DATETIME                    NULL,
    [cnsctvo_scrsl_ctznte]       [dbo].[udtConsecutivo]      NULL,
    [ingrso_bse]                 INT                         NULL,
    [cnsctvo_prdcto_scrsl]       [dbo].[udtConsecutivo]      NULL,
    [estdo]                      [dbo].[udtLogico]           NOT NULL,
    CONSTRAINT [PK_tbCobranzasValidador] PRIMARY KEY CLUSTERED ([cnsctvo_hstrco_estdo] ASC, [cnsctvo_cdgo_tpo_cntrto] ASC, [nmro_cntrto] ASC, [cnsctvo_cbrnza] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tbCobranzasValidador]
    ON [dbo].[tbCobranzasValidador]([cnsctvo_cdgo_tpo_cntrto] ASC, [nmro_cntrto] ASC)
    INCLUDE([inco_vgnca_cbrnza], [fn_vgnca_cbrnza], [nmro_unco_idntfccn_aprtnte], [cnsctvo_cdgo_tpo_cbrnza], [cnsctvo_cbrnza], [cnsctvo_cdgo_clse_aprtnte], [cnsctvo_scrsl_ctznte], [cnsctvo_prdcto_scrsl], [ingrso_bse], [prncpl]) WITH (FILLFACTOR = 70);


GO
CREATE NONCLUSTERED INDEX [idx_prncpl]
    ON [dbo].[tbCobranzasValidador]([prncpl] ASC)
    INCLUDE([cnsctvo_cdgo_tpo_cntrto], [cnsctvo_cdgo_crgo_empldo], [nmro_cntrto]);


GO
CREATE NONCLUSTERED INDEX [idx_vigencias]
    ON [dbo].[tbCobranzasValidador]([prncpl] ASC, [inco_vgnca_cbrnza] ASC, [fn_vgnca_cbrnza] ASC)
    INCLUDE([cnsctvo_cdgo_tpo_cntrto], [nmro_cntrto], [nmro_unco_idntfccn_aprtnte], [cnsctvo_prdcto_scrsl]);


GO
CREATE NONCLUSTERED INDEX [idx_inco_vgnca_cbrnza]
    ON [dbo].[tbCobranzasValidador]([inco_vgnca_cbrnza] ASC, [fn_vgnca_cbrnza] ASC)
    INCLUDE([cnsctvo_cdgo_tpo_cntrto], [nmro_cntrto], [nmro_unco_idntfccn_aprtnte], [cnsctvo_prdcto_scrsl])
    ON [FG_INDEXES];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Analistas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [330004 Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [330004 Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [900002 Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [900002 Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [900002 Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310013 Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310013 Analista Red Servicios]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310013 Analista Red Servicios]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310014 Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310014 Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310014 Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [SOS\310015 Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [SOS\310015 Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [SOS\310015 Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310002 Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310002 Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310002 Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310004 Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310004 Consultor Salud]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310004 Consultor Salud]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310007 Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310007 Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310007 Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310008 Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310008 Auditor Salud]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310008 Auditor Salud]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310003 Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310003 Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310003 Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310001 Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310001 Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310001 Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [330001 Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [330001 Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [330007 Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [330007 Liquidador Facturas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [330003 Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [330003 Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [330003 Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310009 Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310009 Autorizadora Notificacion]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310009 Autorizadora Notificacion]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310010 Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310010 Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310010 Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310011 Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310011 Auditoria Interna Salud]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310011 Auditoria Interna Salud]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [cna_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [900008 Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [900008 Consultor Salud]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [900008 Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [300006 Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [300006 Auditor Interno de PVS]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [300006 Auditor Interno de PVS]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [aut_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [aut_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [ctp_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [ctp_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [ctp_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [ctp_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [SOS\330008 Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [SOS\330008 Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [portal_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [portal_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [portal_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [portal_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [autsalud_rol]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbCobranzasValidador] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];

