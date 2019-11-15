


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	             	:  fnCalcularMaximoConceptosPendientes
* Desarrollado por		:  <\A    Ing. Francisco J. Gonzalez R.						A\>
* Descripcion			:  <\D  Calcular los Consecutivos de los Conceptos Pendientes 		 	D\>
* Observaciones			:  <\O										O\>
* Parametros			:  <\P 	Tipo Contrato								P\>
				:  <\P 	Numero Contrato							P\>
** Fecha Creacion		:  <\FC  2003/19/02								FC\>
*  
*---------------------------------------------------------------------------------*/
CREATE function dbo.fnCalcularMaximoConceptosPendientes(@cnsctvo_cdgo_tpo_cntrto UdtConsecutivo ,  @nmro_cntrto udtNumeroFormulario  )

Returns  udtConsecutivo   
As
  
Begin 

--> Obtener el Maximo Consecutivo de los conceptos pendientes  por Contrato y Tipo de Contrato						
	Declare
	@lnResultado	UdtConsecutivo

	Select 	@lnResultado	=	Isnull(max(cnsctvo_cncpto_pndnte) ,0)
	From	tbConceptosPendientesxBeneficiario  c					
	Where	c.cnsctvo_cdgo_tpo_cntrto	=	@cnsctvo_cdgo_tpo_cntrto			
	And	c.nmro_cntrto			=	@nmro_cntrto 			
						
	Return @lnResultado + 1

End











GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [AdminScripts_Cambios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Inteligencia]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularMaximoConceptosPendientes] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];

