
/*---------------------------------------------------------------------------------
* Metodo o PRG 			: spExtraccionCartasAfiliadosaDesafiliarxMora
* Desarrollado por		: <\A Ing. Maria Liliana Prieto Rincon			A\>
* Descripcion			: <\D Permite conocer que contratos tienen el nro de periodos consultado por el usuario en estado ingresado, es decir se encuentra moroso por ese nro de periodos D\>
* Observaciones			: <\O 	O\>
* Parametros			: <\P	P\>
* Variables				: <\V  	V\>
* Fecha Creacion		: <\FC 2009/01/19	FC\>
*---------------------------------------------------------------------------------
SAU		Analista	Descripcion
*---------------------------------------------------------------------------------*/
CREATE  PROCEDURE [dbo].[spExtraccionCartasAfiliadosaDesafiliarxMora]			

As
Declare
@nmro_prds int

Set Nocount On

Select	@nmro_prds	=  vlr
From	#tbCriteriosTmp
Where   cdgo_cmpo	= 'nmro_prds'
and		oprdr		= '='

-- selecciono todos los contratos activos que tienen hasta 3 estados de cuenta en estado ingresado, 
-- y cuya liquidacion se encuentre en estado finalizada

--drop table #tmpContratos

select	ec.nmro_unco_idntfccn_empldr,	ec.cnsctvo_scrsl,	ec.cnsctvo_cdgo_clse_aprtnte,
		ecc.cnsctvo_cdgo_tpo_cntrto,	ecc.nmro_cntrto,	b.cnsctvo_cdgo_pln,	
		b.nmro_unco_idntfccn_afldo,		count(distinct ec.cnsctvo_Estdo_cnta) cant
into	#tmpContratos
from	tbestadoscuenta ec
			Inner Join	tbestadoscuentacontratos ecc
				On ec.cnsctvo_Estdo_cnta		=	 ecc.cnsctvo_Estdo_cnta
			Inner join	bdcarteraPac.dbo.tbliquidaciones 		c
				On ec.cnsctvo_cdgo_lqdcn		=	c.cnsctvo_cdgo_lqdcn
			Inner Join	bdafiliacion.dbo.Tbcontratos 				b
			On		ecc.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
			And		ecc.nmro_cntrto				= 	b.nmro_cntrto
where	ec.cnsctvo_cdgo_estdo_estdo_cnta					=	1 --INGRESADA
and		ec.nmro_Estdo_cnta									>	0
And		c.cnsctvo_cdgo_estdo_lqdcn							=	3 -- FINALIZADA
And		b.estdo_cntrto										=	'A'
And		convert(varchar(10),b.fn_vgnca_cntrto,111)			=	'9999/12/31'
group by ec.nmro_unco_idntfccn_empldr,	ec.cnsctvo_scrsl,	ec.cnsctvo_cdgo_clse_aprtnte,
			ecc.cnsctvo_cdgo_tpo_cntrto, ecc.nmro_cntrto,	b.cnsctvo_cdgo_pln,	b.nmro_unco_idntfccn_afldo


-- selecciono solo los contratos que nos deben 3 o mas estados de cuenta
--drop table #temp

select	nmro_unco_idntfccn_empldr,	cnsctvo_scrsl,	cnsctvo_cdgo_clse_aprtnte,
		cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,	cnsctvo_cdgo_pln,	nmro_unco_idntfccn_afldo,	cant
into #temp
from #tmpContratos
where cant =	@nmro_prds
order by nmro_unco_idntfccn_empldr,	cnsctvo_scrsl,	cnsctvo_cdgo_clse_aprtnte,
			cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,	cnsctvo_cdgo_pln,	nmro_unco_idntfccn_afldo,	8

-- completo la informacion para la extraccion

--drop table #tmpExtraccionContratosDesafiliar

select	mp.nmro_cntrto,	mp.cnsctvo_cdgo_tpo_cntrto,
	mp.nmro_unco_idntfccn_afldo,	mp.nmro_unco_idntfccn_empldr,
	mp.cnsctvo_scrsl,	mp.cnsctvo_cdgo_clse_aprtnte,
	E.cnsctvo_cdgo_pln,	E.cdgo_pln,	E.dscrpcn_pln,
	f.nmbre_scrsl,	f.drccn,	f.tlfno,	cdgo_tpo_idntfccn	TI_Empresa,
	nmro_idntfccn 		NI_Empresa,	dscrpcn_clse_aprtnte,	space(4) 	Ti_afldo,
	space(25)	Ni_afldo,	space(250)	nmbre_fldo,	se.dscrpcn_sde,    cnsctvo_Cdgo_cdd,
    space(150)	cdd_emplr, space(150)	dprtmnto_emplr--,	a.cnsctvo_Estdo_cnta,	a.cnsctvo_cdgo_lqdcn
