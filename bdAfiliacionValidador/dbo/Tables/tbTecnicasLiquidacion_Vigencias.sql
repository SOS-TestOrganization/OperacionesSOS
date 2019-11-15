CREATE TABLE [dbo].[tbTecnicasLiquidacion_Vigencias] (
    [cnsctvo_vgnca_tcnca_lqdcn] INT           NOT NULL,
    [cnsctvo_cdgo_tcnca_lqdcn]  INT           NOT NULL,
    [cdgo_tcnca_lqdcn]          CHAR (2)      NOT NULL,
    [dscrpcn_tcnca_lqdcn]       VARCHAR (150) NOT NULL,
    [inco_vgnca]                DATETIME      NOT NULL,
    [fn_vgnca]                  DATETIME      NOT NULL,
    [fcha_crcn]                 DATETIME      NOT NULL,
    [Usro_crcn]                 CHAR (30)     NOT NULL,
    [obsrvcns]                  VARCHAR (250) NOT NULL,
    [vsble_usro]                CHAR (1)      NOT NULL,
    [tme_stmp]                  BINARY (8)    NULL,
    CONSTRAINT [PK_tbTecnicasLiquidacion_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_tcnca_lqdcn] ASC)
);


GO
CREATE STATISTICS [cnsctvo_cdgo_tcnca_lqdcn]
    ON [dbo].[tbTecnicasLiquidacion_Vigencias]([cnsctvo_cdgo_tcnca_lqdcn], [cnsctvo_vgnca_tcnca_lqdcn]);


GO
CREATE STATISTICS [cdgo_tcnca_lqdcn]
    ON [dbo].[tbTecnicasLiquidacion_Vigencias]([cdgo_tcnca_lqdcn], [cnsctvo_vgnca_tcnca_lqdcn]);


GO
CREATE STATISTICS [dscrpcn_tcnca_lqdcn]
    ON [dbo].[tbTecnicasLiquidacion_Vigencias]([dscrpcn_tcnca_lqdcn], [cnsctvo_vgnca_tcnca_lqdcn]);


GO
CREATE STATISTICS [inco_vgnca]
    ON [dbo].[tbTecnicasLiquidacion_Vigencias]([inco_vgnca], [cnsctvo_vgnca_tcnca_lqdcn]);


GO
CREATE STATISTICS [fn_vgnca]
    ON [dbo].[tbTecnicasLiquidacion_Vigencias]([fn_vgnca], [cnsctvo_vgnca_tcnca_lqdcn]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbTecnicasLiquidacion_Vigencias]([fcha_crcn], [cnsctvo_vgnca_tcnca_lqdcn]);


GO
CREATE STATISTICS [Usro_crcn]
    ON [dbo].[tbTecnicasLiquidacion_Vigencias]([Usro_crcn], [cnsctvo_vgnca_tcnca_lqdcn]);


GO
CREATE STATISTICS [obsrvcns]
    ON [dbo].[tbTecnicasLiquidacion_Vigencias]([obsrvcns], [cnsctvo_vgnca_tcnca_lqdcn]);


GO
CREATE STATISTICS [vsble_usro]
    ON [dbo].[tbTecnicasLiquidacion_Vigencias]([vsble_usro], [cnsctvo_vgnca_tcnca_lqdcn]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbTecnicasLiquidacion_Vigencias]([tme_stmp], [cnsctvo_vgnca_tcnca_lqdcn]);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTecnicasLiquidacion_Vigencias] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTecnicasLiquidacion_Vigencias] TO [310014 Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTecnicasLiquidacion_Vigencias] TO [autsalud_rol]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTecnicasLiquidacion_Vigencias] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTecnicasLiquidacion_Vigencias] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTecnicasLiquidacion_Vigencias] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTecnicasLiquidacion_Vigencias] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTecnicasLiquidacion_Vigencias] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTecnicasLiquidacion_Vigencias] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTecnicasLiquidacion_Vigencias] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

