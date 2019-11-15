/*---------------------------------------------------------------------------------
* Metodo o PRG			:  spInsertarYActualizarBeneficiariosCuentaManual
* Desarrollado por		: <\A Ing. Jean Paul Villaquiran Madrigal A\> 
* Descripcion			: <\D Permite realizar la gestion para la inserción y actualización de beneficiarios de un estado cuenta manual D\>
* Observaciones			: <\O O\>
* Parametros			: <\P P\>
* Variables				: <\VV\>
* Fecha Creacion		: <\FC 2019/05/02 FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM	AM\>
* Descripcion			: <\DM	DM\>
* Nuevos Parametros		: <\PM	PM\>
* Nuevas Variables		: <\VM	VM\>
* Fecha Modificacion	: <\FM FM\>
*--------------------------------------------------------------------------------- */
CREATE procedure dbo.spInsertarYActualizarBeneficiariosCuentaManual
(
	@numeroPeriodos int,
	@fechaCorte		datetime
)
as
begin
	set nocount on;

	Insert Into	#tmpBeneficiarios
	(
				nmro_unco_idntfccn_aprtnte,	
				cnsctvo_scrsl_ctznte,
				cnsctvo_cdgo_clse_aprtnte,	
				nmro_unco_idntfccn_afldo,
				cnsctvo_cdgo_tpo_cntrto,	
				nmro_cntrto,
				cnsctvo_bnfcro,		
				nmro_unco_idntfccn_bnfcro,
				inco_vgnca_bnfcro,		
				fn_vgnca_bnfcro,
				vlr_upc,			
				cnsctvo_cnta_mnls_cntrto,
				vlr_dcto_comercial,		
				vlr_otros_dcts,
				vlr_iva,			
				vlr_cta,
				vlr_ttl_bnfcro,		
				vlr_ttl_bnfcro_sn_iva,
				vlr_dcto_comercial_aux,	
				vlr_otros_dcts_aux,
				vlr_iva_aux,			
				Grupo_Conceptos,
				cnsctvo_cdgo_tpo_idntfccn,	
				numero_identificacion,
				primer_apellido,		
				segundo_apellido,
				primer_nombre,			
				segundo_nombre,
				Bnfcro_Dfrnte_cro
	)
	Select		a.nmro_unco_idntfccn_aprtnte,	
				a.cnsctvo_scrsl_ctznte,
				a.cnsctvo_cdgo_clse_aprtnte,	
				a.nmro_unco_idntfccn_afldo,
				a.cnsctvo_cdgo_tpo_cntrto,	
				a.nmro_cntrto,
				d.cnsctvo_bnfcro,		
				d.nmro_unco_idntfccn_bnfcro,
				d.inco_vgnca_bnfcro,		
				d.fn_vgnca_bnfcro,
				(e.vlr_upc * @numeroPeriodos),	
				0,
				0,				
				0,
				0,				
				(e.vlr_upc * @numeroPeriodos),
				0,				
				0,
				0,				
				0,
				0,				
				a.Grupo_Conceptos,
				0,				
				'',
				'',				
				'',
				'',				
				'',
				Case When	(IsNull(e.vlr_rl_pgo,0)	> 0) Then 1 Else 0 End Bnfcro_Dfrnte_cro
		From		#Tmpcontratos								a 
		Inner Join	bdafiliacion.dbo.tbbeneficiarios			d With(NoLock)
			On		a.cnsctvo_cdgo_tpo_cntrto	= d.cnsctvo_cdgo_tpo_cntrto
			And		a.nmro_cntrto				= d.nmro_cntrto 
		Inner Join	bdafiliacion.dbo.tbdetbeneficiarioAdicional e With(NoLock)
			On		d.cnsctvo_cdgo_tpo_cntrto	= e.cnsctvo_cdgo_tpo_cntrto
			And		d.nmro_cntrto				= e.nmro_cntrto
			And		d.cnsctvo_bnfcro			= e.cnsctvo_bnfcro
			And		a.nmro_cntrto				= e.nmro_cntrto
			And		a.cnsctvo_cdgo_tpo_cntrto	= e.cnsctvo_cdgo_tpo_cntrto
			And		a.cnsctvo_cbrnza			= e.cnsctvo_cbrnza
			And		Datediff(Day,e.inco_vgnca,@fechaCorte) >= 0
			And		Datediff(Day,@fechaCorte,e.fn_vgnca) >= 0 -- que sea el siguiente del periodo a evaluar
			And		e.estdo_rgstro			= 'S'

		update		cal
		set			cal.vlr_upc = tp.cta_mnsl, 
					cal.vlr_cta = tp.cta_mnsl
		from		#tmpBeneficiarios					cal 
		inner join	#tmpHistoricoTarifasBeneficiarioPAC tp
			on		cal.nmro_cntrto = tp.nmro_cntrto
			and		cal.cnsctvo_cdgo_tpo_cntrto = tp.cnsctvo_cdgo_tpo_cntrto
			and		cal.nmro_unco_idntfccn_bnfcro = tp.nmro_unco_idntfccn
			and		cal.cnsctvo_bnfcro = tp.cnsctvo_bnfcro
		where		cal.vlr_upc <> tp.cta_mnsl

		--Se crea un tabla donde se van a guardar todos los contratos
		--actualiza los contratos que tienen beneficiarios

		Update		#Tmpcontratos
		Set			Activo	=	1
		From		#Tmpcontratos		a 
		Inner Join	#tmpBeneficiarios	b
			On		a.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
			And		a.nmro_cntrto				= b.nmro_cntrto

		--se quitan todos los contratos que no estan en la tabla tbdetbeneficiariosadicionales puesto que no encontraria valor a nivel de beneficiario
		Delete	#Tmpcontratos
		Where	Activo	= 0

		Insert	Into #tmpBeneficiarioValorCero
		(
			 nmro_unco_idntfccn_aprtnte,		
			 cnsctvo_scrsl_ctznte,
			 cnsctvo_cdgo_clse_aprtnte,		
			 cnsctvo_cdgo_tpo_cntrto,
			 nmro_cntrto
		)
		Select		nmro_unco_idntfccn_aprtnte,		
					cnsctvo_scrsl_ctznte,
					cnsctvo_cdgo_clse_aprtnte,		
					cnsctvo_cdgo_tpo_cntrto,
					nmro_cntrto
		From		#tmpBeneficiarios
		Where		Bnfcro_Dfrnte_cro	=	0
		Group by	nmro_unco_idntfccn_aprtnte,	cnsctvo_scrsl_ctznte, cnsctvo_cdgo_clse_aprtnte, cnsctvo_cdgo_tpo_cntrto,nmro_cntrto

		--Se actualiza aquellos registros que tienen al menos un beneficiario en cero  porque le sistema que tarifica obligatoriamente debe tener un valor

		Update		#Tmpcontratos
		Set			Cntrto_igual_cro = 1
		From		#Tmpcontratos				a 
		Inner Join	#tmpBeneficiarioValorCero	b
			On		a.cnsctvo_cdgo_tpo_cntrto	 = b.cnsctvo_cdgo_tpo_cntrto
			And		a.nmro_cntrto				 = b.nmro_cntrto
			And		a.cnsctvo_cdgo_clse_aprtnte	 = b.cnsctvo_cdgo_clse_aprtnte
			And		a.cnsctvo_scrsl_ctznte		 = b.cnsctvo_scrsl_ctznte
			And		a.nmro_unco_idntfccn_aprtnte = b.nmro_unco_idntfccn_aprtnte

		Update		#tmpBeneficiarios
		Set			Bnfcro_Dfrnte_cro	= 0
		From		#tmpBeneficiarios			a 
		Inner Join  #tmpBeneficiarioValorCero	b
			On		a.cnsctvo_cdgo_tpo_cntrto	 = b.cnsctvo_cdgo_tpo_cntrto
			And		a.nmro_cntrto				 = b.nmro_cntrto
			And		a.cnsctvo_cdgo_clse_aprtnte	 = b.cnsctvo_cdgo_clse_aprtnte
			And		a.cnsctvo_scrsl_ctznte		 = b.cnsctvo_scrsl_ctznte
			And		a.nmro_unco_idntfccn_aprtnte = b.nmro_unco_idntfccn_aprtnte

		Insert Into #TmpContratosValorCuotaCero
		(
			 cnsctvo_cdgo_tpo_cntrto,	
			 nmro_cntrto,
			 Causa,				
			 nmro_unco_idntfccn_aprtnte,
			 cnsctvo_scrsl_ctznte,		
			 cnsctvo_cdgo_clse_aprtnte
		)
		Select	a.cnsctvo_cdgo_tpo_cntrto,	
				a.nmro_cntrto,
				'BENEFICIARIO IGUAL A CERO',	
				a.nmro_unco_idntfccn_aprtnte,
				a.cnsctvo_scrsl_ctznte, 	
				a.cnsctvo_cdgo_clse_aprtnte
		From	#Tmpcontratos a
		Where	Cntrto_igual_cro	= 1

		Delete	#Tmpcontratos
		Where	Cntrto_igual_cro	= 1

		Delete	#tmpBeneficiarios
		Where	Bnfcro_Dfrnte_cro	= 0
end