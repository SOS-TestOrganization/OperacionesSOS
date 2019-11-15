CREATE TABLE [dbo].[tbTiposContactosEmpresariales_Vigencias] (
    [cnsctvo_vgnca_tpo_cncto_emprsrl] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_tpo_cncto_emprsrl]  [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_tpo_cncto_emprsrl]          [dbo].[udtCodigo]      NOT NULL,
    [dscrpcn_tpo_cncto_emprsrl]       [dbo].[udtDescripcion] NOT NULL,
    [inco_vgnca]                      DATETIME               NOT NULL,
    [fn_vgnca]                        DATETIME               NOT NULL,
    [fcha_crcn]                       DATETIME               NOT NULL,
    [usro_crcn]                       [dbo].[udtUsuario]     NOT NULL,
    [vsble_usro]                      [dbo].[udtLogico]      NOT NULL,
    [time_stmp]                       ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbTiposContactosEmpresariales_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_tpo_cncto_emprsrl] ASC)
);


GO
CREATE STATISTICS [cnsctvo_cdgo_tpo_cncto_emprsrl]
    ON [dbo].[tbTiposContactosEmpresariales_Vigencias]([cnsctvo_cdgo_tpo_cncto_emprsrl]);


GO
CREATE STATISTICS [cdgo_tpo_cncto_emprsrl]
    ON [dbo].[tbTiposContactosEmpresariales_Vigencias]([cdgo_tpo_cncto_emprsrl]);


GO
CREATE STATISTICS [dscrpcn_tpo_cncto_emprsrl]
    ON [dbo].[tbTiposContactosEmpresariales_Vigencias]([dscrpcn_tpo_cncto_emprsrl]);


GO
CREATE STATISTICS [inco_vgnca]
    ON [dbo].[tbTiposContactosEmpresariales_Vigencias]([inco_vgnca]);


GO
CREATE STATISTICS [fn_vgnca]
    ON [dbo].[tbTiposContactosEmpresariales_Vigencias]([fn_vgnca]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbTiposContactosEmpresariales_Vigencias]([fcha_crcn]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbTiposContactosEmpresariales_Vigencias]([usro_crcn]);


GO
CREATE STATISTICS [vsble_usro]
    ON [dbo].[tbTiposContactosEmpresariales_Vigencias]([vsble_usro]);


GO
CREATE STATISTICS [time_stmp]
    ON [dbo].[tbTiposContactosEmpresariales_Vigencias]([time_stmp]);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposContactosEmpresariales_Vigencias] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTiposContactosEmpresariales_Vigencias] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTiposContactosEmpresariales_Vigencias] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposContactosEmpresariales_Vigencias] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTiposContactosEmpresariales_Vigencias] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbTiposContactosEmpresariales_Vigencias] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbTiposContactosEmpresariales_Vigencias] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbTiposContactosEmpresariales_Vigencias] TO [Autorizadora Notificacion]
    AS [dbo];

