CREATE TABLE [dbo].[tbMotivoOrdenEspecial_Vigencias] (
    [cnsctvo_vgnca_mtvo_ordn_espcl] INT           NOT NULL,
    [cnsctvo_cdgo_mtvo_ordn_espcl]  INT           NOT NULL,
    [cdgo_mtvo_ordn_espcl]          CHAR (2)      NOT NULL,
    [dscrpcn_mtvo_ordn_espcl]       VARCHAR (150) NOT NULL,
    [inco_vgnca]                    DATETIME      NOT NULL,
    [fn_vgnca]                      DATETIME      NOT NULL,
    [fcha_crcn]                     DATETIME      NOT NULL,
    [usro_crcn]                     CHAR (30)     NOT NULL,
    [obsrvcns]                      VARCHAR (250) NOT NULL,
    [vsble_usro]                    CHAR (1)      NOT NULL,
    [tme_stmp]                      ROWVERSION    NOT NULL,
    CONSTRAINT [PK_tbMotivoOrdenEspecial_Vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_mtvo_ordn_espcl] ASC)
);


GO
CREATE STATISTICS [cdgo_mtvo_ordn_espcl]
    ON [dbo].[tbMotivoOrdenEspecial_Vigencias]([cdgo_mtvo_ordn_espcl], [cnsctvo_vgnca_mtvo_ordn_espcl]);


GO
CREATE STATISTICS [cnsctvo_cdgo_mtvo_ordn_espcl]
    ON [dbo].[tbMotivoOrdenEspecial_Vigencias]([cnsctvo_cdgo_mtvo_ordn_espcl], [cnsctvo_vgnca_mtvo_ordn_espcl]);


GO
CREATE STATISTICS [dscrpcn_mtvo_ordn_espcl]
    ON [dbo].[tbMotivoOrdenEspecial_Vigencias]([dscrpcn_mtvo_ordn_espcl], [cnsctvo_vgnca_mtvo_ordn_espcl]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbMotivoOrdenEspecial_Vigencias]([fcha_crcn], [cnsctvo_vgnca_mtvo_ordn_espcl]);


GO
CREATE STATISTICS [fn_vgnca]
    ON [dbo].[tbMotivoOrdenEspecial_Vigencias]([fn_vgnca], [cnsctvo_vgnca_mtvo_ordn_espcl]);


GO
CREATE STATISTICS [inco_vgnca]
    ON [dbo].[tbMotivoOrdenEspecial_Vigencias]([inco_vgnca], [cnsctvo_vgnca_mtvo_ordn_espcl]);


GO
CREATE STATISTICS [obsrvcns]
    ON [dbo].[tbMotivoOrdenEspecial_Vigencias]([obsrvcns], [cnsctvo_vgnca_mtvo_ordn_espcl]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbMotivoOrdenEspecial_Vigencias]([tme_stmp]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbMotivoOrdenEspecial_Vigencias]([usro_crcn], [cnsctvo_vgnca_mtvo_ordn_espcl]);


GO
CREATE STATISTICS [vsble_usro]
    ON [dbo].[tbMotivoOrdenEspecial_Vigencias]([vsble_usro], [cnsctvo_vgnca_mtvo_ordn_espcl]);


GO
CREATE STATISTICS [cnsctvo_vgnca_mtvo_ordn_espcl]
    ON [dbo].[tbMotivoOrdenEspecial_Vigencias]([cnsctvo_vgnca_mtvo_ordn_espcl]);


GO




/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Nombre		: TrCodigosEspeciales_tbMotivoOrdenEspecial_Vigencias
* Desarrollado por	: <\A Ing. Jorge Meneses					A\>
* Descripcion		: <\D Protege los registros que cntienen los códigos de Vacio	D\>
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
CREATE TRIGGER [dbo].[TrCodigosEspeciales_tbMotivoOrdenEspecial_Vigencias]
ON  [dbo].[tbMotivoOrdenEspecial_Vigencias]
FOR  UPDATE, DELETE 
AS 

Declare	@lcLongitud 	TinyInt,
	@lcCodigov 	Varchar(30), 
	@lcCodigoi 	Varchar(30),
	@lcTexto 	Varchar (120)

Set	@lcCodigov ='0'
Set	@lcCodigoi ='9'

Select	@lcLongitud = (COL_LENGTH('tbMotivoOrdenEspecial_Vigencias','cdgo_mtvo_ordn_espcl')) - 1

While	@lcLongitud > 0 
Begin
	Set	@lcCodigov = @lcCodigov + '0'
	Set	@lcCodigoi = @lcCodigoi + '9'
  	Set	@lcLongitud = @lcLongitud - 1
End

Set NoCount On

If	Exists (	Select * From Deleted 
		Where cdgo_mtvo_ordn_espcl = @lcCodigov Or cdgo_mtvo_ordn_espcl = @lcCodigoi)
Begin
	RollBack Transaction
	Select		@lcTexto ='Error, Los registros con códigos '+@lcCodigov+' ó '+@lcCodigoi+' no pueden ser actualizados ni borrados.'
	RAISERROR (999904, 16, 1, @lcTexto)
	Return	
End












GO




