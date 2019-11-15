CREATE TABLE [dbo].[tbTiposCotizante_Vigencias] (
    [cnsctvo_vgnca_tpo_ctznte]          INT             NOT NULL,
    [cnsctvo_cdgo_tpo_ctznte]           INT             NOT NULL,
    [cdgo_tpo_ctznte]                   CHAR (2)        NOT NULL,
    [dscrpcn_tpo_ctznte]                VARCHAR (150)   NOT NULL,
    [inco_vgnca]                        DATETIME        NOT NULL,
    [fn_vgnca]                          DATETIME        NOT NULL,
    [fcha_crcn]                         DATETIME        NOT NULL,
    [usro_crcn]                         CHAR (30)       NOT NULL,
    [obsrvcns]                          VARCHAR (250)   NOT NULL,
    [vsble_usro]                        CHAR (1)        NOT NULL,
    [cnsctvo_cdgo_tpo_cbrnza]           INT             NOT NULL,
    [cnsctvo_agrpcn_tpo_prmtro_prgrmcn] INT             NOT NULL,
    [cntdd_mnma_slro]                   NUMERIC (13, 3) NOT NULL,
    [cnsctvo_cdgo_clse_aprtnte]         INT             NOT NULL,
    [cntdd_mxma_slro]                   NUMERIC (13, 3) NULL,
    [prcntje_ctzcn]                     NUMERIC (13, 3) NULL,
    [edd_mnma]                          INT             NULL,
    [tme_stmp]                          BINARY (8)      NOT NULL,
    [drcho_lqdcn_PE]                    CHAR (1)        NULL,
    CONSTRAINT [PK_tbTiposCotizante_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_tpo_ctznte] ASC)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Prestaciones Economicas]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [pe_soa]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [pe_soa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [pe_soa]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [pe_soa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Consultor Administrativo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [aut_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposCotizante_Vigencias] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];

