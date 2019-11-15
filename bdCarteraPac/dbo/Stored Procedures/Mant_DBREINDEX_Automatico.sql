
CREATE PROC Mant_DBREINDEX_Automatico
AS
  CREATE TABLE #TABLAS_REINDEX
  (
    ID int IDENTITY,
    TABLA varchar(200)
  )

  INSERT INTO #TABLAS_REINDEX (TABLA)
  SELECT     '[' + sysusers.name + ']' + '.' + '[' + sysobjects.name + ']' AS TABLA
  FROM         sysobjects INNER JOIN sysusers ON sysobjects.uid = sysusers.uid
  WHERE     (dbo.sysobjects.xtype = 'u') AND dbo.sysobjects.name <> 'dtproperties'

  DECLARE @Minimo int
  DECLARE @Maximo int

  SELECT @Minimo=MIN(ID) FROM #TABLAS_REINDEX
  SELECT @Maximo=MAX(ID) FROM #TABLAS_REINDEX

  PRINT @Minimo
  PRINT @Maximo

  DECLARE @Contador int
  DECLARE @NombreTabla varchar(200)
  SET @Contador=@Minimo

  WHILE @Contador <=@Maximo
  BEGIN
    SELECT @NombreTabla= TABLA FROM #TABLAS_REINDEX WHERE ID=@Contador 
    PRINT '---------------------------------------------------------------'
    PRINT 'DBCC DBREINDEX (' + '''' + @NombreTabla + '''' + ')'
    EXECUTE ('DBCC DBREINDEX ('+ '''' + @NombreTabla + '''' + ')')
    SET @Contador=@Contador + 1
  END

  DROP TABLE  #TABLAS_REINDEX

