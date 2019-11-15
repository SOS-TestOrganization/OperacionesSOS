CREATE TYPE [dbo].[udtTipoFormulario]
    FROM CHAR (2) NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[udtTipoFormulario] TO PUBLIC;

