CREATE DEFAULT [dbo].[dflts_S]
    AS 'S';


GO
EXECUTE sp_bindefault @defname = N'[dbo].[dflts_S]', @objname = N'[dbo].[tbClasificacionGeografica].[vsble_usro]';

