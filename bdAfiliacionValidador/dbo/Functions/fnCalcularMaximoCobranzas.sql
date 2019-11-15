


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              	:  fnCalcularMaximoCobranzas
* Desarrollado por		:  <\A    Ing. Francisco J. Gonzalez R.						A\>
* Descripcion			:  <\D  Calcular los Consecutivos de las Cobranzas por Afiliado 			D\>
* Observaciones		       	:  <\O										O\>
* Parametros			:  <\P 	Tipo Contrato								P\>
				:  <\P 	Numero Contrato							P\>
** Fecha Creacion		:  <\FC  2003/19/02								FC\>
*  
*---------------------------------------------------------------------------------*/
CREATE function dbo.fnCalcularMaximoCobranzas (@cnsctvo_cdgo_tpo_cntrto UdtConsecutivo ,  @nmro_cntrto udtNumeroFormulario )

Returns  udtConsecutivo   
As
  
Begin 

--> Obtener el Maximo Consecutivo de la Cobranza por Contrato y Tipo de Contrato						
	Declare
	@lnResultado	UdtConsecutivo

	Select 	@lnResultado	=	Isnull(max(cnsctvo_cbrnza) ,0)
	From	tbCobranzas c					
	Where	c.cnsctvo_cdgo_tpo_cntrto	=	@cnsctvo_cdgo_tpo_cntrto 			
	And	c.nmro_cntrto			=	@nmro_cntrto 			
						
						
	Return @lnResultado + 1

End











GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [AdminScripts_Cambios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Inteligencia]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoCobranzas] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];

