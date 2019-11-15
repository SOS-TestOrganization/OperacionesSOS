CREATE TYPE [dbo].[udtUsuario]
    FROM CHAR (30) NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[udtUsuario] TO PUBLIC;

