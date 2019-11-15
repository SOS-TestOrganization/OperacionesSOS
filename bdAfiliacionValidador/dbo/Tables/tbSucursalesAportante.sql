CREATE TABLE [dbo].[tbSucursalesAportante] (
    [cnsctvo_scrsl]                  INT           NOT NULL,
    [nmro_unco_idntfccn_empldr]      INT           NOT NULL,
    [cnsctvo_cdgo_clse_aprtnte]      INT           NOT NULL,
    [prncpl]                         CHAR (1)      NOT NULL,
    [nmbre_scrsl]                    VARCHAR (150) NOT NULL,
    [drccn]                          VARCHAR (80)  NOT NULL,
    [tlfno]                          CHAR (30)     NOT NULL,
    [fx]                             CHAR (30)     NOT NULL,
    [eml]                            VARCHAR (50)  NOT NULL,
    [nmbre_grnte]                    VARCHAR (150) NOT NULL,
    [nmro_emplds]                    INT           NOT NULL,
    [nmbre_cntcto_cmcl]              VARCHAR (150) NOT NULL,
    [cnsctvo_cdgo_crgo_cntcto_cmrcl] INT           NOT NULL,
    [pga_adcnl]                      CHAR (1)      NOT NULL,
    [cnsctvo_cdgo_assr]              INT           NOT NULL,
    [cnsctvo_cdgo_arp]               INT           NOT NULL,
    [cnsctvo_cdgo_cja_cmpnscn]       INT           NOT NULL,
    [cnsctvo_cdgo_zna_pstl]          INT           NOT NULL,
    [cnsctvo_cdgo_znfccn_sde]        INT           NOT NULL,
    [cnsctvo_cdgo_sde_atncn]         INT           NOT NULL,
    [cnsctvo_cdgo_cdd]               INT           NOT NULL,
    [cnsctvo_cdgo_actvdd_ecnmca]     INT           NOT NULL,
    [prmtr_crtra_pc]                 INT           NOT NULL,
    [prmtr_crtra_ps]                 INT           NOT NULL,
    [sde_crtra_pc]                   INT           NOT NULL,
    [sde_crtra_ps]                   INT           NOT NULL,
    [obsrvcns]                       VARCHAR (250) NOT NULL,
    [tme_stmp]                       BINARY (8)    NOT NULL,
    CONSTRAINT [PK_tbSucursalesAportante] PRIMARY KEY CLUSTERED ([cnsctvo_scrsl] ASC, [nmro_unco_idntfccn_empldr] ASC, [cnsctvo_cdgo_clse_aprtnte] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_TbSucursalesFormularios]
    ON [dbo].[tbSucursalesAportante]([nmro_unco_idntfccn_empldr] ASC, [cnsctvo_scrsl] ASC);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Analistas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [900002 Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [900002 Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [900002 Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [900011 Consultor Administrador]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [900011 Consultor Administrador]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [900011 Consultor Administrador]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [900014 Consultor Auditor]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [ServicioClientePortal]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [900001 Consultor Administrativo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [900001 Consultor Administrativo]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [900001 Consultor Administrativo]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Consultor Administrativo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Consultor Administrativo]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Consultor Administrativo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [900008 Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [aut_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [aut_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [suit_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [autsalud_rol]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Consultor Administrador]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Consultor Administrador]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Consultor Administrador]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbSucursalesAportante] TO [Consultor Auditor]
    AS [dbo];

