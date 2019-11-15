CREATE TABLE [dbo].[TbDatosAportanteNotaReintegro] (
    [cnsctvo_dts_aprtnte_nta_rngo] INT                    IDENTITY (1, 1) NOT NULL,
    [nmro_nta]                     VARCHAR (15)           NOT NULL,
    [cnsctvo_cdgo_pgo]             [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_atrzdr_nta]      [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_tpo_idntfccn]            VARCHAR (20)           NOT NULL,
    [nmro_idntfccn]                NUMERIC (18)           NOT NULL,
    [prmr_nmbre]                   VARCHAR (20)           NOT NULL,
    [sgndo_nmbre]                  VARCHAR (20)           NULL,
    [prmr_aplldo]                  VARCHAR (20)           NULL,
    [sgndo_aplldo]                 VARCHAR (20)           NULL,
    [drccn_aprtnte]                VARCHAR (50)           NULL,
    [tlfno_aprtnte]                VARCHAR (30)           NULL,
    [cnsctvo_cdgo_cdd]             VARCHAR (8)            NULL,
    [cntro_csts]                   VARCHAR (10)           NULL,
    [fcha_pgo_acrddo]              DATETIME               NULL,
    [sldo_pgo]                     NUMERIC (18)           NULL,
    [fcha_crcn]                    DATETIME               NOT NULL,
    [cnsctvo_cdgo_sde]             [dbo].[udtConsecutivo] NULL,
    [usro_crcn]                    [dbo].[udtUsuario]     NOT NULL,
    [tme_stmp]                     ROWVERSION             NOT NULL,
    CONSTRAINT [PK_TbDatosAportanteNotaReintegro] PRIMARY KEY CLUSTERED ([nmro_nta] ASC, [cnsctvo_dts_aprtnte_nta_rngo] ASC)
);

