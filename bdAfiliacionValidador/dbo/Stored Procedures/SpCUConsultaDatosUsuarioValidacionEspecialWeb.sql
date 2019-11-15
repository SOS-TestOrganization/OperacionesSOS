



/*---------------------------------------------------------------------------------
* Metodo o PRG 	             	 :   SpCUConsultaDatosUsuarioValidacionEspecialWeb
TEMPORAL PARA PRUEBAS
* Desarrollado por		 :  <\A   Nilson Mossos	Vivas					A\>
* Descripcion			 :  <\D   							D\>
* Descripcion			 :  <\D  								D\>
* Observaciones		              :  <\O								O\>
* Parametros			 :  <\P    Tipo de identificacion					P\>
				 :  <\P  	Numero de identificacion				              P\>
                                                      :  <\P   								P\>
* Variables			 :  <\V								V\>
* Fecha Creacion		 :  <\FC 2003/12/16	 		          			 FC\>
*  
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------  
* Modificado Por		              : <\AM   AM\>
* Descripcion			 : <\DM   DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM   FM\>
*---------------------------------------------------------------------------------*/
CREATE procedure  SpCUConsultaDatosUsuarioValidacionEspecialWeb
@lnTpIdUsuario		udtConsecutivo,
@lcNumIdUsuario 	udtNumeroIdentificacionLargo,
@origen 		char(1)	= NULL
As
Set Nocount On

Declare
@nuiUsuario		udtConsecutivo,
@dFechaMaxima		datetime,
@lnCodigoTipoFormulario	udtConsecutivo,
@lcNumeroFormulario	udtNumeroFormulario

Create	Table #tmpDatosUsuaro(
	prmr_aplldo			udtApellido,
	sgndo_aplldo			udtApellido,
	prmr_nmbre			udtNombre,
	sgndo_nmbre			udtNombre,
	fcha_ncmnto			datetime,
	cnsctvo_cdgo_sxo		udtConsecutivo,
	cnsctvo_cdgo_prntsco		udtConsecutivo,
	cnsctvo_cdgo_cdd_rsdnca		udtConsecutivo,
	cdgo_cdd			char(8),
	cnsctvo_cdgo_pln		udtConsecutivo,
	inco_vgnca			datetime,
	fn_vgnca			datetime,
	cnsctvo_cdgo_tpo_dcmnto		udtConsecutivo,		--Contrato o Formulario
	nmro_dcmnto			udtNumeroFormulario,	--Contrato o Formulario
	cnsctvo_cdgo_rngo_slrl		udtConsecutivo,
	cdgo_rngo_slrl			udtCodigo,
	cnsctvo_cdgo_tpo_afldo		udtConsecutivo,
	cdgo_tpo_afldo			udtCodigo,
	smns_ctzds			int,
	cnsctvo_cdgo_ips		char(8),
	cnctvo_cdgo_afp			udtConsecutivo,
	cdgo_entdd_afp			char(6),
	cnsctvo_cdgo_sde		udtConsecutivo,
	cdgo_sde			udtSede,
	nmro_unco_idntfccn_ctznte	udtConsecutivo,
	cnsctvo_cdgo_tpo_idntfccn_ctznte	udtConsecutivo,
	nmro_idntfccn_ctznte			udtNumeroIdentificacionLargo,
	prmr_aplldo_ctznte			udtApellido,
	sgndo_aplldo_ctznte			udtApellido,
	prmr_nmbre_ctznte			udtNombre,
	sgndo_nmbre_ctznte			udtNombre,
	cdgo_tpo_idntfccn_ctznte		udtTipoIdentificacion,
	nmro_unco_idntfccn_aprtnte		udtConsecutivo,
	cnsctvo_cdgo_tpo_idntfccn_aprtnte	udtConsecutivo,
	nmro_idntfccn_aprtnte			udtNumeroIdentificacionLargo,
	dgto_vrfccn_aprtnte			int,
	cnsctvo_cdgo_clse_aprtnte		udtConsecutivo,
	rzn_scl_aprtnte				varchar(200),
	cnsctvo_cdgo_actvdd_ecnmca		udtConsecutivo,
	cdgo_actvdd_ecnmca			char(4),
	cnsctvo_cdgo_arp			udtConsecutivo,
	cdgo_arp				char(6),
	cnsctvo_cdgo_cdd			udtConsecutivo,
	cdgo_cdd_aprtnte			char(8),
	cnsctvo_cdgo_crgo			udtConsecutivo,
	cdgo_crgo				char(4),
	cnsctvo_cdgo_tpo_ctznte			udtConsecutivo,
	cdgo_tpo_ctznte				udtCodigo,
	cdgo_tpo_prntsco			udtCodigo,
	cdgo_sxo				udtCodigo,	
	cdgo_tpo_idntfccn_aprtnte		udtCodigo	

	)



