
-- sp_helptext spPminsertalogvalidadorSipres

/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	             		:  SpGrabaafiliadoEspecialCaja
* Desarrollado por		:  <\A    Ing. Yasmin Ramirez						A\>
* Descripcion		 	:  <\D    Grabab o modifica un afiliado especial				D\>
* Observaciones		              	:  <\O									O\>
* Parametros			:  <\P 	Tipo de Identificacion del Afiliado especial 			P\>
* 				:  <\P 	Numero de Identificacion del Afiliado especial 			P\>
* 				:  <\P 	Primer Nombre del Afiliado especial 				P\>
* 				:  <\P 	Segundo Nombre del Afiliado especial 				P\>
* 				:  <\P 	Primer Apellido del Afiliado especial 				P\>
* 				:  <\P 	Segundo Apellido del Afiliado especial 				P\>
* 				:  <\P 	Fecha del Nacimiento del Afiliado especial 			P\>
* 				:  <\P 	Sexo del Afiliado especial 					P\>
* 				:  <\P 	Parentesco del Afiliado especial 					P\>
* 				:  <\P 	Ciudad del Afiliado especial 					P\>
* 				:  <\P 	Plan del Afiliado especial 					P\>
* 				:  <\P 	Inicio de Vigencia del Afiliado especial 				P\>
* 				:  <\P 	Fin de Vigencia del Afiliado especial 				P\>
* 				:  <\P 	Rango Salarial del Afiliado especial 				P\>
* 				:  <\P 	Tipo de Afiliado  						P\>
* 				:  <\P 	Semanas Cotizadas 						P\>
* 				:  <\P 	Ips Primaria del Afiliado Especial 				P\>
* 				:  <\P 	Afp Afiliado Especial 						P\>
* 				:  <\P 	Sede de Radicacion del Afiliado Especial 			P\>
* 				:  <\P 	Tipo de Identificacion del cotizante del Afiliado Especial 		P\>
* 				:  <\P 	Nro. de Identificacion del cotizante del Afiliado Especial 		P\>
* 				:  <\P 	Primer Nombre del cotizante del Afiliado Especial 		P\>
* 				:  <\P 	Segundo Nombre del cotizante del Afiliado Especial 		P\>
* 				:  <\P 	Primer Apellido del cotizante del Afiliado Especial 		P\>
* 				:  <\P 	Segundo Apellido del cotizante del Afiliado Especial 		P\>
* 				:  <\P 	Tipo de Identificacion del EMpleador del Afiliado Especial 	P\>
* 				:  <\P 	Nro.de Identificacion del EMpleador del Afiliado Especial 	P\>
* 				:  <\P 	Digito de chequeo del empleador del Afiliado Especial 		P\>
* 				:  <\P 	Razon Social del empleador del Afiliado Especial 		P\>
* 				:  <\P 	Actividad Economica del empleador del Afiliado Especial 	P\>
* 				:  <\P 	ARP del empleador del Afiliado Especial 			P\>
* 				:  <\P 	Sucursal del empleador del Afiliado Especial 			P\>
* 				:  <\P 	Tipo de Cotizante del Afiliado Especial 				P\>
* 				:  <\P 	Cargo del cotizante del Afiliado Especial 				P\>
* 				:  <\P 	Motivo por el cual se graba como  Afiliado Especial 		P\>
* 				:  <\P 	Usuario que autoriza grabar como  Afiliado Especial 		P\>
* 				:  <\P 	Observaciones al grabar Afiliado Especial 			P\>
* 				:  <\P 	Usuario que graba o modifica el  Afiliado Especial 		P\>
* 				:  <\P 	Nui del EMpleador del Afiliado Especial 				P\>
* 				:  <\P 	Aplicativo desde donde se graba el Afiliado Especial 		P\>
* Fecha Creacion		:  <\FC  2003/09/01							FC\>
*  
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION   
*---------------------------------------------------------------------------------  
* Modificado Por		 : <\AM   AM\>
* Descripcion			 : <\DM   DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM   FM\>
*---------------------------------------------------------------------------------*/
CREATE Procedure [dbo].[SpPmGrabaafiliadoEspecialCajaPrueba]
@cnsctvo_cdgo_tpo_idntfccn	Udtconsecutivo, 
@nmro_idntfccn		UdtNumeroIdentificacion, 
@prmr_nmbre			UdtNombre,
@sgndo_nmbre			UdtNombre,
@prmr_aplldo			Udtapellido,
@sgndo_aplldo			Udtapellido,
@fcha_ncmnto			datetime,
@cnsctvo_cdgo_sxo		Udtconsecutivo, 
@cnsctvo_cdgo_prntsco		Udtconsecutivo, 
@cnsctvo_cdgo_cdd		Udtconsecutivo, 
@cnsctvo_cdgo_pln		Udtconsecutivo, 
@inco_vgnca			datetime,
@fn_vgnca			datetime,
@cnsctvo_cdgo_rngo_slrl	Udtconsecutivo, 
@cnsctvo_cdgo_tpo_afldo	Udtconsecutivo, 
@smns_ctzds			int, 
@cdgo_ips_prmra		UdtcodigoIps, 
@cnsctvo_cdgp_tpo_entdd_afp	Udtconsecutivo, 
@cnsctvo_cdgo_sde_rdccn	Udtconsecutivo, 
@cnsctvo_tpo_idntfccn_ctznte	Udtconsecutivo, 
@nmro_idntfccn_ctznte		UdtNumeroIdentificacion, 
@prmr_nmbre_ctnzte		UdtNombre,
@sgndo_nmbre_ctznte		UdtNombre,
@prmr_aplldo_ctznte		Udtapellido,
@sgndo_aplldo_ctznte		Udtapellido,
@cnsctvo_tpo_idntfccn_empldr	Udtconsecutivo, 
@nmro_idntfccn_empldr		UdtNumeroIdentificacion, 
@dgto_chqo			int, 
@rzn_scl			varchar(150),
@cnsctvo_cdgo_actvdd_ecnmca	Udtconsecutivo, 
@cnsctvo_cdgp_tpo_entdd_arp	Udtconsecutivo, 
@cnsctvo_cdgo_cdd_scrsl	Udtconsecutivo, 
@cnsctvo_cdgo_tpo_ctznte	Udtconsecutivo, 
@cnsctvo_cdgo_crgo		Udtconsecutivo,
@cnsctvo_cdgo_mtvo		Udtconsecutivo,
@cdgo_usro_autrza                  	varchar(3),
@obsrvcns			UdtObservacion,
@usro_mdfccn			UdtUsuario,
@nmro_unco_idntfccn_empldr	Udtconsecutivo,
@cnsctvo_cdgo_mdlo 		Udtconsecutivo

