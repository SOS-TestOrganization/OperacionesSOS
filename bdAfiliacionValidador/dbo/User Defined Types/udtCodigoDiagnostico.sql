CREATE TYPE [dbo].[udtCodigoDiagnostico]
    FROM CHAR (5) NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[udtCodigoDiagnostico] TO PUBLIC;

