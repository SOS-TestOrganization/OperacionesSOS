CREATE TABLE [dbo].[tbPromotoresSedes] (
    [cnsctvo_cdgo_prmtr] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_sde]   [dbo].[udtConsecutivo] NOT NULL,
    [ultmo_digto]        INT                    NOT NULL,
    [brrdo]              [dbo].[udtLogico]      NOT NULL,
    [fcha_crcn]          DATETIME               NOT NULL,
    [usro_crcn]          [dbo].[udtUsuario]     NOT NULL,
    [fcha_ultma_mdfccn]  DATETIME               NOT NULL,
    [usro_ultma_mdfccn]  [dbo].[udtUsuario]     NOT NULL,
    [tme_stmp]           ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbPromotoresSedes] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_prmtr] ASC, [cnsctvo_cdgo_sde] ASC, [ultmo_digto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tbPromotoresSedes_tbPromotores] FOREIGN KEY ([cnsctvo_cdgo_prmtr]) REFERENCES [dbo].[tbPromotores] ([cnsctvo_cdgo_prmtr])
);


GO

/*---------------------------------------------------------------------------------
* Nombre                 	: TrReferencia_tbPromotoresSedes
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
CREATE TRIGGER  [dbo].[TrReferencia_tbPromotoresSedes_usro_crcn]    ON    [dbo].[tbPromotoresSedes]
FOR  INSERT,UPDATE
AS
Begin

Declare 	@lcmnsje	varchar(400)

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








GO
/*---------------------------------------------------------------------------------
* Nombre                 : 
* Desarrollado por	 : <\A Ing. Jorge Meneses  A\>
* Descripcion		 : <\D Garantiza integridad referencial con una tebla en otra base de Datos  D\>
* Observaciones          : <\O  O\>
* Parametros		 : <\P   P\>
* Variables		 : <\V   V\>
* Fecha Creacion	 : <\FC 2002/07/01 FC\>
* Modificado		:  Ing. Javier Paez
*---------------------------------------------------------------------------------*/
CREATE TRIGGER  [dbo].[TrReferencia_tbPromotoresSedes_cnsctvo_cdgo_sde]    ON [dbo].[tbPromotoresSedes]
FOR  INSERT,UPDATE


AS
Begin
	Declare 	@lcmnsje	varchar(400)
	Set Nocount On
	If Exists(Select 1 From Inserted)
	Begin
		If Not Exists (Select p.cnsctvo_cdgo_sde
				From [bdAfiliacion].[dbo].[tbSedes] p, Inserted i
				Where p.cnsctvo_cdgo_sde  = i.cnsctvo_cdgo_sde )
		Begin
			ROLLBACK TRANSACTION
			select @lcmnsje  = 'Error:,  Violación de Integridad Referencial con bdAfiliacion..tbSedes'
			RAISERROR(999902, 16, 1,  @lcmnsje)
			RETURN
		End
	End
End

