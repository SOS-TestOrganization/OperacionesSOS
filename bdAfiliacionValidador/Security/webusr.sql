CREATE ROLE [webusr]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [webusr] ADD MEMBER [websos];


GO
ALTER ROLE [webusr] ADD MEMBER [aut_webusr];

