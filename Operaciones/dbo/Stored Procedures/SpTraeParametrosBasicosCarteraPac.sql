/*---------------------------------------------------------------------------------
* Metodo o PRG		:  SpTraeParametrosBasicosCarteraPac
* Desarrollado por	: <\A Ing. Rolando Simbaqueva							A\> 
* Descripcion		: <\D Trae un cursor con los registros de la tabla que se pasa como parametro	D\>
* Observaciones		: <\O										O\>
* Parametros		: <\P Nombre    de  la    Tabla							P\>
			: <\P Codigo de la tabla  a traer							P\>
			: <\P Caracteres ingresados por el usuario para realizar la busqueda		P\>
			: <\P Fecha a la cual se valida la vigencia						P\>
* Variables		: <\V Instruccion Sql  a ejecutar							V\>
			: <\V Parmetros que condicionan la consulta					V\>
			: <\V Fecha que se convierte de date a caracter					V\>
			* Fecha Creacion: <\FC 2002/06/21						FC\>
*
*--------------------------------------------------------------------------------- 
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  FM\>
*---------------------------------------------------------------------------------*/
CREATE         PROCEDURE SpTraeParametrosBasicosCarteraPac  

			@Consecutivo			UdtConsecutivo	= NULL,
			@NombreTabla			Char(80),
			@CadenaSeleccion		Char(20)	= NULL,
			@ldFechaReferencia		Datetime	= NULL,
			@Codigo			Char(20)	= NULL
 
AS    Declare
			@Instruccion			Nvarchar(2000),
			@Parametros			Nvarchar(1000),
			@lcFechaReferencia		Char(8),
			@Id_tabla			Int,
			@nmro_clmns			Int,
			@contador			Int,
			@bse_dts			varchar(50)	

  
Set Nocount On

--Nuevo Se asigna la fecha de vigencia, dado que siempre debe ir a buscar en la tabla de parametros_Vigencias
If  @ldFechaReferencia  Is Null
	Set @ldFechaReferencia = GetDate()

Set 	@NombreTabla = ltrim(rtrim(@NombreTabla)) + '_Vigencias '

                                                -- Se eliminan los especios del parametro
Set   	@CadenaSeleccion  =     ltrim(rtrim(@CadenaSeleccion))  

                                                 --Se empieza a formar el script de consulta 
Set    	@Instruccion            =     'Select  '+  	COL_NAME(OBJECT_ID(@NombreTabla),3)+','+
						COL_NAME(OBJECT_ID(@NombreTabla),4)+','+
						COL_NAME(OBJECT_ID(@NombreTabla),5)+','+
						COL_NAME(OBJECT_ID(@NombreTabla),6)+','+
						COL_NAME(OBJECT_ID(@NombreTabla),7)+','+
						COL_NAME(OBJECT_ID(@NombreTabla),8)+','+
						COL_NAME(OBJECT_ID(@NombreTabla),9)+','+
						COL_NAME(OBJECT_ID(@NombreTabla),10)+','+
						COL_NAME(OBJECT_ID(@NombreTabla),11)+','+
						COL_NAME(OBJECT_ID(@NombreTabla),2)+
 '  From  '+rtrim(ltrim(@NombreTabla))+'  Where '

If @Consecutivo is Null And @Codigo is Null
Begin
  	If  (@CadenaSeleccion  != '+')    and  Not (@CadenaSeleccion is Null)
	Begin
	
                           --Se concatena el  script  con el nombre de  la columna que hace referencia  numero de identificacion de la tabla para formar
                           --la condicion de búsquedad con la clausula Like
	              Set @Instruccion    = @Instruccion + COL_NAME(OBJECT_ID(@NombreTabla),4)+'  Like   ' + Char(39)+  '%'+  ltrim(rtrim(@CadenaSeleccion)) +  '%'  +  Char(39)+  '    And '
	End
End
Else
Begin
	If @Codigo is Not Null
	Begin
		--Se concatena la instruccion igualando el campo del codigo al parametro
		Set @Instruccion    =  @Instruccion +  COL_NAME(OBJECT_ID(@NombreTabla),3)+' = ' +  char(39)+ ltrim(rtrim(@Codigo)) + char(39) + '  And '
	End
	Else
	Begin
		--Se concatena la instruccion igualando el campo del consecutivo al parametro
		Set @Instruccion    =  @Instruccion +  COL_NAME(OBJECT_ID(@NombreTabla),2)+' = ' +  char(39)+ ltrim(rtrim(@Consecutivo)) + char(39) + '  And '
	End
End

--If  @ldFechaReferencia  Is Not  Null
--Begin
		--Si  es una fecha determinada,  esta se convierte  a  texto.
	             Set @lcFechaReferencia   =   rtrim(ltrim(convert(Char(8),@ldFechaReferencia,112)))

                          --Se concatena  la condición    con la fecha  que se encuentre en un rango vigente
	             Set @Instruccion                 =   @Instruccion + '(' + Char(39)+ @lcFechaReferencia + Char(39)+ ' Between ' + COL_NAME(OBJECT_ID(@NombreTabla),5) + '  And ' + COL_NAME(OBJECT_ID(@NombreTabla),6)+ ')'+ '  And '
--End


-- Selecciona el numero que identifica la tabla
Select	@Id_tabla = Id 
From	Sysobjects
Where	ltrim(rtrim(name)) = ltrim(rtrim(@NombreTabla))

-- Selecciona el numero de columnas que posee la tabla
Select	@nmro_clmns = count(*)
From	Syscolumns
Where	Id = @Id_tabla


Select	@contador = 1

While	@contador <= @nmro_clmns
Begin
--	If COL_NAME(OBJECT_ID(@NombreTabla),@contador) = 'Brrdo'
--	Begin
		-- Se  adiciona  a   la cadena    la  validacion  del  campo  borrado que sea igual a 'N'
--		Set    @Instruccion    =  @Instruccion  + COL_NAME(OBJECT_ID(@NombreTabla),@contador)+  ' = '+ Char(39)+ 'N' +Char(39)
--	End
	If COL_NAME(OBJECT_ID(@NombreTabla),@contador) = 'vsble_usro'
	Begin 
		-- Se  adiciona  a   la cadena    la  validacion d el  campo  visible usuario que sea igual a 'S' en el caso de que la tabla lo tenga
		Set    @Instruccion    =  @Instruccion   + COL_NAME(OBJECT_ID(@NombreTabla),@contador)+ ' =  '+ Char(39)+ 'S' +Char(39)
	End
	
	Select @contador = @contador + 1
End	
Exec  Sp_executesql     @Instruccion