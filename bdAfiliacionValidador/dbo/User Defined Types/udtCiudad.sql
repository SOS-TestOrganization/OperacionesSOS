CREATE TYPE [dbo].[udtCiudad]
    FROM CHAR (8) NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[udtCiudad] TO PUBLIC;

