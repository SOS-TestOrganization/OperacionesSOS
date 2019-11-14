/*---------------------------------------------------------------------------------------------------------------------------------------
* Procedimiento			: spGenerarReliquidacionDeFacturasPorPlanYContrato
* Desarrollado por		: <\A	Francisco E. Riaño L - Qvision SA	A\>
* Descripción			: <\D	Realizar la liquidacion de las facturas nuevamente con el fin de comprobar correctitud de valores D\>
* Observaciones			: <\O	O\>
* Parámetros			: <\P  	P\>
* Variables				: <\V  	V\>
* Fecha Creación		: <\FC	2019-10-02 FC\>
*
*---------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------------------------------------------------------------
* Modificado Por			: <\AM	AM\>
* Descripción				: <\DM	DM\>
* Nuevos Parámetros			: <\PM	PM\>
* Nuevas Variables			: <\VM	VM\>
* Fecha Modificación		: <\FM	FM\>
*-----------------------------------------------------------------------------------------------------------------------------------*/
--exec [spGenerarReliquidacionDeFacturasPorPlanYContrato] '94525889', 8, '0'       
CREATE procedure [dbo].[spGenerarReliquidacionDeFacturasPorPlanYContrato]
(
	@numeroEstadoCuenta		varchar(20),
	@consecutivoCodigoPlan	int,
	@nmroContrato			varchar(20)
)
as
begin
	set nocount on;

	declare		@fechaCorte								datetime,
				@lndiasdesafiliacion					int,
				@lcControlaError						udtConsecutivo	= 0,
				@fechaSistema							datetime		= getdate(),
				@consecutivoLiquidacion					int,
				@consecutivoCodigoPeriodoLiquidacion	int,
				@consecutivoCodigoTipoNota_Debito		smallint		= 1,
				@consecutivoCodigoTipoNota_Credito		smallint		= 2,
				@consecutivoConceptoLiquidacion_Iva		smallint		= 3,
				@descripcionConceptoLiquidacion_Iva		varchar(5)		= 'IVA';
	create 
	table	#tmpDetalleFacturas
	(
			cnsctvo_estdo_cnta			int,
			nmro_estdo_cnta				nvarchar(15),
			dscrpcn_prdo_lqdcn			nvarchar(150),
			vlr_cbrdo					udtValorGrande,
			ttl_pgr						udtValorGrande,
			cnsctvo_cdgo_cncpto_lqdcn	udtConsecutivo,
			dscrpcn_cncpto_lqdcn		nvarchar(150),
			cnsctvo_cdgo_pln			udtConsecutivo,
			dscrpcn_pln					nvarchar(150),
			dscrpcn_tpo_nta				varchar(150),
			ttl_dfrnca					udtValorGrande,
			cnsctvo_cdgo_tpo_cntrto		int,
			nmro_cntrto					varchar(20),
			nmro_unco_idntfccn_empldr	udtConsecutivo,
			nmbre_empldr				varchar(300),
			nmro_unco_idntfccn_bnfcro	udtConsecutivo,
			nmbre_bnfcro				varchar(300),
			nmro_idntfccn				udtNumeroIdentificacionLargo,
			nmro_idntfccn_bnfcro		udtNumeroIdentificacionLargo,
			cnsctvo_scrsl udtConsecutivo,
			cnsctvo_cdgo_clse_aprtnte udtConsecutivo,
			cnsctvo_cdgo_prdo_lqdcn udtConsecutivo,
			sldo_estdo_cnta udtValorGrande
	);

	Create 
	table	#Tmpcontratos
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
	);

	create 
	table	#tmpEstadosDeCuentaConContrato
	(
			cnsctvo_estdo_cnta			udtConsecutivo,
			cnsctvo_cdgo_tpo_cntrto		int,	
			nmro_cntrto					varchar(20)
	);

	create 
	table	#TmpContratosPac
	(
			cnsctvo_cdgo_tpo_cntrto		int,
			nmro_cntrto					varchar(20),
			cnsctvo_cdgo_pln			int,
			inco_vgnca_cntrto           datetime,
			fn_vgnca_cntrto				datetime,
			nmro_unco_idntfccn_afldo	int,
			Estado						int
	);

	Create 
	table	#RegistrosClasificarFinal
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
			antgdd_clptra				char(1),
			cnsctvo_estdo_cnta			int
	);	

	Create
	table	#tmpBeneficiarios
	(
			ID_Num						int identity(1,1), 
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
			fn_vgnca					datetime,
			cnsctvo_estdo_cnta			int
	);

	Create
	table	#tmpBeneficiariosActivos   
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
	);

	Create
	table	#tmpVigenciasCobranzasPac
	(
			cnsctvo_vgnca_cbrnza		int,
			inco_vgnca_cbrnza			datetime,
			fn_vgnca_cbrnza				datetime,
			cta_mnsl					numeric(12,0),
			cnsctvo_cdgo_tpo_cntrto		int,
			nmro_cntrto					varchar(20),
			cnsctvo_cbrnza				int,
			cnsctvo_scrsl_ctznte		int
	);

	create
	table	#tmpCobranzasPac	
	(
			cnsctvo_cdgo_tpo_cntrto		int,
			nmro_cntrto					varchar(20),
			cnsctvo_cbrnza				int,
			nmro_unco_idntfccn_aprtnte	int,
			cnsctvo_cdgo_clse_aprtnte	int,
			cnsctvo_cdgo_prdcdd_prpgo	int,
			lsto_fcttr					int 
	);

	Create 
	table	#tmpBeneficiariosEstadoActivos
	(
			cnsctvo_cdgo_tpo_cntrto		int,
			nmro_cntrto					varchar(20),
			cnsctvo_bnfcro				int,
			nmro_unco_idntfccn_bnfcro	int,
			cnsctvo_cdgo_estdo_bfcro	int,
			Suspendido					int
	);

	Create 
	table	#tmpHistoricoEstadosBeneficiario 
	(
			cnsctvo_cdgo_tpo_cntrto		int,
			nmro_cntrto					varchar(20),
			cnsctvo_bnfcro				int,
			nmro_unco_idntfccn_bnfcro	int,
			cnsctvo_cdgo_estdo_bfcro	int
	);

	create 
	table	#tmpBeneficiariosEstadoSuspendidos
	(
			cnsctvo_cdgo_tpo_cntrto		int,
			nmro_cntrto					varchar(20),
			cnsctvo_bnfcro				int,
			nmro_unco_idntfccn_bnfcro	int,
			cnsctvo_cdgo_estdo_bfcro	int
	);

	Create 
	table	#tmpContratosSuspenConUnacuota
					(
					cnsctvo_cdgo_tpo_cntrto		int,
					nmro_cntrto					varchar(20)
					);

	Create 
	table	#tmpSaldoContratoResponsable
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
					);

	Create 
	table	#tmpEstadosCuentaContratos
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
					);	

	select top 1		@consecutivoLiquidacion = a.cnsctvo_cdgo_lqdcn,
						@consecutivoCodigoPeriodoLiquidacion = b.cnsctvo_cdgo_prdo_lqdcn
	from				dbo.tbEstadosCuenta a with(nolock)
	inner join			dbo.tbLiquidaciones b with(nolock)
	on					a.cnsctvo_cdgo_lqdcn = b.cnsctvo_cdgo_lqdcn
	where				a.nmro_estdo_cnta = @numeroEstadoCuenta;
	
	select top 1		@fechaCorte = convert(date,fcha_incl_prdo_lqdcn,103) 
	from				BDCarteraPAC.dbo.tbPeriodosliquidacion_Vigencias with(nolock)
	where				cnsctvo_cdgo_prdo_lqdcn = @consecutivoCodigoPeriodoLiquidacion;

	exec				dbo.spObtenerEstadosCuentaYContratos @numeroEstadoCuenta,@fechaCorte,@consecutivoCodigoPlan;
	exec				dbo.spCalcularSaldosResponsablesDePago @fechaCorte;
	exec				dbo.spObtenerBeneficiariosAFacturar @fechaCorte;	
	exec				dbo.spTarificaLiquidacionPrevia	@fechaSistema,	@consecutivoLiquidacion , @lcControlaError output;

	IF(isnull(@nmroContrato,'0') != '0')
	Begin
		insert into		#tmpDetalleFacturas
						(
						cnsctvo_estdo_cnta,
						nmro_estdo_cnta,
						nmro_cntrto,
						cnsctvo_cdgo_tpo_cntrto,
						vlr_cbrdo,
						nmro_unco_idntfccn_bnfcro			
						)
		select			a.cnsctvo_estdo_cnta,					
						ltrim(rtrim(b.nmro_estdo_cnta)) as nmro_estdo_cnta,
						a.nmro_cntrto,
						a.cnsctvo_cdgo_tpo_cntrto,
						a.vlr_upc / 1.05,
						a.nmro_unco_idntfccn_bnfcro
		from			#tmpBeneficiarios a
		inner join		dbo.tbEstadosCuenta b with(nolock)
			on			b.cnsctvo_estdo_cnta = a.cnsctvo_estdo_cnta
		where			a.nmro_cntrto = @nmroContrato
	End
	Else
	Begin
		insert into		#tmpDetalleFacturas
						(
						cnsctvo_estdo_cnta,
						nmro_estdo_cnta,
						nmro_cntrto,
						cnsctvo_cdgo_tpo_cntrto,
					    vlr_cbrdo,
						nmro_unco_idntfccn_bnfcro			
						)
		select			a.cnsctvo_estdo_cnta,					
						ltrim(rtrim(b.nmro_estdo_cnta)) as nmro_estdo_cnta,
						a.nmro_cntrto,
						a.cnsctvo_cdgo_tpo_cntrto,
						a.vlr_upc / 1.05,
						a.nmro_unco_idntfccn_bnfcro
		from			#tmpBeneficiarios a
		inner join		dbo.tbEstadosCuenta b with(nolock)
			on			b.cnsctvo_estdo_cnta = a.cnsctvo_estdo_cnta
	End
	
	update				a
	set					a.dscrpcn_prdo_lqdcn = ltrim(rtrim(c.dscrpcn_prdo_lqdcn)),
						a.nmro_unco_idntfccn_empldr = z.nmro_unco_idntfccn_empldr,
						a.cnsctvo_scrsl = z.cnsctvo_scrsl,
						a.cnsctvo_cdgo_clse_aprtnte = z.cnsctvo_cdgo_clse_aprtnte,
						a.sldo_estdo_cnta = z.sldo_estdo_cnta,
						a.cnsctvo_cdgo_prdo_lqdcn = b.cnsctvo_cdgo_prdo_lqdcn
	from				#tmpDetalleFacturas a 
	inner join			dbo.tbEstadosCuenta z with(nolock)
	on					z.cnsctvo_estdo_cnta = a.cnsctvo_estdo_cnta
	inner join			dbo.tbLiquidaciones b with(nolock)
	on					z.cnsctvo_cdgo_lqdcn = b.cnsctvo_cdgo_lqdcn
	inner join			dbo.tbPeriodosliquidacion_Vigencias c with(nolock)
	on					b.cnsctvo_cdgo_prdo_lqdcn = c.cnsctvo_cdgo_prdo_lqdcn;

	update				a
	set					a.cnsctvo_cdgo_pln = d.cnsctvo_cdgo_pln,
						a.dscrpcn_pln = d.dscrpcn_pln,
						a.nmro_unco_idntfccn_empldr = c.nmro_unco_idntfccn_afldo,
						a.nmro_idntfccn = e.nmro_idntfccn,
						a.nmbre_empldr = ltrim(rtrim(f.prmr_nmbre))+' '+ltrim(rtrim(f.sgndo_nmbre))+' '+ltrim(rtrim(f.prmr_aplldo))+' '+ltrim(rtrim(f.sgndo_aplldo))
	from				#tmpDetalleFacturas a
	inner join			dbo.tbEstadosCuentaContratos b with(nolock)
	on					a.cnsctvo_estdo_cnta = b.cnsctvo_estdo_cnta
	and					a.nmro_cntrto = b.nmro_cntrto
	and					a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto
	inner join			BDAfiliacion.dbo.tbContratos c with(nolock)
	on					b.nmro_cntrto = c.nmro_cntrto
	and					b.cnsctvo_cdgo_tpo_cntrto = c.cnsctvo_cdgo_tpo_cntrto 
	inner join			BDProcesoBdd.dbo.tbPlanes_Vigencias d with(nolock)
	on					c.cnsctvo_cdgo_pln = d.cnsctvo_cdgo_pln	
	inner join			BDAfiliacion.dbo.tbVinculados e with(nolock)
	on					c.nmro_unco_idntfccn_afldo = e.nmro_unco_idntfccn
	inner join			BDAfiliacion.dbo.tbPersonas f with(nolock)
	on					f.nmro_unco_idntfccn = e.nmro_unco_idntfccn
	where				@fechaSistema between d.inco_vgnca and d.fn_vgnca

	update				a
	set					a.nmro_idntfccn_bnfcro = e.nmro_idntfccn,
						a.nmbre_bnfcro = ltrim(rtrim(f.prmr_nmbre))+' '+ltrim(rtrim(f.sgndo_nmbre))+' '+ltrim(rtrim(f.prmr_aplldo))+' '+ltrim(rtrim(f.sgndo_aplldo))
	from				#tmpDetalleFacturas a
	inner join			BDAfiliacion.dbo.tbVinculados e with(nolock)
	on					a.nmro_unco_idntfccn_bnfcro = e.nmro_unco_idntfccn
	inner join			BDAfiliacion.dbo.tbPersonas f with(nolock)
	on					f.nmro_unco_idntfccn = e.nmro_unco_idntfccn

	update				a
	set					a.dscrpcn_cncpto_lqdcn = c.dscrpcn_cncpto_lqdcn,
						a.cnsctvo_cdgo_cncpto_lqdcn = c.cnsctvo_cdgo_cncpto_lqdcn
	from				#tmpDetalleFacturas a
	inner join			BDCarteraPAC.dbo.tbConceptosLiquidacion_Vigencias c with(nolock)
	on					c.cnsctvo_cdgo_pln = a.cnsctvo_cdgo_pln
	where				c.cnsctvo_cdgo_tpo_mvmnto = 1
	and					@fechaSistema between c.inco_vgnca and c.fn_vgnca;

	select				vlr_rl_pgo as vlr_rl_pgo,
						cnsctvo_estdo_cnta,
						nmro_cntrto,
						cnsctvo_cdgo_tpo_cntrto
	into				#tmpRegistrosClasificarFinal
	from				#RegistrosClasificarFinal;

	--update				a
	--set					vlr_cbrdo =	case	cnsctvo_cdgo_tpo_nta 
	--									when @consecutivoCodigoTipoNota_Debito then a.vlr_cbrdo + b.vlr 
	--									when @consecutivoCodigoTipoNota_Credito then a.vlr_cbrdo - b.vlr 
	--									else a.vlr_cbrdo
	--								end 
	--from				#tmpDetalleFacturas a
	--inner join			dbo.tbNotasEstadoCuenta b
	--on					a.cnsctvo_estdo_cnta = b.cnsctvo_estdo_cnta

	update				a
	set					a.ttl_dfrnca = a.vlr_cbrdo - b.vlr_rl_pgo
	from				#tmpDetalleFacturas a
	inner join			#tmpRegistrosClasificarFinal b
	on					a.nmro_cntrto = b.nmro_cntrto
	and					a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto
	and					a.cnsctvo_estdo_cnta = b.cnsctvo_estdo_cnta

	select				cnsctvo_estdo_cnta,
						nmro_estdo_cnta,
						dscrpcn_prdo_lqdcn,
						vlr_cbrdo * 0.05 as vlr_cbrdo,
						ttl_pgr as ttl_pgr,
						3 as cnsctvo_cdgo_cncpto_lqdcn,
						'IVA' as dscrpcn_cncpto_lqdcn,
						cnsctvo_cdgo_pln,
						dscrpcn_pln,						
						isnull(ttl_dfrnca,0) as ttl_dfrnca,
						'' as dscrpcn_tpo_nta,
						0 as cnsctvo_cdgo_tpo_nta,
						nmro_unco_idntfccn_empldr,
						nmro_idntfccn,
						nmbre_empldr,
						cnsctvo_cdgo_tpo_cntrto,
						nmro_cntrto,
						nmro_unco_idntfccn_bnfcro,
						nmbre_bnfcro,
						nmro_idntfccn_bnfcro,
						nmro_cntrto,
						cnsctvo_scrsl,
						cnsctvo_cdgo_clse_aprtnte,
						cnsctvo_cdgo_prdo_lqdcn,
						sldo_estdo_cnta
	from				#tmpDetalleFacturas	
	union
	select				cnsctvo_estdo_cnta,
						nmro_estdo_cnta,
						dscrpcn_prdo_lqdcn,
						vlr_cbrdo as vlr_cbrdo,
						ttl_pgr as ttl_pgr,
						cnsctvo_cdgo_cncpto_lqdcn,
						dscrpcn_cncpto_lqdcn,
						cnsctvo_cdgo_pln,
						dscrpcn_pln,						
						isnull(case when ttl_dfrnca < 0 then ttl_dfrnca * -1 else ttl_dfrnca end,0) as ttl_dfrnca,
						dscrpcn_tpo_nta =  (
											case 
												when isnull(ttl_dfrnca,0) < 0 then 'Credito' 
												when isnull(ttl_dfrnca,0) > 0 then 'Debito' 
												else 'N/A' 
											end
											),
						cnsctvo_cdgo_tpo_nta =  
											(
											case 
												when isnull(ttl_dfrnca,0) < 0 then @consecutivoCodigoTipoNota_Credito
												when isnull(ttl_dfrnca,0) > 0 then @consecutivoCodigoTipoNota_Debito
												else 0
											end
											),
						nmro_unco_idntfccn_empldr,
						nmro_idntfccn,
						nmbre_empldr,
						cnsctvo_cdgo_tpo_cntrto,
						nmro_cntrto,
						nmro_unco_idntfccn_bnfcro,
						nmbre_bnfcro,
						nmro_idntfccn_bnfcro,
						nmro_cntrto,
						cnsctvo_scrsl,
						cnsctvo_cdgo_clse_aprtnte,
						cnsctvo_cdgo_prdo_lqdcn,
						sldo_estdo_cnta
	from				#tmpDetalleFacturas
	
	--select * from	#tmpRegistrosClasificarFinal	#RegistrosClasificarFinal
	--select * from	  #tmpDetalleFacturas

						
end
