


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :  fnCalcularTotalFormulariosNoTraspasados
* Desarrollado por		 :  <\A Ing. Jorge Ivan Rivera 								A\>
* Descripcion			 :  <\D Calcula el número total de formularios no traspasados por guía			D\>
* Observaciones		              :  <\O											O\>
* Parametros			 :  <\P Número de la guía a evaluar							P\>
*				 :  <\P Número del proceso a consultar							P\>
* Fecha Creacion		 :  <\FC  2003/04/08									FC\>
*  
*---------------------------------------------------------------------------------*/
CREATE function dbo.fnCalcularTotalFormulariosNoTraspasados (@lnNumeroGuia UdtConsecutivo, @lnNumeroProceso udtConsecutivo)

Returns  udtConsecutivo 
As
  
Begin 
	Declare
	@TotalFormulariosNoTraspasados	UdtConsecutivo

	Set @TotalFormulariosNoTraspasados = 0
	
	Select	@TotalFormulariosNoTraspasados = Count(*)
	From	tbDetProcesos a, tbFormulariosEmpleadores b
	Where	a.cnsctvo_prcso				=	@lnNumeroProceso
	And	a.cnsctvo_cdgo_tpo_frmlro		=	b.cnsctvo_cdgo_tpo_frmlro
	And	a.nmro_frmlro				=	b.nmro_frmlro
	And	b.nmro_ga				= 	@lnNumeroGuia
	And	b.cnsctvo_cdgo_estdo_frmlro_empldr	=	5 --DEVUELTO

	Return(@TotalFormulariosNoTraspasados)
End




GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTotalFormulariosNoTraspasados] TO [AdminScripts_Cambios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTotalFormulariosNoTraspasados] TO [Auditor Central Notificaciones]
    AS [dbo];