--If @nuiUsuario Is Not Null
If @origen = '1'	--Contratos
Begin

	Set	@dFechaMaxima = NULL
	Select	@dFechaMaxima	= Max(fn_vgnca_bnfcro)
	From	tbBeneficiariosValidador
	Where	cnsctvo_cdgo_tpo_idntfccn	= @lnTpIdUsuario
	And	nmro_idntfccn			= @lcNumIdUsuario

	Insert Into #tmpDatosUsuaro(
		cnsctvo_cdgo_tpo_dcmnto,	nmro_dcmnto,
		cnsctvo_cdgo_prntsco,		cnsctvo_cdgo_pln,
		prmr_aplldo,	sgndo_aplldo,	prmr_nmbre,
		sgndo_nmbre,	fcha_ncmnto,	cnsctvo_cdgo_sxo,
		cnsctvo_cdgo_cdd_rsdnca,	cnsctvo_cdgo_rngo_slrl,
		inco_vgnca,	fn_vgnca,	cnsctvo_cdgo_tpo_afldo,
		nmro_unco_idntfccn_ctznte,	cnsctvo_cdgo_tpo_idntfccn_ctznte,
		nmro_idntfccn_ctznte,		prmr_aplldo_ctznte,
		sgndo_aplldo_ctznte,		prmr_nmbre_ctznte,
		sgndo_nmbre_ctznte,		smns_ctzds,
		cnctvo_cdgo_afp,		cnsctvo_cdgo_ips
	)
	Select	b.cnsctvo_cdgo_tpo_cntrto,	b.nmro_cntrto,
		b.cnsctvo_cdgo_prntsco,		c.cnsctvo_cdgo_pln,
		b.prmr_aplldo,	b.sgndo_aplldo,	b.prmr_nmbre,
		b.sgndo_nmbre,	b.fcha_ncmnto,	b.cnsctvo_cdgo_sxo,
		b.cnsctvo_cdgo_cdd_rsdnca,	c.cnsctvo_cdgo_rngo_slrl,
		b.inco_vgnca_bnfcro,	b.fn_vgnca_bnfcro,	b.cnsctvo_cdgo_tpo_afldo,
		c.nmro_unco_idntfccn_afldo,	c.cnsctvo_cdgo_tpo_idntfccn,
		c.nmro_idntfccn,		c.prmr_aplldo,
		c.sgndo_aplldo,			c.prmr_nmbre,
		c.sgndo_nmbre,			b.smns_ctzds,
		c.cnsctvo_cdgo_afp,		b.cdgo_intrno
	From	tbBeneficiariosValidador b Inner Join tbContratosValidador c On
		b.cnsctvo_cdgo_tpo_cntrto	= c.cnsctvo_cdgo_tpo_cntrto
	And	b.nmro_cntrto			= c.nmro_cntrto
	Where	b.cnsctvo_cdgo_tpo_idntfccn	= @lnTpIdUsuario
	And	b.nmro_idntfccn			= @lcNumIdUsuario
	And	b.fn_vgnca_bnfcro		= @dFechaMaxima

	Update	#tmpDatosUsuaro
	Set	nmro_unco_idntfccn_aprtnte	= c.nmro_unco_idntfccn_aprtnte,
		cnsctvo_cdgo_clse_aprtnte	= c.cnsctvo_cdgo_clse_aprtnte,
		cnsctvo_cdgo_crgo		= c.cnsctvo_cdgo_crgo_empldo,
		cnsctvo_cdgo_tpo_ctznte		= c.cnsctvo_cdgo_tpo_ctznte
	From	#tmpDatosUsuaro d Inner Join tbCobranzasValidador c On
		d.cnsctvo_cdgo_tpo_dcmnto	= c.cnsctvo_cdgo_tpo_cntrto
	And	d.nmro_dcmnto			= c.nmro_cntrto
	Where	c.estdo				= 'S'
	And	getdate() Between c.inco_vgnca_cbrnza And c.fn_vgnca_cbrnza

	Update	#tmpDatosUsuaro
	Set	cnsctvo_cdgo_tpo_idntfccn_aprtnte	= a.cnsctvo_cdgo_tpo_idntfccn_empldr,
		nmro_idntfccn_aprtnte			= a.nmro_idntfccn_empldr,
		dgto_vrfccn_aprtnte			= bdSISalud.dbo.fnCalcularDigitoVerificacion(a.nmro_idntfccn_empldr),
		rzn_scl_aprtnte				= a.rzn_scl,
		cnsctvo_cdgo_actvdd_ecnmca		= a.cnsctvo_cdgo_actvdd_ecnmca
	From	tbAportanteValidador a Inner Join #tmpDatosUsuaro t On
		a.nmro_unco_idntfccn_aprtnte	= t.nmro_unco_idntfccn_aprtnte
	And	a.cnsctvo_cdgo_clse_aprtnte	= t.cnsctvo_cdgo_clse_aprtnte
