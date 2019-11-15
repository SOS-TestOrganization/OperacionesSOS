CREATE TABLE [dbo].[tbIncidenciasCarteraPac] (
    [cnsctvo_incdnca]       INT                     IDENTITY (1, 1) NOT NULL,
    [bse_dts]               [dbo].[udtNombreObjeto] NOT NULL,
    [nmbre_tbla]            [dbo].[udtNombreObjeto] NOT NULL,
    [nmbre_cmpo]            [dbo].[udtNombreObjeto] NOT NULL,
    [cnsctvo_vgnca]         [dbo].[udtConsecutivo]  NOT NULL,
    [vlr_antrr]             VARCHAR (250)           NULL,
    [vlr_nvo]               VARCHAR (250)           NULL,
    [usro_incdnca]          [dbo].[udtUsuario]      NOT NULL,
    [fcha_incdnca]          DATETIME                NOT NULL,
    [cnsctvo_rgstro_afctdo] [dbo].[udtConsecutivo]  NOT NULL,
    [tme_stmp]              ROWVERSION              NOT NULL,
    CONSTRAINT [PK_tbIncidenciasAfiliacion] PRIMARY KEY CLUSTERED ([cnsctvo_incdnca] ASC)
);


GO
CREATE STATISTICS [bse_dts]
    ON [dbo].[tbIncidenciasCarteraPac]([bse_dts]);


GO
CREATE STATISTICS [nmbre_tbla]
    ON [dbo].[tbIncidenciasCarteraPac]([nmbre_tbla]);


GO
CREATE STATISTICS [nmbre_cmpo]
    ON [dbo].[tbIncidenciasCarteraPac]([nmbre_cmpo]);


GO
CREATE STATISTICS [cnsctvo_vgnca]
    ON [dbo].[tbIncidenciasCarteraPac]([cnsctvo_vgnca]);


GO
CREATE STATISTICS [vlr_antrr]
    ON [dbo].[tbIncidenciasCarteraPac]([vlr_antrr]);


GO
CREATE STATISTICS [vlr_nvo]
    ON [dbo].[tbIncidenciasCarteraPac]([vlr_nvo]);


GO
CREATE STATISTICS [usro_incdnca]
    ON [dbo].[tbIncidenciasCarteraPac]([usro_incdnca]);


GO
CREATE STATISTICS [cnsctvo_rgstro_afctdo]
    ON [dbo].[tbIncidenciasCarteraPac]([cnsctvo_rgstro_afctdo]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbIncidenciasCarteraPac]([tme_stmp]);

