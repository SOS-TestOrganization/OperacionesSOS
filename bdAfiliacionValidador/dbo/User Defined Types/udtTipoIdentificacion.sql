CREATE TYPE [dbo].[udtTipoIdentificacion]
    FROM CHAR (3) NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[udtTipoIdentificacion] TO PUBLIC;

