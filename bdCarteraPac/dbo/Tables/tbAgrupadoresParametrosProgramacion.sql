CREATE TABLE [dbo].[tbAgrupadoresParametrosProgramacion] (
    [cnsctvo_cdgo_agrpdr_prmtro_prgrmcn] [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_agrpdr_prmtro_prgrmcn]         [dbo].[udtCodigo]      NOT NULL,
    [dscrpcn_agrpdr_prmtro_prgrmcn]      [dbo].[udtDescripcion] NOT NULL,
    [brrdo]                              [dbo].[udtLogico]      NOT NULL,
    [inco_vgnca]                         DATETIME               NOT NULL,
    [fn_vgnca]                           DATETIME               NOT NULL,
    [fcha_Crcn]                          DATETIME               NOT NULL,
    [usro_crcn]                          [dbo].[udtUsuario]     NOT NULL,
    [obsrvcns]                           [dbo].[udtObservacion] NOT NULL,
    [vsble_usro]                         [dbo].[udtLogico]      NOT NULL,
    [tme_stmp]                           ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbAgrupadoresParametrosProgramacion] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_agrpdr_prmtro_prgrmcn] ASC)
);


GO
CREATE STATISTICS [dscrpcn_agrpdr_prmtro_prgrmcn]
    ON [dbo].[tbAgrupadoresParametrosProgramacion]([dscrpcn_agrpdr_prmtro_prgrmcn]);


GO
CREATE STATISTICS [fcha_Crcn]
    ON [dbo].[tbAgrupadoresParametrosProgramacion]([fcha_Crcn]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbAgrupadoresParametrosProgramacion]([usro_crcn]);


GO
CREATE STATISTICS [obsrvcns]
    ON [dbo].[tbAgrupadoresParametrosProgramacion]([obsrvcns]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbAgrupadoresParametrosProgramacion]([tme_stmp]);


GO

/*---------------------------------------------------------------------------------
* Nombre                 	: TrReferencia_tbAgrupadoresParametrosProgramacion
* Desarrollado por	: <\A Ing. Jorge Meneses  A\>
* Descripcion	 	: <\D Garantiza integridad referencial con una tabla en otra base de Datos  D\>
* Observaciones     	: <\O  O\>
* Parametros		: <\P   P\>
* Variables		: <\V   V\>
* Fecha Creacion	: <\FC 2002/07/01 FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------
* Modificado Por	     	: <\AM  AM\>
* Descripcion		: <\DM  DM\>
* Nuevos Parametros	: <\PM  PM\>
* Nuevas Variables	: <\VM  VM\>
* Fecha Modificacion	: <\FM  FM\>
-----------------------------------------------------------------------------------*/
CREATE TRIGGER  [dbo].[TrReferencia_tbAgrupadoresParametrosProgramacion_usro_crcn]    ON    [dbo].[tbAgrupadoresParametrosProgramacion]
FOR  INSERT,UPDATE
AS
Begin

Declare 	@lcmnsje	varchar(400)

Set Nocount On

If Not Exists (Select p.lgn_usro 
		From [bdSeguridad].[dbo].[tbUsuarios] p, Inserted i
		Where p.lgn_usro = i.usro_crcn)
	Begin
		Rollback Transaction
		Select @lcmnsje  =  'Error:,  Violación de Integridad Referencial con bdSeguridad.tbUsuarios.usro_crcn'
		RAISERROR(999902, 16, 1,  @lcmnsje)
		Return
	End
End

