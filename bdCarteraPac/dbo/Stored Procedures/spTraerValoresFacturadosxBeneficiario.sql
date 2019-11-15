

CREATE PROCEDURE [dbo].[spTraerValoresFacturadosxBeneficiario]
	@cnsctvo_dcmnto		udtConsecutivo	=	NULL,
	@cnsctvo_cdgo_tpo_dcmnto	udtConsecutivo	=	NULL


As  			
set nocount on				


Select  a.cnsctvo_estdo_cnta_cntrto,  
	a.nmro_cntrto,
	a.cnsctvo_cdgo_tpo_cntrto,
	b.cnsctvo_bnfcro,
	b.nmro_unco_idntfccn_bnfcro,
	b.cnsctvo_estdo_cnta_cntrto_bnfcro,
	0	Valor_cuota,
	0	Valor_iva,
	0	Valor_dscto_fncro,
	0	Valor_otros_dctos,
	vlr_cbrdo,
	space(50)		nmbre_bene,
	space(50)		dscrpcn_prntsco,
	0			cnsctvo_cdgo_prntscs,
        	space(3)  		tpo_idntfccn_bene,
         	space(15)  		nmro_idntfccn_bene,
	0	Total,
	c.cnsctvo_cdgo_lqdcn,
	0	grupo,
	space(150)	nmbre_grpo,
	0	cnsctvo_prdcto,	
	0	cnsctvo_mdlo,
	0	vlr_upc,
	0	vlr_rl_pgo
into	#tmpBeneValores
From	tbEstadosCuentaContratos 	a,
	tbCuentasContratosBeneficiarios b,
	Tbestadoscuenta		c
Where 	a.cnsctvo_estdo_cnta_cntrto		=	@cnsctvo_dcmnto
And	a.cnsctvo_estdo_cnta			=	c.cnsctvo_estdo_cnta
And	a.cnsctvo_estdo_cnta_cntrto		=	b.cnsctvo_estdo_cnta_cntrto
Group by a.cnsctvo_estdo_cnta_cntrto,  
	a.nmro_cntrto,
	a.cnsctvo_cdgo_tpo_cntrto,
	b.cnsctvo_bnfcro,
	b.nmro_unco_idntfccn_bnfcro,
	b.cnsctvo_estdo_cnta_cntrto_bnfcro,
	a.vlr_cbrdo,
	cnsctvo_cdgo_lqdcn

Update 	#tmpBeneValores
Set	grupo			=	b.grupo,
	cnsctvo_prdcto		=	b.cnsctvo_prdcto,
	cnsctvo_mdlo		=	b.cnsctvo_mdlo,
	vlr_upc			=	b.vlr_upc,
	vlr_rl_pgo		=	b.vlr_rl_pgo
From	#tmpBeneValores a, tbhistoricotarificacionxproceso b
Where	a.nmro_cntrto 			= 	b.nmro_cntrto
And	a.cnsctvo_cdgo_tpo_cntrto 	= 	b.cnsctvo_cdgo_tpo_cntrto
And	a.cnsctvo_bnfcro		=	b.cnsctvo_bnfcro
And	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn
And	a.cnsctvo_cdgo_lqdcn		=	b.cnsctvo_cdgo_lqdcn


Update 	#tmpBeneValores
Set	nmbre_grpo		=	dscrpcn_dtlle_grpo
From	#tmpBeneValores a, bdafiliacion..tbdetgrupos  b
Where	a.grupo 				= 	b.cnsctvo_cdgo_dtlle_grpo


Update #tmpBeneValores
Set	cnsctvo_cdgo_prntscs		=	b.cnsctvo_cdgo_prntsco
From	#tmpBeneValores a, bdafiliacion..tbbeneficiarios b
Where  a.nmro_cntrto			=	b.nmro_cntrto
And	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.cnsctvo_bnfcro		=	b.cnsctvo_bnfcro
And	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn_bnfcro

Update #tmpBeneValores
Set	dscrpcn_prntsco		=	b.dscrpcn_prntsco
From	#tmpBeneValores a, bdafiliacion..tbparentescos b
Where   a.cnsctvo_cdgo_prntscs	=	b.cnsctvo_cdgo_prntscs

Update #tmpBeneValores
Set	tpo_idntfccn_bene		=	c.cdgo_tpo_idntfccn,
       	nmro_idntfccn_bene		=	b.nmro_idntfccn
From	#tmpBeneValores a, 	bdafiliacion..tbvinculados  b ,
	bdafiliacion..tbtiposidentificacion 	c
Where   a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn
And	b.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn

Update  #tmpBeneValores
Set	nmbre_bene			=	  ltrim(rtrim(e.prmr_aplldo))  + ' ' + ltrim(rtrim(e.sgndo_aplldo)) + ' ' + ltrim(rtrim(e.prmr_Nmbre )) + ' ' + ltrim(rtrim(e.sgndo_nmbre)) 
From	#tmpBeneValores a,  bdAfiliacion..tbpersonas e
Where	  a.nmro_unco_idntfccn_bnfcro	=            e.nmro_unco_idntfccn


Update  #tmpBeneValores
Set	Valor_cuota	=	vlr
From	#tmpBeneValores a, tbCuentasBeneficiariosConceptos b
where   a.cnsctvo_estdo_cnta_cntrto_bnfcro = b.cnsctvo_estdo_cnta_cntrto_bnfcro
And	b.cnsctvo_cdgo_cncpto_lqdcn	   = 4	

Update  #tmpBeneValores
Set	Valor_iva	=	vlr
From	#tmpBeneValores a, tbCuentasBeneficiariosConceptos b
where   a.cnsctvo_estdo_cnta_cntrto_bnfcro = b.cnsctvo_estdo_cnta_cntrto_bnfcro
And	b.cnsctvo_cdgo_cncpto_lqdcn	   = 3

Update  #tmpBeneValores
Set	Valor_dscto_fncro	=	vlr
From	#tmpBeneValores a, tbCuentasBeneficiariosConceptos b
where   a.cnsctvo_estdo_cnta_cntrto_bnfcro = b.cnsctvo_estdo_cnta_cntrto_bnfcro
And	b.cnsctvo_cdgo_cncpto_lqdcn	   = 5

Update  #tmpBeneValores
Set	Valor_otros_dctos	=	vlr
From	#tmpBeneValores a, tbCuentasBeneficiariosConceptos b
where   a.cnsctvo_estdo_cnta_cntrto_bnfcro = b.cnsctvo_estdo_cnta_cntrto_bnfcro
And	b.cnsctvo_cdgo_cncpto_lqdcn	   = 6


Update  #tmpBeneValores
Set	total	=	Valor_cuota  - Valor_dscto_fncro - Valor_otros_dctos + Valor_iva



Select   tpo_idntfccn_bene,
	nmro_idntfccn_bene,
	nmbre_bene,
	dscrpcn_prntsco,
	Valor_cuota, 
	Valor_dscto_fncro,
	Valor_otros_dctos,
	Valor_iva,
	Total,
	cnsctvo_prdcto,
	cnsctvo_mdlo,
	vlr_upc,
	vlr_rl_pgo,
	nmbre_grpo
From 	#tmpBeneValores



