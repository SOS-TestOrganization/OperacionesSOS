CREATE TABLE [dbo].[tbTiposAportante] (
    [cnsctvo_cdgo_tpo_aprtnte] INT           NOT NULL,
    [cdgo_tpo_aprtnte]         CHAR (2)      NOT NULL,
    [dscrpcn_tpo_aprtnte]      VARCHAR (150) NOT NULL,
    [fcha_crcn]                DATETIME      NOT NULL,
    [usro_crcn]                CHAR (30)     NOT NULL,
    [vsble_usro]               CHAR (1)      NOT NULL,
    CONSTRAINT [PK_TbTiposAportante] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_tpo_aprtnte] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_cdgo_tpo_aprtnte]
    ON [dbo].[tbTiposAportante]([cdgo_tpo_aprtnte] ASC);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante] TO PUBLIC
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante] TO [900011 Consultor Administrador]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante] TO [900014 Consultor Auditor]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante] TO [ServicioClientePortal]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante] TO [900001 Consultor Administrativo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante] TO [Consultor Administrativo]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante] TO [Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante] TO [Consultor Administrador]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposAportante] TO [Consultor Auditor]
    AS [dbo];

