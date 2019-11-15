


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :  	fnCalculallave
* Desarrollado por		 :  <\A    Ing. Angela Sandoval									A\>
* Descripcion			 :  <\D  Devuelve una cadena de los campos de una tabla sin el tme_stmp					D\>
* Observaciones		              :  <\O													O\>
* Parametros			 :  <\P 	Nombre de la Tabla  										P\>
*				    <\P	Ejemplo 'bdAfiliacion..tbFormularios'								P\>
* Fecha Creacion		 :  <\FC  2003/19/02											FC\>
*  
*---------------------------------------------------------------------------------*/
/*declare @lcwhere nvarchar(255)  
select @lcwhere=''
select 	@lcwhere= dbo.fnCalculallave (1342627826)  
print   @lcwhere*/
-- me devuelve un and al final el cual debe ser extraido
CREATE function dbo.fnCalculaCamposSelect  (@idtabla int)
Returns  nvarchar(2000)  
As  
Begin
       declare @name          nvarchar(50),
                   @campos        nvarchar(2000)

	select @campos=''



--------------------------------------------------------
-- se crea el cursor con los campos que se van a insertar

	select @campos = ''
	declare  crcampos cursor for
	select b.name as columna
	from dbo.sysobjects a,dbo. syscolumns b 
	where  a.id = @idtabla and a.id=b.id 
	and b.name!='tme_stmp'
 
	OPEN crcampos
	FETCH NEXT FROM crcampos
	INTO @name

	WHILE @@FETCH_STATUS = 0
	BEGIN
	   select @campos=@campos + rtrim(ltrim(@name))+','
	   FETCH NEXT FROM crcampos 
	   INTO @name
	END

	select @campos=substring(@campos,1,len(@campos)-1)

	CLOSE crcampos
	DEALLOCATE crcampos

	Return(@campos)
end








GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaCamposSelect] TO [AdminScripts_Cambios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaCamposSelect] TO [Auditor Central Notificaciones]
    AS [dbo];

