
/*---------------------------------------------------------------------------------------------------------------------------------------
* Procedimiento			: spTraerOficinasSedes
* Desarrollado por		: <\A Ing. Adriana Cifuentes   							A\>
* Descripción			: <\D Trae todos las oficnas de acuerdo a la sede enviada como parametro	D\>
* Observaciones		: <\O 										O\>
* Parámetros			: <\P @lcCodigoOficina: Código de la oficina                             			P\>
* 				: <\P @ldFechaReferencia: Fecha para recuperar un tipo determinado		P\>
* 				: <\P  			    de origen contenido en un rango de vigencia		P\>
* 				: <\P @lcCadenaSeleccion: Cadena que permite filtrar los registros de  		P\>
* 				: <\P  			    salida de acuerdo a la descripción			P\>
*				: <\P @lcConsecutivoSede:  consecutivo de la ses				P\>
* 				: <\P @lcTraerTodosVisibleUsuario: Permite filtrar los registros de salida	P\>
* 				: <\P  				    de acuerdo a los administrados por		P\>
* 				: <\P  				    el usuario					P\>
* Variables			: <\V										V\>
* Fecha Creación		: <\FC 2003/04/25  								FC\>
*
*---------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------------------------------------------------------------
* Modificado Por		 : <\AM  			AM\>
* Descripcion			 : <\DM 	 		DM\>
*				 : <\DM  			DM\>
* Nuevos Parametros	 	 : <\PM  			PM\>
* Nuevas Variables		 : <\VM  			VM\>
* Fecha Modificacion		 : <\FM			FM\>
*-------------------------------------------------------------------------------------------------------------------------------------*/
create procedure spPMTraerOficinasSedes
@lcCodigoOficina		Char(5)			= 	NULL,
@ldFechaReferencia		DATETIME		= 	NULL,
@lcCadenaSeleccion		UdtDescripcion		= 	NULL,
@lnConsecutivoSede		UdtConsecutivo		=	NULL,
@lnLlamado			udtLogico		=	'N'
AS
SET Nocount ON
IF @ldFechaReferencia Is Null
	Set @ldFechaReferencia = GetDate()
If @lcCodigoOficina Is Null
Begin
	If @lcCadenaSeleccion = '+' Or @lcCadenaSeleccion Is Null
	Begin
		-- Si codigo de la oficina es nulo y cadena de seleccion es nula
		-- Se seleccionan todos las oficinas que no hayan sido borrados y cumplan la vigencia 
		Select	a.cdgo_ofcna, a.dscrpcn_ofcna,	a.cnsctvo_cdgo_ofcna,	
		       	a.cnsctvo_cdgo_sde,	b.cdgo_sde
		From tbOficinas_Vigencias a, tbSedes_Vigencias b
		Where	(@ldFechaReferencia Between a.inco_vgnca And a.fn_vgnca)
		And	((a.cnsctvo_cdgo_sde	= @lnConsecutivoSede) Or @lnConsecutivoSede Is Null)
		And       (a.vsble_usro 			= 'S' Or @lnLlamado = 'S')
		And       a.cnsctvo_cdgo_sde  	= b.cnsctvo_cdgo_sde
		And	(@ldFechaReferencia Between b.inco_vgnca And b.fn_vgnca)
	End	
	Else
	Begin
		-- Si codigo de oficina es nulo y cadena de seleccion no es nula 
		-- Se seleccionan todos las oficinas que no hayan sido borrados, cumplan la vigencia y 
		-- tengan esa descripcion  
		Select	a.cdgo_ofcna, a.dscrpcn_ofcna,	a.cnsctvo_cdgo_ofcna,	
		       	a.cnsctvo_cdgo_sde,	b.cdgo_sde
		From tbOficinas_Vigencias a, tbSedes_Vigencias b
		Where	(@ldFechaReferencia Between a.inco_vgnca And a.fn_vgnca) 
		And     	(a.vsble_usro 		= 'S'Or @lnLlamado = 'S')
		And	ltrim(rtrim(a.dscrpcn_ofcna)) Like '%'+ltrim(rtrim(@lcCadenaSeleccion))+'%'
		And	((a.cnsctvo_cdgo_sde	= @lnConsecutivoSede) Or @lnConsecutivoSede Is Null)
		And       a.cnsctvo_cdgo_sde  = b.cnsctvo_cdgo_sde
		And	(@ldFechaReferencia Between b.inco_vgnca And b.fn_vgnca)
	End	
	
End
Else
Begin
	-- Si codigo de oficina no es nulo se seleccionan todos las oficinas que no hayan sido borrados, 
	-- cumplan la vigencia y tengan el codigo de sede que se ingreso
	Select	a.cdgo_ofcna, a.dscrpcn_ofcna,	a.cnsctvo_cdgo_ofcna,	
		       	a.cnsctvo_cdgo_sde,	b.cdgo_sde
	From tbOficinas_Vigencias a, tbSedes_Vigencias b
	Where	(@ldFechaReferencia Between a.inco_vgnca And a.fn_vgnca)
	And       (a.vsble_usro 		= 'S' Or @lnLlamado = 'S')
	And	a.cdgo_ofcna 		= @lcCodigoOficina
	And	((a.cnsctvo_cdgo_sde	= @lnConsecutivoSede) Or @lnConsecutivoSede Is Null)
	And      a.cnsctvo_cdgo_sde   = b.cnsctvo_cdgo_sde
	And	(@ldFechaReferencia Between b.inco_vgnca And b.fn_vgnca)
End



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [autsalud_rol]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Inteligencia]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasSedes] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];

