

/*---------------------------------------------------------------------------------
* Metodo o PRG 		:  SpTraerInformacionBeneficiariosXContrato
* Desarrollado por		: <\A Ing. Rolando simbaqueva lasso									A\>
* Descripcion			: <\D Este procedimiento realiza una busqueda de los beneficiarios de un contrato			  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P  													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003/02/05 											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  Rolando Simbaqueva LassoAM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM 2003/03/25	 FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[SpTraerInformacionBeneficiariosXContrato]
	@lnNumeroContrato			udtNumeroFormulario,
	@lnTipoContrato			udtConsecutivo,
	@lnlnconsecutivoCobranza		udtConsecutivo,
	@ValorTotalCuota			numeric(12)	output
As	Declare	
	@ldFechasistema			Datetime,
	@cnsctvo_cdgo_prdo_lqdcn		int,
	@ldFecha_Corte			datetime,
	@Poliza_HCU				int

Set Nocount On


Set	@ldFechasistema	=	Getdate()
Set	@Poliza_HCU		=	119

-- se trae el periodo de liquidacion
Select 	@cnsctvo_cdgo_prdo_lqdcn			=	cnsctvo_cdgo_prdo_lqdcn
From	tbPeriodosliquidacion_Vigencias
Where	cnsctvo_cdgo_estdo_prdo			=	2	--Asigan el periodo de liquidacion  estado con periodo abierto


--  estado con periodo abierto
Select 	@ldFecha_Corte		=	fcha_incl_prdo_lqdcn
From	tbPeriodosliquidacion_Vigencias
Where	cnsctvo_cdgo_estdo_prdo	=	2	
And	cnsctvo_cdgo_prdo_lqdcn	=	@cnsctvo_cdgo_prdo_lqdcn

Select  space(3)	cdgo_tpo_idntfccn,
	space(20)	nmro_idntfccn,
	space(100)	nombres,
	b.dscrpcn_prntsco,
	a.inco_vgnca_bnfcro,
	a.fn_vgnca_bnfcro,
	space(100)	dscrpcn_estdo_bnfcro,
	convert(datetime,null)	Fcha_ncmnto,
	0 	Vlr_cta,
	'N'	pos,
	convert(datetime,null)	inco_drcn_rgstro,
	'N'	HCU,
	0	cnsctvo_cdgo_estdo_bfcro,
	cnsctvo_bnfcro,
	nmro_unco_idntfccn_bnfcro,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	@lnlnconsecutivoCobranza	cnsctvo_cbrnza,
	case when	@ldFechasistema	between  inco_vgnca_bnfcro 	and	fn_vgnca_bnfcro then  1 else 0 end  Vigente
into 	#tmpBeneficiarios	
From	bdAfiliacion..tbbeneficiarios a, bdafiliacion..tbparentescos b
Where	a.nmro_cntrto			=	@lnNumeroContrato
And	a.cnsctvo_cdgo_tpo_cntrto	=	@lnTipoContrato
And 	a.cnsctvo_cdgo_prntsco	=	b.cnsctvo_cdgo_prntscs

Update #tmpBeneficiarios
Set	HCU	=	'S'
From	#tmpBeneficiarios a, bdafiliacion..tbafiliados b
Where	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn_afldo
And	b.cnsctvo_cdgo_plza_antrr	=	@Poliza_HCU



Update #tmpBeneficiarios
Set	pos	=	'S'
From	#tmpBeneficiarios a, bdafiliacion..tbbeneficiarios b
Where	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn_bnfcro
And	b.cnsctvo_cdgo_tpo_cntrto	=	1	
And	estdo				=	'A'
And	@ldFechasistema	between  b.inco_vgnca_bnfcro 	and	b.fn_vgnca_bnfcro



Update #tmpBeneficiarios
Set	nombres	=ltrim(rtrim(prmr_aplldo)) +    ' '  +ltrim(Rtrim(sgndo_aplldo)) + ' ' + ltrim(rtrim(prmr_nmbre))  + ' ' + ltrim(rtrim(sgndo_nmbre)),
	fcha_ncmnto	=	b.Fcha_ncmnto
From	#tmpBeneficiarios a, bdAfiliacion..tbpersonas b
Where 	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn

Update  #tmpBeneficiarios
Set	nmro_idntfccn		=	b.nmro_idntfccn,
	cdgo_tpo_idntfccn	=	c.cdgo_tpo_idntfccn
From	#tmpBeneficiarios a,	 bdAfiliacion..tbVinculados b, bdafiliacion..tbtiposidentificacion c
Where 	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn
And	b.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn	

Update  #tmpBeneficiarios
Set	cnsctvo_cdgo_estdo_bfcro	=	b.cnsctvo_cdgo_estdo_bfcro
From	#tmpBeneficiarios a, bdAfiliacion..tbhistoricoEstadosBeneficiario  b 
Where	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto
And	a.cnsctvo_bnfcro		=	b.cnsctvo_bnfcro
And	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn_bnfcro
And	@ldFechasistema between b.inco_vgnca_estdo_bnfcro  and b.fn_vgnca_estdo_bnfcro
And	b.hbltdo				=	'S'

/*
Update  #tmpBeneficiarios
Set	cnsctvo_cdgo_estdo_bfcro	=	b.cnsctvo_cdgo_estdo_bfcro
From	#tmpBeneficiarios a, bdafiliacion..tbhistoricoEstadosBeneficiario  b 
Where	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto
And	a.cnsctvo_bnfcro		=	b.cnsctvo_bnfcro
And	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn_bnfcro
And	@ldFechasistema between b.inco_vgnca_estdo_bnfcro  and b.fn_vgnca_estdo_bnfcro
And	b.hbltdo				=	'S'
*/
                
Update  #tmpBeneficiarios
Set	dscrpcn_estdo_bnfcro		=	b.dscrpcn
From	#tmpBeneficiarios a, bdafiliacion..TbEstados  b 
Where	a.cnsctvo_cdgo_estdo_bfcro	=	b.cnsctvo_cdgo_estdo_afldo

Update  #tmpBeneficiarios
Set	Vlr_cta		=	b.vlr_upc,
	inco_drcn_rgstro	=	b.inco_drcn_rgstro
From	#tmpBeneficiarios a, bdafiliacion..tbdetbeneficiarioAdicional  b 
Where	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto
And	a.cnsctvo_bnfcro		=	b.cnsctvo_bnfcro
And	a.cnsctvo_cbrnza		=	b.cnsctvo_cbrnza
And	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn_bnfcro
and	b.estdo_rgstro			=	'S'	
And	 convert(varchar(10),@ldFecha_Corte,111) 	
	between convert(varchar(10),b.inco_vgnca,111)       and
	convert(varchar(10),b.fn_vgnca,111) -- que sea el siguiente del periodo a evaluar


Select	@ValorTotalCuota = isnull(Sum(Vlr_cta),0)
From	#tmpBeneficiarios
Where 	Vigente	=	1

Select  * From #tmpBeneficiarios

drop table #tmpBeneficiarios


