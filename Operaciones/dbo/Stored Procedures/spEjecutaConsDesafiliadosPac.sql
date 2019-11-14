


/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spEjecutaConsDesafiliadosPac
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
* Modificado Por			: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  FM\>
*---------------------------------------------------------------------------------*/
CREATE   PROCEDURE spEjecutaConsDesafiliadosPac


As

Declare
@tbla					varchar(128),
@cdgo_cmpo 				varchar(128),
@oprdr 					varchar(2),
@vlr 					varchar(250),
@cmpo_rlcn 				varchar(128),
@cmpo_rlcn_prmtro 			varchar(128),
@cnsctvo				Numeric(4),
@IcInstruccion				Nvarchar(4000),
@IcInstruccion1				Nvarchar(4000),
@IcInstruccion2				Nvarchar(4000),
@lcAlias				char(2),
@lnContador				Int,
@ldFechaSistema			Datetime,
@Fecha_Corte				Datetime,
@Fecha_Caracter			varchar(15),
@lnValorIva				numeric(12,2),
@cnsctvo_cdgo_sde  			int,
@cdgo_tpo_idntfccn	  		char(5),
@nmro_idntfccn				char(20),
@cnsctvo_cdgo_pln			int,
@Fcha_crcn_ini				datetime,
@Fcha_crcn_fnl				datetime

Set Nocount On

Select	@ldFechaSistema	=	Getdate()
--Se cruzan los contratos asociados a las sucursales y se traer las sucursales finales para liquidar
Set	@Fcha_crcn_ini  			=	 NULL
Set	@Fcha_crcn_fnl  			=	 NULL
Set	@cnsctvo_cdgo_pln 			=	 NULL
Set	@cdgo_tpo_idntfccn 			=	 NULL
Set	@nmro_idntfccn		  		=	 NULL
Set	@cnsctvo_cdgo_sde 			=	 NULL


Select 	@cnsctvo_cdgo_pln	 =	vlr	
From 	#tbCriteriosTmp
Where 	cdgo_cmpo 		 = 	'cnsctvo_cdgo_pln' 

Select 	@cnsctvo_cdgo_sde 	 =	vlr	
From 	#tbCriteriosTmp
Where 	cdgo_cmpo 		 = 	'cnsctvo_cdgo_sde' 

Select 	@Fcha_crcn_ini 	=	vlr	+' 00:00:00' 
From 	#tbCriteriosTmp
Where 	cmpo_rlcn 		= 	'Fcha_crcn' 
And	oprdr	    		= 	'>='

Select 	@Fcha_crcn_fnl 	=	vlr	+' 23:59:59' 
From 	#tbCriteriosTmp
Where 	cmpo_rlcn 		= 	'Fcha_crcn' 
And	oprdr	    		= 	'<='
 
Select 	@cdgo_tpo_idntfccn	 =	vlr	
From 	#tbCriteriosTmp
Where 	cdgo_cmpo 		 = 	'cdgo_tpo_idntfccn' 

Select 	@cdgo_tpo_idntfccn	 =	vlr	
From 	#tbCriteriosTmp
Where 	cdgo_cmpo 		 = 	'cdgo_tpo_idntfccn' 

Select 	@nmro_idntfccn		 =	vlr	
From 	#tbCriteriosTmp
Where 	cdgo_cmpo 		 = 	'nmro_idntfccn' 

-- Contador de condiciones
Select @lnContador = 1

select  a.nmro_cntrto,
	a.cnsctvo_cdgo_tpo_cntrto,
	b.nmro_unco_idntfccn_afldo,
	a.nmro_unco_idntfccn_empldr,
	a.cnsctvo_scrsl,
	a.cnsctvo_cdgo_clse_aprtnte,
	a.fcha_nvdd,
	a.estdo,
	a.dsfldo,
	c.fcha_crcn,
	E.cnsctvo_cdgo_pln,
	E.cdgo_pln,
	E.dscrpcn_pln,
	f.nmbre_scrsl,
	f.drccn,
	f.tlfno,
	cdgo_tpo_idntfccn	TI_Empresa,
	nmro_idntfccn 		NI_Empresa,
	dscrpcn_clse_aprtnte,
	space(4) 	Ti_afldo,
	space(15)	Ni_afldo,
	space(200)	nmbre_fldo,
		se.dscrpcn_sde ,
		0 as vlr_mra,
		0 as vlr_pgs,
		0 as vlr_nvdds
