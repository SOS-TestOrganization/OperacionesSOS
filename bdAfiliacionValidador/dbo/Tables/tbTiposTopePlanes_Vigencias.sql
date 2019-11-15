CREATE TABLE [dbo].[tbTiposTopePlanes_Vigencias] (
    [cnsctvo_vgnca_tpo_tpe_pln] INT           NOT NULL,
    [cnsctvo_cdgo_tpo_tpe_pln]  INT           NOT NULL,
    [cdgo_tpo_tpe_pln]          CHAR (2)      NOT NULL,
    [dscrpcn_tpo_tpe_pln]       VARCHAR (150) NOT NULL,
    [inco_vgnca]                DATETIME      NOT NULL,
    [fn_vgnca]                  DATETIME      NOT NULL,
    [fcha_crcn]                 DATETIME      NOT NULL,
    [usro_crcn]                 CHAR (30)     NOT NULL,
    [obsrvcns]                  VARCHAR (250) NULL,
    [vsble_usro]                CHAR (1)      NOT NULL,
    [tme_stmp]                  BINARY (8)    NOT NULL,
    CONSTRAINT [PK_TbTiposTopePlanes_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_tpo_tpe_pln] ASC),
    CONSTRAINT [FK_tbTiposTopePlanes_Vigencias_tbTiposTopePlanes] FOREIGN KEY ([cnsctvo_cdgo_tpo_tpe_pln]) REFERENCES [dbo].[tbTiposTopePlanes] ([cnsctvo_cdgo_tpo_tpe_pln]) ON DELETE CASCADE
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposTopePlanes_Vigencias] TO [Analistas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTiposTopePlanes_Vigencias] TO [300004 Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposTopePlanes_Vigencias] TO [300004 Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTiposTopePlanes_Vigencias] TO [300004 Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTiposTopePlanes_Vigencias] TO [300001 Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposTopePlanes_Vigencias] TO [300001 Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTiposTopePlanes_Vigencias] TO [300001 Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTiposTopePlanes_Vigencias] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposTopePlanes_Vigencias] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTiposTopePlanes_Vigencias] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposTopePlanes_Vigencias] TO [Inteligencia]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTiposTopePlanes_Vigencias] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposTopePlanes_Vigencias] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTiposTopePlanes_Vigencias] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposTopePlanes_Vigencias] TO [Consulta]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTiposTopePlanes_Vigencias] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposTopePlanes_Vigencias] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTiposTopePlanes_Vigencias] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];

