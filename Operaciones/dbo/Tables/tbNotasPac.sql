CREATE TABLE [dbo].[tbNotasPac] (
    [nmro_nta]                           VARCHAR (15)           NOT NULL,
    [cnsctvo_cdgo_tpo_nta]               [dbo].[udtConsecutivo] NOT NULL,
    [vlr_nta]                            [dbo].[udtValorGrande] NOT NULL,
    [vlr_iva]                            [dbo].[udtValorGrande] NOT NULL,
    [sldo_nta]                           [dbo].[udtValorGrande] NOT NULL,
    [cnsctvo_prdo]                       [dbo].[udtConsecutivo] NOT NULL,
    [fcha_crcn_nta]                      DATETIME               NOT NULL,
    [cnsctvo_cdgo_estdo_nta]             [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_tpo_aplccn_nta]        [dbo].[udtConsecutivo] NOT NULL,
    [obsrvcns]                           VARCHAR (500)          NOT NULL,
    [usro_crcn]                          [dbo].[udtUsuario]     NOT NULL,
    [nmro_unco_idntfccn_empldr]          [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_scrsl]                      [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_clse_aprtnte]          [dbo].[udtConsecutivo] NOT NULL,
    [fcha_prdo_nta]                      DATETIME               NULL,
    [tme_stmp]                           ROWVERSION             NOT NULL,
    [cnsctvo_cdgo_tpo_dcmnto_nta_rntgro] VARCHAR (50)           NULL,
    [fcha_entrga_nta]                    DATETIME               NULL,
    [cnsctvo_cdgo_exstnca_aprtnte]       INT                    DEFAULT ((1)) NOT NULL,
    [cnsctvo_cdgo_estdo_dcmnto_fe]       [dbo].[udtConsecutivo] NULL,
    [cnsctvo_cdgo_tpo_dcmnto_orgn]       [dbo].[udtConsecutivo] NULL,
    [cnsctvo_cdgo_tpo_nta_orgn]          [dbo].[udtConsecutivo] NULL,
    [nmro_nta_orgn]                      VARCHAR (15)           NULL,
    [cnsctvo_estdo_cnta]                 [dbo].[udtConsecutivo] NULL,
    [cnsctvo_cdgo_cncpto_dn]             [dbo].[udtConsecutivo] NULL,
    [cdna_qr]                            VARCHAR (MAX)          NULL,
    [cuuid]                              VARCHAR (MAX)          NULL,
    [cnsctvo_cdgo_pgo]                   [dbo].[udtConsecutivo] NULL,
    CONSTRAINT [PK_TbNotasPac] PRIMARY KEY CLUSTERED ([nmro_nta] ASC, [cnsctvo_cdgo_tpo_nta] ASC),
    CONSTRAINT [FK_tbNotasPAC_tbConceptosDIAN] FOREIGN KEY ([cnsctvo_cdgo_cncpto_dn]) REFERENCES [dbo].[tbConceptosDIAN] ([cnsctvo_cdgo_cncpto_dn]),
    CONSTRAINT [FK_tbNotasPac_tbEstadosCuenta] FOREIGN KEY ([cnsctvo_estdo_cnta]) REFERENCES [dbo].[tbEstadosCuenta] ([cnsctvo_estdo_cnta]),
    CONSTRAINT [FK_tbNotasPAC_tbEstadosDocumentoFE] FOREIGN KEY ([cnsctvo_cdgo_estdo_dcmnto_fe]) REFERENCES [dbo].[tbEstadosDocumentoFE] ([cnsctvo_cdgo_estdo_dcmnto_fe]),
    CONSTRAINT [FK_tbNotasPac_tbPagos] FOREIGN KEY ([cnsctvo_cdgo_pgo]) REFERENCES [dbo].[tbPagos] ([cnsctvo_cdgo_pgo]),
    CONSTRAINT [FK_tbNotasPac_tbTipoDocumentos] FOREIGN KEY ([cnsctvo_cdgo_tpo_dcmnto_orgn]) REFERENCES [dbo].[tbTipoDocumentos] ([cnsctvo_cdgo_tpo_dcmnto])
);


