CREATE VIEW dbo.vwIndices
AS
SELECT     TOP 100 PERCENT dbo.sysobjects.name AS Tabla, dbo.sysindexes.name AS Indice, dbo.sysindexes.indid, 
                      CASE dbo.sysindexes.indid WHEN 0 THEN 'TABLA MONTON' WHEN 1 THEN 'CLUSTERED' ELSE 'NONCLUSTERED' END TipoIndice, 
                      dbo.sysindexes.keycnt, dbo.sysindexes.dpages, dbo.sysindexes.used, dbo.sysindexes.reserved, dbo.sysindexes.rowcnt, dbo.sysindexes.maxirow, 
                      dbo.sysindexes.rowmodctr, dbo.sysindexes.OrigFillFactor
FROM         dbo.sysindexes LEFT OUTER JOIN
                      dbo.sysobjects ON dbo.sysindexes.id = dbo.sysobjects.id
WHERE     (dbo.sysindexes.indid <> 255) AND (NOT (dbo.sysobjects.name LIKE N'sys%')) AND (NOT (dbo.sysobjects.name LIKE N'MS%')) AND 
                      (dbo.sysobjects.name <> 'dtproperties')
ORDER BY dbo.sysobjects.name, dbo.sysindexes.indid, dbo.sysindexes.name
