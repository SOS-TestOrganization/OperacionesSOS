/*---------------------------------------------------------------------------------
* Metodo o PRG 	         :   SpCUConsultaValidaciones
* Desarrollado por		 :  <\A   Alvaro Zapata			A\>
* Descripcion			 :  <\D  				D\>
* Descripcion			 :  <\D   				D\>
* Observaciones		     :  <\O					O\>
* Parametros			 :  <\P   				P\>
                         :  <\P    				P\>
                         :  <\P   				P\>
* Variables				 :  <\V					V\>
* Fecha Creacion		 :  <\FC 20031023 		FC\>
*  
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------  
* Modificado Por	     : <\AM  Andres Taborda AM\>
* Descripcion			 : <\DM Mejorar Tiempo Optimizacion para consulta validacion por numero y oficina DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion	 : <\FM  Dic/22/2004 FM\>

* Modificado Por	     : <\AM  Samuel Muñoz\>
* Descripcion			 : <\DM Mejorar Tiempo Optimizacion DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion	 : <\FM  Abril/23/2008 FM\>
*---------------------------------------------------------------------------------*/
CREATE Procedure [dbo].[SpCUConsultaValidaciones]
@lcCodigoOficina		Char(5),
@NumeroVerificacion		Numeric,
@ldFechaDesde			Datetime,
@ldFechaHasta			Datetime,
@lnTipoId				udtTipoIdentificacion,
@lnNumeroId				varchar(20),
@lcUsuarioAutorizador	udtUsuario,
@lnTipoConsulta			Int			= Null

As


Set NoCount On

If @lnTipoConsulta Is Null
	If @NumeroVerificacion Is Not Null And  @lcCodigoOficina Is Not Null
		Set @lnTipoConsulta = 1
	Else
		If @lnTipoId Is Not Null And @lnNumeroId Is Not Null
			Set @lnTipoConsulta = 3
		Else
			If @ldFechaDesde Is Not  Null And @ldFechaHasta  Is Not Null
				Set @lnTipoConsulta = 2


Declare	@lcCodigoOficinaReal		udtConsecutivo

Select	@lcCodigoOficinaReal		= cnsctvo_cdgo_ofcna
From	bdAfiliacionValidador.DBO.tbOficinas
Where	cdgo_ofcna					= @lcCodigoOficina


Declare @tmpValidaciones Table
	( nmro_vrfccn				Numeric,
	  fcha_vldcn				Datetime,
	  nmro_idntfccn				Varchar(20),
	  afldo						Char(130),
	  edd						Int,
	  drcho						udtDescripcion,
	  cdgo_usro					udtUsuario,
	  cnsctvo_cdgo_estdo_afldo	udtConsecutivo,
	  cnsctvo_cdgo_ofcna		udtConsecutivo,
	  cnsctvo_cdgo_tpo_idntfccn	udtConsecutivo,
	  cnsctvo_cdgo_pln			udtConsecutivo,
	  cnsctvo_cdgo_sxo			udtConsecutivo,
	  cnsctvo_cdgo_prntscs		udtConsecutivo,
	  cnsctvo_cdgo_rngo_slrl	udtConsecutivo,
	  cnsctvo_cdgo_tpo_undd		udtConsecutivo,
	  cdgo_ips_prmra			udtConsecutivo,
	  cnsctvo_cdgo_pln_pc		udtConsecutivo,
	  cnsctvo_cdgo_tpo_cntrto	udtConsecutivo,
	  nmro_cntrto				udtNumeroFormulario,
	  cnsctvo_bnfcro			udtConsecutivo,
	  nmro_unco_idntfccn_afldo	udtConsecutivo,
	  obsrvcns					Char(250),
	  mtvo_vldcn				Char(50))


