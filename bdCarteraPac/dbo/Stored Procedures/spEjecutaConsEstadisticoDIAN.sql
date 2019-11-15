
--------------------------------------------------------------------------------------------

/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spEjecutaConsEstadisticoDIAN
* Desarrollado por		: <\A Ing. Fernando Valencia E								A\>
* Descripcion			: <\D Este procedimiento para generar el de iva por contrato paa la DIAN			 	D\>
* Observaciones		: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2006/05/12											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[spEjecutaConsEstadisticoDIAN]

As

Declare

@tbla			Varchar(128),
@cdgo_cmpo 		Varchar(128),
@oprdr 		Varchar(2),
@vlr 			Varchar(250),
@cmpo_rlcn 		Varchar(128),
@cmpo_rlcn_prmtro 	Varchar(128),
@cnsctvo		Numeric(4),
@IcInstruccion		Nvarchar(4000),
@IcInstruccion1	Nvarchar(4000),
@IcInstruccion2	Nvarchar(4000),
@lcAlias		Char(2),
@lnContador		Int,
@ldFechaSistema	Datetime,
@Fecha_Corte		Datetime,
@Fecha_Caracter	Varchar(15),
@lnValorIva		Numeric(12,2),
@lnPeriodoEvaluar	Int,
@ldprcntje_fctrcn	Decimal(3,2),
@ldPrcntje_iva		Decimal(3,2),
@Valor_Porcentaje_Iva	UdtValorDecimales,
@Valor_porcentaje_fact	UdtValorDecimales

Set Nocount On

Select	@ldFechaSistema	= Getdate()

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

Select	a.cnsctvo_estdo_cnta,
	fcha_incl_prdo_lqdcn,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	vlr_cbrdo,   
	cntdd_bnfcrs,
	nmro_unco_idntfccn_empldr,
	cnsctvo_cdgo_clse_aprtnte,
	cnsctvo_scrsl,
	0 cnsctvo_sde_inflnca,
	0 Valor_iva,
	--Convert(Numeric(12,2),vlr_iva) / Convert(Numeric(12,2),ttl_fctrdo) * 100  Valor_iva,
	Space(50)	dscrpcn_sde,
	Space(10)	cdgo_sde,
	0		nmro_unco_idntfccn_afldo,
	0		cnsctvo_estdo_cnta_cntrto_bnfcro,
	Convert(Numeric(12,2),0)	Valor_Iva_Bene,
	Convert(Numeric(12,0),0) 	Valor_facturado,
	a.cnsctvo_cdgo_lqdcn,
	0	Grupo,
	0	cnsctvo_cdgo_tps_cbro,
	0	cnsctvo_estdo_cnta_cntrto,
	0	cnsctvo_cdgo_cdd_rsdnca,
	0	cnsctvo_cdgo_pln,
	Space(30)	dscrpcn_pln,
	space(50) prmr_aplldo,
	space(50) sgndo_aplldo,
	space(50) prmr_nmbre,	
	space(50) sgndo_nmbre,
	space(3) TIempresa,
	space(15) NIempresa,
	space(100) nmbre_emprsa,
	0	cnsctvo_cdgo_tpo_idntfccn_empresa,
	space(3) TICotizante,
	space(15) NIcotizante,
	0	cnsctvo_cdgo_tpo_idntfccn_cotizante
Into	#tmpEstadisticoFacturacion
From	bdCarteraPac.dbo.TbestadosCuenta a,
	bdCarteraPac.dbo.TbEstadosCuentaContratos  c,
	#tmpLiquidacionesFinalizadas  d
Where	a.cnsctvo_estdo_cnta	= c.cnsctvo_estdo_cnta
And	a.cnsctvo_cdgo_lqdcn	= d.cnsctvo_cdgo_lqdcn
And	1			= 2

Insert	Into	#tmpEstadisticoFacturacion
Select	a.cnsctvo_estdo_cnta,
	fcha_incl_prdo_lqdcn,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	vlr_cbrdo,
	cntdd_bnfcrs,
	a.nmro_unco_idntfccn_empldr,
	a.cnsctvo_cdgo_clse_aprtnte,
	a.cnsctvo_scrsl,
	0,
	convert(int,@Valor_Porcentaje_Iva),
	'','',
	0,
	cnsctvo_estdo_cnta_cntrto_bnfcro,
	0,
	0,
	a.cnsctvo_cdgo_lqdcn,
	0,
	0,
	c.cnsctvo_estdo_cnta_cntrto,
	0,
	0,
	'',
 	space(50) prmr_aplldo,
	space(50) sgndo_aplldo,
	space(50) prmr_nmbre,	
	space(50) sgndo_nmbre,
	space(3) TIempresa,
	space(15) NIempresa,
	space(100) nmbre_emprsa,
	0	cnsctvo_cdgo_tpo_idntfccn_empresa,
	space(3) TICotizante,
	space(15) NIcotizante,
	0	cnsctvo_cdgo_tpo_idntfccn_cotizante
