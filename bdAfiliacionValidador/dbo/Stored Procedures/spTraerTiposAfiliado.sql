


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	          	:  spTraerTiposAfiliado
* Desarrollado por		:  <\A    Ing. Jorge Ivan Rivera										A\>
* Descripcion			:  <\D  Traer todos los tipos de afiliado definidos en la Base de Datos.					D\>
* Observaciones		 	:  <\O													O\>
* Parametros			:  <\P 	Código tipo afiliado	 									P\>
*				    <\P	Fecha de Referencia										P\>
*				    <\P	Cadena de Selección										P\>		
*				:  <\P													P\>
* Fecha Creacion		:  <\FC  2002/18/02											FC\>
*  
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION   
*---------------------------------------------------------------------------------  
* Modificado Por		              : <\AM Ing. Carlos Andrés López Ramírez AM\>
* Descripcion			 : <\DM Por cambios en las estructuras de las tablas, se ajusta el sp DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM 2003/03/20 FM\>
*---------------------------------------------------------------------------------*/

CREATE procedure  spTraerTiposAfiliado

@lcCodigoTipoAfiliado		char(4)		= NULL,
@ldFechaReferencia		datetime	= NULL,
@lcCadenaSeleccion		UdtDescripcion	= NULL,
@lcTraerTodosVisibleUsuario	udtLogico	='N'

AS

Set Nocount On

If @lcCodigoTipoAfiliado is NULL
Begin
	If @lcCadenaSeleccion = '+'	OR	@lcCadenaSeleccion is NULL
	Begin
		If @ldFechaReferencia is NULL
		Begin
			Select	a.cdgo_tpo_afldo,	a.dscrpcn,	a.cnsctvo_cdgo_tpo_afldo
			From	tbTiposAfiliado a
			Where	(a.vsble_usro				=	'S'	OR	@lcTraerTodosVisibleUsuario	=	'S')
		End
		Else
		Begin
			Select	a.cdgo_tpo_afldo,	a.dscrpcn,	a.cnsctvo_cdgo_tpo_afldo
			From	tbTiposAfiliado_Vigencias a
			Where	(@ldFechaReferencia	Between a.Inco_vgnca	and	a.fn_vgnca)
			And	(a.vsble_usro				=	'S'	OR	@lcTraerTodosVisibleUsuario	=	'S')
		End
	End
	Else
	Begin
		If @ldFechaReferencia is NULL
		Begin
			Select	a.cdgo_tpo_afldo,	a.dscrpcn,	a.cnsctvo_cdgo_tpo_afldo
			From	tbTiposAfiliado a
			Where	a.dscrpcn	Like 	'%' + ltrim(rtrim(@lcCadenaSeleccion)) + '%'
			And	(a.vsble_usro				=	'S'	OR	@lcTraerTodosVisibleUsuario	=	'S')
		End
		Else
		Begin
			Select	a.cdgo_tpo_afldo,	a.dscrpcn,	a.cnsctvo_cdgo_tpo_afldo
			From	tbTiposAfiliado_Vigencias a
			Where	a.dscrpcn	Like 	'%' + ltrim(rtrim(@lcCadenaSeleccion)) + '%'
			And	(@ldFechaReferencia	Between a.Inco_vgnca	and	a.fn_vgnca)
			And	(a.vsble_usro				=	'S'	OR	@lcTraerTodosVisibleUsuario	=	'S')
		End
	End
End
Else
Begin
	If @ldFechaReferencia is NULL
	Begin
		Select	a.cdgo_tpo_afldo,	a.dscrpcn,	a.cnsctvo_cdgo_tpo_afldo
		From	tbTiposAfiliado a
		Where	(a.vsble_usro				=	'S'	OR	@lcTraerTodosVisibleUsuario	=	'S')
		And	a.cdgo_tpo_afldo	= @lcCodigoTipoAfiliado
	End
	Else
	Begin
		Select	a.cdgo_tpo_afldo,	a.dscrpcn,	a.cnsctvo_cdgo_tpo_afldo
		From	tbTiposAfiliado_Vigencias a
		Where	(@ldFechaReferencia	Between a.Inco_vgnca	and	a.fn_vgnca)
		And	(a.vsble_usro				=	'S'	OR	@lcTraerTodosVisibleUsuario	=	'S')
		And	a.cdgo_tpo_afldo	= @lcCodigoTipoAfiliado
	End
End




GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposAfiliado] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposAfiliado] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposAfiliado] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposAfiliado] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposAfiliado] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposAfiliado] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposAfiliado] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposAfiliado] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposAfiliado] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposAfiliado] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposAfiliado] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposAfiliado] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposAfiliado] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposAfiliado] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposAfiliado] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposAfiliado] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposAfiliado] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposAfiliado] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposAfiliado] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposAfiliado] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

