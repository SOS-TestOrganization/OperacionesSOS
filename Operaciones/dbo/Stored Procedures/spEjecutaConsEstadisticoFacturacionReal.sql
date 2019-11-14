



/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spEjecutaConsEstadisticoFacturacionReal
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento para generar el reporte del Estadistico de facturacion			 	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003/02/10											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM Ing. Juan Manuel Victoria AM\>
* Descripcion			: <\DM Se cambia en los Conver el Int por el Bigint DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM 01-07-2015 FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[spEjecutaConsEstadisticoFacturacionReal]

As

Declare

@tbla			Varchar(128),
@cdgo_cmpo 		Varchar(128),
@oprdr 			Varchar(2),
@vlr 			Varchar(250),
@cmpo_rlcn 		Varchar(128),
@cmpo_rlcn_prmtro 	Varchar(128),
@cnsctvo		Numeric(4),
@IcInstruccion		Nvarchar(4000),
@IcInstruccion1		Nvarchar(4000),
@IcInstruccion2		Nvarchar(4000),
@lcAlias		Char(2),
@lnContador		Int,
@ldFechaSistema		Datetime,
@Fecha_Corte		Datetime,
@Fecha_Caracter		Varchar(15),
@lnValorIva		Numeric(12,2),
@lnPeriodoEvaluar	Int,
@lnTotal_Plan_Bienestar	BigInt,
@lnTotal_Plan_excelencia	Int,
@lnTotal_Plan_Quimbaya	Int,
@lnTotal_Plan_Familiar	Int,
@lCNombre_Plan_Bienestar	Char(20),
@lCNombre_Plan_excelencia	Char(20),
@lCNombre_Plan_Quimbaya	Char(20),
@lCNombre_Plan_Familiar	Char(20),
@lnTotalBenef_Bienestar	Int,
@lnTotalBenef_Excelencia Int,
@lnTotalBenef_Quimbaya	Int,
@lnTotalBenef_Familiar	Int,
@ldprcntje_fctrcn	Decimal(3,2),
@ldPrcntje_iva		Decimal(3,2),
@Valor_Porcentaje_Iva	UdtValorDecimales,
@Valor_porcentaje_fact	UdtValorDecimales

Set Nocount On

Select	@ldFechaSistema		= Getdate()

Set	@lnPeriodoEvaluar	= 0

Select	@lnPeriodoEvaluar	= Convert(Int,vlr)
From	#tbCriteriosTmp
Where 	cdgo_cmpo		= 'fcha_incl_prdo_lqdcn'

Select	@Valor_Porcentaje_Iva	= prcntje
From	bdCarteraPac.dbo.tbConceptosLiquidacion_Vigencias
Where	cnsctvo_cdgo_cncpto_lqdcn	= 3
And	@ldFechaSistema	Between inco_vgnca And 	fn_vgnca

Set	@Valor_porcentaje_fact	= Convert(Float,(100 + convert(Int,@Valor_Porcentaje_Iva)))/Convert(Float,100)

Select	bdrecaudos.dbo.fnCalculaPeriodo (a.fcha_incl_prdo_lqdcn) 	fcha_incl_prdo_lqdcn,
	cnsctvo_cdgo_lqdcn
Into	#tmpLiquidacionesFinalizadas
From	bdCarteraPac.dbo.tbPeriodosliquidacion_Vigencias a, bdCarteraPac.dbo.tbLiquidaciones b
Where   a.cnsctvo_cdgo_prdo_lqdcn	=	b.cnsctvo_cdgo_prdo_lqdcn
And	b.cnsctvo_cdgo_estdo_lqdcn	=	3

-- primero se hace para estados de cuenta

