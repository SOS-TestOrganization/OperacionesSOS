
/*---------------------------------------------------------------------------------
* Metodo o PRG		: spAdicionaRegistrosImpresionEstadosCuentaManual
* Desarrollado por	: <\A Ing Rolando Simbaqueva Lasso									A\>
* Descripcion		: <\D Este procedimiento realiza la adicion de los detalles del estado de cuenta tanto los conceptos como los contrato  	D\>
* Observaciones		: <\O  													O\>
* Parametros		: <\P Numero del estado de cuenta									P\>
* Variables		: <\V  													V\>
* Fecha Creacion	: <\FC 2003/03/17 											FC\>
* 
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por	: <\AM  Rolando Simbaqueva Lasso	AM\>
* Descripcion		: <\DM Aplicacion de tecnicas de optimizacion DM\>
* Nuevos Parametros	: <\PM  PM\>
* Nuevas Variables	: <\VM  VM\>
* Fecha Modificacion	: <\FM  2005/09/25	 FM\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por	: <\AM  Ing. Cesar García																	AM\>
* Descripcion		: <\DM	Se adicionan hints a las tablas y se ajusta relación entre tablas utilizando joins	DM\>
* Nuevos Parametros	: <\PM  PM\>
* Nuevas Variables	: <\VM  VM\>
* Fecha Modificacion: <\FM  2017-03-15																			FM\>
*---------------------------------------------------------------------------------*/

--sp_helptext spPTLAdicionaRegistrosImpresionEstadosCuentaManual

CREATE PROCEDURE [dbo].[spPTLAdicionaRegistrosImpresionEstadosCuentaManual]
As
Set Nocount On

Begin
	Declare		@cnsctvo_estdo_cnta			Int,
				@cdgo_cncpto_lqdcn			Varchar(5),
				@dscrpcn_cncpto_lqdcn		Varchar(150),
				@cdgo_pln					Varchar(2),
				@cntdd						Int,
				@vlr						Numeric(12,0),
				@lcValor					Varchar(100),
				@lcValorDecimal				Varchar(100),
				@nmro_estdo_cnta_cncpto 	Varchar(15),
				@ContadorConceptos			Int,
				@nmro_cntrto				Char(15),
				@cntdd_bnfcrs				Int,
				@dscrpcn_pln				Char(150),
				@cnsctvo_cdgo_pln			Int,
				@vlr_cbrdo					Numeric(12,0),
				@cnsctvo_cnta_mnls_cntrto	Int,
				@cdgo_tpo_idntfccn			Char(3),
				@nmro_idntfccn				Varchar(20),
				@prmr_Nmbre 				Char(15),
				@sgndo_nmbre				Char(15),
				@prmr_aplldo				Char(50),
				@sgndo_aplldo				Char(50),
				@nombre						Varchar(200),
				@InicialEstadoCuenta		Int,
				@ContadorContratos			Int,
				@InicialNumeroEstadoCuenta	Varchar(15),
				@nmro_estdo_cnta_cntrto		Int

	--Creacion de tablas temporales

	Create table #tmpReporteEstadocuenta
		(
			nmro_estdo_cnta 			varchar(15),
			cdgo_tpo_idntfccn			varchar(3),
			nmro_idntfccn				varchar(20),
			dscrpcn_clse_aprtnte		varchar(50),
			nmbre_scrsl					varchar(200),
			rzn_scl						varchar(200),
			ttl_fctrdo					numeric(12,0),
			usro_crcn					varchar(30),
			cnsctvo_cdgo_lqdcn 			int,
			accn						varchar(50),
			cnsctvo_estdo_cnta			int,
			fcha_gnrcn					datetime,
			nmro_unco_idntfccn_empldr	int,
			cnsctvo_scrsl				int,
			cnsctvo_cdgo_clse_aprtnte	int,
			cnsctvo_cdgo_sde			int,
			vlr_iva						numeric(12,0),
			sldo_fvr					numeric(12,0),
			ttl_pgr						numeric(12,0),
			Cts_Cnclr					int,
			Cts_sn_Cnclr				int,
			cdgo_cdd					varchar(20),
			dscrpcn_cdd					varchar(100),
			dscrpcn_prdo				varchar(50),
			cdgo_prdo					varchar(6),
			dscrpcn_tpo_idntfccn		varchar(50),
			drccn						varchar(80),
			tlfno						varchar(30),
			cnsctvo_cdgo_prdo_lqdcn		int,
			fcha_incl_fctrcn			datetime,
			fcha_fnl_fctrcn 			datetime,
			fcha_pgo					datetime,
			sldo_antrr					numeric(12,0),
			cnsctvo_cdgo_tpo_idntfccn	int,	
			descripcion_concepto		varchar(1000),
			cantidad_Concepto			varchar(1000),
			valor_Concepto				varchar(1000),
			descripcion_concepto1		varchar(1000),
			cantidad_Concepto1			varchar(1000),
			valor_Concepto1				varchar(1000),
			dscrpcn_sde					varchar(50),
			nmro_Aux					int,
			cdgo_sde					varchar(4),
			---------------------------------------
			idntfcdor_aplccn			Char(10),
			cdgo_ps						Char(10),
			cdgo_emprsa_iac				Char(10),
			idntfccn_tpo_rcdo			Char(10),
			dgto_cntrl					Char(10),
			idntfcdor_aplccn_usro		Char(10),
			idntfcdor_aplccn_usro_ia1	Char(10),
			idntfcdor_aplccn_usro_ia2	Char(10),
			-------Factura-Electronica----------- FE
			fechaExpedicion	varchar(10),
			cufe varchar(160),
			cadenaQR varchar(2000),
			totalPagarLetras varchar(250)
		)
 
