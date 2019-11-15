CREATE PROCEDURE SpTraerBeneficiariosCuentasManualesMayorPeriodo 
		@ldFechaInicialFacturacion	Datetime,
		@ldFechaFinalFacturacion	Datetime,
		@ldFechaLimitePago		Datetime
		
 
AS    Declare
@ldFechaSistema			Datetime,
@nmro_prds				int



 
Set Nocount On
Set	@ldFechaSistema	=	Getdate()


--se calcula el numero de meses a facturar
Select 	 @nmro_prds		=	DATEDIFF(month, @ldFechaInicialFacturacion, @ldFechaFinalFacturacion) + 1
 
   
If 	@nmro_prds	>	1
	Begin
		-- se traen todos los contratos qe se van a liquidar con los contratos del cliente que tengan la periodicidad mayor a uno
			select  	 a.cnsctvo_cdgo_tpo_cntrto,	a.nmro_cntrto,	a.cnsctvo_cdgo_pln,	a.inco_vgnca_cntrto,	a.fn_vgnca_cntrto,
				a.nmro_unco_idntfccn_afldo,
				b.cnsctvo_cbrnza,		b.nmro_unco_idntfccn_aprtnte,
				c.cnsctvo_vgnca_cbrnza,		c.cnsctvo_scrsl_ctznte,			c.inco_vgnca_cbrnza,	c.fn_vgnca_cbrnza,
				c.cta_mnsl,			b.cnsctvo_cdgo_prdcdd_prpgo,
				'0'				nmro_estdo_cnta,
				cnsctvo_cdgo_clse_aprtnte,
				convert(numeric(12,0),0)	 	vlr_ttl_cntrto,
				convert(numeric(12,0),0)	 	vlr_ttl_cntrto_sn_iva,
				0				cntdd_ttl_bnfcrs,
				1 	as  	Grupo_Conceptos   -- por defecto  se toma el concepto generico
			into   	#Tmpcontratos_Antes_liquidar_Mayor_Periodicidad
			From 	bdafiliacion..tbcontratos a,		bdafiliacion..tbcobranzas b ,	bdafiliacion..tbVigenciasCobranzas c,	#tmpContratosSeleccionados d
			Where   a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto
			And 	a.nmro_cntrto		  = b.nmro_cntrto
			And	c.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto
			And	c.nmro_cntrto		  = b.nmro_cntrto
			And	c.cnsctvo_cbrnza	  = b.cnsctvo_cbrnza
			And	a.cnsctvo_cdgo_tpo_cntrto = d.cnsctvo_cdgo_tpo_cntrto
			And 	a.nmro_cntrto		   = d.nmro_cntrto
			And	@ldFechaLimitePago	  between  a.inco_vgnca_cntrto	  and 	 a.fn_vgnca_cntrto			
			And	@ldFechaLimitePago 	 between  c.inco_vgnca_cbrnza 	  and	 c.fn_vgnca_cbrnza
			And	a.cnsctvo_cdgo_tpo_cntrto 		=	2	--Contratos de planes complementarios
			And	c.cta_mnsl				>	0



		-- se crea la tabla temporal que va contener los contratos que se van a liquidar
		Select  	cnsctvo_cdgo_tpo_cntrto,		nmro_cntrto,	cnsctvo_cdgo_pln,	inco_vgnca_cntrto,	fn_vgnca_cntrto,
			nmro_unco_idntfccn_afldo,
			cnsctvo_cbrnza,			nmro_unco_idntfccn_aprtnte,
			cnsctvo_vgnca_cbrnza,		cnsctvo_scrsl_ctznte,		inco_vgnca_cbrnza,	fn_vgnca_cbrnza,
			cta_mnsl,			cnsctvo_cdgo_prdcdd_prpgo,
			'0'				nmro_estdo_cnta,
			cnsctvo_cdgo_clse_aprtnte,
			convert(numeric(12,0),0)	 	vlr_ttl_cntrto,
			convert(numeric(12,0),0)	 	vlr_ttl_cntrto_sn_iva,
			0				cntdd_ttl_bnfcrs,
			1 			as  	Grupo_Conceptos   -- por defecto  se toma el concepto generico
		into   	#Tmpcontratos_Mayor_Periodicidad
		From 	#Tmpcontratos_Antes_liquidar_Mayor_Periodicidad
		Where   	1	=	2



		-- se insertan todos los registros que tiene la tabla temporal #Tmpcontratos_Antes_liquidar
		Insert into #Tmpcontratos_Mayor_Periodicidad
		select  	 a.cnsctvo_cdgo_tpo_cntrto,	a.nmro_cntrto,	a.cnsctvo_cdgo_pln,	a.inco_vgnca_cntrto,	a.fn_vgnca_cntrto,
			 a.nmro_unco_idntfccn_afldo,
			a.cnsctvo_cbrnza,		a.nmro_unco_idntfccn_aprtnte,
			a.cnsctvo_vgnca_cbrnza,	a.cnsctvo_scrsl_ctznte,			a.inco_vgnca_cbrnza,	a.fn_vgnca_cbrnza,
			a.cta_mnsl,			a.cnsctvo_cdgo_prdcdd_prpgo,
			'0'				nmro_estdo_cnta,
			cnsctvo_cdgo_clse_aprtnte,
			convert(numeric(12,0),0)	 	vlr_ttl_cntrto,
			convert(numeric(12,0),0)	 	vlr_ttl_cntrto_sn_iva,
			0				cntdd_ttl_bnfcrs,
			1 	as  	Grupo_Conceptos   -- por defecto  se toma el concepto generico
		From 	#Tmpcontratos_Antes_liquidar_Mayor_Periodicidad	 a



	-- se traen todos los beneficiarios que se van aliquidar con periodicidad mayoe a uno

		select  	a.nmro_unco_idntfccn_aprtnte,  		a.cnsctvo_scrsl_ctznte, 		a.cnsctvo_cdgo_clse_aprtnte , 			a.nmro_unco_idntfccn_afldo,
			a.cnsctvo_cdgo_tpo_cntrto, 		a.nmro_cntrto, 
			d.cnsctvo_bnfcro, 			d.nmro_unco_idntfccn_bnfcro, 	d.inco_vgnca_bnfcro,	d.fn_vgnca_bnfcro,	e.vlr_upc,
			0					cnsctvo_cnta_mnls_cntrto,
			convert(numeric(12,0),0)	 vlr_dcto_comercial, 	convert(numeric(12,0),0)	 vlr_otros_dcts, 	convert(numeric(12,0),0)	 vlr_iva , 
			e.vlr_upc  	vlr_cta,
			convert(numeric(12,0),0)	 vlr_ttl_bnfcro,
			convert(numeric(12,0),0)	 vlr_ttl_bnfcro_sn_iva,
			convert(numeric(12,0),0)	 vlr_dcto_comercial_aux, 	convert(numeric(12,0),0)	 vlr_otros_dcts_aux, 	convert(numeric(12,0),0)	 vlr_iva_aux,
			a.Grupo_Conceptos,
			0		cnsctvo_cdgo_tpo_idntfccn,
			space(23)	numero_identificacion ,
			space(50)	primer_apellido ,
			space(50)	segundo_apellido ,
			space(50)	primer_nombre ,
			space(50)	segundo_nombre,
			e.vlr_rl_pgo,
			@nmro_prds	nmro_prds 
		From 	#Tmpcontratos_Mayor_Periodicidad  a,  bdafiliacion..tbbeneficiarios  d,  bdafiliacion..tbdetbeneficiarioAdicional e
		Where   a.cnsctvo_cdgo_tpo_cntrto	=	d.cnsctvo_cdgo_tpo_cntrto
		And	a.nmro_cntrto			=	d.nmro_cntrto
		And	d.cnsctvo_cdgo_tpo_cntrto	=	e.cnsctvo_cdgo_tpo_cntrto
		And	d.nmro_cntrto			=	e.nmro_cntrto
		And	d.cnsctvo_bnfcro			=	e.cnsctvo_bnfcro

	End

