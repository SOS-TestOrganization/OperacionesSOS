CREATE ROLE [Control General Rezagos]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [Control General Rezagos] ADD MEMBER [130003 Auditor Rezagos];


GO
ALTER ROLE [Control General Rezagos] ADD MEMBER [130001 Control General Rezagos];

