/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spTraerSucursalesXDiasMora
* Desarrollado por		: <\A Ing. ROLANDO SIMBAQUEVA LASSO								A\>
* Descripcion			: <\D Este procedimiento realiza una busqueda de las sucursales de un empleador para unos dias de mora  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P Consecutivo grupo liquidacion									P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/02 											FC\>
**/

CREATE PROCEDURE spTraerSucursalesXDiasMora

	@lnconsecutivoDiasMora		UdtConsecutivo
As

Set Nocount On



Select   distinct a.nmro_unco_idntfccn_empldr ,  a.cnsctvo_scrsl,  b.dgto_vrfccn ,  b.nmro_idntfccn, b.cnsctvo_cdgo_tpo_idntfccn, space(200) rzn_scl ,cnsctvo_cdgo_clse_aprtnte
Into      #tmpDiasMoraSucursal
From    TbDiasCobroMoraSucursal_vigencias  a ,bdafiliacion..tbvinculados b
Where   b.vldo	=	'S'
And      cnsctvo_cdgo_ds_mra		=	@lnconsecutivoDiasMora
And	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn

 

Update 	#tmpDiasMoraSucursal
Set  	rzn_scl	     =  c.rzn_scl
From 	#tmpDiasMoraSucursal a ,  bdafiliacion..tbempleadores b,	bdafiliacion..tbempresas c
Where 	a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn
And	a.nmro_unco_idntfccn_empldr		=	c.nmro_unco_idntfccn 

Update 	#tmpDiasMoraSucursal
Set  	rzn_scl	     =   ltrim(rtrim(isnull(prmr_aplldo,'')))  + ' ' + ltrim(rtrim(isnull(sgndo_aplldo,''))) + ' ' + ltrim(rtrim(isnull(prmr_nmbre,''))) + ' ' + ltrim(rtrim(isnull(sgndo_nmbre,'')))
From 	#tmpDiasMoraSucursal a	,bdafiliacion..tbempleadores b,	bdafiliacion..tbpersonas c--,	tbclasesempleador d
Where	a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn
And	a.nmro_unco_idntfccn_empldr		=	c.nmro_unco_idntfccn





SELECT   B.nmro_unco_idntfccn_empldr NUI_EMPRESA,  
	 B.nmbre_scrsl,
	 A.*, convert(char(20),replace(convert(char(20),A.fcha_crcn,120),'-','/')) fcha_crcn_hra,
	 C.cdgo_ds_mra,
	 C.dscrpcn_da_mra
         ,e.cdgo_tpo_idntfccn , f.nmro_idntfccn ,  b.cnsctvo_scrsl SUCURSAL , E.cnsctvo_cdgo_tpo_idntfccn, f.dgto_vrfccn , f.rzn_scl , SPACE(20) as estdo,G.cdgo_clse_aprtnte, G. dscrpcn_clse_aprtnte
FROM    bdCarterapac..TbDiasCobroMoraSucursal_vigencias A,
               bdAfiliacion..tbSucursalesAportante B, 
	  bdcarterapac..tbdiasmora C,
	  bdafiliacion..tbtiposidentificacion E    ,
               #tmpDiasMoraSucursal  f,
	bdafiliacion..tbclasesaportantes g
Where  A.nmro_unco_idntfccn_empldr	 = 	B.nmro_unco_idntfccn_empldr
AND  A.cnsctvo_scrsl	       		 = 	B.cnsctvo_scrsl  
AND  A.cnsctvo_cdgo_clse_aprtnte	 = 	B.cnsctvo_cdgo_clse_aprtnte  
AND  A.cnsctvo_cdgo_ds_mra	  	 = 	C.cnsctvo_cdgo_ds_mra
AND  A.cnsctvo_cdgo_ds_mra		 =	@lnconsecutivoDiasMora
AND  B.nmro_unco_idntfccn_empldr	 = 	F.nmro_unco_idntfccn_empldr
AND  B.cnsctvo_scrsl 			 =	F.cnsctvo_scrsl
AND  F.cnsctvo_cdgo_tpo_idntfccn	 = 	E.cnsctvo_cdgo_tpo_idntfccn
AND  F.cnsctvo_cdgo_clse_aprtnte	 =	G.cnsctvo_cdgo_clse_aprtnte