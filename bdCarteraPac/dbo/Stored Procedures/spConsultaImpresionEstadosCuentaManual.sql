/*---------------------------------------------------------------------------------
* Metodo o PRG 			: spConsultaImpresionEstadosCuentaManual
* Desarrollado por		: <\A Ing Rolando Simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento realiza la impresion del estado de cuenta manual				  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P Numero del estado de cuenta									P\>
* Variables				: <\V  													V\>
* Fecha Creacion		: <\FC 2003/03/17 											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM  Ing. Fernando Valencia									AM\>
* Descripcion			: <\DM  Se aumenta a 20 los caracteres de los campos de primer nombre y segundo nombre DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion	: <\FM  2006/05/17	 FM\>
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM  Ing. Jean Paul Villaquiran Madrigal AM\>
* Descripcion			: <\DM  Se adicionan campos necesarios para mostrar en el reporte DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion	: <\FM  2019/04/30	 FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[spConsultaImpresionEstadosCuentaManual]
(
		@nmro_estdo_cnta	varchar(15),
		@lnOpcionImpresion	int
)		
As 
Begin
	Set Nocount On;

	Declare 		@cdgo_cncpto_lqdcn			Varchar(5),
					@dscrpcn_cncpto_lqdcn		Varchar(150),
					@cdgo_pln					Varchar(2),
					@cntdd						Int,
					@vlr						Numeric(12,0),
					@lcValorPrestacion			Varchar(100),
					@lcValorDecimal				Varchar(100),
					@nmro_estdo_cnta_cncpto		Varchar(15),
					@ContadorConceptos			int				= 0,
					@nmro_cntrto				char(15),
					@cntdd_bnfcrs				int,
					@dscrpcn_pln				char(150),
					@cnsctvo_cdgo_pln			udtconsecutivo,
					@vlr_cbrdo					numeric(12,0),
					@cnsctvo_cnta_mnls_cntrto	udtconsecutivo,
					@cdgo_tpo_idntfccn			char(3),
					@nmro_idntfccn				varchar(20),
					@prmr_Nmbre 				char(50),
					@sgndo_nmbre				char(50),
					@prmr_aplldo				char(50),
					@sgndo_aplldo				char(50),
					@nombre						varchar(300),
					@fechaActual				date			= getdate()			

	Select		fcha_incl_fctrcn,
				fcha_fnl_fctrcn,
				fcha_lmte_pgo,
 				nmro_unco_idntfccn_empldr,
 				cnsctvo_scrsl,
 				cnsctvo_cdgo_clse_aprtnte,
				a.cnsctvo_cdgo_tpo_idntfccn,
 				nmro_idntfccn_rspnsble_pgo,
				dgto_vrfccn,
				nmbre_empldr,
				nmbre_scrsl,
				cts_cnclr,
				cts_sn_cnclr,
				drccn,
				a.cnsctvo_cdgo_cdd,
				tlfno,
				ttl_fctrdo,
				vlr_iva,
				sldo_fvr,
				ttl_pgr,
				a.sldo_antrr,
				cnsctvo_cdgo_autrzdr_espcl,
 				a.fcha_crcn,
				nmro_estdo_cnta,
 				a.usro_crcn,
				a. cnsctvo_cdgo_prdo,
 				prcntje_incrmnto,
 				cnsctvo_cdgo_prdo_lqdcn,
				cnsctvo_cdgo_estdo_estdo_cnta,
				b.cdgo_cdd,
				b.dscrpcn_cdd,
				a.exste_Cntrto, 
				c.cdgo_tpo_idntfccn,
				d.cdgo_prdo,
				d.dscrpcn_prdo, 
				space(1000)  descripcion_concepto,
				space(1000)  cantidad_Concepto,
				space(1000)  valor_Concepto,
				space(1000)  descripcion_concepto1,
				space(1000)  cantidad_Concepto1,
				space(1000)  valor_Concepto1,
				a.fcha_crcn as fcha_gnrcn,
				a.cufe as codigocufe,
				BDAfiliacionValidador.dbo.fnCalculaValorLetras(isnull(a.ttl_pgr,0)) as  vlr_en_ltrs,                  
				a.cdna_qr as codigoQR,
				e.prfjo_atrzdo_fctrcn as prefijofactura,
				a.fcha_lmte_pgo as fcha_pgo,
				nmro_idntfccn_rspnsble_pgo as nmro_idntfccn,
				a.cnsctvo_cdgo_tpo_dcmnto as cnsctvo_cdgo_tpo_dcmnto,
				a.cdgo_brrs 
	into 		#tmpReporteEstadocuenta		
	From		dbo.TbCuentasManuales								a With(NoLock)
	inner join	bdafiliacion.dbo.tbciudades							b With(NoLock)
	on			a.cnsctvo_cdgo_cdd = b.cnsctvo_cdgo_cdd
	inner join	bdafiliacion.dbo.tbtiposidentificacion				c With(NoLock)
	on			a.cnsctvo_cdgo_tpo_idntfccn	=c.cnsctvo_cdgo_tpo_idntfccn
	inner join	bdafiliacion.dbo.tbperiodos							d With(NoLock)
	on			a.cnsctvo_cdgo_prdo	= d.cnsctvo_cdgo_prdo	
	inner join	BDAfiliacionValidador.dbo.tbResolucionesDIAN_vigencias	e With(NoLock)
	On			e.cnsctvo_cdgo_rslcn_dn = a.cnsctvo_cdgo_rslcn_dn
	Where 		Nmro_estdo_cnta = @nmro_estdo_cnta

	Select 		space(500)  numero_identificacion,
				space(500) nombre_cotizante,
				space(500) numero_afiliacion,
				space(500) codigo_plan,
				space(500) valor_contrato,
				space(500) cantidad_beneficiarios,
				space(500)  numero_identificacion1,
				space(500) nombre_cotizante1,
				space(500) numero_afiliacion1,
				space(500) codigo_plan1,
				space(500) valor_contrato1,
				space(500) cantidad_beneficiarios1,
				nmro_estdo_cnta	  
	into		#tmpContratos
	From 		#tmpReporteEstadocuenta
	Where		nmro_estdo_cnta = @nmro_estdo_cnta

	update		#tmpReporteEstadocuenta
	Set			descripcion_concepto='',
				cantidad_Concepto='',
				valor_Concepto='',
				descripcion_concepto1='',
				cantidad_Concepto1='',
				valor_Concepto1=''

	Update 		#tmpContratos
	Set			numero_identificacion='',
				nombre_cotizante='',
				numero_afiliacion='',
				codigo_plan='',
				valor_contrato='',
				cantidad_beneficiarios	=''

	Declare		crConceptosEstadoCuenta cursor for
	Select		b.cdgo_cncpto_lqdcn, 
				b.dscrpcn_cncpto_lqdcn,	
				c.cdgo_pln,
				a.cntdd,	
				a.vlr,
				a.nmro_estdo_cnta
	From 		dbo.TbCuentasManualesConcepto			a With(NoLock)
	Inner Join	dbo.tbconceptosliquidacion_vigencias	b With(NoLock)
		On		a.cnsctvo_cdgo_cncpto_lqdcn	=	b.cnsctvo_cdgo_cncpto_lqdcn
	Inner Join 	bdplanbeneficios.dbo.tbplanes			c With(NoLock)
		On		b.cnsctvo_cdgo_pln		=	c.cnsctvo_cdgo_pln
	Where		@fechaActual	between b.inco_vgnca	and	b.fn_vgnca
	And			a.nmro_estdo_cnta =	@nmro_estdo_cnta
	order by	dscrpcn_cncpto_lqdcn

	open		crConceptosEstadoCuenta
	Fetch		crConceptosEstadoCuenta into @cdgo_cncpto_lqdcn,  @dscrpcn_cncpto_lqdcn,   @cdgo_pln,
												@cntdd,	          @vlr,	                   @nmro_estdo_cnta_cncpto

	While @@Fetch_status = 0
	Begin
		Select	@lcValorPrestacion = Ltrim(Rtrim(convert(varchar(18),@vlr)))		

		Execute bdrecaudos.dbo.spFormatoDecimal 	@lcValorPrestacion,
													@lcValorDecimal 	Output,
													1

		Set		@ContadorConceptos	=	@ContadorConceptos	+	1
		--le cambiamos el estado para que no lo tenga en cuenta con los tbdetsaldosgeneradosnota
		If 		@ContadorConceptos	<=10
				Update	#tmpReporteEstadocuenta
				Set 	descripcion_concepto = Ltrim(Rtrim(descripcion_concepto)) + ltrim(rtrim(@cdgo_pln)) + ' ' + Rtrim(Ltrim(@dscrpcn_cncpto_lqdcn)) + Char(13),
						cantidad_Concepto = Ltrim(Rtrim(cantidad_Concepto)) + Rtrim(Ltrim(str(@cntdd))) + Char(13),
						valor_Concepto = ltrim(rtrim(valor_Concepto))   +  Space(18-Len(Ltrim(Rtrim(@lcValorDecimal)))) +  ltrim(rtrim(@lcValorDecimal))+Char(13)
				Where	nmro_estdo_cnta = @nmro_estdo_cnta_cncpto
		Else
				Update	#tmpReporteEstadocuenta
				Set 	descripcion_concepto1 		= 	Ltrim(Rtrim(descripcion_concepto1)) + ltrim(rtrim(@cdgo_pln)) + '  ' + Rtrim(Ltrim(@dscrpcn_cncpto_lqdcn)) + Char(13),
						cantidad_Concepto1 		= 	Ltrim(Rtrim(cantidad_Concepto1)) + Rtrim(Ltrim(str(@cntdd))) + Char(13),
						valor_Concepto1		=	ltrim(rtrim(valor_Concepto1))   +  Space(18-Len(Ltrim(Rtrim(@lcValorDecimal)))) +  ltrim(rtrim(@lcValorDecimal))+Char(13)
				Where	nmro_estdo_cnta		=	@nmro_estdo_cnta_cncpto
		

		Fetch crConceptosEstadoCuenta into	@cdgo_cncpto_lqdcn,	@dscrpcn_cncpto_lqdcn,	@cdgo_pln,
											@cntdd,				@vlr,					@nmro_estdo_cnta_cncpto
		
	End

	Close		crConceptosEstadoCuenta
	Deallocate	crConceptosEstadoCuenta

	Select		a.nmro_cntrto,
				a.cnsctvo_cdgo_tpo_cntrto,
				a.cntdd_bnfcrs,
				b.cdgo_pln,			
				b.dscrpcn_pln,
				a.cnsctvo_cdgo_pln,
				a.vlr_cbrdo,
				a.cnsctvo_cnta_mnls_cntrto,
				a.nmro_estdo_cnta,
				space(3) cdgo_tpo_idntfccn,
				space(20) nmro_idntfccn,
				space(50) prmr_Nmbre ,
				space(50) sgndo_nmbre,
				space(50) prmr_aplldo,
				space(50) sgndo_aplldo,
				space(300) nombre
	into		#tmp1
	From		dbo.TbCuentasManualesContrato		a With(NoLock) 
	inner join	bdplanbeneficios.dbo.tbplanes		b With(NoLock)
	on			a.cnsctvo_cdgo_pln	=	b.cnsctvo_cdgo_pln
	Where 		nmro_estdo_cnta 	= 	@nmro_estdo_cnta;

	Update		#tmp1
	Set			prmr_Nmbre 			=	c.prmr_Nmbre ,
				sgndo_nmbre			=	c.sgndo_nmbre,
				prmr_aplldo			=	c.prmr_aplldo,
				sgndo_aplldo		=	c.sgndo_aplldo,
				nombre				=	ltrim(rtrim(c.prmr_aplldo))  + ' ' + ltrim(rtrim(c.sgndo_aplldo)) + ' ' + ltrim(rtrim(c.prmr_Nmbre)) + ' ' + ltrim(rtrim(c.sgndo_nmbre)) ,
				cdgo_tpo_idntfccn	=	d.cdgo_tpo_idntfccn,
				nmro_idntfccn 		=	v.nmro_idntfccn 
	From		#tmp1									a 
	inner join	bdAfiliacion.dbo.TbContratos			b With(NoLock)
	on			a.nmro_cntrto			=	b.nmro_cntrto
	And			a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
	inner join	bdAfiliacion.dbo.tbpersonas				c With(NoLock) 
	on			c.nmro_unco_idntfccn		=	b.nmro_unco_idntfccn_afldo 	
	inner join	bdAfiliacion.dbo.tbvinculados			v With(NoLock)
	on			v.nmro_unco_idntfccn		=	b.nmro_unco_idntfccn_afldo
	inner join	bdafiliacion.dbo.tbtiposidentificacion	d With(NoLock)
	on			v.cnsctvo_cdgo_tpo_idntfccn	=	 d.cnsctvo_cdgo_tpo_idntfccn

	select		a.cnsctvo_cnta_mnls_cntrto, 
				min(cnsctvo_bnfcro) consecutivo_Beneficiario
	into		#tmpBeneficiariosCuentasManuales
	From 		dbo.TbCuentasManualesBeneficiario	a With(NoLock)
	Inner Join	#tmp1								b
		On		a.cnsctvo_cnta_mnls_cntrto = b.cnsctvo_cnta_mnls_cntrto	
	group by	a.cnsctvo_cnta_mnls_cntrto


	Update		#tmp1
	Set			prmr_Nmbre =	ltrim(rtrim(c.prmr_Nmbre)) ,
				sgndo_nmbre =	c.sgndo_nmbre,
				prmr_aplldo =	c.prmr_aplldo,
				sgndo_aplldo =	c.sgndo_aplldo,
				nombre = ltrim(rtrim(c.prmr_aplldo))  + ' ' + ltrim(rtrim(c.sgndo_aplldo)) + ' ' + ltrim(rtrim(c.prmr_Nmbre)) + ' ' + ltrim(rtrim(c.sgndo_nmbre)) ,
				nmro_idntfccn =	c.nmro_idntfccn 
	From		#tmp1 a
	Inner Join	#tmpBeneficiariosCuentasManuales  b 
		On		a.cnsctvo_cnta_mnls_cntrto	=	b.cnsctvo_cnta_mnls_cntrto
	Inner Join  dbo.TbCuentasManualesBeneficiario c with(nolock)
		On		c.cnsctvo_cnta_mnls_cntrto	=	b.cnsctvo_cnta_mnls_cntrto
		And		c.cnsctvo_bnfcro =	b.consecutivo_Beneficiario
	Where 		a.prmr_Nmbre =	''

	Declare		crContratoEstadoCuenta cursor for
	Select    	nmro_cntrto,
				cntdd_bnfcrs,
				cdgo_pln,			
				dscrpcn_pln,
				cnsctvo_cdgo_pln,
				vlr_cbrdo,
				cnsctvo_cnta_mnls_cntrto,
				nmro_estdo_cnta,
				cdgo_tpo_idntfccn,
				nmro_idntfccn,
				prmr_Nmbre ,
				sgndo_nmbre,
				prmr_aplldo,
				sgndo_aplldo,
				nombre
	From		#tmp1
	Order by	cdgo_pln ,
				prmr_aplldo,
				sgndo_aplldo,
				prmr_Nmbre,
				sgndo_nmbre	

	open		crContratoEstadoCuenta
	Fetch		crContratoEstadoCuenta 
	into		@nmro_cntrto,
				@cntdd_bnfcrs,
				@cdgo_pln,			
				@dscrpcn_pln,
				@cnsctvo_cdgo_pln,		
				@vlr_cbrdo,
				@cnsctvo_cnta_mnls_cntrto,	
				@nmro_estdo_cnta_cncpto,
				@cdgo_tpo_idntfccn,		
				@nmro_idntfccn,
				@prmr_Nmbre ,			
				@sgndo_nmbre,
				@prmr_aplldo,			
				@sgndo_aplldo,	
				@nombre

	Set			@ContadorConceptos	=	0

	While @@Fetch_status = 0
	Begin
		Select @lcValorPrestacion = Ltrim(Rtrim(convert(varchar(18),@vlr_cbrdo)))		

		Execute bdrecaudos.dbo.spFormatoDecimal 	@lcValorPrestacion,
													@lcValorDecimal 	Output , 
													1

		Set	@ContadorConceptos	=	@ContadorConceptos	+	1

		If	@ContadorConceptos	<= 14
			Update	#tmpContratos
			Set 	numero_identificacion 	= 	Ltrim(Rtrim(numero_identificacion))  + ltrim(rtrim(@nmro_idntfccn)) 		+  Char(13),
					nombre_cotizante 		= 	Ltrim(Rtrim(nombre_cotizante)) 	   + Rtrim(Ltrim(@nombre)) 		+  Char(13),
					numero_afiliacion		=	ltrim(rtrim(numero_afiliacion))   	   +   ltrim(rtrim(@nmro_cntrto))		+  Char(13),
			 		codigo_plan 			= 	Ltrim(Rtrim(codigo_plan)) 	   + ltrim(rtrim(@cdgo_pln))   		+  Char(13),
					valor_contrato 			= 	Ltrim(Rtrim(valor_contrato))	   + Rtrim(Ltrim(@lcValorDecimal)) 	+  Char(13),
					cantidad_beneficiarios	=	ltrim(rtrim(cantidad_beneficiarios))    +  ltrim(rtrim(str(@cntdd_bnfcrs))) 	+ Char(13)
			Where	nmro_estdo_cnta		=	@nmro_estdo_cnta_cncpto
		Else 
			Begin
				If 	@ContadorConceptos	<=28
					Update	#tmpContratos
					Set 	numero_identificacion1	= Ltrim(Rtrim(numero_identificacion1))  + ltrim(rtrim(@nmro_idntfccn)) 		+  Char(13),
							nombre_cotizante1 		= 	Ltrim(Rtrim(nombre_cotizante1)) 	   + Rtrim(Ltrim(@nombre)) 		+  Char(13),
							numero_afiliacion1		=	ltrim(rtrim(numero_afiliacion1))   	   +   ltrim(rtrim(@nmro_cntrto))		+  Char(13),
							codigo_plan1 			= 	Ltrim(Rtrim(codigo_plan1)) 	   + ltrim(rtrim(@cdgo_pln))   		+  Char(13),
							valor_contrato1 		= 	Ltrim(Rtrim(valor_contrato1))	   + Rtrim(Ltrim(@lcValorDecimal)) 	+  Char(13),
							cantidad_beneficiarios1	=	ltrim(rtrim(cantidad_beneficiarios1))    +  ltrim(rtrim(str(@cntdd_bnfcrs))) 	+ Char(13)
					Where	nmro_estdo_cnta		=	@nmro_estdo_cnta_cncpto
				else
					-- se inserta en una tabla temporal donde contiene todos los  contratos anexos al estado de cuenta que se generan
					-- en otro archivo
					Insert into #tmpContratosRestantes 
					Values (
						@nmro_idntfccn,
						@nombre,
						@nmro_cntrto,
						@cdgo_pln,
						@vlr_cbrdo,
						@cntdd_bnfcrs,
						@nmro_estdo_cnta_cncpto
					)
		
			End		

		Fetch		crContratoEstadoCuenta 
		into		@nmro_cntrto,			
					@cntdd_bnfcrs,
					@cdgo_pln,						
					@dscrpcn_pln,
					@cnsctvo_cdgo_pln,		
					@vlr_cbrdo,
					@cnsctvo_cnta_mnls_cntrto,	
					@nmro_estdo_cnta_cncpto,
					@cdgo_tpo_idntfccn,		
					@nmro_idntfccn,
					@prmr_Nmbre,			
					@sgndo_nmbre,
					@prmr_aplldo,			
					@sgndo_aplldo,	
					@nombre		
	End

	Close		crContratoEstadoCuenta
	Deallocate	crContratoEstadoCuenta

	--Consulta final del reporte del estado de cuenta	
	------------------------------------------------------------------------------------------------
	-------se adicionan  los mensajes a la factura
	Declare		@Mensajes		nvarchar(1000) = '',
				@dscrpcn_mnsje	varchar(200)

	Declare		crMensajes cursor for
	select		dscrpcn_mnsje 
	from 		dbo.tbperiodosliquidacion_vigencias a With(NoLock)
	Inner Join	dbo.tbmensajesxPeriodo b With(NoLock)
		On		a.cnsctvo_cdgo_prdo_lqdcn	=	b.cnsctvo_cdgo_prdo_lqdcn
	Inner Join	dbo.tbmensajes c With(NoLock)
		On		b.cnsctvo_cdgo_mnsje		=	c.cnsctvo_cdgo_mnsje
	where 		cnsctvo_cdgo_estdo_prdo 	= 	2;

	open		crMensajes
	Fetch		crMensajes into  @dscrpcn_mnsje


	While		@@Fetch_status = 0
	Begin
		Set	@Mensajes	=	@Mensajes  + ltrim(rtrim(@dscrpcn_mnsje))+ ' '		
		Fetch crMensajes into @dscrpcn_mnsje		
	End

	Close			crMensajes
	Deallocate		crMensajes

	Set			@Mensajes= Ltrim(Rtrim(@Mensajes))

	Select		a.*, b.numero_identificacion, b.nombre_cotizante, b.numero_afiliacion,
				b.codigo_plan,	b.valor_contrato,	b.cantidad_beneficiarios,
				b.numero_identificacion1, b.nombre_cotizante1, b.numero_afiliacion1,
				b.codigo_plan1,	b.valor_contrato1,	b.cantidad_beneficiarios1,
				'F1'+
				ltrim(rtrim(c.idntfcdor_aplccn)) + ltrim(rtrim(c.cdgo_ps)) + ltrim(rtrim(c.cdgo_emprsa_iac)) + ltrim(rtrim(c.idntfccn_tpo_rcdo)) + ltrim(rtrim(c.dgto_cntrl))  +
				ltrim(rtrim(c.idntfcdor_aplccn_usro)) + 
				right(replicate('0',8)+ltrim(rtrim(a.nmro_estdo_cnta)),8) + 
				'F1'+
				ltrim(rtrim(c.idntfcdor_aplccn_usro))	+	
				right(replicate('0',12)+ltrim(rtrim(a.nmro_idntfccn_rspnsble_pgo)),12) + 
				'F1'+
				ltrim(rtrim(c.idntfcdor_aplccn_usro_ia1))  +  
				right(replicate('0',10)+ ltrim(rtrim(convert(varchar(12),ttl_pgr))),10) + 
				'F1' +
				ltrim(rtrim(c.idntfcdor_aplccn_usro_ia2)) +
				convert(varchar(10),a.fcha_lmte_pgo,112)      Codigo_barras,
				--'(' + LTRIM(RTRIM(c.idntfcdor_aplccn)) + ')' +  ltrim(rtrim(c.cdgo_ps)) + ltrim(rtrim(c.cdgo_emprsa_iac)) + ltrim(rtrim(c.idntfccn_tpo_rcdo)) + ltrim(rtrim(c.dgto_cntrl))  +
				--'(' + ltrim(rtrim(c.idntfcdor_aplccn_usro)) + ')'  +  
				--right(replicate('0',8)+ltrim(rtrim(a.nmro_estdo_cnta)),8) + 
				--'(' + ltrim(rtrim(c.idntfcdor_aplccn_usro)) + ')'  +  
				--right(replicate('0',12)+ltrim(rtrim(a.nmro_idntfccn_rspnsble_pgo)),12) + 
				-- '(' + ltrim(rtrim(c.idntfcdor_aplccn_usro_ia1))  + ')' +
				--right(replicate('0',10)+ltrim(rtrim(convert(varchar(12),ttl_pgr))),10) + 
				--'(' + ltrim(rtrim(c.idntfcdor_aplccn_usro_ia2)) + ')' + convert(varchar(10),a.fcha_lmte_pgo,112)      Valor_Codigo_barras,
				a.cdgo_brrs   Valor_Codigo_barras,
				@Mensajes 		  Mensaje,
				Case when  @lnOpcionImpresion		=	1 	THEN  	0 	          ELSE	   1	END   lnmediato,
				Case when  @lnOpcionImpresion		=	2 	THEN 	'INMEDIATO'  ELSE 	   ''	END  lnMensajeFecha
	From		#tmpReporteEstadocuenta  a, 
				#tmpContratos b,  
				dbo.TbEstructuraCodigoBarras_vigencias  c
	Where		a.nmro_estdo_cnta= b.nmro_estdo_cnta
	And			@fechaActual between c.inco_vgnca and c.fn_vgnca
	And			cnsctvo_vgnca_estrctra_cdgo_brrs = 1    -- consecutivo del  codigo de barras

End