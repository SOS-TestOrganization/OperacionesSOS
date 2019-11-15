CREATE TYPE [dbo].[udtDocumentoLargo]
    FROM CHAR (20) NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[udtDocumentoLargo] TO PUBLIC;

