CREATE TABLE [dbo].[tbEstadosPromotor_Vigencias] (
    [cnsctvo_vgnca_estdo_prmtr] [dbo].[udtConsecutivo] NULL,
    [cnsctvo_cdgo_estdo_prmtr]  [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_estdo_prmtr]          [dbo].[udtCodigo]      NOT NULL,
    [dscrpcn_estdo_prmtr]       [dbo].[udtDescripcion] NOT NULL,
    [inco_vgnca]                DATETIME               NOT NULL,
    [fn_vgnca]                  DATETIME               NOT NULL,
    [fcha_crcn]                 DATETIME               NOT NULL,
    [usro_crcn]                 [dbo].[udtUsuario]     NOT NULL,
    [obsrvcns]                  [dbo].[udtObservacion] NOT NULL,
    [vsble_usro]                [dbo].[udtLogico]      NOT NULL,
    [tme_stmp]                  ROWVERSION             NOT NULL,
    CONSTRAINT [PK_TbEstadosPromotor] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_estdo_prmtr] ASC),
    CONSTRAINT [CKFinVigenciaMayorInicioVigencia_tbEstadosPromotor_Vigencias] CHECK ([fn_vgnca] >= [inco_vgnca]),
    CONSTRAINT [FK_tbEstadosPromotor_Vigencias_tbEstadosPromotor] FOREIGN KEY ([cnsctvo_cdgo_estdo_prmtr]) REFERENCES [dbo].[tbEstadosPromotor] ([cnsctvo_cdgo_estdo_prmtr]) ON DELETE CASCADE
);


GO
/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Nombre		: TrCodigosEspeciales_tbEstadosPromotor_Vigencias
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
CREATE TRIGGER [dbo].[TrCodigosEspeciales_tbEstadosPromotor_Vigencias]
ON  [dbo].[tbEstadosPromotor_Vigencias]
FOR  UPDATE, DELETE 
AS 

Declare	@lcLongitud 	TinyInt,
	@lcCodigov 	Varchar(30), 
	@lcCodigoi 	Varchar(30),
	@lcTexto 	Varchar (120)

Set	@lcCodigov ='0'
Set	@lcCodigoi ='9'

Select	@lcLongitud = (COL_LENGTH('tbEstadosPromotor_Vigencias ','cdgo_estdo_prmtr')) - 1

While	@lcLongitud > 0 
Begin
	Set	@lcCodigov = @lcCodigov + '0'
	Set	@lcCodigoi = @lcCodigoi + '9'
  	Set	@lcLongitud = @lcLongitud - 1
End

Set NoCount On

If	Exists (	Select * From Deleted 
		Where cdgo_estdo_prmtr = @lcCodigov  Or  cdgo_estdo_prmtr =  @lcCodigoi)
Begin
	RollBack Transaction
	Select		@lcTexto ='Error, Los registros con códigos '+@lcCodigov+' ó '+@lcCodigoi+' no pueden ser actualizados ni borrados.'
	RAISERROR (999904, 16, 1,  @lcTexto)
	Return	
End




GO

