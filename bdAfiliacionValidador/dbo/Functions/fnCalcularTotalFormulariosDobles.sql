


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :  fnCalcularTotalFormulariosDobles
* Desarrollado por		 :  <\A Ing. Jorge Ivan Rivera 								A\>
* Descripcion			 :  <\D Calcula el número total de formularios dobles por guía				D\>
* Observaciones		              :  <\O											O\>
* Parametros			 :  <\P Número de la guía a evaluar							P\>
*				 :  <\P Número del proceso a consultar							P\>
* Fecha Creacion		 :  <\FC  2003/04/08									FC\>
*  
*---------------------------------------------------------------------------------*/
CREATE function dbo.fnCalcularTotalFormulariosDobles (@lnNumeroGuia UdtConsecutivo, @lnNumeroProceso udtConsecutivo)

Returns  udtConsecutivo 
As
  
Begin 
	Declare
	@TotalFormulariosDobles	UdtConsecutivo

	Set @TotalFormulariosDobles = 0
	
	Select	@TotalFormulariosDobles = Count(*)
	From	tbDetProcesos a, tbFormulariosEmpleadores b, tbDetProcesoxFormulario c
	Where	a.cnsctvo_prcso				=	@lnNumeroProceso
	And	a.cnsctvo_cdgo_tpo_frmlro		=	b.cnsctvo_cdgo_tpo_frmlro
	And	a.nmro_frmlro				=	b.nmro_frmlro
	And	b.nmro_ga				= 	@lnNumeroGuia
	And	a.cnsctvo_dtlle_prcso			=	c.cnsctvo_dtlle_prcso
	And	c.cnsctvo_cdgo_mtvo_dvlcn		=	195 --EL FORMULARIO SE ENCUENTRA DOBLE

	Return(@TotalFormulariosDobles)
End





GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTotalFormulariosDobles] TO [AdminScripts_Cambios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTotalFormulariosDobles] TO [Auditor Central Notificaciones]
    AS [dbo];

