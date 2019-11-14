CREATE TABLE [dbo].[tbformulariosCoordinadorPac] (
    [prdo_ms]                  INT       NULL,
    [tpo_frmlro]               CHAR (20) NULL,
    [nmro_frmlro]              CHAR (20) NULL,
    [prdo_ano]                 INT       NULL,
    [cnsctvo_frmlro_crdndr_pc] INT       IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [pk_tbformulariosCoordinadorPac] PRIMARY KEY CLUSTERED ([cnsctvo_frmlro_crdndr_pc] ASC)
);


GO
CREATE STATISTICS [tpo_frmlro]
    ON [dbo].[tbformulariosCoordinadorPac]([tpo_frmlro]);


GO
CREATE STATISTICS [prdo_ano]
    ON [dbo].[tbformulariosCoordinadorPac]([prdo_ano]);

