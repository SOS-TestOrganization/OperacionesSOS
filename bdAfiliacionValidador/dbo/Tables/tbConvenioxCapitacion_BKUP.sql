CREATE TABLE [dbo].[tbConvenioxCapitacion_BKUP] (
    [cdgo_cnvno]         NUMERIC (18)           NOT NULL,
    [dscrpcn_cnvno]      [dbo].[udtDescripcion] NOT NULL,
    [cdgo_trfs_cptcn]    NUMERIC (18)           NOT NULL,
    [cdgo_prstcns_cptcn] NUMERIC (18)           NOT NULL,
    [cdgo_mdlo_extrccn]  DECIMAL (18)           NOT NULL,
    [fcha_inco_vgnca]    DATETIME               NOT NULL,
    [fcha_fn_vgnca]      DATETIME               NOT NULL,
    [estdo]              CHAR (1)               NOT NULL,
    [fcha_ultma_mdfccn]  DATETIME               NOT NULL,
    [usro_ultma_mdfccn]  [dbo].[udtUsuario]     NOT NULL,
    [tme_stmp]           ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbConvenioxCapitacion_BKUP] PRIMARY KEY CLUSTERED ([cdgo_cnvno] ASC) WITH (FILLFACTOR = 90)
);

