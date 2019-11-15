CREATE TABLE [dbo].[tbContactosEmpresariales] (
    [cnsctvo_cntcto_emprsrl]         [dbo].[udtConsecutivo]               NOT NULL,
    [nmro_unco_idntfccn_empldr]      [dbo].[udtConsecutivo]               NOT NULL,
    [cnsctvo_scrsl]                  [dbo].[udtConsecutivo]               NOT NULL,
    [cnsctvo_cdgo_clse_aprtnte]      [dbo].[udtConsecutivo]               NOT NULL,
    [cnsctvo_cdgo_tpo_cncto_emprsrl] [dbo].[udtConsecutivo]               NOT NULL,
    [cnsctvo_cdgo_tpo_idntfccn]      [dbo].[udtConsecutivo]               NOT NULL,
    [nmro_idntfccn]                  [dbo].[udtNumeroIdentificacionLargo] NOT NULL,
    [prmr_aplldo]                    [dbo].[udtApellido]                  NOT NULL,
    [sgndo_aplldo]                   [dbo].[udtApellido]                  NOT NULL,
    [prmr_nmbre]                     [dbo].[udtNombre]                    NOT NULL,
    [sgndo_nmbre]                    [dbo].[udtNombre]                    NOT NULL,
    [tlfno]                          [dbo].[udtTelefono]                  NOT NULL,
    [extnsn]                         [dbo].[udtTelefono]                  NOT NULL,
    [eml]                            [dbo].[udtEmail]                     NOT NULL,
    [cnsctvo_cdgo_cncpto_nvdd]       [dbo].[udtConsecutivo]               NOT NULL,
    [inco_vgnca]                     DATETIME                             NOT NULL,
    [fn_vgnca]                       DATETIME                             NOT NULL,
    [fcha_ultma_mdfccn]              DATETIME                             NOT NULL,
    [usro_crcn]                      [dbo].[udtUsuario]                   NOT NULL,
    [tme_stmp]                       ROWVERSION                           NOT NULL,
    CONSTRAINT [PK_tbContactosEmpresariales] PRIMARY KEY CLUSTERED ([cnsctvo_cntcto_emprsrl] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_vigencias]
    ON [dbo].[tbContactosEmpresariales]([inco_vgnca] ASC, [fn_vgnca] ASC, [cnsctvo_cdgo_tpo_cncto_emprsrl] ASC)
    INCLUDE([nmro_unco_idntfccn_empldr], [cnsctvo_scrsl], [cnsctvo_cdgo_clse_aprtnte], [prmr_aplldo], [sgndo_aplldo], [prmr_nmbre], [sgndo_nmbre], [tlfno], [eml])
    ON [FG_INDEXES];


GO
CREATE STATISTICS [cnsctvo_cdgo_tpo_idntfccn]
    ON [dbo].[tbContactosEmpresariales]([cnsctvo_cdgo_tpo_idntfccn]);


GO
CREATE STATISTICS [nmro_idntfccn]
    ON [dbo].[tbContactosEmpresariales]([nmro_idntfccn]);


GO
CREATE STATISTICS [prmr_aplldo]
    ON [dbo].[tbContactosEmpresariales]([prmr_aplldo]);


GO
CREATE STATISTICS [sgndo_aplldo]
    ON [dbo].[tbContactosEmpresariales]([sgndo_aplldo]);


GO
CREATE STATISTICS [prmr_nmbre]
    ON [dbo].[tbContactosEmpresariales]([prmr_nmbre]);


GO
CREATE STATISTICS [sgndo_nmbre]
    ON [dbo].[tbContactosEmpresariales]([sgndo_nmbre]);


GO
CREATE STATISTICS [tlfno]
    ON [dbo].[tbContactosEmpresariales]([tlfno]);


GO
CREATE STATISTICS [extnsn]
    ON [dbo].[tbContactosEmpresariales]([extnsn]);


GO
CREATE STATISTICS [eml]
    ON [dbo].[tbContactosEmpresariales]([eml]);


GO
CREATE STATISTICS [cnsctvo_cdgo_cncpto_nvdd]
    ON [dbo].[tbContactosEmpresariales]([cnsctvo_cdgo_cncpto_nvdd]);


GO
CREATE STATISTICS [fcha_ultma_mdfccn]
    ON [dbo].[tbContactosEmpresariales]([fcha_ultma_mdfccn]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbContactosEmpresariales]([usro_crcn]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbContactosEmpresariales]([tme_stmp]);


GO
DENY DELETE
    ON OBJECT::[dbo].[tbContactosEmpresariales] TO PUBLIC
    AS [dbo];


GO
DENY INSERT
    ON OBJECT::[dbo].[tbContactosEmpresariales] TO PUBLIC
    AS [dbo];


GO
DENY SELECT
    ON OBJECT::[dbo].[tbContactosEmpresariales] TO PUBLIC
    AS [dbo];


GO
DENY UPDATE
    ON OBJECT::[dbo].[tbContactosEmpresariales] TO PUBLIC
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbContactosEmpresariales] TO [Analistas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbContactosEmpresariales] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbContactosEmpresariales] TO [aut_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbContactosEmpresariales] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbContactosEmpresariales] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbContactosEmpresariales] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbContactosEmpresariales] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbContactosEmpresariales] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbContactosEmpresariales] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbContactosEmpresariales] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbContactosEmpresariales] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbContactosEmpresariales] TO [Autorizadora Notificacion]
    AS [dbo];

