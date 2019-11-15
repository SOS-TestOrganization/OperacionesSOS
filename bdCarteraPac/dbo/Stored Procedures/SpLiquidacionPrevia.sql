
/*---------------------------------------------------------------------------------
* Metodo o PRG		:  SpLiquidacionPrevia
* Desarrollado por	: <\A Ing. Rolando Simbaqueva							A\> 
* Descripcion		: <\D Permite generar la liquidacion previa						D\>
* Observaciones		: <\O										O\>
* Parametros		: <\P 										P\>
* Variables		: <\V Instruccion Sql  a ejecutar							V\>a
			: <\V Parmetros que condicionan la consulta					V\>
			: <\V Fecha que se convierte de date a caracter					V\>
			* Fecha Creacion: <\FC 2002/06/21						FC\>
*
*--------------------------------------------------------------------------------- 
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM Rolando Simbaqueva Lasso AM\>
* Descripcion			: <\DM  Aplicacion tecnicas de optimizacion DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  2005/09/21 FM\>

QUICK				Analista		Descripcion
2012-001-026681		sismpr01		se cambia manejo de la tabla tbSucursalAportanteXGrupo por la de vigencias tbSucursalAportanteXGrupo_Vigencias 2012/09/14
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM Francisco E. Riaño L - Qvision S.A AM\>
* Descripcion			: <\DM Ajustes para tener en cuenta la marca de facturacion posterior DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  2019/08/05 FM\>
*---------------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM Francisco E. Riaño L - Qvision S.A AM\>
* Descripcion			: <\DM Ajuste validación vigencia beneficiario DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  2019/08/26 FM\>
*---------------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM Francisco E. Riaño L - Qvision S.A AM\>
* Descripcion			: <\DM ajuste novedad tarificacion envio de fechacorte para fecha novedad DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  2019/09/26 FM\>
*---------------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[SpLiquidacionPrevia] 
(
		@lnTipoliquidacion			int,
		@lnTipoProceso				int,
		@Max_cnsctvo_prcso			udtConsecutivo	output,
		@cnsctvo_cdgo_lqdcn			udtconsecutivo,
		@lcUsuario					udtusuario,
		@CantidadContratos			int				output,
		@NumeroEstadosCuenta		int				output,
		@Valortotalcobrado			UdtValorGrande	output,
		@lnProcesoExitoso			int				output,
		@lcMensaje					char(200)		output
)			
AS
Begin
 
	Set Nocount On;
	
	Declare		@ldFechaCorte						datetime,
				@lnConsecutivoTipoProceso			UdtConsecutivo,
				@lnConsecutivoPeriodoLiquidacion	udtConsecutivo,
				@lcControlaError					udtConsecutivo = 0,
				@ldFechaSistema						Datetime = Getdate(),
				@Fecha_Inicio_Proceso				Datetime = getdate(),
				@Fecha_Fin_Proceso					Datetime = getdate(),
				@MaximoEstadoHistoricoLiquidacion	udtConsecutivo,
				@liquidacionIngresadasProcesadas		int,
				@lnError								int,
				@lnEstadoLiquidacionActual				int,
				@lnMaxcnsctvo_hstrco_trfa_bnfcro		int,
				@lnMaximo_cnsctvo_csa_bnfcro_lqdcn		int,
				@lnProceso								int,
				@lnProcesoDesafiliacion					int,
				@lndiasdesafiliacion					int,
				@periodoAbierto							int	= 2,
				@periodoLiquidacion						int,
				@vldoSi									varchar(1) = 'S',
				@vldoNo									varchar(1) = 'N',
				@consecutivoLiquidacionProcesada		int = 2,
				@consecutivoLiquidacionfinalizada		int = 3,
				@estadoActivo							varchar(1) = 'A',
				@tipoContratoPAC						int = 2,
				@consecutivoConceptoOtrosDescuentos		int = 6,
				@consecutivoConceptoIva					int = 3,
				@consecutivoMovimientoImpuestos			int = 5,
				@consecutivoMovimientoFacturacion		int = 1,
				@max_Cnsctvo_cntrto_dsfldo_mra_pac		int,
				@periodoActual							udtLogico;

	--Para definir el paremetro de desafiliacion
	Select	@lndiasdesafiliacion		= vlr_prmtro_nmrco
	From	bdCarteraPac.dbo.tbParametrosGenerales_Vigencias
	Where	cnsctvo_vgnca_prmtro_gnrl	= 1
	And		@ldFechaSistema	Between inco_vgnca And 	fn_vgnca

	-- se crean tablas temporales
	create table  #tmpContratosLiquidacionprocesada
	(
		cnsctvo_cdgo_tpo_cntrto		int, 
		 nmro_cntrto				varchar(20),
		 nmro_unco_idntfccn_empldr 	int,
		 cnsctvo_scrsl 				int,
		 cnsctvo_cdgo_clse_aprtnte	int
	 )

	create table  #tmpContratosLiquidacionFinalizado
	(
		cnsctvo_cdgo_tpo_cntrto			int, 
		nmro_cntrto						varchar(20),
		nmro_unco_idntfccn_empldr 		int,
		cnsctvo_scrsl 					int,
		cnsctvo_cdgo_clse_aprtnte		int,
		cnsctvo_estdo_cnta				int,
		marca_contrato_liquidar			int
	)

	create table #TmpContratosPac
	(
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20),
		cnsctvo_cdgo_pln			int,
		inco_vgnca_cntrto           datetime,
		fn_vgnca_cntrto				datetime,
		nmro_unco_idntfccn_afldo	int,
		Estado						int
	 )
	
	create table #tmpCobranzasPac	
	(
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20),
		cnsctvo_cbrnza				int,
		nmro_unco_idntfccn_aprtnte	int,
		cnsctvo_cdgo_clse_aprtnte	int,
		cnsctvo_cdgo_prdcdd_prpgo	int,
		lsto_fcttr					int 
	)
	
	create table #tmpcobranzasMp
	(
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20),
		cnsctvo_cbrnza				int,
		nmro_unco_idntfccn_aprtnte	int,
		cnsctvo_cdgo_clse_aprtnte	int,
		cnsctvo_cdgo_prdcdd_prpgo	int,
		lsto_fcttr					int,
		Fecha_lqdcn					datetime,
		ultma_Fecha_lqdcn			datetime,
		nmro_mss					int,
		nmro_mss_prdo				int
	)
	
	Create table #tmpContratosLogPeriodicidadmayor
	(
		nmro_unco_idntfccn_aprtnte	int ,
		cnsctvo_cbrnza				int,
		cnsctvo_cdgo_tpo_cntrto		int ,
		nmro_cntrto					varchar(20),
		cnsctvo_cdgo_clse_aprtnte	int,
		cnsctvo_scrsl				int
	)
	
	Create table #tmpVigenciasCobranzasPac
	(
		cnsctvo_vgnca_cbrnza		int,
		inco_vgnca_cbrnza			datetime,
		fn_vgnca_cbrnza				datetime,
		cta_mnsl					numeric(12,0),
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20),
		cnsctvo_cbrnza				int,
		cnsctvo_scrsl_ctznte		int
	)
	
	Create table #tmpContratosVigenciaCuotaAcotada
	(
		nmro_cntrto					varchar(20),
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_unco_idntfccn_aprtnte	int,
		cnsctvo_scrsl_ctznte		int,	
		cnsctvo_cdgo_clse_aprtnte	int,
		cnsctvo_cbrnza				int
	)
	
	Create table #Tmpcontratos_Antes_liquidar
	(
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto 				varchar(20),
		cnsctvo_cdgo_pln			int,
		inco_vgnca_cntrto 			datetime,
		fn_vgnca_cntrto 			datetime,
		nmro_unco_idntfccn_afldo	int,
		cnsctvo_cbrnza				int,
		nmro_unco_idntfccn_aprtnte	int,
		cnsctvo_vgnca_cbrnza		int,
		cnsctvo_scrsl_ctznte	    int,
		inco_vgnca_cbrnza			datetime,
		fn_vgnca_cbrnza				datetime,
		cta_mnsl					numeric(12,0),
		cnsctvo_cdgo_prdcdd_prpgo	int,
		cnsctvo_estdo_cnta			int,
		cnsctvo_cdgo_clse_aprtnte	int,
		vlr_ttl_cntrto				numeric(12,0),
		vlr_ttl_cntrto_sn_iva		numeric(12,0),	
		cntdd_ttl_bnfcrs			int,
		Grupo_Conceptos				int,        
		Estado_Contrato_Liquidacion int
	)	
	
	Create table #TmpContratosLogResultados
	(
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto 				varchar(20),
		causa   					varchar(100),
		nmro_unco_idntfccn_aprtnte	int,
		cnsctvo_scrsl_ctznte		int,
		cnsctvo_cdgo_clse_aprtnte	int
	)
	
	Create Table #tmpAportantesNoliquidar
	(
		nmro_unco_idntfccn_aprtnte  int,
		cnsctvo_scrsl_ctznte 	    int,
		cnsctvo_cdgo_clse_aprtnte   int
	 )
	
	Create Table #tmpAportantesMarcadosNoMasiva
	(
		nmro_unco_idntfccn_aprtnte	int,
		cnsctvo_scrsl_ctznte 	    int,
		cnsctvo_cdgo_clse_aprtnte   int
	)

	Create Table #tmpcontratosListoNoLiquidados
	(
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20),
		nmro_unco_idntfccn_aprtnte	int,
		cnsctvo_scrsl_ctznte		int,
		cnsctvo_cdgo_clse_aprtnte	int
	)
	
	--Create table #Tmpcontratos
	--IDENTITY(1,1)
	Create table #Tmpcontratos
	(
		ID_Num						int IDENTITY(1,1), 
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20),
		cnsctvo_cdgo_pln			int,
		inco_vgnca_cntrto			datetime,
		fn_vgnca_cntrto				datetime,
		nmro_unco_idntfccn_afldo	int,
		cnsctvo_cbrnza				int,
		nmro_unco_idntfccn_aprtnte  int,
		cnsctvo_vgnca_cbrnza		int,
		cnsctvo_scrsl_ctznte		int,
		inco_vgnca_cbrnza			datetime,
		fn_vgnca_cbrnza				datetime,
		cta_mnsl					numeric(12,0),
		cnsctvo_cdgo_prdcdd_prpgo	int,
		cnsctvo_estdo_cnta			int,
		cnsctvo_cdgo_clse_aprtnte	int,
		vlr_ttl_cntrto				numeric(12,0),
		vlr_ttl_cntrto_sn_iva		numeric(12,0),
		cntdd_ttl_bnfcrs			int,
		Grupo_Conceptos				int,           -- por defecto  se toma el concepto generico
		Activo						int,
		Cntrto_igual_cro			int
	)
	
	Create table #tmpEstadosCuentaContratos
	(
		nmro_unco_idntfccn_empldr	int,
		cnsctvo_scrsl				int,
		cnsctvo_cdgo_clse_aprtnte	int,
		nmro_estdo_cnta				varchar(20),
		cnsctvo_estdo_cnta_cntrto	int,
		cnsctvo_estdo_cnta			int,
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20),
		vlr_cbrdo					numeric(12,0),
		sldo						numeric(12,0)
	)
	
	Create table  #tmpSaldoContratoResponsable
	(
		ID_Num						int IDENTITY(1,1), 
		nmro_unco_idntfccn_empldr	int,
		cnsctvo_scrsl				int,
		cnsctvo_cdgo_clse_aprtnte	int,  
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20),
		sldo						numeric(12,0),
		cuotas						int,
		nmro_cts_prmtdas			int,
		Vldo_pra_fctrr				int
	)
	
	Create table #tmpCuotasDebitosPendienteXAportante 
	(
		nmro_unco_idntfccn_empldr	int,
		cnsctvo_scrsl				int,
		cnsctvo_cdgo_clse_aprtnte	int,
		cuotas						int
	)
	
	
	Create table  #tmpResponsableConSaldoAnterior
	(
		nmro_unco_idntfccn_empldr	int,
		cnsctvo_scrsl				int,
		cnsctvo_cdgo_clse_aprtnte	int, 
		sldo_antrr					numeric(12,0),
		Cts_sn_cnclar				int
	)
	
	Create table #tmpContratosSuspenConUnacuota
	(
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20)
	)
	
	
	Create table #tmpCuotasMayorigualDos
	(
		nmro_unco_idntfccn_empldr	int,
		cnsctvo_scrsl				int,
		cnsctvo_cdgo_clse_aprtnte	int,  
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20),
		sldo						numeric(12,0),
		cuotas						int,
		nmro_cts_prmtdas			int,
		Vldo_pra_fctrr				int
	)
	
	Create table #TmpcontratosDesafiliarMoraPac
	(
		ID_Num						int IDENTITY(1,1), 
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20),	
		nmro_unco_idntfccn_afldo	int,
		cnsctvo_cbrnza				int,
		nmro_unco_idntfccn_empldr	int,
		cnsctvo_scrsl				int,
		cnsctvo_cdgo_clse_aprtnte	int,
		Estdo						char(1)
	)
	
	Create table #tmpBeneficiariosActivos   
	(   
		cnsctvo_cdgo_tpo_cntrto		int,
	    nmro_cntrto					varchar(20),
	    cnsctvo_bnfcro				int,
	    nmro_unco_idntfccn_bnfcro	int,
	    inco_vgnca_bnfcro			datetime,
	    fn_vgnca_bnfcro				datetime,
	    cnsctvo_cdgo_tpo_afldo		int,
	    cnsctvo_cdgo_prntsco		int,
	    Activo						int
	)
	
	Create table #tmpHistoricoEstadosBeneficiario 
	(
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20),
		cnsctvo_bnfcro				int,
		nmro_unco_idntfccn_bnfcro	int,
		cnsctvo_cdgo_estdo_bfcro	int
	)
	
	Create table #tmpBeneficiariosEstadoActivos
	(
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20),
		cnsctvo_bnfcro				int,
		nmro_unco_idntfccn_bnfcro	int,
		cnsctvo_cdgo_estdo_bfcro	int,
		Suspendido					int
	)
	
	create table #tmpBeneficiariosEstadoSuspendidos
	(
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20),
		cnsctvo_bnfcro				int,
		nmro_unco_idntfccn_bnfcro	int,
		cnsctvo_cdgo_estdo_bfcro	int
	)
	
	create table #tmpcontratosCausaSinBene
	(
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20),
		nmro_unco_idntfccn_aprtnte	int,
		cnsctvo_scrsl_ctznte		int,
		cnsctvo_cdgo_clse_aprtnte	int,	
		estado 						int
	)
	
	Create table	#tmpCausalContratosDetBeneficiarios
	( 
		nmro_cntrto  										varchar(20),
		cnsctvo_cdgo_tpo_cntrto								int,
		cnsctvo_cbrnza 										int,
		cnsctvo_bnfcro 										int,	
		nmro_unco_idntfccn_bnfcro							int,
		nmro_unco_idntfccn_aprtnte							int,
		cnsctvo_scrsl_ctznte 								int,
		cnsctvo_cdgo_clse_aprtnte							int,		
		Estado_existe_tbdetbeneficiarioAdicional			int,
		Estado_existe_vigente_tbdetbeneficiarioadicional	int
	)
	
	Create table 	#tmpNuevosBeneNoexietentbdetbeneadicional
	(
		ID_Num						int IDENTITY(1,1), 
		nmro_cntrto					varchar(20) ,
		cnsctvo_cdgo_tpo_cntrto		int,
		cnsctvo_bnfcro				int,	
		nmro_unco_idntfccn_bnfcro	int,
		nmro_unco_idntfccn_aprtnte	int,
		cnsctvo_scrsl_ctznte		int,
		cnsctvo_cdgo_clse_aprtnte	int
	)
	
	Create table 	#tmpNuevosBeneAcotadostbdetbeneadicional
	(
		ID_Num						int IDENTITY(1,1), 
		nmro_cntrto					varchar(20),
		cnsctvo_cdgo_tpo_cntrto		int,
		cnsctvo_bnfcro				int,	
		nmro_unco_idntfccn_bnfcro	int,
		nmro_unco_idntfccn_aprtnte	int,
		cnsctvo_scrsl_ctznte		int,
		cnsctvo_cdgo_clse_aprtnte	int
	)
	
	Create table 	#tmpBeneficiarios
	(
		ID_Num						int IDENTITY(1,1), 
		nmro_unco_idntfccn_aprtnte	int,
		cnsctvo_scrsl_ctznte		int,
		cnsctvo_cdgo_clse_aprtnte	int,
		nmro_unco_idntfccn_afldo	int,
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20), 
		cnsctvo_cbrnza				int,
		cnsctvo_cdgo_pln			int,
		cnsctvo_bnfcro				int,
		nmro_unco_idntfccn_bnfcro	int,
		inco_vgnca_bnfcro			datetime,
		fn_vgnca_bnfcro				datetime,
		vlr_upc						numeric(12,0),
		vlr_rl_pgo					numeric(12,0),
		cnsctvo_estdo_cnta_cntrto	int,
		vlr_dcto_comercial			numeric(12,0),
		vlr_otros_dcts				numeric(12,0),
		vlr_iva						numeric(12,0),
		vlr_cta						numeric(12,0),
		vlr_ttl_bnfcro				numeric(12,0),
		vlr_ttl_bnfcro_sn_iva		numeric(12,0),
		vlr_dcto_comercial_aux		numeric(12,0),
		vlr_otros_dcts_aux			numeric(12,0),
		vlr_iva_aux					numeric(12,0),
		Grupo_Conceptos				int,
		vlr_upc_nuevo				numeric(12,0),
		vlr_rl_pgo_nuevo			numeric(12,0),
		Cambio_Valor_cuota			int,
		Bnfcro_Dfrnte_cro			int,
		cnsctvo_vgnca_cbrnza		int,
		cnsctvo_dtlle_bnfcro_adcnl	int,
		inco_vgnca_cbrnza			datetime,
		cnsctvo_cdgo_prdcdd_prpgo	int,
		nmro_mss					int,
		inco_vgnca					datetime,
		fn_vgnca					datetime
	)	 
	
	Create table 	#tmpBeneficiariosDobles
	(	
		Nmro_Unco_Idntfccn_Bnfcro	int,
		cantidad					int
	)
	
	Create table 	#tmpCausaNuiDobleANivelBeneficiario
	(
		ID_Num						int IDENTITY(1,1), 
		nmro_cntrto					varchar(20), 	
		cnsctvo_cdgo_tpo_cntrto		int,
		cnsctvo_bnfcro				int,	
		nmro_unco_idntfccn_bnfcro	int,
		nmro_unco_idntfccn_aprtnte	int,
		cnsctvo_scrsl_ctznte		int,
		cnsctvo_cdgo_clse_aprtnte	int
	)
	
	Create table 	#tmpContratosNuiDobles
	(
		Cnsctvo_cdgo_tpo_cntrto		int,
		Nmro_cntrto					varchar(20)
	)
	
	Create table	#RegistrosClasificarFinal
	(
		nmro_unco_idntfccn			int,
		edd_bnfcro					int,
		cnsctvo_cdgo_pln			int,
		ps_ss						char(1),
		fcha_aflcn_pc				datetime,
		cnsctvo_cdgo_prntsco		int,
		cnsctvo_cdgo_tpo_afldo		int,
		Dscpctdo					char(1),
		Estdnte						char(1),
		Antgdd_hcu					char(1),
		Atrzdo_sn_Ps				char(1),
		grpo_bsco					char(1),
		cnsctvo_cdgo_tpo_cntrto		int,	
		nmro_cntrto					varchar(20),
		cnsctvo_bnfcro				int,
		cnsctvo_cbrnza				int,
		grupo						int,
		cnsctvo_prdcto				int,
		cnsctvo_mdlo				int,
		vlr_upc						numeric(12,0),
		vlr_rl_pgo					numeric(12,0),
		cnsctvo_cdgo_tps_cbro		int,
		Cobranza_Con_producto		int,
		Beneficiario_Con_producto	int,
		Con_Modelo					int,
		grupo_tarificacion			int,
		igual_plan					int,
		grupo_modelo				int,
		nmro_unco_idntfccn_aprtnte	int,
		cnsctvo_scrsl_ctznte		int, 
		cnsctvo_cdgo_clse_aprtnte	int,
		inco_vgnca_cntrto			datetime,
		bnfcdo_pc					char(1),
		Tne_hjos_cnyge_cmpnra		char(1),
		cntrtnte_ps_ss				char(1),
		grpo_bsco_cn_ps				char(1),
		cntrtnte_tn_pc				char(1),
		antgdd_clptra				char(1)
	)	
	
	Create table #tmpCausaModeloDiferentePlan
	(
		ID_Num						int IDENTITY(1,1), 
		nmro_cntrto					varchar(20),
		cnsctvo_cdgo_tpo_cntrto		int,
		cnsctvo_bnfcro				int,	
		nmro_unco_idntfccn			int,
		nmro_unco_idntfccn_aprtnte	int,
		cnsctvo_scrsl_ctznte		int,
		cnsctvo_cdgo_clse_aprtnte	int
	)
	
	Create table #tmpCausaBeneficiarioSinPorducto
	(
		ID_Num						int 	IDENTITY(1,1), 
		nmro_cntrto 				varchar(20), 	
		cnsctvo_cdgo_tpo_cntrto		int,
		cnsctvo_bnfcro				int,	
		nmro_unco_idntfccn			int,
		nmro_unco_idntfccn_aprtnte	int,
		cnsctvo_scrsl_ctznte		int,
		cnsctvo_cdgo_clse_aprtnte	int
	)
	
	Create table #tmpCausaBeneficiarioConPorductoSinModelo
	(
		ID_Num						int 	IDENTITY(1,1), 
		nmro_cntrto					varchar(20), 	
		cnsctvo_cdgo_tpo_cntrto		int,
		cnsctvo_bnfcro				int,	
		nmro_unco_idntfccn			int,
		nmro_unco_idntfccn_aprtnte	int,
		cnsctvo_scrsl_ctznte		int,
		cnsctvo_cdgo_clse_aprtnte	int
	)
	
	Create table #tmpCausaIgualPlanGrupomodeloCero
	(
		ID_Num						int 	IDENTITY(1,1), 
		nmro_cntrto					varchar(20), 	
		cnsctvo_cdgo_tpo_cntrto		int,
		cnsctvo_bnfcro				int,	
		nmro_unco_idntfccn			int,
		nmro_unco_idntfccn_aprtnte	int,
		cnsctvo_scrsl_ctznte		int,
		cnsctvo_cdgo_clse_aprtnte	int
	)
	
	Create table	#tmpBeneficiarioValorCero
	(
		nmro_unco_idntfccn_aprtnte	int,
		cnsctvo_scrsl_ctznte		int,
		cnsctvo_cdgo_clse_aprtnte	int,
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20)
	)
	
	Create table #tmpResponsablesPago
	(
		ID_Num						int 	IDENTITY(1,1), 
		nmro_unco_idntfccn_aprtnte	int,
		cnsctvo_scrsl_ctznte		int,
		cnsctvo_cdgo_clse_aprtnte	int,
		cnsctvo_cdgo_prdcdd_prpgo	int,
		Grupo_Conceptos				int,
		sldo_antrr					numeric(12,0),
		Cts_sn_cnclar				int,
		cnsctvo_cdgo_pln			int
	)
	
	Create table  #tmpConceptosLiquidacion
	(
		cdgo_cncpto_lqdcn			varchar(10),
		dscrpcn_cncpto_lqdcn		varchar(150),
		cnsctvo_cdgo_cncpto_lqdcn	int,
		cnsctvo_cdgo_pln			int,
		cnsctvo_cdgo_tpo_mvmnto		int,
		oprcn						int,
		cnsctvo_cdgo_grpo_lqdcn		int,
		prcntje						numeric(12,4)
	)
	
	Create table #tmpBeneficiariosConceptos
	(
		nmro_unco_idntfccn_aprtnte			int,
		cnsctvo_scrsl_ctznte				int,
		nmro_unco_idntfccn_afldo			int,
		cnsctvo_cdgo_tpo_cntrto				int,
		nmro_cntrto							varchar(20),
		cnsctvo_bnfcro						int,
		nmro_unco_idntfccn_bnfcro			int,
		inco_vgnca_bnfcro					datetime,
		fn_vgnca_bnfcro						datetime ,
		valor								numeric(12,0) , 
		cnsctvo_cdgo_cncpto_lqdcn			int,
		cnsctvo_estdo_cnta_cntrto_bnfcro	int
	)
	
	Create table #tmpNuevasVigenciasCobranzas
	(
		cnsctvo_vgnca_cbrnza		int,
		cnsctvo_cdgo_tpo_cntrto		int, 
		nmro_cntrto					varchar(20),
		cnsctvo_cbrnza				int
	)
	
	Create table #tmpHistoricoTarifaxBeneficiario
	(
		ID_Num						int 	IDENTITY(1,1), 
		cnsctvo_vgnca_cbrnza		int,
		nmro_unco_idntfccn_aprtnte	int, 
		cnsctvo_scrsl_ctznte		int, 
		cnsctvo_cdgo_clse_aprtnte	int, 
		nmro_unco_idntfccn_afldo	int,	
		cnsctvo_cdgo_tpo_cntrto		int, 
		nmro_cntrto					varchar(20), 
		cnsctvo_cbrnza				int,
		cnsctvo_bnfcro				int,
		nmro_unco_idntfccn_bnfcro	int, 
		inco_vgnca_bnfcro			datetime,
		fn_vgnca_bnfcro				datetime,	
		vlr_upc						numeric(12,0),
		vlr_rl_pgo					numeric(12,0),
		vlr_upc_nuevo				numeric(12,0),
		vlr_rl_pgo_nuevo			numeric(12,0),
		usro_crcn					varchar(30)
	)
	
	Create table #tmpDetBeneficiarioAdicionalAcotar
	(
		cnsctvo_dtlle_bnfcro_adcnl	int,
		fcha_nvdd					datetime
	 )
	
	Create table #tmpVigenciasAcotarXCambioNovedad
	(
		cnsctvo_vgnca_cbrnza		int, 
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20),
		cnsctvo_cbrnza				int,	
		fcha_nvdd					datetime,
		adcnl						char(1),
		usro						char(30),
		estdo						char(1),
		vlr_upc						numeric(12,0)
	)
	
	Create table #tmpDetInformacionNovedad
	(
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20),
		nmro_unco_idntfccn			int,
		cnsctvo_idntfcdr			int,
		vlr_upc						numeric(12,0),
		vlr_rl_pgo					numeric(12,0),
		cnsctvo_cbrnza				int,
		fcha_nvdd					datetime,
		adcnl						char(1),	
		usro						char(30),
		estdo						char(1)
	)
	
	Create table #tmpActualiVigenciasMayorXCambioNovedad
	(
		cnsctvo_vgnca_cbrnza		int,
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20),
		cnsctvo_cbrnza				int,	
		vlr_upc						numeric(12,0)
	)
	
	Create table #TmpConceptosEstadoCuenta
	(
		ID_Num						int 		IDENTITY(1,1), 
		cnsctvo_estdo_cnta 			int,
		cnsctvo_cdgo_cncpto_lqdcn	int,
		Cantidad					int,
		valor_total_concepto		numeric(12,0)
	)
	
	Create table #tmpResultadosLogFinal
	(
		nmro_cntrto					varchar(20),
		cdgo_tpo_idntfccn			varchar(5),
		nmro_idntfccn				varchar(20),
		nombre						varchar(200),
		cnsctvo_cdgo_pln			varchar(2),
		inco_vgnca_cntrto			datetime,
		fn_vgnca_cntrto				datetime,
		nmro_unco_idntfccn_afldo	int,
		cdgo_pln					varchar(4),
		dscrpcn_pln					varchar(150)   ,
		causa						varchar(100),
		nmro_unco_idntfccn_aprtnte	int,
		cnsctvo_scrsl_ctznte		int,
		cnsctvo_cdgo_clse_aprtnte	int,
		nmbre_scrsl					varchar(200),
		dscrpcn_clse_aprtnte		varchar(150),
		tpo_idntfccn_scrsl			varchar(3), 
		nmro_idntfccn_scrsl			varchar(20),
		cdgo_sde					varchar(10), 
		dscrpcn_sde					varchar(150),
		Responsable					varchar(200)
	)
	
	Create table #tmpValorRealSaldo
	(
		nmro_unco_idntfccn_empldr	int,
		cnsctvo_scrsl				int,
		cnsctvo_cdgo_clse_aprtnte	int,
		nmro_estdo_cnta				varchar(20),
		vlr_sldo_antrr				numeric(12,0),
		cnsctvo_cdgo_pln			int
	)


	--Se conculta el maximo consecutivo del proceso
	Select	@Max_cnsctvo_prcso		=	isnull(cnsctvo_prcso,0)	+	1
	From	bdcarteraPac.dbo.TbProcesosCarteraPac
	
	Set	@Fecha_Inicio_Proceso		=	Getdate()


	Select	@lnConsecutivoTipoProceso		=	cnsctvo_cdgo_tpo_prcso,
			@lnConsecutivoPeriodoLiquidacion	=	cnsctvo_cdgo_prdo_lqdcn,
			@lnEstadoLiquidacionActual		=	cnsctvo_cdgo_estdo_lqdcn
	From	bdcarteraPac.dbo.tbliquidaciones
	Where	cnsctvo_cdgo_lqdcn			=	@cnsctvo_cdgo_lqdcn

	Begin try
			declare @vProcesoExitoso varchar(1);
			execute dbo.spValidarResolucionVigenteDIAN @vProcesoExitoso output
	End try
	begin catch
		Set @lnProcesoExitoso = 1
		Set @lcMensaje = error_message()
		--print @lcMensaje
		Return -1
	end catch		
	--Se  Ingresan lo aportantes que no se van a liquidar porque estan con la marca especial de no liquidar en la masiva
 
	if 	@lnConsecutivoTipoProceso	=	2 -- proceso masivo
	begin

		Select 	@ldFechaCorte		=	fcha_incl_prdo_lqdcn
		From	bdcarteraPac.dbo.tbPeriodosliquidacion_Vigencias
		Where	cnsctvo_cdgo_estdo_prdo	=	2	
		And	cnsctvo_cdgo_prdo_lqdcn	=	@lnConsecutivoPeriodoLiquidacion

		insert into #tmpAportantesMarcadosNoMasiva
		select nmro_unco_idntfccn_empldr, cnsctvo_scrsl, cnsctvo_cdgo_clse_aprtnte 
		from bdAfiliacion.dbo.tbClasificacionxSucursalesAportante 
		where cnsctvo_cdgo_mrca_espcl=19 
		and estdo_mrca = @vldoSi
		and @ldFechaCorte between inco_vgnca_mrca and fn_vgnca_mrca
	
	end

	If	@lnEstadoLiquidacionActual		!=	1
	begin
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'la liquidacion no se puede procesar su estado no lo permite'
		--print @lcMensaje
		Return 	-1
	end

	If	@lnConsecutivoTipoProceso	=	2 -- proceso masivo
	Begin
		-- se verifica si existen liquidaciones en estado ingresada o prosesada para el periodo de liqudacion
		Select 	@liquidacionIngresadasProcesadas	=	count(*)
		From 	bdcarteraPac.dbo.tbliquidaciones
		where	cnsctvo_cdgo_prdo_lqdcn	=	@lnConsecutivoPeriodoLiquidacion
		and	(cnsctvo_cdgo_estdo_lqdcn	=	1 or cnsctvo_cdgo_estdo_lqdcn = 2)


		if	@liquidacionIngresadasProcesadas	>	1
			Begin 
				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje		=	'el tipo de proceso es masivo, existen liquidaciones con estado ingresada o procesada'
				print @lcMensaje
				--Return 	-1
			end	

	End

	-- se trae la fecha de corte del periodo de liquidacion
	--  estado con periodo abierto
	Select 	@ldFechaCorte		=	fcha_incl_prdo_lqdcn,
			@periodoActual		= case when cnsctvo_cdgo_estdo_prdo = 2 then 1 else 0 end
	From	bdcarteraPac.dbo.tbPeriodosliquidacion_Vigencias
	Where	cnsctvo_cdgo_prdo_lqdcn	=	@lnConsecutivoPeriodoLiquidacion--cnsctvo_cdgo_estdo_prdo	=	2	
	--And	cnsctvo_cdgo_prdo_lqdcn	=	@lnConsecutivoPeriodoLiquidacion

	IF	@lnConsecutivoTipoProceso	=	2 -- proceso masivo
	Begin
		--Contratos que ya tiene una	liquidacion procesada para ese periodo de liquidacion
		Insert	into	#tmpContratosLiquidacionprocesada
		Select 			c.cnsctvo_cdgo_tpo_cntrto, 		c.nmro_cntrto, 
						b.nmro_unco_idntfccn_empldr , b.cnsctvo_scrsl , b.cnsctvo_cdgo_clse_aprtnte
		From 			bdcarteraPac.dbo.tbliquidaciones			a with(nolock)
		inner join		bdcarteraPac.dbo.TbEstadosCuenta			b with(nolock)
			on			(a.cnsctvo_cdgo_lqdcn		=	b.cnsctvo_cdgo_lqdcn) 
		inner join		bdcarteraPac.dbo.tbEstadosCuentaContratos	c with(nolock)
			on			(b.cnsctvo_estdo_cnta		=	c.cnsctvo_estdo_cnta)
		Where			a.cnsctvo_cdgo_estdo_lqdcn	=	@consecutivoLiquidacionProcesada
		And				a.cnsctvo_cdgo_prdo_lqdcn	=	@lnConsecutivoPeriodoLiquidacion
		Group by		c.cnsctvo_cdgo_tpo_cntrto,	 c.nmro_cntrto	,
						b.nmro_unco_idntfccn_empldr , b.cnsctvo_scrsl , b.cnsctvo_cdgo_clse_aprtnte
        
		--Contratos que ya tienen una liquidacion definitiva para ese periodo de liquidacion
		Insert into		#tmpContratosLiquidacionFinalizado
		Select 			c.cnsctvo_cdgo_tpo_cntrto, 		c.nmro_cntrto,
						b.nmro_unco_idntfccn_empldr , b.cnsctvo_scrsl , b.cnsctvo_cdgo_clse_aprtnte,c.cnsctvo_estdo_cnta, 0
		From 			bdcarteraPac.dbo.tbliquidaciones			a with(nolock)
		inner join		bdcarteraPac.dbo.TbEstadosCuenta			b with(nolock)
			on			(a.cnsctvo_cdgo_lqdcn		=	b.cnsctvo_cdgo_lqdcn) 
		inner join		bdcarteraPac.dbo.tbEstadosCuentaContratos	c with(nolock)
			on			(b.cnsctvo_estdo_cnta		=	c.cnsctvo_estdo_cnta)	
		Where			a.cnsctvo_cdgo_estdo_lqdcn	=	@consecutivoLiquidacionfinalizada
		And				a.cnsctvo_cdgo_prdo_lqdcn	=	@lnConsecutivoPeriodoLiquidacion
		Group by		c.cnsctvo_cdgo_tpo_cntrto, 	c.nmro_cntrto	,
						b.nmro_unco_idntfccn_empldr , b.cnsctvo_scrsl , b.cnsctvo_cdgo_clse_aprtnte,c.cnsctvo_estdo_cnta

	End

	--select * from #tmpContratosLiquidacionFinalizado

	IF	@lnConsecutivoTipoProceso	=	1 -- proceso individual
	Begin
		--Contratos que ya tiene una	liquidacion procesada para ese periodo de liquidacion
		Insert	into	#tmpContratosLiquidacionprocesada
		Select 			c.cnsctvo_cdgo_tpo_cntrto, 		c.nmro_cntrto,
						b.nmro_unco_idntfccn_empldr , b.cnsctvo_scrsl , b.cnsctvo_cdgo_clse_aprtnte
		from 			bdcarteraPac.dbo.tbliquidaciones			a with(nolock)
		inner join		bdcarteraPac.dbo.TbEstadosCuenta			b with(nolock)
			on			(a.cnsctvo_cdgo_lqdcn		=	b.cnsctvo_cdgo_lqdcn) 
		inner join		bdcarteraPac.dbo.tbEstadosCuentaContratos	c with(nolock)
			on			(b.cnsctvo_estdo_cnta		=	c.cnsctvo_estdo_cnta) 
		inner  join		bdcarteraPac.dbo.tbcriteriosliquidacion		d with(nolock)
			on			(b.nmro_unco_idntfccn_empldr = 	d.nmro_unco_idntfccn_empldr
			And			b.cnsctvo_scrsl				 = 	d.cnsctvo_scrsl
			And			b.cnsctvo_cdgo_clse_aprtnte	 = 	d.cnsctvo_cdgo_clse_aprtnte)
		Where			a.cnsctvo_cdgo_estdo_lqdcn	=	@consecutivoLiquidacionProcesada
		And				a.cnsctvo_cdgo_prdo_lqdcn	=	@lnConsecutivoPeriodoLiquidacion
		and				d.cnsctvo_cdgo_lqdcn		 = 	@cnsctvo_cdgo_lqdcn
		Group by		c.cnsctvo_cdgo_tpo_cntrto,	 c.nmro_cntrto	,
						b.nmro_unco_idntfccn_empldr , b.cnsctvo_scrsl , b.cnsctvo_cdgo_clse_aprtnte

		--Contratos que ya tienen una liquidacion definitiva para ese periodo de liquidacion
		Insert	into	#tmpContratosLiquidacionFinalizado
		Select 			c.cnsctvo_cdgo_tpo_cntrto, 		c.nmro_cntrto,
						b.nmro_unco_idntfccn_empldr , b.cnsctvo_scrsl , b.cnsctvo_cdgo_clse_aprtnte, c.cnsctvo_estdo_cnta, 0
		from 			bdcarteraPac.dbo.tbliquidaciones			a with(nolock)
		inner join		bdcarteraPac.dbo.TbEstadosCuenta			b with(nolock)
			on			(a.cnsctvo_cdgo_lqdcn		=	b.cnsctvo_cdgo_lqdcn) 
		inner join		bdcarteraPac.dbo.tbEstadosCuentaContratos	c with(nolock)
			on			(b.cnsctvo_estdo_cnta		=	c.cnsctvo_estdo_cnta) 
		inner join		bdcarteraPac.dbo.tbcriteriosliquidacion		d with(nolock)
			on			(b.nmro_unco_idntfccn_empldr	 = 	d.nmro_unco_idntfccn_empldr
			And			b.cnsctvo_scrsl		 = 	d.cnsctvo_scrsl
			And			b.cnsctvo_cdgo_clse_aprtnte	 = 	d.cnsctvo_cdgo_clse_aprtnte)
		Where			a.cnsctvo_cdgo_estdo_lqdcn	 =	@consecutivoLiquidacionfinalizada
		And				a.cnsctvo_cdgo_prdo_lqdcn	 =	@lnConsecutivoPeriodoLiquidacion
		And				d.cnsctvo_cdgo_lqdcn		 = 	@cnsctvo_cdgo_lqdcn  
		Group by		c.cnsctvo_cdgo_tpo_cntrto,	 c.nmro_cntrto	,
						b.nmro_unco_idntfccn_empldr , b.cnsctvo_scrsl , b.cnsctvo_cdgo_clse_aprtnte,c.cnsctvo_estdo_cnta

	End	

	-- actualiza los contratos que tenga nota credito en saldo 0
	Update		d
	Set			d.marca_contrato_liquidar = 1
	From		#tmpContratosLiquidacionFinalizado d
	inner join  dbo.tbEstadosCuenta k with(nolock)
		on		k.cnsctvo_estdo_cnta = d.cnsctvo_estdo_cnta
		and		k.cnsctvo_scrsl = d.cnsctvo_scrsl
	inner join	dbo.tbEstadosCuentaContratos c with(nolock)
		on		c.nmro_cntrto = d.nmro_cntrto
		and		k.cnsctvo_estdo_cnta = c.cnsctvo_estdo_cnta		
	inner join	dbo.tbNotasEstadoCuenta a with(nolock)
		on		d.cnsctvo_estdo_cnta = a.cnsctvo_estdo_cnta
	inner join	dbo.tbNotasContrato b with(nolock)
		on		a.nmro_nta = b.nmro_nta
		and		a.cnsctvo_cdgo_tpo_nta = b.cnsctvo_cdgo_tpo_nta		
		and		d.nmro_cntrto = b.nmro_cntrto
	where		a.cnsctvo_cdgo_tpo_nta = 2
	and			c.sldo = 0
	and			(isnull(b.vlr,0)+isnull(b.vlr_iva,0)) = c.vlr_cbrdo

	IF	 @ldFechaCorte   is null
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'No se encontro de fecha de corte para el periodo'
		Return -1
	end	

	Insert	into TbProcesosCarteraPac Values
		(@Max_cnsctvo_prcso,
		@lnTipoProceso,
		@Fecha_Inicio_Proceso,
		NULL,
		@lcUsuario)

	Insert into #TmpContratosPac
	Select 	cnsctvo_cdgo_tpo_cntrto,
			nmro_cntrto,
			cnsctvo_cdgo_pln,
			inco_vgnca_cntrto,
			fn_vgnca_cntrto,
			nmro_unco_idntfccn_afldo,
			0	Estado
	from 	bdafiliacion.dbo.tbcontratos with(nolock)
	Where 	cnsctvo_cdgo_tpo_cntrto	=	@tipoContratoPAC 
	--And		estdo_cntrto			=	@estadoActivo
	And		datediff(dd,inco_vgnca_cntrto,@ldFechaCorte) >= 0 
	And		datediff(dd,@ldFechaCorte,fn_vgnca_cntrto) >= 0

	Insert into #tmpCobranzasPac
	Select  c.cnsctvo_cdgo_tpo_cntrto,
		c.nmro_cntrto,
		c.cnsctvo_cbrnza,
		c.nmro_unco_idntfccn_aprtnte,
		c.cnsctvo_cdgo_clse_aprtnte,
		c.cnsctvo_cdgo_prdcdd_prpgo,
		0	lsto_fcttr
	From	bdafiliacion.dbo.tbcobranzas c with(nolock)
	inner join [BDAfiliacion].dbo.[tbVigenciasCobranzas] vc With (Nolock)	on	c.cnsctvo_cdgo_tpo_cntrto	= vc.cnsctvo_cdgo_tpo_cntrto
																			and c.nmro_cntrto				= vc.nmro_cntrto
																			and c.cnsctvo_cbrnza			= vc.cnsctvo_cbrnza
	Where	c.cnsctvo_cdgo_tpo_cntrto	    =	2
	And		c.cnsctvo_cdgo_prdcdd_prpgo	  >=	1 
	and		vc.estdo_rgstro				= @vldoSi
    and		@ldFechaCorte  between vc.inco_vgnca_cbrnza			and vc.fn_vgnca_cbrnza
	--And		estdo				    =	'A'

	Update 	#tmpCobranzasPac
	Set	lsto_fcttr			=	1
	Where 	cnsctvo_cdgo_prdcdd_prpgo	=	1
	
	--Se crea una tabla temporal con la informacion del cobranzas  diferente a mensual
	insert Into	#tmpcobranzasMp
	Select  cnsctvo_cdgo_tpo_cntrto,
		nmro_cntrto,
		cnsctvo_cbrnza,
		nmro_unco_idntfccn_aprtnte,
		cnsctvo_cdgo_clse_aprtnte,
		cnsctvo_cdgo_prdcdd_prpgo,
		lsto_fcttr,
		@ldFechaCorte		      Fecha_lqdcn,
		convert(datetime,null) 	     ultma_Fecha_lqdcn,
		0	nmro_mss,
		cnsctvo_cdgo_prdcdd_prpgo	nmro_mss_prdo
	From	#tmpCobranzasPac
	Where	cnsctvo_cdgo_prdcdd_prpgo	 !=	1 

	-- se hace la homologacion para el consecutivo de periodos y el calculo de numero de meses
	Update  #tmpcobranzasMp	
	Set	nmro_mss_prdo 		  = 6
	Where   cnsctvo_cdgo_prdcdd_prpgo = 5 
	
	Update  #tmpcobranzasMp	
	Set	nmro_mss_prdo = 12
	Where   cnsctvo_cdgo_prdcdd_prpgo = 6
	
	
	-- se actualiza la fecha de la ultima factura creada para esos contratos de su correspondiente cobranzas
	Update  #tmpcobranzasMp
	Set	ultma_Fecha_lqdcn	=	fcha_incl_prdo_lqdcn
	From	#tmpcobranzasMp a, (SELECT   	  a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte ,
				 	  c.cnsctvo_cdgo_tpo_cntrto,
				 	  c.nmro_cntrto	,
					  max(e.fcha_incl_prdo_lqdcn) fcha_incl_prdo_lqdcn
			    FROM    	  bdcarteraPac.dbo.TbestadosCuenta a,	     bdcarteraPac.dbo.TbEstadosCuentaContratos  c,
			 		  bdcarteraPac.dbo.Tbliquidaciones d ,	     bdcarteraPac.dbo.Tbperiodosliquidacion_vigencias e,
									 (select   cnsctvo_cdgo_tpo_cntrto,
							 			   nmro_cntrto
									   From	 #tmpcobranzasMp
									  Group by cnsctvo_cdgo_tpo_cntrto,		 nmro_cntrto) tmpcontratos
	  		   Where  a.cnsctvo_estdo_cnta			=	c.cnsctvo_estdo_cnta  
			   And	  d.cnsctvo_cdgo_estdo_lqdcn		=	3	  
			   And	  a.cnsctvo_cdgo_estdo_estdo_cnta	!=4
		 	   And	  e.cnsctvo_cdgo_prdo_lqdcn		=	d.cnsctvo_cdgo_prdo_lqdcn  
			   And	  a.cnsctvo_cdgo_lqdcn			=	d.cnsctvo_cdgo_lqdcn  
			   And	  c.nmro_cntrto 			= 	tmpcontratos.nmro_cntrto
			   And	  c.cnsctvo_cdgo_tpo_cntrto	=	tmpcontratos.cnsctvo_cdgo_tpo_cntrto
			   Group by  a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte ,
				  c.cnsctvo_cdgo_tpo_cntrto,
				  c.nmro_cntrto	 ) tmpAportacontrato

	Where 	 a.nmro_unco_idntfccn_aprtnte	=	tmpAportacontrato.nmro_unco_idntfccn_empldr
	And	 a.cnsctvo_cdgo_clse_aprtnte	=	tmpAportacontrato.cnsctvo_cdgo_clse_aprtnte
	And	 a.cnsctvo_cdgo_tpo_cntrto	=	tmpAportacontrato.cnsctvo_cdgo_tpo_cntrto
	And	 a.nmro_cntrto			=	tmpAportacontrato.nmro_cntrto

	--- Se  actualiza el numero de meses correspondiente a la ultima factura creada
	Update  #tmpcobranzasMp
	Set	nmro_mss	=	 isnull(DATEDIFF(month, ultma_Fecha_lqdcn,Fecha_lqdcn) ,0)
	
	-- Se  actualiza  las cobranzas que cumplen el criterio de la ultima factura con respecto a la periodicidad del contrato
	Update  #tmpcobranzasMp
	Set	lsto_fcttr	=	    1
	where 	(nmro_mss	%	    nmro_mss_prdo = 0 ) or  nmro_mss = 0
	
	--- se actualizan las cobranzas que sea mayor a uno y que se deben de facturar de nuevo
	
	Update 	#tmpCobranzasPac
	Set	lsto_fcttr	=	1
	From	#tmpCobranzasPac a inner join #tmpcobranzasMp b
		on (a.cnsctvo_cdgo_tpo_cntrto    	=  b.cnsctvo_cdgo_tpo_cntrto
	And	a.nmro_cntrto		     	=  b.nmro_cntrto
	And	a.cnsctvo_cbrnza	     	=  b.cnsctvo_cbrnza
	And	a.nmro_unco_idntfccn_aprtnte 	=  b.nmro_unco_idntfccn_aprtnte
	And	a.cnsctvo_cdgo_clse_aprtnte  	=  b.cnsctvo_cdgo_clse_aprtnte	)
	Where 	a.cnsctvo_cdgo_prdcdd_prpgo	!= 1
	And	b.lsto_fcttr		     	=  1	

--Se crea la tabla temporal de los contratos que no se pueden facturar por sus causa de  periodicidad mayor a mensual
	insert into #tmpContratosLogPeriodicidadmayor
	Select 	nmro_unco_idntfccn_aprtnte , 	cnsctvo_cbrnza , 	cnsctvo_cdgo_tpo_cntrto ,	nmro_cntrto,	cnsctvo_cdgo_clse_aprtnte,
		1 cnsctvo_scrsl
	From	#tmpCobranzasPac 
	Where 	lsto_fcttr = 0
	Group by  nmro_unco_idntfccn_aprtnte , cnsctvo_cbrnza , 	cnsctvo_cdgo_tpo_cntrto ,	nmro_cntrto,	cnsctvo_cdgo_clse_aprtnte


-- se borran las cobranas que sean mayor a uno y que no se pueden generar otra factura

	Delete from #tmpCobranzasPac Where lsto_fcttr = 0

	Drop table #tmpcobranzasMp  

-- como existen registros con  traslape de vigencias de contratos  se crea la tabla temporal de  esta forma

	insert into 	#tmpVigenciasCobranzasPac
	Select   max(cnsctvo_vgnca_cbrnza) cnsctvo_vgnca_cbrnza,
	         max(inco_vgnca_cbrnza) inco_vgnca_cbrnza,
	         max(fn_vgnca_cbrnza) fn_vgnca_cbrnza ,
	         max(cta_mnsl)  cta_mnsl,
	         cnsctvo_cdgo_tpo_cntrto,
	         nmro_cntrto,
	         max(cnsctvo_cbrnza) cnsctvo_cbrnza,
	         max(cnsctvo_scrsl_ctznte) cnsctvo_scrsl_ctznte
	From	bdafiliacion.dbo.tbVigenciasCobranzas
	where   cnsctvo_cdgo_tpo_cntrto		 =	@tipoContratoPAC
	And	estdo_rgstro			 =	 @vldoSi
	And	datediff(dd,inco_vgnca_cbrnza,@ldFechaCorte)>=0 
	And	datediff(dd,@ldFechaCorte,fn_vgnca_cbrnza)>=0
	Group by   cnsctvo_cdgo_tpo_cntrto,
		    nmro_cntrto

	--Se actualiza la sucursal del aportante que tiene periodicidad mayor a mensual.
	Update 	#tmpContratosLogPeriodicidadmayor
	Set	cnsctvo_scrsl	=	b.cnsctvo_scrsl_ctznte
	From	#tmpContratosLogPeriodicidadmayor a inner join  #tmpVigenciasCobranzasPac b
    	on (a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
	And	a.nmro_cntrto			=	b.nmro_cntrto
	And	a.cnsctvo_cbrnza		=	b.cnsctvo_cbrnza)


	--Se actualiza el campo para verificar si tiene vigencia cuota activa
	Update #TmpContratosPac
	Set	estado = 1
	From	#TmpContratosPac a inner join #tmpVigenciasCobranzasPac b
	on (a.nmro_cntrto 			= 	b.nmro_cntrto
	And	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto)



	Insert into 	#tmpContratosVigenciaCuotaAcotada
	Select   		nmro_cntrto , 	cnsctvo_cdgo_tpo_cntrto,
			0 	nmro_unco_idntfccn_aprtnte,
			0	cnsctvo_scrsl_ctznte,
			0	cnsctvo_cdgo_clse_aprtnte,
			0	cnsctvo_cbrnza		
	From		#TmpContratosPac
	Where 		estado = 0 
	Group by 	nmro_cntrto , cnsctvo_cdgo_tpo_cntrto


	Update 		#tmpContratosVigenciaCuotaAcotada
	Set		nmro_unco_idntfccn_aprtnte	=	b.nmro_unco_idntfccn_aprtnte,
			cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte,
			cnsctvo_cbrnza			=	b.cnsctvo_cbrnza
	From		#tmpContratosVigenciaCuotaAcotada a inner join 	#tmpCobranzasPac b
		on (a.nmro_cntrto			=	b.nmro_cntrto
		And a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto)


	Update 		#tmpContratosVigenciaCuotaAcotada
	Set		cnsctvo_scrsl_ctznte		=	b.cnsctvo_scrsl_ctznte
	From		#tmpContratosVigenciaCuotaAcotada a inner join 	bdafiliacion.dbo.tbvigenciasCobranzas b
		on (a.nmro_cntrto			=	b.nmro_cntrto
		And a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And a.cnsctvo_cbrnza		=	b.cnsctvo_cbrnza)

	--Paso  1
	insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Inicial Proceso de Consulta Beneficiarios',Getdate())


	-- se traen todos los contratos qe se van a liquidar
	insert into   	#Tmpcontratos_Antes_liquidar
	select  a.cnsctvo_cdgo_tpo_cntrto,	a.nmro_cntrto,	a.cnsctvo_cdgo_pln,	a.inco_vgnca_cntrto,	a.fn_vgnca_cntrto,
		a.nmro_unco_idntfccn_afldo,
		b.cnsctvo_cbrnza,		b.nmro_unco_idntfccn_aprtnte,
		c.cnsctvo_vgnca_cbrnza,		c.cnsctvo_scrsl_ctznte,		c.inco_vgnca_cbrnza,	c.fn_vgnca_cbrnza,
		c.cta_mnsl,			b.cnsctvo_cdgo_prdcdd_prpgo,
		0				cnsctvo_estdo_cnta,
		cnsctvo_cdgo_clse_aprtnte,
		0	 	vlr_ttl_cntrto,
		0	 	vlr_ttl_cntrto_sn_iva,
		0				cntdd_ttl_bnfcrs,
		1 	Grupo_Conceptos,          -- por defecto  se toma el concepto generico
		0 	Estado_Contrato_Liquidacion		-- estado del contrato para liquidar
	From 	#TmpContratosPac a inner join		#tmpCobranzasPac  b
	on (a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto
	    And  a.nmro_cntrto	      = b.nmro_cntrto) inner join
	#tmpVigenciasCobranzasPac  c
	on (c.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto
	   And	c.nmro_cntrto		  = b.nmro_cntrto
	   And	c.cnsctvo_cbrnza	  = b.cnsctvo_cbrnza)

	If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error Creando informacion de los beneficiarios'
		Return -1
	End


	-- Se actualiza el campo estado de la liquidacion  de los contratos que ya tiene una liquidacion finalizada para ese periodo de liquidacion
	Update	#Tmpcontratos_Antes_liquidar
	Set	Estado_Contrato_Liquidacion	=	1
	From	#Tmpcontratos_Antes_liquidar	a inner join	#tmpContratosLiquidacionFinalizado	b
	on (a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
	  And	a.nmro_cntrto			=	b.nmro_cntrto
	  And	a.nmro_unco_idntfccn_aprtnte	=	b.nmro_unco_idntfccn_empldr
	  And	a.cnsctvo_scrsl_ctznte		=	b.cnsctvo_scrsl 
	  And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte)
	where		b.marca_contrato_liquidar = 0


	If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error actualizando contratos finalizados'
		Return -1
	End

	-- Se crea una tabla temporal con los aportante que no se deben de liquidar
	Insert   Into  	#tmpAportantesNoliquidar
	Select   nmro_unco_idntfccn_aprtnte, cnsctvo_scrsl_ctznte , cnsctvo_cdgo_clse_aprtnte
	From	 #Tmpcontratos_Antes_liquidar
	Where    Estado_Contrato_Liquidacion	=	1
	Group by nmro_unco_idntfccn_aprtnte, cnsctvo_scrsl_ctznte , cnsctvo_cdgo_clse_aprtnte

	
	If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error Creando tabla temporal de contratos afectados liquidados'
		Return -1
	End


	-- Se crea una tabla temporal con los contratos  que no se han liquidado pero el aportante
	-- ya se liquido
	--insert into	#tmpcontratosListoNoLiquidados
	--Select   a.cnsctvo_cdgo_tpo_cntrto, 	a.nmro_cntrto,
	--	a.nmro_unco_idntfccn_aprtnte,
	--	a.cnsctvo_scrsl_ctznte,
	--	a.cnsctvo_cdgo_clse_aprtnte
	--From	#Tmpcontratos_Antes_liquidar a inner join  #tmpAportantesNoliquidar b
	--	on (a.nmro_unco_idntfccn_aprtnte	=	b.nmro_unco_idntfccn_aprtnte
	--	    And	a.cnsctvo_scrsl_ctznte		=	b.cnsctvo_scrsl_ctznte
	--	    And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte)
	--Where   a.Estado_Contrato_Liquidacion	=	0


	--Se ingresan los contratos de los aportantes marcados para no liquidar en la masiva

	if 	@lnConsecutivoTipoProceso	=	2 -- proceso masivo	
	begin	
	    insert into	#tmpcontratosListoNoLiquidados
	    Select   	a.cnsctvo_cdgo_tpo_cntrto, 	a.nmro_cntrto,
					a.nmro_unco_idntfccn_aprtnte,
					a.cnsctvo_scrsl_ctznte,
					a.cnsctvo_cdgo_clse_aprtnte
	    From		#Tmpcontratos_Antes_liquidar a 
		inner join  #tmpAportantesMarcadosNoMasiva b
			on		(a.nmro_unco_idntfccn_aprtnte	=	b.nmro_unco_idntfccn_aprtnte
		    And	a.cnsctvo_scrsl_ctznte		=	b.cnsctvo_scrsl_ctznte
	 	    And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte)
	end
	
	If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error Creando tabla temporal de contratos no liquidados y aportante liquidado'
		Return -1
	End

	if 	@lnConsecutivoTipoProceso	=	2 -- proceso masivo	
	begin	
		--Se actualiza  todos los contratos donde el aportante de ya liquido para que no le vuelva a generar otra factura
		Update		#Tmpcontratos_Antes_liquidar
		Set			Estado_Contrato_Liquidacion	=	1
		From		#Tmpcontratos_Antes_liquidar a 
		inner join  #tmpcontratosListoNoLiquidados b
			on		(a.nmro_unco_idntfccn_aprtnte	=	b.nmro_unco_idntfccn_aprtnte
			And	 a.cnsctvo_scrsl_ctznte			=	b.cnsctvo_scrsl_ctznte
			And	 a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
			And	 a.cnsctvo_cdgo_tpo_cntrto		=	b.cnsctvo_cdgo_tpo_cntrto
			And	 a.nmro_cntrto					=	b.nmro_cntrto)
	end
	If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error actualizando tabla temporal de contratos ya finalizados'
		Return -1
	End


	Insert	#TmpContratosLogResultados
	Select	cnsctvo_cdgo_tpo_cntrto,		nmro_cntrto,	'CONTRATO PROCESADO'   	, 
		nmro_unco_idntfccn_empldr , 		cnsctvo_scrsl , 	cnsctvo_cdgo_clse_aprtnte
	From	#tmpContratosLiquidacionprocesada
	
	
	Insert	#TmpContratosLogResultados
	Select	cnsctvo_cdgo_tpo_cntrto,		nmro_cntrto,	'CONTRATO FINALIZADO'   	,
		nmro_unco_idntfccn_empldr , 		cnsctvo_scrsl , 	cnsctvo_cdgo_clse_aprtnte
	From	#tmpContratosLiquidacionFinalizado
	
	
	Insert	#TmpContratosLogResultados
	Select  cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,		'CONTRATO CON APORTANTE MARCADO PARA LIQUIDACION POSTERIOR',
		nmro_unco_idntfccn_aprtnte,	cnsctvo_scrsl_ctznte,	cnsctvo_cdgo_clse_aprtnte
	From	#tmpcontratosListoNoLiquidados

	If	@lnConsecutivoTipoProceso	=	2 -- proceso masivo
		--Se adiciona los contratos que no se liquidan con periodicidad mayor a unmes
	Begin
		Insert	#TmpContratosLogResultados
		Select 	cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,		'PERIODICIDAD SUPERIOR A UN MES',
			nmro_unco_idntfccn_aprtnte , 	cnsctvo_scrsl , 		cnsctvo_cdgo_clse_aprtnte
		From	#tmpContratosLogPeriodicidadmayor 
		group by  nmro_unco_idntfccn_aprtnte ,  	cnsctvo_cdgo_tpo_cntrto ,	nmro_cntrto,	cnsctvo_cdgo_clse_aprtnte , cnsctvo_scrsl


		Insert	#TmpContratosLogResultados
		Select 	cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,		'VIGENCIA CUOTA ACOTADA',
			nmro_unco_idntfccn_aprtnte , 	cnsctvo_scrsl_ctznte , 		cnsctvo_cdgo_clse_aprtnte
		From	#tmpContratosVigenciaCuotaAcotada 

	End

	Drop Table #tmpContratosLogPeriodicidadmayor
	
	
	Drop Table #tmpContratosVigenciaCuotaAcotada


	if	@lnConsecutivoTipoProceso	=	1 -- proceso individual , entonces se verifica que sucursales tiene para liquidar
	begin	


		Insert into #Tmpcontratos
		select  distinct	 a.cnsctvo_cdgo_tpo_cntrto,	a.nmro_cntrto,	a.cnsctvo_cdgo_pln,	a.inco_vgnca_cntrto,	a.fn_vgnca_cntrto,
			a.nmro_unco_idntfccn_afldo,
			a.cnsctvo_cbrnza,		a.nmro_unco_idntfccn_aprtnte,
			a.cnsctvo_vgnca_cbrnza,	a.cnsctvo_scrsl_ctznte,			a.inco_vgnca_cbrnza,	a.fn_vgnca_cbrnza,
			a.cta_mnsl,			a.cnsctvo_cdgo_prdcdd_prpgo,
			0				cnsctvo_estdo_cnta,
			a.cnsctvo_cdgo_clse_aprtnte,
			convert(numeric(12,0),0)	 	vlr_ttl_cntrto,
			convert(numeric(12,0),0)	 	vlr_ttl_cntrto_sn_iva,
			0				cntdd_ttl_bnfcrs,
			1 	as  	Grupo_Conceptos,          -- por defecto  se toma el concepto generico
			0	as 	Activo,
			0	as	Cntrto_igual_cro
		From 	#Tmpcontratos_Antes_liquidar	 a inner join  bdcarterapac.dbo.tbcriteriosliquidacion  b	
			on (a.nmro_unco_idntfccn_aprtnte	 = 	b.nmro_unco_idntfccn_empldr
			  --  And a.cnsctvo_scrsl_ctznte		 = 	b.cnsctvo_scrsl
			    And	a.cnsctvo_cdgo_clse_aprtnte	 = 	b.cnsctvo_cdgo_clse_aprtnte)
		Where   	b.cnsctvo_cdgo_lqdcn		=	@cnsctvo_cdgo_lqdcn	-- sea igual a la liquidacion
		And	Estado_Contrato_Liquidacion		=	0  -- contratos que se pueden liquidar
	end


	if	@lnConsecutivoTipoProceso	=	2 -- proceso Masivo , entonces contempla todos las sucursales
	begin	

		-- se insertan todos los registros que tiene la tabla temporal #Tmpcontratos_Antes_liquidar
		Insert into #Tmpcontratos
		select  distinct	 a.cnsctvo_cdgo_tpo_cntrto,	a.nmro_cntrto,	a.cnsctvo_cdgo_pln,	a.inco_vgnca_cntrto,	a.fn_vgnca_cntrto,
			a.nmro_unco_idntfccn_afldo,
			a.cnsctvo_cbrnza,		a.nmro_unco_idntfccn_aprtnte,
			a.cnsctvo_vgnca_cbrnza,	a.cnsctvo_scrsl_ctznte,			a.inco_vgnca_cbrnza,	a.fn_vgnca_cbrnza,
			a.cta_mnsl,			a.cnsctvo_cdgo_prdcdd_prpgo,
			0				cnsctvo_estdo_cnta,
			cnsctvo_cdgo_clse_aprtnte,
			convert(numeric(12,0),0)	 	vlr_ttl_cntrto,
			convert(numeric(12,0),0)	 	vlr_ttl_cntrto_sn_iva,
			0				cntdd_ttl_bnfcrs,
			1 	as  	Grupo_Conceptos,          -- por defecto  se toma el concepto generico
			0	as 	Activo,
			0	as	Cntrto_igual_cro
		From 	#Tmpcontratos_Antes_liquidar	 a
		Where 	Estado_Contrato_Liquidacion		=	0  -- contratos que se pueden liquidar
	end

	--se quitan las sucursales las cuales no se deben liquidar de los contratos con notas con saldo cero
	delete a	 
	from #Tmpcontratos a
	inner join 	#tmpContratosLiquidacionFinalizado b
	on b.nmro_cntrto = a.nmro_cntrto
	and a.cnsctvo_scrsl_ctznte != b.cnsctvo_scrsl
	where b.marca_contrato_liquidar = 1

	delete		d
	from		#Tmpcontratos d
	inner join	dbo.tbNotasContrato  a
		on		a.nmro_cntrto = d.nmro_cntrto
	inner join	 dbo.tbNotasPac c
		on		c.nmro_nta = a.nmro_nta
		and		c.cnsctvo_cdgo_tpo_nta = a.cnsctvo_cdgo_tpo_nta
	where		a.cnsctvo_cdgo_tpo_nta = 1
	and			c.cnsctvo_prdo = @lnConsecutivoPeriodoLiquidacion

	--nuevo 28 de enero del 2004
	--Se verifica yo esos contratos asociados a los responsable si tienen mas o igual a dos cuotas para no generarle factura
	insert into    	#tmpEstadosCuentaContratos  
	Select   a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte,
	 a.nmro_estdo_cnta,
	 c.cnsctvo_estdo_cnta_cntrto,
	 c.cnsctvo_estdo_cnta,
	 c.cnsctvo_cdgo_tpo_cntrto,
	 c.nmro_cntrto,
	 c.vlr_cbrdo,
	 c.sldo
	From    bdcarteraPac.dbo.TbEstadosCuenta a inner join bdcarterapac.dbo.tbliquidaciones b
	on (a.cnsctvo_cdgo_lqdcn		=	b.cnsctvo_cdgo_lqdcn)
        inner join tbEstadosCuentaContratos c
	on (a.cnsctvo_estdo_cnta		=	c.cnsctvo_estdo_cnta)
	where   c.sldo	 > 0
	And	c.vlr_cbrdo = c.sldo
	And	b.cnsctvo_cdgo_estdo_lqdcn	=	3


	--Se 	Crea el Saldo anterior
	Insert  Into  #tmpSaldoContratoResponsable
	Select  a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte,  
		a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto ,
		Sum(sldo) sldo,
		count(nmro_estdo_cnta) cuotas,
		@lndiasdesafiliacion	nmro_cts_prmtdas,
		0	Vldo_pra_fctrr
	From	#tmpEstadosCuentaContratos a
	Where 	sldo  > 0
	Group by a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte,
	 a.cnsctvo_cdgo_tpo_cntrto,   a.nmro_cntrto 


	--Se Suman El Numero De Cuotas Para La Suspencion que existen en productos convirtiendo a entero
	Update  #tmpSaldoContratoResponsable
	Set	nmro_cts_prmtdas  		= 	nmro_cts_prmtdas + convert(int,(b.ds_pra_sspnsn/30))  
	From 	#tmpSaldoContratoResponsable a inner join        	bdAfiliacion.dbo.tbDatosComercialesSucursal b
	on 	(a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
	And	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl
	And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte)


	--- SE crea el numero de estados de cuenta pendientes con saldo
	Insert into #tmpCuotasDebitosPendienteXAportante ---Estados de cuenta 
	Select   a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte,
		 count(nmro_estdo_cnta) cuotas
	From    bdcarteraPac.dbo.TbEstadosCuenta a inner join bdcarteraPac.dbo.tbliquidaciones b  
		on (a.cnsctvo_cdgo_lqdcn		=	b.cnsctvo_cdgo_lqdcn)
	Where    a.sldo_estdo_cnta	 	> 	0
	And	b.cnsctvo_cdgo_estdo_lqdcn	=	3
	Group by a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte
	
	
	Insert into #tmpCuotasDebitosPendienteXAportante 
	Select  a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte,
		count(nmro_nta) cuotas ---Notas debito
	From    bdcarteraPac.dbo.TbNotasPac a join bdcarteraPac.dbo.tbliquidaciones b  
		on (a.cnsctvo_prdo		=	b.cnsctvo_cdgo_lqdcn)
	Where   a.sldo_nta	 			> 	0
	And	a.cnsctvo_cdgo_tpo_nta			=	1
	And 	b.cnsctvo_cdgo_estdo_lqdcn		=	3
	And 	a.cnsctvo_cdgo_estdo_nta		in	(1,2,3)
	Group by a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte
	
	select nmro_unco_idntfccn_empldr, cnsctvo_scrsl, cnsctvo_cdgo_clse_aprtnte, SUM(cuotas)  cuotas
	into 	#tmpCuotasPendienteXAportante
	from 	#tmpCuotasDebitosPendienteXAportante 
	group by nmro_unco_idntfccn_empldr, cnsctvo_scrsl, cnsctvo_cdgo_clse_aprtnte
	
	
	--Se crean los aportantes que   tiene 1,2,3  factura en mora
	insert into #tmpResponsableConSaldoAnterior
	Select     a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte, 
		   sum(sldo)	sldo_antrr,
		   0		Cts_sn_cnclar
	From	   #tmpSaldoContratoResponsable a
	Where 	  cuotas		in (1,2,3)
	Group by a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte
	
	--aqui se modifica para  sus
	--Where 	  cuotas		in (1,2,3,4)
	
	---Actualiza el numero de cuotas para cada aportante
	Update #tmpResponsableConSaldoAnterior
	Set	Cts_sn_cnclar	=	b.cuotas
	From	#tmpResponsableConSaldoAnterior a inner join  #tmpCuotasPendienteXAportante b
		on (a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
		    And	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl
		    And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte)
	
	
	
	Update #tmpResponsableConSaldoAnterior
	Set	Cts_sn_cnclar	=	4
	where    Cts_sn_cnclar  >= 	5
	
	--aqui se modifica para  sus
	--Set	Cts_sn_cnclar	=	5
	--where    Cts_sn_cnclar    >= 6
	
	--se actualiza el campo para aquellos registros donde se pueden facturar y tienen cuotas en mora menor o igual a 2
	Update #tmpSaldoContratoResponsable
	Set	Vldo_pra_fctrr	=	1
	Where	cuotas	<  @lndiasdesafiliacion --menor al numero de cuotas  para desafiliar 
	
	
	--Where	cuotas	in (0,1,2)
	
	--Se actualizal el campo para aquellos registros donde el numero de cuotas reales sea menor o igual al permitido y sean mayor a 2 cuotas  reales
	--Actualizacion  04 de marzo del 2005
	--Deber menor 	---	cuotas 		<= 	nmro_cts_prmtdas
	Update #tmpSaldoContratoResponsable
	Set	Vldo_pra_fctrr	 =	1
	Where	cuotas 		 < 	nmro_cts_prmtdas
	And	Vldo_pra_fctrr	 =	0
	
	
	--Nuevo  el  13  de  noviembre  del  2004
	insert into		#tmpContratosSuspenConUnacuota
	Select   	cnsctvo_cdgo_tpo_cntrto, 	nmro_cntrto 
	From		#tmpSaldoContratoResponsable 
	Where 		Vldo_pra_fctrr	=	1
	Group by 	cnsctvo_cdgo_tpo_cntrto,	 nmro_cntrto

--Anterior
--Se Crean los Contratos para verificar si estan suspendidos  pero se les permite crear otra factura
/*
Select   		cnsctvo_cdgo_tpo_cntrto, 	nmro_cntrto 
into		#tmpContratosSuspenConUnacuota
From		#tmpSaldoContratoResponsable 
Where 		cuotas		in 	(1,2,3)
Group by 	cnsctvo_cdgo_tpo_cntrto,	 nmro_cntrto

--aqui se modifica para  sus
--Where 		cuotas		in 	(1,2,3,4)

-- se crean los contratos que tienen mas de dos facturas para no generar tercera factura
--	cuotas >= 2   o (arriba  cuotas >= 1 y cuotas <= 2) para la tabla  #tmpResponsableConSaldoAnterior
*/


