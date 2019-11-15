CREATE TYPE [dbo].[udtValorDecimales]
    FROM NUMERIC (14, 4) NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[udtValorDecimales] TO PUBLIC;

