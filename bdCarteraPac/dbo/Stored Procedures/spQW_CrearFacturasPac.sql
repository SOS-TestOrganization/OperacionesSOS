
/*---------------------------------------------------------------------------------
* Metodo o PRG 		    :spQW_CrearFacturasPac
* Desarrollado por		: <\A  Cristian Camilo Zambrano Grajales				A\>
* Descripcion			: <\D Este procedimien realiza el proceso de            D\>
                        : <\D liquidacion de la factura basado en un archivo    D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables				: <\V  													V\>
* Fecha Creacion		: <\FC 2019/09/18										FC\>
*
*---------------------------------------------------------------------------------
*---------------------------------------------------------------------------------*/
-- execute  [dbo].[spQW_CrearFacturasPac] 'qvisionczg','20190901', 0
CREATE PROCEDURE [dbo].[spQW_CrearFacturasPac]
@lcUsuario				udtUsuario,
@Fcha_Liquidacion       datetime,
@sldo_antrr             udtValorGrande
as
DECLARE 

	@mnsje_slda				varchar(1000) ,
	@cdgo_slda				udtCodigo	,
	@detalleEjecucion		varchar(5000) ,
	@lnConsCodigoLiquidacionGenerado udtConsecutivo	

--begin tran

	Set Nocount On

	Declare @ldfechaCorte	datetime, 
			@lnConsCodigoPeriodoLiq udtConsecutivo,
			@mensajeSalida  udtObservacion,
			@codigoSalida	udtCodigo,
			@filasAfectadas INT=0,
			@lnNuevoConsCodigoLiquidacion udtConsecutivo,
			@lnTipoProceso	 int=1, --Procesar Liquidacion
			@lnIdConsecutivoProceso udtConsecutivo,
			@lnNumEstadosCuentaCreados int,
			@lnConsCodigoPlan int,
			@lcSaltoLinea char(2)=CHAR(13) + CHAR(10),
			@logTxt varchar(5000)='' 

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

	select	@ldfechaCorte = fcha_incl_prdo_lqdcn,
			@lnConsCodigoPeriodoLiq = cnsctvo_cdgo_prdo_lqdcn
	from bdCarterapac.dbo.tbPeriodosLiquidacion_vigencias a with(nolock) 
	where fcha_incl_prdo_lqdcn = @Fcha_Liquidacion

	if @lnConsCodigoPeriodoLiq > 0
	begin
		Set @mnsje_slda	= '';
		Set @cdgo_slda	= 0; -- 0k
	end
		else
			begin
					Set	@cdgo_slda	=	1
					Set	@mnsje_slda		=	'No existe un solo periodo con estado abierto para generar la liquidaciÃ³n'
			end

		
			set @logTxt = 'spObtenerInfoPeriodoLiquidacion			     - @codigoSalida: '+CAST(@codigoSalida AS VARCHAR(12))+' @mensajeSalida: '+@mensajeSalida+@lcSaltoLinea
			--print @logTxt

				
        If @codigoSalida <>0 
			begin
				 
				Set @mnsje_slda	= @mensajeSalida;
				Set @cdgo_slda	= @codigoSalida;
				-- rollback tran
				RETURN			
			end 
	
		
			 Declare @lnConsecutivoCodigoLiquidacion udtConsecutivo,
			@lnConsecutivoEstadoLiquidacion	udtconsecutivo = 1,
			@lcObservaciones				varchar(250)='Proceso Generado Para Acuavalle',
			@lnConsecutivoTipoProceso		udtConsecutivo=1

			Select  @lnConsecutivoCodigoLiquidacion = isnull(max(cnsctvo_cdgo_lqdcn),0)+1	
			From	dbo.tbliquidaciones with(nolock)

			Insert into dbo.tbliquidaciones
			(
				cnsctvo_cdgo_lqdcn,				 
				cnsctvo_cdgo_prdo_lqdcn,			
				cnsctvo_cdgo_estdo_lqdcn,
				cnsctvo_cdgo_tpo_prcso,			 
				nmro_estds_cnta,					
				vlr_lqddo,
				nmro_cntrts,					 
				fcha_crcn,							
				usro_crcn,
				fcha_inco_prcso,				 
				fcha_fnl_prcso,					
				obsrvcns
			)
			Values
			(
				 @lnConsecutivoCodigoLiquidacion,	
				 @lnConsCodigoPeriodoLiq,
				 @lnConsecutivoEstadoLiquidacion,
				 @lnConsecutivoTipoProceso,				
				 0,										
				 0,
				 0,										
				 getdate(),
				 @lcUsuario,
				 GETDATE(),
				 Null,
				 @lcObservaciones
			)
	
		if @@error <> 0
		begin
			-- rollback tran
			return
		end

		set @lnNuevoConsCodigoLiquidacion=@lnConsecutivoCodigoLiquidacion 
					
		--Establecemos el valor de salida del procedimiento 
		SET @lnConsCodigoLiquidacionGenerado = @lnNuevoConsCodigoLiquidacion

		set @logTxt +='spRegistrarLiquidacionPLUS			         - @codigoSalida: '+CAST(@codigoSalida AS VARCHAR(12))+' @mensajeSalida: '+@mensajeSalida+@lcSaltoLinea
		--print @logTxt
		
		Declare @ADICIONAL smallint=4,
			@VALIDO char(1) = 'S',
			@ACTIVO char(1) = 'A'

			
			INSERT INTO #tmpSucursalesProducto
			Select	distinct 
				ROW_NUMBER() OVER(ORDER BY c.nmro_idntfccn ASC) AS nmro_rgstro,
				e.cdgo_tpo_idntfccn,	
				c.nmro_idntfccn,	
				b.nmbre_scrsl,	
				a.cnsctvo_scrsl,
				a.nmro_unco_idntfccn_empldr, 
				a.cnsctvo_cdgo_clse_aprtnte,  
				b.sde_crtra_pc as cnsctvo_cdgo_sde, 
				a.cnsctvo_prdcto_scrsl,
				a.cnsctvo_prdcto
			From	bdAfiliacion.dbo.tbProductosxAportantes a With(NoLock) 
			cross apply (select cnsctvo_prdcto, cnsctvo_scrsl, nmro_unco_idntfccn_empldr, cnsctvo_cdgo_clse_aprtnte
						 from  temporal.dbo.beneficiariosFacturar_pedido f
						 where a.cnsctvo_prdcto = f.cnsctvo_prdcto and a.cnsctvo_scrsl	= f.cnsctvo_scrsl
								And a.nmro_unco_idntfccn_empldr	= f.nmro_unco_idntfccn_empldr
								And a.cnsctvo_cdgo_clse_aprtnte = f.cnsctvo_cdgo_clse_aprtnte
						 group by cnsctvo_prdcto, cnsctvo_scrsl, nmro_unco_idntfccn_empldr, cnsctvo_cdgo_clse_aprtnte
						 ) f
				Inner Join	bdAfiliacion.dbo.tbSucursalesAportante b With(NoLock)
			On	b.cnsctvo_scrsl	= f.cnsctvo_scrsl
			And b.nmro_unco_idntfccn_empldr	= f.nmro_unco_idntfccn_empldr
			And b.cnsctvo_cdgo_clse_aprtnte = f.cnsctvo_cdgo_clse_aprtnte
			Inner Join	bdAfiliacion.dbo.tbVinculados c With(NoLock)
			On	c.nmro_unco_idntfccn	= f.nmro_unco_idntfccn_empldr
			Inner Join	bdAfiliacion.dbo.tbTiposIdentificacion e With(NoLock)
			On	e.cnsctvo_cdgo_tpo_idntfccn	= c.cnsctvo_cdgo_tpo_idntfccn
			Where	 c.vldo	= 'S'
			and	@ldFechaCorte between inco_vgnca_asccn and fn_vgnca_asccn
			Order by b.nmbre_scrsl, a.cnsctvo_scrsl

			truncate table #tmpContratosVigentes
			INSERT INTO #tmpContratosVigentes
			select distinct
				c.cnsctvo_cdgo_tpo_cntrto,	
				c.nmro_cntrto,
				sp.nmro_unco_idntfccn_empldr,
				sp.cnsctvo_cdgo_clse_aprtnte,
				sp.cnsctvo_scrsl  
				-- select *
			from	#tmpSucursalesProducto										sp 
			inner join temporal.dbo.beneficiariosFacturar_pedido f on sp.cnsctvo_cdgo_clse_aprtnte = f.cnsctvo_cdgo_clse_aprtnte and sp.cnsctvo_scrsl = f.cnsctvo_scrsl
																	and sp.nmro_unco_idntfccn_empldr = f.nmro_unco_idntfccn_empldr and sp.cnsctvo_prdcto = f.cnsctvo_prdcto
			inner join [BDAfiliacion].dbo.[tbCobranzas]							c With (Nolock) 
				on  sp.nmro_unco_idntfccn_empldr = c.nmro_unco_idntfccn_aprtnte  
				and sp.cnsctvo_cdgo_clse_aprtnte = c.cnsctvo_cdgo_clse_aprtnte
				and c.nmro_cntrto = f.nmro_cntrto and c.cnsctvo_cdgo_tpo_cntrto = f.cnsctvo_cdgo_tpo_cntrto 
			inner join [BDAfiliacion].dbo.[tbVigenciasCobranzas]				vc With (Nolock)
				on	c.cnsctvo_cdgo_tpo_cntrto	= vc.cnsctvo_cdgo_tpo_cntrto
				and c.nmro_cntrto				= vc.nmro_cntrto
				and c.cnsctvo_cbrnza			= vc.cnsctvo_cbrnza
				and vc.cnsctvo_scrsl_ctznte		= sp.cnsctvo_scrsl 
			inner join	[bdAfiliacion].dbo.tbProductosCobranza					pc With (Nolock)
				on	c.cnsctvo_cdgo_tpo_cntrto	= pc.cnsctvo_cdgo_tpo_cntrto
				and c.nmro_cntrto				= pc.nmro_cntrto
				and c.cnsctvo_cbrnza			= pc.cnsctvo_cbrnza
				--and sp.cnsctvo_prdcto_scrsl		= pc.cnsctvo_prdcto_scrsl
				and sp.cnsctvo_prdcto			= pc.cnsctvo_prdcto 
			inner join BdAfiliacion.dbo.tbContratos								cn With(NoLock)
				on cn.cnsctvo_cdgo_tpo_cntrto	= c.cnsctvo_cdgo_tpo_cntrto
				and cn.nmro_cntrto				= c.nmro_cntrto
			where	c.cnsctvo_cdgo_tpo_cntrto	= 2	 
			--and		c.estdo						= @ACTIVO 
			and		vc.estdo_rgstro				= @VALIDO
			and		@ldFechaCorte  between vc.inco_vgnca_cbrnza			and vc.fn_vgnca_cbrnza
			and		pc.estdo_rgstro				= @VALIDO
			and		@ldFechaCorte  between pc.inco_vgnca				and pc.fn_vgnca
			--and		cn.estdo_cntrto				= @ACTIVO
			
			truncate table #tmpBeneficiarios
			insert into #tmpBeneficiarios
			select 
				c.cnsctvo_cdgo_tpo_cntrto, 
				c.nmro_cntrto, 
				b.cnsctvo_bnfcro, 
				b.nmro_unco_idntfccn_bnfcro,
				c.nmro_unco_idntfccn_empldr,
				c.cnsctvo_cdgo_clse_aprtnte,
				c.cnsctvo_scrsl,
				CAST (f.vlr AS numeric(12,0)) vlr,
				CAST (f.valor_iva_bene AS numeric(12,0)) iva	
				-- select *		
			from #tmpContratosVigentes c 
			inner join bdAfiliacion.dbo.tbVigenciasBeneficiarios vb With(NoLock)
			on vb.cnsctvo_cdgo_tpo_cntrto = c.cnsctvo_cdgo_tpo_cntrto
			and vb.nmro_cntrto = c.nmro_cntrto
			inner join temporal.dbo.beneficiariosFacturar_pedido f on vb.cnsctvo_cdgo_tpo_cntrto = f.cnsctvo_cdgo_tpo_cntrto
																	and vb.nmro_cntrto = f.nmro_cntrto
																	and vb.cnsctvo_bnfcro = f.cnsctvo_bnfcro
			inner join bdAfiliacion.dbo.tbBeneficiarios b With(NoLock)
			on vb.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto
			and vb.nmro_cntrto = b.nmro_cntrto
			and vb.cnsctvo_bnfcro = b.cnsctvo_bnfcro
			inner join bdAfiliacion.dbo.tbVinculados v With(NoLock)
			on b.nmro_unco_idntfccn_bnfcro  = v.nmro_unco_idntfccn
			Inner Join bdAfiliacion.dbo.tbTiposIdentificacion ti With(NoLock)
			On ti.cnsctvo_cdgo_tpo_idntfccn	= v.cnsctvo_cdgo_tpo_idntfccn
			Inner Join bdAfiliacion.dbo.tbTiposAfiliado ta With(NoLock) 
			On b.cnsctvo_cdgo_tpo_afldo = ta.cnsctvo_cdgo_tpo_afldo
			where @ldFechaCorte  between vb.inco_vgnca_estdo_bnfcro and vb.fn_vgnca_estdo_bnfcro
			and vb.estdo_rgstro=@VALIDO
			--and b.estdo=@ACTIVO 
			select * from temporal.dbo.beneficiariosFacturar_pedido
			/*
			select a.* from temporal.dbo.beneficiariosFacturar_pedido a
			left join #tmpContratosVigentes b on a.nmro_cntrto = b.nmro_cntrto and a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn_empldr
			where b.nmro_cntrto is null

				select a.* from temporal.dbo.beneficiariosFacturar_pedido a
			left join #tmpBeneficiarios b on a.nmro_cntrto = b.nmro_cntrto and a.nmro_unco_idntfccn_bnfcro = b.nmro_unco_idntfccn_bnfcro
			where b.nmro_cntrto is null
			*/

				insert into #tmpTarifaSucursal 
			Select distinct 
				 ROW_NUMBER() OVER(ORDER BY a.nmro_unco_idntfccn_empldr ASC) nm_rgstro,
				 a.nmro_unco_idntfccn_empldr, 
				 a.cnsctvo_cdgo_clse_aprtnte,  
				 a.cnsctvo_scrsl, 
				 sum(b.vlr),
				 (@lnConsecutivoCodigoLiquidacion  + 1) cnsctvo_cdgo_crtro_lqdcn,
				 a.nmro_unco_idntfccn_empldr,
				  a.cnsctvo_cdgo_clse_aprtnte,  
				 a.cnsctvo_scrsl
				 -- select *
			from #tmpSucursalesProducto a    
				Inner join temporal.dbo.beneficiariosFacturar_pedido b With(NoLock)
				on  a.nmro_unco_idntfccn_empldr  = b.nmro_unco_idntfccn_empldr	
					and a.cnsctvo_cdgo_clse_aprtnte = b.cnsctvo_cdgo_clse_aprtnte
					and a.cnsctvo_scrsl = b.cnsctvo_scrsl
					and a.cnsctvo_prdcto = b.cnsctvo_prdcto
			group by  a.nmro_unco_idntfccn_empldr, 
				 a.cnsctvo_cdgo_clse_aprtnte,  
				 a.cnsctvo_scrsl

				 

		set @logTxt += 'spPoblarTablasPlanesPLUS			         - @codigoSalida: '+CAST(@codigoSalida AS VARCHAR(12))+' @mensajeSalida: '+@mensajeSalida+@lcSaltoLinea
						--print @logTxt

						
	IF exists(select top 1 1 from #tmpSucursalesProducto)
		BEGIN
	
	
		Declare @lnMaxCnsctvo_cdgo_crtro_lqdcn int=0
	
		Set @mnsje_slda	= '';
		Set @cdgo_slda = 0;

		Select @lnMaxCnsctvo_cdgo_crtro_lqdcn=isnull(max(cnsctvo_cdgo_crtro_lqdcn),0) From dbo.tbcriteriosliquidacion with(nolock);

		insert into dbo.tbcriteriosliquidacion
		(
			cnsctvo_cdgo_crtro_lqdcn,
			cnsctvo_cdgo_lqdcn,
			cnsctvo_cdgo_sde,
			nmro_unco_idntfccn_empldr,
			cnsctvo_scrsl,
			cnsctvo_cdgo_clse_aprtnte
		)
		Select	
				(ROW_NUMBER() OVER(ORDER BY nmro_unco_idntfccn_empldr ASC)	+	@lnMaxCnsctvo_cdgo_crtro_lqdcn ),
				@lnNuevoConsCodigoLiquidacion,	
				cnsctvo_cdgo_sde,
				nmro_unco_idntfccn_empldr,
				cnsctvo_scrsl,
				cnsctvo_cdgo_clse_aprtnte
		From	#tmpSucursalesProducto  

		if @@error <> 0
		begin
			-- rollback tran
			return
		end

		SET @filasAfectadas=@@ROWCOUNT

					set @logTxt += 'spRegistrarCriteriosLiquidacionPLUS          - @codigoSalida: '+CAST(@codigoSalida AS VARCHAR(12))+' @mensajeSalida: '+@mensajeSalida+@lcSaltoLinea
					--print @logTxt

		
		Create table #TmpEstadoCuentaNum
	(
		ID_Num						int IDENTITY(1,1), 
		cnsctvo_estdo_cnta			int,
		nmro_estdo_cnta				varchar(15)
	)
		
		Declare @lnMaximoConsecutivoEstadoCuenta int,
			@consecutivoEstadoDocumentoIngresado int=1,
			@vlr_actl							int,
			@vlr_antrr							int,
			@CONSECUTIVO_COD_ESTADO_CUENTA		tinyint=1,
			@lnConsCodigoResolucionDIAN	int = 2, -- PAC
			@lnConsCodigoTipoDocumento	int =6, -- Factura
			@INMEDIATO varchar(10) = 'INMEDIATO',
			@lcMensaje	varchar(500),
			@lnCodigo	int

		--set @lcUsuario = 'Procesos'


		Select	@lnMaximoConsecutivoEstadoCuenta = isnull(max(cnsctvo_estdo_cnta) ,0)
		From	dbo.tbEstadosCuenta with(nolock)

		Insert into	dbo.tbEstadosCuenta
		(
			cnsctvo_estdo_cnta,
			cnsctvo_cdgo_lqdcn,
			fcha_gnrcn,
			nmro_unco_idntfccn_empldr,
			cnsctvo_scrsl,
			cnsctvo_cdgo_clse_aprtnte,
			ttl_fctrdo,
			vlr_iva,
			sldo_fvr,
			ttl_pgr,
			sldo_estdo_cnta,
			sldo_antrr,
			Cts_Cnclr,
			Cts_sn_Cnclr,
			nmro_estdo_cnta,
			cnsctvo_cdgo_estdo_estdo_cnta,
			usro_crcn,
			Fcha_crcn,
			fcha_imprsn,
			cnsctvo_cdgo_prdcdd_prpgo,
			dgto_chqo,
			imprso,
			usro_imprsn,
			cnsctvo_cdgo_estdo_dcmnto_fe,
			txto_vncmnto,
			cnsctvo_cdgo_rslcn_dn,
			cnsctvo_cdgo_tpo_dcmnto
		)
		Select 		
				nm_rgstro +  @lnMaximoConsecutivoEstadoCuenta ,
				@lnNuevoConsCodigoLiquidacion,
				getdate(),  --fcha_gnrcn,
				nmro_unco_idntfccn_rspnsble,
				cnsctvo_scrsl_rspnsble,
				cnsctvo_cdgo_clse_aprtnte_rspnsble,
				0,--ttl_fctrdo
				0,--vlr_iva
				0,--sldo_fvr
				0,--ttl_pgr
				0,--sldo_estdo_cnta
				@sldo_antrr,--sldo_antrr
				1,--Cts_Cnclr
				0,--Cts_sn_Cnclr
				0,--nmro_estdo_cnta
				@CONSECUTIVO_COD_ESTADO_CUENTA,--cnsctvo_cdgo_estdo_estdo_cta
				@lcUsuario, --usro_crcn
				getdate(),--Fcha_crcn
				null, --fcha_imprsn
				1,
				null,		--digito de chequeo
				'N',		--Impreso
				@lcUsuario,		--Usuario de creacion
				@consecutivoEstadoDocumentoIngresado,
				null,
				@lnConsCodigoResolucionDIAN,
				@lnConsCodigoTipoDocumento		
				-- select *	
		From	#tmpTarifaSucursal

		SET @lnNumEstadosCuentaCreados= @@ROWCOUNT

		if @@error <> 0
		begin
			-- rollback tran
			return
		end
			--Estados de cuenta creados


		Insert Into	#TmpEstadoCuentaNum
		Select 		cnsctvo_estdo_cnta,
					Convert(varchar(15),'0')	nmro_estdo_cnta
		From		dbo.tbEstadosCuenta With(NoLock)
		Where 		cnsctvo_cdgo_lqdcn 	=	 @lnNuevoConsCodigoLiquidacion

		
		insert into #tmpEstadosCuentaPlus
		Select 
			cnsctvo_estdo_cnta,
			cnsctvo_cdgo_lqdcn,
			fcha_gnrcn,
			nmro_unco_idntfccn_empldr,
			cnsctvo_scrsl,
			cnsctvo_cdgo_clse_aprtnte,
			ttl_fctrdo,
			vlr_iva,
			sldo_fvr,
			ttl_pgr,
			sldo_estdo_cnta,
			sldo_antrr,
			Cts_Cnclr,
			Cts_sn_Cnclr,
			nmro_estdo_cnta,
			cnsctvo_cdgo_estdo_dcmnto_fe,
			txto_vncmnto
			from dbo.tbEstadosCuenta with(nolock)
		where cnsctvo_cdgo_lqdcn=@lnNuevoConsCodigoLiquidacion;

		set @logTxt =  'spRegistrarEstadosCuentaPLUS                 - @codigoSalida: '+CAST(@codigoSalida AS VARCHAR(12))+' @mensajeSalida: '+@mensajeSalida+@lcSaltoLinea										
					--print @logTxt
										
		
		Declare	@lnMaximoConsecutivoContratoEstadoCuenta	udtConsecutivo=1,
				@CONCEPTO_IVA INT=3
					
		insert into #tmpTotalEstadoCuenta 
		(cnsctvo_estdo_cnta_cntrto_tmp,
		cnsctvo_estdo_cnta,
		cnsctvo_cdgo_tpo_cntrto,
		nmro_cntrto,
		vlr_cbrdo,
		sldo,
		sldo_fvr,
		cntdd_bnfcrs,
		fcha_ultma_mdfccn,
		usro_ultma_mdfccn,
		vlr_trfa,
		vlr_iva)
		Select 		
				@lnMaximoConsecutivoContratoEstadoCuenta cnsctvo_estdo_cnta_cntrto_tmp,
				c.cnsctvo_estdo_cnta,
				a.cnsctvo_cdgo_tpo_cntrto,
				a.nmro_cntrto,
				sum(a.vlr+a.iva),
				sum(a.vlr+a.iva),
				0 sldo_fvr, --Sldo_fvr  del contrato
				count(1) cntdd_bnfcrs, --cntdd_bnfcrs
				getdate() fcha_ultma_mdfccn,
				@lcUsuario usro_ultma_mdfccn,
				sum(a.vlr), -- vlr_cbrdo
				sum(a.iva) --sldo
				-- select a.*
		From #tmpBeneficiarios a
		inner join #tmpTarifaSucursal b
			on b.nmro_unco_idntfccn_empldr=a.nmro_unco_idntfccn_empldr
			AND b.cnsctvo_cdgo_clse_aprtnte_empldr=a.cnsctvo_cdgo_clse_aprtnte
			AND b.cnsctvo_scrsl_empldr=a.cnsctvo_scrsl 
		inner join #tmpEstadosCuentaPlus c
			on 	b.nmro_unco_idntfccn_rspnsble=c.nmro_unco_idntfccn_empldr
			AND b.cnsctvo_cdgo_clse_aprtnte_rspnsble=c.cnsctvo_cdgo_clse_aprtnte
			AND b.cnsctvo_scrsl_rspnsble=c.cnsctvo_scrsl 
      	group by c.cnsctvo_estdo_cnta, a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto

			
		insert into #tmpResumenEstadoCuenta
		Select 
			cnsctvo_estdo_cnta, 
			sum(vlr_trfa) ttl_fctrdo, 
			sum(vlr_iva)  vlr_iva,
			sum(vlr_trfa)+sum(vlr_iva)+@sldo_antrr ttl_pgr,
			sum(vlr_trfa)+sum(vlr_iva) sldo_estdo_cnta
		From  #tmpTotalEstadoCuenta 
		group by cnsctvo_estdo_cnta 

		if not exists(select top 1 1 from #tmpResumenEstadoCuenta)
		begin
			select 'No inserta Datos #tmpResumenEstadoCuenta'
			-- rollback tran
			return
		end
		-- Actualizamos el total que se debe pagar por cuenta
		update a 
			Set a.ttl_fctrdo=b.ttl_fctrdo,
				a.vlr_iva=b.vlr_iva,
				a.ttl_pgr=b.ttl_pgr,
				a.sldo_estdo_cnta=b.sldo_estdo_cnta 
			from dbo.tbEstadosCuenta a with(nolock)
			inner join #tmpResumenEstadoCuenta b
			on a.cnsctvo_estdo_cnta=b.cnsctvo_estdo_cnta

		if @@error <> 0
		begin
			-- rollback tran
			return
		end

		Select	@lnMaximoConsecutivoContratoEstadoCuenta =max(cnsctvo_estdo_cnta_cntrto)
		From	dbo.TbEstadosCuentaContratos with(nolock)

		Insert into	dbo.TbEstadosCuentaContratos
		(
			cnsctvo_estdo_cnta_cntrto,
			cnsctvo_estdo_cnta,
			cnsctvo_cdgo_tpo_cntrto,
			nmro_cntrto,
			vlr_cbrdo,
			sldo,
			sldo_fvr,
			cntdd_bnfcrs,
			fcha_ultma_mdfccn,
			usro_ultma_mdfccn
		)
		select 
			ROW_NUMBER() OVER(ORDER BY cnsctvo_estdo_cnta ASC)  + @lnMaximoConsecutivoContratoEstadoCuenta,
			cnsctvo_estdo_cnta,
			cnsctvo_cdgo_tpo_cntrto,
			nmro_cntrto,
			vlr_cbrdo,
			sldo,
			sldo_fvr,
			cntdd_bnfcrs,
			fcha_ultma_mdfccn,
			usro_ultma_mdfccn
		From #tmpTotalEstadoCuenta 

		if @@error <> 0
		begin
		select 'Error insertando dbo.TbEstadosCuentaContratos'
			-- rollback tran
			return
		end
		--Recuperamos los estados de cuentas contratos que se acaban de insertar
		insert into #tmpEstadosCuentaContratos
		Select 
			a.cnsctvo_estdo_cnta_cntrto,
			a.cnsctvo_estdo_cnta,
			a.cnsctvo_cdgo_tpo_cntrto,
			a.nmro_cntrto,
			a.vlr_cbrdo,
			a.sldo,
			a.sldo_fvr,
			a.cntdd_bnfcrs,
			a.fcha_ultma_mdfccn,
			a.usro_ultma_mdfccn
		From dbo.TbEstadosCuentaContratos a With(NoLock) 
			inner join dbo.tbEstadosCuenta b With(NoLock)  
			on a.cnsctvo_estdo_cnta=b.cnsctvo_estdo_cnta
		Where cnsctvo_estdo_cnta_cntrto> @lnMaximoConsecutivoContratoEstadoCuenta
		and b.cnsctvo_cdgo_lqdcn=@lnNuevoConsCodigoLiquidacion;
		
		set @logTxt +=  'spRegistrarEstadosCuentaContratosPLUS        - @codigoSalida: '+CAST(@codigoSalida AS VARCHAR(12))+' @mensajeSalida: '+@mensajeSalida+@lcSaltoLinea	
					--print @logTxt 
																											
Declare	@lnMaximoConsecutivoCuentaContsBeneficiarios udtConsecutivo

Select	@lnMaximoConsecutivoCuentaContsBeneficiarios = isnull(max(cnsctvo_estdo_cnta_cntrto_bnfcro) ,0)
		From	dbo.tbCuentasContratosBeneficiarios with(nolock)

		-- Identificamos los estados de cuenta de los beneficiarios
		insert into #tmpCuentasContratosBeneficiarios
		Select 		
				ROW_NUMBER() OVER(ORDER BY e.cnsctvo_estdo_cnta_cntrto ASC)+@lnMaximoConsecutivoCuentaContsBeneficiarios  cnsctvo_estdo_cnta_cntrto_bnfcro,
				e.cnsctvo_estdo_cnta_cntrto,
				a.cnsctvo_bnfcro,
				a.nmro_unco_idntfccn_bnfcro, 
				a.vlr+a.iva,
				a.vlr
				-- select *
		From #tmpBeneficiarios a
		inner join #tmpTarifaSucursal b
			on b.nmro_unco_idntfccn_empldr=a.nmro_unco_idntfccn_empldr
			AND b.cnsctvo_cdgo_clse_aprtnte_empldr=a.cnsctvo_cdgo_clse_aprtnte
			AND b.cnsctvo_scrsl_empldr=a.cnsctvo_scrsl 
		inner join #tmpEstadosCuentaPlus c
			on 	b.nmro_unco_idntfccn_rspnsble=c.nmro_unco_idntfccn_empldr
			AND b.cnsctvo_cdgo_clse_aprtnte_rspnsble=c.cnsctvo_cdgo_clse_aprtnte
			AND b.cnsctvo_scrsl_rspnsble=c.cnsctvo_scrsl 
		inner join #tmpEstadosCuentaContratos e With(NoLock) 
		on  e.cnsctvo_estdo_cnta=c.cnsctvo_estdo_cnta 
		and e.cnsctvo_cdgo_tpo_cntrto=a.cnsctvo_cdgo_tpo_cntrto
		and	e.nmro_cntrto=a.nmro_cntrto


		Insert into dbo.tbCuentasContratosBeneficiarios (
				cnsctvo_estdo_cnta_cntrto_bnfcro,
				cnsctvo_estdo_cnta_cntrto,
				cnsctvo_bnfcro,
				nmro_unco_idntfccn_bnfcro, 
				vlr 
		)
		Select 
				cnsctvo_estdo_cnta_cntrto_bnfcro,
				cnsctvo_estdo_cnta_cntrto,
				cnsctvo_bnfcro,
				nmro_unco_idntfccn_bnfcro, 
				vlr 
		from #tmpCuentasContratosBeneficiarios

		if @@error <> 0
		begin
			-- rollback tran
			return
		end

	set @logTxt += 'spRegistrarCuentasContratosBeneficiariosPLUS - @codigoSalida: '+CAST(@codigoSalida AS VARCHAR(12))+' @mensajeSalida: '+@mensajeSalida+@lcSaltoLinea										
					--print @logTxt

		Insert into dbo.tbCuentasBeneficiariosConceptos(
			cnsctvo_estdo_cnta_cntrto_bnfcro,
			cnsctvo_cdgo_cncpto_lqdcn,
			vlr
		)
		select 
			cnsctvo_estdo_cnta_cntrto_bnfcro,
			4,--c.cnsctvo_cdgo_cncpto_lqdcn,
			sum(b.vlr)
		from #tmpCuentasContratosBeneficiarios a
		inner join temporal.dbo.beneficiariosFacturar_pedido b on a.nmro_unco_idntfccn_bnfcro = b.nmro_unco_idntfccn_bnfcro and a.cnsctvo_bnfcro = b.cnsctvo_bnfcro
		--inner join dbo.tbConceptosLiquidacion_Vigencias c with(nolock) on b.cnsctvo_cdgo_pln = c.cnsctvo_cdgo_pln
		--where getdate() between c.inco_vgnca and c.fn_vgnca and c.cnsctvo_cdgo_tpo_mvmnto = 1 and c.oprcn = 3
		group by cnsctvo_estdo_cnta_cntrto_bnfcro;
		
		if @@error <> 0
		begin
			-- rollback tran
			return
		end

		--Registramos el IVA del concepto 
		Insert into dbo.tbCuentasBeneficiariosConceptos(
			cnsctvo_estdo_cnta_cntrto_bnfcro,
			cnsctvo_cdgo_cncpto_lqdcn,
			vlr
		)
		select 
			cnsctvo_estdo_cnta_cntrto_bnfcro,
			3,--IVA
			sum(b.valor_iva_bene)
		from #tmpCuentasContratosBeneficiarios a
		inner join temporal.dbo.beneficiariosFacturar_pedido b on a.nmro_unco_idntfccn_bnfcro = b.nmro_unco_idntfccn_bnfcro and a.cnsctvo_bnfcro = b.cnsctvo_bnfcro
		group by cnsctvo_estdo_cnta_cntrto_bnfcro; 

		if @@error <> 0
		begin
			-- rollback tran
			return
		end

		set @logTxt += 'spRegistrarCuentasBeneficiariosConceptosPLUS - @codigoSalida: '+CAST(@codigoSalida AS VARCHAR(12))+' @mensajeSalida: '+@mensajeSalida+@lcSaltoLinea										
					--print @logTxt
		
		Declare @lnMaximoEstadosCuentaConceptos	udtConsecutivo

		insert into #tmpEstadosCuentaConceptos
		Select 
				@lnMaximoEstadosCuentaConceptos cnsctvo_estdo_cnta_cncpto_tmp,
				a.cnsctvo_estdo_cnta,
				cl.cnsctvo_cdgo_cncpto_lqdcn,
				sum(d.vlr) vlr_cbrdo, --vlr_cbrdo
				sum(d.vlr) sldo, --sldo
				count(distinct(b.nmro_cntrto))  cntdd -- cntdd 
		from dbo.tbEstadosCuenta a With(NoLock) 
		inner join dbo.tbEstadosCuentaContratos b With(NoLock) 
		on a.cnsctvo_estdo_cnta=b.cnsctvo_estdo_cnta 
		inner join dbo.tbCuentasContratosBeneficiarios c With(NoLock)
		on c.cnsctvo_estdo_cnta_cntrto=b.cnsctvo_estdo_cnta_cntrto 
		--inner join dbo.tbCuentasBeneficiariosConceptos d With(NoLock)
		--on d.cnsctvo_estdo_cnta_cntrto_bnfcro=c.cnsctvo_estdo_cnta_cntrto_bnfcro
		inner join temporal.dbo.beneficiariosFacturar_pedido d on c.nmro_unco_idntfccn_bnfcro = d.nmro_unco_idntfccn_bnfcro and c.cnsctvo_bnfcro = d.cnsctvo_bnfcro
		inner join dbo.tbConceptosLiquidacion_Vigencias cl with(nolock) on d.cnsctvo_cdgo_pln = cl.cnsctvo_cdgo_pln
		where a.cnsctvo_cdgo_lqdcn=@lnNuevoConsCodigoLiquidacion
		and @ldFechaCorte between cl.inco_vgnca and cl.fn_vgnca and cl.cnsctvo_cdgo_tpo_mvmnto = 1 and cl.oprcn = 3
		group by a.cnsctvo_estdo_cnta,cl.cnsctvo_cdgo_cncpto_lqdcn

		insert into #tmpEstadosCuentaConceptos
		Select 
				@lnMaximoEstadosCuentaConceptos cnsctvo_estdo_cnta_cncpto_tmp,
				a.cnsctvo_estdo_cnta,
				3,
				sum(d.valor_iva_bene) vlr_cbrdo, --vlr_cbrdo
				sum(d.valor_iva_bene) sldo, --sldo
				count(distinct(b.nmro_cntrto)) cntdd -- cntdd 
		from dbo.tbEstadosCuenta a With(NoLock) 
		inner join dbo.tbEstadosCuentaContratos b With(NoLock) 
		on a.cnsctvo_estdo_cnta=b.cnsctvo_estdo_cnta 
		inner join dbo.tbCuentasContratosBeneficiarios c With(NoLock)
		on c.cnsctvo_estdo_cnta_cntrto=b.cnsctvo_estdo_cnta_cntrto 
		--inner join dbo.tbCuentasBeneficiariosConceptos d With(NoLock)
		--on d.cnsctvo_estdo_cnta_cntrto_bnfcro=c.cnsctvo_estdo_cnta_cntrto_bnfcro
		inner join temporal.dbo.beneficiariosFacturar_pedido d on c.nmro_unco_idntfccn_bnfcro = d.nmro_unco_idntfccn_bnfcro and c.cnsctvo_bnfcro = d.cnsctvo_bnfcro
		where a.cnsctvo_cdgo_lqdcn=@lnNuevoConsCodigoLiquidacion
		group by a.cnsctvo_estdo_cnta

		Select	@lnMaximoEstadosCuentaConceptos = isnull(max(cnsctvo_estdo_cnta_cncpto) ,0)
		From	dbo.tbEstadosCuentaConceptos with(nolock)

		-- Totalizamos la cuenta por concepto 
		INSERT INTO dbo.tbEstadosCuentaConceptos
					(cnsctvo_estdo_cnta_cncpto
					,cnsctvo_estdo_cnta
					,cnsctvo_cdgo_cncpto_lqdcn
					,vlr_cbrdo
					,sldo
					,cntdd)
		Select
					@lnMaximoEstadosCuentaConceptos+ROW_NUMBER() OVER(ORDER BY cnsctvo_estdo_cnta_cncpto_tmp ASC)
					,cnsctvo_estdo_cnta
					,cnsctvo_cdgo_cncpto_lqdcn
					,vlr_cbrdo
					,sldo
					,cntdd
		from #tmpEstadosCuentaConceptos

		if @@error <> 0
		begin
			-- rollback tran
			return
		end

	set @logTxt += 'spRegistrarEstadosCuentaConceptosPLUS        - @codigoSalida: '+CAST(@codigoSalida AS VARCHAR(12))+' @mensajeSalida: '+@mensajeSalida+@lcSaltoLinea											
	--print @logTxt


	Declare @ldValorLiquidado udtValorDecimales =0,
	    @lnNumEstadosCuenta int=0,
		@lnNumContratos int=0,
        @lnMaximoHistoricoEstadoLiquidacion	udtConsecutivo,
		@ESTADO_LIQU_FINALIZADA int=3
	
	Select 
			@ldValorLiquidado = sum(vlr_cbrdo),
			@lnNumEstadosCuenta = count(cnsctvo_estdo_cnta) 
		from #tmpEstadosCuentaConceptos 
		where cnsctvo_cdgo_cncpto_lqdcn <> 3
	
	Select 
			 @lnNumContratos=count(b.nmro_cntrto) 	
		from dbo.tbEstadosCuenta a With(NoLock) 
		inner join dbo.tbEstadosCuentaContratos b With(NoLock) 
		on a.cnsctvo_estdo_cnta=b.cnsctvo_estdo_cnta 
		where a.cnsctvo_cdgo_lqdcn=@lnNuevoConsCodigoLiquidacion

	Select	@lnMaximoHistoricoEstadoLiquidacion = isnull(max(cnsctvo_hstrco_estdo_lqdcn) ,0)
			From	dbo.tbHistoricoEstadoLiquidacion With(NoLock) 

	    --Actualizamos la liquidacion con los valores calculados
		Update dbo.tbLiquidaciones 
			set nmro_estds_cnta=@lnNumEstadosCuenta,
				vlr_lqddo=@ldValorLiquidado,
				nmro_cntrts=@lnNumContratos,
				cnsctvo_cdgo_estdo_lqdcn=@ESTADO_LIQU_FINALIZADA
		Where cnsctvo_cdgo_lqdcn=@lnNuevoConsCodigoLiquidacion;

		if @@error <> 0
		begin
			-- rollback tran
			return
		end

		--Si se liquidaron contratos plus, se registra la información de facturación electronica
		If 	@lnNumContratos > 0
		Begin 

			EXEC [dbo].[spRegistrarInfoFEPLUS] 
											@lnNuevoConsCodigoLiquidacion, 
											@lcMensaje Output,
											@lnCodigo Output

		
		End	

		--Registro el historico de la liquidacion
		INSERT INTO dbo.tbHistoricoEstadoLiquidacion
				   (cnsctvo_hstrco_estdo_lqdcn
				   ,cnsctvo_cdgo_estdo_lqdcn
				   ,cnsctvo_cdgo_lqdcn
				   ,nmro_estds_cnta
				   ,vlr_lqddo
				   ,nmro_cntrts
				   ,usro_crcn
				   ,fcha_crcn)
		select (@lnMaximoHistoricoEstadoLiquidacion+1),
			   @ESTADO_LIQU_FINALIZADA,
			   @lnNuevoConsCodigoLiquidacion,
			   @lnNumEstadosCuenta,
			   @ldValorLiquidado,
			   @lnNumContratos,
			   @lcUsuario,
			   getdate()
		
		if @@error <> 0
		begin
			-- rollback tran
			return
		end

	set @logTxt += 'spRegistrarHistoricoEstadoLiquidacionPLUS    - @codigoSalida: '+CAST(@codigoSalida AS VARCHAR(12))+' @mensajeSalida: '+@mensajeSalida+@lcSaltoLinea	
					--print @logTxt									
																			
					exec dbo.spFinalizarProcesoCarteraPLUS
						@lnIdConsecutivoProceso,
						@mensajeSalida	Output,
						@codigoSalida	Output

					set @logTxt +=  'spFinalizarProcesoCarteraPLUS                - @codigoSalida: '+CAST(@codigoSalida AS VARCHAR(12))+' @mensajeSalida: '+@mensajeSalida+@lcSaltoLinea	
					--print @logTxt									


					
					Set @mnsje_slda	= 'Finalización exitosa del proceso de generación del estado de cuenta.';
					SET @detalleEjecucion = @logTxt
		END


--commit tran

--
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


