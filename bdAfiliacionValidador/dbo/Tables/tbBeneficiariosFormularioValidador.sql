CREATE TABLE [dbo].[tbBeneficiariosFormularioValidador] (
    [cnsctvo_cdgo_tpo_frmlro]           INT           NOT NULL,
    [nmro_frmlro]                       CHAR (15)     NOT NULL,
    [cnsctvo_bnfcro]                    INT           NOT NULL,
    [dscrpcn_tpo_frmlro_crta]           CHAR (8)      NULL,
    [cnsctvo_tpo_idntfccn_bnfcro]       INT           NULL,
    [nmro_idntfccn_bnfcro]              VARCHAR (23)  NULL,
    [prmr_nmbre]                        CHAR (30)     NULL,
    [sgndo_nmbre]                       CHAR (30)     NULL,
    [prmr_aplldo]                       CHAR (50)     NULL,
    [sgndo_aplldo]                      CHAR (50)     NULL,
    [fcha_ncmnto]                       DATETIME      NULL,
    [cnsctvo_cdgo_sxo]                  INT           NULL,
    [rngo_slrl]                         INT           NULL,
    [cnsctvo_cdgo_prntsco]              INT           NULL,
    [cnsctvo_cdgo_tpo_ctznte]           INT           NULL,
    [cnsctvo_cdgo_cdd_rsdnca]           INT           NULL,
    [cnsctvo_cdgo_dprtmnto]             INT           NULL,
    [drccn_rsdnca]                      VARCHAR (80)  NULL,
    [tlfno_rsdnca]                      CHAR (30)     NULL,
    [cnsctvo_cdgo_ips]                  CHAR (8)      NULL,
    [adcnl]                             CHAR (1)      NULL,
    [inco_vgnca_bnfcro]                 DATETIME      NULL,
    [fn_vgnca_bnfcro]                   DATETIME      NULL,
    [cnsctvo_tpo_idntfccn_ctznte]       INT           NULL,
    [nmro_idntfccn_ctznte]              VARCHAR (23)  NULL,
    [prmr_nmbre_ctznte]                 CHAR (30)     NULL,
    [sgndo_nmbre_ctznte]                CHAR (30)     NULL,
    [prmr_aplldo_ctznte]                CHAR (50)     NULL,
    [sgndo_aplldo_ctznte]               CHAR (50)     NULL,
    [cnsctvo_cdgo_estdo_frmlro]         INT           NULL,
    [dscrpcn_estdo_frmlro]              VARCHAR (150) NULL,
    [cnsctvo_cdgo_tpo_idntfccn_aprtnte] INT           NULL,
    [nmro_idntfccn_aprtnte]             VARCHAR (23)  NULL,
    [cnsctvo_cdgo_pln]                  INT           NULL,
    [nmro_unco_idntfccn_aprtnte]        INT           NULL,
    [cnsctvo_cdgo_clse_aprtnte]         INT           NULL,
    [rzn_scl]                           VARCHAR (200) NULL,
    [smns_ctzds]                        INT           NULL,
    [cnsctvo_cdgo_tpo_afldo]            INT           NULL,
    [cnsctvo_cdgo_estdo_drcho]          INT           NULL,
    [cnsctvo_cdgo_csa_drcho]            INT           NULL,
    [cnsctvo_cdgo_tpo_aflcn]            INT           NULL,
    [dscrpcn_tpo_aflcn]                 VARCHAR (150) NULL,
    [fcha_aflcn_sgsss]                  DATETIME      NULL,
    [fcha_dsde]                         DATETIME      NULL,
    [fcha_hsta]                         DATETIME      NULL,
    CONSTRAINT [PK_tbBeneficiariosFormularioValidador] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_tpo_frmlro] ASC, [nmro_frmlro] ASC, [cnsctvo_bnfcro] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_nmro_idntfccn_bnfcro]
    ON [dbo].[tbBeneficiariosFormularioValidador]([nmro_idntfccn_bnfcro] ASC, [cnsctvo_tpo_idntfccn_bnfcro] ASC, [cnsctvo_cdgo_pln] ASC, [cnsctvo_cdgo_estdo_frmlro] ASC)
    INCLUDE([fcha_dsde], [fcha_hsta], [cnsctvo_cdgo_estdo_drcho]) WITH (FILLFACTOR = 80);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [ServicioClientePortal]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [aut_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [900004 Consultor Coordinador Comercial]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [autsalud_rol]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbBeneficiariosFormularioValidador] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];