--Nuevo 13 de noviembre del 2004
	insert Into	#tmpCuotasMayorigualDos
	Select nmro_unco_idntfccn_empldr ,
	       cnsctvo_scrsl ,
	       cnsctvo_cdgo_clse_aprtnte ,
	       cnsctvo_cdgo_tpo_cntrto ,
	       nmro_cntrto ,
	       sldo ,
	       cuotas ,
	       nmro_cts_prmtdas ,
	       Vldo_pra_fctrr 
	From	#tmpSaldoContratoResponsable
	Where 	Vldo_pra_fctrr	= 0 


/*  --Anterior
Select *
Into	#tmpCuotasMayorigualDos
From	#tmpSaldoContratoResponsable
Where 	cuotas	>= 4    
-- aqui se modifica para  sus	5
*/

	--Se inserta la informacion de los contratos que no se puede generar factura y se mandan para el log
	Insert	#TmpContratosLogResultados
	Select	a.cnsctvo_cdgo_tpo_cntrto,		a.nmro_cntrto,	'SUSPENSION CUOTAS',
		a.nmro_unco_idntfccn_aprtnte,		a.cnsctvo_scrsl_ctznte,			a.cnsctvo_cdgo_clse_aprtnte
	From	#Tmpcontratos a inner join  #tmpCuotasMayorigualDos b
		on (a.nmro_unco_idntfccn_aprtnte	=	b.nmro_unco_idntfccn_empldr
		    And	a.cnsctvo_scrsl_ctznte		=	b.cnsctvo_scrsl
		    And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
		    And	a.nmro_cntrto			=	b.nmro_cntrto
		    And	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto)
	Group by 	a.cnsctvo_cdgo_tpo_cntrto,		a.nmro_cntrto,	
			a.nmro_unco_idntfccn_aprtnte,		a.cnsctvo_scrsl_ctznte,			a.cnsctvo_cdgo_clse_aprtnte
	
	-- Se crea tabla con los registros que va desafiliar
	insert into #TmpcontratosDesafiliarMoraPac
	Select	cnsctvo_cdgo_tpo_cntrto,
		nmro_cntrto,	
		nmro_unco_idntfccn_afldo,
		cnsctvo_cbrnza,
		nmro_unco_idntfccn_empldr,
		cnsctvo_scrsl,
		cnsctvo_cdgo_clse_aprtnte,
		Estdo
	From	(Select	a.cnsctvo_cdgo_tpo_cntrto,
			a.nmro_cntrto,	
			a.nmro_unco_idntfccn_afldo,
			a.cnsctvo_cbrnza,
			b.nmro_unco_idntfccn_empldr,
			b.cnsctvo_scrsl,
			b.cnsctvo_cdgo_clse_aprtnte,
			space(1)	Estdo
		From	#Tmpcontratos a inner join  #tmpCuotasMayorigualDos b
			on (    a.nmro_unco_idntfccn_aprtnte	=	b.nmro_unco_idntfccn_empldr
			And	a.cnsctvo_scrsl_ctznte		=	b.cnsctvo_scrsl
			And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
			And	a.nmro_cntrto			=	b.nmro_cntrto
			And	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto)
		Group by 	a.cnsctvo_cdgo_tpo_cntrto,
			a.nmro_cntrto,	
			a.nmro_unco_idntfccn_afldo,
			a.cnsctvo_cbrnza,
			b.nmro_unco_idntfccn_empldr,
			b.cnsctvo_scrsl,
			b.cnsctvo_cdgo_clse_aprtnte ) tmpcontradesafili
	
	
	--Se eliminan los contratos asociados a los responsables que tienen mas o igual a dos estados de cuenta en mora.
	Delete  #Tmpcontratos
	From	#Tmpcontratos a inner join #tmpCuotasMayorigualDos b
		on (a.nmro_unco_idntfccn_aprtnte	=	b.nmro_unco_idntfccn_empldr
		And	a.cnsctvo_scrsl_ctznte		=	b.cnsctvo_scrsl
		And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
		And	a.nmro_cntrto			=	b.nmro_cntrto
		And	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto)
	
	
	If  @@Error!=0  
		Begin 
			Set	@lnProcesoExitoso	=	1
			Set	@lcMensaje		=	'Error eliminando contratos con mas de 3 facturas en mora ' 
			Return -1
	
		end	


