CREATE TABLE [dbo].[tbLiquidaciones] (
    [cnsctvo_cdgo_lqdcn]       [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_prdo_lqdcn]  [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_estdo_lqdcn] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_tpo_prcso]   [dbo].[udtConsecutivo] NOT NULL,
    [nmro_estds_cnta]          [dbo].[udtValorGrande] NOT NULL,
    [vlr_lqddo]                [dbo].[udtValorGrande] NOT NULL,
    [nmro_cntrts]              [dbo].[udtValorGrande] NOT NULL,
    [fcha_crcn]                DATETIME               NOT NULL,
    [usro_crcn]                [dbo].[udtUsuario]     NOT NULL,
    [fcha_inco_prcso]          DATETIME               NULL,
    [fcha_fnl_prcso]           DATETIME               NULL,
    [obsrvcns]                 [dbo].[udtObservacion] NULL,
    [tme_stmp]                 ROWVERSION             NOT NULL,
    CONSTRAINT [PK_tbliquidaciones] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_lqdcn] ASC),
    CONSTRAINT [FK_tbLiquidaciones_tbEstadosLiquidacion] FOREIGN KEY ([cnsctvo_cdgo_estdo_lqdcn]) REFERENCES [dbo].[tbEstadosLiquidacion] ([cnsctvo_cdgo_estdo_lqdcn]),
    CONSTRAINT [FK_tbLiquidaciones_tbPeriodosliquidacion] FOREIGN KEY ([cnsctvo_cdgo_prdo_lqdcn]) REFERENCES [dbo].[tbPeriodosliquidacion] ([cnsctvo_cdgo_prdo_lqdcn]),
    CONSTRAINT [FK_tbLiquidaciones_tbTipoProceso] FOREIGN KEY ([cnsctvo_cdgo_tpo_prcso]) REFERENCES [dbo].[tbTipoProceso] ([cnsctvo_cdgo_tpo_prcso])
);


GO
CREATE NONCLUSTERED INDEX [idx_estdo_lqdcn]
    ON [dbo].[tbLiquidaciones]([cnsctvo_cdgo_estdo_lqdcn] ASC)
    INCLUDE([cnsctvo_cdgo_lqdcn], [cnsctvo_cdgo_prdo_lqdcn]);


GO
CREATE NONCLUSTERED INDEX [idx_prdo_estdo_lqdcn]
    ON [dbo].[tbLiquidaciones]([cnsctvo_cdgo_prdo_lqdcn] ASC, [cnsctvo_cdgo_estdo_lqdcn] ASC)
    INCLUDE([cnsctvo_cdgo_lqdcn]);


GO
/*---------------------------------------------------------------------------------
* Nombre                 	: TrReferencia_tbLiquidaciones
* Desarrollado por	: <\A Ing. Jorge Meneses  A\>
* Descripcion	 	: <\D Garantiza integridad referencial con una tabla en otra base de Datos  D\>
* Observaciones     	: <\O  O\>
* Parametros		: <\P   P\>
* Variables		: <\V   V\>
* Fecha Creacion	: <\FC 2002/07/01 FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------
* Modificado Por	     	: <\AM  AM\>
* Descripcion		: <\DM  DM\>
* Nuevos Parametros	: <\PM  PM\>
* Nuevas Variables	: <\VM  VM\>
* Fecha Modificacion	: <\FM  FM\>
-----------------------------------------------------------------------------------*/
CREATE TRIGGER  [dbo].[TrReferencia_tbLiquidaciones_usro_crcn]    ON    [dbo].[tbLiquidaciones]
FOR  INSERT,UPDATE
AS
Begin

Declare 	@lcmnsje	varchar(400)

Set Nocount On

If Not Exists (Select p.lgn_usro 
		From [bdSeguridad].[dbo].[tbUsuarios] p, Inserted i
		Where p.lgn_usro = i.usro_crcn)
	Begin
		Rollback Transaction
		Select @lcmnsje  =  'Error:,  Violación de Integridad Referencial con bdSeguridad.tbUsuarios.usro_crcn'
		RAISERROR(999902, 16, 1,  @lcmnsje)
		Return
	End
End


GO
/*---------------------------------------------------------------------------------
* Metodo o PRG 			:  TrIncidencias_tbLiquidaciones
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

CREATE TRIGGER [dbo].[TrIncidencias_tbLiquidaciones] On [BDCarteraPAC].[dbo].[tbLiquidaciones]
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
		
	SET @nombre_tabla	= 'bdCarteraPac.DBO.tbLiquidaciones'
	SET @mascara_1_64 	=0x0000000000000400 --de derecha a izquierda: 0010000000000000010000001011100001111101000010000000000000100000
	SET @mascara_128_65 	= 0x0000000000000000 --de izquierda a derecha
	SET @mascara_combinada	= 0x0400 
			         
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
						)SELECT 'bdCarteraPac', 'tbLiquidciones',@lcCampo,
						99999, d.cnsctvo_cdgo_estdo_lqdcn, n.cnsctvo_cdgo_estdo_lqdcn,
						@lcUsuario,  @lcFechaIncidencia , d.cnsctvo_cdgo_lqdcn
							FROM 	deleted d, inserted n 
						 WHERE 	d.cnsctvo_cdgo_lqdcn = n.cnsctvo_cdgo_lqdcn AND 
							(
							 (
							(d.cnsctvo_cdgo_estdo_lqdcn <> n.cnsctvo_cdgo_estdo_lqdcn And d.cnsctvo_cdgo_estdo_lqdcn Is Not Null	And n.cnsctvo_cdgo_estdo_lqdcn Is Not Null)	Or
							 (d.cnsctvo_cdgo_estdo_lqdcn Is Null And n.cnsctvo_cdgo_estdo_lqdcn Is Not Null) Or 
							 (n.cnsctvo_cdgo_estdo_lqdcn Is Null And d.cnsctvo_cdgo_estdo_lqdcn is Not null))
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

