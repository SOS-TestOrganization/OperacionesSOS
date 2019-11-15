


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :  	fnCampostabla
* Desarrollado por		 :  <\A    Ing. Alexander Yela Reyes									A\>
* Descripcion			 :  <\D  Devuelve una cadena de los campos de una tabla sin el tme_stmp					D\>
* Observaciones		              :  <\O													O\>
* Parametros			 :  <\P 	Nombre de la Tabla  										P\>
*				    <\P	Ejemplo 'bdAfiliacion..tbFormularios'								P\>
* Fecha Creacion		 :  <\FC  2003/19/02											FC\>
*  
*---------------------------------------------------------------------------------*/

CREATE function dbo.fnCampostabla  (@NombreTabla char(70),@alias char(2)=null)
RETURNS nvarchar(4000)  AS  
BEGIN 
declare @cntdd_clmns 	int,
	@lcIdColumna	Int, 
	@lcCampo 	char(100),
	@lcString 	nVarChar(4000)
if @alias is null or @alias =''
	set @alias =''
else 
	set @alias =rtrim(ltrim(@alias))+'.' 

Select	@cntdd_clmns = count(*)
From	Syscolumns
Where	Id = Object_Id(@NombreTabla)


Declare crCamposParametro Cursor For
Select name,colid 
From Syscolumns 
Where	id 	= Object_Id(@NombreTabla)
--And 	colid 	!= @cntdd_clmns
Order by colid

Open crCamposParametro
Fetch Next From crCamposParametro
Into @lcCampo, @lcIdColumna
SET @lcString =''

-->Recorrer el cursor de los Campos del parámetro para determinar las columnas 
-->actualizadas e Insertar el Registro correspondiente en tbIncidenciasParametros
While @@Fetch_Status = 0
Begin
    	--Armar la cadena de Inserción del registro de la incidencia
	If ltrim(rtrim(@lcCampo))!='tme_stmp' 
		Begin 
			Select @lcString = rtrim(ltrim(@lcString))+rtrim(@alias)+rtrim(@lcCampo)+',' 
		End 


	
	--Ejecutar Cadena de Inserción
        Fetch Next From crCamposParametro
   	Into @lcCampo, @lcIdColumna
  End--Fin del Ciclo
Select @lcString	=	substring(@lcString,1,len(rtrim(ltrim(@lcString)))-1) 
Close crCamposParametro
Deallocate crCamposParametro

 RETURN ( @lcString )
END















GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCampostabla] TO [AdminScripts_Cambios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCampostabla] TO [Auditor Central Notificaciones]
    AS [dbo];

