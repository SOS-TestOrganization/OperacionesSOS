CREATE TABLE [dbo].[tbAutorizacionesNotas] (
    [cnsctvo_nta_cncpto]         [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_autrzdr_espcl] [dbo].[udtConsecutivo] NOT NULL,
    [tme_stmp]                   ROWVERSION             NOT NULL,
    CONSTRAINT [PK_TbAutorizacionesNotas] PRIMARY KEY CLUSTERED ([cnsctvo_nta_cncpto] ASC),
    CONSTRAINT [FK_tbAutorizacionesNotas_tbAutorizadoresEspeciales] FOREIGN KEY ([cnsctvo_cdgo_autrzdr_espcl]) REFERENCES [dbo].[tbAutorizadoresEspeciales] ([cnsctvo_cdgo_autrzdr_espcl])
);


GO
CREATE STATISTICS [cnsctvo_cdgo_autrzdr_espcl]
    ON [dbo].[tbAutorizacionesNotas]([cnsctvo_cdgo_autrzdr_espcl], [cnsctvo_nta_cncpto]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbAutorizacionesNotas]([tme_stmp]);

