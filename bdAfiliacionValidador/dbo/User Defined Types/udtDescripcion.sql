CREATE TYPE [dbo].[udtDescripcion]
    FROM VARCHAR (150) NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[udtDescripcion] TO PUBLIC;

