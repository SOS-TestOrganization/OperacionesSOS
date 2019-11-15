﻿CREATE TABLE [dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] (
    [cnsctvo_vgnca_agrpdr_tpo_idntfccn] INT           NOT NULL,
    [cnsctvo_cdgo_agrpdr_tpo_idntfccn]  INT           NOT NULL,
    [cdgo_agrpdr_tpo_idntfccn]          CHAR (2)      NOT NULL,
    [dscrpcn_agrpdr]                    VARCHAR (150) NOT NULL,
    [inco_vgnca]                        DATETIME      NOT NULL,
    [fn_vgnca]                          DATETIME      NOT NULL,
    [fcha_crcn]                         DATETIME      NOT NULL,
    [usro_crcn]                         CHAR (30)     NOT NULL,
    [obsrvcns]                          VARCHAR (250) NOT NULL,
    [vsble_usro]                        CHAR (1)      NOT NULL,
    [tme_stmp]                          BINARY (8)    NULL,
    CONSTRAINT [PK_tbAgrupadoresTiposIdentificacion_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_agrpdr_tpo_idntfccn] ASC),
    CONSTRAINT [FK_tbAgrupadoresTiposIdentificacion_Vigencias_tbAgrupadoresTiposIdentificacion] FOREIGN KEY ([cnsctvo_cdgo_agrpdr_tpo_idntfccn]) REFERENCES [dbo].[tbAgrupadoresTiposIdentificacion] ([cnsctvo_cdgo_agrpdr_tpo_idntfccn])
);


GO
CREATE STATISTICS [dscrpcn_agrpdr]
    ON [dbo].[tbAgrupadoresTiposIdentificacion_Vigencias]([dscrpcn_agrpdr], [cnsctvo_vgnca_agrpdr_tpo_idntfccn]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbAgrupadoresTiposIdentificacion_Vigencias]([fcha_crcn], [cnsctvo_vgnca_agrpdr_tpo_idntfccn]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbAgrupadoresTiposIdentificacion_Vigencias]([usro_crcn], [cnsctvo_vgnca_agrpdr_tpo_idntfccn]);


GO
CREATE STATISTICS [obsrvcns]
    ON [dbo].[tbAgrupadoresTiposIdentificacion_Vigencias]([obsrvcns], [cnsctvo_vgnca_agrpdr_tpo_idntfccn]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbAgrupadoresTiposIdentificacion_Vigencias]([tme_stmp], [cnsctvo_vgnca_agrpdr_tpo_idntfccn]);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Analistas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [cna_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [900005 Consultor Asesor Comercial]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Desarrollo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbAgrupadoresTiposIdentificacion_Vigencias] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];
