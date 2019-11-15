CREATE TABLE [dbo].[tbEntidades_Vigencias_isis] (
    [cnsctvo_vgnca_entdd]      INT           NOT NULL,
    [cnsctvo_cdgo_entdd]       INT           NOT NULL,
    [cdgo_entdd]               CHAR (8)      NOT NULL,
    [dscrpcn_entdd]            VARCHAR (150) NOT NULL,
    [inco_vgnca]               DATETIME      NOT NULL,
    [fn_vgnca]                 DATETIME      NOT NULL,
    [fcha_crcn]                DATETIME      NOT NULL,
    [usro_crcn]                CHAR (30)     NOT NULL,
    [obsrvcns]                 VARCHAR (250) NOT NULL,
    [vsble_usro]               CHAR (1)      NOT NULL,
    [nmro_unco_idntfccn_entdd] INT           NOT NULL,
    [cnsctvo_cdgo_tpo_entdd]   INT           NOT NULL,
    [tlfno_entdd]              CHAR (30)     NOT NULL,
    [fx_entdd]                 CHAR (30)     NOT NULL,
    [drccn_entdd]              VARCHAR (80)  NOT NULL,
    [eml]                      VARCHAR (50)  NOT NULL,
    [cnsctvo_cdgo_cdd]         INT           NOT NULL,
    [prmr_aplldo]              CHAR (50)     NOT NULL,
    [sgndo_aplldo]             CHAR (50)     NOT NULL,
    [prmr_nmbre]               CHAR (20)     NOT NULL,
    [sgndo_nmbre]              CHAR (20)     NOT NULL,
    [cnsctvo_cdgo_crgo]        INT           NOT NULL,
    [tme_stmp]                 BINARY (8)    NULL,
    CONSTRAINT [PK_tbEntidades_Visis] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_entdd] ASC)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias_isis] TO [900014 Consultor Auditor]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias_isis] TO [Consultor Administrativo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias_isis] TO [Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias_isis] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias_isis] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias_isis] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbEntidades_Vigencias_isis] TO [Consultor Auditor]
    AS [dbo];

