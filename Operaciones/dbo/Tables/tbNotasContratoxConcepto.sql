CREATE TABLE [dbo].[tbNotasContratoxConcepto] (
    [cnsctvo_nta_cntrto] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_nta_cncpto] [dbo].[udtConsecutivo] NOT NULL,
    [vlr]                [dbo].[udtValorGrande] NOT NULL,
    [vlr_ants_iva]       [dbo].[udtValorGrande] NULL,
    [vlr_iva]            [dbo].[udtValorGrande] NULL,
    [tme_stmp]           ROWVERSION             NOT NULL,
    CONSTRAINT [PK_TbNotasContratoxConcepto] PRIMARY KEY CLUSTERED ([cnsctvo_nta_cntrto] ASC, [cnsctvo_nta_cncpto] ASC),
    CONSTRAINT [FK_tbNotasContratoxConcepto_tbNotasConceptos] FOREIGN KEY ([cnsctvo_nta_cncpto]) REFERENCES [dbo].[tbNotasConceptos] ([Cnsctvo_nta_cncpto]),
    CONSTRAINT [FK_tbNotasContratoxConcepto_tbNotasContrato] FOREIGN KEY ([cnsctvo_nta_cntrto]) REFERENCES [dbo].[tbNotasContrato] ([cnsctvo_nta_cntrto])
);


GO
CREATE STATISTICS [cnsctvo_nta_cncpto]
    ON [dbo].[tbNotasContratoxConcepto]([cnsctvo_nta_cncpto], [cnsctvo_nta_cntrto]);


GO
CREATE STATISTICS [vlr]
    ON [dbo].[tbNotasContratoxConcepto]([vlr], [cnsctvo_nta_cntrto], [cnsctvo_nta_cncpto]);


GO
CREATE STATISTICS [vlr_ants_iva]
    ON [dbo].[tbNotasContratoxConcepto]([vlr_ants_iva], [cnsctvo_nta_cntrto], [cnsctvo_nta_cncpto]);


GO
CREATE STATISTICS [vlr_iva]
    ON [dbo].[tbNotasContratoxConcepto]([vlr_iva], [cnsctvo_nta_cntrto], [cnsctvo_nta_cncpto]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbNotasContratoxConcepto]([tme_stmp]);

