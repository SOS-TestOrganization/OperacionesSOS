CREATE TABLE [dbo].[tbTiposContactosEmpresariales] (
    [cnsctvo_cdgo_tpo_cncto_emprsrl] [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_tpo_cncto_emprsrl]         [dbo].[udtCodigo]      NOT NULL,
    [dscrpcn_tpo_cncto_emprsrl]      [dbo].[udtDescripcion] NOT NULL,
    [fcha_crcn]                      DATETIME               NOT NULL,
    [usro_crcn]                      [dbo].[udtUsuario]     NOT NULL,
    [vsble_usro]                     [dbo].[udtLogico]      NOT NULL,
    CONSTRAINT [PK_tbTiposContactosEmpresariales] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_tpo_cncto_emprsrl] ASC)
);


GO
CREATE STATISTICS [cdgo_tpo_cncto_emprsrl]
    ON [dbo].[tbTiposContactosEmpresariales]([cdgo_tpo_cncto_emprsrl]);


GO
CREATE STATISTICS [dscrpcn_tpo_cncto_emprsrl]
    ON [dbo].[tbTiposContactosEmpresariales]([dscrpcn_tpo_cncto_emprsrl]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbTiposContactosEmpresariales]([fcha_crcn]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbTiposContactosEmpresariales]([usro_crcn]);


GO
CREATE STATISTICS [vsble_usro]
    ON [dbo].[tbTiposContactosEmpresariales]([vsble_usro]);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposContactosEmpresariales] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTiposContactosEmpresariales] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTiposContactosEmpresariales] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposContactosEmpresariales] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTiposContactosEmpresariales] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTiposContactosEmpresariales] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposContactosEmpresariales] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTiposContactosEmpresariales] TO [Autorizadora Notificacion]
    AS [dbo];

