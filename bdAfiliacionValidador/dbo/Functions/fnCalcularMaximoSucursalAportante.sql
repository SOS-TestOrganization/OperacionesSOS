


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :  fnCalcularMaximoSucursalAportante
* Desarrollado por		 :  <\A Ing. Jorge Ivan Rivera 								A\>
* Descripcion			 :  <\D Devuelve el máximo consecutivo de la tabla tbSucursalesAportante para un Nui y 	D\>
*				 :  <\D Clase de aportante definidos		 					D\>
* Observaciones		              :  <\O											O\>
* Parametros			 :  <\P Número Único de Identificación del empleador					P\>
*				 :  <\P Consecutivo de la clase de aportante						P\>
** Fecha Creacion		 :  <\FC  2003/04/14									FC\>
*  
*---------------------------------------------------------------------------------*/
CREATE function dbo.fnCalcularMaximoSucursalAportante (@lnNui UdtConsecutivo ,  @lnClaseAportante UdtConsecutivo)

Returns  udtConsecutivo 
As
  
Begin 
	Declare
	@lnSucursal	UdtConsecutivo

	Select	@lnSucursal	=	Isnull(Max(cnsctvo_scrsl),0)
	From	tbSucursalesAportante
	Where	nmro_unco_idntfccn_empldr	= @lnNui
	And	cnsctvo_cdgo_clse_aprtnte	= @lnClaseAportante
	
	Set	@lnSucursal =	@lnSucursal + 1

	Return ( @lnSucursal)
End



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoSucursalAportante] TO [AdminScripts_Cambios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoSucursalAportante] TO [Auditor Central Notificaciones]
    AS [dbo];

