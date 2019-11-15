CREATE TYPE [dbo].[udtNumeroIdentificacion]
    FROM VARCHAR (20) NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[udtNumeroIdentificacion] TO PUBLIC;

