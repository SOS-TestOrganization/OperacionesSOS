CREATE TABLE [dbo].[tbCamposConsultas_Vigencias] (
    [cnsctvo_vgnca_cdgo_cmpo_cnslta] [dbo].[udtConsecutivo]  NOT NULL,
    [cnsctvo_cdgo_cmpo_cnslta]       [dbo].[udtConsecutivo]  NOT NULL,
    [cdgo_cmpo_cnslta]               CHAR (4)                NOT NULL,
    [dscrpcn_cmpo_cnslta]            [dbo].[udtDescripcion]  NOT NULL,
    [inco_vgnca]                     DATETIME                NOT NULL,
    [fn_vgnca]                       DATETIME                NOT NULL,
    [fcha_crcn]                      DATETIME                NOT NULL,
    [usro_crcn]                      [dbo].[udtUsuario]      NOT NULL,
    [obsrvcns]                       [dbo].[udtObservacion]  NOT NULL,
    [vsble_usro]                     [dbo].[udtLogico]       NOT NULL,
    [nmbre_sp_prmtro]                [dbo].[udtDescripcion]  NULL,
    [prmtrs_sp]                      VARCHAR (100)           NULL,
    [clse_lgca]                      CHAR (50)               NOT NULL,
    [tpo_dts]                        VARCHAR (50)            NULL,
    [lngtd_cmpo]                     INT                     NOT NULL,
    [nmbre_cmpo_cdgo]                [dbo].[udtNombreObjeto] NULL,
    [nmbre_cmpo_cnsctvo]             [dbo].[udtNombreObjeto] NULL,
    [nmbre_cmpo_dscrpcn]             [dbo].[udtNombreObjeto] NULL,
    [nmro_crctrs_dscrpcn]            [dbo].[udtConsecutivo]  NULL,
    [nmbrs_clmns_grd]                [dbo].[udtDescripcion]  NULL,
    [dscrpcn_bsqda]                  [dbo].[udtDescripcion]  NULL,
    [tpo_aplccn]                     [dbo].[udtConsecutivo]  NULL,
    [nmbre_cmpo_prncpl]              [dbo].[udtNombreObjeto] NULL,
    [envr_cmo_prmtro]                TINYINT                 NULL,
    [ordn_prmtro_adcnl]              TINYINT                 NULL,
    [tme_stmp]                       ROWVERSION              NOT NULL,
    CONSTRAINT [PK_tbCamposConsultas_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_cdgo_cmpo_cnslta] ASC),
    CONSTRAINT [CKFinicioVgncaMayor_InicioVigencia_tbCamposConsultas_Vigencias] CHECK ([fn_vgnca] >= [inco_vgnca]),
    CONSTRAINT [FK_tbCamposConsultas_Vigencias_tbCamposConsultas] FOREIGN KEY ([cnsctvo_cdgo_cmpo_cnslta]) REFERENCES [dbo].[tbCamposConsultas] ([cnsctvo_cdgo_cmpo_cnslta]) ON DELETE CASCADE
);


GO
CREATE STATISTICS [cnsctvo_cdgo_cmpo_cnslta]
    ON [dbo].[tbCamposConsultas_Vigencias]([cnsctvo_cdgo_cmpo_cnslta], [cnsctvo_vgnca_cdgo_cmpo_cnslta]);


GO
CREATE STATISTICS [cdgo_cmpo_cnslta]
    ON [dbo].[tbCamposConsultas_Vigencias]([cdgo_cmpo_cnslta], [cnsctvo_vgnca_cdgo_cmpo_cnslta]);


GO
CREATE STATISTICS [dscrpcn_cmpo_cnslta]
    ON [dbo].[tbCamposConsultas_Vigencias]([dscrpcn_cmpo_cnslta], [cnsctvo_vgnca_cdgo_cmpo_cnslta]);


GO
CREATE STATISTICS [inco_vgnca]
    ON [dbo].[tbCamposConsultas_Vigencias]([inco_vgnca], [cnsctvo_vgnca_cdgo_cmpo_cnslta]);


GO
CREATE STATISTICS [fn_vgnca]
    ON [dbo].[tbCamposConsultas_Vigencias]([fn_vgnca], [cnsctvo_vgnca_cdgo_cmpo_cnslta]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbCamposConsultas_Vigencias]([fcha_crcn], [cnsctvo_vgnca_cdgo_cmpo_cnslta]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbCamposConsultas_Vigencias]([usro_crcn], [cnsctvo_vgnca_cdgo_cmpo_cnslta]);