--Fin de los contratos que no se le van hacer factura
--Fin 28 de enero 2004

-- se trae la informacion de los beneficiarios  asociados a los contratos y  vigentes

--Verifica si el estado del beneficiario esta Activo y no suspendido
insert Into #tmpBeneficiariosActivos                   
Select 	   cnsctvo_cdgo_tpo_cntrto,
           nmro_cntrto,
           cnsctvo_bnfcro,
           nmro_unco_idntfccn_bnfcro,
           inco_vgnca_bnfcro,
           fn_vgnca_bnfcro,
           cnsctvo_cdgo_tpo_afldo,
           cnsctvo_cdgo_prntsco,
           0		Activo	
from 	bdafiliacion.dbo.tbBeneficiarios
Where   cnsctvo_cdgo_tpo_cntrto 	=	 2
--And	estdo				=	'A'
And		datediff(dd,inco_vgnca_bnfcro,@ldFechaCorte) >= 0 
And		datediff(dd,@ldFechaCorte,fn_vgnca_bnfcro) >= 0
--aqui estdo


/*Se crea la tabla temporal con la informacion delos beneficiarios que se encuentran activos y tambien pueden estar suspendidos*/
insert into #tmpHistoricoEstadosBeneficiario 
Select   cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	cnsctvo_bnfcro,
	nmro_unco_idntfccn_bnfcro,
	cnsctvo_cdgo_estdo_bfcro