If @lnTipoConsulta = 1   -- Cuando se realiza una consulta por el numero de validacion y oficina

	Begin

		Insert	
		Into	@tmpValidaciones(
					nmro_vrfccn,					fcha_vldcn,					nmro_idntfccn,
					afldo,							edd,						drcho,
					cdgo_usro,						cnsctvo_cdgo_estdo_afldo,	cnsctvo_cdgo_ofcna,
					cnsctvo_cdgo_tpo_idntfccn,		cnsctvo_cdgo_pln,			cnsctvo_cdgo_sxo,
					cnsctvo_cdgo_prntscs,			cnsctvo_cdgo_rngo_slrl,		cnsctvo_cdgo_tpo_undd,
					cdgo_ips_prmra,					cnsctvo_cdgo_pln_pc,		cnsctvo_cdgo_tpo_cntrto,
					nmro_cntrto,					cnsctvo_bnfcro,				nmro_unco_idntfccn_afldo,
					obsrvcns)
		Select		a.nmro_vrfccn,					a.fcha_vldcn,				a.nmro_idntfccn,
					ltrim(rtrim(Isnull(a.prmr_aplldo,'')))+' '+ltrim(rtrim(Isnull(a.sgndo_aplldo,'')))+' '+ltrim(rtrim(Isnull(a.prmr_nmbre,'')))+' '+ltrim(rtrim(Isnull(a.sgndo_nmbre,''))) as afldo,
					a.edd,							a.drcho,
					a.cdgo_usro,					a.cnsctvo_cdgo_estdo_afldo,	a.cnsctvo_cdgo_ofcna,
					a.cnsctvo_cdgo_tpo_idntfccn,	a.cnsctvo_cdgo_pln,			a.cnsctvo_cdgo_sxo,
					a.cnsctvo_cdgo_prntscs,			a.cnsctvo_cdgo_rngo_slrl,	a.cnsctvo_cdgo_tpo_undd,
					a.cdgo_ips_prmra,				a.cnsctvo_cdgo_pln_pc,		a.cnsctvo_cdgo_tpo_cntrto,
					a.nmro_cntrto,					a.cnsctvo_bnfcro,			a.nmro_unco_idntfccn_afldo,
					a.obsrvcns
		From		bdSisalud.dbo.tbLog a
		Where		a.nmro_vrfccn			= @NumeroVerificacion 
		And  		a.cnsctvo_cdgo_ofcna	= @lcCodigoOficinaReal

		If @@Rowcount = 0 -- Si no encuentra la validacion en tbLog va a buscarla a TbLogCuentas
			Begin
				Insert	
				Into	@tmpValidaciones(
							nmro_vrfccn,					fcha_vldcn,					nmro_idntfccn,
							afldo,							edd,						drcho,
							cdgo_usro,						cnsctvo_cdgo_estdo_afldo,	cnsctvo_cdgo_ofcna,
							cnsctvo_cdgo_tpo_idntfccn,		cnsctvo_cdgo_pln,			cnsctvo_cdgo_sxo,
							cnsctvo_cdgo_prntscs,			cnsctvo_cdgo_rngo_slrl,		cnsctvo_cdgo_tpo_undd,
							cdgo_ips_prmra,					cnsctvo_cdgo_pln_pc,		cnsctvo_cdgo_tpo_cntrto,
							nmro_cntrto,					cnsctvo_bnfcro,				nmro_unco_idntfccn_afldo,
							obsrvcns)
				Select		a.nmro_vrfccn,					a.fcha_vldcn,				a.nmro_idntfccn,
							ltrim(rtrim(Isnull(a.prmr_aplldo,'')))+' '+ltrim(rtrim(Isnull(a.sgndo_aplldo,'')))+' '+ltrim(rtrim(Isnull(a.prmr_nmbre,'')))+' '+ltrim(rtrim(Isnull(a.sgndo_nmbre,''))) as afldo,
							a.edd,							a.drcho,
							a.cdgo_usro,					a.cnsctvo_cdgo_estdo_afldo,	a.cnsctvo_cdgo_ofcna,
							a.cnsctvo_cdgo_tpo_idntfccn,	a.cnsctvo_cdgo_pln,			a.cnsctvo_cdgo_sxo,
							a.cnsctvo_cdgo_prntscs,			a.cnsctvo_cdgo_rngo_slrl,	a.cnsctvo_cdgo_tpo_undd,
							a.cdgo_ips_prmra,				a.cnsctvo_cdgo_pln_pc,		a.cnsctvo_cdgo_tpo_cntrto,
							a.nmro_cntrto,					a.cnsctvo_bnfcro,			a.nmro_unco_idntfccn_afldo,
							a.obsrvcns
				From		bdSiSalud.dbo.tblog_cuentas a	
				Where		a.nmro_vrfccn			= @NumeroVerificacion 
				And  		a.cnsctvo_cdgo_ofcna	= @lcCodigoOficinaReal
			End
	End

