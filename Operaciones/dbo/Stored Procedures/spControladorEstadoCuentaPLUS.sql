
/*------------------------------------------------------------------------------------------------------------------------------------------
* Método o PRG		:		spControladorEstadoCuentaPLUS							
* Desarrollado por	: <\A	Carlos Vela - Qvision	A\>	
* Descripción		: <\D	Controlador de creacion de Estados de cuenta para planes PAC Plus y PBS PlusD\>
* Observaciones		: <\O 	O\>	
* Parámetros		: <\P 	P\>	
* Variables			: <\V	V\>	
* Fecha Creación	: <\FC	2019/05/22	FC\>
*------------------------------------------------------------------------------------------------------------------------------------------*/

CREATE Procedure [dbo].[spControladorEstadoCuentaPLUS]
--DECLARE 
	@lcUsuario				udtUsuario,
	@lnConceptoLiquidacion	udtConsecutivo	,
	@mnsje_slda				varchar(1000) Output,
	@cdgo_slda				udtCodigo	Output,
	@detalleEjecucion		varchar(5000) Output,
	@lnConsCodigoLiquidacionGenerado udtConsecutivo	Output
As
Begin
	Set Nocount On

	Declare @ldfechaCorte	datetime, 
			@lnConsCodigoPeriodoLiq udtConsecutivo,
			@mensajeSalida  udtObservacion,
			@codigoSalida	udtCodigo,
			@TIPO_CONTRATO INT, -- 1 para PBS PLUS  2  - para PAC PLUS
			@PAC_PLUS INT=346,
			@PBS_PLUS INT=345,
			@filasAfectadas INT=0,
			@lnNuevoConsCodigoLiquidacion udtConsecutivo,
			@lnTipoProceso	 int=1, --Procesar Liquidacion
			@lnIdConsecutivoProceso udtConsecutivo,
			@lnNumEstadosCuentaCreados int,
			@PAC_PLUS1 smallint=64,
			@PAC_PLUS2 smallint=21,
			@PBS_PLUS1 smallint=101,
			@lnConsCodigoPlan int,
			@lcSaltoLinea char(2)=CHAR(13) + CHAR(10),
			@logTxt varchar(5000)='' 