as
declare 	@existe 			char(1),
	@nui_afldo 		UdtConsecutivo,
	@max_nui		UdtConsecutivo

set nocount on 

If	(Select ltrim(rtrim(vlr_prmtro))
	From	dbo.tbtablaParametros
	Where	cnsctvo_prmtro	in (4))	= ltrim(rtrim(CONVERT(varchar(30), SERVERPROPERTY('machinename')))) -- atenea
		
	or

	(Select ltrim(rtrim(vlr_prmtro))
	From	dbo.tbtablaParametros
	Where	cnsctvo_prmtro	in (5))	= ltrim(rtrim(CONVERT(varchar(30), SERVERPROPERTY('machinename')))) -- temis


begin tran 

select @existe='N'

		select 	@existe='S' 
		from 	bdIPSIntegracion.dbo.tbInfAfiliadosEspeciales
		where 	cnsctvo_cdgo_tpo_idntfccn	=	@cnsctvo_cdgo_tpo_idntfccn
		and   	nmro_idntfccn 				=	@nmro_idntfccn

		if @existe != 'S'
		Begin
			insert into bdIPSIntegracion.dbo.tbInfAfiliadosEspeciales
			(	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,			prmr_nmbre,
				sgndo_nmbre,			prmr_aplldo,			sgndo_aplldo,
				fcha_ncmnto,			cnsctvo_cdgo_pln, 		cnsctvo_cdgo_sxo,
				cnsctvo_cdgo_rngo_slrl,		cnsctvo_cdgo_cdd,		cnsctvo_cdgo_prntsco,
				cnsctvo_cdgo_tpo_entdd_arp,	cnsctvo_cdgp_tpo_entdd_afp,	inco_vgnca,
				fn_vgnca,			cnsctvo_cdgo_sde_rdccn,	smns_ctzds,
				cdgo_ips_prmra,		cnsctvo_cdgo_tpo_afldo,		cnsctvo_tpo_idntfccn_ctznte,
				nmro_idntfccn_ctznte,		prmr_nmbre_ctnzte,		sgndo_nmbre_ctznte,
				prmr_aplldo_ctznte,		sgndo_aplldo_ctznte,		nmro_unco_idntfccn_empldr,
				cnsctvo_tpo_idntfccn_empldr,	nmro_idntfccn_empldr,		dgto_chqo,
				rzn_scl,				cnsctvo_cdgo_actvdd_ecnmca,	cnsctvo_cdgo_cdd_scrsl,
				cnsctvo_cdgo_crgo,		cnsctvo_cdgo_tpo_ctznte,	cnsctvo_cdgo_mtvo,--cdgo_mtvo,
				fcha_crcn,			fcha_ultma_mdfccn,		usro_ultma_mdfccn,
				cdgo_usro_atrza,		Obsrvcns,			cnsctvo_cdgo_mdlo,
				mqna_usro		)			
			values
			(	@cnsctvo_cdgo_tpo_idntfccn,	@nmro_idntfccn,		@prmr_nmbre,
				@sgndo_nmbre,			@prmr_aplldo,			@sgndo_aplldo,
				@fcha_ncmnto,			@cnsctvo_cdgo_pln,		@cnsctvo_cdgo_sxo,
				@cnsctvo_cdgo_rngo_slrl,	@cnsctvo_cdgo_cdd,		@cnsctvo_cdgo_prntsco,
				@cnsctvo_cdgp_tpo_entdd_arp,	@cnsctvo_cdgp_tpo_entdd_afp,	@inco_vgnca,	
				@fn_vgnca,			@cnsctvo_cdgo_sde_rdccn,	@smns_ctzds,
				@cdgo_ips_prmra,		@cnsctvo_cdgo_tpo_afldo,	@cnsctvo_tpo_idntfccn_ctznte,
				@nmro_idntfccn_ctznte,		@prmr_nmbre_ctnzte,		@sgndo_nmbre_ctznte,
				@prmr_aplldo_ctznte,		@sgndo_aplldo_ctznte,		@nmro_unco_idntfccn_empldr,
				@cnsctvo_tpo_idntfccn_empldr,	@nmro_idntfccn_empldr,	@dgto_chqo,	
				@rzn_scl,			@cnsctvo_cdgo_actvdd_ecnmca,	@cnsctvo_cdgo_cdd_scrsl,
				@cnsctvo_cdgo_crgo,		@cnsctvo_cdgo_tpo_ctznte,	@cnsctvo_cdgo_mtvo,
				getdate(),			getdate(),			@usro_mdfccn,
				@cdgo_usro_autrza,		@obsrvcns,			@cnsctvo_cdgo_mdlo,
				host_name()		)
			if @@error <> 0
			Begin
				rollback tran
				return -1
			End
		End
		else
		Begin
			update 	bdIPSIntegracion.dbo.tbInfAfiliadosEspeciales
			set 	prmr_nmbre		= 	@prmr_nmbre,
				sgndo_nmbre		= 	@sgndo_nmbre,	
				prmr_aplldo		= 	@prmr_aplldo,			
				sgndo_aplldo		= 	@sgndo_aplldo,
				fcha_ncmnto		= 	@fcha_ncmnto,			
				cnsctvo_cdgo_pln	= 	@cnsctvo_cdgo_pln, 		
				cnsctvo_cdgo_sxo	= 	@cnsctvo_cdgo_sxo,
				cnsctvo_cdgo_rngo_slrl	= 	@cnsctvo_cdgo_rngo_slrl,						cnsctvo_cdgo_cdd	= 	@cnsctvo_cdgo_cdd,	
				cnsctvo_cdgo_prntsco	= 	@cnsctvo_cdgo_prntsco,	
				cnsctvo_cdgo_tpo_entdd_arp	= @cnsctvo_cdgp_tpo_entdd_arp,
				cnsctvo_cdgp_tpo_entdd_afp	=@cnsctvo_cdgp_tpo_entdd_afp,
				inco_vgnca		= 	@inco_vgnca,
				fn_vgnca		= 	@fn_vgnca,			
				cnsctvo_cdgo_sde_rdccn	= @cnsctvo_cdgo_sde_rdccn, 
				smns_ctzds		= 	@smns_ctzds,
				cdgo_ips_prmra	= 	@cdgo_ips_prmra,	
				cnsctvo_cdgo_tpo_afldo	= 	@cnsctvo_cdgo_tpo_afldo,	
				cnsctvo_tpo_idntfccn_ctznte	= @cnsctvo_tpo_idntfccn_ctznte,
				nmro_idntfccn_ctznte	= 	@nmro_idntfccn_ctznte,
				prmr_nmbre_ctnzte	= 	@prmr_nmbre_ctnzte,	
				sgndo_nmbre_ctznte	= 	@sgndo_nmbre_ctznte,
				prmr_aplldo_ctznte	=  	@prmr_aplldo_ctznte,	
				sgndo_aplldo_ctznte	= 	@sgndo_aplldo_ctznte,	
				nmro_unco_idntfccn_empldr	= @nmro_unco_idntfccn_empldr,
				cnsctvo_tpo_idntfccn_empldr	= @cnsctvo_tpo_idntfccn_empldr,
				nmro_idntfccn_empldr	= 	@nmro_idntfccn_empldr,
				dgto_chqo		= 	@dgto_chqo,
				rzn_scl			= 	@rzn_scl,		
				cnsctvo_cdgo_actvdd_ecnmca	= @cnsctvo_cdgo_actvdd_ecnmca, 
				cnsctvo_cdgo_cdd_scrsl	= 	@cnsctvo_cdgo_cdd_scrsl,
				cnsctvo_cdgo_crgo	=  	@cnsctvo_cdgo_crgo,
				cnsctvo_cdgo_tpo_ctznte	= @cnsctvo_cdgo_tpo_ctznte,	
				cnsctvo_cdgo_mtvo	= 	@cnsctvo_cdgo_mtvo,
				fcha_ultma_mdfccn	= 	getdate(),		
				usro_ultma_mdfccn	= 	@usro_mdfccn,
				cdgo_usro_atrza	= 	@cdgo_usro_autrza,		
				Obsrvcns		= 	@obsrvcns ,			
				cnsctvo_cdgo_mdlo	= 	@cnsctvo_cdgo_mdlo ,
				mqna_usro		= 	host_name()
			where cnsctvo_cdgo_tpo_idntfccn	=	@cnsctvo_cdgo_tpo_idntfccn
			and   nmro_idntfccn			=	@nmro_idntfccn
			if @@error <> 0
			Begin
				rollback tran
				return -1
			End
		End
