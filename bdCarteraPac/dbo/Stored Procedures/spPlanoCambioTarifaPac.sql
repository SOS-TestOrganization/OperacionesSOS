
/*---------------------------------------------------------------------------------
* Metodo o PRG 		:  spPlanoCambioTarifaPac
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento para generar el plano del ingenio Providencia				 	D\>
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
CREATE   PROCEDURE spPlanoCambioTarifaPac

--@cnsctvo_cdgo_estdo_lqdcn int out,
--@lcmensaje		  char(200) out  	 

As

Declare
@tbla			varchar(128),
@cdgo_cmpo 		varchar(128),
@oprdr 			varchar(2),
@vlr 			varchar(250),
@cmpo_rlcn 		varchar(128),
@cmpo_rlcn_prmtro 	varchar(128),
@cnsctvo		Numeric(4),
@IcInstruccion		Nvarchar(4000),
@IcInstruccion1		Nvarchar(4000),
@IcInstruccion2		Nvarchar(4000),
@lcAlias		char(2),
@lnContador		Int,
@ldFechaSistema		Datetime,
@nmro_lqdcn		INT,
@nmro_lqdcn_ini		int,
@nmro_lqdcn_fn		int,
@fechaInicial		datetime,
@fechaAnterior		datetime,
@lcmensaje		  char(200),
@cnsctvo_cdgo_estdo_lqdcn int 

	

Set Nocount On


Select	@ldFechaSistema	=	Getdate()

-- Contador de condiciones
Select @lnContador = 1
set	@nmro_lqdcn_ini	=	NULL
SET	@nmro_lqdcn_fn	=	NULL

Select 	@nmro_lqdcn_ini 	 =	vlr
From 	#tbCriteriosTmp
Where 	cdgo_cmpo 		 = 	'cnsctvo_cdgo_lqdcn' 	
and 	oprdr       		=  '>='

Select 	@nmro_lqdcn_fn 	 	=	vlr
From 	#tbCriteriosTmp
Where 	cdgo_cmpo 		= 	'cnsctvo_cdgo_lqdcn' 	
and 	oprdr       		=  '<='
	

create table #tmpCausas (cnsctvo_cdgo_csa int ,descrpcn_cdgo_csa varchar(50))
insert  into #tmpCausas values (1,  'EDAD DEL BENEFICIARIO')
insert  into #tmpCausas values (2,  'POS CON SOS')
insert  into #tmpCausas values (3,  'FECHA DE AFILIACION DEL BENEFICIARIO')
insert  into #tmpCausas values (4,  'CAMBIO EN EL PARENTESCO')
insert  into #tmpCausas values (5,  'CAMBIO TIPO DE AFILIADO')
insert  into #tmpCausas values (6,  'CAMBIO DISCAPACIDAD')
insert  into #tmpCausas values (7,  'CAMBIO ESTUDIANTE')
insert  into #tmpCausas values (8,  'CAMBIO HCU')
insert  into #tmpCausas values (9,  'CAMBIO AUTORIZADO SIN POS')
insert  into #tmpCausas values (10, 'CAMBIO GRUPO BASICO')


select @cnsctvo_cdgo_estdo_lqdcn =cnsctvo_cdgo_estdo_lqdcn from tbliquidaciones 
where cnsctvo_cdgo_lqdcn=@nmro_lqdcn_ini

if  @cnsctvo_cdgo_estdo_lqdcn = 4

	Begin 
		Set	@lcMensaje		=	'No existe un solo periodo con estado abierto para generar la liquidación'
		Return -1
	end	


Select  	@fechaInicial	=	b.fcha_incl_prdo_lqdcn 
From 	tbliquidaciones a, tbperiodosliquidacion_vigencias b
Where 	cnsctvo_cdgo_lqdcn 		=   @nmro_lqdcn_ini
And	a.cnsctvo_cdgo_estdo_lqdcn	=  3
And	a.cnsctvo_cdgo_prdo_lqdcn 	=   b.cnsctvo_cdgo_prdo_lqdcn



Select	@fechaAnterior	=	   DATEADD(month, -1, @fechaInicial) 


select  edd_bnfcro,
	ps_ss,
	fcha_aflcn_pc,
	cnsctvo_cdgo_prntsco,
	cnsctvo_cdgo_tpo_afldo,
	Dscpctdo,
	Estdnte,
	Antgdd_hcu,
	Atrzdo_sn_Ps,
	grpo_bsco,
	inco_vgnca_cntrto,
	grupo,
	cnsctvo_prdcto,
	cnsctvo_mdlo,
	cnsctvo_cdgo_tps_cbro,
	vlr_upc,
	vlr_rl_pgo,
	nmro_unco_idntfccn,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	cnsctvo_bnfcro,
	cnsctvo_cbrnza,
	nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte,
	a.cnsctvo_cdgo_lqdcn
into    #tmpActual
From	tbhistoricotarificacionxproceso	 a, Tbliquidaciones b
Where   a.cnsctvo_cdgo_lqdcn 		= b.cnsctvo_cdgo_lqdcn
And	b.cnsctvo_cdgo_estdo_lqdcn	= 3
And	vlr_rl_pgo 	  		> 0	
And	fcha_incl_prdo_lqdcn		= @fechaInicial
And	a.cnsctvo_cdgo_lqdcn		between convert(int,@nmro_lqdcn_ini) and convert(int,@nmro_lqdcn_fn)


select  edd_bnfcro,
	ps_ss,
	fcha_aflcn_pc,
	cnsctvo_cdgo_prntsco,
	cnsctvo_cdgo_tpo_afldo,
	Dscpctdo,
	Estdnte,
	Antgdd_hcu,
	Atrzdo_sn_Ps,
	grpo_bsco,
	inco_vgnca_cntrto,
	grupo,
	cnsctvo_cdgo_tps_cbro,
	cnsctvo_prdcto,
	cnsctvo_mdlo,
	vlr_upc,
	vlr_rl_pgo,
	nmro_unco_idntfccn,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	cnsctvo_bnfcro,
	cnsctvo_cbrnza,
	nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte,
	a.cnsctvo_cdgo_lqdcn
into    #tmpAnterior
From	tbhistoricotarificacionxproceso	 a, Tbliquidaciones b
Where   a.cnsctvo_cdgo_lqdcn 		= b.cnsctvo_cdgo_lqdcn
And 	b.cnsctvo_cdgo_estdo_lqdcn	= 3
And	vlr_rl_pgo 	  		> 0	
And	convert(char(10),fcha_incl_prdo_lqdcn,110)		= convert(char(10),@fechaAnterior,110)
--And	a.cnsctvo_cdgo_lqdcn		between convert(int,@nmro_lqdcn_ini) and convert(int,@nmro_lqdcn_fn)


select  a.*,  case when (a.edd_bnfcro = b.edd_bnfcro ) 				then 1 else 0 	end edd_bnfcro_aux ,
	      case when (a.ps_ss = b.ps_ss ) 					then 1 else 0	end ps_ss_aux ,
	      case when (a.fcha_aflcn_pc = b.fcha_aflcn_pc ) 			then 1 else 0	end fcha_aflcn_pc_aux ,
	      case when (a.cnsctvo_cdgo_prntsco = b.cnsctvo_cdgo_prntsco )	then 1 else 0 	end cnsctvo_cdgo_prntsco_aux ,
	      case when (a.cnsctvo_cdgo_tpo_afldo = b.cnsctvo_cdgo_tpo_afldo ) 	then 1 else 0	end cnsctvo_cdgo_tpo_afldo_aux ,
	      case when (a.Dscpctdo = b.Dscpctdo ) 				then 1 else 0	end Dscpctdo_aux ,
	      case when (a.Estdnte = b.Estdnte )				then 1 else 0	end Estdnte_aux ,
	      case when (a.Antgdd_hcu = b.Antgdd_hcu ) 				then 1 else 0	end Antgdd_hcu_aux ,
	      case when (a.Atrzdo_sn_Ps = b.Atrzdo_sn_Ps )			then 1 else 0	end Atrzdo_sn_Ps_aux ,
	      case when (a.grpo_bsco = b.grpo_bsco ) 				then 1 else 0	end grpo_bsco_aux ,
	      case when (a.inco_vgnca_cntrto = b.inco_vgnca_cntrto ) 		then 1 else 0	end inco_vgnca_cntrto_aux ,
	      case when (a.cnsctvo_cdgo_tps_cbro = b.cnsctvo_cdgo_tps_cbro ) 	then 1 else 0	end cnsctvo_cdgo_tps_cbro_aux ,
	      case when (a.grupo = b.grupo ) 					then 1 else 0	end grupo_aux ,
	      case when (a.cnsctvo_prdcto = b.cnsctvo_prdcto ) 			then 1 else 0	end cnsctvo_prdcto_aux,
	      case when (a.cnsctvo_mdlo = b.cnsctvo_mdlo ) 			then 1 else 0	end cnsctvo_mdlo_aux ,
	b.vlr_rl_pgo	vlr_real_anterior
into    #tmpResultado
from    #tmpactual a , #tmpanterior b
where   a.nmro_unco_idntfccn 	   	= b.nmro_unco_idntfccn
And	a.cnsctvo_cdgo_tpo_cntrto  	= b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto		   	= b.nmro_cntrto
And	a.cnsctvo_bnfcro	   	= b.cnsctvo_bnfcro
And	a.cnsctvo_cbrnza	   	= b.cnsctvo_cbrnza
And	a.nmro_unco_idntfccn_empldr	= b.nmro_unco_idntfccn_empldr
And	a.cnsctvo_scrsl		   	= b.cnsctvo_scrsl
And	a.cnsctvo_cdgo_clse_aprtnte	= b.cnsctvo_cdgo_clse_aprtnte 	
And	((a.vlr_rl_pgo		   	!=b.vlr_rl_pgo)
or	(a.vlr_upc         		!=b.vlr_upc))

/*
select count(*) from #tmpResultado where edd_bnfcro_aux = 0
select count(*) from #tmpResultado where ps_ss_aux = 0
select count(*) from #tmpResultado where fcha_aflcn_pc_aux = 0
select count(*) from #tmpResultado where cnsctvo_cdgo_prntsco_aux = 0
select count(*) from #tmpResultado where cnsctvo_cdgo_tpo_afldo_aux = 0
select count(*) from #tmpResultado where Dscpctdo_aux = 0
select count(*) from #tmpResultado where Estdnte_aux = 0
select count(*) from #tmpResultado where Antgdd_hcu_aux = 0
select count(*) from #tmpResultado where Atrzdo_sn_Ps_aux = 0
select count(*) from #tmpResultado where grpo_bsco_aux = 0
select count(*) from #tmpResultado where inco_vgnca_cntrto_aux = 0
select count(*) from #tmpResultado where grupo_aux = 0
select count(*) from #tmpResultado where cnsctvo_cdgo_tps_cbro = 0
select count(*) from #tmpResultado where cnsctvo_prdcto_aux = 0
select count(*) from #tmpResultado where cnsctvo_mdlo_aux = 0

*/