-- se crea un atbla temporal con los campos de contratos que aparecen en el detalle del estado de cuenta

	Create table #tmpContratos
		(	numero_identificacion		varchar(500),
			nombre_cotizante			varchar(2000),
			numero_afiliacion			varchar(500),
			codigo_plan					varchar(150),
			valor_contrato				varchar(500),
			cantidad_beneficiarios		varchar(100),
			numero_identificacion1		varchar(500),
			nombre_cotizante1			varchar(2000),
			numero_afiliacion1			varchar(500),
			codigo_plan1				varchar(150),
			valor_contrato1				varchar(500),
			cantidad_beneficiarios1		varchar(100),
			cnsctvo_estdo_cnta			int
		)

	Create table #TmpContratosEstadosCuenta
		(	cnsctvo_estdo_cnta_cntrto	int,
			cnsctvo_estdo_cnta			int,
			cnsctvo_cdgo_tpo_cntrto		int,
			nmro_cntrto					varchar(20),
			vlr_cbrdo					numeric(12,0),
			sldo						numeric(12,0),
			cntdd_bnfcrs				int
		)

	Create table #tmpContratosPacEstadoscuenta
		(	cnsctvo_cdgo_tpo_cntrto		int,
			nmro_cntrto					varchar(20),
			cnsctvo_cdgo_pln			int,
			nmro_unco_idntfccn_afldo	int,
			cnsctvo_estdo_cnta			int
		)

	Create table #tmpContratosEstadosCuenta_aux
		(	nmro_cntrto					varchar(20),
			cntdd_bnfcrs				int,
			cdgo_pln					varchar(4),
			dscrpcn_pln					varchar(50),
			cnsctvo_cdgo_pln			int,
			vlr_cbrdo					numeric(12,0),
			cnsctvo_estdo_cnta_cntrto	int,
			cnsctvo_estdo_cnta			int,
			cdgo_tpo_idntfccn			varchar(4),
			nmro_idntfccn				varchar(20),
			prmr_Nmbre					varchar(100),
			sgndo_nmbre					varchar(100),
			prmr_aplldo					varchar(100),
			sgndo_aplldo				varchar(100),
			nombre						varchar(200)
		)


	Create Table #tmpContratosIniciales  
		(	nmro_idntfccn				varchar(20),
			nombre						varchar(200),
			nmro_cntrto					char(15),
			cdgo_pln					varchar(2),
			vlr_cbrdo					Numeric(12,0),
			cntdd_bnfcrs				Int,
			nmro_estdo_cnta_cntrto		Int
		)

	Create Table #tmpContratosRestantes  
		(	nmro_idntfccn				varchar(20),
			nombre						varchar(200),
			nmro_cntrto					char(15),
			cdgo_pln					varchar(2),
			vlr_cbrdo					Numeric(12,0),
			cntdd_bnfcrs				Int,
			nmro_estdo_cnta_cntrto		Int
		)
			
	Set	@ContadorConceptos	=	0

