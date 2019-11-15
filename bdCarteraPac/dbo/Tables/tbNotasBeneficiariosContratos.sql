CREATE TABLE [dbo].[tbNotasBeneficiariosContratos] (
    [cnsctvo_nta_bnfcro_cntrto] INT                    IDENTITY (1, 1) NOT NULL,
    [cnsctvo_nta_cncpto]        INT                    NULL,
    [cnsctvo_nta_cntrto]        INT                    NULL,
    [nmro_unco_idntfccn_bnfcro] INT                    NULL,
    [vlr_nta_bnfcro]            NUMERIC (12)           NULL,
    [vlr_iva]                   NUMERIC (12)           NULL,
    [obsrvcns]                  VARCHAR (250)          NULL,
    [fcha_crcn]                 DATETIME               NULL,
    [usro_crcn]                 CHAR (30)              NULL,
    [tme_stmp]                  ROWVERSION             NOT NULL,
    [cnsctvo_dcmnto]            [dbo].[udtConsecutivo] NULL,
    [cnsctvo_cdgo_tpo_dcmnto]   [dbo].[udtConsecutivo] NULL,
    CONSTRAINT [PK_tbNotasBeneficiariosContratos] PRIMARY KEY CLUSTERED ([cnsctvo_nta_bnfcro_cntrto] ASC),
    CONSTRAINT [FK_tbNotasBeneficiariosContratos_TbNotasContrato] FOREIGN KEY ([cnsctvo_nta_cntrto]) REFERENCES [dbo].[tbNotasContrato] ([cnsctvo_nta_cntrto])
);

