


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :  fnCalcularTotalFormulariosxGuiaAfiliacion
* Desarrollado por		 :  <\A Ing. Jorge Ivan Rivera 								A\>
* Descripcion			 :  <\D Calcula el número total de formularios existentes por guía				D\>
* Observaciones		              :  <\O											O\>
* Parametros			 :  <\P Número de la guía a evaluar							P\>
* Fecha Creacion		 :  <\FC  2003/04/08									FC\>
*  
*---------------------------------------------------------------------------------*/
CREATE function dbo.fnCalcularTotalFormulariosxGuiaAfiliacion (@lnNumeroGuia UdtConsecutivo, @lnNumeroProceso udtConsecutivo)

Returns  udtConsecutivo 
As
  
Begin 
	Declare
	@TotalFormularios	UdtConsecutivo

	Set @TotalFormularios = 0
	
	Select	@TotalFormularios = Count(*)
	From	tbDetProcesos a, tbFormularios b
	Where	a.cnsctvo_prcso			=	@lnNumeroProceso
	And	a.cnsctvo_cdgo_tpo_frmlro	=	b.cnsctvo_cdgo_tpo_frmlro
	And	a.nmro_frmlro			=	b.nmro_frmlro
	And	b.nmro_ga			= 	@lnNumeroGuia

	Return(@TotalFormularios)
End








GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTotalFormulariosxGuiaAfiliacion] TO [AdminScripts_Cambios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTotalFormulariosxGuiaAfiliacion] TO [Auditor Central Notificaciones]
    AS [dbo];

