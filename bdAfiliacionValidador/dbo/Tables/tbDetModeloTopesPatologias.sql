CREATE TABLE [dbo].[tbDetModeloTopesPatologias] (
    [cnsctvo_dtlle_mdlo_tps_ptlgs] INT             NOT NULL,
    [cnsctvo_mdlo]                 INT             NOT NULL,
    [cnsctvo_cdgo_ptlgs_ctstrfcs]  INT             NOT NULL,
    [cnsctvo_cdgo_tpo_vlr_ptlga]   INT             NOT NULL,
    [vlr_asmdo_ss]                 NUMERIC (12, 2) NOT NULL,
    [usro_crcn]                    CHAR (30)       NOT NULL,
    [fcha_crcn]                    DATETIME        NOT NULL,
    [usro_ultma_mdfccn]            CHAR (30)       NULL,
    [fcha_ultma_mdfccn]            DATETIME        NULL,
    [tme_stmp]                     BINARY (8)      NOT NULL,
    CONSTRAINT [PK_TbDetModeloTopesPatologias] PRIMARY KEY CLUSTERED ([cnsctvo_dtlle_mdlo_tps_ptlgs] ASC, [cnsctvo_mdlo] ASC)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesPatologias] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesPatologias] TO [310014 Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesPatologias] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesPatologias] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesPatologias] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesPatologias] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesPatologias] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesPatologias] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesPatologias] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesPatologias] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesPatologias] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesPatologias] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloTopesPatologias] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

