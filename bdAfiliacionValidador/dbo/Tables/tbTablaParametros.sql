CREATE TABLE [dbo].[tbTablaParametros] (
    [cnsctvo_prmtro] [dbo].[udtConsecutivo] NOT NULL,
    [dscrpcn_prmtro] [dbo].[udtDescripcion] NOT NULL,
    [vlr_prmtro]     VARCHAR (250)          NOT NULL,
    CONSTRAINT [PK_tbTablaParametros] PRIMARY KEY CLUSTERED ([cnsctvo_prmtro] ASC)
);


GO
CREATE STATISTICS [dscrpcn_prmtro]
    ON [dbo].[tbTablaParametros]([dscrpcn_prmtro], [cnsctvo_prmtro]);


GO
CREATE STATISTICS [vlr_prmtro]
    ON [dbo].[tbTablaParametros]([vlr_prmtro], [cnsctvo_prmtro]);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTablaParametros] TO [Analistas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTablaParametros] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTablaParametros] TO [aut_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTablaParametros] TO [aut_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTablaParametros] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTablaParametros] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTablaParametros] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTablaParametros] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTablaParametros] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTablaParametros] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTablaParametros] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTablaParametros] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTablaParametros] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTablaParametros] TO [proceso3047_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTablaParametros] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTablaParametros] TO [autsalud_rol]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTablaParametros] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTablaParametros] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTablaParametros] TO [Consulta]
    AS [dbo];

