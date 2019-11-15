
/*---------------------------------------------------------------------------------
* Metodo o PRG		: spPTLConsultarEstadoCuentaImpresionXEmpleadorConceptos
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
* Descripcion			: <\DM DM\>
* Nuevos Parametros		: <\PM PM\>
* Nuevas Variables		: <\VM VM\>
* Fecha Modificacion	: <\FM FM\>
*---------------------------------------------------------------------------------*/
--exec [spPTLConsultarEstadoCuentaImpresionXEmpleadorConceptos] 30036075
CREATE PROCEDURE [dbo].[spPTLConsultarEstadoCuentaImpresionXEmpleadorConceptos]
	@nmro_unco_idntfccn_empldr   udtConsecutivo

As

Set Nocount On

Declare
		@tbla   varchar(128),	@cdgo_cmpo   varchar(128),
		@oprdr   varchar(2),
		@vlr    varchar(250),
		@cmpo_rlcn   varchar(128),
		@cmpo_rlcn_prmtro  varchar(128),
		@cnsctvo  Numeric(4),
		@IcInstruccion  Nvarchar(4000),
		@IcInstruccion1  Nvarchar(4000),
		@IcInstruccion2  Nvarchar(4000),
		@lcAlias  char(2),
		@lnContador  Int,
		@CONCEPTO_IVA INT=3

		Create Table #tmpEstadosCuentaConsultar(
					 nmro_estdo_cnta varchar(15),
					 cnsctvo_cdgo_tpo_dcmnto int)

		Create Table #TmpImpresionEstadosCuenta_aux(
			nmro_estdo_cnta				varchar (15),					cdgo_tpo_idntfccn			varchar(3),    
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
				fcha_fnl_fctrcn			datetime,						fcha_pgo					datetime,    
			sldo_antrr					udtValorGrande,					cnsctvo_cdgo_tpo_idntfccn	udtConsecutivo,
			dscrpcn_sde					udtDescripcion,					nmro_Aux int, 
			cdgo_sde					udtSede
			)



			
		Create table #tmpReporteEstadocuenta
		(	nmro_estdo_cnta 				varchar(15),		cdgo_tpo_idntfccn	varchar(3),			nmro_idntfccn				varchar(20),
			dscrpcn_clse_aprtnte			varchar(50),		nmbre_scrsl         varchar(200),		rzn_scl						varchar(200),
			ttl_fctrdo						numeric(12,0),		usro_crcn			varchar(30),		cnsctvo_cdgo_lqdcn 			int,
			accn							varchar(50),		cnsctvo_estdo_cnta	int,				fcha_gnrcn					datetime,
			nmro_unco_idntfccn_empldr		int,				cnsctvo_scrsl		int,				cnsctvo_cdgo_clse_aprtnte	int,	
			cnsctvo_cdgo_sde				int,				vlr_iva				numeric(12,0),		sldo_fvr					numeric(12,0),
			ttl_pgr							numeric(12,0),		Cts_Cnclr			int,				Cts_sn_Cnclr				int,
			cdgo_cdd						varchar(20),
			dscrpcn_cdd		varchar(100),
			dscrpcn_prdo		varchar(50),
			cdgo_prdo		varchar(6),
			dscrpcn_tpo_idntfccn   varchar(50),
			drccn			varchar(80),
			tlfno			varchar(30),
			cnsctvo_cdgo_prdo_lqdcn int,
			fcha_incl_fctrcn	datetime,
			fcha_fnl_fctrcn 	datetime,
			fcha_pgo  datetime,
			sldo_antrr numeric(12,0),
			cnsctvo_cdgo_tpo_idntfccn int,	
			descripcion_concepto varchar(1000),
			cantidad_Concepto varchar(1000),
			valor_Concepto varchar(1000),
			descripcion_concepto1 varchar(1000),
			cantidad_Concepto1 varchar(1000),
			valor_Concepto1 varchar(1000),
			dscrpcn_sde varchar(50),
			nmro_Aux int,
			cdgo_sde varchar(4))
 
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
									mensaje nvarchar(1000)				,		mensaje2 nvarchar(1000)		
									)





