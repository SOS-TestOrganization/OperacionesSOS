CREATE TABLE [dbo].[tbEstadosCuenta] (
    [cnsctvo_estdo_cnta]            [dbo].[udtConsecutivo]  NOT NULL,
    [cnsctvo_cdgo_lqdcn]            [dbo].[udtConsecutivo]  NOT NULL,
    [fcha_gnrcn]                    DATETIME                NOT NULL,
    [nmro_unco_idntfccn_empldr]     [dbo].[udtConsecutivo]  NOT NULL,
    [cnsctvo_scrsl]                 [dbo].[udtConsecutivo]  NOT NULL,
    [cnsctvo_cdgo_clse_aprtnte]     [dbo].[udtConsecutivo]  NOT NULL,
    [ttl_fctrdo]                    [dbo].[udtValorGrande]  NOT NULL,
    [vlr_iva]                       [dbo].[udtValorGrande]  NOT NULL,
    [sldo_fvr]                      [dbo].[udtValorGrande]  NOT NULL,
    [ttl_pgr]                       [dbo].[udtValorGrande]  NOT NULL,
    [sldo_estdo_cnta]               [dbo].[udtValorGrande]  NOT NULL,
    [sldo_antrr]                    [dbo].[udtValorGrande]  NOT NULL,
    [Cts_Cnclr]                     [dbo].[udtValorPequeno] NOT NULL,
    [Cts_sn_Cnclr]                  [dbo].[udtValorPequeno] NOT NULL,
    [nmro_estdo_cnta]               VARCHAR (15)            NOT NULL,
    [cnsctvo_cdgo_estdo_estdo_cnta] [dbo].[udtConsecutivo]  NOT NULL,
    [usro_crcn]                     [dbo].[udtUsuario]      NOT NULL,
    [Fcha_crcn]                     DATETIME                NOT NULL,
    [fcha_imprsn]                   DATETIME                NULL,
    [cnsctvo_cdgo_prdcdd_prpgo]     [dbo].[udtConsecutivo]  NULL,
    [dgto_chqo]                     CHAR (1)                NULL,
    [imprso]                        CHAR (1)                NULL,
    [usro_imprsn]                   [dbo].[udtUsuario]      NULL,
    [tme_stmp]                      ROWVERSION              NOT NULL,
    [cnsctvo_cdgo_rslcn_dn]         [dbo].[udtConsecutivo]  NULL,
    [cnsctvo_cdgo_tpo_dcmnto]       [dbo].[udtConsecutivo]  NULL,
    [cnsctvo_cdgo_estdo_dcmnto_fe]  [dbo].[udtConsecutivo]  NULL,
    [cdgo_brrs]                     VARCHAR (MAX)           NULL,
    [txto_vncmnto]                  VARCHAR (50)            NULL,
    [cufe]                          VARCHAR (MAX)           NULL,
    [cdna_qr]                       VARCHAR (MAX)           NULL,
    CONSTRAINT [PK_tbEstadosCuenta] PRIMARY KEY CLUSTERED ([cnsctvo_estdo_cnta] ASC),
    CONSTRAINT [FK_tbEstadosCuenta_tbEstadosDocumento] FOREIGN KEY ([cnsctvo_cdgo_estdo_dcmnto_fe]) REFERENCES [dbo].[tbEstadosDocumentoFE] ([cnsctvo_cdgo_estdo_dcmnto_fe]),
    CONSTRAINT [FK_tbEstadosCuenta_tbTipoDocumentos] FOREIGN KEY ([cnsctvo_cdgo_tpo_dcmnto]) REFERENCES [dbo].[tbTipoDocumentos] ([cnsctvo_cdgo_tpo_dcmnto])
);


