CREATE PROCEDURE spTraerBeneficiariosXDescuento

	@lnconsecutivoGrupoDescuento		UdtConsecutivo
As

Set Nocount On


Select  distinct a.nmro_unco_idntfccn ,    b.dgto_vrfccn ,  b.nmro_idntfccn, b.cnsctvo_cdgo_tpo_idntfccn, space(100) Nmbre_bene,
	cdgo_autrzdr_espcl, 	dscrpcn_autrzdr_espcl ,
	space(40) prmr_nmbre,
	space(40) sgndo_nmbre,
	space(40) prmr_aplldo,
	space(40) sgndo_aplldo
Into    #tmpGruposAportante
From    tbResponsableXDescuento_Vigencias  a ,bdafiliacion..tbvinculados b, tbAutorizadoresEspeciales c
Where   b.vldo				=	'S'
And     cnsctvo_cdgo_dscnto		=	@lnconsecutivoGrupoDescuento
And	a.nmro_unco_idntfccn		=	b.nmro_unco_idntfccn
And	a.cnsctvo_cdgo_autrzdr_espcl   =             c.cnsctvo_cdgo_autrzdr_espcl


Update 	#tmpGruposAportante
Set  	Nmbre_bene	 		= 	 ltrim(rtrim(p.prmr_nmbre)) + ' '  + ltrim(rtrim(p.sgndo_nmbre)) + ' ' + ltrim(rtrim(p.prmr_aplldo)) + ' ' + ltrim(rtrim(p.sgndo_aplldo)),
	prmr_nmbre			=	 ltrim(rtrim(p.prmr_nmbre)),
	sgndo_nmbre			=	 ltrim(rtrim(p.sgndo_nmbre)),
	prmr_aplldo			=	 ltrim(rtrim(p.prmr_aplldo)),
	sgndo_aplldo			=	 ltrim(rtrim(p.sgndo_aplldo))
From 	#tmpGruposAportante a ,  bdafiliacion..tbPersonas p 
Where 	a.nmro_unco_idntfccn	= p.nmro_unco_idntfccn


SELECT   f.nmro_unco_idntfccn nui_Bene,  
	   A.*, convert(char(20),replace(convert(char(20),A.fcha_crcn,120),'-','/')) fcha_crcn_hra,
	   C.cdgo_dscnto,
	   C.dscrpcn_dscnto,  
	   e.cdgo_tpo_idntfccn 	 	cdgo_tpo_idntfccn_bene, 
	   f.nmro_idntfccn 	 	nmro_idntfccn_bene ,
	   E.cnsctvo_cdgo_tpo_idntfccn  cnsctvo_cdgo_tpo_idntfccn_bene , 
                f.dgto_vrfccn , 
	   f.Nmbre_bene , SPACE(20) as estdo,
	   f.cdgo_autrzdr_espcl, 	f.dscrpcn_autrzdr_espcl ,
	   prmr_nmbre,
	   sgndo_nmbre,
	   prmr_aplldo,
	   sgndo_aplldo,
	   c.vlr
FROM    tbResponsableXDescuento_Vigencias   A,
               bdcarteraPac..tbdescuentos_vigencias  C,
	  bdafiliacion..tbtiposidentificacion 	E,
              #tmpGruposAportante 			f
Where  A.nmro_unco_idntfccn	 = 	f.nmro_unco_idntfccn
AND  A.cnsctvo_cdgo_dscnto  		 = 	C.cnsctvo_cdgo_dscnto
AND  A.cnsctvo_cdgo_dscnto		 =	@lnconsecutivoGrupoDescuento
AND  F.cnsctvo_cdgo_tpo_idntfccn	 = 	E.cnsctvo_cdgo_tpo_idntfccn