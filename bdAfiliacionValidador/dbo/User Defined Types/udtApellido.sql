CREATE TYPE [dbo].[udtApellido]
    FROM CHAR (50) NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[udtApellido] TO PUBLIC;

