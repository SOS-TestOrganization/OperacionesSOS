CREATE ROLE [Consultor Administrativo Privilegiado]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [Consultor Administrativo Privilegiado] ADD MEMBER [900010 Consultor Administrativo Privilegiado];


GO
ALTER ROLE [Consultor Administrativo Privilegiado] ADD MEMBER [SOS\900010 Consultor Administrativo Privilegiado];

