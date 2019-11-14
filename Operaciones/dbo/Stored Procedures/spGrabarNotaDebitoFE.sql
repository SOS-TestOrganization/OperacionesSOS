
/*---------------------------------------------------------------------------------
* Metodo o PRG		:  spGrabarNotaDebitoFE
* Desarrollado por	: <\A Francisco E. Riaño L. - Qvision S.A	A\>
* Descripcion		: <\D Este procedimiento grabar una nota debito	de factura o estado de cuenta D\>
* Observaciones		: <\O	O\>
* Parametros		: <\P	P\>
* Variables			: <\V  	V\>
* Fecha Creacion	: <\FC 2019/08/21 FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM	AM\>
* Descripcion			: <\DM	DM\>
* Nuevos Parametros		: <\PM	PM\>
* Nuevas Variables		: <\VM	VM\>
* Fecha Modificacion	: <\FM	FM\>
*---------------------------------------------------------------------------------
*/

CREATE  PROCEDURE [dbo].[spGrabarNotaDebitoFE] (
		@lcTipoNota					udtConsecutivo,
		@lnNivel					udtConsecutivo,	
		@lnValorTotalNota			udtValorGrande,
		@lcObservaciones			Varchar(500),
		@nmro_unco_idntfccn_empldr	udtconsecutivo,
		@cnsctvo_scrsl				udtconsecutivo,
		@cnsctvo_cdgo_clse_aprtnte	udtconsecutivo,	
		@lcUsuario					udtUsuario,
		@lnProcesoExitoso			Int = 0		Output,
		@lcMensaje					Char(200)	Output,
		@nmro_nta					Varchar(15)	Output,
		@cnsctvo_cdgo_prdo_lqdcn	int,
		@cnsctvo_estdo_cnta			udtConsecutivo
)
As
Begin
	Set Nocount On;

	Declare		@vlr_actl												Int,
				@vlr_antrr												Int,
				@lnConsecutivoCodigoEstadoNotaIngresada					UdtConsecutivo = 1,
				@lnConsecutivoCodigoTipoAplicacionNotaProximoPeriodo	UdtConsecutivo = 2,
				@lnConsecutivoCodigoPeriodoLiquidacion					UdtConsecutivo,
				@ldFechaSistema											Datetime = Getdate(),	
				@ldFechaEvaluarPeriodo									Datetime,
				@lnNumeroPeriodosEvaluados								Int,
				@lnMax_cnsctvo_estdo_nta								UdtConsecutivo,
				@lnMax_Cnsctvo_nta_cncpto								UdtConsecutivo,
				@lnMax_cnsctvo_nta_cntrto								UdtConsecutivo,
				@Valor_iva_nota											UdtValorGrande,
				@Valor_saldo_nota										UdtValorGrande,
				@Valor_Porcentaje_Iva									UdtValorDecimales = 0,
				@MaximoConsecutivoContrato								UdtConsecutivo,
				@MaximoConsecutivoResponsable							UdtConsecutivo,
				@Cantidad_Contratos_Pac									Int,
				@AcumTotalIvaContrato									UdtValorGrande,
				@AcumTotalSaldoNotaContrato								UdtValorGrande,
				@PagoCarteraCastigada									int,
				@lnValorTotalAntIvaNota									udtValorGrande,
				@lnConsecutivoCodigoTipoDocEstadoCuenta					UdtConsecutivo,
				@lnConsecutivoCodigoEstadoDocumentoIngresadoFE			UdtConsecutivo = 1,
				@lnConsecutivoCodigoConceptoDianGastosCobrar			UdtConsecutivo = 2,
				@lnConsecutivoCodigoTipoConsecutivoNotaDebito			udtConsecutivo = 3,
				@lnConsecutivoConceptoPagoCarteraCastigadaFamiliar		udtConsecutivo = 231,
				@lnConsecutivoConceptoPagoCarteraCastigadaBienestar		udtConsecutivo = 232,
				@lnConsecutivoConceptoPagoCarteraCastigadaExcelencia	udtConsecutivo = 233,
				@lnConsecutivoConceptoPagoCarteraCastigadaQuimbaya		udtConsecutivo = 234;
	
	--Set @lnProcesoExitoso			= 0;

	Create	table #TMPConceptoNotaDebitoFinal
	(
		nmro_rgstro					Int IDENTITY(1,1),		
		nmro_nta					Varchar(15),
		cnsctvo_cdgo_tpo_nta		udtConsecutivo,	
		cnsctvo_cdgo_cncpto_lqdcn	udtConsecutivo,
		vlr_nta						udtValorGrande,		
		cnsctvo_cdgo_autrzdr_espcl	udtConsecutivo,
		cnsctvo_nta_cncpto			udtConsecutivo
	)

	Create	Table #tmpContratosResponsableTotal
	(
		nmro_rgstro					Int IDENTITY(1,1),			
		nmro_nta					Varchar(15),
		cnsctvo_cdgo_tpo_nta		udtConsecutivo,		
		cnsctvo_estdo_cnta_cntrto	udtConsecutivo,
		cnsctvo_cdgo_tpo_cntrto		udtConsecutivo,	
		nmro_cntrto					udtNumeroFormulario,
		vlr							udtValorGrande
	)

	Create	Table #tmpnotasContratoxConcepto
	(
		cnsctvo_nta_cntrto			udtConsecutivo,		
		Valor						udtValorGrande,
		Cnsctvo_nta_cncpto			udtConsecutivo,		
		cnsctvo_cdgo_cncpto_lqdcn	udtConsecutivo,
		vlr_ants_iva				udtValorGrande,
		vlr_iva						udtValorGrande
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

		update		a
		set			a.cnsctvo_cdgo_cncpto_lqdcn = b.cnsctvo_cdgo_cncpto_lqdcn
		from		#TMPcontratosresponsable a
		inner join	#TMPConceptoNotaDebito b
		on			a.cnsctvo_cdgo_pln = b.cnsctvo_cdgo_pln;

		update		b
		set			b.valor = a.valor
		from		#TMPcontratosresponsable a
		inner join	#TMPConceptoNotaDebito b
		on			a.cnsctvo_cdgo_pln = b.cnsctvo_cdgo_pln;
	end

	Select	@ldFechaEvaluarPeriodo = fcha_incl_prdo_lqdcn 
	From	dbo.tbPeriodosliquidacion_Vigencias with(nolock)
	Where	cnsctvo_cdgo_prdo_lqdcn = @cnsctvo_cdgo_prdo_lqdcn
	And		@ldFechaSistema between inco_vgnca and fn_vgnca

	-- trae el valor del porcentaje  para aplicar
	Select	@Valor_Porcentaje_Iva		= prcntje
	From	dbo.tbConceptosLiquidacion_Vigencias
	Where	cnsctvo_cdgo_cncpto_lqdcn	= @lnConsecutivoCodigoTipoConsecutivoNotaDebito
	And		@ldFechaEvaluarPeriodo	Between inco_vgnca And 	fn_vgnca

	If  @Valor_Porcentaje_Iva	= 0
	Begin
		Set @lnProcesoExitoso	= 1
		Set @lcMensaje		= 'No existe parametrizacion de iva para procesar'
		Return -1
	End

	-- se calcula el valor de la iva de la nota
	select  @PagoCarteraCastigada = isnull(count(*),0) 
	from	#TMPConceptoNotaDebito 
	where	cnsctvo_cdgo_cncpto_lqdcn in (@lnConsecutivoConceptoPagoCarteraCastigadaFamiliar,@lnConsecutivoConceptoPagoCarteraCastigadaBienestar,@lnConsecutivoConceptoPagoCarteraCastigadaExcelencia,@lnConsecutivoConceptoPagoCarteraCastigadaQuimbaya) 
	and		valor	> 0
	
	If @PagoCarteraCastigada > 0  and @PagoCarteraCastigada is not null
	begin
		set @Valor_Porcentaje_Iva = 0
	end

	Set @lnValorTotalAntIvaNota	= convert(numeric(12,0), (@lnValorTotalNota * 100))    / convert(numeric(12,0), (100 + @Valor_Porcentaje_Iva ))
	set @Valor_iva_nota     = convert(numeric(12,0), (@lnValorTotalNota * @Valor_Porcentaje_Iva)) /  convert(numeric(12,0), (100 + @Valor_Porcentaje_Iva ))

	-- se calcula el saldo de la nota valor de la nota  mas el valor del iva de la nota
	Set @Valor_saldo_nota	= @lnValorTotalAntIvaNota	+	@Valor_iva_nota

	Begin Tran


		Set @nmro_nta	= Convert(varchar(15),next value for dbo.SeqNumeroNotasDebito)
		
		Select	@lnConsecutivoCodigoTipoDocEstadoCuenta	=	cnsctvo_cdgo_tpo_dcmnto
		From	dbo.tbestadoscuenta with(nolock)
		Where	cnsctvo_estdo_cnta	= @cnsctvo_estdo_cnta

		Insert	Into dbo.tbNotasPac
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
			@lnValorTotalAntIvaNota,		
			@Valor_iva_nota,
			@Valor_saldo_nota,		
			@cnsctvo_cdgo_prdo_lqdcn,
			@ldFechaSistema,		
			@lnConsecutivoCodigoEstadoNotaIngresada,
			@lnConsecutivoCodigoTipoAplicacionNotaProximoPeriodo,	
			@lcObservaciones,
			@lcUsuario,			
			@nmro_unco_idntfccn_empldr,
			@cnsctvo_scrsl,		
			@cnsctvo_cdgo_clse_aprtnte,
			@ldFechaEvaluarPeriodo,
			@lnConsecutivoCodigoEstadoDocumentoIngresadoFE,
			@lnConsecutivoCodigoConceptoDianGastosCobrar
		)


		If  @@error!=0  
		Begin
			Set @lnProcesoExitoso	= 1
			Set @lcMensaje		= 'Error creando la nota'
			Rollback Tran
			Return -1
		End

		--Se consulta el numero siguiente del concepto y nota
		Select 	@lnMax_Cnsctvo_nta_cncpto	= Isnull(Max(Cnsctvo_nta_cncpto),0)
		From	dbo.tbNotasConceptos With(NoLock)

		-- se crea una tabla temporal con un contador  para que de esta forma poder asociar de una forma mas facil
		-- el consecutivo del registro en tbnotasconceptos

		Insert	Into #TMPConceptoNotaDebitoFinal
		(
			nmro_nta,				
			cnsctvo_cdgo_tpo_nta,
			cnsctvo_cdgo_cncpto_lqdcn,		
			vlr_nta,
			cnsctvo_cdgo_autrzdr_espcl,		
			cnsctvo_nta_cncpto
		)
		Select	@nmro_nta,			
				@lcTipoNota,
				cnsctvo_cdgo_cncpto_lqdcn,	
				valor,
				cnsctvo_cdgo_autrzdr_espcl,	
				0
		From	#TMPConceptoNotaDebito
		Where	valor	> 0

		--Se graba los conceptos de la nota debito
		
		Insert	Into dbo.tbNotasConceptos
		(
			Cnsctvo_nta_cncpto,			
			nmro_nta,
			cnsctvo_cdgo_tpo_nta,			
			cnsctvo_cdgo_cncpto_lqdcn,
			vlr_nta
		)
		Select	nmro_rgstro + @lnMax_Cnsctvo_nta_cncpto, 
				nmro_nta,
				cnsctvo_cdgo_tpo_nta,			
				cnsctvo_cdgo_cncpto_lqdcn,
				vlr_nta
		From	#TMPConceptoNotaDebitoFinal
		
		If  @@error!=0  
		Begin 
			Set @lnProcesoExitoso	= 1
			Set @lcMensaje		= 'Error insertando el concepto por nota'
			Rollback Tran
			Return -1
		End

		Update		a
		Set			a.cnsctvo_nta_cncpto	= b.cnsctvo_nta_cncpto
		From		#TMPConceptoNotaDebitoFinal a 
		Inner Join	dbo.tbNotasConceptos b with(nolock)
			On		a.cnsctvo_cdgo_cncpto_lqdcn	= b.cnsctvo_cdgo_cncpto_lqdcn
		Where		b.nmro_nta				= @nmro_nta
		And			b.cnsctvo_cdgo_tpo_nta	= @lcTipoNota

		Insert	Into dbo.tbAutorizacionesNotas
		(
			cnsctvo_nta_cncpto,		
			cnsctvo_cdgo_autrzdr_espcl
		)
		Select	cnsctvo_nta_cncpto,		
				cnsctvo_cdgo_autrzdr_espcl
		From	#TMPConceptoNotaDebitoFinal
		Where	cnsctvo_cdgo_autrzdr_espcl	> 0

		If  @@error!=0
		Begin
			Set @lnProcesoExitoso	= 1
			Set @lcMensaje		= 'Error insertando los autorizadores  por nota'
			Rollback Tran
			Return -1
		End

		If @lnNivel	= 1	-- si es a nivel de contrato
		Begin

			-- se crea la tabla temporal de l valor total por cada contrato  para controlar el numero del consecutivo
			Insert	Into #tmpContratosResponsableTotal
			(
				nmro_nta,			
				cnsctvo_cdgo_tpo_nta,
				cnsctvo_estdo_cnta_cntrto,	
				cnsctvo_cdgo_tpo_cntrto,
				nmro_cntrto,			
				vlr
			)
			Select	@nmro_nta,			
					@lcTipoNota,
					0,				
					cnsctvo_cdgo_tpo_cntrto,
					nmro_cntrto,			
					Sum(valor)
			From	#TMPcontratosresponsable
			Group by cnsctvo_cdgo_tpo_cntrto, nmro_cntrto

			-- se busca el maximo del consecutivo nota contrato

			Select	@lnMax_cnsctvo_nta_cntrto	= Isnull(Max(cnsctvo_nta_cntrto),0)
			From	dbo.tbNotasContrato with(nolock)

			-- se inserta la informacion a nivel de contrato de la nota

			Insert	Into dbo.tbNotasContrato
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
			Select	(a.nmro_rgstro + @lnMax_cnsctvo_nta_cntrto), 
					a.nmro_nta,
					a.cnsctvo_cdgo_tpo_nta,			
					a.cnsctvo_estdo_cnta_cntrto,
					a.cnsctvo_cdgo_tpo_cntrto,		
					a.nmro_cntrto,
					isnull(convert(numeric(12,0), (a.vlr * 100))    / convert(numeric(12,0), (100 + @Valor_Porcentaje_Iva )),0),
					isnull(convert(numeric(12,0), (a.vlr * @Valor_Porcentaje_Iva)) /  convert(numeric(12,0), (100 + @Valor_Porcentaje_Iva )),0),
					a.vlr,  --saldo a nivel de contrato
					@ldFechaSistema,					
					@lcUsuario
			From	#tmpContratosResponsableTotal a
			Where	a.vlr > 0

			If  @@Error!=0
			Begin
				Set @lnProcesoExitoso	= 1
				Set @lcMensaje		= 'Error insertando los contratos por nota'
				Rollback Tran
				Return -1
			End

			--Actualiza la nota a nivel de contrato
			Select	@AcumTotalIvaContrato		= sum(vlr_iva),
					@AcumTotalSaldoNotaContrato	= sum(sldo_nta_cntrto)
			From	dbo.tbNotasContrato
			Where	nmro_nta				= @nmro_nta
			And		cnsctvo_cdgo_tpo_nta	= @lcTipoNota

			If  @@Error!=0
			Begin
				Set @lnProcesoExitoso	= 1
				Set @lcMensaje		= 'Error Actualizando el saldo de la nota  contrato'
				Rollback Tran
				Return -1
			End


			Insert	Into #tmpnotasContratoxConcepto
			(
				cnsctvo_nta_cntrto,		
				Valor,
				Cnsctvo_nta_cncpto,		
				cnsctvo_cdgo_cncpto_lqdcn,
				vlr_ants_iva,
				vlr_iva
			)
			Select		b.cnsctvo_nta_cntrto,		
						a.Valor,
						0 Cnsctvo_nta_cncpto,		
						cnsctvo_cdgo_cncpto_lqdcn,
						isnull(convert(numeric(12,0), (a.Valor * 100))    / convert(numeric(12,0), (100 + @Valor_Porcentaje_Iva )),0),
						isnull(convert(numeric(12,0), (a.Valor * @Valor_Porcentaje_Iva)) /  convert(numeric(12,0), (100 + @Valor_Porcentaje_Iva )),0)
			From		#TMPcontratosresponsable	a 
			Inner Join	dbo.tbNotasContrato			b with(nolock)
				On		a.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
				And		a.nmro_cntrto				= b.nmro_cntrto
			Where		b.nmro_nta				= @nmro_nta
			And			b.cnsctvo_cdgo_tpo_nta	= @lcTipoNota
			And			a.valor	> 0

			-- actualiza el valor del concepto por nota
			Update		a
			Set			a.cnsctvo_nta_cncpto		= b.Cnsctvo_nta_cncpto
			From		#tmpnotasContratoxConcepto	a 
			Inner Join	dbo.tbNotasConceptos		b with(nolock)
				On		a.cnsctvo_cdgo_cncpto_lqdcn	= b.cnsctvo_cdgo_cncpto_lqdcn
				And		b.nmro_nta				= @nmro_nta
				And		b.cnsctvo_cdgo_tpo_nta	= @lcTipoNota

			-- se inserta la informacion de cada contrato y cada concepto
			Insert	Into dbo.tbNotasContratoxConcepto
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
					vlr_ants_iva,
					vlr_iva
			From	#tmpnotasContratoxConcepto

			If  @@error!=0  
			Begin 
				Set @lnProcesoExitoso	= 1
				Set @lcMensaje		= 'Error insertando contrato del concepto de la nota'
				Rollback Tran
				Return -1
			End
		End	-- Fin de a nivel de contrato

		-- se consulta el maximo consecutivo que siguie para el estado por nota
		-- se guardan todos los estado por nota

		Select	@lnMax_cnsctvo_estdo_nta	= Isnull(Max(cnsctvo_estdo_nta),0)
		From	dbo.tbEstadosxNota with(nolock)

		Insert	Into dbo.tbEstadosxNota
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
			@lnMax_cnsctvo_estdo_nta + 1,	
			@nmro_nta,
			@lcTipoNota,			
			@lnConsecutivoCodigoEstadoDocumentoIngresadoFE,
			@lnValorTotalAntIvaNota,		
			@Valor_iva_nota,
			@Valor_saldo_nota,		
			@ldFechaSistema,
			@lcUsuario
		)


		If  @@Error!=0
		Begin
			Set @lnProcesoExitoso	= 1
			Set @lcMensaje		= 'Error insertando historico del estado de  la nota'
			Rollback Tran
			Return -1
		End

		exec dbo.spCalcularDatosFExNotaPAC @lcTipoNota, @nmro_nta

	Commit tran

End

