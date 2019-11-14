/*---------------------------------------------------------------------------------
* Metodo o PRG 		: SpDetalleaplicacionpago
* Desarrollado por		: <\A Ing. Rolando Simbaqueva Lasso					A\>
* Descripcion			: <\D Este traer infromacion detalla del pago aplicado		 	D\>
* Observaciones			: <\O  									O\>
* Parametros			: <\P									P\>
* Variables			: <\V  									V\>
* Fecha Creacion		: <\FC 2003/02/10							FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM   AM\>
* Descripcion			: <\DM   DM\>
* Nuevos Parametros		: <\PM   PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM 	FM\>
*---------------------------------------------------------------------------------*/

CREATE  PROCEDURE [dbo].[SpDetalleaplicacionpago]

As
Set Nocount On


Declare @numeropagoini 	int,
	@numeropagofin 	int

Set	@numeropagoini 	= NULL
Set	@numeropagofin 	= NULL

Select 	@numeropagoini 	 =	vlr
From 	#tbCriteriosTmp
Where 	cdgo_cmpo 	 = 	'cnsctvo_cdgo_pgo' 
And	oprdr	   	 = 	'>='


Select @numeropagofin 	=	vlr	
From #tbCriteriosTmp
Where 	cdgo_cmpo 		= 	'cnsctvo_cdgo_pgo' 
And	oprdr	    		= 	'<='

create table #tmpPago1 ( cnsctvo_cdgo_pgo	 int)

create table #tmpNotas ( nmro_nta	 varchar(15))

create table #tmpTotalResul (cnsctvo_cdgo_pgo int ,
			     nmro_dcmto char(15),
			     tpo_documento char(50),
			     nmro_idntfccn char(20),
			     nmro_unco_idntfccn int,	
			     nmbre_cntrtnte char(250),	
			     nmro_cntrto char(20),
			     dscrpcn_pln char(50),
			     valor_aplicado numeric(12,0))


insert into #tmpPago1
Select 	cnsctvo_cdgo_pgo
from 	bdcarterapac.dbo.tbPagos x
where  x.cnsctvo_cdgo_pgo  >=  @numeropagoini	 
and x.cnsctvo_cdgo_pgo <= @numeropagofin


Insert into #tmpNotas
Select  np.nmro_nta  
From  	dbo.tbNotasPac np 
Where   np.cnsctvo_cdgo_tpo_nta = 1
and     np.nmro_nta not in (select nc.nmro_nta from  dbo.tbNotasContrato nc 
			 where  nc.cnsctvo_cdgo_tpo_nta = 1)
and	np.cnsctvo_cdgo_estdo_nta !=6


insert into #tmpTotalResul
select  a.cnsctvo_cdgo_pgo ,c.nmro_estdo_cnta nmro_dcmto, 'Estado Cuenta' tpo_documento,
	i.nmro_idntfccn,
	i.nmro_unco_idntfccn,
	space(40),
	g.nmro_cntrto,
	h.dscrpcn_pln,
	(a.vlr_abno_cta + a.vlr_abno_iva) valor_aplicado
from 	bdcarterapac.dbo.tbabonoscontrato 	 	a,
	bdcarterapac.dbo.tbEstadoscuentacontratos 	b,
	bdcarterapac.dbo.Tbestadoscuenta 		c,
	bdafiliacion.dbo.tbContratos 			g,
	bdplanbeneficios.dbo.tbPlanes 			h,
	bdafiliacion.dbo.tbVinculados 			i,
	#tmpPago1 j
where   a.cnsctvo_estdo_cnta_cntrto 	= 	b.cnsctvo_estdo_cnta_cntrto
And	b.cnsctvo_estdo_cnta		=	c.cnsctvo_estdo_cnta
And	b.cnsctvo_cdgo_tpo_cntrto 	= 	g.cnsctvo_cdgo_tpo_cntrto
And	b.nmro_cntrto		 	=  	g.nmro_cntrto
And	g.cnsctvo_cdgo_pln		=	h.cnsctvo_cdgo_pln
And	g.nmro_unco_idntfccn_afldo 	= 	i.nmro_unco_idntfccn
and	j.cnsctvo_cdgo_pgo	   	= 	a.cnsctvo_cdgo_pgo
Union
select  e.cnsctvo_cdgo_pgo,nmro_nta, 'nota Debito',
	i.nmro_idntfccn,
	i.nmro_unco_idntfccn,
	space(40),
	g.nmro_cntrto,
	h.dscrpcn_pln,
	(e.vlr_nta_cta + e.vlr_nta_iva)
from 	bdcarterapac.dbo.TbAbonosNotasContrato e,
     	bdcarterapac.dbo.tbnotascontrato f,
	bdafiliacion..tbContratos g,
	bdplanbeneficios.dbo.tbPlanes h,
	bdafiliacion.dbo.tbVinculados i,
	#tmpPago1 j
where   e.cnsctvo_nta_cntrto 		= 	f.cnsctvo_nta_cntrto
And	f.cnsctvo_cdgo_tpo_cntrto 	= 	g.cnsctvo_cdgo_tpo_cntrto
And	f.nmro_cntrto		  	= 	g.nmro_cntrto
And	g.cnsctvo_cdgo_pln	  	= 	h.cnsctvo_cdgo_pln
And	g.nmro_unco_idntfccn_afldo 	= 	i.nmro_unco_idntfccn
And	j.cnsctvo_cdgo_pgo		=	e.cnsctvo_cdgo_pgo

insert into #tmpTotalResul
Select  a.cnsctvo_cdgo_pgo,
	a.nmro_nta,
	'no aplica',
	'nota Debito',
	0,
	'no aplica',
	'no aplica',
	'no aplica',
	vlr
From	bdcarteraPac.dbo.tbpagosnotas a inner join  #tmpPago1  b
	on (a.cnsctvo_cdgo_pgo = b.cnsctvo_cdgo_pgo) inner join  #tmpNotas c
	on (a.nmro_nta = c.nmro_nta)
Where   a.cnsctvo_cdgo_tpo_nta =1

update #tmpTotalResul
set nmbre_cntrtnte=ltrim(rtrim(b.prmr_aplldo))+' '+ltrim(rtrim(b.sgndo_aplldo))+' '+ltrim(rtrim(b.prmr_nmbre))+' '+ltrim(rtrim(b.sgndo_nmbre))
from #tmpTotalResul a inner join bdAfiliacion.dbo.tbPersonas b
on a.nmro_unco_idntfccn=b.nmro_unco_idntfccn


select  a.cnsctvo_cdgo_pgo, 
        a.nmro_dcmto ,
	a.tpo_documento,
	a.nmro_idntfccn,
	a.nmbre_cntrtnte,
	a.nmro_cntrto ,
	a.dscrpcn_pln,
	a.valor_aplicado ,b.vlr_dcmnto
from #tmpTotalResul a inner join  bdcarterapac.dbo.tbpagos b
     on (a.cnsctvo_cdgo_pgo = b.cnsctvo_cdgo_pgo)	
order by a.nmbre_cntrtnte

