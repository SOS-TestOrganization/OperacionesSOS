CREATE TABLE [dbo].[tbCuentasContratosBeneficiarios] (
    [cnsctvo_estdo_cnta_cntrto_bnfcro] [dbo].[udtConsecutivo]  NOT NULL,
    [cnsctvo_estdo_cnta_cntrto]        [dbo].[udtConsecutivo]  NOT NULL,
    [cnsctvo_bnfcro]                   [dbo].[udtValorPequeno] NOT NULL,
    [nmro_unco_idntfccn_bnfcro]        [dbo].[udtConsecutivo]  NOT NULL,
    [Vlr]                              [dbo].[udtValorGrande]  NOT NULL,
    [tme_stmp]                         ROWVERSION              NOT NULL,
    CONSTRAINT [PK_TbCuentasContratosBeneficiarios] PRIMARY KEY CLUSTERED ([cnsctvo_estdo_cnta_cntrto_bnfcro] ASC),
    CONSTRAINT [FK_tbCuentasContratosBeneficiarios_tbEstadosCuentaContratos] FOREIGN KEY ([cnsctvo_estdo_cnta_cntrto]) REFERENCES [dbo].[tbEstadosCuentaContratos] ([cnsctvo_estdo_cnta_cntrto])
);


GO
CREATE NONCLUSTERED INDEX [ix_EstadoCuentaContrato]
    ON [dbo].[tbCuentasContratosBeneficiarios]([cnsctvo_estdo_cnta_cntrto] ASC);


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
CREATE TRIGGER  [dbo].[TrReferencia_tbCuentasContratosBeneficiarios_nmro_unco_idntfccn_bnfcro]    ON [dbo].[tbCuentasContratosBeneficiarios]
FOR  INSERT,UPDATE
AS
Begin
DECLARE 	@lcmnsje	varchar(400)
SET NOCOUNT ON
If Exists(Select 1 From Inserted)
Begin 
If Not Exists (Select p.nmro_unco_idntfccn_bnfcro

			from [bdAfiliacion].[dbo].[tbBeneficiarios] p, Inserted i
			Where p.nmro_unco_idntfccn_bnfcro  = i.nmro_unco_idntfccn_bnfcro )
	Begin
		ROLLBACK TRANSACTION
		select @lcmnsje  =  'Error:,  Violación de Integridad Referencial con bdAfiliacion..tbBeneficiarios'
		RAISERROR(999902, 16, 1,  @lcmnsje)
		RETURN
	End
End
End 



