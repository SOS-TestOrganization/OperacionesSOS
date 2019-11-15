CREATE TABLE [dbo].[tbDiasCobroMoraSucursal] (
    [cnsctvo_cdgo_da_mra_scrsl] [dbo].[udtConsecutivo] NOT NULL,
    [fcha_crcn]                 DATETIME               NOT NULL,
    [usro_crcn]                 [dbo].[udtUsuario]     NOT NULL,
    [cnsctvo_cdgo_ds_mra]       [dbo].[udtConsecutivo] NOT NULL,
    [nmro_unco_idntfccn_empldr] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_scrsl]             [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_clse_aprtnte] [dbo].[udtConsecutivo] NOT NULL,
    CONSTRAINT [PK_TbDiasCobroMoraSucursal] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_da_mra_scrsl] ASC),
    CONSTRAINT [FK_tbDiasCobroMoraSucursal_tbDiasMora] FOREIGN KEY ([cnsctvo_cdgo_ds_mra]) REFERENCES [dbo].[tbDiasMora] ([cnsctvo_cdgo_ds_mra])
);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbDiasCobroMoraSucursal]([fcha_crcn], [cnsctvo_cdgo_da_mra_scrsl]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbDiasCobroMoraSucursal]([usro_crcn], [cnsctvo_cdgo_da_mra_scrsl]);


GO
CREATE STATISTICS [cnsctvo_cdgo_ds_mra]
    ON [dbo].[tbDiasCobroMoraSucursal]([cnsctvo_cdgo_ds_mra], [cnsctvo_cdgo_da_mra_scrsl]);


GO
CREATE STATISTICS [nmro_unco_idntfccn_empldr]
    ON [dbo].[tbDiasCobroMoraSucursal]([nmro_unco_idntfccn_empldr], [cnsctvo_cdgo_da_mra_scrsl]);


GO
CREATE STATISTICS [cnsctvo_scrsl]
    ON [dbo].[tbDiasCobroMoraSucursal]([cnsctvo_scrsl], [cnsctvo_cdgo_da_mra_scrsl]);


GO
CREATE STATISTICS [cnsctvo_cdgo_clse_aprtnte]
    ON [dbo].[tbDiasCobroMoraSucursal]([cnsctvo_cdgo_clse_aprtnte], [cnsctvo_cdgo_da_mra_scrsl]);


GO
/*--------------------------------------------------------------------------------------------------------
* Nombre                 	:	TrReferencia_Usuario_tbDiasCobroMoraSucursal
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
CREATE TRIGGER  [dbo].[TrReferencia_Usuario_tbDiasCobroMoraSucursal]  ON    [dbo].[tbDiasCobroMoraSucursal]
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
