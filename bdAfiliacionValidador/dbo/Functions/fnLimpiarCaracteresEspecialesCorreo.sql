/*---------------------------------------------------------------------------------
* Metodo o PRG 		: fnLimpiarCaracteresEspecialesCorreo
* Desarrollado por		: <\A Francisco E Riaño L - Qvision S.A						A\>
* Descripcion			: <\D Esta función permite limpiar cadenas de tipo correo
							que contengan caracteres especiales ocultos				D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P 													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2019/07/26											FC\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  FM\>
*---------------------------------------------------------------------------------*/
CREATE  FUNCTION [dbo].[fnLimpiarCaracteresEspecialesCorreo] (@eml  udtEmail)  
RETURNS udtEmail
AS  
BEGIN 

Declare @cadena	  	udtEmail;

	set @cadena = replace(replace(replace(replace(replace(@eml,char(13),''),char(10),''),char(9),''),char(39),''),char(0),'')
	
	Return(ltrim(rtrim(@cadena)))
END


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnLimpiarCaracteresEspecialesCorreo] TO [Consultor Asesor Cartera]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnLimpiarCaracteresEspecialesCorreo] TO [Consultor Administrativo Novedades]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnLimpiarCaracteresEspecialesCorreo] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnLimpiarCaracteresEspecialesCorreo] TO [Consultor Administrador]
    AS [dbo];

