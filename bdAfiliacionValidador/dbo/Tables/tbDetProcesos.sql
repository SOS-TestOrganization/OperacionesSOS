CREATE TABLE [dbo].[tbDetProcesos] (
    [cnsctvo_dtlle_prcso]     [dbo].[udtConsecutivo]      NOT NULL,
    [cnsctvo_prcso]           [dbo].[udtConsecutivo]      NOT NULL,
    [cnsctvo_cdgo_tpo_frmlro] [dbo].[udtConsecutivo]      NOT NULL,
    [nmro_frmlro]             [dbo].[udtNumeroFormulario] NOT NULL,
    CONSTRAINT [PK_TbDetProcesos] PRIMARY KEY CLUSTERED ([cnsctvo_dtlle_prcso] ASC) WITH (FILLFACTOR = 95)
);


GO
CREATE STATISTICS [cnsctvo_prcso]
    ON [dbo].[tbDetProcesos]([cnsctvo_prcso], [cnsctvo_dtlle_prcso]);


GO
CREATE STATISTICS [cnsctvo_cdgo_tpo_frmlro]
    ON [dbo].[tbDetProcesos]([cnsctvo_cdgo_tpo_frmlro], [cnsctvo_dtlle_prcso]);


GO
CREATE STATISTICS [nmro_frmlro]
    ON [dbo].[tbDetProcesos]([nmro_frmlro], [cnsctvo_dtlle_prcso]);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetProcesos] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetProcesos] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetProcesos] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbDetProcesos] TO [Consulta]
    AS [dbo];

