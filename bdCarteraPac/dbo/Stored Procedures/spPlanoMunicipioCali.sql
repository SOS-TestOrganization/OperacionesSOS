/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spPlanoMunicipioCali
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento crea la informacion del archivo del municipio  	D\>
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
CREATE   PROCEDURE spPlanoMunicipioCali

As

Declare
@tbla				varchar(128),
@cdgo_cmpo	 		varchar(128),
@oprdr 				varchar(2),
@vlr 				varchar(250),
@cmpo_rlcn 			varchar(128),
@cmpo_rlcn_prmtro 		varchar(128),
@cnsctvo			Numeric(4),
@IcInstruccion			Nvarchar(4000),
@IcInstruccion1			Nvarchar(4000),
@IcInstruccion2			Nvarchar(4000),
@ldfechaSistema		datetime,
@lcAlias			char(2),
@lnContador			Int,
@Nmro_estdo_cnta		Varchar(15)


Set Nocount On

Select 	@Nmro_estdo_cnta 	 =	vlr	
From 	#tbCriteriosTmp
Where 	cmpo_rlcn 	 = 	'nmro_estdo_cnta' 

Set	@ldfechaSistema	=	getdate()
	-- Contador de condiciones

	
Select 	a.nmro_cntrto , a.cnsctvo_cdgo_tpo_cntrto , a.vlr_cbrdo , 0 nui, space(15) NI
into	#tmpMunicpio
From 	tbestadoscuentacontratos a, tbestadoscuenta b
Where 	b.cnsctvo_estdo_cnta = a.cnsctvo_estdo_cnta
and	b.nmro_estdo_cnta      = @Nmro_estdo_cnta


Update  #tmpMunicpio
Set	nui	=	nmro_unco_idntfccn_afldo
From	#tmpMunicpio a, bdafiliacion..tbcontratos b
Where	a.nmro_cntrto = b.nmro_cntrto
And	a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto

Update  #tmpMunicpio
Set	NI	=	nmro_idntfccn
From	#tmpMunicpio a, bdafiliacion..tbvinculados b
Where	a.nui = b.nmro_unco_idntfccn


Select  NI ,603 codigo , sum(convert(int,vlr_cbrdo))  vlr_cbrdo
From #tmpMunicpio
Group by NI
Order by NI