Select  edd_bnfcro,
	ps_ss,
	fcha_aflcn_pc,
	cnsctvo_cdgo_prntsco,
	cnsctvo_cdgo_tpo_afldo,
	Dscpctdo,
	Estdnte,
	Antgdd_hcu,
	Atrzdo_sn_Ps,
	grpo_bsco,
	inco_vgnca_cntrto,
	grupo,
	cnsctvo_cdgo_tps_cbro,
	cnsctvo_prdcto,
	cnsctvo_mdlo,
	vlr_upc,
	vlr_rl_pgo,
	vlr_real_anterior,
	nmro_unco_idntfccn,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	cnsctvo_bnfcro,
	cnsctvo_cbrnza,
	nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte,
	1	Causa,
	cnsctvo_cdgo_lqdcn
into	#tmpResultadoFinal
From 	#tmpResultado
Where   edd_bnfcro_aux = 0


insert into #tmpResultadoFinal
select  edd_bnfcro,
	ps_ss,
	fcha_aflcn_pc,
	cnsctvo_cdgo_prntsco,
	cnsctvo_cdgo_tpo_afldo,
	Dscpctdo,
	Estdnte,
	Antgdd_hcu,
	Atrzdo_sn_Ps,
	grpo_bsco,
	inco_vgnca_cntrto,
	grupo,
	cnsctvo_cdgo_tps_cbro,
	cnsctvo_prdcto,
	cnsctvo_mdlo,
	vlr_upc,
	vlr_rl_pgo,
	vlr_real_anterior,
	nmro_unco_idntfccn,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	cnsctvo_bnfcro,
	cnsctvo_cbrnza,
	nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte,
	2	Causa,
	cnsctvo_cdgo_lqdcn
