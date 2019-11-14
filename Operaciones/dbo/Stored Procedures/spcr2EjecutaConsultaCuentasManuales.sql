
/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spcr2EjecutaConsultaCuentasManuales
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento arma y ejecuta la cadena donde se tiene los criterios para seleccionar los promotoresr 	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003/02/10											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  Rolando Simbaqueva Lasso AM\>
* Descripcion			: <\DM  Aplicacion tecnicas de optimizacion DM\>
* Nuevos Parametros		: <\PM  Usuario de creacion PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  2005 / 08 / 25 FM\>
*---------------------------------------------------------------------------------*/
CREATE  PROCEDURE spcr2EjecutaConsultaCuentasManuales
			@usro_crcn  varchar(30)

As 

Set Nocount On

create table #tmpEstadosCuenta
 ( nmro_estdo_cnta varchar(15),  cdgo_tpo_idntfccn varchar(3), nmro_idntfccn_rspnsble_pgo varchar(20),
   dscrpcn_clse_aprtnte varchar(50), nmbre_scrsl varchar(150) , nmbre_empldr varchar(200),
   ttl_fctrdo numeric(12,0),  dscrpcn_estdo_estdo_cnta varchar(50), fcha_incl_fctrcn datetime,
   fcha_fnl_fctrcn datetime, 	fcha_crcn_hra varchar(20), usro_crcn varchar(30),
   accn varchar(50) ,  fcha_lmte_pgo datetime , nmro_unco_idntfccn_empldr int,
   cnsctvo_scrsl int,  cnsctvo_cdgo_clse_aprtnte int,  cnsctvo_cdgo_tpo_idntfccn int,
   dgto_vrfccn int, cts_cnclr int, drccn varchar(100) , cnsctvo_cdgo_cdd int,
   tlfno varchar(20),	 vlr_iva numeric(12,0) , sldo_fvr numeric(12,0),
   ttl_pgr numeric(12,0) , fcha_crcn datetime, cnsctvo_cdgo_prdo int,
   cnsctvo_cdgo_autrzdr_espcl int, prcntje_incrmnto numeric (12,3),
   cnsctvo_cdgo_prdo_lqdcn int, cnsctvo_cdgo_estdo_estdo_cnta int,
   dscrpcn_tpo_idntfccn varchar(50), cdgo_clse_aprtnte varchar(2),
   cdgo_prdo varchar(2), dscrpcn_prdo varchar(60),
   cdgo_prdo_lqdcn varchar(4) , dscrpcn_prdo_lqdcn varchar(60),
   cdgo_estdo_estdo_cnta varchar(2),
   Usro_atrzdr  varchar(200),
   cdgo_autrzdr_espcl varchar(30),
   exste_cntrto  varchar(1))

insert into  #tmpEstadosCuenta
Select  a.nmro_estdo_cnta,
	'',
	a.nmro_idntfccn_rspnsble_pgo ,
	'',
	a.nmbre_scrsl,
	a.nmbre_empldr,
	a.ttl_fctrdo,
	'',
	a.fcha_incl_fctrcn,
	a.fcha_fnl_fctrcn,
	convert(char(20),replace(convert(char(20),a.fcha_crcn,120),'-' , '/'  )) fcha_crcn_hra,  
	a.usro_crcn,
	'NO SELECCIONADO'  accn ,  
	a.fcha_lmte_pgo,
	a.nmro_unco_idntfccn_empldr,
	a.cnsctvo_scrsl,
	a.cnsctvo_cdgo_clse_aprtnte,
	a.cnsctvo_cdgo_tpo_idntfccn,
	a.dgto_vrfccn,
	a.cts_cnclr,
	a.drccn,
	a.cnsctvo_cdgo_cdd,
	a.tlfno,
	a.vlr_iva,
	a.sldo_fvr,
	a.ttl_pgr,
	a.fcha_crcn,
	a.cnsctvo_cdgo_prdo,
	a.cnsctvo_cdgo_autrzdr_espcl,
	a.prcntje_incrmnto,
	a.cnsctvo_cdgo_prdo_lqdcn,
	a.cnsctvo_cdgo_estdo_estdo_cnta,
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	a.exste_cntrto 
From	bdcarteraPac.dbo.tbCuentasManuales a
where	@usro_crcn	=	a.usro_crcn




