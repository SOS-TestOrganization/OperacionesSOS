


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 		:  fnCalcularMaximoVigenciasCobranzas
* Desarrollado por		:  <\A    Ing. Francisco J. Gonzalez R.							A\>
* Descripcion			:  <\D  Calcular los Consecutivos de las Vigencias de las Cobranzas por Afiliado 		D\>
* Observaciones			:  <\O											O\>
* Parametros			:  <\P 	Tipo Contrato									P\>
*				:  <\P 	Numero Contrato								P\>
*				:  <\P 	Numero Cobranza								P\>
* Fecha Creacion		:  <\FC  2003/19/02									FC\>
*  
*---------------------------------------------------------------------------------*/
CREATE function dbo.fnCalcularMaximoVigenciasCobranzas(@cnsctvo_cdgo_tpo_cntrto UdtConsecutivo ,  @nmro_cntrto udtNumeroFormulario, 
		@cnsctvo_cbrnza udtConsecutivo )

Returns  udtConsecutivo   
As
  
Begin 

--> Obtener el Maximo Consecutivo de Vigencias por Contrato y Tipo de Contrato						
	Declare
	@lnResultado	UdtConsecutivo

	Select 	@lnResultado	=	Isnull(max(cnsctvo_vgnca_cbrnza) ,0)
	From tbVigenciasCobranzas v					
	Where	v.cnsctvo_cdgo_tpo_cntrto	=	@cnsctvo_cdgo_tpo_cntrto 			
	And	v.nmro_cntrto			=	@nmro_cntrto			
	And	v.cnsctvo_cbrnza		=	@cnsctvo_cbrnza		
						
	Return @lnResultado + 1

End













GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoVigenciasCobranzas] TO [AdminScripts_Cambios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoVigenciasCobranzas] TO [Auditor Central Notificaciones]
    AS [dbo];

