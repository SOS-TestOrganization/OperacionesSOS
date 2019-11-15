CREATE TABLE [dbo].[tbDiasCobroMoraSucursal_Vigencias] (
    [cnsctvo_vgnca_da_mra_scrsl] [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_da_mra_scrsl]  [dbo].[udtConsecutivo] NOT NULL,
    [inco_vgnca]                 DATETIME               NOT NULL,
    [fn_vgnca]                   DATETIME               NOT NULL,
    [fcha_crcn]                  DATETIME               NOT NULL,
    [usro_crcn]                  [dbo].[udtUsuario]     NOT NULL,
    [cnsctvo_cdgo_ds_mra]        [dbo].[udtConsecutivo] NOT NULL,
    [nmro_unco_idntfccn_empldr]  [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_scrsl]              [dbo].[udtConsecutivo] NOT NULL,
    [cnsctvo_cdgo_clse_aprtnte]  [dbo].[udtConsecutivo] NOT NULL,
    [tme_stmp]                   ROWVERSION             NOT NULL,
    CONSTRAINT [PK_TbDiasCobroMora] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_da_mra_scrsl] ASC),
    CONSTRAINT [CK_tbDiasCobroMoraSucursal_Vigencias] CHECK ([inco_vgnca] < [fn_vgnca]),
    CONSTRAINT [FK_tbDiasCobroMoraSucursal_Vigencias_tbDiasCobroMoraSucursal] FOREIGN KEY ([cnsctvo_cdgo_da_mra_scrsl]) REFERENCES [dbo].[tbDiasCobroMoraSucursal] ([cnsctvo_cdgo_da_mra_scrsl]) ON DELETE CASCADE,
    CONSTRAINT [FK_tbDiasCobroMoraSucursal_Vigencias_tbDiasMora] FOREIGN KEY ([cnsctvo_cdgo_ds_mra]) REFERENCES [dbo].[tbDiasMora] ([cnsctvo_cdgo_ds_mra])
);


GO
CREATE STATISTICS [cnsctvo_cdgo_da_mra_scrsl]
    ON [dbo].[tbDiasCobroMoraSucursal_Vigencias]([cnsctvo_cdgo_da_mra_scrsl], [cnsctvo_vgnca_da_mra_scrsl]);


GO
CREATE STATISTICS [inco_vgnca]
    ON [dbo].[tbDiasCobroMoraSucursal_Vigencias]([inco_vgnca], [cnsctvo_vgnca_da_mra_scrsl]);


GO
CREATE STATISTICS [fn_vgnca]
    ON [dbo].[tbDiasCobroMoraSucursal_Vigencias]([fn_vgnca], [cnsctvo_vgnca_da_mra_scrsl]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbDiasCobroMoraSucursal_Vigencias]([fcha_crcn], [cnsctvo_vgnca_da_mra_scrsl]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbDiasCobroMoraSucursal_Vigencias]([usro_crcn], [cnsctvo_vgnca_da_mra_scrsl]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbDiasCobroMoraSucursal_Vigencias]([tme_stmp]);


GO