from  	bdafiliacion.dbo.tbHistoricoEstadosBeneficiario
Where 	cnsctvo_cdgo_tpo_cntrto 	= 	 2
And	hbltdo				=	'S'
and 	(cnsctvo_cdgo_estdo_bfcro = 1 or cnsctvo_cdgo_estdo_bfcro  = 5 )
And	datediff(dd,inco_vgnca_estdo_bnfcro,@ldFechaCorte)>=0 
And	datediff(dd,@ldFechaCorte,fn_vgnca_estdo_bnfcro)>=0


--Como un beneficiario puede tener 2 estados a la vez activos o suspendidos
--hay que identificar que solamente tengan el estado activo
--Se crea una tabla temporal de los benefciarios activos  de la consulta anterior

insert into #tmpBeneficiariosEstadoActivos
Select 	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
       	cnsctvo_bnfcro,
	nmro_unco_idntfccn_bnfcro,
	cnsctvo_cdgo_estdo_bfcro,
	0	Suspendido
From	#tmpHistoricoEstadosBeneficiario
Where 	cnsctvo_cdgo_estdo_bfcro	=	1


/*Se crea una tabla temporal de los benefciarios Suspendidos*/
insert into	#tmpBeneficiariosEstadoSuspendidos
Select 	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
       	cnsctvo_bnfcro,
	nmro_unco_idntfccn_bnfcro,
	cnsctvo_cdgo_estdo_bfcro
From	#tmpHistoricoEstadosBeneficiario
Where 	cnsctvo_cdgo_estdo_bfcro	=	5

--Se borran los contratos que estan suspendidos  pero como solo tiene una cuota en mora se le permite asociar  el segundo estado de cuenta

Delete	#tmpBeneficiariosEstadoSuspendidos
From	#tmpBeneficiariosEstadoSuspendidos a inner join   #tmpContratosSuspenConUnacuota b
on 	(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
	 And	a.nmro_cntrto		=	b.nmro_cntrto)


--


--si existen registros que esten en ambas tablas es porque puede estar suspendido a la vez.
Update 	#tmpBeneficiariosEstadoActivos
Set	suspendido	=	1
From	#tmpBeneficiariosEstadoActivos a inner join 	#tmpBeneficiariosEstadoSuspendidos b
  on    (a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
	And	a.nmro_cntrto			=	b.nmro_cntrto
	And	a.cnsctvo_bnfcro		=	b.cnsctvo_bnfcro
	And	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn_bnfcro)



Update	#tmpBeneficiariosActivos
Set	Activo		=	1
From	#tmpBeneficiariosActivos a inner join  #tmpBeneficiariosEstadoActivos b
	on (a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
	And	a.nmro_cntrto			=	b.nmro_cntrto
	And	a.cnsctvo_bnfcro		=	b.cnsctvo_bnfcro
	And	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn_bnfcro)


--And	b.suspendido			=	0

--aqui
--Se verifica si el contrato por lo menos tiene un beneficiario activo..
Insert Into   	#tmpcontratosCausaSinBene
Select  cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	nmro_unco_idntfccn_aprtnte,
	cnsctvo_scrsl_ctznte,
	cnsctvo_cdgo_clse_aprtnte,	
	0 estado
From 	  #Tmpcontratos
Group by cnsctvo_cdgo_tpo_cntrto,
	  nmro_cntrto,
	  nmro_unco_idntfccn_aprtnte,
	  cnsctvo_scrsl_ctznte,
	  cnsctvo_cdgo_clse_aprtnte	


--Se actualiza para los contratos que por lo menos tiene un beneficiario

Update #tmpcontratosCausaSinBene
Set	estado = 1
From	#tmpcontratosCausaSinBene a inner join #tmpBeneficiariosActivos b
	on (a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
	And	a.nmro_cntrto		=	b.nmro_cntrto
	And	b.Activo		=	1)

--Se inserta los contratos que no tienen beneficiarios para que salgan en log
Insert	#TmpContratosLogResultados
Select 	cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,		'CONTRATO SIN BENE ACTIVOS',
	nmro_unco_idntfccn_aprtnte , 	cnsctvo_scrsl_ctznte , 		cnsctvo_cdgo_clse_aprtnte
From	#tmpcontratosCausaSinBene
Where	 estado	=	0

Drop table #tmpcontratosCausaSinBene

--delete from  #tmpBeneficiariosActivos where Activo = 0

--Se crea tabla temporal con la causal si existe en tbdetbeneficiarioadicional
Insert  Into   	#tmpCausalContratosDetBeneficiarios
Select 	a.nmro_cntrto , 	a.cnsctvo_cdgo_tpo_cntrto , 	a.cnsctvo_cbrnza,
	b.cnsctvo_bnfcro,	
	b.nmro_unco_idntfccn_bnfcro,
	a.nmro_unco_idntfccn_aprtnte,
	a.cnsctvo_scrsl_ctznte,
	a.cnsctvo_cdgo_clse_aprtnte,		
	0			Estado_existe_tbdetbeneficiarioAdicional,
	0			Estado_existe_vigente_tbdetbeneficiarioadicional
From	#Tmpcontratos a inner join #tmpBeneficiariosActivos b
	on (a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
	And	a.nmro_cntrto		=	b.nmro_cntrto)


--Se verifica si existe en tbdetbeneficiarioAdicional	para la misma cobranza

Update #tmpCausalContratosDetBeneficiarios
Set	Estado_existe_tbdetbeneficiarioAdicional		=	1
From	#tmpCausalContratosDetBeneficiarios a inner join bdafiliacion.dbo.tbdetbeneficiarioAdicional b
	On(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
	And	a.nmro_cntrto			=	b.nmro_cntrto
	And	a.cnsctvo_bnfcro		=	b.cnsctvo_bnfcro
	And	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn_bnfcro
	And	a.cnsctvo_cbrnza		=	b.cnsctvo_cbrnza)


--Se actualiza para los que estan vigentes
Update #tmpCausalContratosDetBeneficiarios
Set	Estado_existe_vigente_tbdetbeneficiarioadicional		=	1
From	#tmpCausalContratosDetBeneficiarios a inner join  bdafiliacion.dbo.tbdetbeneficiarioAdicional b
	on( a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
	And	a.nmro_cntrto			=	b.nmro_cntrto
	And	a.cnsctvo_bnfcro		=	b.cnsctvo_bnfcro
	And	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn_bnfcro
	And	a.cnsctvo_cbrnza		=	b.cnsctvo_cbrnza)
Where	convert(varchar(10),@ldFechaCorte,111) 	between convert(varchar(10),b.inco_vgnca,111)       and	convert(varchar(10),b.fn_vgnca,111) 
And	b.estdo_rgstro			=	'S'



Select	@lnMaximo_cnsctvo_csa_bnfcro_lqdcn	=	isnull(max(cnsctvo_csa_bnfcro_lqdcn),0)
From	bdcarteraPac.dbo.tbCausasBeneficiariosxLiquidacion

Insert into	#tmpNuevosBeneNoexietentbdetbeneadicional
Select	nmro_cntrto , 	cnsctvo_cdgo_tpo_cntrto ,
	cnsctvo_bnfcro,	
	nmro_unco_idntfccn_bnfcro,
	nmro_unco_idntfccn_aprtnte,
	cnsctvo_scrsl_ctznte,
	cnsctvo_cdgo_clse_aprtnte
From	#tmpCausalContratosDetBeneficiarios
Where 	Estado_existe_tbdetbeneficiarioAdicional	=	0

