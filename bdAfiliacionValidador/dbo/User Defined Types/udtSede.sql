CREATE TYPE [dbo].[udtSede]
    FROM CHAR (3) NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[udtSede] TO PUBLIC;

