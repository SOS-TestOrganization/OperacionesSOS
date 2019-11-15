


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :  fnCalcularMaximoEstadoFormularioEmpleador
* Desarrollado por		 :  <\A Ing. Jorge Ivan Rivera 								A\>
* Descripcion			 :  <\D Devuelve el máximo consecutivo de la tabla tbEstadosxFormulariosEmpleadores	D\>
*				 :  <\D para un tipo y número de formulario del empleador 					D\>
* Observaciones		              :  <\O											O\>
* Parametros			 :  <\P Consecutivo del tipo de formulario del empleador					P\>
*				 :  <\P Numero del formulario del empleador						P\>
** Fecha Creacion		 :  <\FC  2003/19/02									FC\>
*  
*---------------------------------------------------------------------------------*/
CREATE function dbo.fnCalcularMaximoEstadoFormularioEmpleador (@lnTipoFormulario UdtConsecutivo ,  @lcNumeroFormulario udtNumeroFormulario )

Returns  udtConsecutivo 
As
  
Begin 
	Declare
	@MaximoEstado	UdtConsecutivo

	Select	@MaximoEstado	=   Isnull(max(cnsctvo_estdo_frmlro) ,0) 
	From   	tbEstadosxFormulariosEmpleadores
	Where 	cnsctvo_cdgo_tpo_frmlro 	= @lnTipoFormulario
	And	nmro_frmlro			=  @lcNumeroFormulario
	
	Set  @MaximoEstado =   @MaximoEstado + 1 

	Return ( @MaximoEstado)
End



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoEstadoFormularioEmpleador] TO [AdminScripts_Cambios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoEstadoFormularioEmpleador] TO [Auditor Central Notificaciones]
    AS [dbo];

