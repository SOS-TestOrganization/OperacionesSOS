


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :  fnCalcularMaximoDocumento
* Desarrollado por		:  <\A    Ing. Francisco J. Gonzalez R.								A\>
* Descripcion			:  <\D  Calcular los Consecutivos de los Documentos Soportes de los  Beneficiarios x Contrato 	D\>
* Observaciones		  	:  <\O												O\>
* Parametros			:  <\P 	Tipo Contrato										P\>
				:  <\P 	Numero Contrato									P\>
** Fecha Creacion		:  <\FC  2003/19/02										FC\>
*  
*---------------------------------------------------------------------------------*/
CREATE function dbo.fnCalcularMaximoDocumento (@cnsctvo_cdgo_tpo_cntrto UdtConsecutivo ,  @nmro_cntrto udtNumeroFormulario )

Returns  udtConsecutivo   
As
  
Begin 

--> Obtener el Maximo Consecutivo de Documentos x Beneficiario por Contrato y Tipo de Contrato					
	Declare
	@lnResultado	UdtConsecutivo

	Select 	@lnResultado	=	Isnull(max(cnsctvo_dcmnto) ,0)
	From	tbDocumentosSoportesxBeneficiariosContrato d				
	Where	d.cnsctvo_cdgo_tpo_cntrto	=	@cnsctvo_cdgo_tpo_cntrto		
	And	d.nmro_cntrto			=	@nmro_cntrto 		
	
	Return @lnResultado + 1 			

End















GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoDocumento] TO [AdminScripts_Cambios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoDocumento] TO [Auditor Central Notificaciones]
    AS [dbo];