GO
CREATE STATISTICS [obsrvcns]
    ON [dbo].[tbCamposConsultas_Vigencias]([obsrvcns], [cnsctvo_vgnca_cdgo_cmpo_cnslta]);


GO
CREATE STATISTICS [vsble_usro]
    ON [dbo].[tbCamposConsultas_Vigencias]([vsble_usro], [cnsctvo_vgnca_cdgo_cmpo_cnslta]);


GO
CREATE STATISTICS [nmbre_sp_prmtro]
    ON [dbo].[tbCamposConsultas_Vigencias]([nmbre_sp_prmtro], [cnsctvo_vgnca_cdgo_cmpo_cnslta]);


GO
CREATE STATISTICS [prmtrs_sp]
    ON [dbo].[tbCamposConsultas_Vigencias]([prmtrs_sp], [cnsctvo_vgnca_cdgo_cmpo_cnslta]);


GO
CREATE STATISTICS [clse_lgca]
    ON [dbo].[tbCamposConsultas_Vigencias]([clse_lgca], [cnsctvo_vgnca_cdgo_cmpo_cnslta]);


GO
CREATE STATISTICS [tpo_dts]
    ON [dbo].[tbCamposConsultas_Vigencias]([tpo_dts], [cnsctvo_vgnca_cdgo_cmpo_cnslta]);


GO
CREATE STATISTICS [lngtd_cmpo]
    ON [dbo].[tbCamposConsultas_Vigencias]([lngtd_cmpo], [cnsctvo_vgnca_cdgo_cmpo_cnslta]);


GO
CREATE STATISTICS [nmbre_cmpo_cdgo]
    ON [dbo].[tbCamposConsultas_Vigencias]([nmbre_cmpo_cdgo], [cnsctvo_vgnca_cdgo_cmpo_cnslta]);


GO
CREATE STATISTICS [nmbre_cmpo_cnsctvo]
    ON [dbo].[tbCamposConsultas_Vigencias]([nmbre_cmpo_cnsctvo], [cnsctvo_vgnca_cdgo_cmpo_cnslta]);


GO
CREATE STATISTICS [nmbre_cmpo_dscrpcn]
    ON [dbo].[tbCamposConsultas_Vigencias]([nmbre_cmpo_dscrpcn], [cnsctvo_vgnca_cdgo_cmpo_cnslta]);


GO
CREATE STATISTICS [nmro_crctrs_dscrpcn]
    ON [dbo].[tbCamposConsultas_Vigencias]([nmro_crctrs_dscrpcn], [cnsctvo_vgnca_cdgo_cmpo_cnslta]);


GO
CREATE STATISTICS [nmbrs_clmns_grd]
    ON [dbo].[tbCamposConsultas_Vigencias]([nmbrs_clmns_grd], [cnsctvo_vgnca_cdgo_cmpo_cnslta]);


GO
CREATE STATISTICS [dscrpcn_bsqda]
    ON [dbo].[tbCamposConsultas_Vigencias]([dscrpcn_bsqda], [cnsctvo_vgnca_cdgo_cmpo_cnslta]);


GO
CREATE STATISTICS [tpo_aplccn]
    ON [dbo].[tbCamposConsultas_Vigencias]([tpo_aplccn], [cnsctvo_vgnca_cdgo_cmpo_cnslta]);


GO
CREATE STATISTICS [nmbre_cmpo_prncpl]
    ON [dbo].[tbCamposConsultas_Vigencias]([nmbre_cmpo_prncpl], [cnsctvo_vgnca_cdgo_cmpo_cnslta]);


GO
CREATE STATISTICS [envr_cmo_prmtro]
    ON [dbo].[tbCamposConsultas_Vigencias]([envr_cmo_prmtro], [cnsctvo_vgnca_cdgo_cmpo_cnslta]);


GO
CREATE STATISTICS [ordn_prmtro_adcnl]
    ON [dbo].[tbCamposConsultas_Vigencias]([ordn_prmtro_adcnl], [cnsctvo_vgnca_cdgo_cmpo_cnslta]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbCamposConsultas_Vigencias]([tme_stmp]);

