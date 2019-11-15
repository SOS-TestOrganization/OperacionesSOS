CREATE TABLE [dbo].[tbProcesosCarteraPac] (
    [cnsctvo_prcso]          INT                    NOT NULL,
    [cnsctvo_cdgo_tpo_prcso] [dbo].[udtConsecutivo] NOT NULL,
    [fcha_inco_prcso]        DATETIME               NOT NULL,
    [fcha_fn_prcso]          DATETIME               NULL,
    [usro_crcn]              [dbo].[udtUsuario]     NOT NULL,
    CONSTRAINT [PK_tbProcesosCarteraPac] PRIMARY KEY CLUSTERED ([cnsctvo_prcso] ASC)
);


GO
CREATE STATISTICS [fcha_inco_prcso]
    ON [dbo].[tbProcesosCarteraPac]([fcha_inco_prcso], [cnsctvo_prcso]);


GO
CREATE STATISTICS [fcha_fn_prcso]
    ON [dbo].[tbProcesosCarteraPac]([fcha_fn_prcso], [cnsctvo_prcso]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbProcesosCarteraPac]([usro_crcn], [cnsctvo_prcso]);


GO

/*---------------------------------------------------------------------------------
* Nombre                 	: TrReferencia_tbProcesosCarteraPac
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
CREATE TRIGGER  [dbo].[TrReferencia_tbProcesosCarteraPac_usro_crcn]    ON    [dbo].[tbProcesosCarteraPac]
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

