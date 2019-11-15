


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              	:  fnCalcularCodigoAsesor
* Desarrollado por		:  <\A    Ing. Adriana Cifuentes Lozano						A\>
* Descripcion			:  <\D  Calcula el maximo consecutivo de la tabla tbCodigosAsesor	D\>
* Observaciones		:  <\O									O\>
* Parametros			:  <\P 								P\>
* Fecha Creacion		:  <\FC  2003/05/29								FC\>
*  
*----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
CREATE function dbo.fnCalcularCodigoAsesor ( )

Returns  udtConsecutivo   
As
  
Begin 

--> Obtener el Maximo codigo del Asesor
	Declare
	@lnResultado	UdtConsecutivo

	Select 	@lnResultado	=	Isnull(max(cnsctvo_cdgo_assr) ,0)
	From	bdAfiliacion..tbCodigosAsesor_Vigencias
	Where	cnsctvo_cdgo_assr	<> 99999			
						
						
	Return @lnResultado + 1

End















GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularCodigoAsesor] TO [AdminScripts_Cambios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularCodigoAsesor] TO [Auditor Central Notificaciones]
    AS [dbo];

