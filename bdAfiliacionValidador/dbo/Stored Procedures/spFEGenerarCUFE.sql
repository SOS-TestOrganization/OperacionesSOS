/*--------------------------------------------------------------------------------------
* Método o PRG		:		dbo.spFEGenerarCUFE							
* Desarrollado por	: <\A	Ing. Juan Carlos Vásquez García										   A\>	
* Descripción		: <\D	Procedimento : Ejecución Generar CUFE (código Unico Factura Electrónica)	D\>
* Observaciones		: <\O 	Se puede ejecutar 
							1. Por demanda enviando los parámetros 
							2. Masivo enviado los datos en un tabla temporal #tmpParametrosRecibidosCufe		   O\>	
* Parámetros		: <\P 	P\>	
* Variables			: <\V	V\>	
* Fecha Creación	: <\FC	2019/0109															FC\>
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION    
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Modificado Por     : <\AM   AM\>    
* Descripcion        : <\D  D\> 
* Nuevas Variables   : <\VM  VM\>    
* Fecha Modificacion : <\FM FM\>    
*-----------------------------------------------------------------------------------------------------------------------------------------------------------------*/

-- exec BDAfiliacionValidador.dbo.spFEGenerarCUFE

CREATE PROCEDURE  [dbo].[spFEGenerarCUFE]
	@NmroCnta       varchar(15) = null,
	@NumFac			varchar(30) = null,
	@FecFac			varchar(30) = null,
	@ValFac			varchar(30) = null,
	@CodImp1		varchar(10) = null,
	@ValImp1		varchar(30) = null,
	@CodImp2		varchar(10) = null,
	@ValImp2		varchar(30) = null,
	@CodImp3		varchar(10) = null,
	@ValImp3		varchar(30) = null,
	@ValImp			varchar(30) = null,
	@NitOFE			varchar(30) = null,
	@TipAdq			varchar(10) = null,
	@NumAdq			varchar(30) = null,
	@CITec			varchar(250) = null,
	@cCUFE			varchar(4000) = null,
	@CUFE			varchar(250) = null
As
Begin
	Set NoCount On;

	-- Validamos si generamos el CUFE por demanda o masivo
	If (@NmroCnta is not null)
		Begin
		    -- Creamos temporal
			Create Table #tmpParametrosRecibidosCufe
			(
				NmroCnta    varchar(15),
				NumFac		varchar(30),
				FecFac		varchar(30),
				ValFac		varchar(30),
				CodImp1		varchar(10),
				ValImp1		varchar(30),
				CodImp2		varchar(10),
				ValImp2		varchar(30),
				CodImp3		varchar(10),
				ValImp3		varchar(30),
				ValImp		varchar(30),
				NitOFE		varchar(30),
				TipAdq		varchar(10),
				NumAdq		varchar(30),
				CITec		varchar(250),
			)

			create
			nonclustered
			index            IX_#tmpParametrosRecibidosCufe
			on                #tmpParametrosRecibidosCufe
                    (
                        NumFac
                    )

			-- Insertamos parámetros para el CUFE
			Insert #tmpParametrosRecibidosCufe
			(
				NumFac,							FecFac,						ValFac,
				CodImp1,						ValImp1,					CodImp2,
				ValImp2,						CodImp3,					ValImp3,
				ValImp,							NitOFE,						TipAdq,
				NumAdq,							CITec,						NmroCnta			
			)
			Values
			(
				@NumFac,						@FecFac,					@ValFac,
				@CodImp1,						@ValImp1,					@CodImp2,
				@ValImp2,						@CodImp3,					@ValImp3,
				@ValImp,						@NitOFE,					@TipAdq,
				@NumAdq,						@CITec,						@NmroCnta

			)
		End

	-- Creamos temporal de retorno del CUFE generado
	Create Table #tmpCUFE
	(
		NmroCnta        varchar(15),
		NumFac			varchar(30),
		cCUFE			varchar(4000),
		CUFE			varchar(250)
	)

	create
    nonclustered
    index            IX_#tmpCUFE
    on                #tmpCUFE
                    (
                        NumFac
                    )

	Insert #tmpCUFE
	(
			NumFac,
			NmroCnta	
	)
	Select
			NumFac,
			NmroCnta
	From #tmpParametrosRecibidosCufe


    -- Concatenamos campos para generar el CUFE
	Update		t
	Set			cCUFE = CONCAT(t1.NumFac,t1.FecFac,t1.ValFac,t1.CodImp1,t1.ValImp1,t1.CodImp2,t1.ValImp2,t1.CodImp3,t1.ValImp3,t1.ValImp,t1.NitOFE,t1.TipAdq,t1.NumAdq,t1.CITec)
	From		#tmpCUFE t
	Inner Join	#tmpParametrosRecibidosCufe t1
	On			t1.NumFac = t.NumFac


	-- Generarmos el CUFE
	Update		t
	Set			CUFE = sys.fn_varbintohexsubstring(0,HASHBYTES('SHA1', cCUFE),1,0)
	From		#tmpCUFE t
	
	Select 
			NmroCnta,
			NumFac,
			CUFE,
			cCUFE
	From	#tmpCUFE



End

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spFEGenerarCUFE] TO [Consultor Asesor Cartera]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spFEGenerarCUFE] TO [Consultor Administrativo Novedades]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spFEGenerarCUFE] TO [portal_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spFEGenerarCUFE] TO [qvision]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spFEGenerarCUFE] TO [quick_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spFEGenerarCUFE] TO [Administrador Cartera Pac]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spFEGenerarCUFE] TO [Auditoria Interna]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spFEGenerarCUFE] TO [Auxiliar Cartera Pac]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spFEGenerarCUFE] TO [Consultor Cartera Pac]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spFEGenerarCUFE] TO [Consultor Parametros Cartera Pac]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spFEGenerarCUFE] TO [Coordinador Cartera Pac]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spFEGenerarCUFE] TO [Coordinador Parametros Cartera Pac]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spFEGenerarCUFE] TO [Jefatura Cartera]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spFEGenerarCUFE] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spFEGenerarCUFE] TO [Consultor Administrador]
    AS [dbo];

