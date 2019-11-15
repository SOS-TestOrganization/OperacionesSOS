CREATE TABLE [dbo].[tbEstadosCuentaPrevia] (
    [cnsctvo_estdo_cnta] [dbo].[udtConsecutivo]  NOT NULL,
    [cnsctvo_cdgo_lqdcn] [dbo].[udtConsecutivo]  NOT NULL,
    [ttl_fctrdo]         [dbo].[udtValorGrande]  NOT NULL,
    [sldo_fvr]           [dbo].[udtValorGrande]  NOT NULL,
    [ttl_pgr]            [dbo].[udtValorGrande]  NOT NULL,
    [sldo_estdo_cnta]    [dbo].[udtValorGrande]  NOT NULL,
    [sldo_antrr]         [dbo].[udtValorGrande]  NOT NULL,
    [Cts_Cnclr]          [dbo].[udtValorPequeno] NOT NULL,
    [Cts_sn_Cnclr]       [dbo].[udtValorPequeno] NOT NULL,
    CONSTRAINT [PK_tbEstadosCuentaPrevia] PRIMARY KEY CLUSTERED ([cnsctvo_estdo_cnta] ASC)
);


GO
CREATE STATISTICS [cnsctvo_cdgo_lqdcn]
    ON [dbo].[tbEstadosCuentaPrevia]([cnsctvo_cdgo_lqdcn], [cnsctvo_estdo_cnta]);


GO
CREATE STATISTICS [ttl_fctrdo]
    ON [dbo].[tbEstadosCuentaPrevia]([ttl_fctrdo], [cnsctvo_estdo_cnta]);


GO
CREATE STATISTICS [sldo_fvr]
    ON [dbo].[tbEstadosCuentaPrevia]([sldo_fvr], [cnsctvo_estdo_cnta]);


GO
CREATE STATISTICS [ttl_pgr]
    ON [dbo].[tbEstadosCuentaPrevia]([ttl_pgr], [cnsctvo_estdo_cnta]);


GO
CREATE STATISTICS [sldo_estdo_cnta]
    ON [dbo].[tbEstadosCuentaPrevia]([sldo_estdo_cnta], [cnsctvo_estdo_cnta]);


GO
CREATE STATISTICS [sldo_antrr]
    ON [dbo].[tbEstadosCuentaPrevia]([sldo_antrr], [cnsctvo_estdo_cnta]);


GO
CREATE STATISTICS [Cts_Cnclr]
    ON [dbo].[tbEstadosCuentaPrevia]([Cts_Cnclr], [cnsctvo_estdo_cnta]);


GO
CREATE STATISTICS [Cts_sn_Cnclr]
    ON [dbo].[tbEstadosCuentaPrevia]([Cts_sn_Cnclr], [cnsctvo_estdo_cnta]);


GO
/*---------------------------------------------------------------------------------
* Metodo o PRG 			:  TrIncidencias_tbEstadosCuentaPrevia
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


CREATE TRIGGER [dbo].[TrIncidencias_tbEstadosCuentaPrevia] On [BDCarteraPAC].[dbo].[tbEstadosCuentaPrevia]
For UPDATE  As

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
		@nombre_tabla			VARCHAR(60) --Nombre de la tabla del trigger.



	--Estas varibles deben modificarse para el trigger de cada tabla y 
	--para las columna que se deseen auditar.
		
	SET @nombre_tabla	= 'bdCarteraPac.DBO.tbEstadosCuentaPrevia'
	SET @mascara_1_64 	=0x0000000000006800   --de derecha a izquierda: 0010000000000000010000001011100001111101000010000000000000100000
	SET @mascara_128_65 	= 0x0000000000000000 --de izquierda a derecha
	SET @mascara_combinada	= 0x6800 
			         
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


					IF @id_columna = 4
						INSERT INTO [bdCarteraPac].[dbo].[tbIncidenciasCarteraPac] (
							bse_dts, nmbre_tbla, nmbre_cmpo, 
							cnsctvo_vgnca, vlr_antrr, vlr_nvo,
							usro_incdnca, fcha_incdnca, cnsctvo_rgstro_afctdo
						)SELECT 'bdCarteraPac', 'tbEstadosCuentaPrevia',@lcCampo,
						99999, d.sldo_fvr, n.sldo_fvr,
						@lcUsuario,  @lcFechaIncidencia , d.cnsctvo_estdo_cnta
							FROM 	deleted d, inserted n 
						 WHERE 	d.cnsctvo_estdo_cnta = n.cnsctvo_estdo_cnta AND 
							(
							 (
							(d.sldo_fvr <> n.sldo_fvr And d.sldo_fvr Is Not Null	And n.sldo_fvr Is Not Null)	Or
							 (d.sldo_fvr Is Null And n.sldo_fvr Is Not Null) Or 
							 (n.sldo_fvr Is Null And d.sldo_fvr is Not null))
							)
							ELSE 	IF @id_columna = 6
						INSERT INTO [bdCarteraPac].[dbo].[tbIncidenciasCarteraPac] (
							bse_dts, nmbre_tbla, nmbre_cmpo, 
							cnsctvo_vgnca, vlr_antrr, vlr_nvo,
							usro_incdnca, fcha_incdnca, cnsctvo_rgstro_afctdo
						)SELECT  'bdCarteraPac', 'tbEstadosCuentaPrevia',@lcCampo,
						99999, d.sldo_estdo_cnta, n.sldo_estdo_cnta,
						@lcUsuario,  @lcFechaIncidencia , d.cnsctvo_estdo_cnta
							FROM 	deleted d, inserted n 
						 WHERE 	d.cnsctvo_estdo_cnta = n.cnsctvo_estdo_cnta AND 
							(
							 (
							(d.sldo_estdo_cnta <> n.sldo_estdo_cnta And d.sldo_estdo_cnta Is Not Null	And n.sldo_estdo_cnta Is Not Null)	Or
							 (d.sldo_estdo_cnta Is Null And n.sldo_estdo_cnta Is Not Null) Or 
							 (n.sldo_estdo_cnta Is Null And d.sldo_estdo_cnta is Not null))
							)
									ELSE 	IF @id_columna = 7
						INSERT INTO [bdCarteraPac].[dbo].[tbIncidenciasCarteraPac] (
							bse_dts, nmbre_tbla, nmbre_cmpo, 
							cnsctvo_vgnca, vlr_antrr, vlr_nvo,
							usro_incdnca, fcha_incdnca, cnsctvo_rgstro_afctdo
						)SELECT 'bdCarteraPac', 'tbEstadosCuentaPrevia',@lcCampo,
						99999, d.sldo_antrr, n.sldo_antrr,
						@lcUsuario,  @lcFechaIncidencia , d.cnsctvo_estdo_cnta
							FROM 	deleted d, inserted n 
						 WHERE 	d.cnsctvo_estdo_cnta = n.cnsctvo_estdo_cnta AND 
							(
							 (
							(d.sldo_antrr <> n.sldo_antrr And d.sldo_antrr Is Not Null	And n.sldo_antrr Is Not Null)	Or
							 (d.sldo_antrr Is Null And n.sldo_antrr Is Not Null) Or 
							 (n.sldo_antrr Is Null And d.sldo_antrr is Not null))
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