/*---------------------------------------------------------------------------------
* Nombre                 	: TrIncidencias_tbDiasCobroMoraSucursal_Vigencias
* Desarrollado por	: <\A Ing. Maribel Valencia Herrera				 A\>
* DescripciÃ³n		: <\D Inserta un registro en la tabla tbIncidenciasCarteraPac 		D\>
* 			  <\D Cuando se actualiza un Campo de tbDiasCobroMoraSucursal_Vigencias  D\>
* Observaciones       	: <\O  O\>
* Parametros		: <\P   P\>
* Variables		: <\V @lcFechaIncidencia  : Fecha en la que ocurre la incidencia 	V\>
*			  <\V IdColumna  	: Identificador de columna		 V\>
*			  <\V @lcCampo 	: Nombre de Campo			 V\>
*			  <\V @lcUsuario 	: LogIn de Usuario 			V\>
*			  <\V @InsertString	 : Cadena de inserción  			V\>
*			  <\V@cntdd_clmns	:  Numero de columnas de la tabla 	V\>
*			  <\V @cnsctvo_in 	:Consecutivo de la incidencia		V\>
*			  <\V @fcha_antrr	: Fecha Anterior				V\>
*			  <\V @fcha_nva	: Fecha Nueva 				V\>
* Fecha Creacion	: <\FC 2003/03/17 FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------
* Modificado Por	     	: <\AM  Ing. Diana Lorena Gomez Betancourt AM\>
* Descripcion		: <\DM  Se optimizó creandolo de acuerdo a la forma definida por TRIONIK , se quito el consecutivo de incidencia ya que este en la tabla es un INDENTITY DM\>
* Nuevos Parametros	: <\PM  PM\>
* Nuevas Variables	: <\VM  VM\>
* Fecha Modificacion	: <\FM 2008/06/24 FM\>
-----------------------------------------------------------------------------------*/