From 	#tmpResultado
Where   ps_ss_aux = 0
/*
insert into #tmpResultadoFinal
select  edd_bnfcro,
	ps_ss,
	fcha_aflcn_pc,
	cnsctvo_cdgo_prntsco,
	cnsctvo_cdgo_tpo_afldo,
	Dscpctdo,
	Estdnte,
	Antgdd_hcu,
	Atrzdo_sn_Ps,
	grpo_bsco,
	inco_vgnca_cntrto,
	grupo,
	cnsctvo_cdgo_tps_cbro,
	cnsctvo_prdcto,
	cnsctvo_mdlo,
	vlr_upc,
	vlr_rl_pgo,
	vlr_real_anterior,
	nmro_unco_idntfccn,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	cnsctvo_bnfcro,
	cnsctvo_cbrnza,
	nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte,
	3	Causa,
	cnsctvo_cdgo_lqdcn
From 	#tmpResultado
Where   fcha_aflcn_pc_aux = 0
*/
insert into #tmpResultadoFinal
select  edd_bnfcro,
	ps_ss,
	fcha_aflcn_pc,
	cnsctvo_cdgo_prntsco,
	cnsctvo_cdgo_tpo_afldo,
	Dscpctdo,
	Estdnte,
	Antgdd_hcu,
	Atrzdo_sn_Ps,
	grpo_bsco,
	inco_vgnca_cntrto,
	grupo,
	cnsctvo_cdgo_tps_cbro,
	cnsctvo_prdcto,
	cnsctvo_mdlo,
	vlr_upc,
	vlr_rl_pgo,
	vlr_real_anterior,
	nmro_unco_idntfccn,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	cnsctvo_bnfcro,
	cnsctvo_cbrnza,
	nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte,
	4	Causa,
	cnsctvo_cdgo_lqdcn
