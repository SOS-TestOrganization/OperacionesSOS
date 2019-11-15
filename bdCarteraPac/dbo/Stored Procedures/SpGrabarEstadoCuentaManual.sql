/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :   SpGrabarEstadoCuentaManual
* Desarrollado por		 :  <\A	Ing. Rolando Simbaqueva Lasso						A\>
* Descripcion			 :  <\D   Inserta la informacion del estado de cuenta manual				D\>
* Observaciones		              :  <\O										O\>
* Parametros			 :  <\P    tabla tempora # TMPEncabezadoResponsable				P\>
* Variables			 :  <\V										V\>
* Fecha Creacion		 :  <\FC  2002/10/07								FC\>
* 
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION  
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------  
* Modificado Por		              : <\AM  Rolando Simbaqueva Lasso  AM\>
* Descripcion			 : <\DM   Aplicacion tecnicas de optimizacion DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM   2005 / 09 / 26 FM\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION  
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------  
* Modificado Por		: <\AM Francisco E. Riaño L - Qvision S.A AM\>
* Descripcion			: <\DM  Ajustes Facturacion Electronica DM\>
* Nuevos Parametros	 	: <\PM   PM\>
* Nuevas Variables		: <\VM   VM\>
* Fecha Modificacion	: <\FM   2019-05-06 FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE  [dbo].[SpGrabarEstadoCuentaManual]
(
	@lnProcesoExitoso	int  		Output,
	@lcMensaje			char(200)	output,
	@lnTipo				int	
)
AS	
Begin
	Set Nocount On;

	Declare		@cnsctvo_cdgo_prdo						udtConsecutivo = 99999,
				@nmro_prds								int,
				@cnsctvo_cdgo_prdo_lqdcn				int,
				@cnsctvo_cdgo_estdo_estdo_cnta			int,
				@nmro_estdo_cnta						varchar(15),
				@vlr_actl								int,
				@vlr_antrr								int,
				@usro_crcn								Varchar(30),
				@cnsctvo_cnta_mnls_cntrto				udtconsecutivo,
				@nmro_estdo_cnta_mdfcdo					varchar(15),
				@nConsecutivoResolucionDianPac			udtConsecutivo	= 2,
				@nConsecutivoTipoDocumentoFactura		udtConsecutivo	= 6,
				@nConsecutivoEstadoDocumentoIngresado	udtConsecutivo	= 1,
				@ldFechaSistema							datetime		= getdate()

	-- Creacion de tablas temporales
	Create table  #TmpcontratoresponsableNuevos
	(
		nmro_rgstro int IDENTITY(1,1), 
		nmro_estdo_cnta varchar(15),
		cnsctvo_cdgo_tpo_cntrto int,
		nmro_cntrto varchar(15), 
		vlr_cbrdo numeric(12,0), 
		sldo numeric(12,0),   
		cntdd_bnfcrs int,
		cnsctvo_cdgo_pln int,
		usro_crcn varchar(30),
		fcha_crcn datetime
	);

	--actualizacion campo CUFE
	Create Table #tmpParametrosRecibidosCufe
	(
		   NmroCnta varchar(15),
		   NumFac varchar(30),
		   FecFac varchar(30),
		   ValFac varchar(30),
		   CodImp1 varchar(10),
		   ValImp1 varchar(30),
		   CodImp2 varchar(10),
		   ValImp2 varchar(30),
		   CodImp3 varchar(10),
		   ValImp3 varchar(30),
		   ValImp varchar(30),
		   NitOFE varchar(30),
		   TipAdq varchar(10),
		   NumAdq varchar(30),
		   CITec varchar(250)
	);

	Create Nonclustered Index IX_#tmpParametrosRecibidosCufe 
		on #tmpParametrosRecibidosCufe
    (
			NumFac
	);

	Create Table #tmpCUFEGenerado
	(
		   NmroCnta varchar(15),
		   NumFac varchar(30),
		   CUFE varchar(250),
		   cCUFE varchar(250),
	);

	Begin Tran Uno

		Set	@lcMensaje	=	''
		set	@lnProcesoExitoso = 0

		--Se Captura el usuario de creacion
		Select 	@usro_crcn	=	usro_crcn
		From	#TMPEncabezadoResponsable

		Select	@cnsctvo_cdgo_prdo_lqdcn	=	cnsctvo_cdgo_prdo_lqdcn
		From	dbo.tbPeriodosLiquidacion_vigencias With(NoLock)
		Where	cnsctvo_cdgo_estdo_prdo	=	2  -- periodo con estado abierto. 

		--se calcula el numero de meses a facturar
		Select	@nmro_prds	=	DATEDIFF(month, fcha_incl_fctrcn, fcha_fnl_fctrcn) + 1
		From 	#TMPEncabezadoResponsable

		If (@nmro_prds = 1)
			Set @cnsctvo_cdgo_prdo = 1

		If (@nmro_prds = 2)
			Set @cnsctvo_cdgo_prdo = 2

		If (@nmro_prds = 3)
			Set @cnsctvo_cdgo_prdo = 3

		If (@nmro_prds = 4)
			Set @cnsctvo_cdgo_prdo = 4

		If (@nmro_prds = 6)
			Set @cnsctvo_cdgo_prdo = 5

		If (@nmro_prds = 12)
			Set @cnsctvo_cdgo_prdo = 6

		If (@lnTipo = 1)
		Begin
			/* se consulta el consecutivo actual del estado de cuenta y consecutivo anterior
			Select  @vlr_actl	=	isnull(vlr_actl,0) + 1,
					@vlr_antrr	=	vlr_actl
			From	dbo.tbtiposconsecutivo_vigencias With(NoLock)
			Where	cnsctvo_cdgo_tpo_cnsctvo = 1  -- consecutivos de estado de cuenta

			--Actualizamos el consecutivo del estado  de cuenta
			Update	a
			Set 	vlr_actl	=	@vlr_actl,
					vlr_antrr	=	@vlr_antrr
			From	dbo.tbtiposconsecutivo_vigencias a With(RowLock)
			Where	cnsctvo_cdgo_tpo_cnsctvo = 1*/

			--se consulta la secuencia para el estado de cuenta	
			Begin try
				declare @vProcesoExitoso varchar(1);
				execute dbo.spValidarResolucionVigenteDIAN @vProcesoExitoso output
			End try
			begin catch
				Set @lnProcesoExitoso = 1
				Set @lcMensaje = error_message()
				Rollback Tran Uno
				Return -1
			end catch		
				
			select @vlr_actl = next value for dbo.seqNumeroEstadoCuentaDIAN
			
			/*If  @@error!=0  
				Begin 
					Set	@lnProcesoExitoso	=	1
					Set	@lcMensaje='Error Actualizando el tipo de conseuctivo'
					Rollback tran uno
					Return -1
				End	*/

			-- se asigna el numero del estado de cuenta	
			Set	@nmro_estdo_cnta = convert(varchar(15),@vlr_actl)
			Set	@cnsctvo_cdgo_estdo_estdo_cnta	=	1 -- Estado del estado de cuenta ingresado

			Insert Into dbo.TbCuentasManuales
			(
				nmro_estdo_cnta,
				fcha_incl_fctrcn,
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
				cts_sn_cnclr,
				drccn,
				cnsctvo_cdgo_cdd,
				tlfno,
				ttl_fctrdo,
				vlr_iva,
				sldo_fvr,
				sldo_antrr,
				ttl_pgr,
				fcha_crcn,
				usro_crcn,
				cnsctvo_cdgo_prdo,
				cnsctvo_cdgo_autrzdr_espcl,
				prcntje_incrmnto,
				cnsctvo_cdgo_prdo_lqdcn,
				cnsctvo_cdgo_estdo_estdo_cnta,
				exste_cntrto,
				sldo_estdo_cnta,
				dgto_chqo,
				fcha_imprsn,
				imprso,
				usro_imprsn,
				--Nuevos Campos
				cnsctvo_cdgo_rslcn_dn,
				cnsctvo_cdgo_tpo_dcmnto,
				cnsctvo_cdgo_estdo_dcmnto_fe
			)
			Select	 
					@nmro_estdo_cnta,
					fcha_incl_fctrcn,
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
					@nmro_prds,
					cts_sn_cnclr,
					drccn,
					cnsctvo_cdgo_cdd,
					tlfno,
					ttl_fctrdo,
					vlr_iva,
					sldo_fvr,
					sldo_antrr,
					ttl_pgr,
					Getdate(),
					usro_crcn,
					@cnsctvo_cdgo_prdo,
					cnsctvo_cdgo_autrzdr_espcl,
					0,
					@cnsctvo_cdgo_prdo_lqdcn,
					@cnsctvo_cdgo_estdo_estdo_cnta,
					'N',                 -- es porque no existe contrato
					ttl_fctrdo + vlr_iva,
					'0',		--digito de chequeo
					NULL, 		--fcha_imprsn
					'N', 		--imprso
					NULL,		--usro_imprsn
					@nConsecutivoResolucionDianPac,
					@nConsecutivoTipoDocumentoFactura,
					@nConsecutivoEstadoDocumentoIngresado
			From	#TMPEncabezadoResponsable

			If  @@error!=0  
				Begin 
					Set	@lnProcesoExitoso	=	1
					Set	@lcMensaje='Error insertando el estado de cuenta'
					Rollback tran uno
					Return -1
				End	

			-- se inserta informacion de los conceptos del estado de cuenta manual
		
			Insert into dbo.TbCuentasManualesConcepto
			(
				nmro_estdo_cnta,
				cnsctvo_cdgo_cncpto_lqdcn,
				cntdd,
				vlr,
				sldo,
				usro_crcn,
				usro_ultma_mdfccn,
				fcha_crcn,
				fcha_ultma_mdfccn
			)
			Select	
					@nmro_estdo_cnta,
					cnsctvo_cdgo_cncpto_lqdcn,
					cantidad, 
					valor,
					valor,
					@usro_crcn,
					@usro_crcn,
					Getdate(),
					Getdate()
			From	#Tmpdatosresponsable  

			If  @@error!=0  
				Begin 
					Set	@lnProcesoExitoso	=	1
					Set	@lcMensaje='Error insertando conceptos de estado de cuenta'
					Rollback tran uno
					Return -1
				End	


			Select 	@cnsctvo_cnta_mnls_cntrto =  isnull(max(cnsctvo_cnta_mnls_cntrto),0)	 
			From	dbo.TbCuentasManualesContrato With(NoLock)

			-- se inserta la informacion de los contratos del estado de cuenta manual.
			Insert into dbo.TbCuentasManualesContrato
			(
				cnsctvo_cnta_mnls_cntrto,
				nmro_estdo_cnta,
				cnsctvo_cdgo_tpo_cntrto,
				nmro_cntrto,
				vlr_cbrdo,
				sldo,
				cntdd_bnfcrs,
				cnsctvo_cdgo_pln,
				usro_crcn,
				fcha_crcn
			)
			Select 	
					(@cnsctvo_cnta_mnls_cntrto	+	 consecutivo_registro),
					@nmro_estdo_cnta,
					0 ,-- Es consecutivo tipo Contrato
					convert(varchar(15),numero_contrato), 
					vlr_cntrto, 
					Vlr_cntrto,   --  es  el saldo
					Cantidad_beneficiarios ,
					cnsctvo_cdgo_pln,
					@usro_crcn,
					getdate()
			From	#Tmpcontratoresponsable 		
		

			If  @@error!=0  
				Begin 
					Set	@lnProcesoExitoso	=	1
					Set	@lcMensaje='Error insertando contratos del estado de cuenta'
					Rollback tran uno
					Return -1
				End	

			-- se actualiza el consecutivo que fue asignado a cada contrato del estado de cuenta en la tabla temporal
			Update		a 
			Set			cnsctvo_cnta_mnls_cntrto = b.cnsctvo_cnta_mnls_cntrto
			From		#TmpBeneficiario				a 
			Inner Join	dbo.TbCuentasManualesContrato	b With(NoLock)
				On		(convert(varchar(15),a.numero_contrato)	 =	b.nmro_cntrto)
			Where		b.nmro_estdo_cnta	=	@nmro_estdo_cnta

			-- se inserta la informacion de los beneficiarios
			Insert into dbo.TbCuentasManualesBeneficiario
			(
				cnsctvo_cnta_mnls_cntrto,
				cnsctvo_bnfcro,
				cnsctvo_cdgo_tpo_idntfccn,
				nmro_idntfccn,
				prmr_aplldo,
				sgndo_aplldo,
				prmr_Nmbre,
				sgndo_nmbre,
				vlr,
				nmro_unco_idntfccn_bnfcro,
				usro_crcn,
				fcha_crcn
			)
			Select	
					cnsctvo_cnta_mnls_cntrto,
					Consecutivo_beneficiario ,
					cnsctvo_cdgo_tpo_idntfccn,
					numero_identificacion ,
					primer_apellido ,
					segundo_apellido ,
					primer_nombre ,
					segundo_nombre ,
					valor_beneficiario,
					0,
					@usro_crcn,
					getdate()
			From	#TmpBeneficiario


			If  @@error!=0  
				Begin 
					Set	@lnProcesoExitoso	=	1
					Set	@lcMensaje='Error insertando beneficiarios del estado de cuenta'
					Rollback tran uno
					Return -1
				End

			-- se actualiza informacion del consecutivo del beneficiario
	
			Update		#TmpConceptoBeneficiario 
			Set			cnsctvo_cnta_mnls_cntrto	 =	b.cnsctvo_cnta_mnls_cntrto
			From		#TmpConceptoBeneficiario		a 
			Inner Join	dbo.TbCuentasManualesContrato	b With(NoLock)
				On		(convert(varchar(15),a.numero_contrato)	 =	b.nmro_cntrto)
			Where		b.nmro_estdo_cnta	 =	@nmro_estdo_cnta

			-- se inserta informacion de los concpetos de los beneficiarios
			
			Insert into dbo.TbCuentasManualesBeneficiarioxConceptos
			(
				cnsctvo_cnta_mnls_cntrto,
				cnsctvo_bnfcro,
				cnsctvo_cdgo_cncpto_lqdcn,
				vlr,
				fcha_crcn,
				usro_crcn
			)
			Select	cnsctvo_cnta_mnls_cntrto,
					Consecutivo_beneficiario, 
					cnsctvo_cdgo_cncpto,
					valor, 
					getdate(),
					@usro_crcn
			From	#TmpConceptoBeneficiario 
			
			If  @@error!=0  
				Begin 
				Set	@lnProcesoExitoso	=	1
					Set	@lcMensaje='Error insertando conceptos del beneficiario el estado de cuenta'
					Rollback tran uno
					Return -1
				End	
		
			-- Actualizacion del texto de vencimiento
			update		a
			set			a.txto_vncmnto = 'INMEDIATO',
						a.usro_crcn = @usro_crcn
			from		dbo.tbCuentasManuales a With(RowLock)
			where		a.sldo_antrr > 0	
			And			a.nmro_estdo_cnta = @nmro_estdo_cnta;

			update		a
			set			a.txto_vncmnto = convert(date,h.fcha_mxma_pgo,103),
						a.usro_crcn = @usro_crcn
			from		dbo.tbCuentasManuales a With(RowLock)
			inner join  dbo.tbPeriodosliquidacion_Vigencias h With(NoLock) 
			on			a.cnsctvo_cdgo_prdo_lqdcn = h.cnsctvo_cdgo_prdo_lqdcn 
			where		a.sldo_antrr <= 0
			And			a.nmro_estdo_cnta = @nmro_estdo_cnta;		

			Insert	#tmpParametrosRecibidosCufe
			(
					NmroCnta,
					NumFac,								   
					FecFac,									
					ValFac,
					CodImp1,								
					ValImp1,								
					CodImp2,
					ValImp2,								
					CodImp3,								
					ValImp3,
					ValImp,									
					NitOFE,									
					TipAdq,
					NumAdq,									
					CITec			
			)
			Select		a.nmro_estdo_cnta,
						(convert(varchar,b.prfjo_atrzdo_fctrcn) + convert(varchar,a.nmro_estdo_cnta)), --NUMFAC
						Format(a.Fcha_crcn,'yyyyMMddhhmmss'), -- FECFAC
						a.ttl_fctrdo, -- VALFAC
						b.cdgo_rslcn_dn, --CODIMP1
						a.vlr_iva, -- VALIMP1
						'02', -- CODIMP2
						'0.00', -- VALIMP2
						'03', -- CODIMP3
						'0.00', -- VALIMP3
						a.ttl_pgr, -- VALIMP
						'805001157', -- NitOFE
						d.cdgo_dn, -- TIPADQ
						rtrim(ltrim(c.nmro_idntfccn)), -- NUMADQ
						b.clve_tcnca_dn -- CITec
			From		dbo.tbCuentasManuales					a With(NoLock)
			Inner Join 	BDAfiliacionValidador.dbo.tbResolucionesDIAN_vigencias	b With(NoLock)
				On		b.cnsctvo_cdgo_rslcn_dn = a.cnsctvo_cdgo_rslcn_dn
			Inner Join  BDAfiliacion.dbo.tbVinculados						c With(NoLock)
				On		a.nmro_unco_idntfccn_empldr = c.nmro_unco_idntfccn
			Inner Join  dbo.tbCodigosDIAN_Vigencias       d With(NoLock)
				On		d.cnsctvo_cdgo_llve_sos = c.cnsctvo_cdgo_tpo_idntfccn
			Where		@ldFechaSistema Between b.inco_vgnca And b.fn_vgnca
			And			d.cnsctvo_cdgo_tpo_cdgo_dn = 1
			And			a.nmro_estdo_cnta = @nmro_estdo_cnta;

			Insert	#tmpCUFEGenerado
			(
				   NmroCnta,
				   NumFac, 
				   CUFE,
				   cCUFE
			) 
			exec	BDAfiliacionValidador.dbo.spFEGenerarCUFE;

			Update		a
			Set			cufe = t.CUFE,
						a.usro_crcn = @usro_crcn
			From		dbo.tbCuentasManuales a
			Inner Join	#tmpCUFEGenerado t
			On			t.NmroCnta = a.nmro_estdo_cnta;

			Update		a
			Set			cdna_qr = concat('NumFac:',ltrim(rtrim(t.NumFac)),' ','FecFac:',ltrim(rtrim(t1.FecFac)),' ','NitFac:',ltrim(rtrim(t1.NitOFE)),' ','DocAdq:',ltrim(rtrim(t1.NumAdq)),' ','ValFac:',ltrim(rtrim(t1.ValFac)),' ','ValIva:',ltrim(rtrim(t1.ValImp1)),' ','ValOtroIm:','0.00',' ','ValFacIm:',ltrim(rtrim(t1.ValImp)),' ','CUFE:',t.cufe),
						a.usro_crcn = @usro_crcn
			From		dbo.tbCuentasManuales a
			Inner Join	#tmpCUFEGenerado t
			On			t.NmroCnta = a.nmro_estdo_cnta
			Inner join  #tmpParametrosRecibidosCufe t1
			On          t.NumFac = t1.NumFac

			-- Se realiza actualizacion del codigo de barras
			Update		a
			Set			a.cdgo_brrs='(' + LTRIM(RTRIM(c.idntfcdor_aplccn)) + ')' +  ltrim(rtrim(c.cdgo_ps)) + ltrim(rtrim(c.cdgo_emprsa_iac)) + ltrim(rtrim(c.idntfccn_tpo_rcdo)) + ltrim(rtrim(c.dgto_cntrl))  +
						'(' + ltrim(rtrim(c.idntfcdor_aplccn_usro)) + ')'  +  
						right(replicate('0',8)+ltrim(rtrim(a.nmro_estdo_cnta)),8) + 
						'(' + ltrim(rtrim(c.idntfcdor_aplccn_usro)) + ')'  +  
						right(replicate('0',12)+ltrim(rtrim(d.nmro_idntfccn)),12) + 
						 '(' + ltrim(rtrim(c.idntfcdor_aplccn_usro_ia1))  + ')' +
						right(replicate('0',10)+ltrim(rtrim(convert(varchar(12),ttl_pgr))),10) + 
						'(' + ltrim(rtrim(c.idntfcdor_aplccn_usro_ia2)) + ')' + convert(varchar(10),h.fcha_pgo,112)     			
			From 		dbo.tbCuentasManuales								a
			INNER JOIN  bdAfiliacion.dbo.tbVinculados						d With(NoLock)
				ON		a.nmro_unco_idntfccn_empldr = d.nmro_unco_idntfccn 
			INNER JOIN  dbo.tbPeriodosliquidacion_Vigencias	h With(NoLock)
				ON		a.cnsctvo_cdgo_prdo_lqdcn = h.cnsctvo_cdgo_prdo_lqdcn 
			INNER JOIN	dbo.TbEstructuraCodigoBarras_vigencias				c With(NoLock)
				on		@ldFechaSistema	between 	c.inco_vgnca 	and 	c. fn_vgnca
			Where 		cnsctvo_vgnca_estrctra_cdgo_brrs = 1    -- consecutivo del  codigo de barras

		End
	ELSE
	BEGIN
		-- actualiza el estado de cuenta manual
		Update		a
		Set			fcha_incl_fctrcn			=	b.fcha_incl_fctrcn,
					fcha_fnl_fctrcn				=	b.fcha_fnl_fctrcn,
					fcha_lmte_pgo				=	b.fcha_lmte_pgo,
					nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr,	
					cnsctvo_scrsl				=	b.cnsctvo_scrsl,
					cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte,
					cnsctvo_cdgo_tpo_idntfccn	=	b.cnsctvo_cdgo_tpo_idntfccn,
					nmro_idntfccn_rspnsble_pgo	=	b.nmro_idntfccn_rspnsble_pgo,
					dgto_vrfccn					=	b.dgto_vrfccn,
					nmbre_empldr				=	b.nmbre_empldr,
					nmbre_scrsl					=	b.nmbre_scrsl,
					cts_cnclr					=	@nmro_prds,
					drccn						=	b.drccn,
					cnsctvo_cdgo_cdd			=	b.cnsctvo_cdgo_cdd,
					tlfno						=	b.tlfno,
					ttl_fctrdo					=	b.ttl_fctrdo,
					vlr_iva						=	b.vlr_iva,
					sldo_fvr					=	b.sldo_fvr,
					ttl_pgr						=	b.ttl_pgr,
					sldo_antrr					=	b.sldo_antrr,
					sldo_estdo_cnta				=	b.ttl_fctrdo	+	b.vlr_iva,
					cnsctvo_cdgo_prdo			=	@cnsctvo_cdgo_prdo,
					cnsctvo_cdgo_autrzdr_espcl	=	b.cnsctvo_cdgo_autrzdr_espcl,
					cnsctvo_cdgo_prdo_lqdcn		=	@cnsctvo_cdgo_prdo_lqdcn,
					usro_ultma_mdfccn           =	@usro_crcn,
					fcha_ultma_mdfccn  			=	Getdate(),
					usro_crcn					= @usro_crcn
		From		dbo.TbCuentasManuales		a 
		Inner Join	#TMPEncabezadoResponsable	b
			On		(a.nmro_estdo_cnta	=	b.nmro_estdo_cnta)

		If  @@error!=0  
			Begin 
				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje='Error Actualizando el estado de cuenta manual'
				Rollback tran 
				Return -1
			End	

		Select	@nmro_estdo_cnta_mdfcdo	=	b.nmro_estdo_cnta
		From	#TMPEncabezadoResponsable b

		--  primero de hace para los conceptos del estado de cuenta.
		--  es decir  se actualizan los que ya existen, se adicionan los que no existen y se eliminan  los que existian antesy yo no estan.	 
			
		--Actualiza los concpetos que ya existen en la base de datos
		Update		a
		Set			cntdd				=	cantidad, 
					vlr					=	valor,
					sldo				=	valor,
					usro_ultma_mdfccn   =	@usro_crcn,
					fcha_ultma_mdfccn	=	Getdate()
		From		dbo.TbCuentasManualesConcepto		a 
		Inner Join 	#Tmpdatosresponsable				b
			On     (a.nmro_estdo_cnta		=	b.nmro_estdo_cnta
			And		a.cnsctvo_cdgo_cncpto_lqdcn	=	b.cnsctvo_cdgo_cncpto_lqdcn)

		If  @@error!=0  
			Begin 
				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje='Error Actualizando los  conceptos de estado de cuenta'
				Rollback tran 
				Return -1
			End	

		--Ingresa los conceptos nuevos a la base de datos 
		Insert into dbo.TbCuentasManualesConcepto
		(
			nmro_estdo_cnta,
			cnsctvo_cdgo_cncpto_lqdcn,
			cntdd,
			vlr,
			sldo,
			usro_crcn,
			usro_ultma_mdfccn,
			fcha_crcn,
			fcha_ultma_mdfccn
		)
		Select	
				a.nmro_estdo_cnta,
				a.cnsctvo_cdgo_cncpto_lqdcn,
				a.cantidad, 
				a.valor,
				a.valor,
				@usro_crcn,
				@usro_crcn,
				Getdate(),
				Getdate()
		From	#Tmpdatosresponsable  a
		Where	right(replicate('0',15)+ltrim(rtrim(a.nmro_estdo_cnta)),15) + right(replicate('0',15)+ltrim(rtrim(str(a.cnsctvo_cdgo_cncpto_lqdcn))),15)  
			Not  In (Select 	right(replicate('0',15)+ltrim(rtrim(b.nmro_estdo_cnta)),15) + right(replicate('0',15)+ltrim(rtrim(str(b.cnsctvo_cdgo_cncpto_lqdcn))),15)    From   dbo.TbCuentasManualesConcepto b )		

		If  @@error!=0  
			Begin 
				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje='Error insertando los registros nuevos para los conceptos del estado de cuenta'
				Rollback tran 
				Return -1
			End	

		--Elimina los conceptos que anteriormente estaban y ya no se encuentran en la base de datos.
		Delete from  dbo.TbCuentasManualesConcepto
		From		dbo.TbCuentasManualesConcepto a
		Where 	right(replicate('0',15)+ltrim(rtrim(a.nmro_estdo_cnta)),15) + right(replicate('0',15)+ltrim(rtrim(str(a.cnsctvo_cdgo_cncpto_lqdcn))),15)  
			not  in (select right(replicate('0',15)+ltrim(rtrim(b.nmro_estdo_cnta)),15) + right(replicate('0',15)+ltrim(rtrim(str(b.cnsctvo_cdgo_cncpto_lqdcn))),15)   From   #Tmpdatosresponsable b )		
		And	a.nmro_estdo_cnta	=	@nmro_estdo_cnta_mdfcdo


		If  @@error!=0  
			Begin 
				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje='Error eliminando los conceptos del estado de cuenta'
				Rollback tran 
				Return -1
			End	

		--Ahora se hace para los contratos
		-- se actualiza los contratos que ya existian en la base de datos.
		Update		a
		Set			nmro_cntrto			=	convert(varchar(15),numero_contrato), 
					vlr_cbrdo			=	vlr_cntrto, 
					sldo				=	vlr_cntrto, 
					cntdd_bnfcrs		=	Cantidad_beneficiarios ,
					cnsctvo_cdgo_pln	=	b.cnsctvo_cdgo_pln
		From		dbo.TbCuentasManualesContrato	a 
		Inner Join	#Tmpcontratoresponsable			b
			On		(a.cnsctvo_cnta_mnls_cntrto	=	b.cnsctvo_cnta_mnls_cntrto)

		If  @@error!=0  
			Begin 
				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje='Error Actualizando la informacion del contratos'
				Rollback tran 
				Return -1
			End	

		-- se consulta el numero de estado de cuenta que se esta modificando
		Select	@nmro_estdo_cnta = nmro_estdo_cnta From #TMPEncabezadoResponsable

		-- se borran los registros que anteirormente estaban pero ya no estan en la tabla temporal
		Delete From	dbo.TbCuentasManualesContrato
		From		dbo.TbCuentasManualesContrato	a
		Where 		a.nmro_estdo_cnta	=	@nmro_estdo_cnta
		And 		a.cnsctvo_cnta_mnls_cntrto	 not in 	(Select	cnsctvo_cnta_mnls_cntrto From #Tmpcontratoresponsable )

		If  @@error!=0  
			Begin 
				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje='Error borrando los contratos de los estados de cuenta que anteriormente existian'
				Rollback tran 
				Return -1
			End	

		-- se consulta el maximo concecutivo que sigue en la tabla  cnsctvo_cnta_mnls_cntrto
		Select 	@cnsctvo_cnta_mnls_cntrto	 =	  isnull(max(cnsctvo_cnta_mnls_cntrto),0)	 
		From	dbo.TbCuentasManualesContrato With(NoLock)


		-- se inserta la informacion de los contratos del estado de cuenta manual.

		-- se crea una tabla temporal con los nuevos registros
		Insert	Into	#TmpcontratoresponsableNuevos
		select	
				nmro_estdo_cnta,
				0					cnsctvo_cdgo_tpo_cntrto,
				convert(varchar(15),numero_contrato)	nmro_cntrto, 
				vlr_cntrto				vlr_cbrdo, 
				Vlr_cntrto				sldo,   
				Cantidad_beneficiarios 			cntdd_bnfcrs,
				cnsctvo_cdgo_pln,
				@usro_crcn				usro_crcn,
				getdate()				fcha_crcn
		From 	#Tmpcontratoresponsable
		Where 	cnsctvo_cnta_mnls_cntrto		=	0


		-- se insertan los nuevos contratos	
		Insert into dbo.TbCuentasManualesContrato
		(
			cnsctvo_cnta_mnls_cntrto,
			nmro_estdo_cnta,
			cnsctvo_cdgo_tpo_cntrto,
			nmro_cntrto,
			vlr_cbrdo,
			sldo,
			cntdd_bnfcrs,
			cnsctvo_cdgo_pln,
			usro_crcn,
			fcha_crcn
		)
		Select 	
				(@cnsctvo_cnta_mnls_cntrto	+	 nmro_rgstro),
				nmro_estdo_cnta,
				cnsctvo_cdgo_tpo_cntrto,
				nmro_cntrto,
				vlr_cbrdo,
				sldo,
				cntdd_bnfcrs ,
				cnsctvo_cdgo_pln,
				usro_crcn,
				fcha_crcn
		From	#TmpcontratoresponsableNuevos 


		If  @@error!=0  
			Begin 
				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje='Error insertando los nuevos  contratos del estado de cuenta'
				Rollback tran 
				Return -1
			End	

		-- se actualiza el consecutivo asignado del estado de cuenta manual contrato
		Update		a 
		Set			cnsctvo_cnta_mnls_cntrto 	=	b.cnsctvo_cnta_mnls_cntrto
		From		#TmpBeneficiario				a 
		Inner Join	dbo.TbCuentasManualesContrato	b With(NoLock)
			On		a.numero_contrato	 =	convert(varchar(15),b.nmro_cntrto)
		And			b.nmro_estdo_cnta	=	@nmro_estdo_cnta


		-- ahora se hace para todos los beneficiarios
		Update		a
		Set			cnsctvo_cdgo_tpo_idntfccn	=	b.cnsctvo_cdgo_tpo_idntfccn,
					nmro_idntfccn				=	b.numero_identificacion,
					prmr_aplldo 				=	b.primer_apellido,
					sgndo_aplldo 				=	b.segundo_apellido,
					prmr_Nmbre					=	b.primer_nombre,
					sgndo_nmbre 				=	b.segundo_nombre,
					vlr							=	b.valor_beneficiario
		From		dbo.TbCuentasManualesBeneficiario	a 
		Inner Join  #TmpBeneficiario					b
			On		(a.cnsctvo_cnta_mnls_cntrto	=	b.cnsctvo_cnta_mnls_cntrto
			And		a.cnsctvo_bnfcro			=	b.Consecutivo_beneficiario)


		If  @@error!=0  
			Begin 
				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje='Error actualizando los beneficiarios del estado de cuenta'
				Rollback tran 
				Return -1
			End	

		-- se inserta  la informacion del beneficiarios nuevos
		Insert into dbo.TbCuentasManualesBeneficiario
		(
			cnsctvo_cnta_mnls_cntrto,
			cnsctvo_bnfcro,
			cnsctvo_cdgo_tpo_idntfccn,
			nmro_idntfccn,
			prmr_aplldo,
			sgndo_aplldo,
			prmr_Nmbre,
			sgndo_nmbre,
			vlr,
			nmro_unco_idntfccn_bnfcro,
			usro_crcn,
			fcha_crcn
		)
		Select	
				cnsctvo_cnta_mnls_cntrto,
				Consecutivo_beneficiario ,
				cnsctvo_cdgo_tpo_idntfccn,
				numero_identificacion ,
				primer_apellido ,
				segundo_apellido ,
				primer_nombre ,
				segundo_nombre ,
				valor_beneficiario,
				0,
				@usro_crcn,
				getdate()
		From	#TmpBeneficiario a
		Where 	Not Exists ( Select  1 From dbo.TbCuentasManualesBeneficiario b
							Where   a.cnsctvo_cnta_mnls_cntrto = b.cnsctvo_cnta_mnls_cntrto
							And    a.Consecutivo_beneficiario = b.cnsctvo_bnfcro)


		If  @@error!=0  
			Begin 
				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje='Error insertando  los nuevos  beneficiarios del estado de cuenta'
				Rollback tran 
				Return -1
			End	

		-- se borran los beneficiarios que anteriormente estaban y ya no aparecen en la tabla temporal
		Delete From	dbo.TbCuentasManualesBeneficiario
		From	dbo.TbCuentasManualesBeneficiario a 
		Inner Join dbo.tbCuentasManualesContrato b
			on a.cnsctvo_cnta_mnls_cntrto	=	b.cnsctvo_cnta_mnls_cntrto
		Where	right(replicate('0',15)+ltrim(rtrim(str(a.cnsctvo_cnta_mnls_cntrto))),15) + right(replicate('0',15)+ltrim(rtrim(str(a.cnsctvo_bnfcro))),15)  
			not in (Select	right(replicate('0',15)+ltrim(rtrim(str(cnsctvo_cnta_mnls_cntrto))),15) + right(replicate('0',15)+ltrim(rtrim(str(Consecutivo_beneficiario))),15)  
			           From	#TmpBeneficiario)
		And	b.nmro_estdo_cnta		=	@nmro_estdo_cnta


		If  @@error!=0  
		Begin 
			Set	@lnProcesoExitoso	=	1
			Set	@lcMensaje='Error eliminando los beneficiarios  del estado de cuenta'
			Rollback tran 
			Return -1
		End	


		-- ahora se  hace para los conceptos de los beneficiarios
		-- primero se actualiza el campo de consecutivo del benficiario concepto	

		Update		a 
		Set			cnsctvo_cnta_mnls_cntrto	 =	b.cnsctvo_cnta_mnls_cntrto
		From		#TmpConceptoBeneficiario		a 
		Inner Join	dbo.TbCuentasManualesContrato	b With(NoLock)
			On		(a.numero_contrato	 =	convert(varchar(15),b.nmro_cntrto))
		Where		b.nmro_estdo_cnta	 =	@nmro_estdo_cnta


		Update		a
		Set			vlr	=	b.valor
		From		dbo.TbCuentasManualesBeneficiarioxConceptos a 
		Inner Join	#TmpConceptoBeneficiario b
			On 		(a.cnsctvo_cnta_mnls_cntrto	=	b.cnsctvo_cnta_mnls_cntrto
			And		a.cnsctvo_bnfcro			=	b.Consecutivo_beneficiario 
			And		a.cnsctvo_cdgo_cncpto_lqdcn	=	b.cnsctvo_cdgo_cncpto	)


		If  @@error!=0  
			Begin 
				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje='Error Actualizando los conceptos de los beneficiarios  del estado de cuenta'
				Rollback tran 
				Return -1
			End	

		
		Insert into dbo.TbCuentasManualesBeneficiarioxConceptos
		(
			cnsctvo_cnta_mnls_cntrto,
			cnsctvo_bnfcro,
			cnsctvo_cdgo_cncpto_lqdcn,
			vlr,
			fcha_crcn,
			usro_crcn
		)
		Select	
				cnsctvo_cnta_mnls_cntrto,
				Consecutivo_beneficiario, 
				cnsctvo_cdgo_cncpto,
				valor, 
				getdate(),
				@usro_crcn
		From	#TmpConceptoBeneficiario a
		Where 	Not Exists ( Select  1 From dbo.TbCuentasManualesBeneficiarioxConceptos b
							where   a.cnsctvo_cnta_mnls_cntrto = b.cnsctvo_cnta_mnls_cntrto
							and		a.Consecutivo_beneficiario = b.cnsctvo_bnfcro
							and		a.cnsctvo_cdgo_cncpto     =  b.cnsctvo_cdgo_cncpto_lqdcn)
			
		If  @@error!=0  
			Begin 
				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje='Error Insertando los conceptos de los beneficiarios  del estado de cuenta'
				Rollback tran 
				Return -1
			End	

		Delete From dbo.TbCuentasManualesBeneficiarioxConceptos 
		From		dbo.TbCuentasManualesBeneficiarioxConceptos	a 
		Inner Join	dbo.tbCuentasManualesBeneficiario			b With(NoLock)
			On		b.cnsctvo_cnta_mnls_cntrto		=	a.cnsctvo_cnta_mnls_cntrto
			And		b.cnsctvo_bnfcro			=	a.cnsctvo_bnfcro
		Inner Join  dbo.tbCuentasManualesContrato				c With(NoLock)
			On		c.cnsctvo_cnta_mnls_cntrto		=	b.cnsctvo_cnta_mnls_cntrto
		Where		c.nmro_estdo_cnta	 		=	@nmro_estdo_cnta
		And	not exists ( select 1  from  #TmpConceptoBeneficiario  d 
						where	a.cnsctvo_cnta_mnls_cntrto 		= 	d.cnsctvo_cnta_mnls_cntrto
						and		a.cnsctvo_bnfcro	        		=	d.Consecutivo_beneficiario
						and 	a.cnsctvo_cdgo_cncpto_lqdcn		=	d.cnsctvo_cdgo_cncpto )


		If  @@error!=0  
			Begin 
				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje='Error eliminando los  conceptos de los beneficiarios  del estado de cuenta'
				Rollback tran 
				Return -1
			End	

		-- Actualizacion del texto de vencimiento
		update		a
		set			a.txto_vncmnto = 'INMEDIATO',
					a.usro_crcn =  @usro_crcn
		from		dbo.tbCuentasManuales a With(RowLock)
		where		a.sldo_antrr > 0	
		And			a.nmro_estdo_cnta = @nmro_estdo_cnta_mdfcdo;

		update		a
		set			a.txto_vncmnto = convert(date,h.fcha_mxma_pgo,103) ,
					a.usro_crcn =  @usro_crcn
		from		dbo.tbCuentasManuales a With(RowLock)
		inner join  dbo.tbPeriodosliquidacion_Vigencias h With(NoLock) 
		on			a.cnsctvo_cdgo_prdo_lqdcn = h.cnsctvo_cdgo_prdo_lqdcn 
		where		a.sldo_antrr <= 0
		And			a.nmro_estdo_cnta = @nmro_estdo_cnta_mdfcdo;

		--generacion de CUFE
		Insert	#tmpParametrosRecibidosCufe
		(
				NmroCnta,
				NumFac,								   
				FecFac,									
				ValFac,
				CodImp1,								
				ValImp1,								
				CodImp2,
				ValImp2,								
				CodImp3,								
				ValImp3,
				ValImp,									
				NitOFE,									
				TipAdq,
				NumAdq,									
				CITec			
		)
		Select		a.nmro_estdo_cnta,
					(convert(varchar,b.prfjo_atrzdo_fctrcn) + convert(varchar,a.nmro_estdo_cnta)), --NUMFAC
					Format(a.Fcha_crcn,'yyyyMMddhhmmss'), -- FECFAC
					a.ttl_fctrdo, -- VALFAC
					b.cdgo_rslcn_dn, --CODIMP1
					a.vlr_iva, -- VALIMP1
					'02', -- CODIMP2
					'0.00', -- VALIMP2
					'03', -- CODIMP3
					'0.00', -- VALIMP3
					a.ttl_pgr, -- VALIMP
					'805001157', -- NitOFE
					d.cdgo_dn, -- TIPADQ
					rtrim(ltrim(c.nmro_idntfccn)), -- NUMADQ
					b.clve_tcnca_dn -- CITec
		From		dbo.tbCuentasManuales									a With(NoLock)
		Inner Join 	BDAfiliacionValidador.dbo.tbResolucionesDIAN_vigencias	b With(NoLock)
			On		b.cnsctvo_cdgo_rslcn_dn = a.cnsctvo_cdgo_rslcn_dn
		Inner Join  BDAfiliacion.dbo.tbVinculados							c With(NoLock)
			On		a.nmro_unco_idntfccn_empldr = c.nmro_unco_idntfccn
		Inner Join  dbo.tbCodigosDIAN_Vigencias								d With(NoLock)
			On		d.cnsctvo_cdgo_llve_sos = c.cnsctvo_cdgo_tpo_idntfccn
		Where		@ldFechaSistema Between b.inco_vgnca And b.fn_vgnca
		And			d.cnsctvo_cdgo_tpo_cdgo_dn = 1
		And			a.nmro_estdo_cnta = @nmro_estdo_cnta_mdfcdo;		

		Insert	#tmpCUFEGenerado
		(
			   NmroCnta,
			   NumFac, 
			   CUFE,
			   cCUFE
		) 
		exec	bdAfiliacionValidador.dbo.spFEGenerarCUFE;

		Update		a
		Set			cufe = t.CUFE,
					a.usro_crcn =  @usro_crcn
		From		dbo.tbCuentasManuales a
		Inner Join	#tmpCUFEGenerado t
		On			t.NmroCnta = a.nmro_estdo_cnta;

		-- Generacion de QR
		Update		a
		Set			cdna_qr = concat('NumFac:',ltrim(rtrim(t.NumFac)),' ','FecFac:',ltrim(rtrim(t1.FecFac)),' ','NitFac:',ltrim(rtrim(t1.NitOFE)),' ','DocAdq:',ltrim(rtrim(t1.NumAdq)),' ','ValFac:',ltrim(rtrim(t1.ValFac)),' ','ValIva:',ltrim(rtrim(t1.ValImp1)),' ','ValOtroIm:','0.00',' ','ValFacIm:',ltrim(rtrim(t1.ValImp)),' ','CUFE:',t.cufe),
					a.usro_crcn =  @usro_crcn
		From		dbo.tbCuentasManuales a
		Inner Join	#tmpCUFEGenerado t
		On			t.NmroCnta = a.nmro_estdo_cnta
		Inner join  #tmpParametrosRecibidosCufe t1
		On          t.NumFac = t1.NumFac

		-- Se realiza actualizacion del codigo de barras
		Update		a
		Set			a.cdgo_brrs='(' + LTRIM(RTRIM(c.idntfcdor_aplccn)) + ')' +  ltrim(rtrim(c.cdgo_ps)) + ltrim(rtrim(c.cdgo_emprsa_iac)) + ltrim(rtrim(c.idntfccn_tpo_rcdo)) + ltrim(rtrim(c.dgto_cntrl))  +
					'(' + ltrim(rtrim(c.idntfcdor_aplccn_usro)) + ')'  +  
					right(replicate('0',8)+ltrim(rtrim(a.nmro_estdo_cnta)),8) + 
					'(' + ltrim(rtrim(c.idntfcdor_aplccn_usro)) + ')'  +  
					right(replicate('0',12)+ltrim(rtrim(d.nmro_idntfccn)),12) + 
					 '(' + ltrim(rtrim(c.idntfcdor_aplccn_usro_ia1))  + ')' +
					right(replicate('0',10)+ltrim(rtrim(convert(varchar(12),ttl_pgr))),10) + 
					'(' + ltrim(rtrim(c.idntfcdor_aplccn_usro_ia2)) + ')' + convert(varchar(10),h.fcha_pgo,112)     			
		From 		dbo.tbCuentasManuales								a
		INNER JOIN  bdAfiliacion.dbo.tbVinculados						d With(NoLock)
			ON		a.nmro_unco_idntfccn_empldr = d.nmro_unco_idntfccn 
		INNER JOIN  dbo.tbPeriodosliquidacion_Vigencias					h With(NoLock)
			ON		a.cnsctvo_cdgo_prdo_lqdcn = h.cnsctvo_cdgo_prdo_lqdcn 
		INNER JOIN	dbo.TbEstructuraCodigoBarras_vigencias				c With(NoLock)
			on		@ldFechaSistema	between 	c.inco_vgnca 	and 	c. fn_vgnca
		Where 		cnsctvo_vgnca_estrctra_cdgo_brrs = 1    -- consecutivo del  codigo de barras

	END	

	Commit tran uno

End