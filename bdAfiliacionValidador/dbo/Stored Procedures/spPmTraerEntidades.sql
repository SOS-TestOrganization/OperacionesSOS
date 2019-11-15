


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :  spTraerEntidades
* Desarrollado por		 :  <\A    Ing. Alexander Yela Reyes						A\>
* Descripcion			 :  <\D   Traer todos las Entidades				.			D\>
* Observaciones		              :  <\O										O\>
* Parametros			 :  <\P  Consecutivo Codigo Entidad						P\>		
* Fecha Creacion		 :  <\FC  2002/29/10								FC\>
*  
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION   
*---------------------------------------------------------------------------------  
* Modificado Por		              : <\AM Ing. Carlos Andrés López Ramírez 					AM\>
* Descripcion			 : <\DM Por cambios en las estructuras de las tablas, se ajusta el sp 			DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM 2003/03/20 FM\>
*---------------------------------------------------------------------------------*/
CREATE procedure  spPmTraerEntidades
@lcCodigoEntidad		Char(6) 	= Null,
@ldFechaReferencia		Datetime	= Null ,
@lcCadenaSeleccion		udtDescripcion	= Null,
@lnTipoEntidad			udtConsecutivo,
@lcTraerTodosVisibleUsuario	udtLogico	= 'N'

AS

Set Nocount On

If @ldFechaReferencia = Null
	Set @ldFechaReferencia = getdate()

/*Los registros de los codigos especiales no estan creados por tipo de entidad
estan asociados al tipo de entidad vacio, por eso cuando el codigo enviado
es uno de estos el tipo de entidad se cambia a 0 (vacio) */

If @lcCodigoEntidad = '000000' or @lcCodigoEntidad = '999999'
	Set @lnTipoEntidad = 0

If @lcCodigoEntidad IS NULL
	If @lcCadenaSeleccion =  '+' Or @lcCadenaSeleccion IS NULL
		--Selecciona todos los registros de  la tabla  TbEntidades donde el campo borrado sea 'N' y este
		--dentro de un rango vigente. 				
		Select	cdgo_entdd,	 dscrpcn_entdd ,	 cnsctvo_cdgo_entdd,		nmro_unco_idntfccn_entdd
		From	dbo.tbEntidades_Vigencias
		Where	(@ldFechaReferencia  between inco_vgnca   And    fn_vgnca)
		And	(Vsble_Usro	 =	 'S'	or @lcTraerTodosVisibleUsuario ='S')
		And	cnsctvo_cdgo_tpo_entdd	= @lnTipoEntidad
               Else
		--Selecciona todos los registros de  la tabla  TbEntidades donde el campo borrado sea 'N'  y este
		--dentro de un rango vigente  ademas que   el campo descripcion  contenga el parametro de seleccion
		Select	cdgo_entdd,	 dscrpcn_entdd,	 cnsctvo_cdgo_entdd,nmro_unco_idntfccn_entdd
		From	dbo.tbEntidades_Vigencias
		Where	(@ldFechaReferencia  between inco_vgnca        And   fn_vgnca)
		And	dscrpcn_entdd     like  '%' +    ltrim(rtrim(@lcCadenaSeleccion) + '%' )
		And	(Vsble_Usro	 =	 'S'	or @lcTraerTodosVisibleUsuario ='S')
		And	cnsctvo_cdgo_tpo_entdd	= @lnTipoEntidad
Else
	--Selecciona todos los registros de  la tabla  TbEntidades donde el campo borrado sea 'N'  y este
	--dentro de un rango vigente  ademas  donde el codigo sea igual al parametro  @lnCodigoTipoEntidad
	Select	cdgo_entdd,	 dscrpcn_entdd,	 cnsctvo_cdgo_entdd,nmro_unco_idntfccn_entdd
	From	dbo.tbEntidades_Vigencias
	Where	(@ldFechaReferencia  between inco_vgnca    And     fn_vgnca)
	And	cdgo_entdd =  @lcCodigoEntidad
	And	(Vsble_Usro	 =	 'S'	or @lcTraerTodosVisibleUsuario ='S')
	And	cnsctvo_cdgo_tpo_entdd	= @lnTipoEntidad



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerEntidades] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerEntidades] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerEntidades] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerEntidades] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerEntidades] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerEntidades] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerEntidades] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerEntidades] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerEntidades] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerEntidades] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerEntidades] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerEntidades] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerEntidades] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerEntidades] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerEntidades] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerEntidades] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerEntidades] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerEntidades] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerEntidades] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerEntidades] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerEntidades] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerEntidades] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerEntidades] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

