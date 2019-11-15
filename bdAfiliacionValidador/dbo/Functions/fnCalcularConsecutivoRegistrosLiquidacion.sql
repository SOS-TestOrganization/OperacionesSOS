


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              	:  fnCalcularConsecutivoRegistrosLiquidacion
* Desarrollado por		:  <\A    Ing. Adriana Cifuentes Lozano						A\>
* Descripcion			:  <\D  Calcula el maximo consecutivo de la tabla tbRegistrosLiquidacion	D\>
* Observaciones		:  <\O									O\>
* Parametros			:  <\P 								P\>
* Fecha Creacion		:  <\FC  2003/07/02								FC\>
*  
*----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
CREATE function dbo.fnCalcularConsecutivoRegistrosLiquidacion ( )

Returns  udtConsecutivo   
As
  
Begin 

--> Obtener el Maximo Consecutivo de la tabla tbRegistrosLiquidacion
	Declare
	@lnResultado	UdtConsecutivo

	Select 	@lnResultado	=	Isnull(max(cnsctvo_rgstro) ,0)
	From	bdAfiliacion..tbRegistrosLiquidacion
						
						
	Return @lnResultado + 1

End



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularConsecutivoRegistrosLiquidacion] TO [AdminScripts_Cambios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularConsecutivoRegistrosLiquidacion] TO [Auditor Central Notificaciones]
    AS [dbo];

