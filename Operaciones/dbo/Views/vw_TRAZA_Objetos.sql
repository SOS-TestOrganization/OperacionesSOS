CREATE VIEW dbo.vw_TRAZA_Objetos
AS
SELECT     id, name, xtype
FROM         dbo.sysobjects
WHERE     (xtype = 'U' OR
                      xtype = 'P' OR
                      xtype = 'TR' OR
                      xtype = 'V') AND (NOT (name LIKE N'dt_%')) AND (NOT (name LIKE N'sys_%')) AND (NOT (name LIKE  N'MS%')) AND (NOT (name LIKE  N'sync%')) 
