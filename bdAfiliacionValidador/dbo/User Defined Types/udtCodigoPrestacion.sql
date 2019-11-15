CREATE TYPE [dbo].[udtCodigoPrestacion]
    FROM CHAR (10) NOT NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[udtCodigoPrestacion] TO PUBLIC;

