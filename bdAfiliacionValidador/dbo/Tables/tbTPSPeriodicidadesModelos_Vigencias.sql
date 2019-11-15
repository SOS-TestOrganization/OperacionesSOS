CREATE TABLE [dbo].[tbTPSPeriodicidadesModelos_Vigencias] (
    [cnsctvo_vgnca_prdcdd] INT           NOT NULL,
    [cnsctvo_cdgo_prdcdd]  INT           NOT NULL,
    [cdgo_prdcdd]          CHAR (2)      NOT NULL,
    [dscrpcn_prdcdd]       VARCHAR (150) NOT NULL,
    [inco_vgnca]           DATETIME      NOT NULL,
    [fn_vgnca]             DATETIME      NOT NULL,
    [fcha_crcn]            DATETIME      NOT NULL,
    [usro_crcn]            CHAR (30)     NOT NULL,
    [obsrvcns]             VARCHAR (250) NOT NULL,
    [vsble_usro]           CHAR (1)      NOT NULL,
    [tme_stmp]             BINARY (8)    NOT NULL,
    CONSTRAINT [PK_tbTPSPeriodicidadesModelos_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_prdcdd] ASC)
);


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbTPSPeriodicidadesModelos_Vigencias] TO [Coordinador Parametros RedSalud]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTPSPeriodicidadesModelos_Vigencias] TO [Coordinador Parametros RedSalud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTPSPeriodicidadesModelos_Vigencias] TO [Coordinador Parametros RedSalud]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTPSPeriodicidadesModelos_Vigencias] TO [Coordinador Parametros RedSalud]
    AS [dbo];