into	#tmpContratosDesafiliadosPac
from 	TbcontratosdesafiliadosXmoraPac 	a,
	bdafiliacion..Tbcontratos 		b,
     	bdcarteraPac.dbo.tbliquidaciones 	c,
	bdafiliacion..tbclasesaportantes	d,
	bdplanbeneficios.dbo.tbplanes		E,
	bdafiliacion.Dbo.tbsucursalesaportante	F,
	bdafiliacion.dbo.tbtiposidentificacion  g,
	bdafiliacion.dbo.tbVinculados		h,
	bdafiliacion.dbo.tbsedes			se
Where   a.nmro_cntrto			= 	b.nmro_cntrto
And	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.cnsctvo_cdgo_lqdcn		=	c.cnsctvo_cdgo_lqdcn
And	b.cnsctvo_cdgo_pln		=	E.cnsctvo_cdgo_pln
And	c.cnsctvo_cdgo_estdo_lqdcn	=	3
And	a.nmro_unco_idntfccn_empldr	=	f.nmro_unco_idntfccn_empldr
And	a.cnsctvo_scrsl			=	f.cnsctvo_scrsl
And	a.cnsctvo_cdgo_clse_aprtnte	=	f.cnsctvo_cdgo_clse_aprtnte
And	a.nmro_unco_idntfccn_empldr	=	h.nmro_unco_idntfccn
And	h.cnsctvo_cdgo_tpo_idntfccn	=	g.cnsctvo_cdgo_tpo_idntfccn
And	a.cnsctvo_cdgo_clse_aprtnte	=	D.cnsctvo_cdgo_clse_aprtnte
And	se.cnsctvo_cdgo_sde		=	f.sde_crtra_pc
And	(@cnsctvo_cdgo_sde is null or  (@cnsctvo_cdgo_sde is not null and f.sde_crtra_pc = @cnsctvo_cdgo_sde))
And	(@cnsctvo_cdgo_pln is null  or  (@cnsctvo_cdgo_pln is not null and E.cnsctvo_cdgo_pln = @cnsctvo_cdgo_pln))
And	(@cdgo_tpo_idntfccn is null  or  (@cdgo_tpo_idntfccn is not null and g.cdgo_tpo_idntfccn = @cdgo_tpo_idntfccn))
And	(@nmro_idntfccn is null  	     or  (@nmro_idntfccn is not null and h.nmro_idntfccn = @nmro_idntfccn))
And   	(@Fcha_crcn_ini is null or 	(@Fcha_crcn_ini is not null and c.fcha_crcn between @Fcha_crcn_ini and @Fcha_crcn_fnl))
		 
Update #tmpContratosDesafiliadosPac
Set	Ti_afldo				=	cdgo_tpo_idntfccn,
	Ni_afldo			=	nmro_idntfccn
From	#tmpContratosDesafiliadosPac a, 	bdafiliacion.dbo.tbtiposidentificacion  g,
	bdafiliacion.dbo.tbVinculados		h
where 	a.nmro_unco_idntfccn_afldo	=	h.nmro_unco_idntfccn
And	h.cnsctvo_cdgo_tpo_idntfccn	=	g.cnsctvo_cdgo_tpo_idntfccn

Update #tmpContratosDesafiliadosPac
Set	nmbre_fldo	=	convert(varchar(50),ltrim(rtrim(prmr_aplldo)) + ' ' + ltrim(rtrim(sgndo_aplldo)) + ' ' + ltrim(rtrim(prmr_nmbre)) + ' '  + ltrim(rtrim(sgndo_nmbre)))
From	#tmpContratosDesafiliadosPac a, bdafiliacion..tbPersonas b
Where 	a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn

