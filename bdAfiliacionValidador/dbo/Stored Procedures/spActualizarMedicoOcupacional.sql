

/*---------------------------------------------------------------------------------
* Metodo o PRG 			: spActualizarMedicoOcupacional
* Desarrollado por		: <\A Julian Andres Mina Caicedo A\>
* Descripcion			: <\D 	D\>
* Observaciones			: <\O  	O\>
* Parametros			: <\P 	P\> 
* Variables				: <\V  	V\>
* Fecha Creacion		: <\FC 2010/03/05 				FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		 : <\AM AM\>
* Descripcion			 : <\DM DM\>
* Nuevos Parametros	 	 : <\PM PM\>
* Nuevas Variables		 : <\VM VM\>
* Fecha Modificacion	 : <\FM FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[spActualizarMedicoOcupacional]
@lnNumeroUnicoIdentificacionEmpleador	udtConsecutivo,
@lnConsecutivoSucursal					udtConsecutivo,
@lnConsecutivoClaseAportante			udtConsecutivo,
@lcPrimerApellido						udtApellido,
@lcSegundoApellido						udtApellido,
@lcPrimerNombre							udtNombre,
@lcSegundoNombre						udtNombre,
@lcEmail								udtEmail,
@lcUsuario								udtUsuario
As

Set Nocount On

Declare	
	@fechaActual				datetime,
	@ConsecutivoContacto		int,
	@numeroRegistros			int
	

Begin
	-- Obtine la fecha atual
	Set @fechaActual = getDate()

	SELECT	@numeroRegistros = isNull(count(*),0)
	FROM 	bdAfiliacion.dbo.tbContactosEmpresariales
	WHERE	nmro_unco_idntfccn_empldr = @lnNumeroUnicoIdentificacionEmpleador
    AND		cnsctvo_scrsl = @lnConsecutivoSucursal
    AND		cnsctvo_cdgo_clse_aprtnte = @lnConsecutivoClaseAportante
    AND		cnsctvo_cdgo_tpo_cncto_emprsrl = 1 -->Medico Ocupacional
	AND		@fechaActual between inco_vgnca and fn_vgnca
	AND		upper(ltrim(rtrim(prmr_aplldo)))  = upper(ltrim(rtrim(@lcPrimerApellido)))
	AND		upper(ltrim(rtrim(sgndo_aplldo))) = upper(ltrim(rtrim(@lcSegundoApellido)))
	AND		upper(ltrim(rtrim(prmr_nmbre)))   = upper(ltrim(rtrim(@lcPrimerNombre)))
	AND		upper(ltrim(rtrim(sgndo_nmbre)))  = upper(ltrim(rtrim(@lcSegundoNombre)))


	
	If @numeroRegistros = 0
	-- El nombre es diferente o no existe un medico ocupacional para dicha empresa
	  Begin  
		-- Se acota la vigencia para crear el nuevo medico ocupacional
		exec spAcotarMedicoOcupacional	@lnNumeroUnicoIdentificacionEmpleador,
									@lnConsecutivoSucursal,
									@lnConsecutivoClaseAportante

		-- Se crea el nuevo medico ocupacional para dicha empresa
		exec spCrearMedicoOcupacional	@lnNumeroUnicoIdentificacionEmpleador,
									@lnConsecutivoSucursal,
									@lnConsecutivoClaseAportante,
									@lcPrimerApellido,
									@lcSegundoApellido,
									@lcPrimerNombre,
									@lcSegundoNombre,
									@lcEmail,
									@lcUsuario
		
	  End
	Else
	  -- El nombre es igual por lo tanto solo se cambia el email	
	  Begin  
		-- Cambia el email
		UPDATE	bdAfiliacion.dbo.tbContactosEmpresariales
		SET		eml = @lcEmail
		WHERE	nmro_unco_idntfccn_empldr = @lnNumeroUnicoIdentificacionEmpleador
		AND		cnsctvo_scrsl = @lnConsecutivoSucursal
		AND		cnsctvo_cdgo_clse_aprtnte = @lnConsecutivoClaseAportante
		AND		cnsctvo_cdgo_tpo_cncto_emprsrl = 1 -->Medico Ocupacional
		AND		@fechaActual between inco_vgnca and fn_vgnca
	  End

End

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spActualizarMedicoOcupacional] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spActualizarMedicoOcupacional] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spActualizarMedicoOcupacional] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spActualizarMedicoOcupacional] TO [Autorizadora Notificacion]
    AS [dbo];

