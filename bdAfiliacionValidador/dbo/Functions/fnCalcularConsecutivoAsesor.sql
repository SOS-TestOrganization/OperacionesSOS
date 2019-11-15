


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              	:  fnCalcularConsecutivoAsesor
* Desarrollado por		:  <\A    Ing. Adriana Cifuentes Lozano						A\>
* Descripcion			:  <\D  Calcula el maximo consecutivo de la tabla tbAsesoresComerciales	D\>
* Observaciones		:  <\O									O\>
* Parametros			:  <\P 								P\>
* Fecha Creacion		:  <\FC  2003/05/29								FC\>
*  
*----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
CREATE function dbo.fnCalcularConsecutivoAsesor ( )

Returns  udtConsecutivo   
As
  
Begin 

--> Obtener el Maximo Consecutivo del Asesor
	Declare
	@lnResultado	UdtConsecutivo

	Select 	@lnResultado	=	Isnull(max(cnsctvo_assr) ,0)
	From	bdAfiliacion..tbAsesoresComerciales		
	Where	cnsctvo_assr	<> 99999
	And	vsble_usro	= 'S'			
						
						
	Return @lnResultado + 1

End



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularConsecutivoAsesor] TO [AdminScripts_Cambios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularConsecutivoAsesor] TO [Auditor Central Notificaciones]
    AS [dbo];

