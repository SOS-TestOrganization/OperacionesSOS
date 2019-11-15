


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	         :  fnCalculaNuixTipoNumeroID
* Desarrollado por		 :  <\A    Ing. Jorge Andres Garcia Erazo - Geniar S.A.S A\>
* Descripcion			 :  <\D  Devuelve el NUI para el tipo y numero de identificacion D\>
* Observaciones		     :  <\O											O\>
* Parametros			 :  <\P 
								@cnsctvo_cdgo_tpo_idntfccn UdtConsecutivo,  
								@nmro_idntfccn udtNumeroIdentificacionLargo
							P\>
** Fecha Creacion		 :  <\FC 2013/04/27 FC\>
*  
*---------------------------------------------------------------------------------*/
CREATE function [dbo].[fnCalculaNuixTipoNumeroID] (
	@cnsctvo_cdgo_tpo_idntfccn UdtConsecutivo,  
	@nmro_idntfccn udtNumeroIdentificacionLargo
 )

RETURNS  udtConsecutivo   
As
  
BEGIN 
	DECLARE
	@Nui	UdtConsecutivo,
	@nmro_idntfccn_tmp udtNumeroIdentificacionLargo

	SET @nmro_idntfccn_tmp = rtrim(ltrim(@nmro_idntfccn))

	Select @Nui = nmro_unco_idntfccn_afldo
	From   tbbeneficiariosvalidador 
	Where  nmro_idntfccn = @nmro_idntfccn_tmp
	AND cnsctvo_cdgo_tpo_idntfccn = @cnsctvo_cdgo_tpo_idntfccn

--	If @Nui is Null 
--		Set @Nui = null 

	Return (@Nui)
END


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaNuixTipoNumeroID] TO [Analistas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaNuixTipoNumeroID] TO [cna_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaNuixTipoNumeroID] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaNuixTipoNumeroID] TO [ctc_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaNuixTipoNumeroID] TO [proceso3047_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaNuixTipoNumeroID] TO [AdminScripts_Cambios]
    AS [dbo];