From 	#tmpResultado
Where   cnsctvo_cdgo_prntsco_aux = 0

insert into #tmpResultadoFinal
select  edd_bnfcro,
	ps_ss,
	fcha_aflcn_pc,
	cnsctvo_cdgo_prntsco,
	cnsctvo_cdgo_tpo_afldo,
	Dscpctdo,
	Estdnte,
	Antgdd_hcu,
	Atrzdo_sn_Ps,
	grpo_bsco,
	inco_vgnca_cntrto,
	grupo,
	cnsctvo_cdgo_tps_cbro,
	cnsctvo_prdcto,
	cnsctvo_mdlo,
	vlr_upc,
	vlr_rl_pgo,
	vlr_real_anterior,
	nmro_unco_idntfccn,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	cnsctvo_bnfcro,
	cnsctvo_cbrnza,
	nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte,
	5 Causa,
	cnsctvo_cdgo_lqdcn
From 	#tmpResultado
Where   cnsctvo_cdgo_tpo_afldo_aux = 0

insert into #tmpResultadoFinal
select  edd_bnfcro,
	ps_ss,
	fcha_aflcn_pc,
	cnsctvo_cdgo_prntsco,
	cnsctvo_cdgo_tpo_afldo,
	Dscpctdo,
	Estdnte,
	Antgdd_hcu,
	Atrzdo_sn_Ps,
	grpo_bsco,
	inco_vgnca_cntrto,
	grupo,
	cnsctvo_cdgo_tps_cbro,
	cnsctvo_prdcto,
	cnsctvo_mdlo,
	vlr_upc,
	vlr_rl_pgo,
	vlr_real_anterior,
	nmro_unco_idntfccn,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	cnsctvo_bnfcro,
	cnsctvo_cbrnza,
	nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte,
	6 Causa,
	cnsctvo_cdgo_lqdcn
From 	#tmpResultado
Where   Dscpctdo_aux = 0

insert into #tmpResultadoFinal
select  edd_bnfcro,
	ps_ss,
	fcha_aflcn_pc,
	cnsctvo_cdgo_prntsco,
	cnsctvo_cdgo_tpo_afldo,
	Dscpctdo,
	Estdnte,
	Antgdd_hcu,
	Atrzdo_sn_Ps,
	grpo_bsco,
	inco_vgnca_cntrto,
	grupo,
	cnsctvo_cdgo_tps_cbro,
	cnsctvo_prdcto,
	cnsctvo_mdlo,
	vlr_upc,
	vlr_rl_pgo,
	vlr_real_anterior,
	nmro_unco_idntfccn,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	cnsctvo_bnfcro,
	cnsctvo_cbrnza,
	nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte,
	7 Causa,
	cnsctvo_cdgo_lqdcn
