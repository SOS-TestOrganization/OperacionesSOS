


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              	:  fnCalcularMaximoConsecutivoValorDetalle
* Desarrollado por		:  <\A    Ing. Francisco J. Gonzalez R.						A\>
* Descripcion			:  <\D  Calcular el Maximo valor detalle para el Consecutivo Novedad, detalle novedad y concepto afectado 			D\>
* Descripcion			:  <\D  en la tabla de TBVALORESCONCEPTOSAFECTADOS 			D\>
* Observaciones		       	:  <\O										O\>
* Parametros			:  <\P 	Tipo Contrato								P\>
				:  <\P 	Numero Contrato							P\>
** Fecha Creacion		:  <\FC  2003/19/02								FC\>
*  
*---------------------------------------------------------------------------------*/
CREATE function dbo.fnCalcularMaximoConsecutivoValorDetalle (@cConsecutivoNovedad udtNumeroFormulario,  @nConsecutivoDetalleNovedad udtConsecutivo, @nConsecutivoConceptoAfecatodo udtConsecutivo)

Returns  udtConsecutivo   
As
  
Begin 

--> Obtener el Maximo Consecutivo de la Cobranza por Contrato y Tipo de Contrato						
	Declare
	@lnResultado	UdtConsecutivo
	
	Select 	@lnResultado = Isnull(Max(cnsctvo_vlr_dtlle),0) 
	From	tbValoresConceptosAfectados 
	Where 	cnsctvo_nvdd		=	@cConsecutivoNovedad
	And	cnsctvo_dtlle_nvdd	=	@nConsecutivoDetalleNovedad
	And	cnsctvo_cncpto_afctdo	= 	@nConsecutivoConceptoAfecatodo

	Return @lnResultado + 1

End














GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConsecutivoValorDetalle] TO [AdminScripts_Cambios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConsecutivoValorDetalle] TO [Auditor Central Notificaciones]
    AS [dbo];

