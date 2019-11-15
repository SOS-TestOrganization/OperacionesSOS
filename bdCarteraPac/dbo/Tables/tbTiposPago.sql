CREATE TABLE [dbo].[tbTiposPago] (
    [cnsctvo_cdgo_tpo_pgo] [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_tpo_pgo]         [dbo].[udtCodigo]      NOT NULL,
    [dscrpcn_tpo_pgo]      [dbo].[udtDescripcion] NOT NULL,
    [fcha_crcn]            DATETIME               NOT NULL,
    [usro_crcn]            [dbo].[udtUsuario]     NOT NULL,
    [vsble_usro]           [dbo].[udtLogico]      NOT NULL,
    CONSTRAINT [PK_tbTiposPago_1] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_tpo_pgo] ASC),
    CONSTRAINT [IX_tbTiposPago] UNIQUE NONCLUSTERED ([cdgo_tpo_pgo] ASC)
);


GO
CREATE STATISTICS [dscrpcn_tpo_pgo]
    ON [dbo].[tbTiposPago]([dscrpcn_tpo_pgo], [cnsctvo_cdgo_tpo_pgo]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbTiposPago]([fcha_crcn], [cnsctvo_cdgo_tpo_pgo]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbTiposPago]([usro_crcn], [cnsctvo_cdgo_tpo_pgo]);


GO
CREATE STATISTICS [vsble_usro]
    ON [dbo].[tbTiposPago]([vsble_usro], [cnsctvo_cdgo_tpo_pgo]);


GO
/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Nombre		: TrCodigosEspeciales_tbTiposPago
* Desarrollado por	: <\A Ing. Jorge Meneses					A\>
* Descripcion		: <\D Protege los registros que contienen los códigos de Vacio	D\>
*			  <\D e Inexistente, para que no se actualicen ni borren			D\>
* Observaciones		: <\O Inexistente: Código lleno de ceros. Vacio: Código lleno de nueves	O\>
* Parametros		: <\P  									P\>
* Variables		: <\V Longitud del código						V\>
			: <\V Código de Vacio							V\>
			: <\V Código de Inexistente						V\>
			: <\V Texto del mensaje de						V\>
* Fecha Creacion	: <\FC 2002/07/17							FC\>
*
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Modificado Por		: <\Amino. Javier Paez				AM\>
* Descripcion		: <\DM  							DM\>
* Nuevos Parametros	: <\PM  							PM\>
* Nuevas Variables	: <\VM  								VM\>
* Fecha Modificacion	: <\FM  									FM\>
---------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
CREATE TRIGGER [dbo].[TrCodigosEspeciales_tbTiposPago]
ON  [dbo].[tbTiposPago]
FOR  UPDATE, DELETE 
AS 

Declare	@lcLongitud 	TinyInt,
	@lcCodigov 	Varchar(30), 
	@lcCodigoi 	Varchar(30),
	@lcTexto 	Varchar (120)

Set	@lcCodigov ='0'
Set	@lcCodigoi ='9'

Select	@lcLongitud = (COL_LENGTH('tbTiposPago','cdgo_tpo_pgo')) - 1

While	@lcLongitud > 0 
Begin
	Set	@lcCodigov = @lcCodigov + '0'
	Set	@lcCodigoi = @lcCodigoi + '9'
  	Set	@lcLongitud = @lcLongitud - 1
End

Set NoCount On

If	Exists (	Select * From Deleted 
		Where cdgo_tpo_pgo = @lcCodigov  Or  cdgo_tpo_pgo =  @lcCodigoi)
Begin
	RollBack Transaction
	Select		@lcTexto ='Error, Los registros con códigos '+@lcCodigov+' ó '+@lcCodigoi+' no pueden ser actualizados ni borrados.'
	RAISERROR (999904, 16, 1,  @lcTexto)
	Return	
End



GO


