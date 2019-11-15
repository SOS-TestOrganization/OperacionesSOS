CREATE TABLE [dbo].[tbTPSPeriodicidadesModelos] (
    [cnsctvo_cdgo_prdcdd] INT           NOT NULL,
    [cdgo_prdcdd]         CHAR (2)      NOT NULL,
    [dscrpcn_prdcdd]      VARCHAR (150) NOT NULL,
    [fcha_crcn]           DATETIME      NOT NULL,
    [usro_crcn]           CHAR (30)     NOT NULL,
    [vsble_usro]          CHAR (1)      NOT NULL,
    CONSTRAINT [PK_tbTPSPeriodicidadesModelos] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_prdcdd] ASC)
);


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbTPSPeriodicidadesModelos] TO [Coordinador Parametros RedSalud]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTPSPeriodicidadesModelos] TO [Coordinador Parametros RedSalud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTPSPeriodicidadesModelos] TO [Coordinador Parametros RedSalud]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTPSPeriodicidadesModelos] TO [Coordinador Parametros RedSalud]
    AS [dbo];

