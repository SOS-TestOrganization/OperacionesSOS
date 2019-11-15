CREATE TABLE [dbo].[tbModeloCapitacionExtraccionDetalle] (
    [cnsctvo_cdgo_mdlo_cptcn_extrccn_dtlle] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_mdlo_cptcn_extrccn]       [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_tpo_mdlo]                 [dbo].[udtConsecutivo] NOT NULL,
    [da_extrccn]                            INT                    NOT NULL,
    [da_crte]                               INT                    NOT NULL,
    [prdcdd]                                [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_mdlo_cptcn_extrccn_ref]   [dbo].[udtConsecutivo] NULL,
    [fcha_crcn]                             DATETIME               NOT NULL,
    [usro_crcn]                             [dbo].[udtUsuario]     NOT NULL,
    [inco_vgnca]                            DATETIME               NOT NULL,
    [fn_vgnca]                              DATETIME               NOT NULL,
    [obsrvcns]                              [dbo].[udtObservacion] NOT NULL,
    [tme_stmp]                              ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbModeloCapitacionExtraccionDetalle] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_mdlo_cptcn_extrccn_dtlle] ASC)
);


GO
CREATE STATISTICS [cnsctvo_cdgo_tpo_mdlo]
    ON [dbo].[tbModeloCapitacionExtraccionDetalle]([cnsctvo_cdgo_tpo_mdlo]);


GO
CREATE STATISTICS [da_extrccn]
    ON [dbo].[tbModeloCapitacionExtraccionDetalle]([da_extrccn]);


GO
CREATE STATISTICS [da_crte]
    ON [dbo].[tbModeloCapitacionExtraccionDetalle]([da_crte]);


GO
CREATE STATISTICS [prdcdd]
    ON [dbo].[tbModeloCapitacionExtraccionDetalle]([prdcdd]);


GO
CREATE STATISTICS [cnsctvo_cdgo_mdlo_cptcn_extrccn_ref]
    ON [dbo].[tbModeloCapitacionExtraccionDetalle]([cnsctvo_cdgo_mdlo_cptcn_extrccn_ref]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbModeloCapitacionExtraccionDetalle]([fcha_crcn]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbModeloCapitacionExtraccionDetalle]([usro_crcn]);


GO
CREATE STATISTICS [obsrvcns]
    ON [dbo].[tbModeloCapitacionExtraccionDetalle]([obsrvcns]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbModeloCapitacionExtraccionDetalle]([tme_stmp]);


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbModeloCapitacionExtraccionDetalle] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbModeloCapitacionExtraccionDetalle] TO [aut_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbModeloCapitacionExtraccionDetalle] TO [aut_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbModeloCapitacionExtraccionDetalle] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbModeloCapitacionExtraccionDetalle] TO [webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbModeloCapitacionExtraccionDetalle] TO [webusr]
    AS [dbo];