Else
	Begin

		-- se retorna la el cursor con cero registros
		select  	0	nmro_unco_idntfccn_aprtnte,  	0	cnsctvo_scrsl_ctznte,		0	cnsctvo_cdgo_clse_aprtnte ,
 			0	nmro_unco_idntfccn_afldo,	0	cnsctvo_cdgo_tpo_cntrto, 	0	nmro_cntrto, 
			d.cnsctvo_bnfcro, 			d.nmro_unco_idntfccn_bnfcro, 	d.inco_vgnca_bnfcro,	d.fn_vgnca_bnfcro,	e.vlr_upc,
			0					cnsctvo_cnta_mnls_cntrto,
			convert(numeric(12,0),0)	 vlr_dcto_comercial, 	convert(numeric(12,0),0)	 vlr_otros_dcts, 	convert(numeric(12,0),0)	 vlr_iva , 
			e.vlr_upc  	vlr_cta,
			convert(numeric(12,0),0)	 vlr_ttl_bnfcro,
			convert(numeric(12,0),0)	 vlr_ttl_bnfcro_sn_iva,
			convert(numeric(12,0),0)	 vlr_dcto_comercial_aux, 	convert(numeric(12,0),0)	 vlr_otros_dcts_aux, 	convert(numeric(12,0),0)	 vlr_iva_aux,
			0		Grupo_Conceptos,
			0		cnsctvo_cdgo_tpo_idntfccn,
			space(23)	numero_identificacion ,
			space(50)	primer_apellido ,
			space(50)	segundo_apellido ,
			space(50)	primer_nombre ,
			space(50)	segundo_nombre ,
			e.vlr_rl_pgo,
			@nmro_prds	nmro_prds
		From 	bdafiliacion..tbcontratos  a,  bdafiliacion..tbbeneficiarios  d,  bdafiliacion..tbdetbeneficiarioAdicional e
		Where   1				=	2

	End