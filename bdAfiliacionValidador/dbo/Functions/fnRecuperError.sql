




/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :  fnRecuperaError
* Desarrollado por		 :  <\A    Ing. Mauricio Muñoz								A\>
* Descripcion			 :  <\D  Devuelve el mensaje de error dado el codigo	 				D\>
* Observaciones		              :  <\O											O\>
* Parametros			 :  <\P 	Codigo del error  								P\>
** Fecha Creacion		 :  <\FC  2003/09/26									FC\>
*  
*---------------------------------------------------------------------------------*/
CREATE function dbo.fnRecuperError (@nmro_errr int )
Returns  nvarchar(255)  
As
  
Begin 
	Declare
	@descripcion	nvarchar(255)
	Select 	 @descripcion	= description
	From   master.dbo.sysmessages 
	Where 	error   	= @nmro_errr
	
	If @descripcion is Null 
		Set @descripcion = 'No se encontro la definicion del error en sysmessages' 
	Return (@descripcion)
End



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnRecuperError] TO [AdminScripts_Cambios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnRecuperError] TO [Auditor Central Notificaciones]
    AS [dbo];