Select	fcha_incl_prdo_lqdcn,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	vlr_cbrdo,   
	cntdd_bnfcrs,
	nmro_unco_idntfccn_empldr,
	cnsctvo_cdgo_clse_aprtnte,
	cnsctvo_scrsl,
	0 cnsctvo_sde_inflnca,
	Convert(Numeric(12,2),vlr_iva) / Convert(Numeric(12,2),ttl_fctrdo) * 100  Valor_iva,
	Space(50)	dscrpcn_sde,
	Space(10)	cdgo_sde,
	0		nmro_unco_idntfccn_bnfcro,
	0		cnsctvo_estdo_cnta_cntrto_bnfcro,
	Convert(Numeric(12,2),0)	Valor_Iva_Bene,
	Convert(Numeric(12,0),0) 	Valor_facturado,
	a.cnsctvo_cdgo_lqdcn,
	0	Grupo,
	0	cnsctvo_cdgo_tps_cbro,
	0	cnsctvo_estdo_cnta_cntrto,
	0	cnsctvo_cdgo_cdd_rsdnca,
	0	cnsctvo_cdgo_pln,
	Space(30)	dscrpcn_pln
Into	#tmpEstadisticoFacturacion
From	bdCarteraPac.dbo.TbestadosCuenta a,
	bdCarteraPac.dbo.TbEstadosCuentaContratos  c,
	#tmpLiquidacionesFinalizadas  d
Where	a.cnsctvo_estdo_cnta	= c.cnsctvo_estdo_cnta
And	a.cnsctvo_cdgo_lqdcn	= d.cnsctvo_cdgo_lqdcn
And	1			= 2

Insert	Into	#tmpEstadisticoFacturacion
Select	fcha_incl_prdo_lqdcn,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	vlr_cbrdo,
	cntdd_bnfcrs,
	a.nmro_unco_idntfccn_empldr,
	a.cnsctvo_cdgo_clse_aprtnte,
	a.cnsctvo_scrsl,
	0,
	Convert(Numeric(12,2),vlr_iva) / Convert(Numeric(12,2),ttl_fctrdo) * 100  Valor_iva,
	'','',
	nmro_unco_idntfccn_bnfcro,
	cnsctvo_estdo_cnta_cntrto_bnfcro,
	0,
	0,
	a.cnsctvo_cdgo_lqdcn,
	0,
	0,
	c.cnsctvo_estdo_cnta_cntrto,
	0,
	0,
	''
From	bdCarteraPac.dbo.tbEstadosCuenta a,
	bdCarteraPac.dbo.tbEstadosCuentaContratos  c,
	#tmpLiquidacionesFinalizadas d,
	bdCarteraPac.dbo.tbCuentasContratosBeneficiarios t
Where	a.cnsctvo_estdo_cnta		= c.cnsctvo_estdo_cnta  
And	a.cnsctvo_cdgo_lqdcn		= d.cnsctvo_cdgo_lqdcn  
And	a.cnsctvo_cdgo_estdo_estdo_cnta	!= 4
And	t.cnsctvo_estdo_cnta_cntrto 	= c.cnsctvo_estdo_cnta_cntrto
And	fcha_incl_prdo_lqdcn		= @lnPeriodoEvaluar
And a.ttl_fctrdo > 0

Update	#tmpEstadisticoFacturacion
Set	Valor_facturado	=	vlr
From	#tmpEstadisticoFacturacion a, bdCarteraPac.dbo.tbCuentasBeneficiariosConceptos b
Where	a.cnsctvo_estdo_cnta_cntrto_bnfcro	= b.cnsctvo_estdo_cnta_cntrto_bnfcro
And	cnsctvo_cdgo_cncpto_lqdcn		= 4

Update	#tmpEstadisticoFacturacion
Set	Valor_facturado	=	Valor_facturado		-	vlr
From	#tmpEstadisticoFacturacion a, tbCuentasBeneficiariosConceptos b
Where	a.cnsctvo_estdo_cnta_cntrto_bnfcro	=	b.cnsctvo_estdo_cnta_cntrto_bnfcro
And	cnsctvo_cdgo_cncpto_lqdcn		=	5

