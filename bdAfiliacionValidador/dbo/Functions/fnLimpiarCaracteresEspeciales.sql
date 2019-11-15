
CREATE FUNCTION [dbo].[fnLimpiarCaracteresEspeciales](@inputString VARCHAR(8000))
RETURNS VARCHAR(55)
AS

BEGIN
	DECLARE	@cnsctvo_prmtro	INT	=	7,
			@Caracteres		VARCHAR(100)
			
	SELECT	@Caracteres =	vlr_prmtro
	FROM	dbo.tbTablaParametros	With(NoLock)
	WHERE	cnsctvo_prmtro	=	@cnsctvo_prmtro
	
	WHILE @inputString LIKE '%[' + @Caracteres + ']%'
		BEGIN
			SELECT @inputString = REPLACE(@inputString
			, SUBSTRING(@inputString
			, PATINDEX('%[' + @Caracteres + ']%'
			, @inputString)
			, 1)
			,'')
		END;
		RETURN @inputString collate SQL_Latin1_General_Cp1251_CS_AS;
END;

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnLimpiarCaracteresEspeciales] TO [Analistas]
    AS [dbo];

