CREATE PROC MANT_DBReindex_BDAfiliacionValidador

AS  
Set Nocount On

Begin

EXEC Mant_DBREINDEX_Automatico


BACKUP TRANSACTION BDAfiliacionValidador  WITH NO_LOG
DBCC SHRINKDATABASE (N'BDAfiliacionValidador',0,TRUNCATEONLY)

EXEC sp_createstats

EXEC sp_updatestats

BACKUP TRANSACTION BDAfiliacionValidador WITH NO_LOG
DBCC SHRINKDATABASE (N'BDAfiliacionValidador',0,TRUNCATEONLY)

end