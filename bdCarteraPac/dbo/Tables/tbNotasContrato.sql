CREATE TABLE [dbo].[tbNotasContrato] (
    [cnsctvo_nta_cntrto]        [dbo].[udtConsecutivo]      NOT NULL,
    [nmro_nta]                  VARCHAR (15)                NOT NULL,
    [cnsctvo_cdgo_tpo_nta]      [dbo].[udtConsecutivo]      NOT NULL,
    [cnsctvo_estdo_cnta_cntrto] [dbo].[udtConsecutivo]      NOT NULL,
    [cnsctvo_cdgo_tpo_cntrto]   [dbo].[udtConsecutivo]      NOT NULL,
    [nmro_cntrto]               [dbo].[udtNumeroFormulario] NOT NULL,
    [vlr]                       [dbo].[udtValorGrande]      NOT NULL,
    [vlr_iva]                   [dbo].[udtValorGrande]      NULL,
    [sldo_nta_cntrto]           [dbo].[udtValorGrande]      NOT NULL,
    [fcha_ultma_mdfccn]         DATETIME                    NULL,
    [usro_ultma_mdfccn]         [dbo].[udtUsuario]          NULL,
    [tme_stmp]                  ROWVERSION                  NOT NULL,
    CONSTRAINT [PK_TbNotasContrato] PRIMARY KEY CLUSTERED ([cnsctvo_nta_cntrto] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_cnsctvo_cdgo_tpo_nta]
    ON [dbo].[tbNotasContrato]([cnsctvo_cdgo_tpo_nta] ASC, [cnsctvo_cdgo_tpo_cntrto] ASC, [nmro_cntrto] ASC, [sldo_nta_cntrto] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_tpo_nta_sldo_cntrto]
    ON [dbo].[tbNotasContrato]([cnsctvo_cdgo_tpo_nta] ASC, [sldo_nta_cntrto] ASC)
    INCLUDE([nmro_nta], [cnsctvo_estdo_cnta_cntrto], [cnsctvo_cdgo_tpo_cntrto], [nmro_cntrto]);


GO
CREATE NONCLUSTERED INDEX [idx_tbNotasPac_NumeroNota]
    ON [dbo].[tbNotasContrato]([nmro_nta] ASC, [cnsctvo_cdgo_tpo_nta] ASC, [sldo_nta_cntrto] ASC)
    INCLUDE([cnsctvo_estdo_cnta_cntrto], [cnsctvo_cdgo_tpo_cntrto], [nmro_cntrto]);


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
CREATE TRIGGER  [dbo].[TrReferencia_tbNotasContrato_cnsctvo_cdgo_tpo_cntrto]   ON [dbo].[tbNotasContrato]
FOR  INSERT,UPDATE


AS
Begin
	Declare 	@lcmnsje	varchar(400)
	Set Nocount On
	If Exists(Select 1 From Inserted)
	Begin
		If Not Exists (Select p.cnsctvo_cdgo_tpo_cntrto
				From [bdAfiliacion].[dbo].[tbContratos] p, Inserted i
				Where p.cnsctvo_cdgo_tpo_cntrto  = i.cnsctvo_cdgo_tpo_cntrto )
		Begin
			ROLLBACK TRANSACTION
			select @lcmnsje  = 'Error:,  Violación de Integridad Referencial con bdAfiliacion..tbContratos'
			RAISERROR(999902, 16, 1,  @lcmnsje)
			RETURN
		End
	End
End

