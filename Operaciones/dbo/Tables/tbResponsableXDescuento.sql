CREATE TABLE [dbo].[tbResponsableXDescuento] (
    [cnsctvo_cdgo_rspnsble_dscnto] [dbo].[udtConsecutivo] NOT NULL,
    [fcha_crcn]                    DATETIME               NOT NULL,
    [usro_crcn]                    [dbo].[udtUsuario]     NOT NULL,
    [cnsctvo_cdgo_dscnto]          [dbo].[udtConsecutivo] NOT NULL,
    [nmro_unco_idntfccn]           INT                    NOT NULL,
    [cnsctvo_scrsl]                INT                    NOT NULL,
    [cnsctvo_cdgo_clse_aprtnte]    [dbo].[udtConsecutivo] NOT NULL,
    CONSTRAINT [PK_TbResponsableXDescuento_1] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_rspnsble_dscnto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tbResponsableXDescuento_tbDescuentos] FOREIGN KEY ([cnsctvo_cdgo_dscnto]) REFERENCES [dbo].[tbDescuentos] ([cnsctvo_cdgo_dscnto])
);


GO
/*--------------------------------------------------------------------------------------------------------
* Nombre                 	:	TrReferencia_Usuario_tbResponsableXDescuento
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
CREATE TRIGGER  [dbo].[TrReferencia_Usuario_tbResponsableXDescuento] ON    [dbo].[tbResponsableXDescuento] 
FOR  INSERT,UPDATE
AS
Begin
	Declare 	@lcmnsje	varchar(400),
			@lcusro		varchar(10)

	



Set Nocount On

If exists(select 1 from  Inserted Where usro_crcn  is not null)
	begin
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
	End

