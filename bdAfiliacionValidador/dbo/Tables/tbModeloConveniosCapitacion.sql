CREATE TABLE [dbo].[tbModeloConveniosCapitacion] (
    [cnsctvo_cdgo_mdlo_cnvno_cptcn] INT           NOT NULL,
    [cdgo_mdlo_cnvno_cptcn]         CHAR (3)      NULL,
    [dscrpcn_mdlo_cnvno_cptcn]      VARCHAR (150) NOT NULL,
    [fcha_crcn]                     DATETIME      NOT NULL,
    [usro_crcn]                     CHAR (30)     NOT NULL,
    [inco_vgnca]                    DATETIME      NOT NULL,
    [fn_vgnca]                      DATETIME      NOT NULL,
    [obsrvcns]                      VARCHAR (250) NOT NULL,
    [estdo]                         CHAR (1)      NOT NULL,
    [tme_stmp]                      BINARY (8)    NOT NULL,
    [cnsctvo_cdgo_tpo_mdlo]         INT           CONSTRAINT [DF__tbModeloC__cnsct__31DC5032] DEFAULT ((4)) NULL,
    CONSTRAINT [PK_tbModeloConveniosCapitacion] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_mdlo_cnvno_cptcn] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tbModeloConveniosCapitacion]
    ON [dbo].[tbModeloConveniosCapitacion]([cdgo_mdlo_cnvno_cptcn] ASC);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbModeloConveniosCapitacion] TO [autsalud_rol]
    AS [dbo];

