


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :   spTraerActividadesEconomicas
* Desarrollado por		 :  <\A    Ing. Alexander Yela Reyes									A\>
* Descripcion			 :  <\D  Traer las Actividades Economicas			.						D\>
* Observaciones		              :  <\O													O\>
* Parametros			 :  <\P 	Consecutivo Actividad Economica									P\>
*				 :  <\P													P\>
* Fecha Creacion		 :  <\FC  2002/31/10											FC\>
*  
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION   
*---------------------------------------------------------------------------------  
* Modificado Por		              : <\AM Ing. Carlos Andrés López Ramírez AM\>
* Descripcion			 : <\DM Por cambios en las estructuras de las tablas, se ajusta el sp DM\>
*	 	 		 : <\PM Se ajustaron las variables y parámetros originales a la nueva plantilla PM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM 2003/03/22 FM\>
*---------------------------------------------------------------------------------*/

CREATE procedure  spTraerActividadesEconomicas

@lcCodigoActividadEconomica	Char(6)		= NULL,
@ldFechaReferencia		Datetime	= NULL,
@lcCadenaSeleccion		UdtDescripcion	= NULL,
@lcTraerTodosVisibleUsuario	udtLogico	='N'

AS

SET Nocount ON

If @ldFechaReferencia IS NULL
	If 	@lcCodigoActividadEconomica IS NULL
		If 	@lcCadenaSeleccion 	= 	'+'	OR	@lcCadenaSeleccion 	IS 	NULL
			Select	a.cdgo_actvdd_ecnmca,		a.dscrpcn_actvdd_ecnmca,	a.cnsctvo_cdgo_actvdd_ecnmca
			From	tbActividadesEconomicas a
			Where  (a.Vsble_Usro	 =	 'S'	OR @lcTraerTodosVisibleUsuario ='S')
		Else
			Select	a.cdgo_actvdd_ecnmca,		a.dscrpcn_actvdd_ecnmca,	a.cnsctvo_cdgo_actvdd_ecnmca
			From	tbActividadesEconomicas a
			Where	a.dscrpcn_actvdd_ecnmca	LIKE	'%' 	+	LTRIM(RTRIM(@lcCadenaSeleccion)) 	+	 '%'
			AND	(a.Vsble_Usro	 =	 'S'	OR @lcTraerTodosVisibleUsuario ='S')
	Else
		Select	a.cdgo_actvdd_ecnmca,		a.dscrpcn_actvdd_ecnmca,	a.cnsctvo_cdgo_actvdd_ecnmca
		From	tbActividadesEconomicas a
		Where	(a.Vsble_Usro		=	 'S'	OR @lcTraerTodosVisibleUsuario ='S')
		AND	a.cdgo_actvdd_ecnmca	= 	@lcCodigoActividadEconomica
Else
	If 	@lcCodigoActividadEconomica IS NULL
		If 	@lcCadenaSeleccion 	= 	'+'	OR	@lcCadenaSeleccion 	Is 	NULL
			Select	a.cdgo_actvdd_ecnmca,		a.dscrpcn_actvdd_ecnmca,	a.cnsctvo_cdgo_actvdd_ecnmca
			From	tbActividadesEconomicas_vigencias a
			Where	(@ldFechaReferencia	BETWEEN 	a.Inco_vgnca	AND	a.Fn_vgnca)
			AND	(a.Vsble_Usro	 =	 'S'	OR @lcTraerTodosVisibleUsuario ='S')
		Else 
			Select	a.cdgo_actvdd_ecnmca,		a.dscrpcn_actvdd_ecnmca,	a.cnsctvo_cdgo_actvdd_ecnmca
			From	tbActividadesEconomicas_vigencias a
			Where	a.dscrpcn_actvdd_ecnmca	LIKE	'%' 	+	LTRIM(RTRIM(@lcCadenaSeleccion)) 	+	 '%'
			AND	(@ldFechaReferencia	BETWEEN 	a.Inco_vgnca	AND	a.Fn_vgnca)
			AND	(a.Vsble_Usro	 =	 'S'	OR @lcTraerTodosVisibleUsuario ='S')
	Else
		Select	a.cdgo_actvdd_ecnmca,		a.dscrpcn_actvdd_ecnmca,	a.cnsctvo_cdgo_actvdd_ecnmca
		From	tbActividadesEconomicas_vigencias a
		Where	(@ldFechaReferencia		BETWEEN 	a.Inco_vgnca	AND	a.Fn_vgnca)
		AND	(a.Vsble_Usro	 =	 'S'	OR @lcTraerTodosVisibleUsuario ='S')
		AND	a.cdgo_actvdd_ecnmca	= 	@lcCodigoActividadEconomica







GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerActividadesEconomicas] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerActividadesEconomicas] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerActividadesEconomicas] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerActividadesEconomicas] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerActividadesEconomicas] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerActividadesEconomicas] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerActividadesEconomicas] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerActividadesEconomicas] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerActividadesEconomicas] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerActividadesEconomicas] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerActividadesEconomicas] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerActividadesEconomicas] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerActividadesEconomicas] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerActividadesEconomicas] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerActividadesEconomicas] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerActividadesEconomicas] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerActividadesEconomicas] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