If @lnTipoConsulta = 2   -- Cuando se realiza una consulta por Fechas
	Begin

		-- Consulta en TbLog

		Insert	
		Into	@tmpValidaciones(
					nmro_vrfccn,					fcha_vldcn,					nmro_idntfccn,
					afldo,							edd,						drcho,
					cdgo_usro,						cnsctvo_cdgo_estdo_afldo,	cnsctvo_cdgo_ofcna,
					cnsctvo_cdgo_tpo_idntfccn,		cnsctvo_cdgo_pln,			cnsctvo_cdgo_sxo,
					cnsctvo_cdgo_prntscs,			cnsctvo_cdgo_rngo_slrl,		cnsctvo_cdgo_tpo_undd,
					cdgo_ips_prmra,					cnsctvo_cdgo_pln_pc,		cnsctvo_cdgo_tpo_cntrto,
					nmro_cntrto,					cnsctvo_bnfcro,				nmro_unco_idntfccn_afldo,
					obsrvcns)
		Select		a.nmro_vrfccn,					a.fcha_vldcn,				a.nmro_idntfccn,
					ltrim(rtrim(Isnull(a.prmr_aplldo,'')))+' '+ltrim(rtrim(Isnull(a.sgndo_aplldo,'')))+' '+ltrim(rtrim(Isnull(a.prmr_nmbre,'')))+' '+ltrim(rtrim(Isnull(a.sgndo_nmbre,''))) as afldo,
					a.edd,							a.drcho,
					a.cdgo_usro,					a.cnsctvo_cdgo_estdo_afldo,	a.cnsctvo_cdgo_ofcna,
					a.cnsctvo_cdgo_tpo_idntfccn,	a.cnsctvo_cdgo_pln,			a.cnsctvo_cdgo_sxo,
					a.cnsctvo_cdgo_prntscs,			a.cnsctvo_cdgo_rngo_slrl,	a.cnsctvo_cdgo_tpo_undd,
					a.cdgo_ips_prmra,				a.cnsctvo_cdgo_pln_pc,		a.cnsctvo_cdgo_tpo_cntrto,
					a.nmro_cntrto,					a.cnsctvo_bnfcro,			a.nmro_unco_idntfccn_afldo,
					a.obsrvcns
		From		bdSisalud.dbo.tbLog a
		Where		a.fcha_vldcn			>= @ldFechaDesde
		And			a.fcha_vldcn			<= @ldFechaHasta+1 
		And			(a.cnsctvo_cdgo_ofcna	= @lcCodigoOficinaReal	Or  @lcCodigoOficinaReal is Null)
		And			(a.cdgo_usro			= @lcUsuarioAutorizador Or	@lcUsuarioAutorizador Is null) 


		-- Consulta en TbLogCuentas

		Insert	
		Into	@tmpValidaciones(
					nmro_vrfccn,					fcha_vldcn,					nmro_idntfccn,
					afldo,							edd,						drcho,
					cdgo_usro,						cnsctvo_cdgo_estdo_afldo,	cnsctvo_cdgo_ofcna,
					cnsctvo_cdgo_tpo_idntfccn,		cnsctvo_cdgo_pln,			cnsctvo_cdgo_sxo,
					cnsctvo_cdgo_prntscs,			cnsctvo_cdgo_rngo_slrl,		cnsctvo_cdgo_tpo_undd,
					cdgo_ips_prmra,					cnsctvo_cdgo_pln_pc,		cnsctvo_cdgo_tpo_cntrto,
					nmro_cntrto,					cnsctvo_bnfcro,				nmro_unco_idntfccn_afldo,
					obsrvcns)
		Select		a.nmro_vrfccn,					a.fcha_vldcn,				a.nmro_idntfccn,
					ltrim(rtrim(Isnull(a.prmr_aplldo,'')))+' '+ltrim(rtrim(Isnull(a.sgndo_aplldo,'')))+' '+ltrim(rtrim(Isnull(a.prmr_nmbre,'')))+' '+ltrim(rtrim(Isnull(a.sgndo_nmbre,''))) as afldo,
					a.edd,							a.drcho,
					a.cdgo_usro,					a.cnsctvo_cdgo_estdo_afldo,	a.cnsctvo_cdgo_ofcna,
					a.cnsctvo_cdgo_tpo_idntfccn,	a.cnsctvo_cdgo_pln,			a.cnsctvo_cdgo_sxo,
					a.cnsctvo_cdgo_prntscs,			a.cnsctvo_cdgo_rngo_slrl,	a.cnsctvo_cdgo_tpo_undd,
					a.cdgo_ips_prmra,				a.cnsctvo_cdgo_pln_pc,		a.cnsctvo_cdgo_tpo_cntrto,
					a.nmro_cntrto,					a.cnsctvo_bnfcro,			a.nmro_unco_idntfccn_afldo,
					a.obsrvcns
		From		bdSiSalud.dbo.tblog_cuentas a
		Where		a.fcha_vldcn			>= @ldFechaDesde
		And			a.fcha_vldcn			<= @ldFechaHasta+1 
		And			(a.cnsctvo_cdgo_ofcna	= @lcCodigoOficinaReal	Or  @lcCodigoOficinaReal is Null)
		And			(a.cdgo_usro			= @lcUsuarioAutorizador Or	@lcUsuarioAutorizador Is null) 


	End

