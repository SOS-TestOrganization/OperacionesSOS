CREATE TABLE [dbo].[tbCuentasManualesContrato] (
    [cnsctvo_cnta_mnls_cntrto] [dbo].[udtConsecutivo]      NOT NULL,
    [nmro_estdo_cnta]          VARCHAR (15)                NOT NULL,
    [cnsctvo_cdgo_tpo_cntrto]  [dbo].[udtConsecutivo]      NOT NULL,
    [nmro_cntrto]              [dbo].[udtNumeroFormulario] NOT NULL,
    [vlr_cbrdo]                [dbo].[udtValorGrande]      NOT NULL,
    [sldo]                     [dbo].[udtValorGrande]      NOT NULL,
    [cntdd_bnfcrs]             [dbo].[udtValorPequeno]     NOT NULL,
    [cnsctvo_cdgo_pln]         [dbo].[udtConsecutivo]      NOT NULL,
    [usro_crcn]                [dbo].[udtUsuario]          NOT NULL,
    [fcha_crcn]                DATETIME                    NOT NULL,
    [tme_stmp]                 ROWVERSION                  NOT NULL,
    CONSTRAINT [PK_TbCuentasManualesContrato] PRIMARY KEY CLUSTERED ([cnsctvo_cnta_mnls_cntrto] ASC),
    CONSTRAINT [FK_tbCuentasManualesContrato_tbCuentasManuales] FOREIGN KEY ([nmro_estdo_cnta]) REFERENCES [dbo].[tbCuentasManuales] ([nmro_estdo_cnta])
);


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
CREATE TRIGGER  [dbo].[TrReferencia_tbCuentasManualesContrato_cnsctvo_cdgo_pln]    ON [dbo].[tbCuentasManualesContrato]
FOR  INSERT,UPDATE
AS
Begin
DECLARE 	@lcmnsje	varchar(400)
SET NOCOUNT ON
	If Exists(Select 1 From Inserted)
Begin 
If Not Exists (Select p.cnsctvo_cdgo_pln

			from [bdplanbeneficios].[dbo].[tbPlanes] p, Inserted i
			Where p.cnsctvo_cdgo_pln  = i.cnsctvo_cdgo_pln )
	Begin
		ROLLBACK TRANSACTION
		select @lcmnsje  =  'Error:,  Violación de Integridad Referencial con bdAfiliacion..tbPlanes'
		RAISERROR(999902, 16, 1,  @lcmnsje)
		RETURN
	End
End
End 




GO

/*---------------------------------------------------------------------------------
* Nombre                 	: TrReferencia_tbCuentasManualesContrato
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
CREATE TRIGGER  [dbo].[TrReferencia_tbCuentasManualesContrato_usro_crcn]    ON    [dbo].[tbCuentasManualesContrato]
FOR  INSERT,UPDATE
AS




Set Nocount On
Declare 	@lcmnsje	varchar(400)
Begin

		-- Si el usuario no es null valido que exista en tbUsuarios
		If  exists(select 1 from  Inserted Where usro_crcn is not null)
		  Begin

			If Not Exists (Select p.lgn_usro 
			from [bdseguridad].[dbo].[tbusuarios] p, Inserted i
			Where p.lgn_usro  = i.usro_crcn )
			Begin
				ROLLBACK TRANSACTION
				select @lcmnsje  =  'Error: Violación de Integridad Referencial con bdSeguridad.tbUsuarios'
				RAISERROR(999902, 16, 1,  @lcmnsje)
				RETURN
			End
		 End
End




