CREATE TABLE [dbo].[tbEstadosCuentaContratosPrevia] (
    [cnsctvo_estdo_cnta_cntrto] [dbo].[udtConsecutivo] NOT NULL,
    [vlr_cbrdo]                 [dbo].[udtValorGrande] NOT NULL,
    [sldo]                      [dbo].[udtValorGrande] NOT NULL,
    [sldo_fvr]                  [dbo].[udtValorGrande] NULL,
    CONSTRAINT [PK_TbEstadosCuentaContratosPrevia] PRIMARY KEY CLUSTERED ([cnsctvo_estdo_cnta_cntrto] ASC)
);


GO
CREATE STATISTICS [vlr_cbrdo]
    ON [dbo].[tbEstadosCuentaContratosPrevia]([vlr_cbrdo], [cnsctvo_estdo_cnta_cntrto]);


GO
CREATE STATISTICS [sldo]
    ON [dbo].[tbEstadosCuentaContratosPrevia]([sldo], [cnsctvo_estdo_cnta_cntrto]);


GO
CREATE STATISTICS [sldo_fvr]
    ON [dbo].[tbEstadosCuentaContratosPrevia]([sldo_fvr], [cnsctvo_estdo_cnta_cntrto]);


GO

/*---------------------------------------------------------------------------------
* Metodo o PRG 			:  TrIncidencias_tbEstadosCuentaContratosPrevia
* Desarrollado por		: <\A Ing. Diana Lorena Gomez Betancourt											A\>
* Descripcion			: <\D Este trigger genera las incidencias de los campos que se desean auditar	 		D\>
*				: <\D 												D\>
* Observaciones			: <\O  												O\>
* Parametros			: <\P 									 			P\>
* Variables			: <\V  												V\>
* Fecha Creacion		: <\FC 2008/06/13										FC\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
Sau		Analista		Descripción
*/

CREATE TRIGGER [dbo].[TrIncidencias_tbEstadosCuentaContratosPrevia] On [BDCarteraPAC].[dbo].[tbEstadosCuentaContratosPrevia]
For  UPDATE  As

	SET NOCOUNT ON --prevenir que se retornen valores.

	--Variables para tomar el tiempo de ejecucion del codigo.
--	DECLARE @inicio DATETIME,
--		@fin	DATETIME

