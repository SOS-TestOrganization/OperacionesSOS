/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spConsultaDetalleCuentaManual
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento arma y ejecuta la cadena donde se tiene los criterios para seleccionar los promotoresr 	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003/02/10											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  FM\>
*---------------------------------------------------------------------------------*/
CREATE  PROCEDURE [dbo].[spConsultaDetalleCuentaManual]
		@lnTipo		int,
		@nmro_estdo_cnta	varchar(15) 
 
As


IF 	@lnTipo	=	1  -- trae el estado de cuenta
	BEGIN
	select	 fcha_incl_fctrcn,
		fcha_fnl_fctrcn,
		fcha_lmte_pgo,
		nmro_unco_idntfccn_empldr,
		cnsctvo_scrsl,
		cnsctvo_cdgo_clse_aprtnte,
		cnsctvo_cdgo_tpo_idntfccn,
		nmro_idntfccn_rspnsble_pgo,
		dgto_vrfccn,
		nmbre_empldr,
		nmbre_scrsl,
		cts_cnclr,
		drccn,
		a.cnsctvo_cdgo_cdd,
		tlfno,
		ttl_fctrdo,
		vlr_iva,
		sldo_fvr,
		ttl_pgr,
		cnsctvo_cdgo_autrzdr_espcl,
		a.fcha_crcn,
		nmro_estdo_cnta,
		a.usro_crcn,
		cnsctvo_cdgo_prdo,
		prcntje_incrmnto,
		cnsctvo_cdgo_prdo_lqdcn,
		cnsctvo_cdgo_estdo_estdo_cnta,
		b.cdgo_cdd,
		b.dscrpcn_cdd,
		a.exste_Cntrto, 
		a.cts_sn_cnclr,
		a.sldo_antrr
	From	 TbCuentasManuales a , bdafiliacion..tbciudades b 
	Where 	 nmro_estdo_cnta=@nmro_estdo_cnta
	And	a.cnsctvo_cdgo_cdd=b.cnsctvo_cdgo_cdd
	END



IF 	@lnTipo	=	2  -- trae los conceptos del estado cuenta
	BEGIN
		select	b.cdgo_cncpto_lqdcn 	codigo,
			b.dscrpcn_cncpto_lqdcn 	nombre,
			a.cntdd			 cantidad,
			IsNull(a.vlr,0) as valor,
			a.cnsctvo_cdgo_cncpto_lqdcn,
			a.nmro_estdo_cnta,	
			a.usro_crcn,
			a.usro_ultma_mdfccn,
			a.fcha_crcn,
			a.fcha_ultma_mdfccn
		From TbCuentasManualesConcepto a, TbConceptosliquidacion b
		Where a.cnsctvo_cdgo_cncpto_lqdcn=b.cnsctvo_cdgo_cncpto_lqdcn
		And	a.nmro_estdo_cnta=@nmro_estdo_cnta
	END





IF 	@lnTipo	=	3   -- trae los contratos
	BEGIN
	select	convert(int,(a.nmro_cntrto))	numero_contrato,
		a.cntdd_bnfcrs			Cantidad_beneficiarios,
		b.dscrpcn_pln  			nombre_plan,	
		a.cnsctvo_cdgo_pln,
		a.vlr_cbrdo			vlr_cntrto,	
		0				consecutivo_registro,
		a.cnsctvo_cnta_mnls_cntrto,
		a.nmro_estdo_cnta,
		a.cnsctvo_cdgo_tpo_cntrto,
		a.usro_crcn,
		a.fcha_crcn,
		b.cdgo_pln,
		b.dscrpcn_pln  
	From	TbCuentasManualesContrato a, bdplanbeneficios..tbplanes b
	Where   a.nmro_estdo_cnta 	= 	@nmro_estdo_cnta
	And	a.cnsctvo_cdgo_pln	=	b.cnsctvo_cdgo_pln
	END



IF 	@lnTipo	=	4  --traer los beneficiarios
	BEGIN
		Select	convert(int,(b.nmro_cntrto))	numero_contrato,
			a.cnsctvo_bnfcro		Consecutivo_beneficiario,
			c.cdgo_tpo_idntfccn	Tipo_identificacion,
			a.nmro_idntfccn		numero_identificacion,
			a.prmr_Nmbre		primer_nombre,
			a.sgndo_nmbre		segundo_nombre,
			a.prmr_aplldo		primer_apellido,
			a.sgndo_aplldo		segundo_apellido,
			a.cnsctvo_cdgo_tpo_idntfccn,
			0	estdo,
			a.cnsctvo_cnta_mnls_cntrto,
			IsNull(a.vlr,0) as valor_beneficiario,
			a.fcha_crcn
		From 	TbCuentasManualesBeneficiario  a, TbCuentasManualesContrato b , bdafiliacion..tbtiposidentificacion c
		Where 	a.cnsctvo_cnta_mnls_cntrto	=	 b.cnsctvo_cnta_mnls_cntrto
		And	a.cnsctvo_cdgo_tpo_idntfccn	=	 c.cnsctvo_cdgo_tpo_idntfccn
		 And     	 b.nmro_estdo_cnta 		= 	@nmro_estdo_cnta




    	END
IF 	@lnTipo	=	5  --traer los conceptos de los  beneficiarios
	BEGIN
		Select	d.cdgo_cncpto_lqdcn	   	codigo,
			d.dscrpcn_cncpto_lqdcn      	nombre,
			IsNull(a.vlr,0) as 	valor,	
			a.cnsctvo_cdgo_cncpto_lqdcn	cnsctvo_cdgo_cncpto,
			convert(int,(c.nmro_cntrto))	numero_contrato,
			a.cnsctvo_bnfcro			Consecutivo_beneficiario,
			a.cnsctvo_cnta_mnls_cntrto,
			CASE  WHEN d.oprcn= 3 THEN  IsNull(a.vlr,0)  ELSE (IsNull(a.vlr,0) * -1)  END  valor_aux,
			a.fcha_crcn,
			a.usro_crcn
		From	TbCuentasManualesBeneficiarioxConceptos a ,TbCuentasManualesBeneficiario b ,TbCuentasManualesContrato c,
			TbConceptosliquidacion_vigencias  d
		Where	b.cnsctvo_cnta_mnls_cntrto	=	 c.cnsctvo_cnta_mnls_cntrto
		And	a.cnsctvo_cnta_mnls_cntrto	=	 b.cnsctvo_cnta_mnls_cntrto
		And	a.cnsctvo_bnfcro		=	 b.cnsctvo_bnfcro	
		And	d.cnsctvo_cdgo_cncpto_lqdcn	=	 a.cnsctvo_cdgo_cncpto_lqdcn 
		And	c.nmro_estdo_cnta 		= 	@nmro_estdo_cnta
		And	convert(varchar(10),getdate() ,111)  between convert(varchar(10),d.inco_vgnca,111)  and	convert(varchar(10),d.fn_vgnca,111)


    	END