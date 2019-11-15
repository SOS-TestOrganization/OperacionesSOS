


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :  fnCalcularMaximoPosC
* Desarrollado por		:  <\A    Ing. Francisco J. Gonzalez R.						A\>
* Descripcion			:  <\D Calcular el Consecutivo de los PosC por Afiliado		 		D\>
* Observaciones		       	 :  <\O										O\>
* Parametros			:  <\P 	Tipo Contrato								P\>
				:  <\P 	Numero Contrato							P\>
** Fecha Creacion		:  <\FC  2003/19/02								FC\>
*  
*---------------------------------------------------------------------------------*/
CREATE function dbo.fnCalcularMaximoPosC (@cnsctvo_cdgo_tpo_cntrto UdtConsecutivo ,  @nmro_cntrto udtNumeroFormulario )

Returns  udtConsecutivo   
As
  
Begin 

--> Obtener el Maximo Consecutivo de la Relacion PosC  por Contrato y Tipo de Contrato						
	Declare
	@lnResultado	UdtConsecutivo

	Select 	@lnResultado	=	Isnull(max(cnsctvo_cntrto_psc) ,0)
	From	tbRelacionPosC					
	Where	cnsctvo_cdgo_tpo_cntrto	=	@cnsctvo_cdgo_tpo_cntrto 			
	And	nmro_cntrto			=	@nmro_cntrto 			
						
	Return @lnResultado + 1
End












GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoPosC] TO [AdminScripts_Cambios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoPosC] TO [Auditor Central Notificaciones]
    AS [dbo];