Update	#tmpEstadisticoFacturacion
Set	Valor_facturado	=	Valor_facturado		-	vlr
From	#tmpEstadisticoFacturacion a, tbCuentasBeneficiariosConceptos b
Where	a.cnsctvo_estdo_cnta_cntrto_bnfcro	=	b.cnsctvo_estdo_cnta_cntrto_bnfcro
And	cnsctvo_cdgo_cncpto_lqdcn		=	6

Update	#tmpEstadisticoFacturacion
Set	Valor_Iva_Bene		=		vlr
From	#tmpEstadisticoFacturacion a, tbCuentasBeneficiariosConceptos b
Where	a.cnsctvo_estdo_cnta_cntrto_bnfcro	=	b.cnsctvo_estdo_cnta_cntrto_bnfcro
And	cnsctvo_cdgo_cncpto_lqdcn		=	3

Update	#tmpEstadisticoFacturacion
Set	grupo			=	b.grupo,
	cnsctvo_cdgo_tps_cbro	=	b.cnsctvo_cdgo_tps_cbro
From	#tmpEstadisticoFacturacion a, tbhistoricotarificacionxproceso b
Where	a.cnsctvo_cdgo_lqdcn		=	b.cnsctvo_cdgo_lqdcn
And	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn

Select	cnsctvo_estdo_cnta_cntrto ,grupo , Sum(Valor_Iva_Bene) Valor_Iva_Bene ,Sum(Valor_facturado) Valor_facturado, cnsctvo_cdgo_tps_cbro,
	Count(nmro_unco_idntfccn_bnfcro) Cantidad_bene
Into	#tmpGrupales
From	#tmpEstadisticoFacturacion
Where	cnsctvo_cdgo_tps_cbro 		= 8
Group By cnsctvo_estdo_cnta_cntrto ,grupo, cnsctvo_cdgo_tps_cbro

Update	#tmpEstadisticoFacturacion
Set	Valor_Iva_Bene	= b.Valor_Iva_Bene  / Cantidad_bene,
	Valor_facturado	= b.Valor_facturado / Cantidad_bene
From	#tmpEstadisticoFacturacion a , #tmpGrupales b
Where	a.cnsctvo_estdo_cnta_cntrto	= b.cnsctvo_estdo_cnta_cntrto
And	a.grupo 			= b.grupo
And	a.cnsctvo_cdgo_tps_cbro		= b.cnsctvo_cdgo_tps_cbro

Update	#tmpEstadisticoFacturacion
Set	cnsctvo_cdgo_cdd_rsdnca		= b.cnsctvo_cdgo_cdd_rsdnca
From	#tmpEstadisticoFacturacion a, 	bdafiliacion.dbo.tbpersonas b
Where	a.nmro_unco_idntfccn_bnfcro	= b.nmro_unco_idntfccn

Update	#tmpEstadisticoFacturacion
Set	cnsctvo_sde_inflnca		= b.cnsctvo_sde_inflnca
From	#tmpEstadisticoFacturacion a, bdafiliacion.dbo.tbciudades_vigencias b
Where	a.cnsctvo_cdgo_cdd_rsdnca	= b.cnsctvo_cdgo_cdd
And		a.fcha_incl_prdo_lqdcn + '01' BetWeen b.inco_vgnca And b.fn_vgnca

Update	#tmpEstadisticoFacturacion
Set	dscrpcn_sde	= s.dscrpcn_sde,
	cdgo_sde	= s.cdgo_sde
From	#tmpEstadisticoFacturacion a,     bdafiliacion.dbo.tbSedes s
Where	a.cnsctvo_sde_inflnca		= s.cnsctvo_cdgo_sde

Update	#tmpEstadisticoFacturacion
Set	cnsctvo_cdgo_pln		= b.cnsctvo_cdgo_pln
From	#tmpEstadisticoFacturacion  a,  BDAfiliacion.dbo.tbcontratos b
Where	a.nmro_cntrto			= b.nmro_cntrto
And	a.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto

