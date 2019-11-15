


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              	:  fnCalcularConsecutivoAsignacionAsesor
* Desarrollado por		:  <\A    Ing. Adriana Cifuentes Lozano						A\>
* Descripcion			:  <\D  Calcula el maximo consecutivo de la tabla tbAsesoresComerciales	D\>
* Observaciones		:  <\O									O\>
* Parametros			:  <\P 								P\>
* Fecha Creacion		:  <\FC  2003/05/29								FC\>
*  
*----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
CREATE function dbo.fnCalcularConsecutivoAsignacionAsesor ( )

Returns  udtConsecutivo   
As
  
Begin 

--> Obtener el Maximo Consecutivo del Asesor
	Declare
	@lnResultado	UdtConsecutivo

	Select 	@lnResultado	=	Isnull(max(cnsctvo_asgncn) ,0)
	From	bdAfiliacion..tbAsesoresAsignados
						
						
	Return @lnResultado + 1

End



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularConsecutivoAsignacionAsesor] TO [AdminScripts_Cambios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularConsecutivoAsignacionAsesor] TO [Auditor Central Notificaciones]
    AS [dbo];

