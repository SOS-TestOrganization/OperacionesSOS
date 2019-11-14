
/*---------------------------------------------------------------------------------
* Metodo o PRG   : spcr3EjecutaConsultaImpresionEstadoCuenta
* Desarrollado por  : <\A Ing. Rolando simbaqueva Lasso         A\>
* Descripcion   : <\D Este procedimiento crea la informacion de de la generacion del estado de cuenta    D\>
* Observaciones   : <\O               O\>
* Parametros   : <\P             P\>
* Variables   : <\V               V\>
* Fecha Creacion  : <\FC 2003/02/10           FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por   : <\AM Rolando Simbaqueva Lasso AM\>
* Descripcion   : <\DM  Aplicacion tecnicas de optimizacion DM\>
* Nuevos Parametros  : <\PM  Numero Estado de cuenta PM\>
* Nuevas Variables  : <\VM  VM\>
* Fecha Modificacion  : <\FM  2005 / 08/ 29FM\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM  Francisco E. Riaño L.- Qvision S.A	AM\>
* Descripcion			: <\DM	Ajustes para facturacion Electronica DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion	: <\FM  30/04/2019	 FM\>
*---------------------------------------------------------------------------------
exec [dbo].[spcr3EjecutaConsultaImpresionEstadoCuenta] '161470','161470'
*/
CREATE PROCEDURE [dbo].[spcr3EjecutaConsultaImpresionEstadoCuenta]
(
	@NumeroEstadoIni varchar(15),
	@NumeroEstadoFin varchar(15)
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
				@lnContador						Int,
				@consecutivoTipoContactoGeneral int = 1,
				@consecutivoTipoContactoFE		int = 2,
				@fechaActual					Datetime	= getdate();

	Create table  #TmpImpresionEstadosCuenta_aux
	(  
		nmro_estdo_cnta				varchar(15),
		cdgo_tpo_idntfccn			varchar(4),
		nmro_idntfccn				varchar(20), 
		dscrpcn_clse_aprtnte		varchar(50),
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
		dscrpcn_cdd					varchar(100),
		dscrpcn_prdo				varchar(50),
		cdgo_prdo					varchar(6),
		dscrpcn_tpo_idntfccn		varchar(50),
		drccn						varchar(150),
		tlfno						varchar(20),
		cnsctvo_cdgo_prdo_lqdcn		int,
		fcha_incl_fctrcn			datetime,
		fcha_fnl_fctrcn				datetime, 
		fcha_pgo					datetime,
		sldo_antrr					numeric(12,0),
		cnsctvo_cdgo_tpo_idntfccn	int,
		dscrpcn_sde					varchar(50),
		nmro_Aux					int,
		cdgo_sde					varchar(4),
		prefijofactura				varchar(10),
		codigocufe					varchar(max),
		vlr_en_ltrs					varchar(max),
		codigoQR					varchar(max),
		cnsctvo_cdgo_tpo_dcmnto		udtConsecutivo,
		cdgo_brrs					varchar(max)
	)

	Insert Into #TmpImpresionEstadosCuenta_aux
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
				b.sde_crtra_pc,   a.vlr_iva, 
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
				b.tlfno,     
				h.cnsctvo_cdgo_prdo_lqdcn,
				h.fcha_incl_prdo_lqdcn,   
				h.fcha_fnl_prdo_lqdcn,                 
				h.fcha_pgo,  
				a.sldo_antrr, 
				f.cnsctvo_cdgo_tpo_idntfccn, 
				s.dscrpcn_sde,   
				convert(int,nmro_estdo_cnta) nmro_Aux, 
				s.cdgo_sde,
				j.prfjo_atrzdo_fctrcn as prefijofactura,	
				a.cufe,
				bdAfiliacionValidador.dbo.fnCalculaValorLetras(isnull(a.ttl_pgr,0)),	
				a.cdna_qr, 
				a.cnsctvo_cdgo_tpo_dcmnto,
				a.cdgo_brrs
	From		dbo.tbEstadosCuenta										a With(NoLock)
	INNER JOIN  bdAfiliacion.dbo.tbSucursalesAportante					b With(NoLock)
		ON		a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn_empldr 
		AND		a.cnsctvo_scrsl = b.cnsctvo_scrsl 
		AND     a.cnsctvo_cdgo_clse_aprtnte = b.cnsctvo_cdgo_clse_aprtnte 
	INNER JOIN  bdAfiliacion.dbo.tbCiudades_Vigencias					c With(NoLock)
		ON		b.cnsctvo_cdgo_cdd = c.cnsctvo_cdgo_cdd 
	INNER JOIN  bdAfiliacion.dbo.tbDepartamentos						dp With(NoLock)
		ON		c.cnsctvo_cdgo_dprtmnto = dp.cnsctvo_cdgo_dprtmnto 
	INNER JOIN  bdAfiliacion.dbo.tbPeriodos								e With(NoLock)
		ON		a.cnsctvo_cdgo_prdcdd_prpgo = e.cnsctvo_cdgo_prdo 
	INNER JOIN  bdAfiliacion.dbo.tbVinculados							d With(NoLock)
		ON		a.nmro_unco_idntfccn_empldr = d.nmro_unco_idntfccn 
	INNER JOIN  bdAfiliacion.dbo.tbTiposIdentificacion					f With(NoLock)
		ON		d.cnsctvo_cdgo_tpo_idntfccn = f.cnsctvo_cdgo_tpo_idntfccn 
	INNER JOIN  dbo.tbLiquidaciones										g With(NoLock)
		ON		a.cnsctvo_cdgo_lqdcn = g.cnsctvo_cdgo_lqdcn 
	INNER JOIN  dbo.tbPeriodosliquidacion_Vigencias						h With(NoLock)
		ON		g.cnsctvo_cdgo_prdo_lqdcn = h.cnsctvo_cdgo_prdo_lqdcn 
	INNER JOIN  bdAfiliacion.dbo.tbSedes								s With(NoLock)
		ON		b.sde_crtra_pc = s.cnsctvo_cdgo_sde 
	INNER JOIN  bdAfiliacion.dbo.tbClasesAportantes						i With(NoLock)
		ON		b.cnsctvo_cdgo_clse_aprtnte = i.cnsctvo_cdgo_clse_aprtnte
	INNER JOIN 	bdAfiliacionValidador.dbo.tbResolucionesDIAN_vigencias	j With(NoLock)
		On		j.cnsctvo_cdgo_rslcn_dn = a.cnsctvo_cdgo_rslcn_dn
	WHERE		(g.cnsctvo_cdgo_estdo_lqdcn = 3) 
	AND			a.nmro_estdo_cnta >= @NumeroEstadoIni   and  a.nmro_estdo_cnta <= @NumeroEstadoFin
	And			datediff(dd,c.inco_vgnca,@fechaActual)>=0  And datediff(dd,@fechaActual,c.fn_vgnca)>=0
	And			@fechaActual Between j.inco_vgnca And j.fn_vgnca

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
	Set			rzn_scl  =  c.rzn_scl
	From		#TmpImpresionEstadosCuenta_aux  a 
	Inner Join	bdafiliacion.dbo.tbempleadores  b With(NoLock)
		On		(a.nmro_unco_idntfccn_empldr  = b.nmro_unco_idntfccn
		And		a.cnsctvo_cdgo_clse_aprtnte  = b.cnsctvo_cdgo_clse_aprtnte )
	Inner Join  bdafiliacion.dbo.tbempresas		c With(NoLock)
		On		(a.nmro_unco_idntfccn_empldr  = c.nmro_unco_idntfccn)

	Update		a
	Set			rzn_scl  =   ltrim(rtrim(isnull(prmr_aplldo,'')))  + ' ' + ltrim(rtrim(isnull(sgndo_aplldo,''))) + ' ' + ltrim(rtrim(isnull(prmr_nmbre,''))) + ' ' + ltrim(rtrim(isnull(sgndo_nmbre,'')))
	From		#TmpImpresionEstadosCuenta_aux  a 
	Inner Join  bdafiliacion.dbo.tbempleadores  b With(NoLock)
		On		(a.nmro_unco_idntfccn_empldr  = b.nmro_unco_idntfccn
		And		a.cnsctvo_cdgo_clse_aprtnte  = b.cnsctvo_cdgo_clse_aprtnte)
	Inner Join  bdafiliacion.dbo.tbpersonas		c With(NoLock)
		On		(a.nmro_unco_idntfccn_empldr  = c.nmro_unco_idntfccn)
	Where		rzn_scl     = ''

	execute spAdicionaRegistrosImpresionEstadosCuentaManual

End