GO
CREATE NONCLUSTERED INDEX [missing_index_1]
    ON [dbo].[tbEstadosCuenta]([sldo_antrr] ASC, [sldo_estdo_cnta] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_empldr_clse_estdo_cnta]
    ON [dbo].[tbEstadosCuenta]([nmro_unco_idntfccn_empldr] ASC, [cnsctvo_cdgo_clse_aprtnte] ASC, [cnsctvo_cdgo_estdo_estdo_cnta] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_1]
    ON [dbo].[tbEstadosCuenta]([nmro_unco_idntfccn_empldr] ASC, [cnsctvo_scrsl] ASC, [cnsctvo_cdgo_clse_aprtnte] ASC)
    INCLUDE([Fcha_crcn], [nmro_estdo_cnta], [cnsctvo_cdgo_lqdcn]) WITH (FILLFACTOR = 80);


GO
CREATE STATISTICS [ttl_fctrdo]
    ON [dbo].[tbEstadosCuenta]([ttl_fctrdo], [cnsctvo_estdo_cnta]);


GO
CREATE STATISTICS [vlr_iva]
    ON [dbo].[tbEstadosCuenta]([vlr_iva], [cnsctvo_estdo_cnta]);


GO
CREATE STATISTICS [Cts_Cnclr]
    ON [dbo].[tbEstadosCuenta]([Cts_Cnclr], [cnsctvo_estdo_cnta]);


GO
CREATE STATISTICS [Cts_sn_Cnclr]
    ON [dbo].[tbEstadosCuenta]([Cts_sn_Cnclr], [cnsctvo_estdo_cnta]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbEstadosCuenta]([usro_crcn], [cnsctvo_estdo_cnta]);


GO
CREATE STATISTICS [dgto_chqo]
    ON [dbo].[tbEstadosCuenta]([dgto_chqo], [cnsctvo_estdo_cnta]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbEstadosCuenta]([tme_stmp]);


GO
/*---------------------------------------------------------------------------------
* Nombre                 	: TrReferencia_tbEstadosCuenta
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
CREATE TRIGGER  [dbo].[TrReferencia_tbEstadosCuenta_usro_crcn]    ON    [dbo].[tbEstadosCuenta]
FOR  INSERT,UPDATE
AS


Set Nocount On
Declare 	@lcmnsje	varchar(400)
Begin

		-- Si el usuario no es null valido que exista en tbUsuarios
		If  exists(select 1 from  Inserted Where usro_crcn is not null)
		  Begin

			If Not Exists (Select p.lgn_usro 
			from [bdseguridad].[dbo].[tbusuarios] p, Inserted i
			Where p.lgn_usro  = i.usro_crcn )
			Begin
				ROLLBACK TRANSACTION
				select @lcmnsje  =  'Error: Violación de Integridad Referencial con bdSeguridad.tbUsuarios';
				THROW 51000, @lcmnsje, 1;
				RETURN
			End
		 End
End


GO
DISABLE TRIGGER [dbo].[TrReferencia_tbEstadosCuenta_usro_crcn]
    ON [dbo].[tbEstadosCuenta];


GO
/*---------------------------------------------------------------------------------
* Nombre                 : 
* Desarrollado por	 : <\A Ing. Jorge Meneses  A\>
* Descripcion		 : <\D Garantiza integridad referencial con una tebla en otra base de Datos  D\>
* Observaciones          : <\O  O\>
* Parametros		 : <\P   P\>
* Variables		 : <\V   V\>
* Fecha Creacion	 : <\FC 2002/07/01 FC\>
* Modificado		:  Ing. Javier Paez
*---------------------------------------------------------------------------------*/
CREATE TRIGGER  [dbo].[TrReferencia_tbEstadosCuenta_cnsctvo_cdgo_prdcdd_prpgo]    ON [dbo].[tbEstadosCuenta]
FOR  INSERT,UPDATE
AS
Begin
DECLARE 	@lcmnsje	varchar(400)
SET NOCOUNT ON
If Exists(Select 1 From Inserted)
Begin 
If Not Exists (Select p.cnsctvo_cdgo_prdo

			from [bdAfiliacion].[dbo].[tbPeriodos] p, Inserted i
			Where p.cnsctvo_cdgo_prdo  = i.cnsctvo_cdgo_prdcdd_prpgo )
	Begin
		ROLLBACK TRANSACTION
		select @lcmnsje  =  'Error:,  Violación de Integridad Referencial con bdAfiliacion..tbPeriodos'
		RAISERROR(999902, 16, 1,  @lcmnsje)
		RETURN
	End
