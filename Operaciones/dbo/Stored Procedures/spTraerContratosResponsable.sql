
/*---------------------------------------------------------------------------------
* Metodo o PRG 		:  SpTraerContratosResponsable
* Desarrollado por		: <\A Ing. Rolando simbaqueva lasso									A\>
* Descripcion			: <\D Este procedimiento realiza una busqueda de loscontratos del responsable			  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P  													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003/02/05 											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  Rolando Simbaqueva LassoAM\>
* Descripcion				: <\DM Aplicación tecnicas de optimización DM\>
* Nuevos Parametros			: <\PM  PM\>
* Nuevas Variables			: <\VM  VM\>
* Fecha Modificacion			: <\FM 2005/09/25	 FM\>
*---------------------------------------------------------------------------------*/

CREATE        PROCEDURE spTraerContratosResponsable
	@lnConsecutivoClaseAportante	udtconsecutivo,
	@lnNumeroInicoIdentificacion	udtConsecutivo,
	@lnConsecutivoSucursal		udtConsecutivo

As	Declare
@ldFechaSistema		Datetime,
@cnsctvo_cdgo_prdo_lqdcn	int,
@ldFecha_Corte		Datetime

-- creacion de la tabla temporal
Set Nocount On

Create table #tmpCobranzas
(cnsctvo_cdgo_tpo_cntrto int,
 nmro_cntrto udtNumeroFormulario, 
 cnsctvo_cbrnza int,
 nmro_unco_idntfccn_aprtnte int,
 cnsctvo_cdgo_clse_aprtnte int,
 cnsctvo_cdgo_frma_cbro int,
 cnsctvo_cdgo_prdcdd_prpgo int)

Create table #tmpContratos
(nmro_cntrto udtNumeroFormulario,
 cnsctvo_cdgo_tpo_cntrto int,
 cnsctvo_cdgo_pln int,
 inco_vgnca_cntrto datetime,
 fn_vgnca_cntrto datetime,
 nmro_unco_idntfccn_afldo int)

/*
Create table	#tmpBeneficiarios
(cnsctvo_cdgo_tpo_cntrto int,
 nmro_cntrto  varchar(20),
 cnsctvo_bnfcro int,
 nmro_unco_idntfccn_bnfcro int,
 inco_vgnca_bnfcro datetime ,
 fn_vgnca_bnfcro datetime)
*/

Create table #tmpVigenciasCobranzasPac
(cnsctvo_vgnca_cbrnza int,
 inco_vgnca_cbrnza datetime,
 fn_vgnca_cbrnza datetime,
 cta_mnsl numeric(12,0),
 cnsctvo_cdgo_tpo_cntrto int,
 nmro_cntrto udtNumeroFormulario,
 cnsctvo_cbrnza int,
 cnsctvo_scrsl_ctznte int)



Select 	@ldFechaSistema	=	Getdate()

-- se trae el periodo de liquidacion
Select 	@cnsctvo_cdgo_prdo_lqdcn			=	cnsctvo_cdgo_prdo_lqdcn
From	tbPeriodosliquidacion_Vigencias
Where	cnsctvo_cdgo_estdo_prdo			=	2	--Asigan el periodo de liquidacion  estado con periodo abierto


--  estado con periodo abierto
Select 	@ldFecha_Corte		=	fcha_incl_prdo_lqdcn
From	tbPeriodosliquidacion_Vigencias
Where	cnsctvo_cdgo_estdo_prdo	=	2	
And	cnsctvo_cdgo_prdo_lqdcn	=	@cnsctvo_cdgo_prdo_lqdcn

Insert into #tmpCobranzas
Select  cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	cnsctvo_cbrnza,
	nmro_unco_idntfccn_aprtnte,
	cnsctvo_cdgo_clse_aprtnte,
	cnsctvo_cdgo_frma_cbro,
	cnsctvo_cdgo_prdcdd_prpgo
From	bdafiliacion.dbo.tbCobranzas
Where 	nmro_unco_idntfccn_aprtnte 	 = @lnNumeroInicoIdentificacion
and 	cnsctvo_cdgo_clse_aprtnte	 = @lnConsecutivoClaseAportante
And	cnsctvo_cdgo_tpo_cntrto	 	 = 2
And	estdo				 = 'A'

--aqui estdo

Insert	into       #tmpContratos
Select    a.nmro_cntrto,		a.cnsctvo_cdgo_tpo_cntrto,
	  a.cnsctvo_cdgo_pln,		a.inco_vgnca_cntrto,	a.fn_vgnca_cntrto,			a.nmro_unco_idntfccn_afldo
From 	  bdafiliacion.dbo.tbcontratos  a inner join  ( Select 	 cnsctvo_cdgo_tpo_cntrto, nmro_cntrto
					  	        From	#tmpCobranzas
						        Group by cnsctvo_cdgo_tpo_cntrto, 	nmro_cntrto)  tmpCobranzasA  
	  on (a.cnsctvo_cdgo_tpo_cntrto		=	tmpCobranzasA.cnsctvo_cdgo_tpo_cntrto
	  And	a.nmro_cntrto			=	tmpCobranzasA.nmro_cntrto)
WHERE  datediff(dd,inco_vgnca_cntrto,@ldFecha_Corte)	>= 0 And	datediff(dd,@ldFecha_Corte,fn_vgnca_cntrto)	>= 0 