--	set @inicio = GETDATE()

	--Variables de configuracion de los parametros del trigger.
	DECLARE 
		@mascara_1_64			BIGINT, 	--Mascara parcial de las columnas a auditar.
		@mascara_128_65			BIGINT,		--Mascara parcial de las columnas a auditar.
		@mascara_combinada		VARBINARY(20),	--Mascara completa de las columnas a auditar.
		@columnas_modificadas 		VARBINARY(20),	--Mascara de todas las columnas que fueron modificadas.
		@nombre_tabla			VARCHAR(60) 	--Nombre de la tabla del trigger.

	--Estas varibles deben modificarse para el trigger de cada tabla y 
	--para las columna que se deseen auditar.
		
	SET @nombre_tabla	= 'bdCarteraPac.DBO.tbEstadosCuentaContratosPrevia'
	SET @mascara_1_64 	=0x000000000000000C   --de derecha a izquierda: 0010000000000000010000001011100001111101000010000000000000100000
	SET @mascara_128_65 	= 0x0000000000000000 --de izquierda a derecha
	SET @mascara_combinada	= 0x0C 
			         
	SET @columnas_modificadas = COLUMNS_UPDATED() --no debe modificarse, dejar asi.

	--Evalua si alguna de las columnas de auditoria fue modificada.
	--de lo contrario, el trigger no hace nada y termina.
	IF (BDSeguridad.DBO.fnExistenModificaciones(@columnas_modificadas, @mascara_1_64, @mascara_128_65) = 1)
	BEGIN
		--Variables del algoritmo
		DECLARE	@indice_byte 	TINYINT, 	--indice del byte actual que se esta evaluando.
			@id_columna 	TINYINT,	--colid de la columna que se esta evaluando
			@id_tabla 		INT, 		--id de la tabla
			@num_bytes		TINYINT

		--Variables de informacion de la incidencia
		DECLARE	@lcFechaIncidencia	VARCHAR(30),
			@lcCampo 		VARCHAR(60),
			@lcUsuario 		VARCHAR(60),
			@lnLinea		CHAR(01)
		
		--> Inicializacion de las variables del algoritmo.
		SET @indice_byte = 1
		SET @id_columna	= 1
		SET @id_tabla 	= OBJECT_ID(@nombre_tabla) --almacena el id de la tabla para utilizarlo en las consultas.
		SET @num_bytes	= DATALENGTH(@mascara_combinada)
		
		--> Obtener Fecha y @lcUsuario de la incidencia
		SET @lcFechaIncidencia	= CONVERT(VARCHAR(30),GetDate(),120)
		SET @lcUsuario		= SYSTEM_USER
		SET @lnLinea 		= '0'

		--Recorre los bytes que representan el numero total de columnas.
		WHILE @indice_byte <= @num_bytes
		BEGIN
			DECLARE @num_bit 	TINYINT,--Contador de bits.
				@auditar 	SMALLINT,	--
				@potencia 	SMALLINT	--Representa los bits de cada byte en el rango de 0 a 7,
										--Evita realizar multiplicacione y potencias en el codigo.

			--Inicializacion de variables del algoritmo.
			--Estas variables se inicializan por cada iteracion
			--debido a que se utilizan para recorrer los bits de cada byte.
			SET @num_bit 	= 0
			SET @potencia  	= 1
			SET @auditar = SUBSTRING(@columnas_modificadas, @indice_byte, 1) & 
					CAST(SUBSTRING(@mascara_combinada, @indice_byte, 1) AS SMALLINT)

			WHILE @num_bit < 8
			
			
			BEGIN
				IF (@auditar & @potencia != 0)
				BEGIN
					SELECT 	@lcCampo = name FROM syscolumns
					WHERE 	id = @id_tabla AND colid = @id_columna


					IF @id_columna = 3
						INSERT INTO [bdCarteraPac].[dbo].[tbIncidenciasCarteraPac] (
							bse_dts, nmbre_tbla, nmbre_cmpo, 
							cnsctvo_vgnca, vlr_antrr, vlr_nvo,
							usro_incdnca, fcha_incdnca, cnsctvo_rgstro_afctdo
						)SELECT 					'bdCarteraPac', 'tbEstadosCuentaContratosPrevia',@lcCampo,
						99999, d.sldo, n.sldo,
						@lcUsuario,  @lcFechaIncidencia , d.cnsctvo_estdo_cnta_cntrto
							FROM 	deleted d, inserted n 
						 WHERE 	d.cnsctvo_estdo_cnta_cntrto = n.cnsctvo_estdo_cnta_cntrto AND 
							(
							 (
							(d.sldo <> n.sldo And d.sldo Is Not Null	And n.sldo Is Not Null)	Or
							 (d.sldo Is Null And n.sldo Is Not Null) Or 
							 (n.sldo Is Null And d.sldo is Not null))
							)
							ELSE 	IF @id_columna = 4
						INSERT INTO [bdCarteraPac].[dbo].[tbIncidenciasCarteraPac] (
							bse_dts, nmbre_tbla, nmbre_cmpo, 
							cnsctvo_vgnca, vlr_antrr, vlr_nvo,
							usro_incdnca, fcha_incdnca, cnsctvo_rgstro_afctdo
						)SELECT  	'bdCarteraPac', 'tbEstadosCuentaContratosPrevia',@lcCampo,
						99999, d.sldo_fvr, n.sldo_fvr,
						@lcUsuario,  @lcFechaIncidencia , d.cnsctvo_estdo_cnta_cntrto
							FROM 	deleted d, inserted n 
						 WHERE 	d.cnsctvo_estdo_cnta_cntrto = n.cnsctvo_estdo_cnta_cntrto AND 
							(
							 (
							(d.sldo_fvr <> n.sldo_fvr And d.sldo_fvr Is Not Null	And n.sldo_fvr Is Not Null)	Or
							 (d.sldo_fvr Is Null And n.sldo_fvr Is Not Null) Or 
							 (n.sldo_fvr Is Null And d.sldo_fvr is Not null))
							)
							END
							
				SET @num_bit = @num_bit + 1
				SET @id_columna = @id_columna + 1
				SET @potencia = @potencia + @potencia
			END--Fin del Ciclo
			SET @indice_byte = @indice_byte + 1
		END--Fin del Ciclo	
	END --Fin IF

--	SET @fin = GETDATE()
--	INSERT INTO tiempos(duracion, fecha, usuario, tabla) VALUES (datediff(ms, @inicio, @fin), getdate(), SYSTEM_USER,@nombre_tabla)

