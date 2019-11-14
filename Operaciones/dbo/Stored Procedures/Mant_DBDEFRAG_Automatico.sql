
CREATE PROC Mant_DBDEFRAG_Automatico
AS
  SET NOCOUNT ON

  CREATE TABLE #TABLAS_REINDEX
  (
    ID int IDENTITY,
    BASEDATOS varchar(200),
    TABLA varchar(200),
    INDICE varchar(200)  
  )


  INSERT INTO #TABLAS_REINDEX (BASEDATOS,TABLA,INDICE)
  SELECT db_name()  AS BaseDatos, dbo.sysobjects.name AS TABLA, dbo.sysindexes.name AS INDICE
  FROM    dbo.sysobjects INNER JOIN dbo.sysindexes ON dbo.sysobjects.id = dbo.sysindexes.id
  WHERE     (dbo.sysobjects.xtype = 'u') AND (dbo.sysobjects.name <> 'dtproperties') AND NOT (dbo.sysobjects.name LIKE 'MS%') AND NOT (dbo.sysobjects.name LIKE 'dbo.sys%')
     AND dbo.sysindexes.indid > 0 AND dbo.sysindexes.indid < 255 AND (dbo.sysindexes.status & 64)=0 
  ORDER BY dbo.sysindexes.indid

  DECLARE @Minimo int
  DECLARE @Maximo int

  SELECT @Minimo=MIN(ID) FROM #TABLAS_REINDEX
  SELECT @Maximo=MAX(ID) FROM #TABLAS_REINDEX

  DECLARE @Contador int
  DECLARE @BaseDatos varchar(200),@NombreTabla varchar(200), @Indice varchar(200)
  SET @Contador=@Minimo

  WHILE @Contador <=@Maximo
  BEGIN
    SELECT @BaseDatos=BaseDatos,@NombreTabla= TABLA, @Indice=Indice FROM #TABLAS_REINDEX WHERE ID=@Contador 
    PRINT '------------------------------------------------------------------------------------' 
    PRINT 'DBCC INDEXDEFRAG ('+ '[' + @BaseDatos + ']' + ',' + '[' + @NombreTabla + ']' + ',' + '[' + @Indice + ']' + ')'
    EXECUTE ('DBCC INDEXDEFRAG ('+ '[' + @BaseDatos + ']' + ',' + '[' + @NombreTabla + ']' + ',' + '[' + @Indice + ']' + ')')
    SET @Contador=@Contador + 1
  END

  DROP TABLE  #TABLAS_REINDEX
  
  exec sp_createstats
  exec sp_updatestats

  SET NOCOUNT OFF