/*---------------------------------------------------------------------------------
* Nombre                 	: TrIncidencias_tbMotivoOrdenEspecial_Vigencias
* Desarrollado por	: <\A Ing. Maribel Valencia Herrera				 A\>
* Descripción		: <\D Inserta un registro en la tabla tbInsidenciasAfiliacion  		D\>
* 			  <\D Cuando se actualiza un Campo de tbMotivoOrdenEspecial_Vigencias\>
* Observaciones       	: <\O  O\>
* Parametros		: <\P   P\>
* Variables		: <\V @lcFechaIncidencia  : Fecha en la que ocurre la incidencia 	V\>
*			  <\V IdColumna  	: Identificador de columna		 V\>
*			  <\V @lcCampo 	: Nombre de Campo			 V\>
*			  <\V @lcUsuario 	: LogIn de Usuario 			V\>
*			  <\V @InsertString	 : Cadena de inserción  			V\>
*			  <\V@cntdd_clmns	:  Numero de columnas de la tabla 	V\>
*			  <\V @cnsctvo_in 	:Consecutivo de la incidencia		V\>
*			  <\V @fcha_antrr	: Fecha Anterior				V\>
*			  <\V @fcha_nva	: Fecha Nueva 				V\>
* Fecha Creacion	: <\FC 2003/03/17 FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------
* Modificado Por	     	: <\AM  AM\>
* Descripcion		: <\DM DM\>
* Nuevos Parametros	: <\PM  PM\>
* Nuevas Variables	: <\VM  VM\>
* Fecha Modificacion	: <\FM  FM\>
-----------------------------------------------------------------------------------*/
CREATE TRIGGER [dbo].[TrIncidencias_tbMotivoOrdenEspecial_Vigencias]
On [dbo].[tbMotivoOrdenEspecial_Vigencias]
For Update As

Declare	@lcFechaIncidencia	VarChar(30),
	@lcIdColumna		Int, 
	@lcCampo 		udtNombreObjeto,
	@lcUsuario 		udtUsuario,
	@lcInsertString 		nVarChar(2000),
	@cntdd_clmns		Int,
	@cnsctvo_in		 Int,
	@fcha_antrr		datetime,
	@fcha_nva		datetime,
	@cdgo_mtvo_ordn_espcl			varchar(2000)
		
-->Obtener Fecha y Usuario de la incidencia

set @lcFechaIncidencia	= convert(VarChar(30),GetDate(),120)
set @lcUsuario		= Ltrim(Rtrim(System_User))
set @cnsctvo_in	=0
Set NoCount On

-->Obtener cantidad de columnas de la tabla parámetro
Select	@cntdd_clmns = count(*)
From	Syscolumns
Where	Id = Object_Id('bdSiSalud..tbMotivoOrdenEspecial_Vigencias')

-->Obtener nombres de las columnas de la tabla parámetro
Declare crCamposParametro Cursor For
Select name,colid 
From Syscolumns 
Where	id 	= Object_Id('bdSiSalud..tbMotivoOrdenEspecial_Vigencias')
And 	colid 	!= @cntdd_clmns
Order by colid

--> Obtener la imagen de los registros Modificados (Deleted) e Insertados (Inserted)
Select * Into #tbValoresAnteriores From Deleted
Select * Into #tbValoresNuevos From Inserted

--> Obtener el consecutivo de la incidencia
select @cnsctvo_in = max(a.cnsctvo_incdnca)
from tbIncidenciasSiSalud a

--> Si no  hay registros en la tabla de incidencias

if   @cnsctvo_in is NULL
	set	 @cnsctvo_in =1
else 
	set	 @cnsctvo_in = @cnsctvo_in+ 1

Open crCamposParametro
Fetch Next From crCamposParametro
Into @lcCampo, @lcIdColumna

-->Recorrer el cursor de los Campos del parámetro para determinar las columnas 
-->actualizadas e Insertar el Registro correspondiente en tbIncidenciasSiSalud
While @@Fetch_Status = 0
Begin

-->Armar la cadena de Inserción del registro de la incidencia

Select @lcInsertString = 'Insert Into [bdSiSalud].[dbo].[tbIncidenciasSiSalud]  ( cnsctvo_incdnca, bse_dts,nmbre_tbla,nmbre_cmpo, cnsctvo_vgnca,  vlr_antrr ,vlr_nvo ,usro_incdnca, fcha_incdnca,cnsctvo_rgstro_afctdo) Select  ' +convert(varchar(10),@cnsctvo_in)+', '+char(39)+'bdSiSalud' +char(39)+', '+char(39)+'tbMotivoOrdenEspecial_Vigencias'+char(39)+','+char(39)+@lcCampo+char(39)+' ,  d.cnsctvo_vgnca_mtvo_ordn_espcl,  '+' d.'+@lcCampo+', '+'n.'+@lcCampo+', '+char(39)+@lcUsuario+char(39)+','+char(39)+@lcFechaIncidencia+char(39)+' , d.cnsctvo_cdgo_mtvo_ordn_espcl  From #tbValoresAnteriores d, #tbValoresNuevos n Where d.cnsctvo_vgnca_mtvo_ordn_espcl = n.cnsctvo_vgnca_mtvo_ordn_espcl And ((d.'+@lcCampo+' <> n.'+@lcCampo+') Or (d.'+@lcCampo+' Is Null And n.'+@lcCampo+' Is Not Null) Or (n.'+@lcCampo+' Is Null And d.'+@lcCampo+	' is Not null))' 
-->  Ejecutar Cadena de Inserción

	Exec sp_ExecuteSql @lcInsertString


