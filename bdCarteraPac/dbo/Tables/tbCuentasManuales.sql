CREATE TABLE [dbo].[tbCuentasManuales] (
    [nmro_estdo_cnta]               VARCHAR (15)                         NOT NULL,
    [fcha_incl_fctrcn]              DATETIME                             NOT NULL,
    [fcha_fnl_fctrcn]               DATETIME                             NOT NULL,
    [fcha_lmte_pgo]                 DATETIME                             NOT NULL,
    [nmro_unco_idntfccn_empldr]     [dbo].[udtConsecutivo]               NOT NULL,
    [cnsctvo_scrsl]                 [dbo].[udtConsecutivo]               NOT NULL,
    [cnsctvo_cdgo_clse_aprtnte]     [dbo].[udtConsecutivo]               NOT NULL,
    [cnsctvo_cdgo_tpo_idntfccn]     [dbo].[udtConsecutivo]               NOT NULL,
    [nmro_idntfccn_rspnsble_pgo]    [dbo].[udtNumeroIdentificacionLargo] NOT NULL,
    [dgto_vrfccn]                   [dbo].[udtValorPequeno]              NOT NULL,
    [nmbre_empldr]                  VARCHAR (200)                        NOT NULL,
    [nmbre_scrsl]                   VARCHAR (200)                        NOT NULL,
    [cts_cnclr]                     [dbo].[udtValorPequeno]              NOT NULL,
    [cts_sn_cnclr]                  [dbo].[udtValorPequeno]              NOT NULL,
    [drccn]                         [dbo].[udtDescripcion]               NOT NULL,
    [cnsctvo_cdgo_cdd]              [dbo].[udtConsecutivo]               NOT NULL,
    [tlfno]                         [dbo].[udtTelefono]                  NOT NULL,
    [ttl_fctrdo]                    [dbo].[udtValorGrande]               NOT NULL,
    [vlr_iva]                       [dbo].[udtValorGrande]               NOT NULL,
    [sldo_fvr]                      [dbo].[udtValorGrande]               NOT NULL,
    [sldo_antrr]                    [dbo].[udtValorGrande]               NOT NULL,
    [ttl_pgr]                       [dbo].[udtValorGrande]               NOT NULL,
    [fcha_crcn]                     DATETIME                             NOT NULL,
    [usro_crcn]                     [dbo].[udtUsuario]                   NOT NULL,
    [cnsctvo_cdgo_prdo]             [dbo].[udtConsecutivo]               NOT NULL,
    [cnsctvo_cdgo_autrzdr_espcl]    [dbo].[udtConsecutivo]               NOT NULL,
    [prcntje_incrmnto]              [dbo].[udtValorDecimales]            NOT NULL,
    [cnsctvo_cdgo_prdo_lqdcn]       [dbo].[udtConsecutivo]               NOT NULL,
    [cnsctvo_cdgo_estdo_estdo_cnta] [dbo].[udtConsecutivo]               NOT NULL,
    [exste_cntrto]                  [dbo].[udtLogico]                    NOT NULL,
    [sldo_estdo_cnta]               [dbo].[udtValorGrande]               NOT NULL,
    [usro_ultma_mdfccn]             [dbo].[udtUsuario]                   NULL,
    [fcha_ultma_mdfccn]             DATETIME                             NULL,
    [dgto_chqo]                     CHAR (1)                             NULL,
    [fcha_imprsn]                   DATETIME                             NULL,
    [imprso]                        CHAR (1)                             NULL,
    [usro_imprsn]                   [dbo].[udtUsuario]                   NULL,
    [tme_stmp]                      ROWVERSION                           NOT NULL,
    [cnsctvo_cdgo_rslcn_dn]         [dbo].[udtConsecutivo]               NULL,
    [cnsctvo_cdgo_tpo_dcmnto]       [dbo].[udtConsecutivo]               NULL,
    [cnsctvo_cdgo_estdo_dcmnto_fe]  [dbo].[udtConsecutivo]               NULL,
    [cdgo_brrs]                     VARCHAR (MAX)                        NULL,
    [txto_vncmnto]                  VARCHAR (50)                         NULL,
    [cufe]                          VARCHAR (MAX)                        NULL,
    [cdna_qr]                       VARCHAR (MAX)                        NULL,
    CONSTRAINT [PK_TbCuentasManuales] PRIMARY KEY CLUSTERED ([nmro_estdo_cnta] ASC),
    CONSTRAINT [FK_tbCuentasManuales_tbAutorizadoresEspeciales] FOREIGN KEY ([cnsctvo_cdgo_autrzdr_espcl]) REFERENCES [dbo].[tbAutorizadoresEspeciales] ([cnsctvo_cdgo_autrzdr_espcl]),
    CONSTRAINT [FK_tbCuentasManuales_tbEstadosDocumento] FOREIGN KEY ([cnsctvo_cdgo_estdo_dcmnto_fe]) REFERENCES [dbo].[tbEstadosDocumentoFE] ([cnsctvo_cdgo_estdo_dcmnto_fe]),
    CONSTRAINT [FK_tbCuentasManuales_tbEstadosEstadosCuenta] FOREIGN KEY ([cnsctvo_cdgo_estdo_estdo_cnta]) REFERENCES [dbo].[tbEstadosEstadosCuenta] ([cnsctvo_cdgo_estdo_estdo_cnta]),
    CONSTRAINT [FK_tbCuentasManuales_tbPeriodosliquidacion] FOREIGN KEY ([cnsctvo_cdgo_prdo_lqdcn]) REFERENCES [dbo].[tbPeriodosliquidacion] ([cnsctvo_cdgo_prdo_lqdcn]),
    CONSTRAINT [FK_tbCuentasManuales_tbTipoDocumentos] FOREIGN KEY ([cnsctvo_cdgo_tpo_dcmnto]) REFERENCES [dbo].[tbTipoDocumentos] ([cnsctvo_cdgo_tpo_dcmnto])
);


