CREATE TABLE [dbo].[tbGruposPoblacionesAfiliados] (
    [cnsctvo_id]               INT                    IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [nmro_unco_idntfccn_afldo] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_grpo_pblcnl] [dbo].[udtConsecutivo] NOT NULL,
    [inco_vgnca]               DATETIME               NULL,
    [fn_vgnca]                 DATETIME               NULL,
    [estdo_rgstro]             [dbo].[udtLogico]      NOT NULL,
    [inco_drcn_rgstro]         DATETIME               NOT NULL,
    [fn_drcn_rgstro]           DATETIME               NOT NULL,
    [fcha_ultma_mdfccn]        DATETIME               NOT NULL,
    [tme_stmp]                 ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbGruposPoblacionesAfiliados] PRIMARY KEY NONCLUSTERED ([cnsctvo_id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_nui_grpo_vigencias]
    ON [dbo].[tbGruposPoblacionesAfiliados]([nmro_unco_idntfccn_afldo] ASC, [cnsctvo_cdgo_grpo_pblcnl] ASC, [inco_vgnca] ASC, [fn_vgnca] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_nmro_unco_idntfccn]
    ON [dbo].[tbGruposPoblacionesAfiliados]([nmro_unco_idntfccn_afldo] ASC, [inco_vgnca] ASC, [fn_vgnca] ASC);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [300202 Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [900002 Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [900011 Consultor Administrador]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [340010 Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [Prestaciones Economicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [cna_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [vafss_role]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [900001 Consultor Administrativo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [900008 Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [outbts01]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [900007 Consultor Administrativo Novedades]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [900003 Consultor Asesor Cartera]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [900005 Consultor Asesor Comercial]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [900004 Consultor Coordinador Comercial]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [970004 Consultor General Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [900006 Consultor Comercial Privilegiado]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [970003 Consultor Jefaturas Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [970005 Consultor Web Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [970006 Consultor Kiosko Servicio al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [autsalud_rol]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbGruposPoblacionesAfiliados] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

