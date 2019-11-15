CREATE TYPE [dbo].[udtSexo]
    FROM CHAR (1) NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[udtSexo] TO PUBLIC;