GO
CREATE STATISTICS [fcha_incl_fctrcn]
    ON [dbo].[tbCuentasManuales]([fcha_incl_fctrcn], [nmro_estdo_cnta]);


GO
CREATE STATISTICS [fcha_fnl_fctrcn]
    ON [dbo].[tbCuentasManuales]([fcha_fnl_fctrcn], [nmro_estdo_cnta]);


GO
CREATE STATISTICS [fcha_lmte_pgo]
    ON [dbo].[tbCuentasManuales]([fcha_lmte_pgo], [nmro_estdo_cnta]);


GO
CREATE STATISTICS [dgto_vrfccn]
    ON [dbo].[tbCuentasManuales]([dgto_vrfccn], [nmro_estdo_cnta]);


GO
CREATE STATISTICS [nmbre_empldr]
    ON [dbo].[tbCuentasManuales]([nmbre_empldr], [nmro_estdo_cnta]);


GO
CREATE STATISTICS [nmbre_scrsl]
    ON [dbo].[tbCuentasManuales]([nmbre_scrsl], [nmro_estdo_cnta]);


GO
CREATE STATISTICS [cts_cnclr]
    ON [dbo].[tbCuentasManuales]([cts_cnclr], [nmro_estdo_cnta]);


GO
CREATE STATISTICS [cts_sn_cnclr]
    ON [dbo].[tbCuentasManuales]([cts_sn_cnclr], [nmro_estdo_cnta]);


GO
CREATE STATISTICS [drccn]
    ON [dbo].[tbCuentasManuales]([drccn], [nmro_estdo_cnta]);


GO
CREATE STATISTICS [tlfno]
    ON [dbo].[tbCuentasManuales]([tlfno], [nmro_estdo_cnta]);


GO
CREATE STATISTICS [ttl_fctrdo]
    ON [dbo].[tbCuentasManuales]([ttl_fctrdo], [nmro_estdo_cnta]);


