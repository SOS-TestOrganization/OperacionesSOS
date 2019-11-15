CREATE TABLE [dbo].[tbClasificacionGeografica] (
    [cnsctvo_cdgo_clsfccn_ggrfca] [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_tpo_clsfccn_ggrfca]     CHAR (3)               NOT NULL,
    [dscrpcn_tpo_clsfccn_ggrfca]  [dbo].[udtDescripcion] NOT NULL,
    [fcha_crcn]                   DATETIME               NOT NULL,
    [usro_crcn]                   [dbo].[udtUsuario]     NOT NULL,
    [vsble_usro]                  [dbo].[udtLogico]      NOT NULL,
    CONSTRAINT [PK_TbClasificacionGeografica] PRIMARY KEY NONCLUSTERED ([cnsctvo_cdgo_clsfccn_ggrfca] ASC)
);


GO
CREATE STATISTICS [cdgo_tpo_clsfccn_ggrfca]
    ON [dbo].[tbClasificacionGeografica]([cdgo_tpo_clsfccn_ggrfca]);


GO
CREATE STATISTICS [dscrpcn_tpo_clsfccn_ggrfca]
    ON [dbo].[tbClasificacionGeografica]([dscrpcn_tpo_clsfccn_ggrfca]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbClasificacionGeografica]([fcha_crcn]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbClasificacionGeografica]([usro_crcn]);


GO
CREATE STATISTICS [vsble_usro]
    ON [dbo].[tbClasificacionGeografica]([vsble_usro]);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbClasificacionGeografica] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbClasificacionGeografica] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbClasificacionGeografica] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbClasificacionGeografica] TO [Consulta]
    AS [dbo];