-- Eliminamos las tablas temporales
	IF OBJECT_ID('tempdb.dbo.#tmpSucursalesProducto') IS NOT NULL 
		DROP TABLE #tmpSucursalesProducto

	IF OBJECT_ID('tempdb.dbo.#tmpProductosLiq') IS NOT NULL 
		DROP TABLE #tmpProductosLiq

	IF OBJECT_ID('tempdb.dbo.#tmpTarifaSucursal') IS NOT NULL 
		DROP TABLE #tmpTarifaSucursal

	IF OBJECT_ID('tempdb.dbo.#tmpContratosVigentes') IS NOT NULL 
		DROP TABLE #tmpContratosVigentes

	IF OBJECT_ID('tempdb.dbo.#tmpEstadosCuentaPlus') IS NOT NULL 
		DROP TABLE #tmpEstadosCuentaPlus

	IF OBJECT_ID('tempdb.dbo.#tmpBeneficiarios') IS NOT NULL 
		DROP TABLE #tmpBeneficiarios

	IF OBJECT_ID('tempdb.dbo.#tmpTotalEstadoCuenta') IS NOT NULL 
		DROP TABLE #tmpTotalEstadoCuenta

	IF OBJECT_ID('tempdb.dbo.#tmpResumenEstadoCuenta') IS NOT NULL 
		DROP TABLE #tmpResumenEstadoCuenta

	IF OBJECT_ID('tempdb.dbo.#tmpEstadosCuentaContratos') IS NOT NULL 
		DROP TABLE #tmpEstadosCuentaContratos

	IF OBJECT_ID('tempdb.dbo.#tmpCuentasContratosBeneficiarios') IS NOT NULL 
		DROP TABLE #tmpCuentasContratosBeneficiarios

	IF OBJECT_ID('tempdb.dbo.#tmpEstadosCuentaConceptos') IS NOT NULL 
		DROP TABLE #tmpEstadosCuentaConceptos

	IF OBJECT_ID('tempdb.dbo.#tmpContratosLiqConceptoPlus') IS NOT NULL 
		DROP TABLE #tmpContratosLiqConceptoPlus

	IF OBJECT_ID('tempdb.dbo.#tmpContratosNoValidos') IS NOT NULL 
		DROP TABLE #tmpContratosNoValidos

	IF OBJECT_ID('tempdb.dbo.#tmpContratosValidos') IS NOT NULL 
		DROP TABLE #tmpContratosValidos
		
	IF OBJECT_ID('tempdb.dbo.#tmpBeneficiariosNoValidos') IS NOT NULL 
		DROP TABLE #tmpBeneficiariosNoValidos

	IF OBJECT_ID('tempdb.dbo.#tmpResultadosLogFinal') IS NOT NULL 
		DROP TABLE #tmpResultadosLogFinal

	IF OBJECT_ID('tempdb.dbo.#tmpContratosYaLiquidados') IS NOT NULL 
		DROP TABLE #tmpContratosYaLiquidados

	IF OBJECT_ID('tempdb.dbo.#tmpContratosVigentesLiqPlus') IS NOT NULL 
		DROP TABLE #tmpContratosVigentesLiqPlus

	IF OBJECT_ID('tempdb.dbo.#tmpSucuralesNoLiqPlus') IS NOT NULL 
		DROP TABLE #tmpSucuralesNoLiqPlus

    CREATE TABLE #tmpProductosLiq (cnsctvo_prdcto udtConsecutivo, primary key(cnsctvo_prdcto));

	CREATE TABLE #tmpSucursalesProducto(
		nmro_rgstro					bigint,
		cdgo_tpo_idntfccn			char(3),
		nmro_idntfccn				varchar(23),
		nmbre_scrsl					varchar(150),
		cnsctvo_scrsl				udtConsecutivo,
		nmro_unco_idntfccn_empldr	udtValorGrande,
		cnsctvo_cdgo_clse_aprtnte	udtConsecutivo,
		cnsctvo_cdgo_sde			udtConsecutivo,
		cnsctvo_prdcto_scrsl		udtConsecutivo,
		cnsctvo_prdcto				udtConsecutivo
	)

	CREATE TABLE #tmpContratosVigentes(
		cnsctvo_cdgo_tpo_cntrto udtConsecutivo,
		nmro_cntrto udtNumeroFormulario,
		nmro_unco_idntfccn_empldr udtConsecutivo,
		cnsctvo_cdgo_clse_aprtnte udtConsecutivo,
		cnsctvo_scrsl udtConsecutivo
	)

	CREATE TABLE #tmpTarifaSucursal(
		nm_rgstro bigint,
		nmro_unco_idntfccn_rspnsble udtConsecutivo,
		cnsctvo_cdgo_clse_aprtnte_rspnsble udtConsecutivo,
		cnsctvo_scrsl_rspnsble udtConsecutivo,
		vlr_trfa float,
		cnsctvo_cdgo_crtro_lqdcn udtConsecutivo,
		nmro_unco_idntfccn_empldr udtConsecutivo,
		cnsctvo_cdgo_clse_aprtnte_empldr udtConsecutivo,
		cnsctvo_scrsl_empldr udtConsecutivo
	)

	CREATE TABLE #tmpBeneficiarios(
		cnsctvo_cdgo_tpo_cntrto udtConsecutivo,
		nmro_cntrto udtNumeroFormulario,
		cnsctvo_bnfcro udtConsecutivo,
		nmro_unco_idntfccn_bnfcro udtConsecutivo,
		nmro_unco_idntfccn_empldr udtConsecutivo,
		cnsctvo_cdgo_clse_aprtnte udtConsecutivo,
		cnsctvo_scrsl udtConsecutivo,
		vlr numeric(12,0),
		iva numeric(12,0)
	)

	CREATE TABLE #tmpEstadosCuentaPlus(
		cnsctvo_estdo_cnta udtConsecutivo,
		cnsctvo_cdgo_lqdcn udtConsecutivo,
		fcha_gnrcn datetime,
		nmro_unco_idntfccn_empldr udtConsecutivo,
		cnsctvo_scrsl udtConsecutivo,
		cnsctvo_cdgo_clse_aprtnte udtConsecutivo,
		ttl_fctrdo udtValorGrande,
		vlr_iva udtValorGrande,
		sldo_fvr udtValorGrande,
		ttl_pgr udtValorGrande,
		sldo_estdo_cnta udtValorGrande,
		sldo_antrr udtValorGrande,
		Cts_Cnclr udtValorPequeno,
		Cts_sn_Cnclr udtValorPequeno,
		nmro_estdo_cnta varchar(15),
		cnsctvo_cdgo_estdo_dcmnto_fe udtConsecutivo,
		txto_vncmnto varchar(50)
	)

	CREATE TABLE #tmpTotalEstadoCuenta(
		cnsctvo_estdo_cnta_cntrto_tmp udtConsecutivo,
		cnsctvo_estdo_cnta udtConsecutivo,
		cnsctvo_cdgo_tpo_cntrto udtConsecutivo,
		nmro_cntrto udtNumeroFormulario,
		vlr_cbrdo dbo.udtValorDecimales,
		sldo int,
		sldo_fvr int,
		cntdd_bnfcrs int,
		fcha_ultma_mdfccn datetime,
		usro_ultma_mdfccn udtUsuario,
		vlr_trfa dbo.udtValorDecimales,
		vlr_iva dbo.udtValorDecimales,
	)

	CREATE TABLE #tmpResumenEstadoCuenta(
			cnsctvo_estdo_cnta udtConsecutivo, 
			ttl_fctrdo dbo.udtValorDecimales, 
			vlr_iva float,
			ttl_pgr dbo.udtValorDecimales,
			sldo_estdo_cnta	dbo.udtValorDecimales
	)

	CREATE TABLE #tmpEstadosCuentaContratos(
		cnsctvo_estdo_cnta_cntrto udtConsecutivo,
		cnsctvo_estdo_cnta udtConsecutivo,
		cnsctvo_cdgo_tpo_cntrto udtConsecutivo,
		nmro_cntrto udtNumeroFormulario,
		vlr_cbrdo udtValorGrande,
		sldo udtValorGrande,
		sldo_fvr udtValorGrande,
		cntdd_bnfcrs int,
		fcha_ultma_mdfccn datetime,
		usro_ultma_mdfccn udtUsuario
	)

	CREATE TABLE #tmpCuentasContratosBeneficiarios(
		cnsctvo_estdo_cnta_cntrto_bnfcro bigint,
		cnsctvo_estdo_cnta_cntrto udtConsecutivo,
		cnsctvo_bnfcro udtConsecutivo,
		nmro_unco_idntfccn_bnfcro udtConsecutivo,
		vlr udtValorDecimales,
		vlr_trfa udtValorDecimales
	)

	CREATE TABLE #tmpEstadosCuentaConceptos(
		cnsctvo_estdo_cnta_cncpto_tmp udtConsecutivo,
		cnsctvo_estdo_cnta udtConsecutivo,
		cnsctvo_cdgo_cncpto_lqdcn udtConsecutivo,
		vlr_cbrdo udtValorGrande,
		sldo udtValorGrande,
		cntdd int
	)

	CREATE TABLE #tmpContratosLiqConceptoPlus(
		csctvo_cdgo_lqdcn udtConsecutivo,
		cnsctvo_cdgo_prdo_lqdcn udtConsecutivo,
		cnsctvo_estdo_cnta udtConsecutivo,
		cnsctvo_cdgo_tpo_cntrto udtConsecutivo,
		nmro_cntrto udtNumeroFormulario,
		cnsctvo_cdgo_cncpto_lqdcn udtConsecutivo
	)

	-- Tablas temporales para registro del log
	CREATE TABLE #tmpContratosNoValidos(
		cnsctvo_cdgo_tpo_cntrto udtConsecutivo,
		nmro_cntrto udtNumeroFormulario,
		nmro_unco_idntfccn_empldr udtConsecutivo,
		cnsctvo_scrsl udtConsecutivo,
		cnsctvo_cdgo_clse_aprtnte udtConsecutivo,
		causa varchar(50)	
	)

	CREATE TABLE #tmpContratosValidos(
		cnsctvo_cdgo_tpo_cntrto udtConsecutivo,
		nmro_cntrto udtNumeroFormulario,
		nmro_unco_idntfccn_empldr udtConsecutivo,
		cnsctvo_scrsl udtConsecutivo,
		cnsctvo_cdgo_clse_aprtnte udtConsecutivo
	)

	CREATE TABLE #tmpBeneficiariosNoValidos(
		cnsctvo_cdgo_tpo_cntrto udtConsecutivo,
		nmro_cntrto udtNumeroFormulario,
		cnsctvo_bnfcro udtConsecutivo,
		nmro_unco_idntfccn_bnfcro udtConsecutivo,
		cnsctvo_cdgo_tpo_afldo udtConsecutivo,
		nmro_unco_idntfccn udtConsecutivo,
		causa varchar(50)
	)

	CREATE TABLE #tmpContratosYaLiquidados(
		cnsctvo_cdgo_tpo_cntrto udtConsecutivo,
		nmro_cntrto udtNumeroFormulario
	)


	Create table #tmpResultadosLogFinal
	(
		nmro_cntrto					varchar(20),
		cdgo_tpo_idntfccn			varchar(3),
		nmro_idntfccn				varchar(20),
		nombre						varchar(200),
		cnsctvo_cdgo_pln			int,
		inco_vgnca_cntrto			datetime,
		fn_vgnca_cntrto				datetime,
		nmro_unco_idntfccn_afldo	int,
		cdgo_pln					varchar(6),
		dscrpcn_pln					varchar(50),
		causa						varchar(100),
		nmro_unco_idntfccn_empldr	int,
		cnsctvo_scrsl				int,
		cnsctvo_cdgo_clse_aprtnte	int,
		nmbre_scrsl					varchar(200),
		dscrpcn_clse_aprtnte		varchar(100),
		tpo_idntfccn_scrsl			varchar(3),
		nmro_idntfccn_scrsl			varchar(20),
		Responsable					varchar(100),
		cnsctvo_cdgo_lqdcn			int,
		nmro_unco_idntfccn_bnfcro	udtConsecutivo
	 )	

	CREATE TABLE #tmpSucuralesNoLiqPlus(
		nmro_unco_idntfccn_empldr udtConsecutivo,
		cnsctvo_cdgo_clse_aprtnte udtConsecutivo,
		cnsctvo_scrsl udtConsecutivo
	)


	Begin Try 

		--Obtenemos la información del periodo a liquidar
		exec dbo.spObtenerInfoPeriodoLiquidacionPLUS  
			@ldfechaCorte output,
			@lnConsCodigoPeriodoLiq output,
			@mensajeSalida output,
			@codigoSalida output

			set @logTxt = 'spObtenerInfoPeriodoLiquidacion			     - @codigoSalida: '+CAST(@codigoSalida AS VARCHAR(12))+' @mensajeSalida: '+@mensajeSalida+@lcSaltoLinea
			--print @logTxt


        If @codigoSalida <>0 
			begin
				 
				Set @mnsje_slda	= @mensajeSalida;
				Set @cdgo_slda	= @codigoSalida;

				
				-- Se registrara la ejecucion del proceso
				exec dbo.spIniciarProcesoCarteraPLUS @lcUsuario,@lnTipoProceso,@lnIdConsecutivoProceso output, @mensajeSalida output, @codigoSalida output
				exec dbo.spFinalizarProcesoCarteraPLUS @lnIdConsecutivoProceso, @mensajeSalida	Output, @codigoSalida	Output
				
				RETURN			
			end 
		else
			begin
		
			   --En esta seccion se debe tomar los productos	
			   IF @lnConceptoLiquidacion = @PAC_PLUS
				BEGIN
					insert INTO #tmpProductosLiq values (@PAC_PLUS1); --PAC PLUS
					insert INTO #tmpProductosLiq values (@PAC_PLUS2); --PAC PLUS
					SET @TIPO_CONTRATO=2;
					SET @lnConsCodigoPlan=8;
				END
			   ELSE
				BEGIN
					insert INTO #tmpProductosLiq values (@PBS_PLUS1); -- PBS PLUS
					SET @TIPO_CONTRATO=1;
					SET @lnConsCodigoPlan=1;
				END		

				exec dbo.spIniciarProcesoCarteraPLUS
					@lcUsuario,
					@lnTipoProceso,
					@lnIdConsecutivoProceso output, 
					@mensajeSalida output, 
					@codigoSalida output

				set @logTxt += 'spIniciarProcesoCarteraPLUS			         - @codigoSalida: '+CAST(@codigoSalida AS VARCHAR(12))+' @mensajeSalida: '+@mensajeSalida+@lcSaltoLinea
				--print @logTxt

			   IF (@codigoSalida<>0)
				BEGIN
					set @cdgo_slda=1;
					Set @mnsje_slda	= 'No fue posible generar el identificador de proceso de cartera plus. La tarea no continuara. '+@mensajeSalida;
					SET @detalleEjecucion = @mnsje_slda
					RETURN;
				END
			   ELSE
				BEGIN
					--Se crea la liquidacion
					exec dbo.spRegistrarLiquidacionPLUS
							@lcUsuario,
							@lnConsCodigoPeriodoLiq,
							@lnNuevoConsCodigoLiquidacion Output,
							@mensajeSalida	Output,
							@codigoSalida	Output	
					
					--Establecemos el valor de salida del procedimiento 
					SET @lnConsCodigoLiquidacionGenerado = @lnNuevoConsCodigoLiquidacion

					set @logTxt +='spRegistrarLiquidacionPLUS			         - @codigoSalida: '+CAST(@codigoSalida AS VARCHAR(12))+' @mensajeSalida: '+@mensajeSalida+@lcSaltoLinea
					--print @logTxt

					IF @codigoSalida <> 0 
						BEGIN
							set @cdgo_slda=1;
							Set @mnsje_slda	= 'No fue posible generar la liquidacion. La tarea no continuara. '+@mensajeSalida;
							SET @detalleEjecucion = @logTxt
							RETURN;
						END;
					ELSE
						BEGIN
							
							exec dbo.spPoblarTablasPlanesPLUS @ldFechaCorte, @TIPO_CONTRATO, 
							    @lnNuevoConsCodigoLiquidacion, @lnConceptoLiquidacion, 
								@lnConsCodigoPeriodoLiq, @lnConsCodigoPlan,
								@mensajeSalida output, @codigoSalida output

							set @logTxt += 'spPoblarTablasPlanesPLUS			         - @codigoSalida: '+CAST(@codigoSalida AS VARCHAR(12))+' @mensajeSalida: '+@mensajeSalida+@lcSaltoLinea
							--print @logTxt

							IF @codigoSalida <> 0 
								BEGIN
									set @cdgo_slda=1;
									Set @mnsje_slda	= 'No fue posible crear las tablas temporales. '+@mensajeSalida;
									SET @detalleEjecucion = @logTxt
									RETURN;								
								END
							ELSE
								BEGIN

									exec dbo.spRegistrarLogLiquidacionesContratosPLUS @ldFechaCorte, @TIPO_CONTRATO, 
										@lnNuevoConsCodigoLiquidacion, @lnConceptoLiquidacion, @lnConsCodigoPlan,
										@mensajeSalida output, @codigoSalida output

									set @logTxt +='spRegistrarLogLiquidacionesContratosPLUS     - @codigoSalida: '+CAST(@codigoSalida AS VARCHAR(12))+' @mensajeSalida: '+@mensajeSalida+@lcSaltoLinea
									--print @logTxt 

									exec dbo.spRegistrarCriteriosLiquidacionPLUS
										@lnNuevoConsCodigoLiquidacion,
										@mensajeSalida Output,
										@codigoSalida Output

									set @logTxt += 'spRegistrarCriteriosLiquidacionPLUS          - @codigoSalida: '+CAST(@codigoSalida AS VARCHAR(12))+' @mensajeSalida: '+@mensajeSalida+@lcSaltoLinea
									--print @logTxt
										
									exec dbo.spRegistrarEstadosCuentaPLUS
										@lnNuevoConsCodigoLiquidacion,
										@lcUsuario,
										@lnNumEstadosCuentaCreados Output,
										@mensajeSalida	Output,
										@codigoSalida	Output

									set @logTxt +=  'spRegistrarEstadosCuentaPLUS                 - @codigoSalida: '+CAST(@codigoSalida AS VARCHAR(12))+' @mensajeSalida: '+@mensajeSalida+@lcSaltoLinea										
									--print @logTxt
										
									-- Si fueron creados estados de cuenta es porque existe beneficiarios con 
									-- el plan PBS PLUS o PAC PLUS
									 
									If 	@lnNumEstadosCuentaCreados = 0	
										begin
												set @cdgo_slda=1;

												Set @mnsje_slda	= 'No existen contratos pendientes por liquidar para los planes PBS PLUS o PAC PLUS, en el periodo vigente. '+@mensajeSalida;
												SET @detalleEjecucion = @logTxt
												RETURN;	
										end
									

									exec dbo.spRegistrarEstadosCuentaContratosPLUS
										@lnNuevoConsCodigoLiquidacion,
										@mensajeSalida	Output,
										@codigoSalida	Output	
									
									set @logTxt +=  'spRegistrarEstadosCuentaContratosPLUS        - @codigoSalida: '+CAST(@codigoSalida AS VARCHAR(12))+' @mensajeSalida: '+@mensajeSalida+@lcSaltoLinea	
									--print @logTxt 

									If 	@codigoSalida <> 0 
										Begin
												set @cdgo_slda=1;
												Set @mnsje_slda	= 'No fue posible crear los estados de cuenta para el contrato. Detalle: '+@mensajeSalida;
												SET @detalleEjecucion = @logTxt
												RETURN;	
										End
																											

									exec dbo.spRegistrarCuentasContratosBeneficiariosPLUS
										@mensajeSalida	Output,
										@codigoSalida	Output	

									set @logTxt += 'spRegistrarCuentasContratosBeneficiariosPLUS - @codigoSalida: '+CAST(@codigoSalida AS VARCHAR(12))+' @mensajeSalida: '+@mensajeSalida+@lcSaltoLinea										
									--print @logTxt

									If 	@codigoSalida <> 0 
										Begin
												set @cdgo_slda=1;
												Set @mnsje_slda	= 'No fue posible crear la cuenta-contrato beneficiario. Detalle: '+@mensajeSalida;
												SET @detalleEjecucion = @logTxt
												RETURN;	
										End

									exec dbo.spRegistrarCuentasBeneficiariosConceptosPLUS
										@lnConceptoLiquidacion,
										@mensajeSalida	Output,
										@codigoSalida	Output

									set @logTxt += 'spRegistrarCuentasBeneficiariosConceptosPLUS - @codigoSalida: '+CAST(@codigoSalida AS VARCHAR(12))+' @mensajeSalida: '+@mensajeSalida+@lcSaltoLinea										
									--print @logTxt

									If 	@codigoSalida <> 0 
										Begin
												set @cdgo_slda=1;
												Set @mnsje_slda	= 'No fue posible registrar el concepto de liquidacion para el beneficiario. Detalle: '+@mensajeSalida;
												SET @detalleEjecucion = @logTxt
												RETURN;	
										End

									exec dbo.spRegistrarEstadosCuentaConceptosPLUS
										@lnNuevoConsCodigoLiquidacion,
										@mensajeSalida  Output,
										@codigoSalida   Output

									set @logTxt += 'spRegistrarEstadosCuentaConceptosPLUS        - @codigoSalida: '+CAST(@codigoSalida AS VARCHAR(12))+' @mensajeSalida: '+@mensajeSalida+@lcSaltoLinea											
									--print @logTxt

									If 	@codigoSalida <> 0 
										Begin
												set @cdgo_slda=1;
												Set @mnsje_slda	= 'No fue posible crear el estado de cuenta resumido por concepto. Detalle: '+@mensajeSalida;
												SET @detalleEjecucion = @logTxt
												RETURN;	
										End

									exec dbo.spRegistrarHistoricoEstadoLiquidacionPLUS
										@lnNuevoConsCodigoLiquidacion,
										@lnConceptoLiquidacion,
										@lcUsuario,
										@mensajeSalida Output,
										@codigoSalida	Output
										
									set @logTxt += 'spRegistrarHistoricoEstadoLiquidacionPLUS    - @codigoSalida: '+CAST(@codigoSalida AS VARCHAR(12))+' @mensajeSalida: '+@mensajeSalida+@lcSaltoLinea	
									--print @logTxt									

									If 	@codigoSalida <> 0 
										Begin
												set @cdgo_slda=1;
												Set @mnsje_slda	= 'No fue posible registrar en el historico la liquidacion. Detalle: '+@mensajeSalida;
												SET @detalleEjecucion = @logTxt
												RETURN;	
										End
																			
									exec dbo.spFinalizarProcesoCarteraPLUS
										@lnIdConsecutivoProceso,
										@mensajeSalida	Output,
										@codigoSalida	Output

									set @logTxt +=  'spFinalizarProcesoCarteraPLUS                - @codigoSalida: '+CAST(@codigoSalida AS VARCHAR(12))+' @mensajeSalida: '+@mensajeSalida+@lcSaltoLinea	
									--print @logTxt									


									If 	@codigoSalida <> 0 
										Begin
												set @cdgo_slda=1;
												Set @mnsje_slda	= 'No fue posible marcar el proceso de liquidacion como finalizado. Detalle: '+@mensajeSalida;
												SET @detalleEjecucion = @logTxt
												RETURN;	
										End

									Set @mnsje_slda	= 'Finalización exitosa del proceso de generación del estado de cuenta.';
									SET @detalleEjecucion = @logTxt
								END;
						END 
				END
			END 

	End Try
	Begin Catch
		Set @mnsje_slda	= ERROR_PROCEDURE()+Concat(ERROR_MESSAGE(), ' ', ERROR_PROCEDURE(), ' ', ERROR_LINE());
		Set @cdgo_slda	= 1;
		set @logTxt = 'Mensaje ERROR Contralador: '+@mnsje_slda
		--print @logTxt 

	End Catch

	SET @detalleEjecucion = @logTxt

	--
	Drop Table #tmpProductosLiq;
	DROP TABLE #tmpSucursalesProducto;
	DROP TABLE #tmpTarifaSucursal;
	DROP TABLE #tmpContratosVigentes;
	DROP TABLE #tmpEstadosCuentaPlus;
	DROP TABLE #tmpBeneficiarios;
	DROP TABLE #tmpTotalEstadoCuenta;
	DROP TABLE #tmpEstadosCuentaContratos;
	DROP TABLE #tmpCuentasContratosBeneficiarios;
	DROP TABLE #tmpEstadosCuentaConceptos;
	DROP TABLE #tmpSucuralesNoLiqPlus;
	--
	DROP TABLE #tmpContratosNoValidos;
	DROP TABLE #tmpContratosValidos;
	DROP TABLE #tmpBeneficiariosNoValidos;
	DROP TABLE #tmpResultadosLogFinal;


End