--> Actualizar en la tabla parametro la última descripción actualizada
	if @lccampo='dscrpcn_mtvo_ordn_espcl'
		update tbMotivoOrdenEspecial set dscrpcn_mtvo_ordn_espcl =(select dscrpcn_mtvo_ordn_espcl from #tbValoresNuevos)
		where cnsctvo_cdgo_mtvo_ordn_espcl= (select cnsctvo_cdgo_mtvo_ordn_espcl from #tbValoresNuevos)

--> Para insertar en incidencias afiliacion el campo   inicio vigencia en el formato AAAA/MM/DD   

	if  exists (select * from tbIncidenciasSiSalud where cnsctvo_incdnca= convert(varchar(10),@cnsctvo_in)
		 and nmbre_cmpo='inco_vgnca')

		begin
		select @fcha_antrr=inco_vgnca from #tbValoresAnteriores
		select @fcha_nva=inco_vgnca from #tbValoresNuevos
		update  tbIncidenciasSiSalud set vlr_antrr= convert(varchar(10),@fcha_antrr, 111),
		vlr_nvo=convert(varchar(10),@fcha_nva,111)
		where cnsctvo_incdnca =convert(varchar(10),@cnsctvo_in)
		end
--> Para insertar en incidencias afiliacion el campo  fin vigencia en el formato AAAA/MM/DD   

	if exists (select * from tbIncidenciasSiSalud where cnsctvo_incdnca= convert(varchar(10),@cnsctvo_in)
		 and  nmbre_cmpo='fn_vgnca')
      		begin 
		select @fcha_antrr=fn_vgnca from #tbValoresAnteriores
		select @fcha_nva=fn_vgnca from #tbValoresNuevos
                           update  tbIncidenciasSiSalud set vlr_antrr= convert(varchar(10),@fcha_antrr,111),
		vlr_nvo=convert(varchar(10),@fcha_nva,111)
		where cnsctvo_incdnca =convert(varchar(10),@cnsctvo_in)
		end

	

--> Incrementar el consecutivo de las incidencias por si hay más de una modificación 
	select @cnsctvo_in = isnull(max(a.cnsctvo_incdnca),0) +1
	from tbIncidenciasSiSalud a	

	
        Fetch Next From crCamposParametro
   	Into @lcCampo, @lcIdColumna
  End--Fin del Ciclo



Close crCamposParametro
Deallocate crCamposParametro
Drop Table #tbValoresAnteriores
Drop Table #tbValoresNuevos










GO




/*--------------------------------------------------------------------------------------------------------
* Nombre                 	:	TrReferencia_Usuario_tbMotivoOrdenEspecial_Vigencias
* Desarrollado por	: <\A	Ing. Jorge Meneses			  A\>
* Descripcion	 	: <\D	Garantiza integridad referencial con una tabla en otra base de Datos D\>
* Observaciones     	: <\O	O\>
* Parametros		: <\P	P\>
* Variables		: <\V	V\>
* Fecha Creacion	: <\FC 2002/07/01	FC\>
*--------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*--------------------------------------------------------------------------------------------------------
* Modificado Por	   	: <\AM Ing. Maribel Valencia Herrera		AM\>
* Descripcion		: <\DM El mensaje no corresponde a la validacion del trigger y es muy técnico para el usuario  DM\>
			  <\DM Error, Violación de Integridad Referencial con bdSeguridad.tbUsuarios.usro_crcn	 DM\>
			  <\DM el trigger valida que el usuario se encuentrecreado  en  bdSeguridad.tbUsuarios.usro_crcn	 DM\>			 DM\>
* Nuevos Parametros	: <\PM		PM\>
* Nuevas Variables	: <\VM		VM\>
* Fecha Modificacion	: <\FM		FM\>
*------------------------------------------------------------------------------------------------------*/
CREATE TRIGGER  [dbo].[TrReferencia_Usuario_tbMotivoOrdenEspecial_Vigencias]    ON    [dbo].[tbMotivoOrdenEspecial_Vigencias]
FOR  INSERT,UPDATE
AS
Begin
	Declare 	@lccdgo_mtvo_ordn_espcl	varchar(400),
			@lcusro		varchar(10)
	Set Nocount On
	
	If Not Exists (	Select	 p.lgn_usro From	[bdSeguridad].[dbo].[tbUsuarios] p, Inserted i
			Where	p.lgn_usro = i.usro_crcn)
	Begin
		Select	@lcusro=  i.usro_crcn From	 Inserted i
		Rollback Transaction
		Select 	@lccdgo_mtvo_ordn_espcl  =  'Error, El Usuario '+  @lcusro+' no se encuentra creado en  bdSeguridad..tbUsuarios.usro_crcn'
		RAISERROR (999902, 16, 1, @lccdgo_mtvo_ordn_espcl)
		Return
	End
End




GO




/*--------------------------------------------------------------------------------------------------------
*Metodo o Programa	: 	TrValidaModifiVigenciasRelacion_tbMotivoOrdenEspecial_Vigencias
* Desarrollado por	:  <\A  	  Ing. Maribel Valencia Herrera			A\>
* Descripcion		:  <\D   Valida la modificiacion  de fechas de vigencia en la tabla Parámetro	 D\>
			   <\D	tbMotivoOrdenEspecial_Vigencias contra las tablas de relación			D\>
* Observaciones		:  <\O			O\>
* Parametros		 :  <\P    		P\>
* Variables		 :  <\V	Fecha Inicio Nueva  de la Vigencia del Concepto			V\>
			:  <\V	Fecha Fin Nueva de la Vigencia del Concepto			V\>
			 :  <\V	Fecha Inicio Anterior   de la Vigencia del Concepto			V\>
			:  <\V	Fecha FinAnterior de la Vigencia del Concepto			V\>
			:  <\V	Consecutivo del concepto		   	     		V\>
			:  <\V	Nombre de la Tabla Relación					V\>
			:  <\V	Nombre de la Base de Datos					V\>
			:  <\V	Campo del parámetro en la relación				V\>
			:  <\V	Opción del Menú referente a la relación				V\>
			:  <\V	Campo del llave de  la relación					V\>
			:  <\V	Mensaje							V\>
			:  <\V	Cadena de Intruccion			   	      		V\>
			:  <\V	Cadena de Intruccion 1				V\>
			:  <\V	Contador de relaciones de la Instrucción		V\>
			:  <\V	Parametros de la Instruccion				V\>
			:  <\V	Parametro de salida de la Instruccion		V\>
			:  <\V	Contador de relaciones de la Instruccion		V\>
			:  <\V	Parametros de la Instruccion 1		         	V\>
			:  <\V	Parametro de salida de la Instruccion1				V\>
* Fecha Creacion	:  <\FC  	2003/03/20							FC\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------  
* Modificado Por		 : <\AM   AM\>
* Descripcion		 : <\DM   DM\>
* Nuevos Parametros	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion	 : <\FM   FM\>
*---------------------------------------------------------------------------------*/
CREATE TRIGGER [dbo].[TrValidaModifiVigenciasRelacion_tbMotivoOrdenEspecial_Vigencias] ON   [dbo].[tbMotivoOrdenEspecial_Vigencias]
FOR UPDATE
AS 
Declare   
	@fcha_inco_vgnca		datetime, 	
	@fcha_fn_vgnca		datetime,
	@dinco_vgnca			datetime, 	
	@dfn_vgnca			datetime,
   	@cnsctvo_tbla			udtConsecutivo,	
	@lcTbla			varchar(100),
	@lcBse_Dts			varchar(100),
	@lccamporln			varchar(100),
	@lcopcion_menu		varchar(100),
	@lccampo_llave			varchar(100),
	@cdgo_mtvo_ordn_espcl  			varchar(4000), 
	@IcInstruccion			Nvarchar(4000),
	@IcInstruccion1			Nvarchar(4000),
	@lncontador			int,
	@lcParametros			nvarchar(200),
	@lnsalida			int,
	@lncontador1			udtConsecutivo,
	@lcParametros1			nvarchar(200),
	@lnsalida1			int


Begin
SET NOCOUNT ON

--> Encontrar las tablas Relacion 
Declare crTablasRelacion CURSOR FOR
select tbla_rlcn+'_Vigencias' , cmpo_rlcn ,bse_dts,opcn_mnu,cmpo_llve_rlcn
from tbTablasParametrovsRelacion
where tbla_prmtro='tbMotivoOrdenEspecial_Vigencias'

--> Se capturan las variables que se estan tratando de insertar
select  	@fcha_inco_vgnca= inco_vgnca,
	@fcha_fn_vgnca=fn_vgnca,
	@cnsctvo_tbla = cnsctvo_cdgo_mtvo_ordn_espcl
from INSERTED

--> Se capturan los valores modificados
select  	@dinco_vgnca= inco_vgnca,
	@dfn_vgnca=fn_vgnca,
            	@cnsctvo_tbla = cnsctvo_cdgo_mtvo_ordn_espcl
from  deleted 

-->Obtener la imagen de los registros Modificados (Deleted) e Insertados (Inserted)
select * into #tbValoresAnteriores From Deleted
select * into #tbValoresNuevos From Inserted



-->Valida que los campos que se estan modificando sean los campos de fecha de vigencia 
if  Exists (select * from #tbValoresAnteriores d,  #tbValoresNuevos n
              where   (convert(varchar(10),d.inco_vgnca,111)<>convert(varchar(10),n.inco_vgnca,111)
             		or convert(varchar(10),d.fn_vgnca,111)<>convert(varchar(10),n.fn_vgnca,111))
              and d.cnsctvo_vgnca_mtvo_ordn_espcl = n.cnsctvo_vgnca_mtvo_ordn_espcl)

begin 

	set nocount on
	set @lnsalida = 1
                set @lncontador=0
	Set @lcParametros  	= '@inco int output'
	set @lncontador1=0
	set @lnsalida1=1
	Set @lcParametros1  	= '@inco1 udtConsecutivo output'

--> Validar  si las vigencias modificadas afectan alguna relacion existente con la tabla tbMotivoOrdenEspecial_Vigencias
	OPEN  crTablasRelacion
	FETCH NEXT FROM crTablasRelacion
	Into @lcTbla, @lccamporln,@lcBse_Dts,@lcopcion_menu,@lccampo_llave		 
	WHILE @@FETCH_STATUS = 0
	 Begin
		set nocount on
		
--> Armar la cadena para saber si existe alguna relacion en la tabla Relacion con el  codigo de la  tabla tbAreas y las fechas modificadas
		select @IcInstruccion1	= 'select  @inco1 = ' + @lccampo_llave + '  from '+@lcBse_Dts+'..'+ @lcTbla +
					 ' where  ' + @lccamporln  + '  =  '+convert(varchar(10),@cnsctvo_tbla) + 
					 ' and convert(varchar(10),inco_vgnca,111) >= '+ char(39)+ convert(varchar(10),@dinco_vgnca,111)+char(39)+
					'and  convert(varchar(10),fn_vgnca,111) <= '+ char(39)+ convert(varchar(10),@dfn_vgnca,111)+char(39)
--> Ejecutar cadena de datos
		exec sp_executesql @IcInstruccion1, @lcParametros1, @inco1 =@lncontador1 output
 
 
-->Si hay relaciones entra a validar que la modificacion no afecte la relacion existente 
	if    @lncontador1!=0 -- and @lncontador1  is not  null 
		begin
 			set @lncontador=1
--> Armar la cadena para traer los datos de la tabla relacion 
			select @IcInstruccion	= 'select  @inco = count(*)  from ' +@lcBse_Dts+'..'+ @lcTbla +
			' where ' + @lccamporln  + ' = '+ convert(varchar(10),@cnsctvo_tbla)+
			' and convert(varchar(10),inco_vgnca,111) >= '+char(39)+convert(varchar(10),@fcha_inco_vgnca,111)+char(39)+
 			' and convert(varchar(10),fn_vgnca,111) <= '+char(39)+convert(varchar(10),@fcha_fn_vgnca,111)+char(39)+
			' and  ' +@lccampo_llave	+' = '+convert(varchar(10),@lncontador1)

--> Ejecutar cadena de datos
			exec sp_executesql @IcInstruccion, @lcParametros, @inco =@lncontador output
--> Si  se encuentra en , por encima o por debajo del rango de la relacion no  actualiza e indica con cual opcion del menú esta relacionada el parámetro

			If      @lncontador=0
			      Begin

			   	 close crTablasRelacion
				 deallocate crTablasRelacion
				 ROLLBACK TRANSACTION
	     			 select @cdgo_mtvo_ordn_espcl  =  'Error, Existe una  Relacion entre los Parámetros tbMotivoOrdenEspecial_Vigencias  y  ' + @lcopcion_menu	
	      	 		 RAISERROR (999901, 16, 1, @cdgo_mtvo_ordn_espcl)
	     	 	     	 RETURN
			        end	
	end
	FETCH NEXT FROM crTablasRelacion
	into @lcTbla, @lccamporln,@lcBse_Dts,@lcopcion_menu,	 @lccampo_llave
	End  --fin Ciclo
     close crTablasRelacion
     end
     deallocate crTablasRelacion
end








GO




/*---------------------------------------------------------------------------------
* Nombre		: TrValidaTraslapeCodigo_tbMotivoOrdenEspecial_Vigencias
* Desarrollado por	: <\A Ing. Maribel Valencia Herrera				A\>
* Descripcion		: <\D Valida que no se traslape  la Vigencia Nueva con Alguna existente para el mismo parametro D\>
* Observaciones		: <\O		O\>
* Parametros		: <\P   P\>
* Variables		: <\V	Fecha Inicial Nueva					V\>
*			: <\V   Fecha Final Nueva					V\>
*			: <\V   Fecha Inicial Traslape					V\>
*			: <\V   Fecha Final Traslape					V\>
*			: <\V   Mensaje de Error					V\>
*			: <\V   Contador  de registros					V\>
*			: <\V   Consectivo del Parametro Nuevo			V\>
*			: <\V   Codigo del Parametro Nuevo				V\>
*			: <\V   Consecutivo de la Vigencia				V\>
*			: <\V   Descripción del parámetro Nuevo			V\>
* Fecha Creacion	: <\FC 2003/03/20				FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM  AM\>
* Descripcion		: <\DM  DM\>
* Nuevos Parametros	: <\PM  PM\>
* Nuevas Variables	: <\VM  VM\>
* Fecha Modificacion	: <\FM  FM\>
-----------------------------------------------------------------------------------*/
CREATE TRIGGER  [dbo].[TrValidaTraslapeCodigo_tbMotivoOrdenEspecial_Vigencias] ON   [dbo].[tbMotivoOrdenEspecial_Vigencias]
FOR  INSERT
AS
Begin

SET NOCOUNT ON
	DECLARE	@inco_vgnca		datetime,     
		@fn_vgnca		datetime,      
		@tinco_vgnca		datetime,     
		@tfn_vgnca		datetime,      
		@cdgo_mtvo_ordn_espcl	varchar(400), 
		@contador		int,
		@Codigo_Consecutivo	udtConsecutivo,
	  	@cdgo_ara		udtcodigo,
		@cdgo_vgnca		udtconsecutivo,
		@dscrpcn		udtDescripcion


-->Se capturan las variables que se estan tratando de insertar
SELECT	@inco_vgnca = inco_vgnca,
		@fn_vgnca	= fn_vgnca,
		@Codigo_Consecutivo = cnsctvo_cdgo_mtvo_ordn_espcl	,
		@cdgo_ara = cdgo_mtvo_ordn_espcl		,
		@cdgo_vgnca	= cnsctvo_vgnca_mtvo_ordn_espcl,
		@dscrpcn = dscrpcn_mtvo_ordn_espcl
FROM   INSERTED

	
-->Se Calcula si hay  traslape de fechas
	SELECT @contador=count(*)
	FROM tbMotivoOrdenEspecial_Vigencias p
	WHERE ( (convert(varchar(10),p.inco_vgnca,111)  >= convert(varchar(10),@inco_vgnca,111) 
	And	convert(varchar(10),p.inco_vgnca,111)  <= convert(varchar(10),@fn_vgnca,111))   Or
		(convert(varchar(10),p.fn_vgnca,111)    >= convert(varchar(10),@inco_vgnca,111) 
	And	 convert(varchar(10),p.fn_vgnca,111)    <= convert(varchar(10),@fn_vgnca,111))   Or
		(convert(varchar(10),p.inco_vgnca,111)  <= convert(varchar(10),@inco_vgnca,111) 
	And	convert(varchar(10),p.fn_vgnca,111)     >= convert(varchar(10),@fn_vgnca,111)))  
	And	p.cnsctvo_cdgo_mtvo_ordn_espcl= @Codigo_Consecutivo

-->Hay traslape de fechas

	IF @contador > 1
          
	Begin   

-->Para Indicar al usuario contra que fecha hay traslape
		SELECT @tinco_vgnca = inco_vgnca,@tfn_vgnca = fn_vgnca
		FROM tbMotivoOrdenEspecial_Vigencias p
		WHERE ( (convert(varchar(10),p.inco_vgnca,111)  >= convert(varchar(10),@inco_vgnca,111) 
		And	convert(varchar(10),p.inco_vgnca,111)  <= convert(varchar(10),@fn_vgnca,111))   Or
			(convert(varchar(10),p.fn_vgnca,111)    >= convert(varchar(10),@inco_vgnca,111) 
		And	 convert(varchar(10),p.fn_vgnca,111)    <= convert(varchar(10),@fn_vgnca,111))   Or
		(convert(varchar(10),p.inco_vgnca,111)  <= convert(varchar(10),@inco_vgnca,111) 
		And	convert(varchar(10),p.fn_vgnca,111)     >= convert(varchar(10),@fn_vgnca,111)))  
		And	p.cnsctvo_cdgo_mtvo_ordn_espcl = @Codigo_Consecutivo
		and 	cnsctvo_vgnca_mtvo_ordn_espcl != @cdgo_vgnca	
		
		
		ROLLBACK TRANSACTION
		select @cdgo_mtvo_ordn_espcl  =  'Error, Insertando, Existe  Traslape con   '+  convert(varchar(10),@tinco_vgnca,111) + '  ' + convert(varchar(10),@tfn_vgnca,111)
		RAISERROR (999905, 16, 1, @cdgo_mtvo_ordn_espcl)
		RETURN
	End

update tbMotivoOrdenEspecial set dscrpcn_mtvo_ordn_espcl = @dscrpcn
where cnsctvo_cdgo_mtvo_ordn_espcl = @Codigo_Consecutivo

End









GO




/*---------------------------------------------------------------------------------
* Nombre		: TrValidaUpdateTraslapeCodigo_tbMotivoOrdenEspecial_Vigencias
* Desarrollado por	: <\A Ing. Rolando Simbaqueva					A\>
* Descripcion		: <\D Valida que no se traslape  las fechas Modificadas con una exitente		D\>
* Observaciones		: <\O								O\>
* Parametros		: <\P	P\>
* Variables		: <\V   Fecha Inicial Nueva					V\>
*			: <\V   Fecha Final Nueva				
*			: <\V   Fecha Inicial Traslape					V\>
*			: <\V   Fecha Final Traslape					V\>
*			: <\V   Mensaje de Error					V\>
*			: <\V   Contador  de registros					V\>
*			: <\V   Consectivo del Parametro Nuevo			V\>
*			: <\V   Mensaje de Error					V\>
*			: <\V   Contador  de registros					V\>
*			: <\V   Fecha Inicial Modificada				V\>
*			: <\V   Fecha Final Modificada				V\>
*			: <\V   Consecutivo del Parametro Modificado		V\>
*			: <\V   Codigo del Parametro Nuevo				V\>
*			: <\V   Consecutivo de la Vigencia Modificado		V\>							V\>
* Fecha Creacion		: <\FC 2002/06/20				FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM  AM\>
* Descripcion		: <\DM  DM\>
* Nuevos Parametros	: <\PM  PM\>
* Nuevas Variables	: <\VM  VM\>
* Fecha Modificacion	: <\FM  FM\>
-----------------------------------------------------------------------------------*/
CREATE TRIGGER  [dbo].[TrValidaUpdateTraslapeCodigo_tbMotivoOrdenEspecial_Vigencias] ON   [dbo].[tbMotivoOrdenEspecial_Vigencias]
FOR  UPDATE
AS
Begin

SET NOCOUNT ON
	DECLARE	@inco_vgnca		datetime,     
			@fn_vgnca		datetime,      
			@tinco_vgnca		datetime,     
			@tfn_vgnca		datetime,      
			@cdgo_mtvo_ordn_espcl			varchar(400), 
			@contador		int,
			@Codigo_Consecutivo	udtConsecutivo,
			@dinco_vgnca		datetime,     
      		  	@dfn_vgnca		datetime,
      			@dcnsctvo_tbla		udtConsecutivo,
			@cdgo_ara		char(4),
			@cnsctvo_vgnca	udtConsecutivo

--> Se capturan las variables que se estan tratando de insertar
SELECT	@inco_vgnca = inco_vgnca,
		@fn_vgnca	= fn_vgnca,
		@Codigo_Consecutivo = cnsctvo_cdgo_mtvo_ordn_espcl	,
		@cdgo_ara = cdgo_mtvo_ordn_espcl		
FROM   INSERTED

-->    Se capturan las variables que se estan modificando
SELECT     @dinco_vgnca   =  inco_vgnca,
	      @dfn_vgnca     =  fn_vgnca,
     	      @dcnsctvo_tbla  =  cnsctvo_cdgo_mtvo_ordn_espcl,
	      @cnsctvo_vgnca = cnsctvo_vgnca_mtvo_ordn_espcl			     
FROM	deleted
 
-->Obtener la imagen de los registros Modificados (Deleted) e Insertados (Inserted)
select * into #tbValoresAnteriores From Deleted
select * into #tbValoresNuevos From Inserted



-->valida que los campos que se estan modificando sean los campos de fecha de vigencia 
if  Exists (select * from #tbValoresAnteriores d,  #tbValoresNuevos n
              where   (convert(varchar(10),d.inco_vgnca,111)<>convert(varchar(10),n.inco_vgnca,111)
             		or convert(varchar(10),d.fn_vgnca,111)<>convert(varchar(10),n.fn_vgnca,111))
              and d.cnsctvo_vgnca_mtvo_ordn_espcl = n.cnsctvo_vgnca_mtvo_ordn_espcl )


begin
     

--> Valida que el parametro a modificar sea vigente
		if  (convert(varchar(10),@dfn_vgnca,111) < convert(varchar(10),getDate(),111)  and 
                                convert(varchar(10),@inco_vgnca,111) <= convert(varchar(10),@dfn_vgnca,111) and
                                convert(varchar(10),@fn_vgnca,111) >=  convert(varchar(10),@dinco_vgnca,111)  )
		    	 begin
				Drop Table #tbValoresAnteriores
				Drop Table #tbValoresNuevos
  				ROLLBACK TRANSACTION
				select @cdgo_mtvo_ordn_espcl  =  'Error,  No se puede Modificar la Vigencia de un Parámetro no Vigente'
				RAISERROR (999909, 16, 1, @cdgo_mtvo_ordn_espcl)
				RETURN
		                end
--> Valida que si el parametro es vigente no pueda incrementar inicio vigencia
			if convert(varchar(10),@dfn_vgnca,111) >=convert(varchar(10),getDate(),111)  and 
                           	     	convert(varchar(10),@dinco_vgnca,111)<=convert(varchar(10),getDate(),111)  and
				convert(varchar(10),@dinco_vgnca,111) <  convert(varchar(10),@inco_vgnca,111) and
				convert(varchar(10),@inco_vgnca,111) <  convert(varchar(10),@dfn_vgnca,111)					
				begin 
					Drop Table #tbValoresAnteriores
					Drop Table #tbValoresNuevos
					ROLLBACK TRANSACTION
					select @cdgo_mtvo_ordn_espcl  =  'Error, No se permite Incrementar el Inicio de Vigencia de un Parámetro Vigente '
					RAISERROR (999908, 16, 1, @cdgo_mtvo_ordn_espcl)
					RETURN
 				end
	

-->Valida que el fin de vigencia no sea inferior a fecha actual  para un parametro vigente
	 if  convert(varchar(10),@dfn_vgnca,111) >=convert(varchar(10),getDate(),111)  and 
      				   convert(varchar(10),@fn_vgnca,111) <  convert(varchar(10),getDate(),111) and
                  convert(varchar(10),@dinco_vgnca,111) < =convert(varchar(10),@fn_vgnca,111)  
			
				begin 
					Drop Table #tbValoresAnteriores
					Drop Table #tbValoresNuevos
					ROLLBACK TRANSACTION
					select @cdgo_mtvo_ordn_espcl  =  'Error, El  Fin de Vigencia debe ser Superior  a  la Fecha Actual para un Parámetro Vigente '
					RAISERROR (999907, 16, 1, @cdgo_mtvo_ordn_espcl)
					RETURN
 				end
-->Se Calcula si hay  traslape de fechas
	SELECT @contador=count(*)
	FROM  tbMotivoOrdenEspecial_Vigencias p
	WHERE ( (convert(varchar(10),p.inco_vgnca,111)  >= convert(varchar(10),@inco_vgnca,111) 
	And	convert(varchar(10),p.inco_vgnca,111)  <= convert(varchar(10),@fn_vgnca,111))   Or
		(convert(varchar(10),p.fn_vgnca,111)    >= convert(varchar(10),@inco_vgnca,111) 
	And	 convert(varchar(10),p.fn_vgnca,111)    <= convert(varchar(10),@fn_vgnca,111))   Or
		(convert(varchar(10),p.inco_vgnca,111)  <= convert(varchar(10),@inco_vgnca,111) 
	And	convert(varchar(10),p.fn_vgnca,111)     >= convert(varchar(10),@fn_vgnca,111)))  
	And	p.cnsctvo_cdgo_mtvo_ordn_espcl = @Codigo_Consecutivo
    
	IF @contador > 1
-->Hay traslape de fechas
	Begin
		SELECT @tinco_vgnca=inco_vgnca,@tfn_vgnca=fn_vgnca
		FROM tbMotivoOrdenEspecial_Vigencias p
		WHERE ( (convert(varchar(10),p.inco_vgnca,111)  >= convert(varchar(10),@inco_vgnca,111) 
		And	convert(varchar(10),p.inco_vgnca,111)  <= convert(varchar(10),@fn_vgnca,111))   Or
			(convert(varchar(10),p.fn_vgnca,111)    >= convert(varchar(10),@inco_vgnca,111) 
		And	 convert(varchar(10),p.fn_vgnca,111)    <= convert(varchar(10),@fn_vgnca,111))   Or
		(convert(varchar(10),p.inco_vgnca,111)  <= convert(varchar(10),@inco_vgnca,111) 
		And	convert(varchar(10),p.fn_vgnca,111)     >= convert(varchar(10),@fn_vgnca,111)))  
		And	p.cnsctvo_cdgo_mtvo_ordn_espcl = @Codigo_Consecutivo
  	      	and       p.cnsctvo_vgnca_mtvo_ordn_espcl != @cnsctvo_vgnca

		Drop Table #tbValoresAnteriores
		Drop Table #tbValoresNuevos
		ROLLBACK TRANSACTION
		select @cdgo_mtvo_ordn_espcl  =  'Error, Insertando, Existe  Traslape con  '+  convert(varchar(10),@tinco_vgnca,111) + '  ' + convert(varchar(10),@tfn_vgnca,111)
		RAISERROR (999905, 16, 1, @cdgo_mtvo_ordn_espcl)
		RETURN
	End


end

End













GO





/*---------------------------------------------------------------------------------
* Nombre		: TrValidaVigencias_tbMotivoOrdenEspecial_Vigencias
* Desarrollado por	: <\A Ing. Maribel Valencia Herrera				A\>
* Descripcion		: <\D Valida que no se traslape  la Vigencia Nueva con Alguna existente para el mismo parametro D\>
* Observaciones		: <\O		O\>
* Parametros		: <\P   P\>
* Variables		: <\V	Fecha Inicial Nueva					V\>
*			: <\V   Fecha Final Nueva					V\>
*			: <\V   Fecha Inicial Traslape					V\>
*			: <\V   Fecha Final Traslape					V\>
*			: <\V   Mensaje de Error					V\>
*			: <\V   Contador  de registros					V\>
*			: <\V   Consectivo del Parametro Nuevo			V\>
*			: <\V   Codigo del Parametro Nuevo				V\>
*			: <\V   Consecutivo de la Vigencia				V\>
*			: <\V   Descripción del parámetro Nuevo			V\>
* Fecha Creacion	: <\FC 2003/03/20				FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM  AM\>
* Descripcion		: <\DM  DM\>
* Nuevos Parametros	: <\PM  PM\>
* Nuevas Variables	: <\VM  VM\>
* Fecha Modificacion	: <\FM  FM\>
-----------------------------------------------------------------------------------*/
CREATE TRIGGER  [dbo].[TrValidaVigencias_tbMotivoOrdenEspecial_Vigencias] ON   [dbo].[tbMotivoOrdenEspecial_Vigencias]
FOR  INSERT, update
AS
Begin
	DECLARE	@inco_vgnca	datetime,     
		@fn_vgnca	datetime,      
		@tinco_vgnca	datetime,     
		@tfn_vgnca	datetime,      
		@mnsje		varchar(400), 
		@contador	int,
		@Codigo_Consecutivo	udtCodigo,
	  	@cdgo_ara		udtcodigo,
		@cdgo_vgnca		udtconsecutivo,
		@dscrpcn		udtDescripcion


-->Se capturan las variables que se estan tratando de insertar
SELECT	@inco_vgnca 		= inco_vgnca,
	@fn_vgnca		= fn_vgnca,
	@Codigo_Consecutivo 	= cnsctvo_cdgo_mtvo_ordn_espcl	,
	@cdgo_ara 		= cdgo_mtvo_ordn_espcl		,
	@cdgo_vgnca		= cnsctvo_vgnca_mtvo_ordn_espcl,
	@dscrpcn 		= dscrpcn_mtvo_ordn_espcl
FROM   INSERTED

	
IF @inco_vgnca > @fn_vgnca
          
	Begin   

	
		ROLLBACK TRANSACTION
		select @mnsje  =  'Error, el fin de vigencia no puede ser inferior al inicio de vigencia  '+  convert(varchar(10),@inco_vgnca,111) + '  ' + convert(varchar(10),@fn_vgnca,111)
		RAISERROR (999909, 16, 1, @mnsje)
		RETURN
	End


End




GO
GRANT SELECT
    ON OBJECT::[dbo].[tbMotivoOrdenEspecial_Vigencias] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbMotivoOrdenEspecial_Vigencias] TO [webusr]
    AS [dbo];

