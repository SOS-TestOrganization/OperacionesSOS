


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :  fnCalculaNui
* Desarrollado por		 :  <\A    Ing. Alexander Yela Reyes							A\>
* Descripcion			 :  <\D  Devuelve el NUI	para un Tipo y Número de Identificación 				D\>
* Observaciones		              :  <\O											O\>
* Parametros			 :  <\P 	Nombre de la Tabla  								P\>
** Fecha Creacion		 :  <\FC  2003/19/02									FC\>
*  
*---------------------------------------------------------------------------------*/
CREATE function dbo.fnCalculaNui (@cnsctvo_cdgo_tpo_idntfccn UdtConsecutivo ,  @nmro_idntfccn udtNumeroIdentificacionLargo )

Returns  udtConsecutivo   
As
  
Begin 
	Declare
	@Nui	UdtConsecutivo

	Select 	 @Nui	= nmro_unco_idntfccn
	From   tbVinculados 
	Where 	Cnsctvo_cdgo_tpo_idntfccn 	= @cnsctvo_cdgo_tpo_idntfccn
	And	nmro_idntfccn			= ltrim(rtrim(@nmro_idntfccn))
	And	vldo				= 'S'

	If @Nui is Null 
		Set @Nui = 0 

	Return (@Nui)
End










GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaNui] TO [AdminScripts_Cambios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaNui] TO [Auditor Central Notificaciones]
    AS [dbo];

