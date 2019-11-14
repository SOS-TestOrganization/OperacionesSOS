
/*---------------------------------------------------------------------------------
* Metodo o PRG		: spConsultaImpresionEstadoCuenta
* Desarrollado por  : <\A	Ing. Jean Paul Villaquiran Madrigal A\>
* Descripcion		: <\D	Este procedimiento crea la informacion de de la generacion del estado de cuenta    D\>
* Observaciones		: <\O	O\>
* Parametros		: <\P   P\>
* Variables			: <\V   V\>
* Fecha Creacion	: <\FC	2019/07/31 FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por	: <\AM	AM\>
* Descripcion		: <\DM	DM\>
* Nuevos Parametros : <\PM	PM\>
* Nuevas Variables  : <\VM	VM\>
* Fecha Modificacion: <\FM	FM\>
*---------------------------------------------------------------------------------*/

create procedure [dbo].[spcr5EjecutaConsultaImpresionEstadoCuenta]
(
	@sede				int,
	@numeroliquiini		int,
	@numeroliquifin		int,
	@numeroFacturaInicial varchar(15),
	@numeroFacturFinal varchar(15)
)
as
Begin
			Set Nocount On;

			Declare			@tbla									varchar(128),
							@cdgo_cmpo								varchar(128),
							@oprdr									varchar(2),
							@vlr									varchar(250),
							@cmpo_rlcn								varchar(128),
							@cmpo_rlcn_prmtro						varchar(128),
							@cnsctvo								Numeric(4),
							@IcInstruccion							Nvarchar(4000),
							@IcInstruccion1							Nvarchar(4000),
							@IcInstruccion2							Nvarchar(4000),
							@lcAlias								char(2),
							@lnContador								Int,
							@consecutivoTipoContactoGeneral			int = 1,
							@consecutivoTipoContactoFE				int = 2,
							@consecutivoCodigoTipoDocumentoFactura	int = 6,
							@fechaActual							Datetime	= getdate(),
							@consecutivoCodigoClaseEmpleadorNatural smallint = 2,
							@consecutivoCodigoClaseAportanteIndependiente smallint = 4;

				create 
				table		#tbEstadosCuenta
							(
							cnsctvo_estdo_cnta dbo.udtConsecutivo
							)

				Create 
				table		#TmpImpresionEstadosCuenta_aux
							(  
							nmro_estdo_cnta				varchar(15),
							cdgo_tpo_idntfccn			varchar(4),
							nmro_idntfccn				varchar(23), 
							dscrpcn_clse_aprtnte		varchar(150),
							nmbre_scrsl					varchar(200),
							rzn_scl						varchar(200),
							ttl_fctrdo					numeric(12,0),
							usro_crcn					varchar(30),
							cnsctvo_cdgo_lqdcn			int,
							accn						varchar(50),
							cnsctvo_estdo_cnta			int,
							fcha_gnrcn					datetime,
							nmro_unco_idntfccn_empldr	int,
							cnsctvo_scrsl				int,
							cnsctvo_cdgo_clse_aprtnte	int,
							cnsctvo_cdgo_sde			int,
							vlr_iva						numeric(12,0),
							sldo_fvr					numeric(12,0),
							ttl_pgr						numeric(12,0),
							Cts_Cnclr					int,
							Cts_sn_Cnclr				int,
							cdgo_cdd					varchar(20),
							dscrpcn_cdd					varchar(400),
							dscrpcn_prdo				varchar(150),
							cdgo_prdo					varchar(6),
							dscrpcn_tpo_idntfccn		varchar(150),
							drccn						varchar(150),
							tlfno						varchar(50),
							cnsctvo_cdgo_prdo_lqdcn		int,
							fcha_incl_fctrcn			datetime ,
							fcha_fnl_fctrcn				datetime, 
							fcha_pgo					datetime,
							sldo_antrr					numeric(12,0),
							cnsctvo_cdgo_tpo_idntfccn	int,
							dscrpcn_sde					varchar(150),
							nmro_Aux					int,
							cdgo_sde					varchar(4),
							prefijofactura				varchar(10),
							codigocufe					varchar(max),
							vlr_en_ltrs					varchar(max),
							codigoQR					varchar(max),
							cnsctvo_cdgo_tpo_dcmnto		udtConsecutivo,
							cdgo_brrs					varchar(max),
							cnsctvo_cdgo_rslcn_dn		int
							)

				Insert into #TmpImpresionEstadosCuenta_aux
				Select		a.nmro_estdo_cnta,  
							f.cdgo_tpo_idntfccn,   
							d.nmro_idntfccn,    
							i.dscrpcn_clse_aprtnte,
							b.nmbre_scrsl,   
							' '  rzn_scl,    
							a.ttl_fctrdo,  
							a.usro_crcn,  
							a.cnsctvo_cdgo_lqdcn, 
							'NO SELECCIONADO'   accn,  
							a.cnsctvo_estdo_cnta,   
							a.fcha_gnrcn,     
							a.nmro_unco_idntfccn_empldr,
							a.cnsctvo_scrsl,   
							a.cnsctvo_cdgo_clse_aprtnte,        
							b.sde_crtra_pc,   
							a.vlr_iva, 
							a.sldo_fvr,    
							a.ttl_pgr,     
							a.Cts_Cnclr,    
							a.Cts_sn_Cnclr,
							c.cdgo_cdd,    
							ltrim(rtrim(c.dscrpcn_cdd)) +  ' -  ' +   ltrim(rtrim(dp.dscrpcn_dprtmnto))  dscrpcn_cdd,     
							e.dscrpcn_prdo,   
							e.cdgo_prdo, 
							f.dscrpcn_tpo_idntfccn,   
							b.drccn,     
							ltrim(rtrim(isnull (b.tlfno,''))),     
							h.cnsctvo_cdgo_prdo_lqdcn,
							h.fcha_incl_prdo_lqdcn,   
							h.fcha_fnl_prdo_lqdcn,                 
							h.fcha_pgo,  
							a.sldo_antrr, 
							f.cnsctvo_cdgo_tpo_idntfccn, 
							s.dscrpcn_sde,   
							convert(int,a.nmro_estdo_cnta) nmro_Aux, 
							s.cdgo_sde,
							null as prefijofactura,	
							a.cufe,
							bdAfiliacionValidador.dbo.fnCalculaValorLetras(isnull(a.ttl_pgr,0)),	
							a.cdna_qr,    
							a.cnsctvo_cdgo_tpo_dcmnto,
							a.cdgo_brrs,
							a.cnsctvo_cdgo_rslcn_dn   
				from		dbo.tbEstadosCuenta										a With(NoLock)					
				inner join  bdAfiliacion.dbo.tbSucursalesAportante					b With(NoLock)
					on		a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn_empldr 
					and		a.cnsctvo_scrsl = b.cnsctvo_scrsl 
					and     a.cnsctvo_cdgo_clse_aprtnte = b.cnsctvo_cdgo_clse_aprtnte 
				inner join  bdAfiliacion.dbo.tbCiudades_Vigencias					c With(NoLock)
					on		b.cnsctvo_cdgo_cdd = c.cnsctvo_cdgo_cdd 
				inner join  bdAfiliacion.dbo.tbDepartamentos						dp With(NoLock)
					on		c.cnsctvo_cdgo_dprtmnto = dp.cnsctvo_cdgo_dprtmnto 
				inner join  bdAfiliacion.dbo.tbPeriodos								e With(NoLock)
					on		a.cnsctvo_cdgo_prdcdd_prpgo = e.cnsctvo_cdgo_prdo 
				inner join  bdAfiliacion.dbo.tbVinculados							d With(NoLock)
					on		a.nmro_unco_idntfccn_empldr = d.nmro_unco_idntfccn 
				inner join  bdAfiliacion.dbo.tbTiposIdentificacion					f With(NoLock)
					on		d.cnsctvo_cdgo_tpo_idntfccn = f.cnsctvo_cdgo_tpo_idntfccn 
				inner join  dbo.tbLiquidaciones										g With(NoLock)
					on		a.cnsctvo_cdgo_lqdcn = g.cnsctvo_cdgo_lqdcn 
				inner join  dbo.tbPeriodosliquidacion_Vigencias						h With(NoLock)
					on		g.cnsctvo_cdgo_prdo_lqdcn = h.cnsctvo_cdgo_prdo_lqdcn 
				inner join  bdAfiliacion.dbo.tbSedes								s With(NoLock)
					on		b.sde_crtra_pc = s.cnsctvo_cdgo_sde 
				inner join  bdAfiliacion.dbo.tbClasesAportantes						i With(NoLock)
					on		b.cnsctvo_cdgo_clse_aprtnte = i.cnsctvo_cdgo_clse_aprtnte
				where		s.cnsctvo_cdgo_sde = @sede
				and			a.cnsctvo_cdgo_lqdcn between @numeroliquiini and @numeroliquifin
				and			a.nmro_estdo_cnta between @numeroFacturaInicial and @numeroFacturFinal
				and			(a.ttl_pgr > 0) AND (g.cnsctvo_cdgo_estdo_lqdcn = 3) 
				and			datediff(dd,c.inco_vgnca,@fechaActual)> = 0  And datediff(dd,@fechaActual,c.fn_vgnca)>=0 --Para evaluar la vigencia de ciudad  
				and			@fechaActual between h.inco_vgnca and h.fn_vgnca;    

				update		a
				set			a.drccn = ltrim(rtrim(b.drccn)),
							a.tlfno = ltrim(rtrim(b.tlfno)),
							a.cdgo_cdd = c.cdgo_cdd,    
							a.dscrpcn_cdd = ltrim(rtrim(c.dscrpcn_cdd)) +  ' -  ' +   ltrim(rtrim(dp.dscrpcn_dprtmnto))
				from		#TmpImpresionEstadosCuenta_aux							a
				inner join	bdAfiliacion.dbo.tbDatosContactosxSucursalAportante		b with(nolock)
					on		a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn_empldr 
					and		a.cnsctvo_scrsl = b.cnsctvo_scrsl 
					and     a.cnsctvo_cdgo_clse_aprtnte = b.cnsctvo_cdgo_clse_aprtnte 
				inner join  bdAfiliacion.dbo.tbCiudades_Vigencias					c With(NoLock)
					on		b.cnsctvo_cdgo_cdd = c.cnsctvo_cdgo_cdd 
				inner join  bdAfiliacion.dbo.tbDepartamentos						dp With(NoLock)
					on		c.cnsctvo_cdgo_dprtmnto = dp.cnsctvo_cdgo_dprtmnto 
				where		b.cnsctvo_cdgo_tpo_cntcto = @consecutivoTipoContactoGeneral 
				and			@fechaActual between b.inco_vgnca and b.fn_vgnca
				and			@fechaActual between c.inco_vgnca and c.fn_vgnca

				update		a
				set			a.drccn = ltrim(rtrim(b.drccn)),
							a.tlfno = ltrim(rtrim(b.tlfno)),
							a.cdgo_cdd = c.cdgo_cdd,    
							a.dscrpcn_cdd = ltrim(rtrim(c.dscrpcn_cdd)) +  ' -  ' +   ltrim(rtrim(dp.dscrpcn_dprtmnto))
				from		#TmpImpresionEstadosCuenta_aux							a
				inner join	bdAfiliacion.dbo.tbDatosContactosxSucursalAportante		b with(nolock)
					on		a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn_empldr 
					and		a.cnsctvo_scrsl = b.cnsctvo_scrsl 
					and     a.cnsctvo_cdgo_clse_aprtnte = b.cnsctvo_cdgo_clse_aprtnte 
				inner join  bdAfiliacion.dbo.tbCiudades_Vigencias					c With(NoLock)
					on		b.cnsctvo_cdgo_cdd = c.cnsctvo_cdgo_cdd 
				inner join  bdAfiliacion.dbo.tbDepartamentos						dp With(NoLock)
					on		c.cnsctvo_cdgo_dprtmnto = dp.cnsctvo_cdgo_dprtmnto 
				where		b.cnsctvo_cdgo_tpo_cntcto = @consecutivoTipoContactoFE
				and			@fechaActual between b.inco_vgnca and b.fn_vgnca
				and			@fechaActual between c.inco_vgnca and c.fn_vgnca

				Update 		a
				Set    		a.rzn_scl = b.rzn_scl
				From 		#TmpImpresionEstadosCuenta_aux 		a		
				Inner Join  bdAfiliacionValidador.dbo.tbEmpresas    b with(nolock)	
				On 			a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn
				inner join	BDAfiliacion.dbo.tbEmpleadores c
				on			c.nmro_unco_idntfccn = b.nmro_unco_idntfccn
				and			a.cnsctvo_cdgo_clse_aprtnte = c.cnsctvo_cdgo_clse_aprtnte
				inner join	BDAfiliacion.dbo.tbClasesEmpleador_Vigencias d
				on			c.cnsctvo_cdgo_clse_empldr = d.cnsctvo_cdgo_clse_empldr
				where		c.cnsctvo_cdgo_clse_aprtnte != @consecutivoCodigoClaseAportanteIndependiente
				and			d.cnsctvo_cdgo_clse_empldr != @consecutivoCodigoClaseEmpleadorNatural
				and			@fechaActual between d.inco_vgnca and d.fn_vgnca;

				Update 		a
				Set    		a.rzn_scl = rtrim(ltrim(b.prmr_nmbre))+' '+rtrim(ltrim(b.sgndo_nmbre))+' '+rtrim(ltrim(b.prmr_aplldo)) + ' ' + rtrim(ltrim(b.sgndo_aplldo))					
				From 		#TmpImpresionEstadosCuenta_aux 		a		
				Inner Join  bdAfiliacionValidador.dbo.tbPersonas    b with(nolock)	
				On 			a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn
				inner join	BDAfiliacion.dbo.tbEmpleadores c
				on			c.nmro_unco_idntfccn = b.nmro_unco_idntfccn
				and			a.cnsctvo_cdgo_clse_aprtnte = c.cnsctvo_cdgo_clse_aprtnte
				inner join	BDAfiliacion.dbo.tbClasesEmpleador_Vigencias d
				on			c.cnsctvo_cdgo_clse_empldr = d.cnsctvo_cdgo_clse_empldr
				where		(a.cnsctvo_cdgo_clse_aprtnte = @consecutivoCodigoClaseAportanteIndependiente
				or			d.cnsctvo_cdgo_clse_empldr = @consecutivoCodigoClaseEmpleadorNatural)
				and			@fechaActual between d.inco_vgnca and d.fn_vgnca;

				Update 		a
				Set    		a.rzn_scl = rtrim(ltrim(b.prmr_nmbre))+' '+rtrim(ltrim(b.sgndo_nmbre))+' '+rtrim(ltrim(b.prmr_aplldo)) + ' ' + rtrim(ltrim(b.sgndo_aplldo))					
				From 		#TmpImpresionEstadosCuenta_aux 		a	
				Inner Join	bdAfiliacionValidador.dbo.tbPersonas b with(nolock)	
				On			a.nmro_unco_idntfccn_empldr  = b.nmro_unco_idntfccn	
				where		(	
								a.nmbre_scrsl = '' 
								or
								a.nmbre_scrsl is null
							);

				update      a
				set         a.prefijofactura = b.prfjo_atrzdo_fctrcn
				from        #TmpImpresionEstadosCuenta_aux a
				inner join  BDAfiliacionValidador.dbo.tbResolucionesDIAN_Vigencias b
				on          a.cnsctvo_cdgo_rslcn_dn = b.cnsctvo_cdgo_rslcn_dn
				where       a.cnsctvo_cdgo_tpo_dcmnto = @consecutivoCodigoTipoDocumentoFactura
				And         @fechaActual Between b.inco_vgnca And b.fn_vgnca;

				execute		spAdicionaRegistrosImpresionEstadosCuentaManual

End

