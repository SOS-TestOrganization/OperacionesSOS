/*---------------------------------------------------------------------------------
* Metodo o PRG	: spPlanoMunicipioCali
* Desarrollado por	: <\A Ing. Fernando Valncia							A\>
* Descripcion		: <\D Este procedimiento crea la informacion del archivo de Fontragrasas  	D\>
* Observaciones	: <\O  										O\>
* Parametros		: <\P										P\>
* Variables		: <\V  										V\>
* Fecha Creacion	: <\FC 2006/04/19								FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por	: <\AM  AM\>
* Descripcion		: <\DM  DM\>
* Nuevos Parametros	: <\PM  PM\>
* Nuevas Variables	: <\VM  VM\>
* Fecha Modificacion	: <\FM  FM\>
*---------------------------------------------------------------------------------*/
CREATE  PROCEDURE spPlanoFontragrasas

As

Declare

@ldfechaSistema		Datetime,
@Nmro_estdo_cnta	Varchar(15)

Set Nocount On

Select 	@Nmro_estdo_cnta =	vlr
From 	#tbCriteriosTmp
Where 	cmpo_rlcn	 = 	'nmro_estdo_cnta'

Set	@ldfechaSistema	=	Getdate()

Create	Table #tmp1
	(tpo_idntfccn_bnfcro Char(3),	nmro_idntfccn_bnfcro Varchar(23),
	tpo_idntfccn_ctznte Char(3),	nmro_idntfccn_ctznte Varchar(23),
	nmbre_bnfcro Varchar(100),	nmbre_ctznte Varchar(100),			
	nmro_cntrto Char(15),	 	cnsctvo_cdgo_tpo_cntrto Int,
	cnsctvo_bnfcro Int, 		nmro_unco_idntfccn_bnfcro udtConsecutivo,	
	nui_ctznte udtConsecutivo,	prntsco Int,
	dscrpcn_prntsco varchar(25),   Edd int,
	Nmro_estdo_cnta char(15), 	Vlr udtValorGrande, 
	cnsctvo_cdgo_pln Int, 		cdgo_pln Char(2),
	fcha_ncmnto datetime)

Insert	Into #tmp1
	(tpo_idntfccn_bnfcro,		nmro_idntfccn_bnfcro,
	 nmbre_bnfcro,			nmro_cntrto,
	 cnsctvo_cdgo_tpo_cntrto,	cnsctvo_bnfcro,
	 nmro_unco_idntfccn_bnfcro,	nui_ctznte,
	 prntsco,			Vlr,
	 cnsctvo_cdgo_pln,	 	cdgo_pln)
Select  '',				'',
	'',				b.nmro_cntrto,
	b.cnsctvo_cdgo_tpo_cntrto,	c.cnsctvo_bnfcro,
	c.nmro_unco_idntfccn_bnfcro,	0,
	0,				c.Vlr,
	0,	''
From	bdCarteraPac.dbo.tbEstadosCuenta a Inner Join
	bdCarteraPac.dbo.tbEstadosCuentaContratos b
On	a.cnsctvo_estdo_cnta 	    	= b.cnsctvo_estdo_cnta Inner Join
	bdCarteraPac.dbo.tbCuentasContratosBeneficiarios c
On	b.cnsctvo_estdo_cnta_cntrto 	= c.cnsctvo_estdo_cnta_cntrto
Where	a.nmro_estdo_cnta		= @Nmro_estdo_cnta

Update	#tmp1
Set	prntsco = x.cnsctvo_cdgo_prntsco
From	#tmp1 a Inner Join
	bdafiliacion.dbo.tbBeneficiarios x
On	a.cnsctvo_bnfcro =  x.cnsctvo_bnfcro
And	a.nmro_cntrto = x.nmro_cntrto
And	a.cnsctvo_cdgo_tpo_cntrto = x.cnsctvo_cdgo_tpo_cntrto

update #tmp1
set dscrpcn_prntsco=b.dscrpcn_prntsco
from #tmp1 a inner Join 
	bdafiliacion.dbo.tbparentescos b
