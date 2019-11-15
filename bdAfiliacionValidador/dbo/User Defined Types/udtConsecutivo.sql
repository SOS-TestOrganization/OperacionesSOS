CREATE TYPE [dbo].[udtConsecutivo]
    FROM INT NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[udtConsecutivo] TO PUBLIC;

