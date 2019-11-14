
/*---------------------------------------------------------------------------------
* Metodo o PRG   : spConsultaImpresionXdocumento
* Desarrollado por  : <\A Ing. Rolando simbaqueva Lasso         A\>
* Descripcion   : <\D Este procedimiento arma y ejecuta la cadena donde se tiene los criterios para seleccionar los promotores y sus sucursales  D\>
* Observaciones   : <\O               O\>
* Parametros   : <\P             P\>
* Variables   : <\V               V\>
* Fecha Creacion  : <\FC 2003/02/10           FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por   : <\AM Andres camelo (illustrato ltda)  AM\>
* Descripcion   : <\DM Se modifica para que imprima las notas de tipo Debito   DM\>
* Nuevos Parametros  : <\PM  PM\>
* Nuevas Variables  : <\VM  VM\>
* Fecha Modificacion  : <\FM 2013/11/22  FM\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por   : <\AM Francisco E. Riaño L - Qvision S.A  AM\>
* Descripcion   : <\DM Se modifica procedimiento para realizar ajustes de Facturación eléctronica   DM\>
* Nuevos Parametros : <\PM  PM\>
* Nuevas Variables  : <\VM  VM\>
* Fecha Modificacion  : <\FM 2019/06/13  FM\>
*---------------------------------------------------------------------------------*/
--exec [spConsultaImpresionXdocumento] 82541,1
CREATE   PROCEDURE [dbo].[spConsultaImpresionXdocumento](
	@nmro_dcmnto		varchar(20),
	@lnTipoDocumento	int
)
As
Begin
	Set Nocount On;

	Declare		@tbla							varchar(128),
				@cdgo_cmpo						varchar(128),
				@oprdr							varchar(2),
				@vlr							varchar(250),
				@cmpo_rlcn						varchar(128),
				@cmpo_rlcn_prmtro				varchar(128),
				@cnsctvo						Numeric(4),
				@IcInstruccion					Nvarchar(4000),
				@IcInstruccion1					Nvarchar(4000),
				@IcInstruccion2					Nvarchar(4000),
				@lcAlias						char(2),
				@fechaActual					datetime = getdate(),
				@consecutivoTipoContactoGeneral int = 1,
				@consecutivoTipoContactoFE		int = 2,
				@lnContador						Int = 1; -- contador de condiciones

	If @lnTipoDocumento = 1 
	begin
		SELECT	a.nmro_estdo_cnta,  
				f.cdgo_tpo_idntfccn,    
				d.nmro_idntfccn,   
				i.dscrpcn_clse_aprtnte,
				b.nmbre_scrsl,   
				space(200)  rzn_scl, 
				a.ttl_fctrdo,    
				a.usro_crcn,  
				a.cnsctvo_cdgo_lqdcn,  
				'NO SELECCIONADO'    accn,
				a.cnsctvo_estdo_cnta,   
				a.fcha_gnrcn,    
				a.nmro_unco_idntfccn_empldr,   
				a.cnsctvo_scrsl,  
				a.cnsctvo_cdgo_clse_aprtnte,      
				b.sde_crtra_pc     cnsctvo_cdgo_sde,    
				a.vlr_iva, 
				a.sldo_fvr,    
				a.ttl_pgr,    
				a.Cts_Cnclr,     
				a.Cts_sn_Cnclr,   
				c.cdgo_cdd,    
				c.dscrpcn_cdd,    
				e.dscrpcn_prdo,    
				e.cdgo_prdo,                
				f.dscrpcn_tpo_idntfccn,   
				b.drccn,     
				b.tlfno,      
				h.cnsctvo_cdgo_prdo_lqdcn,  
				h.fcha_incl_prdo_lqdcn   fcha_incl_fctrcn  ,   
				h.fcha_fnl_prdo_lqdcn fcha_fnl_fctrcn, 
				h.fcha_pgo,   a.sldo_antrr,   
				d.cnsctvo_cdgo_tpo_idntfccn,
				s.dscrpcn_sde,
				convert(int,nmro_estdo_cnta) nmro_Aux,
				s.cdgo_sde,
				j.prfjo_atrzdo_fctrcn as prefijofactura,	
				a.cufe as codigocufe,
				bdAfiliacionValidador.dbo.fnCalculaValorLetras(isnull(a.ttl_pgr,0)) as vlr_en_ltrs,	
				a.cdna_qr as codigoQR,   
				a.cnsctvo_cdgo_tpo_dcmnto,
				a.cdgo_brrs 
		Into	#TmpImpresionEstadosCuenta_aux
		FROM	tbEstadosCuenta a,   
				bdAfiliacion.dbo.tbCiudades c  , 
				bdAfiliacion.dbo.tbSucursalesAportante b   ,
				bdAfiliacion.dbo.tbPeriodos e  , 
				bdAfiliacion.dbo.tbVinculados d  ,
				bdAfiliacion.dbo.tbTiposIdentificacion f ,
				tbliquidaciones g    , 
				tbPeriodosliquidacion_Vigencias h  ,
				bdAfiliacion.dbo.tbClasesAportantes i  ,
				bdAfiliacion.dbo.Tbsedes  s,
				bdAfiliacionValidador.dbo.tbResolucionesDIAN_vigencias	j
		Where   a.ttl_pgr     >= 0 -- que el estado de cuenta tenga un valor a pagar mayor a cero
		AND  1=2

		Insert into #TmpImpresionEstadosCuenta_aux
		Select		a.nmro_estdo_cnta,  f.cdgo_tpo_idntfccn,   d.nmro_idntfccn,    i.dscrpcn_clse_aprtnte,
					b.nmbre_scrsl,   ' '  rzn_scl,    a.ttl_fctrdo,  
					a.usro_crcn,  
					a.cnsctvo_cdgo_lqdcn  , 
					'SELECCIONADO'   accn ,  
					a.cnsctvo_estdo_cnta,   a.fcha_gnrcn,     a.nmro_unco_idntfccn_empldr,
					a.cnsctvo_scrsl,   a.cnsctvo_cdgo_clse_aprtnte,        b.sde_crtra_pc,   a.vlr_iva, 
					a.sldo_fvr,    a.ttl_pgr,     a.Cts_Cnclr,    a.Cts_sn_Cnclr,
					c.cdgo_cdd,    ltrim(rtrim(c.dscrpcn_cdd)) +  ' -  ' +   + ltrim(rtrim(dp.dscrpcn_dprtmnto))  dscrpcn_cdd ,     e.dscrpcn_prdo,   e.cdgo_prdo,
					f.dscrpcn_tpo_idntfccn,   b.drccn,     b.tlfno,     h.cnsctvo_cdgo_prdo_lqdcn,
					h.fcha_incl_prdo_lqdcn     ,   h.fcha_fnl_prdo_lqdcn ,                 h.fcha_pgo,  a.sldo_antrr, 
					f.cnsctvo_cdgo_tpo_idntfccn , s.dscrpcn_sde,   convert(int,nmro_estdo_cnta) nmro_Aux, s.cdgo_sde,
					j.prfjo_atrzdo_fctrcn as prefijofactura,	
					a.cufe as codigocufe,
					bdAfiliacionValidador.dbo.fnCalculaValorLetras(isnull(a.ttl_pgr,0)) as vlr_en_ltrs,	
					a.cdna_qr as codigoQR,   
					a.cnsctvo_cdgo_tpo_dcmnto,
					a.cdgo_brrs  
		From		tbEstadosCuenta							a	With(NoLock)   				 
		Inner Join	bdAfiliacion.dbo.tbSucursalesAportante	b   With(Nolock)
			on		a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn_empldr 
			And		a.cnsctvo_scrsl					=	b.cnsctvo_scrsl 
			And		a.cnsctvo_cdgo_clse_aprtnte		=	b.cnsctvo_cdgo_clse_aprtnte 
		Inner Join	bdAfiliacion.dbo.tbciudades_vigencias	c  With(Nolock)
			on		b.cnsctvo_cdgo_cdd   = c.cnsctvo_cdgo_cdd 
		Inner Join	bdAfiliacion.dbo.tbdepartamentos		dp With(Nolock)
			on		c.cnsctvo_cdgo_dprtmnto  = dp.cnsctvo_cdgo_dprtmnto
		Inner Join	bdAfiliacion.dbo.tbPeriodos				e  With(NoLock) 
			on		a.cnsctvo_cdgo_prdcdd_prpgo   =  e.cnsctvo_cdgo_prdo 		 
		Inner Join	bdAfiliacion.dbo.tbVinculados			d  With(NoLock)
			on		a.nmro_unco_idntfccn_empldr   =  d.nmro_unco_idntfccn 
		Inner Join	bdAfiliacion.dbo.tbTiposIdentificacion	f With(NoLock)
			on		d.cnsctvo_cdgo_tpo_idntfccn   = f.cnsctvo_cdgo_tpo_idntfccn
		Inner Join	tbliquidaciones							g   With(NoLock)
			on		a.cnsctvo_cdgo_lqdcn    =  g.cnsctvo_cdgo_lqdcn 
		Inner Join	tbPeriodosliquidacion_Vigencias			h  With(NoLock)
			on		g.cnsctvo_cdgo_prdo_lqdcn   = h.cnsctvo_cdgo_prdo_lqdcn
		Inner Join	bdAfiliacion.dbo.Tbsedes				s With(NoLock)
			on		s.cnsctvo_cdgo_sde    = b.sde_crtra_pc
		Inner Join	bdAfiliacion.dbo.tbClasesAportantes		i  With(NoLock)
			on		b.cnsctvo_cdgo_clse_aprtnte   =  i.cnsctvo_cdgo_clse_aprtnte 	
		Inner Join	bdAfiliacionValidador.dbo.tbResolucionesDIAN_vigencias	j With(NoLock)
			On		j.cnsctvo_cdgo_rslcn_dn = a.cnsctvo_cdgo_rslcn_dn		 		
		Where		g.cnsctvo_cdgo_estdo_lqdcn   in (3,6)  --Finalizada y finalizada de prueba
		And			a.nmro_estdo_cnta   = @nmro_dcmnto
		And			@fechaActual between c.inco_vgnca and c.fn_vgnca
		And			datediff(dd,c.inco_vgnca,@fechaActual)>=0  And datediff(dd,@fechaActual,c.fn_vgnca)>=0 --Para evaluar la vigencia de ciudad

		update		a
		set			a.drccn = ltrim(rtrim(b.drccn)),
					a.tlfno = ltrim(rtrim(b.tlfno)),
					a.cdgo_cdd = c.cdgo_cdd,    
					a.dscrpcn_cdd = ltrim(rtrim(c.dscrpcn_cdd)) +  ' -  ' +   ltrim(rtrim(dp.dscrpcn_dprtmnto))
		from		#TmpImpresionEstadosCuenta_aux							a
		Inner Join	bdAfiliacion.dbo.tbDatosContactosxSucursalAportante		b with(nolock)
			on		a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn_empldr 
			AND		a.cnsctvo_scrsl = b.cnsctvo_scrsl 
			AND     a.cnsctvo_cdgo_clse_aprtnte = b.cnsctvo_cdgo_clse_aprtnte 
		Inner Join  bdAfiliacion.dbo.tbCiudades_Vigencias					c With(NoLock)
			ON		b.cnsctvo_cdgo_cdd = c.cnsctvo_cdgo_cdd 
		INNER JOIN  bdAfiliacion.dbo.tbDepartamentos						dp With(NoLock)
			ON		c.cnsctvo_cdgo_dprtmnto = dp.cnsctvo_cdgo_dprtmnto 
		where		b.cnsctvo_cdgo_tpo_cntcto = @consecutivoTipoContactoGeneral 
		and			@fechaActual between b.inco_vgnca and b.fn_vgnca
		And			@fechaActual between c.inco_vgnca and c.fn_vgnca

		update		a
		set			a.drccn = ltrim(rtrim(b.drccn)),
					a.tlfno = ltrim(rtrim(b.tlfno)),
					a.cdgo_cdd = c.cdgo_cdd,    
					a.dscrpcn_cdd = ltrim(rtrim(c.dscrpcn_cdd)) +  ' -  ' +   ltrim(rtrim(dp.dscrpcn_dprtmnto))
		from		#TmpImpresionEstadosCuenta_aux							a
		Inner Join	bdAfiliacion.dbo.tbDatosContactosxSucursalAportante		b with(nolock)
			on		a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn_empldr 
			AND		a.cnsctvo_scrsl = b.cnsctvo_scrsl 
			AND     a.cnsctvo_cdgo_clse_aprtnte = b.cnsctvo_cdgo_clse_aprtnte 
		Inner Join  bdAfiliacion.dbo.tbCiudades_Vigencias					c With(NoLock)
			ON		b.cnsctvo_cdgo_cdd = c.cnsctvo_cdgo_cdd 
		INNER JOIN  bdAfiliacion.dbo.tbDepartamentos						dp With(NoLock)
			ON		c.cnsctvo_cdgo_dprtmnto = dp.cnsctvo_cdgo_dprtmnto 
		where		b.cnsctvo_cdgo_tpo_cntcto = @consecutivoTipoContactoFE
		and			@fechaActual between b.inco_vgnca and b.fn_vgnca
		And			@fechaActual between c.inco_vgnca and c.fn_vgnca

		Update		a
		Set			a.rzn_scl  =  c.rzn_scl
		From		#TmpImpresionEstadosCuenta_aux  a 
		Inner Join	bdafiliacion.dbo.tbempleadores	b With(NoLock)
			on		a.nmro_unco_idntfccn_empldr  = b.nmro_unco_idntfccn
			And		a.cnsctvo_cdgo_clse_aprtnte  = b.cnsctvo_cdgo_clse_aprtnte 
		Inner Join	bdafiliacion.dbo.tbempresas		c With(NoLock)
			on		a.nmro_unco_idntfccn_empldr  = c.nmro_unco_idntfccn

		Update		a
		Set			a.rzn_scl  =   ltrim(rtrim(isnull(prmr_aplldo,'')))  + ' ' + ltrim(rtrim(isnull(sgndo_aplldo,''))) + ' ' + ltrim(rtrim(isnull(prmr_nmbre,''))) + ' ' + ltrim(rtrim(isnull(sgndo_nmbre,'')))
		From		#TmpImpresionEstadosCuenta_aux  a
		Inner Join	bdafiliacion.dbo.tbempleadores	b With(NoLock)
			on		a.nmro_unco_idntfccn_empldr  = b.nmro_unco_idntfccn
			And		a.cnsctvo_cdgo_clse_aprtnte  = b.cnsctvo_cdgo_clse_aprtnte 
		Inner Join	bdafiliacion.dbo.tbpersonas		c With(NoLock)
			on		a.nmro_unco_idntfccn_empldr  = c.nmro_unco_idntfccn
		Where		a.rzn_scl     = ''

		execute spAdicionaRegistrosImpresionEstadosCuentaManual
	End 
	Else
	Begin
		--2013/11/22 Andres camelo (illustrato ltda) Se modifica para que imprima las notas de tipo Debito 
		execute SpImprimirNota 1,@nmro_dcmnto
	End
End