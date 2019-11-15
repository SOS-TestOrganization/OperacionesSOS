CREATE TABLE [dbo].[tbBeneficiariosValidador] (
    [cnsctvo_cdgo_tpo_cntrto]     [dbo].[udtConsecutivo]      NOT NULL,
    [nmro_cntrto]                 [dbo].[udtNumeroFormulario] NOT NULL,
    [cnsctvo_bnfcro]              [dbo].[udtConsecutivo]      NOT NULL,
    [nmro_unco_idntfccn_afldo]    [dbo].[udtConsecutivo]      NOT NULL,
    [cnsctvo_cdgo_tpo_idntfccn]   [dbo].[udtConsecutivo]      NOT NULL,
    [nmro_idntfccn]               VARCHAR (20)                NOT NULL,
    [inco_vgnca_bnfcro]           DATETIME                    NOT NULL,
    [fn_vgnca_bnfcro]             DATETIME                    NOT NULL,
    [cnsctvo_cdgo_tpo_afldo]      [dbo].[udtConsecutivo]      NOT NULL,
    [cnsctvo_cdgo_prntsco]        [dbo].[udtConsecutivo]      NOT NULL,
    [estdo]                       [dbo].[udtLogico]           NOT NULL,
    [prmr_aplldo]                 [dbo].[udtApellido]         NOT NULL,
    [sgndo_aplldo]                [dbo].[udtApellido]         NOT NULL,
    [prmr_nmbre]                  [dbo].[udtNombre]           NOT NULL,
    [sgndo_nmbre]                 [dbo].[udtNombre]           NOT NULL,
    [smns_ctzds]                  [dbo].[udtConsecutivo]      NOT NULL,
    [smns_ctzds_antrr_eps]        [dbo].[udtConsecutivo]      NOT NULL,
    [tlfno_rsdnca]                [dbo].[udtTelefono]         NOT NULL,
    [drccn_rsdnca]                [dbo].[udtDireccion]        NOT NULL,
    [cnsctvo_cdgo_cdd_rsdnca]     [dbo].[udtConsecutivo]      NOT NULL,
    [cdgo_intrno]                 [dbo].[udtCodigoIps]        NOT NULL,
    [cnsctvo_cdgo_sxo]            [dbo].[udtConsecutivo]      NOT NULL,
    [cnsctvo_cdgo_estdo_cvl]      [dbo].[udtConsecutivo]      NOT NULL,
    [fcha_ncmnto]                 DATETIME                    NOT NULL,
    [cnsctvo_cdgo_brro]           [dbo].[udtConsecutivo]      NOT NULL,
    [cnsctvo_cdgo_estrto_sccnmco] [dbo].[udtConsecutivo]      NOT NULL,
    [smns_aflcn]                  [dbo].[udtConsecutivo]      NOT NULL,
    [smns_aflcn_antrr_eps]        [dbo].[udtConsecutivo]      NOT NULL,
    [eml]                         [dbo].[udtEmail]            NULL,
    CONSTRAINT [PK_tbBeneficiariosValidador] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_tpo_cntrto] ASC, [nmro_cntrto] ASC, [cnsctvo_bnfcro] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_cnsctvo_cdgo_tpo_idntfccn]
    ON [dbo].[tbBeneficiariosValidador]([cnsctvo_cdgo_tpo_idntfccn] ASC)
    INCLUDE([nmro_idntfccn], [nmro_unco_idntfccn_afldo]);


GO
CREATE NONCLUSTERED INDEX [IX_tbbeneficiariosValidador]
    ON [dbo].[tbBeneficiariosValidador]([cnsctvo_cdgo_tpo_idntfccn] ASC, [nmro_idntfccn] ASC)
    INCLUDE([cnsctvo_cdgo_tpo_cntrto], [nmro_cntrto], [cnsctvo_bnfcro], [nmro_unco_idntfccn_afldo], [inco_vgnca_bnfcro], [fn_vgnca_bnfcro]);


GO
CREATE NONCLUSTERED INDEX [IX_tbbeneficiariosValidador_1]
    ON [dbo].[tbBeneficiariosValidador]([nmro_unco_idntfccn_afldo] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_cnsctvo_cdgo_tpo_cntrto>]
    ON [dbo].[tbBeneficiariosValidador]([cnsctvo_cdgo_tpo_cntrto] ASC, [nmro_idntfccn] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_prmr_aplldo]
    ON [dbo].[tbBeneficiariosValidador]([prmr_aplldo] ASC, [prmr_nmbre] ASC)
    INCLUDE([cnsctvo_cdgo_tpo_cntrto], [nmro_cntrto], [nmro_unco_idntfccn_afldo], [cnsctvo_cdgo_tpo_idntfccn], [nmro_idntfccn], [inco_vgnca_bnfcro], [fn_vgnca_bnfcro], [cnsctvo_cdgo_tpo_afldo], [cnsctvo_cdgo_prntsco], [sgndo_aplldo], [sgndo_nmbre], [fcha_ncmnto])
    ON [FG_INDEXES];


GO
CREATE NONCLUSTERED INDEX [idx_vigencias]
    ON [dbo].[tbBeneficiariosValidador]([inco_vgnca_bnfcro] ASC, [fn_vgnca_bnfcro] ASC)
    INCLUDE([cnsctvo_cdgo_tpo_cntrto], [nmro_cntrto], [cnsctvo_bnfcro], [cnsctvo_cdgo_tpo_afldo], [nmro_unco_idntfccn_afldo])
    ON [FG_INDEXES];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [300202 Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [900002 Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [900002 Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [900002 Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310013 Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310013 Analista Red Servicios]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310013 Analista Red Servicios]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310014 Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310014 Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310014 Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [SOS\310015 Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [SOS\310015 Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [SOS\310015 Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310002 Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310002 Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310002 Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310004 Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310004 Consultor Salud]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310004 Consultor Salud]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310007 Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310007 Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310007 Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310008 Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310008 Auditor Salud]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310008 Auditor Salud]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310003 Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310003 Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310003 Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310001 Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310001 Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310001 Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [330003 Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [330003 Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [330003 Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310009 Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310009 Autorizadora Notificacion]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310009 Autorizadora Notificacion]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310010 Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310010 Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310010 Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310011 Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310011 Auditoria Interna Salud]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310011 Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [SOS\BO_CNA]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [cna_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [ServicioClientePortal]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [900008 Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [900008 Consultor Salud]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [900008 Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [300006 Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [300006 Auditor Interno de PVS]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [300006 Auditor Interno de PVS]
    AS [dbo];


GO
GRANT ALTER
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [aut_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [aut_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [cpw_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [ctp_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [ctp_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [ctp_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [ctp_webusr]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [suit_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [suit_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [suit_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [suit_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [ctc_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [portal_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [portal_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [portal_webusr]
    AS [dbo];


GO
GRANT ALTER
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [portal_rol]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [portal_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [portal_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [proceso3047_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [autsalud_rol]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [procesope_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [envioops_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Auditor Tesoreria]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [quick_webusr]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Desarrollo]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Desarrollo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Desarrollo]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Desarrollo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosValidador] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];

