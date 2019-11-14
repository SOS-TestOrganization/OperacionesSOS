
/*---------------------------------------------------------------------------------
* Metodo o PRG 			: spTarificacionCalculaTarifaXBeneficiario
* Desarrollado por		: <\A Ing. ROLANDO SIMBAQUEVA LASSO			A\>
* Descripcion			: <\D Este procedimiento Actualiza el grupos de tarifas para cada beneficiario	D\>
* Observaciones			: <\O  				O\>
* Parametros			: <\P 				P\>
* Variables				: <\V  				V\>
* Fecha Creacion		: <\FC 2002/07/02	FC\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado por por	: <\A Ing. ROLANDO SIMBAQUEVA LASSO						A\>
* Descripcion			: <\D Aplicacion de tecnicas de optimizacion		 	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P 													P\>
* Variables				: <\V  													V\>
* Fecha Creacion		: <\FC 2005/ 09/ 26 FC\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM sismpr01 AM\>
* Descripcion			: <\DM 	Las personas que cotizan se cobren como adicional sean o no discapacitados DM\>
* Nuevos Parametros		: <\PM  @cnsctvo_cdgo_lqdcn PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion	: <\FM  2019/09/18 FM\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM Francisco Eduardo Riaño - Qvision S.A AM\>
* Descripcion			: <\DM 	se adiciona parametro de entrada para utilizar el periodo de liquidacion
								que se esta realizando en el momento DM\>
* Nuevos Parametros		: <\PM  @cnsctvo_cdgo_lqdcn PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion	: <\FM  2019/09/18 FM\>
*---------------------------------------------------------------------------------*/
CREATE  PROCEDURE [dbo].[spTarificacionCalculaTarifaXBeneficiario](
	@cnsctvo_cdgo_lqdcn udtConsecutivo
)
As
Begin
	
	set nocount on;

	Declare		@ldFechaEvaluacion			Datetime,
				@cnsctvo_cdgo_prdo_lqdcn	int
			
	--Creacion de tablas temporales
	Create table 	#tmp126
	(
		nmro_unco_idntfccn int,
		edd_bnfcro int,
		cnsctvo_cdgo_pln int,
		ps_ss char(1),
		fcha_aflcn_pc	datetime,
		cnsctvo_cdgo_prntsco int,
		cnsctvo_cdgo_tpo_afldo int, 
		Dscpctdo char(1),
		Estdnte char(1),
		Antgdd_hcu char(1),
		Atrzdo_sn_Ps char(1),
		grpo_bsco char(1),
		cnsctvo_cdgo_tpo_cntrto int,	
		nmro_cntrto varchar(20),
		cnsctvo_bnfcro int,
		cnsctvo_cbrnza int,
		grupo int,
		cnsctvo_prdcto int,
		cnsctvo_mdlo int,
		vlr_upc numeric(12,0),
		vlr_rl_pgo numeric(12,0),
		cnsctvo_cdgo_tps_cbro int,
		Cobranza_Con_producto int,
		Beneficiario_Con_producto int,
		Con_Modelo int,
		grupo_tarificacion int,
		igual_plan int,
		grupo_modelo int,
		nmro_unco_idntfccn_aprtnte int,
		cnsctvo_scrsl_ctznte int, 
		cnsctvo_cdgo_clse_aprtnte int,
		inco_vgnca_cntrto datetime,
		bnfcdo_pc char(1)
	)
	
	Create table #tmp126A
	(
		cnsctvo_cdgo_tpo_cntrto int,
		nmro_cntrto varchar(20),
		cnsctvo_cbrnza int
	)
	
	Create table #tmp126B
	(
		cnsctvo_cdgo_tpo_cntrto int,
		nmro_cntrto varchar(20),
		cnsctvo_cbrnza int
	)
	
	Create table 	#tmp124
	(
		nmro_unco_idntfccn int,
		edd_bnfcro int,
		cnsctvo_cdgo_pln int,
		ps_ss char(1),
		fcha_aflcn_pc	datetime,
		cnsctvo_cdgo_prntsco int,
		cnsctvo_cdgo_tpo_afldo int,
		Dscpctdo char(1),
		Estdnte char(1),
		Antgdd_hcu char(1),
		Atrzdo_sn_Ps char(1),
		grpo_bsco char(1),
		cnsctvo_cdgo_tpo_cntrto int,	
		nmro_cntrto varchar(20),
		cnsctvo_bnfcro int,
		cnsctvo_cbrnza int,
		grupo int,
		cnsctvo_prdcto int,
		cnsctvo_mdlo int,
		vlr_upc numeric(12,0),
		vlr_rl_pgo numeric(12,0),
		cnsctvo_cdgo_tps_cbro int,
		Cobranza_Con_producto int,
		Beneficiario_Con_producto int,
		Con_Modelo int,
		grupo_tarificacion int,
		igual_plan int,
		grupo_modelo int,
		nmro_unco_idntfccn_aprtnte int,
		cnsctvo_scrsl_ctznte int, 
		cnsctvo_cdgo_clse_aprtnte int,
		inco_vgnca_cntrto datetime,
		bnfcdo_pc char(1)
	)
	
	Create table #tmp124A
	(
		cnsctvo_cdgo_tpo_cntrto int,
		nmro_cntrto varchar(20),
		cnsctvo_cbrnza int
	)
	
	Create table #tmp124B
	(
		cnsctvo_cdgo_tpo_cntrto int,
		nmro_cntrto varchar(20),
		cnsctvo_cbrnza int
	)

	Create table 	#tmp130
	(
		nmro_unco_idntfccn int,
		edd_bnfcro int,
		cnsctvo_cdgo_pln int,
		ps_ss char(1),
		fcha_aflcn_pc	datetime,
		cnsctvo_cdgo_prntsco int,
		cnsctvo_cdgo_tpo_afldo int,
		Dscpctdo char(1),
		Estdnte char(1),
		Antgdd_hcu char(1),
		Atrzdo_sn_Ps char(1),
		grpo_bsco char(1),
		cnsctvo_cdgo_tpo_cntrto int,	
		nmro_cntrto varchar(20),
		cnsctvo_bnfcro int,
		cnsctvo_cbrnza int,
		grupo int,
		cnsctvo_prdcto int,
		cnsctvo_mdlo int,
		vlr_upc numeric(12,0),
		vlr_rl_pgo numeric(12,0),
		cnsctvo_cdgo_tps_cbro int,
		Cobranza_Con_producto int,
		Beneficiario_Con_producto int,
		Con_Modelo int,
		grupo_tarificacion int,
		igual_plan int,
		grupo_modelo int,
		nmro_unco_idntfccn_aprtnte int,
		cnsctvo_scrsl_ctznte int, 
		cnsctvo_cdgo_clse_aprtnte int,
		inco_vgnca_cntrto datetime,
		bnfcdo_pc char(1)
	)
	
	Create table #tmp130A
	(
		cnsctvo_cdgo_tpo_cntrto int,
		nmro_cntrto varchar(20),
		cnsctvo_cbrnza int
	)
	
	Create table #tmp130B
	(
		cnsctvo_cdgo_tpo_cntrto int,
		nmro_cntrto varchar(20),
		cnsctvo_cbrnza int
	)
	
	Create table 	#tmp127
	(
		nmro_unco_idntfccn int,
		edd_bnfcro int,
		cnsctvo_cdgo_pln int,
		ps_ss char(1),
		fcha_aflcn_pc	datetime,
		cnsctvo_cdgo_prntsco int,
		cnsctvo_cdgo_tpo_afldo int,
		Dscpctdo char(1),
		Estdnte char(1),
		Antgdd_hcu char(1),
		Atrzdo_sn_Ps char(1),
		grpo_bsco char(1),
		cnsctvo_cdgo_tpo_cntrto int,	
		nmro_cntrto varchar(20),
		cnsctvo_bnfcro int,
		cnsctvo_cbrnza int,
		grupo int,
		cnsctvo_prdcto int,
		cnsctvo_mdlo int,
		vlr_upc numeric(12,0),
		vlr_rl_pgo numeric(12,0),
		cnsctvo_cdgo_tps_cbro int,
		Cobranza_Con_producto int,
		Beneficiario_Con_producto int,
		Con_Modelo int,
		grupo_tarificacion int,
		igual_plan int,
		grupo_modelo int,
		nmro_unco_idntfccn_aprtnte int,
		cnsctvo_scrsl_ctznte int, 
		cnsctvo_cdgo_clse_aprtnte int,
		inco_vgnca_cntrto datetime,
		bnfcdo_pc char(1)
	)
	
	Create table #tmp127A
	(
		cnsctvo_cdgo_tpo_cntrto int,
		nmro_cntrto varchar(20),
		cnsctvo_cbrnza int
	)
	
	Create table #tmp127B
	(
		cnsctvo_cdgo_tpo_cntrto int,
		nmro_cntrto varchar(20),
		cnsctvo_cbrnza int
	)

	Create table 	#tmp125
	(
		nmro_unco_idntfccn int,
		edd_bnfcro int,
		cnsctvo_cdgo_pln int,
		ps_ss char(1),
		fcha_aflcn_pc	datetime,
		cnsctvo_cdgo_prntsco int,
		cnsctvo_cdgo_tpo_afldo int,
		Dscpctdo char(1),
		Estdnte char(1),
		Antgdd_hcu char(1),
		Atrzdo_sn_Ps char(1),
		grpo_bsco char(1),
		cnsctvo_cdgo_tpo_cntrto int,	
		nmro_cntrto varchar(20),
		cnsctvo_bnfcro int,
		cnsctvo_cbrnza int,
		grupo int,
		cnsctvo_prdcto int,
		cnsctvo_mdlo int,
		vlr_upc numeric(12,0),
		vlr_rl_pgo numeric(12,0),
		cnsctvo_cdgo_tps_cbro int,
		Cobranza_Con_producto int,
		Beneficiario_Con_producto int,
		Con_Modelo int,
		grupo_tarificacion int,
		igual_plan int,
		grupo_modelo int,
		nmro_unco_idntfccn_aprtnte int,
		cnsctvo_scrsl_ctznte int, 
		cnsctvo_cdgo_clse_aprtnte int,
		inco_vgnca_cntrto datetime,
		bnfcdo_pc char(1)
	)
	
	Create table #tmp125A
	(
		cnsctvo_cdgo_tpo_cntrto int,
		nmro_cntrto varchar(20),
		cnsctvo_cbrnza int
	)
	
	Create table #tmp125B
	(
		cnsctvo_cdgo_tpo_cntrto int,
		nmro_cntrto varchar(20),
		cnsctvo_cbrnza int
	)

	Create table 	#tmp131
	(
		nmro_unco_idntfccn int,
		edd_bnfcro int,
		cnsctvo_cdgo_pln int,
		ps_ss char(1),
		fcha_aflcn_pc	datetime,
		cnsctvo_cdgo_prntsco int,
		cnsctvo_cdgo_tpo_afldo int,
		Dscpctdo char(1),
		Estdnte char(1),
		Antgdd_hcu char(1),
		Atrzdo_sn_Ps char(1),
		grpo_bsco char(1),
		cnsctvo_cdgo_tpo_cntrto int,	
		nmro_cntrto varchar(20),
		cnsctvo_bnfcro int,
		cnsctvo_cbrnza int,
		grupo int,
		cnsctvo_prdcto int,
		cnsctvo_mdlo int,
		vlr_upc numeric(12,0),
		vlr_rl_pgo numeric(12,0),
		cnsctvo_cdgo_tps_cbro int,
		Cobranza_Con_producto int,
		Beneficiario_Con_producto int,
		Con_Modelo int,
		grupo_tarificacion int,
		igual_plan int,
		grupo_modelo int,
		nmro_unco_idntfccn_aprtnte int,
		cnsctvo_scrsl_ctznte int, 
		cnsctvo_cdgo_clse_aprtnte int,
		inco_vgnca_cntrto datetime,
		bnfcdo_pc char(1)
	)
	
	Create table #tmp131A
	(
		cnsctvo_cdgo_tpo_cntrto int,
		nmro_cntrto varchar(20),
		cnsctvo_cbrnza int
	)
	
	Create table #tmp131B
	(
		cnsctvo_cdgo_tpo_cntrto int,
		nmro_cntrto varchar(20),
		cnsctvo_cbrnza int
	)
	
	Create table 	#tmp252
	(
		nmro_unco_idntfccn int,
		edd_bnfcro int,
		cnsctvo_cdgo_pln int,
		ps_ss char(1),
		fcha_aflcn_pc	datetime,
		cnsctvo_cdgo_prntsco int,
		cnsctvo_cdgo_tpo_afldo int,
		Dscpctdo char(1),
		Estdnte char(1),
		Antgdd_hcu char(1),
		Atrzdo_sn_Ps char(1),
		grpo_bsco char(1),
		cnsctvo_cdgo_tpo_cntrto int,	
		nmro_cntrto varchar(20),
		cnsctvo_bnfcro int,
		cnsctvo_cbrnza int,
		grupo int,
		cnsctvo_prdcto int,
		cnsctvo_mdlo int,
		vlr_upc numeric(12,0),
		vlr_rl_pgo numeric(12,0),
		cnsctvo_cdgo_tps_cbro int,
		Cobranza_Con_producto int,
		Beneficiario_Con_producto int,
		Con_Modelo int,
		grupo_tarificacion int,
		igual_plan int,
		grupo_modelo int,
		nmro_unco_idntfccn_aprtnte int,
		cnsctvo_scrsl_ctznte int, 
		cnsctvo_cdgo_clse_aprtnte int,
		inco_vgnca_cntrto datetime,
		bnfcdo_pc char(1)
	)
	
	Create table #tmp252A
	(
		cnsctvo_cdgo_tpo_cntrto int,
		nmro_cntrto varchar(20),
		cnsctvo_cbrnza int
	)
	
	Create table #tmp252B
	(
		cnsctvo_cdgo_tpo_cntrto int,
		nmro_cntrto varchar(20),
		cnsctvo_cbrnza int
	)
	
	Create table 	#tmp254
	(
		nmro_unco_idntfccn int,
		edd_bnfcro int,
		cnsctvo_cdgo_pln int,
		ps_ss char(1),
		fcha_aflcn_pc	datetime,
		cnsctvo_cdgo_prntsco int,
		cnsctvo_cdgo_tpo_afldo int,
		Dscpctdo char(1),
		Estdnte char(1),
		Antgdd_hcu char(1),
		Atrzdo_sn_Ps char(1),
		grpo_bsco char(1),
		cnsctvo_cdgo_tpo_cntrto int,	
		nmro_cntrto varchar(20),
		cnsctvo_bnfcro int,
		cnsctvo_cbrnza int,
		grupo int,
		cnsctvo_prdcto int,
		cnsctvo_mdlo int,
		vlr_upc numeric(12,0),
		vlr_rl_pgo numeric(12,0),
		cnsctvo_cdgo_tps_cbro int,
		Cobranza_Con_producto int,
		Beneficiario_Con_producto int,
		Con_Modelo int,
		grupo_tarificacion int,
		igual_plan int,
		grupo_modelo int,
		nmro_unco_idntfccn_aprtnte int,
		cnsctvo_scrsl_ctznte int, 
		cnsctvo_cdgo_clse_aprtnte int,
		inco_vgnca_cntrto datetime,
		bnfcdo_pc char(1)
	)
	
	Create table #tmp254A
	(
		cnsctvo_cdgo_tpo_cntrto int,
		nmro_cntrto varchar(20),
		cnsctvo_cbrnza int
	)
	
	Create table #tmp254B
	(
		cnsctvo_cdgo_tpo_cntrto int,
		nmro_cntrto varchar(20),
		cnsctvo_cbrnza int
	)

	Create table 	#tmp258
	(
		nmro_unco_idntfccn int,
		edd_bnfcro int,
		cnsctvo_cdgo_pln int,
		ps_ss char(1),
		fcha_aflcn_pc	datetime,
		cnsctvo_cdgo_prntsco int,
		cnsctvo_cdgo_tpo_afldo int,
		Dscpctdo char(1),
		Estdnte char(1),
		Antgdd_hcu char(1),
		Atrzdo_sn_Ps char(1),
		grpo_bsco char(1),
		cnsctvo_cdgo_tpo_cntrto int,	
		nmro_cntrto varchar(20),
		cnsctvo_bnfcro int,
		cnsctvo_cbrnza int,
		grupo int,
		cnsctvo_prdcto int,
		cnsctvo_mdlo int,
		vlr_upc numeric(12,0),
		vlr_rl_pgo numeric(12,0),
		cnsctvo_cdgo_tps_cbro int,
		Cobranza_Con_producto int,
		Beneficiario_Con_producto int,
		Con_Modelo int,
		grupo_tarificacion int,
		igual_plan int,
		grupo_modelo int,
		nmro_unco_idntfccn_aprtnte int,
		cnsctvo_scrsl_ctznte int, 
		cnsctvo_cdgo_clse_aprtnte int,
		inco_vgnca_cntrto datetime,
		bnfcdo_pc char(1)
	)
	
	Create table #tmp258A
	(
		cnsctvo_cdgo_tpo_cntrto int,
		nmro_cntrto varchar(20),
		cnsctvo_cbrnza int
	)
	
	Create table #tmp258B
	(
		cnsctvo_cdgo_tpo_cntrto int,
		nmro_cntrto varchar(20),
		cnsctvo_cbrnza int
	)

	Create table 	#tmp253
	(
		nmro_unco_idntfccn int,
		edd_bnfcro int,
		cnsctvo_cdgo_pln int,
		ps_ss char(1),
		fcha_aflcn_pc	datetime,
		cnsctvo_cdgo_prntsco int,
		cnsctvo_cdgo_tpo_afldo int,
		Dscpctdo char(1),
		Estdnte char(1),
		Antgdd_hcu char(1),
		Atrzdo_sn_Ps char(1),
		grpo_bsco char(1),
		cnsctvo_cdgo_tpo_cntrto int,	
		nmro_cntrto varchar(20),
		cnsctvo_bnfcro int,
		cnsctvo_cbrnza int,
		grupo int,
		cnsctvo_prdcto int,
		cnsctvo_mdlo int,
		vlr_upc numeric(12,0),
		vlr_rl_pgo numeric(12,0),
		cnsctvo_cdgo_tps_cbro int,
		Cobranza_Con_producto int,
		Beneficiario_Con_producto int,
		Con_Modelo int,
		grupo_tarificacion int,
		igual_plan int,
		grupo_modelo int,
		nmro_unco_idntfccn_aprtnte int,
		cnsctvo_scrsl_ctznte int, 
		cnsctvo_cdgo_clse_aprtnte int,
		inco_vgnca_cntrto datetime,
		bnfcdo_pc char(1)
	)
	
	Create table #tmp253A
	(
		cnsctvo_cdgo_tpo_cntrto int,
		nmro_cntrto varchar(20),
		cnsctvo_cbrnza int
	)
	
	Create table #tmp253B
	(
		cnsctvo_cdgo_tpo_cntrto int,
		nmro_cntrto varchar(20),
		cnsctvo_cbrnza int
	)
	
	Create table 	#tmp255
	(
		nmro_unco_idntfccn int,
		edd_bnfcro int,
		cnsctvo_cdgo_pln int,
		ps_ss char(1),
		fcha_aflcn_pc	datetime,
		cnsctvo_cdgo_prntsco int,
		cnsctvo_cdgo_tpo_afldo int,
		Dscpctdo char(1),
		Estdnte char(1),
		Antgdd_hcu char(1),
		Atrzdo_sn_Ps char(1),
		grpo_bsco char(1),
		cnsctvo_cdgo_tpo_cntrto int,	
		nmro_cntrto varchar(20),
		cnsctvo_bnfcro int,
		cnsctvo_cbrnza int,
		grupo int,
		cnsctvo_prdcto int,
		cnsctvo_mdlo int,
		vlr_upc numeric(12,0),
		vlr_rl_pgo numeric(12,0),
		cnsctvo_cdgo_tps_cbro int,
		Cobranza_Con_producto int,
		Beneficiario_Con_producto int,
		Con_Modelo int,
		grupo_tarificacion int,
		igual_plan int,
		grupo_modelo int,
		nmro_unco_idntfccn_aprtnte int,
		cnsctvo_scrsl_ctznte int, 
		cnsctvo_cdgo_clse_aprtnte int,
		inco_vgnca_cntrto datetime,
		bnfcdo_pc char(1)
	)
	
	Create table #tmp255A
	(	
		cnsctvo_cdgo_tpo_cntrto int,
		nmro_cntrto varchar(20),
		cnsctvo_cbrnza int
	)
	
	Create table #tmp255B
	(
		cnsctvo_cdgo_tpo_cntrto int,
		nmro_cntrto varchar(20),
		cnsctvo_cbrnza int
	)
	
	Create table 	#tmp259
	(
		nmro_unco_idntfccn int,
		edd_bnfcro int,
		cnsctvo_cdgo_pln int,
		ps_ss char(1),
		fcha_aflcn_pc	datetime,
		cnsctvo_cdgo_prntsco int,
		cnsctvo_cdgo_tpo_afldo int,
		Dscpctdo char(1),
		Estdnte char(1),
		Antgdd_hcu char(1),
		Atrzdo_sn_Ps char(1),
		grpo_bsco char(1),
		cnsctvo_cdgo_tpo_cntrto int,	
		nmro_cntrto varchar(20),
		cnsctvo_bnfcro int,
		cnsctvo_cbrnza int,
		grupo int,
		cnsctvo_prdcto int,
		cnsctvo_mdlo int,
		vlr_upc numeric(12,0),
		vlr_rl_pgo numeric(12,0),
		cnsctvo_cdgo_tps_cbro int,
		Cobranza_Con_producto int,
		Beneficiario_Con_producto int,
		Con_Modelo int,
		grupo_tarificacion int,
		igual_plan int,
		grupo_modelo int,
		nmro_unco_idntfccn_aprtnte int,
		cnsctvo_scrsl_ctznte int, 
		cnsctvo_cdgo_clse_aprtnte int,
		inco_vgnca_cntrto datetime,
		bnfcdo_pc char(1)
	)
	
	Create table #tmp259A
	(
		cnsctvo_cdgo_tpo_cntrto int,
		nmro_cntrto varchar(20),
		cnsctvo_cbrnza int
	)
	
	Create table #tmp259B
	(
		cnsctvo_cdgo_tpo_cntrto int,
		nmro_cntrto varchar(20),
		cnsctvo_cbrnza int
	)

	Create table	#tmpProductosCobranza
	(
		cnsctvo_prdcto_cbrnza int,
		cnsctvo_cdgo_tpo_cntrto int,
		nmro_cntrto varchar(20),
		cnsctvo_cbrnza int,
		cnsctvo_prdcto_scrsl int,
		cnsctvo_prdcto int,
		inco_vgnca datetime,
		fn_vgnca datetime,
		estdo_rgstro char(1)
	)
	
	Create table  	#tmpModelosAsociadosxProducto	
	(
		cnsctvo_cdgo_tpo_cntrto int,
		nmro_cntrto varchar(20),
		cnsctvo_bnfcro int,
		cnsctvo_cbrnza int,
		cnsctvo_prdcto int,
		cnsctvo_mdlo int,
		cnsctvo_cdgo_clse_mdlo int,
		inco_vgnca_asccn datetime,
		fn_vgnca_asccn datetime,
		fcha_uso_mdlo datetime,    
		fcha_aflcn_pc datetime,
		Estado  int
	)                                     

	Create table #tmpModelosMayorUno
	(
		cnsctvo_cdgo_tpo_cntrto int,
		nmro_cntrto varchar(20),
		cnsctvo_bnfcro int,
		cnsctvo_cbrnza int,
		cnsctvo_prdcto int,
		cnsctvo_mdlo int,
		cnsctvo_cdgo_clse_mdlo int,
		inco_vgnca_asccn datetime,
		fn_vgnca_asccn datetime,
		fcha_uso_mdlo datetime,     
		fcha_aflcn_pc datetime,
		Estado1 int,
		Estado2 int,
		brrdo char(1)
	)
	
	Create table #tmpContratoPosCotizantes
	(
		nmro_unco_idntfccn int
	)
	
	Create table #tmpValoresGrupales
	(
		cnsctvo_cdgo_tpo_cntrto int,
		nmro_cntrto varchar(20),
		cnsctvo_cbrnza int,
		vlr_rl_pgo numeric(12,0),
		grupo int,
		cnsctvo_bnfcro int
	)
	
	insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(-1,'Paso 1  spTarificacionCalculaTarifaXBeneficiario',Getdate())


	Select  a.cnsctvo_cdgo_tpo_cntrto,	a.nmro_cntrto, count (cnsctvo_bnfcro) cantidad_beneficiarios
	into	#tmpCantidadBeneHijos
	From	#RegistrosClasificar a
	where	a.cnsctvo_cdgo_prntsco	 in (2,3,4)
	and		a.nmro_cntrto not in (select nmro_cntrto  from  #RegistrosClasificar a where  a.cnsctvo_cdgo_prntsco	not in (1,2,3,4) group by nmro_cntrto )
	group by a.cnsctvo_cdgo_tpo_cntrto,a.nmro_cntrto 

	update	#RegistrosClasificar
	set		tne_hjos_cnyge_cmpnra = 'N'


	update		#RegistrosClasificar 
	Set			Tne_hjos_cnyge_cmpnra	=	'S'
	From		#RegistrosClasificar  a 
	Inner Join 	#tmpCantidadBeneHijos  b
		On 		a.cnsctvo_cdgo_tpo_cntrto	=	 b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto				=	b.nmro_cntrto
	where		cnsctvo_cdgo_tpo_afldo		= 1

	select	cnsctvo_cdgo_tpo_cntrto,nmro_cntrto
	into	#tmp359C 
	from	#RegistrosClasificar   
	where	nmro_unco_idntfccn_aprtnte = 30043100
	and		cnsctvo_scrsl_ctznte = 3
	and		tne_hjos_cnyge_cmpnra = 'S'
	and		grpo_bsco_cn_ps = 'S'
	and		cnsctvo_cdgo_tpo_afldo = 1
	group by cnsctvo_cdgo_tpo_cntrto,nmro_cntrto
       
	update		a
	set			grupo = 359
	from		#RegistrosClasificar   a 
	inner join  #tmp359C b
		on		a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto
		and		a.nmro_cntrto = b.nmro_cntrto

	Select  a.cnsctvo_cdgo_tpo_cntrto,	a.nmro_cntrto, count (cnsctvo_bnfcro) cantidad_beneficiarios
	into	#tmpCantidadAdicionales
	From	#RegistrosClasificar a
	where	a.cnsctvo_cdgo_prntsco	 = 4
	and		a.nmro_cntrto  in (select nmro_cntrto  from  #RegistrosClasificar a where  a.cnsctvo_cdgo_prntsco	not in (1,2,3,4) group by nmro_cntrto) 
	group by  a.cnsctvo_cdgo_tpo_cntrto,	a.nmro_cntrto


	update		#RegistrosClasificar 
	Set			Tne_hjos_cnyge_cmpnra	=	'A'
	From		#RegistrosClasificar  a 
	Inner Join 	#tmpCantidadAdicionales  b
		On 		a.cnsctvo_cdgo_tpo_cntrto			=	 b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto			=	b.nmro_cntrto
	where		cnsctvo_cdgo_tpo_afldo = 1


	select	cnsctvo_cdgo_tpo_cntrto,nmro_cntrto
	into	#tmp359A
	from	#RegistrosClasificar   
	where	nmro_unco_idntfccn_aprtnte = 30043100
	and		cnsctvo_scrsl_ctznte = 3
	and		tne_hjos_cnyge_cmpnra = 'A'
	and		grpo_bsco_cn_ps = 'S'
	and		cnsctvo_cdgo_tpo_afldo = 1
	group by cnsctvo_cdgo_tpo_cntrto,nmro_cntrto

	update		a
	set			grupo = 359
	from		#RegistrosClasificar   a 
	inner join  #tmp359A b
		on		a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto
		and		a.nmro_cntrto = b.nmro_cntrto
		and		a.cnsctvo_cdgo_prntsco	 in (1,2,3,4)


	insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(-1,'Paso 2  spTarificacionCalculaTarifaXBeneficiario',Getdate())


	Select	@cnsctvo_cdgo_prdo_lqdcn	=	cnsctvo_cdgo_prdo_lqdcn
	From	bdcarteraPac.dbo.tbliquidaciones with(nolock)
	Where	cnsctvo_cdgo_lqdcn		=	@cnsctvo_cdgo_lqdcn
	
	Select 	@ldFechaEvaluacion		=	fcha_incl_prdo_lqdcn
	From	bdcarteraPac.dbo.tbperiodosliquidacion_vigencias with(nolock)
	Where	cnsctvo_cdgo_prdo_lqdcn	=	@cnsctvo_cdgo_prdo_lqdcn
	
	--nuevo 11 de marzo del 2004
	--Se actualiza dependiendo el grupo para padres
	--primero el grupo 2  y con pos

	Insert Into  	#tmp126
	select  nmro_unco_idntfccn , edd_bnfcro , cnsctvo_cdgo_pln , ps_ss , fcha_aflcn_pc,
			cnsctvo_cdgo_prntsco,cnsctvo_cdgo_tpo_afldo, Dscpctdo, Estdnte,
			Antgdd_hcu , Atrzdo_sn_Ps, grpo_bsco, cnsctvo_cdgo_tpo_cntrto , nmro_cntrto,
			cnsctvo_bnfcro, cnsctvo_cbrnza, grupo, cnsctvo_prdcto, cnsctvo_mdlo, vlr_upc,
			vlr_rl_pgo, cnsctvo_cdgo_tps_cbro, Cobranza_Con_producto,
			Beneficiario_Con_producto,  Con_Modelo,  grupo_tarificacion, igual_plan,
			grupo_modelo, nmro_unco_idntfccn_aprtnte , cnsctvo_scrsl_ctznte ,
			cnsctvo_cdgo_clse_aprtnte, inco_vgnca_cntrto , bnfcdo_pc
	From 	#RegistrosClasificar 
	where 	cnsctvo_cdgo_prntsco	=	5
	And		grupo 					= 	126
	And		cnsctvo_cdgo_pln		=	2	


	Insert into 	 #tmp126A
	select   cnsctvo_cdgo_tpo_cntrto, nmro_cntrto ,     cnsctvo_cbrnza
	from     #tmp126
	group by cnsctvo_cdgo_tpo_cntrto, nmro_cntrto ,     cnsctvo_cbrnza
	
	Insert Into      #tmp126B
	Select		a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto ,     a.cnsctvo_cbrnza 
	From		#tmp126A a 
	inner join  #RegistrosClasificar	 b
		on		(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto				=	b.nmro_cntrto
		And		a.cnsctvo_cbrnza			=	b.cnsctvo_cbrnza)
	Where   cnsctvo_cdgo_prntsco			=	5
	Group by a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto ,     a.cnsctvo_cbrnza
	Having count(b.cnsctvo_bnfcro) > 1


	update		#RegistrosClasificar 
	Set			grupo	=	126
	From 		#RegistrosClasificar a 
	inner join	#tmp126B b
		On		(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto				=	b.nmro_cntrto
		And		a.cnsctvo_cbrnza			=	b.cnsctvo_cbrnza)
	where 		a.cnsctvo_cdgo_prntsco		=	5
	And			grupo in	(122,124,130)


	--Segundo proceso
	Insert  Into  	#tmp124
	Select  nmro_unco_idntfccn , edd_bnfcro , cnsctvo_cdgo_pln , ps_ss , fcha_aflcn_pc,
			cnsctvo_cdgo_prntsco,cnsctvo_cdgo_tpo_afldo, Dscpctdo, Estdnte,
			Antgdd_hcu , Atrzdo_sn_Ps, grpo_bsco, cnsctvo_cdgo_tpo_cntrto , nmro_cntrto,
			cnsctvo_bnfcro, cnsctvo_cbrnza, grupo, cnsctvo_prdcto, cnsctvo_mdlo, vlr_upc,
			vlr_rl_pgo, cnsctvo_cdgo_tps_cbro, Cobranza_Con_producto,
			Beneficiario_Con_producto,  Con_Modelo,  grupo_tarificacion, igual_plan,
			grupo_modelo, nmro_unco_idntfccn_aprtnte , cnsctvo_scrsl_ctznte ,
			cnsctvo_cdgo_clse_aprtnte, inco_vgnca_cntrto , bnfcdo_pc
	From 	#RegistrosClasificar
	where 	cnsctvo_cdgo_prntsco	=	5
	And		grupo 					= 	124
	And		cnsctvo_cdgo_pln		=	2

	Insert into 	 #tmp124A
	select   cnsctvo_cdgo_tpo_cntrto, nmro_cntrto ,     cnsctvo_cbrnza
	from     #tmp124
	group by cnsctvo_cdgo_tpo_cntrto, nmro_cntrto ,     cnsctvo_cbrnza


	Insert Into    	#tmp124b
	Select  a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto ,     a.cnsctvo_cbrnza 
	From    #tmp124A a, #RegistrosClasificar	 b
	Where   a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
	And	a.nmro_cntrto				=	b.nmro_cntrto
	And	a.cnsctvo_cbrnza			=	b.cnsctvo_cbrnza
	And	cnsctvo_cdgo_prntsco		=	5
	Group by a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto ,     a.cnsctvo_cbrnza
	Having count(b.cnsctvo_bnfcro) > 1


	update		#RegistrosClasificar 
	Set			grupo	=	124
	From 		#RegistrosClasificar a 
	inner join	#tmp124b b
		on		(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto			=	b.nmro_cntrto
		And		a.cnsctvo_cbrnza		=	b.cnsctvo_cbrnza)
	Where		a.cnsctvo_cdgo_prntsco	=	5
	And			grupo	in	(122,126,130)

	--Tercero proceso
	Insert  Into  	#tmp130
	Select  nmro_unco_idntfccn , edd_bnfcro , cnsctvo_cdgo_pln , ps_ss , fcha_aflcn_pc,
			cnsctvo_cdgo_prntsco,cnsctvo_cdgo_tpo_afldo, Dscpctdo, Estdnte,
			Antgdd_hcu , Atrzdo_sn_Ps, grpo_bsco, cnsctvo_cdgo_tpo_cntrto , nmro_cntrto,
			cnsctvo_bnfcro, cnsctvo_cbrnza, grupo, cnsctvo_prdcto, cnsctvo_mdlo, vlr_upc,
			vlr_rl_pgo, cnsctvo_cdgo_tps_cbro, Cobranza_Con_producto,
			Beneficiario_Con_producto,  Con_Modelo,  grupo_tarificacion, igual_plan,
			grupo_modelo, nmro_unco_idntfccn_aprtnte , cnsctvo_scrsl_ctznte ,
			cnsctvo_cdgo_clse_aprtnte, inco_vgnca_cntrto , bnfcdo_pc
	From 	#RegistrosClasificar
	where 	cnsctvo_cdgo_prntsco	=	5
	And		grupo 					= 	130
	And		cnsctvo_cdgo_pln		=	2	
	
	Insert Into  #tmp130A
	select   cnsctvo_cdgo_tpo_cntrto, nmro_cntrto ,     cnsctvo_cbrnza
	from     #tmp130
	group by cnsctvo_cdgo_tpo_cntrto, nmro_cntrto ,     cnsctvo_cbrnza
		
	Insert Into	#tmp130B
	Select		a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto ,     a.cnsctvo_cbrnza 
	From		#tmp130A a 
	inner join	#RegistrosClasificar	 b
		on		(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto			=	b.nmro_cntrto
		And		a.cnsctvo_cbrnza		=	b.cnsctvo_cbrnza)
	Where   cnsctvo_cdgo_prntsco		=	5
	Group by a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto ,     a.cnsctvo_cbrnza
	Having count(b.cnsctvo_bnfcro) > 1
		
	Update		#RegistrosClasificar 
	Set			grupo	=	130
	From 		#RegistrosClasificar a 
	inner join	#tmp130B b
		on		(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto				=	b.nmro_cntrto
		And		a.cnsctvo_cbrnza			=	b.cnsctvo_cbrnza)
	Where		a.cnsctvo_cdgo_prntsco		=	5
	And			grupo	in	(122,126,124)

	--cuarto proceso
	Insert Into  	#tmp127
	Select  nmro_unco_idntfccn , edd_bnfcro , cnsctvo_cdgo_pln , ps_ss , fcha_aflcn_pc,
			cnsctvo_cdgo_prntsco,cnsctvo_cdgo_tpo_afldo, Dscpctdo, Estdnte,
			Antgdd_hcu , Atrzdo_sn_Ps, grpo_bsco, cnsctvo_cdgo_tpo_cntrto , nmro_cntrto,
			cnsctvo_bnfcro, cnsctvo_cbrnza, grupo, cnsctvo_prdcto, cnsctvo_mdlo, vlr_upc,
			vlr_rl_pgo, cnsctvo_cdgo_tps_cbro, Cobranza_Con_producto,
			Beneficiario_Con_producto,  Con_Modelo,  grupo_tarificacion, igual_plan,
			grupo_modelo, nmro_unco_idntfccn_aprtnte , cnsctvo_scrsl_ctznte ,
			cnsctvo_cdgo_clse_aprtnte, inco_vgnca_cntrto , bnfcdo_pc
	From 	#RegistrosClasificar
	Where 	cnsctvo_cdgo_prntsco	=	5
	And		grupo 					= 	127
	And		cnsctvo_cdgo_pln		=	2	
	
	
	Insert into  #tmp127A
	Select   cnsctvo_cdgo_tpo_cntrto, nmro_cntrto ,     cnsctvo_cbrnza
	From     #tmp127
	group by cnsctvo_cdgo_tpo_cntrto, nmro_cntrto ,     cnsctvo_cbrnza
	
	Insert Into    #tmp127B
	Select		a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto ,     a.cnsctvo_cbrnza 
	From		#tmp127A a 
	inner join	#RegistrosClasificar	 b
		on      (a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto			=	b.nmro_cntrto
		And		a.cnsctvo_cbrnza		=	b.cnsctvo_cbrnza)
	Where   cnsctvo_cdgo_prntsco		=	5
	Group by a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto ,     a.cnsctvo_cbrnza
	Having count(b.cnsctvo_bnfcro) > 1
		
	update		#RegistrosClasificar 
	Set			grupo	=	127
	From 		#RegistrosClasificar a 
	inner join  #tmp127B b
		on     (a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto				=	b.nmro_cntrto
		And		a.cnsctvo_cbrnza			=	b.cnsctvo_cbrnza)
	Where		a.cnsctvo_cdgo_prntsco		=	5
	And			grupo	in	(123,125,131)
	
	insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(-1,'Paso 3  spTarificacionCalculaTarifaXBeneficiario',Getdate())


	--Proceso quinto
	Insert Into  	#tmp125
	Select  nmro_unco_idntfccn , edd_bnfcro , cnsctvo_cdgo_pln , ps_ss , fcha_aflcn_pc,
			cnsctvo_cdgo_prntsco,cnsctvo_cdgo_tpo_afldo, Dscpctdo, Estdnte,
			Antgdd_hcu , Atrzdo_sn_Ps, grpo_bsco, cnsctvo_cdgo_tpo_cntrto , nmro_cntrto,
			cnsctvo_bnfcro, cnsctvo_cbrnza, grupo, cnsctvo_prdcto, cnsctvo_mdlo, vlr_upc,
			vlr_rl_pgo, cnsctvo_cdgo_tps_cbro, Cobranza_Con_producto,
			Beneficiario_Con_producto,  Con_Modelo,  grupo_tarificacion, igual_plan,
			grupo_modelo, nmro_unco_idntfccn_aprtnte , cnsctvo_scrsl_ctznte ,
			cnsctvo_cdgo_clse_aprtnte, inco_vgnca_cntrto , bnfcdo_pc
	From 	#RegistrosClasificar
	where 	cnsctvo_cdgo_prntsco	=	5
	And		grupo 					= 	125
	And		cnsctvo_cdgo_pln		=	2
	
	Insert into      #tmp125A
	select   cnsctvo_cdgo_tpo_cntrto, nmro_cntrto ,     cnsctvo_cbrnza
	from     #tmp125
	group by cnsctvo_cdgo_tpo_cntrto, nmro_cntrto ,     cnsctvo_cbrnza
	
	
	Insert Into    #tmp125b
	Select		a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto ,     a.cnsctvo_cbrnza 
	From		#tmp125A a 
	inner join	#RegistrosClasificar	 b
		on		(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto				=	b.nmro_cntrto
		And		a.cnsctvo_cbrnza			=	b.cnsctvo_cbrnza)
	Where		cnsctvo_cdgo_prntsco		=	5
	Group by a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto ,     a.cnsctvo_cbrnza
	Having count(b.cnsctvo_bnfcro) > 1
			
	update		#RegistrosClasificar 
	Set			grupo	=	125
	From 		#RegistrosClasificar a 
	inner join	#tmp125b b
		on		(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto				=	b.nmro_cntrto
		And		a.cnsctvo_cbrnza			=	b.cnsctvo_cbrnza)
	Where		a.cnsctvo_cdgo_prntsco		=	5
	And			grupo	in	(123,127,131)

	--sexto proceso
	Insert Into  	#tmp131
	Select  nmro_unco_idntfccn , edd_bnfcro , cnsctvo_cdgo_pln , ps_ss , fcha_aflcn_pc,
			cnsctvo_cdgo_prntsco,cnsctvo_cdgo_tpo_afldo, Dscpctdo, Estdnte,
			Antgdd_hcu , Atrzdo_sn_Ps, grpo_bsco, cnsctvo_cdgo_tpo_cntrto , nmro_cntrto,
			cnsctvo_bnfcro, cnsctvo_cbrnza, grupo, cnsctvo_prdcto, cnsctvo_mdlo, vlr_upc,
			vlr_rl_pgo, cnsctvo_cdgo_tps_cbro, Cobranza_Con_producto,
			Beneficiario_Con_producto,  Con_Modelo,  grupo_tarificacion, igual_plan,
			grupo_modelo, nmro_unco_idntfccn_aprtnte , cnsctvo_scrsl_ctznte ,
			cnsctvo_cdgo_clse_aprtnte, inco_vgnca_cntrto , bnfcdo_pc
	From 	#RegistrosClasificar
	where 	cnsctvo_cdgo_prntsco	=	5
	And		grupo 					= 	131
	And		cnsctvo_cdgo_pln		=	2	
	
	
	Insert into 	 #tmp131A
	Select   cnsctvo_cdgo_tpo_cntrto, nmro_cntrto ,     cnsctvo_cbrnza
	from     #tmp131
	Group by cnsctvo_cdgo_tpo_cntrto, nmro_cntrto ,     cnsctvo_cbrnza
	
	Insert Into    #tmp131B
	Select		a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto ,     a.cnsctvo_cbrnza 
	From		#tmp131A a 
	inner join	#RegistrosClasificar	 b
		on		(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto				=	b.nmro_cntrto
		And		a.cnsctvo_cbrnza			=	b.cnsctvo_cbrnza)
	Where		cnsctvo_cdgo_prntsco		=	5
	Group by a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto ,     a.cnsctvo_cbrnza
	Having count(b.cnsctvo_bnfcro) > 1
	
	update		#RegistrosClasificar 
	Set			grupo	=	131
	From 		#RegistrosClasificar a 
	inner join	#tmp131B b
		on		(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto			=	b.nmro_cntrto
		And		a.cnsctvo_cbrnza		=	b.cnsctvo_cbrnza)
	Where		a.cnsctvo_cdgo_prntsco		=	5
	And			grupo	in	(123,125,127)
	
	--Fin  nuevo 11 de marzo del 2004
	--Septimo proceso
	---Ahora Para el grupo sos
	Insert Into  	#tmp252
	Select  nmro_unco_idntfccn , edd_bnfcro , cnsctvo_cdgo_pln , ps_ss , fcha_aflcn_pc,
			cnsctvo_cdgo_prntsco,cnsctvo_cdgo_tpo_afldo, Dscpctdo, Estdnte,
			Antgdd_hcu , Atrzdo_sn_Ps, grpo_bsco, cnsctvo_cdgo_tpo_cntrto , nmro_cntrto,
			cnsctvo_bnfcro, cnsctvo_cbrnza, grupo, cnsctvo_prdcto, cnsctvo_mdlo, vlr_upc,
			vlr_rl_pgo, cnsctvo_cdgo_tps_cbro, Cobranza_Con_producto,
			Beneficiario_Con_producto,  Con_Modelo,  grupo_tarificacion, igual_plan,
			grupo_modelo, nmro_unco_idntfccn_aprtnte , cnsctvo_scrsl_ctznte ,
			cnsctvo_cdgo_clse_aprtnte, inco_vgnca_cntrto , bnfcdo_pc
	From 	#RegistrosClasificar
	where 	cnsctvo_cdgo_prntsco	=	5
	And		grupo 					= 	252
	And		cnsctvo_cdgo_pln		=	2	
	
	Insert into 	 #tmp252A
	select   cnsctvo_cdgo_tpo_cntrto, nmro_cntrto ,     cnsctvo_cbrnza
	from     #tmp252
	group by cnsctvo_cdgo_tpo_cntrto, nmro_cntrto ,     cnsctvo_cbrnza
	
	Insert Into    #tmp252B
	Select		a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto ,     a.cnsctvo_cbrnza 
	From		#tmp252A a 
	inner join	#RegistrosClasificar	 b
		on		(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto				=	b.nmro_cntrto
		And		a.cnsctvo_cbrnza			=	b.cnsctvo_cbrnza)
	Where		cnsctvo_cdgo_prntsco		=	5
	Group by a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto ,     a.cnsctvo_cbrnza
	Having count(b.cnsctvo_bnfcro) > 1
			
	update		#RegistrosClasificar 
	Set			grupo	=	252
	From 		#RegistrosClasificar a 
	inner join	#tmp252B b
		on		(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto				=	b.nmro_cntrto
		And		a.cnsctvo_cbrnza			=	b.cnsctvo_cbrnza)
	Where		a.cnsctvo_cdgo_prntsco		=	5
	And			grupo	in	(250,254,258)
	
	--octavo proceso
	
	Insert Into  	#tmp254
	Select  nmro_unco_idntfccn , edd_bnfcro , cnsctvo_cdgo_pln , ps_ss , fcha_aflcn_pc,
			cnsctvo_cdgo_prntsco,cnsctvo_cdgo_tpo_afldo, Dscpctdo, Estdnte,
			Antgdd_hcu , Atrzdo_sn_Ps, grpo_bsco, cnsctvo_cdgo_tpo_cntrto , nmro_cntrto,
			cnsctvo_bnfcro, cnsctvo_cbrnza, grupo, cnsctvo_prdcto, cnsctvo_mdlo, vlr_upc,
			vlr_rl_pgo, cnsctvo_cdgo_tps_cbro, Cobranza_Con_producto,
			Beneficiario_Con_producto,  Con_Modelo,  grupo_tarificacion, igual_plan,
			grupo_modelo, nmro_unco_idntfccn_aprtnte , cnsctvo_scrsl_ctznte ,
			cnsctvo_cdgo_clse_aprtnte, inco_vgnca_cntrto , bnfcdo_pc
	From 	#RegistrosClasificar
	where 	cnsctvo_cdgo_prntsco	=	5
	And		grupo 					= 	254
	And		cnsctvo_cdgo_pln		=	2	
	
	Insert into 	 #tmp254A
	select   cnsctvo_cdgo_tpo_cntrto, nmro_cntrto ,     cnsctvo_cbrnza
	from     #tmp254
	group by cnsctvo_cdgo_tpo_cntrto, nmro_cntrto ,     cnsctvo_cbrnza
	
	Insert Into    #tmp254B
	Select		a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto ,     a.cnsctvo_cbrnza 
	From		#tmp254A a	
	inner join	#RegistrosClasificar	 b
		on		(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto				=	b.nmro_cntrto
		And		a.cnsctvo_cbrnza			=	b.cnsctvo_cbrnza)
	Where		cnsctvo_cdgo_prntsco		=	5
	Group by a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto ,     a.cnsctvo_cbrnza
	Having count(b.cnsctvo_bnfcro) > 1
		
	update		#RegistrosClasificar 
	Set			grupo	=	254
	From 		#RegistrosClasificar a 
	inner join	#tmp254B b
		on		(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto				=	b.nmro_cntrto
		And		a.cnsctvo_cbrnza			=	b.cnsctvo_cbrnza)
	Where		a.cnsctvo_cdgo_prntsco		=	5
	And			grupo	in	(250,252,258)
	
	insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(-1,'Paso 4  spTarificacionCalculaTarifaXBeneficiario',Getdate())
		
	--Noveno proceso
	Insert Into  	#tmp258
	Select  nmro_unco_idntfccn , edd_bnfcro , cnsctvo_cdgo_pln , ps_ss , fcha_aflcn_pc,
			cnsctvo_cdgo_prntsco,cnsctvo_cdgo_tpo_afldo, Dscpctdo, Estdnte,
			Antgdd_hcu , Atrzdo_sn_Ps, grpo_bsco, cnsctvo_cdgo_tpo_cntrto , nmro_cntrto,
			cnsctvo_bnfcro, cnsctvo_cbrnza, grupo, cnsctvo_prdcto, cnsctvo_mdlo, vlr_upc,
			vlr_rl_pgo, cnsctvo_cdgo_tps_cbro, Cobranza_Con_producto,
			Beneficiario_Con_producto,  Con_Modelo,  grupo_tarificacion, igual_plan,
			grupo_modelo, nmro_unco_idntfccn_aprtnte , cnsctvo_scrsl_ctznte ,
			cnsctvo_cdgo_clse_aprtnte, inco_vgnca_cntrto , bnfcdo_pc
	From 	#RegistrosClasificar
	where 	cnsctvo_cdgo_prntsco	=	5
	And		grupo 					= 	258
	And		cnsctvo_cdgo_pln		=	2	
	
	Insert into 	 #tmp258A
	select   cnsctvo_cdgo_tpo_cntrto, nmro_cntrto ,     cnsctvo_cbrnza
	from     #tmp258
	group by cnsctvo_cdgo_tpo_cntrto, nmro_cntrto ,     cnsctvo_cbrnza
	
	Insert Into    #tmp258B
	Select		a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto ,     a.cnsctvo_cbrnza 
	From		#tmp258A a 
	inner join  #RegistrosClasificar	 b
		on		(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto				=	b.nmro_cntrto
		And		a.cnsctvo_cbrnza			=	b.cnsctvo_cbrnza)
	Where		cnsctvo_cdgo_prntsco		=	5
	Group by a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto ,     a.cnsctvo_cbrnza
	Having   count(b.cnsctvo_bnfcro) > 1
		
	Update		#RegistrosClasificar 
	Set			grupo	=	258
	From 		#RegistrosClasificar a 
	inner join	#tmp258B b
		on		(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto				=	b.nmro_cntrto
		And		a.cnsctvo_cbrnza			=	b.cnsctvo_cbrnza)
	Where		a.cnsctvo_cdgo_prntsco		=	5
	And			grupo in	(250,252,254)
	
	--decimo proceso	
	--Ahora se hace para sin pos
	Insert Into  	#tmp253
	Select  nmro_unco_idntfccn , edd_bnfcro , cnsctvo_cdgo_pln , ps_ss , fcha_aflcn_pc,
			cnsctvo_cdgo_prntsco,cnsctvo_cdgo_tpo_afldo, Dscpctdo, Estdnte,
			Antgdd_hcu , Atrzdo_sn_Ps, grpo_bsco, cnsctvo_cdgo_tpo_cntrto , nmro_cntrto,
			cnsctvo_bnfcro, cnsctvo_cbrnza, grupo, cnsctvo_prdcto, cnsctvo_mdlo, vlr_upc,
			vlr_rl_pgo, cnsctvo_cdgo_tps_cbro, Cobranza_Con_producto,
			Beneficiario_Con_producto,  Con_Modelo,  grupo_tarificacion, igual_plan,
			grupo_modelo, nmro_unco_idntfccn_aprtnte , cnsctvo_scrsl_ctznte ,
			cnsctvo_cdgo_clse_aprtnte, inco_vgnca_cntrto , bnfcdo_pc
	From 	#RegistrosClasificar
	where 	cnsctvo_cdgo_prntsco	=	5
	And		grupo 					= 	253
	And		cnsctvo_cdgo_pln		=	2	
	
	Insert into 	 #tmp253A
	select   cnsctvo_cdgo_tpo_cntrto, nmro_cntrto ,     cnsctvo_cbrnza
	from     #tmp253
	group by cnsctvo_cdgo_tpo_cntrto, nmro_cntrto ,     cnsctvo_cbrnza
	
	Insert Into    #tmp253B
	Select		a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto ,  a.cnsctvo_cbrnza 
	From		#tmp253A a 
	inner join	#RegistrosClasificar	 b
		on		(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto				=	b.nmro_cntrto
		And		a.cnsctvo_cbrnza			=	b.cnsctvo_cbrnza)
	Where		cnsctvo_cdgo_prntsco		=	5
	Group by a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto ,     a.cnsctvo_cbrnza
	Having count(b.cnsctvo_bnfcro) > 1
		
	update		#RegistrosClasificar 
	Set			grupo	=	253
	From 		#RegistrosClasificar a 
	inner join	#tmp253B b
		on		(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto				=	b.nmro_cntrto
		And		a.cnsctvo_cbrnza			=	b.cnsctvo_cbrnza)
	Where		a.cnsctvo_cdgo_prntsco		=	5
	And			grupo	in	(251,255,259)
	
	--proceso 11
	Insert  Into  	#tmp255
	Select  nmro_unco_idntfccn , edd_bnfcro , cnsctvo_cdgo_pln , ps_ss , fcha_aflcn_pc,
			cnsctvo_cdgo_prntsco,cnsctvo_cdgo_tpo_afldo, Dscpctdo, Estdnte,
			Antgdd_hcu , Atrzdo_sn_Ps, grpo_bsco, cnsctvo_cdgo_tpo_cntrto , nmro_cntrto,
			cnsctvo_bnfcro, cnsctvo_cbrnza, grupo, cnsctvo_prdcto, cnsctvo_mdlo, vlr_upc,
			vlr_rl_pgo, cnsctvo_cdgo_tps_cbro, Cobranza_Con_producto,
			Beneficiario_Con_producto,  Con_Modelo,  grupo_tarificacion, igual_plan,
			grupo_modelo, nmro_unco_idntfccn_aprtnte , cnsctvo_scrsl_ctznte ,
			cnsctvo_cdgo_clse_aprtnte, inco_vgnca_cntrto , bnfcdo_pc
	From 	#RegistrosClasificar
	where 	cnsctvo_cdgo_prntsco	=	5
	And		grupo 					= 	255
	And		cnsctvo_cdgo_pln		=	2	
	
	Insert   into  #tmp255A
	select   cnsctvo_cdgo_tpo_cntrto, nmro_cntrto ,     cnsctvo_cbrnza
	from     #tmp255
	group by cnsctvo_cdgo_tpo_cntrto, nmro_cntrto ,     cnsctvo_cbrnza
	
	Insert Into    #tmp255B
	Select		a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto ,     a.cnsctvo_cbrnza 
	From		#tmp255A a 
	inner join	#RegistrosClasificar	 b
		on		(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto				=	b.nmro_cntrto
		And		a.cnsctvo_cbrnza			=	b.cnsctvo_cbrnza)
	Where		cnsctvo_cdgo_prntsco		=	5
	Group by a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto ,     a.cnsctvo_cbrnza
	Having count(b.cnsctvo_bnfcro) > 1
		
	update		#RegistrosClasificar 
	Set			grupo	=	255
	From 		#RegistrosClasificar a 
	inner join	#tmp255B b
		on		(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto				=	b.nmro_cntrto
		And		a.cnsctvo_cbrnza			=	b.cnsctvo_cbrnza)
	Where		a.cnsctvo_cdgo_prntsco		=	5
	And			grupo	in	(251,253,259)
	
	--proceso 12
	Insert Into  	#tmp259
	Select  nmro_unco_idntfccn , edd_bnfcro , cnsctvo_cdgo_pln , ps_ss , fcha_aflcn_pc,
			cnsctvo_cdgo_prntsco,cnsctvo_cdgo_tpo_afldo, Dscpctdo, Estdnte,
			Antgdd_hcu , Atrzdo_sn_Ps, grpo_bsco, cnsctvo_cdgo_tpo_cntrto , nmro_cntrto,
			cnsctvo_bnfcro, cnsctvo_cbrnza, grupo, cnsctvo_prdcto, cnsctvo_mdlo, vlr_upc,
			vlr_rl_pgo, cnsctvo_cdgo_tps_cbro, Cobranza_Con_producto,
			Beneficiario_Con_producto,  Con_Modelo,  grupo_tarificacion, igual_plan,
			grupo_modelo, nmro_unco_idntfccn_aprtnte , cnsctvo_scrsl_ctznte ,
			cnsctvo_cdgo_clse_aprtnte, inco_vgnca_cntrto , bnfcdo_pc
	From 	#RegistrosClasificar
	where 	cnsctvo_cdgo_prntsco	=	5
	And		grupo 					= 	259
	And		cnsctvo_cdgo_pln		=	2	
	
	Insert into 	 #tmp259A
	select   cnsctvo_cdgo_tpo_cntrto, nmro_cntrto ,     cnsctvo_cbrnza
	from     #tmp259
	group by cnsctvo_cdgo_tpo_cntrto, nmro_cntrto ,     cnsctvo_cbrnza
	
	Insert Into    #tmp259B
	Select		a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto ,     a.cnsctvo_cbrnza 
	From		#tmp259A a 
	inner join	#RegistrosClasificar	 b
		on		(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto				=	b.nmro_cntrto
		And		a.cnsctvo_cbrnza			=	b.cnsctvo_cbrnza)
	Where		cnsctvo_cdgo_prntsco		=	5
	Group by a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto ,     a.cnsctvo_cbrnza
	Having count(b.cnsctvo_bnfcro) > 1
		
	update		#RegistrosClasificar 
	Set			grupo	=	259
	From 		#RegistrosClasificar a 
	inner join	#tmp258B b
		on		(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto				=	b.nmro_cntrto
		And		a.cnsctvo_cbrnza			=	b.cnsctvo_cbrnza)
	Where		a.cnsctvo_cdgo_prntsco		=	5
	And			grupo	in	(251,253,255)
	
	insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(-1,'Paso 5  spTarificacionCalculaTarifaXBeneficiario',Getdate())
	
	--------------------------------------------------------------------------------------
	---Arreglamos los demas 
	--------------------------------------------------------------------------------------
	
	Create Table #tmpAportantesValidar (nmro_unco_idntfccn_aprtnte Int)
	
	Insert Into #tmpAportantesValidar (nmro_unco_idntfccn_aprtnte)
	select		c.nmro_unco_idntfccn_aprtnte  
	from		#RegistrosClasificar a 
	inner join	bdafiliacion.dbo.tbproductoscobranza b
		on		a.nmro_cntrto				= b.nmro_cntrto
		and		a.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
	inner join	bdafiliacion.dbo.tbcobranzas c
		on		b.nmro_cntrto = c.nmro_cntrto
		and		b.cnsctvo_cdgo_tpo_cntrto = c.cnsctvo_cdgo_tpo_cntrto
		and		b.cnsctvo_cbrnza = c.cnsctvo_cbrnza
	where 		@ldFechaEvaluacion between inco_vgnca  and fn_vgnca
	and			b.cnsctvo_prdcto In (24,78)
	and			b.estdo_rgstro = 'S'
	group by	c.nmro_unco_idntfccn_aprtnte
	
	
	------------------------------------------------------------------------------------------------------ 
	
	update 	#RegistrosClasificar
	set 	grupo				=	112
	from 	#RegistrosClasificar 
	where   nmro_unco_idntfccn_aprtnte <> 30052383 
	and		nmro_unco_idntfccn_aprtnte <> 30045798  --compañia de electricidad de tulua, epsa 
	and		nmro_unco_idntfccn_aprtnte not in (select  nmro_unco_idntfccn_aprtnte  
												from #tmpAportantesValidar)	
	and     grupo	in	(355,356,357,358,394,395)
	and 	cnsctvo_cdgo_pln	=	8
	and 	edd_bnfcro 			< 	60
	and 	(ps_ss				=	'S' or Atrzdo_sn_Ps ='S')  
	
	update 	#RegistrosClasificar
	set 	grupo				=	112
	from 	#RegistrosClasificar 
	where   nmro_unco_idntfccn_aprtnte  <> 30052383 
	and		nmro_unco_idntfccn_aprtnte <> 30045798  --compañia de electricidad de tulua, epsa 
	and		nmro_unco_idntfccn_aprtnte not in (select  nmro_unco_idntfccn_aprtnte  
												from #tmpAportantesValidar)
	and     grupo in (355,356, 394)
	and 	edd_bnfcro 			< 	60
	and 	cnsctvo_cdgo_pln	=	8
	and 	(ps_ss				=	'S' )
	
	insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(-1,'Paso 6  spTarificacionCalculaTarifaXBeneficiario',Getdate())
	
	-----------------------------------------------------------------------------------------------------
	update 	#RegistrosClasificar
	set 	grupo				=	114
	from 	#RegistrosClasificar 
	where   nmro_unco_idntfccn_aprtnte <> 30052383 
	and		nmro_unco_idntfccn_aprtnte <> 30045798 --compañia de electricidad de tulua, EPSA 
	and		nmro_unco_idntfccn_aprtnte not in (select  nmro_unco_idntfccn_aprtnte  
												from #tmpAportantesValidar)
	and     grupo				IN	(357,358,404,356,355)
	and 	cnsctvo_cdgo_pln	=	8
	and 	edd_bnfcro 			>= 	60
	and 	(ps_ss				=	'S' or Atrzdo_sn_Ps ='S')  
	and		fcha_aflcn_pc > '19991231'
	
	----------------------------------------------------------------------------------------------------
	
	update 	#RegistrosClasificar
	set 	grupo				=	116 ---Si tiene antiguedad
	from 	#RegistrosClasificar 
	where   nmro_unco_idntfccn_aprtnte <> 30052383 
	and		nmro_unco_idntfccn_aprtnte <> 30045798 
	and		nmro_unco_idntfccn_aprtnte <> 30051350 --compañia de electricidad de tulua, EPSA 
	and		nmro_unco_idntfccn_aprtnte not in (select  nmro_unco_idntfccn_aprtnte  
												from #tmpAportantesValidar)
	and     grupo	IN	(355,356,400)
	and 	cnsctvo_cdgo_pln	=	8
	and 	edd_bnfcro 			>= 	60 
	and		edd_bnfcro			<= 69 ---Entre 60 y 69 Años
	and 	(ps_ss				=	'S' or Atrzdo_sn_Ps ='S')  
	and fcha_aflcn_pc between '19900101' and	'19991231'
	
	insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(-1,'Paso 7  spTarificacionCalculaTarifaXBeneficiario',Getdate())
		
	update 	#RegistrosClasificar
	set 	grupo				=	118
	from 	#RegistrosClasificar 
	where   nmro_unco_idntfccn_aprtnte  <> 	30052383 
	and		nmro_unco_idntfccn_aprtnte <> 30045798  
	and		nmro_unco_idntfccn_aprtnte <> 30051350 --compañia de electricidad de tulua, EPSA 
	and		nmro_unco_idntfccn_aprtnte not in (select  nmro_unco_idntfccn_aprtnte  
													from #tmpAportantesValidar)
	and     grupo	IN	(355,356,401,397,404,401)
	and 	cnsctvo_cdgo_pln	=	8
	and 	(ps_ss				=	'S' or Atrzdo_sn_Ps ='S')  
	and 	edd_bnfcro 			>= 	70                ------- Mas de 70 Años
	and   fcha_aflcn_pc between '19900101' and	'19991231'
	
	insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(-1,'Paso 8  spTarificacionCalculaTarifaXBeneficiario',Getdate())
	
	--------------------------------------------------------------------------------------
	--Para Arreglar Cetsa 
	--------------------------------------------------------------------------------------
	update 	#RegistrosClasificar
	set 	grupo				=	112
	from 	#RegistrosClasificar 
	where   nmro_unco_idntfccn_aprtnte  =	30052383 ---COMPANIA DE ELECTRICIDAD DE TULUA S.A.                                                                                                                                                                  
	and     grupo		in	(357,358,394,395)
	and 	cnsctvo_cdgo_pln			=	8
	and  	cnsctvo_cdgo_clse_aprtnte 	= 	1
	and 	cnsctvo_scrsl_ctznte		=	1
	and 	ps_ss						=	'S'
	
	update 	#RegistrosClasificar
	set 	grupo				=	355
	from 	#RegistrosClasificar 
	where   nmro_unco_idntfccn_aprtnte  =	30052383 ---COMPANIA DE ELECTRICIDAD DE TULUA S.A.                                                                                                                                                                  
	and     grupo	in	(404,114)
	and 	cnsctvo_cdgo_pln			=	8
	and  	cnsctvo_cdgo_clse_aprtnte 	= 	1
	and 	cnsctvo_scrsl_ctznte		=	1
	and 	ps_ss						=	'S'
	
	insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(-1,'Paso 9  spTarificacionCalculaTarifaXBeneficiario',Getdate())
	
	-----------------------------------------------------------------------------------------
	--Para arreglar EPSA 
	-----------------------------------------------------------------------------------------
	update 	#RegistrosClasificar
	set 	grupo				=	357
	from 	#RegistrosClasificar 
	where   nmro_unco_idntfccn_aprtnte  =	30045798 ---EPSA                                                                                                                                                                 
	and     grupo	in	(358,394)
	and  	cnsctvo_cdgo_clse_aprtnte 	= 	1
	and 	cnsctvo_scrsl_ctznte		=	1
	and 	cnsctvo_cdgo_pln			=	8
	and 	ps_ss						=	'S'
	and 	fcha_aflcn_pc				<='20061231' 
	and		inco_vgnca_cntrto			>= '20070101'
	and 	edd_bnfcro					< 60
		
	update 	#RegistrosClasificar
	set 	grupo				=	355
	from 	#RegistrosClasificar 
	where   nmro_unco_idntfccn_aprtnte  =	30045798 ---EPSA                                                                                                                                                                 
	and     grupo		in (356,404,400)
	and  	cnsctvo_cdgo_clse_aprtnte 	= 	1
	and 	cnsctvo_scrsl_ctznte		=	1
	and 	cnsctvo_cdgo_pln			=	8
	and 	ps_ss						=	'S'
	and 	fcha_aflcn_pc				<='20061231' 
	and		inco_vgnca_cntrto			>= '20070101'
	and 	edd_bnfcro					>= 60
	
	update 	#RegistrosClasificar
	set 	grupo				=	358
	from 	#RegistrosClasificar 
	where   nmro_unco_idntfccn_aprtnte  =	30045798 ---EPSA                                                                                                                                                                 
	and     grupo	in (356,404,394)
	and  	cnsctvo_cdgo_clse_aprtnte 	= 	1
	and 	cnsctvo_scrsl_ctznte		=	1
	and 	cnsctvo_cdgo_pln			=	8
	and 	ps_ss						=	'S'
	and		inco_vgnca_cntrto			>= '20070101'
	and 	edd_bnfcro					< 60
	
	insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(-1,'Paso 10  spTarificacionCalculaTarifaXBeneficiario',Getdate())
	
	----------------------------------------------------------------------------------------
	--Fin de adecuacion casdo 355,356,357,358
	----------------------------------------------------------------------------------------
	---Fin Sos
	-----INICIO MODIFICACIONES SERVICIOS AAA
	
	update 	#RegistrosClasificar
	set 	grupo						=	136,
	        grupo_tarificacion			= 2
	from 	#RegistrosClasificar 
	where   nmro_unco_idntfccn_aprtnte  = 33441813
	and     grupo						= 232
	and 	cnsctvo_cdgo_pln			=	2
	and		grpo_bsco					= 'S'
	and 	ps_ss						= 'S' 
	
	update 	#RegistrosClasificar
	set 	grupo						=	122,
	        grupo_tarificacion			= 2
	from 	#RegistrosClasificar 
	where   nmro_unco_idntfccn_aprtnte  = 33441813
	and     grupo						= 218
	and 	cnsctvo_cdgo_pln			=	2
	and 	ps_ss						= 'S' 
	and		edd_bnfcro					< 60
	and		cnsctvo_cdgo_prntsco		= 5
		
	update 	#RegistrosClasificar	
	set 	grupo						=	120
	from 	#RegistrosClasificar 
	where   nmro_unco_idntfccn_aprtnte  = 100631
	and     grupo						= 216
	and 	cnsctvo_cdgo_pln			=	2
	and 	ps_ss						= 'S' 
	and		cnsctvo_cdgo_prntsco  IN (2,4)
	
	--- FIN MODIFICACIONES SERVICIOS AAA
	-----INICIO MODIFICACIONES LLOREDA
	
	update 	#RegistrosClasificar
	set 	grupo						=	392
	from 	#RegistrosClasificar 
	where   nmro_unco_idntfccn_aprtnte  = 30049713
	and     grupo	IN (112,394,395,398)
	and 	cnsctvo_cdgo_pln			=	8
	and 	ps_ss						= 'S' 
	and		edd_bnfcro					< 60
	and		inco_vgnca_cntrto			>= '20120101'
	
	update 	#RegistrosClasificar
	set 	grupo						=	390
	from 	#RegistrosClasificar 
	where   nmro_unco_idntfccn_aprtnte  = 30049713
	and     grupo						IN (112,394)
	and 	cnsctvo_cdgo_pln			=	8
	and 	ps_ss						= 'N' 
	and		edd_bnfcro					< 64
	
	
	insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(-1,'Paso 11  spTarificacionCalculaTarifaXBeneficiario',Getdate())
	
	-----------------------------------------------------------------------------------------------------
	update 	#RegistrosClasificar
	set 	grupo						=	114
	from 	#RegistrosClasificar 
	where   nmro_unco_idntfccn_aprtnte  = 30051350 
	and     grupo				IN	(357,358,404,356,355)
	and 	cnsctvo_cdgo_pln	=	8
	and 	edd_bnfcro 			>= 	60
	and 	(ps_ss				=	'S' or Atrzdo_sn_Ps ='S')  
	and		fcha_aflcn_pc		> '19991231'
	
	----------------------------------------------------------------------------------------------------
	
	update 	#RegistrosClasificar
	set 	grupo				=	116 ---Si tiene antiguedad
	from 	#RegistrosClasificar 
	where   nmro_unco_idntfccn_aprtnte  = 30051350
	and     grupo				IN	(355,356,400)
	and 	cnsctvo_cdgo_pln	=	8
	and 	edd_bnfcro 			>= 	60 
	and		edd_bnfcro			<= 69 ---Entre 60 y 69 Años
	and 	(ps_ss				=	'S' or Atrzdo_sn_Ps ='S')  
	and		fcha_aflcn_pc between '19900101' and	'19991231'
		
	update 	#RegistrosClasificar
	set 	grupo				=	118
	from 	#RegistrosClasificar 
	where   nmro_unco_idntfccn_aprtnte  = 30051350
	and     grupo				IN	(355,356,401,397,404,401)
	and 	cnsctvo_cdgo_pln	=	8
	and 	(ps_ss				=	'S' or Atrzdo_sn_Ps ='S')  
	and 	edd_bnfcro 			>= 	70                ------- Mas de 70 Años
	and		fcha_aflcn_pc between '19900101' and	'19991231'
	
	update 	#RegistrosClasificar
	set 	grupo				=	119
	from 	#RegistrosClasificar 
	where   nmro_unco_idntfccn_aprtnte  	= 30051350
	and     grupo				IN	(355,356,401,397,404,401)
	and 	cnsctvo_cdgo_pln		=	8
	and 	(ps_ss				=	'N'  )  
	and 	edd_bnfcro 			>= 	70                ------- Mas de 70 Años
	and   fcha_aflcn_pc between '19900101' and	'19991231'
	
	insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(-1,'Paso 52  spTarificacionCalculaTarifaXBeneficiario',Getdate())
	
	--SE borran tablas temporales
	
	drop table #tmp253
	drop table #tmp253A
	drop table #tmp253B	
	
	drop table #tmp255
	drop table #tmp255A
	drop table #tmp255B
	
	drop table #tmp259
	drop table #tmp259A
	drop table #tmp259B	
	
	drop table #tmp252
	drop table #tmp252A
	drop table #tmp252B
		
	drop table #tmp254
	drop table #tmp254A
	drop table #tmp254B
	
	drop table #tmp258
	drop table #tmp258A
	drop table #tmp258B
		
	drop table #tmp124
	drop table #tmp124A
	drop table #tmp124B
		
	drop table #tmp126
	drop table #tmp126A
	drop table #tmp126B
	
	drop table #tmp130
	drop table #tmp130A
	drop table #tmp130B
	
	drop table #tmp125
	drop table #tmp125A
	drop table #tmp125B
	
	drop table #tmp127
	drop table #tmp127A
	drop table #tmp127B
	
	drop table #tmp131
	drop table #tmp131A
	drop table #tmp131B

	-- Fecha: 06 de Diciembre del 2018
	-- Descripcion: 
	-- Ajuste:	
	--------------------------------------------------------------------------
	-- Cónyuge menor de 60 años con PBS en SOS
	--------------------------------------------------------------------------
	
	create table #ContarHijos (cnsctvo_cdgo_tpo_cntrto udtConsecutivo, nmro_cntrto udtNumeroFormulario,  hjs int)
	
	create table #ContratosConGrupoBasico (cnsctvo_cdgo_tpo_cntrto udtConsecutivo, nmro_cntrto udtNumeroFormulario)
	
	create table #ContratosConPadres (cnsctvo_cdgo_tpo_cntrto udtConsecutivo, nmro_cntrto udtNumeroFormulario)
	
	insert into #ContarHijos (
			cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,		hjs)
	Select  b.cnsctvo_cdgo_tpo_cntrto,	b.nmro_cntrto,		Count(b.cnsctvo_bnfcro) 
	from 		#RegistrosClasificar a
	inner join	bdafiliacion.dbo.tbBeneficiarios b with(nolock) 
		on		a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto 
		And		a.nmro_cntrto				=	b.nmro_cntrto
	where		b.estdo						=	'A'
	and			@ldFechaEvaluacion between b.inco_vgnca_bnfcro and b.fn_vgnca_bnfcro
	And			b.cnsctvo_cdgo_tpo_afldo	= 3
	And			b.cnsctvo_cdgo_prntsco		= 4
	and			a.edd_bnfcro				< 25
	group by b.cnsctvo_cdgo_tpo_cntrto, b.nmro_cntrto
	
	insert into #ContarHijos (
			cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,		hjs)
	Select  b.cnsctvo_cdgo_tpo_cntrto,	b.nmro_cntrto,		Count(b.cnsctvo_bnfcro) 
	from 		#RegistrosClasificar a
	inner join	bdafiliacion.dbo.tbBeneficiarios b with(nolock) 
		on		a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto 
		And		a.nmro_cntrto				=	b.nmro_cntrto
	left join	#ContarHijos ch 
		on		a.cnsctvo_cdgo_tpo_cntrto	=	ch.cnsctvo_cdgo_tpo_cntrto 
		And		a.nmro_cntrto				=	ch.nmro_cntrto
	where		b.estdo						=	'A'
	and			@ldFechaEvaluacion between b.inco_vgnca_bnfcro and b.fn_vgnca_bnfcro
	And			b.cnsctvo_cdgo_tpo_afldo	= 3
	And			b.cnsctvo_cdgo_prntsco		= 4
	and			a.Dscpctdo					= 'S'
	and			ch.nmro_cntrto is null
	group by b.cnsctvo_cdgo_tpo_cntrto, b.nmro_cntrto
	
	
	insert into #ContratosConGrupoBasico (cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto)
	select cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto
	from #ContarHijos
	
	insert into #ContratosConGrupoBasico (cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto)
	select distinct a.cnsctvo_cdgo_tpo_cntrto,	a.nmro_cntrto
	from 		#RegistrosClasificar a
	left join	#ContratosConGrupoBasico b 
		on		a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto 
		And		a.nmro_cntrto				=	b.nmro_cntrto
	where		a.cnsctvo_cdgo_prntsco		In (2,3)				-- select * From bdAfiliacion.dbo.tbParentescos
	and 		a.cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	and			a.cnsctvo_cdgo_tpo_afldo		= 3
	and			b.nmro_cntrto is null
	
	/*Inserto beneficiarios con numero contrato distinto*/
	insert into #ContratosConGrupoBasico (cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto)
	select distinct a.cnsctvo_cdgo_tpo_cntrto,	a.nmro_cntrto
	from 		#RegistrosClasificar a
	inner join	bdAfiliacion.dbo.tbContratos c with(nolock) 
		on		a.nmro_unco_idntfccn = c.nmro_unco_idntfccn_afldo 
	inner join	bdAfiliacion.dbo.tbBeneficiarios d with(nolock) 
		on		c.cnsctvo_cdgo_tpo_cntrto	=	d.cnsctvo_cdgo_tpo_cntrto 
		And		c.nmro_cntrto			=	d.nmro_cntrto
	left join	#ContratosConGrupoBasico b 
		on		a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto 
		And		a.nmro_cntrto			=	b.nmro_cntrto
	where		a.cnsctvo_cdgo_prntsco		In (1,2,3)				-- select * From bdAfiliacion.dbo.tbParentescos
	and 		a.cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	and			a.cnsctvo_cdgo_tpo_afldo	in (1,3)
	and			c.cnsctvo_cdgo_tpo_cntrto = 2
	and			a.nmro_cntrto <> c.nmro_cntrto
	and			c.estdo_cntrto = 'A'
	and			d.estdo = 'A'
	and			d.nmro_unco_idntfccn_bnfcro <> a.nmro_unco_idntfccn
	and			b.nmro_cntrto is null
	
	insert into #ContratosConPadres (cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto)
	select distinct a.cnsctvo_cdgo_tpo_cntrto,	a.nmro_cntrto
	from 	#RegistrosClasificar a
	where   a.cnsctvo_cdgo_prntsco		In (5)				-- select * From bdAfiliacion.dbo.tbParentescos
	and 	a.cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	and		a.cnsctvo_cdgo_tpo_afldo	= 3 /*select * from bdAfiliacion.dbo.tbTiposAfiliado*/
	
	--------------------------------------------------------------------------
	-- Cónyuge menor de 60 años con PBS en SOS
	--------------------------------------------------------------------------
	
	update 		#RegistrosClasificar
	set 		grupo	=	485										-- Cónyuge menor de 60 años con PBS en SOS
	from 		#RegistrosClasificar a
	left join	#ContarHijos b 
		on		a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto 
		and		a.nmro_cntrto = b.nmro_cntrto
	where		grupo						= 120					-- Grupo Conyuge e hijos  con POS			Select a.* from tbDetGrupos a Where	cnsctvo_cdgo_grpo = 2 And dscrpcn_dtlle_grpo Like '%conyug%'
	And			edd_bnfcro					< 60
	and 		ps_ss						= 'S'					-- POS en SOS
	and			cnsctvo_cdgo_prntsco		In (2,3)				-- select * From bdAfiliacion.dbo.tbParentescos
	and 		cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	and			cnsctvo_cdgo_tpo_afldo		= 3						-- BENEFICIARIO								Select * From bdAfiliacion.dbo.tbTiposAfiliado
	and			b.nmro_cntrto			is null

	--------------------------------------------------------------------------
	-- Cónyuge mayor de 60 años con PBS en SOS
	--------------------------------------------------------------------------
	
	update 	#RegistrosClasificar
	set 	grupo	=	486										-- Cónyuge mayor de 60 años con PBS en SOS
	from 	#RegistrosClasificar a
	left join #ContarHijos b on a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = b.nmro_cntrto
	where   grupo						= 120					-- Grupo Conyuge e hijos  con POS			Select a.* from tbDetGrupos a Where	cnsctvo_cdgo_grpo = 2 And dscrpcn_dtlle_grpo Like '%conyug%'
	And		edd_bnfcro					>= 60
	and 	ps_ss						= 'S'					-- POS en SOS
	and		cnsctvo_cdgo_prntsco		In (2,3)				-- select * From bdAfiliacion.dbo.tbParentescos
	and 	cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	and		cnsctvo_cdgo_tpo_afldo		= 3						-- BENEFICIARIO								Select * From bdAfiliacion.dbo.tbTiposAfiliado
	and		b.nmro_cntrto			is null
	
	
	
	--------------------------------------------------------------------------
	-- Cónyuge menor de 60 sin PBS en SOS
	--------------------------------------------------------------------------
	
	update 	#RegistrosClasificar
	set 	grupo	=	487										-- Cónyuge menor de 60 años con PBS en SOS
	from 	#RegistrosClasificar a
	left join #ContarHijos b on a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = b.nmro_cntrto
	where   grupo						= 121					-- Grupo Conyuge e hijos  Sin POS 			Select a.* from tbDetGrupos a Where	cnsctvo_cdgo_grpo = 2 And dscrpcn_dtlle_grpo Like '%conyug%'
	And		edd_bnfcro					< 60
	and 	ps_ss						= 'N'					-- POS en SOS
	and		cnsctvo_cdgo_prntsco		In (2,3)				-- select * From bdAfiliacion.dbo.tbParentescos
	and 	cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	and		cnsctvo_cdgo_tpo_afldo		= 3						-- BENEFICIARIO								Select * From bdAfiliacion.dbo.tbTiposAfiliado
	and		b.nmro_cntrto			is null
	
	
	--------------------------------------------------------------------------
	-- Cónyuge menor de 60 sin PBS en SOS
	--------------------------------------------------------------------------
	
	update 	#RegistrosClasificar
	set 	grupo	=	488										-- Cónyuge menor de 60 años con PBS en SOS
	from 	#RegistrosClasificar a
	left join #ContarHijos b on a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = b.nmro_cntrto
	where   grupo						= 121					-- Grupo Conyuge e hijos  Sin POS 			Select a.* from tbDetGrupos a Where	cnsctvo_cdgo_grpo = 2 And dscrpcn_dtlle_grpo Like '%conyug%'
	And		edd_bnfcro					>= 60
	and 	ps_ss						= 'N'					-- POS en SOS
	and		cnsctvo_cdgo_prntsco		In (2,3)				-- select * From bdAfiliacion.dbo.tbParentescos
	and 	cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	and		cnsctvo_cdgo_tpo_afldo		= 3						-- BENEFICIARIO								Select * From bdAfiliacion.dbo.tbTiposAfiliado
	and		b.nmro_cntrto			is null
	
	
	--------------------------------------------------------------------------------
	-- Si tiene hijo se asiga el grupo 120
	--------------------------------------------------------------------------------
	
	-- Caso 1
	update 	#RegistrosClasificar
	set 	grupo	=	120										-- Cónyuge menor de 60 años con PBS en SOS
	-- Select *
	from 	#RegistrosClasificar a
	inner join #ContarHijos b on a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = b.nmro_cntrto
	where   grupo						in (485,486)
	and		cnsctvo_cdgo_tpo_afldo		= 3	
	
	-- Caso 2
	update 	#RegistrosClasificar
	set 	grupo	=	121										-- Cónyuge menor de 60 años con PBS en SOS
	-- Select *
	from 	#RegistrosClasificar a
	inner join #ContarHijos b on a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = b.nmro_cntrto
	where   grupo						in (487,488)
	and		cnsctvo_cdgo_tpo_afldo		= 3	
	
	
	
	-- Caso Propal
	update 	#RegistrosClasificar
	set 	grupo	=	216										-- Grupo Conyuge e hijos  con POS 
	-- Select *
	from 	#RegistrosClasificar a
	inner join #ContarHijos b on a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = b.nmro_cntrto
	where   grupo						in (525,526)
	and		cnsctvo_cdgo_tpo_afldo		= 3	
	
	-- Caso 2
	update 	#RegistrosClasificar
	set 	grupo	=	217										-- Grupo Conyuge e hijos  Sin POS 
	-- Select *
	from 	#RegistrosClasificar a
	inner join #ContarHijos b on a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = b.nmro_cntrto
	where   grupo						in (527,528)
	and		cnsctvo_cdgo_tpo_afldo		= 3	
	
	
	--------------------------------------------------------------------------
	-- Cotizante 
	--------------------------------------------------------------------------
	/*
	136  	Trabajador (cotizante) con Grupo  Con pos
	Trabajador (cotizante) menor de 60 años con Grupo Con PBS		493
	*/
	update 	#RegistrosClasificar
	set 	grupo	=	493										
	from 	#RegistrosClasificar a
	inner join #ContratosConGrupoBasico b on a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = b.nmro_cntrto
	where   a.grupo						= 136
	And		a.edd_bnfcro					< 60
	and 	a.ps_ss						= 'S'					-- POS en SOS
	and 	a.cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	
	update 	#RegistrosClasificar
	set 	grupo	=	493										
	from 	#RegistrosClasificar a
	inner join #ContratosConPadres b on a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = b.nmro_cntrto
	where   a.grupo						= 136
	And		a.edd_bnfcro					< 60
	and 	a.ps_ss						= 'S'					-- POS en SOS
	and 	a.cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	
	/*
	Trabajador (cotizante) mayor de 60 años con Grupo Con PBS		494
	*/
	
	update 	#RegistrosClasificar
	set 	grupo	=	494										
	from 	#RegistrosClasificar a
	inner join #ContratosConGrupoBasico b on a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = b.nmro_cntrto
	where   a.grupo						= 136
	And		a.edd_bnfcro					>= 60
	and 	a.ps_ss						= 'S'					-- POS en SOS
	and 	a.cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	
	update 	#RegistrosClasificar
	set 	grupo	=	494										
	from 	#RegistrosClasificar a
	inner join #ContratosConPadres b on a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = b.nmro_cntrto
	where   a.grupo						= 136
	And		a.edd_bnfcro					>= 60
	and 	a.ps_ss						= 'S'					-- POS en SOS
	and 	a.cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	
	/*
	522  	Trabajador mayor de 60 años sin grupo basico con PBS en SOS
	*/
	update 	#RegistrosClasificar
	set 	grupo	=	522										
	from 	#RegistrosClasificar a
	left join #ContratosConGrupoBasico b on a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = b.nmro_cntrto
	where   a.grupo						= 136
	And		a.edd_bnfcro					>= 60
	and 	a.ps_ss						= 'S'					-- POS en SOS
	and 	a.cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	and		b.nmro_cntrto is null
	and		a.grupo_tarificacion = 8
	/*
	521  	Trabajador menor de 60 años sin grupo basico con PBS en SOS
	*/
	update 	#RegistrosClasificar
	set 	grupo	=	521										
	from 	#RegistrosClasificar a
	left join #ContratosConGrupoBasico b on a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = b.nmro_cntrto
	where   a.grupo						= 136
	And		a.edd_bnfcro					< 60
	and 	a.ps_ss						= 'S'					-- POS en SOS
	and 	a.cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	and		b.nmro_cntrto is null
	and		a.grupo_tarificacion = 8
	/*
	524  	Trabajador mayor de 60 años sin grupo basico sin PBS en SOS
	*/
	update 	#RegistrosClasificar
	set 	grupo	=	524										
	from 	#RegistrosClasificar a
	left join #ContratosConGrupoBasico b on a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = b.nmro_cntrto
	where   a.grupo						= 137
	And		a.edd_bnfcro					>= 60
	and 	a.ps_ss						= 'N'					-- POS en SOS
	and 	a.cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	and		b.nmro_cntrto is null
	and		a.grupo_tarificacion = 8
	/*
	523  	Trabajador menor de 60 años sin grupo basico sin PBS en SOS
	*/
	update 	#RegistrosClasificar
	set 	grupo	=	523										
	from 	#RegistrosClasificar a
	left join #ContratosConGrupoBasico b on a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = b.nmro_cntrto
	where   a.grupo						= 137
	And		a.edd_bnfcro					< 60
	and 	a.ps_ss						= 'N'					-- POS en SOS
	and 	a.cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	and		b.nmro_cntrto is null
	and		a.grupo_tarificacion = 8
	/*
	137  	Trabajador (cotizante) con Grupo  Sin pos
	Trabajador (cotizante) menor de 60 años con Grupo Sin PBS		495
	*/
	update 	#RegistrosClasificar
	set 	grupo	=	495										
	from 	#RegistrosClasificar a
	inner join #ContratosConGrupoBasico b on a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = b.nmro_cntrto
	where   a.grupo						= 137
	And		a.edd_bnfcro					< 60
	and 	a.ps_ss						= 'N'					-- POS en SOS
	and 	a.cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	
	update 	#RegistrosClasificar
	set 	grupo	=	495										
	from 	#RegistrosClasificar a
	inner join #ContratosConPadres b on a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = b.nmro_cntrto
	where   a.grupo						= 137
	And		a.edd_bnfcro					< 60
	and 	a.ps_ss						= 'N'					-- POS en SOS
	and 	a.cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	
	/*
	Trabajador (cotizante) mayor de 60 años con Grupo Sin PBS		496
	*/
	
	update 	#RegistrosClasificar
	set 	grupo	=	496										
	from 	#RegistrosClasificar a
	inner join #ContratosConGrupoBasico b on a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = b.nmro_cntrto
	where   a.grupo						= 137
	And		a.edd_bnfcro					>= 60
	and 	a.ps_ss						= 'N'					-- POS en SOS
	and 	a.cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	
	update 	#RegistrosClasificar
	set 	grupo	=	496										
	from 	#RegistrosClasificar a
	inner join #ContratosConPadres b on a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = b.nmro_cntrto
	where   a.grupo						= 137
	And		a.edd_bnfcro					>= 60
	and 	a.ps_ss						= 'N'					-- POS en SOS
	and 	a.cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	
	/*
	200  	Trabajador Sin Grupo Basico  Con Pos
	Trabajador menor de 60 años sin grupo básico Con Pos		489
	*/
	
	update 	#RegistrosClasificar
	set 	grupo	=	489										
	from 	#RegistrosClasificar a
	left join #ContratosConGrupoBasico b on a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = b.nmro_cntrto
	left join #ContratosConPadres c on a.cnsctvo_cdgo_tpo_cntrto = c.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = c.nmro_cntrto
	where   a.grupo						in (200,437)
	And		a.edd_bnfcro					< 60
	and 	a.ps_ss						= 'S'					-- POS en SOS
	and 	a.cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	and		a.cnsctvo_cdgo_tpo_afldo = 1
	and		b.nmro_cntrto is null
	and		c.nmro_cntrto is null
	--and		a.nmro_unco_idntfccn_aprtnte <> 100003
	/*
	Trabajador mayor de 60 años sin grupo básico Con Pos		490
	*/
	
	update 	#RegistrosClasificar
	set 	grupo	=	490										
	from 	#RegistrosClasificar a
	left join #ContratosConGrupoBasico b on a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = b.nmro_cntrto
	left join #ContratosConPadres c on a.cnsctvo_cdgo_tpo_cntrto = c.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = c.nmro_cntrto
	where   a.grupo						in (200,437)
	And		a.edd_bnfcro					>= 60
	and 	a.ps_ss						= 'S'					-- POS en SOS
	and 	a.cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	and		a.cnsctvo_cdgo_tpo_afldo = 1
	and		b.nmro_cntrto is null
	and		c.nmro_cntrto is null
	--and		a.nmro_unco_idntfccn_aprtnte <> 100003
	
	update 	#RegistrosClasificar
	set 	grupo	=	490										
	from 	#RegistrosClasificar a
	left join #ContratosConGrupoBasico b on a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = b.nmro_cntrto
	left join #ContratosConPadres c on a.cnsctvo_cdgo_tpo_cntrto = c.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = c.nmro_cntrto
	where   a.grupo						= 136
	And		a.edd_bnfcro					>= 60
	and 	a.ps_ss						= 'S'					-- POS en SOS
	and 	a.cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	and		a.cnsctvo_cdgo_tpo_afldo = 1
	and		b.nmro_cntrto is null
	and		c.nmro_cntrto is null
	/*
	201  	Trabajador Sin Grupo Basico Sin Pos
	Trabajador menor de 60 años sin grupo básico Sin Pos		491
	*/
	
	update 	#RegistrosClasificar
	set 	grupo	=	491										
	from 	#RegistrosClasificar a
	left join #ContratosConGrupoBasico b on a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = b.nmro_cntrto
	left join #ContratosConPadres c on a.cnsctvo_cdgo_tpo_cntrto = c.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = c.nmro_cntrto
	where   /*a.grupo						= 201
	And		*/a.edd_bnfcro					< 60
	and 	a.ps_ss						= 'N'					-- POS en SOS
	and 	a.cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	and		a.cnsctvo_cdgo_tpo_afldo = 1
	and		b.nmro_cntrto is null
	and		c.nmro_cntrto is null
	
	/*
	Trabajador mayor de 60 años sin grupo básico Sin Pos		492
	*/
	update 	#RegistrosClasificar
	set 	grupo	=	492									
	from 	#RegistrosClasificar a
	left join #ContratosConGrupoBasico b on a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = b.nmro_cntrto
	left join #ContratosConPadres c on a.cnsctvo_cdgo_tpo_cntrto = c.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = c.nmro_cntrto
	where   /*a.grupo						= 201
	And		*/a.edd_bnfcro				>= 60
	and 	a.ps_ss						= 'N'					-- POS en SOS
	and 	a.cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	and		a.cnsctvo_cdgo_tpo_afldo = 1
	and		b.nmro_cntrto is null
	and		c.nmro_cntrto is null
	
	/*
	248  	Grupo Conyuge e hijos  con POS
	497  	Conyuge menor de 60 años con PBS en SOS
	*/
	update 	#RegistrosClasificar
	set 	grupo	=	497									
	from 	#RegistrosClasificar a
	where   a.grupo						= 248
	And		a.edd_bnfcro				< 60
	and 	a.ps_ss						= 'S'					-- POS en SOS
	and		cnsctvo_cdgo_prntsco		In (2,3)				-- select * From bdAfiliacion.dbo.tbParentescos
	and 	cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	and		cnsctvo_cdgo_tpo_afldo		= 3						-- BENEFICIARIO								Select * From bdAfiliacion.dbo.tbTiposAfiliado
	
	/*
	498  	Conyuge mayor de 60 años con PBS en SOS
	*/
	update 	#RegistrosClasificar
	set 	grupo	=	498									
	from 	#RegistrosClasificar a
	where   a.grupo						= 248
	And		a.edd_bnfcro				>= 60
	and 	a.ps_ss						= 'S'					-- POS en SOS
	and		cnsctvo_cdgo_prntsco		In (2,3)				-- select * From bdAfiliacion.dbo.tbParentescos
	and 	cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	and		cnsctvo_cdgo_tpo_afldo		= 3						-- BENEFICIARIO								Select * From bdAfiliacion.dbo.tbTiposAfiliado
	
	--------------------------------------------------------------------------------
	-- Si tiene hijo
	--------------------------------------------------------------------------------
	
	-- Caso 1
	update 	#RegistrosClasificar
	set 	grupo	=	248										-- Cónyuge menor de 60 años con PBS en SOS
	-- Select *
	from 	#RegistrosClasificar a
	inner join #ContarHijos b on a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = b.nmro_cntrto
	where   grupo						in (498,497)
	and		cnsctvo_cdgo_tpo_afldo		= 3
	/*
	249  	Grupo Conyuge e hijos  Sin POS 
	499  	Conyuge menor de 60 años sin PBS en SOS
	*/
	update 	#RegistrosClasificar
	set 	grupo	=	499									
	from 	#RegistrosClasificar a
	where   a.grupo						= 249
	And		a.edd_bnfcro				< 60
	and 	a.ps_ss						= 'N'					-- POS en SOS
	and		cnsctvo_cdgo_prntsco		In (2,3)				-- select * From bdAfiliacion.dbo.tbParentescos
	and 	cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	and		cnsctvo_cdgo_tpo_afldo		= 3						-- BENEFICIARIO								Select * From bdAfiliacion.dbo.tbTiposAfiliado
	
	/*
	500  	Conyuge mayor de 60 años sin PBS en SOS
	*/
	update 	#RegistrosClasificar
	set 	grupo	=	500									
	from 	#RegistrosClasificar a
	where   a.grupo						= 249
	And		a.edd_bnfcro				>= 60
	and 	a.ps_ss						= 'N'					-- POS en SOS
	and		cnsctvo_cdgo_prntsco		In (2,3)				-- select * From bdAfiliacion.dbo.tbParentescos
	and 	cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	and		cnsctvo_cdgo_tpo_afldo		= 3						-- BENEFICIARIO								Select * From bdAfiliacion.dbo.tbTiposAfiliado
	
	--------------------------------------------------------------------------------
	-- Si tiene hijo
	--------------------------------------------------------------------------------
	
	-- Caso 1
	update 	#RegistrosClasificar
	set 	grupo	=	249										-- Cónyuge menor de 60 años con PBS en SOS
	-- Select *
	from 	#RegistrosClasificar a
	inner join #ContarHijos b on a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = b.nmro_cntrto
	where   grupo						in (499,500)
	and		cnsctvo_cdgo_tpo_afldo		= 3
	/*
	260  	Grupo Beneficiarios Adicionales con POS 
	501  	beneficiarios Adicionales con PBS menor de 60 años
	*/
	update 	#RegistrosClasificar
	set 	grupo	=	501									
	from 	#RegistrosClasificar a
	where   a.grupo						= 260
	And		a.edd_bnfcro				< 60
	and 	a.ps_ss						= 'S'					-- POS en SOS
	and 	a.cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	and		a.cnsctvo_cdgo_tpo_afldo	in (3,4)						-- BENEFICIARIO								Select * From bdAfiliacion.dbo.tbTiposAfiliado
	and		a.Dscpctdo					= 'N'
	
	
	/*
	502  	beneficiarios Adicionales con PBS mayor de 60 años
	*/
	update 	#RegistrosClasificar
	set 	grupo	=	502									
	from 	#RegistrosClasificar a
	where   a.grupo						= 260
	And		a.edd_bnfcro				>= 60
	and 	a.ps_ss						= 'S'					-- POS en SOS
	and 	cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	and		a.cnsctvo_cdgo_tpo_afldo	in (3,4)						-- BENEFICIARIO								Select * From bdAfiliacion.dbo.tbTiposAfiliado
	and		a.Dscpctdo					= 'N'
	/*
	261  	Grupo Beneficiarios Adicionales Sin POS
	503  	beneficiarios Adicionales sin PBS menor de 60 años
	*/
	update 	#RegistrosClasificar
	set 	grupo	=	503									
	from 	#RegistrosClasificar a
	where   a.grupo						= 261
	And		a.edd_bnfcro				< 60
	and 	a.ps_ss						= 'N'					-- POS en SOS
	and 	cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	and		a.cnsctvo_cdgo_tpo_afldo	in (3,4)						-- BENEFICIARIO								Select * From bdAfiliacion.dbo.tbTiposAfiliado
	and		a.Dscpctdo					= 'N'
	/*
	504  	beneficiarios Adicionales sin PBS mayor de 60 años
	*/
	update 	#RegistrosClasificar
	set 	grupo	=	504								
	from 	#RegistrosClasificar a
	where   a.grupo						= 261
	And		a.edd_bnfcro				>= 60
	and 	a.ps_ss						= 'N'					-- POS en SOS
	and 	cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	and		a.cnsctvo_cdgo_tpo_afldo	in (3,4)						-- BENEFICIARIO								Select * From bdAfiliacion.dbo.tbTiposAfiliado
	and		a.Dscpctdo					= 'N'
	
	/*
	266  	Conyuge o Compañera(o) Cotizante  Con  Pos 
	505  	Conyuge o Compañera(o) Cotizante menor de 60 años Con PBS en SOS
	*/
	update 	#RegistrosClasificar
	set 	grupo	=	505								
	from 	#RegistrosClasificar a
	where   a.grupo						= 266
	And		a.edd_bnfcro				< 60
	and 	a.ps_ss						= 'S'					-- POS en SOS
	and		cnsctvo_cdgo_prntsco		In (2,3)				-- select * From bdAfiliacion.dbo.tbParentescos
	and 	cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	and		cnsctvo_cdgo_tpo_afldo		= 2
	
	
	/*
	506  	Conyuge o Compañera(o) Cotizante mayor de 60 años Con PBS en SOS
	*/
	update 	#RegistrosClasificar
	set 	grupo	=	506							
	from 	#RegistrosClasificar a
	where   a.grupo						= 266
	And		a.edd_bnfcro				>= 60
	and 	a.ps_ss						= 'S'					-- POS en SOS
	and		cnsctvo_cdgo_prntsco		In (2,3)				-- select * From bdAfiliacion.dbo.tbParentescos
	and 	cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	and		cnsctvo_cdgo_tpo_afldo		= 2
	
	/*
	267  	Conyuge o Compañera(o) Cotizante  Sin  Pos
	507  	Conyuge o Compañera(o) Cotizante menor de 60 años Sin PBS en SOS
	*/
	update 	#RegistrosClasificar
	set 	grupo	=	507						
	from 	#RegistrosClasificar a
	where   a.grupo						= 267
	And		a.edd_bnfcro				< 60
	and 	a.ps_ss						= 'N'					-- POS en SOS
	and		cnsctvo_cdgo_prntsco		In (2,3)				-- select * From bdAfiliacion.dbo.tbParentescos
	and 	cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	
	/*
	508  	Conyuge o Compañera(o) Cotizante mayor de 60 años Sin PBS en SOS
	*/
	update 	#RegistrosClasificar
	set 	grupo	=	508						
	from 	#RegistrosClasificar a
	where   a.grupo						= 267
	And		a.edd_bnfcro				>= 60
	and 	a.ps_ss						= 'N'					-- POS en SOS
	and		cnsctvo_cdgo_prntsco		In (2,3)				-- select * From bdAfiliacion.dbo.tbParentescos
	and 	cnsctvo_cdgo_pln			In (2,6)				-- 2=Familiar y 6=Quimbaya					Select * From bdPlanBeneficios.dbo.tbPlanes
	
	
	update 	#RegistrosClasificar
	set 	grupo	=	212						
	from 	#RegistrosClasificar a
	inner join BDAfiliacion.dbo.tbBeneficiarios b with(nolock) on a.nmro_unco_idntfccn = b.nmro_unco_idntfccn_bnfcro 
	where   a.grupo						= 202
	And		a.edd_bnfcro				< 25
	and 	a.ps_ss						= 'S'					-- POS en SOS
	and		a.cnsctvo_cdgo_prntsco		In (4)				-- select * From bdAfiliacion.dbo.tbParentescos
	and 	a.cnsctvo_cdgo_pln			In (8)				-- 8=Bienestar				Select * From bdPlanBeneficios.dbo.tbPlanes
	and		a.Dscpctdo					= 'N'
	and		b.estdo = 'A'
	and		b.cnsctvo_cdgo_tpo_cntrto = 1
	and		b.cnsctvo_cdgo_tpo_afldo = 1
	
	update 	#RegistrosClasificar
	set 	grupo	=	120						
	from 	#RegistrosClasificar a
	where   a.grupo						= 413
	and 	a.cnsctvo_cdgo_pln			In (2,6)
	and		a.cnsctvo_cdgo_tpo_afldo	in (3)						-- BENEFICIARIO								Select * From bdAfiliacion.dbo.tbTiposAfiliado
	and		a.grupo_tarificacion = 17
	
	update 	#RegistrosClasificar
	set 	grupo	=	493  /*Trabajador (cotizante) menor de 60 años con Grupo Con PBS*/						
	from 	#RegistrosClasificar a
	inner join #ContratosConGrupoBasico b on a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = b.nmro_cntrto
	where   a.grupo						= 435 /*Trabajador (cotizante) con Grupo  Con pos*/
	And		a.edd_bnfcro				< 60
	and 	a.ps_ss						= 'S'					-- POS en SOS
	and 	a.cnsctvo_cdgo_pln			In (2,6)
	and		a.grupo_tarificacion = 17
	and		cnsctvo_cdgo_tpo_afldo		= 1
	
	update 	#RegistrosClasificar
	set 	grupo	=	494  /*Trabajador (cotizante) mayor de 60 años con Grupo Con PBS*/						
	from 	#RegistrosClasificar a
	inner join #ContratosConGrupoBasico b on a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = b.nmro_cntrto
	where   a.grupo						= 435 /*Trabajador (cotizante) con Grupo  Con pos*/
	And		a.edd_bnfcro				>= 60
	and 	a.ps_ss						= 'S'					-- POS en SOS
	and 	a.cnsctvo_cdgo_pln			In (2,6)
	and		a.grupo_tarificacion = 17
	and		cnsctvo_cdgo_tpo_afldo		= 1
	
	update 	#RegistrosClasificar
	set 	grupo	=	495  /*Trabajador (cotizante) menor de 60 años con Grupo Sin PBS*/						
	from 	#RegistrosClasificar a
	inner join #ContratosConGrupoBasico b on a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = b.nmro_cntrto
	where   a.grupo						= 436 /*Trabajador (cotizante) con Grupo  Con pos*/
	And		a.edd_bnfcro				< 60
	and 	a.ps_ss						= 'N'					-- POS en SOS
	and 	a.cnsctvo_cdgo_pln			In (2,6)
	and		a.grupo_tarificacion = 17
	and		cnsctvo_cdgo_tpo_afldo		= 1
	
	
	update 	#RegistrosClasificar
	set 	grupo	=	496  /*Trabajador (cotizante) mayor de 60 años con Grupo Sin PBS*/						
	from 	#RegistrosClasificar a
	inner join #ContratosConGrupoBasico b on a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto and a.nmro_cntrto = b.nmro_cntrto
	where   a.grupo						= 436 /*Trabajador (cotizante) con Grupo  Con pos*/
	And		a.edd_bnfcro				>= 60
	and 	a.ps_ss						= 'N'					-- POS en SOS
	and 	a.cnsctvo_cdgo_pln			In (2,6)
	and		a.grupo_tarificacion = 17
	and		cnsctvo_cdgo_tpo_afldo		= 1
	
	/*ADICIONALES*/
	/*
	132  	Beneficiarios Adicionales con POS 
	477  	Beneficiarios Adicionales con PBS Menores de 60 años
	*/
	update 	#RegistrosClasificar
	set 	grupo	=	477  /*477  	Beneficiarios Adicionales con PBS Menores de 60 años*/						
	from 	#RegistrosClasificar a
	where   a.grupo						= 132 /*Beneficiarios Adicionales con POS */
	And		a.edd_bnfcro				< 60
	and 	a.ps_ss						= 'S'					-- POS en SOS
	and 	a.cnsctvo_cdgo_pln			In (2,6)
	
	
	update 	#RegistrosClasificar
	set 	grupo	=	478  /*Beneficiarios Adicionales con PBS Mayores de 60 años*/						
	from 	#RegistrosClasificar a
	where   a.grupo						= 132 /*Beneficiarios Adicionales con POS */
	And		a.edd_bnfcro				>= 60
	and 	a.ps_ss						= 'S'					-- POS en SOS
	and 	a.cnsctvo_cdgo_pln			In (2,6)
	
	update 	#RegistrosClasificar
	set 	grupo	=	479  /*Beneficiarios Adicionales sin PBS Menores de 60 años*/						
	from 	#RegistrosClasificar a
	where   a.grupo						= 133 /*Beneficiarios Adicionales SIN POS */
	And		a.edd_bnfcro				>= 60
	and 	a.ps_ss						= 'N'					-- POS en SOS
	and 	a.cnsctvo_cdgo_pln			In (2,6)
	
	
	update 	#RegistrosClasificar
	set 	grupo	=	480  /*Beneficiarios Adicionales sin PBS Mayores de 60 años*/						
	from 	#RegistrosClasificar a
	where   a.grupo						= 133 /*Beneficiarios Adicionales SIN POS */
	And		a.edd_bnfcro				>= 60
	and 	a.ps_ss						= 'N'					-- POS en SOS
	and 	a.cnsctvo_cdgo_pln			In (2,6)
	
	update 	#RegistrosClasificar
	set 	grupo	=	355  /*Persona mayor de 60 años con POS en SOS afiliada hasta 20061231*/						
	from 	#RegistrosClasificar a
	where   a.grupo						= 356 /*Persona mayor de 60 años con POS en SOS fecha real de contrato mayor o igual 20070101*/
	And		a.edd_bnfcro				>= 60
	and 	a.ps_ss						= 'S'					-- POS en SOS
	and 	a.cnsctvo_cdgo_pln			In (8)

	
	-- trae la informacion de las cobranzas que tiene productos
	Insert into	#tmpProductosCobranza
	Select		a.cnsctvo_prdcto_cbrnza,
				a.cnsctvo_cdgo_tpo_cntrto,
				a.nmro_cntrto,
				a.cnsctvo_cbrnza,
				a.cnsctvo_prdcto_scrsl,
				a.cnsctvo_prdcto,
				a.inco_vgnca,
				a.fn_vgnca,
				a.estdo_rgstro
	From		bdafiliacion.dbo.tbProductosCobranza a 
	inner join  #RegistrosClasificar b
		on		(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto			=	b.nmro_cntrto
		And		a.cnsctvo_cbrnza		=	b.cnsctvo_cbrnza)
	Where		convert(varchar(10), @ldFechaEvaluacion,111) between convert(varchar(10),a.inco_vgnca,111)  and	convert(varchar(10),a.fn_vgnca,111) -- que sea el siguiente del periodo a evaluar
	and			a.estdo_rgstro		=	'S'
		
	insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(-1,'Paso 53  spTarificacionCalculaTarifaXBeneficiario',Getdate())
			
	delete from #tmpProductosCobranza where cnsctvo_prdcto = 1 or cnsctvo_prdcto = 0
	
	If  @@error <> 0
	Begin 			
		Return -1
	end
	
	
	--Se actualiza los cobranzas que tiene  productos
	Update		#RegistrosClasificar
	Set			Cobranza_Con_producto		=	1
	From		#tmpProductosCobranza		a 
	inner join  #RegistrosClasificar b
		on		(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto			=	b.nmro_cntrto
		And		a.cnsctvo_cbrnza		=	b.cnsctvo_cbrnza)
		
	If  @@error <> 0
	Begin 			
		Return -1
	end
	
	insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(-1,'Paso 54  spTarificacionCalculaTarifaXBeneficiario',Getdate())
		
	--Actualiza los beneficiarios que tiene productos
	Update 		#RegistrosClasificar
	Set			cnsctvo_prdcto			=	c.cnsctvo_prdcto,
				Beneficiario_Con_producto	=	1
	From		#RegistrosClasificar a 
	inner join  bdafiliacion.dbo.tbProductosxBeneficiario b 
		on     (a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto			=	b.nmro_cntrto
		And		a.cnsctvo_bnfcro		=	b.cnsctvo_bnfcro
		And		a.cnsctvo_cbrnza		=	b.cnsctvo_cbrnza) 
	inner join	#tmpProductosCobranza c
		on		(b.cnsctvo_prdcto_cbrnza		=	c.cnsctvo_prdcto_cbrnza	)
	Where		convert(varchar(10), @ldFechaEvaluacion	,111) 	between convert(varchar(10),b.inco_vgnca,111)   and	convert(varchar(10),b.fn_vgnca,111) -- que sea el siguiente del periodo a evaluar
	And			b.estdo_rgstro		=	'S'
	
	If  @@error <> 0
	Begin 			
		Return -1
	end
	
	insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(-1,'Paso 55  spTarificacionCalculaTarifaXBeneficiario',Getdate())
	
	-- clase modelo de tarifas..	
	Insert into 	#tmpModelosAsociadosxProducto	
	select		b.cnsctvo_cdgo_tpo_cntrto,
				b.nmro_cntrto,
				b.cnsctvo_bnfcro,
				b.cnsctvo_cbrnza,
				a.cnsctvo_prdcto,
				a.cnsctvo_mdlo,
				a.cnsctvo_cdgo_clse_mdlo,
				a.inco_vgnca_asccn,
				a.fn_vgnca_asccn,
				a.fcha_uso_mdlo,    
				b.fcha_aflcn_pc,
				0	Estado                                       
	from 		bdplanbeneficios.dbo.tbDetproductos a 
	inner join	#RegistrosClasificar b
		on		(a.cnsctvo_prdcto		=	b.cnsctvo_prdcto)
	where 		a.cnsctvo_cdgo_clse_mdlo	=	6	
	And	( 	 (Convert(varchar(10), @ldFechaEvaluacion	,111) 	between convert(varchar(10),a.inco_vgnca_asccn,111)       and	convert(varchar(10),a.fn_vgnca_asccn,111) )
		or 	 (Convert(varchar(10), @ldFechaEvaluacion	,111) 	between convert(varchar(10),a.fcha_uso_mdlo,111)       and	convert(varchar(10),a.inco_vgnca_asccn,111) )
		)
	
	If  @@error <> 0
	Begin 		
		Return -1
	end
	
	insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(-1,'Paso 56  spTarificacionCalculaTarifaXBeneficiario',Getdate())
		
	--Se actualiza  para aquellos productos que solamente tienen un solo registro a evaluar
	update	#tmpModelosAsociadosxProducto
	Set		Estado	=	1
	From	#tmpModelosAsociadosxProducto a , (Select   cnsctvo_cdgo_tpo_cntrto,
														nmro_cntrto,
														cnsctvo_bnfcro,
														cnsctvo_cbrnza,
														cnsctvo_prdcto ,count(*)	Cantidad_Productos
												From	#tmpModelosAsociadosxProducto
												group by cnsctvo_cdgo_tpo_cntrto,
													    nmro_cntrto,
													    cnsctvo_bnfcro,
													    cnsctvo_cbrnza,
													    cnsctvo_prdcto
												Having	count(*)=1 ) tmpCantidadProductos1
	Where	a.cnsctvo_prdcto		=	tmpCantidadProductos1.cnsctvo_prdcto
	And	a.cnsctvo_cdgo_tpo_cntrto	=	tmpCantidadProductos1.cnsctvo_cdgo_tpo_cntrto
	And	a.nmro_cntrto				=	tmpCantidadProductos1.nmro_cntrto
	And	a.cnsctvo_bnfcro			=	tmpCantidadProductos1.cnsctvo_bnfcro
	And	a.cnsctvo_cbrnza			=	tmpCantidadProductos1.cnsctvo_cbrnza						    
							  
	If  @@error <> 0
	Begin 		
		Return -1
	end
	
	insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(-1,'Paso 57  spTarificacionCalculaTarifaXBeneficiario',Getdate())
	
	--Se crea una tabla temporal que contiene todos los productos que tiene mas de un modelo
	Insert into	 #tmpModelosMayorUno
	select  cnsctvo_cdgo_tpo_cntrto,
			nmro_cntrto,
			cnsctvo_bnfcro,
			cnsctvo_cbrnza,
			cnsctvo_prdcto,
			cnsctvo_mdlo,
			cnsctvo_cdgo_clse_mdlo,
			inco_vgnca_asccn,
			fn_vgnca_asccn,
			fcha_uso_mdlo,    
			fcha_aflcn_pc,
			0	Estado1,
			0	Estado2,
			'N'	brrdo
	From	#tmpModelosAsociadosxProducto
	where 	Estado	=	0
	
	If  @@error <> 0
	Begin 			
		Return -1
	end
	
	insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(-1,'Paso 58  spTarificacionCalculaTarifaXBeneficiario',Getdate())
		
	--Se actualiza el modelo que que esta vigente al sistema
	update	#tmpModelosMayorUno
	Set		Estado1		=	1
	Where	convert(varchar(10),@ldFechaEvaluacion ,111) 	between convert(varchar(10),inco_vgnca_asccn,111)       and	convert(varchar(10),fn_vgnca_asccn,111) 
		
	If  @@error <> 0
	Begin 		
		Return -1
	end

	--Se actualiza  el registro si se requiere utilizar el modelo donde el incio del contrato sea mayor que
	--la fecha de uso y no este vigente para el sistema
	update	#tmpModelosMayorUno
	Set		Estado2		=	1
	Where	fcha_aflcn_pc >=  fcha_uso_mdlo
	and		Estado1		=	0	

	If  @@error <> 0
	Begin 		
		Return -1
	end
	
	--Se marcan los modelos que no se actualizaron con el fin de contemplarlos para el proceso
	update	#tmpModelosMayorUno
	Set		brrdo		=	'S'
	Where	Estado1	=	0 
	and		Estado2 = 0
	
	If  @@error <> 0
	Begin 	
		Return -1
	end
	
	insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(-1,'Paso 59  spTarificacionCalculaTarifaXBeneficiario',Getdate())
		
	--se actualiza  el registro para aquellos modelos que cumplen con las dos condiciones
	--pero se requiere qel que el estado2 sea igual  a cero es decir que no es vigente para el sistema
	--pwero si vigente para el uso
	
	update #tmpModelosMayorUno
	Set	brrdo	=	'S'
	From	#tmpModelosMayorUno a, (Select   cnsctvo_cdgo_tpo_cntrto,
											nmro_cntrto,
											cnsctvo_bnfcro,
			 								cnsctvo_cbrnza,
											cnsctvo_prdcto , count(*) Cantidad_Modelos
			 						From	#tmpModelosMayorUno
			 						Where   brrdo	=	'N'
			 						Group by cnsctvo_cdgo_tpo_cntrto,
											nmro_cntrto,
											cnsctvo_bnfcro,
					 						cnsctvo_cbrnza,
											cnsctvo_prdcto
									Having	count(*)> 1 ) tmpBorrados
	Where	a.cnsctvo_prdcto		=	tmpBorrados.cnsctvo_prdcto
	And	a.cnsctvo_cdgo_tpo_cntrto	=	tmpBorrados.cnsctvo_cdgo_tpo_cntrto
	And	a.nmro_cntrto				=	tmpBorrados.nmro_cntrto
	And	a.cnsctvo_bnfcro			=	tmpBorrados.cnsctvo_bnfcro
	And	a.cnsctvo_cbrnza			=	tmpBorrados.cnsctvo_cbrnza
	And	a.Estado2					=	0
		
	If  @@error <> 0
	Begin 			
		Return -1
	end
		
	insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(-1,'Paso 60  spTarificacionCalculaTarifaXBeneficiario',Getdate())
	
	
	--Se actualiza el modelo que re requiere para que aquellos que tenia mas de 1 modelo
	--para su evaluacion
	
	Update		#tmpModelosAsociadosxProducto
	Set			Estado	=	1
	From		#tmpModelosAsociadosxProducto a 
	inner join	#tmpModelosMayorUno b
		on		(a.cnsctvo_prdcto			=	b.cnsctvo_prdcto
		And		a.cnsctvo_mdlo				=	b.cnsctvo_mdlo
		And		a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto				=	b.nmro_cntrto
		And		a.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro
		And		a.cnsctvo_cbrnza			=	b.cnsctvo_cbrnza)
	Where		a.Estado					=	0
	And			b.brrdo						=	'N'
	
	If  @@error <> 0
	Begin 	
		Return -1
	end
	
	insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(-1,'Paso 61 spTarificacionCalculaTarifaXBeneficiario',Getdate())
		
	--Se actualiza el modelo final del producto para cada beneficiario
	
	Update		#RegistrosClasificar
	Set			cnsctvo_mdlo	=	b.cnsctvo_mdlo,
				Con_Modelo		=	1
	From		#RegistrosClasificar a 
	inner join	#tmpModelosAsociadosxProducto b
		on     (a.cnsctvo_prdcto			=	b.cnsctvo_prdcto
		And		a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto				=	b.nmro_cntrto
		And		a.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro
		And		a.cnsctvo_cbrnza			=	b.cnsctvo_cbrnza)
	Where		b.Estado					=	1
		
	If  @@error <> 0
	Begin 
		Return -1
	end
	
	insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(-1,'Paso 62 spTarificacionCalculaTarifaXBeneficiario',Getdate())
	
	--Actualiza el campo si corresponde el mismo plan para el modelo
	
	Update		#RegistrosClasificar
	Set			igual_Plan	=	1
	From		#RegistrosClasificar a 
	inner join  bdplanbeneficios.dbo.tbmodelos b
		on     (a.cnsctvo_mdlo		=	b.cnsctvo_mdlo
		And		a.cnsctvo_cdgo_pln	=	b.cnsctvo_cdgo_pln)
	
	If  @@error <> 0
	Begin 
		Return -1
	end
	
	-- cnsctvo_cdgo_frma_dscnto	=	3 valor
	-- cnsctvo_cdgo_frma_dscnto	=	4 porcentaje
	
	--Se actualiza el valor real pagado y el tipo de cobro
	update		#RegistrosClasificar
	Set			vlr_rl_pgo				=	case when cnsctvo_cdgo_frma_dscnto = 3 then (b.vlr - b.vlr_dscnto) else  (b.vlr  - ( convert(numeric(12,2),b.vlr) * convert(numeric(12,2),b.vlr_dscnto) / 100)) end,
	 			cnsctvo_cdgo_tps_cbro	=       b.cnsctvo_cdgo_tps_cbro ,
				grupo_modelo			=	1 
	From		#RegistrosClasificar	 a  
	inner join  bdplanBeneficios.dbo.tbDetModeloTarifas b with(nolock)
		on     (a.cnsctvo_mdlo	=	b.cnsctvo_mdlo
		And		a.grupo		=	b.cnsctvo_cdgo_grpo_trfro)
		
	If  @@error <> 0
	Begin 		
		Return -1
	end
	
	insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(-1,'Paso 63 spTarificacionCalculaTarifaXBeneficiario',Getdate())
	
	---Nuevo requrimiento verificar a los parentescos hijos cuando salgan de grupo basico los cobre como adicional
	--siempre y cuando esten como cotizantes del pos
	-- 30834
	Insert into 	#tmpContratoPosCotizantes
	Select   nmro_unco_idntfccn
	From 	bdafiliacion.dbo.tbbeneficiarios a,  #RegistrosClasificar b 
	Where 	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn
	And		convert(varchar(10),@ldFechaEvaluacion,111) 	between convert(varchar(10),inco_vgnca_bnfcro,111)       and	convert(varchar(10),fn_vgnca_bnfcro,111) 
	And		a.cnsctvo_cdgo_tpo_cntrto	=	1
	And		a.cnsctvo_cdgo_tpo_afldo	=	1
	And		a.estdo						=	'A'
	And		b.ps_ss						= 	'S'	       -- que tengan pos	
	And		b.cnsctvo_cdgo_prntsco		=	4	       --parentesco hijos	
	And		b.cnsctvo_cdgo_tpo_afldo	=	3	       --sean beneficiarios del pac
	And		b.cnsctvo_cdgo_tps_cbro		=	8	        --y sea grupal		
	Group by nmro_unco_idntfccn
	--aqui estdo
	
	insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(-1,'Paso 64 spTarificacionCalculaTarifaXBeneficiario',Getdate())
	
	
	-- Se actualiza la modalidad de cobro para esos beneficiarios que estan grupales y ahora se cobran como individuales
	Update	#RegistrosClasificar
	Set		cnsctvo_cdgo_tps_cbro	=       7		-- Se pasan a individual
	From	#RegistrosClasificar  a inner join  #tmpContratoPosCotizantes b
		on	(a.nmro_unco_idntfccn	=	b.nmro_unco_idntfccn)
	Where   (a.cnsctvo_cdgo_pln = 2 or a.cnsctvo_cdgo_pln = 6)    --solo familiar o quimbaya
	And		a.ps_ss						= 	'S'	       -- que tengan pos	
	And		a.cnsctvo_cdgo_prntsco		=	4	       --parentesco hijos
	And		a.cnsctvo_cdgo_tpo_afldo	=	3	       --sean beneficiarios del pac
	And		a.cnsctvo_cdgo_tps_cbro		=	8	        --y sea grupal		
	
	-- cnsctvo_cdgo_tps_cbro	=	7	-individual
	-- cnsctvo_cdgo_tps_cbro	=	8	-Grupal

	--Se crea una tabla temporal con la informacion agrupada por grupo para cada cobranza de cada contrato
	--Porque pueden haber muchos grupos dentro de la misma cobranza
	Insert into	#tmpValoresGrupales
	select  cnsctvo_cdgo_tpo_cntrto, nmro_cntrto,  cnsctvo_cbrnza,vlr_rl_pgo ,grupo, min (cnsctvo_bnfcro) cnsctvo_bnfcro
	From	 #RegistrosClasificar
	Where	cnsctvo_cdgo_tps_cbro	=	8
	group by cnsctvo_cdgo_tpo_cntrto, nmro_cntrto,  cnsctvo_cbrnza,vlr_rl_pgo ,grupo

	If  @@error <> 0
	Begin 		
		Return -1
	end

	insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(-1,'Paso 65 spTarificacionCalculaTarifaXBeneficiario',Getdate())

	--Se actualiza el valor para los individuales
	Update	#RegistrosClasificar
	Set		vlr_upc	=	vlr_rl_pgo
	where	cnsctvo_cdgo_tps_cbro	=	7

	If  @@error <> 0
	Begin 
		Return -1
	end


	--Se actualiza el valor para cada contrato perteneciente a su grupo
	Update		#RegistrosClasificar
	Set			vlr_upc	=	b.vlr_rl_pgo
	From		#RegistrosClasificar a 
	inner join  #tmpValoresGrupales b
		on     (a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto			=	b.nmro_cntrto
		And		a.cnsctvo_cbrnza		=	b.cnsctvo_cbrnza
		And		a.cnsctvo_bnfcro		=	b.cnsctvo_bnfcro
		And		a.grupo					=	b.grupo)
	Where		a.cnsctvo_cdgo_tps_cbro			=	8


	If  @@error <> 0
	Begin 		
		Return -1
	end

	drop 	table	#tmpModelosAsociadosxProducto
	Drop	table	#tmpModelosMayorUno

end