CREATE TABLE [dbo].[tbCamposConsultas] (
    [cnsctvo_cdgo_cmpo_cnslta] [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_cmpo_cnslta]         CHAR (4)               NOT NULL,
    [dscrpcn_cmpo_cnslta]      [dbo].[udtDescripcion] NOT NULL,
    [fcha_crcn]                DATETIME               NOT NULL,
    [usro_crcn]                [dbo].[udtUsuario]     NOT NULL,
    [vsble_usro]               [dbo].[udtLogico]      NOT NULL,
    CONSTRAINT [PK_tbCamposConsultas] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_cmpo_cnslta] ASC)
);


GO
CREATE STATISTICS [cdgo_cmpo_cnslta]
    ON [dbo].[tbCamposConsultas]([cdgo_cmpo_cnslta], [cnsctvo_cdgo_cmpo_cnslta]);


GO
CREATE STATISTICS [dscrpcn_cmpo_cnslta]
    ON [dbo].[tbCamposConsultas]([dscrpcn_cmpo_cnslta], [cnsctvo_cdgo_cmpo_cnslta]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbCamposConsultas]([fcha_crcn], [cnsctvo_cdgo_cmpo_cnslta]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbCamposConsultas]([usro_crcn], [cnsctvo_cdgo_cmpo_cnslta]);


GO
CREATE STATISTICS [vsble_usro]
    ON [dbo].[tbCamposConsultas]([vsble_usro], [cnsctvo_cdgo_cmpo_cnslta]);

