CREATE  procedure  [dbo].[spPmTraerTiposIdentificacion]
@ldFechaReferencia						datetime		= Null,
@lcCodigoAgrupadorTipoIdentificacion	udtCodigo		= Null,
@lcCodigoTipoIdentificacion				udtTipoIdentificacion	= Null,
@lnClaseEmpleador						udtConsecutivo		= Null,
@lcTraerTodosVisibleUsuario				udtLogico		= 'N'

AS
Set Nocount On

If @ldFechaReferencia Is Null
	Set @ldFechaReferencia = GetDate()

If @lcTraerTodosVisibleUsuario Is Null
	Set	@lcTraerTodosVisibleUsuario = ''

If @lcCodigoTipoIdentificacion Is Null
	Begin
		-- si codigo tipo de identificacion no viene se deben seleccionar todos los  tipos de identificacion
		-- que no esten borrados, cumplan las vigencias y pertenezcan al codigo agrupador ingresado
		--Set	@lcTraerTodosVisibleUsuario	='S'
		Select		c.cdgo_tpo_idntfccn,	Substring(Ltrim(Rtrim(c.dscrpcn_tpo_idntfccn)),1,50)	dscrpcn_tpo_idntfccn,	c.cnsctvo_cdgo_tpo_idntfccn,
 					rngo_infrr,				rngo_sprr
		From		tbTiposIdentificacion_Vigencias	c	With(NoLock)
		Where		@ldFechaReferencia	Between c.inco_vgnca And c.fn_vgnca
		And			c.vsble_usro		= 'S'
		Union
		Select		c.cdgo_tpo_idntfccn,	Substring(Ltrim(Rtrim(c.dscrpcn_tpo_idntfccn)),1,50)	dscrpcn_tpo_idntfccn,	c.cnsctvo_cdgo_tpo_idntfccn,
 					rngo_infrr,				rngo_sprr
		From		tbTiposIdentificacion_Vigencias	c	With(NoLock)
		Where		@ldFechaReferencia	Between c.inco_vgnca And c.fn_vgnca
		And			@lcTraerTodosVisibleUsuario	= 'S'
		Order by	c.cdgo_tpo_idntfccn
	End
Else
	Begin
		-- si codigo tipo de identificacion viene se deben seleccionar todos los tipos de identificacion
		-- que no esten borrados, cumplan las vigencias y tengan ese codigo tipo de identificacion
		Select	c.cdgo_tpo_idntfccn,	Substring(Ltrim(Rtrim(c.dscrpcn_tpo_idntfccn)),1,50)	dscrpcn_tpo_idntfccn,	c.cnsctvo_cdgo_tpo_idntfccn,
 				rngo_infrr,				rngo_sprr
		From 	tbTiposIdentificacion_Vigencias	c	With(NoLock)
		Where	cdgo_tpo_idntfccn			= @lcCodigoTipoIdentificacion 
		And 	@ldFechaReferencia	Between c.inco_vgnca And c.fn_vgnca
		And		c.vsble_usro		= 'S'
		Union
		Select	c.cdgo_tpo_idntfccn,	Substring(Ltrim(Rtrim(c.dscrpcn_tpo_idntfccn)),1,50)	dscrpcn_tpo_idntfccn,	c.cnsctvo_cdgo_tpo_idntfccn,
 				rngo_infrr,				rngo_sprr
		From 	tbTiposIdentificacion_Vigencias	c	With(NoLock)
		Where	cdgo_tpo_idntfccn			= @lcCodigoTipoIdentificacion 
		And 	@ldFechaReferencia			Between c.inco_vgnca And c.fn_vgnca
		And		@lcTraerTodosVisibleUsuario	= 'S'
		Order by c.cdgo_tpo_idntfccn
	End

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [300202 Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [cna_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [vafss_role]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [Atep_Soa]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [outbts01]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [ctp_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [ctc_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerTiposIdentificacion] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