/*
Select	*
From	tbBeneficiariosValidador
--From	tbContratosValidador
--From	tbAportanteValidador
--From	tbCobranzasValidador

	Update	#tmpDatosUsuaro
	Set	cnsctvo_cdgo_arp		= s.cnsctvo_cdgo_arp,
		cnsctvo_cdgo_cdd		= s.cnsctvo_cdgo_cdd
	From	bdConsulta..tbSucursalesAportante s, #tmpDatosUsuaro t
	Where	s.nmro_unco_idntfccn_empldr	= t.nmro_unco_idntfccn_aprtnte
	And	s.cnsctvo_cdgo_clse_aprtnte	= t.cnsctvo_cdgo_clse_aprtnte
--	And	s.cnsctvo_scrsl
	And	s.prncpl	= 'S'

	Update	#tmpDatosUsuaro
	Set	cdgo_entdd_afp = e.cdgo_entdd
	from	tbEntidades e, #tmpDatosUsuaro t
	Where	e.cnsctvo_cdgo_entdd = t.cnctvo_cdgo_afp
*/
End
Else
Begin
	Set	@dFechaMaxima = NULL
	Select	@dFechaMaxima = Max(isNull(fcha_dsde,'9999/12/31'))
	From	tbbeneficiariosFormularioValidador
	Where	cnsctvo_tpo_idntfccn_bnfcro	= @lnTpIdUsuario
	And	nmro_idntfccn_bnfcro		= @lcNumIdUsuario

	
	Set	@lcNumeroFormulario = NULL
	If @dFechaMaxima is Not Null 
	Begin
		Insert Into #tmpDatosUsuaro(
			prmr_aplldo,		sgndo_aplldo,		prmr_nmbre,
			sgndo_nmbre,		fcha_ncmnto,		cnsctvo_cdgo_sxo,
			cnsctvo_cdgo_prntsco,	cnsctvo_cdgo_cdd_rsdnca,cnsctvo_cdgo_pln,
			inco_vgnca,		fn_vgnca,		cnsctvo_cdgo_tpo_dcmnto,
			nmro_dcmnto,		cnsctvo_cdgo_rngo_slrl,	--cnsctvo_cdgo_sde,
			cnsctvo_cdgo_tpo_ctznte, cnsctvo_cdgo_ips,
			cnsctvo_cdgo_tpo_idntfccn_ctznte,	nmro_idntfccn_ctznte,
			prmr_nmbre_ctznte,	sgndo_nmbre_ctznte,	prmr_aplldo_ctznte,
			sgndo_aplldo_ctznte,
			cnsctvo_cdgo_tpo_idntfccn_aprtnte,	nmro_idntfccn_aprtnte,
			cnsctvo_cdgo_clse_aprtnte,
			nmro_unco_idntfccn_aprtnte,	dgto_vrfccn_aprtnte,	rzn_scl_aprtnte
		)
		Select	prmr_aplldo,		sgndo_aplldo,			prmr_nmbre,
			sgndo_nmbre,		fcha_ncmnto,			cnsctvo_cdgo_sxo,
			cnsctvo_cdgo_prntsco,	cnsctvo_cdgo_cdd_rsdnca,	cnsctvo_cdgo_pln,
			inco_vgnca_bnfcro,	fn_vgnca_bnfcro,		cnsctvo_cdgo_tpo_frmlro,
			nmro_frmlro,		rngo_slrl,			--cnsctvo_cdgo_sde,
			cnsctvo_cdgo_tpo_ctznte,cnsctvo_cdgo_ips,
			cnsctvo_tpo_idntfccn_ctznte,		nmro_idntfccn_ctznte,
			prmr_nmbre_ctznte,	sgndo_nmbre_ctznte,	prmr_aplldo_ctznte,
			sgndo_aplldo_ctznte,	
			cnsctvo_cdgo_tpo_idntfccn_aprtnte,	nmro_idntfccn_aprtnte,
			cnsctvo_cdgo_clse_aprtnte,
			nmro_unco_idntfccn_aprtnte,bdSISalud.dbo.fnCalcularDigitoVerificacion(nmro_idntfccn_aprtnte),rzn_scl
		From	tbbeneficiariosFormularioValidador b
		Where	cnsctvo_tpo_idntfccn_bnfcro		= @lnTpIdUsuario
		And	nmro_idntfccn_bnfcro			= @lcNumIdUsuario
		And	isNull(fcha_dsde,'9999/12/31')		= @dFechaMaxima