/*---------------------------------------------------------------------------------------------------------------------
*Metodo o Programa	: 	TrValidaBorrar_tbTiposPago
* Desarrollado por	:<\A   Ings. Javier Paez y Maribel Valencia Herrera A\>
* Descripcion		:  <\D   Valida el borrar Conceptos en todas las tablas Referencial o Relacion	D\>
		 	   <\D	y en todas las Bases de Datos				D\>
* Observaciones	:  <\O								O\>
* Parametros		:  <\P    							P\>
* Variables		:  <\V	Consecutivo Codigo del concepto    	  		V\>
			:  <\V	Nombre de la Tabla Relacion				V\>
			:  <\V	Nombre del Campo en la Tabla Relacion		V\>
			:  <\V	Nombre de la Base de Datos de la Tabla Relacion		V\>
			:  <\V	Mensaje						V\>
			:  <\V	Cadena de Intruccion 1					V\>
			:  <\V	Contador de relaciones de la Instruccion1         	  		V\>
			:  <\V	Parametros de la Instruccion 1		         	  	V\>
			:  <\V	Parametro de salida de la Instruccion1				V\>
* Fecha Creacion		:  <\FC  	2003/02/08						FC\>
*  
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------  
* Modificado Por			 : <\Maribel Valencia Herrera\>
* Descripcion			 : <\Borre las incidencias , las Vigencias e Insertar en tabla tbTiposPago \>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables			 : <\VM   VM\>
* Fecha Modificacion		 : <\FM   FM\>
*---------------------------------------------------------------------------------*/
CREATE TRIGGER [dbo].[trValidaBorrar_tbTiposPago] ON    [dbo].[tbTiposPago]
FOR DELETE
AS 
Declare   
	@cnsctvo_tbla			udtConsecutivo,	
	@lcTbla			varchar(50),
	@lcCampo			varchar(100),
	@lcBse_dts			varchar(100),
	@mnsje  			varchar(400), 
	@IcInstruccion1			Nvarchar(4000),
	@lncontador1			int,
	@lcParametros1			nvarchar(200),
	@lnsalida1			int,
	@liConsecutivo			udtConsecutivo,
	@cdgo				char(10),
	@dscrpcn			udtDescripcion,
	@usro				udtUsuario,
	@fcha_elmncn			datetime


Begin

SET NOCOUNT ON

set	@liConsecutivo = 0

-->Obtener las tablas con las cuales esta relacionada la tabla parámetro
Declare crTablasRelacion CURSOR FOR
select tbla_rlcn,cmpo_rlcn,bse_dts
from tbTablasRelacionGeneral
where tbla_prmtro = 'tbTiposPago'
 
-- >Obtener los campos del parámetro  que se estan tratando de borrar
select    @cnsctvo_tbla =  cnsctvo_cdgo_tpo_pgo,
	@cdgo = cdgo_tpo_pgo,
	@dscrpcn=     dscrpcn_tpo_pgo
from deleted

set nocount on
set @lncontador1=1
set @lnsalida1=1
Set @lcParametros1  	= '@inco1 int output'

OPEN  crTablasRelacion
FETCH NEXT FROM crTablasRelacion
Into @lcTbla,@lcCampo,@lcBse_dts

WHILE @@FETCH_STATUS = 0
	 Begin
		set nocount on
-->Armar la cadena para saber si existe alguna relacion en las Bases de Datos con el codigo del concepto
		select @IcInstruccion1	= 'select @inco1 = count(*) from '+@lcBse_dts+'..'+ @lcTbla +'
					  where '+@lcCampo+'= '+convert(varchar(10),@cnsctvo_tbla)
					
-->Ejecutar cadena de datos
		exec sp_executesql @IcInstruccion1, @lcParametros1, @inco1 =@lncontador1 output
--> Si el contador es Cero para todas las tablas encontradas lo borra de lo contrario no 
		If      @lncontador1!=0
		 Begin
			Close		crTablasRelacion
			Deallocate	crTablasRelacion
			ROLLBACK TRANSACTION
	     	     	select @mnsje  = 'Error, el registro no se puede Eliminar , está siendo utilizado en una Afiliación ' 
                    		RAISERROR (999903, 16, 1,  @mnsje)
	     	     	RETURN
	 	End
	FETCH NEXT FROM crTablasRelacion
	into @lcTbla,@lcCampo,@lcBse_dts
	End  --fin Ciclo
	close crTablasRelacion
	deallocate crTablasRelacion

select @liConsecutivo = max(a.cnsctvo_brrdo)
from tbParametrosEliminados a

-->Si no hay registros en la tabla tbParametrosEliminados

if  @liConsecutivo is null
	set	@liConsecutivo =1
else 
set	@liConsecutivo = @liConsecutivo + 1

set @usro=system_user
set @fcha_elmncn=convert(varchar(30),getDate(),120 )


--> Obetener la descripción de la Tabla Parámetro
	select @dscrpcn	=	dscrpcn_tpo_pgo from tbTiposPago
	where  cnsctvo_cdgo_tpo_pgo = @cnsctvo_tbla

--> Insertar el la tabla  tbParametrosEliminados
insert into bdCarteraPac..tbParametrosEliminados values (@liConsecutivo,'bdCarteraPac','tbTiposPago', @usro,@fcha_elmncn,@cnsctvo_tbla,@cdgo,@dscrpcn,null)

--> Borrar todos los Registros (vigencias, incidencias y parámetro) relacionados con el parámetro eliminado	
delete  tbTiposPago_vigencias where  cnsctvo_cdgo_tpo_pgo = @cnsctvo_tbla
delete tbIncidenciasCarteraPac  where cnsctvo_rgstro_afctdo = @cnsctvo_tbla
delete tbTiposPago where  cnsctvo_cdgo_tpo_pgo = @cnsctvo_tbla

commit

end


GO


/*---------------------------------------------------------------------------------
* Nombre                 	: TrReferencia_tbTiposPago
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
CREATE TRIGGER  [dbo].[TrReferencia_tbTiposPago_usro_crcn]    ON    [dbo].[tbTiposPago]
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

