CREATE TYPE [dbo].[udtCodigoIps]
    FROM CHAR (8) NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[udtCodigoIps] TO PUBLIC;