Begin

		Set @nmro_unco_idntfccn_empldr=33244953;

		---Se consultan los numeros de cuenta del empleador 
		Insert Into #tmpEstadosCuentaConsultar 
					exec  dbo.spPTLConsultaNumeroCuentaXEmpleador  @nmro_unco_idntfccn_empldr


		 Insert into #TmpImpresionEstadosCuenta_aux
		 Select  a.nmro_estdo_cnta,  f.cdgo_tpo_idntfccn,   d.nmro_idntfccn,    i.dscrpcn_clse_aprtnte,
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
		  f.cnsctvo_cdgo_tpo_idntfccn , s.dscrpcn_sde,   convert(int,a.nmro_estdo_cnta) nmro_Aux, s.cdgo_sde  
		 From tbEstadosCuenta a,   bdAfiliacion.dbo.tbciudades_vigencias  c  , bdAfiliacion.dbo.tbSucursalesAportante b   ,
				  bdAfiliacion.dbo.tbPeriodos e  , 
				  bdAfiliacion.dbo.tbVinculados d  ,
				  bdAfiliacion.dbo.tbTiposIdentificacion f ,
				  tbliquidaciones g    , 
				  tbPeriodosliquidacion_Vigencias h  ,
				  bdAfiliacion.dbo.Tbsedes  s  ,
				  bdAfiliacion.dbo.tbClasesAportantes i   ,
				  bdAfiliacion.dbo.tbdepartamentos dp, 
				  #tmpEstadosCuentaConsultar ecc 
		 Where    a.nmro_unco_idntfccn_empldr  =    b.nmro_unco_idntfccn_empldr 
		  AND  a.cnsctvo_scrsl     =  b.cnsctvo_scrsl  
		  AND a.cnsctvo_cdgo_clse_aprtnte   =  b.cnsctvo_cdgo_clse_aprtnte  
		 AND  b.cnsctvo_cdgo_cdd   = c.cnsctvo_cdgo_cdd  
		 AND  c.cnsctvo_cdgo_dprtmnto  = dp.cnsctvo_cdgo_dprtmnto  
		 AND a.cnsctvo_cdgo_prdcdd_prpgo   =  e.cnsctvo_cdgo_prdo 
		 AND a.nmro_unco_idntfccn_empldr   =  d.nmro_unco_idntfccn  
		 AND d.cnsctvo_cdgo_tpo_idntfccn   = f.cnsctvo_cdgo_tpo_idntfccn 
		 AND a.cnsctvo_cdgo_lqdcn    =  g.cnsctvo_cdgo_lqdcn  
		 AND g.cnsctvo_cdgo_prdo_lqdcn   = h.cnsctvo_cdgo_prdo_lqdcn  
		 AND s.cnsctvo_cdgo_sde    = b.sde_crtra_pc  
		 AND  b.cnsctvo_cdgo_clse_aprtnte   =  i.cnsctvo_cdgo_clse_aprtnte 
		 AND g.cnsctvo_cdgo_estdo_lqdcn   in (3,6)  --Finalizada y finalizada de prueba
		 And a.nmro_estdo_cnta   = ecc.nmro_estdo_cnta
		 And     datediff(dd,c.inco_vgnca,getdate())>=0  And datediff(dd,getdate(),c.fn_vgnca)>=0 --Para evaluar la vigencia de ciudad
 


		 Update  #TmpImpresionEstadosCuenta_aux
		 Set  rzn_scl  =  c.rzn_scl
		 From  #TmpImpresionEstadosCuenta_aux  a ,bdafiliacion..tbempleadores b, bdafiliacion..tbempresas c --, tbclasesempleador d
		 Where a.nmro_unco_idntfccn_empldr  = b.nmro_unco_idntfccn
		 And a.cnsctvo_cdgo_clse_aprtnte  = b.cnsctvo_cdgo_clse_aprtnte 
		 And a.nmro_unco_idntfccn_empldr  = c.nmro_unco_idntfccn
		 --And a.vldo     = 'S'


		 Update  #TmpImpresionEstadosCuenta_aux
		 Set  rzn_scl  =   ltrim(rtrim(isnull(prmr_aplldo,'')))  + ' ' + ltrim(rtrim(isnull(sgndo_aplldo,''))) + ' ' + ltrim(rtrim(isnull(prmr_nmbre,''))) + ' ' + ltrim(rtrim(isnull(sgndo_nmbre,'')))
		 From  #TmpImpresionEstadosCuenta_aux  a , bdafiliacion..tbempleadores b, bdafiliacion..tbpersonas c
		 Where a.nmro_unco_idntfccn_empldr  = b.nmro_unco_idntfccn
		 And a.cnsctvo_cdgo_clse_aprtnte  = b.cnsctvo_cdgo_clse_aprtnte 
		 And a.nmro_unco_idntfccn_empldr  = c.nmro_unco_idntfccn
		 And rzn_scl     = ''



		 Insert Into #tmpReporteEstadocuenta
