CREATE TABLE [dbo].[tmptbNotasPac] (
    [nmro_nta]                           VARCHAR (15)           NOT NULL,
    [cnsctvo_cdgo_tpo_nta]               [dbo].[udtConsecutivo] NOT NULL,
    [vlr_nta]                            [dbo].[udtValorGrande] NOT NULL,
    [vlr_iva]                            [dbo].[udtValorGrande] NOT NULL,
    [sldo_nta]                           [dbo].[udtValorGrande] NOT NULL,
    [cnsctvo_prdo]                       [dbo].[udtConsecutivo] NOT NULL,
    [fcha_crcn_nta]                      DATETIME               NOT NULL,
    [cnsctvo_cdgo_estdo_nta]             [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_tpo_aplccn_nta]        [dbo].[udtConsecutivo] NOT NULL,
    [obsrvcns]                           VARCHAR (500)          NOT NULL,
    [usro_crcn]                          [dbo].[udtUsuario]     NOT NULL,
    [nmro_unco_idntfccn_empldr]          [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_scrsl]                      [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_clse_aprtnte]          [dbo].[udtConsecutivo] NOT NULL,
    [fcha_prdo_nta]                      DATETIME               NULL,
    [tme_stmp]                           ROWVERSION             NOT NULL,
    [cnsctvo_cdgo_tpo_dcmnto_nta_rntgro] VARCHAR (50)           NULL,
    [fcha_entrga_nta]                    DATETIME               NULL,
    [cnsctvo_cdgo_exstnca_aprtnte]       INT                    NOT NULL,
    [cnsctvo_cdgo_estdo_dcmnto_fe]       [dbo].[udtConsecutivo] NULL
);

