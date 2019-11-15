CREATE TYPE [dbo].[udtnumeroidentificacion2]
    FROM CHAR (19) NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[udtnumeroidentificacion2] TO PUBLIC;