From	bdCarteraPac.dbo.tbEstadosCuenta a,
	bdCarteraPac.dbo.tbEstadosCuentaContratos  c,
	#tmpLiquidacionesFinalizadas d,
	bdCarteraPac.dbo.tbCuentasContratosBeneficiarios t
Where	a.cnsctvo_estdo_cnta		= c.cnsctvo_estdo_cnta  
And	a.cnsctvo_cdgo_lqdcn		= d.cnsctvo_cdgo_lqdcn  
And	a.cnsctvo_cdgo_estdo_estdo_cnta	!= 4
And	t.cnsctvo_estdo_cnta_cntrto 	= c.cnsctvo_estdo_cnta_cntrto
And	fcha_incl_prdo_lqdcn		= @lnPeriodoEvaluar

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


Select	cnsctvo_estdo_cnta_cntrto ,grupo , Sum(Valor_Iva_Bene) Valor_Iva_Bene ,Sum(Valor_facturado) Valor_facturado, cnsctvo_cdgo_tps_cbro,
	Count(nmro_unco_idntfccn_afldo) Cantidad_bene
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
And	a.cnsctvo_cdgo_tps_cbro	= b.cnsctvo_cdgo_tps_cbro

update a
set   	nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn_afldo
from  	#tmpEstadisticoFacturacion a inner join bdafiliacion.dbo.tbcontratos b
On    	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
and	a.nmro_cntrto			=	b.nmro_cntrto


Update #tmpEstadisticoFacturacion
Set	NIempresa				=	convert(varchar(11),b.nmro_idntfccn),
	cnsctvo_cdgo_tpo_idntfccn_empresa	=	b.cnsctvo_cdgo_tpo_idntfccn
From	#tmpEstadisticoFacturacion a,		 	bdAfiliacion..tbvinculados b
Where 	a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn


Update #tmpEstadisticoFacturacion
Set	NIcotizante				=	convert(varchar(11),b.nmro_idntfccn),
	cnsctvo_cdgo_tpo_idntfccn_cotizante	=	b.cnsctvo_cdgo_tpo_idntfccn
From	#tmpEstadisticoFacturacion a,		 bdAfiliacion..tbvinculados b
Where 	a.nmro_unco_idntfccn_afldo		=	b.nmro_unco_idntfccn


update  #tmpEstadisticoFacturacion
Set	TIempresa	=	b.cdgo_tpo_idntfccn
From	#tmpEstadisticoFacturacion a , bdafiliacion..tbtiposidentificacion b
Where   a.cnsctvo_cdgo_tpo_idntfccn_empresa	=	b.cnsctvo_cdgo_tpo_idntfccn


update  #tmpEstadisticoFacturacion
Set	TICotizante	=	b.cdgo_tpo_idntfccn
From	#tmpEstadisticoFacturacion a , bdafiliacion..tbtiposidentificacion b
Where   a.cnsctvo_cdgo_tpo_idntfccn_cotizante	=	b.cnsctvo_cdgo_tpo_idntfccn


Update  #tmpEstadisticoFacturacion
Set	prmr_nmbre		=	  ltrim(rtrim(b.prmr_nmbre))  
From	#tmpEstadisticoFacturacion a , bdAfiliacion..tbpersonas b
Where   a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn

Update  #tmpEstadisticoFacturacion
Set	sgndo_nmbre		=	  ltrim(rtrim(b.sgndo_nmbre))  
From	#tmpEstadisticoFacturacion a , bdAfiliacion..tbpersonas b
Where   a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn

Update  #tmpEstadisticoFacturacion
Set	prmr_aplldo		=	  ltrim(rtrim(b.prmr_aplldo))  
From	#tmpEstadisticoFacturacion a , bdAfiliacion..tbpersonas b
Where   a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn

Update  #tmpEstadisticoFacturacion
Set	sgndo_aplldo		=	  ltrim(rtrim(b.sgndo_aplldo))  
From	#tmpEstadisticoFacturacion a , bdAfiliacion..tbpersonas b
Where   a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn


Update  #tmpEstadisticoFacturacion
Set	nmbre_emprsa			=	  ltrim(rtrim(b.nmbre_scrsl))  
From	#tmpEstadisticoFacturacion a , bdAfiliacion.dbo.tbSucursalesAportante b
Where   a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
and 	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl


SELECT cnsctvo_estdo_cnta, 
	fcha_incl_prdo_lqdcn, 
	cnsctvo_cdgo_tpo_cntrto, 
	nmro_cntrto,
	vlr_cbrdo, 
	TICotizante,
	NIcotizante,
	prmr_aplldo,
	sgndo_aplldo,
	prmr_nmbre,
	sgndo_nmbre,
	TIempresa,
	NIempresa,
	nmbre_emprsa,
	Convert(Numeric(12,2),valor_iva) as valor_iva,
	Convert(Numeric(12,2),Valor_Iva_Bene) as  Valor_Iva_Bene, 
	Valor_facturado 
	FROM #tmpEstadisticoFacturacion




