CREATE TYPE [dbo].[udtValorPequeno]
    FROM NUMERIC (4) NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[udtValorPequeno] TO PUBLIC;

