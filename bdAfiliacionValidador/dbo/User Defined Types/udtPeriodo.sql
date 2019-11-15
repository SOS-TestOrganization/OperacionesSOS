CREATE TYPE [dbo].[udtPeriodo]
    FROM NUMERIC (6) NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[udtPeriodo] TO PUBLIC;