--Se insertan los beneficiarios que no existen en cuotas
--Con causa no exiete vigencia cuota del bene
Insert	bdcarteraPac.dbo.tbCausasBeneficiariosxLiquidacion
Select	ID_Num	+ @lnMaximo_cnsctvo_csa_bnfcro_lqdcn,
	nmro_unco_idntfccn_bnfcro,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	nmro_unco_idntfccn_aprtnte,
	cnsctvo_scrsl_ctznte,
	cnsctvo_cdgo_clse_aprtnte,
	cnsctvo_bnfcro,
	1,
	@cnsctvo_cdgo_lqdcn,
	Null
From	#tmpNuevosBeneNoexietentbdetbeneadicional

Drop Table 	#tmpNuevosBeneNoexietentbdetbeneadicional

Select	@lnMaximo_cnsctvo_csa_bnfcro_lqdcn	=	isnull(max(cnsctvo_csa_bnfcro_lqdcn),0)
From	tbCausasBeneficiariosxLiquidacion

insert into	#tmpNuevosBeneAcotadostbdetbeneadicional
Select	nmro_cntrto , 	cnsctvo_cdgo_tpo_cntrto ,
	cnsctvo_bnfcro,	
	nmro_unco_idntfccn_bnfcro,
	nmro_unco_idntfccn_aprtnte,
	cnsctvo_scrsl_ctznte,
	cnsctvo_cdgo_clse_aprtnte
From	#tmpCausalContratosDetBeneficiarios
Where 	Estado_existe_tbdetbeneficiarioAdicional		=	1
and	Estado_existe_vigente_tbdetbeneficiarioadicional	=	0

--Se insertan los beneficiarios que no existen en cuotas
--con causa existe vigencia cuota pero acotada
Insert	BdcarteraPac.dbo.tbCausasBeneficiariosxLiquidacion
Select	ID_Num	+ @lnMaximo_cnsctvo_csa_bnfcro_lqdcn,
	nmro_unco_idntfccn_bnfcro,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	nmro_unco_idntfccn_aprtnte,
	cnsctvo_scrsl_ctznte,
	cnsctvo_cdgo_clse_aprtnte,
	cnsctvo_bnfcro,
	2,
	@cnsctvo_cdgo_lqdcn,
	NULL
From	#tmpNuevosBeneAcotadostbdetbeneadicional


Drop Table 	#tmpNuevosBeneAcotadostbdetbeneadicional
Drop Table 	#tmpCausalContratosDetBeneficiarios


Insert into 	#tmpBeneficiarios
Select  a.nmro_unco_idntfccn_aprtnte,  a.cnsctvo_scrsl_ctznte, a.cnsctvo_cdgo_clse_aprtnte , a.nmro_unco_idntfccn_afldo,a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto, 
	a.cnsctvo_cbrnza,
	a.cnsctvo_cdgo_pln,
	d.cnsctvo_bnfcro, 	d.nmro_unco_idntfccn_bnfcro, d.inco_vgnca_bnfcro,d.fn_vgnca_bnfcro,	e.vlr_upc,
	e.vlr_rl_pgo,
	0		cnsctvo_estdo_cnta_cntrto,
	convert(numeric(12,0),0)	 vlr_dcto_comercial, 	convert(numeric(12,0),0)	 vlr_otros_dcts, 	convert(numeric(12,0),0)	 vlr_iva , 
	e.vlr_upc  vlr_cta,
	convert(numeric(12,0),0)	 vlr_ttl_bnfcro,
	convert(numeric(12,0),0)	 vlr_ttl_bnfcro_sn_iva,
	convert(numeric(12,0),0)	 vlr_dcto_comercial_aux, 	convert(numeric(12,0),0)	 vlr_otros_dcts_aux, 	convert(numeric(12,0),0)	 vlr_iva_aux,
	a.Grupo_Conceptos ,
	convert(numeric(12,0),0)	vlr_upc_nuevo ,
	convert(numeric(12,0),0)	vlr_rl_pgo_nuevo,
	0	Cambio_Valor_cuota,
	case when	(e.vlr_rl_pgo	>	0) 	then	1	else	0	end Bnfcro_Dfrnte_cro,
	a.cnsctvo_vgnca_cbrnza,
	e.cnsctvo_dtlle_bnfcro_adcnl,
	a.inco_vgnca_cbrnza,
	a.cnsctvo_cdgo_prdcdd_prpgo,
	0	nmro_mss,
	e.inco_vgnca,
	e.fn_vgnca	
From 	#Tmpcontratos  a ,  #tmpBeneficiariosActivos   d,  bdafiliacion.dbo.tbdetbeneficiarioAdicional e
Where   a.cnsctvo_cdgo_tpo_cntrto	=	d.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	d.nmro_cntrto
And	d.cnsctvo_cdgo_tpo_cntrto	=	e.cnsctvo_cdgo_tpo_cntrto
And	d.nmro_cntrto			=	e.nmro_cntrto
And	d.cnsctvo_bnfcro		=	e.cnsctvo_bnfcro
And	d.nmro_unco_idntfccn_bnfcro	=	e.nmro_unco_idntfccn_bnfcro
And	a.nmro_cntrto			=	e.nmro_cntrto
And	a.cnsctvo_cdgo_tpo_cntrto	=	e.cnsctvo_cdgo_tpo_cntrto
And	a.cnsctvo_cbrnza		=	e.cnsctvo_cbrnza	
And	convert(varchar(10),@ldFechaCorte,111) 	between convert(varchar(10),e.inco_vgnca,111)       and	convert(varchar(10),e.fn_vgnca,111) 
And	e.estdo_rgstro			=	'S'
And	d. Activo 			=	 1


--Se valida si existe el beneficiario dos veces para facturarlo porque puede tener dos vigencias cuotas activa
insert Into  	  #tmpBeneficiariosDobles
Select   	  Nmro_Unco_Idntfccn_Bnfcro  , count(Nmro_Unco_Idntfccn_Bnfcro) cantidad
From 	  #tmpBeneficiarios
Group by Nmro_Unco_Idntfccn_Bnfcro
Having   count(Nmro_Unco_Idntfccn_Bnfcro)> 1


-- se busca el consecutivo siguiente de la tabla
Select	@lnMaximo_cnsctvo_csa_bnfcro_lqdcn	=	isnull(max(cnsctvo_csa_bnfcro_lqdcn),0)
From	bdcarteraPac.dbo.tbCausasBeneficiariosxLiquidacion

--Se crea una tabla temporal con los beneficiarios duplicados para mandarlos al log
insert into	#tmpCausaNuiDobleANivelBeneficiario
Select	b.nmro_cntrto , 	
	b.cnsctvo_cdgo_tpo_cntrto ,
	b.cnsctvo_bnfcro,	
	a.nmro_unco_idntfccn_bnfcro,
	b.nmro_unco_idntfccn_aprtnte,
	b.cnsctvo_scrsl_ctznte,
	b.cnsctvo_cdgo_clse_aprtnte
From	#tmpBeneficiariosDobles a inner join   #tmpBeneficiarios b
	on (a.Nmro_Unco_Idntfccn_Bnfcro	=	b.Nmro_Unco_Idntfccn_Bnfcro)


--Se insertan los beneficiarios que tiene  dos vigencias cuotas activas
--con causa beneficiario doble
Insert	bdcarteraPac.dbo.tbCausasBeneficiariosxLiquidacion
Select	ID_Num	+ @lnMaximo_cnsctvo_csa_bnfcro_lqdcn,
	nmro_unco_idntfccn_bnfcro,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	nmro_unco_idntfccn_aprtnte,
	cnsctvo_scrsl_ctznte,
	cnsctvo_cdgo_clse_aprtnte,
	cnsctvo_bnfcro,
	3,
	@cnsctvo_cdgo_lqdcn,
	NULL
From	#tmpCausaNuiDobleANivelBeneficiario


Drop Table 	#tmpCausaNuiDobleANivelBeneficiario



Insert		#TmpContratosLogResultados
Select 		b.Cnsctvo_cdgo_tpo_cntrto,		b.Nmro_cntrto,		'BENEFICIARIO DUPLICADO',
		b.nmro_unco_idntfccn_aprtnte,		b.cnsctvo_scrsl_ctznte,			b.cnsctvo_cdgo_clse_aprtnte
From		#tmpBeneficiariosDobles a inner join  #tmpBeneficiarios b
		on (a.Nmro_Unco_Idntfccn_Bnfcro	=	b.Nmro_Unco_Idntfccn_Bnfcro)
Group by	 b.Cnsctvo_cdgo_tpo_cntrto,		b.Nmro_cntrto,	
		b.nmro_unco_idntfccn_aprtnte,		b.cnsctvo_scrsl_ctznte,			b.cnsctvo_cdgo_clse_aprtnte


Insert into 	#tmpContratosNuiDobles
Select 		b.Cnsctvo_cdgo_tpo_cntrto,		b.Nmro_cntrto
From		#tmpBeneficiariosDobles a inner join  #tmpBeneficiarios b
		on (a.Nmro_Unco_Idntfccn_Bnfcro	=	b.Nmro_Unco_Idntfccn_Bnfcro)
Group by	 b.Cnsctvo_cdgo_tpo_cntrto,		b.Nmro_cntrto


--Se borra la informacion de los beneficiario que no se van a facturar y todos los bene de ese contrato
--Delete 	from	#tmpBeneficiarios
--From	#tmpContratosNuiDobles a inner join #tmpBeneficiarios b
--	on (a.Cnsctvo_cdgo_tpo_cntrto	=	b.Cnsctvo_cdgo_tpo_cntrto
--	And		a.Nmro_cntrto	=	b.Nmro_cntrto)


Drop table #tmpContratosNuiDobles


Update		#tmpBeneficiarios
Set		nmro_mss	=	cnsctvo_cdgo_prdcdd_prpgo
Where 		cnsctvo_cdgo_prdcdd_prpgo in (1,2,3,4)


update	#tmpBeneficiarios
Set	nmro_mss	=	6
where 	cnsctvo_cdgo_prdcdd_prpgo in (5)


update	#tmpBeneficiarios
Set	nmro_mss	=	12
where 	cnsctvo_cdgo_prdcdd_prpgo in (6)


--actualiza los contratos que tienen beneficiarios
Update #Tmpcontratos
Set	Activo	=	1
From	#Tmpcontratos a inner join  #tmpBeneficiarios b
	on (    a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
	And	a.nmro_cntrto			=	b.nmro_cntrto)


--se quitan todos los contratos que no estan en la tabla tbdetbeneficiariosadicionales puesto que no encontraria valor a nivel de beneficiario
Delete from	#Tmpcontratos	where 	Activo	=	0


insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Crea tabla temporal con los beneficiarios para Inicial Proceso de tarifas',Getdate())


--Se crea una tabla temporal con las personas que va tarificar

insert into	#RegistrosClasificarFinal
select nmro_unco_idntfccn_bnfcro  nmro_unco_idntfccn,
   	    0	edd_bnfcro,
	    cnsctvo_cdgo_pln,
	   'N'	ps_ss,
	    convert(datetime,null) fcha_aflcn_pc	,
	0        cnsctvo_cdgo_prntsco,
	0	 cnsctvo_cdgo_tpo_afldo,
	'N'    	 Dscpctdo,
	'N'	 Estdnte,
	'N'	 Antgdd_hcu,
	'N'	 Atrzdo_sn_Ps,
	'N'	 grpo_bsco,
	cnsctvo_cdgo_tpo_cntrto,	
	nmro_cntrto,
	cnsctvo_bnfcro,
	cnsctvo_cbrnza,
	0	grupo,
	0	cnsctvo_prdcto,
	0     	  cnsctvo_mdlo,
	0	vlr_upc,
	0	vlr_rl_pgo,
	0	cnsctvo_cdgo_tps_cbro,
	0	Cobranza_Con_producto,
	0	Beneficiario_Con_producto,
	0	Con_Modelo,
	2	grupo_tarificacion,
	0	igual_plan,
	0	grupo_modelo,
	nmro_unco_idntfccn_aprtnte,
	cnsctvo_scrsl_ctznte, 
	cnsctvo_cdgo_clse_aprtnte,
	convert(datetime,null) 	inco_vgnca_cntrto,
	'N'			bnfcdo_pc,
    'N'			Tne_hjos_cnyge_cmpnra,
  'N'			cntrtnte_ps_ss,
		  'N'			grpo_bsco_cn_ps,
				  'N'			cntrtnte_tn_pc,
		  'N'			antgdd_clptra
From	#tmpBeneficiarios


insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Iinicia proceso spTarificaLiquidacionPrevia',Getdate())

exec	bdcarteraPac.dbo.spTarificaLiquidacionPrevia	@ldFechaSistema,	@cnsctvo_cdgo_lqdcn , @lcControlaError output

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Finaliza el  proceso  spTarificaLiquidacionPrevia',Getdate())



If  @lcControlaError!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error procesando el spTarificaLiquidacionPrevia ' 
		Return -1

	end	


insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Iinicia actualizacion datos 1  [SpLiquidacionPrevia]',Getdate())

--Se actualiza el valor igual a cero para aquellos registros donde no es el mismo plan 
Update #RegistrosClasificarFinal
Set	vlr_upc			=	0,
	vlr_rl_pgo		=	0
Where	igual_plan	 	=	0
And	grupo_modelo		=	1

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Finaliza actualizacion datos 1  [SpLiquidacionPrevia]',Getdate())


insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Iinicia actualizacion datos 2  [SpLiquidacionPrevia]',Getdate())

---se inserta la informacion de los beneficiarios al log del proceso  

-- se busca el consecutivo siguiente de la tabla
Select	@lnMaximo_cnsctvo_csa_bnfcro_lqdcn	=	isnull(max(cnsctvo_csa_bnfcro_lqdcn),0)
From	tbCausasBeneficiariosxLiquidacion

--Se crea una tabla temporal con los beneficiarios con porducto encontrado pero de diferente plan

Insert Into #tmpCausaModeloDiferentePlan
Select	nmro_cntrto , 	
	cnsctvo_cdgo_tpo_cntrto ,
	cnsctvo_bnfcro,	
	nmro_unco_idntfccn,
	nmro_unco_idntfccn_aprtnte,
	cnsctvo_scrsl_ctznte,
	cnsctvo_cdgo_clse_aprtnte
From	#RegistrosClasificarFinal
Where	igual_plan	 	=	0
And	grupo_modelo		=	1

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Finaliza actualizacion datos 2  [SpLiquidacionPrevia]',Getdate())


insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Iinicia actualizacion datos 3  [SpLiquidacionPrevia]',Getdate())

--Se insertan los beneficiarios que tiene  dos vigencias cuotas activas
--con causa beneficiario doble
Insert	bdcarterapac.dbo.tbCausasBeneficiariosxLiquidacion
Select	ID_Num	+ @lnMaximo_cnsctvo_csa_bnfcro_lqdcn,
	nmro_unco_idntfccn,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	nmro_unco_idntfccn_aprtnte,
	cnsctvo_scrsl_ctznte,
	cnsctvo_cdgo_clse_aprtnte,
	cnsctvo_bnfcro,
	4,
	@cnsctvo_cdgo_lqdcn,
	NULL
From	#tmpCausaModeloDiferentePlan


Drop Table 	#tmpCausaModeloDiferentePlan

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Finaliza actualizacion datos 4  [SpLiquidacionPrevia]',Getdate())



insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Iinicia actualizacion datos 5  [SpLiquidacionPrevia]',Getdate())

---se inserta la informacion de los beneficiarios al log del proceso  beneficiario sin producto

-- se busca el consecutivo siguiente de la tabla
Select	@lnMaximo_cnsctvo_csa_bnfcro_lqdcn	=	isnull(max(cnsctvo_csa_bnfcro_lqdcn),0)
From	tbCausasBeneficiariosxLiquidacion

Insert  Into	#tmpCausaBeneficiarioSinPorducto
Select	nmro_cntrto, 	
	cnsctvo_cdgo_tpo_cntrto,
	cnsctvo_bnfcro,	
	nmro_unco_idntfccn,
	nmro_unco_idntfccn_aprtnte,
	cnsctvo_scrsl_ctznte,
	cnsctvo_cdgo_clse_aprtnte
From	#RegistrosClasificarFinal
Where	Beneficiario_Con_producto =	0

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Finaliza actualizacion datos 5  [SpLiquidacionPrevia]',Getdate())


insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Iinicia actualizacion datos 6  [SpLiquidacionPrevia]',Getdate())

--Se insertan los beneficiarios que tiene  dos vigencias cuotas activas
--con causa beneficiario doble
Insert	bdcarteraPac.dbo.tbCausasBeneficiariosxLiquidacion
Select	ID_Num	+ @lnMaximo_cnsctvo_csa_bnfcro_lqdcn,
	nmro_unco_idntfccn,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	nmro_unco_idntfccn_aprtnte,
	cnsctvo_scrsl_ctznte,
	cnsctvo_cdgo_clse_aprtnte,
	cnsctvo_bnfcro,
	5,
	@cnsctvo_cdgo_lqdcn,
	NULL
From	#tmpCausaBeneficiarioSinPorducto


Drop Table 	#tmpCausaBeneficiarioSinPorducto

--Fin de causa beneficiario sin producto

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Fin actualizacion datos 6  [SpLiquidacionPrevia]',Getdate())


insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Iinicia actualizacion datos 7  [SpLiquidacionPrevia]',Getdate())

---se inserta la informacion de los beneficiarios al log del proceso  beneficiario con producto sin modelo

-- se busca el consecutivo siguiente de la tabla
Select	@lnMaximo_cnsctvo_csa_bnfcro_lqdcn	=	isnull(max(cnsctvo_csa_bnfcro_lqdcn),0)
From	tbCausasBeneficiariosxLiquidacion

insert Into	#tmpCausaBeneficiarioConPorductoSinModelo
Select	nmro_cntrto , 	
	cnsctvo_cdgo_tpo_cntrto ,
	cnsctvo_bnfcro,	
	nmro_unco_idntfccn,
	nmro_unco_idntfccn_aprtnte,
	cnsctvo_scrsl_ctznte,
	cnsctvo_cdgo_clse_aprtnte
From	#RegistrosClasificarFinal
Where	Beneficiario_Con_producto =	1
And	Con_Modelo		   =	0


--Se insertan los beneficiarios que tiene  dos vigencias cuotas activas
--con causa beneficiario doble
Insert	bdcarteraPac.dbo.tbCausasBeneficiariosxLiquidacion
Select	ID_Num	+ @lnMaximo_cnsctvo_csa_bnfcro_lqdcn,
	nmro_unco_idntfccn,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	nmro_unco_idntfccn_aprtnte,
	cnsctvo_scrsl_ctznte,
	cnsctvo_cdgo_clse_aprtnte,
	cnsctvo_bnfcro,
	6,
	@cnsctvo_cdgo_lqdcn,
	NULL
From	#tmpCausaBeneficiarioConPorductoSinModelo


Drop Table 	#tmpCausaBeneficiarioConPorductoSinModelo

--Fin de causa beneficiario con producto  sin modelo

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Fin actualizacion datos 7  [SpLiquidacionPrevia]',Getdate())


insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Inicializa actualizacion datos 8  [SpLiquidacionPrevia]',Getdate())

--Causa igual plan y el grupo con el modelo es cero
-- se busca el consecutivo siguiente de la tabla
Select	@lnMaximo_cnsctvo_csa_bnfcro_lqdcn	=	isnull(max(cnsctvo_csa_bnfcro_lqdcn),0)
From	tbCausasBeneficiariosxLiquidacion

--Se crea una tabla temporal con los beneficiarios con porducto encontrado pero de diferente plan
Insert into	#tmpCausaIgualPlanGrupomodeloCero
Select	nmro_cntrto , 	
	cnsctvo_cdgo_tpo_cntrto ,
	cnsctvo_bnfcro,	
	nmro_unco_idntfccn,
	nmro_unco_idntfccn_aprtnte,
	cnsctvo_scrsl_ctznte,
	cnsctvo_cdgo_clse_aprtnte
From	#RegistrosClasificarFinal
Where	igual_plan	 	=	1
And	grupo_modelo		=	0
and nmro_unco_idntfccn_aprtnte not in ( select nmro_unco_idntfccn_empldr 
										from bdplanbeneficios.dbo.tbSucursalAportanteXGrupo_vigencias  
										where cnsctvo_cdgo_grpo = 15
										And	getdate() between inco_vgnca and fn_vgnca
									  )
-- bdplanbeneficios.dbo.sp_help tbSucursalAportanteXGrupo_vigencias  
--Se insertan los beneficiarios que tiene  dos vigencias cuotas activas
--con causa beneficiario doble
Insert	bdcarteraPac.dbo.tbCausasBeneficiariosxLiquidacion
Select	ID_Num	+ @lnMaximo_cnsctvo_csa_bnfcro_lqdcn,
	nmro_unco_idntfccn,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	nmro_unco_idntfccn_aprtnte,
	cnsctvo_scrsl_ctznte,
	cnsctvo_cdgo_clse_aprtnte,
	cnsctvo_bnfcro,
	7,
	@cnsctvo_cdgo_lqdcn,
	NULL
From	#tmpCausaIgualPlanGrupomodeloCero
where nmro_unco_idntfccn_aprtnte not in (select nmro_unco_idntfccn_empldr 
										 from	bdplanbeneficios.dbo.tbSucursalAportanteXGrupo_Vigencias  
										 where	cnsctvo_cdgo_grpo = 15
										 And	getdate() between inco_vgnca and fn_vgnca	
										)