select e.nmro_estdo_cnta,		e.cdgo_tpo_idntfccn, 		e.nmro_idntfccn, 		e.dscrpcn_clse_aprtnte,
	e.nmbre_scrsl,			e.rzn_scl,				e.ttl_fctrdo, 		e.usro_crcn,		
	e.cnsctvo_cdgo_lqdcn,
	e.accn	,		
	e.cnsctvo_estdo_cnta, 		e.fcha_gnrcn, 		e.nmro_unco_idntfccn_empldr,
	e.cnsctvo_scrsl, 			e.cnsctvo_cdgo_clse_aprtnte,       	e.cnsctvo_cdgo_sde,	e.vlr_iva, 
	e.sldo_fvr, 			e.ttl_pgr,	 			e.Cts_Cnclr, 		e.Cts_sn_Cnclr,
	e.cdgo_cdd, 			e.dscrpcn_cdd, 			e.dscrpcn_prdo, 		e.cdgo_prdo,
	e.dscrpcn_tpo_idntfccn, 		e.drccn, 				ltrim(rtrim(isnull(e.tlfno,''))), 			e.cnsctvo_cdgo_prdo_lqdcn,
	 e.fcha_incl_fctrcn,		dateadd(day,-1,DATEADD(month, e.Cts_Cnclr, e.fcha_incl_fctrcn) )  fcha_fnl_fctrcn 	, 	              	e.fcha_pgo, 	e.sldo_antrr,	
	e.cnsctvo_cdgo_tpo_idntfccn,	
	Rtrim(Ltrim(b.dscrpcn_cncpto_lqdcn))   descripcion_concepto,
	Rtrim(Ltrim(str(a.cntdd)))  cantidad_Concepto,
	Ltrim(Rtrim(convert(varchar(18),a.vlr_cbrdo)))  valor_Concepto,
	''  descripcion_concepto1,
	''  cantidad_Concepto1,
	''  valor_Concepto1,
	e.dscrpcn_sde,
	e.nmro_Aux,
	e.cdgo_sde
from  #TmpImpresionEstadosCuenta_aux e 
inner join bdcarteraPac.dbo.TbEstadosCuentaConceptos 	a 
On	a.cnsctvo_estdo_cnta		=	e.cnsctvo_estdo_cnta
inner join 	bdcarteraPac.dbo.tbconceptosliquidacion_vigencias  	b
on 		a.cnsctvo_cdgo_cncpto_lqdcn	=	b.cnsctvo_cdgo_cncpto_lqdcn
inner join     	bdplanbeneficios.dbo.tbplanes 	c  
on  	b.cnsctvo_cdgo_pln		=	c.cnsctvo_cdgo_pln
And	a.cnsctvo_cdgo_cncpto_lqdcn	=	b.cnsctvo_cdgo_cncpto_lqdcn
And	getdate()	between	 b.inco_vgnca	and		b.fn_vgnca
And a.cnsctvo_cdgo_cncpto_lqdcn <>  @CONCEPTO_IVA 
order by a.cnsctvo_estdo_cnta,b.dscrpcn_cncpto_lqdcn
/*
update #tmpReporteEstadocuenta
set  valor_Concepto =   bdrecaudos.[dbo].[fnPasaFormatoDecimal] (	valor_Concepto,  1)*/

		 Insert Into #resultado ( descripcion_concepto	,				cantidad_Concepto,
					valor_Concepto)
		 SELECT  descripcion_concepto	,				cantidad_Concepto,
					valor_Concepto					 
						From 	#tmpReporteEstadocuenta


		  --Detalle del reporte
		 Select 		 				 
					descripcion_concepto	,				cantidad_Concepto,
					valor_Concepto				
		From 	#resultado
		ORDER BY 		descripcion_concepto		

End 

