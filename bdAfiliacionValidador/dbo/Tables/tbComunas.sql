CREATE TABLE [dbo].[tbComunas] (
    [cnsctvo_cdgo_cmna] [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_cmna]         CHAR (4)               NOT NULL,
    [dscrpcn_cmna]      [dbo].[udtDescripcion] NOT NULL,
    [fcha_crcn]         DATETIME               NOT NULL,
    [usro_crcn]         [dbo].[udtUsuario]     NOT NULL,
    [vsble_usro]        [dbo].[udtLogico]      NOT NULL,
    CONSTRAINT [PK_tbComunas] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_cmna] ASC)
);


GO
CREATE STATISTICS [cdgo_cmna]
    ON [dbo].[tbComunas]([cdgo_cmna]);


GO
CREATE STATISTICS [dscrpcn_cmna]
    ON [dbo].[tbComunas]([dscrpcn_cmna]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbComunas]([fcha_crcn]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbComunas]([usro_crcn]);


GO
CREATE STATISTICS [vsble_usro]
    ON [dbo].[tbComunas]([vsble_usro]);


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbComunas] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbComunas] TO [aut_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbComunas] TO [aut_webusr]
    AS [dbo];

