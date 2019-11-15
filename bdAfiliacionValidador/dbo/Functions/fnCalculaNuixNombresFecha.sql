



/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	         :  fnCalculaNuixNombresFecha
* Desarrollado por		 :  <\A    Ing. Jorge Andres Garcia Erazo - Geniar S.A.S A\>
* Descripcion			 :  <\D  Devuelve el NUI para los nombres, apellidos y fecha nacimiento de un afiliado D\>
* Observaciones		     :  <\O											O\>
* Parametros			 :  <\P @primerNomnbre UdtNombre,  
								@segundoNomnbre UdtNombre,
								@primerApellido UdtApellido,
								@segundoApellido UdtApellido,
								@fechaNacimiento datetime 
							P\>
** Fecha Creacion		 :  <\FC 2013/04/27 FC\>
*  
*---------------------------------------------------------------------------------*/
create function [dbo].[fnCalculaNuixNombresFecha] (
	@primerNombre UdtNombre,  
	@segundoNombre UdtNombre,
	@primerApellido UdtApellido,
	@segundoApellido UdtApellido,
	@fechaNacimiento datetime,
	@fechaVigencia datetime
 )

RETURNS  udtConsecutivo   
As
  
BEGIN 
	DECLARE @temp table(
		nui UdtConsecutivo,
		fecha_ncmto datetime
	)

	DECLARE
	@Nui	UdtConsecutivo

	insert into @temp
	Select nmro_unco_idntfccn_afldo, fcha_ncmnto
	From   [tbBeneficiariosValidador] 
	Where  prmr_aplldo = COALESCE(ltrim(rtrim(@primerApellido)),prmr_aplldo) 
	AND sgndo_aplldo = COALESCE(ltrim(rtrim(@segundoApellido)),sgndo_aplldo)
	AND prmr_nmbre =  COALESCE(ltrim(rtrim(@primerNombre)),prmr_nmbre)
	AND sgndo_nmbre = COALESCE(ltrim(rtrim(@segundoNombre)),sgndo_nmbre)

	select @Nui = nui
	from @temp
	where CONVERT(CHAR(8),fecha_ncmto, 112)=CONVERT(CHAR(8),@fechaNacimiento, 112)

	If @Nui is Null 
		Set @Nui = null 

	Return (@Nui)
END




GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaNuixNombresFecha] TO [Analistas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaNuixNombresFecha] TO [cna_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaNuixNombresFecha] TO [AdminScripts_Cambios]
    AS [dbo];

