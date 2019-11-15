CREATE TYPE [dbo].[udtNombre]
    FROM CHAR (20) NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[udtNombre] TO PUBLIC;

