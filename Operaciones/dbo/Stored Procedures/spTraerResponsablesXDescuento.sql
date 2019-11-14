/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spTraerResponsablesXDescuento
* Desarrollado por		: <\A Ing. ROLANDO SIMBAQUEVA LASSO								A\>
* Descripcion			: <\D Este procedimiento realiza una busqueda de las responsables por descuentoto			.  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P Consecutivo grupo liquidacion									P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/02 											FC\>
**/

CREATE PROCEDURE spTraerResponsablesXDescuento

	@lnConsecutivoDescuento		UdtConsecutivo
As

Set Nocount On

 



Select   distinct a.nmro_unco_idntfccn ,   a.cnsctvo_scrsl,  a.cnsctvo_cdgo_dscnto,
	 b.dgto_vrfccn ,  b.nmro_idntfccn, b.cnsctvo_cdgo_tpo_idntfccn,a.cnsctvo_cdgo_bse_aplcda,
	 space(200) nombre, c.cdgo_tpo_idntfccn, space(200) nmbre_scrsl  ,a.cnsctvo_cdgo_clse_aprtnte
Into     #tmpDescuentosxResponsable
From    TbResponsableXDescuento_vigencias  a ,bdafiliacion..tbvinculados b, bdafiliacion..tbtiposidentificacion c
Where   b.vldo	=	'S'
And     a.cnsctvo_cdgo_dscnto		 =	@lnConsecutivoDescuento
And	a.nmro_unco_idntfccn	  	 =	b.nmro_unco_idntfccn
And	b.cnsctvo_cdgo_tpo_idntfccn	 = 	c.cnsctvo_cdgo_tpo_idntfccn


Update 	#tmpDescuentosxResponsable
Set  	nombre	     =  c.rzn_scl
From 	#tmpDescuentosxResponsable a ,  bdafiliacion..tbempleadores b,	bdafiliacion..tbempresas c
Where 	a.nmro_unco_idntfccn		=	b.nmro_unco_idntfccn
And	a.nmro_unco_idntfccn		=	c.nmro_unco_idntfccn 
And	(a.cnsctvo_cdgo_bse_aplcda	=	3 or  a.cnsctvo_cdgo_bse_aplcda= 2 ) -- Empresa o Sucursal

Update 	#tmpDescuentosxResponsable
Set  	nombre	     =   ltrim(rtrim(isnull(prmr_aplldo,'')))  + ' ' + ltrim(rtrim(isnull(sgndo_aplldo,''))) + ' ' + ltrim(rtrim(isnull(prmr_nmbre,''))) + ' ' + ltrim(rtrim(isnull(sgndo_nmbre,'')))
From 	#tmpDescuentosxResponsable a	,bdafiliacion..tbempleadores b,	bdafiliacion..tbpersonas c
Where	a.nmro_unco_idntfccn		=	b.nmro_unco_idntfccn
And	a.nmro_unco_idntfccn		=	c.nmro_unco_idntfccn 
And	(a.cnsctvo_cdgo_bse_aplcda	=	3 or  a.cnsctvo_cdgo_bse_aplcda= 2 ) -- Empresa o Sucursal


Update 	#tmpDescuentosxResponsable
Set  	nmbre_scrsl	    		 =   ltrim(rtrim(b.nmbre_scrsl))
From 	#tmpDescuentosxResponsable a	, bdafiliacion..tbSucursalesAportante b
Where	a.nmro_unco_idntfccn		=	b.nmro_unco_idntfccn_empldr
And	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl 
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
And	(a.cnsctvo_cdgo_bse_aplcda	=	3 or  a.cnsctvo_cdgo_bse_aplcda= 2 ) -- Empresa o Sucursal




Update 	#tmpDescuentosxResponsable
Set  	nombre	     =   ltrim(rtrim(isnull(prmr_aplldo,'')))  + ' ' + ltrim(rtrim(isnull(sgndo_aplldo,''))) + ' ' + ltrim(rtrim(isnull(prmr_nmbre,''))) + ' ' + ltrim(rtrim(isnull(sgndo_nmbre,'')))
From 	#tmpDescuentosxResponsable a	,bdafiliacion..tbpersonas c--,	tbclasesempleador d
Where	a.nmro_unco_idntfccn		=	c.nmro_unco_idntfccn 
And	a.cnsctvo_cdgo_bse_aplcda	=	1  -- Empresa





Select	b.cdgo_tpo_idntfccn, b.nmro_idntfccn, b.nombre,b.nmbre_scrsl,
	A.*, convert(char(20),replace(convert(char(20),A.fcha_crcn,120),'-','/')) fcha_crcn_hra,
	c.dscrpcn_bse_aplcda , c.cdgo_tpo_bse_aplcda,SPACE(20) as estdo , d.cdgo_dscnto , e.dscrpcn_autrzdr_espcl,b.cnsctvo_cdgo_tpo_idntfccn , 
	 b.dgto_vrfccn, e.cdgo_autrzdr_espcl , d.dscrpcn_dscnto  ,  dscrpcn_clse_aprtnte
From    TbResponsableXDescuento_vigencias  a,#tmpDescuentosxResponsable b ,  tbbasesaplicadas c , tbdescuentos d,  tbautorizadoresEspeciales  e,
	 bdafiliacion..tbclasesaportantes  f
Where   a.nmro_unco_idntfccn	      = b.nmro_unco_idntfccn
And	a.cnsctvo_scrsl	 	      = b.cnsctvo_scrsl
And	a.cnsctvo_cdgo_dscnto	      = b.cnsctvo_cdgo_dscnto
And	a.cnsctvo_cdgo_bse_aplcda  = c.cnsctvo_cdgo_bse_aplcda
And	a.cnsctvo_cdgo_dscnto	      =d.cnsctvo_cdgo_dscnto 	
And	a.cnsctvo_cdgo_autrzdr_espcl =e.cnsctvo_cdgo_autrzdr_espcl
AND     a.cnsctvo_cdgo_dscnto	 =	@lnConsecutivoDescuento
AND	a.cnsctvo_cdgo_clse_aprtnte	=	f.cnsctvo_cdgo_clse_aprtnte