CREATE TABLE [dbo].[tbNotasContratoReintegro] (
    [cnsctvo_nta_cntrto]        [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_nta_cncpto]        [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_nta_cntrto_rntgro] [dbo].[udtConsecutivo] NOT NULL,
    [vlr_rntgro]                [dbo].[udtValorGrande] NOT NULL,
    [tme_stmp]                  ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbNotasContratoReintegro] PRIMARY KEY CLUSTERED ([cnsctvo_nta_cntrto] ASC, [cnsctvo_nta_cncpto] ASC, [cnsctvo_nta_cntrto_rntgro] ASC),
    CONSTRAINT [FK_tbNotasContratoReintegro_tbNotasContrato] FOREIGN KEY ([cnsctvo_nta_cntrto_rntgro]) REFERENCES [dbo].[tbNotasContrato] ([cnsctvo_nta_cntrto]),
    CONSTRAINT [FK_tbNotasContratoReintegro_tbNotasContratoxConcepto] FOREIGN KEY ([cnsctvo_nta_cntrto], [cnsctvo_nta_cncpto]) REFERENCES [dbo].[tbNotasContratoxConcepto] ([cnsctvo_nta_cntrto], [cnsctvo_nta_cncpto])
);


GO
CREATE STATISTICS [cnsctvo_nta_cncpto]
    ON [dbo].[tbNotasContratoReintegro]([cnsctvo_nta_cncpto], [cnsctvo_nta_cntrto], [cnsctvo_nta_cntrto_rntgro]);


GO
CREATE STATISTICS [cnsctvo_nta_cntrto_rntgro]
    ON [dbo].[tbNotasContratoReintegro]([cnsctvo_nta_cntrto_rntgro], [cnsctvo_nta_cntrto], [cnsctvo_nta_cncpto]);


GO
CREATE STATISTICS [vlr_rntgro]
    ON [dbo].[tbNotasContratoReintegro]([vlr_rntgro], [cnsctvo_nta_cntrto], [cnsctvo_nta_cncpto], [cnsctvo_nta_cntrto_rntgro]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbNotasContratoReintegro]([tme_stmp]);

