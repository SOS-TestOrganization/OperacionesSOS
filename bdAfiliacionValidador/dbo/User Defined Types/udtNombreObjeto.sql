CREATE TYPE [dbo].[udtNombreObjeto]
    FROM VARCHAR (128) NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[udtNombreObjeto] TO PUBLIC;