if @@error = 0
	commit tran

else

begin tran 

select @existe='N'

		select 	@existe='S' 
		from 	bdSisalud.dbo.tbInfAfiliadosEspeciales
		where 	cnsctvo_cdgo_tpo_idntfccn	=	@cnsctvo_cdgo_tpo_idntfccn
		and   	nmro_idntfccn 				=	@nmro_idntfccn

		if @existe != 'S'
		Begin
			insert into bdSisalud.dbo.tbInfAfiliadosEspeciales
			(	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,			prmr_nmbre,
				sgndo_nmbre,			prmr_aplldo,			sgndo_aplldo,
				fcha_ncmnto,			cnsctvo_cdgo_pln, 		cnsctvo_cdgo_sxo,
				cnsctvo_cdgo_rngo_slrl,		cnsctvo_cdgo_cdd,		cnsctvo_cdgo_prntsco,
				cnsctvo_cdgo_tpo_entdd_arp,	cnsctvo_cdgp_tpo_entdd_afp,	inco_vgnca,
				fn_vgnca,			cnsctvo_cdgo_sde_rdccn,	smns_ctzds,
				cdgo_ips_prmra,		cnsctvo_cdgo_tpo_afldo,		cnsctvo_tpo_idntfccn_ctznte,
				nmro_idntfccn_ctznte,		prmr_nmbre_ctnzte,		sgndo_nmbre_ctznte,
				prmr_aplldo_ctznte,		sgndo_aplldo_ctznte,		nmro_unco_idntfccn_empldr,
				cnsctvo_tpo_idntfccn_empldr,	nmro_idntfccn_empldr,		dgto_chqo,
				rzn_scl,				cnsctvo_cdgo_actvdd_ecnmca,	cnsctvo_cdgo_cdd_scrsl,
				cnsctvo_cdgo_crgo,		cnsctvo_cdgo_tpo_ctznte,	cnsctvo_cdgo_mtvo,--cdgo_mtvo,
				fcha_crcn,			fcha_ultma_mdfccn,		usro_ultma_mdfccn,
				cdgo_usro_atrza,		Obsrvcns,			cnsctvo_cdgo_mdlo,
				mqna_usro		)			
			values
			(	@cnsctvo_cdgo_tpo_idntfccn,	@nmro_idntfccn,		@prmr_nmbre,
				@sgndo_nmbre,			@prmr_aplldo,			@sgndo_aplldo,
				@fcha_ncmnto,			@cnsctvo_cdgo_pln,		@cnsctvo_cdgo_sxo,
				@cnsctvo_cdgo_rngo_slrl,	@cnsctvo_cdgo_cdd,		@cnsctvo_cdgo_prntsco,
				@cnsctvo_cdgp_tpo_entdd_arp,	@cnsctvo_cdgp_tpo_entdd_afp,	@inco_vgnca,	
				@fn_vgnca,			@cnsctvo_cdgo_sde_rdccn,	@smns_ctzds,
				@cdgo_ips_prmra,		@cnsctvo_cdgo_tpo_afldo,	@cnsctvo_tpo_idntfccn_ctznte,
				@nmro_idntfccn_ctznte,		@prmr_nmbre_ctnzte,		@sgndo_nmbre_ctznte,
				@prmr_aplldo_ctznte,		@sgndo_aplldo_ctznte,		@nmro_unco_idntfccn_empldr,
				@cnsctvo_tpo_idntfccn_empldr,	@nmro_idntfccn_empldr,	@dgto_chqo,	
				@rzn_scl,			@cnsctvo_cdgo_actvdd_ecnmca,	@cnsctvo_cdgo_cdd_scrsl,
				@cnsctvo_cdgo_crgo,		@cnsctvo_cdgo_tpo_ctznte,	@cnsctvo_cdgo_mtvo,
				getdate(),			getdate(),			@usro_mdfccn,
				@cdgo_usro_autrza,		@obsrvcns,			@cnsctvo_cdgo_mdlo,
				host_name()		)
			if @@error <> 0
			Begin
				rollback tran
				return -1
			End
		End
		else
		Begin
			update 	bdSisalud.dbo.tbInfAfiliadosEspeciales
			set 	prmr_nmbre		= 	@prmr_nmbre,
				sgndo_nmbre		= 	@sgndo_nmbre,	
				prmr_aplldo		= 	@prmr_aplldo,			
				sgndo_aplldo		= 	@sgndo_aplldo,
				fcha_ncmnto		= 	@fcha_ncmnto,			
				cnsctvo_cdgo_pln	= 	@cnsctvo_cdgo_pln, 		
				cnsctvo_cdgo_sxo	= 	@cnsctvo_cdgo_sxo,
				cnsctvo_cdgo_rngo_slrl	= 	@cnsctvo_cdgo_rngo_slrl,						cnsctvo_cdgo_cdd	= 	@cnsctvo_cdgo_cdd,	
				cnsctvo_cdgo_prntsco	= 	@cnsctvo_cdgo_prntsco,	
				cnsctvo_cdgo_tpo_entdd_arp	= @cnsctvo_cdgp_tpo_entdd_arp,
				cnsctvo_cdgp_tpo_entdd_afp	=@cnsctvo_cdgp_tpo_entdd_afp,
				inco_vgnca		= 	@inco_vgnca,
				fn_vgnca		= 	@fn_vgnca,			
				cnsctvo_cdgo_sde_rdccn	= @cnsctvo_cdgo_sde_rdccn, 
				smns_ctzds		= 	@smns_ctzds,
				cdgo_ips_prmra	= 	@cdgo_ips_prmra,	
				cnsctvo_cdgo_tpo_afldo	= 	@cnsctvo_cdgo_tpo_afldo,	
				cnsctvo_tpo_idntfccn_ctznte	= @cnsctvo_tpo_idntfccn_ctznte,
				nmro_idntfccn_ctznte	= 	@nmro_idntfccn_ctznte,
				prmr_nmbre_ctnzte	= 	@prmr_nmbre_ctnzte,	
				sgndo_nmbre_ctznte	= 	@sgndo_nmbre_ctznte,
				prmr_aplldo_ctznte	=  	@prmr_aplldo_ctznte,	
				sgndo_aplldo_ctznte	= 	@sgndo_aplldo_ctznte,	
				nmro_unco_idntfccn_empldr	= @nmro_unco_idntfccn_empldr,
				cnsctvo_tpo_idntfccn_empldr	= @cnsctvo_tpo_idntfccn_empldr,
				nmro_idntfccn_empldr	= 	@nmro_idntfccn_empldr,
				dgto_chqo		= 	@dgto_chqo,
				rzn_scl			= 	@rzn_scl,		
				cnsctvo_cdgo_actvdd_ecnmca	= @cnsctvo_cdgo_actvdd_ecnmca, 
				cnsctvo_cdgo_cdd_scrsl	= 	@cnsctvo_cdgo_cdd_scrsl,
				cnsctvo_cdgo_crgo	=  	@cnsctvo_cdgo_crgo,
				cnsctvo_cdgo_tpo_ctznte	= @cnsctvo_cdgo_tpo_ctznte,	
				cnsctvo_cdgo_mtvo	= 	@cnsctvo_cdgo_mtvo,
				fcha_ultma_mdfccn	= 	getdate(),		
				usro_ultma_mdfccn	= 	@usro_mdfccn,
				cdgo_usro_atrza	= 	@cdgo_usro_autrza,		
				Obsrvcns		= 	@obsrvcns ,			
				cnsctvo_cdgo_mdlo	= 	@cnsctvo_cdgo_mdlo ,
				mqna_usro		= 	host_name()
			where cnsctvo_cdgo_tpo_idntfccn	=	@cnsctvo_cdgo_tpo_idntfccn
			and   nmro_idntfccn			=	@nmro_idntfccn
			if @@error <> 0
			Begin
				rollback tran
				return -1
			End
		End
if @@error = 0
	commit tran




GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmGrabaafiliadoEspecialCajaPrueba] TO PUBLIC
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmGrabaafiliadoEspecialCajaPrueba] TO [310010 Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmGrabaafiliadoEspecialCajaPrueba] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmGrabaafiliadoEspecialCajaPrueba] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmGrabaafiliadoEspecialCajaPrueba] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmGrabaafiliadoEspecialCajaPrueba] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmGrabaafiliadoEspecialCajaPrueba] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmGrabaafiliadoEspecialCajaPrueba] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmGrabaafiliadoEspecialCajaPrueba] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmGrabaafiliadoEspecialCajaPrueba] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmGrabaafiliadoEspecialCajaPrueba] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmGrabaafiliadoEspecialCajaPrueba] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmGrabaafiliadoEspecialCajaPrueba] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmGrabaafiliadoEspecialCajaPrueba] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