GO
CREATE STATISTICS [vlr_iva]
    ON [dbo].[tbCuentasManuales]([vlr_iva], [nmro_estdo_cnta]);


GO
CREATE STATISTICS [sldo_fvr]
    ON [dbo].[tbCuentasManuales]([sldo_fvr], [nmro_estdo_cnta]);


GO
CREATE STATISTICS [sldo_antrr]
    ON [dbo].[tbCuentasManuales]([sldo_antrr], [nmro_estdo_cnta]);


GO
CREATE STATISTICS [ttl_pgr]
    ON [dbo].[tbCuentasManuales]([ttl_pgr], [nmro_estdo_cnta]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbCuentasManuales]([fcha_crcn], [nmro_estdo_cnta]);


GO
CREATE STATISTICS [prcntje_incrmnto]
    ON [dbo].[tbCuentasManuales]([prcntje_incrmnto], [nmro_estdo_cnta]);


GO
CREATE STATISTICS [exste_cntrto]
    ON [dbo].[tbCuentasManuales]([exste_cntrto], [nmro_estdo_cnta]);


GO
CREATE STATISTICS [sldo_estdo_cnta]
    ON [dbo].[tbCuentasManuales]([sldo_estdo_cnta], [nmro_estdo_cnta]);


GO
CREATE STATISTICS [usro_ultma_mdfccn]
    ON [dbo].[tbCuentasManuales]([usro_ultma_mdfccn], [nmro_estdo_cnta]);


GO
CREATE STATISTICS [fcha_ultma_mdfccn]
    ON [dbo].[tbCuentasManuales]([fcha_ultma_mdfccn], [nmro_estdo_cnta]);


GO
CREATE STATISTICS [dgto_chqo]
    ON [dbo].[tbCuentasManuales]([dgto_chqo], [nmro_estdo_cnta]);


GO
CREATE STATISTICS [usro_imprsn]
    ON [dbo].[tbCuentasManuales]([usro_imprsn], [nmro_estdo_cnta]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbCuentasManuales]([tme_stmp]);


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
CREATE TRIGGER  [dbo].[TrReferencia_tbCuentasManuales_cnsctvo_cdgo_tpo_idntfccn]    ON [dbo].[tbCuentasManuales]
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
* Nombre                 : 
* Desarrollado por	 : <\A Ing. Jorge Meneses  A\>
* Descripcion		 : <\D Garantiza integridad referencial con una tebla en otra base de Datos  D\>
* Observaciones          : <\O  O\>
* Parametros		 : <\P   P\>
* Variables		 : <\V   V\>
* Fecha Creacion	 : <\FC 2002/07/01 FC\>
* Modificado		:  Ing. Javier Paez
*---------------------------------------------------------------------------------*/
CREATE TRIGGER  [dbo].[TrReferencia_tbCuentasManuales_cnsctvo_cdgo_prdo]    ON [dbo].[tbCuentasManuales]
FOR  INSERT,UPDATE
AS
Begin
DECLARE 	@lcmnsje	varchar(400)
SET NOCOUNT ON
	If Exists(Select 1 From Inserted)
Begin 
If Not Exists (Select p.cnsctvo_cdgo_prdo

			from [bdAfiliacion].[dbo].[tbPeriodos] p, Inserted i
			Where p.cnsctvo_cdgo_prdo  = i.cnsctvo_cdgo_prdo )
	Begin
		ROLLBACK TRANSACTION
		select @lcmnsje  =  'Error:,  Violación de Integridad Referencial con bdAfiliacion..tbPeriodos'
		RAISERROR(999902, 16, 1,  @lcmnsje)
		RETURN
	End
End
End


GO
/*---------------------------------------------------------------------------------
* Nombre                 	: TrReferencia_tbCuentasManuales
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
CREATE TRIGGER  [dbo].[TrReferencia_tbCuentasManuales_usro_crcn]    ON    [dbo].[tbCuentasManuales]
FOR  INSERT,UPDATE
AS


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