/*---------------------------------------------------------------------------------
* Nombre		: TrValidaTraslapeCodigo_tbEstadosPromotor_Vigencias
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
CREATE TRIGGER  [dbo].[TrValidaTraslapeCodigo_tbEstadosPromotor_Vigencias] ON   [dbo].[tbEstadosPromotor_Vigencias]
FOR  INSERT
AS
Begin

SET NOCOUNT ON
	DECLARE	@inco_vgnca		datetime,     
			@fn_vgnca		datetime,      
			@tinco_vgnca		datetime,     
			@tfn_vgnca		datetime,      
			@mnsje			varchar(400), 
			@contador		int,
			@Codigo_Consecutivo	udtConsecutivo,
		  	@cdgo_ara		char(4),
			@cdgo_vgnca		udtConsecutivo,
			@dscrpcn		udtDescripcion


-->Se capturan las variables que se estan tratando de insertar
SELECT	@inco_vgnca = inco_vgnca,
		@fn_vgnca	= fn_vgnca,
		@Codigo_Consecutivo = cnsctvo_cdgo_estdo_prmtr	,
		@cdgo_ara = cdgo_estdo_prmtr		,
		@cdgo_vgnca	= cnsctvo_vgnca_estdo_prmtr,
		@dscrpcn =  dscrpcn_estdo_prmtr
FROM   INSERTED

	
-->Se Calcula si hay  traslape de fechas
	SELECT @contador = count(*)
	FROM  tbEstadosPromotor_Vigencias p
	WHERE ( (convert(varchar(10),p.inco_vgnca,111)  >= convert(varchar(10),@inco_vgnca,111) 
	And	convert(varchar(10),p.inco_vgnca,111)  <= convert(varchar(10),@fn_vgnca,111))   Or
		(convert(varchar(10),p.fn_vgnca,111)    >= convert(varchar(10),@inco_vgnca,111) 
	And	 convert(varchar(10),p.fn_vgnca,111)    <= convert(varchar(10),@fn_vgnca,111))   Or
		(convert(varchar(10),p.inco_vgnca,111)  <= convert(varchar(10),@inco_vgnca,111) 
	And	convert(varchar(10),p.fn_vgnca,111)     >= convert(varchar(10),@fn_vgnca,111)))  
	And	p.cnsctvo_cdgo_estdo_prmtr = @Codigo_Consecutivo

-->Hay traslape de fechas

	IF @contador > 1
          
	Begin   

-->Para Indicar al usuario contra que fecha hay traslape
		SELECT @tinco_vgnca = inco_vgnca,@tfn_vgnca = fn_vgnca
		FROM  tbEstadosPromotor_Vigencias p
		WHERE ( (convert(varchar(10),p.inco_vgnca,111)  >= convert(varchar(10),@inco_vgnca,111) 
		And	convert(varchar(10),p.inco_vgnca,111)  <= convert(varchar(10),@fn_vgnca,111))   Or
			(convert(varchar(10),p.fn_vgnca,111)    >= convert(varchar(10),@inco_vgnca,111) 
		And	 convert(varchar(10),p.fn_vgnca,111)    <= convert(varchar(10),@fn_vgnca,111))   Or
		(convert(varchar(10),p.inco_vgnca,111)  <= convert(varchar(10),@inco_vgnca,111) 
		And	convert(varchar(10),p.fn_vgnca,111)     >= convert(varchar(10),@fn_vgnca,111)))  
		And	p.cnsctvo_cdgo_estdo_prmtr =  @Codigo_Consecutivo
		and 	cnsctvo_vgnca_estdo_prmtr !=  @cdgo_vgnca	
		
		
		ROLLBACK TRANSACTION
		select @mnsje  =  'Error, Insertando, Existe  Traslape con   '+  convert(varchar(10),@tinco_vgnca,111) + '  ' + convert(varchar(10),@tfn_vgnca,111)
		RAISERROR (999905, 16, 1,  @mnsje)
		RETURN
	End

update tbEstadosPromotor set dscrpcn_estdo_prmtr =  @dscrpcn
where cnsctvo_cdgo_estdo_prmtr = @Codigo_Consecutivo

End


GO
/*---------------------------------------------------------------------------------
* Nombre		: TrValidaUpdateTraslapeCodigo_tbEstadosPromotor_Vigencias
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
CREATE TRIGGER  [dbo].[TrValidaUpdateTraslapeCodigo_tbEstadosPromotor_Vigencias] ON   [dbo].[tbEstadosPromotor_Vigencias]
FOR  UPDATE
AS
Begin

SET NOCOUNT ON
	DECLARE	@inco_vgnca		datetime,     
			@fn_vgnca		datetime,      
			@tinco_vgnca		datetime,     
			@tfn_vgnca		datetime,      
			@mnsje			varchar(400), 
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
		@Codigo_Consecutivo =  cnsctvo_cdgo_estdo_prmtr	,
		@cdgo_ara =  cdgo_estdo_prmtr		
FROM   INSERTED

-->    Se capturan las variables que se estan modificando
SELECT     @dinco_vgnca   =  inco_vgnca,
	      @dfn_vgnca     =  fn_vgnca,
     	      @dcnsctvo_tbla  =  cnsctvo_cdgo_estdo_prmtr,
	      @cnsctvo_vgnca = cnsctvo_vgnca_estdo_prmtr			     
FROM	deleted
 
-->Obtener la imagen de los registros Modificados (Deleted) e Insertados (Inserted)
select * into #tbValoresAnteriores From Deleted
select * into #tbValoresNuevos From Inserted



-->valida que los campos que se estan modificando sean los campos de fecha de vigencia 
if  Exists (select * from #tbValoresAnteriores d,  #tbValoresNuevos n
              where   (convert(varchar(10),d.inco_vgnca,111)<>convert(varchar(10),n.inco_vgnca,111)
             		or convert(varchar(10),d.fn_vgnca,111)<>convert(varchar(10),n.fn_vgnca,111))
              and d.cnsctvo_vgnca_estdo_prmtr = n.cnsctvo_vgnca_estdo_prmtr )


begin
     

--> Valida que el parametro a modificar sea vigente
		if  (convert(varchar(10),@dfn_vgnca,111) < convert(varchar(10),getDate(),111)  and 
                                convert(varchar(10),@inco_vgnca,111) <= convert(varchar(10),@dfn_vgnca,111) and
                                convert(varchar(10),@fn_vgnca,111) >=  convert(varchar(10),@dinco_vgnca,111)  )
		    	 begin
				Drop Table #tbValoresAnteriores
				Drop Table #tbValoresNuevos
  				ROLLBACK TRANSACTION
				select @mnsje  =  'Error,  No se puede Modificar la Vigencia de un Parámetro no Vigente'
				RAISERROR (999909, 16, 1,  @mnsje)
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
					select @mnsje  =  'Error, No se permite Incrementar el Inicio de Vigencia de un Parámetro Vigente '
					RAISERROR (999908, 16, 1,  @mnsje)
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
					select @mnsje  =  'Error, El  Fin de Vigencia debe ser Superior  a  la Fecha Actual para un Parámetro Vigente '
					RAISERROR (999907, 16, 1,  @mnsje)
					RETURN
 				end
-->Se Calcula si hay  traslape de fechas
	SELECT @contador=count(*)
	FROM  tbEstadosPromotor_Vigencias p
	WHERE ( (convert(varchar(10),p.inco_vgnca,111)  >= convert(varchar(10),@inco_vgnca,111) 
	And	convert(varchar(10),p.inco_vgnca,111)  <= convert(varchar(10),@fn_vgnca,111))   Or
		(convert(varchar(10),p.fn_vgnca,111)    >= convert(varchar(10),@inco_vgnca,111) 
	And	 convert(varchar(10),p.fn_vgnca,111)    <= convert(varchar(10),@fn_vgnca,111))   Or
		(convert(varchar(10),p.inco_vgnca,111)  <= convert(varchar(10),@inco_vgnca,111) 
	And	convert(varchar(10),p.fn_vgnca,111)     >= convert(varchar(10),@fn_vgnca,111)))  
	And	p.cnsctvo_cdgo_estdo_prmtr = @Codigo_Consecutivo
    
	IF @contador > 1
-->Hay traslape de fechas
	Begin
		SELECT @tinco_vgnca = inco_vgnca,@tfn_vgnca=fn_vgnca
		FROM  tbEstadosPromotor_Vigencias p
		WHERE ( (convert(varchar(10),p.inco_vgnca,111)  >= convert(varchar(10),@inco_vgnca,111) 
		And	convert(varchar(10),p.inco_vgnca,111)  <= convert(varchar(10),@fn_vgnca,111))   Or
			(convert(varchar(10),p.fn_vgnca,111)    >= convert(varchar(10),@inco_vgnca,111) 
		And	 convert(varchar(10),p.fn_vgnca,111)    <= convert(varchar(10),@fn_vgnca,111))   Or
		(convert(varchar(10),p.inco_vgnca,111)  <= convert(varchar(10),@inco_vgnca,111) 
		And	convert(varchar(10),p.fn_vgnca,111)     >= convert(varchar(10),@fn_vgnca,111)))  
		And	p.cnsctvo_cdgo_estdo_prmtr = @Codigo_Consecutivo
  	      	and       p.cnsctvo_vgnca_estdo_prmtr != @cnsctvo_vgnca

		Drop Table #tbValoresAnteriores
		Drop Table #tbValoresNuevos
		ROLLBACK TRANSACTION
		select @mnsje  =  'Error, Insertando, Existe  Traslape con  '+  convert(varchar(10),@tinco_vgnca,111) + '  ' + convert(varchar(10),@tfn_vgnca,111)
		RAISERROR (999905, 16, 1,  @mnsje)
		RETURN
	End


end
End


GO
/*--------------------------------------------------------------------------------------------------------
*Metodo o Programa	: 	TrValidaModifiVigenciasRelacion_ttbEstadosPromotor_Vigencias
* Desarrollado por	:  <\A  	  Ing. Maribel Valencia Herrera			A\>
* Descripcion		:  <\D   Valida la modificiacion  de fechas de vigencia en la tabla Parámetro	 D\>
			   <\D	tbEstadosPromotor_Vigencias contra las tablas de relación			D\>
* Observaciones		:  <\O			O\>
* Parametros		 :  <\P    		P\>
* Variables		 :  <\V	Fecha Inicio Nueva  de la Vigencia del Concepto	V\>
			:  <\V	Fecha Fin Nueva de la Vigencia del Concepto	V\>
			 :  <\V	Fecha Inicio Anterior   de la Vigencia del Concepto			V\>
			:  <\V	Fecha FinAnterior de la Vigencia del Concepto	V\>
			:  <\V	Consecutivo del concepto		   	  	V\>
			:  <\V	Nombre de la Tabla Relación				V\>
			:  <\V	Nombre de la Base de Datos				V\>
			:  <\V	Campo del parámetro en la relación			V\>
			:  <\V	Opción del Menú referente a la relación		V\>
			:  <\V	Campo del llave de  la relación			V\>
			:  <\V	Mensaje						V\>
			:  <\V	Cadena de Intruccion			   	   	V\>
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
CREATE TRIGGER [dbo].[TrValidaModifiVigenciasRelacion_tbEstadosPromotor_Vigencias] ON   [dbo].[tbEstadosPromotor_Vigencias]
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
	@mnsje  			varchar(4000), 
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
where tbla_prmtro='tbEstadosPromotor_Vigencias'

--> Se capturan las variables que se estan tratando de insertar
select  	@fcha_inco_vgnca = inco_vgnca,
	@fcha_fn_vgnca = fn_vgnca,
	@cnsctvo_tbla =  cnsctvo_cdgo_estdo_prmtr
from INSERTED

--> Se capturan los valores modificados
select  	@dinco_vgnca= inco_vgnca,
	@dfn_vgnca = fn_vgnca,
            	@cnsctvo_tbla =  cnsctvo_cdgo_estdo_prmtr
from  deleted 

-->Obtener la imagen de los registros Modificados (Deleted) e Insertados (Inserted)
select * into #tbValoresAnteriores From Deleted
select * into #tbValoresNuevos From Inserted



-->Valida que los campos que se estan modificando sean los campos de fecha de vigencia 
if  Exists (select * from #tbValoresAnteriores d,  #tbValoresNuevos n
              where   (convert(varchar(10),d.inco_vgnca,111)<>convert(varchar(10),n.inco_vgnca,111)
             		or convert(varchar(10),d.fn_vgnca,111)<>convert(varchar(10),n.fn_vgnca,111))
              and d.cnsctvo_vgnca_estdo_prmtr = n.cnsctvo_vgnca_estdo_prmtr)

begin 

	set nocount on
	set @lnsalida = 1
                set @lncontador=0
	Set @lcParametros  	= '@inco int output'
	set @lncontador1=0
	set @lnsalida1=1
	Set @lcParametros1  	= '@inco1 udtConsecutivo output'

--> Validar  si las vigencias modificadas afectan alguna relacion existente con la tabla  tbEstadosPromotor_Vigencias
	OPEN  crTablasRelacion
	FETCH NEXT FROM crTablasRelacion
	Into @lcTbla, @lccamporln,@lcBse_Dts,@lcopcion_menu,@lccampo_llave		 
	WHILE @@FETCH_STATUS = 0
	 Begin
		set nocount on
		
--> Armar la cadena para saber si existe alguna relacion en la tabla Relacion con el  codigo de la  tabla tbEstadosPromotor y las fechas modificadas
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
	     			 select @mnsje  =  'Error, Existe una  Relacion entre los Parámetros tbEstadosPromotor_Vigencias  y  ' + @lcopcion_menu	
	      	 		 RAISERROR (999901, 16, 1,  @mnsje)
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
* Nombre                 	: TrIncidencias_tbEstadosPromotor_Vigencias
* Desarrollado por	: <\A Ing. Maribel Valencia Herrera				 A\>
* DescripciÃ³n		: <\D Inserta un registro en la tabla tbEstadosPromotor_Vigencias 		D\>
* 			  <\D Cuando se actualiza un Campo de  TbEstadosPeriodo_Vigencias  D\>
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
* Modificado Por	     	: <\AM  Ing. Diana Lorena Gomez Betancourt AM\>
* Descripcion		: <\DM  Se optimizó creandolo de acuerdo a la forma definida por TRIONIK , se quito el consecutivo de incidencia ya que este en la tabla es un INDENTITY DM\>
* Nuevos Parametros	: <\PM  PM\>
* Nuevas Variables	: <\VM  VM\>
* Fecha Modificacion	: <\FM 2008/06/24 FM\>
-----------------------------------------------------------------------------------*/

