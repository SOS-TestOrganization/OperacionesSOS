CREATE TYPE [dbo].[udtCodigo]
    FROM CHAR (2) NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[udtCodigo] TO PUBLIC;

