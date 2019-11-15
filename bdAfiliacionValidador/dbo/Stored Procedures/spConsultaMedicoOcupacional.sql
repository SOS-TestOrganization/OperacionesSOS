
/*---------------------------------------------------------------------------------
* Metodo o PRG 			: spConsultaMedicoOcupacional
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
CREATE PROCEDURE [dbo].[spConsultaMedicoOcupacional]
@lnNumeroUnicoIdentificacionEmpleador	udtConsecutivo,
@lnConsecutivoSucursal					udtConsecutivo,
@lnConsecutivoClaseAportante			udtConsecutivo
As

Set Nocount On

Declare	
	@fechaActual datetime

Begin

	Set @fechaActual = getDate()

	SELECT	ltrim(rtrim(prmr_aplldo))+' '+ltrim(rtrim(sgndo_aplldo))+' '+ltrim(rtrim(prmr_nmbre))+' '+ltrim(rtrim(sgndo_nmbre)) nmbre_mdco, eml
	FROM 	bdAfiliacion.dbo.tbContactosEmpresariales
	WHERE	nmro_unco_idntfccn_empldr = @lnNumeroUnicoIdentificacionEmpleador
    AND		cnsctvo_scrsl = @lnConsecutivoSucursal
    AND		cnsctvo_cdgo_clse_aprtnte = @lnConsecutivoClaseAportante
    AND		cnsctvo_cdgo_tpo_cncto_emprsrl = 1 -->Medico Ocupacional
	AND		@fechaActual between inco_vgnca and fn_vgnca
	
End

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaMedicoOcupacional] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaMedicoOcupacional] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaMedicoOcupacional] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaMedicoOcupacional] TO [Autorizadora Notificacion]
    AS [dbo];

