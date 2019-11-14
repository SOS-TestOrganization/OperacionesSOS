/*---------------------------------------------------------------------------------
* Metodo o PRG 			: spTarificaLiquidacionPrevia
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso		A\>
* Descripcion			: <\D Este procedimiento ejecuta el proceso de tarificacion 
								los registrso que se encuentran en la table tenmporal D\>
* Observaciones			: <\O  	O\>
* Parametros			: <\P	P\>
* Variables				: <\V  	V\>
* Fecha Creacion		: <\FC 2003/02/10	FC\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM Rolando Simbaqueva lasso AM\>
* Descripcion			: <\DM Aplicacion tecnica de optimizacion DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion	: <\FM  2005 /09/ 26 FM\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM sismpr01 AM\>
* Descripcion			: <\DM QUICK 2012-001-026681 
								se cambia manejo de la tabla tbSucursalAportanteXGrupo por la de vigencias 
								tbSucursalAportanteXGrupo_Vigencias	DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  2012/09/14 FM\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM Francisco Eduardo Riaño - Qvision S.A AM\>
* Descripcion			: <\DM 	se adiciona parametro de entrada al procedimiento almacenado
								spTarificacionCalculaTarifaXBeneficiario DM\>
* Nuevos Parametros		: <\PM  @cnsctvo_cdgo_lqdcn PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion	: <\FM  2019/09/18 FM\>
*---------------------------------------------------------------------------------*/
CREATE   PROCEDURE [dbo].[spTarificaLiquidacionPrevia](
		@ldFechaSistema			datetime,
		@cnsctvo_cdgo_lqdcn		int,
		@lcControlaError		int	output
)
As
begin
	
	Set Nocount On;

	Declare		@Grupo_Generico_tarifas			int = 2,
				@cnsctvo_hstrco_prcso_lqdcn		int,
				@lnError						int,
				@cnsctvo_cdgo_prdo_lqdcn		int,
				@fcha_incl_prdo_lqdcn			Datetime,
				@cantidad_ciat					int,
				@ldFechaActual					datetime = getdate(),
				@cnsctvo_cdgo_grpo				udtConsecutivo,
				@lncontadorProceso				udtConsecutivo = 7,
				@Paso							udtConsecutivo;

	-- Se crean tablas temporales
	Create table 	#RegistrosClasificar
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
		bnfcdo_pc char(1),
		Tne_hjos_cnyge_cmpnra char(1),
		cntrtnte_ps_ss char(1),
		grpo_bsco_cn_ps char(1),
		cntrtnte_tn_pc char(1),
		antgdd_clptra char(1)
	)

	Select	@cnsctvo_cdgo_prdo_lqdcn	=	cnsctvo_cdgo_prdo_lqdcn
	From	bdcarteraPac.dbo.tbliquidaciones with(nolock)
	Where	cnsctvo_cdgo_lqdcn		=	@cnsctvo_cdgo_lqdcn
	
	Select 	@fcha_incl_prdo_lqdcn		=	fcha_incl_prdo_lqdcn
	From	bdcarteraPac.dbo.tbperiodosliquidacion_vigencias with(nolock)
	Where	cnsctvo_cdgo_prdo_lqdcn	=	@cnsctvo_cdgo_prdo_lqdcn

	insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Iinicia llena informacion datos basicos del beneficiario',Getdate())
	
	Exec @lnError	=	bdcarteraPac.dbo.spTarificacionLLenaInformacionBeneficiario  @cnsctvo_cdgo_lqdcn
	
		--print 'spAcotarDetBeneficiarioAdicional'
	If @lnError = -1 or @@error <> 0
	Begin 
		Set	@lcControlaError	=	1
		Return -1
	end

	--Actualiza el grupo de tarifas para aquellas empresas

	update		#RegistrosClasificarFinal
	Set			grupo_tarificacion	=	cnsctvo_cdgo_grpo
	From		#RegistrosClasificarFinal a 
	inner join 	bdplanBeneficios.dbo.tbSucursalAportanteXGrupo_vigencias b with(nolock)
		on 		a.nmro_unco_idntfccn_aprtnte	=	b.nmro_unco_idntfccn_empldr
		And		a.cnsctvo_scrsl_ctznte			=	b.Cnsctvo_scrsl
		And		a.cnsctvo_cdgo_clse_aprtnte		=	b.cnsctvo_cdgo_clse_aprtnte
		And		@ldFechaActual between  b.inco_vgnca	and	b.fn_vgnca

	If  @@error!=0  
	Begin 
		Set	@lcControlaError	=	1
		Return -1
	end

	--Se crea la tabla temporal generica #RegistrosClasificar para que evalue el grupo generico
	
	Select  @cantidad_ciat  = count(*) from #RegistrosClasificarFinal
								where nmro_unco_idntfccn_aprtnte = 30043100
								and cnsctvo_scrsl_ctznte = 3
								and cnsctvo_cdgo_clse_aprtnte = 1


	Insert	into	#RegistrosClasificar
	select  nmro_unco_idntfccn,
			edd_bnfcro,
			cnsctvo_cdgo_pln,
			ps_ss,
			fcha_aflcn_pc	,
			cnsctvo_cdgo_prntsco,
			cnsctvo_cdgo_tpo_afldo,
            Dscpctdo,
            Estdnte,
            Antgdd_hcu,
            Atrzdo_sn_Ps,
            grpo_bsco,
            cnsctvo_cdgo_tpo_cntrto,	
            nmro_cntrto,
            cnsctvo_bnfcro,
            cnsctvo_cbrnza,
            grupo,
            cnsctvo_prdcto,
            cnsctvo_mdlo,
            vlr_upc,
            vlr_rl_pgo,
			cnsctvo_cdgo_tps_cbro,
			Cobranza_Con_producto,
			Beneficiario_Con_producto,
			Con_Modelo,
			grupo_tarificacion,
			igual_plan,
			grupo_modelo,
			nmro_unco_idntfccn_aprtnte,
			cnsctvo_scrsl_ctznte, 
			cnsctvo_cdgo_clse_aprtnte,
			inco_vgnca_cntrto,
			bnfcdo_pc	,
			Tne_hjos_cnyge_cmpnra,
			cntrtnte_ps_ss,
			grpo_bsco_cn_ps ,
			cntrtnte_tn_pc ,
			antgdd_clptra
	From	#RegistrosClasificarFinal
	Where	grupo_tarificacion	=	@Grupo_Generico_tarifas


	If  @@error!=0  
	Begin 
		Set	@lcControlaError	=	1
		Return -1
	end

	Select  @cantidad_ciat  = count(*) from #RegistrosClasificar 
								where nmro_unco_idntfccn_aprtnte = 30043100
								and cnsctvo_scrsl_ctznte = 3
								and cnsctvo_cdgo_clse_aprtnte = 1

	insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Iinicia Calculo Grupo  Generico de los beneficiarios',Getdate())

	--Se calcula el grupo de todos los beneficiarios del grupo generico
	
	Exec @lnError	=	bdcarteraPac.dbo.spTarificacionActualizaGrupoXBeneficiarios @Grupo_Generico_tarifas ,	@cnsctvo_cdgo_lqdcn, 	 @ldFechaSistema


	--print 'spAcotarDetBeneficiarioAdicional'
	If @lnError = -1 or @@error <> 0
	Begin 
		Set	@lcControlaError	=	1
		Return -1
	end

	insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Actualiza el Grupo de los Beneficiarios',Getdate())

	--Actualizamos la tabla resultado con el grupo donde queda el beneficiario para el generico
	Update		#RegistrosClasificarFinal
	Set			Grupo				=	b.Grupo
	From		#RegistrosClasificarFinal  a 
	inner join  #RegistrosClasificar b
		on		(a.nmro_unco_idntfccn	=	b.nmro_unco_idntfccn)
	Where 		a.grupo_tarificacion		=	@Grupo_Generico_tarifas

	If  @@error!=0  
	Begin 
		Set	@lcControlaError	=	1
		Return -1
	end


	-----------------------------------------------------------------------
	--Se hace un ciclo para los beneficiasrios de grupos especiales

	Declare crGrupoXAportante cursor for
	Select	cnsctvo_cdgo_grpo
	from 	bdplanBeneficios.dbo.tbSucursalAportanteXGrupo_vigencias b with(nolock)
	Where	@ldFechaActual between  b.inco_vgnca	and	b.fn_vgnca
	group by cnsctvo_cdgo_grpo

	If  @@error!=0  
	Begin 
		Set	@lcControlaError	=	1
		Return -1
	end


	open	crGrupoXAportante
	Fetch   crGrupoXAportante into  @cnsctvo_cdgo_grpo

	While @@Fetch_status = 0
	Begin
		-- se borra  la informacion de la tabla temporal	#RegistrosClasificar
		truncate table	#RegistrosClasificar 

		Set	@lncontadorProceso	=	@lncontadorProceso	+	1

		If  @@error!=0  
		Begin 
			Set	@lcControlaError	=	1
			Close crGrupoXAportante
			Deallocate crGrupoXAportante
			Return -1
		end
	
		-- se inserta la informacion correspondiente al grupo
		insert into	#RegistrosClasificar
		select 		nmro_unco_idntfccn,
					edd_bnfcro,
					cnsctvo_cdgo_pln,
					ps_ss,
					fcha_aflcn_pc	,
					cnsctvo_cdgo_prntsco,
					cnsctvo_cdgo_tpo_afldo,
					Dscpctdo,
					Estdnte,
					Antgdd_hcu,
					Atrzdo_sn_Ps,
					grpo_bsco,
					cnsctvo_cdgo_tpo_cntrto,	
					nmro_cntrto,
					cnsctvo_bnfcro,
					cnsctvo_cbrnza,
					grupo,
					cnsctvo_prdcto,
					cnsctvo_mdlo,
					vlr_upc,
					vlr_rl_pgo,
		 			cnsctvo_cdgo_tps_cbro,
					Cobranza_Con_producto,
					Beneficiario_Con_producto,
					Con_Modelo ,
					grupo_tarificacion,
					igual_plan,
					grupo_modelo,
					nmro_unco_idntfccn_aprtnte,
					cnsctvo_scrsl_ctznte, 
					cnsctvo_cdgo_clse_aprtnte,
					inco_vgnca_cntrto,
					bnfcdo_pc		,
					Tne_hjos_cnyge_cmpnra,
					cntrtnte_ps_ss,
					grpo_bsco_cn_ps ,
					cntrtnte_tn_pc ,
					antgdd_clptra
		From		#RegistrosClasificarFinal
		Where		grupo_tarificacion	=	@cnsctvo_cdgo_grpo

		If  @@error!=0  
		Begin 
			Set	@lcControlaError	=	1
			Close crGrupoXAportante
			Deallocate crGrupoXAportante
			Return -1
		end
				
		--Se calcula el grupo de los registros

		insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Iinicia Calculo Grupo  diferente al Generico de los beneficiarios',Getdate())

		Exec @lnError	=	bdcarteraPac.dbo.spTarificacionActualizaGrupoXBeneficiarios @cnsctvo_cdgo_grpo ,	@cnsctvo_cdgo_lqdcn, 	 @ldFechaSistema

		--print 'spAcotarDetBeneficiarioAdicional'
		If @lnError = -1 or @@error <> 0
		Begin 
			Set	@lcControlaError	=	1
				Close crGrupoXAportante
				Deallocate crGrupoXAportante
				Return -1
		end

		--Actualizamos la tabla resultado con el grupo donde queda el beneficiario para  grupo que se
		-- esta evaluando

		insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Iinicia actualizacion del grupo diferente al Generico de los beneficiarios',Getdate())

		Update		#RegistrosClasificarFinal
		Set			Grupo	=	b.Grupo
		From		#RegistrosClasificarFinal a 
		inner join	#RegistrosClasificar b
			on		(a.nmro_unco_idntfccn	=	b.nmro_unco_idntfccn)
		Where 		a.grupo_tarificacion		=	@cnsctvo_cdgo_grpo

		If  @@error!=0  
		Begin 
			Set	@lcControlaError	=	1
			Close crGrupoXAportante
			Deallocate crGrupoXAportante
			Return -1
		end

		Fetch crGrupoXAportante into  @cnsctvo_cdgo_grpo
			
	End

	Close crGrupoXAportante
	Deallocate crGrupoXAportante

	truncate table #RegistrosClasificar

	If  @@error!=0  
	Begin 
		Set	@lcControlaError	=	1
		Return -1
	end

	insert into	#RegistrosClasificar
	select   	nmro_unco_idntfccn,
	            edd_bnfcro,
	            cnsctvo_cdgo_pln,
				ps_ss,
				fcha_aflcn_pc	,
				cnsctvo_cdgo_prntsco,
				cnsctvo_cdgo_tpo_afldo,
				Dscpctdo,
				Estdnte,
				Antgdd_hcu,
				Atrzdo_sn_Ps,
				grpo_bsco,
				cnsctvo_cdgo_tpo_cntrto,	
				nmro_cntrto,
				cnsctvo_bnfcro,
				cnsctvo_cbrnza,
				grupo,
				cnsctvo_prdcto,
				cnsctvo_mdlo,
				vlr_upc,
				vlr_rl_pgo,
	 			cnsctvo_cdgo_tps_cbro,
				Cobranza_Con_producto,
				Beneficiario_Con_producto,
				Con_Modelo ,
				grupo_tarificacion,
				igual_plan,
				grupo_modelo,
				nmro_unco_idntfccn_aprtnte,
				cnsctvo_scrsl_ctznte, 
				cnsctvo_cdgo_clse_aprtnte,
				inco_vgnca_cntrto,
				bnfcdo_pc,
				Tne_hjos_cnyge_cmpnra,
				cntrtnte_ps_ss,
				grpo_bsco_cn_ps ,
				cntrtnte_tn_pc ,
				antgdd_clptra
	From		#RegistrosClasificarFinal

	If  @@error!=0  
	Begin 
		Set	@lcControlaError	=	1
		Return -1
	end

	insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Iinicia proceso  spTarificacionCalculaTarifaXBeneficiario',Getdate())

	Exec @lnError	=	bdcarteraPac.dbo.spTarificacionCalculaTarifaXBeneficiario @cnsctvo_cdgo_lqdcn

	--print 'spAcotarDetBeneficiarioAdicional'
	If @lnError = -1 or @@error <> 0
	Begin 
		Set	@lcControlaError	=	1
		Return -1
	end

	insert	into  bdcarteraPac.dbo.tbPasosLiquidacion values(@cnsctvo_cdgo_lqdcn,'Finaliza el  proceso  spTarificacionCalculaTarifaXBeneficiario',Getdate())

	Update		#RegistrosClasificarFinal
	Set			cnsctvo_prdcto			=	b.cnsctvo_prdcto,
				cnsctvo_mdlo			=	b.cnsctvo_mdlo,
				vlr_upc					=	b.vlr_upc,
				vlr_rl_pgo				=	b.vlr_rl_pgo,
				cnsctvo_cdgo_tps_cbro		=	b.cnsctvo_cdgo_tps_cbro,
				Cobranza_Con_producto		=	b.Cobranza_Con_producto,
				Beneficiario_Con_producto	=	b.Beneficiario_Con_producto,
				Con_Modelo			=	b.Con_Modelo,
				igual_plan			=	b.igual_plan,
				grupo_modelo			=	b.grupo_modelo
	From		#RegistrosClasificarFinal a 
	inner join	#RegistrosClasificar b
		on 	(a.nmro_unco_idntfccn	=	b.nmro_unco_idntfccn
		And	 a.nmro_cntrto		=	b.nmro_cntrto)

	If  @@error!=0  
	Begin 
		Set	@lcControlaError	=	1
		Return -1
	end

	Select	@cnsctvo_hstrco_prcso_lqdcn	=	isnull(max(cnsctvo_hstrco_prcso_lqdcn),0)	
	From	bdcarteraPac.dbo.tbHistoricoTarificacionXProceso with(nolock)

	If  @@error!=0  
	Begin 
		Set	@lcControlaError	=	1
		Return -1
	end


	Select 	IDENTITY(int, 1 ,1) AS	nmro_rgstro,		
			nmro_unco_idntfccn,
			edd_bnfcro,
			cnsctvo_cdgo_pln,
			ps_ss,
			fcha_aflcn_pc,
			cnsctvo_cdgo_prntsco,
			cnsctvo_cdgo_tpo_afldo,
			Dscpctdo,
			Estdnte,
			Antgdd_hcu,
			Atrzdo_sn_Ps,
			grpo_bsco,
			cnsctvo_cdgo_tpo_cntrto,
			nmro_cntrto,
			cnsctvo_bnfcro,
			cnsctvo_cbrnza,
			grupo,
			cnsctvo_prdcto,
			cnsctvo_mdlo,
			vlr_upc,
			vlr_rl_pgo,
			cnsctvo_cdgo_tps_cbro,
			Cobranza_Con_producto,
			Beneficiario_Con_producto,
			Con_Modelo,
			grupo_tarificacion,
			igual_plan,
			grupo_modelo,
			nmro_unco_idntfccn_aprtnte,
			cnsctvo_scrsl_ctznte, 
			cnsctvo_cdgo_clse_aprtnte,	
			@cnsctvo_cdgo_lqdcn  	cnsctvo_cdgo_lqdcn,
			inco_vgnca_cntrto,
			bnfcdo_pc
	into	#tmpHistoricoTarificacionXProceso
	From	#RegistrosClasificar

	If  @@error!=0  
	Begin 
		Set	@lcControlaError	=	1
		Return -1
	end
	
	insert into  bdcarteraPac.dbo.tbHistoricoTarificacionXProceso
	Select 	(nmro_rgstro	+	@cnsctvo_hstrco_prcso_lqdcn ),		
			nmro_unco_idntfccn,
			edd_bnfcro,
			cnsctvo_cdgo_pln,
			ps_ss,
			fcha_aflcn_pc,
			cnsctvo_cdgo_prntsco,
			cnsctvo_cdgo_tpo_afldo,
			Dscpctdo,
			Estdnte,
			Antgdd_hcu,
			Atrzdo_sn_Ps,
			grpo_bsco,
			cnsctvo_cdgo_tpo_cntrto,
			nmro_cntrto,
			cnsctvo_bnfcro,
			cnsctvo_cbrnza,
			grupo,
			cnsctvo_prdcto,
			cnsctvo_mdlo,
			vlr_upc,
			vlr_rl_pgo,
			cnsctvo_cdgo_tps_cbro,
			Cobranza_Con_producto,
			Beneficiario_Con_producto,
			Con_Modelo,
			grupo_tarificacion,
			igual_plan,
			grupo_modelo,
			nmro_unco_idntfccn_aprtnte,
			cnsctvo_scrsl_ctznte, 
			cnsctvo_cdgo_clse_aprtnte,	
			cnsctvo_cdgo_lqdcn,
			inco_vgnca_cntrto,
			@fcha_incl_prdo_lqdcn,
			bnfcdo_pc,
			Null
	From	#tmpHistoricoTarificacionXProceso

	If  @@error!=0  
	Begin 
		Set	@lcControlaError	=	1
		Return -1
	end

end
