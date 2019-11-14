CREATE TABLE [dbo].[tbAcumuladosSucursalAportante] (
    [cnsctvo_acmldo_scrsl_aprtnte] [dbo].[udtConsecutivo]  NOT NULL,
    [nmro_unco_idntfccn_empldr]    [dbo].[udtConsecutivo]  NULL,
    [cnsctvo_scrsl]                [dbo].[udtConsecutivo]  NULL,
    [cnsctvo_cdgo_clse_aprtnte]    [dbo].[udtConsecutivo]  NULL,
    [tpo_dcmnto]                   [dbo].[udtConsecutivo]  NULL,
    [nmro_dcmnto]                  VARCHAR (15)            NULL,
    [dbts]                         [dbo].[udtValorGrande]  NULL,
    [crdts]                        [dbo].[udtValorGrande]  NULL,
    [vlr_sldo]                     [dbo].[udtValorGrande]  NULL,
    [fcha_crcn]                    DATETIME                NULL,
    [usro_crcn]                    [dbo].[udtUsuario]      NULL,
    [intrs_mra]                    [dbo].[udtValorGrande]  NULL,
    [cntdd_fctrs_mra]              [dbo].[udtValorPequeno] NULL,
    [fcha_ultmo_pgo]               DATETIME                NULL,
    [fcha_ultma_fctra]             DATETIME                NULL,
    [fcha_mra]                     DATETIME                NULL,
    [ultma_oprcn]                  [dbo].[udtValorPequeno] NULL,
    [brrdo]                        [dbo].[udtLogico]       NULL,
    [tme_stmp]                     ROWVERSION              NULL,
    CONSTRAINT [PK_TbAcumuladosSucursalAportante] PRIMARY KEY CLUSTERED ([cnsctvo_acmldo_scrsl_aprtnte] ASC)
);


GO
/*---------------------------------------------------------------------------------
* Nombre                 	: TrReferencia_tbAcumuladosSucursalAportante
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
CREATE TRIGGER  [dbo].[TrReferencia_tbAcumuladosSucursalAportante_usro_crcn]    ON    [dbo].[tbAcumuladosSucursalAportante]
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
			Select @lcmnsje  =  'Error:,  Violación de Integridad Referencial con bdSeguridad.tbUsuarios.usro_crcn';
			THROW 51000, @lcmnsje, 1;
			Return
		End
	End
end 