Drop Table 	#tmpCausaIgualPlanGrupomodeloCero

--Fin  igual plan pero con grupo modelo cero

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Fin actualizacion datos 8  [SpLiquidacionPrevia]',Getdate())


insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Inicia actualizacion datos 9  [SpLiquidacionPrevia]',Getdate())

Update	#tmpBeneficiarios
Set	vlr_upc_nuevo	 	= 	b.vlr_upc,
	vlr_rl_pgo_nuevo	=	b.vlr_rl_pgo,
	Cambio_Valor_cuota	=	case      when	    (isnull(a.vlr_rl_pgo,0)  <> isnull(b.vlr_rl_pgo,0) or isnull(a.vlr_upc,0)<>isnull(b.vlr_upc,0))   then  1 else 0 end,
	Bnfcro_Dfrnte_cro	=	case	when	(b.vlr_rl_pgo	>	0  ) 	then	1 else  0   end
From	#tmpBeneficiarios a inner join	#RegistrosClasificarFinal b
	on (a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn
	and	a.nmro_cntrto			=	b.nmro_cntrto)


--para los cotizantes de sos que no pagan ningun valor no deben ir en el log
Update	#tmpBeneficiarios
Set	Bnfcro_Dfrnte_cro	=	1
From	#tmpBeneficiarios a ,	#RegistrosClasificarFinal b
Where	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn
And	a.Bnfcro_Dfrnte_cro		=	0
And	b.cnsctvo_cdgo_prntsco		=	1		--Cotizante
And	b.grupo_tarificacion		=	9
And	b.grupo				<>	0
And	(b.cnsctvo_cdgo_pln		=	2 or b.cnsctvo_cdgo_pln	 = 6)
And	b.igual_plan			=	1

Insert into	#tmpBeneficiarioValorCero
Select	nmro_unco_idntfccn_aprtnte,  cnsctvo_scrsl_ctznte, cnsctvo_cdgo_clse_aprtnte , cnsctvo_cdgo_tpo_cntrto, nmro_cntrto
From	#tmpBeneficiarios
Where	Bnfcro_Dfrnte_cro	=	0
Group by nmro_unco_idntfccn_aprtnte,  cnsctvo_scrsl_ctznte, cnsctvo_cdgo_clse_aprtnte , cnsctvo_cdgo_tpo_cntrto, nmro_cntrto


--Se actualiza aquellos registros que tienen al menos un beneficiario en cero  porque le sistema que tarifica obligatoriamente debe tener un valor

Update #Tmpcontratos
Set	Cntrto_igual_cro		=	1
From	#Tmpcontratos a inner join #tmpBeneficiarioValorCero b
	on     (a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
	And	a.nmro_cntrto			=	b.nmro_cntrto
	And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
	And	a.cnsctvo_scrsl_ctznte		=	b.cnsctvo_scrsl_ctznte
	And	a.nmro_unco_idntfccn_aprtnte	=	b.nmro_unco_idntfccn_aprtnte)


Update	#tmpBeneficiarios
Set	Bnfcro_Dfrnte_cro	=	0
From	#tmpBeneficiarios a inner join  #tmpBeneficiarioValorCero b
	on (a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
	And	a.nmro_cntrto			=	b.nmro_cntrto
	And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
	And	a.cnsctvo_scrsl_ctznte		=	b.cnsctvo_scrsl_ctznte
	And	a.nmro_unco_idntfccn_aprtnte	=	b.nmro_unco_idntfccn_aprtnte)


insert	into	#TmpContratosLogResultados
Select  	a.cnsctvo_cdgo_tpo_cntrto,	a.nmro_cntrto,	'BENEFICIARIO   IGUAL  A  CERO',
	a.nmro_unco_idntfccn_aprtnte , 	a.cnsctvo_scrsl_ctznte , 	a.cnsctvo_cdgo_clse_aprtnte
From 	#Tmpcontratos	 a
Where 	Cntrto_igual_cro			=	1


Delete From	#Tmpcontratos		Where	Cntrto_igual_cro		=	1
Delete	From	#tmpBeneficiarios	Where	Bnfcro_Dfrnte_cro	=	0


insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Fin actualizacion datos 9  [SpLiquidacionPrevia]',Getdate())
	

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Inicia actualizacion datos 10  [SpLiquidacionPrevia]',Getdate())

-- se traen todos los responsables del pago que s eles va crear factura

	select nmro_unco_idntfccn_empldr
	into #tmpResponsablesPorPlan
	from bdAfiliacion.dbo.tbClasificacionxSucursalesAportante 
	where cnsctvo_cdgo_mrca_espcl=24
	and estdo_mrca = 'S'
	and @ldFechaSistema between inco_vgnca_mrca and fn_vgnca_mrca
    group by nmro_unco_idntfccn_empldr


Insert Into	 #tmpResponsablesPago
Select   nmro_unco_idntfccn_aprtnte,
	 cnsctvo_scrsl_ctznte,
	 cnsctvo_cdgo_clse_aprtnte,
 	 cnsctvo_cdgo_prdcdd_prpgo,
	 Grupo_Conceptos,   
	 sldo_antrr,
	 Cts_sn_cnclar,
		cnsctvo_cdgo_pln
