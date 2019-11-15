CREATE DEFAULT [dbo].[dflts_N]
    AS 'N';


GO
EXECUTE sp_bindefault @defname = N'[dbo].[dflts_N]', @objname = N'[dbo].[tbCampos].[brrdo]';

