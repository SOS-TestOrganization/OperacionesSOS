


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
CREATE function dbo.fnCalculallave  (
@idtabla int)

returns  @tempLlaves table  (
	lcllave              nvarchar(500),
	lcclave             nvarchar(1000),
	lccampoclave  nvarchar(500)
)

As  
Begin
       declare @lcllave       nvarchar(500),
	       @lcwhere       nvarchar(500),
	       @name          nvarchar(50),
	       @lccampoclave  nvarchar(500),
	       @lcclave       nvarchar(1000)


	select @lcwhere=''
	select @lcllave=''
	select @lcclave=''   -- Contiene la misma informacion de @lcwhere sin el AND al final
	select @lccampoclave =''

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
		select @lcllave=@lcllave+'a.'+rtrim(ltrim(@name))+ ','
		select @lccampoclave = rtrim(ltrim(@name))  -- En este campo queda  un campo qeu sirve de comodin para revisar cuales registros se han adicionado
	        FETCH NEXT FROM crwhere 
	        INTO @name 
               end
	select @lcllave=substring(@lcllave,1,len(@lcllave)-1)
	select @lcclave=substring(@lcwhere,1,len(@lcwhere)-3)
	CLOSE crwhere
	DEALLOCATE crwhere
	INSERT @tempLlaves (lcllave,lcclave,lccampoclave) 
	VALUES (@lcllave,@lcclave,@lccampoclave) 

	Return--(@lcllave)
End




