CREATE ROLE [Consulta]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [Consulta] ADD MEMBER [Analistas];


GO
ALTER ROLE [Consulta] ADD MEMBER [Auditoria Informatica];


GO
ALTER ROLE [Consulta] ADD MEMBER [Kiosko];

