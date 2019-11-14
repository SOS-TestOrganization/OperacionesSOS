

/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spEjecutaConsCarteraJuridicoPac
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento arma y ejecuta la cadena donde se tiene los criterios para seleccionar los pagos  	D\>
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
CREATE   PROCEDURE spEjecutaConsCarteraJuridicoPac

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
@fcha_ini			Datetime,
@fcha_fn			Datetime


Set Nocount On

Select 	@fcha_ini 	 =	vlr	+' 00:00:00' 
From 	#tbCriteriosTmp
Where 	cdgo_cmpo 	 = 	'fcha_crcn' 
And	oprdr	   	 = 	'>='


Select @fcha_fn 	=	vlr	+' 23:59:59' 
From #tbCriteriosTmp
Where 	cdgo_cmpo 		= 	'fcha_crcn' 
And	oprdr	    		= 	'<='




Select  a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte,
	a.nmro_estdo_cnta,
	c.sldo,
	c.nmro_cntrto,
	c.cnsctvo_cdgo_tpo_cntrto,
	Space(20)	nmro_idntfccn_ctznte,
	Space(10)	tpo_idntfccn_ctznte,
	Space(100)	nmbre_ctznte,
	Space(30)	dscrpcn_pln,
	Space(100)	drccn_ctznte,
	Space(50)	tlfno_ctznte,
	Space(20)	nmro_idntfccn_emlpdr,
	Space(10)	tpo_idntfccn_emlpdr,
	Space(100)	nmbre_emlpdr,
	Space(100)	drccn_emlpdr,
	Space(50)	tlfno_emlpdr,
	 0 	nmro_unco_idntfccn_afldo,
	 0 	cnsctvo_cdgo_tpo_idntfccn_afldo,
	 0 	cnsctvo_cdgo_tpo_idntfccn_empldr,
	0	sde_pac,
	space(100) 	nombre_sede_pac
into    #tmpEstadosCuentaContratos   
From    bdcarteraPac.dbo.TbEstadosCuenta a,
	bdcarteraPac.dbo.tbliquidaciones b ,
	bdcarteraPac.dbo.tbEstadosCuentaContratos c ,
	bdcarteraPac.dbo.tbperiodosliquidacion_vigencias  d,
	bdafiliacion.dbo.tbSucursalesAportante  e
where   c.sldo	 					> 	0
And	a.cnsctvo_cdgo_lqdcn				=	b.cnsctvo_cdgo_lqdcn
And	a.cnsctvo_estdo_cnta				=	c.cnsctvo_estdo_cnta
And	b.cnsctvo_cdgo_prdo_lqdcn			=	d.cnsctvo_cdgo_prdo_lqdcn	
And	b.cnsctvo_cdgo_estdo_lqdcn			=	3	
And	e.cnsctvo_cdgo_clse_aprtnte			=	a.cnsctvo_cdgo_clse_aprtnte
And	e.nmro_unco_idntfccn_empldr			=	a.nmro_unco_idntfccn_empldr
And	e.cnsctvo_scrsl					=	a.cnsctvo_scrsl
and	e.prmtr_crtra_pc				=	12
And	(datediff(dd,@fcha_ini,d.fcha_incl_prdo_lqdcn)>=0  And datediff(dd,d.fcha_incl_prdo_lqdcn,@fcha_fn)>=0)

--and	e.prmtr_crtra_pc				=	12  abogado
--And	b.cnsctvo_cdgo_estdo_lqdcn			=	3	--Finalizada


Update #tmpEstadosCuentaContratos
Set	nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn_afldo
From	#tmpEstadosCuentaContratos a, bdafiliacion..tbcontratos b
where   a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto		=	b.nmro_cntrto




Update	#tmpEstadosCuentaContratos
Set	nmro_idntfccn_ctznte		=	ltrim(rtrim(b.nmro_idntfccn)),
	cnsctvo_cdgo_tpo_idntfccn_afldo	=	b.cnsctvo_cdgo_tpo_idntfccn
From	#tmpEstadosCuentaContratos  a,  	bdafiliacion..tbvinculados  b
Where   a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn



Update	#tmpEstadosCuentaContratos
Set	tpo_idntfccn_ctznte		 =	ltrim(rtrim(b.cdgo_tpo_idntfccn))
From	#tmpEstadosCuentaContratos  a,  	bdafiliacion..tbtiposidentificacion  b
Where   a.cnsctvo_cdgo_tpo_idntfccn_afldo=	b.cnsctvo_cdgo_tpo_idntfccn



Update	#tmpEstadosCuentaContratos
Set	nmbre_ctznte		=	ltrim(rtrim(prmr_nmbre)) +  ' ' + ltrim(rtrim(sgndo_nmbre)) + ' ' + ltrim(rtrim(prmr_aplldo)) + ' '  + ltrim(rtrim(sgndo_aplldo)),
	drccn_ctznte		=	drccn_rsdnca,
	tlfno_ctznte		=	tlfno_rsdnca
From	#tmpEstadosCuentaContratos  a,  	bdafiliacion..tbpersonas  b
Where   a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn


Update	#tmpEstadosCuentaContratos
Set	nmro_idntfccn_emlpdr		=	ltrim(rtrim(b.nmro_idntfccn)),
	cnsctvo_cdgo_tpo_idntfccn_empldr=	b.cnsctvo_cdgo_tpo_idntfccn
From	#tmpEstadosCuentaContratos  a,  	bdafiliacion..tbvinculados  b
Where   a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn



Update	#tmpEstadosCuentaContratos
Set	tpo_idntfccn_emlpdr		=	ltrim(rtrim(b.cdgo_tpo_idntfccn))
From	#tmpEstadosCuentaContratos  a,  	bdafiliacion..tbtiposidentificacion  b
Where   a.cnsctvo_cdgo_tpo_idntfccn_empldr	=	b.cnsctvo_cdgo_tpo_idntfccn



Update	#tmpEstadosCuentaContratos
Set	nmbre_emlpdr		     =	b.nmbre_scrsl,
	drccn_emlpdr		     =	b.drccn,
	tlfno_emlpdr		     =	b.tlfno,
	sde_pac			     = 	b.sde_crtra_pc
From	#tmpEstadosCuentaContratos  a,  	 bdafiliacion..tbsucursalesaportante  b
Where   a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
and	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte



Update	#tmpEstadosCuentaContratos
Set	nombre_sede_pac		=	b.dscrpcn_sde
From	#tmpEstadosCuentaContratos  a,  	 bdafiliacion..tbsedes b
Where   a.sde_pac	=	b.cnsctvo_cdgo_sde


Select  tpo_idntfccn_emlpdr TI_empleador,
	nmro_idntfccn_emlpdr Ni_empleador,
	nmbre_emlpdr nombre_empleador,
	cnsctvo_scrsl sucursal ,
	drccn_emlpdr direccion_empleador,
	tlfno_emlpdr telefono_empleador,		
	tpo_idntfccn_ctznte ti_cotizante,
	nmro_idntfccn_ctznte ni_cotizante,
	nmbre_ctznte nombre_cotizante,
	drccn_ctznte direccion_cotizante,
	tlfno_ctznte telefono_cotizante,
	nmro_estdo_cnta numero_estdo_cnta,
	sldo		saldo,
	nmro_cntrto     contrato
From  	#tmpEstadosCuentaContratos 
order by nmro_idntfccn_ctznte