


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :  spTraerRangosSalariales
* Desarrollado por		 :  <\A    Ing. Frnacisco Javier Gonzalez R									A\>
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
* Modificado Por		              : <\AM   AM\>
* Descripcion			 : <\DM   DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM   FM\>
*----------------------------------------------------------------------------------*/
CREATE procedure  spTraerRangosSalariales
@lcCodigoTipoAfiliado	Char(2)		= NULL,
@ldFechaReferencia	Datetime	= NULL,
@lcCadenaSeleccion	UdtDescripcion	= NULL

AS

Set Nocount On

If	@ldFechaReferencia	Is 	Null
	If 	@lcCodigoTipoAfiliado 	Is 	Null
	Begin
		If @lcCadenaSeleccion = '+'	OR	@lcCadenaSeleccion is NULL
		Begin
			Select	a.cdgo_rngo_slrl,	a.dscrpcn_rngo_slrl,	a.cnsctvo_cdgo_rngo_slrl
			From	tbRangosSalariales a
			Where	a.vsble_usro	= 'S'
		End
		Else
		Begin
			Select	a.cdgo_rngo_slrl,	a.dscrpcn_rngo_slrl,	a.cnsctvo_cdgo_rngo_slrl
			From	tbRangosSalariales a
			Where	a.dscrpcn_rngo_slrl	Like 	'%' + ltrim(rtrim(@lcCadenaSeleccion)) + '%'
			And	a.vsble_usro	= 'S'
		End
	End
	Else
	Begin
		Select	a.cdgo_rngo_slrl,	a.dscrpcn_rngo_slrl,	a.cnsctvo_cdgo_rngo_slrl
		From	tbRangosSalariales a
		Where	a.vsble_usro	= 'S'
		And	a.cdgo_rngo_slrl	= @lcCodigoTipoAfiliado
	End
Else
	If @lcCodigoTipoAfiliado is NULL
	Begin
		If @lcCadenaSeleccion = '+'	OR	@lcCadenaSeleccion is NULL
		Begin
			Select	a.cdgo_rngo_slrl,	a.dscrpcn_rngo_slrl,	a.cnsctvo_cdgo_rngo_slrl
			From	tbRangosSalariales_Vigencias a
			Where	((@ldFechaReferencia	Between a.Inco_vgnca	and	a.fn_vgnca)	OR	 @ldFechaReferencia is NULL)
			And	a.vsble_usro	= 'S'
		End
		Else
		Begin
			Select	a.cdgo_rngo_slrl,	a.dscrpcn_rngo_slrl,	a.cnsctvo_cdgo_rngo_slrl
			From	tbRangosSalariales_Vigencias a
			Where	a.dscrpcn_rngo_slrl	Like 	'%' + ltrim(rtrim(@lcCadenaSeleccion)) + '%'
			And	((@ldFechaReferencia	Between a.Inco_vgnca	and	a.fn_vgnca)	OR	 @ldFechaReferencia is NULL)
			And	a.vsble_usro	= 'S'
		End
	End
	Else
	Begin
		Select	a.cdgo_rngo_slrl,	a.dscrpcn_rngo_slrl,	a.cnsctvo_cdgo_rngo_slrl
		From	tbRangosSalariales_Vigencias a
		Where	((@ldFechaReferencia	Between a.Inco_vgnca	and	a.fn_vgnca)	OR	 @ldFechaReferencia is NULL)
		And	a.vsble_usro	= 'S'
		And	a.cdgo_rngo_slrl	= @lcCodigoTipoAfiliado
	End




GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerRangosSalariales] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerRangosSalariales] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerRangosSalariales] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerRangosSalariales] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerRangosSalariales] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerRangosSalariales] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerRangosSalariales] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerRangosSalariales] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerRangosSalariales] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerRangosSalariales] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerRangosSalariales] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerRangosSalariales] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerRangosSalariales] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerRangosSalariales] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerRangosSalariales] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerRangosSalariales] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerRangosSalariales] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerRangosSalariales] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerRangosSalariales] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerRangosSalariales] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

