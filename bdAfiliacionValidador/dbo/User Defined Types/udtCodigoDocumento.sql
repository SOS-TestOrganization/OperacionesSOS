CREATE TYPE [dbo].[udtCodigoDocumento]
    FROM CHAR (2) NOT NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[udtCodigoDocumento] TO PUBLIC;