CREATE TRIGGER [dbo].[TrIncidencias_tbEstadosPromotor_Vigencias]   On [dbo].[tbEstadosPromotor_Vigencias]
For  UPDATE  As

	SET NOCOUNT ON --prevenir que se retornen valores.

	--Variables para tomar el tiempo de ejecucion del codigo.
--	DECLARE @inicio DATETIME,
--		@fin	DATETIME

--	set @inicio = GETDATE()

	--Variables de configuracion de los parametros del trigger.
	DECLARE 
		@mascara_1_64			BIGINT, 	--Mascara parcial de las columnas a auditar.
		@mascara_128_65			BIGINT,		--Mascara parcial de las columnas a auditar.
		@mascara_combinada		VARBINARY(20),	--Mascara completa de las columnas a auditar.
		@columnas_modificadas 		VARBINARY(20),	--Mascara de todas las columnas que fueron modificadas.
		@nombre_tabla			VARCHAR(60) 	--Nombre de la tabla del trigger.


	--Estas varibles deben modificarse para el trigger de cada tabla y 
	--para las columna que se deseen auditar.
		
	SET @nombre_tabla	= 'bdCarteraPac.DBO.tbEstadosPromotor_Vigencias'
	SET @mascara_1_64 	=  0x0000000000003000   --de derecha a izquierda: 0010000000000000010000001011100001111101000010000000000000100000
	SET @mascara_128_65 	=   0x0000000000000000           --de izquierda a derecha
	SET @mascara_combinada	=   0x3000          

							 
							 
	SET @columnas_modificadas = COLUMNS_UPDATED() --no debe modificarse, dejar asi.

	--Evalua si alguna de las columnas de auditoria fue modificada.
	--de lo contrario, el trigger no hace nada y termina.
	IF (BDSeguridad.DBO.fnExistenModificaciones(@columnas_modificadas, @mascara_1_64, @mascara_128_65) = 1)
	BEGIN
		--Variables del algoritmo
		DECLARE	@indice_byte 	TINYINT, 	--indice del byte actual que se esta evaluando.
			@id_columna 	TINYINT,	--colid de la columna que se esta evaluando
			@id_tabla 		INT, 		--id de la tabla
			@num_bytes		TINYINT

		--Variables de informacion de la incidencia
		DECLARE	@lcFechaIncidencia	VARCHAR(30),
			@lcCampo 		VARCHAR(60),
			@lcUsuario 		VARCHAR(60),
			@lnLinea		CHAR(01)
		
		--> Inicializacion de las variables del algoritmo.
		SET @indice_byte = 1
		SET @id_columna	= 1
		SET @id_tabla 	= OBJECT_ID(@nombre_tabla) --almacena el id de la tabla para utilizarlo en las consultas.
		SET @num_bytes	= DATALENGTH(@mascara_combinada)
		
		--> Obtener Fecha y @lcUsuario de la incidencia
		SET @lcFechaIncidencia	= CONVERT(VARCHAR(30),GetDate(),120)
		SET @lcUsuario		= SYSTEM_USER
		SET @lnLinea 		= '0'

		--Recorre los bytes que representan el numero total de columnas.
		WHILE @indice_byte <= @num_bytes
		BEGIN
			DECLARE @num_bit 	TINYINT,--Contador de bits.
				@auditar 	SMALLINT,	--
				@potencia 	SMALLINT	--Representa los bits de cada byte en el rango de 0 a 7,
										--Evita realizar multiplicacione y potencias en el codigo.

			--Inicializacion de variables del algoritmo.
			--Estas variables se inicializan por cada iteracion
			--debido a que se utilizan para recorrer los bits de cada byte.
			SET @num_bit 	= 0
			SET @potencia  	= 1
			SET @auditar = SUBSTRING(@columnas_modificadas, @indice_byte, 1) & 
					CAST(SUBSTRING(@mascara_combinada, @indice_byte, 1) AS SMALLINT)

			WHILE @num_bit < 8
			
			BEGIN
				IF (@auditar & @potencia != 0)
				BEGIN
					SELECT 	@lcCampo = name FROM syscolumns
					WHERE 	id = @id_tabla AND colid = @id_columna

					IF @id_columna = 5
						INSERT INTO [bdCarteraPac].[dbo].[tbIncidenciasCarteraPac] (
							 bse_dts, nmbre_tbla, nmbre_cmpo, 
							cnsctvo_vgnca, vlr_antrr, vlr_nvo,
							usro_incdnca, fcha_incdnca, cnsctvo_rgstro_afctdo
						)SELECT 'bdCarteraPac', 'tbEstadosPromotor_Vigencias',@lcCampo,
						d.cnsctvo_vgnca_estdo_prmtr, d.inco_vgnca, n.inco_vgnca,
						@lcUsuario,  @lcFechaIncidencia , d.cnsctvo_cdgo_estdo_prmtr
							FROM 	deleted d, inserted n 
						 WHERE 	d.cnsctvo_cdgo_estdo_prmtr = n.cnsctvo_cdgo_estdo_prmtr AND 
							(
							 (
							(d.inco_vgnca <> n.inco_vgnca And d.inco_vgnca Is Not Null	And n.inco_vgnca Is Not Null)	Or
							 (d.inco_vgnca Is Null And n.inco_vgnca Is Not Null) Or 
							 (n.inco_vgnca Is Null And d.inco_vgnca is Not null))
							)
							
					ELSE 	IF @id_columna = 6
						INSERT INTO [bdCarteraPac].[dbo].[tbIncidenciasCarteraPac] (
							 bse_dts, nmbre_tbla, nmbre_cmpo, 
							cnsctvo_vgnca, vlr_antrr, vlr_nvo,
							usro_incdnca, fcha_incdnca, cnsctvo_rgstro_afctdo
						)SELECT 'bdCarteraPac', 'tbEstadosPromotor_Vigencias',@lcCampo,
						d.cnsctvo_vgnca_estdo_prmtr, d.fn_vgnca, n.fn_vgnca,
						@lcUsuario,  @lcFechaIncidencia , d.cnsctvo_cdgo_estdo_prmtr
							FROM 	deleted d, inserted n 
						 WHERE 	d.cnsctvo_cdgo_estdo_prmtr = n.cnsctvo_cdgo_estdo_prmtr AND 
							(
							 (
							(d.fn_vgnca <> n.fn_vgnca And d.fn_vgnca Is Not Null	And n.fn_vgnca Is Not Null)	Or
							 (d.fn_vgnca Is Null And n.fn_vgnca Is Not Null) Or 
							 (n.fn_vgnca Is Null And d.fn_vgnca is Not null))
							)
							END
							
				SET @num_bit = @num_bit + 1
				SET @id_columna = @id_columna + 1
				SET @potencia = @potencia + @potencia
			END--Fin del Ciclo
			SET @indice_byte = @indice_byte + 1
		END--Fin del Ciclo	
	END --Fin IF

--	SET @fin = GETDATE()
--	INSERT INTO tiempos(duracion, fecha, usuario, tabla) VALUES (datediff(ms, @inicio, @fin), getdate(), SYSTEM_USER,@nombre_tabla)


GO


/*---------------------------------------------------------------------------------
* Nombre                 	: TrReferencia_tbEstadosPromotor_Vigencias
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
CREATE TRIGGER  [dbo].[TrReferencia_tbEstadosPromotor_Vigencias_usro_crcn]    ON    [dbo].[tbEstadosPromotor_Vigencias]
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

