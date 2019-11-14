CREATE TABLE [dbo].[tbNotasCreditoContratosxNotasDebito] (
    [cnsctvo_nta_cntrto_cdto] INT                    NOT NULL,
    [cnsctvo_nta_cntrto_dbto] INT                    NOT NULL,
    [vlr_aplcdo]              [dbo].[udtValorGrande] NULL,
    [tme_stmp]                ROWVERSION             NULL,
    CONSTRAINT [Pk_tbNotasCreditoContratosxNotasDebito] PRIMARY KEY CLUSTERED ([cnsctvo_nta_cntrto_cdto] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE STATISTICS [vlr_aplcdo]
    ON [dbo].[tbNotasCreditoContratosxNotasDebito]([vlr_aplcdo]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbNotasCreditoContratosxNotasDebito]([tme_stmp]);

