

/*---------------------------------------------------------------------------------
* Metodo o PRG 			: spCrearMedicoOcupacional
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
CREATE PROCEDURE [dbo].[spCrearMedicoOcupacional]
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
	@ConsecutivoContacto		int
	

Begin
	-- Obtine la fecha atual
	Set @fechaActual = getDate()

	-- Obtiene el proximo consecutivo de contacto empresarial
	SELECT @ConsecutivoContacto = isNull(max(cnsctvo_cntcto_emprsrl),0)+1
	FROM   tbContactosEmpresariales	

	
	INSERT INTO [bdAfiliacion].[dbo].[tbContactosEmpresariales]
           (cnsctvo_cntcto_emprsrl,nmro_unco_idntfccn_empldr,cnsctvo_scrsl,cnsctvo_cdgo_clse_aprtnte,
			cnsctvo_cdgo_tpo_cncto_emprsrl,cnsctvo_cdgo_tpo_idntfccn,nmro_idntfccn,prmr_aplldo,
			sgndo_aplldo,prmr_nmbre,sgndo_nmbre,tlfno,extnsn,eml,cnsctvo_cdgo_cncpto_nvdd,inco_vgnca,
			fn_vgnca,fcha_ultma_mdfccn,usro_crcn)
     VALUES
           (@ConsecutivoContacto,@lnNumeroUnicoIdentificacionEmpleador,@lnConsecutivoSucursal,@lnConsecutivoClaseAportante,1,0,'0',@lcPrimerApellido,
            @lcSegundoApellido,@lcPrimerNombre,@lcSegundoNombre,'','',@lcEmail,1,@fechaActual,'99991231',@fechaActual,@lcUsuario)
	
End

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCrearMedicoOcupacional] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCrearMedicoOcupacional] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCrearMedicoOcupacional] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCrearMedicoOcupacional] TO [Autorizadora Notificacion]
    AS [dbo];

