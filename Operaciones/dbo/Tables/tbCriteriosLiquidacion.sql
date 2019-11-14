CREATE TABLE [dbo].[tbCriteriosLiquidacion] (
    [cnsctvo_cdgo_crtro_lqdcn]  [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_lqdcn]        [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_sde]          [dbo].[udtConsecutivo] NOT NULL,
    [nmro_unco_idntfccn_empldr] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_scrsl]             [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_clse_aprtnte] [dbo].[udtConsecutivo] NOT NULL,
    [tme_stmp]                  ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbCriteriosLiquidacion] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_crtro_lqdcn] ASC),
    CONSTRAINT [FK_tbCriteriosLiquidacion_tbLiquidaciones] FOREIGN KEY ([cnsctvo_cdgo_lqdcn]) REFERENCES [dbo].[tbLiquidaciones] ([cnsctvo_cdgo_lqdcn])
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
CREATE TRIGGER  [dbo].[TrReferencia_tbCriteriosLiquidacion_cnsctvo_cdgo_sde]    ON [dbo].[tbCriteriosLiquidacion]
FOR  INSERT,UPDATE
AS
Begin
DECLARE 	@lcmnsje	varchar(400)
SET NOCOUNT ON
If Exists(Select 1 From Inserted)
Begin 
If Not Exists (Select p.cnsctvo_cdgo_sde

			from [bdAfiliacion].[dbo].[tbSedes] p, Inserted i
			Where p.cnsctvo_cdgo_sde  = i.cnsctvo_cdgo_sde )
	Begin
		ROLLBACK TRANSACTION
		select @lcmnsje  =  'Error:,  Violación de Integridad Referencial con bdAfiliacion..tbSedes'
		RAISERROR(999902, 16, 1,  @lcmnsje)
		RETURN
	End
End
End 


