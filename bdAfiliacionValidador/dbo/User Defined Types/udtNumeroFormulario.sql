CREATE TYPE [dbo].[udtNumeroFormulario]
    FROM CHAR (15) NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[udtNumeroFormulario] TO PUBLIC;

