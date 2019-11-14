CREATE TABLE [dbo].[tbCuentasManualesBeneficiarioxConceptos] (
    [cnsctvo_cnta_mnls_cntrto]  [dbo].[udtConsecutivo]  NOT NULL,
    [cnsctvo_bnfcro]            [dbo].[udtValorPequeno] NOT NULL,
    [cnsctvo_cdgo_cncpto_lqdcn] [dbo].[udtConsecutivo]  NOT NULL,
    [vlr]                       [dbo].[udtValorGrande]  NOT NULL,
    [fcha_crcn]                 DATETIME                NOT NULL,
    [usro_crcn]                 [dbo].[udtUsuario]      NOT NULL,
    [tme_stmp]                  ROWVERSION              NOT NULL,
    CONSTRAINT [PK_TbCuentasManualesBeneficiarioxConceptos] PRIMARY KEY CLUSTERED ([cnsctvo_cnta_mnls_cntrto] ASC, [cnsctvo_bnfcro] ASC, [cnsctvo_cdgo_cncpto_lqdcn] ASC),
    CONSTRAINT [FK_tbCuentasManualesBeneficiarioxConceptos_tbConceptosliquidacion] FOREIGN KEY ([cnsctvo_cdgo_cncpto_lqdcn]) REFERENCES [dbo].[tbConceptosLiquidacion] ([cnsctvo_cdgo_cncpto_lqdcn]),
    CONSTRAINT [FK_tbCuentasManualesBeneficiarioxConceptos_tbCuentasManualesContrato] FOREIGN KEY ([cnsctvo_cnta_mnls_cntrto]) REFERENCES [dbo].[tbCuentasManualesContrato] ([cnsctvo_cnta_mnls_cntrto])
);


GO

/*---------------------------------------------------------------------------------
* Nombre                 	: TrReferencia_tbCuentasManualesBeneficiarioxConceptos
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
CREATE TRIGGER  [dbo].[TrReferencia_tbCuentasManualesBeneficiarioxConceptos_usro_crcn]    ON    [dbo].[tbCuentasManualesBeneficiarioxConceptos]
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