From 	#tmpResultado
Where   Estdnte_aux = 0


insert into #tmpResultadoFinal
select  edd_bnfcro,
	ps_ss,
	fcha_aflcn_pc,
	cnsctvo_cdgo_prntsco,
	cnsctvo_cdgo_tpo_afldo,
	Dscpctdo,
	Estdnte,
	Antgdd_hcu,
	Atrzdo_sn_Ps,
	grpo_bsco,
	inco_vgnca_cntrto,
	grupo,
	cnsctvo_cdgo_tps_cbro,
	cnsctvo_prdcto,
	cnsctvo_mdlo,
	vlr_upc,
	vlr_rl_pgo,
	vlr_real_anterior,
	nmro_unco_idntfccn,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	cnsctvo_bnfcro,
	cnsctvo_cbrnza,
	nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte,
	8 Causa,
	cnsctvo_cdgo_lqdcn
From 	#tmpResultado
Where   Antgdd_hcu_aux = 0


insert into #tmpResultadoFinal
select  edd_bnfcro,
	ps_ss,
	fcha_aflcn_pc,
	cnsctvo_cdgo_prntsco,
	cnsctvo_cdgo_tpo_afldo,
	Dscpctdo,
	Estdnte,
	Antgdd_hcu,
	Atrzdo_sn_Ps,
	grpo_bsco,
	inco_vgnca_cntrto,
	grupo,
	cnsctvo_cdgo_tps_cbro,
	cnsctvo_prdcto,
	cnsctvo_mdlo,
	vlr_upc,
	vlr_rl_pgo,
	vlr_real_anterior,
	nmro_unco_idntfccn,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	cnsctvo_bnfcro,
	cnsctvo_cbrnza,
	nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte,
	9 Causa,
	cnsctvo_cdgo_lqdcn
From 	#tmpResultado
Where   Atrzdo_sn_Ps_aux = 0

insert into #tmpResultadoFinal
select  edd_bnfcro,
	ps_ss,
	fcha_aflcn_pc,
	cnsctvo_cdgo_prntsco,
	cnsctvo_cdgo_tpo_afldo,
	Dscpctdo,
	Estdnte,
	Antgdd_hcu,
	Atrzdo_sn_Ps,
	grpo_bsco,
	inco_vgnca_cntrto,
	grupo,
	cnsctvo_cdgo_tps_cbro,
	cnsctvo_prdcto,
	cnsctvo_mdlo,
	vlr_upc,
	vlr_rl_pgo,
	vlr_real_anterior,
	nmro_unco_idntfccn,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	cnsctvo_bnfcro,
	cnsctvo_cbrnza,
	nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte,
	10 Causa,
	cnsctvo_cdgo_lqdcn
From 	#tmpResultado
Where   grpo_bsco_aux = 0



select  nmro_unco_idntfccn,
	cnsctvo_cdgo_tpo_cntrto,
	cnsctvo_bnfcro,
	cnsctvo_cbrnza,
	nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte,
	space(3)   Tpo_idntfccn_cntrtnte,
	space(15)  Nmro_idntfccn_cntrtnte,
	space(100) Nmbrs_apllds_cntrtnte,
	space(100) Drccn_cntrtnte,
	space(80)  Tlfno_cntrtnte,
	space(100) Cdd_cntrtnte,
	space(100) Dprtmnto_cntrtnte,
	0	   cnsctvo_cdgo_cdd_rsdnca_cntrtnte,
	0	   cnsctvo_cdgo_dprtmnto_cntrtnte,
	nmro_cntrto,
	space(3)   Tpo_idntfccn_bnfcro,
	space(15)  Nmro_idntfccn_bnfcro,
	space(100) Nmbrs_apllds_bnfcro,
	descrpcn_cdgo_csa,
	space(3)   Tpo_idntfccn_rspnsble_pgo,
	space(15)  Nmro_idntfccn_rspnsble_pgo,
	space(150) Nmbre_rspnsble_pgo,
	space(100) nmbre_Sde_vnta,
	space(100) nmbre_sde_crtra_pc, 
	space(100) Drccn_rspnsble_pgo,
	space(80)  Tlfno_rspnsble_pgo,
	space(100) Cdd_rspnsble_pgo,
	space(100) Dprtmnto_rspnsble_pgo,
	space(15)  Nmro_fctra,
	0	   Nmro_unco_idntfccn_afldo,
	0	   cnsctvo_cdgo_cdd_rsdnca_rspnsble_pgo,
	0	   cnsctvo_cdgo_dprtmnto_rspnsble_pgo,
	0	   sde_crtra_pc,
	0	   Sde_vnta,
	cnsctvo_cdgo_lqdcn,
	vlr_real_anterior,
	vlr_rl_pgo

