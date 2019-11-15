CREATE TABLE [dbo].[tbTiposAportante_Vigencias] (
    [cnsctvo_vgnca_tpo_aprtnte] INT           NOT NULL,
    [cnsctvo_cdgo_tpo_aprtnte]  INT           NOT NULL,
    [cdgo_tpo_aprtnte]          CHAR (2)      NOT NULL,
    [dscrpcn_tpo_aprtnte]       VARCHAR (150) NOT NULL,
    [inco_vgnca]                DATETIME      NOT NULL,
    [fn_vgnca]                  DATETIME      NOT NULL,
    [fcha_crcn]                 DATETIME      NOT NULL,
    [usro_crcn]                 CHAR (30)     NOT NULL,
    [obsrvcns]                  VARCHAR (250) NOT NULL,
    [vsble_usro]                CHAR (1)      NOT NULL,
    [rngo_infrr]                NUMERIC (18)  NOT NULL,
    [rngo_sprr]                 NUMERIC (18)  NOT NULL,
    [tme_stmp]                  BINARY (8)    NOT NULL,
    CONSTRAINT [PK_tbTiposAportante_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_tpo_aprtnte] ASC)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante_Vigencias] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante_Vigencias] TO [900002 Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante_Vigencias] TO [900011 Consultor Administrador]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante_Vigencias] TO [900014 Consultor Auditor]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante_Vigencias] TO [900001 Consultor Administrativo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante_Vigencias] TO [Consultor Administrativo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante_Vigencias] TO [900008 Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante_Vigencias] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante_Vigencias] TO [Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante_Vigencias] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante_Vigencias] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante_Vigencias] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante_Vigencias] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante_Vigencias] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante_Vigencias] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante_Vigencias] TO [Consultor Administrador]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante_Vigencias] TO [Consultor Auditor]
    AS [dbo];