If @lnTipoConsulta = 3   -- Cuando se realiza una consulta por Tipo y Numero de Id. del Usuario
	Begin

		-- Consulta en tbLog

		Insert	
		Into	@tmpValidaciones(
					nmro_vrfccn,					fcha_vldcn,					nmro_idntfccn,
					afldo,							edd,						drcho,
					cdgo_usro,						cnsctvo_cdgo_estdo_afldo,	cnsctvo_cdgo_ofcna,
					cnsctvo_cdgo_tpo_idntfccn,		cnsctvo_cdgo_pln,			cnsctvo_cdgo_sxo,
					cnsctvo_cdgo_prntscs,			cnsctvo_cdgo_rngo_slrl,		cnsctvo_cdgo_tpo_undd,
					cdgo_ips_prmra,					cnsctvo_cdgo_pln_pc,		cnsctvo_cdgo_tpo_cntrto,
					nmro_cntrto,					cnsctvo_bnfcro,				nmro_unco_idntfccn_afldo,
					obsrvcns)
		Select		a.nmro_vrfccn,					a.fcha_vldcn,				a.nmro_idntfccn,
					ltrim(rtrim(Isnull(a.prmr_aplldo,'')))+' '+ltrim(rtrim(Isnull(a.sgndo_aplldo,'')))+' '+ltrim(rtrim(Isnull(a.prmr_nmbre,'')))+' '+ltrim(rtrim(Isnull(a.sgndo_nmbre,''))) as afldo,
					a.edd,							a.drcho,
					a.cdgo_usro,					a.cnsctvo_cdgo_estdo_afldo,	a.cnsctvo_cdgo_ofcna,
					a.cnsctvo_cdgo_tpo_idntfccn,	a.cnsctvo_cdgo_pln,			a.cnsctvo_cdgo_sxo,
					a.cnsctvo_cdgo_prntscs,			a.cnsctvo_cdgo_rngo_slrl,	a.cnsctvo_cdgo_tpo_undd,
					a.cdgo_ips_prmra,				a.cnsctvo_cdgo_pln_pc,		a.cnsctvo_cdgo_tpo_cntrto,
					a.nmro_cntrto,					a.cnsctvo_bnfcro,			a.nmro_unco_idntfccn_afldo,
					a.obsrvcns
		From		bdSisalud.dbo.tbLog a
		Where		a.cnsctvo_cdgo_tpo_idntfccn 		= @lnTipoId 
		And			a.nmro_idntfccn 					= @lnNumeroId

	-- Consulta en tbLogCuentas

		Insert	
		Into	@tmpValidaciones(
					nmro_vrfccn,					fcha_vldcn,					nmro_idntfccn,
					afldo,							edd,						drcho,
					cdgo_usro,						cnsctvo_cdgo_estdo_afldo,	cnsctvo_cdgo_ofcna,
					cnsctvo_cdgo_tpo_idntfccn,		cnsctvo_cdgo_pln,			cnsctvo_cdgo_sxo,
					cnsctvo_cdgo_prntscs,			cnsctvo_cdgo_rngo_slrl,		cnsctvo_cdgo_tpo_undd,
					cdgo_ips_prmra,					cnsctvo_cdgo_pln_pc,		cnsctvo_cdgo_tpo_cntrto,
					nmro_cntrto,					cnsctvo_bnfcro,				nmro_unco_idntfccn_afldo,
					obsrvcns)
		Select		a.nmro_vrfccn,					a.fcha_vldcn,				a.nmro_idntfccn,
					ltrim(rtrim(Isnull(a.prmr_aplldo,'')))+' '+ltrim(rtrim(Isnull(a.sgndo_aplldo,'')))+' '+ltrim(rtrim(Isnull(a.prmr_nmbre,'')))+' '+ltrim(rtrim(Isnull(a.sgndo_nmbre,''))) as afldo,
					a.edd,							a.drcho,
					a.cdgo_usro,					a.cnsctvo_cdgo_estdo_afldo,	a.cnsctvo_cdgo_ofcna,
					a.cnsctvo_cdgo_tpo_idntfccn,	a.cnsctvo_cdgo_pln,			a.cnsctvo_cdgo_sxo,
					a.cnsctvo_cdgo_prntscs,			a.cnsctvo_cdgo_rngo_slrl,	a.cnsctvo_cdgo_tpo_undd,
					a.cdgo_ips_prmra,				a.cnsctvo_cdgo_pln_pc,		a.cnsctvo_cdgo_tpo_cntrto,
					a.nmro_cntrto,					a.cnsctvo_bnfcro,			a.nmro_unco_idntfccn_afldo,
					a.obsrvcns
		From		bdSisalud.dbo.tblog_cuentas a
		Where		a.cnsctvo_cdgo_tpo_idntfccn 		= @lnTipoId 
		And			a.nmro_idntfccn 					= @lnNumeroId

	End



