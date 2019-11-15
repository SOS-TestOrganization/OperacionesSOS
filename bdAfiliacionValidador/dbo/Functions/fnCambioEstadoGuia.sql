


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :  fnCambioEstadoGuia
* Desarrollado por		 :  <\A Ing. Jorge Ivan Rivera 								A\>
* Descripcion			 :  <\D Devuelve el  consecutivo del estado con el cual debería quedar una guía después 	D\>
*				 :  <\D de realizado un proceso sobre ella 							D\>
* Observaciones		              :  <\O											O\>
* Parametros			 :  <\P Número de la guía a evaluar							P\>
** Fecha Creacion		 :  <\FC  2003/04/06									FC\>
*  
*---------------------------------------------------------------------------------*/
CREATE function dbo.fnCambioEstadoGuia (@lnNumeroGuia UdtConsecutivo)

Returns  udtConsecutivo 
As
  
Begin 
	Declare
	@EstadoGuia	UdtConsecutivo

	If Exists	(Select	1
		 From	tbFormulariosEmpleadores
		 Where	@lnNumeroGuia				=	nmro_ga
		 And	cnsctvo_cdgo_estdo_frmlro_empldr	!=	6
		 And	cnsctvo_cdgo_estdo_frmlro_empldr	!=	7)
	Begin
		Set @EstadoGuia = 3 --TRASPASADA PARCIAL
	End
	Else
	Begin
		Set @EstadoGuia = 4 --TRASPASADA TOTAL
	End

	Return (@EstadoGuia)
End




GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCambioEstadoGuia] TO [AdminScripts_Cambios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCambioEstadoGuia] TO [Auditor Central Notificaciones]
    AS [dbo];

