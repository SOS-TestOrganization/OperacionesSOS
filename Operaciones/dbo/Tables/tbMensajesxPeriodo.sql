CREATE TABLE [dbo].[tbMensajesxPeriodo] (
    [cnsctvo_mnsje_prdo]      [dbo].[udtConsecutivo] NOT NULL,
    [fcha_crcn]               DATETIME               NOT NULL,
    [usro_crcn]               [dbo].[udtUsuario]     NOT NULL,
    [cnsctvo_cdgo_prdo_lqdcn] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_mnsje]      [dbo].[udtConsecutivo] NOT NULL,
    CONSTRAINT [PK_TbMensajesxPeriodo_1] PRIMARY KEY CLUSTERED ([cnsctvo_mnsje_prdo] ASC),
    CONSTRAINT [FK_tbMensajesxPeriodo_tbMensajes] FOREIGN KEY ([cnsctvo_cdgo_mnsje]) REFERENCES [dbo].[tbMensajes] ([cnsctvo_cdgo_mnsje])
);


GO
/*--------------------------------------------------------------------------------------------------------
* Nombre                 	:	TrReferencia_Usuario_tbMensajesxPeriodo
* Desarrollado por	: <\A	Ing. Jorge Meneses			  A\>
* Descripcion	 	: <\D	Garantiza integridad referencial con una tabla en otra base de Datos D\>
* Observaciones     	: <\O	O\>
* Parametros		: <\P	P\>
* Variables		: <\V	V\>
* Fecha Creacion	: <\FC 2002/07/01	FC\>
*--------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*--------------------------------------------------------------------------------------------------------
* Modificado Por	   	: <\AM Ing. Maribel Valencia Herrera		AM\>
* Descripcion		: <\DM El mensaje no corresponde a la validacion del trigger y es muy técnico para el usuario  DM\>
			  <\DM Error, Violación de Integridad Referencial con bdSeguridad.tbUsuarios.usro_crcn	 DM\>
			  <\DM el trigger valida que el usuario se encuentrecreado  en  bdSeguridad.tbUsuarios.usro_crcn	 DM\>			 DM\>
* Nuevos Parametros	: <\PM		PM\>
* Nuevas Variables	: <\VM		VM\>
* Fecha Modificacion	: <\FM		FM\>
*------------------------------------------------------------------------------------------------------*/
CREATE TRIGGER  [dbo].[TrReferencia_Usuario_tbMensajesxPeriodo] ON    [dbo].[tbMensajesxPeriodo] 
FOR  INSERT,UPDATE
AS
Begin
	Declare 	@lcmnsje	varchar(400),
			@lcusro		varchar(10)
	Set Nocount On
	
	If Not Exists (	Select	 p.lgn_usro From	[bdSeguridad].[dbo].[tbUsuarios] p, Inserted i
			Where	p.lgn_usro = i.usro_crcn)
	Begin
		Select	@lcusro=  i.usro_crcn From	 Inserted i
		Rollback Transaction
		Select 	@lcmnsje  =  'Error, El Usuario '+  @lcusro+' no se encuentra creado en  bdSeguridad..tbUsuarios.usro_crcn'
		RAISERROR(999902, 16, 1,  @lcmnsje)
		Return
	End
End

