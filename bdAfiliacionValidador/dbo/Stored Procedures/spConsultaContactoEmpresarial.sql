

/*---------------------------------------------------------------------------------
* Metodo o PRG 			: spConsultaContactoEmpresarial
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
CREATE PROCEDURE [dbo].[spConsultaContactoEmpresarial]
@lnNumeroUnicoIdentificacionEmpleador	udtConsecutivo,
@lnConsecutivoSucursal					udtConsecutivo,
@lnConsecutivoClaseAportante			udtConsecutivo,
@lnConsecutivoTipoContactoEmpresarial	udtConsecutivo,
@ldFechaReferencia						datetime		= NULL
As


Set Nocount On

Begin

	If @ldFechaReferencia is null
	Begin
		set @ldFechaReferencia = getDate()
	End

	SELECT	cnsctvo_cntcto_emprsrl,nmro_unco_idntfccn_empldr,cnsctvo_scrsl,cnsctvo_cdgo_clse_aprtnte,
			cnsctvo_cdgo_tpo_cncto_emprsrl,cnsctvo_cdgo_tpo_idntfccn,nmro_idntfccn,prmr_aplldo,
			sgndo_aplldo,prmr_nmbre,sgndo_nmbre,tlfno,extnsn,eml,cnsctvo_cdgo_cncpto_nvdd,inco_vgnca,
			fn_vgnca,fcha_ultma_mdfccn,usro_crcn
	FROM 	bdAfiliacion.dbo.tbContactosEmpresariales
	WHERE	nmro_unco_idntfccn_empldr = @lnNumeroUnicoIdentificacionEmpleador
    AND		cnsctvo_scrsl = @lnConsecutivoSucursal
    AND		cnsctvo_cdgo_clse_aprtnte = @lnConsecutivoClaseAportante
    AND		cnsctvo_cdgo_tpo_cncto_emprsrl = @lnConsecutivoTipoContactoEmpresarial
	AND		@ldFechaReferencia between inco_vgnca and fn_vgnca
     
End

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaContactoEmpresarial] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaContactoEmpresarial] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaContactoEmpresarial] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaContactoEmpresarial] TO [Autorizadora Notificacion]
    AS [dbo];

