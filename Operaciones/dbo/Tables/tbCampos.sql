﻿CREATE TABLE [dbo].[tbCampos] (
    [bse_dts]             [dbo].[udtNombreObjeto] NOT NULL,
    [cdgo_cmpo]           [dbo].[udtNombreObjeto] NOT NULL,
    [tbla]                [dbo].[udtNombreObjeto] NOT NULL,
    [dscrpcn_prmtro]      [dbo].[udtDescripcion]  NULL,
    [bse_dts_prmtrs]      [dbo].[udtNombreObjeto] NULL,
    [cdgo_cmpo_prmtrs]    [dbo].[udtNombreObjeto] NULL,
    [dscrpcn_cmpo_prmtrs] [dbo].[udtNombreObjeto] NULL,
    [aplca_scrsl]         [dbo].[udtLogico]       NULL,
    [brrdo]               [dbo].[udtLogico]       NULL,
    [usro_ultma_mdfccn]   [dbo].[udtUsuario]      NULL,
    [fcha_ultma_mdfccn]   DATETIME                NULL,
    [tpo_dts]             VARCHAR (25)            NULL,
    [tbla_prmtrs]         [dbo].[udtNombreObjeto] NULL,
    [dscrpcn_cmpo]        [dbo].[udtDescripcion]  NOT NULL,
    [tpo_aplccn]          [dbo].[udtCodigo]       NOT NULL,
    [aplca_incdnca]       [dbo].[udtLogico]       NULL,
    [aplca_cnslta]        [dbo].[udtLogico]       NULL,
    [tpo_cnslta]          INT                     NULL,
    [id_clmna]            INT                     NULL,
    [lngtd_cmpo]          INT                     NULL,
    [clse_lgca]           CHAR (50)               NULL,
    [dscrpcn_bsqda]       CHAR (30)               NULL,
    [sp_bsqda]            VARCHAR (250)           NULL,
    [cmpo_cnsctvo_prmtro] [dbo].[udtNombreObjeto] NULL,
    [vsble_usro]          [dbo].[udtLogico]       NULL,
    CONSTRAINT [PK_TbCampos] PRIMARY KEY CLUSTERED ([bse_dts] ASC, [cdgo_cmpo] ASC, [tbla] ASC) WITH (FILLFACTOR = 90)
);

