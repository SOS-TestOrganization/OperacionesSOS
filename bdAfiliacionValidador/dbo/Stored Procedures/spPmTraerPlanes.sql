



/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spTraerPlanes
* Desarrollado por		: <\A Ing. Maria Liliana Prieto  										A\>
* Descripcion			: <\D Este procedimiento permite recuperar la lista de los planes, permitiendo filtrar o no por tipo de plan y por 	D\>
				  <\D descripcion, validando o no su vigencia, tambien se puede recuperar el registro de un plan especifico 	D\>
				  <\D enviando el codigo del plan.  									D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P Fecha a la cual se valida la vigencia del plan 								P\>
				  <\P Caracteres ingresados por el usuario para realizar la busqueda por el nombre del plan 			P\>				 
				  <\P Tipo de plan a seleccionar (POS - PAC) 								P\>
				  <\P Codigo del plan a traer 										P\>
				  <\P Llamado = null se incluiye entre los planes Vacio e inexistente, != no se incluye vacio e inexistente entre los planes P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/06/27 											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*--------------------------------------------------------------------------------- 
* Modificado Por			: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  FM\>
*---------------------------------------------------------------------------------*/
CREATE procedure  [spPmTraerPlanes]
	@lcCodigoPlan			UdtCodigo 	= NULL,
	@ldFechaReferencia		Datetime 	= NULL,
	@lcCadenaSeleccion		UdtDescripcion	= NULL,
	@lnConsecutivoTipoPlan		UdtConsecutivo	= NULL,
	@lnLlamado			int		= NULL
	
As

Set Nocount On


IF @ldFechaReferencia Is Null
	Set @ldFechaReferencia = GetDate()


If @lcCodigoPlan Is Null
Begin
	If @lcCadenaSeleccion = '+' Or @lcCadenaSeleccion Is Null
	Begin
		-- Si codigo de plan es nulo y cadena de seleccion es nula
		-- Se seleccionan todos los planes que no hayan sido borrados y cumplan la vigencia 
		Select	a.cdgo_pln,			a.dscrpcn_pln,		a.cnsctvo_cdgo_pln,	
		       	a.cnsctvo_cdgo_tpo_pln,	b.cdgo_tpo_pln
		From tbPlanes_Vigencias a, tbTiposPlan_Vigencias b
		Where	(@ldFechaReferencia Between a.inco_vgnca And a.fn_vgnca)
		And	((a.cnsctvo_cdgo_tpo_pln	= @lnConsecutivoTipoPlan) Or @lnConsecutivoTipoPlan Is Null)
		And       (a.vsble_usro 			= 'S' Or @lnLlamado Is Null)
		And       a.cnsctvo_cdgo_tpo_pln  	= b.cnsctvo_cdgo_tpo_pln
		And	(@ldFechaReferencia Between b.inco_vgnca And b.fn_vgnca)
		Order By a.cnsctvo_cdgo_pln

	End	
	Else
	Begin
		-- Si codigo de plan es nulo y cadena de seleccion no es nula 
		-- Se seleccionan todos los planes que no hayan sido borrados, cumplan la vigencia y 
		-- tengan esa descripcion  
		Select a.cdgo_pln,	a.dscrpcn_pln, 	a.cnsctvo_cdgo_pln,	a.cnsctvo_cdgo_tpo_pln,
		          b.cdgo_tpo_pln
		From tbPlanes_Vigencias a, tbTiposPlan_Vigencias b
		Where	(@ldFechaReferencia Between a.inco_vgnca And a.fn_vgnca) 
		And     	(a.vsble_usro 		= 'S'Or @lnLlamado Is Null)
		And	ltrim(rtrim(a.dscrpcn_pln)) Like '%'+ltrim(rtrim(@lcCadenaSeleccion))+'%'
		And	((a.cnsctvo_cdgo_tpo_pln	= @lnConsecutivoTipoPlan) Or @lnConsecutivoTipoPlan Is Null)
		And       a.cnsctvo_cdgo_tpo_pln  = b.cnsctvo_cdgo_tpo_pln
		And	(@ldFechaReferencia Between b.inco_vgnca And b.fn_vgnca)
		Order By a.cnsctvo_cdgo_pln
	End	
	
End
Else
Begin
	-- Si codigo de plan no es nulo se seleccionan todos los planes que no hayan sido borrados, 
	-- cumplan la vigencia y tengan el tipo de plan que se ingreso
	Select a.cdgo_pln,	a.dscrpcn_pln, 	a.cnsctvo_cdgo_pln,	a.cnsctvo_cdgo_tpo_pln,
	          b.cdgo_tpo_pln
	From tbPlanes_Vigencias a,	 tbTiposPlan_Vigencias b
	Where	(@ldFechaReferencia Between a.inco_vgnca And a.fn_vgnca)
	And       (a.vsble_usro 		= 'S' Or @lnLlamado Is Null)
	And	a.cdgo_pln 		= @lcCodigoPlan
	And	((a.cnsctvo_cdgo_tpo_pln	= @lnConsecutivoTipoPlan) Or @lnConsecutivoTipoPlan Is Null)
	And      a.cnsctvo_cdgo_tpo_pln   = b.cnsctvo_cdgo_tpo_pln
	And	(@ldFechaReferencia Between b.inco_vgnca And b.fn_vgnca)
	Order By a.cnsctvo_cdgo_pln
End




GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [300202 Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [cna_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [vafss_role]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [ServicioClientePortal]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [outbts01]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Consultor Auxiliar Sedes Red Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Aprendiz Red de Servicios Red Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Coordinador Parametros RedSalud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Consultor Cuentas Medicas Red Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Auditor Interno Red Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Auxiliar Parametros Red Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [portal_rol]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [autsalud_rol]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerPlanes] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

