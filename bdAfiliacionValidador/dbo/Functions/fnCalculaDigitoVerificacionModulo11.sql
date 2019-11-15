
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :  fnCalculaDigitoVerificacionModulo11 
* Desarrollado por		 :  <\A    Ing. Samuel Muñoz										A\>
* Descripcion			 :  <\D  Devuelve el Digito de Verficiacion, según metodo del modulo 11					D\>
* Observaciones		              :  <\O													O\>
* Parametros			 :  <\P 	Numero a Calcular el Digito									P\>
*				    <\P													P\>
* Fecha Creacion		 :  <\FC  2004/09/11											FC\>
*  
*---------------------------------------------------------------------------------*/
Create  Function dbo.fnCalculaDigitoVerificacionModulo11 (@Numero int )
Returns Int

As  
Begin
	Declare 	

	@lnSuma		Int,
	@lcNumeroCompleto	Char(15),
	@lcNumero		Char(10),
	@lnResto		Int,
	@lnDigito		Int
		

	Set @lnSuma 		= 0
	Set @lcNumero 		= Rtrim(Ltrim(Cast(@Numero as Char(10))))
	Set @lcNumeroCompleto	= Rtrim(Ltrim(Replicate('0',15-Len(@lcNumero)) +  Cast(@lcNumero as Char)))
	Set @lnSuma 		= @lnSuma 
				+ Cast(Substring(@lcNumeroCompleto,1,1) as Int) * 71
				+ Cast(Substring(@lcNumeroCompleto,2,1) as Int) * 67
				+ Cast(Substring(@lcNumeroCompleto,3,1) as Int) * 59
				+ Cast(Substring(@lcNumeroCompleto,4,1) as Int) * 53
				+ Cast(Substring(@lcNumeroCompleto,5,1) as Int) * 47
				+ Cast(Substring(@lcNumeroCompleto,6,1) as Int) * 43
				+ Cast(Substring(@lcNumeroCompleto,7,1) as Int) * 41
				+ Cast(Substring(@lcNumeroCompleto,8,1) as Int) * 37
				+ Cast(Substring(@lcNumeroCompleto,9,1) as Int) * 29
				+ Cast(Substring(@lcNumeroCompleto,10,1) as Int) * 23
				+ Cast(Substring(@lcNumeroCompleto,11,1) as Int) * 19
				+ Cast(Substring(@lcNumeroCompleto,12,1) as Int) * 17
				+ Cast(Substring(@lcNumeroCompleto,13,1) as Int) * 13
				+ Cast(Substring(@lcNumeroCompleto,14,1) as Int) *   7 
				+ Cast(Substring(@lcNumeroCompleto,15,1) as Int) *   3
		
		Set @lnResto = (@lnSuma%11)
	
		If @lnResto = 0
			Set @lnDigito =  0
		Else
			If @lnResto = 1
				Set @lnDigito = 1
			Else
				Set @lnDigito = @lnResto - 11

	Return(Abs(@lnDigito))
End


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaDigitoVerificacionModulo11] TO [Audio]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaDigitoVerificacionModulo11] TO [310014 Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT REFERENCES
    ON OBJECT::[dbo].[fnCalculaDigitoVerificacionModulo11] TO [310014 Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaDigitoVerificacionModulo11] TO [310002 Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaDigitoVerificacionModulo11] TO [cna_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaDigitoVerificacionModulo11] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaDigitoVerificacionModulo11] TO [proceso3047_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaDigitoVerificacionModulo11] TO [AdminScripts_Cambios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaDigitoVerificacionModulo11] TO [autsalud_rol]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaDigitoVerificacionModulo11] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaDigitoVerificacionModulo11] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaDigitoVerificacionModulo11] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaDigitoVerificacionModulo11] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaDigitoVerificacionModulo11] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaDigitoVerificacionModulo11] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaDigitoVerificacionModulo11] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaDigitoVerificacionModulo11] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT REFERENCES
    ON OBJECT::[dbo].[fnCalculaDigitoVerificacionModulo11] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaDigitoVerificacionModulo11] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT REFERENCES
    ON OBJECT::[dbo].[fnCalculaDigitoVerificacionModulo11] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

