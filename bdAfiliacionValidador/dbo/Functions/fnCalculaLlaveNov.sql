


/*declare @lcwhere nvarchar(255)  
select @lcwhere=''
select 	@lcwhere= dbo.fnCalculaLlaveNov ('tbBeneficiariosValidador','tbNovTipo3')  
print   @lcwhere*/
-- me devuelve un and al final el cual debe ser extraido

/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :  	fnCalculaLlaveNov
* Desarrollado por		 :  <\A    Ing. María Fernanda Giraldo									A\>
* Descripcion			 :  <\D  Devuelve la cadena where para aplicar novedades							D\>
* Observaciones		              :  <\O													O\>
* Parametros			 :  <\P 	Nombre de la Tabla original y nombre de la tabla que tiene las novedades				P\>
*				    <\P													P\>
* Fecha Creacion		 :  <\FC  2003/10/10											FC\>
*  
*---------------------------------------------------------------------------------*/
CREATE function dbo.fnCalculaLlaveNov  (@table1 varchar(128), @table2 varchar(128))

returns  @tempLlaves table  (
	lcclave              nvarchar(500),
	lccampoclave  nvarchar(1000),
	lccampo	nvarchar(500),
	lcclave2	nvarchar(500)
)

As  

Begin
	
	declare	@idtabla1	int,
		@idtabla2	int,
		@lcllave	nvarchar(500),
		@lcwhere	nvarchar(500),
		@name1	nvarchar(50),
		@name2	nvarchar(50),
		@lccampoclave	nvarchar(500),
		@lcclave	nvarchar(1000),
		@lccampo	nvarchar(500),
		@lcclave2	nvarchar(500)
	
	--set	@table1 = 'tbBeneficiariosValidador'
	--set	@table2 = 'tbNovTipo3'
	
	select	@idtabla1 = a.id
	from	sysobjects a
	where  	 a.type	= 'U' 	and 
		 a.name	= @table1
	
	select	@idtabla2 = a.id
	from	sysobjects a
	where  	 a.type	= 'U' 	and 
		 a.name	= @table2
	
	DECLARE @temp1 TABLE
		(name		nvarchar(128),
		 colid		int
		)
	
	DECLARE @temp2 TABLE
		(name		nvarchar(128),
		 colid		int
		)
	
	insert into @temp1
	SELECT     dbo.syscolumns.name, dbo.syscolumns.colid
	FROM       dbo.syscolumns INNER JOIN
	           dbo.sysindexkeys ON dbo.syscolumns.id = dbo.sysindexkeys.id AND dbo.syscolumns.colid = dbo.sysindexkeys.colid
	WHERE     (dbo.syscolumns.id = @idtabla1 and dbo.sysindexkeys.indid=1)
	
	insert into @temp2
	SELECT    dbo.syscolumns.name, dbo.syscolumns.colid - 3 as colid
	FROM       dbo.syscolumns INNER JOIN
	           dbo.sysindexkeys ON dbo.syscolumns.id = dbo.sysindexkeys.id AND dbo.syscolumns.colid = dbo.sysindexkeys.colid
	WHERE     (dbo.syscolumns.id = @idtabla2 and dbo.sysindexkeys.indid=1)
			and name != 'cmpo'
			and name != 'cnsctvo_prcso'
	
	select @lcwhere=''
	--select @lcllave=''
	select @lcclave=''   -- Contiene la misma informacion de @lcwhere sin el AND al final
	select @lccampoclave =''
	select @lccampo = ''
	select @lcclave2 = ''
	
	DECLARE crwhere CURSOR FOR 
	select	a.name, b.name
	from	@temp1 a,
		@temp2 b
	where	a.colid = b.colid
	
	OPEN crwhere
	FETCH NEXT FROM crwhere 
	INTO @name1, @name2
	WHILE @@FETCH_STATUS = 0
	BEGIN
		select @lcwhere=@lcwhere+'a.'+rtrim(ltrim(@name1))+'='+'b.'+rtrim(ltrim(@name2))+'  and'+' ' 
		select @lcclave2=@lcclave2+'a.'+rtrim(ltrim(@name2))+'='+'b.'+rtrim(ltrim(@name1))+'  and'+' ' 
		select @lccampoclave = @lccampoclave + 'b.' + rtrim(ltrim(@name2)) + ','
		select @lccampo = rtrim(ltrim(@name1)) 
	        FETCH NEXT FROM crwhere 
	        INTO @name1, @name2 
	end

	CLOSE crwhere
	DEALLOCATE crwhere

	if isnull(@lcwhere,'') != ''
	begin
		select @lcclave = substring(ltrim(rtrim(@lcwhere)),1,len(ltrim(rtrim(@lcwhere)))-3)
		select @lcclave2 = substring(ltrim(rtrim(@lcclave2)),1,len(ltrim(rtrim(@lcclave2)))-3)
		select @lccampoclave = substring(ltrim(rtrim(@lccampoclave)),1,len(ltrim(rtrim(@lccampoclave)))-1)
	end

	insert into @tempLlaves values (@lcclave, @lccampoclave, @lccampo, @lcclave2)

	return

end
/*
drop table #temp1
drop table #temp2
*/








