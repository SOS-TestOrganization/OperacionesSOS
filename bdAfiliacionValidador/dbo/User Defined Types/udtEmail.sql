CREATE TYPE [dbo].[udtEmail]
    FROM VARCHAR (50) NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[udtEmail] TO PUBLIC;

