CREATE TABLE [dbo].[tbDetModeloConveniosCapitacion] (
    [cnsctvo_cdgo_det_mdlo_cnvno_cptcn]    [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_mdlo_cnvno_cptcn]        [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_mdlo_cnvno_cptcn_trfa]   [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_mdlo_cnvno_cptcn_prstcn] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_mdlo_cptcn_extrccn]      [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_mdlo_cptcn_escnro]       [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_mdlo_cptcn_cdd]          [dbo].[udtConsecutivo] NOT NULL,
    [usro_crcn]                            [dbo].[udtUsuario]     NOT NULL,
    [fcha_crcn]                            DATETIME               NOT NULL,
    [inco_vgnca]                           DATETIME               NOT NULL,
    [fn_vgnca]                             DATETIME               NOT NULL,
    [obsrvcns]                             [dbo].[udtObservacion] NOT NULL,
    [tme_stmp]                             ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbDetModeloConveniosCapitacion] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_det_mdlo_cnvno_cptcn] ASC)
);


GO
CREATE STATISTICS [cnsctvo_cdgo_mdlo_cnvno_cptcn_trfa]
    ON [dbo].[tbDetModeloConveniosCapitacion]([cnsctvo_cdgo_mdlo_cnvno_cptcn_trfa]);


GO
CREATE STATISTICS [cnsctvo_cdgo_mdlo_cnvno_cptcn_prstcn]
    ON [dbo].[tbDetModeloConveniosCapitacion]([cnsctvo_cdgo_mdlo_cnvno_cptcn_prstcn]);


GO
CREATE STATISTICS [cnsctvo_cdgo_mdlo_cptcn_extrccn]
    ON [dbo].[tbDetModeloConveniosCapitacion]([cnsctvo_cdgo_mdlo_cptcn_extrccn]);


GO
CREATE STATISTICS [cnsctvo_cdgo_mdlo_cptcn_escnro]
    ON [dbo].[tbDetModeloConveniosCapitacion]([cnsctvo_cdgo_mdlo_cptcn_escnro]);


GO
CREATE STATISTICS [cnsctvo_cdgo_mdlo_cptcn_cdd]
    ON [dbo].[tbDetModeloConveniosCapitacion]([cnsctvo_cdgo_mdlo_cptcn_cdd]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbDetModeloConveniosCapitacion]([usro_crcn]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbDetModeloConveniosCapitacion]([fcha_crcn]);


GO
CREATE STATISTICS [obsrvcns]
    ON [dbo].[tbDetModeloConveniosCapitacion]([obsrvcns]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbDetModeloConveniosCapitacion]([tme_stmp]);


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbDetModeloConveniosCapitacion] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloConveniosCapitacion] TO [aut_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbDetModeloConveniosCapitacion] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetModeloConveniosCapitacion] TO [autsalud_rol]
    AS [dbo];

