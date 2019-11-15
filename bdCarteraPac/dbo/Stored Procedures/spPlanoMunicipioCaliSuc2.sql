/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spPlanoMunicipioCaliSuc2
* Desarrollado por		: <\A Ing. Fernando Valencia E									A\>
* Descripcion			: <\D Este procedimiento crea la informacion del archivo del municipio de Cali Suc 2  	D\>
* Observaciones		: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2006/09/19											FC\>
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
CREATE   PROCEDURE spPlanoMunicipioCaliSuc2

As

Declare
@tbla				varchar(128),
@cdgo_cmpo	 		varchar(128),
@oprdr 				varchar(2),
@vlr 				varchar(250),
@cmpo_rlcn 			varchar(128),
@cmpo_rlcn_prmtro 		varchar(128),
@cnsctvo			Numeric(4),
@ldfechaSistema		datetime,
@lcAlias			char(2),
@lnContador			Int,
@Nmro_estdo_cnta		Varchar(15),
@cntdd_rgstrs 			int,
@ano 				char(4),
@mes 				char(2),
@vlr_cbrdo			int 


Create table 	#Registros
(campo char(77))
 
Set Nocount On

Select 	@Nmro_estdo_cnta 	 =	vlr	
From 	#tbCriteriosTmp
Where 	cmpo_rlcn 	 = 	'nmro_estdo_cnta' 

Set	@ldfechaSistema	=	getdate()
	-- Contador de condiciones

Select 	identity(int,1,1) as cnsctvo, a.nmro_cntrto , a.cnsctvo_cdgo_tpo_cntrto , a.vlr_cbrdo , 0 nui,   space(15) NI, b.cts_cnclr, 0 ultmo_dia 
into	#tmpMunicpio
From 	tbestadoscuentacontratos a, tbestadoscuenta b
Where 	b.cnsctvo_estdo_cnta	= 	a.cnsctvo_estdo_cnta
and	b.nmro_estdo_cnta      = 	@Nmro_estdo_cnta
and 	b.cnsctvo_scrsl		=	2


Update  #tmpMunicpio
Set	nui	=	nmro_unco_idntfccn_afldo
From	#tmpMunicpio a, bdafiliacion..tbcontratos b
Where	a.nmro_cntrto = b.nmro_cntrto
And	a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto

Update  #tmpMunicpio
Set	NI	=	nmro_idntfccn
From	#tmpMunicpio a, bdafiliacion..tbvinculados b
Where	a.nui = b.nmro_unco_idntfccn



----------Para el encabezado------------------

select @ano =year(fcha_gnrcn) from tbestadoscuenta
where nmro_estdo_cnta=@Nmro_estdo_cnta

select  @mes= month(fcha_gnrcn) 
from tbestadoscuenta
where nmro_estdo_cnta=@Nmro_estdo_cnta
if len(@mes) = 1
	select @mes='0'+(@mes)

select @vlr_cbrdo=sum(vlr_cbrdo)   from  #tmpMunicpio
select @vlr_cbrdo=right(replicate('0',11)+ltrim(rtrim(@vlr_cbrdo)),11) 

select @cntdd_rgstrs=count(*)   from  #tmpMunicpio
select @cntdd_rgstrs=right(replicate('0',7)+ltrim(rtrim(@cntdd_rgstrs)),7) 

update #tmpMunicpio  SET ultmo_dia = bdAfiliacion.dbo.fnCalculaUltimoDiaMes(@mes,@ano)

insert into #Registros (campo)
Select   '001545'+'008050011572'+'SERVICIO OCCIDENTAL DE SALUD PREPAG'+@ano+@mes+ right(replicate('0',11)+ltrim(rtrim(@vlr_cbrdo)),11)+right(replicate('0',7)+ltrim(rtrim(@cntdd_rgstrs)),7)  

---Para el detalle
insert into #Registros (campo)
select right(replicate('0',10)+ltrim(rtrim(cnsctvo)),10)+ right(replicate('0',12)+ltrim(rtrim(ni)),12)+'000001' +right(replicate('0',12)+ltrim(rtrim(vlr_cbrdo)),12)+ltrim(rtrim(ultmo_dia))+@mes+@ano+right(replicate('0',3)+ltrim(rtrim(cts_cnclr)),3) from #tmpMunicpio

select campo from #Registros

