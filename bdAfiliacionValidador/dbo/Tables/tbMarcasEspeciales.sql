CREATE TABLE [dbo].[tbMarcasEspeciales] (
    [cnsctvo_mrca_espcl] [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_mrca_espcl]    [dbo].[udtCodigo]      NOT NULL,
    [dscrpcn_mrca_espcl] [dbo].[udtDescripcion] NOT NULL,
    [fcha_crcn]          DATETIME               NOT NULL,
    [usro_crcn]          [dbo].[udtUsuario]     NOT NULL,
    [vsble_usro]         [dbo].[udtLogico]      NOT NULL,
    CONSTRAINT [PK_TbMarcasEspeciales] PRIMARY KEY CLUSTERED ([cnsctvo_mrca_espcl] ASC)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbMarcasEspeciales] TO [autsalud_rol]
    AS [dbo];

