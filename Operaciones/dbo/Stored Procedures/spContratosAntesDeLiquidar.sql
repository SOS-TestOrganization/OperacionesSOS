/*---------------------------------------------------------------------------------
* Metodo o PRG			:  spContratosAntesDeLiquidar
* Desarrollado por		: <\A Ing. Jean Paul Villaquiran Madrigal A\> 
* Descripcion			: <\D Sp que se encarga de insertar los datos sufientes para liquidacion D\>
* Observaciones			: <\O O\>
* Parametros			: <\P P\>
* Variables				: <\VV\>
* Fecha Creacion		: <\FC 2019/05/02 FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM	AM\>
* Descripcion			: <\DM	DM\>
* Nuevos Parametros		: <\PM	PM\>
* Nuevas Variables		: <\VM	VM\>
* Fecha Modificacion	: <\FM FM\>
*---------------------------------------------------------------------------------
* Scritp's de pruebas
*---------------------------------------------------------------------------------

--------------------------------------------------------------------------------*/
CREATE procedure dbo.spContratosAntesDeLiquidar
(
	@numeroEstadoCuenta			int,
	@fechaCorte					datetime,
	@fechaInicialFacturacion	datetime
)
as
begin
		set nocount on;

		
		-- se traen todos los contratos qe se van a liquidar con los contratos del cliente
		Insert	
		Into		#Tmpcontratos_Antes_liquidar
					(
					cnsctvo_cdgo_tpo_cntrto,	
					nmro_cntrto,
					cnsctvo_cdgo_pln,		
					inco_vgnca_cntrto,
					fn_vgnca_cntrto,		
					nmro_unco_idntfccn_afldo,
					cnsctvo_cbrnza,		
					nmro_unco_idntfccn_aprtnte,
					cnsctvo_vgnca_cbrnza,		
					cnsctvo_scrsl_ctznte,
					inco_vgnca_cbrnza,		
					fn_vgnca_cbrnza,
					cta_mnsl,			
					cnsctvo_cdgo_prdcdd_prpgo,
					nmro_estdo_cnta,		
					cnsctvo_cdgo_clse_aprtnte,
					vlr_ttl_cntrto,		
					vlr_ttl_cntrto_sn_iva,
					cntdd_ttl_bnfcrs,		
					Grupo_Conceptos
					)
		Select		a.cnsctvo_cdgo_tpo_cntrto,	
					a.nmro_cntrto,
					a.cnsctvo_cdgo_pln,		
					a.inco_vgnca_cntrto,
					a.fn_vgnca_cntrto,		
					a.nmro_unco_idntfccn_afldo,
					b.cnsctvo_cbrnza,		
					b.nmro_unco_idntfccn_aprtnte,
					c.cnsctvo_vgnca_cbrnza,		
					c.cnsctvo_scrsl_ctznte,
					c.inco_vgnca_cbrnza,		
					c.fn_vgnca_cbrnza,
					c.cta_mnsl,			
					b.cnsctvo_cdgo_prdcdd_prpgo,
					@numeroEstadoCuenta,		
					cnsctvo_cdgo_clse_aprtnte,
					0,				0,
					0,				1 -- por defecto  se toma el concepto generico
		From 		(
					Select		a.cnsctvo_cdgo_tpo_cntrto,	a.nmro_cntrto,
								a.cnsctvo_cdgo_pln,		a.inco_vgnca_cntrto,
								a.fn_vgnca_cntrto,		a.estdo_cntrto,
								a.nmro_unco_idntfccn_afldo
					From		bdafiliacion.dbo.tbcontratos	a with(nolock)
					Inner Join	#tmpContratosSeleccionados		d
						On		a.cnsctvo_cdgo_tpo_cntrto	= d.cnsctvo_cdgo_tpo_cntrto
						And		a.nmro_cntrto				= d.nmro_cntrto
					where		a.cnsctvo_cdgo_tpo_cntrto	= 2
					And			estdo_cntrto	=	'A'
					)  a 
		Inner Join	(
					Select		a.cnsctvo_cdgo_tpo_cntrto,	a.nmro_cntrto,
								a.cnsctvo_cbrnza,		a.nmro_unco_idntfccn_aprtnte,
								a.cnsctvo_cdgo_clse_aprtnte,	a.cnsctvo_cdgo_prdcdd_prpgo
					From		bdafiliacion.dbo.tbcobranzas	a  with(nolock)
					Inner Join	#tmpContratosSeleccionados		d
						On		a.cnsctvo_cdgo_tpo_cntrto	= d.cnsctvo_cdgo_tpo_cntrto
						And		a.nmro_cntrto				= d.nmro_cntrto
					Where		a.cnsctvo_cdgo_tpo_cntrto	= 2
					) b
					On		a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto
					And 	a.nmro_cntrto		  = b.nmro_cntrto 
		Inner Join	(
					Select		Max(a.cnsctvo_vgnca_cbrnza) cnsctvo_vgnca_cbrnza,
								Max(a.inco_vgnca_cbrnza) inco_vgnca_cbrnza,
								Max(a.fn_vgnca_cbrnza) fn_vgnca_cbrnza,
								Max(a.cta_mnsl)  cta_mnsl,
								a.cnsctvo_cdgo_tpo_cntrto,
								a.nmro_cntrto,
								Max(a.cnsctvo_cbrnza) cnsctvo_cbrnza,
								Max(a.cnsctvo_scrsl_ctznte) cnsctvo_scrsl_ctznte
					From		bdafiliacion.dbo.tbVigenciasCobranzas	a  with(nolock)
					Inner Join	#tmpContratosSeleccionados				d
						On		a.cnsctvo_cdgo_tpo_cntrto	= d.cnsctvo_cdgo_tpo_cntrto
						And		a.nmro_cntrto				= d.nmro_cntrto
					Where		a.cnsctvo_cdgo_tpo_cntrto	= 2
					And			a.estdo_rgstro				= 'S'
					And			Datediff(Day,a.inco_vgnca_cbrnza,@fechaCorte) >= 0
					And			Datediff(Day,@fechaCorte,a.fn_vgnca_cbrnza)	 >= 0 -- que sea el siguiente del periodo a evaluar
					Group by   a.cnsctvo_cdgo_tpo_cntrto,a.nmro_cntrto
					)  c
					On		c.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto
					And		c.nmro_cntrto		  = b.nmro_cntrto
					And		c.cnsctvo_cbrnza	  = b.cnsctvo_cbrnza
		Where		Datediff(Day,a.inco_vgnca_cntrto,@fechaCorte)>= 0
		And			Datediff(Day,@fechaCorte,a.fn_vgnca_cntrto)	>= 0 -- que sea el siguiente del periodo a evaluar
		And			Datediff(Day,c.inco_vgnca_cbrnza,@fechaCorte)>= 0
		And			Datediff(Day,@fechaCorte,c.fn_vgnca_cbrnza)	>= 0 -- que sea el siguiente del periodo a evaluar
		And			a.cnsctvo_cdgo_tpo_cntrto 		=	2	--Contratos de planes complementarios
		
		--truncate table #tmpHistoricoTarifasContratoPAC
		Insert into #tmpHistoricoTarifasContratoPAC (
					cnsctvo_cdgo_tpo_cntrto ,
					nmro_cntrto ,
					cnsctvo_cbrnza ,
					cnsctvo_scrsl_ctznte ,
					cnsctvo_cdgo_clse_aprtnte ,
					cta_mnsl 
					)
		select 
					hb.cnsctvo_cdgo_tpo_cntrto,
					hb.nmro_cntrto,
					hb.cnsctvo_cbrnza,
					hb.cnsctvo_scrsl ,
					hb.cnsctvo_cdgo_clse_aprtnte,
					sum(vlr_upc) as cta_msl
		from		dbo.tbHistoricoTarificacionXProceso hb 
		inner join	(select max(cnsctvo_cdgo_lqdcn) cnsctvo_cdgo_lqdcn, htp.nmro_cntrto, htp.cnsctvo_cdgo_tpo_cntrto  
					from dbo.tbHistoricoTarificacionXProceso htp with(nolock)  
					inner join #Tmpcontratos_Antes_liquidar al
						on	htp.nmro_cntrto = al.nmro_cntrto 
						and htp.cnsctvo_cdgo_tpo_cntrto = al.cnsctvo_cdgo_tpo_cntrto
					where fcha_incl_prdo_lqdcn < = @fechaInicialFacturacion
					group by htp.nmro_cntrto, htp.cnsctvo_cdgo_tpo_cntrto    ) det
			on			hb.nmro_cntrto = det.nmro_cntrto
			and			hb.cnsctvo_cdgo_tpo_cntrto = det.cnsctvo_cdgo_tpo_cntrto
			and			hb.cnsctvo_cdgo_lqdcn = det.cnsctvo_cdgo_lqdcn
		group by	hb.cnsctvo_cdgo_tpo_cntrto,
					hb.nmro_cntrto,
					hb.cnsctvo_cbrnza,
					hb.cnsctvo_scrsl ,
					hb.cnsctvo_cdgo_clse_aprtnte

		update		cal
		set			cal.cta_mnsl = tp.cta_mnsl
		from		#Tmpcontratos_Antes_liquidar	cal 
		inner join  #tmpHistoricoTarifasContratoPAC tp
			on		cal.nmro_cntrto = tp.nmro_cntrto
		and			cal.cnsctvo_cdgo_tpo_cntrto = tp.cnsctvo_cdgo_tpo_cntrto
		and			cal.cnsctvo_cbrnza = tp.cnsctvo_cbrnza
		where		cal.cta_mnsl <> tp.cta_mnsl

		--truncate table #tmpHistoricoTarifasBeneficiarioPAC
		Insert into #tmpHistoricoTarifasBeneficiarioPAC 
		(
					cnsctvo_cdgo_tpo_cntrto ,
					nmro_cntrto ,
					nmro_unco_idntfccn,
					cnsctvo_bnfcro ,
					cnsctvo_cbrnza ,
					cnsctvo_scrsl_ctznte ,
					cnsctvo_cdgo_clse_aprtnte ,
					cta_mnsl  
		)
		select 
					hb.cnsctvo_cdgo_tpo_cntrto,
					hb.nmro_cntrto,
					hb.nmro_unco_idntfccn,
					hb.cnsctvo_bnfcro,
					hb.cnsctvo_cbrnza,
					hb.cnsctvo_scrsl ,
					hb.cnsctvo_cdgo_clse_aprtnte,
					sum(vlr_upc) as cta_msl
		from		dbo.tbHistoricoTarificacionXProceso hb 
		inner join	(select		max(cnsctvo_cdgo_lqdcn) cnsctvo_cdgo_lqdcn, htp.nmro_cntrto, htp.cnsctvo_cdgo_tpo_cntrto  
					from		dbo.tbHistoricoTarificacionXProceso htp with(nolock) 
					inner join  #Tmpcontratos_Antes_liquidar al
						on		htp.nmro_cntrto = al.nmro_cntrto 
						and		htp.cnsctvo_cdgo_tpo_cntrto = al.cnsctvo_cdgo_tpo_cntrto
					where		fcha_incl_prdo_lqdcn < = @fechaInicialFacturacion
					group by	htp.nmro_cntrto, htp.cnsctvo_cdgo_tpo_cntrto     ) det
			on		hb.nmro_cntrto = det.nmro_cntrto
			and		hb.cnsctvo_cdgo_tpo_cntrto = det.cnsctvo_cdgo_tpo_cntrto
			and		hb.cnsctvo_cdgo_lqdcn = det.cnsctvo_cdgo_lqdcn
		group by	hb.cnsctvo_cdgo_tpo_cntrto,
					hb.nmro_cntrto,
					hb.nmro_unco_idntfccn,
					hb.cnsctvo_bnfcro,
					hb.cnsctvo_cbrnza,
					hb.cnsctvo_scrsl ,
					hb.cnsctvo_cdgo_clse_aprtnte

		Insert	
		Into		#Tmpcontratos
					(cnsctvo_cdgo_tpo_cntrto,		nmro_cntrto,
					cnsctvo_cdgo_pln,			inco_vgnca_cntrto,
					fn_vgnca_cntrto,			nmro_unco_idntfccn_afldo,
					cnsctvo_cbrnza,			nmro_unco_idntfccn_aprtnte,
					cnsctvo_vgnca_cbrnza,			cnsctvo_scrsl_ctznte,
					inco_vgnca_cbrnza,			fn_vgnca_cbrnza,
					cta_mnsl,				cnsctvo_cdgo_prdcdd_prpgo,
					nmro_estdo_cnta,			cnsctvo_cdgo_clse_aprtnte,
					vlr_ttl_cntrto,			vlr_ttl_cntrto_sn_iva,
					cntdd_ttl_bnfcrs,			Grupo_Conceptos,
					Activo,				Cntrto_igual_cro)
		Select		a.cnsctvo_cdgo_tpo_cntrto,		a.nmro_cntrto,
					a.cnsctvo_cdgo_pln,			a.inco_vgnca_cntrto,
					a.fn_vgnca_cntrto,			a.nmro_unco_idntfccn_afldo,
					a.cnsctvo_cbrnza,			a.nmro_unco_idntfccn_aprtnte,
					a.cnsctvo_vgnca_cbrnza,			a.cnsctvo_scrsl_ctznte,
					a.inco_vgnca_cbrnza,			a.fn_vgnca_cbrnza,
					a.cta_mnsl,				a.cnsctvo_cdgo_prdcdd_prpgo,
					@numeroEstadoCuenta nmro_estdo_cnta,	cnsctvo_cdgo_clse_aprtnte,
					Convert(Numeric(12,0),0),		Convert(Numeric(12,0),0),
					0,					1, -- por defecto  se toma el concepto generico
					0,					0
		From 		#Tmpcontratos_Antes_liquidar	 a;
end