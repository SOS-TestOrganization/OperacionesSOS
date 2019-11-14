/*---------------------------------------------------------------------------------
* Metodo o PRG 		:  spGrabarNotaCreditoFE
* Desarrollado por	: <\A Francisco E. Riaño L. - Qvision S.A							A\>
* Descripcion		: <\D Este procedimiento permite grabar una nota credito de la pantalla de notas
							crédito Facturación	D\>
* Observaciones		: <\O  	O\>
* Parametros		: <\P	P\>
* Variables			: <\V  	V\>
* Fecha Creacion	: <\FC 2019/08/05 FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion	: <\FM  FM\>
* ----------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[spGrabarNotaCreditoFE](
		@lcTipoNota							udtConsecutivo,
		@lnTipoAplicacion					udtConsecutivo,	
		@lnValorIvaEstadoCuenta				numeric(12,3),
		@cnsctvo_estdo_cnta					udtConsecutivo,
		@lnValorTotalNota					udtValorGrande,
		@lcObservaciones					varchar(500),
		@nmro_unco_idntfccn_empldr			udtconsecutivo,
		@cnsctvo_scrsl						udtconsecutivo,
		@cnsctvo_cdgo_clse_aprtnte			udtconsecutivo,	
		@lcUsuario							udtUsuario,
		@lnSldoEstadoCuenta					udtValorGrande,
		@lntipoDocumento					int,
		@lnProcesoExitoso					int		output,
		@lcMensaje							char(200)	output,
		@nmro_nta							Varchar(15)	output,
		@cnsctvo_cdgo_prdo_lqdcn			int,
		@lnconsecutivoCodigoEstadoNota		udtconsecutivo,
		@consecutivoCodigoConceptoLiquidacion udtconsecutivo
)
As	
Begin
	Set Nocount On;
	
	Declare		@vlr_actl											int,
				@vlr_antrr											int,
				@cnsctvo_cdgo_tpo_aplccn_nta						udtconsecutivo,
				@lnConsecutivoCodigoPeriodoLiquidacion				udtconsecutivo,
				@ldFechaSistema										datetime = Getdate(),	
				@ldFechaEvaluarPeriodo								datetime,
				@lnNumeroPeriodosEvaluados							int,
				@lnMax_cnsctvo_estdo_nta							udtconsecutivo,
				@lnMax_Cnsctvo_nta_cncpto							udtconsecutivo,
				@lnMax_cnsctvo_nta_cntrto							udtconsecutivo,
				@Valor_iva_nota										udtValorGrande,
				@NuevoSaldoEstadoCuenta								udtValorGrande,
				@Valor_saldo_nota									udtValorGrande,
				@lnValorInicialSaldoNota							udtValorGrande = 0,
				@Valor_Porcentaje_Iva								udtValorDecimales,
				@MaximoConsecutivoContrato							udtConsecutivo,
				@MaximoConsecutivoResponsable						udtConsecutivo,
				@EstadoEstadoCuentaCanceladoParcial					udtConsecutivo = 2,
				@EstadoEstadoCuentaCanceladoTotal					udtConsecutivo = 3,
				@Cantidad_Contratos_Pac								int = 0,
				@lnCambioSaldoEstadoCuenta							int,
				@lnSumSaldocontrato									udtValorGrande,
				@cnsctvo_nta_aplcda_max								int,	
				@lnTipoDocumentoFactura								int = 6,
				@lnTipo												int,
				@lnConsecutivoTipoAplicacionNotaAhora				udtConsecutivo = 1,
				@lnConsecutivoTipoAplicacionNotaProximoPeriodo		udtConsecutivo = 2,
				@lnConsecutivoTipoNotaCredito						udtConsecutivo = 2,
				@lnConsecutivoCodigoTipoDocumentoFeIngresado		udtConsecutivo = 1,
				@lnConsecutivoCodigoTipoDocEstadoCuenta				udtConsecutivo,
				@consecutivoCodigoConceptoDianOtros					smallint = 9,
				@consecutivoCodigoConceptoDianAnulacion				smallint = 5;

	-- Creacion de tablas temporales
	Create table #TMPConceptoNotaDebitoFinal
	(	nmro_rgstro					int IDENTITY(1,1), 
		nmro_nta					varchar(15),
		cnsctvo_cdgo_tpo_nta		int,
		cnsctvo_cdgo_cncpto_lqdcn	int,
		vlr_nta						numeric(12,0),
		cnsctvo_cdgo_autrzdr_espcl	int,
		cnsctvo_nta_cncpto			int
	)

	Create table #tmpContratosResponsableTotal
	(	cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20),
		cnsctvo_estdo_cnta_cntrto	int,
		vlr							numeric(12,0)
	)

	Create table #TMPcontratosresponsableFinal
	(	nmro_rgstro					int IDENTITY(1,1), 
		nmro_nta					varchar(15),
		cnsctvo_cdgo_tpo_nta		int,
		cnsctvo_estdo_cnta_cntrto	int,
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20),
		vlr							numeric(12,0)
	)

	Create table #tmpnotasContratoxConcepto
	(	cnsctvo_nta_cntrto			int,
		Valor						numeric(12,0),
		Cnsctvo_nta_cncpto			int,
		cnsctvo_cdgo_cncpto_lqdcn	int
	)

	Create table #tmpConsecutivoAbonos
	(
		id_tabla UdtConsecutivo
	)

	if object_id('tempdb..#TMPcontratosresponsable') IS NULL
	begin
		
		Create table #TMPcontratosresponsable
		(
		cnsctvo_estdo_cnta					udtConsecutivo,
		nmro_unco_idntfccn_empldr			udtConsecutivo,
		cnsctvo_scrsl						udtConsecutivo,
		cnsctvo_cdgo_clse_aprtnte			udtConsecutivo,
		ttl_fctrdo							udtValorGrande,
		vlr_iva								udtValorGrande,
		ttl_pgr								udtValorGrande,
		nmro_estdo_cnta						varchar(15),
		cnsctvo_cdgo_tpo_cntrto				udtConsecutivo,
		nmro_cntrto							udtNumeroFormulario,
		nmbre_afldo							varchar(200),
		nmbre_scrsl							varchar(200),
		rzn_scl								varchar(200),
		dgto_vrfccn							int,
		nmro_idntfccn_empldr				varchar(20),
		cdgo_tpo_idntfccn_empldr			varchar(3),
		cnsctvo_cdgo_tpo_idntfccn_Empldr	int,	
		cdgo_tpo_idntfccn					udtTipoIdentificacion,
		nmro_idntfccn						udtNumeroIdentificacionLargo,
		accn								varchar(15),
		cnsctvo_cdgo_pln					udtConsecutivo,
		nmro_unco_idntfccn_afldo			udtConsecutivo,
		cnsctvo_cdgo_estdo_estdo_cnta		udtConsecutivo,
		sldo_estdo_cnta						udtValorGrande,
		vlr_cbrdo_cntrto					udtValorGrande,
		sldo_cntrto							udtValorGrande,
		cnsctvo_estdo_cnta_cntrto			udtConsecutivo,	
		fcha_crcn_nta						datetime,
		cnsctvo_cdgo_lqdcn					udtConsecutivo,
		cnsctvo_cdgo_prdo_lqdcn				udtConsecutivo,
		dscrpcn_prdo_lqdcn					varchar(200),
		fcha_incl_prdo_lqdcn				datetime,
		valor								numeric(12,0),
		cnsctvo_cdgo_cncpto_lqdcn			udtConsecutivo
		)

		declare @nmro_estdo_cnta varchar(15);
		select	@nmro_estdo_cnta = nmro_estdo_cnta 
		from	dbo.tbEstadosCuenta 
		where	cnsctvo_estdo_cnta = @cnsctvo_estdo_cnta;
		
		insert 
		into	#TMPcontratosresponsable
				(
				cnsctvo_estdo_cnta,			
				nmro_unco_idntfccn_empldr,		
				cnsctvo_scrsl,
				cnsctvo_cdgo_clse_aprtnte,		
				ttl_fctrdo,				
				vlr_iva,
				ttl_pgr,				
				nmro_estdo_cnta,			
				cnsctvo_cdgo_tpo_cntrto,
				nmro_cntrto,				
				nmbre_afldo,				
				nmbre_scrsl,
				rzn_scl,				
				dgto_vrfccn,				
				nmro_idntfccn_empldr,
				cdgo_tpo_idntfccn_empldr,		
				cnsctvo_cdgo_tpo_idntfccn_Empldr,	
				cdgo_tpo_idntfccn,
				nmro_idntfccn,				
				accn,					
				cnsctvo_cdgo_pln,
				nmro_unco_idntfccn_afldo,		
				cnsctvo_cdgo_estdo_estdo_cnta,		
				sldo_estdo_cnta,
				vlr_cbrdo_cntrto,			
				sldo_cntrto,				
				cnsctvo_estdo_cnta_cntrto,
				fcha_crcn_nta,
				cnsctvo_cdgo_lqdcn,		
				cnsctvo_cdgo_prdo_lqdcn,		
				dscrpcn_prdo_lqdcn,
				fcha_incl_prdo_lqdcn
				)
		exec	bdcarterapac.dbo.SpConsultaContratosEstadoCuenta @nmro_estdo_cnta;

		update	#TMPcontratosresponsable
		set		valor = @lnValorTotalNota;
	end

	
	if object_id('tempdb..#TMPConceptoNotaDebito') IS NULL
	begin
		Create 
		table		#TMPConceptoNotaDebito
					(
					cdgo_cncpto_lqdcn char(5), 	
					dscrpcn_cncpto_lqdcn udtDescripcion,
					valor numeric(12,0),
					cnsctvo_cdgo_pln udtConsecutivo,
					cnsctvo_cdgo_tpo_mvmnto udtConsecutivo,
					oprcn udtConsecutivo, 
					slcta_atrzdr char(1), 		
					cnsctvo_cdgo_autrzdr_espcl udtConsecutivo,
					cnsctvo_cdgo_cncpto_lqdcn udtConsecutivo,
					cnsctvo_cdgo_bse_aplcda	udtConsecutivo	
					)

		declare		@consecutivoPlan udtConsecutivo;
		select 
		top 1		@consecutivoPlan = cnsctvo_cdgo_pln 
		from		#TMPcontratosresponsable;

		insert into #TMPConceptoNotaDebito
					(
					cdgo_cncpto_lqdcn, 	
					dscrpcn_cncpto_lqdcn,
					valor,
					cnsctvo_cdgo_pln,
					cnsctvo_cdgo_tpo_mvmnto,
					oprcn, 
					slcta_atrzdr, 		
					cnsctvo_cdgo_autrzdr_espcl,
					cnsctvo_cdgo_cncpto_lqdcn,
					cnsctvo_cdgo_bse_aplcda	
					)
		exec		dbo.SpTraerConceptosXTipoMovimiento 1,@consecutivoPlan;	

		update		b
		set			b.valor = a.valor
		from		#TMPcontratosresponsable a
		inner join	#TMPConceptoNotaDebito b
		on			a.cnsctvo_cdgo_pln = b.cnsctvo_cdgo_pln;
	end

	If	@lnTipoAplicacion =	@lnConsecutivoTipoAplicacionNotaAhora
	Begin		
					
		Select		@lnSumSaldocontrato			=	sum(isnull(b.sldo,0))
		From		bdcarteraPac.dbo.TbestadosCuenta a with(nolock)
		inner join	bdcarteraPac.dbo.tbestadoscuentacontratos b with(nolock)
			on		(a.cnsctvo_estdo_cnta		=	b.cnsctvo_estdo_cnta)
		Where		a.cnsctvo_estdo_cnta		=	@cnsctvo_estdo_cnta
		And			isnull(b.sldo,0)			>	0

		If 	@lnSumSaldocontrato	 		!=	@lnSldoEstadoCuenta
		Begin 
			Set	@lnProcesoExitoso	=	1
			Set	@lcMensaje		=	'Error el Saldo del Estado cuenta Cambio por favor vuelva a consultarlo'
			Return -1
		End	
	End

	Select	@ldFechaEvaluarPeriodo = fcha_incl_prdo_lqdcn 
	From	dbo.tbPeriodosliquidacion_Vigencias with(nolock)
	Where	cnsctvo_cdgo_prdo_lqdcn = @cnsctvo_cdgo_prdo_lqdcn

	
	Set	@cnsctvo_cdgo_tpo_aplccn_nta =	@lnTipoAplicacion
	Set	@lnProcesoExitoso			 =	0
	Set	@Valor_Porcentaje_Iva		 =	0

	-- trae el valor del porcentaje  para aplicar
	Select 	@Valor_Porcentaje_Iva = prcntje
	From	dbo.tbconceptosliquidacion_vigencias with(nolock)
	where   cnsctvo_cdgo_cncpto_lqdcn	=	3
	And		@ldFechaEvaluarPeriodo  between inco_vgnca	and 	fn_vgnca

	If  @Valor_Porcentaje_Iva	=	0
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'No existe parametrizacion de iva para procesar'
		Return -1
	end	

	Set	@Valor_Porcentaje_Iva		=	@lnValorIvaEstadoCuenta;

	Select  @lnValorTotalNota = sum(convert(numeric(12,0), (valor * 100))    / convert(numeric(12,0), (100 + @Valor_Porcentaje_Iva ))) ,
			@Valor_iva_nota	= sum(convert(numeric(12,0), (valor * @Valor_Porcentaje_Iva)) /  convert(numeric(12,0), (100 + @Valor_Porcentaje_Iva )))
	From	#TMPcontratosresponsable
	Where	valor	>	0;

	IF	@lnTipoAplicacion =	@lnConsecutivoTipoAplicacionNotaAhora
	Begin
		Set @Valor_saldo_nota =	@lnValorTotalNota	+	@Valor_iva_nota;
	End
	Else
	Begin
		Set @Valor_saldo_nota			=	@lnValorTotalNota;
		Set	@lnValorInicialSaldoNota	=	@lnValorTotalNota	+	@Valor_iva_nota;
	End

	Set @lnConsecutivoCodigoPeriodoLiquidacion = @cnsctvo_cdgo_prdo_lqdcn

	Begin Tran 

	Set	@nmro_nta	 = convert(varchar(15),next value for dbo.SeqNumeroNotasCredito)

	Select	@lnConsecutivoCodigoTipoDocEstadoCuenta	=	cnsctvo_cdgo_tpo_dcmnto
	From	dbo.tbestadoscuenta with(nolock)
	Where	cnsctvo_estdo_cnta	= @cnsctvo_estdo_cnta

	Insert into dbo.TbNotasPac	
	(	
		nmro_nta,		
		cnsctvo_cdgo_tpo_nta,		
		cnsctvo_cdgo_tpo_dcmnto_orgn,
		cnsctvo_estdo_cnta,
		vlr_nta,
		vlr_iva,			
		sldo_nta,			
		cnsctvo_prdo,
		fcha_crcn_nta,		
		cnsctvo_cdgo_estdo_nta,		
		cnsctvo_cdgo_tpo_aplccn_nta,
		obsrvcns,		
		usro_crcn,			
		nmro_unco_idntfccn_empldr,
		cnsctvo_scrsl,		
		cnsctvo_cdgo_clse_aprtnte, 
		fcha_prdo_nta, 
		cnsctvo_cdgo_estdo_dcmnto_fe,
		cnsctvo_cdgo_cncpto_dn
	) 
	Values	
	(	
		@nmro_nta,		
		@lcTipoNota,	
		@lnConsecutivoCodigoTipoDocEstadoCuenta,
		@cnsctvo_estdo_cnta,
		@lnValorTotalNota,
		@Valor_iva_nota,	
		@lnValorInicialSaldoNota,	
		@lnConsecutivoCodigoPeriodoLiquidacion,					
		@ldFechaSistema,	
		@lnconsecutivoCodigoEstadoNota,	
		@cnsctvo_cdgo_tpo_aplccn_nta,
		@lcObservaciones,	
		@lcUsuario,			
		@nmro_unco_idntfccn_empldr,
		@cnsctvo_scrsl,		
		@cnsctvo_cdgo_clse_aprtnte, 
		@ldFechaEvaluarPeriodo,
		@lnConsecutivoCodigoTipoDocumentoFeIngresado,
		@consecutivoCodigoConceptoDianOtros
	)

	If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error creando la nota'
		Rollback tran 
		Return -1
	end	

	--Se consulta el numero siguiente del concepto y nota 

	Select 	@lnMax_Cnsctvo_nta_cncpto	=	 isnull(max(Cnsctvo_nta_cncpto),0)	 
	From	dbo.tbNotasConceptos

	-- se crea una tabla temporal con un contador  para que de esta forma poder asociar de una forma mas facil
	-- el consecutivo del registro en tbnotasconceptos

	Insert into	#TMPConceptoNotaDebitoFinal
	Select	@nmro_nta	nmro_nta,
			@lcTipoNota	cnsctvo_cdgo_tpo_nta,
			isnull(@consecutivoCodigoConceptoLiquidacion,cnsctvo_cdgo_cncpto_lqdcn),
			valor		vlr_nta,
			cnsctvo_cdgo_autrzdr_espcl,
			0	cnsctvo_nta_cncpto
	From	#TMPConceptoNotaDebito
	Where	valor		>	0


	--Se graba los conceptos de la nota debito
	Insert into dbo.tbNotasConceptos 
	(
		Cnsctvo_nta_cncpto,
		nmro_nta,
		cnsctvo_cdgo_tpo_nta,
		cnsctvo_cdgo_cncpto_lqdcn,
		vlr_nta
	)
	Select 	(nmro_rgstro + @lnMax_Cnsctvo_nta_cncpto),
			nmro_nta,
			cnsctvo_cdgo_tpo_nta,
			cnsctvo_cdgo_cncpto_lqdcn,
			vlr_nta
	From	#TMPConceptoNotaDebitoFinal

	If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error insertando el concepto por nota'
		Rollback tran 
		Return -1
	end	

	Update		a
	Set			cnsctvo_nta_cncpto		=	b.cnsctvo_nta_cncpto
	From		#TMPConceptoNotaDebitoFinal	a 
	inner join	dbo.tbNotasConceptos		b with(nolock)
		on		(a.cnsctvo_cdgo_cncpto_lqdcn	=	b.cnsctvo_cdgo_cncpto_lqdcn)
	Where		b.nmro_nta				=	@nmro_nta
	And			b.cnsctvo_cdgo_tpo_nta	=	@lcTipoNota

	Insert	into dbo.tbautorizacionesnotas
	(
		cnsctvo_nta_cncpto,
		cnsctvo_cdgo_autrzdr_espcl
	)
	Select	cnsctvo_nta_cncpto,
			cnsctvo_cdgo_autrzdr_espcl	
	From	#TMPConceptoNotaDebitoFinal
	Where	cnsctvo_cdgo_autrzdr_espcl	>	0

	If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error insertando los autorizadores  por nota'
		Rollback tran 
		Return -1
	end	

	--Se calcula el valor maximo de cada contrato
	Insert 	into	#tmpContratosResponsableTotal
	Select 			cnsctvo_cdgo_tpo_cntrto,
					nmro_cntrto,
					cnsctvo_estdo_cnta_cntrto,
					Sum(valor)		vlr
	From			#TMPcontratosresponsable
	Group by		cnsctvo_cdgo_tpo_cntrto,
					nmro_cntrto,	cnsctvo_estdo_cnta_cntrto

	-- se crea la tabla temporal de l valor total por cada contrato  para controlar el numero del consecutivo
	Insert 	into	#TMPcontratosresponsableFinal
	Select			@nmro_nta		nmro_nta,
					@lcTipoNota		cnsctvo_cdgo_tpo_nta,
					cnsctvo_estdo_cnta_cntrto,
					cnsctvo_cdgo_tpo_cntrto,
					nmro_cntrto,
					convert(numeric(12,3),vlr)	vlr
	From			#tmpContratosResponsableTotal
	Where			Vlr	>	0

	-- se busca el maximo del consecutivo nota contrato
	Select 	@lnMax_cnsctvo_nta_cntrto	=	 isnull(max(cnsctvo_nta_cntrto),0)	 
	From	dbo.tbnotasContrato with(nolock)

	-- se inserta la informacion a nivel de contrato de la nota
	insert into	 dbo.TbnotasContrato
	(
		cnsctvo_nta_cntrto,
		nmro_nta,
		cnsctvo_cdgo_tpo_nta,
		cnsctvo_estdo_cnta_cntrto,
		cnsctvo_cdgo_tpo_cntrto,
		nmro_cntrto,
		vlr,
		vlr_iva,
		sldo_nta_cntrto,
		fcha_ultma_mdfccn,
		usro_ultma_mdfccn
	)
	Select 	(nmro_rgstro + @lnMax_cnsctvo_nta_cntrto),
			nmro_nta,
			cnsctvo_cdgo_tpo_nta,
			cnsctvo_estdo_cnta_cntrto,
			cnsctvo_cdgo_tpo_cntrto,
			nmro_cntrto,
			convert(numeric(12,0), (vlr * 100))    / convert(numeric(12,0), (100 + @Valor_Porcentaje_Iva )) ,
			convert(numeric(12,0), (vlr * @Valor_Porcentaje_Iva)) /  convert(numeric(12,0), (100 + @Valor_Porcentaje_Iva )),
			case when @lnTipoAplicacion	=	@lnConsecutivoTipoAplicacionNotaAhora then  0 
				else convert(numeric(12,0), (vlr * 100))    / convert(numeric(12,0), (100 + @Valor_Porcentaje_Iva )) + convert(numeric(12,0), (vlr * @Valor_Porcentaje_Iva)) /  convert(numeric(12,0), (100 + @Valor_Porcentaje_Iva )) End,				
			@ldFechaSistema,
			@lcUsuario
	From	#TMPcontratosresponsableFinal

	If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error insertando los contratos por nota'
		Rollback tran 
		Return -1
	end	

	-- Se crea una tabla temporal con la informacion  del valor de cada concepto para cada contrato
	-- y luego poder actualizar el concpeto asociadoa a la nota

	Insert Into #tmpnotasContratoxConcepto	
	Select		b.cnsctvo_nta_cntrto,
				a.Valor,
				0	Cnsctvo_nta_cncpto,
				cnsctvo_cdgo_cncpto_lqdcn
	From		#TMPcontratosresponsable	a 
	inner join	dbo.TbnotasContrato			b with(nolock)
		on		(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto	=	b.nmro_cntrto)
	Where		b.nmro_nta			=	@nmro_nta
	And			b.cnsctvo_cdgo_tpo_nta	=	@lcTipoNota
	And			a.valor	>	0

	-- actualiza el valor del concepto por nota
	Update 		#tmpnotasContratoxConcepto
	Set			Cnsctvo_nta_cncpto	 =	b.Cnsctvo_nta_cncpto
	From		#tmpnotasContratoxConcepto	a 
	inner join	dbo.tbNotasConceptos		b with(nolock)
		on		(a.cnsctvo_cdgo_cncpto_lqdcn =	b.cnsctvo_cdgo_cncpto_lqdcn)
	Where		b.nmro_nta				=	@nmro_nta
	And			b.cnsctvo_cdgo_tpo_nta	=	@lcTipoNota 

	-- se inserta la informacion de cada contrato y cada concepto
	insert into	dbo.tbnotasContratoxConcepto	
	(
		cnsctvo_nta_cntrto,
		cnsctvo_nta_cncpto,
		vlr,
		vlr_ants_iva,
		vlr_iva
	)
	Select	cnsctvo_nta_cntrto,
			Cnsctvo_nta_cncpto,
			valor,
			0,
			0
	From	#tmpnotasContratoxConcepto

	If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error insertando contrato del concepto de la nota'
		Rollback tran 
		Return -1
	end	
	
	Insert into dbo.tbnotasestadocuenta	
	(
		nmro_nta,       
		cnsctvo_cdgo_tpo_nta,	 
		cnsctvo_estdo_cnta, 	
		vlr,		
		fcha_aplccn,  
		usro_aplccn
	)
	Values	
	(
		@nmro_nta,	
		@lcTipoNota,	
		@cnsctvo_estdo_cnta,	
		(@lnValorTotalNota+@Valor_iva_nota),	
		@ldFechaSistema,
		@lcUsuario  
	)

	If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error insertando la nota del estado cuenta'
		Rollback tran 
		Return -1
	end	

	-- se disminuye el saldo de los contratos  del estado de cuenta
	Update		a
	Set			sldo				=	a.sldo	-	(b.vlr + b.vlr_iva),-- se debe de colocar incluido el iva b.vlr
				fcha_ultma_mdfccn	=	@ldFechaSistema,
				usro_ultma_mdfccn	=	@lcUsuario
	From		dbo.tbestadoscuentacontratos	a 
	inner join	dbo.tbnotascontrato				b with(nolock)
		on		(a.cnsctvo_estdo_cnta_cntrto =	b.cnsctvo_estdo_cnta_cntrto)
	Where		b.nmro_nta			=	@nmro_nta
	And			b.cnsctvo_cdgo_tpo_nta		=	@lcTipoNota

	If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error Actualizando el  saldo del contrato del estado cuenta'
		Rollback tran 
		Return -1
	end	

	--Se verifica el nuevo saldo
	Select	@NuevoSaldoEstadoCuenta	=	sldo_estdo_cnta	- @Valor_saldo_nota
	From	dbo.tbestadoscuenta with(nolock)
	Where	cnsctvo_estdo_cnta	= @cnsctvo_estdo_cnta

	Update	a
	Set		a.sldo_estdo_cnta	=	a.sldo_estdo_cnta - @Valor_saldo_nota
	From	dbo.tbestadoscuenta a
	Where	cnsctvo_estdo_cnta	=	@cnsctvo_estdo_cnta

	If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error Actualizando el  saldo del estado de cuenta'
		Rollback tran 
		Return -1
	end	

	Update	a
	Set		a.cnsctvo_cdgo_estdo_estdo_cnta	= case 
												when sldo_estdo_cnta <= 0 then  @EstadoEstadoCuentaCanceladoTotal 
												else @EstadoEstadoCuentaCanceladoParcial 
											  end
	From	dbo.tbestadoscuenta a
	Where	cnsctvo_estdo_cnta	=	@cnsctvo_estdo_cnta

	If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error Actualizando el  saldo del estado de cuenta'
		Rollback tran 
		Return -1
	end	

	If	@NuevoSaldoEstadoCuenta	=	0
	-- se actualiza el estado del estado de cuenta	 a cancelado total
	Begin
		Update 	a
		Set		a.cnsctvo_cdgo_estdo_estdo_cnta	= @EstadoEstadoCuentaCanceladoTotal
		From	dbo.tbestadoscuenta a 
		Where	cnsctvo_estdo_cnta	= @cnsctvo_estdo_cnta

		Update	a 
		Set		a.cnsctvo_cdgo_cncpto_dn = @consecutivoCodigoConceptoDianAnulacion
		From	dbo.tbNotasPac a
		Where   a.nmro_nta = @nmro_nta

		If  @@error!=0  
		Begin 
			Set	@lnProcesoExitoso	=	1
			Set	@lcMensaje		=	'Error Actualizando el  estado del estado de cuenta'
			Rollback tran 
			Return -1
		end	
	End

	--Grabar Pagos

	If	@lnTipoAplicacion	=	@lnConsecutivoTipoAplicacionNotaAhora	
	Begin
		Insert into dbo.tbPagosNotas	
		(
			nmro_nta,       
			cnsctvo_cdgo_tpo_nta,	 	
			vlr
		)
		Values	
		(
			@nmro_nta,	
			@lcTipoNota,	
			(@lnValorTotalNota+@Valor_iva_nota)
		)

		If  @@error!=0  
		Begin 
			Set	@lnProcesoExitoso	=	1
			Set	@lcMensaje		=	'Error insertando Pagos Notas'
			Rollback tran 
			Return -1
		end	

		Insert into dbo.tbAbonosNotasContrato	
		(       
			cnsctvo_nta_cntrto,	 
			vlr_nta_cta, 	
			vlr_nta_iva
		)
		Select	
				cnsctvo_nta_cntrto,
				a.vlr,
				convert(numeric(12,0), (a.vlr * @Valor_Porcentaje_Iva)) /  convert(numeric(12,0), (100 + @Valor_Porcentaje_Iva ))
		From	dbo.tbnotascontrato				a with(nolock)
		where	a.nmro_nta = @nmro_nta

		If  @@error!=0  
		Begin 
			Set	@lnProcesoExitoso	=	1
			Set	@lcMensaje		=	'Error insertando Abonos Notas Contrato'
			Rollback tran 
			Return -1
		end	

		Insert into dbo.tbAbonos 
		(
			cnsctvo_estdo_cnta,
			vlr_abno,
			nmro_nta,
			cnsctvo_cdgo_tpo_nta,
			fcha_crcn				
		)
		Output inserted.cnsctvo_abno into #tmpConsecutivoAbonos(id_tabla)
		Values
		(
			@cnsctvo_estdo_cnta,
			(@lnValorTotalNota+@Valor_iva_nota),
			@nmro_nta,
			@lnConsecutivoTipoNotaCredito,
			@ldFechaSistema
		)

		If  @@error!=0  
		Begin 
			Set	@lnProcesoExitoso	=	1
			Set	@lcMensaje		=	'Error insertando Abonos'
			Rollback tran 
			Return -1
		end	

		Insert into dbo.tbAbonosContrato
		(
			cnsctvo_abno,
			cnsctvo_estdo_cnta_cntrto,
			vlr_abno_cta,
			vlr_abno_iva,
			vlr_abno_rtfnte,
			vlr_abno_rtca,
			vlr_abno_estmpllas,
			vlr_abno_otrs,
			fcha_crcn
		)
		select 
			 (select top 1 id_tabla from #tmpConsecutivoAbonos),
			 a.cnsctvo_estdo_cnta_cntrto,
			 (a.vlr + a.vlr_iva),
			 convert(numeric(12,0), ((a.vlr + a.vlr_iva) * @Valor_Porcentaje_Iva)) /  convert(numeric(12,0), (100 + @Valor_Porcentaje_Iva )),
			 0,
			 0,
			 0,
			 0,
			 @ldFechaSistema
		From dbo.TbnotasContrato a with(nolock)
		where a.nmro_nta = @nmro_nta

		If  @@error!=0  
		Begin 
			Set	@lnProcesoExitoso	=	1
			Set	@lcMensaje		=	'Error insertando Abonos Contrato'
			Rollback tran 
			Return -1
		end	

	End	

	-- se consulta el maximo consecutivo que siguie para el estado por nota
	-- se guardan todos los estado por nota
	Select 	@lnMax_cnsctvo_estdo_nta	=	 isnull(max(cnsctvo_estdo_nta),0)	 
	From	dbo.tbestadosXnota with(nolock)
	
	Insert into dbo.TbestadosXnota
	(
		cnsctvo_estdo_nta,		
		nmro_nta,		
		cnsctvo_cdgo_tpo_nta,
		cnsctvo_cdgo_estdo_nta,		
		vlr_nta,			
		vlr_iva,
		sldo_nta,			
		fcha_cmbo_estdo,	
		usro_cmbo_estdo
	)
	Values  	
	(
		@lnMax_cnsctvo_estdo_nta+1,	
		@nmro_nta,		
		@lcTipoNota,
		@lnconsecutivoCodigoEstadoNota,	
		@lnValorTotalNota,	
		@Valor_iva_nota,
		@Valor_saldo_nota,		
		@ldFechaSistema,	
		@lcUsuario
	)

	If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error insertando historico del estado de  la nota'
		Rollback tran 
		Return -1
	end	
	
	-- Se actualiza informacion DIAN
	select		@lnTipo   = ec.cnsctvo_cdgo_tpo_dcmnto
	from		dbo.tbNotasPAC			np with(nolock)
	inner join	dbo.tbNotasEstadoCuenta b with(nolock)
		on		np.cnsctvo_cdgo_tpo_nta  = b.cnsctvo_cdgo_tpo_nta
		and		np.nmro_nta  = b.nmro_nta
	inner join	dbo.tbEstadosCuenta		ec with(nolock)
		on		ec.cnsctvo_estdo_cnta = b.cnsctvo_estdo_cnta

	-- Si el documento asociado a la nota  es una factura se debe actualizar la informacion DIAN
	if @lnTipo = @lnTipoDocumentoFactura
	Begin
		exec dbo.spCalcularDatosFExNotaPAC @lcTipoNota, @nmro_nta
	End		 

Commit tran

End