On 	a.prntsco=b.cnsctvo_cdgo_prntscs


Update	#tmp1
Set	nui_ctznte = z.nmro_unco_idntfccn_afldo,
	cnsctvo_cdgo_pln = z.cnsctvo_cdgo_pln
From	#tmp1 a Inner Join
	bdafiliacion.dbo.tbcontratos z
On	a.nmro_cntrto = z.nmro_cntrto
And	a.cnsctvo_cdgo_tpo_cntrto = z.cnsctvo_cdgo_tpo_cntrto

Update	#tmp1
Set	cdgo_pln = p.cdgo_pln
From	#tmp1 a Inner Join
	bdPlanBeneficios.dbo.tbplanes p
On	a.cnsctvo_cdgo_pln = p.cnsctvo_cdgo_pln


--Tipo y numero de identificacion para el beneficiario
Update	#tmp1
Set	tpo_idntfccn_bnfcro = ti.cdgo_tpo_idntfccn,
	nmro_idntfccn_bnfcro = v.nmro_idntfccn
From	#tmp1 a Inner Join
	bdafiliacion.dbo.tbVinculados v
On	a.nmro_unco_idntfccn_bnfcro = v.nmro_unco_idntfccn Inner Join
	bdAfiliacion.dbo.tbTiposIdentificacion ti
On	v.cnsctvo_cdgo_tpo_idntfccn = ti.cnsctvo_cdgo_tpo_idntfccn


--Tipo y numero de identificacion para el cotizante
Update	#tmp1
Set	tpo_idntfccn_ctznte 	= ti.cdgo_tpo_idntfccn,
	nmro_idntfccn_ctznte 	= v.nmro_idntfccn
From	#tmp1 a Inner Join
	bdafiliacion.dbo.tbVinculados v
On	a.nui_ctznte = v.nmro_unco_idntfccn Inner Join
	bdAfiliacion.dbo.tbTiposIdentificacion ti
On	v.cnsctvo_cdgo_tpo_idntfccn = ti.cnsctvo_cdgo_tpo_idntfccn


Update	#tmp1
Set	nmbre_ctznte	= Convert(Varchar(50),Ltrim(Rtrim(prmr_aplldo)) + ' ' + Ltrim(Rtrim(sgndo_aplldo)) + ' ' + Ltrim(Rtrim(prmr_nmbre)) + ' '  + Ltrim(Rtrim(sgndo_nmbre))),
	fcha_ncmnto=b.fcha_ncmnto
From	#tmp1 a Inner Join
	bdafiliacion.dbo.tbPersonas b
On	a.nui_ctznte	=	b.nmro_unco_idntfccn

Update	#tmp1
Set	nmbre_bnfcro	= Convert(Varchar(50),Ltrim(Rtrim(prmr_aplldo)) + ' ' + Ltrim(Rtrim(sgndo_aplldo)) + ' ' + Ltrim(Rtrim(prmr_nmbre)) + ' '  + Ltrim(Rtrim(sgndo_nmbre))),
	fcha_ncmnto=b.fcha_ncmnto
From	#tmp1 a Inner Join
	bdafiliacion.dbo.tbPersonas b
On	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn

update #tmp1
set Nmro_estdo_cnta=@Nmro_estdo_cnta

update #tmp1  SET edd = bdAFiliacion.dbo.fnCalculaanos(fcha_ncmnto,getdate(),1)


select 	tpo_idntfccn_bnfcro,		nmro_idntfccn_bnfcro,		tpo_idntfccn_ctznte,
	nmro_idntfccn_ctznte,  	nmbre_bnfcro,			nmbre_ctznte,			
	nmro_cntrto,	 		cnsctvo_cdgo_tpo_cntrto,	cnsctvo_bnfcro ,
	nmro_unco_idntfccn_bnfcro, 	nui_ctznte,			prntsco,
	dscrpcn_prntsco,   		Edd,				Nmro_estdo_cnta, 
	Vlr,				convert(char(10),fcha_ncmnto,111) as fcha_ncmnto
from #tmp1