into	#tmpBeneficiariosXcambioTarifa
From	#tmpResultadoFinal a, 	#tmpCausas b
Where   a.Causa = b.cnsctvo_cdgo_csa


Update #tmpBeneficiariosXcambioTarifa
Set	Nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn_afldo
From	#tmpBeneficiariosXcambioTarifa a, 	bdafiliacion..tbcontratos b
Where   a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto

--Actualiza informacion del cotizante
Update  #tmpBeneficiariosXcambioTarifa
Set	Tpo_idntfccn_cntrtnte		=	cdgo_tpo_idntfccn,
	Nmro_idntfccn_cntrtnte		=	nmro_idntfccn
From	#tmpBeneficiariosXcambioTarifa a, bdafiliacion..tbvinculados b,
	bdafiliacion..tbtiposidentificacion c
Where   a.Nmro_unco_idntfccn_afldo	=	b.Nmro_unco_idntfccn
And	b.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn

Update  #tmpBeneficiariosXcambioTarifa
Set	Nmbrs_apllds_cntrtnte			=	convert(varchar(100), ltrim(rtrim(prmr_nmbre)) + ' '  + ltrim(rtrim(sgndo_nmbre)) + ' ' +  ltrim(rtrim(prmr_aplldo)) + ' ' + ltrim(rtrim(sgndo_aplldo))),
	Drccn_cntrtnte				= 	drccn_rsdnca,
	Tlfno_cntrtnte				=	tlfno_rsdnca,
	cnsctvo_cdgo_cdd_rsdnca_cntrtnte	=	b.cnsctvo_cdgo_cdd_rsdnca
From	#tmpBeneficiariosXcambioTarifa a, 	bdafiliacion..tbPersonas b
Where 	a.nmro_unco_idntfccn_afldo		=	b.nmro_unco_idntfccn

--Actualiza la cuidad
Update  #tmpBeneficiariosXcambioTarifa
Set	Cdd_cntrtnte				=	b.dscrpcn_cdd,
	cnsctvo_cdgo_dprtmnto_cntrtnte		= 	b.cnsctvo_cdgo_dprtmnto
From	#tmpBeneficiariosXcambioTarifa a, 	bdafiliacion..tbciudades_vigencias b
Where 	a.cnsctvo_cdgo_cdd_rsdnca_cntrtnte	=	b.cnsctvo_cdgo_cdd

--Actualiza el departamento
Update  #tmpBeneficiariosXcambioTarifa
Set	Dprtmnto_cntrtnte			=	b.dscrpcn_dprtmnto
From	#tmpBeneficiariosXcambioTarifa a, 	bdafiliacion..tbdepartamentos_vigencias b
Where 	a.cnsctvo_cdgo_dprtmnto_cntrtnte	=	b.cnsctvo_cdgo_dprtmnto


--Actualiza informacion del beneficiario
Update  #tmpBeneficiariosXcambioTarifa
Set	Tpo_idntfccn_bnfcro		=	cdgo_tpo_idntfccn,
	Nmro_idntfccn_bnfcro		=	nmro_idntfccn
From	#tmpBeneficiariosXcambioTarifa a, bdafiliacion..tbvinculados b,
	bdafiliacion..tbtiposidentificacion c
Where   a.nmro_unco_idntfccn		=	b.Nmro_unco_idntfccn
And	b.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn



Update  #tmpBeneficiariosXcambioTarifa
Set	Nmbrs_apllds_bnfcro			=	convert(varchar(100), ltrim(rtrim(prmr_nmbre)) + ' '  + ltrim(rtrim(sgndo_nmbre)) + ' ' +  ltrim(rtrim(prmr_aplldo)) + ' ' + ltrim(rtrim(sgndo_aplldo))),
	cnsctvo_cdgo_cdd_rsdnca_cntrtnte	=	b.cnsctvo_cdgo_cdd_rsdnca
From	#tmpBeneficiariosXcambioTarifa a, 	bdafiliacion..tbPersonas b
Where 	a.nmro_unco_idntfccn			=	b.nmro_unco_idntfccn


--Actualiza informacion del Responsable del pago
Update  #tmpBeneficiariosXcambioTarifa
Set	Tpo_idntfccn_rspnsble_pgo		=	cdgo_tpo_idntfccn,
	Nmro_idntfccn_rspnsble_pgo		=	nmro_idntfccn
From	#tmpBeneficiariosXcambioTarifa a, bdafiliacion..tbvinculados b,
	bdafiliacion..tbtiposidentificacion c
Where   a.nmro_unco_idntfccn_empldr		=	b.Nmro_unco_idntfccn
And	b.cnsctvo_cdgo_tpo_idntfccn		=	c.cnsctvo_cdgo_tpo_idntfccn


Update  #tmpBeneficiariosXcambioTarifa
Set	Nmbre_rspnsble_pgo			=	b.nmbre_scrsl,
	Drccn_rspnsble_pgo			=	b.drccn,
	Tlfno_rspnsble_pgo			=	b.tlfno,
	cnsctvo_cdgo_cdd_rsdnca_rspnsble_pgo	=	b.cnsctvo_cdgo_cdd,
	sde_crtra_pc				=	b.sde_crtra_pc
From	#tmpBeneficiariosXcambioTarifa a, bdafiliacion..tbsucursalesaportante b
Where   a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn_empldr
And	a.cnsctvo_scrsl				=	b.cnsctvo_scrsl
And	a.cnsctvo_cdgo_clse_aprtnte		=	b.cnsctvo_cdgo_clse_aprtnte


--Actualiza la cuidad
Update  #tmpBeneficiariosXcambioTarifa
Set	Cdd_rspnsble_pgo			=	b.dscrpcn_cdd,
	cnsctvo_cdgo_dprtmnto_rspnsble_pgo	= 	b.cnsctvo_cdgo_dprtmnto
From	#tmpBeneficiariosXcambioTarifa a, 		bdafiliacion..tbciudades_vigencias b
Where 	a.cnsctvo_cdgo_cdd_rsdnca_rspnsble_pgo	=	b.cnsctvo_cdgo_cdd

--Actualiza el departamento
Update  #tmpBeneficiariosXcambioTarifa
Set	Dprtmnto_rspnsble_pgo			=	b.dscrpcn_dprtmnto
From	#tmpBeneficiariosXcambioTarifa a, 		bdafiliacion..tbdepartamentos_vigencias b
Where 	a.cnsctvo_cdgo_dprtmnto_rspnsble_pgo	=	b.cnsctvo_cdgo_dprtmnto

--Actualiza la sede Pac
Update  #tmpBeneficiariosXcambioTarifa
Set	nmbre_sde_crtra_pc			=	b.dscrpcn_sde,
	nmbre_Sde_vnta				=	b.dscrpcn_sde
From	#tmpBeneficiariosXcambioTarifa a, 		bdafiliacion..tbsedes b
Where 	a.sde_crtra_pc				=	b.cnsctvo_cdgo_sde