Update	#tmpEstadisticoFacturacion
Set	dscrpcn_pln			= b.dscrpcn_pln
From	#tmpEstadisticoFacturacion  a, bdplanbeneficios.dbo.tbplanes  b
Where	a.cnsctvo_cdgo_pln		= b.cnsctvo_cdgo_pln

Select	cnsctvo_cdgo_pln,
	Sum(Valor_Iva_Bene+Valor_facturado) vlr_cbrdo_pln,
	Count(cntdd_bnfcrs) tot_benef
Into	#tmpTotales
From	#tmpEstadisticoFacturacion
Group By cnsctvo_cdgo_pln

Select	@lnTotal_Plan_Bienestar 	= Convert(BigInt,vlr_cbrdo_pln),
	@lnTotalBenef_Bienestar		= tot_benef
From	#tmpTotales
Where	cnsctvo_cdgo_pln		= 8

Select	@lnTotal_Plan_excelencia 	= Convert(Int,vlr_cbrdo_pln),
	@lnTotalBenef_Excelencia	= tot_benef
From	#tmpTotales
Where	cnsctvo_cdgo_pln		= 5

Select	@lnTotal_Plan_Quimbaya		= Convert(Int,vlr_cbrdo_pln),
	@lnTotalBenef_Quimbaya		= tot_benef
From	#tmpTotales
Where	cnsctvo_cdgo_pln		= 6

Select	@lnTotal_Plan_Familiar		= Convert(Int,vlr_cbrdo_pln),
	@lnTotalBenef_Familiar		= tot_benef
From	#tmpTotales
Where	cnsctvo_cdgo_pln		= 2

Select	cdgo_sde,
	dscrpcn_sde,
	fcha_incl_prdo_lqdcn,
	dscrpcn_pln,
	Count(cntdd_bnfcrs)	cntdd_bnfcrs,
	Convert(BigInt,Sum(Valor_Iva_Bene)) valor_iva,
	Convert(BigInt,Sum(Valor_facturado)) valor_Fctrdo,
	Convert(BigInt,Sum(Valor_Iva_Bene+Valor_facturado)) vlr_cbrdo,
	@lnTotal_Plan_Bienestar		lnTotal_Plan_Bienestar,
	@lnTotal_Plan_excelencia	lnTotal_Plan_excelencia,
	@lnTotal_Plan_Quimbaya		lnTotal_Plan_Quimbaya,
	@lnTotal_Plan_Familiar		lnTotal_Plan_Familiar,
	@lnTotalBenef_Bienestar		lnTotalBenef_Bienestar,
	@lnTotalBenef_Excelencia	lnTotalBenef_Excelencia,
	@lnTotalBenef_Quimbaya		lnTotalBenef_Quimbaya,
	@lnTotalBenef_Familiar		lnTotalBenef_Familiar,
	@Valor_Porcentaje_Iva		ldIva,
	@Valor_porcentaje_fact		ldFact,
	Convert(BigInt,(Convert(BigInt,@lnTotal_Plan_Bienestar)/Convert(Numeric(3,2),@Valor_porcentaje_fact))) lnTotalFact_Bienestar,
	Convert(BigInt,(Convert(BigInt,@lnTotal_Plan_excelencia)/Convert(Numeric(12,3),@Valor_porcentaje_fact))) lnTotalFact_Excelencia,
	Convert(BigInt,(Convert(BigInt,@lnTotal_Plan_Quimbaya)/Convert(Numeric(12,3),@Valor_porcentaje_fact))) lnTotalFact_Quimbaya,
	Convert(BigInt,(Convert(BigInt,@lnTotal_Plan_Familiar)/Convert(Numeric(12,3),@Valor_porcentaje_fact))) lnTotalFact_Familiar
From	#tmpEstadisticoFacturacion
Group by  cdgo_sde,
	  dscrpcn_sde,
	  fcha_incl_prdo_lqdcn,
	  dscrpcn_pln
Order By cdgo_sde , dscrpcn_pln