Into #tmpExtraccionContratosDesafiliar
from	#temp mp
		Inner Join	bdafiliacion..tbclasesaportantes		d
			On		mp.cnsctvo_cdgo_clse_aprtnte	=	D.cnsctvo_cdgo_clse_aprtnte
		Inner Join	bdplanbeneficios.dbo.tbplanes			E
			On		mp.cnsctvo_cdgo_pln		=	E.cnsctvo_cdgo_pln
		Inner Join	bdafiliacion.Dbo.tbsucursalesaportante	F
			On		mp.nmro_unco_idntfccn_empldr	=	f.nmro_unco_idntfccn_empldr
			And		mp.cnsctvo_scrsl				=	f.cnsctvo_scrsl
			And		mp.cnsctvo_cdgo_clse_aprtnte	=	f.cnsctvo_cdgo_clse_aprtnte		
		Inner Join	bdafiliacion.dbo.tbVinculados			h
			On		mp.nmro_unco_idntfccn_empldr	=	h.nmro_unco_idntfccn
		Inner Join	bdafiliacion.dbo.tbtiposidentificacion  g
			On		h.cnsctvo_cdgo_tpo_idntfccn	=	g.cnsctvo_cdgo_tpo_idntfccn
		Inner Join	bdafiliacion.dbo.tbsedes				se
			On		se.cnsctvo_cdgo_sde		    =	f.sde_crtra_pc

Update #tmpExtraccionContratosDesafiliar
Set		Ti_afldo	=	g.cdgo_tpo_idntfccn,
		Ni_afldo	=	h.nmro_idntfccn
From	#tmpExtraccionContratosDesafiliar a
		Inner Join	bdafiliacion.dbo.tbVinculados		h
			On	a.nmro_unco_idntfccn_afldo	=	h.nmro_unco_idntfccn	
		Inner Join	bdafiliacion.dbo.tbtiposidentificacion  g
			On	h.cnsctvo_cdgo_tpo_idntfccn	=	g.cnsctvo_cdgo_tpo_idntfccn

Update	#tmpExtraccionContratosDesafiliar
Set		nmbre_fldo	=	ltrim(rtrim(prmr_aplldo)) + Space(1) + ltrim(rtrim(sgndo_aplldo)) + Space(1) + ltrim(rtrim(prmr_nmbre)) + Space(1)  + ltrim(rtrim(sgndo_nmbre))
From	#tmpExtraccionContratosDesafiliar a, bdafiliacion.dbo.tbPersonas b
Where 	a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn

Update	#tmpExtraccionContratosDesafiliar
Set	    cdd_emplr	=	ltrim(rtrim(dscrpcn_cdd)),
 	dprtmnto_emplr = ltrim(rtrim(d.dscrpcn_dprtmnto))
From	#tmpExtraccionContratosDesafiliar a 
inner join bdafiliacion..tbCiudades b
on 	a.cnsctvo_Cdgo_cdd	=	b.cnsctvo_Cdgo_cdd
inner join bdafiliacion..tbDepartamentos d
on substring(b.cdgo_cdd ,1,2) = ltrim(rtrim(d.cdgo_dprtmnto))



select	a.nmro_unco_idntfccn_empldr,a.cnsctvo_cdgo_clse_aprtnte,a.cnsctvo_scrsl
into	#tmpEmpresasMarcadas
from	bdafiliacion.dbo.tbDatosComercialesSucursal a
where	a.ds_pra_sspnsn			>	0

Select dscrpcn_clse_aprtnte, TI_Empresa,NI_Empresa, nmbre_scrsl,cnsctvo_scrsl, drccn,tlfno,
          cdd_emplr, dprtmnto_emplr, dscrpcn_sde,Ti_afldo,ni_afldo,nmbre_fldo,nmro_cntrto,dscrpcn_pln
from	#tmpExtraccionContratosDesafiliar  ecd
Where	Not Exists (select 1 from #tmpEmpresasMarcadas em	
					where ecd.nmro_unco_idntfccn_empldr = em.nmro_unco_idntfccn_empldr
					And	ecd.cnsctvo_cdgo_clse_aprtnte = em.cnsctvo_cdgo_clse_aprtnte
					And	ecd.cnsctvo_scrsl = em.cnsctvo_scrsl
					)

