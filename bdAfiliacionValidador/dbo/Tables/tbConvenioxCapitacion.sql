CREATE TABLE [dbo].[tbConvenioxCapitacion] (
    [cdgo_cnvno]         NUMERIC (18)  NOT NULL,
    [dscrpcn_cnvno]      VARCHAR (150) NOT NULL,
    [cdgo_trfs_cptcn]    NUMERIC (18)  NOT NULL,
    [cdgo_prstcns_cptcn] NUMERIC (18)  NOT NULL,
    [cdgo_mdlo_extrccn]  DECIMAL (18)  NOT NULL,
    [fcha_inco_vgnca]    DATETIME      NOT NULL,
    [fcha_fn_vgnca]      DATETIME      NOT NULL,
    [estdo]              CHAR (1)      NOT NULL,
    [fcha_ultma_mdfccn]  DATETIME      NOT NULL,
    [usro_ultma_mdfccn]  CHAR (30)     NOT NULL,
    [tme_stmp]           BINARY (8)    NOT NULL,
    CONSTRAINT [PK_tbConvenioxCapitacion] PRIMARY KEY CLUSTERED ([cdgo_cnvno] ASC)
);

