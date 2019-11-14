CREATE TABLE [dbo].[tbEmpresasExcluidaMarcaExtemporaneidad] (
    [cnsctvo_emprsa_exclda]   [dbo].[udtConsecutivo] IDENTITY (1, 1) NOT NULL,
    [nmro_unco_emprsa_exclda] [dbo].[udtConsecutivo] NOT NULL,
    [inco_vgnca]              DATETIME               NOT NULL,
    [fn_vgnca]                DATETIME               NOT NULL,
    [usro_exclsn]             [dbo].[udtUsuario]     NOT NULL,
    [fcha_exclsn]             DATETIME               NOT NULL,
    [obsrvcns]                [dbo].[udtObservacion] NULL,
    [tme_stmp]                ROWVERSION             NULL,
    CONSTRAINT [PK_tbEmpresasExcluidaMarcaExtemporaneidad] PRIMARY KEY CLUSTERED ([cnsctvo_emprsa_exclda] ASC) WITH (FILLFACTOR = 90)
);