From	(select	 nmro_unco_idntfccn_aprtnte,
	 cnsctvo_scrsl_ctznte,
	 cnsctvo_cdgo_clse_aprtnte,
 	 cnsctvo_cdgo_prdcdd_prpgo,
	 1 as  Grupo_Conceptos,   
	 0	sldo_antrr,
	 0	Cts_sn_cnclar,
		0 cnsctvo_cdgo_pln
	From 	#Tmpcontratos
	where nmro_unco_idntfccn_aprtnte not in (select nmro_unco_idntfccn_empldr  from #tmpResponsablesPorPlan )
	Group by nmro_unco_idntfccn_aprtnte,	cnsctvo_scrsl_ctznte,	cnsctvo_cdgo_clse_aprtnte,	cnsctvo_cdgo_prdcdd_prpgo ) tmpResp

---INSERTA LOS QUE SE VA A GRABAR FACTURA POR PLAN COMPLEMENTARIO

Insert Into	 #tmpResponsablesPago
Select   nmro_unco_idntfccn_aprtnte,
	 cnsctvo_scrsl_ctznte,
	 cnsctvo_cdgo_clse_aprtnte,
 	 cnsctvo_cdgo_prdcdd_prpgo,
	 Grupo_Conceptos,   
	 sldo_antrr,
	 Cts_sn_cnclar,
		cnsctvo_cdgo_pln
From	(select	 nmro_unco_idntfccn_aprtnte,
	 cnsctvo_scrsl_ctznte,
	 cnsctvo_cdgo_clse_aprtnte,
 	 cnsctvo_cdgo_prdcdd_prpgo,
	 1 as  Grupo_Conceptos,   
	 0	sldo_antrr,
	 0	Cts_sn_cnclar,
	 cnsctvo_cdgo_pln
	From 	#Tmpcontratos
	where nmro_unco_idntfccn_aprtnte  in (select nmro_unco_idntfccn_empldr  from #tmpResponsablesPorPlan )
	Group by nmro_unco_idntfccn_aprtnte,	cnsctvo_scrsl_ctznte,	cnsctvo_cdgo_clse_aprtnte,	cnsctvo_cdgo_prdcdd_prpgo , cnsctvo_cdgo_pln ) tmpResp



insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Fin actualizacion datos 10  [SpLiquidacionPrevia]',Getdate())

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Inicia actualizacion datos 11  [SpLiquidacionPrevia]',Getdate())

Insert	into	 #tmpValorRealSaldo
Select    a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte,
	 a.nmro_estdo_cnta,
	 sum(c.sldo) vlr_sldo_antrr,
		0 	cnsctvo_cdgo_pln 
From       bdcarteraPac.dbo.TbEstadosCuenta a inner join bdcarterapac.dbo.tbliquidaciones b
	  on (a.cnsctvo_cdgo_lqdcn		=	b.cnsctvo_cdgo_lqdcn)
	 	  inner join tbEstadosCuentaContratos c
	  on (a.cnsctvo_estdo_cnta		=	c.cnsctvo_estdo_cnta)
Where    c.sldo	 > 0
And	 b.cnsctvo_cdgo_estdo_lqdcn	=	3
and a.nmro_unco_idntfccn_empldr not in (select nmro_unco_idntfccn_empldr  from #tmpResponsablesPorPlan )
Group by a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte,
	 a.nmro_estdo_cnta
		
				
Insert	into	 #tmpValorRealSaldo
Select    a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte,
	 a.nmro_estdo_cnta,
	 sum(c.sldo) vlr_sldo_antrr,
	ct.cnsctvo_cdgo_pln 
From       bdcarteraPac.dbo.TbEstadosCuenta a inner join bdcarterapac.dbo.tbliquidaciones b
	  on (a.cnsctvo_cdgo_lqdcn		=	b.cnsctvo_cdgo_lqdcn)
	 	  inner join tbEstadosCuentaContratos c
	  on (a.cnsctvo_estdo_cnta		=	c.cnsctvo_estdo_cnta)
			inner join bdafiliacion.dbo.tbContratos ct
			on c.cnsctvo_cdgo_tpo_cntrto = ct.cnsctvo_cdgo_tpo_cntrto
			and c.nmro_cntrto = ct.nmro_cntrto
Where    c.sldo	 > 0
And	 b.cnsctvo_cdgo_estdo_lqdcn	=	3
and a.nmro_unco_idntfccn_empldr  in (select nmro_unco_idntfccn_empldr  from #tmpResponsablesPorPlan )
Group by a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte,
	 a.nmro_estdo_cnta, ct.cnsctvo_cdgo_pln
		
		
Update	#tmpResponsablesPago
Set	sldo_antrr	=	tmpsaldoAnterior.vlr_sldo_antrr,
	Cts_sn_cnclar	=	tmpsaldoAnterior.ctas
From	#tmpResponsablesPago a inner join  	(Select   b.nmro_unco_idntfccn_empldr, b.cnsctvo_scrsl, b.cnsctvo_cdgo_clse_aprtnte,
						 count(b.nmro_estdo_cnta) ctas,
						 sum(b.vlr_sldo_antrr) vlr_sldo_antrr,
							b.cnsctvo_cdgo_pln
						 From     #tmpValorRealSaldo b
						Group by b.nmro_unco_idntfccn_empldr, b.cnsctvo_scrsl, b.cnsctvo_cdgo_clse_aprtnte, b.cnsctvo_cdgo_pln	) tmpsaldoAnterior
	On (a.nmro_unco_idntfccn_aprtnte	=	tmpsaldoAnterior.nmro_unco_idntfccn_empldr
	And	a.cnsctvo_scrsl_ctznte		=	tmpsaldoAnterior.cnsctvo_scrsl
	And	a.cnsctvo_cdgo_clse_aprtnte	=	tmpsaldoAnterior.cnsctvo_cdgo_clse_aprtnte
	And a.cnsctvo_cdgo_pln = tmpsaldoAnterior.cnsctvo_cdgo_pln)

	 
--Fin enero 28 del 2004

Update	#tmpResponsablesPago
Set	sldo_antrr	=	(sldo_antrr + Saldo_nta)
From	#tmpResponsablesPago a , (select  a.nmro_unco_idntfccn_empldr , a.cnsctvo_scrsl , a.cnsctvo_cdgo_clse_aprtnte,
				  sum(a.sldo_nta) Saldo_nta,
						0 cnsctvo_cdgo_pln
				  from 	bdcarteraPac.dbo.tbNotasPac a
				  where a.cnsctvo_cdgo_tpo_nta = 1
				  And	a.sldo_nta > 0
				  And	a.cnsctvo_cdgo_estdo_nta in  (1,2) 
						and a.nmro_unco_idntfccn_empldr not in  (select nmro_unco_idntfccn_empldr  from #tmpResponsablesPorPlan )
				  Group by a.nmro_unco_idntfccn_empldr , a.cnsctvo_scrsl , a.cnsctvo_cdgo_clse_aprtnte
				  ) tmpSaldoAnteriorNotasD
where   a.nmro_unco_idntfccn_aprtnte	=	tmpSaldoAnteriorNotasD.nmro_unco_idntfccn_empldr
And	a.cnsctvo_scrsl_ctznte	   	=	tmpSaldoAnteriorNotasD.cnsctvo_scrsl
And	a.cnsctvo_cdgo_clse_aprtnte 	=	tmpSaldoAnteriorNotasD.cnsctvo_cdgo_clse_aprtnte

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Fin actualizacion datos 11  [SpLiquidacionPrevia]',Getdate())

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Inicia actualizacion datos 12  [SpLiquidacionPrevia]',Getdate())

Update	#tmpResponsablesPago
Set	sldo_antrr	=	(sldo_antrr + Saldo_nta)
From	#tmpResponsablesPago a , (select  a.nmro_unco_idntfccn_empldr , a.cnsctvo_scrsl , a.cnsctvo_cdgo_clse_aprtnte,
				  sum(nc.sldo_nta_cntrto) Saldo_nta,
						ct.cnsctvo_cdgo_pln
				  from 	bdcarteraPac.dbo.tbNotasPac a
						inner join bdcarterapac.dbo.tbNotasContrato nc
						on a.nmro_nta = nc.nmro_nta
						and a.cnsctvo_cdgo_tpo_nta = nc.cnsctvo_cdgo_tpo_nta
						inner join bdafiliacion.dbo.tbContratos ct
						on nc.nmro_cntrto = ct.nmro_cntrto
						and nc.cnsctvo_cdgo_tpo_cntrto = ct.cnsctvo_cdgo_tpo_cntrto
						where a.cnsctvo_cdgo_tpo_nta = 1
				  And	nc.sldo_nta_cntrto > 0
				  And	a.cnsctvo_cdgo_estdo_nta in  (1,2) 
						and a.nmro_unco_idntfccn_empldr  in  (select nmro_unco_idntfccn_empldr  from #tmpResponsablesPorPlan )
				  Group by a.nmro_unco_idntfccn_empldr , a.cnsctvo_scrsl , a.cnsctvo_cdgo_clse_aprtnte, ct.cnsctvo_cdgo_pln
				  ) tmpSaldoAnteriorNotasD
where   a.nmro_unco_idntfccn_aprtnte	=	tmpSaldoAnteriorNotasD.nmro_unco_idntfccn_empldr
And	a.cnsctvo_scrsl_ctznte	   	=	tmpSaldoAnteriorNotasD.cnsctvo_scrsl
And	a.cnsctvo_cdgo_clse_aprtnte 	=	tmpSaldoAnteriorNotasD.cnsctvo_cdgo_clse_aprtnte
And a.cnsctvo_cdgo_pln = tmpSaldoAnteriorNotasD.cnsctvo_cdgo_pln

--Fin Septiembre  21 del 2005
Update	#tmpResponsablesPago
Set		sldo_antrr	=	0
where	@periodoActual = 0

-- se actualiza al responsable del grupo en la cual le pertenece
Update  #tmpResponsablesPago
Set	Grupo_Conceptos	=	b.cnsctvo_cdgo_grpo_lqdcn
From	#tmpResponsablesPago a inner join bdcarteraPac.dbo.TbGrupoLiquidacionAportante b
	on 	(a.nmro_unco_idntfccn_aprtnte	= 	b.nmro_unco_idntfccn_empldr
	And	a.cnsctvo_scrsl_ctznte		=	b.cnsctvo_scrsl
	And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte)


-- se actualiza el grupo de cada beneficiario asociado al responsable
Update #Tmpcontratos
Set	Grupo_Conceptos = b.Grupo_Conceptos
From 	#Tmpcontratos   a inner join #tmpResponsablesPago b
	on 	(a.nmro_unco_idntfccn_aprtnte	= 	b.nmro_unco_idntfccn_aprtnte
	And	a.cnsctvo_scrsl_ctznte		=	b.cnsctvo_scrsl_ctznte 
	And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte)
	Where a.nmro_unco_idntfccn_aprtnte	 not in   (select nmro_unco_idntfccn_empldr  from #tmpResponsablesPorPlan )

Update #Tmpcontratos
Set	Grupo_Conceptos = b.Grupo_Conceptos
From 	#Tmpcontratos   a inner join #tmpResponsablesPago b
	on 	(a.nmro_unco_idntfccn_aprtnte	= 	b.nmro_unco_idntfccn_aprtnte
	And	a.cnsctvo_scrsl_ctznte		=	b.cnsctvo_scrsl_ctznte 
	And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
	And a.cnsctvo_Cdgo_pln = b.cnsctvo_Cdgo_pln)
	Where a.nmro_unco_idntfccn_aprtnte	  in   (select nmro_unco_idntfccn_empldr  from #tmpResponsablesPorPlan )


--se traen todos los conceptos y su grupo respectivo que se van a tener en cuanta para la liquidacion.
--y que sean de e facturacion, notas, impuestos o descuentos , intereses


insert into  #tmpConceptosLiquidacion
Select	   a.cdgo_cncpto_lqdcn,   a.dscrpcn_cncpto_lqdcn,	 	 a.cnsctvo_cdgo_cncpto_lqdcn,
	   a.cnsctvo_cdgo_pln,     a.cnsctvo_cdgo_tpo_mvmnto,	 a.oprcn  ,			 b.cnsctvo_cdgo_grpo_lqdcn, 	b.prcntje
From       bdcarteraPac.dbo.tbconceptosliquidacion_vigencias a inner join
 	   bdcarteraPac.dbo.TbGruposxConcepto_vigencias b 
	   on(a.cnsctvo_cdgo_cncpto_lqdcn	=	b.cnsctvo_cdgo_cncpto_lqdcn	)
Where      (convert(varchar(10), @ldFechaCorte,111)	  between convert(varchar(10),a.inco_vgnca,111)   And    Convert(varchar(10),a.fn_vgnca,111)   ) 
And          (a.vsble_usro			=	'S')
And	   a.cnsctvo_cdgo_bse_aplcda  	In	(1,2,3,4,5)  -- que sean de facturacion, notas, impuestos o descuentos , intereses
And	(  convert(varchar(10),@ldFechaCorte,111) 	between convert(Varchar(10),b.inco_vgnca,111)   And    Convert(varchar(10),b.fn_vgnca,111)   )


insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Fin actualizacion datos 12  [SpLiquidacionPrevia]',Getdate())

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Inicia actualizacion datos 13  [SpLiquidacionPrevia]',Getdate())


--Se actualiza el valor de la cuota cuando el mayor la periodicidad



-- se actualiza el valor de descuentos de pronto pago 
Update #tmpBeneficiarios
Set	vlr_otros_dcts		=	case	when cnsctvo_cdgo_prmtro_prgrmcn	=	5	Then	((vlr_upc_nuevo * nmro_mss)	*	vlr /100)  
					else	vlr	end,
	vlr_otros_dcts_aux	=	case	when cnsctvo_cdgo_prmtro_prgrmcn	=	5	Then	((vlr_upc_nuevo * nmro_mss)	*	vlr /100)  
					else	vlr	end
From	#tmpBeneficiarios a inner join  bdcarteraPac.dbo.tbdescuentos_vigencias  b
	on (a.cnsctvo_cdgo_prdcdd_prpgo		=	b.cnsctvo_cdgo_prdo)
Where	@ldFechasistema	 between	 b.inco_vgnca   and  b.fn_vgnca
And	b.espcl					=	'N'
And	a.cnsctvo_cdgo_prdcdd_prpgo		>	1


--Se verifica si tiene otros descuentos
Update #tmpBeneficiarios
Set	vlr_otros_dcts		=	vlr_otros_dcts		+	case when (cnsctvo_cdgo_prmtro_prgrmcn = 6)  then ( vlr) else ( ((vlr_upc_nuevo * nmro_mss) * vlr/100)) end,
	vlr_otros_dcts_aux	=	vlr_otros_dcts_aux	+	case when (cnsctvo_cdgo_prmtro_prgrmcn = 6)  then ( vlr) else ( ((vlr_upc_nuevo * nmro_mss) * vlr/100)) end
From	#tmpBeneficiarios c, 	bdcarterapac.dbo.tbResponsableXDescuento_Vigencias a, 	bdcarteraPac.dbo.tbdescuentos_vigencias b 
Where 	a.cnsctvo_cdgo_dscnto	=	b.cnsctvo_cdgo_dscnto
and	espcl			=	'S'
and	a.nmro_unco_idntfccn	=	c.nmro_unco_idntfccn_bnfcro
And	(convert(varchar(10),@ldFechaCorte,111) between convert(varchar(10),a.inco_vgnca,111) and 	convert(varchar(10),a.fn_vgnca,111))
And	(convert(varchar(10),@ldFechaCorte,111) between convert(varchar(10),b.inco_vgnca,111) and 	convert(varchar(10),b.fn_vgnca,111))





Update #tmpBeneficiarios
Set	vlr_otros_dcts_aux	=	 case when oprcn = 4 then  (vlr_otros_dcts_aux   * -1)  else    vlr_otros_dcts_aux  end
From	  #tmpBeneficiarios  a inner join  #tmpConceptosLiquidacion b
        on (b.cnsctvo_cdgo_grpo_lqdcn	=	a.Grupo_Conceptos)
Where	b.cnsctvo_cdgo_cncpto_lqdcn	=	6  --Es el consecutivo del  concepto de otros descuentos



-- si la operacion es restar entonces automaticamente  se multiplica por -1
--Con el fin totalizar el valor total pendiendo si suma o resta
update #tmpBeneficiarios
Set	vlr_iva		= 	(prcntje *  ((vlr_upc_nuevo * nmro_mss)  - vlr_dcto_comercial   -  vlr_otros_dcts))  /100,
	vlr_iva_aux	=	 case when oprcn = 4 then  (((prcntje *  ((vlr_upc_nuevo * nmro_mss)  - vlr_dcto_comercial   -  vlr_otros_dcts))  /100)   * -1)  else    (((prcntje *  ((vlr_upc_nuevo * nmro_mss)  - vlr_dcto_comercial   -  vlr_otros_dcts))  /100)   *  1)  end
From     #tmpBeneficiarios  a inner join  #tmpConceptosLiquidacion b
on 	(b.cnsctvo_cdgo_grpo_lqdcn	=	a.Grupo_Conceptos)
Where   b.cnsctvo_cdgo_cncpto_lqdcn	=	3  --Es el consecutivo del  concepto del  iva 


--Calcula el valor total para cada beneficiario 
Update #tmpBeneficiarios
Set	vlr_ttl_bnfcro 		= 	( (vlr_upc_nuevo * nmro_mss)	+	vlr_dcto_comercial_aux	 +	  vlr_otros_dcts_aux	 +	   vlr_iva_aux),

	vlr_ttl_bnfcro_sn_iva	=	 ((vlr_upc_nuevo * nmro_mss)	+	vlr_dcto_comercial_aux	 +	  vlr_otros_dcts_aux)


--Calcula el valor total de cada contrato
Update	#Tmpcontratos
Set	vlr_ttl_cntrto		= Sumatoria_Contrato,
	vlr_ttl_cntrto_sn_iva	= Sumatoria_Contrato_sin_iva
From	#Tmpcontratos a ,  (Select  nmro_unco_idntfccn_aprtnte,	 cnsctvo_scrsl_ctznte,	cnsctvo_cdgo_clse_aprtnte,
				  nmro_unco_idntfccn_afldo, cnsctvo_cdgo_tpo_cntrto, nmro_cntrto, sum(vlr_ttl_bnfcro) Sumatoria_Contrato, sum(vlr_ttl_bnfcro_sn_iva) Sumatoria_Contrato_sin_iva
			     From #tmpBeneficiarios
			    Group by nmro_unco_idntfccn_aprtnte,	 cnsctvo_scrsl_ctznte,	cnsctvo_cdgo_clse_aprtnte,
				    nmro_unco_idntfccn_afldo, cnsctvo_cdgo_tpo_cntrto, nmro_cntrto ) TmpsumatoriaBene
Where	a.nmro_unco_idntfccn_aprtnte	= TmpsumatoriaBene.nmro_unco_idntfccn_aprtnte
And	a. cnsctvo_scrsl_ctznte		= TmpsumatoriaBene.cnsctvo_scrsl_ctznte
And	a. cnsctvo_cdgo_clse_aprtnte	= TmpsumatoriaBene.cnsctvo_cdgo_clse_aprtnte
And	a.nmro_unco_idntfccn_afldo	= TmpsumatoriaBene.nmro_unco_idntfccn_afldo
And	a. cnsctvo_cdgo_tpo_cntrto	= TmpsumatoriaBene.cnsctvo_cdgo_tpo_cntrto
And	a. nmro_cntrto			= TmpsumatoriaBene.nmro_cntrto


insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Fin actualizacion datos 13  [SpLiquidacionPrevia]',Getdate())

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Inicia actualizacion datos 14  [SpLiquidacionPrevia]',Getdate())

-- se actualiza la catidad de beneficiarios para cada contrato
Update	#Tmpcontratos
Set	cntdd_ttl_bnfcrs	= cantidad_beneficiarios
From	#Tmpcontratos a ,  (select  nmro_unco_idntfccn_aprtnte,	 cnsctvo_scrsl_ctznte,	cnsctvo_cdgo_clse_aprtnte ,	nmro_unco_idntfccn_afldo,
				  cnsctvo_cdgo_tpo_cntrto,	 nmro_cntrto,
				 count(nmro_unco_idntfccn_bnfcro)  cantidad_beneficiarios
			    From #tmpBeneficiarios
			--    Where nmro_unco_idntfccn_afldo<>nmro_unco_idntfccn_bnfcro
			    Group by nmro_unco_idntfccn_aprtnte,cnsctvo_scrsl_ctznte,cnsctvo_cdgo_clse_aprtnte ,nmro_unco_idntfccn_afldo,
				      cnsctvo_cdgo_tpo_cntrto, nmro_cntrto ) TmpCantidadBene
Where	a.nmro_unco_idntfccn_aprtnte	= TmpCantidadBene.nmro_unco_idntfccn_aprtnte
And	a. cnsctvo_scrsl_ctznte		= TmpCantidadBene.cnsctvo_scrsl_ctznte
And	a. cnsctvo_cdgo_clse_aprtnte	= TmpCantidadBene.cnsctvo_cdgo_clse_aprtnte
And	a.nmro_unco_idntfccn_afldo	= TmpCantidadBene.nmro_unco_idntfccn_afldo
And	a. cnsctvo_cdgo_tpo_cntrto	= TmpCantidadBene.cnsctvo_cdgo_tpo_cntrto
And	a. nmro_cntrto			= TmpCantidadBene.nmro_cntrto






--Se crea una tabla temporal con la estructura final  de los conceptos asociados a cada beneficiario donde se guada  todos los valores
--que aplican a nivel contrato.

-- primero se inserta el valor de la cuota de cada beneficiario
-- 4 e el consecutivo del concepto valor de la cuota.
insert into #tmpBeneficiariosConceptos
Select  nmro_unco_idntfccn_aprtnte, 	cnsctvo_scrsl_ctznte, 		nmro_unco_idntfccn_afldo, 	cnsctvo_cdgo_tpo_cntrto,	 	nmro_cntrto, 
          cnsctvo_bnfcro, 			nmro_unco_idntfccn_bnfcro, 	 inco_vgnca_bnfcro, 		 fn_vgnca_bnfcro  ,   		(vlr_upc_nuevo * nmro_mss), 	 4  , 0
From  #tmpBeneficiarios
--Segundo se inserta el valor del descuento comercial de cada  beneficiario
-- 5 e el consecutivo del concepto del descuento comercial.
insert into #tmpBeneficiariosConceptos
Select  nmro_unco_idntfccn_aprtnte, 	cnsctvo_scrsl_ctznte, 		nmro_unco_idntfccn_afldo,	 cnsctvo_cdgo_tpo_cntrto, 	nmro_cntrto, 
          cnsctvo_bnfcro, 			nmro_unco_idntfccn_bnfcro,  	inco_vgnca_bnfcro, 		 fn_vgnca_bnfcro  ,   		vlr_dcto_comercial,  5 , 0
From  #tmpBeneficiarios

--Tercero se inserta el valor de otros descuentos de cada beneficiaerio
-- 6 e el consecutivo del concepto de otros descuentos.
insert into #tmpBeneficiariosConceptos
Select  nmro_unco_idntfccn_aprtnte, 	cnsctvo_scrsl_ctznte, 		nmro_unco_idntfccn_afldo,	 cnsctvo_cdgo_tpo_cntrto, 	nmro_cntrto, 
          cnsctvo_bnfcro, 			nmro_unco_idntfccn_bnfcro,  	inco_vgnca_bnfcro, 		 fn_vgnca_bnfcro  ,  		 vlr_otros_dcts, 	 6 , 0
From  #tmpBeneficiarios 


-- Cuarto se inserta el valor de l iva de cada beneficiario
-- 3  es  el consecutivo del valor del iva 
insert into #tmpBeneficiariosConceptos
Select  nmro_unco_idntfccn_aprtnte,	 cnsctvo_scrsl_ctznte, 		nmro_unco_idntfccn_afldo, 	cnsctvo_cdgo_tpo_cntrto,		 nmro_cntrto, 
            cnsctvo_bnfcro, 			 nmro_unco_idntfccn_bnfcro, 	 inco_vgnca_bnfcro,  		fn_vgnca_bnfcro  ,  		 vlr_iva,  	3  , 0
From  #tmpBeneficiarios 


---Inicia el proceso de actualizacion de datos


insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Fin actualizacion datos 14  [SpLiquidacionPrevia]',Getdate())

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Inicia actualizacion datos 15  [SpLiquidacionPrevia]',Getdate())



---Se aplica la novedad Cambio de tarifa 
Create table #tmpInformacionNovedad (	
	cnsctvo_cdgo_tpo_cntrto	udtConsecutivo,			nmro_cntrto			udtNumeroFormulario,						
	nmro_unco_idntfccn		udtConsecutivo,			cnsctvo_idntfcdr			udtConsecutivo,
	cnsctvo_cdgo_tpo_nvdd		udtConsecutivo,			cnsctvo_cdgo_csa_nvdd		udtConsecutivo,
	fcha_nvdd			Datetime,			adcnl				udtLogico,
	usro				udtUsuario,			cnsctvo_cdgo_tpo_cntrto_psc	udtConsecutivo,		
	nmro_cntrto_psc			udtNumeroFormulario,		cnsctvo_cdgo_estdo_cvl		udtConsecutivo,
	cnsctvo_cdgo_sb_csa_nvdd	udtConsecutivo,			estdo				udtLogico,
	cnsctvo_cdgo_cncpto_nvdd	udtConsecutivo,			cnsctvo_nvdd			udtNumeroFormulario,
	nmro_unco_idntfccn_ctznte	udtConsecutivo,			cnsctvo_cdgo_clse_aprtnte	udtConsecutivo,
	cnsctvo_plnlla			udtConsecutivo,			cnsctvo_lna			udtConsecutivo,				
	cnsctvo_dtlle_nvdd_gnrda	udtConsecutivo)




--Se crea una tabla temporal  de todos los contratos y su cobranzas de los beneficiarios que va cambiar la tarifa

Insert into	#tmpNuevasVigenciasCobranzas
Select		0	cnsctvo_vgnca_cbrnza,
		cnsctvo_cdgo_tpo_cntrto, 
		nmro_cntrto, 
		cnsctvo_cbrnza
From 		#tmpBeneficiarios
Where   	Cambio_Valor_cuota	=	1
group by 	cnsctvo_cdgo_tpo_cntrto, 
		nmro_cntrto, 
		cnsctvo_cbrnza

If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error Creando tabla temporal historico cambio de tarifa'
		Return -1
	end	



--Se crea una tabla temporal con toda la informacion de los beneficiarios que se les va a cambiar la 	tarifa
--para guardarlos en la tabla historica
insert into #tmpHistoricoTarifaxBeneficiario
Select 	 0	cnsctvo_vgnca_cbrnza,
	 nmro_unco_idntfccn_aprtnte, 
	cnsctvo_scrsl_ctznte, 
	cnsctvo_cdgo_clse_aprtnte , 
	nmro_unco_idntfccn_afldo,	
	cnsctvo_cdgo_tpo_cntrto, 
	nmro_cntrto, 
	cnsctvo_cbrnza,
	cnsctvo_bnfcro,
	nmro_unco_idntfccn_bnfcro, 
	inco_vgnca_bnfcro,
	fn_vgnca_bnfcro,	
	vlr_upc,
	vlr_rl_pgo,
	vlr_upc_nuevo ,
	vlr_rl_pgo_nuevo,
	@lcUsuario	usro_crcn
From 	#tmpBeneficiarios
Where   Cambio_Valor_cuota	=	1



If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error Creando tabla temporal historico cambio de tarifa'
		Return -1
	end	

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Fin actualizacion datos 15  [SpLiquidacionPrevia]',Getdate())

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Inicia actualizacion datos 16  [SpLiquidacionPrevia]',Getdate())


insert	into	#tmpInformacionNovedad
Select	cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,	nmro_unco_idntfccn_bnfcro,	cnsctvo_bnfcro,
	29,				35,	--29,	-- tipo novedad cambio de tarifa		35,	-- causa cambio tarifa
	@ldFechaSistema,			'N',		@lcUsuario,
	0,				0,		0,		0,	
	'A',				0,		0,		nmro_unco_idntfccn_bnfcro,
	0,				0,		0,		0
From	#tmpBeneficiarios
Where	Cambio_Valor_cuota		 =	1
And	inco_vgnca_cbrnza		<=	@ldFechaSistema
And	inco_vgnca			<=	@ldFechaSistema


--Se crea una tabla temporal con la informacion de las personas que van a cambiar  valor

insert into  #tmpDetBeneficiarioAdicionalAcotar
SELECT 	cnsctvo_dtlle_bnfcro_adcnl,
	dateadd(day,-1,@ldFechaCorte) fcha_nvdd
From	#tmpBeneficiarios
Where	Cambio_Valor_cuota		 =	1
And	inco_vgnca			<=	@ldFechaSistema



--se crea la tabla temporal con la vigencias que se van acotar
Insert into		#tmpVigenciasAcotarXCambioNovedad
Select		cnsctvo_vgnca_cbrnza, 
		cnsctvo_cdgo_tpo_cntrto,
		nmro_cntrto ,
		cnsctvo_cbrnza,	
		@ldFechaSistema	fcha_nvdd,
		'N'			adcnl,
		@lcUsuario 		usro,
		'A'	     		estdo,
		sum(vlr_upc_nuevo)	vlr_upc
From		#tmpBeneficiarios
Where		Cambio_Valor_cuota		=	1
And		inco_vgnca_cbrnza		<=	@ldFechaSistema
Group by 	cnsctvo_vgnca_cbrnza, 
		cnsctvo_cdgo_tpo_cntrto,
		nmro_cntrto ,
		cnsctvo_cbrnza	

---actualiza el valor upc de la vigencias cobranzas
Update #tmpVigenciasAcotarXCambioNovedad
Set	vlr_upc			=	valor_total_contrato
From	#tmpVigenciasAcotarXCambioNovedad a, (   Select    sum(vlr_upc_nuevo) valor_total_contrato,
							cnsctvo_vgnca_cbrnza, 
							cnsctvo_cdgo_tpo_cntrto,
							nmro_cntrto ,
							cnsctvo_cbrnza
						      From #tmpBeneficiarios
						      Group by		cnsctvo_vgnca_cbrnza, 
									cnsctvo_cdgo_tpo_cntrto,

									nmro_cntrto ,
									cnsctvo_cbrnza ) tmpValortotalXcobranza
Where	a.cnsctvo_vgnca_cbrnza		=	tmpValortotalXcobranza.cnsctvo_vgnca_cbrnza
And	a.cnsctvo_cdgo_tpo_cntrto		=	tmpValortotalXcobranza.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto				=	tmpValortotalXcobranza.nmro_cntrto
And	a.cnsctvo_cbrnza			=	tmpValortotalXcobranza.cnsctvo_cbrnza	





If ( @@Error != 0)
			Begin
				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje		=	'Error creando tabla temporal  #tmpVigenciasAcotarXCambioNovedad ' 
				Return -1
			End 

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Fin actualizacion datos 16  [SpLiquidacionPrevia]',Getdate())

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Inicia actualizacion datos 17  [SpLiquidacionPrevia]',Getdate())


--Se inicial la transaccion
Begin Tran 	
Insert Into	#tmpDetInformacionNovedad
Select	cnsctvo_cdgo_tpo_cntrto,		nmro_cntrto,	nmro_unco_idntfccn_bnfcro	nmro_unco_idntfccn,
	cnsctvo_bnfcro	cnsctvo_idntfcdr,	vlr_upc_nuevo	vlr_upc,		vlr_rl_pgo_nuevo	vlr_rl_pgo,
	cnsctvo_cbrnza,
	@ldFechaCorte	fcha_nvdd,
	'N'	adcnl,
	@lcUsuario 	usro,
	'A'	     estdo
From	#tmpBeneficiarios
Where	Cambio_Valor_cuota		=	1
And	inco_vgnca			<=	@ldFechaSistema
--And	inco_vgnca_cbrnza		<=	@ldFechaSistema


if @@rowcount	>	0
	Begin

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Inicia actualizacion datos 17  [SpLiquidacionPrevia]',Getdate())		

		if @lnTipoliquidacion           = 	 1 --Para que ejecuta la novedad solo en el caso que la  liquidacion sea definitiva
		begin
		Execute	@lnError	=	 bdafiliacion..spAdmonNovedadCambioTarifa 	'',2,	@lcUsuario,	@lnProceso Output

			If (@lnError != 0 or @@Error != 0)
			Begin
				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje		=	'Error ejecutando el  spAdmonNovedadCambioTarifa ' 
		Rollback tran 				
				Return -1
			End 
		End
insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Fin actualizacion datos 17  [SpLiquidacionPrevia]',Getdate())


	end

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Inicia actualizacion datos 18  [SpLiquidacionPrevia]',Getdate())

--se crea una tabla temporal con la informacion  con contratos mayor o igual a la fecha del corte
Insert Into #tmpActualiVigenciasMayorXCambioNovedad	
Select	cnsctvo_vgnca_cbrnza,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto ,
	cnsctvo_cbrnza,	
	0	vlr_upc
From	#tmpBeneficiarios
Where	Cambio_Valor_cuota		=	1
And	inco_vgnca_cbrnza		>	@ldFechaSistema
And	inco_vgnca			>	@ldFechaSistema
Group by cnsctvo_vgnca_cbrnza,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto ,
	cnsctvo_cbrnza


If ( @@Error != 0)
			Begin
				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje		=	'Error creando tabla temporal  #tmpActualiVigenciasMayorXCambioNovedad ' 

				Rollback tran 
				Return -1
			End 

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Fin actualizacion datos 18  [SpLiquidacionPrevia]',Getdate())

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Inicia actualizacion datos 19  [SpLiquidacionPrevia]',Getdate())
	
--actualiza el valor total de la cuota para la vigencia futura
Update #tmpActualiVigenciasMayorXCambioNovedad
Set	vlr_upc			=	valor_total_contrato
From	#tmpActualiVigenciasMayorXCambioNovedad a, (	Select   sum(vlr_upc_nuevo) valor_total_contrato,
								cnsctvo_vgnca_cbrnza, 
								cnsctvo_cdgo_tpo_cntrto,
								nmro_cntrto ,
								cnsctvo_cbrnza
					      		 From #tmpBeneficiarios
						       	 Group by  cnsctvo_vgnca_cbrnza, 
								  cnsctvo_cdgo_tpo_cntrto,
		 						  nmro_cntrto ,
								  cnsctvo_cbrnza )   tmpValortotalXcobranza
Where	a.cnsctvo_vgnca_cbrnza		=	tmpValortotalXcobranza.cnsctvo_vgnca_cbrnza
And	a.cnsctvo_cdgo_tpo_cntrto	=	tmpValortotalXcobranza.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	tmpValortotalXcobranza.nmro_cntrto
And	a.cnsctvo_cbrnza		=	tmpValortotalXcobranza.cnsctvo_cbrnza

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Fin actualizacion datos 19  [SpLiquidacionPrevia]',Getdate())

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Inicia actualizacion datos 20  [SpLiquidacionPrevia]',Getdate())

---Actualiza los registros que tiene una vigencia futura 
if @lnTipoliquidacion = 1 --Solo para procesos definitivos
   Begin 	
	Update 	bdafiliacion.dbo.tbVigenciasCobranzas
	Set	cta_mnsl				=	cta_mnsl_nvo,
		fcha_ultma_mdfccn			=	getdate()
	From	bdafiliacion.dbo.tbVigenciasCobranzas a, (Select	cnsctvo_vgnca_cbrnza,
							cnsctvo_cdgo_tpo_cntrto,
							nmro_cntrto ,
							cnsctvo_cbrnza,	
							sum(vlr_upc)  cta_mnsl_nvo
					       From	#tmpActualiVigenciasMayorXCambioNovedad
					       Group by 	cnsctvo_vgnca_cbrnza,
							cnsctvo_cdgo_tpo_cntrto,
							nmro_cntrto ,
							cnsctvo_cbrnza ) tmpMayorVigenciasCobranzas
	Where	a.cnsctvo_vgnca_cbrnza		=     tmpMayorVigenciasCobranzas.cnsctvo_vgnca_cbrnza	
	And	a.cnsctvo_cdgo_tpo_cntrto	=     tmpMayorVigenciasCobranzas.cnsctvo_cdgo_tpo_cntrto	
	And	a.nmro_cntrto			=     tmpMayorVigenciasCobranzas.nmro_cntrto	
	And	a.cnsctvo_cbrnza		=     tmpMayorVigenciasCobranzas.cnsctvo_cbrnza	

	If (@@Error != 0)
	Begin
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error Actualizando los datos en  tbVigenciasCobranzas ' 
		Rollback tran 
		Return -1
	End 
		

	update 	bdafiliacion..tbdetbeneficiarioAdicional
	Set	vlr_upc			=	vlr_upc_nuevo,		
	vlr_rl_pgo		=	vlr_rl_pgo_nuevo,
	fcha_ultma_mdfccn	=	Getdate()
	From	bdafiliacion.dbo.tbdetbeneficiarioAdicional a,   #tmpBeneficiarios  b
	Where	a.cnsctvo_dtlle_bnfcro_adcnl	=	b.cnsctvo_dtlle_bnfcro_adcnl
	And	Cambio_Valor_cuota		=	1
	And	b.inco_vgnca			>	@ldFechaSistema



	If (@@Error != 0)
	Begin
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error Actualizando los datos en  tbdetbeneficiarioAdicional ' 
		Rollback tran 
		Return -1
	End 
