CREATE TYPE [dbo].[udtTelefono]
    FROM CHAR (30) NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[udtTelefono] TO PUBLIC;