/*
Insert Into 	#tmpBeneficiarios          
Select	a. cnsctvo_cdgo_tpo_cntrto, 	a.nmro_cntrto  ,   	a.cnsctvo_bnfcro, 	a.nmro_unco_idntfccn_bnfcro, 
	a.inco_vgnca_bnfcro  ,       	a.fn_vgnca_bnfcro
from   bdafiliacion.dbo.tbBeneficiarios   a inner join ( Select 	 cnsctvo_cdgo_tpo_cntrto, nmro_cntrto
						     From	#tmpCobranzas
						     Group by cnsctvo_cdgo_tpo_cntrto, 	nmro_cntrto)  tmpCobranzasA
	on (a.cnsctvo_cdgo_tpo_cntrto	=	tmpCobranzasA.cnsctvo_cdgo_tpo_cntrto
	And	a.nmro_cntrto		=	tmpCobranzasA.nmro_cntrto )
WHERE  datediff(dd,inco_vgnca_bnfcro,@ldFecha_Corte)	>= 0 And	datediff(dd,@ldFecha_Corte,fn_vgnca_bnfcro)	>= 0 
*/

-- se crea una tabla temporal con las cobranzas del responsable
Insert into 	#tmpVigenciasCobranzasPac
Select   max(a.cnsctvo_vgnca_cbrnza) cnsctvo_vgnca_cbrnza,
         max(a.inco_vgnca_cbrnza) inco_vgnca_cbrnza,
         max(a.fn_vgnca_cbrnza) fn_vgnca_cbrnza ,
         max(a.cta_mnsl)  cta_mnsl,
         a.cnsctvo_cdgo_tpo_cntrto,
         a.nmro_cntrto,
         max(a.cnsctvo_cbrnza) cnsctvo_cbrnza,
         max(a.cnsctvo_scrsl_ctznte) cnsctvo_scrsl_ctznte
From	bdafiliacion.dbo.tbVigenciasCobranzas a inner join   ( Select 	 cnsctvo_cdgo_tpo_cntrto, nmro_cntrto
						     	     From	#tmpCobranzas
						     	     Group by cnsctvo_cdgo_tpo_cntrto, 	nmro_cntrto)  tmpCobranzasA
	 on (a.cnsctvo_cdgo_tpo_cntrto	=	tmpCobranzasA.cnsctvo_cdgo_tpo_cntrto
	And	a.nmro_cntrto			=	tmpCobranzasA.nmro_cntrto)	
Where	a.estdo_rgstro			 =	 'S'
and   datediff(dd,inco_vgnca_cbrnza,@ldFecha_Corte)	>= 0 And	datediff(dd,@ldFecha_Corte,fn_vgnca_cbrnza)	>= 0 
Group by   a.cnsctvo_cdgo_tpo_cntrto,	    a.nmro_cntrto

 


-- Se traer los contratos asociados al responsable
Select  a.nmro_cntrto,	f.cdgo_tpo_idntfccn,	e.nmro_idntfccn,
	ltrim(rtrim(d.prmr_aplldo)) + ' ' + ltrim(rtrim(d.sgndo_aplldo)) + ' ' + ltrim(rtrim(d.prmr_nmbre)) + ' ' +ltrim(rtrim(sgndo_nmbre)) nombre,p. dscrpcn_pln  , 
	'NO SELECCIONADO'	accn,
	a.cnsctvo_cdgo_tpo_cntrto,	a.cnsctvo_cdgo_pln,		a.inco_vgnca_cntrto,	a.fn_vgnca_cntrto,	a.nmro_unco_idntfccn_afldo,
	b.cnsctvo_cbrnza,		b.nmro_unco_idntfccn_aprtnte,	
	c.cnsctvo_vgnca_cbrnza,		c.cnsctvo_scrsl_ctznte,		c.inco_vgnca_cbrnza,	c.fn_vgnca_cbrnza,	c.cta_mnsl,
	b.cnsctvo_cdgo_prdcdd_prpgo	,p.cdgo_pln	
From 	#tmpContratos  a inner join 		#tmpCobranzas  b
	on (a.cnsctvo_cdgo_tpo_cntrto 	=	 b.cnsctvo_cdgo_tpo_cntrto
	And 	a.nmro_cntrto		  	= 	 b.nmro_cntrto) 
	inner join  	#tmpVigenciasCobranzasPac c
	on (c.cnsctvo_cdgo_tpo_cntrto 	=	 b.cnsctvo_cdgo_tpo_cntrto
	And	c.nmro_cntrto		  	=	 b.nmro_cntrto
	And	c.cnsctvo_cbrnza	  	=	 b.cnsctvo_cbrnza)
	inner join	bdafiliacion.dbo.tbpersonas d
	on (a.nmro_unco_idntfccn_afldo	=	d.nmro_unco_idntfccn)
	inner join bdafiliacion.dbo.tbvinculados  e
	on (d.nmro_unco_idntfccn		=	e.nmro_unco_idntfccn)
	inner join 	bdafiliacion.dbo.tbtiposidentificacion f		
	on (e.cnsctvo_cdgo_tpo_idntfccn	=	f.cnsctvo_cdgo_tpo_idntfccn)
	inner join	bdplanbeneficios..tbplanes	p
	on (a.cnsctvo_cdgo_pln		=	p.cnsctvo_cdgo_pln)
Where   b.cnsctvo_cdgo_clse_aprtnte	=	@lnConsecutivoClaseAportante	
And	b.nmro_unco_idntfccn_aprtnte	=	@lnNumeroInicoIdentificacion
And	c.cnsctvo_scrsl_ctznte		=	@lnConsecutivoSucursal