CREATE TABLE [dbo].[tbParametrosProgramacionCarteraPac] (
    [cnsctvo_cdgo_prmtro_prgrmcn] [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_prmtro_prgrmcn]         [dbo].[udtCodigo]      NOT NULL,
    [dscrpcn_prmtro_prgrmcn]      [dbo].[udtDescripcion] NOT NULL,
    [brrdo]                       [dbo].[udtLogico]      NOT NULL,
    [inco_vgnca]                  DATETIME               NOT NULL,
    [fn_vgnca]                    DATETIME               NOT NULL,
    [fcha_Crcn]                   DATETIME               NOT NULL,
    [usro_crcn]                   [dbo].[udtUsuario]     NOT NULL,
    [obsrvcns]                    [dbo].[udtObservacion] NOT NULL,
    [vsble_usro]                  [dbo].[udtLogico]      NOT NULL,
    [tme_stmp]                    ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbParametrosProgramacionCarteraPac] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_prmtro_prgrmcn] ASC)
);


GO

/*---------------------------------------------------------------------------------
* Nombre                 	: TrReferencia_tbParametrosProgramacionCarteraPac
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
CREATE TRIGGER  [dbo].[TrReferencia_tbParametrosProgramacionCarteraPac_usro_crcn]    ON    [dbo].[tbParametrosProgramacionCarteraPac]
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

