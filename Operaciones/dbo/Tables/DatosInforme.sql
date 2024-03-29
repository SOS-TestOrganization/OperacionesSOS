﻿CREATE TABLE [dbo].[DatosInforme] (
    [cnsctvo_cdgo_pgo]             INT                    NULL,
    [dscrpcn_estdo_pgo]            VARCHAR (30)           NULL,
    [dscrpcn_tpo_pgo]              VARCHAR (30)           NULL,
    [vlr_dcmnto]                   NUMERIC (12)           NULL,
    [cdgo_tpo_idntfccn]            VARCHAR (3)            NULL,
    [nmro_idntfccn]                VARCHAR (15)           NULL,
    [dscrpcn_clse_aprtnte]         VARCHAR (200)          NULL,
    [nmbre_scrsl]                  VARCHAR (200)          NULL,
    [rzn_scl]                      VARCHAR (200)          NULL,
    [fcha_rcdo]                    CHAR (10)              NULL,
    [fcha_intrfce]                 CHAR (10)              NULL,
    [fcha_aplccn]                  CHAR (10)              NULL,
    [nmro_rmsa]                    INT                    NULL,
    [nmro_lna]                     INT                    NULL,
    [nmro_dcmnto]                  CHAR (15)              NULL,
    [usro_crcn]                    CHAR (30)              NULL,
    [cnsctvo_cdgo_estdo_pgo]       INT                    NULL,
    [cnsctvo_cdgo_tpo_pgo]         INT                    NULL,
    [nmro_unco_idntfccn_empldr]    INT                    NULL,
    [cnsctvo_scrsl]                INT                    NULL,
    [cnsctvo_cdgo_clse_aprtnte]    INT                    NULL,
    [dgto_vrfccn]                  INT                    NULL,
    [sldo_pgo]                     NUMERIC (12)           NULL,
    [dscrpcn_sde_crtra]            VARCHAR (200)          NULL,
    [Dscrpcn_tpo_dcmnto]           [dbo].[udtDescripcion] NOT NULL,
    [nmro_dcmnto_crce]             VARCHAR (15)           NOT NULL,
    [vlr_aplcdo]                   NUMERIC (12)           NOT NULL,
    [cnsctvo_cdgo_tpo_dcmnto]      [dbo].[udtConsecutivo] NOT NULL,
    [Consecutivo_documento_origen] INT                    NULL,
    [estado_documento]             [dbo].[udtConsecutivo] NOT NULL,
    [ttl_fctrdo]                   NUMERIC (12)           NOT NULL,
    [vlr_iva]                      NUMERIC (12)           NOT NULL,
    [vlr_dcmnto_dbto]              NUMERIC (13)           NULL,
    [sldo_dcmnto_dbto]             NUMERIC (12)           NOT NULL,
    [fcha_dcmnto]                  DATE                   NULL
);

