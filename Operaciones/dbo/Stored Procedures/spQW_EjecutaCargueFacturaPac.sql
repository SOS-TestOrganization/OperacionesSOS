
/*---------------------------------------------------------------------------------
* Metodo o PRG 		    :spQW_EjecutaCargueFacturaPac
* Desarrollado por		: <\A  Cristian Camilo Zambrano Grajales				A\>
* Descripcion			: <\D Este procedimiento sube y envia el archivo de facturasD\>
                        : <\D pac a una tabla temporal para que pueda ser procesadasD\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables				: <\V  													V\>
* Fecha Creacion		: <\FC 2019/09/18										FC\>
*
*---------------------------------------------------------------------------------
*---------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[spQW_EjecutaCargueFacturaPac]

as
 
if exists (select 1 from [Temporal].[dbo].[beneficiariosFacturar_pedido] with(nolock))

 begin

 SET LANGUAGE spanish

Declare	@instruccion	nvarchar(4000), --Construir Instruccion SQL, para obtener los campos del archivo Plano 
		@filename				Varchar(150), 
		@cmd			varchar(4000), --Variable para enviar archivo , 
		@outputfile		varchar(1000), --Nombre Archivo interfaz para el envio del archivo plano 
		@server			varchar(30), -- Nombre del Servidor donde se copia el archivo plano ,
		@instancia		varchar(30), --Nombre Servidor Base de Datos
		@resultado		int,       --Control para la copia del archivo 
		@nt				char(30),	--Nombre Archivo Interfaz 
		@rta_crpta 		varchar(100), --Ruta destino del Archivo 
		@FolderPath		varchar(100),
		@ExtractTables	varchar(500),
		@ExcelFileName	varchar(50),
		@nmro_cmncdo	varchar(15),
		@tpo_prcso		varchar(1),
		@conexion1     varchar(500)


declare @nameServer varchar(20)
set @nameServer =convert(varchar(20),SERVERPROPERTY('MachineName'))

set	@server = ltrim(rtrim(CONVERT(varchar(30), SERVERPROPERTY('machinename'))))


--Datos Nombre Servidor Base de Datos
set	@instancia = ltrim(rtrim(CONVERT(varchar(30), SERVERPROPERTY('servername')))) 

set @conexion1 = 'Data Source='+@instancia+';Initial Catalog=temporal;Integrated Security=True;Application Name=SSIS-ExtraerDatosSQLExcel-{B2E87759-48AE-4697-8150-3B96629F6E30}Selene_informes_bdFuenteSalud;'

Set	@ExcelFileName				=	'Cargue_Facturas_'+DATENAME(month,GetDate())+'_'+DATENAME(day,GetDate())+'_'+DATENAME(year,GetDate())
Set	@FolderPath			=	'\\'+@nameServer+'\CargueArchivos'
set @ExtractTables = '('+char(39)+'beneficiariosFacturar_pedido'+char(39)+')'

EXEC @resultado = bdSeguridad.dbo.[SpEjecutaDTS_cmdshell_CATALOGO] 
											@instancia,
											'\SSISDB\BajarTablasSqlExcel\ExtraerDatosSQLExcel\ExtraerDatosSQLExcel.dtsx',
											Null,
											Null,
											Null,
											Null,
											'Selene_informes_bdFuenteSalud',
											@conexion1,
											null,
											null,
											'ExcelFileName',
											@ExcelFileName,
											'ExtractTables',
											@ExtractTables,
											'FolderPath',
											@FolderPath,
											null,null,null,null,null,null,null,null




Declare		@usrs_infrme			VarChar(500),
			
			@mensaje				Varchar(500), 
			@asunto					Varchar(500),
			@profile_name			VarChar(30),
			@file_attachments		varchar(200)

Set			@usrs_infrme			=	'soporteapp-financieroyexperienciausuario@sos.com.co'
Set			@mensaje				=	'Cordial Saludo,'+char(13)+char(13)+'Anexo el cargue de facturas del Mes de '+ DATENAME(month,GetDate()) + ' día ' + DATENAME(day,GetDate()) +' del año '+ DATENAME(year,GetDate()) +'.'
Set			@asunto					=	'Cargue Facturas'

Set			@profile_name			=	'EnvioMailProcesosAutomaticos'

set @file_attachments = @FolderPath+'\'+@ExcelFileName+'.xlsx'

Exec		msdb.dbo.spEnvioEmailGeneral	@profile_name					=	@profile_name,
									@recipients					    =	@usrs_infrme,
									@subject						=	@asunto,
									@body							=	@mensaje,
									@attach_query_result_as_file	=	0,
									@file_attachments				=	@file_attachments, 
									@query_result_header            =   1

SET LANGUAGE English

end

declare @borrar varchar(1000)

set @borrar = 'del \\'+@nameServer+'\CargueArchivos\.* /Q'

-- ELIMINAR_ARCHIVO FUENTE
Exec	xp_cmdshell @borrar


