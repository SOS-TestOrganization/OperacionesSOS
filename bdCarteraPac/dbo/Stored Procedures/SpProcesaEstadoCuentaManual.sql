/*---------------------------------------------------------------------------------
* Metodo o PRG			:  SpProcesaEstadoCuentaManual
* Desarrollado por		: <\A	Ing. Rolando Simbaqueva A\> 
* Descripcion			: <\D	Permite generar la liquidacion previa D\>
* Observaciones			: <\O	O\>
* Parametros			: <\P	P\>
* Variables				: <\V	Instruccion Sql  a ejecutar V\>
*						: <\V	Parmetros que condicionan la consulta V\>
*						: <\V	Fecha que se convierte de date a caracter V\>
* Fecha Creacion		: <\FC	2002/06/21 FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM	Ing. Jorge Ivan Rivera Gallego AM\>
* Descripcion			: <\DM	Aplicación proceso optimización técnica DM\>
* Nuevos Parametros		: <\PM	PM\>
* Nuevas Variables		: <\VM	VM\>
* Fecha Modificacion	: <\FM	2005/09/15 FM\>
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM	Ing. Jean Paul Villaquiran Madrigal AM\>
* Descripcion			: <\DM	Se realiza refactorización de codigo ya que se encuentra una cantidad no recomendable de lineas de codigo, DM\>
						: <\DM	codigo desordenado y bloques duplicado sin causa justa (-_-) DM\>
* Nuevos Parametros		: <\PM	PM\>
* Nuevas Variables		: <\VM	VM\>
* Fecha Modificacion	: <\FM	2019/05/02FM\>
*--------------------------------------------------------------------------------- */
CREATE PROCEDURE [dbo].[SpProcesaEstadoCuentaManual]
(
		@lnTipo Int,
		@lnPorcentajeIncremento UdtValorDecimales,	
		@ldFechaInicialFacturacion Datetime,
		@ldFechaFinalFacturacion Datetime,
		@ldFechaLimitePago Datetime,
		@lcUsuarioAutorizador UdtConsecutivo,
		@lcUsuario Udtusuario,
		@nmro_estdo_cnta Varchar(15),
		@cnsctvo_cdgo_tpo_prcso UdtConsecutivo,
		@lntotalContratos UdtValorGrande output,
		@lnTotalPagar UdtValorGrande output,
		@Max_cnsctvo_prcso UdtConsecutivo output,
		@lnProcesoExitoso Int output,
		@lcMensaje Char(200) output
)
AS
		Declare
		@lcControlaError UdtConsecutivo = 0,
		@ldFechaSistema Datetime = Getdate(),
		@cnsctvo_cdgo_prdo UdtConsecutivo = 99999,
		@nmro_prds Int,
		@cnsctvo_cdgo_prdo_lqdcn Int,
		@cnsctvo_cdgo_estdo_estdo_cnta Int,
		@vlr_actl Int,
		@vlr_antrr Int,
		@usro_crcn Varchar(30),
		@cnsctvo_cnta_mnls_cntrto UdtConsecutivo,
		@Fecha_Inicio_Proceso Datetime = Getdate(),
		@Fecha_Fin_Proceso Datetime,
		@cnsctvo_cdgo_prmtro_prgrmcn UdtConsecutivo,
		@vlr_descuento Numeric(12,2),
		@ldFecha_Corte Datetime,
		@ldFechaParametroConceptos Datetime,
		@creacionCuentaManual int = 1,
		@modificacionCuentaManual int = 2,
		@valorActual int;

		Set Nocount On;

		begin--Creacion Tablas Temporales

		Create	
		Table	#Tmpcontratos_Antes_liquidar
				(cnsctvo_cdgo_tpo_cntrto udtConsecutivo,	nmro_cntrto udtNumeroFormulario,
				cnsctvo_cdgo_pln udtConsecutivo,			inco_vgnca_cntrto Datetime,
				fn_vgnca_cntrto Datetime,					nmro_unco_idntfccn_afldo udtConsecutivo,
				cnsctvo_cbrnza udtConsecutivo,				nmro_unco_idntfccn_aprtnte udtConsecutivo,
				cnsctvo_vgnca_cbrnza udtConsecutivo,		cnsctvo_scrsl_ctznte udtConsecutivo,
				inco_vgnca_cbrnza Datetime,					fn_vgnca_cbrnza Datetime,
				cta_mnsl Numeric(9,2),						cnsctvo_cdgo_prdcdd_prpgo udtConsecutivo,
				nmro_estdo_cnta VarChar(15),				cnsctvo_cdgo_clse_aprtnte udtConsecutivo,
				vlr_ttl_cntrto Numeric(12,0),				vlr_ttl_cntrto_sn_iva Numeric(12,0),
				cntdd_ttl_bnfcrs Int,						Grupo_Conceptos Int
				)

		Create
		Table	#Tmpcontratos
				(
				ID_Num Int IDENTITY(1,1),					cnsctvo_cdgo_tpo_cntrto udtConsecutivo,
				nmro_cntrto udtNumeroFormulario,			cnsctvo_cdgo_pln udtConsecutivo,
				inco_vgnca_cntrto Datetime,					fn_vgnca_cntrto Datetime,
				nmro_unco_idntfccn_afldo udtConsecutivo,	cnsctvo_cbrnza udtConsecutivo,
				nmro_unco_idntfccn_aprtnte udtConsecutivo,	cnsctvo_vgnca_cbrnza udtConsecutivo,
				cnsctvo_scrsl_ctznte udtConsecutivo,		inco_vgnca_cbrnza Datetime,
				fn_vgnca_cbrnza Datetime,					cta_mnsl Numeric(9,2),
				cnsctvo_cdgo_prdcdd_prpgo udtConsecutivo,	nmro_estdo_cnta Varchar(15),
				cnsctvo_cdgo_clse_aprtnte udtConsecutivo,	vlr_ttl_cntrto Numeric(12,0),
				vlr_ttl_cntrto_sn_iva Numeric(12,0),		cntdd_ttl_bnfcrs Int,
				Grupo_Conceptos Int,						Activo Int,
				Cntrto_igual_cro Int
				)

		Create
		Table	#tmpBeneficiarios
				(ID_Num Int IDENTITY(1,1),							nmro_unco_idntfccn_aprtnte udtConsecutivo,
				cnsctvo_scrsl_ctznte udtConsecutivo,				cnsctvo_cdgo_clse_aprtnte udtConsecutivo,
				nmro_unco_idntfccn_afldo udtConsecutivo,			cnsctvo_cdgo_tpo_cntrto udtConsecutivo,
				nmro_cntrto udtNumeroFormulario,					cnsctvo_bnfcro udtConsecutivo,
				nmro_unco_idntfccn_bnfcro udtConsecutivo,			inco_vgnca_bnfcro Datetime,
				fn_vgnca_bnfcro Datetime,							vlr_upc Numeric(12,0),
				cnsctvo_cnta_mnls_cntrto udtConsecutivo,			vlr_dcto_comercial Numeric(12,0),
				vlr_otros_dcts Numeric(12,0),						vlr_iva Numeric(12,0),
				vlr_cta Numeric(12,0),								vlr_ttl_bnfcro Numeric(12,0),
				vlr_ttl_bnfcro_sn_iva Numeric(12,0),				vlr_dcto_comercial_aux Numeric(12,0),
				vlr_otros_dcts_aux Numeric(12,0),					vlr_iva_aux Numeric(12,0),
				Grupo_Conceptos Int,								cnsctvo_cdgo_tpo_idntfccn udtConsecutivo,
				numero_identificacion udtNumeroIdentificacionLargo,	primer_apellido Varchar(50),
				segundo_apellido Varchar(50),						primer_nombre Varchar(50),
				segundo_nombre Varchar(50),							Bnfcro_Dfrnte_cro Int
				)

		Create
		Table	#TmpContratosValorCuotaCero
				(cnsctvo_cdgo_tpo_cntrto udtConsecutivo,	nmro_cntrto udtNumeroFormulario,
				Causa Varchar(100),							nmro_unco_idntfccn_aprtnte udtConsecutivo,
				cnsctvo_scrsl_ctznte udtConsecutivo,		cnsctvo_cdgo_clse_aprtnte udtConsecutivo
				)

		Create
		Table	#tmpBeneficiarioValorCero
				(nmro_unco_idntfccn_aprtnte udtConsecutivo,		cnsctvo_scrsl_ctznte udtConsecutivo,
				cnsctvo_cdgo_clse_aprtnte udtConsecutivo,		cnsctvo_cdgo_tpo_cntrto udtConsecutivo,
				nmro_cntrto udtNumeroFormulario
				)

		Create
		Table	#tmpResponsablesPago
				(ID_Num Int IDENTITY(1,1),					nmro_unco_idntfccn_aprtnte udtConsecutivo,
				cnsctvo_scrsl_ctznte udtConsecutivo,		cnsctvo_cdgo_clse_aprtnte udtConsecutivo,
				cnsctvo_cdgo_prdcdd_prpgo udtConsecutivo,	Grupo_Conceptos Int,
				nmbre_empldr Varchar(200),					nmbre_scrsl Varchar(200),
				cnsctvo_cdgo_tpo_idntfccn udtConsecutivo,	nmro_idntfccn_rspnsble_pgo udtNumeroIdentificacionLargo,
				dgto_vrfccn Int,							drccn Varchar(80),
				tlfno Varchar(30),							cnsctvo_cdgo_cdd udtConsecutivo
				)

		Create
		Table	#tmpConceptosLiquidacion
				(cdgo_cncpto_lqdcn Char(5),					dscrpcn_cncpto_lqdcn udtDescripcion,
				cnsctvo_cdgo_cncpto_lqdcn udtConsecutivo,	cnsctvo_cdgo_pln udtConsecutivo,
				cnsctvo_cdgo_tpo_mvmnto udtConsecutivo,		oprcn udtConsecutivo,
				cnsctvo_cdgo_grpo_lqdcn udtConsecutivo,		prcntje udtValorDecimales
				)

		Create
		Table	#TmpConceptosEstadoCuenta
				(ID_num Int IDENTITY(1,1),					nmro_estdo_cnta Varchar(15),
				cnsctvo_cdgo_cncpto_lqdcn udtConsecutivo,	Cantidad Int,
				valor_total_concepto Numeric(12,0)
				)

		--Se crea una tabla temporal con la estructura final  de los conceptos asociados a cada beneficiario donde se guada  todos los valores
		--que aplican a nivel contrato.

		Create	
		Table	#tmpBeneficiariosConceptos
				(
				nmro_unco_idntfccn_aprtnte udtConsecutivo,	cnsctvo_scrsl_ctznte udtConsecutivo,
				nmro_unco_idntfccn_afldo udtConsecutivo,	cnsctvo_cdgo_tpo_cntrto udtConsecutivo,
				nmro_cntrto udtNumeroFormulario,			cnsctvo_bnfcro udtConsecutivo,
				nmro_unco_idntfccn_bnfcro udtConsecutivo,	inco_vgnca_bnfcro Datetime,
				fn_vgnca_bnfcro Datetime,					Valor Numeric(12,0),
				cnsctvo_cdgo_cncpto_lqdcn udtConsecutivo,	cnsctvo_cnta_mnls_cntrto udtConsecutivo
				)

		Create
		Table	#tmpResultadosLogFinal
				(
				nmro_cntrto udtNumeroFormulario,			cdgo_tpo_idntfccn udtTipoIdentificacion,
				nmro_idntfccn udtNumeroIdentificacionLargo,	nombre Varchar(200),
				cnsctvo_cdgo_pln udtConsecutivo,			inco_vgnca_cntrto Datetime,
				fn_vgnca_cntrto Datetime,					nmro_unco_idntfccn_afldo udtConsecutivo,
				cdgo_pln udtCodigo,							dscrpcn_pln udtDescripcion,
				causa Varchar(100),							nmro_unco_idntfccn_aprtnte udtConsecutivo,
				cnsctvo_scrsl_ctznte udtConsecutivo,		cnsctvo_cdgo_clse_aprtnte udtConsecutivo,
				nmbre_scrsl Varchar(200),					dscrpcn_clse_aprtnte Varchar(100),
				tpo_idntfccn_scrsl Char(3),					nmro_idntfccn_scrsl Varchar(20),
				Responsable Varchar(30)
				)

		Create
		Table	#tmpHistoricoTarifasContratoPAC 
				(
				cnsctvo_cdgo_tpo_cntrto udtConsecutivo,		nmro_cntrto udtNumeroFormulario,
				cnsctvo_cbrnza udtConsecutivo,				cnsctvo_scrsl_ctznte udtConsecutivo,
				cnsctvo_cdgo_clse_aprtnte udtConsecutivo,	cta_mnsl  numeric(12)
				)

		Create
		Table	#tmpHistoricoTarifasBeneficiarioPAC 
				(
				cnsctvo_cdgo_tpo_cntrto udtConsecutivo,		nmro_cntrto udtNumeroFormulario,
				nmro_unco_idntfccn udtConsecutivo,			cnsctvo_bnfcro int,
				cnsctvo_cbrnza udtConsecutivo,				cnsctvo_scrsl_ctznte udtConsecutivo,
				cnsctvo_cdgo_clse_aprtnte udtConsecutivo,	cta_mnsl  numeric(12)
				)

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
		)

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

		end--Fin Creacion Tablas Temporales

		Set		@lnProcesoExitoso	= 0;
		Set		@lcMensaje		= '';

		-- Se trae el periodo de liquidacion
		Select	@cnsctvo_cdgo_prdo_lqdcn	= cnsctvo_cdgo_prdo_lqdcn
		From	dbo.tbPeriodosliquidacion_Vigencias
		Where	cnsctvo_cdgo_estdo_prdo = 2 --Asigan el periodo de liquidacion  estado con periodo abierto

		-- Estado con periodo abierto
		Select	@ldFecha_Corte		= fcha_incl_prdo_lqdcn
		From	dbo.tbPeriodosliquidacion_Vigencias
		Where	cnsctvo_cdgo_estdo_prdo	= 2
		And		cnsctvo_cdgo_prdo_lqdcn	= @cnsctvo_cdgo_prdo_lqdcn

		-- Se calcula el numero de meses a facturar
		Set		@nmro_prds	= DATEDIFF(month, @ldFechaInicialFacturacion, @ldFechaFinalFacturacion) + 1

		If		@nmro_prds Between 1 And 4
			Set @cnsctvo_cdgo_prdo = @nmro_prds
		Else
			If	@nmro_prds = 6
				set @cnsctvo_cdgo_prdo = 5
			Else
				If @nmro_prds = 12
					set @cnsctvo_cdgo_prdo = 6

		-- Se inserta el tipo de Proceso y numero de proceso
		begin try
			exec	dbo.spCrearProcesoCarteraPAC @cnsctvo_cdgo_tpo_prcso,@lcUsuario,@Max_cnsctvo_prcso output
		end try
		begin catch			
			Set @lnProcesoExitoso	= 1
			Set @lcMensaje		= error_message();
			Return -1
		end catch
		
		Begin Tran Uno

		If		@lnTipo = @creacionCuentaManual
		Begin
			Begin try
				declare @vProcesoExitoso varchar(1);
				execute dbo.spValidarResolucionVigenteDIAN @vProcesoExitoso output
			End try
			begin catch
				Set @lnProcesoExitoso = 1
				Set @lcMensaje = error_message()
				Rollback Tran uno
				Return -1
			end catch			
			--Poner el calcula del consecutivo							
			select  @valorActual = next value for dbo.seqNumeroEstadoCuentaDIAN		
			set		@nmro_estdo_cnta = Convert(Varchar(15),@valorActual)			
			-- se asigna el numero del estado de cuenta
		End

		If		@lnTipo = @modificacionCuentaManual  -- se modifica el estado de cuenta
		Begin try
			exec	dbo.spEliminarEstadoCuentaManual @nmro_estdo_cnta;
		End try
		begin catch
			Set @lnProcesoExitoso = 1
			Set @lcMensaje = error_message()
			Rollback Tran uno
			Return -1
		end catch

		Set		@cnsctvo_cdgo_estdo_estdo_cnta	= 1 -- Estado del estado de cuenta abierto.
		exec	dbo.spContratosAntesDeLiquidar @nmro_estdo_cnta,@ldFecha_Corte,@ldFechaInicialFacturacion;
		
		--Beneficarios
		exec	dbo.spInsertarYActualizarBeneficiariosCuentaManual @nmro_prds, @ldFecha_Corte;

		--Responsable de pago
		exec	dbo.spInsertarYActualizarResponsablesDePago;
		
		--Se calcula para identificar el parametro de los conceptos
		If		@ldFechaSistema >= @ldFechaInicialFacturacion
			Set @ldFechaParametroConceptos	= @ldFechaSistema
		Else
			Set @ldFechaParametroConceptos	= @ldFechaInicialFacturacion

		exec	dbo.spInsertarConceptosLiquidacion @ldFechaParametroConceptos,@cnsctvo_cdgo_prmtro_prgrmcn,@vlr_descuento,@cnsctvo_cdgo_prdo,@ldFechaInicialFacturacion;

		--Calcula el valor total y cantidad de beneficarios de cada contrato
		Update	#Tmpcontratos
		Set		vlr_ttl_cntrto			= Sumatoria_Contrato,
				vlr_ttl_cntrto_sn_iva	= Sumatoria_Contrato_sin_iva,
				cntdd_ttl_bnfcrs		= cantidad_beneficiarios 
		From	#Tmpcontratos a Inner Join
				(
				Select		nmro_unco_idntfccn_aprtnte,		cnsctvo_scrsl_ctznte,
							cnsctvo_cdgo_clse_aprtnte,		nmro_unco_idntfccn_afldo,
							cnsctvo_cdgo_tpo_cntrto,		nmro_cntrto,
							Sum(vlr_ttl_bnfcro) Sumatoria_Contrato,
							Sum(vlr_ttl_bnfcro_sn_iva) Sumatoria_Contrato_sin_iva,
							Count(nmro_unco_idntfccn_bnfcro)  cantidad_beneficiarios
				From		#tmpBeneficiarios
				Group by	nmro_unco_idntfccn_aprtnte,	cnsctvo_scrsl_ctznte,
							cnsctvo_cdgo_clse_aprtnte,	nmro_unco_idntfccn_afldo,
							cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto
				) b
		On		a.nmro_unco_idntfccn_aprtnte	= b.nmro_unco_idntfccn_aprtnte
		And		a. cnsctvo_scrsl_ctznte			= b.cnsctvo_scrsl_ctznte
		And		a. cnsctvo_cdgo_clse_aprtnte	= b.cnsctvo_cdgo_clse_aprtnte
		And		a.nmro_unco_idntfccn_afldo		= b.nmro_unco_idntfccn_afldo
		And		a. cnsctvo_cdgo_tpo_cntrto		= b.cnsctvo_cdgo_tpo_cntrto
		And		a. nmro_cntrto					= b.nmro_cntrto		

		exec	dbo.spInsertarConceptosDeBeneficiarios;		

		begin try
			exec	dbo.spInsertarOActualizarCuentaManual @lnTipo,
					@nmro_estdo_cnta,
					@ldFechaInicialFacturacion,
					@ldFechaFinalFacturacion,
					@ldFechaLimitePago,
					@nmro_prds,
					@lcUsuario,
					@cnsctvo_cdgo_prdo,
					@lcUsuarioAutorizador,
					@lnPorcentajeIncremento,
					@cnsctvo_cdgo_prdo_lqdcn,
					@cnsctvo_cdgo_estdo_estdo_cnta;
		end try
		begin catch
			Set		@lnProcesoExitoso	= 1
					Set @lcMensaje		= error_message();
					Rollback Tran uno
					Return -1
		end catch

		begin try
			exec	dbo.spGestionarDetallesDeCuentaManual @nmro_estdo_cnta,@lcUsuario;
		end try
		begin catch
			Set @lnProcesoExitoso	= 1
				Set @lcMensaje		= error_message();
				Rollback Tran uno
				Return -1
		end catch

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

		--actualizacion campo CUFE

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
					d.cdgo_dn, -- TIPADQ--lo estoy cambiando esperate
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
		And			a.nmro_estdo_cnta = @nmro_estdo_cnta;		

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
					a.usro_crcn = @usro_crcn
		From		dbo.tbCuentasManuales a
		Inner Join	#tmpCUFEGenerado t
		On			t.NmroCnta = a.nmro_estdo_cnta;

		-- generacion del codigo QR
		Update		a
		Set			cdna_qr = concat('NumFac:',ltrim(rtrim(t.NumFac)),' ','FecFac:',ltrim(rtrim(t1.FecFac)),' ','NitFac:',ltrim(rtrim(t1.NitOFE)),' ','DocAdq:',ltrim(rtrim(t1.NumAdq)),' ','ValFac:',ltrim(rtrim(t1.ValFac)),' ','ValIva:',ltrim(rtrim(t1.ValImp1)),' ','ValOtroIm:','0.00',' ','ValFacIm:',ltrim(rtrim(t1.ValImp)),' ','CUFE:',t.cufe),
					a.usro_crcn = @usro_crcn
		From		dbo.tbCuentasManuales a
		Inner Join	#tmpCUFEGenerado t
		On			t.NmroCnta = a.nmro_estdo_cnta
		Inner join  #tmpParametrosRecibidosCufe t1
		On          t.NumFac = t1.NumFac

		-- actualizacion del codigo de barras
		Update		a
		Set			a.cdgo_brrs='(' + LTRIM(RTRIM(c.idntfcdor_aplccn)) + ')' +  ltrim(rtrim(c.cdgo_ps)) + ltrim(rtrim(c.cdgo_emprsa_iac)) + ltrim(rtrim(c.idntfccn_tpo_rcdo)) + ltrim(rtrim(c.dgto_cntrl))  +
					'(' + ltrim(rtrim(c.idntfcdor_aplccn_usro)) + ')'  +  
					right(replicate('0',8)+ltrim(rtrim(a.nmro_estdo_cnta)),8) + 
					'(' + ltrim(rtrim(c.idntfcdor_aplccn_usro)) + ')'  +  
					right(replicate('0',12)+ltrim(rtrim(d.nmro_idntfccn)),12) + 
					 '(' + ltrim(rtrim(c.idntfcdor_aplccn_usro_ia1))  + ')' +
					right(replicate('0',10)+ltrim(rtrim(convert(varchar(12),ttl_pgr))),10) + 
					'(' + ltrim(rtrim(c.idntfcdor_aplccn_usro_ia2)) + ')' + convert(varchar(10),h.fcha_pgo,112)     			
		From 		dbo.tbCuentasManuales  a
		INNER JOIN  bdAfiliacion.dbo.tbVinculados d With(NoLock)
			ON		a.nmro_unco_idntfccn_empldr = d.nmro_unco_idntfccn 
		INNER JOIN  dbo.tbPeriodosliquidacion_Vigencias h With(NoLock)
			ON		a.cnsctvo_cdgo_prdo_lqdcn = h.cnsctvo_cdgo_prdo_lqdcn 
		INNER JOIN	dbo.TbEstructuraCodigoBarras_vigencias  c
			on		@ldFechaSistema 	between 	c.inco_vgnca 	and 	c. fn_vgnca
		Where 		cnsctvo_vgnca_estrctra_cdgo_brrs = 1    -- consecutivo del  codigo de barras

		Set			@Fecha_Fin_Proceso	= Getdate();

		-- Se Actualiza el fin del proceso
		Update		bdCarteraPac.dbo.tbProcesosCarteraPac
		Set			fcha_fn_prcso	= @Fecha_Fin_Proceso
		Where		cnsctvo_prcso	= @Max_cnsctvo_prcso

		If @@error!= 0
		Begin
			Set @lnProcesoExitoso	= 1
			Set @lcMensaje		= 'Error actualizando el  fin del proceso'
			Rollback Tran uno
			Return -1
		End

		--Retorna el total de contratos liquidados
		Select	@lntotalContratos	= Count(1)
		From	bdCarteraPac.dbo.tbCuentasManualesContrato
		Where	nmro_estdo_cnta		= @nmro_estdo_cnta

		--Retorna el valor  total a pagar
		Select	@lnTotalPagar	= ttl_pgr
		From	bdCarteraPac.dbo.tbCuentasManuales
		Where	nmro_estdo_cnta	= @nmro_estdo_cnta

		-- Se traer los contratos asociados al responsable que no se liquidaron con cuota igual a cero
		Insert	
		Into	#tmpResultadosLogFinal
				(
				nmro_cntrto,		cdgo_tpo_idntfccn,
				nmro_idntfccn,		nombre,
				cnsctvo_cdgo_pln,	inco_vgnca_cntrto,
				fn_vgnca_cntrto,	nmro_unco_idntfccn_afldo,
				cdgo_pln,		dscrpcn_pln,
				causa,			nmro_unco_idntfccn_aprtnte,
				cnsctvo_scrsl_ctznte,	cnsctvo_cdgo_clse_aprtnte,
				nmbre_scrsl,		dscrpcn_clse_aprtnte,
				tpo_idntfccn_scrsl,	nmro_idntfccn_scrsl,
				Responsable
				)
		Select	a.nmro_cntrto,		f.cdgo_tpo_idntfccn,
				e.nmro_idntfccn,	Ltrim(Rtrim(d.prmr_aplldo)) + ' ' + Ltrim(Rtrim(d.sgndo_aplldo)) + ' ' + Ltrim(Rtrim(d.prmr_nmbre)) + ' ' + Ltrim(Rtrim(sgndo_nmbre)),
				a.cnsctvo_cdgo_pln,	a.inco_vgnca_cntrto,
				a.fn_vgnca_cntrto,	a.nmro_unco_idntfccn_afldo,
				p.cdgo_pln,		p.dscrpcn_pln,
				b.causa,		b.nmro_unco_idntfccn_aprtnte,
				b.cnsctvo_scrsl_ctznte,	b.cnsctvo_cdgo_clse_aprtnte,
				'',			'',
				'',			'',
				Ltrim(Rtrim(b.nmro_unco_idntfccn_aprtnte)) + Ltrim(Rtrim(b.cnsctvo_scrsl_ctznte)) + Ltrim(Rtrim(b.cnsctvo_cdgo_clse_aprtnte))
		From	bdafiliacion.dbo.tbcontratos a Inner Join
				#TmpContratosValorCuotaCero b
		On		a.cnsctvo_cdgo_tpo_cntrto 	= b.cnsctvo_cdgo_tpo_cntrto
		And 	a.nmro_cntrto		  	= b.nmro_cntrto Inner Join
				bdAfiliacion.dbo.tbpersonas d
		On		a.nmro_unco_idntfccn_afldo	= d.nmro_unco_idntfccn Inner Join
				bdAfiliacion.dbo.tbvinculados e
		On		d.nmro_unco_idntfccn		= e.nmro_unco_idntfccn Inner Join
				bdAfiliacion.dbo.tbtiposidentificacion f
		On		e.cnsctvo_cdgo_tpo_idntfccn	= f.cnsctvo_cdgo_tpo_idntfccn Inner Join
				bdPlanBeneficios.dbo.tbplanes p
		On		a.cnsctvo_cdgo_pln		= p.cnsctvo_cdgo_pln
		Order 
		By		d.prmr_aplldo, d.sgndo_aplldo, d.prmr_nmbre, d.sgndo_nmbre;

		Update	#tmpResultadosLogFinal
		Set		nmbre_scrsl		= s.nmbre_scrsl,
				dscrpcn_clse_aprtnte	= c.dscrpcn_clse_aprtnte,
				tpo_idntfccn_scrsl	= t.cdgo_tpo_idntfccn,
				nmro_idntfccn_scrsl	= v.nmro_idntfccn
		From	#tmpResultadosLogFinal a Inner Join
				bdAfiliacion.dbo.tbsucursalesaportante s
		On		a.nmro_unco_idntfccn_aprtnte	=	s.nmro_unco_idntfccn_empldr
		And		a.cnsctvo_scrsl_ctznte		=	s.cnsctvo_scrsl 
		And		a.cnsctvo_cdgo_clse_aprtnte	=	s.cnsctvo_cdgo_clse_aprtnte Inner Join
				bdAfiliacion.dbo.tbclasesaportantes c
		On		a.cnsctvo_cdgo_clse_aprtnte	=	c.cnsctvo_cdgo_clse_aprtnte Inner Join
				bdAfiliacion.dbo.tbvinculados v
		On		s.nmro_unco_idntfccn_empldr	=	v.nmro_unco_idntfccn Inner Join
				bdafiliacion..tbtiposidentificacion t
		On		t.cnsctvo_cdgo_tpo_idntfccn	=	v.cnsctvo_cdgo_tpo_idntfccn;

		Select	*
		From	#tmpResultadosLogFinal
		Order 
		By		nmbre_scrsl, 
				nombre;

		Commit Tran uno;