


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :  fnCalcularMaximoRolFormularioEmpleador
* Desarrollado por		 :  <\A Ing. Jorge Ivan Rivera 								A\>
* Descripcion			 :  <\D Devuelve el máximo consecutivo de la tabla tbRolesxFormularioEmpleador		D\>
*				 :  <\D para un tipo y número de formulario del empleador 					D\>
* Observaciones		              :  <\O											O\>
* Parametros			 :  <\P Consecutivo del tipo de formulario del empleador					P\>
*				 :  <\P Numero del formulario del empleador						P\>
** Fecha Creacion		 :  <\FC  2003/19/02									FC\>
*  
*---------------------------------------------------------------------------------*/
CREATE function dbo.fnCalcularMaximoRolFormularioEmpleador (@lnTipoFormulario UdtConsecutivo ,  @lcNumeroFormulario udtNumeroFormulario )

Returns  udtConsecutivo 
As
  
Begin 
	Declare
	@MaximoRol	UdtConsecutivo

	Select	@MaximoRol	=   Isnull(max(cnsctvo_rl_frmlro) ,0) 
	From   	tbRolesxFormularioEmpleador
	Where 	cnsctvo_cdgo_tpo_frmlro 	= @lnTipoFormulario
	And	nmro_frmlro			=  @lcNumeroFormulario
	
	Set  @MaximoRol =   @MaximoRol + 1 

	Return ( @MaximoRol)

END



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoRolFormularioEmpleador] TO [AdminScripts_Cambios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoRolFormularioEmpleador] TO [Auditor Central Notificaciones]
    AS [dbo];

