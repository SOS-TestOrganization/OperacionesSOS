CREATE TABLE [dbo].[tbCuentasManualesBeneficiario] (
    [cnsctvo_cnta_mnls_cntrto]  [dbo].[udtConsecutivo]          NOT NULL,
    [cnsctvo_bnfcro]            [dbo].[udtValorPequeno]         NOT NULL,
    [cnsctvo_cdgo_tpo_idntfccn] [dbo].[udtConsecutivo]          NOT NULL,
    [nmro_idntfccn]             [dbo].[udtNumeroIdentificacion] NOT NULL,
    [prmr_aplldo]               [dbo].[udtApellido]             NOT NULL,
    [sgndo_aplldo]              [dbo].[udtApellido]             NOT NULL,
    [prmr_Nmbre]                [dbo].[udtNombre]               NOT NULL,
    [sgndo_nmbre]               [dbo].[udtNombre]               NOT NULL,
    [vlr]                       [dbo].[udtValorGrande]          NOT NULL,
    [nmro_unco_idntfccn_bnfcro] [dbo].[udtConsecutivo]          NOT NULL,
    [usro_crcn]                 [dbo].[udtUsuario]              NOT NULL,
    [fcha_crcn]                 DATETIME                        NOT NULL,
    [tme_stmp]                  ROWVERSION                      NOT NULL,
    CONSTRAINT [PK_TbCuentasManualesBeneficiario] PRIMARY KEY CLUSTERED ([cnsctvo_cnta_mnls_cntrto] ASC, [cnsctvo_bnfcro] ASC),
    CONSTRAINT [FK_tbCuentasManualesBeneficiario_tbCuentasManualesContrato] FOREIGN KEY ([cnsctvo_cnta_mnls_cntrto]) REFERENCES [dbo].[tbCuentasManualesContrato] ([cnsctvo_cnta_mnls_cntrto])
);


GO
CREATE STATISTICS [cnsctvo_bnfcro]
    ON [dbo].[tbCuentasManualesBeneficiario]([cnsctvo_bnfcro], [cnsctvo_cnta_mnls_cntrto]);


GO
CREATE STATISTICS [cnsctvo_cdgo_tpo_idntfccn]
    ON [dbo].[tbCuentasManualesBeneficiario]([cnsctvo_cdgo_tpo_idntfccn], [cnsctvo_cnta_mnls_cntrto], [cnsctvo_bnfcro]);


GO
CREATE STATISTICS [nmro_idntfccn]
    ON [dbo].[tbCuentasManualesBeneficiario]([nmro_idntfccn], [cnsctvo_cnta_mnls_cntrto], [cnsctvo_bnfcro]);


GO
CREATE STATISTICS [prmr_aplldo]
    ON [dbo].[tbCuentasManualesBeneficiario]([prmr_aplldo], [cnsctvo_cnta_mnls_cntrto], [cnsctvo_bnfcro]);


GO
CREATE STATISTICS [sgndo_aplldo]
    ON [dbo].[tbCuentasManualesBeneficiario]([sgndo_aplldo], [cnsctvo_cnta_mnls_cntrto], [cnsctvo_bnfcro]);


GO
CREATE STATISTICS [prmr_Nmbre]
    ON [dbo].[tbCuentasManualesBeneficiario]([prmr_Nmbre], [cnsctvo_cnta_mnls_cntrto], [cnsctvo_bnfcro]);


GO
CREATE STATISTICS [sgndo_nmbre]
    ON [dbo].[tbCuentasManualesBeneficiario]([sgndo_nmbre], [cnsctvo_cnta_mnls_cntrto], [cnsctvo_bnfcro]);


GO
CREATE STATISTICS [vlr]
    ON [dbo].[tbCuentasManualesBeneficiario]([vlr], [cnsctvo_cnta_mnls_cntrto], [cnsctvo_bnfcro]);


GO
CREATE STATISTICS [nmro_unco_idntfccn_bnfcro]
    ON [dbo].[tbCuentasManualesBeneficiario]([nmro_unco_idntfccn_bnfcro], [cnsctvo_cnta_mnls_cntrto], [cnsctvo_bnfcro]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbCuentasManualesBeneficiario]([usro_crcn], [cnsctvo_cnta_mnls_cntrto], [cnsctvo_bnfcro]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbCuentasManualesBeneficiario]([fcha_crcn], [cnsctvo_cnta_mnls_cntrto], [cnsctvo_bnfcro]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbCuentasManualesBeneficiario]([tme_stmp]);


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
CREATE TRIGGER  [dbo].[TrReferencia_tbCuentasManualesBeneficiario_cnsctvo_cdgo_tpo_idntfccn]    ON [dbo].[tbCuentasManualesBeneficiario]
FOR  INSERT,UPDATE
AS
Begin
DECLARE 	@lcmnsje	varchar(400)
SET NOCOUNT ON
	If Exists(Select 1 From Inserted)
Begin 
If Not Exists (Select p.cnsctvo_cdgo_tpo_idntfccn

			from [bdAfiliacion].[dbo].[tbTiposIdentificacion] p, Inserted i
			Where p.cnsctvo_cdgo_tpo_idntfccn  = i.cnsctvo_cdgo_tpo_idntfccn )
	Begin
		ROLLBACK TRANSACTION
		select @lcmnsje  =  'Error:,  Violación de Integridad Referencial con bdAfiliacion..tbTiposIdentificacion'
		RAISERROR(999902, 16, 1,  @lcmnsje)
		RETURN
	End
End
End


GO
/*---------------------------------------------------------------------------------
* Nombre                 	: TrReferencia_tbCuentasManualesBeneficiario
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
CREATE TRIGGER  [dbo].[TrReferencia_tbCuentasManualesBeneficiario_usro_crcn]    ON    [dbo].[tbCuentasManualesBeneficiario]
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

