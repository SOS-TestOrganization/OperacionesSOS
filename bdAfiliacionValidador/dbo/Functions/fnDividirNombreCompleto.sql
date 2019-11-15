


/*---------------------------------------------------------------------------------
* Metodo o PRG 			: fnDividirNombreCompleto
* Desarrollado por		: <\A Ing. Janeth Barrera  										A\>
* Descripcion			: <\D Esta funcion descompone un nombre completo en primer nombre, segundo nombre, primer apellido y segundo apellido D\>
* Observaciones			: <\O  															O\>
* Parametros			: <\P 															P\>
* Variables				: <\V  																V\>
* Fecha Creacion		: <\FC 2016/03/04												FC\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM Ing. Warner Valencia - SEIT Consultores AM\>
* Descripcion				: <\DM  se adiciona la logica para que descomponga  completo en primer nombre, segundo nombre, primer apellido y segundo apellido DM\>
* Nuevos Parametros			: <\PM  PM\>
* Nuevas Variables			: <\VM  VM\>
* Fecha Modificacion		: <\FM   2016/03/10	FM\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  AM\>
* Descripcion				: <\DM  DM\>
* Nuevos Parametros			: <\PM  PM\>
* Nuevas Variables			: <\VM  VM\>
* Fecha Modificacion		: <\FM  FM\>
*---------------------------------------------------------------------------------*/
/*
SELECT * FROM [dbo].[fnDividirNombreCompleto] ('DE LA PEÑA GOMEZ, LUIS EDUARDO’ ')
SELECT * FROM [dbo].[fnDividirNombreCompleto] ('LASSO DE LA TORRE, LUISA FERNANDA')
SELECT * FROM [dbo].[fnDividirNombreCompleto] ('CASTILLO HERNANDEZ, OMAIRA DE JESUS')
SELECT * FROM [dbo].[fnDividirNombreCompleto] ('CORONADO NEGRETE, ANGELINA DE LA CONCEPCION')
SELECT * FROM [dbo].[fnDividirNombreCompleto] ('MEJIA  QUINTERO  ADRIANA  CRISTINA DEL PILAR')
SELECT * FROM [dbo].[fnDividirNombreCompleto] ('MARGARITA DEL PILAR ALVAREZ ZAMBRANO' )
SELECT * FROM [dbo].[fnDividirNombreCompleto] ('ANGELICA DEL PILAR QUINTERO LONDOÑO’' )

*/
CREATE FUNCTION  [dbo].[fnDividirNombreCompleto] (@lcNombreCompleto varchar(200))  
RETURNS @Nombre TABLE (prmr_nmbre varchar(30), sgndo_nmbre varchar(30), prmr_aplldo varchar(50),sgndo_aplldo varchar(50) )
AS  
BEGIN 
	Declare @lcPrimerNombre		varchar(30),
			@lcSegundoNombre	varchar(30),
			@lcPrimerApellido	varchar(50),
			@lcSegundoApellido	varchar(50)	



		Set  @lcNombreCompleto = LTRIM(rtrim(@lcNombreCompleto))
		Set @lcNombreCompleto = replace(@lcNombreCompleto,'’',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,'''',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,'_',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,'.',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,',',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,'-',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,'#',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,'(',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,')',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,'/',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,'\',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,'[',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,']',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,'  ',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,'°',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,'"',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,'?',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,'¿',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,'¡',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,'!',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,'<',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,'>',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,'=',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,'$',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,'&',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,'*',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,'+',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,'~',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,'}',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,'{',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,';',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,':',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,'¬',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,'|',' ')
		Set @lcNombreCompleto = replace(@lcNombreCompleto,'^',' ')


Set  @lcNombreCompleto = LTRIM(rtrim(@lcNombreCompleto))
	/*** Extraemos el primer apellido ***/
	Set @lcPrimerApellido = substring (@lcNombreCompleto,1,CHARINDEX(' ',@lcNombreCompleto))
	-- Validar el inicio de la cadena 'DE'
	If @lcPrimerApellido ='DE'
		Begin --Validar el inicio de la cadena 'DE' primer apellido
			-- se extrae de la cadena la palabra asignada anteriormente
			SELECT @lcNombreCompleto = RIGHT(@lcNombreCompleto,LEN(@lcNombreCompleto)-CHARINDEX(' ',@lcNombreCompleto))
			-- Se extrae la siguiente parabra
			Set @lcPrimerApellido = CONCAT(@lcPrimerApellido,' ', substring (@lcNombreCompleto,1,CHARINDEX(' ',@lcNombreCompleto)))
			-- se extrae de la cadena la palabra asignada anteriormente
			SELECT @lcNombreCompleto = RIGHT(@lcNombreCompleto,LEN(@lcNombreCompleto)-CHARINDEX(' ',@lcNombreCompleto))
			Set @lcPrimerApellido = CONCAT(@lcPrimerApellido,' ', substring (@lcNombreCompleto,1,CHARINDEX(' ',@lcNombreCompleto)))
			
	End --Validar el inicio de la cadena 'DE' primer apellido
	Else
	  Begin 
			If @lcPrimerApellido ='DEL'
				Begin --Validar el inicio de la cadena 'DE' primer apellido
					-- se extrae de la cadena la palabra asignada anteriormente
					SELECT @lcNombreCompleto = RIGHT(@lcNombreCompleto,LEN(@lcNombreCompleto)-CHARINDEX(' ',@lcNombreCompleto))
					-- Se extrae la siguiente parabra
					Set @lcPrimerApellido = CONCAT(@lcPrimerApellido,' ', substring (@lcNombreCompleto,1,CHARINDEX(' ',@lcNombreCompleto)))
					-- se extrae de la cadena la palabra asignada anteriormente
					--SELECT @lcNombreCompleto = RIGHT(@lcNombreCompleto,LEN(@lcNombreCompleto)-CHARINDEX(' ',@lcNombreCompleto))
					--Set @lcPrimerApellido = CONCAT(@lcPrimerApellido,' ', substring (@lcNombreCompleto,1,CHARINDEX(' ',@lcNombreCompleto)))
			
			End --Validar el inicio de la cadena 'DE' primer apellido


	  End


	-- SE QUITA ESPACIOS A LA NUEVA CADENA
	 Set  @lcNombreCompleto = LTRIM(rtrim(@lcNombreCompleto))
		-- Se extrae de la cadena la palabra asignada anteriormente
	SELECT @lcNombreCompleto = RIGHT(@lcNombreCompleto,LEN(@lcNombreCompleto)-CHARINDEX(' ',@lcNombreCompleto))
	Set  @lcNombreCompleto = LTRIM(rtrim(@lcNombreCompleto))
	/*** Extraemos el segundo apellido ***/
	Set @lcSegundoApellido = substring (@lcNombreCompleto,1,CHARINDEX(' ',@lcNombreCompleto))
	-- Validar el inicio de la cadena 'DE'  segundo apellido
	If @lcSegundoApellido ='DE'
		Begin --Validar el inicio de la cadena 'DE'
			-- se extrae de la cadena la palabra asignada anteriormente
			SELECT @lcNombreCompleto = RIGHT(@lcNombreCompleto,LEN(@lcNombreCompleto)-CHARINDEX(' ',@lcNombreCompleto))
			-- Se extrae la siguiente parabra
			Set @lcSegundoApellido = CONCAT(@lcSegundoApellido,' ', substring (@lcNombreCompleto,1,CHARINDEX(' ',@lcNombreCompleto)))
			-- se extrae de la cadena la palabra asignada anteriormente
			SELECT @lcNombreCompleto = RIGHT(@lcNombreCompleto,LEN(@lcNombreCompleto)-CHARINDEX(' ',@lcNombreCompleto))
			Set @lcSegundoApellido = CONCAT(@lcSegundoApellido,' ', substring (@lcNombreCompleto,1,CHARINDEX(' ',@lcNombreCompleto)))
	End --Validar el inicio de la cadena 'DE' segundo apellido
	Else
	  Begin 
			If @lcSegundoApellido ='DEL'
				Begin --Validar el inicio de la cadena 'DE' primer apellido
					-- se extrae de la cadena la palabra asignada anteriormente
					SELECT @lcNombreCompleto = RIGHT(@lcNombreCompleto,LEN(@lcNombreCompleto)-CHARINDEX(' ',@lcNombreCompleto))
					-- Se extrae la siguiente parabra
					Set @lcSegundoApellido = CONCAT(@lcSegundoApellido,' ', substring (@lcNombreCompleto,1,CHARINDEX(' ',@lcNombreCompleto)))
					-- se extrae de la cadena la palabra asignada anteriormente
					--SELECT @lcNombreCompleto = RIGHT(@lcNombreCompleto,LEN(@lcNombreCompleto)-CHARINDEX(' ',@lcNombreCompleto))
					--Set @lcPrimerApellido = CONCAT(@lcPrimerApellido,' ', substring (@lcNombreCompleto,1,CHARINDEX(' ',@lcNombreCompleto)))
			
			End --Validar el inicio de la cadena 'DE' primer apellido


	  End

	-- SE QUITA ESPACIOS A LA NUEVA CADENA
	 Set  @lcNombreCompleto = LTRIM(rtrim(@lcNombreCompleto))
		-- Se extrae de la cadena la palabra asignada anteriormente
	SELECT @lcNombreCompleto = RIGHT(@lcNombreCompleto,LEN(@lcNombreCompleto)-CHARINDEX(' ',@lcNombreCompleto))
	Set  @lcNombreCompleto = LTRIM(rtrim(@lcNombreCompleto))
	/*** Extraemos el primer Nombre ***/
	Set @lcPrimerNombre = substring (@lcNombreCompleto,1,CHARINDEX(' ',@lcNombreCompleto))
		 
	-- Validar el inicio de la cadena 'DE'  segundo apellido
	If @lcPrimerNombre ='DE'
		Begin --Validar el inicio de la cadena 'DE'
			-- se extrae de la cadena la palabra asignada anteriormente
			SELECT @lcNombreCompleto = RIGHT(@lcNombreCompleto,LEN(@lcNombreCompleto)-CHARINDEX(' ',@lcNombreCompleto))
			-- Se extrae la siguiente parabra
			Set @lcPrimerNombre = CONCAT(@lcPrimerNombre,' ', substring (@lcNombreCompleto,1,CHARINDEX(' ',@lcNombreCompleto)))
			-- se extrae de la cadena la palabra asignada anteriormente
			SELECT @lcNombreCompleto = RIGHT(@lcNombreCompleto,LEN(@lcNombreCompleto)-CHARINDEX(' ',@lcNombreCompleto))
			Set @lcPrimerNombre = CONCAT(@lcPrimerNombre,' ', substring (@lcNombreCompleto,1,CHARINDEX(' ',@lcNombreCompleto)))
	    End --Validar el inicio de la cadena 'DE' segundo apellido

	Else
	  Begin 
			If @lcPrimerNombre ='DEL'
				Begin --Validar el inicio de la cadena 'DE' primer apellido
					-- se extrae de la cadena la palabra asignada anteriormente
					SELECT @lcNombreCompleto = RIGHT(@lcNombreCompleto,LEN(@lcNombreCompleto)-CHARINDEX(' ',@lcNombreCompleto))
					-- Se extrae la siguiente parabra
					Set @lcPrimerNombre = CONCAT(@lcPrimerNombre,' ', substring (@lcNombreCompleto,1,CHARINDEX(' ',@lcNombreCompleto)))
					-- se extrae de la cadena la palabra asignada anteriormente
					--SELECT @lcNombreCompleto = RIGHT(@lcNombreCompleto,LEN(@lcNombreCompleto)-CHARINDEX(' ',@lcNombreCompleto))
					--Set @lcPrimerApellido = CONCAT(@lcPrimerApellido,' ', substring (@lcNombreCompleto,1,CHARINDEX(' ',@lcNombreCompleto)))
			
			End --Validar el inicio de la cadena 'DE' primer apellido


	  End

	-- SE QUITA ESPACIOS A LA NUEVA CADENA
	 Set  @lcNombreCompleto = LTRIM(rtrim(@lcNombreCompleto))
		-- Se extrae de la cadena la palabra asignada anteriormente
	SELECT @lcNombreCompleto = RIGHT(@lcNombreCompleto,LEN(@lcNombreCompleto)-CHARINDEX(' ',@lcNombreCompleto))
	Set  @lcNombreCompleto = LTRIM(rtrim(@lcNombreCompleto))
	/*** Extraemos el segundo Nombre ***/ 
	SELECT @lcSegundoNombre=@lcNombreCompleto
	-- Validar el inicio de la cadena 'DE'  segundo nombre
	If @lcSegundoNombre ='DE'
		Begin --Validar el inicio de la cadena 'DE'
			-- se extrae de la cadena la palabra asignada anteriormente
			SELECT @lcNombreCompleto = RIGHT(@lcNombreCompleto,LEN(@lcNombreCompleto)-CHARINDEX(' ',@lcNombreCompleto))
			-- Se extrae la siguiente parabra
			Set @lcSegundoNombre = CONCAT(@lcSegundoNombre,' ', substring (@lcNombreCompleto,1,CHARINDEX(' ',@lcNombreCompleto)))
			-- se extrae de la cadena la palabra asignada anteriormente
			SELECT @lcNombreCompleto = RIGHT(@lcNombreCompleto,LEN(@lcNombreCompleto)-CHARINDEX(' ',@lcNombreCompleto))
			Set @lcSegundoNombre = CONCAT(@lcSegundoNombre,' ', substring (@lcNombreCompleto,1,CHARINDEX(' ',@lcNombreCompleto)))
			
		End --Validar el inicio de la cadena 'DE' segundo apellido
	  Begin 
			If @lcSegundoNombre ='DEL'
				Begin --Validar el inicio de la cadena 'DE' primer apellido
					-- se extrae de la cadena la palabra asignada anteriormente
					SELECT @lcNombreCompleto = RIGHT(@lcNombreCompleto,LEN(@lcNombreCompleto)-CHARINDEX(' ',@lcNombreCompleto))
					-- Se extrae la siguiente parabra
					Set @lcSegundoNombre = CONCAT(@lcSegundoNombre,' ', substring (@lcNombreCompleto,1,CHARINDEX(' ',@lcNombreCompleto)))
					-- se extrae de la cadena la palabra asignada anteriormente
					--SELECT @lcNombreCompleto = RIGHT(@lcNombreCompleto,LEN(@lcNombreCompleto)-CHARINDEX(' ',@lcNombreCompleto))
					--Set @lcPrimerApellido = CONCAT(@lcPrimerApellido,' ', substring (@lcNombreCompleto,1,CHARINDEX(' ',@lcNombreCompleto)))
			
			End --Validar el inicio de la cadena 'DE' primer apellido


	  End

	

	   insert into @Nombre values (@lcPrimerNombre,@lcSegundoNombre,@lcPrimerApellido,@lcSegundoApellido)

	Return
END

GO
GRANT SELECT
    ON OBJECT::[dbo].[fnDividirNombreCompleto] TO [procesope_webusr]
    AS [dbo];