/*
---Se crea la consulta final  con todos los registros
create table #tmpArchivoBeneficiarios (informacion nvarchar(4000))
insert into #tmpArchivoBeneficiarios
Select	 (ltrim(rtrim(Tpo_idntfccn_cntrtnte))	 	+  char(124) +
	 ltrim(rtrim(Nmro_idntfccn_cntrtnte))	  	+  char(124) +
	 ltrim(rtrim(Nmbrs_apllds_cntrtnte))	  	+  char(124) +
	 ltrim(rtrim(Drccn_cntrtnte))		  	+  char(124) +
	 ltrim(rtrim(Tlfno_cntrtnte))	  		+  char(124) +
	 ltrim(rtrim(Cdd_cntrtnte))	  		+  char(124) +
	 ltrim(rtrim(Dprtmnto_cntrtnte))	  	+  char(124) +
	 ltrim(rtrim(nmro_cntrto))		  	+  char(124) +
	 ltrim(rtrim(Tpo_idntfccn_bnfcro))	  	+  char(124) +
	 ltrim(rtrim(Nmro_idntfccn_bnfcro))	  	+  char(124) +
	 ltrim(rtrim(Nmbrs_apllds_bnfcro))	  	+  char(124) +
	 ltrim(rtrim(descrpcn_cdgo_csa))	  	+  char(124) +
	 ltrim(rtrim(Tpo_idntfccn_rspnsble_pgo))  	+  char(124) +
	 ltrim(rtrim(Nmro_idntfccn_rspnsble_pgo))  	+  char(124) +
	 ltrim(rtrim(Nmbre_rspnsble_pgo))	  	+  char(124) +
	 ltrim(rtrim(nmbre_Sde_vnta))	  		+  char(124) +
	 ltrim(rtrim(nmbre_sde_crtra_pc))	  	+  char(124) +
	 ltrim(rtrim(Drccn_rspnsble_pgo))	  	+  char(124) +
	 ltrim(rtrim(Tlfno_rspnsble_pgo))	  	+  char(124) +
	 ltrim(rtrim(Cdd_rspnsble_pgo))	  		+  char(124) +
	 ltrim(rtrim(Dprtmnto_rspnsble_pgo))	  	+  char(124) +
	 ltrim(rtrim(Nmro_fctra))	) 
From	 #tmpBeneficiariosXcambioTarifa
*/

select 	cnsctvo_cdgo_lqdcn
into    #tmpliquidacionesFinal 
From	#tmpBeneficiariosXcambioTarifa
group by cnsctvo_cdgo_lqdcn


select  a.cnsctvo_estdo_cnta,b.nmro_estdo_cnta,cnsctvo_cdgo_tpo_cntrto , nmro_cntrto,d.cnsctvo_cdgo_lqdcn
into	#tmpFacturasXcontrato
from	#tmpliquidacionesFinal d , tbestadoscuenta b ,   tbestadoscuentacontratos a 
where   b.cnsctvo_estdo_cnta 		= 	a.cnsctvo_estdo_cnta
And	b.cnsctvo_cdgo_lqdcn		=	d.cnsctvo_cdgo_lqdcn


Update #tmpBeneficiariosXcambioTarifa
Set	Nmro_fctra	=	nmro_estdo_cnta
From	#tmpBeneficiariosXcambioTarifa a, #tmpFacturasXcontrato b
where   a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto
and	a.nmro_cntrto		  = b.nmro_cntrto	
And	a.cnsctvo_cdgo_lqdcn	  = b.cnsctvo_cdgo_lqdcn	

--delete from TbCausaBeneficiariosXCambioTarifa
--insert into TbCausaBeneficiariosXCambioTarifa
Select  
	Tpo_idntfccn_cntrtnte,
	Nmro_idntfccn_cntrtnte,
	Nmbrs_apllds_cntrtnte,
	Drccn_cntrtnte,
	Tlfno_cntrtnte,
	Cdd_cntrtnte,
	Dprtmnto_cntrtnte,
	nmro_cntrto,
	Tpo_idntfccn_bnfcro,
	Nmro_idntfccn_bnfcro,
	Nmbrs_apllds_bnfcro,
	descrpcn_cdgo_csa,
	Tpo_idntfccn_rspnsble_pgo,
	Nmro_idntfccn_rspnsble_pgo,
	Nmbre_rspnsble_pgo,
	nmbre_Sde_vnta,
	nmbre_sde_crtra_pc,
	Drccn_rspnsble_pgo,
	Tlfno_rspnsble_pgo,
	Cdd_rspnsble_pgo,
	Dprtmnto_rspnsble_pgo,
	Nmro_fctra,
	vlr_real_anterior,
	vlr_rl_pgo,
	cnsctvo_cdgo_lqdcn
From	 #tmpBeneficiariosXcambioTarifa
order by cnsctvo_cdgo_lqdcn

--Select  informacion from bdcarteraPac..TbCausaBeneficiariosXCambioTarifa