end

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Fin actualizacion datos 20  [SpLiquidacionPrevia]',Getdate())

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Inicia actualizacion datos 21  [SpLiquidacionPrevia]',Getdate())

--Actualiza la ultima vigencia cobrnzas
Update #tmpNuevasVigenciasCobranzas
Set	cnsctvo_vgnca_cbrnza	=	TmpVigenciasCobranzas.cnsctvo_vgnca_cbrnza
From	#tmpNuevasVigenciasCobranzas a, (Select	max(b.cnsctvo_vgnca_cbrnza) 	cnsctvo_vgnca_cbrnza, 
							b.cnsctvo_cdgo_tpo_cntrto, 
							b.nmro_cntrto, 
							b.cnsctvo_cbrnza
					      From 	#tmpNuevasVigenciasCobranzas a, bdafiliacion..tbvigenciasCobranzas b
					      where 	b.cnsctvo_cdgo_tpo_cntrto	=	a.cnsctvo_cdgo_tpo_cntrto
					       And	b.nmro_cntrto			=	a.nmro_cntrto 
					       And	b.cnsctvo_cbrnza		=	a.cnsctvo_cbrnza
					      Group by 	b.cnsctvo_cdgo_tpo_cntrto, b.nmro_cntrto, b.cnsctvo_cbrnza ) TmpVigenciasCobranzas
Where 	a.cnsctvo_cdgo_tpo_cntrto	=	TmpVigenciasCobranzas.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	TmpVigenciasCobranzas.nmro_cntrto 
And	a.cnsctvo_cbrnza		=	TmpVigenciasCobranzas.cnsctvo_cbrnza


If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error Actualizando maximo consecutivo vigencia cobranza'
		Rollback tran 
		Return -1
	end	

---Actualiza la ultima vigencia cobranza
Update #tmpHistoricoTarifaxBeneficiario
Set	cnsctvo_vgnca_cbrnza		=	b.cnsctvo_vgnca_cbrnza
From	#tmpHistoricoTarifaxBeneficiario a inner join  	#tmpNuevasVigenciasCobranzas b
	on 	(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
	And	a.nmro_cntrto			=	b.nmro_cntrto 
	And	a.cnsctvo_cbrnza		=	b.cnsctvo_cbrnza)

If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error Actualizando tabla temporal historico cambio de tarifa'
		Rollback tran 
		Return -1
	end	

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Fin actualizacion datos 21  [SpLiquidacionPrevia]',Getdate())

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Inicia actualizacion datos 22  [SpLiquidacionPrevia]',Getdate())

--Calcula el maximo consecutivo de la tabla
Select	@lnMaxcnsctvo_hstrco_trfa_bnfcro	=	isnull(max(cnsctvo_hstrco_trfa_bnfcro),0)
From	bdcarteraPac.dbo.TbHistoricoTarifaxBeneficiario


-- se inserta infromacion en la tabla final
Insert	into	bdcarterapac.dbo.TbHistoricoTarifaxBeneficiario
Select	(ID_Num + @lnMaxcnsctvo_hstrco_trfa_bnfcro),
	cnsctvo_vgnca_cbrnza,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	cnsctvo_cbrnza,
	cnsctvo_bnfcro,
	nmro_unco_idntfccn_bnfcro,
	nmro_unco_idntfccn_afldo,
	nmro_unco_idntfccn_aprtnte,
	cnsctvo_cdgo_clse_aprtnte,
	cnsctvo_scrsl_ctznte,
	@cnsctvo_cdgo_lqdcn,
	vlr_upc,
	vlr_upc_nuevo,
	vlr_rl_pgo,
	vlr_rl_pgo_nuevo,
	getdate(),
	usro_crcn,
	Null
From 	#tmpHistoricoTarifaxBeneficiario


If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error Guardando historico cambio de tarifa'
		Rollback tran 
		Return -1
	end	

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Fin actualizacion datos 22  [SpLiquidacionPrevia]',Getdate())

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Inicia actualizacion datos 23  [SpLiquidacionPrevia]',Getdate())

Execute	bdcarterapac.dbo.spCreaEstadosCuenta				  	@cnsctvo_cdgo_lqdcn	,@lcUsuario,	@lcControlaError output

If  @lcControlaError!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error creando los estados de cuenta  de la  liquidacion' 
		Rollback tran 
		Return -1
	end	

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Fin actualizacion datos 23  [SpLiquidacionPrevia]',Getdate())


insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Inicia actualizacion datos 24  [SpLiquidacionPrevia]',Getdate())

Execute bdcarterapac.dbo.spCreaContratosEstadosCuenta			  	@cnsctvo_cdgo_lqdcn	,@lcControlaError output

If  @lcControlaError!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error creando los contratos del estado  de cuenta  de la  liquidacion' 
		Rollback tran 
		Return -1
	end	


insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Fin actualizacion datos 24  [SpLiquidacionPrevia]',Getdate())

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Inicia actualizacion datos 25  [SpLiquidacionPrevia]',Getdate())


Execute bdcarterapac.dbo.spCreaBeneficiariosContratosEstadosCuenta	  	@cnsctvo_cdgo_lqdcn	,@lcControlaError output

If  @lcControlaError!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error creando los beneficiarios  del estado  de cuenta  de la  liquidacion' 
		Rollback tran 
		Return -1

	end	

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Fin actualizacion datos 25  [SpLiquidacionPrevia]',Getdate())

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Inicia actualizacion datos 26  [SpLiquidacionPrevia]',Getdate())

Execute bdcarterapac.dbo.spCreaConceptosBeneficiariosContratosEstadosCuenta	@cnsctvo_cdgo_lqdcn	,@lcControlaError output

If  @lcControlaError!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error creando los conceptos de los  beneficiarios  del estado  de cuenta  de la  liquidacion' 
		Rollback tran 
		Return -1

	end	

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Fin actualizacion datos 26  [SpLiquidacionPrevia]',Getdate())


insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Inicia actualizacion datos 27  [SpLiquidacionPrevia]',Getdate())

-- Se Crean Todos los conceptos de facturacion de cada plan de cada estado de cuenta
-- y  ya la tabla temporal 	#Tmpcontratos tiene asociado el consecutivo estado cuenta
insert Into 	#TmpConceptosEstadoCuenta
Select    a.cnsctvo_estdo_cnta, 	b.cnsctvo_cdgo_cncpto_lqdcn , 	count(*) Cantidad , 	sum(vlr_ttl_cntrto_sn_iva) valor_total_concepto
From    #Tmpcontratos a inner join  #tmpConceptosLiquidacion b
	on 	(a.cnsctvo_cdgo_pln		=	b.cnsctvo_cdgo_pln
	And	a.Grupo_Conceptos		=	b.cnsctvo_cdgo_grpo_lqdcn)
Where   cnsctvo_cdgo_tpo_mvmnto	=	 1		-- conceptos de facturacion
Group by a.cnsctvo_estdo_cnta, 		b.cnsctvo_cdgo_cncpto_lqdcn


Insert into #TmpConceptosEstadoCuenta
Select	 a.cnsctvo_estdo_cnta, 		b.cnsctvo_cdgo_cncpto_lqdcn , 	0 , 	sum(vlr_ttl_cntrto		-	vlr_ttl_cntrto_sn_iva) 	valor_total_iva
From   	 #Tmpcontratos a inner join		 #tmpConceptosLiquidacion b
	on (a.Grupo_Conceptos		=	b.cnsctvo_cdgo_grpo_lqdcn)
Where  	cnsctvo_cdgo_tpo_mvmnto	=	 5		-- Movimientos de  impuestos
And	b.cnsctvo_cdgo_cncpto_lqdcn	=	 3		-- Concecutivo del Conceptos de  iva
Group by a.cnsctvo_estdo_cnta, 		b.cnsctvo_cdgo_cncpto_lqdcn

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Fin actualizacion datos 28  [SpLiquidacionPrevia]',Getdate())


insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Inicia actualizacion datos 29  [SpLiquidacionPrevia]',Getdate())

--se crea los conceptos de notas debito
-- se crean los conceptos de los estados de cuenta
Execute	 BdcarteraPac.dbo.spCreaConceptosEstadosCuenta				@cnsctvo_cdgo_lqdcn,	@lcControlaError output

If  @lcControlaError!=0  
	Begin 

		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error creando los conceptos del estado  de cuenta  de la  liquidacion' 
		Rollback tran 
		Return -1
	end	

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Fin actualizacion datos 29  [SpLiquidacionPrevia]',Getdate())


insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Inicia actualizacion datos 30  [SpLiquidacionPrevia]',Getdate())


--Se actualiza el valor del encabezado del estado de cuenta
Execute	 bdcarteraPac.dbo.spActualizaEncabezadoEstadosCuenta			@cnsctvo_cdgo_lqdcn,	@lcControlaError output

If  @lcControlaError!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error actualizando el encabezado  del estado  de cuenta  de la  liquidacion' 
		Rollback tran 
		Return -1
	end	

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Fin actualizacion datos 30  [SpLiquidacionPrevia]',Getdate())

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Inicia actualizacion datos 31  [SpLiquidacionPrevia]',Getdate())



-- Se Captura la fecha final proceso
Set	@Fecha_Fin_Proceso	=	Getdate()
-- Se Actualiza el fin del proceso
Update bdcarteraPac.dbo.TbProcesosCarteraPac
Set	fcha_fn_prcso	=	@Fecha_Fin_Proceso
Where	cnsctvo_prcso	=	@Max_cnsctvo_prcso

If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error actualizando el  fin del proceso'
		Rollback tran 
		Return -1
	end



--- sa calcula el numero de facturas y el valor total cobrado
Select 	@NumeroEstadosCuenta	=	count(*),
	@Valortotalcobrado		=	isnull(sum(ttl_pgr),0)	
From 	bdcarteraPac.dbo.TbEstadosCuenta
Where 	cnsctvo_cdgo_lqdcn	=	@cnsctvo_cdgo_lqdcn


-- actualiza el numero de contratos
Select	@CantidadContratos	=	Count(cnsctvo_estdo_cnta_cntrto)
From	bdcarteraPac.dbo.TbEstadosCuentaContratos	a inner join	BdcarteraPac.dbo.TbEstadosCuenta	b
	on (a.cnsctvo_estdo_cnta	=	b.cnsctvo_estdo_cnta)
Where	b.cnsctvo_cdgo_lqdcn	=	@cnsctvo_cdgo_lqdcn



--Actualiza el estado de la  liquidacion y el valor total de contratos y el numero de estados de cuenta.
Update 	bdcarteraPac.dbo.Tbliquidaciones
Set	cnsctvo_cdgo_estdo_lqdcn=	case  when @lnTipoliquidacion = 2  then 5
					      when @lnTipoliquidacion = 1  then 2  
					end ,	
	nmro_estds_cnta			=		@NumeroEstadosCuenta,
	vlr_lqddo			=		@Valortotalcobrado,
	nmro_cntrts			=		@CantidadContratos,
	fcha_inco_prcso			=		@Fecha_Inicio_Proceso,
	fcha_fnl_prcso			=		@Fecha_Fin_Proceso
Where 	cnsctvo_cdgo_lqdcn		=		@cnsctvo_cdgo_lqdcn


if @lnTipoliquidacion =2
begin 
	Update 	bdcarteraPac.dbo.TbEstadoscuenta
	set     cnsctvo_cdgo_estdo_estdo_cnta	= 5
	where   cnsctvo_cdgo_lqdcn=@cnsctvo_cdgo_lqdcn
end

		
If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error Actualizando estado de la liquidacion'
		Rollback tran 
		Return -1
	end	

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Fin actualizacion datos 31  [SpLiquidacionPrevia]',Getdate())


insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Inicia actualizacion datos 32  [SpLiquidacionPrevia]',Getdate())


--Actualiza el  historico estado de la liquidacion
Select 	@MaximoEstadoHistoricoLiquidacion	=	isnull(max(cnsctvo_hstrco_estdo_lqdcn),0) + 1	
From	bdcarterapac.dbo.tbHistoricoEstadoLiquidacion

Insert into	bdcarteraPac.dbo.tbHistoricoEstadoLiquidacion
					(cnsctvo_hstrco_estdo_lqdcn,
					 cnsctvo_cdgo_estdo_lqdcn,
					 cnsctvo_cdgo_lqdcn,
				 	 nmro_estds_cnta,
					 vlr_lqddo,
					nmro_cntrts,
					 usro_crcn,
					 fcha_crcn)
				Values	(
					@MaximoEstadoHistoricoLiquidacion,
					case  when @lnTipoliquidacion = 1  then 2
					      when @lnTipoliquidacion = 2  then 5
					end,
					@cnsctvo_cdgo_lqdcn,
					@NumeroEstadosCuenta,
					@Valortotalcobrado,
					@CantidadContratos,
					@lcUsuario,
					@ldFechaSistema)

	
If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error Insertando el Historico de la liqudacion'
		Rollback tran 
		Return -1
	end	

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Fin actualizacion datos 32  [SpLiquidacionPrevia]',Getdate())

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Inicia actualizacion datos 33  [SpLiquidacionPrevia]',Getdate())


-- Se traer los contratos asociados al responsable que no se liquidaron con cuota igual acero

insert into #tmpResultadosLogFinal
Select  a.nmro_cntrto,	f.cdgo_tpo_idntfccn,	e.nmro_idntfccn,
	ltrim(rtrim(d.prmr_aplldo)) + ' ' + ltrim(rtrim(d.sgndo_aplldo)) + ' ' + ltrim(rtrim(d.prmr_nmbre)) + ' ' +ltrim(rtrim(sgndo_nmbre)) nombre,
	a.cnsctvo_cdgo_pln,		a.inco_vgnca_cntrto,	a.fn_vgnca_cntrto,	a.nmro_unco_idntfccn_afldo,
	p.cdgo_pln,	p. dscrpcn_pln   ,	b.causa , 
	b.nmro_unco_idntfccn_aprtnte,
	b.cnsctvo_scrsl_ctznte,
	b.cnsctvo_cdgo_clse_aprtnte,
	space(200)	nmbre_scrsl,
	space(100)	dscrpcn_clse_aprtnte,
	space(3)	tpo_idntfccn_scrsl,
	space(20)	nmro_idntfccn_scrsl,
	space(30)	cdgo_sde,
        space(100)	dscrpcn_sde,
	right(replicate('0',20)+ltrim(rtrim(b.nmro_unco_idntfccn_aprtnte)),20) + right(replicate('0',2)+ltrim(rtrim(b.cnsctvo_scrsl_ctznte)),2) + right(replicate('0',2)+ltrim(rtrim(b.cnsctvo_cdgo_clse_aprtnte)),2)	Responsable
From 	bdafiliacion.dbo.tbcontratos a,		 	#TmpContratosLogResultados b , 	bdafiliacion.dbo.tbpersonas d,
	bdafiliacion.dbo.tbvinculados  e, 	bdafiliacion.dbo.tbtiposidentificacion f	,	bdplanbeneficios.dbo.tbplanes	p
Where   a.cnsctvo_cdgo_tpo_cntrto 	=	 b.cnsctvo_cdgo_tpo_cntrto
And 	a.nmro_cntrto		  	= 	 b.nmro_cntrto
And	a.nmro_unco_idntfccn_afldo	=	d.nmro_unco_idntfccn
And	d.nmro_unco_idntfccn		=	e.nmro_unco_idntfccn
And	e.cnsctvo_cdgo_tpo_idntfccn	=	f.cnsctvo_cdgo_tpo_idntfccn
And	a.cnsctvo_cdgo_pln		=	p.cnsctvo_cdgo_pln
order by  d.prmr_aplldo ,d.sgndo_aplldo,d.prmr_nmbre,d.sgndo_nmbre

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Fin actualizacion datos 33  [SpLiquidacionPrevia]',Getdate())

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Inicia actualizacion datos 34  [SpLiquidacionPrevia]',Getdate())

update	#tmpResultadosLogFinal
Set	nmbre_scrsl		=	s.nmbre_scrsl,
	dscrpcn_clse_aprtnte	=	c.dscrpcn_clse_aprtnte,
	tpo_idntfccn_scrsl	=	t.cdgo_tpo_idntfccn,
	nmro_idntfccn_scrsl	=	v.nmro_idntfccn,
	cdgo_sde		=	se.cdgo_sde,
	dscrpcn_sde		=	se.dscrpcn_sde
From	#tmpResultadosLogFinal a,  bdafiliacion.dbo.tbvinculados v,
	bdafiliacion.dbo.tbtiposidentificacion  t ,  bdafiliacion.dbo.tbclasesaportantes c,
	bdafiliacion.dbo.tbsucursalesaportante s,  bdafiliacion.dbo.tbsedes  se
Where	a.nmro_unco_idntfccn_aprtnte	=	s.nmro_unco_idntfccn_empldr
And	a.cnsctvo_scrsl_ctznte		=	s.cnsctvo_scrsl 
And	a.cnsctvo_cdgo_clse_aprtnte	=	s.cnsctvo_cdgo_clse_aprtnte
And	a.cnsctvo_cdgo_clse_aprtnte	=	c.cnsctvo_cdgo_clse_aprtnte
and	s.nmro_unco_idntfccn_empldr	=	v.nmro_unco_idntfccn
And	t.cnsctvo_cdgo_tpo_idntfccn	=	v.cnsctvo_cdgo_tpo_idntfccn
And	s.sde_crtra_pc			=	se.cnsctvo_cdgo_sde


Select	@max_Cnsctvo_cntrto_dsfldo_mra_pac	 = 	 isnull(max(Cnsctvo_cntrto_dsfldo_mra_pac),0)
From	bdcarterapac.dbo.TbcontratosdesafiliadosXmoraPac

if @lnTipoliquidacion = 1 --Deficnitiva
begin
	Insert	Into	bdcarterapac.dbo.TbcontratosdesafiliadosXmoraPac
	Select	(ID_Num + @max_Cnsctvo_cntrto_dsfldo_mra_pac),
	nmro_cntrto,
	cnsctvo_cdgo_tpo_cntrto,
	cnsctvo_cbrnza,
	nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte,
	@cnsctvo_cdgo_lqdcn,
	'A',
	NULL,
	'N' 
	From	#TmpcontratosDesafiliarMoraPac 
end


insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Fin actualizacion datos 34  [SpLiquidacionPrevia]',Getdate())

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Inicia actualizacion datos 35  [SpLiquidacionPrevia]',Getdate())
 
Select   nmro_cntrto,
	 cdgo_tpo_idntfccn ,
	 nmro_idntfccn,
	 nombre,
	 cnsctvo_cdgo_pln,
	 inco_vgnca_cntrto,
	 fn_vgnca_cntrto ,
	 nmro_unco_idntfccn_afldo,
	 cdgo_pln ,
	 dscrpcn_pln ,
	 causa ,
	 nmro_unco_idntfccn_aprtnte,
	 cnsctvo_scrsl_ctznte ,
	 cnsctvo_cdgo_clse_aprtnte,
	 nmbre_scrsl ,
	 dscrpcn_clse_aprtnte ,
	 tpo_idntfccn_scrsl ,
	 nmro_idntfccn_scrsl ,
	 cdgo_sde ,
	 dscrpcn_sde ,
	 Responsable 
from	#tmpResultadosLogFinal
order by nmbre_scrsl, nombre

--Select *
--Into	##tmpResultadosLogFinal_20150106
--from	#tmpResultadosLogFinal
--order by nmbre_scrsl, nombre

---Para guardar el log de contratos y pueda ser consultado 

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Fin actualizacion datos 35  [SpLiquidacionPrevia]',Getdate())


insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Inicia actualizacion datos 36  [SpLiquidacionPrevia]',Getdate())


insert into tbLogliquidacionesContratos
select 	@cnsctvo_cdgo_lqdcn,
	nmro_cntrto,
	cdgo_tpo_idntfccn ,
	nmro_idntfccn,
	SUBSTRING(Ltrim(Rtrim(nombre)),1,30),
	cnsctvo_cdgo_pln,
	inco_vgnca_cntrto,
	fn_vgnca_cntrto ,
	nmro_unco_idntfccn_afldo,
	SUBSTRING(Rtrim(Ltrim(cdgo_pln)),1,2),
	dscrpcn_pln ,
	SUBSTRING(Rtrim(Ltrim(causa)),1,50) ,
	nmro_unco_idntfccn_aprtnte,
	cnsctvo_scrsl_ctznte ,
	cnsctvo_cdgo_clse_aprtnte,
	SUBSTRING(Rtrim(Ltrim(nmbre_scrsl)),1,30) ,
	dscrpcn_clse_aprtnte ,
	tpo_idntfccn_scrsl ,
	nmro_idntfccn_scrsl ,
	SUBSTRING(Rtrim(Ltrim(cdgo_sde)),1,2) ,
	dscrpcn_sde ,
	SUBSTRING(Rtrim(Ltrim(Responsable)),1,50)
from	#tmpResultadosLogFinal
order by nmbre_scrsl, nombre

If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error Insertando en tbLogliquidacionesContratos'
		Rollback tran 
		Return -1
	end	

insert	into  tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Fin actualizacion datos 36  [SpLiquidacionPrevia]',Getdate())


Commit tran



End
