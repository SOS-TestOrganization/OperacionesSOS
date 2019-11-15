CREATE TYPE [dbo].[udtNumeroIdentificacionLargo]
    FROM VARCHAR (23) NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[udtNumeroIdentificacionLargo] TO PUBLIC;

