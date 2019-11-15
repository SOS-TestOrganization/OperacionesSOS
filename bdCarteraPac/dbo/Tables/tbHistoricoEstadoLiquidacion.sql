CREATE TABLE [dbo].[tbHistoricoEstadoLiquidacion] (
    [cnsctvo_hstrco_estdo_lqdcn] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_estdo_lqdcn]   [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_lqdcn]         [dbo].[udtConsecutivo] NOT NULL,
    [nmro_estds_cnta]            INT                    NOT NULL,
    [vlr_lqddo]                  [dbo].[udtValorGrande] NOT NULL,
    [nmro_cntrts]                INT                    NOT NULL,
    [usro_crcn]                  [dbo].[udtUsuario]     NOT NULL,
    [fcha_crcn]                  DATETIME               NOT NULL,
    [tme_stmp]                   ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbHistoricoEstadoLliquidacion] PRIMARY KEY CLUSTERED ([cnsctvo_hstrco_estdo_lqdcn] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tbHistoricoEstadoLiquidacion_tbEstadosLiquidacion] FOREIGN KEY ([cnsctvo_cdgo_estdo_lqdcn]) REFERENCES [dbo].[tbEstadosLiquidacion] ([cnsctvo_cdgo_estdo_lqdcn]),
    CONSTRAINT [FK_tbHistoricoEstadoLiquidacion_tbLiquidaciones] FOREIGN KEY ([cnsctvo_cdgo_lqdcn]) REFERENCES [dbo].[tbLiquidaciones] ([cnsctvo_cdgo_lqdcn])
);


GO
CREATE NONCLUSTERED INDEX [ix_EstadoCuenta]
    ON [dbo].[tbHistoricoEstadoLiquidacion]([cnsctvo_cdgo_lqdcn] ASC) WITH (FILLFACTOR = 90);


GO
CREATE STATISTICS [cnsctvo_cdgo_estdo_lqdcn]
    ON [dbo].[tbHistoricoEstadoLiquidacion]([cnsctvo_cdgo_estdo_lqdcn], [cnsctvo_hstrco_estdo_lqdcn]);


GO
CREATE STATISTICS [nmro_estds_cnta]
    ON [dbo].[tbHistoricoEstadoLiquidacion]([nmro_estds_cnta], [cnsctvo_hstrco_estdo_lqdcn]);


GO
CREATE STATISTICS [vlr_lqddo]
    ON [dbo].[tbHistoricoEstadoLiquidacion]([vlr_lqddo], [cnsctvo_hstrco_estdo_lqdcn]);


GO
CREATE STATISTICS [nmro_cntrts]
    ON [dbo].[tbHistoricoEstadoLiquidacion]([nmro_cntrts], [cnsctvo_hstrco_estdo_lqdcn]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbHistoricoEstadoLiquidacion]([usro_crcn], [cnsctvo_hstrco_estdo_lqdcn]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbHistoricoEstadoLiquidacion]([fcha_crcn], [cnsctvo_hstrco_estdo_lqdcn]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbHistoricoEstadoLiquidacion]([tme_stmp]);


GO
/*---------------------------------------------------------------------------------
* Nombre                 	: TrReferencia_tbHistoricoEstadoLiquidacion
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
CREATE TRIGGER  [dbo].[TrReferencia_tbHistoricoEstadoLiquidacion_usro_crcn]    ON    [dbo].[tbHistoricoEstadoLiquidacion]
FOR  INSERT,UPDATE
AS
Begin

Declare 	@lcmnsje	varchar(400)

Set Nocount On

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

