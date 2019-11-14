CREATE ROLE [AdminScripts_Cambios]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [AdminScripts_Cambios] ADD MEMBER [SOS\sqlscript];