update  #tmpEstadosCuenta
Set	cdgo_tpo_idntfccn	=	b.cdgo_tpo_idntfccn,
	dscrpcn_tpo_idntfccn	=	b.dscrpcn_tpo_idntfccn
From	#tmpEstadosCuenta a inner join bdafiliacion.dbo.tbtiposidentificacion b
	On (b.cnsctvo_cdgo_tpo_idntfccn 	=  a.cnsctvo_cdgo_tpo_idntfccn)

update  #tmpEstadosCuenta
Set	cdgo_clse_aprtnte	=	c.cdgo_clse_aprtnte,
	dscrpcn_clse_aprtnte	=	c.dscrpcn_clse_aprtnte
From	#tmpEstadosCuenta a inner join bdafiliacion.dbo.tbclasesaportantes    c 
	On (c.cnsctvo_cdgo_clse_aprtnte	 = a.cnsctvo_cdgo_clse_aprtnte)

update  #tmpEstadosCuenta
Set	cdgo_prdo	=	d.cdgo_prdo,
	dscrpcn_prdo	=	d.dscrpcn_prdo
From	#tmpEstadosCuenta a inner join bdafiliacion.dbo.tbperiodos	    d 
	On (d.cnsctvo_cdgo_prdo		    = a.cnsctvo_cdgo_prdo)


Update  #tmpEstadosCuenta
Set	cdgo_prdo_lqdcn		=	e.cdgo_prdo_lqdcn,
	dscrpcn_prdo_lqdcn	=	e.dscrpcn_prdo_lqdcn
From	#tmpEstadosCuenta a inner join bdcarterapac.dbo.tbPeriodosLiquidacion	   e
	On (e.cnsctvo_cdgo_prdo_lqdcn 	  = a.cnsctvo_cdgo_prdo_lqdcn)

Update  #tmpEstadosCuenta
Set	Usro_atrzdr		=	isnull(f.prmr_nmbre_usro,'') ,
	cdgo_autrzdr_espcl	=	f.cdgo_autrzdr_espcl
From	#tmpEstadosCuenta a inner join bdcarterapac.dbo.tbautorizadoresEspeciales_vigencias	   f
	On (f.cnsctvo_cdgo_autrzdr_espcl   = a.cnsctvo_cdgo_autrzdr_espcl)

Update  #tmpEstadosCuenta
Set	dscrpcn_estdo_estdo_cnta	=g.dscrpcn_estdo_estdo_cnta,
	cdgo_estdo_estdo_cnta		=g.cdgo_estdo_estdo_cnta
From	#tmpEstadosCuenta a inner join bdcarterapac.dbo.tbestadosestadoscuenta	  g
	On (g.cnsctvo_cdgo_estdo_estdo_cnta   = a.cnsctvo_cdgo_estdo_estdo_cnta)



Select	   nmro_estdo_cnta ,  cdgo_tpo_idntfccn , nmro_idntfccn_rspnsble_pgo ,
	   dscrpcn_clse_aprtnte , nmbre_scrsl  , nmbre_empldr ,
	   ttl_fctrdo ,  dscrpcn_estdo_estdo_cnta , fcha_incl_fctrcn ,
	   fcha_fnl_fctrcn ,	fcha_crcn_hra , usro_crcn ,
	   accn , fcha_lmte_pgo ,nmro_unco_idntfccn_empldr ,
	   cnsctvo_scrsl , cnsctvo_cdgo_clse_aprtnte ,  cnsctvo_cdgo_tpo_idntfccn ,
	   dgto_vrfccn ,cts_cnclr , drccn ,  cnsctvo_cdgo_cdd ,
	   tlfno ,	 vlr_iva , sldo_fvr ,
	   ttl_pgr , fcha_crcn , cnsctvo_cdgo_prdo,
	   cnsctvo_cdgo_autrzdr_espcl , prcntje_incrmnto ,
	   cnsctvo_cdgo_prdo_lqdcn , cnsctvo_cdgo_estdo_estdo_cnta ,
	   dscrpcn_tpo_idntfccn , cdgo_clse_aprtnte ,
	   cdgo_prdo , dscrpcn_prdo ,
	   cdgo_prdo_lqdcn , dscrpcn_prdo_lqdcn ,
	   cdgo_estdo_estdo_cnta ,
	   Usro_atrzdr  ,
	   cdgo_autrzdr_espcl ,
	   exste_cntrto 
From	#tmpEstadosCuenta