GO
CREATE NONCLUSTERED INDEX [idx_tbNotasPac_ProductosAportante]
    ON [dbo].[tbNotasPac]([cnsctvo_cdgo_tpo_nta] ASC, [cnsctvo_cdgo_estdo_nta] ASC)
    INCLUDE([cnsctvo_prdo], [fcha_crcn_nta], [nmro_unco_idntfccn_empldr], [cnsctvo_scrsl], [cnsctvo_cdgo_clse_aprtnte]);


GO
CREATE NONCLUSTERED INDEX [idx_tbNotasPac_Periodo]
    ON [dbo].[tbNotasPac]([cnsctvo_prdo] ASC)
    INCLUDE([fcha_crcn_nta], [nmro_unco_idntfccn_empldr], [cnsctvo_scrsl], [cnsctvo_cdgo_clse_aprtnte]);


GO
CREATE NONCLUSTERED INDEX [idx_tbNotasPac_TipoNota]
    ON [dbo].[tbNotasPac]([cnsctvo_cdgo_tpo_nta] ASC, [nmro_unco_idntfccn_empldr] ASC, [cnsctvo_scrsl] ASC, [cnsctvo_cdgo_clse_aprtnte] ASC)
    INCLUDE([cnsctvo_prdo], [fcha_crcn_nta], [cnsctvo_cdgo_estdo_nta]);


GO
CREATE STATISTICS [obsrvcns]
    ON [dbo].[tbNotasPac]([obsrvcns]);


GO
CREATE STATISTICS [fcha_prdo_nta]
    ON [dbo].[tbNotasPac]([fcha_prdo_nta]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbNotasPac]([tme_stmp]);


GO
/*---------------------------------------------------------------------------------
* Nombre                 : 	 TrReferencia_ttbEstadosCuenta_nmro_unco_idntfccn_empldr  
* Desarrollado por	 : <\A Ing. Jorge Meneses  A\>
* Descripcion		 : <\D Garantiza integridad referencial con una tebla en otra base de Datos  D\>
* Observaciones          : <\O  O\>
* Parametros		 : <\P   P\>
* Variables		 : <\V   V\>
* Fecha Creacion	 : <\FC 2002/07/01 FC\>
* Modificado		:  Ing. Javier Paez
*---------------------------------------------------------------------------------*/
CREATE TRIGGER  [dbo].[TrReferencia_tbNotasPac_nmro_unco_idntfccn_empldr]  ON [dbo].[tbNotasPac]
FOR  INSERT,UPDATE


AS
Begin
	Declare 	@lcmnsje	varchar(400)
	Set Nocount On
	If Exists(Select 1 From Inserted where cnsctvo_cdgo_exstnca_aprtnte <> 2)
	Begin
		If Not Exists (Select p.nmro_unco_idntfccn_empldr
				From [bdAfiliacion].[dbo].[tbSucursalesaportante] p, Inserted i
				Where p.nmro_unco_idntfccn_empldr 	 = i.nmro_unco_idntfccn_empldr
				And     p.cnsctvo_scrsl		    	 = i.cnsctvo_scrsl
				And     p.cnsctvo_cdgo_clse_aprtnte	 = i.cnsctvo_cdgo_clse_aprtnte	)					
		Begin
			ROLLBACK TRANSACTION
			select @lcmnsje  = 'Error:,  Violación de Integridad Referencial con bdAfiliacion..tbSucursalesaportante'
			RAISERROR(999902, 16, 1,  @lcmnsje)
			RETURN
		End
	End
End


GO
DISABLE TRIGGER [dbo].[TrReferencia_tbNotasPac_nmro_unco_idntfccn_empldr]
    ON [dbo].[tbNotasPac];


GO
/*---------------------------------------------------------------------------------
* Nombre                 	: TrReferencia_tbNotasPac
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
CREATE TRIGGER  [dbo].[TrReferencia_tbNotasPac_usro_crcn]    ON    [dbo].[tbNotasPac]
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
end


GO
DISABLE TRIGGER [dbo].[TrReferencia_tbNotasPac_usro_crcn]
    ON [dbo].[tbNotasPac];

