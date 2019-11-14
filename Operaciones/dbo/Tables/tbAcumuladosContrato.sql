CREATE TABLE [dbo].[tbAcumuladosContrato] (
    [Cnsctvo_Acmldo_cntrto]     [dbo].[udtConsecutivo]      NOT NULL,
    [tpo_dcmnto]                [dbo].[udtConsecutivo]      NULL,
    [nmro_dcmnto]               VARCHAR (15)                NULL,
    [dbts]                      [dbo].[udtValorGrande]      NULL,
    [crdts]                     [dbo].[udtValorGrande]      NULL,
    [vlr_sldo]                  [dbo].[udtValorGrande]      NULL,
    [fcha_crcn]                 DATETIME                    NULL,
    [usro_crcn]                 [dbo].[udtUsuario]          NULL,
    [cnsctvo_cdgo_tpo_cntrto]   [dbo].[udtConsecutivo]      NULL,
    [nmro_cntrto]               [dbo].[udtNumeroFormulario] NULL,
    [ultma_oprcn]               [dbo].[udtValorPequeno]     NULL,
    [cntdd_fctrs_mra]           [dbo].[udtValorPequeno]     NULL,
    [fcha_ultmo_pgo]            DATETIME                    NULL,
    [fcha_ultma_fctra]          DATETIME                    NULL,
    [fcha_mra]                  DATETIME                    NULL,
    [brrdo]                     [dbo].[udtLogico]           NULL,
    [nmro_unco_idntfccn_empldr] [dbo].[udtConsecutivo]      NULL,
    [cnsctvo_scrsl]             [dbo].[udtConsecutivo]      NULL,
    [cnsctvo_cdgo_clse_aprtnte] [dbo].[udtConsecutivo]      NULL,
    [tme_stmp]                  ROWVERSION                  NULL,
    CONSTRAINT [PK_TbAcumuladosContrato] PRIMARY KEY CLUSTERED ([Cnsctvo_Acmldo_cntrto] ASC)
);


GO
CREATE STATISTICS [dbts]
    ON [dbo].[tbAcumuladosContrato]([dbts], [Cnsctvo_Acmldo_cntrto]);


GO
CREATE STATISTICS [crdts]
    ON [dbo].[tbAcumuladosContrato]([crdts], [Cnsctvo_Acmldo_cntrto]);


GO
CREATE STATISTICS [vlr_sldo]
    ON [dbo].[tbAcumuladosContrato]([vlr_sldo], [Cnsctvo_Acmldo_cntrto]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbAcumuladosContrato]([fcha_crcn], [Cnsctvo_Acmldo_cntrto]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbAcumuladosContrato]([usro_crcn], [Cnsctvo_Acmldo_cntrto]);


GO
CREATE STATISTICS [cntdd_fctrs_mra]
    ON [dbo].[tbAcumuladosContrato]([cntdd_fctrs_mra], [Cnsctvo_Acmldo_cntrto]);


GO
CREATE STATISTICS [fcha_ultmo_pgo]
    ON [dbo].[tbAcumuladosContrato]([fcha_ultmo_pgo], [Cnsctvo_Acmldo_cntrto]);


GO
CREATE STATISTICS [fcha_ultma_fctra]
    ON [dbo].[tbAcumuladosContrato]([fcha_ultma_fctra], [Cnsctvo_Acmldo_cntrto]);


GO
CREATE STATISTICS [fcha_mra]
    ON [dbo].[tbAcumuladosContrato]([fcha_mra], [Cnsctvo_Acmldo_cntrto]);


GO
CREATE STATISTICS [brrdo]
    ON [dbo].[tbAcumuladosContrato]([brrdo], [Cnsctvo_Acmldo_cntrto]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbAcumuladosContrato]([tme_stmp]);


GO
/*---------------------------------------------------------------------------------
* Nombre                 	: TrReferencia_tbAcumuladosContrato
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
CREATE TRIGGER  [dbo].[TrReferencia_tbAcumuladosContrato_usro_crcn]    ON    [dbo].[tbAcumuladosContrato]
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
	End