-- se crea la tabla temporal con la informacion de los estados de cuenta que se van a imprimir

	Insert Into #tmpReporteEstadocuenta
	Select		nmro_estdo_cnta,				cdgo_tpo_idntfccn, 		nmro_idntfccn, 					dscrpcn_clse_aprtnte,
				nmbre_scrsl,					rzn_scl,				ttl_fctrdo, 					usro_crcn,		
				cnsctvo_cdgo_lqdcn,				accn,					cnsctvo_estdo_cnta, 			fcha_gnrcn,
				nmro_unco_idntfccn_empldr,		cnsctvo_scrsl, 			cnsctvo_cdgo_clse_aprtnte,      cnsctvo_cdgo_sde,
				vlr_iva,						sldo_fvr, 				ttl_pgr,	 					Cts_Cnclr,
				Cts_sn_Cnclr,					cdgo_cdd, 				dscrpcn_cdd, 					dscrpcn_prdo,
				cdgo_prdo,						dscrpcn_tpo_idntfccn, 	drccn, 							ltrim(rtrim(isnull(tlfno,''))),
				cnsctvo_cdgo_prdo_lqdcn,		fcha_incl_fctrcn,		dateadd(day,-1,DATEADD(month, Cts_Cnclr, fcha_incl_fctrcn) )  fcha_fnl_fctrcn,
				fcha_pgo, 						sldo_antrr,				cnsctvo_cdgo_tpo_idntfccn,		'',
				'',								'',						'',								'',
				'',								dscrpcn_sde,			nmro_Aux,						cdgo_sde,
				NULL,							NULL,					NULL,							NULL,
				NULL,							NULL,					NULL,							NULL,
				convert(varchar, fechaExpedicion, 103),	cufe , cadenaQR, BDAfiliacionValidador.dbo.fnCalculaValorLetras(ttl_pgr)
	From		#TmpImpresionEstadosCuenta_aux With(NoLock)

	-- se crea un atbla temporal con los campos de contratos que aparecen en el detalle del estado de cuenta

	insert into #tmpContratos	(cnsctvo_estdo_cnta)
	Select 		cnsctvo_estdo_cnta
	From 		#tmpReporteEstadocuenta With(NoLock)

	-- se inicializan los campos de la tabla temporal
	Update	#tmpReporteEstadocuenta
	Set		descripcion_concepto	=	'',
			cantidad_Concepto		=	'',
			valor_Concepto			=	'',
			descripcion_concepto1	=	'',
			cantidad_Concepto1		=	'',
			valor_Concepto1			=	''

	--se inicializan los campos de contratos
	Update 	#tmpContratos
	Set		numero_identificacion	=	'',
			nombre_cotizante		=	'',
			numero_afiliacion		=	'',
			codigo_plan				=	'',
			valor_contrato			=	'',
			cantidad_beneficiarios	=	''

	Update	#tmpReporteEstadocuenta
	Set		idntfcdor_aplccn			=	c.idntfcdor_aplccn,
			cdgo_ps						=	c.cdgo_ps,
			cdgo_emprsa_iac				=	c.cdgo_emprsa_iac,
			idntfccn_tpo_rcdo			=	c.idntfccn_tpo_rcdo,
			dgto_cntrl					=	c.dgto_cntrl,
			idntfcdor_aplccn_usro		=	c.idntfcdor_aplccn_usro,
			idntfcdor_aplccn_usro_ia1	=	c.idntfcdor_aplccn_usro_ia1,
			idntfcdor_aplccn_usro_ia2	=	c.idntfcdor_aplccn_usro_ia2
	From	bdcarteraPac.dbo.TbEstructuraCodigoBarras_vigencias c	With(NoLock)
	Where 	getdate() 	between 	c.inco_vgnca 	and 	c. fn_vgnca
	And		cnsctvo_vgnca_estrctra_cdgo_brrs = 1

	--se crea un cursor con todos los conceptos de los estados de cuenta
	Declare		crConceptosEstadoCuenta cursor for
	Select		b.cdgo_cncpto_lqdcn, 	b.dscrpcn_cncpto_lqdcn,		c.cdgo_pln,
				a.cntdd,			a.vlr_cbrdo,			a.cnsctvo_estdo_cnta
	from 		bdcarteraPac.dbo.TbEstadosCuentaConceptos			a	With(NoLock)
	Inner Join	bdcarteraPac.dbo.tbconceptosliquidacion_vigencias  	b	With(NoLock)	On	b.cnsctvo_cdgo_cncpto_lqdcn	=	a.cnsctvo_cdgo_cncpto_lqdcn
	Inner Join	bdplanbeneficios.dbo.tbplanes 						c	With(NoLock)	On	c.cnsctvo_cdgo_pln			=	b.cnsctvo_cdgo_pln
	Inner Join	#tmpReporteEstadocuenta 							d	With(NoLock)	On	d.cnsctvo_estdo_cnta		=	a.cnsctvo_estdo_cnta
	Where		getdate()	between	 b.inco_vgnca	and		b.fn_vgnca
	order by a.cnsctvo_estdo_cnta,b.dscrpcn_cncpto_lqdcn

	open	crConceptosEstadoCuenta
	Fetch    crConceptosEstadoCuenta into	@cdgo_cncpto_lqdcn,	@dscrpcn_cncpto_lqdcn,  @cdgo_pln,
											@cntdd,	          	@vlr,					@cnsctvo_estdo_cnta

	Set	@InicialEstadoCuenta	= @cnsctvo_estdo_cnta
	Set	@ContadorConceptos	=	0

	While @@Fetch_status = 0
		Begin

			if 	@InicialEstadoCuenta	<>	@cnsctvo_estdo_cnta
				Begin
					Set @InicialEstadoCuenta	=	@cnsctvo_estdo_cnta
					Set	@ContadorConceptos	=	0
				End

			Select @lcValor = Ltrim(Rtrim(convert(varchar(18),@vlr)))		
			Execute bdcarterapac.dbo.spFormatoDecimal 	@lcValor,	@lcValorDecimal 	Output,		1

			Set	@ContadorConceptos	=	@ContadorConceptos	+	1
			--le cambiamos el estado para que no lo tenga en cuenta con los tbdetsaldosgeneradosnota
			if 	@ContadorConceptos	<=10
				Update	#tmpReporteEstadocuenta
				Set 	descripcion_concepto 		= 	Ltrim(Rtrim(descripcion_concepto)) + ltrim(rtrim(@cdgo_pln)) + ' ' + Rtrim(Ltrim(@dscrpcn_cncpto_lqdcn)) + Char(13),
						cantidad_Concepto 		= 	Ltrim(Rtrim(cantidad_Concepto)) + Rtrim(Ltrim(str(@cntdd))) + Char(13),
						valor_Concepto			=	ltrim(rtrim(valor_Concepto))   +  Space(18-Len(Ltrim(Rtrim(@lcValorDecimal)))) +  ltrim(rtrim(@lcValorDecimal))+Char(13)
				Where	cnsctvo_estdo_cnta		=	@cnsctvo_estdo_cnta
			else
				Update	#tmpReporteEstadocuenta
				Set 	descripcion_concepto1 		= 	Ltrim(Rtrim(descripcion_concepto1)) + ltrim(rtrim(@cdgo_pln)) + '  ' + Rtrim(Ltrim(@dscrpcn_cncpto_lqdcn)) + Char(13),
						cantidad_Concepto1 		= 	Ltrim(Rtrim(cantidad_Concepto1)) + Rtrim(Ltrim(str(@cntdd))) + Char(13),
						valor_Concepto1		=	ltrim(rtrim(valor_Concepto1))   +  Space(18-Len(Ltrim(Rtrim(@lcValorDecimal)))) +  ltrim(rtrim(@lcValorDecimal))+Char(13)
				Where	cnsctvo_estdo_cnta		=	@cnsctvo_estdo_cnta

			Fetch crConceptosEstadoCuenta into	@cdgo_cncpto_lqdcn, @dscrpcn_cncpto_lqdcn,	@cdgo_pln,
												@cntdd,				@vlr,					@cnsctvo_estdo_cnta
		End

	Close crConceptosEstadoCuenta
	Deallocate crConceptosEstadoCuenta

	--Se crea una tabla temporal con los contratos del los estados de cuenta
	insert into #TmpContratosEstadosCuenta
	Select		cnsctvo_estdo_cnta_cntrto,
				a.cnsctvo_estdo_cnta,
				cnsctvo_cdgo_tpo_cntrto,
				nmro_cntrto,
				vlr_cbrdo,
				sldo,
				cntdd_bnfcrs
	From 		bdcarterapac.dbo.TbEstadosCuentaContratos	a	With(NoLock)
	inner join	#tmpReporteEstadocuenta						b	With(NoLock)	on	(a.cnsctvo_estdo_cnta	=	b.cnsctvo_estdo_cnta)

	Insert into #tmpContratosPacEstadoscuenta
	Select		a.cnsctvo_cdgo_tpo_cntrto,
				a.nmro_cntrto,
				a.cnsctvo_cdgo_pln,
				a.nmro_unco_idntfccn_afldo,
				b.cnsctvo_estdo_cnta
	From 		bdafiliacion.dbo.tbcontratos	a	With(NoLock)
	inner join	#TmpContratosEstadosCuenta		b	With(NoLock)	on	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
																	And	a.nmro_cntrto				=	b.nmro_cntrto

	Insert into #tmpContratosEstadosCuenta_aux
	Select		b.nmro_cntrto,				a.cntdd_bnfcrs,					f.cdgo_pln,						f.dscrpcn_pln,
				f.cnsctvo_cdgo_pln,			a.vlr_cbrdo,					a.cnsctvo_estdo_cnta_cntrto,	g.cnsctvo_estdo_cnta,
				d.cdgo_tpo_idntfccn,		c.nmro_idntfccn,				e.prmr_Nmbre,					e.sgndo_nmbre,
				e.prmr_aplldo,				e.sgndo_aplldo,					ltrim(rtrim(e.prmr_aplldo))  + ' ' + ltrim(rtrim(e.sgndo_aplldo)) + ' ' + ltrim(rtrim(e.prmr_Nmbre)) + ' ' + ltrim(rtrim(e.sgndo_nmbre)) nombre
	From		#TmpContratosEstadosCuenta				a
	inner join	#tmpContratosPacEstadoscuenta			b	With(NoLock)	on  (a.cnsctvo_cdgo_tpo_cntrto  	=    b.cnsctvo_cdgo_tpo_cntrto
																			And a.nmro_cntrto		   	=    b.nmro_cntrto
																			And a.cnsctvo_estdo_cnta		=    b.cnsctvo_estdo_cnta)
	inner join	bdafiliacion.dbo.tbvinculados			c	With(NoLock)	on	(b.nmro_unco_idntfccn_afldo  	=    c.nmro_unco_idntfccn)
	inner join	bdafiliacion.dbo.tbtiposidentificacion  d	With(NoLock)	on	(c.cnsctvo_cdgo_tpo_idntfccn 	=    d.cnsctvo_cdgo_tpo_idntfccn)
	inner join	bdafiliacion.dbo.tbpersonas				e	With(NoLock)	on	(b.nmro_unco_idntfccn_afldo	=    e.nmro_unco_idntfccn)
	inner join	bdplanbeneficios.dbo.tbplanes			f	With(NoLock)	on	(b.cnsctvo_cdgo_pln		=    f.cnsctvo_cdgo_pln	)
	inner join	#tmpReporteEstadocuenta					g	With(NoLock)	on	(g.cnsctvo_estdo_cnta		=   a.cnsctvo_estdo_cnta)

	Declare crContratoEstadoCuenta cursor for
	Select	nmro_cntrto,		cntdd_bnfcrs,			cdgo_pln,dscrpcn_pln,
			cnsctvo_cdgo_pln,	vlr_cbrdo,				cnsctvo_estdo_cnta_cntrto,
			cnsctvo_estdo_cnta,	cdgo_tpo_idntfccn,		nmro_idntfccn,
			prmr_Nmbre,			sgndo_nmbre,			prmr_aplldo,
			sgndo_aplldo,		nombre
	from	#tmpContratosEstadosCuenta_aux	With(NoLock)
	order by cnsctvo_estdo_cnta,cdgo_pln ,prmr_aplldo,sgndo_aplldo,prmr_Nmbre,sgndo_nmbre,nmro_cntrto	

	open	crContratoEstadoCuenta
	Fetch   crContratoEstadoCuenta into	@nmro_cntrto,				@cntdd_bnfcrs,
				    					@cdgo_pln,					@dscrpcn_pln,
										@cnsctvo_cdgo_pln,			@vlr_cbrdo,
										@cnsctvo_cnta_mnls_cntrto,	@nmro_estdo_cnta_cntrto,
										@cdgo_tpo_idntfccn,			@nmro_idntfccn,
										@prmr_Nmbre ,				@sgndo_nmbre,
										@prmr_aplldo,				@sgndo_aplldo,	
										@nombre

	Set	@ContadorContratos		=	0
	Set	@InicialNumeroEstadoCuenta	=	@nmro_estdo_cnta_cntrto

	While @@Fetch_status = 0
		Begin


			If	@InicialNumeroEstadoCuenta	<>	@nmro_estdo_cnta_cntrto
				Begin
					Set	@InicialNumeroEstadoCuenta	=	@nmro_estdo_cnta_cntrto
					Set	@ContadorContratos		=	0
				
				End

			Select @lcValor = Ltrim(Rtrim(convert(varchar(18),@vlr_cbrdo)))		
			Execute bdcarterapac..spFormatoDecimal 	@lcValor,	@lcValorDecimal 	Output , 1

			Set	@ContadorContratos	=	@ContadorContratos	+	1

			if @ContadorContratos	<= 14
				Begin
					Update		#tmpContratos
					Set 		numero_identificacion 		= 	Ltrim(Rtrim(numero_identificacion))  + ltrim(rtrim(@nmro_idntfccn)) 		+  Char(13),
								nombre_cotizante 		= 	Ltrim(Rtrim(nombre_cotizante)) 	   + Rtrim(Ltrim(@nombre)) 		+  Char(13),
								numero_afiliacion		=	ltrim(rtrim(numero_afiliacion))   	   +   ltrim(rtrim(@nmro_cntrto))		+  Char(13),
				 				codigo_plan 			= 	Ltrim(Rtrim(codigo_plan)) 	   + ltrim(rtrim(@cdgo_pln))   		+  Char(13),
								valor_contrato 			= 	Ltrim(Rtrim(valor_contrato))	   + Rtrim(Ltrim(@lcValorDecimal)) 	+  Char(13),
								cantidad_beneficiarios		=	ltrim(rtrim(cantidad_beneficiarios))    +  ltrim(rtrim(str(@cntdd_bnfcrs))) 	+ Char(13)
					Where		cnsctvo_estdo_cnta		=	@nmro_estdo_cnta_cntrto

					Insert into #tmpContratosIniciales
					Values		(@nmro_idntfccn,@nombre,@nmro_cntrto,@cdgo_pln,@vlr_cbrdo,@cntdd_bnfcrs,@nmro_estdo_cnta_cntrto)
				End
			else 
				Begin
					if 	 @ContadorContratos	<=28
						Begin
							Update	#tmpContratos
							Set 	numero_identificacion1 		= 	Ltrim(Rtrim(numero_identificacion1))  + ltrim(rtrim(@nmro_idntfccn)) 		+  Char(13),
									nombre_cotizante1 		= 	Ltrim(Rtrim(nombre_cotizante1)) 	   + Rtrim(Ltrim(@nombre)) 		+  Char(13),
									numero_afiliacion1		=	ltrim(rtrim(numero_afiliacion1))   	   +   ltrim(rtrim(@nmro_cntrto))		+  Char(13),
						 			codigo_plan1 			= 	Ltrim(Rtrim(codigo_plan1)) 	   + ltrim(rtrim(@cdgo_pln))   		+  Char(13),
									valor_contrato1 			= 	Ltrim(Rtrim(valor_contrato1))	   + Rtrim(Ltrim(@lcValorDecimal)) 	+  Char(13),
									cantidad_beneficiarios1		=	ltrim(rtrim(cantidad_beneficiarios1))    +  ltrim(rtrim(str(@cntdd_bnfcrs))) 	+ Char(13)
							Where	cnsctvo_estdo_cnta		=	@nmro_estdo_cnta_cntrto

							Insert into #tmpContratosIniciales
							Values		(@nmro_idntfccn,@nombre,@nmro_cntrto,@cdgo_pln,@vlr_cbrdo,@cntdd_bnfcrs,@nmro_estdo_cnta_cntrto)
						End
					ELSE
						-- se inserta en una tabla temporal donde contiene todos los  contratos anexos al estado de cuenta que se generan
						-- en otro archivo
						Insert into #tmpContratosRestantes Values (@nmro_idntfccn,@nombre,@nmro_cntrto,@cdgo_pln,@vlr_cbrdo,@cntdd_bnfcrs,@nmro_estdo_cnta_cntrto)
				END

			Fetch    crContratoEstadoCuenta into	@nmro_cntrto,				@cntdd_bnfcrs,
						    						@cdgo_pln,					@dscrpcn_pln,
													@cnsctvo_cdgo_pln,			@vlr_cbrdo,
													@cnsctvo_cnta_mnls_cntrto,	@nmro_estdo_cnta_cntrto,
													@cdgo_tpo_idntfccn,			@nmro_idntfccn,
													@prmr_Nmbre ,				@sgndo_nmbre,
													@prmr_aplldo,				@sgndo_aplldo,	
													@nombre
		End

	Close crContratoEstadoCuenta
	Deallocate crContratoEstadoCuenta

	--Consulta final del reporte del estado de cuenta
	------------------------------------------------
	-------se adicionan  los mensajes a la factura
	Declare @Mensajes		nvarchar(1000),
			@dscrpcn_mnsje	varchar(200)

	Declare		crMensajes cursor for
	select		dscrpcn_mnsje 
	from 		bdcarteraPac.dbo.tbperiodosliquidacion_vigencias	a	With(NoLock)
	inner join	bdcarteraPac.dbo.tbmensajesxPeriodo					b	With(NoLock)	on	(a.cnsctvo_cdgo_prdo_lqdcn	=	b.cnsctvo_cdgo_prdo_lqdcn)
	inner join	bdcarteraPac.dbo.tbmensajes							c	With(NoLock)	on	(b.cnsctvo_cdgo_mnsje		=	c.cnsctvo_cdgo_mnsje)
	where 		cnsctvo_cdgo_estdo_prdo 	= 	2

	Set 	@Mensajes	=	''

	open	 crMensajes
	Fetch    crMensajes into  @dscrpcn_mnsje


	While @@Fetch_status = 0
		Begin
			Set	@Mensajes	=	Ltrim(Rtrim(@Mensajes))  + ltrim(rtrim(@dscrpcn_mnsje)) + Char(13)
			Fetch crMensajes into @dscrpcn_mnsje
		End

	Close crMensajes
	Deallocate crMensajes

	Select 	a.nmro_estdo_cnta,						a.cdgo_tpo_idntfccn,								a.nmro_idntfccn ,					a.dscrpcn_clse_aprtnte,
			a.nmbre_scrsl,							a.rzn_scl,											a.ttl_fctrdo,						a.usro_crcn,
			a.cnsctvo_cdgo_lqdcn,					a.accn,												a.cnsctvo_estdo_cnta,				a.fcha_gnrcn,		
			a.nmro_unco_idntfccn_empldr,			a.cnsctvo_scrsl,									a.cnsctvo_cdgo_clse_aprtnte,		a.cnsctvo_cdgo_sde,
			a.vlr_iva,								a.sldo_fvr,											a.ttl_pgr,							a.Cts_Cnclr,
 			a.Cts_sn_Cnclr,							a.cdgo_cdd,											a.dscrpcn_cdd,						a.dscrpcn_prdo,
 			a.cdgo_prdo,							a.dscrpcn_tpo_idntfccn,								a.drccn,							a.tlfno,
 			a.cnsctvo_cdgo_prdo_lqdcn,				a.fcha_incl_fctrcn,									a.fcha_fnl_fctrcn,					a.fcha_pgo,
			a.sldo_antrr,							a.cnsctvo_cdgo_tpo_idntfccn,						a.descripcion_concepto,				a.cantidad_Concepto,
			a.valor_Concepto,						a.descripcion_concepto1,							a.cantidad_Concepto1,				a.valor_Concepto1,
			a.dscrpcn_sde,							a.nmro_Aux,											a.cdgo_sde,							b.numero_identificacion,
			b.nombre_cotizante, 					b.numero_afiliacion,								b.codigo_plan,						b.valor_contrato,
			b.cantidad_beneficiarios,				b.numero_identificacion1, 							b.nombre_cotizante1, 				b.numero_afiliacion1,
			b.codigo_plan1,							b.valor_contrato1,									b.cantidad_beneficiarios1,
			'F1'+ltrim(rtrim(a.idntfcdor_aplccn)) + ltrim(rtrim(a.cdgo_ps)) + ltrim(rtrim(a.cdgo_emprsa_iac)) + ltrim(rtrim(a.idntfccn_tpo_rcdo)) + ltrim(rtrim(a.dgto_cntrl))  +
			ltrim(rtrim(a.idntfcdor_aplccn_usro)) + right(replicate('0',8)+ltrim(rtrim(a.nmro_estdo_cnta)),8) + 'F1'+ltrim(rtrim(a.idntfcdor_aplccn_usro))	+	
			right(replicate('0',12)+ltrim(rtrim(a.nmro_idntfccn)),12) + 'F1'+ltrim(rtrim(a.idntfcdor_aplccn_usro_ia1))  +  right(replicate('0',10)+ ltrim(rtrim(convert(varchar(12),ttl_pgr))),10) + 
			'F1'+ltrim(rtrim(a.idntfcdor_aplccn_usro_ia2)) +convert(varchar(10),a.fcha_pgo,112)			Codigo_barras,
			'(' + LTRIM(RTRIM(a.idntfcdor_aplccn)) + ')' +  ltrim(rtrim(a.cdgo_ps)) + ltrim(rtrim(a.cdgo_emprsa_iac)) + ltrim(rtrim(a.idntfccn_tpo_rcdo)) + ltrim(rtrim(a.dgto_cntrl))  +
			'(' + ltrim(rtrim(a.idntfcdor_aplccn_usro)) + ')'  +  right(replicate('0',8)+ltrim(rtrim(a.nmro_estdo_cnta)),8) + '(' + ltrim(rtrim(a.idntfcdor_aplccn_usro)) + ')'  +  
			right(replicate('0',12)+ltrim(rtrim(a.nmro_idntfccn)),12) + '(' + ltrim(rtrim(a.idntfcdor_aplccn_usro_ia1))  + ')' + right(replicate('0',10)+ltrim(rtrim(convert(varchar(12),ttl_pgr))),10) + 
			'(' + ltrim(rtrim(a.idntfcdor_aplccn_usro_ia2)) + ')' + convert(varchar(10),a.fcha_pgo,112) Valor_Codigo_barras,
			@Mensajes mensaje, '' as mensaje2,
			a.fechaExpedicion,
			a.cufe,
			a.cadenaQR,
			a.totalPagarLetras 
	From 		#tmpReporteEstadocuenta			a	With(NoLock)
	Inner Join	#tmpContratos					b	With(NoLock)	On	b.cnsctvo_estdo_cnta= a.cnsctvo_estdo_cnta

	Drop Table	#tmpContratos
	Drop Table	#tmpReporteEstadocuenta
	Drop Table	#TmpContratosEstadosCuenta
	Drop Table	#tmpContratosPacEstadoscuenta
	Drop Table	#tmpContratosEstadosCuenta_aux
	Drop Table	#tmpContratosIniciales
	Drop Table	#tmpContratosRestantes
	Drop Table	#tmpEstadosCuentaConsultar
End