-- Actualiza Descripcion Motivo de Validacion

Update	@tmpValidaciones
Set		mtvo_vldcn					= b.dscrpcn_mtvo_ordn_espcl
From	@tmpValidaciones a, bdSisalud.dbo.tbInfAfiliadosEspeciales c, bdSiSalud.dbo.tbMotivoOrdenEspecial b 
Where	a.cnsctvo_cdgo_tpo_idntfccn	= c.cnsctvo_cdgo_tpo_idntfccn
And		a.nmro_idntfccn				= c.nmro_idntfccn
And		c.cnsctvo_cdgo_mtvo			= b.cnsctvo_cdgo_mtvo_ordn_espcl


-- Consulta para enviar al cliente

Select		a.nmro_vrfccn,							o.dscrpcn_ofcna,								a.fcha_vldcn,			
			i.cdgo_tpo_idntfccn as tpo_idntfccn,	a.nmro_idntfccn,								d.dscrpcn_pln, 		
			a.edd,									t.dscrpcn_tpo_undd,								s.cdgo_sxo as sexo,
			r.dscrpcn_rngo_slrl,					IsNull(f.nmbre_scrsl,'') as dscrpcn_ips,		e.dscrpcn_estdo_drcho,
			a.drcho,								b.dscrpcn_pln as dscrpcn_pln_cmplmntro,			p.dscrpcn_prntsco,
			a.cdgo_usro,							a.afldo,										a.cnsctvo_cdgo_ofcna,
			a.cnsctvo_cdgo_tpo_cntrto,				a.nmro_cntrto,									a.cnsctvo_bnfcro,	
			a.nmro_unco_idntfccn_afldo,				a.obsrvcns,										a.mtvo_vldcn
From		@tmpValidaciones a
Inner Join 	bdAfiliacionValidador.dbo.tbPlanes b					On	b.cnsctvo_cdgo_pln			= a.cnsctvo_cdgo_pln_pc
Inner Join	bdAfiliacionValidador.dbo.tbParentescos p				On	p.cnsctvo_cdgo_prntscs		= a.cnsctvo_cdgo_prntscs
Inner Join	bdAfiliacionValidador.dbo.tbEstadosDerechoValidador e	On	e.cnsctvo_cdgo_estdo_drcho	= a.cnsctvo_cdgo_estdo_afldo
Inner Join	bdAfiliacionValidador.dbo.tbRangosSalariales r			On	r.cnsctvo_cdgo_rngo_slrl	= a.cnsctvo_cdgo_rngo_slrl
Inner Join	bdAfiliacionValidador.dbo.tbSexos s						On  s.cnsctvo_cdgo_sxo			= a.cnsctvo_cdgo_sxo
Inner Join 	bdAfiliacionValidador.dbo.tbPlanes d					On	d.cnsctvo_cdgo_pln			= a.cnsctvo_cdgo_pln
Inner Join	bdAfiliacionValidador.dbo.tbOficinas o					On	o.cnsctvo_cdgo_ofcna		= a.cnsctvo_cdgo_ofcna	
Inner Join	bdAfiliacionValidador.dbo.tbTiposIdentificacion i		On	i.cnsctvo_cdgo_tpo_idntfccn	= a.cnsctvo_cdgo_tpo_idntfccn
Inner Join	bdAfiliacionValidador.dbo.tbTiposUnidades t				On	t.cnsctvo_cdgo_tpo_undd		= a.cnsctvo_cdgo_tpo_undd
Inner Join	bdSisalud.DBO.tbIpsPrimarias_Vigencias f				On	f.cdgo_intrno				= a.cdgo_ips_prmra
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaValidaciones] TO [900011 Consultor Administrador]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaValidaciones] TO [310010 Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaValidaciones] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaValidaciones] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaValidaciones] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaValidaciones] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaValidaciones] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaValidaciones] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaValidaciones] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaValidaciones] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaValidaciones] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaValidaciones] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaValidaciones] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaValidaciones] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaValidaciones] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

