
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              	 :   SpImprimirNotaImpuestos
* Desarrollado por		 :  <\A	Ing. Fernando Valencia E 						A\>
* Descripcion			 :  <\D   Inserta la informacion de la nota para imprimir				D\>
* Observaciones		              :  <\O										O\>
* Parametros			 :  <\P    									P\>
* Variables			 :  <\V										V\>
* Fecha Creacion		 :  <\FC  2006/11/30								FC\>
* 
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION  
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------  
* Modificado Por		              : <\AM    AM\>
* Descripcion			 : <\DM   DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM   FM\>
*---------------------------------------------------------------------------------*/
CREATE      PROCEDURE  SpImprimirNotaImpuestos
		@lnConsecutivoTipoNota		udtConsecutivo,
		@lnNumeroNota				Varchar(15)
AS	declare

@lnNivelContrato					int

Set  Nocount On


Set	@lnNivelContrato	=	0

-- se crea uan tabla temporal con la informacion de los contratos asociados a la nota
Select  a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto, nmro_unco_idntfccn_afldo,
	e.vlr		 valor_contrato,
	nmro_idntfccn,cdgo_tpo_idntfccn , 
	e.cnsctvo_nta_cncpto,
	case when	(@lnConsecutivoTipoNota = 3)	then  a.vlr  else   (e.vlr) end		 valor_contrato_concepto,   
--	case when	(@lnConsecutivoTipoNota = 3)	then  a.vlr  else   (a.vlr + a.vlr_iva) end		 valor_contrato_concepto,  
--	e.vlr		 valor_contrato_concepto,   anterior
	space(200) nmbre_afldo,
	e.vlr_ants_iva,  e.vlr_iva as vlr_iva_cncpto
into 	#tmpContratosNotas
From	tbNotasContrato a	,	bdafiliacion..Tbcontratos	b ,
	bdafiliacion..tbVinculados	c , bdafiliacion..tbtiposIdentificacion d,
	tbNotasContratoxConcepto	e
Where 	a.nmro_nta			=	@lnNumeroNota
And	a.cnsctvo_cdgo_tpo_nta		=	@lnConsecutivoTipoNota
And	a.nmro_cntrto			=	b.nmro_cntrto
And	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	b.nmro_unco_idntfccn_afldo	=	c.nmro_unco_idntfccn
And	c.cnsctvo_cdgo_tpo_idntfccn	=	d.cnsctvo_cdgo_tpo_idntfccn
And	a.cnsctvo_nta_cntrto		=	e.cnsctvo_nta_cntrto

-- verificamos si es hay contratos
if	@@ROWCOUNT		=	0
	Set	@lnNivelContrato	=	0
else
	Set	@lnNivelContrato	=	1




--actualiza el nombre del afiliado

Update	#tmpContratosNotas
Set	nmbre_afldo		=   ltrim(rtrim(e.prmr_aplldo))  + ' ' + ltrim(rtrim(e.sgndo_aplldo)) + ' ' + ltrim(rtrim(e.prmr_Nmbre )) + ' ' + ltrim(rtrim(e.sgndo_nmbre)) 
From    #tmpContratosNotas a , 	bdafiliacion..tbpersonas e 
Where   a.nmro_unco_idntfccn_afldo  	=    e.nmro_unco_idntfccn



--se crea una tabla temporal de los conceptos de las notas

Select  a.nmro_unco_idntfccn_empldr,
	a.cnsctvo_scrsl, 
	a.cnsctvo_cdgo_clse_aprtnte,
	b.cnsctvo_cdgo_cncpto_lqdcn,
	a.vlr_nta 	valor_total_nota,  -- aqui debe reemplazar el valor de del saldo de la nota
	b.vlr_nta valor_nota_concepto,
	c.cdgo_cncpto_lqdcn,
	c.Dscrpcn_cncpto_lqdcn,
	d.nmro_idntfccn,
	e.cdgo_tpo_idntfccn ,
	b.cnsctvo_nta_cncpto,
	f.nmbre_scrsl,
	f.drccn,
	g.dscrpcn_cdd,
	 space(200) rzn_scl,
	0	Cantidad_contratos_concepto,
	a.usro_crcn,
              a.cnsctvo_cdgo_estdo_nta,
	a.vlr_iva,
	a.sldo_nta,
	a.obsrvcns,
	a.fcha_crcn_nta
