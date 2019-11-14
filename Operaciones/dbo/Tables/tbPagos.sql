CREATE TABLE [dbo].[tbPagos] (
    [cnsctvo_cdgo_pgo]          [dbo].[udtConsecutivo]      NOT NULL,
    [cnsctvo_cdgo_estdo_pgo]    [dbo].[udtConsecutivo]      NOT NULL,
    [cnsctvo_cdgo_tpo_pgo]      [dbo].[udtConsecutivo]      NOT NULL,
    [fcha_crcn]                 DATETIME                    NOT NULL,
    [fcha_aplccn]               DATETIME                    NULL,
    [usro_aplccn]               [dbo].[udtUsuario]          NULL,
    [usro_crcn]                 [dbo].[udtUsuario]          NOT NULL,
    [cnsctvo_rcdo_cncldo]       [dbo].[udtConsecutivo]      NOT NULL,
    [fcha_rcdo]                 DATETIME                    NOT NULL,
    [nmro_dcmnto]               [dbo].[udtNumeroFormulario] NOT NULL,
    [vlr_dcmnto]                [dbo].[udtValorGrande]      NOT NULL,
    [nmro_rmsa]                 INT                         NOT NULL,
    [prdo_rmsa]                 INT                         NOT NULL,
    [nmro_lna]                  INT                         NOT NULL,
    [cnsctvo_prcso]             INT                         NOT NULL,
    [sldo_pgo]                  [dbo].[udtValorGrande]      NOT NULL,
    [cnsctvo_cdgo_tpo_prsntcn]  [dbo].[udtConsecutivo]      NULL,
    [nmro_unco_idntfccn_empldr] [dbo].[udtConsecutivo]      NULL,
    [cnsctvo_scrsl]             [dbo].[udtConsecutivo]      NULL,
    [cnsctvo_cdgo_clse_aprtnte] [dbo].[udtConsecutivo]      NULL,
    [tme_stmp]                  ROWVERSION                  NOT NULL,
    CONSTRAINT [PK_TbPagos] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_pgo] ASC),
    CONSTRAINT [FK_tbPagos_tbEstadosPago] FOREIGN KEY ([cnsctvo_cdgo_estdo_pgo]) REFERENCES [dbo].[tbEstadosPago] ([cnsctvo_cdgo_estdo_pgo]),
    CONSTRAINT [FK_tbPagos_tbProcesosCarteraPac] FOREIGN KEY ([cnsctvo_prcso]) REFERENCES [dbo].[tbProcesosCarteraPac] ([cnsctvo_prcso]),
    CONSTRAINT [FK_tbPagos_tbTiposPago] FOREIGN KEY ([cnsctvo_cdgo_tpo_pgo]) REFERENCES [dbo].[tbTiposPago] ([cnsctvo_cdgo_tpo_pgo])
);


GO
CREATE NONCLUSTERED INDEX [IX_Documento]
    ON [dbo].[tbPagos]([nmro_dcmnto] ASC, [cnsctvo_cdgo_tpo_prsntcn] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_IndexConsultaU]
    ON [dbo].[tbPagos]([nmro_dcmnto] ASC, [cnsctvo_cdgo_tpo_prsntcn] ASC, [nmro_unco_idntfccn_empldr] ASC) WITH (FILLFACTOR = 90);


GO
/*---------------------------------------------------------------------------------
* Nombre                 	: TrReferencia_tbPagos
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
CREATE TRIGGER  [dbo].[TrReferencia_tbPagos_usro_crcn]    ON    [dbo].[tbPagos]
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
				Select @lcmnsje  =  'Error:,  Violación de Integridad Referencial  tbpagos con bdSeguridad.tbUsuarios.usro_crcn';
				THROW 51000, @lcmnsje, 1;
				Return
			End
		End
	End


GO
DISABLE TRIGGER [dbo].[TrReferencia_tbPagos_usro_crcn]
    ON [dbo].[tbPagos];


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
CREATE TRIGGER  [dbo].[TrReferencia_tbPagos_cnsctvo_rcdo_cncldo]     ON [dbo].[tbPagos]
FOR  INSERT,UPDATE

AS
Begin
	Declare 	@lcmnsje	varchar(400)


	Set Nocount On

/*
	If Exists(Select 1 From Inserted)
	Begin
		If Not Exists (Select p.cnsctvo_rcdo_cncldo
				From [bdAdmonRecaudo].[dbo].[tbRecaudoConciliado] p, Inserted i
				Where p.cnsctvo_rcdo_cncldo  = i.cnsctvo_rcdo_cncldo )
		Begin
			ROLLBACK TRANSACTION
			select @lcmnsje  = 'Error:,  Violación de Integridad Referencial con bdAdmonRecuado..tbRecaudoConciliado'
			RAISERROR(999902, 16, 1,  @lcmnsje)
			RETURN
		End
	End 
*/
End


