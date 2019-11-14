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
* Modificado Por		: <\AM  Francisco E. Riaño L.- Qvision S.A	AM\>
* Descripcion			: <\DM	Ajustes para facturacion Electronica DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion	: <\FM  25/04/2019	 FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[spAdicionaRegistrosImpresionEstadosCuentaManual]
As 
Begin
	Set Nocount On;
	Declare		@cnsctvo_estdo_cnta							udtConsecutivo,
				@cdgo_cncpto_lqdcn							Varchar(5),
				@dscrpcn_cncpto_lqdcn						Varchar(150),
				@cdgo_pln									Varchar(2),
				@cntdd										Int,
				@vlr										Numeric(12,0),
				@lcValor									Varchar(100),
				@lcValorDecimal								Varchar(100),
				@nmro_estdo_cnta_cncpto						Varchar(15),
				@ContadorConceptos							Int,
				@nmro_cntrto								Char(15),
				@cntdd_bnfcrs								Int,
				@dscrpcn_pln								Char(150),
				@cnsctvo_cdgo_pln							udtConsecutivo,
				@vlr_cbrdo									Numeric(12,0),
				@cnsctvo_cnta_mnls_cntrto					udtConsecutivo,
				@cdgo_tpo_idntfccn							Char(3),
				@nmro_idntfccn								Varchar(20),
				@prmr_Nmbre 								Char(15),
				@sgndo_nmbre								Char(15),
				@prmr_aplldo								Char(50),
				@sgndo_aplldo								Char(50),
				@nombre										Varchar(200),
				@InicialEstadoCuenta						udtConsecutivo,
				@ContadorContratos							Int,
				@InicialNumeroEstadoCuenta					Varchar(15),
				@nmro_estdo_cnta_cntrto						udtConsecutivo,
				@fechaActual								Datetime	= getDate(),
				@consecutivoCodigoConceptoLiquidacionIva	smallint = 3,
				@consecutivoTipoDocumentoEstadoCuenta		int = 1,
				@consecutivoTipoDocumentoFactura			int = 6;

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
		cnsctvo_cdgo_prdo_lqdcn int,
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
		prefijofactura				varchar(10),
		codigocufe					varchar(max),
		vlr_en_ltrs					varchar(max),
		codigoQR					varchar(max),
		cnsctvo_cdgo_tpo_dcmnto		udtConsecutivo,
		cdgo_brrs					varchar(max)
	)
 
	-- se crea un atbla temporal con los campos de contratos que aparecen en el detalle del estado de cuenta

	Create table #tmpContratos
	(
		numero_identificacion	varchar(500),
		nombre_cotizante		varchar(2000),
		numero_afiliacion		varchar(500),
		codigo_plan				varchar(150),
		valor_contrato			varchar(500),
		cantidad_beneficiarios	varchar(100),
		numero_identificacion1	varchar(500),
		nombre_cotizante1		varchar(2000),
		numero_afiliacion1		varchar(500),
		codigo_plan1			varchar(150),
		valor_contrato1			varchar(500),
		cantidad_beneficiarios1 varchar(100),
		cnsctvo_estdo_cnta		int
	) 

	Create table #TmpContratosEstadosCuenta
	(
		cnsctvo_estdo_cnta_cntrto	int,
		cnsctvo_estdo_cnta			int,
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20),
		vlr_cbrdo					numeric(12,0),
		sldo						numeric(12,0),
		cntdd_bnfcrs				int
	)

	Create table #tmpContratosPacEstadoscuenta
	(
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20),
		cnsctvo_cdgo_pln			int,
		nmro_unco_idntfccn_afldo	int,
		cnsctvo_estdo_cnta			int
	)

	Create table #tmpContratosEstadosCuenta_aux
	(
		nmro_cntrto					varchar(20),
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
			
	Set	@ContadorConceptos	=	0

	-- se crea la tabla temporal con la informacion de los estados de cuenta que se van a imprimir

	Insert Into #tmpReporteEstadocuenta
	Select		nmro_estdo_cnta,				cdgo_tpo_idntfccn, 			nmro_idntfccn, 					dscrpcn_clse_aprtnte,
				nmbre_scrsl,					rzn_scl,					ttl_fctrdo, 					usro_crcn,		
				cnsctvo_cdgo_lqdcn,				accn,						cnsctvo_estdo_cnta, 			fcha_gnrcn, 		
				nmro_unco_idntfccn_empldr,		cnsctvo_scrsl, 				cnsctvo_cdgo_clse_aprtnte,      cnsctvo_cdgo_sde,	
				vlr_iva, 						sldo_fvr, 					ttl_pgr,	 					Cts_Cnclr, 		
				Cts_sn_Cnclr,					cdgo_cdd, 					dscrpcn_cdd, 					dscrpcn_prdo, 		
				cdgo_prdo,						dscrpcn_tpo_idntfccn, 		drccn, 							ltrim(rtrim(isnull(tlfno,''))), 	
				cnsctvo_cdgo_prdo_lqdcn,		fcha_incl_fctrcn,			dateadd(day,-1,DATEADD(month, Cts_Cnclr, fcha_incl_fctrcn) )  fcha_fnl_fctrcn, 	
				fcha_pgo, 						sldo_antrr,					cnsctvo_cdgo_tpo_idntfccn,		''  descripcion_concepto,
				''  cantidad_Concepto,			''  valor_Concepto,			''  descripcion_concepto1,		''  cantidad_Concepto1,
				''  valor_Concepto1,			dscrpcn_sde,				nmro_Aux,						cdgo_sde,
				prefijofactura,					codigocufe,					vlr_en_ltrs,					codigoQR,
				cnsctvo_cdgo_tpo_dcmnto,		cdgo_brrs
	From		#TmpImpresionEstadosCuenta_aux

	-- se crea un atbla temporal con los campos de contratos que aparecen en el detalle del estado de cuenta

	Insert Into #tmpContratos
	Select 		space(500)  numero_identificacion,
				space(2000) nombre_cotizante,
				space(500) numero_afiliacion,
				space(150) codigo_plan,
				space(500) valor_contrato,
				space(100) cantidad_beneficiarios,
				space(500)  numero_identificacion1,
				space(2000) nombre_cotizante1,
				space(500) numero_afiliacion1,
				space(150) codigo_plan1,
				space(500) valor_contrato1,
				space(100) cantidad_beneficiarios1,
				cnsctvo_estdo_cnta	  
	From 		#tmpReporteEstadocuenta


	-- se inicializan los campos de la tabla temporal
	
	Update	#tmpReporteEstadocuenta
	Set		descripcion_concepto	='',
			cantidad_Concepto		='',
			valor_Concepto			='',
			descripcion_concepto1	='',
			cantidad_Concepto1		='',
			valor_Concepto1			=''
	
	--se inicializan los campos de contratos

	Update 	#tmpContratos
	Set		numero_identificacion	='',
			nombre_cotizante		='',
			numero_afiliacion		='',
			codigo_plan				='',
			valor_contrato			='',
			cantidad_beneficiarios	=''

	Declare		crConceptosEstadoCuenta Cursor For
	Select		b.cdgo_cncpto_lqdcn, 	b.dscrpcn_cncpto_lqdcn,		c.cdgo_pln,
				a.cntdd,				a.vlr_cbrdo,				a.cnsctvo_estdo_cnta
	From 		dbo.TbEstadosCuentaConceptos 			a With(NoLock) 
	Inner Join	dbo.tbconceptosliquidacion_vigencias  	b With(NoLock) 	
		On      a.cnsctvo_cdgo_cncpto_lqdcn	=	b.cnsctvo_cdgo_cncpto_lqdcn
	Inner Join	bdplanbeneficios.dbo.tbplanes 			c With(NoLock) 	
		On		b.cnsctvo_cdgo_pln		=	c.cnsctvo_cdgo_pln
	Inner Join	#tmpReporteEstadocuenta 				d
		On		a.cnsctvo_estdo_cnta		=	d.cnsctvo_estdo_cnta
	Where		@fechaActual	between	 b.inco_vgnca	and		b.fn_vgnca
	and			b.cnsctvo_cdgo_cncpto_lqdcn != @consecutivoCodigoConceptoLiquidacionIva
	Order By	a.cnsctvo_estdo_cnta,b.dscrpcn_cncpto_lqdcn

	open		crConceptosEstadoCuenta
	Fetch		crConceptosEstadoCuenta into	@cdgo_cncpto_lqdcn,  @dscrpcn_cncpto_lqdcn,   @cdgo_pln,
												@cntdd,	          	@vlr,	                 @cnsctvo_estdo_cnta

	Set	@InicialEstadoCuenta	= @cnsctvo_estdo_cnta
	Set	@ContadorConceptos		=	0

	While @@Fetch_status = 0
	Begin
		If 	@InicialEstadoCuenta	<>	@cnsctvo_estdo_cnta
			Begin
				Set @InicialEstadoCuenta	=	@cnsctvo_estdo_cnta
				Set	@ContadorConceptos		=	0
			End
		Select @lcValor = Ltrim(Rtrim(convert(varchar(18),@vlr)))		
		Execute bdcarterapac.dbo.spFormatoDecimal 	@lcValor,	@lcValorDecimal 	Output,	 1

		Set	@ContadorConceptos	=	@ContadorConceptos	+	1
		--le cambiamos el estado para que no lo tenga en cuenta con los tbdetsaldosgeneradosnota
		If 	@ContadorConceptos	<= 10
			Begin
			Update	#tmpReporteEstadocuenta
			Set		descripcion_concepto 	= 	Ltrim(Rtrim(descripcion_concepto)) + ltrim(rtrim(@cdgo_pln)) + ' ' + Rtrim(Ltrim(@dscrpcn_cncpto_lqdcn)) + Char(13),
					cantidad_Concepto 		= 	Ltrim(Rtrim(cantidad_Concepto)) + Rtrim(Ltrim(str(@cntdd))) + Char(13),
					valor_Concepto			=	ltrim(rtrim(valor_Concepto))   +  Space(18-Len(Ltrim(Rtrim(@lcValorDecimal)))) +  ltrim(rtrim(@lcValorDecimal))+Char(13)
			Where	cnsctvo_estdo_cnta		=	@cnsctvo_estdo_cnta
			and		cnsctvo_cdgo_tpo_dcmnto = @consecutivoTipoDocumentoEstadoCuenta;

			Update	#tmpReporteEstadocuenta
			Set		descripcion_concepto 	= 	Ltrim(Rtrim(descripcion_concepto)) + Rtrim(Ltrim(@dscrpcn_cncpto_lqdcn)) + Char(13),
					cantidad_Concepto 		= 	Ltrim(Rtrim(cantidad_Concepto)) + Rtrim(Ltrim(str(@cntdd))) + Char(13),
					valor_Concepto			=	ltrim(rtrim(valor_Concepto))   +  Space(18-Len(Ltrim(Rtrim(@lcValorDecimal)))) +  ltrim(rtrim(@lcValorDecimal))+Char(13)
			Where	cnsctvo_estdo_cnta		=	@cnsctvo_estdo_cnta
			and		cnsctvo_cdgo_tpo_dcmnto = @consecutivoTipoDocumentoFactura;
			End
		Else
			Begin
			Update	#tmpReporteEstadocuenta
			Set 	descripcion_concepto1 	= 	Ltrim(Rtrim(descripcion_concepto1)) + ltrim(rtrim(@cdgo_pln)) + '  ' + Rtrim(Ltrim(@dscrpcn_cncpto_lqdcn)) + Char(13),
					cantidad_Concepto1 		= 	Ltrim(Rtrim(cantidad_Concepto1)) + Rtrim(Ltrim(str(@cntdd))) + Char(13),
					valor_Concepto1			=	ltrim(rtrim(valor_Concepto1))   +  Space(18-Len(Ltrim(Rtrim(@lcValorDecimal)))) +  ltrim(rtrim(@lcValorDecimal))+Char(13)
			Where	cnsctvo_estdo_cnta		=	@cnsctvo_estdo_cnta
			and		cnsctvo_cdgo_tpo_dcmnto = @consecutivoTipoDocumentoEstadoCuenta;

			Update	#tmpReporteEstadocuenta
			Set 	descripcion_concepto1 	= 	Ltrim(Rtrim(descripcion_concepto1)) + Rtrim(Ltrim(@dscrpcn_cncpto_lqdcn)) + Char(13),
					cantidad_Concepto1 		= 	Ltrim(Rtrim(cantidad_Concepto1)) + Rtrim(Ltrim(str(@cntdd))) + Char(13),
					valor_Concepto1			=	ltrim(rtrim(valor_Concepto1))   +  Space(18-Len(Ltrim(Rtrim(@lcValorDecimal)))) +  ltrim(rtrim(@lcValorDecimal))+Char(13)
			Where	cnsctvo_estdo_cnta		=	@cnsctvo_estdo_cnta
			and		cnsctvo_cdgo_tpo_dcmnto = @consecutivoTipoDocumentoFactura;
			End

		Fetch crConceptosEstadoCuenta into @cdgo_cncpto_lqdcn, @dscrpcn_cncpto_lqdcn,	@cdgo_pln,
											@cntdd,				@vlr,					@cnsctvo_estdo_cnta	
	End

	Close crConceptosEstadoCuenta
	Deallocate crConceptosEstadoCuenta


	--Se crea una tabla temporal con los contratos del los estados de cuenta
	Insert Into #TmpContratosEstadosCuenta
	Select		cnsctvo_estdo_cnta_cntrto,
				a.cnsctvo_estdo_cnta,
				cnsctvo_cdgo_tpo_cntrto,
				nmro_cntrto,
				vlr_cbrdo,
				sldo,
				cntdd_bnfcrs
	From 		dbo.TbEstadosCuentaContratos	a With(NoLock)
	Inner Join	#tmpReporteEstadocuenta			b
		On		(a.cnsctvo_estdo_cnta	=	b.cnsctvo_estdo_cnta)


	Insert into #tmpContratosPacEstadoscuenta
	Select		a.cnsctvo_cdgo_tpo_cntrto,
				a.nmro_cntrto,
				a.cnsctvo_cdgo_pln,
				a.nmro_unco_idntfccn_afldo,
				b.cnsctvo_estdo_cnta
	From 		bdafiliacion.dbo.tbcontratos	a  With(NoLock)
	Inner Join	#TmpContratosEstadosCuenta		b
		on		(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto				=	b.nmro_cntrto)

	Insert into #tmpContratosEstadosCuenta_aux
	Select		b.nmro_cntrto,
				a.cntdd_bnfcrs,
				f.cdgo_pln,
				f.dscrpcn_pln,
				f.cnsctvo_cdgo_pln,
				a.vlr_cbrdo,
				a.cnsctvo_estdo_cnta_cntrto,
				g.cnsctvo_estdo_cnta,
				d.cdgo_tpo_idntfccn,
				c.nmro_idntfccn,
				e.prmr_Nmbre ,
				e.sgndo_nmbre,
				e.prmr_aplldo,
				e.sgndo_aplldo,
				ltrim(rtrim(e.prmr_aplldo))  + ' ' + ltrim(rtrim(e.sgndo_aplldo)) + ' ' + ltrim(rtrim(e.prmr_Nmbre)) + ' ' + ltrim(rtrim(e.sgndo_nmbre)) nombre
	From		#TmpContratosEstadosCuenta				a 
	Inner Join	#tmpContratosPacEstadoscuenta			b
		On		(a.cnsctvo_cdgo_tpo_cntrto  =    b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto		   		=    b.nmro_cntrto
		And		a.cnsctvo_estdo_cnta		=    b.cnsctvo_estdo_cnta) 
	Inner Join	bdafiliacion.dbo.tbvinculados			c With(NoLock)
		On		(b.nmro_unco_idntfccn_afldo  	=    c.nmro_unco_idntfccn) 
	Inner Join	bdafiliacion.dbo.tbtiposidentificacion  d  With(NoLock)
		On		(c.cnsctvo_cdgo_tpo_idntfccn 	=    d.cnsctvo_cdgo_tpo_idntfccn) 
	Inner Join 	bdafiliacion.dbo.tbpersonas				e With(NoLock)
		On		(b.nmro_unco_idntfccn_afldo	=    e.nmro_unco_idntfccn) 
	Inner Join	bdplanbeneficios.dbo.tbplanes			f With(NoLock)
		On		(b.cnsctvo_cdgo_pln		=    f.cnsctvo_cdgo_pln	)  
	Inner Join 	#tmpReporteEstadocuenta					g
		On		(g.cnsctvo_estdo_cnta		=   a.cnsctvo_estdo_cnta)	


	Declare		crContratoEstadoCuenta Cursor For
	Select		nmro_cntrto,cntdd_bnfcrs,cdgo_pln,dscrpcn_pln,
				cnsctvo_cdgo_pln,vlr_cbrdo,cnsctvo_estdo_cnta_cntrto,cnsctvo_estdo_cnta,
				cdgo_tpo_idntfccn,nmro_idntfccn,prmr_Nmbre ,sgndo_nmbre,prmr_aplldo,
				sgndo_aplldo, nombre
	From		#tmpContratosEstadosCuenta_aux
	Order By	cnsctvo_estdo_cnta,cdgo_pln ,prmr_aplldo,sgndo_aplldo,prmr_Nmbre,sgndo_nmbre,nmro_cntrto	


	open		crContratoEstadoCuenta
	Fetch		crContratoEstadoCuenta into	@nmro_cntrto,				@cntdd_bnfcrs,
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
					Set	@ContadorContratos			=	0				
				End

			Select @lcValor = Ltrim(Rtrim(convert(varchar(18),@vlr_cbrdo)))		
			Execute bdcarterapac.dbo.spFormatoDecimal 	@lcValor,@lcValorDecimal 	Output , 1

			Set	@ContadorContratos	=	@ContadorContratos	+	1

			If @ContadorContratos	<= 14
				Begin
					Update		#tmpContratos
					Set 		numero_identificacion 	= 	Ltrim(Rtrim(numero_identificacion))  + ltrim(rtrim(@nmro_idntfccn)) 		+  Char(13),
								nombre_cotizante 		= 	Ltrim(Rtrim(nombre_cotizante)) 	   + Rtrim(Ltrim(@nombre)) 		+  Char(13),
								numero_afiliacion		=	ltrim(rtrim(numero_afiliacion))   	   +   ltrim(rtrim(@nmro_cntrto))		+  Char(13),
				 				codigo_plan 			= 	Ltrim(Rtrim(codigo_plan)) 	   + ltrim(rtrim(@cdgo_pln))   		+  Char(13),
								valor_contrato 			= 	Ltrim(Rtrim(valor_contrato))	   + Rtrim(Ltrim(@lcValorDecimal)) 	+  Char(13),
								cantidad_beneficiarios	=	ltrim(rtrim(cantidad_beneficiarios))    +  ltrim(rtrim(str(@cntdd_bnfcrs))) 	+ Char(13)
					Where		cnsctvo_estdo_cnta		=	@nmro_estdo_cnta_cntrto
					Insert into #tmpContratosIniciales Values (@nmro_idntfccn,@nombre,@nmro_cntrto,@cdgo_pln,@vlr_cbrdo,@cntdd_bnfcrs,@nmro_estdo_cnta_cntrto)
				End
			Else 
				Begin
				If 	 @ContadorContratos	<=28
					Begin
						Update	#tmpContratos
						Set		numero_identificacion1 	= 	Ltrim(Rtrim(numero_identificacion1))  + ltrim(rtrim(@nmro_idntfccn)) 		+  Char(13),
								nombre_cotizante1 		= 	Ltrim(Rtrim(nombre_cotizante1)) 	   + Rtrim(Ltrim(@nombre)) 		+  Char(13),
								numero_afiliacion1		=	ltrim(rtrim(numero_afiliacion1))   	   +   ltrim(rtrim(@nmro_cntrto))		+  Char(13),
						 		codigo_plan1 			= 	Ltrim(Rtrim(codigo_plan1)) 	   + ltrim(rtrim(@cdgo_pln))   		+  Char(13),
								valor_contrato1 		= 	Ltrim(Rtrim(valor_contrato1))	   + Rtrim(Ltrim(@lcValorDecimal)) 	+  Char(13),
								cantidad_beneficiarios1	=	ltrim(rtrim(cantidad_beneficiarios1))    +  ltrim(rtrim(str(@cntdd_bnfcrs))) 	+ Char(13)
						Where	cnsctvo_estdo_cnta		=	@nmro_estdo_cnta_cntrto
						Insert into #tmpContratosIniciales Values (@nmro_idntfccn,@nombre,@nmro_cntrto,@cdgo_pln,@vlr_cbrdo,@cntdd_bnfcrs,@nmro_estdo_cnta_cntrto)
					End
				--ELSE
				--	-- se inserta en una tabla temporal donde contiene todos los  contratos anexos al estado de cuenta que se generan
				--	-- en otro archivo
				--	Begin
				--		Insert into #tmpContratosRestantes Values (@nmro_idntfccn,@nombre,@nmro_cntrto,@cdgo_pln,@vlr_cbrdo,@cntdd_bnfcrs,@nmro_estdo_cnta_cntrto)		
				--	End
				END
			Insert into #tmpContratosRestantes Values (@nmro_idntfccn,@nombre,@nmro_cntrto,@cdgo_pln,@vlr_cbrdo,@cntdd_bnfcrs,@nmro_estdo_cnta_cntrto)

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
	Declare @Mensajes		nvarchar(1000) = '',
			@dscrpcn_mnsje	varchar(200)

	Declare		crMensajes Cursor For
	Select		dscrpcn_mnsje 
	From 		dbo.tbperiodosliquidacion_vigencias a With(NoLock)
	Inner Join 	dbo.tbmensajesxPeriodo				b With(NoLock)
		On		(a.cnsctvo_cdgo_prdo_lqdcn	=	b.cnsctvo_cdgo_prdo_lqdcn) 
	Inner Join	dbo.tbmensajes						c With(NoLock)
		On		(b.cnsctvo_cdgo_mnsje		=	c.cnsctvo_cdgo_mnsje)
	Where 		cnsctvo_cdgo_estdo_prdo 	= 	2

	open	 crMensajes
	Fetch    crMensajes into  @dscrpcn_mnsje


	While @@Fetch_status = 0
		Begin
			Set	@Mensajes	=	@Mensajes  + ltrim(rtrim(@dscrpcn_mnsje))+ ' '
			Fetch crMensajes into @dscrpcn_mnsje
		End

	Close crMensajes
	Deallocate crMensajes

	Set  @Mensajes = ltrim(rtrim(@Mensajes));

	Select 	a.nmro_estdo_cnta,
			a.cdgo_tpo_idntfccn,
			a.nmro_idntfccn ,
			a.dscrpcn_clse_aprtnte,
			a.nmbre_scrsl,
			a.rzn_scl,
			a.ttl_fctrdo,
			a.usro_crcn,
			a.cnsctvo_cdgo_lqdcn,
			a.accn,
			a.cnsctvo_estdo_cnta,
			a.fcha_gnrcn,		
			a.nmro_unco_idntfccn_empldr,
			a.cnsctvo_scrsl	,
			a.cnsctvo_cdgo_clse_aprtnte, 
			a.cnsctvo_cdgo_sde,
			a.vlr_iva,
			a.sldo_fvr,
			a.ttl_pgr,
			a.Cts_Cnclr,
 			a.Cts_sn_Cnclr,
 			a.cdgo_cdd,
 			a.dscrpcn_cdd,
 			a.dscrpcn_prdo,
 			a.cdgo_prdo,
 			a.dscrpcn_tpo_idntfccn,
 			a.drccn,
 			a.tlfno,
 			a.cnsctvo_cdgo_prdo_lqdcn,
 			a.fcha_incl_fctrcn,
 			a.fcha_fnl_fctrcn,
 			a.fcha_pgo,
			a.sldo_antrr,
			a.cnsctvo_cdgo_tpo_idntfccn,
			a.descripcion_concepto,
			a.cantidad_Concepto,
			a.valor_Concepto,
			a.descripcion_concepto1,
			a.cantidad_Concepto1,
			a.valor_Concepto1,
			a.dscrpcn_sde,
			a.nmro_Aux,
			a.cdgo_sde, 
			b.numero_identificacion,	 
			b.nombre_cotizante, 	
			b.numero_afiliacion,
			b.codigo_plan,	
			b.valor_contrato,		
			b.cantidad_beneficiarios,
			b.numero_identificacion1, 		
			b.nombre_cotizante1, 	
			b.numero_afiliacion1,
			b.codigo_plan1,	
			b.valor_contrato1,	
			b.cantidad_beneficiarios1,
			'F1'+
			ltrim(rtrim(c.idntfcdor_aplccn)) + ltrim(rtrim(c.cdgo_ps)) + ltrim(rtrim(c.cdgo_emprsa_iac)) + ltrim(rtrim(c.idntfccn_tpo_rcdo)) + ltrim(rtrim(c.dgto_cntrl))  +
			ltrim(rtrim(c.idntfcdor_aplccn_usro)) + 
			right(replicate('0',8)+ltrim(rtrim(a.nmro_estdo_cnta)),8) + 
			'F1'+
			ltrim(rtrim(c.idntfcdor_aplccn_usro))	+	
			right(replicate('0',12)+ltrim(rtrim(a.nmro_idntfccn)),12) + 
			'F1'+
			ltrim(rtrim(c.idntfcdor_aplccn_usro_ia1))  +  
			right(replicate('0',10)+ ltrim(rtrim(convert(varchar(12),ttl_pgr))),10) + 
			'F1'+
			ltrim(rtrim(c.idntfcdor_aplccn_usro_ia2)) +
			convert(varchar(10),a.fcha_pgo,112)      Codigo_barras,
			--'(' + LTRIM(RTRIM(c.idntfcdor_aplccn)) + ')' +  ltrim(rtrim(c.cdgo_ps)) + ltrim(rtrim(c.cdgo_emprsa_iac)) + ltrim(rtrim(c.idntfccn_tpo_rcdo)) + ltrim(rtrim(c.dgto_cntrl))  +
			--'(' + ltrim(rtrim(c.idntfcdor_aplccn_usro)) + ')'  +  
			--right(replicate('0',8)+ltrim(rtrim(a.nmro_estdo_cnta)),8) + 
			--'(' + ltrim(rtrim(c.idntfcdor_aplccn_usro)) + ')'  +  
			--right(replicate('0',12)+ltrim(rtrim(a.nmro_idntfccn)),12) + 
			-- '(' + ltrim(rtrim(c.idntfcdor_aplccn_usro_ia1))  + ')' +
			--right(replicate('0',10)+ltrim(rtrim(convert(varchar(12),ttl_pgr))),10) + 
			--'(' + ltrim(rtrim(c.idntfcdor_aplccn_usro_ia2)) + ')' + convert(varchar(10),a.fcha_pgo,112)      Valor_Codigo_barras,
			a.cdgo_brrs  Valor_Codigo_barras, 
			@Mensajes mensaje,
			a.prefijofactura,
			a.codigocufe,
			a.vlr_en_ltrs,
			a.codigoQR,
			a.cnsctvo_cdgo_tpo_dcmnto
	From 	#tmpReporteEstadocuenta  a, #tmpContratos b ,  dbo.TbEstructuraCodigoBarras_vigencias  c
	Where 	a.cnsctvo_estdo_cnta= b.cnsctvo_estdo_cnta
	And		@fechaActual 	between 	c.inco_vgnca 	and 	c. fn_vgnca
	And		cnsctvo_vgnca_estrctra_cdgo_brrs = 1    -- consecutivo del  codigo de barras

End