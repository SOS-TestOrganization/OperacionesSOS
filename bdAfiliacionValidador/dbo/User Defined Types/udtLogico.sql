CREATE TYPE [dbo].[udtLogico]
    FROM CHAR (1) NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[udtLogico] TO PUBLIC;

