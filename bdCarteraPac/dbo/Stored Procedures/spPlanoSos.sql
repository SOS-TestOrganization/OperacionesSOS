/*---------------------------------------------------------------------------------
* Metodo o PRG	:  spPlanoServicio Occidental de Salud
* Desarrollado por	: <\A Ing. Fernando Valencia Echeverry							A\>
* Descripcion		: <\D Este procedimiento crea la informacion del archivo de Fontragrasas  	D\>
* Observaciones	: <\O  										O\>
* Parametros		: <\P fecha  del sistema, numero estado de cuenta				P\>
* Variables		: <\V  										V\>
* Fecha Creacion	: <\FC 2006/04/20								FC\>
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
CREATE  PROCEDURE spPlanoSos

As

Declare

@ldfechaSistema		Datetime,
@Nmro_estdo_cnta	Varchar(15)

Set Nocount On

Select 	@Nmro_estdo_cnta =	vlr
From 	#tbCriteriosTmp
Where 	cmpo_rlcn	 = 	'nmro_estdo_cnta'

Set	@ldfechaSistema	=	Getdate()

Create	Table #tmp2
	(tpo_idntfccn_bnfcro Char(3),	nmro_idntfccn_bnfcro Varchar(23),
	 nmbre_bnfcro Varchar(100),	nui_ctznte udtConsecutivo,  
	cntdd_bnfcrs Int, 		Vlr udtValorGrande,
	cnsctvo_cdgo_tpo_cntrto int,	nmro_cntrto char(15))				

Insert	Into #tmp2
	(tpo_idntfccn_bnfcro,		nmro_idntfccn_bnfcro,
	 nmbre_bnfcro,			nui_ctznte,
	 cntdd_bnfcrs,			Vlr,
	 cnsctvo_cdgo_tpo_cntrto, 	nmro_cntrto)
Select  '',				'',
	'',				0,
	b.cntdd_bnfcrs,			b.Vlr_cbrdo,
	b.cnsctvo_cdgo_tpo_cntrto,     b.nmro_cntrto			
From	bdCarteraPac.dbo.tbEstadosCuenta a Inner Join
	bdCarteraPac.dbo.tbEstadosCuentaContratos b
On	a.cnsctvo_estdo_cnta 	    = b.cnsctvo_estdo_cnta
Where	a.nmro_estdo_cnta	=	@Nmro_estdo_cnta

--Se actualiza el nui del cotizante
Update	#tmp2
Set	nui_ctznte = z.nmro_unco_idntfccn_afldo
From	#tmp2 a Inner Join
	bdafiliacion.dbo.tbcontratos z
On	a.nmro_cntrto = z.nmro_cntrto
And	a.cnsctvo_cdgo_tpo_cntrto = z.cnsctvo_cdgo_tpo_cntrto


Update	#tmp2
Set	tpo_idntfccn_bnfcro = ti.cdgo_tpo_idntfccn,
	nmro_idntfccn_bnfcro = v.nmro_idntfccn
From	#tmp2 a Inner Join
	bdafiliacion.dbo.tbVinculados v
On	a.nui_ctznte = v.nmro_unco_idntfccn Inner Join
	bdAfiliacion.dbo.tbTiposIdentificacion ti
On	v.cnsctvo_cdgo_tpo_idntfccn = ti.cnsctvo_cdgo_tpo_idntfccn

Create	Table #tmp1
	(tpo_idntfccn_bnfcro Char(3),			nmro_idntfccn_bnfcro Varchar(23),
	 nmbre_bnfcro Varchar(100),			cntdd_bnfcrs Int,
	 Vlr udtValorGrande,				nui_ctznte udtConsecutivo )				

Insert into #tmp1 (tpo_idntfccn_bnfcro, nmro_idntfccn_bnfcro, nui_ctznte, Vlr, cntdd_bnfcrs)				
select  tpo_idntfccn_bnfcro, nmro_idntfccn_bnfcro, nui_ctznte,  SUM(Vlr) as vlr, sum(cntdd_bnfcrs) as cntdd_bnfcrs
from #tmp2
group by tpo_idntfccn_bnfcro, nmro_idntfccn_bnfcro, nui_ctznte 
Order By  1,2

Update	#tmp1
Set	nmbre_bnfcro	= Convert(Varchar(50),Ltrim(Rtrim(prmr_aplldo)) + ' ' + Ltrim(Rtrim(sgndo_aplldo)) + ' ' + Ltrim(Rtrim(prmr_nmbre)) + ' '  + Ltrim(Rtrim(sgndo_nmbre)))
From	#tmp1 a Inner Join
	bdafiliacion.dbo.tbPersonas b
On	a.nui_ctznte	=	b.nmro_unco_idntfccn

select tpo_idntfccn_bnfcro, nmro_idntfccn_bnfcro, nmbre_bnfcro, cntdd_bnfcrs, Vlr 
from #tmp1

