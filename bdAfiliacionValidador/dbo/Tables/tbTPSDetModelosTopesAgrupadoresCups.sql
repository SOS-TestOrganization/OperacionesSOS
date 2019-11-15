CREATE TABLE [dbo].[tbTPSDetModelosTopesAgrupadoresCups] (
    [cnsctvo_dtlle_mdlo_tps_agrpdrs_cps] INT        NOT NULL,
    [cnsctvo_mdlo]                       INT        NOT NULL,
    [cnsctvo_cdgo_agrpdr_prstcn]         INT        NOT NULL,
    [cnsctvo_cdgo_clse_atncn]            INT        NOT NULL,
    [cnsctvo_cdgo_prdcdd]                INT        NOT NULL,
    [vlr_tpe]                            INT        NOT NULL,
    [usro_crcn]                          CHAR (30)  NOT NULL,
    [fcha_crcn]                          DATETIME   NOT NULL,
    [usro_ultma_mdfccn]                  CHAR (30)  NOT NULL,
    [fcha_ultma_mdfccn]                  DATETIME   NOT NULL,
    [tme_stmp]                           BINARY (8) NOT NULL,
    CONSTRAINT [PK_tbTPSDetModelosTopesAgrupadoresCups] PRIMARY KEY CLUSTERED ([cnsctvo_dtlle_mdlo_tps_agrpdrs_cps] ASC)
);


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [900002 Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [900002 Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [900002 Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310013 Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310013 Analista Red Servicios]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310013 Analista Red Servicios]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310014 Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310014 Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310014 Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [SOS\310015 Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [SOS\310015 Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [SOS\310015 Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310002 Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310002 Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310002 Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310004 Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310004 Consultor Salud]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310004 Consultor Salud]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310007 Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310007 Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310007 Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310008 Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310008 Auditor Salud]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310008 Auditor Salud]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310003 Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310003 Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310003 Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310001 Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310001 Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310001 Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [330003 Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [330003 Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [330003 Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310009 Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310009 Autorizadora Notificacion]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310009 Autorizadora Notificacion]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310010 Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310010 Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310010 Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310011 Auditoria Interna Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310011 Auditoria Interna Salud]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [310011 Auditoria Interna Salud]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [cna_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [cna_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [900008 Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [900008 Consultor Salud]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [900008 Consultor Salud]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [300006 Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [300006 Auditor Interno de PVS]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [300006 Auditor Interno de PVS]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [aut_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [aut_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [ctp_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [ctp_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [ctp_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [ctp_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTPSDetModelosTopesAgrupadoresCups] TO [webusr]
    AS [dbo];

