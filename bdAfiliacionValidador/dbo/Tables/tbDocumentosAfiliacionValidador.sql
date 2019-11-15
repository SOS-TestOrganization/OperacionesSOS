CREATE TABLE [dbo].[tbDocumentosAfiliacionValidador] (
    [cnsctvo_dcmnto_gnrdo]      INT          NOT NULL,
    [cnsctvo_cdgo_tpo_dcmnto]   INT          NOT NULL,
    [nmro_dcmnto]               CHAR (50)    NOT NULL,
    [cnsctvo_cdgo_estdo_dcmnto] INT          NOT NULL,
    [inco_vgnca_dcmnto]         DATETIME     NULL,
    [fn_vgnca_dcmnto]           DATETIME     NULL,
    [cnsctvo_cdgo_pln]          INT          NOT NULL,
    [cnsctvo_bnfcro]            INT          NOT NULL,
    [cnsctvo_cdgo_tpo_idntfccn] INT          NULL,
    [nmro_idntfccn]             VARCHAR (23) NULL,
    [nmro_unco_idntfccn]        INT          NULL,
    [fcha_utlzcn_bno]           DATETIME     NULL,
    CONSTRAINT [PK_tbDocumentosAfiliacionValidador] PRIMARY KEY CLUSTERED ([cnsctvo_dcmnto_gnrdo] ASC)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDocumentosAfiliacionValidador] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDocumentosAfiliacionValidador] TO [310001 Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDocumentosAfiliacionValidador] TO [310009 Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDocumentosAfiliacionValidador] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDocumentosAfiliacionValidador] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDocumentosAfiliacionValidador] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDocumentosAfiliacionValidador] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDocumentosAfiliacionValidador] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDocumentosAfiliacionValidador] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDocumentosAfiliacionValidador] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDocumentosAfiliacionValidador] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