Into	#TmpConceptosNotas
From 	TbnotasPac	a,	TbNotasConceptos b , TbconceptosLiquidacion c,	
	bdafiliacion..tbVinculados	d , bdafiliacion..tbtiposIdentificacion e,
	bdafiliacion..tbsucursalesaportante		f,	 bdafiliacion..tbciudades  g
Where 	a.nmro_nta			=	b.nmro_nta
And	a.cnsctvo_cdgo_tpo_nta		=	b.cnsctvo_cdgo_tpo_nta
And	b.cnsctvo_cdgo_cncpto_lqdcn	=	c.cnsctvo_cdgo_cncpto_lqdcn
And	a.nmro_unco_idntfccn_empldr	=	d.nmro_unco_idntfccn
And	d.cnsctvo_cdgo_tpo_idntfccn	=	e.cnsctvo_cdgo_tpo_idntfccn	
And	a.nmro_nta			=	@lnNumeroNota
And	a.cnsctvo_cdgo_tpo_nta		=	@lnConsecutivoTipoNota	
And	f.cnsctvo_scrsl			=	a.cnsctvo_scrsl	
And	f. nmro_unco_idntfccn_empldr	=	a.nmro_unco_idntfccn_empldr
And	f. cnsctvo_cdgo_clse_aprtnte	=	a.cnsctvo_cdgo_clse_aprtnte
And	f.cnsctvo_cdgo_cdd		=	g.cnsctvo_cdgo_cdd


-- se consulta la cantidad de cantratos asociados
Select	b.cnsctvo_nta_cncpto ,	count(cnsctvo_nta_cntrto) 	cantidad_contratos_Concepto
into	#TmpCantidadContratosConcepto
From	tbNotasConceptos  a,	 tbNotasContratoxConcepto  b
Where		a.Cnsctvo_nta_cncpto		=	b.Cnsctvo_nta_cncpto
And		a.nmro_nta			=	@lnNumeroNota
And		a.cnsctvo_cdgo_tpo_nta		=	@lnConsecutivoTipoNota	
Group by 	b.cnsctvo_nta_cncpto

-- se actualiza  la cantidad de contratos para el concepto
Update 	#TmpConceptosNotas
Set	Cantidad_contratos_concepto	= 	b.cantidad_contratos_Concepto
From	#TmpConceptosNotas	a,	#TmpCantidadContratosConcepto b
Where	a.Cnsctvo_nta_cncpto		=	b.Cnsctvo_nta_cncpto



-- se adctualiza la razon social

Update 	#TmpConceptosNotas
Set	 rzn_scl	 =  c.rzn_scl
From 	#TmpConceptosNotas	 a	,bdafiliacion..tbempleadores b,	bdafiliacion..tbempresas c --,	tbclasesempleador d
Where	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte 
And	a.nmro_unco_idntfccn_empldr	=	c.nmro_unco_idntfccn
--And	a.vldo				=	'S'


Update 	#TmpConceptosNotas
Set	 rzn_scl	 =   ltrim(rtrim(isnull(prmr_aplldo,'')))  + ' ' + ltrim(rtrim(isnull(sgndo_aplldo,''))) + ' ' + ltrim(rtrim(isnull(prmr_nmbre,''))) + ' ' + ltrim(rtrim(isnull(sgndo_nmbre,'')))
From 	#TmpConceptosNotas	 a	, bdafiliacion..tbempleadores b,	bdafiliacion..tbpersonas c
Where	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte 
And	a.nmro_unco_idntfccn_empldr	=	c.nmro_unco_idntfccn
And	rzn_scl				=	''


