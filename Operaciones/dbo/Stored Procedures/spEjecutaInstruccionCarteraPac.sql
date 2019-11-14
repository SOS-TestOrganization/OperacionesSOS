/*---------------------------------------------------------------------------------
* Nombre			: spEjecutaInstruccionCarteraPac 
* Desarrollado por	 	: <\A Ing. Rolando Simbaqueva  A\>
* Descripcion			: <\D Se encarga de ejecutar una instruccion SQL  D\>
* Observaciones			: <\O   O\>
* Parametros			: <\P Instruccion a ejecutar  P\>
* Variables			: <\V   V\>
* Fecha Creacion		: <\FC 2002/06/20 FC\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION cdgo
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  FM\>
-----------------------------------------------------------------------------------*/

CREATE  PROCEDURE spEjecutaInstruccionCarteraPac 
       
        @instruccion   NVARCHAR(3000)  -- EJECUTA INSTRUCCION

 AS

SET NOCOUNT ON

EXEC sp_executesql @instruccion