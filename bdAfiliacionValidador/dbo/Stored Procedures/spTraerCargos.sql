


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :  spTraerCargos
* Desarrollado por		 :  <\A    Ing. Alexander Yela Reyes									A\>
* Descripcion			 :  <\D  Traer todos los cargos definidos en la Base de Datos.						D\>
* Observaciones		              :  <\O													O\>
* Parametros			 :  <\P 	Código Cargo	 										P\>
*				    <\P	Fecha de Referencia										P\>
*				    <\P	Cadena de Selección										P\>		
*				 :  <\P													P\>
* Fecha Creacion		 :  <\FC  2002/31/10											FC\>
*  
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION   
*---------------------------------------------------------------------------------  
* Modificado Por		              : <\AM Ing. Carlos Andrés López Ramírez  AM\>
* Descripcion			 : <\DM Por cambios en las estructuras de las tablas, se ajusta el sp DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM 2003/03/22  FM\>
*---------------------------------------------------------------------------------*/
CREATE procedure  spTraerCargos 
@lcCodigoCargo		Char(4)		= NULL,
@ldFechaReferencia		Datetime	= NULL,
@lcCadenaSeleccion		UdtDescripcion	= NULL,
@lcTraerTodosVisibleUsuario	udtLogico	= 'N'

AS

Set Nocount On

If @lcCodigoCargo is NULL
Begin
	If @lcCadenaSeleccion = '+'	OR	@lcCadenaSeleccion is NULL
	Begin
		If @ldFechaReferencia Is Null
		Begin
			Select	a.cdgo_crgo,	a.dscrpcn_crgo,	a.cnsctvo_cdgo_crgo
			From	tbCargos a
			Where	(a.vsble_usro				=	'S'	OR	@lcTraerTodosVisibleUsuario	=	'S')
		End
		Else
		Begin
			Select	a.cdgo_crgo,	a.dscrpcn_crgo,	a.cnsctvo_cdgo_crgo
			From	tbCargos_Vigencias a
			Where	(@ldFechaReferencia	Between a.Inco_vgnca	and	a.fn_vgnca)
			And	(a.vsble_usro				=	'S'	OR	@lcTraerTodosVisibleUsuario	=	'S')
		End
	End
	Else
	Begin
		If @ldFechaReferencia Is Null
		Begin
			Select	a.cdgo_crgo,	a.dscrpcn_crgo,	a.cnsctvo_cdgo_crgo
			From	tbCargos a
			Where	a.dscrpcn_crgo	Like 	'%' + ltrim(rtrim(@lcCadenaSeleccion)) + '%'
			And	(a.vsble_usro				=	'S'	OR	@lcTraerTodosVisibleUsuario	=	'S')
		End
		Else
		Begin
			Select	a.cdgo_crgo,	a.dscrpcn_crgo,	a.cnsctvo_cdgo_crgo
			From	tbCargos_Vigencias a
			Where	a.dscrpcn_crgo	Like 	'%' + ltrim(rtrim(@lcCadenaSeleccion)) + '%'
			And	(@ldFechaReferencia	Between a.Inco_vgnca	and	a.fn_vgnca)
			And	(a.vsble_usro				=	'S'	OR	@lcTraerTodosVisibleUsuario	=	'S')
		End
	End
End
Else
Begin
	If @ldFechaReferencia Is Null
	Begin
		Select	a.cdgo_crgo,	a.dscrpcn_crgo,	a.cnsctvo_cdgo_crgo
		From	tbCargos a
		Where	(a.vsble_usro				=	'S'	OR	@lcTraerTodosVisibleUsuario	=	'S')
		And	a.cdgo_crgo	= @lcCodigoCargo
	End
	Else
	Begin
		Select	a.cdgo_crgo,	a.dscrpcn_crgo,	a.cnsctvo_cdgo_crgo
		From	tbCargos_Vigencias a
		Where	(@ldFechaReferencia	Between a.Inco_vgnca	and	a.fn_vgnca)
		And	(a.vsble_usro				=	'S'	OR	@lcTraerTodosVisibleUsuario	=	'S')
		And	a.cdgo_crgo	= @lcCodigoCargo
	End
End




GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerCargos] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerCargos] TO [Atep_Soa]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerCargos] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerCargos] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerCargos] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerCargos] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerCargos] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerCargos] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerCargos] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerCargos] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerCargos] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerCargos] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerCargos] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerCargos] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerCargos] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerCargos] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerCargos] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerCargos] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerCargos] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerCargos] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerCargos] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