-- Se suma el saldo d elos estados de cuenta
update cd
set cd.vlr_mra = e.vlr
from  #tmpContratosDesafiliadosPac  cd inner join (	Select  sum(i.sldo) vlr, i.nmro_cntrto 
																																											From    tbestadosCuenta a
																																											inner join tbliquidaciones l
																																											on  a.cnsctvo_cdgo_lqdcn		=	l.cnsctvo_cdgo_lqdcn
																																											inner join  tbperiodosliquidacion_vigencias p
																																											on 	l.cnsctvo_cdgo_prdo_lqdcn	=	p.cnsctvo_cdgo_prdo_lqdcn
																																											inner join 	tbestadoscuentaContratos i
																																											on a.cnsctvo_estdo_cnta		=	i.cnsctvo_estdo_cnta
																																											Where	i.Nmro_cntrto		 in (select ltrim(rtrim(nmro_cntrto)) as nmro_cntrto from  #tmpContratosDesafiliadosPac group by nmro_cntrto)   
																																											And	i.cnsctvo_cdgo_tpo_cntrto	=	2
																																											And	i.sldo	!=	0
																																											And	a.cnsctvo_estdo_cnta		>   	0
																																											And	l.cnsctvo_cdgo_estdo_lqdcn	=	3   --Finalizada..
																																											And	a.cnsctvo_cdgo_estdo_estdo_cnta	<>	4	
																																											group by   i.nmro_cntrto 	) e
on cd.nmro_cntrto = e.nmro_cntrto																							

--- Se  suma el saldo de las notas debito
update cd
set cd.vlr_mra = cd.vlr_mra + e.vlr
from  #tmpContratosDesafiliadosPac  cd inner join (Select  sum(sldo_nta_cntrto) vlr , nmro_cntrto
																																									from	tbNotasPac a
																																									inner join  TbestadosNota b
																																									on 	a.cnsctvo_cdgo_estdo_nta	=	b.cnsctvo_cdgo_estdo_nta
																																									inner join 	tbnotascontrato d
																																									on 	a.cnsctvo_cdgo_tpo_nta		=	d.cnsctvo_cdgo_tpo_nta
																																									And	a.nmro_nta			=	d.nmro_nta
																																									Where  	d.nmro_cntrto	 in (select ltrim(rtrim(nmro_cntrto)) as nmro_cntrto from  #tmpContratosDesafiliadosPac group by nmro_cntrto)   
																																									And	d.cnsctvo_cdgo_tpo_cntrto	=	2
																																									and	a.cnsctvo_cdgo_tpo_nta		=	1	--notas debito
																																									And	sldo_nta_cntrto				!=	0
																																									And	a.cnsctvo_cdgo_estdo_nta	<>	6	--Anulada
																																									group by nmro_cntrto	) e
on cd.nmro_cntrto = e.nmro_cntrto	


