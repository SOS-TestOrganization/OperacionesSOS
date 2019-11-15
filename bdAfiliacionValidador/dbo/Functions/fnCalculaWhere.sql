


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
CREATE function dbo.fnCalculaWhere  (@idtabla int)
Returns  nvarchar(1000)  
As  
Begin
       declare  @lcwhere       nvarchar(1000),
	       @name          nvarchar(50)


	select @lcwhere=''

-- Se obtienen todo los campos de la tabla
	DECLARE crwhere CURSOR FOR 
	SELECT     dbo.syscolumns.name
	FROM       dbo.syscolumns INNER JOIN
	           dbo.sysindexkeys ON dbo.syscolumns.id = dbo.sysindexkeys.id AND dbo.syscolumns.colid = dbo.sysindexkeys.colid
	WHERE     (dbo.syscolumns.id = @idtabla and dbo.sysindexkeys.indid=1)

	OPEN crwhere
	FETCH NEXT FROM crwhere 
	INTO @name
	WHILE @@FETCH_STATUS = 0
		BEGIN
		select @lcwhere=@lcwhere+'a.'+rtrim(ltrim(@name))+'='+'b.'+rtrim(ltrim(@name))+'  and'+' ' 
	        FETCH NEXT FROM crwhere 
	        INTO @name 
               end
	CLOSE crwhere
	DEALLOCATE crwhere

	Return(@lcwhere)
End





GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaWhere] TO [AdminScripts_Cambios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaWhere] TO [Auditor Central Notificaciones]
    AS [dbo];

