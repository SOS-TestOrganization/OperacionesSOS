

/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spExportaDetalleContratosCuentaManual
* Desarrollado por		: <\A Ing Rolando Simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento exporta la informacion de los contratos del estado de cuenta manual	  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P Numero del estado de cuenta									P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003/03/17 											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  Rolando Simbaqueva Lasso	AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  2002/09/10	 FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[spExportaDetalleContratosCuentaManual]

		@nmro_estdo_cnta	varchar(15) 
	
		

As  
Set nocount ON

Create Table #tmpContratosFacManual
( nmro_cntrto varchar(15),
  cnsctvo_cdgo_tpo_cntrto int,
  cntdd_bnfcrs int,
  cdgo_pln char(2),
  dscrpcn_pln varchar(50),
  cnsctvo_cdgo_pln int,
  vlr_cbrdo numeric(12,0),
  cnsctvo_cnta_mnls_cntrto int,
  nmro_estdo_cnta varchar(15),	
  cdgo_tpo_idntfccn varchar(3),	
  nmro_idntfccn varchar(20),	
  prmr_Nmbre varchar(20),	
  sgndo_nmbre varchar(20),	
  prmr_aplldo varchar(50),	
  sgndo_aplldo varchar(50))

Create Table #tmpBeneficiariosCuentasManuales
(cnsctvo_cnta_mnls_cntrto int, consecutivo_Beneficiario int)


insert into #tmpContratosFacManual
Select  a.nmro_cntrto,
	a.cnsctvo_cdgo_tpo_cntrto,
	a.cntdd_bnfcrs,
	b.cdgo_pln,			
	b.dscrpcn_pln,
	a.cnsctvo_cdgo_pln,
	a.vlr_cbrdo,
	a.cnsctvo_cnta_mnls_cntrto,
	a.nmro_estdo_cnta,
	'',
	'',
	'',
	'',
	'',
	''
From 	bdcarteraPac.dbo.TbCuentasManualesContrato a  inner join  bdplanbeneficios..tbplanes  b
	on (a.cnsctvo_cdgo_pln	=	b.cnsctvo_cdgo_pln)
Where 	nmro_estdo_cnta 	= 	@nmro_estdo_cnta




Update #tmpContratosFacManual
Set	prmr_Nmbre 		=	c.prmr_Nmbre ,
	sgndo_nmbre		=	c.sgndo_nmbre,
	prmr_aplldo		=	c.prmr_aplldo,
	sgndo_aplldo		=	c.sgndo_aplldo,
	cdgo_tpo_idntfccn	=	d.cdgo_tpo_idntfccn,
	nmro_idntfccn 		=	v.nmro_idntfccn 
From	#tmpContratosFacManual a inner join bdAfiliacion.dbo.TbContratos b
	on (a.nmro_cntrto			=	b.nmro_cntrto
	and a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto) 
	inner join 	bdAfiliacion.dbo.tbpersonas  c
	on (c.nmro_unco_idntfccn		=	b.nmro_unco_idntfccn_afldo)
	inner join  bdAfiliacion.dbo.tbvinculados v  
	on (v.nmro_unco_idntfccn		=	b.nmro_unco_idntfccn_afldo)
	inner join	bdafiliacion.dbo.tbtiposidentificacion d 
	on (v.cnsctvo_cdgo_tpo_idntfccn	=	 d.cnsctvo_cdgo_tpo_idntfccn)


Insert Into #tmpBeneficiariosCuentasManuales
select  a.cnsctvo_cnta_mnls_cntrto, min(cnsctvo_bnfcro) consecutivo_Beneficiario
From 	bdcarteraPac.dbo.TbCuentasManualesBeneficiario a inner join #tmpContratosFacManual b
	on(a.cnsctvo_cnta_mnls_cntrto	=	b.cnsctvo_cnta_mnls_cntrto)
Group by a.cnsctvo_cnta_mnls_cntrto


Update  #tmpContratosFacManual
Set	prmr_Nmbre 		=	c.prmr_Nmbre ,
	sgndo_nmbre		=	c.sgndo_nmbre,
	prmr_aplldo		=	c.prmr_aplldo,
	sgndo_aplldo		=	c.sgndo_aplldo,
	nmro_idntfccn 		=	c.nmro_idntfccn 
From	#tmpContratosFacManual a inner join #tmpBeneficiariosCuentasManuales  b
	on (a.cnsctvo_cnta_mnls_cntrto	=	b.cnsctvo_cnta_mnls_cntrto )
	inner join  bdcarteraPac.dbo.TbCuentasManualesBeneficiario c
	on (c.cnsctvo_cnta_mnls_cntrto	=	b.cnsctvo_cnta_mnls_cntrto
	And c.cnsctvo_bnfcro		=	b.consecutivo_Beneficiario)
Where 	a.prmr_Nmbre		=	''

Select   nmro_cntrto ,
 	cnsctvo_cdgo_tpo_cntrto ,
  	cntdd_bnfcrs ,
  	cdgo_pln ,
  	dscrpcn_pln ,
  	cnsctvo_cdgo_pln ,
  	vlr_cbrdo ,
  	nmro_estdo_cnta ,
  	cdgo_tpo_idntfccn ,
  	nmro_idntfccn ,
  	prmr_Nmbre ,
  	sgndo_nmbre ,
  	prmr_aplldo ,
  	sgndo_aplldo 
From #tmpContratosFacManual



