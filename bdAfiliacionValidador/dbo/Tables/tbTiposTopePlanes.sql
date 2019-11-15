CREATE TABLE [dbo].[tbTiposTopePlanes] (
    [cnsctvo_cdgo_tpo_tpe_pln] INT           NOT NULL,
    [cdgo_tpo_tpe_pln]         CHAR (2)      NOT NULL,
    [dscrpcn_tpo_tpe_pln]      VARCHAR (150) NOT NULL,
    [fcha_crcn]                DATETIME      NOT NULL,
    [usro_crcn]                CHAR (30)     NOT NULL,
    [vsble_usro]               CHAR (1)      NOT NULL,
    CONSTRAINT [PK_TbTiposTopePlanes] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_tpo_tpe_pln] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_cdgo_tpo_tpe_pln]
    ON [dbo].[tbTiposTopePlanes]([cdgo_tpo_tpe_pln] ASC);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposTopePlanes] TO [Analistas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTiposTopePlanes] TO [300004 Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposTopePlanes] TO [300004 Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTiposTopePlanes] TO [300004 Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTiposTopePlanes] TO [300001 Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposTopePlanes] TO [300001 Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTiposTopePlanes] TO [300001 Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTiposTopePlanes] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposTopePlanes] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTiposTopePlanes] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposTopePlanes] TO [Inteligencia]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTiposTopePlanes] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposTopePlanes] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTiposTopePlanes] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposTopePlanes] TO [Consulta]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTiposTopePlanes] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposTopePlanes] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTiposTopePlanes] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];

