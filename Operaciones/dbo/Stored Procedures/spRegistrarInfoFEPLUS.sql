


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	         :  spRegistrarInfoFEPLUS
* Desarrollado por		 :  <\A  Carlos Vela - Qvision							A\>
* Descripcion			 :  <\D  Asigna al estado de cuenta la información necesaria para facturación eléctronica D\>
* Observaciones		     :  <\O													O\>
* Parametros			 :  <\P  Número de la liquidación						P\>
** Fecha Creacion		 :  <\FC 2019/06/05									FC\>
*  
*---------------------------------------------------------------------------------*/
CREATE Procedure [dbo].[spRegistrarInfoFEPLUS] 
		@cnsctvo_cdgo_lqdcn UdtConsecutivo,
		@mnsje_slda	varchar(3000) Output, 
		@cdgo_slda int OutPut
As
  
Begin 
	Declare
	@ldFechaSistema	datetime=getdate(),
	@CODIGO_BARRAS_PAC int=1

-- Eliminamos las tablas temporales
	IF OBJECT_ID('tempdb..#tmpParametrosRecibidosCufe') IS NOT NULL 
		DROP TABLE #tmpParametrosRecibidosCufe

	IF OBJECT_ID('tempdb..#tmpCUFEGenerado') IS NOT NULL 
		DROP TABLE #tmpCUFEGenerado


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
	)

	Create Table #tmpCUFEGenerado
	(
		   NmroCnta varchar(15),
		   NumFac varchar(30),
		   CUFE varchar(250),
		   cCUFE varchar(250),
	)

	Begin Try

			--Texto por defecto 
			Update	a
			Set		a.txto_vncmnto = 'INMEDIATO'
			From	dbo.tbEstadosCuenta a 
			where	a.sldo_antrr > 0
			And     a.cnsctvo_cdgo_lqdcn	=	@cnsctvo_cdgo_lqdcn;

			-- Se realiza calculo de texto de vencimiento de la factura
			Update		a
			Set			a.txto_vncmnto = convert(date,h.fcha_mxma_pgo,103)
			From		dbo.tbEstadosCuenta									a 
			INNER JOIN  dbo.tbLiquidaciones									g With(NoLock) 
				ON		a.cnsctvo_cdgo_lqdcn = g.cnsctvo_cdgo_lqdcn 
			INNER JOIN  dbo.tbPeriodosliquidacion_Vigencias					h With(NoLock) 
				ON		g.cnsctvo_cdgo_prdo_lqdcn = h.cnsctvo_cdgo_prdo_lqdcn 
			Where		a.cnsctvo_cdgo_lqdcn	=	@cnsctvo_cdgo_lqdcn 
						AND a.sldo_antrr <= 0;

			-- Tomamos la secuencia de facturacion
			Update		a
			Set			nmro_estdo_cnta = (next value for dbo.seqNumeroEstadoCuentaDIAN)
			From		dbo.tbEstadosCuenta a
			Where    a.cnsctvo_cdgo_lqdcn	=	@cnsctvo_cdgo_lqdcn;

			If @@ROWCOUNT>0 
				Begin
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
							Format(a.Fcha_crcn,'yyyyMMddHHmmss'), -- FECFAC
							cast(a.ttl_fctrdo as numeric(12,2)), -- VALFAC
							'01', --CODIMP1
							cast(a.vlr_iva as numeric(12,2)), -- VALIMP1
							'02', -- CODIMP2
							'0.00', -- VALIMP2
							'03', -- CODIMP3
							'0.00', -- VALIMP3
							cast(a.ttl_fctrdo as numeric(12,2)) + cast(a.vlr_iva as numeric(12,2)), -- VALIMP
							'805001157', -- NitOFE
							d.cdgo_dn, -- TIPADQ
							rtrim(ltrim(c.nmro_idntfccn)), -- NUMADQ
							b.clve_tcnca_dn -- CITec
				From		dbo.tbEstadosCuenta										a With(NoLock)
				Inner Join 	BDAfiliacionValidador.dbo.tbResolucionesDIAN_vigencias	b With(NoLock)
					On		b.cnsctvo_cdgo_rslcn_dn = a.cnsctvo_cdgo_rslcn_dn
				Inner Join  BDAfiliacion.dbo.tbVinculados							c With(NoLock)
					On		a.nmro_unco_idntfccn_empldr = c.nmro_unco_idntfccn
				Inner Join  dbo.tbCodigosDIAN_Vigencias								d With(NoLock)
					On		d.cnsctvo_cdgo_llve_sos = c.cnsctvo_cdgo_tpo_idntfccn
				Where		@ldFechaSistema Between b.inco_vgnca And b.fn_vgnca
				And			d.cnsctvo_cdgo_tpo_cdgo_dn = 1
				And         a.cnsctvo_cdgo_lqdcn	=	@cnsctvo_cdgo_lqdcn;


				Insert	#tmpCUFEGenerado
				(
					   NmroCnta,
					   NumFac, 
					   CUFE,
					   cCUFE
				) 
				exec	BDAfiliacionValidador.dbo.spFEGenerarCUFE;

				Update		a
				Set			cufe = t.CUFE
				From		dbo.tbEstadosCuenta a
				Inner Join	#tmpCUFEGenerado t
				On			t.NmroCnta = a.nmro_estdo_cnta;

				-- 
				IF @@ROWCOUNT >0 
					BEGIN
						-- Se genera el codigo QR a partir de la informacion del cufe	
						Update		a
							Set			cdna_qr = concat('NumFac:',ltrim(rtrim(t.NumFac)),' ','FecFac:',ltrim(rtrim(t1.FecFac)),' ','NitFac:',ltrim(rtrim(t1.NitOFE)),' ','DocAdq:',ltrim(rtrim(t1.NumAdq)),' ','ValFac:',ltrim(rtrim(t1.ValFac)),' ','ValIva:',ltrim(rtrim(t1.ValImp1)),' ','ValOtroIm:','0.00',' ','ValFacIm:',ltrim(rtrim(t1.ValImp)),' ','CUFE:',t.cufe)
							From		dbo.tbEstadosCuenta a
							Inner Join	#tmpCUFEGenerado t
							On			t.NmroCnta = a.nmro_estdo_cnta
							Inner join  #tmpParametrosRecibidosCufe t1
							On          t.NumFac = t1.NumFac

						--Se realiza el calculo del codigo de barras
							Update		a
							Set			a.cdgo_brrs='(' + LTRIM(RTRIM(c.idntfcdor_aplccn)) + ')' +  ltrim(rtrim(c.cdgo_ps)) + ltrim(rtrim(c.cdgo_emprsa_iac)) + ltrim(rtrim(c.idntfccn_tpo_rcdo)) + ltrim(rtrim(c.dgto_cntrl))  +
										'(' + ltrim(rtrim(c.idntfcdor_aplccn_usro)) + ')'  +  
										right(replicate('0',8)+ltrim(rtrim(a.nmro_estdo_cnta)),8) + 
										'(' + ltrim(rtrim(c.idntfcdor_aplccn_usro)) + ')'  +  
										right(replicate('0',12)+ltrim(rtrim(d.nmro_idntfccn)),12) + 
										 '(' + ltrim(rtrim(c.idntfcdor_aplccn_usro_ia1))  + ')' +
										right(replicate('0',10)+ltrim(rtrim(convert(varchar(12),ttl_pgr))),10) + 
										'(' + ltrim(rtrim(c.idntfcdor_aplccn_usro_ia2)) + ')' + convert(varchar(10),h.fcha_pgo,112)     			
							From 		dbo.tbEstadosCuenta						a
							INNER JOIN  bdAfiliacion.dbo.tbVinculados			d With(NoLock)
								ON		a.nmro_unco_idntfccn_empldr = d.nmro_unco_idntfccn 
							INNER JOIN  dbo.tbLiquidaciones						g With(NoLock)
								ON		a.cnsctvo_cdgo_lqdcn = g.cnsctvo_cdgo_lqdcn 
							INNER JOIN  dbo.tbPeriodosliquidacion_Vigencias		h With(NoLock)
								ON		g.cnsctvo_cdgo_prdo_lqdcn = h.cnsctvo_cdgo_prdo_lqdcn 
							INNER JOIN  dbo.TbEstructuraCodigoBarras_vigencias  c With(NoLock)
								on		@ldFechaSistema between c.inco_vgnca and c. fn_vgnca
							Inner Join	#tmpCUFEGenerado t
								On		t.NmroCnta = a.nmro_estdo_cnta
							Where c.cnsctvo_vgnca_estrctra_cdgo_brrs = @CODIGO_BARRAS_PAC   -- consecutivo del  codigo de barras 
								and @ldFechaSistema between c.inco_vgnca and c.fn_vgnca


						Set @mnsje_slda	= 'Información de Facturación electronica asignada exitosamente';
						Set @cdgo_slda	= 0;
				
					END
				ELSE
					BEGIN
						Set @mnsje_slda	= 'No fue posible asignar los CUFEs a la liquidación '+cast(@cnsctvo_cdgo_lqdcn as varchar(12));
						Set @cdgo_slda	= 1;
					END
				End
			Else 
				Begin
						Set @mnsje_slda	= 'No fue posible establecer el numero(s) de estado de cuenta para la liquidación '+cast(@cnsctvo_cdgo_lqdcn as varchar(12));
						Set @cdgo_slda	= 1;
				End


	End Try
	Begin Catch
		Set @mnsje_slda	= ERROR_PROCEDURE()+Concat(ERROR_MESSAGE(), ' ', ERROR_PROCEDURE(), ' ', ERROR_LINE());
		Set @cdgo_slda	= 1;


	End Catch

	DROP TABLE #tmpParametrosRecibidosCufe
	DROP TABLE #tmpCUFEGenerado

End

