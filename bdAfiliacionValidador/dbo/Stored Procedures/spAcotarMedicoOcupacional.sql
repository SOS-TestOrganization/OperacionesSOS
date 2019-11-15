
/*---------------------------------------------------------------------------------
* Metodo o PRG 			: spAcotarMedicoOcupacional
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
CREATE PROCEDURE [dbo].[spAcotarMedicoOcupacional]
@lnNumeroUnicoIdentificacionEmpleador	udtConsecutivo,
@lnConsecutivoSucursal					udtConsecutivo,
@lnConsecutivoClaseAportante			udtConsecutivo
As

Set Nocount On

Declare	
	@fechaActual				datetime,
	@ConsecutivoContacto		int
	

Begin
	-- Obtine la fecha atual
	Set @fechaActual = getDate()

	-- Obtiene el consecutivo de contacto empresarial
	SELECT  @ConsecutivoContacto = cnsctvo_cntcto_emprsrl
	FROM 	bdAfiliacion.dbo.tbContactosEmpresariales
	WHERE	nmro_unco_idntfccn_empldr = @lnNumeroUnicoIdentificacionEmpleador
    AND		cnsctvo_scrsl = @lnConsecutivoSucursal
    AND		cnsctvo_cdgo_clse_aprtnte = @lnConsecutivoClaseAportante
    AND		cnsctvo_cdgo_tpo_cncto_emprsrl = 1 -->Medico Ocupacional
	AND		@fechaActual between inco_vgnca and fn_vgnca

	-- Acota la vigencia del Contacto Empresarial	
	UPDATE	bdAfiliacion.dbo.tbContactosEmpresariales
	SET		fn_vgnca = @fechaActual,
			fcha_ultma_mdfccn = @fechaActual
	WHERE	cnsctvo_cntcto_emprsrl = @ConsecutivoContacto
	
End

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spAcotarMedicoOcupacional] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spAcotarMedicoOcupacional] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spAcotarMedicoOcupacional] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spAcotarMedicoOcupacional] TO [Autorizadora Notificacion]
    AS [dbo];

