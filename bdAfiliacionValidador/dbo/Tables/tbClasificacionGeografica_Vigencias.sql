CREATE TABLE [dbo].[tbClasificacionGeografica_Vigencias] (
    [cnsctvo_vgnca_clsfccn_ggrfca] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_clsfccn_ggrfca]  [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_tpo_clsfccn_ggrfca]      CHAR (3)               NOT NULL,
    [dscrpcn_tpo_clsfccn_ggrfca]   [dbo].[udtDescripcion] NOT NULL,
    [inco_vgnca]                   DATETIME               NOT NULL,
    [fn_vgnca]                     DATETIME               NOT NULL,
    [fcha_crcn]                    DATETIME               NOT NULL,
    [usro_crcn]                    [dbo].[udtUsuario]     NOT NULL,
    [obsrvcns]                     [dbo].[udtObservacion] NOT NULL,
    [vsble_usro]                   [dbo].[udtLogico]      NOT NULL,
    [tme_stmp]                     ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbClasificacionGeografica_Vigencias] PRIMARY KEY NONCLUSTERED ([cnsctvo_vgnca_clsfccn_ggrfca] ASC)
);


GO
CREATE STATISTICS [cnsctvo_vgnca_clsfccn_ggrfca]
    ON [dbo].[tbClasificacionGeografica_Vigencias]([cnsctvo_vgnca_clsfccn_ggrfca]);


GO
CREATE STATISTICS [cnsctvo_cdgo_clsfccn_ggrfca]
    ON [dbo].[tbClasificacionGeografica_Vigencias]([cnsctvo_cdgo_clsfccn_ggrfca]);


GO
CREATE STATISTICS [cdgo_tpo_clsfccn_ggrfca]
    ON [dbo].[tbClasificacionGeografica_Vigencias]([cdgo_tpo_clsfccn_ggrfca]);


GO
CREATE STATISTICS [dscrpcn_tpo_clsfccn_ggrfca]
    ON [dbo].[tbClasificacionGeografica_Vigencias]([dscrpcn_tpo_clsfccn_ggrfca]);


GO
CREATE STATISTICS [inco_vgnca]
    ON [dbo].[tbClasificacionGeografica_Vigencias]([inco_vgnca]);


GO
CREATE STATISTICS [fn_vgnca]
    ON [dbo].[tbClasificacionGeografica_Vigencias]([fn_vgnca]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbClasificacionGeografica_Vigencias]([fcha_crcn]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbClasificacionGeografica_Vigencias]([usro_crcn]);


GO
CREATE STATISTICS [obsrvcns]
    ON [dbo].[tbClasificacionGeografica_Vigencias]([obsrvcns]);


GO
CREATE STATISTICS [vsble_usro]
    ON [dbo].[tbClasificacionGeografica_Vigencias]([vsble_usro]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbClasificacionGeografica_Vigencias]([tme_stmp]);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbClasificacionGeografica_Vigencias] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbClasificacionGeografica_Vigencias] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbClasificacionGeografica_Vigencias] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbClasificacionGeografica_Vigencias] TO [Consulta]
    AS [dbo];

