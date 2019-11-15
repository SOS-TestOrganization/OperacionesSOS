


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :  fnCalcularMaximoDetalleDocumento
* Desarrollado por		:  <\A    Ing. Maribel Valencia Herrera									A\>
* Descripcion			:  <\D  Calcular los Consecutivos de losDetalles de los Documentos Soporte de los  Beneficiarios x Contrato 	D\>
* Observaciones		  	:  <\O													O\>
* Parametros			:  <\P 	Tipo Contrato											P\>
				:  <\P 	Numero Contrato										P\>
** Fecha Creacion		:  <\FC  2003/05/15											FC\>
*  
*---------------------------------------------------------------------------------*/
CREATE function dbo.fnCalcularMaximoDetalleDocumento (@cnsctvo_cdgo_tpo_cntrto UdtConsecutivo ,  @nmro_cntrto udtNumeroFormulario )

Returns  udtConsecutivo   
As
  
Begin 

--> Obtener el Maximo Consecutivo de Detalles de Documentos Soporte x Beneficiario por Contrato y Tipo de Contrato
				
	Declare
	@lnResultado	UdtConsecutivo

	Select 	@lnResultado	=	Isnull(max(cnsctvo_dtlle_dcmnto_sprte_bnfcro) ,0)
	From	tbDetDocumentosSoportexBeneficiarioContrato d				
	Where	d.cnsctvo_cdgo_tpo_cntrto	=	@cnsctvo_cdgo_tpo_cntrto		
	And	d.nmro_cntrto			=	@nmro_cntrto 		
	
	Return @lnResultado + 1 			

End
















GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoDetalleDocumento] TO [AdminScripts_Cambios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoDetalleDocumento] TO [Auditor Central Notificaciones]
    AS [dbo];