CREATE TRIGGER [dbo].[TrIncidencias_tbDiasCobroMoraSucursal_Vigencias]   On [dbo].[tbDiasCobroMoraSucursal_Vigencias]
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
		
	SET @nombre_tabla	= 'bdCarteraPac.DBO.tbDiasCobroMoraSucursal_Vigencias'
	SET @mascara_1_64 	=  0x0000000000000C00   --de derecha a izquierda: 0010000000000000010000001011100001111101000010000000000000100000
	SET @mascara_128_65 	= 0x0000000000000000             --de izquierda a derecha
	SET @mascara_combinada	=  0x0C00           

							 
							 
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
						)SELECT 'bdCarteraPac', 'tbDiasCobroMoraSucursal_Vigencias',@lcCampo,
						d.cnsctvo_vgnca_da_mra_scrsl, d.inco_vgnca, n.inco_vgnca,
						@lcUsuario,  @lcFechaIncidencia , d.cnsctvo_cdgo_da_mra_scrsl
							FROM 	deleted d, inserted n 
						 WHERE 	d.cnsctvo_cdgo_da_mra_scrsl = n.cnsctvo_cdgo_da_mra_scrsl AND 
							(
							 (
							(d.inco_vgnca <> n.inco_vgnca And d.inco_vgnca Is Not Null	And n.inco_vgnca Is Not Null)	Or
							 (d.inco_vgnca Is Null And n.inco_vgnca Is Not Null) Or 
							 (n.inco_vgnca Is Null And d.inco_vgnca is Not null))
							)
							
					ELSE 	IF @id_columna = 4
						INSERT INTO [bdCarteraPac].[dbo].[tbIncidenciasCarteraPac] (
							 bse_dts, nmbre_tbla, nmbre_cmpo, 
							cnsctvo_vgnca, vlr_antrr, vlr_nvo,
							usro_incdnca, fcha_incdnca, cnsctvo_rgstro_afctdo
						)SELECT 'bdCarteraPac', 'tbDiasCobroMoraSucursal_Vigencias',@lcCampo,
						d.cnsctvo_vgnca_da_mra_scrsl, d.fn_vgnca, n.fn_vgnca,
						@lcUsuario,  @lcFechaIncidencia , d.cnsctvo_cdgo_da_mra_scrsl
							FROM 	deleted d, inserted n 
						 WHERE 	d.cnsctvo_cdgo_da_mra_scrsl = n.cnsctvo_cdgo_da_mra_scrsl AND 
							(
							 (
							(d.fn_vgnca <> n.fn_vgnca And d.fn_vgnca Is Not Null	And n.fn_vgnca Is Not Null)	Or
							 (d.fn_vgnca Is Null And n.fn_vgnca Is Not Null) Or 
							 (n.fn_vgnca Is Null And d.fn_vgnca is Not null))
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


GO
/*--------------------------------------------------------------------------------------------------------
* Nombre                 	:	TrReferencia_Usuario_tbDiasCobroMoraSucursal_Vigencias
* Desarrollado por	: <\A	Ing. Jorge Meneses			  A\>
* Descripcion	 	: <\D	Garantiza integridad referencial con una tabla en otra base de Datos D\>
* Observaciones     	: <\O	O\>
* Parametros		: <\P	P\>
* Variables		: <\V	V\>
* Fecha Creacion	: <\FC 2002/07/01	FC\>
*--------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*--------------------------------------------------------------------------------------------------------
* Modificado Por	   	: <\AM Ing. Maribel Valencia Herrera		AM\>
* Descripcion		: <\DM El mensaje no corresponde a la validacion del trigger y es muy técnico para el usuario  DM\>
			  <\DM Error, Violación de Integridad Referencial con bdSeguridad.tbUsuarios.usro_crcn	 DM\>
			  <\DM el trigger valida que el usuario se encuentrecreado  en  bdSeguridad.tbUsuarios.usro_crcn	 DM\>			 DM\>
* Nuevos Parametros	: <\PM		PM\>
* Nuevas Variables	: <\VM		VM\>
* Fecha Modificacion	: <\FM		FM\>
*------------------------------------------------------------------------------------------------------*/
CREATE TRIGGER  [dbo].[TrReferencia_Usuario_tbDiasCobroMoraSucursal_Vigencias] ON    [dbo].[tbDiasCobroMoraSucursal_Vigencias]
FOR  INSERT,UPDATE
AS
Begin
	Declare 	@lcmnsje	varchar(400),
			@lcusro		varchar(10)
	Set Nocount On
	
	If Not Exists (	Select	 p.lgn_usro From	[bdSeguridad].[dbo].[tbUsuarios] p, Inserted i
			Where	p.lgn_usro = i.usro_crcn)
	Begin
		Select	@lcusro=  i.usro_crcn From	 Inserted i
		Rollback Transaction
		Select 	@lcmnsje  =  'Error, El Usuario '+  @lcusro+' no se encuentra creado en  bdSeguridad..tbUsuarios.usro_crcn'
		RAISERROR(999902, 16, 1,  @lcmnsje)
		Return
	End
End



GO
/*---------------------------------------------------------------------------------
* Metodo o PRG 	            	 :   TrValidaTraslapeRel_tbDiasCobroMoraSucursal_Vigencias
* Desarrollado por		 :  <\A    Ing. Rolando Simbaqueva				A\>
* Descripcion			:  <\D   valida el ingreso de fechas que no se traslape en la tabla.	D\>
* Observaciones			:  <\O								O\>
* Parametros			 :  <\P    							P\>
* Variables			 :  <\V	Consecutivo codigo documento soporte			V\>
				:  <\V	Consecutivo codigo documento soporte			V\>
				:  <\V	Inicio vigencia documento soporte	         	  	V\>
				:  <\V	Fin vigencia documento soporte				V\>
				:  <\V	Inicio vigencia documento soporte			V\>
				:  <\V	Fin Vigencia documento soporte				V\>
				:  <\V	Inicio Vigencia rol empresa				V\>
				:  <\V	Fin Vigencia dsn						V\>
				:  <\V	Mensaje de dsn						V\>
				:  <\V	Numero de registros que cumpla la condicion		V\>
				:  <\V	variables logica del borrado de la tabla			V\>
* Fecha Creacion		 :  <\FC  2002/07/09						FC\>
*  
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------  
* Modificado Por			 : <\AM   AM\>
* Descripcion			 : <\DM   DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM   FM\>
*---------------------------------------------------------------------------------*/

CREATE TRIGGER   [dbo].[TrValidaTraslapeRel_tbDiasCobroMoraSucursal_Vigencias]  ON    [dbo].[tbDiasCobroMoraSucursal_Vigencias]
FOR  INSERT,UPDATE
AS
declare @Identificador_Tabla1					udtconsecutivo,
	@Identificador_Tabla2_nmro_unco_idntfccn_empldr		udtconsecutivo,
	@Identificador_Tabla2_cnsctvo_scrsl			udtconsecutivo,
	@Identificador_Tabla2_cnsctvo_cdgo_clse_aprtnte		udtconsecutivo,
	@inco_vgnca_Tabla1		datetime,
	@fn_vgnca_Tabla1		datetime,
	@inco_vgnca_Tabla2         	datetime,
	@fn_vgnca_Tabla2	       	datetime,
	@inco_vgnca_Rel     		datetime,
	@fn_vgnca_Rel      		datetime,
	@tinco_vgnca			datetime,
	@tfn_vgnca			datetime,
	@mnsje  		    	varchar(400), 
	@contador 		    	int,
	@brrdo                      	udtlogico,
	@cnsctvo_vgnca			udtConsecutivo

Begin

SET NOCOUNT ON

        --Se capturan las variables que se estan tratando de insertar
SELECT    @inco_vgnca_Rel = inco_vgnca,
	    @fn_vgnca_Rel = fn_vgnca,
	    @Identificador_Tabla1= cnsctvo_cdgo_ds_mra, 
	    @Identificador_Tabla2_nmro_unco_idntfccn_empldr	=	nmro_unco_idntfccn_empldr,
	    @Identificador_Tabla2_cnsctvo_scrsl			=	cnsctvo_scrsl,
	    @Identificador_Tabla2_cnsctvo_cdgo_clse_aprtnte	=	cnsctvo_cdgo_clse_aprtnte,	
	    @cnsctvo_vgnca 					= 	cnsctvo_vgnca_da_mra_scrsl
FROM        INSERTED



--Comprar las varibles de entrada contra la tabla tbTabla1 
-- para encontrar un rango de vigencias que contemple la relacion


SELECT @contador=count(*)
	FROM  tbdiasmora_Vigencias p
	WHERE convert(varchar(10),p.inco_vgnca,111)  <= convert(varchar(10),@inco_vgnca_Rel,111)  and 
		convert(varchar(10),p.fn_vgnca,111)    >= convert(varchar(10),@fn_vgnca_Rel,111) 
	And	p.cnsctvo_cdgo_ds_mra = @Identificador_Tabla1


--Si no se encuentra en el rango no  actualiza 
If    @contador<1     
	 Begin
	      ROLLBACK TRANSACTION
	      select @mnsje  =  'Error, no cumple con el rango de fechas en el Parámetro tbdiasmora_Vigencias'  
	      RAISERROR (999901, 16, 1,  @mnsje)
	      RETURN
	 End


--Comprar las varibles de entrada contra la tabla tbTabla 2 
-- para encontrar un rango de vigencias que contemple la relacion

set @contador=0
SELECT @contador=count(*)
	FROM bdAfiliacion..tbSucursalesAportante p
	WHERE cnsctvo_scrsl		=  @Identificador_Tabla2_cnsctvo_scrsl		
	And   nmro_unco_idntfccn_empldr	=  @Identificador_Tabla2_nmro_unco_idntfccn_empldr
	And   cnsctvo_cdgo_clse_aprtnte =  @Identificador_Tabla2_cnsctvo_cdgo_clse_aprtnte



--Si no se encuentra en el rango no  actualiza 
If    @contador<1      
	 Begin
	      ROLLBACK TRANSACTION
	      select @mnsje  =  'Error, no cumple con el rango de fechas en el Parámetro bdAfiliacion..tbSucursalesAportante  '  
	      RAISERROR (999901, 16, 1,  @mnsje)
	      RETURN
	 End


set @contador=0
--Se Calcula si hay  traslape de fechas
 SELECT  @contador   =  count(*)
 FROM	tbDiasCobroMoraSucursal_Vigencias
 WHERE ( ( convert(varchar(10),inco_vgnca,111)  >=  convert(varchar(10),@inco_vgnca_Rel,111) 
 And             convert(varchar(10),inco_vgnca,111) <=   convert(varchar(10),@fn_vgnca_Rel,111))   Or
	      (convert(varchar(10),fn_vgnca,111) 	>=   convert(varchar(10),@inco_vgnca_Rel,111) 
 And             convert(varchar(10),fn_vgnca,111)	<=   convert(varchar(10),@fn_vgnca_Rel,111))   Or
 	      (convert(varchar(10),inco_vgnca,111) <=   convert(varchar(10),@inco_vgnca_Rel,111) 
 And             convert(varchar(10),fn_vgnca,111)	>=   convert(varchar(10),@fn_vgnca_Rel,111)))  
And            cnsctvo_cdgo_ds_mra 		=  @Identificador_Tabla1
And	       cnsctvo_scrsl			=  @Identificador_Tabla2_cnsctvo_scrsl		
And   	       nmro_unco_idntfccn_empldr	=  @Identificador_Tabla2_nmro_unco_idntfccn_empldr
And            cnsctvo_cdgo_clse_aprtnte 	=  @Identificador_Tabla2_cnsctvo_cdgo_clse_aprtnte



IF @contador > 1
          --Hay traslape de fechas
	 Begin
		SELECT @tinco_vgnca=inco_vgnca,@tfn_vgnca=fn_vgnca
		FROM tbDiasCobroMoraSucursal_Vigencias p
		WHERE ( ( convert(varchar(10),inco_vgnca,111)  >=  convert(varchar(10),@inco_vgnca_Rel,111) 
 		And             convert(varchar(10),inco_vgnca,111) <=   convert(varchar(10),@fn_vgnca_Rel,111))   Or
			      (convert(varchar(10),fn_vgnca,111) 	>=   convert(varchar(10),@inco_vgnca_Rel,111) 
		 And             convert(varchar(10),fn_vgnca,111)	<=   convert(varchar(10),@fn_vgnca_Rel,111))   Or
 			      (convert(varchar(10),inco_vgnca,111) <=   convert(varchar(10),@inco_vgnca_Rel,111) 
 		And             convert(varchar(10),fn_vgnca,111)	>=   convert(varchar(10),@fn_vgnca_Rel,111)))  
		And            cnsctvo_cdgo_ds_mra 		=  @Identificador_Tabla1
		And	       cnsctvo_scrsl			=  @Identificador_Tabla2_cnsctvo_scrsl		
		And   	       nmro_unco_idntfccn_empldr	=  @Identificador_Tabla2_nmro_unco_idntfccn_empldr
		And            cnsctvo_cdgo_clse_aprtnte 	=  @Identificador_Tabla2_cnsctvo_cdgo_clse_aprtnte
  	      	and            p.cnsctvo_vgnca_da_mra_scrsl	!= @cnsctvo_vgnca

		
		ROLLBACK TRANSACTION
		select @mnsje  =  'Error, Insertando, Existe  Traslape con  '+  convert(varchar(10),@tinco_vgnca,111) + '  ' + convert(varchar(10),@tfn_vgnca,111)
		RAISERROR (999905, 16, 1,  @mnsje)
		RETURN


	  
	 End

End



GO
/*---------------------------------------------------------------------------------
* Nombre		: TrValidaUpdateTraslapeRel_tbDiasCobroMoraSucursal_Vigencias
* Desarrollado por	: <\A Ing. Maribel Valenciaa				A\>
* Descripcion		: <\D Valida Las modificaciones de las vigencias D\>
* Observaciones		: <\O							O\>
* Parametros		: <\P   Fecha Inicial						P\>
*			: <\P   Fecha Final						P\>
*			: <\P   Mensaje de Error					P\>
*			: <\P   Contador  de registros					P\>
* Variables		: <\V								V\>
* Fecha Creacion		: <\FC 2003/03/21					FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM  AM\>
* Descripcion		: <\DM  DM\>
* Nuevos Parametros	: <\PM  PM\>
* Nuevas Variables	: <\VM  VM\>
* Fecha Modificacion	: <\FM  FM\>
-----------------------------------------------------------------------------------*/
CREATE TRIGGER  [dbo].[TrValidaUpdateTraslapeRel_tbDiasCobroMoraSucursal_Vigencias]    ON   [dbo].[tbDiasCobroMoraSucursal_Vigencias]
FOR  UPDATE
AS
Begin

SET NOCOUNT ON
	DECLARE	@inco_vgnca	datetime,     
			@fn_vgnca		datetime,      
			@tinco_vgnca	datetime,     
			@tfn_vgnca		datetime,      
			@mnsje		varchar(400), 
			@contador		int,
			@Codigo_Consecutivo		udtCodigo,
			@dinco_vgnca			datetime,     
      		  	@dfn_vgnca			datetime,
      			@dcnsctvo_tbla			udtConsecutivo,
			@cdgo_ara		udtcodigo,
			@cnsctvo_vgnca	udtcodigo

  --Se capturan las variables que se estan tratando de insertar
	SELECT	@inco_vgnca = inco_vgnca,
			@fn_vgnca	= fn_vgnca,
			@Codigo_Consecutivo = cnsctvo_cdgo_da_mra_scrsl
	FROM   INSERTED


       	
--    Se capturan las variables que se estan modificando
	SELECT     @dinco_vgnca   =  inco_vgnca,
	        		      @dfn_vgnca     =  fn_vgnca,
		     	      @dcnsctvo_tbla = cnsctvo_cdgo_da_mra_scrsl,
			@cnsctvo_vgnca 	= cnsctvo_vgnca_da_mra_scrsl     
	FROM	deleted


 
-->Obtener la imagen de los registros Modificados (Deleted) e Insertados (Inserted)
select * into #tbValoresAnteriores From Deleted
select * into #tbValoresNuevos From Inserted



--valida que los campos que se estan modificando sean los campos de fecha de vigencia 
if  Exists (select * from #tbValoresAnteriores d,  #tbValoresNuevos n
              where   (convert(varchar(10),d.inco_vgnca,111)<>convert(varchar(10),n.inco_vgnca,111)
             		or convert(varchar(10),d.fn_vgnca,111)<>convert(varchar(10),n.fn_vgnca,111))
              and d.cnsctvo_cdgo_da_mra_scrsl = n.cnsctvo_cdgo_da_mra_scrsl)


begin
     

-- Valida que el parametro a modificar sea vigente
		if  (convert(varchar(10),@dfn_vgnca,111) < convert(varchar(10),getDate(),111)  and 
                                convert(varchar(10),@inco_vgnca,111) <= convert(varchar(10),@dfn_vgnca,111) and
                                convert(varchar(10),@fn_vgnca,111) >=  convert(varchar(10),@dinco_vgnca,111)  )
		 
		
		    	 begin

				Drop Table #tbValoresAnteriores
				Drop Table #tbValoresNuevos
  				ROLLBACK TRANSACTION
				select @mnsje  =  'Error,  No se puede Modificar la Vigencia de un Parámetro no Vigente'
				RAISERROR (999909, 16, 1,  @mnsje)
				RETURN
		                end
-- Valida que si el parametro es vigente no pueda incrementar inicio vigencia

			if convert(varchar(10),@dfn_vgnca,111) >=convert(varchar(10),getDate(),111)  and 
                           	     	convert(varchar(10),@dinco_vgnca,111)<=convert(varchar(10),getDate(),111)  and
				convert(varchar(10),@dinco_vgnca,111) <  convert(varchar(10),@inco_vgnca,111) and
				convert(varchar(10),@inco_vgnca,111) <  convert(varchar(10),@dfn_vgnca,111)					
				begin 
					Drop Table #tbValoresAnteriores
					Drop Table #tbValoresNuevos
					ROLLBACK TRANSACTION
					select @mnsje  =  'Error, No se permite Incrementar el Inicio de Vigencia de un Parámetro Vigente '
					RAISERROR (999908, 16, 1,  @mnsje)
					RETURN
 				end
	

--Valida que el fin de vigencia no sea inferior a fecha actual  para un parametro vigente
	 if  convert(varchar(10),@dfn_vgnca,111) >=convert(varchar(10),getDate(),111)  and 
      				   convert(varchar(10),@fn_vgnca,111) <  convert(varchar(10),getDate(),111) and
                  convert(varchar(10),@dinco_vgnca,111) < =convert(varchar(10),@fn_vgnca,111)  
			
				begin 
					Drop Table #tbValoresAnteriores
					Drop Table #tbValoresNuevos
					ROLLBACK TRANSACTION
					select @mnsje  =  'Error, El  Fin de Vigencia debe ser Superior  a  la Fecha Actual para un Parámetro Vigente '
					RAISERROR (999907, 16, 1,  @mnsje)
					RETURN
 				end



   /*     --Se Calcula si hay  traslape de fechas
	SELECT @contador=count(*)
	FROM tbMensajesxPeriodo_Vigencias p
	WHERE ( (convert(varchar(10),p.inco_vgnca,111)  >= convert(varchar(10),@inco_vgnca,111) 
	And	convert(varchar(10),p.inco_vgnca,111)  <= convert(varchar(10),@fn_vgnca,111))   Or
		(convert(varchar(10),p.fn_vgnca,111)    >= convert(varchar(10),@inco_vgnca,111) 
	And	 convert(varchar(10),p.fn_vgnca,111)    <= convert(varchar(10),@fn_vgnca,111))   Or
		(convert(varchar(10),p.inco_vgnca,111)  <= convert(varchar(10),@inco_vgnca,111) 
	And	convert(varchar(10),p.fn_vgnca,111)     >= convert(varchar(10),@fn_vgnca,111)))  
	And	p.cnsctvo_mnsje_prdo = @Codigo_Consecutivo
    

	IF @contador > 1
              --Hay traslape de fechas
	Begin
		SELECT @tinco_vgnca=inco_vgnca,@tfn_vgnca=fn_vgnca
		FROM tbMensajesxPeriodo_Vigencias p
		WHERE ( (convert(varchar(10),p.inco_vgnca,111)  >= convert(varchar(10),@inco_vgnca,111) 
		And	convert(varchar(10),p.inco_vgnca,111)  <= convert(varchar(10),@fn_vgnca,111))   Or
			(convert(varchar(10),p.fn_vgnca,111)    >= convert(varchar(10),@inco_vgnca,111) 
		And	 convert(varchar(10),p.fn_vgnca,111)    <= convert(varchar(10),@fn_vgnca,111))   Or
		(convert(varchar(10),p.inco_vgnca,111)  <= convert(varchar(10),@inco_vgnca,111) 
		And	convert(varchar(10),p.fn_vgnca,111)     >= convert(varchar(10),@fn_vgnca,111)))  
		And	p.cnsctvo_mnsje_prdo = @Codigo_Consecutivo
  	      	and       p.cnsctvo_vgnca_mnsje_prdo != @cnsctvo_vgnca

		Drop Table #tbValoresAnteriores
		Drop Table #tbValoresNuevos
		ROLLBACK TRANSACTION
		select @mnsje  =  'Error, Insertando, Existe  Traslape con  '+  convert(varchar(10),@tinco_vgnca,111) + '  ' + convert(varchar(10),@tfn_vgnca,111)
		RAISERROR (999901, 16, 1,  @mnsje)
		RETURN
	End
*/

end
End



