
/*---------------------------------------------------------------------------------
* Metodo o PRG		: spPTLConsultarEstadoCuentaImpresionXEmpleadorCabecera
* Desarrollado por  : <\A Ing. Warner Fernando Valencia - SEIT Consultores A\>
* Descripcion		: <\D  Permite consultar los estados de cuenta a imprimir por empleador D\>
* Observaciones		: <\O               O\>
* Parametros		: <\P             P\>
* Variables			: <\V               V\>
* Fecha Creacion	: <\FC 2003/02/10           FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM AM\>
* Descripcion			: <\DM Se corrige para que muestre la columna Valor_Codigo_barras en lugar de codigo_barras y muestre el fax y extension vacios, no se requieren DM\>
* Nuevos Parametros		: <\PM PM\>
* Nuevas Variables		: <\VM VM\>
* Fecha Modificacion	: <\FM 2015/11/05 FM\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM Ing. Cesar García	AM\>
* Descripcion			: <\DM Se optimiza procedimiento, adicionando hints y ajustando las relaciones con joins. Adcionalmente DM\>
						  <\DM se rompe una consulta con mas de 10 joins en joins independientes								DM\>
* Nuevos Parametros		: <\PM PM\>
* Nuevas Variables		: <\VM VM\>
* Fecha Modificacion	: <\FM 2017-03-15 FM\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM Carlos Vela - Qvision	AM\>
* Descripcion			: <\DM Se ajusta para soportar campos de Factura Electronica DM\>
* Nuevos Parametros		: <\PM PM\>
* Nuevas Variables		: <\VM VM\>
* Fecha Modificacion	: <\FM 2019-06-21 FM\>
*---------------------------------------------------------------------------------
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM Carlos Vela - Qvision	AM\>
* Descripcion			: <\DM Se ajusta el nombre de la sucursal, para tomarlo de persona o empresa, y recuperar
							   la razón social DM\>
* Nuevos Parametros		: <\PM PM\>
* Nuevas Variables		: <\VM VM\>
* Fecha Modificacion	: <\FM 2019-07-21 FM\>
*---------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[spPTLConsultarEstadoCuentaImpresionXEmpleadorCabecera] @nmro_unco_idntfccn_empldr   udtConsecutivo
 --EXEC  [dbo].[spPTLConsultarEstadoCuentaImpresionXEmpleadorCabecera] 33240097
-- sp_helptext spPTLConsultarEstadoCuentaImpresionXEmpleadorCabecera
--DECLARE @nmro_unco_idntfccn_empldr   udtConsecutivo = 31608478
As
Set Nocount On

		Declare
			@tbla				varchar(128),
			@cdgo_cmpo			varchar(128),
			@oprdr				varchar(2),
			@vlr				varchar(250),
			@cmpo_rlcn			varchar(128),
			@cmpo_rlcn_prmtro	varchar(128),
			@cnsctvo			Numeric(4),
			@IcInstruccion		Nvarchar(4000),
			@IcInstruccion1		Nvarchar(4000),
			@IcInstruccion2		Nvarchar(4000),
			@lcAlias			char(2),
			@lnContador			Int,
			@FechaActual		datetime,
			@msje_cncpto		nvarchar(1000),
			@cnta_bncra			varchar(200),		
			@rvsra				varchar(200),
			@dirccn_ss			varchar(200),		
			@pbx_ss				varchar(15),	
			@fx_ss				varchar(15),
			@extnsn_ss			varchar(15),		
			@ln_atncn_ss		varchar(20), 
			@prm_msje_cncpto	int,
			@prm_cnta_bncra		int,		
			@prm_rvsra			int,
			@prm_dirccn_ss		int,		
			@prm_pbx_ss			int,		
			@prm_fx_ss			int,
			@prm_extnsn_ss		int,		
			@prm_ln_atncn_ss	int,
			@NIT_ss				udtNumeroIdentificacionLargo,
			@prm_ciudad_ss		int,		
			@ciudad_ss			varchar(200),
			@msje_rslcn_ln1	nvarchar(500),
			@msje_rslcn_ln2	nvarchar(500),
			@encbzdo_mnsje varchar(500),
			@prm_rslcn_ln1		int,
			@prm_rslcn_ln2		int,
			@prm_encbzdo_mnsje  int,
			@consecutivoCodigoClaseEmpleadorNatural smallint = 2,
			@consecutivoCodigoClaseAportanteIndependiente smallint = 4

		Create Table #tmpEstadosCuentaConsultar(
					 nmro_estdo_cnta varchar(15),
					 cnsctvo_cdgo_tpo_dcmnto int)

		Create Table #TmpImpresionEstadosCuenta_aux
			(	nmro_estdo_cnta				varchar (15),					cdgo_tpo_idntfccn			varchar(3),    
				nmro_idntfccn				udtNumeroIdentificacionLargo,	dscrpcn_clse_aprtnte		udtDescripcion,
				nmbre_scrsl					udtDescripcion,					rzn_scl						varchar(200),  
				ttl_fctrdo					udtValorGrande,					usro_crcn					udtUsuario,  
				cnsctvo_cdgo_lqdcn			udtConsecutivo,					accn						varchar(20), 
				cnsctvo_estdo_cnta			udtConsecutivo,					fcha_gnrcn					datetime,    
				nmro_unco_idntfccn_empldr	udtConsecutivo,					cnsctvo_scrsl				udtConsecutivo,  
				cnsctvo_cdgo_clse_aprtnte	udtConsecutivo,					cnsctvo_cdgo_sde			udtConsecutivo,    
				vlr_iva						udtValorGrande,					sldo_fvr					udtValorGrande,    
				ttl_pgr						udtValorGrande,					Cts_Cnclr					udtValorPequeno,     
				Cts_sn_Cnclr				udtValorPequeno,				cdgo_cdd					char(8),    
				dscrpcn_cdd					udtDescripcion,					dscrpcn_prdo				udtDescripcion,    
				cdgo_prdo					udtCodigo,						dscrpcn_tpo_idntfccn		udtDescripcion,   
				drccn						udtDireccion,					tlfno						udtTelefono,
				cnsctvo_cdgo_prdo_lqdcn		char(8),						fcha_incl_fctrcn			datetime ,   
				fcha_fnl_fctrcn				datetime,						fcha_pgo					datetime,    
				sldo_antrr					udtValorGrande,					cnsctvo_cdgo_tpo_idntfccn	udtConsecutivo,
				dscrpcn_sde					udtDescripcion,					nmro_Aux int, 
				cdgo_sde					udtSede,
				cnsctvo_cdgo_cdd			Int,							cnsctvo_cdgo_prdcdd_prpgo	Int,
				fechaExpedicion				date,							cufe						varchar(160),
				cadenaQR					varchar(2000),					totalPagarLetras			varchar(250)
			)

		CREATE TABLE #resultado(	nmro_estdo_cnta varchar(15)			,		cdgo_tpo_idntfccn varchar(3),
									nmro_idntfccn varchar(20)			,		dscrpcn_clse_aprtnte varchar(50),
									nmbre_scrsl varchar(200)			,		rzn_scl varchar(200),
									ttl_fctrdo numeric(12,0)			,		usro_crcn varchar(30),
									cnsctvo_cdgo_lqdcn int				,		accn varchar(50),
									cnsctvo_estdo_cnta int				,		fcha_gnrcn datetime,		
									nmro_unco_idntfccn_empldr int		,		cnsctvo_scrsl	int ,
									cnsctvo_cdgo_clse_aprtnte int		,		cnsctvo_cdgo_sde int,
									vlr_iva numeric(12,0)				,		sldo_fvr numeric(12,0),
									ttl_pgr numeric(12,0)				,		Cts_Cnclr int,
									Cts_sn_Cnclr int					,		cdgo_cdd		varchar(20),
									dscrpcn_cdd		varchar(100)		,		dscrpcn_prdo		varchar(50),
									cdgo_prdo		varchar(6)			,		dscrpcn_tpo_idntfccn   varchar(50),
									drccn			varchar(80)			,       tlfno			varchar(30),
									cnsctvo_cdgo_prdo_lqdcn int			,		fcha_incl_fctrcn	datetime,
									fcha_fnl_fctrcn 	datetime		,		fcha_pgo  datetime,
									sldo_antrr numeric(12,0)			,		cnsctvo_cdgo_tpo_idntfccn int,	
									descripcion_concepto varchar(1000)	,		cantidad_Concepto varchar(1000),
									valor_Concepto varchar(1000)		,		descripcion_concepto1 varchar(1000),
									cantidad_Concepto1 varchar(1000)	,		valor_Concepto1 varchar(1000)		,		
									dscrpcn_sde varchar(50)				,		nmro_Aux int						,		
									cdgo_sde varchar(4)					,		numero_identificacion varchar(500)	,
									nombre_cotizante varchar(2000)		,		numero_afiliacion varchar(500),
									codigo_plan varchar(150)			,		valor_contrato varchar(500),
									cantidad_beneficiarios varchar(100)	,		numero_identificacion1 varchar(500),
									nombre_cotizante1 varchar(2000)		,		numero_afiliacion1 varchar(500),
									codigo_plan1 varchar(150)			,		valor_contrato1 varchar(500),
									cantidad_beneficiarios1 varchar(100),		codigo_barras varchar(500),
									Valor_Codigo_barras varchar(500)	,
									mensaje nvarchar(1000)				,		mensaje2 nvarchar(1000),
									cuenta_bancaria varchar(200)			,		revisoria varchar(200),
									direccionSOS varchar(200)			,		pbxSOS varchar(15),
									faxSOS varchar(15),
									extensionSOS varchar(15)			,		lineaAtencionSOS varchar(20),
									fechaExpedicion	varchar(10)			,		cufe varchar(160),
									cadenaQR varchar(2000)				,       totalPagarLetras varchar(250),
									ciudadDireccionSOS varchar(200)		,		mensajeResLinea1 varchar(500),
									mensajeResLinea2 varchar(500)		,		txtNumeracionResDian varchar(80),
									encabezadoMensaje	varchar(250)	,		prfjo_atrzdo_fctrcn varchar(10)										
									)

Begin
	Set @FechaActual		= getdate()
	Set @prm_cnta_bncra		= 119				
	Set @prm_dirccn_ss		= 120		
	Set @prm_pbx_ss			= 121		
	Set @prm_fx_ss			= 122
	Set @prm_extnsn_ss		= 123		
	Set @prm_ln_atncn_ss	= 124
	Set @prm_msje_cncpto	= 125
	Set @prm_rvsra			= 126
	Set @NIT_ss			    = '805.001.157-2'
	Set @prm_ciudad_ss		= 163
	Set @prm_rslcn_ln1		= 164
	Set	@prm_rslcn_ln2		= 165
	Set	@prm_encbzdo_mnsje	= 166



	/**Se consultan los datos de */
	-- parametro cuenta nbancaria  (117)
 	Select		@cnta_bncra =vlr_prmtro_crctr
	From		bdSeguridad.dbo.tbParametrosGeneralesPortal				a	With(NoLock)
	Inner Join	bdSeguridad.dbo.tbParametrosGeneralesPortal_Vigencias	b	With(NoLock)	On  a.cnsctvo_cdgo_prmtro_gnrl_slctd_sld =b.cnsctvo_cdgo_prmtro_gnrl_slctd_sld
	Where		a.cnsctvo_cdgo_prmtro_gnrl_slctd_sld =@prm_cnta_bncra
	And			@FechaActual between b.inco_vgnca  and b.fn_vgnca

	-- parametro cuenta dirección sos  (118)
	Select		@dirccn_ss =vlr_prmtro_crctr
	From		bdSeguridad.dbo.tbParametrosGeneralesPortal				a	With(NoLock)
	Inner Join	bdSeguridad.dbo.tbParametrosGeneralesPortal_Vigencias	b	With(NoLock)	On  a.cnsctvo_cdgo_prmtro_gnrl_slctd_sld =b.cnsctvo_cdgo_prmtro_gnrl_slctd_sld
	Where		a.cnsctvo_cdgo_prmtro_gnrl_slctd_sld =@prm_dirccn_ss
	And			@FechaActual between b.inco_vgnca  and b.fn_vgnca
	
	-- parametro pbx @prm_pbx_ss (119)
	Select		@pbx_ss =vlr_prmtro_crctr
	From		bdSeguridad.dbo.tbParametrosGeneralesPortal				a	With(NoLock)
	Inner Join	bdSeguridad.dbo.tbParametrosGeneralesPortal_Vigencias	b	With(NoLock)	On  a.cnsctvo_cdgo_prmtro_gnrl_slctd_sld =b.cnsctvo_cdgo_prmtro_gnrl_slctd_sld
	Where		a.cnsctvo_cdgo_prmtro_gnrl_slctd_sld =@prm_pbx_ss
	And			@FechaActual between b.inco_vgnca  and b.fn_vgnca

	-- parametro @prm_fx_ss (120)
	Select		@fx_ss =vlr_prmtro_crctr
	From		bdSeguridad.dbo.tbParametrosGeneralesPortal				a	With(NoLock)
	Inner Join	bdSeguridad.dbo.tbParametrosGeneralesPortal_Vigencias	b	With(NoLock)	On  a.cnsctvo_cdgo_prmtro_gnrl_slctd_sld =b.cnsctvo_cdgo_prmtro_gnrl_slctd_sld
	Where		a.cnsctvo_cdgo_prmtro_gnrl_slctd_sld =@prm_fx_ss
	And			@FechaActual between b.inco_vgnca  and b.fn_vgnca

	-- parametro cuenta nbancaria  (121)
	Select		@extnsn_ss =vlr_prmtro_crctr
	From		bdSeguridad.dbo.tbParametrosGeneralesPortal				a	With(NoLock)
	Inner Join	bdSeguridad.dbo.tbParametrosGeneralesPortal_Vigencias	b	With(NoLock)	On  a.cnsctvo_cdgo_prmtro_gnrl_slctd_sld =b.cnsctvo_cdgo_prmtro_gnrl_slctd_sld
	Where		a.cnsctvo_cdgo_prmtro_gnrl_slctd_sld =@prm_extnsn_ss
	And			@FechaActual between b.inco_vgnca  and b.fn_vgnca

	-- parametro cuenta nbancaria  (122)
	Select		@ln_atncn_ss =vlr_prmtro_crctr
	From		bdSeguridad.dbo.tbParametrosGeneralesPortal				a	With(NoLock)
	Inner Join	bdSeguridad.dbo.tbParametrosGeneralesPortal_Vigencias	b	With(NoLock)	On  a.cnsctvo_cdgo_prmtro_gnrl_slctd_sld =b.cnsctvo_cdgo_prmtro_gnrl_slctd_sld
	Where		a.cnsctvo_cdgo_prmtro_gnrl_slctd_sld =@prm_ln_atncn_ss
	And			@FechaActual between b.inco_vgnca  and b.fn_vgnca

	-- parametro cuenta nbancaria  (123)
	Select		@msje_cncpto =vlr_prmtro_crctr
	From		bdSeguridad.dbo.tbParametrosGeneralesPortal				a	With(NoLock)
	Inner Join	bdSeguridad.dbo.tbParametrosGeneralesPortal_Vigencias	b	With(NoLock)	On  a.cnsctvo_cdgo_prmtro_gnrl_slctd_sld =b.cnsctvo_cdgo_prmtro_gnrl_slctd_sld
	Where		a.cnsctvo_cdgo_prmtro_gnrl_slctd_sld =@prm_msje_cncpto
	And			@FechaActual between b.inco_vgnca  and b.fn_vgnca

	-- parametro cuenta @prm_rvsra  (124)
	Select		@rvsra =vlr_prmtro_crctr
	From		bdSeguridad.dbo.tbParametrosGeneralesPortal				a	With(NoLock)
	Inner Join	bdSeguridad.dbo.tbParametrosGeneralesPortal_Vigencias	b	With(NoLock)	On  a.cnsctvo_cdgo_prmtro_gnrl_slctd_sld =b.cnsctvo_cdgo_prmtro_gnrl_slctd_sld
	Where		a.cnsctvo_cdgo_prmtro_gnrl_slctd_sld =@prm_rvsra
	And			@FechaActual between b.inco_vgnca  and b.fn_vgnca
 
	-- parametro ciudad dirección sos  (163)
	Select		@ciudad_ss =vlr_prmtro_crctr
	From		bdSeguridad.dbo.tbParametrosGeneralesPortal				a	With(NoLock)
	Inner Join	bdSeguridad.dbo.tbParametrosGeneralesPortal_Vigencias	b	With(NoLock)	On  a.cnsctvo_cdgo_prmtro_gnrl_slctd_sld =b.cnsctvo_cdgo_prmtro_gnrl_slctd_sld
	Where		a.cnsctvo_cdgo_prmtro_gnrl_slctd_sld =@prm_ciudad_ss
	And			@FechaActual between b.inco_vgnca  and b.fn_vgnca

	-- parametro resolucion linea 1
	Select		@msje_rslcn_ln1 =vlr_prmtro_crctr
	From		bdSeguridad.dbo.tbParametrosGeneralesPortal				a	With(NoLock)
	Inner Join	bdSeguridad.dbo.tbParametrosGeneralesPortal_Vigencias	b	With(NoLock)	On  a.cnsctvo_cdgo_prmtro_gnrl_slctd_sld =b.cnsctvo_cdgo_prmtro_gnrl_slctd_sld
	Where		a.cnsctvo_cdgo_prmtro_gnrl_slctd_sld =@prm_rslcn_ln1
	And			@FechaActual between b.inco_vgnca  and b.fn_vgnca

	-- parametro resolucion linea 2
	Select		@msje_rslcn_ln2 =vlr_prmtro_crctr
	From		bdSeguridad.dbo.tbParametrosGeneralesPortal				a	With(NoLock)
	Inner Join	bdSeguridad.dbo.tbParametrosGeneralesPortal_Vigencias	b	With(NoLock)	On  a.cnsctvo_cdgo_prmtro_gnrl_slctd_sld =b.cnsctvo_cdgo_prmtro_gnrl_slctd_sld
	Where		a.cnsctvo_cdgo_prmtro_gnrl_slctd_sld =@prm_rslcn_ln2
	And			@FechaActual between b.inco_vgnca  and b.fn_vgnca

	-- parametro encabezado mensaje
	Select		@encbzdo_mnsje =vlr_prmtro_crctr
	From		bdSeguridad.dbo.tbParametrosGeneralesPortal				a	With(NoLock)
	Inner Join	bdSeguridad.dbo.tbParametrosGeneralesPortal_Vigencias	b	With(NoLock)	On  a.cnsctvo_cdgo_prmtro_gnrl_slctd_sld =b.cnsctvo_cdgo_prmtro_gnrl_slctd_sld
	Where		a.cnsctvo_cdgo_prmtro_gnrl_slctd_sld =@prm_encbzdo_mnsje
	And			@FechaActual between b.inco_vgnca  and b.fn_vgnca

		---Se consultan los numeros de cuenta del empleador 
	Insert Into #tmpEstadosCuentaConsultar 
	exec		dbo.spPTLConsultaNumeroCuentaXEmpleador  @nmro_unco_idntfccn_empldr


	Insert into #TmpImpresionEstadosCuenta_aux	
				(	nmro_estdo_cnta,				cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,					nmbre_scrsl,			ttl_fctrdo,
					usro_crcn,						cnsctvo_cdgo_lqdcn,				accn,							cnsctvo_estdo_cnta,		fcha_gnrcn,
					nmro_unco_idntfccn_empldr,		cnsctvo_scrsl,					cnsctvo_cdgo_clse_aprtnte,		cnsctvo_cdgo_sde,		vlr_iva,
					sldo_fvr,						ttl_pgr,						Cts_Cnclr,						Cts_sn_Cnclr,			cnsctvo_cdgo_prdcdd_prpgo,
					drccn,							tlfno,							cnsctvo_cdgo_prdo_lqdcn,		sldo_antrr,				nmro_Aux,
					cnsctvo_cdgo_cdd,				fechaExpedicion,				cufe,							cadenaQR
				)	
	Select			a.nmro_estdo_cnta,				d.cnsctvo_cdgo_tpo_idntfccn,	d.nmro_idntfccn,				b.nmbre_scrsl,			a.ttl_fctrdo,
					a.usro_crcn,					a.cnsctvo_cdgo_lqdcn,			'SELECCIONADO',					a.cnsctvo_estdo_cnta,   a.fcha_gnrcn,
					a.nmro_unco_idntfccn_empldr,	a.cnsctvo_scrsl,				a.cnsctvo_cdgo_clse_aprtnte,    b.sde_crtra_pc,			a.vlr_iva,
					a.sldo_fvr,						a.ttl_pgr,						a.Cts_Cnclr,					a.Cts_sn_Cnclr,			a.cnsctvo_cdgo_prdcdd_prpgo,
					b.drccn,						b.tlfno,						g.cnsctvo_cdgo_prdo_lqdcn,		a.sldo_antrr,			convert(int,a.nmro_estdo_cnta),
					b.cnsctvo_cdgo_cdd,				a.Fcha_crcn,					a.cufe,							a.cdna_qr 			
	From		tbEstadosCuenta							a	With(NoLock)
	Inner Join	bdAfiliacion.dbo.tbSucursalesAportante	b	With(NoLock)	On	b.nmro_unco_idntfccn_empldr	=   a.nmro_unco_idntfccn_empldr
																			AND	b.cnsctvo_scrsl				=	a.cnsctvo_scrsl
																			And	b.cnsctvo_cdgo_clse_aprtnte =	a.cnsctvo_cdgo_clse_aprtnte
	Inner Join	bdAfiliacion.dbo.tbVinculados			d	With(NoLock)	On	d.nmro_unco_idntfccn		=	a.nmro_unco_idntfccn_empldr
	Inner Join	tbliquidaciones							g	With(NoLock)	On	g.cnsctvo_cdgo_lqdcn		=	a.cnsctvo_cdgo_lqdcn  
	Inner Join	#tmpEstadosCuentaConsultar				ecc	With(NoLock)	On	ecc.nmro_estdo_cnta			=	a.nmro_estdo_cnta
	Where		g.cnsctvo_cdgo_estdo_lqdcn   in (3,6)  --Finalizada y finalizada de prueba


	Update		#TmpImpresionEstadosCuenta_aux
	Set			cdgo_cdd	=	c.cdgo_cdd,
				dscrpcn_cdd	=	ltrim(rtrim(c.dscrpcn_cdd))+  ' -  ' + ltrim(rtrim(dp.dscrpcn_dprtmnto))
	From		#TmpImpresionEstadosCuenta_aux				a	With(NoLock)
	Inner Join	bdAfiliacion.dbo.tbciudades_vigencias		c	With(NoLock)	On	c.cnsctvo_cdgo_cdd			=	a.cnsctvo_cdgo_cdd
	Inner Join	bdAfiliacion.dbo.tbdepartamentos_vigencias	dp	With(NoLock)	On	dp.cnsctvo_cdgo_dprtmnto	=	c.cnsctvo_cdgo_dprtmnto
	Where		getdate() Between c.inco_vgnca And c.fn_vgnca
	And			getdate() Between dp.inco_vgnca And dp.fn_vgnca

	Update		#TmpImpresionEstadosCuenta_aux
	Set			cdgo_sde	=	s.cdgo_sde,
				dscrpcn_sde	=	s.dscrpcn_sde
	From		#TmpImpresionEstadosCuenta_aux			a	With(NoLock)
	Inner Join	bdAfiliacion.dbo.Tbsedes_Vigencias		s	With(NoLock)	On	s.cnsctvo_cdgo_sde	=	a.cnsctvo_cdgo_sde
	Where		getdate() Between s.inco_vgnca And s.fn_vgnca

	Update		#TmpImpresionEstadosCuenta_aux
	Set			cdgo_prdo		=	p.cdgo_prdo,
				dscrpcn_prdo	=	p.dscrpcn_prdo
	From		#TmpImpresionEstadosCuenta_aux	a	With(NoLock)
	Inner Join	bdAfiliacion.dbo.tbPeriodos		p	With(NoLock)	On	p.cnsctvo_cdgo_prdo	=	a.cnsctvo_cdgo_prdcdd_prpgo

	Update		#TmpImpresionEstadosCuenta_aux
	Set			dscrpcn_tpo_idntfccn		=	t.dscrpcn_tpo_idntfccn,
				cdgo_tpo_idntfccn			=   t.cdgo_tpo_idntfccn
	From		#TmpImpresionEstadosCuenta_aux						a	With(NoLock)
	Inner Join	bdAfiliacion.dbo.tbTiposIdentificacion_Vigencias	t	With(NoLock)	On	t.cnsctvo_cdgo_tpo_idntfccn	=	a.cnsctvo_cdgo_tpo_idntfccn
	Where		getdate() Between t.inco_vgnca And t.fn_vgnca

	Update		#TmpImpresionEstadosCuenta_aux
	Set			cnsctvo_cdgo_prdo_lqdcn	=	h.cnsctvo_cdgo_prdo_lqdcn,
				fcha_incl_fctrcn		=	h.fcha_incl_prdo_lqdcn,
				fcha_fnl_fctrcn			=	h.fcha_fnl_prdo_lqdcn,
				fcha_pgo				=	h.fcha_pgo
	From		#TmpImpresionEstadosCuenta_aux	a	With(NoLock)
	Inner Join	tbPeriodosliquidacion_Vigencias	h	With(NoLock)	On	h.cnsctvo_cdgo_prdo_lqdcn	=	a.cnsctvo_cdgo_prdo_lqdcn

	Update		#TmpImpresionEstadosCuenta_aux
	Set			dscrpcn_clse_aprtnte	=	i.dscrpcn_clse_aprtnte
	From		#TmpImpresionEstadosCuenta_aux		a	With(NoLock)
	Inner Join	bdAfiliacion.dbo.tbClasesAportantes	i	With(NoLock)	On	i.cnsctvo_cdgo_clse_aprtnte	=	a.cnsctvo_cdgo_clse_aprtnte
 
	--Empresas 
	Update 		a
	Set    		a.nmbre_scrsl = b.rzn_scl
	From 		#TmpImpresionEstadosCuenta_aux 		a		
	Inner Join  bdAfiliacion.dbo.tbEmpresas    b with(nolock)	
	On 			a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn
	inner join	BDAfiliacion.dbo.tbEmpleadores c With(NoLock)
	on			c.nmro_unco_idntfccn = b.nmro_unco_idntfccn
	and			a.cnsctvo_cdgo_clse_aprtnte = c.cnsctvo_cdgo_clse_aprtnte
	inner join	BDAfiliacion.dbo.tbClasesEmpleador_Vigencias d With(NoLock) 
	on			c.cnsctvo_cdgo_clse_empldr = d.cnsctvo_cdgo_clse_empldr
	where		c.cnsctvo_cdgo_clse_aprtnte != @consecutivoCodigoClaseAportanteIndependiente
	and			d.cnsctvo_cdgo_clse_empldr != @consecutivoCodigoClaseEmpleadorNatural
	and			getdate() between d.inco_vgnca and d.fn_vgnca; 

	-- Personas
	Update 		a
	Set    		a.nmbre_scrsl = rtrim(ltrim(b.prmr_nmbre))+' '+rtrim(ltrim(b.sgndo_nmbre))+' '+rtrim(ltrim(b.prmr_aplldo)) + ' ' + rtrim(ltrim(b.sgndo_aplldo))					
	From 		#TmpImpresionEstadosCuenta_aux 		a		
	Inner Join  bdAfiliacion.dbo.tbPersonas    b With(nolock)	
	On 			a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn
	inner join	BDAfiliacion.dbo.tbEmpleadores c With(NoLock)
	on			c.nmro_unco_idntfccn = b.nmro_unco_idntfccn
	and			a.cnsctvo_cdgo_clse_aprtnte = c.cnsctvo_cdgo_clse_aprtnte
	inner join	BDAfiliacion.dbo.tbClasesEmpleador_Vigencias d With(NoLock)
	on			c.cnsctvo_cdgo_clse_empldr = d.cnsctvo_cdgo_clse_empldr
	where		(a.cnsctvo_cdgo_clse_aprtnte = @consecutivoCodigoClaseAportanteIndependiente
	or			d.cnsctvo_cdgo_clse_empldr = @consecutivoCodigoClaseEmpleadorNatural)
	and			getdate() between d.inco_vgnca and d.fn_vgnca;

	-- Si la razon social queda vacia, se toma de Personas
	Update 		a
	Set    		a.nmbre_scrsl = rtrim(ltrim(b.prmr_nmbre))+' '+rtrim(ltrim(b.sgndo_nmbre))+' '+rtrim(ltrim(b.prmr_aplldo)) + ' ' + rtrim(ltrim(b.sgndo_aplldo))					
	From 		#TmpImpresionEstadosCuenta_aux 		a	
	Inner Join	bdAfiliacion.dbo.tbPersonas b with(nolock)	
	On			a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn	
	where		(	
					a.nmbre_scrsl = '' 
					or
					a.nmbre_scrsl is null
				);


	Insert Into #resultado
			(	nmro_estdo_cnta,			cdgo_tpo_idntfccn,			nmro_idntfccn,				dscrpcn_clse_aprtnte,
				nmbre_scrsl,				rzn_scl,					ttl_fctrdo,					usro_crcn,
				cnsctvo_cdgo_lqdcn,			accn,						cnsctvo_estdo_cnta,			fcha_gnrcn,
				nmro_unco_idntfccn_empldr,	cnsctvo_scrsl,				cnsctvo_cdgo_clse_aprtnte,	cnsctvo_cdgo_sde,
				vlr_iva,					sldo_fvr,					ttl_pgr,					Cts_Cnclr,
				Cts_sn_Cnclr,				cdgo_cdd,					dscrpcn_cdd,				dscrpcn_prdo,
				cdgo_prdo,					dscrpcn_tpo_idntfccn,		drccn,						tlfno,
				cnsctvo_cdgo_prdo_lqdcn,	fcha_incl_fctrcn,			fcha_fnl_fctrcn,			fcha_pgo,
				sldo_antrr,					cnsctvo_cdgo_tpo_idntfccn,	descripcion_concepto,		cantidad_Concepto,
				valor_Concepto,				descripcion_concepto1,		cantidad_Concepto1,			valor_Concepto1,
				dscrpcn_sde,				nmro_Aux,					cdgo_sde,					numero_identificacion,
				nombre_cotizante,			numero_afiliacion,			codigo_plan,				valor_contrato,
				cantidad_beneficiarios,		numero_identificacion1,		nombre_cotizante1,			numero_afiliacion1,
				codigo_plan1,				valor_contrato1,			cantidad_beneficiarios1,	codigo_barras,
				Valor_Codigo_barras,		mensaje,					mensaje2,
				fechaExpedicion,			cufe,						cadenaQR,					totalPagarLetras
			)
	execute		spPTLAdicionaRegistrosImpresionEstadosCuentaManual

	--Recuperamos la numeracion de la DIAN
	Update a 
		Set txtNumeracionResDian= ISNULL(c.prfjo_atrzdo_fctrcn,'')+' del '+isnull(c.rngo_inco_atrzdo_fctrcn,'')+' al '+isnull(c.rngo_fn_atrzdo_fctrcn,''),
			prfjo_atrzdo_fctrcn = ltrim(rtrim(isnull(c.prfjo_atrzdo_fctrcn,'')))
		From #resultado a
			Inner Join dbo.tbEstadosCuenta b With(NoLock)
			On a.nmro_estdo_cnta=b.nmro_estdo_cnta 
			Inner Join BDAfiliacionValidador.dbo.tbResolucionesDIAN_Vigencias c With(NoLock)
			On b.cnsctvo_cdgo_rslcn_dn = c.cnsctvo_cdgo_rslcn_dn 
			Where b.Fcha_crcn between c.inco_vgnca and c.fn_vgnca;

	--Actulizacion de los datos que extraen de las tablas parametricas
	Update #resultado
	Set		mensaje2		= @msje_cncpto		, cuenta_bancaria	= @cnta_bncra		, revisoria = @rvsra, 
			direccionSOS	= @dirccn_ss		, pbxSOS			= @pbx_ss			, faxSOS	= @fx_ss, 
			extensionSOS	= @extnsn_ss		, lineaAtencionSOS	= @ln_atncn_ss		, ciudadDireccionSOS = @ciudad_ss,
			mensajeResLinea1 =@msje_rslcn_ln1   , mensajeResLinea2  = @msje_rslcn_ln2 + isnull(txtNumeracionResDian,''),
			encabezadoMensaje = @encbzdo_mnsje	, nmro_estdo_cnta   = isnull(prfjo_atrzdo_fctrcn,'')+nmro_estdo_cnta  	 
	FROM	#resultado


	--cabecera del reporte
	Select Top 1	nmbre_scrsl																													,	drccn							,			
					CONCAT('SUC-', cnsctvo_scrsl) AS	cnsctvo_scrsl																				,	CONCAT('tel.',tlfno) AS  tlfno	,
					dscrpcn_cdd																														,	cdgo_sde						,
					CONCAT( (CONVERT(VARCHAR(10), fcha_incl_fctrcn, 101)),'    -    ',(CONVERT(VARCHAR(10), fcha_fnl_fctrcn, 101)))  as fcha_incl_fctrcn	,	nmro_estdo_cnta					,
					Cts_sn_Cnclr																						,		Cts_Cnclr+Cts_sn_Cnclr as Cts_Cnclr						,					
					CASE when sldo_antrr > 0 Then 'INMEDIATO' Else  convert (varchar(23),fcha_pgo) end as fechaPago		,		cdgo_tpo_idntfccn										,
					ttl_fctrdo																							,		vlr_iva													,
					sldo_antrr																							,		sldo_fvr												,
					ttl_pgr																								,		mensaje													,
					mensaje2																							,		codigo_barras 										,
					CONCAT (cdgo_tpo_idntfccn, ' ', nmro_idntfccn) As identificacion									,		cuenta_bancaria 										,		
					revisoria																							,		direccionSOS											,		
					pbxSOS																								,		'' faxSOS													,
					'' extensionSOS 																						,		lineaAtencionSOS										,	
					@NIT_ss  as nmro_idntfccn, Valor_Codigo_barras,
					fechaExpedicion,
					cufe,
					cadenaQR,
					totalPagarLetras,
					ciudadDireccionSOS,
					mensajeResLinea1,
					mensajeResLinea2,
					ltrim(rtrim(CONCAT (' ', cdgo_tpo_idntfccn, nmro_idntfccn))) As idDocReceptor,
					encabezadoMensaje  					 
	From 			#resultado With(NoLock)


End