---- Se suma el valor de los pagos aplicados al contrato a partir del dia 12 del periodo , el periodo se extrae de la fecha inicial digitada por el usuario 
update cd
set cd.vlr_pgs = cd.vlr_pgs + e.vlr
from  #tmpContratosDesafiliadosPac  cd inner join
(select sum(abc.vlr_abno_cta + abc.vlr_abno_iva) vlr, det.nmro_cntrto  from dbo.tbAbonosContrato abc
inner join dbo.tbPagos p
on abc.cnsctvo_cdgo_pgo = p.cnsctvo_cdgo_pgo
inner join  (Select   i.cnsctvo_estdo_cnta_cntrto, i.nmro_cntrto
																																											From    tbestadosCuenta a
																																											inner join tbliquidaciones l
																																											on  a.cnsctvo_cdgo_lqdcn		=	l.cnsctvo_cdgo_lqdcn
																																											inner join  tbperiodosliquidacion_vigencias p
																																											on 	l.cnsctvo_cdgo_prdo_lqdcn	=	p.cnsctvo_cdgo_prdo_lqdcn
																																											inner join 	tbestadoscuentaContratos i
																																											on a.cnsctvo_estdo_cnta		=	i.cnsctvo_estdo_cnta
																																											Where	i.Nmro_cntrto  in (select ltrim(rtrim(nmro_cntrto)) as nmro_cntrto from  #tmpContratosDesafiliadosPac group by nmro_cntrto)   
																																											And	i.cnsctvo_cdgo_tpo_cntrto	=	2
																																											And	a.cnsctvo_estdo_cnta		>   	0
																																											And	l.cnsctvo_cdgo_estdo_lqdcn	=	3   --Finalizada..
																																											And	a.cnsctvo_cdgo_estdo_estdo_cnta	<>	4	
																																											group by   i.cnsctvo_estdo_cnta_cntrto, i.nmro_cntrto) det
on abc.cnsctvo_estdo_cnta_cntrto = det.cnsctvo_estdo_cnta_cntrto
where  p.fcha_aplccn > = (select bdrecaudos.dbo.fnConviertePeriodoFecha(bdrecaudos.dbo.fnCalculaPeriodo(@Fcha_crcn_ini),12))
group by det.nmro_cntrto) e
on cd.nmro_cntrto = e.nmro_cntrto																															


update cd
set cd.vlr_pgs = cd.vlr_pgs + e.vlr
from  #tmpContratosDesafiliadosPac  cd inner join
(select sum(anc.vlr_nta_cta + anc.vlr_nta_iva) vlr, det.nmro_cntrto
from dbo.TbAbonosNotasContrato anc
inner join dbo.tbPagos p
on anc.cnsctvo_cdgo_pgo = p.cnsctvo_cdgo_pgo
inner join (Select  d.cnsctvo_nta_cntrto , nmro_cntrto
																																									from	tbNotasPac a
																																									inner join  TbestadosNota b
																																									on 	a.cnsctvo_cdgo_estdo_nta	=	b.cnsctvo_cdgo_estdo_nta
																																									inner join 	tbnotascontrato d
																																									on 	a.cnsctvo_cdgo_tpo_nta		=	d.cnsctvo_cdgo_tpo_nta
																																									And	a.nmro_nta			=	d.nmro_nta
																																									Where  	d.nmro_cntrto in (select ltrim(rtrim(nmro_cntrto)) as nmro_cntrto from  #tmpContratosDesafiliadosPac group by nmro_cntrto)   
																																									And	d.cnsctvo_cdgo_tpo_cntrto	=	2
																																									and	a.cnsctvo_cdgo_tpo_nta		=	1	--notas debito
																																									And	a.cnsctvo_cdgo_estdo_nta	<>	6	--Anulada
																																									group by  d.cnsctvo_nta_cntrto, nmro_cntrto) det

on anc.cnsctvo_nta_cntrto = det.cnsctvo_nta_cntrto
where  p.fcha_aplccn > = (select bdrecaudos.dbo.fnConviertePeriodoFecha(bdrecaudos.dbo.fnCalculaPeriodo(@Fcha_crcn_ini),12))
group by det.nmro_cntrto )e
on cd.nmro_cntrto = e.nmro_cntrto																															



update cd
set cd.vlr_nvdds = cd.vlr_nvdds + e.vlr
from  #tmpContratosDesafiliadosPac  cd inner join (Select  sum(nc.vlr + nc.vlr_iva) vlr , nc.nmro_cntrto
																																									 from dbo.tbNotasPac np
																																									 inner join dbo.tbNotasContrato nc
																																									 on np.nmro_nta = nc.nmro_nta
																																									 and np.cnsctvo_cdgo_tpo_nta = nc.cnsctvo_cdgo_tpo_nta																													 
																																									Where  np.fcha_crcn_nta > = (select bdrecaudos.dbo.fnConviertePeriodoFecha(bdrecaudos.dbo.fnCalculaPeriodo(@Fcha_crcn_ini),12))
																																									and nc.nmro_cntrto in (select ltrim(rtrim(nmro_cntrto)) as nmro_cntrto from  #tmpContratosDesafiliadosPac group by nmro_cntrto)   
																																							  	and nc.cnsctvo_cdgo_tpo_cntrto = 2
																																									and np.cnsctvo_cdgo_tpo_nta = 2
																													                        and	np.cnsctvo_cdgo_estdo_nta	<>	6	--Anulada
																																									group by nmro_cntrto	) e
on cd.nmro_cntrto = e.nmro_cntrto				

---- Se suma el valor de las notas credito (que en cartera llaman novedades) aplicadas, al contrato a partir del dia 12 del periodo , el periodo se extrae de la fecha inicial digitada por el usuario 

Select  
vlr_mra as Valor_Mora,
vlr_pgs as Valor_Pagos,
vlr_nvdds  as Valor_Novedades,
dscrpcn_sde as Sede, 
ti_empresa as Tipo_Id_Empleador,
ni_empresa as Nro_Empleador,
nmbre_scrsl as Nombre_Empleador,
cnsctvo_scrsl as Suc,
dscrpcn_clse_aprtnte as Clase_Aportante,
drccn as Direccion_Empleador,
tlfno as Tel_Empleador ,
ti_afldo as Tipo,
ni_afldo as Nmro_Contratante,
nmbre_fldo as Nombre_Contratante,
nmro_cntrto as Nro_Contrato,
dscrpcn_pln as [Plan]
from #tmpContratosDesafiliadosPac 
order by  NI_Empresa
