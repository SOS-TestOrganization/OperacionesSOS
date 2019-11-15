CREATE TABLE [dbo].[tbDetModeloTecnicasBonificacion] (
    [cnsctvo_dtlle_mdlo_tcncs_bnfccn] INT             NOT NULL,
    [cnsctvo_mdlo]                    INT             NOT NULL,
    [Cnsctvo_cdgo_itm_bnfccn]         INT             NOT NULL,
    [Cnsctvo_cdgo_rngo_slrl]          INT             NOT NULL,
    [Cnsctvo_cdgo_tps_entdd_prstdr]   INT             NOT NULL,
    [Cnsctvo_cdgo_tpo_afldo]          INT             NOT NULL,
    [Bnfcro_adcnl]                    CHAR (1)        NOT NULL,
    [Cnsctvo_cdgo_frma_atncn]         INT             NOT NULL,
    [Cnsctvo_cdgo_tcnca_lqdcn]        INT             NOT NULL,
    [Vlr_tcnca_lqdcn]                 NUMERIC (12, 2) NOT NULL,
    [Nmro_actvdds]                    INT             NOT NULL,
    [Cnsctvo_cdgo_frma_rcbro]         INT             NULL,
    [Cnsctvo_cdgo_tpo_rcbro]          INT             NULL,
    [Vlr_frma_rcbro]                  NUMERIC (12, 2) NULL,
    [Usro_crcn]                       CHAR (30)       NOT NULL,
    [fcha_crcn]                       DATETIME        NOT NULL,
    [Usro_ultma_mdfccn]               CHAR (30)       NULL,
    [Fcha_ultma_mdfccn]               DATETIME        NULL,
    [tme_stmp]                        BINARY (8)      NOT NULL,
    CONSTRAINT [PK_TbDetModeloTecnicasBonificacion] PRIMARY KEY CLUSTERED ([cnsctvo_dtlle_mdlo_tcncs_bnfccn] ASC, [cnsctvo_mdlo] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Tbtecnicas]
    ON [dbo].[tbDetModeloTecnicasBonificacion]([Cnsctvo_cdgo_itm_bnfccn] ASC, [Cnsctvo_cdgo_rngo_slrl] ASC, [Cnsctvo_cdgo_tps_entdd_prstdr] ASC, [Cnsctvo_cdgo_tpo_afldo] ASC, [Bnfcro_adcnl] ASC, [Cnsctvo_cdgo_frma_atncn] ASC, [Cnsctvo_cdgo_tcnca_lqdcn] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Consecutivo_modelo]
    ON [dbo].[tbDetModeloTecnicasBonificacion]([cnsctvo_mdlo] ASC);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTecnicasBonificacion] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTecnicasBonificacion] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTecnicasBonificacion] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbDetModeloTecnicasBonificacion] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTecnicasBonificacion] TO [autsalud_rol]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbDetModeloTecnicasBonificacion] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTecnicasBonificacion] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTecnicasBonificacion] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTecnicasBonificacion] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTecnicasBonificacion] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTecnicasBonificacion] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTecnicasBonificacion] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTecnicasBonificacion] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTecnicasBonificacion] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTecnicasBonificacion] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTecnicasBonificacion] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTecnicasBonificacion] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTecnicasBonificacion] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTecnicasBonificacion] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTecnicasBonificacion] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTecnicasBonificacion] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