---Para sacar los valores del total y de iva 
select 	a.cnsctvo_cdgo_tpo_nta, 
a.nmro_nta,  
convert(bigint,sum(b.vlr)) vlr, 
d.cdgo_cncpto_lqdcn 
into #tmp_valores 
from tbNotasContrato a 
inner join tbNotasContratoxconcepto b
on a.cnsctvo_nta_cntrto=b.cnsctvo_nta_cntrto
inner join tbNotasConceptos c 
On b.Cnsctvo_nta_cncpto=c.Cnsctvo_nta_cncpto
inner join tbConceptosLiquidacion d 
on  c.cnsctvo_cdgo_cncpto_lqdcn = d.cnsctvo_cdgo_cncpto_lqdcn
where  a.cnsctvo_cdgo_tpo_nta=@lnConsecutivoTipoNota
and    a.nmro_nta=@lnNumeroNota 	
group by a.cnsctvo_cdgo_tpo_nta, a.nmro_nta,    d.cdgo_cncpto_lqdcn 


If	@lnNivelContrato	=	0

	Select   space(2)  nmro_cntrto,		  space(2)  valor_contrato ,		
		  space(2)	nmro_idntfccn_contrato,		 space(2)	cdgo_tpo_idntfccn_contrato , 
		 space(2)  cnsctvo_nta_cncpto,	 space(2)  valor_contrato_concepto ,
		 space(2)   nmbre_afldo, 		  valor_nota_concepto,		b.cdgo_cncpto_lqdcn,
		b.Dscrpcn_cncpto_lqdcn,	
		b.nmro_idntfccn 	nmro_idntfccn_responsable,	b.cdgo_tpo_idntfccn  cdgo_tpo_idntfccn_responsable ,	
		b.rzn_scl,
		b.nmbre_scrsl,
		b.drccn,
		b.dscrpcn_cdd,
		@lnNumeroNota		nmro_nta,
		b.valor_total_nota,
		b.Cantidad_contratos_concepto,
		b.usro_crcn,
		b.cnsctvo_cdgo_estdo_nta,
		b.vlr_iva,
		b.sldo_nta,
		b.obsrvcns,
		b.fcha_crcn_nta
	From 	#TmpConceptosNotas	b LEFT OUTER JOIN  #tmpContratosNotas a 
	on	 (b.cnsctvo_nta_cncpto	=	a.cnsctvo_nta_cncpto)
	order by	cdgo_cncpto_lqdcn
Else
	
	Select    a.nmro_cntrto,		a.valor_contrato,		
		a.nmro_idntfccn 		nmro_idntfccn_contrato,		a.cdgo_tpo_idntfccn 	cdgo_tpo_idntfccn_contrato , 
		a.cnsctvo_nta_cncpto,	a.valor_contrato_concepto,
		a.nmbre_afldo , 		b.valor_nota_concepto,		b.cdgo_cncpto_lqdcn,
		b.Dscrpcn_cncpto_lqdcn,	
		b.nmro_idntfccn 	nmro_idntfccn_responsable,	b.cdgo_tpo_idntfccn  cdgo_tpo_idntfccn_responsable ,	
		b.rzn_scl,
		b.nmbre_scrsl,
		b.drccn,
		b.dscrpcn_cdd,
		@lnNumeroNota		nmro_nta,
		b.valor_total_nota,
		b.Cantidad_contratos_concepto,
		b.usro_crcn,
		b.cnsctvo_cdgo_estdo_nta,
		b.vlr_iva,
		b.sldo_nta,
		b.obsrvcns,
		b.fcha_crcn_nta,
		a.vlr_ants_iva,
		a.vlr_iva_cncpto,
	        c.vlr vlr_ttl_cncpto
		From 	#TmpConceptosNotas	b   , #tmpContratosNotas a, #tmp_valores c 
	Where	b.cnsctvo_nta_cncpto	=	a.cnsctvo_nta_cncpto
        and	b.cdgo_cncpto_lqdcn	= 	c.cdgo_cncpto_lqdcn
	order by	b.cdgo_cncpto_lqdcn,  nmbre_afldo