/*		Update	#tmpDatosUsuaro
		Set			= a.cnsctvo_cdgo_actvdd_ecnmca,
			cnsctvo_cdgo_arp			= a.cnsctvo_cdgo_arp,
			cnsctvo_cdgo_cdd			= a.cnsctvo_cdgo_cdd,
			cnsctvo_cdgo_crgo			= a.cnsctvo_cdgo_crgo
		From	bdConsulta..tbaportantesformulario a, #tmpDatosUsuaro t
		Where	a.cnsctvo_cdgo_tpo_frmlro	= t.cnsctvo_cdgo_tpo_dcmnto
		And	a.nmro_frmlro			= t.nmro_dcmnto
*/
		Update	#tmpDatosUsuaro
		Set	cnsctvo_cdgo_actvdd_ecnmca = a.cnsctvo_cdgo_actvdd_ecnmca
		From	tbAportanteValidador a Inner Join #tmpDatosUsuaro t On
			a.nmro_unco_idntfccn_aprtnte	= t.nmro_unco_idntfccn_aprtnte
		And	a.cnsctvo_cdgo_clse_aprtnte	= t.cnsctvo_cdgo_clse_aprtnte

	End
End

If Exists(Select 1 From #tmpDatosUsuaro)
Begin
	Update	#tmpDatosUsuaro
	Set	cdgo_cdd = c.cdgo_cdd
	From	tbCiudades c Inner Join #tmpDatosUsuaro d On
		c.cnsctvo_cdgo_cdd = d.cnsctvo_cdgo_cdd_rsdnca
	Where	c.vsble_Usro			= 'S'	
	
	Update	#tmpDatosUsuaro
	Set	cdgo_rngo_slrl = r.cdgo_rngo_slrl
	From	tbRangosSalariales r Inner Join #tmpDatosUsuaro t On
		r.cnsctvo_cdgo_rngo_slrl	= t.cnsctvo_cdgo_rngo_slrl
	Where	r.vsble_usro			= 'S'
	
	Update	#tmpDatosUsuaro
	Set	cdgo_tpo_afldo = ta.cdgo_tpo_afldo
	from	tbTiposAfiliado ta Inner Join #tmpDatosUsuaro t On
		ta.cnsctvo_cdgo_tpo_afldo = t.cnsctvo_cdgo_tpo_afldo
	Where	ta.vsble_Usro			= 'S'	
	
/*	Update	#tmpDatosUsuaro
	Set	cdgo_sde = s.cdgo_sde
	From	tbSedes s,#tmpDatosUsuaro t
	Where	s.cnsctvo_cdgo_sde = t.cnsctvo_cdgo_sde
	And	s.vsble_Usro			= 'S'	
*/	
	
	Update	#tmpDatosUsuaro
	Set	cdgo_tpo_idntfccn_ctznte = ti.cdgo_tpo_idntfccn
	From	tbTiposIdentificacion ti Inner Join #tmpDatosUsuaro t On
		ti.cnsctvo_cdgo_tpo_idntfccn = t.cnsctvo_cdgo_tpo_idntfccn_ctznte
	Where	ti.vsble_Usro			= 'S'	
	
	
	Update	#tmpDatosUsuaro
	Set	cdgo_actvdd_ecnmca = a.cdgo_actvdd_ecnmca
	From	tbActividadesEconomicas a Inner Join #tmpDatosUsuaro t On
		a.cnsctvo_cdgo_actvdd_ecnmca	= t.cnsctvo_cdgo_actvdd_ecnmca
	Where	a.vsble_Usro			= 'S'
	
	Update	#tmpDatosUsuaro
	Set	cdgo_arp	= e.cdgo_entdd
	From	tbEntidades e Inner Join #tmpDatosUsuaro t On
		e.cnsctvo_cdgo_entdd	= t.cnsctvo_cdgo_arp
	Where	e.vsble_Usro			= 'S'	
	
	Update	#tmpDatosUsuaro
	Set	cdgo_cdd_aprtnte	= c.cdgo_cdd
	From	tbCiudades c Inner Join #tmpDatosUsuaro t On
		c.cnsctvo_cdgo_cdd	= t.cnsctvo_cdgo_cdd
	Where	c.vsble_Usro			= 'S'	
	
	
	Update	#tmpDatosUsuaro
	Set	cdgo_tpo_ctznte	= tc.cdgo_tpo_ctznte
	From	tbTiposCotizante tc Inner Join #tmpDatosUsuaro t On
		tc.cnsctvo_cdgo_tpo_ctznte	= t.cnsctvo_cdgo_tpo_ctznte
	Where	tc.vsble_Usro			= 'S'	
	
	Update	#tmpDatosUsuaro
	Set	cdgo_tpo_prntsco	= tc.cdgo_prntscs
	From	tbParentescos tc Inner Join #tmpDatosUsuaro t On
		tc.cnsctvo_cdgo_prntscs	= t.cnsctvo_cdgo_prntsco
	Where	tc.vsble_Usro			= 'S'	

	Update	#tmpDatosUsuaro
	Set	cdgo_sxo	= tc.cdgo_sxo
	From	tbSexos tc Inner Join #tmpDatosUsuaro t On
		tc.cnsctvo_cdgo_sxo	= t.cnsctvo_cdgo_sxo
	Where	tc.vsble_Usro			= 'S'	

	Update	#tmpDatosUsuaro
	Set	cdgo_tpo_idntfccn_aprtnte = ti.cdgo_tpo_idntfccn
	From	tbTiposIdentificacion ti Inner Join #tmpDatosUsuaro t On
		ti.cnsctvo_cdgo_tpo_idntfccn = t.cnsctvo_cdgo_tpo_idntfccn_aprtnte
	Where	ti.vsble_Usro			= 'S'	

	Update	#tmpDatosUsuaro
	Set	cdgo_crgo	= c.cdgo_crgo
	From	tbCargos c Inner Join #tmpDatosUsuaro t On
		c.cnsctvo_cdgo_crgo	= t.cnsctvo_cdgo_crgo
	Where	c.vsble_Usro			= 'S'	
End

Select * From #tmpDatosUsuaro
Drop Table #tmpDatosUsuaro








GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaDatosUsuarioValidacionEspecialWeb] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaDatosUsuarioValidacionEspecialWeb] TO [Consultor Servicio al Cliente]
    AS [dbo];

