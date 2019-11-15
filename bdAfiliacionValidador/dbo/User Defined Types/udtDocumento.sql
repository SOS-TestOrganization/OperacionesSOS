CREATE TYPE [dbo].[udtDocumento]
    FROM CHAR (15) NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[udtDocumento] TO PUBLIC;