End
End


GO
/*---------------------------------------------------------------------------------
* Nombre                 : 	 TrReferencia_ttbEstadosCuenta_nmro_unco_idntfccn_empldr  
* Desarrollado por	 : <\A Ing. Jorge Meneses  A\>
* Descripcion		 : <\D Garantiza integridad referencial con una tebla en otra base de Datos  D\>
* Observaciones          : <\O  O\>
* Parametros		 : <\P   P\>
* Variables		 : <\V   V\>
* Fecha Creacion	 : <\FC 2002/07/01 FC\>
* Modificado		:  Ing. Javier Paez
*---------------------------------------------------------------------------------*/
CREATE TRIGGER  [dbo].[TrReferencia_ttbEstadosCuenta_nmro_unco_idntfccn_empldr]  ON [dbo].[tbEstadosCuenta]
FOR  INSERT,UPDATE


AS
Begin
	Declare 	@lcmnsje	varchar(400)
	Set Nocount On
	If Exists(Select 1 From Inserted)
	Begin
		If Not Exists (Select p.nmro_unco_idntfccn_empldr
				From [bdAfiliacion].[dbo].[tbSucursalesaportante] p, Inserted i
				Where p.nmro_unco_idntfccn_empldr 	 = i.nmro_unco_idntfccn_empldr
				And     p.cnsctvo_scrsl		    	 = i.cnsctvo_scrsl
				And     p.cnsctvo_cdgo_clse_aprtnte	 = i.cnsctvo_cdgo_clse_aprtnte	)					
		Begin
			ROLLBACK TRANSACTION
			select @lcmnsje  = 'Error:,  Violación de Integridad Referencial con bdAfiliacion..tbSucursalesaportante';
			THROW 51000, @lcmnsje, 1;
			RETURN
		End
	End
End


GO
/*---------------------------------------------------------------------------------
* Metodo o PRG 			:  TrIncidencias_tbEstadosCuenta
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

CREATE TRIGGER [dbo].[TrIncidencias_tbEstadosCuenta]
On [BDCarteraPAC].[dbo].[tbEstadosCuenta]
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

	SET @nombre_tabla		= 'bdCarteraPac.DBO.tbEstadosCuenta'
	SET @mascara_1_64 		= 0x0000000000000D00    --de derecha a izquierda: 0010000000000000010000001011100001111101000010000000000000100000
	SET @mascara_128_65 	= 0x0000000000000000 --de izquierda a derecha
	SET @mascara_combinada	= 0x000D00 
 
      
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


					IF @id_columna = 9
				
						INSERT INTO [bdCarteraPac].[dbo].[tbIncidenciasCarteraPac] (
							 bse_dts, nmbre_tbla, nmbre_cmpo, 
							cnsctvo_vgnca, vlr_antrr, vlr_nvo,
							usro_incdnca, fcha_incdnca, cnsctvo_rgstro_afctdo
						)SELECT  
						'bdCarteraPac', 'tbEstadosCuenta',@lcCampo,
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


							ELSE 	IF @id_columna = 11
						INSERT INTO [bdCarteraPac].[dbo].[tbIncidenciasCarteraPac] (
							 bse_dts, nmbre_tbla, nmbre_cmpo, 
							cnsctvo_vgnca, vlr_antrr, vlr_nvo,
							usro_incdnca, fcha_incdnca, cnsctvo_rgstro_afctdo
						)SELECT 'bdCarteraPac', 'tbEstadosCuenta',@lcCampo,
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
							ELSE 	IF @id_columna = 12
						INSERT INTO [bdCarteraPac].[dbo].[tbIncidenciasCarteraPac] (
							 bse_dts, nmbre_tbla, nmbre_cmpo, 
							cnsctvo_vgnca, vlr_antrr, vlr_nvo,
							usro_incdnca, fcha_incdnca, cnsctvo_rgstro_afctdo
						)SELECT 'bdCarteraPac', 'tbEstadosCuenta',@lcCampo,
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

