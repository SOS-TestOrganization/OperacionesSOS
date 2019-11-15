CREATE TYPE [dbo].[udtObservacion]
    FROM VARCHAR (250) NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[udtObservacion] TO PUBLIC;

