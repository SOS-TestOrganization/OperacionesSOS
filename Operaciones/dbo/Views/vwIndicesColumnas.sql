

CREATE VIEW dbo.vwIndicesColumnas
AS
SELECT     TOP 100 PERCENT dbo.sysobjects.name AS Tabla, dbo.sysindexes.name AS Indice, dbo.syscolumns.name AS Columna, dbo.systypes.name AS Tipo, 
                      dbo.syscolumns.length AS Longitud, dbo.sysindexes.indid, 
                      CASE dbo.sysindexes.indid WHEN 0 THEN 'TABLA MONTON' WHEN 1 THEN 'CLUSTERED' ELSE 'NONCLUSTERED' END TipoIndice, 
                      dbo.sysindexes.keycnt, dbo.sysindexes.dpages, dbo.sysindexes.reserved, dbo.sysindexes.rowcnt, dbo.sysindexes.maxirow, 
                      dbo.sysindexes.OrigFillFactor, dbo.sysindexkeys.keyno
FROM         dbo.sysindexkeys RIGHT OUTER JOIN
                      dbo.sysindexes LEFT OUTER JOIN
                      dbo.sysobjects ON dbo.sysindexes.id = dbo.sysobjects.id ON dbo.sysindexkeys.id = dbo.sysindexes.id AND 
                      dbo.sysindexkeys.indid = dbo.sysindexes.indid LEFT OUTER JOIN
                      dbo.systypes RIGHT OUTER JOIN
                      dbo.syscolumns ON dbo.systypes.xtype = dbo.syscolumns.xtype AND dbo.systypes.type = dbo.syscolumns.type AND 
                      dbo.systypes.usertype = dbo.syscolumns.usertype AND dbo.systypes.xusertype = dbo.syscolumns.xusertype ON 
                      dbo.sysindexkeys.id = dbo.syscolumns.id AND dbo.sysindexkeys.colid = dbo.syscolumns.colid
WHERE     (dbo.sysindexes.indid <> 255) AND (NOT (dbo.sysobjects.name LIKE N'sys%')) AND (NOT (dbo.sysobjects.name LIKE N'MS%')) AND 
                      (dbo.sysobjects.name <> 'dtproperties')
ORDER BY dbo.sysobjects.name, dbo.sysindexes.name, dbo.sysindexes.indid, dbo.sysindexkeys.keyno

