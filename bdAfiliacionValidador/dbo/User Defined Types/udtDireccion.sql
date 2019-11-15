CREATE TYPE [dbo].[udtDireccion]
    FROM VARCHAR (80) NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[udtDireccion] TO PUBLIC;

