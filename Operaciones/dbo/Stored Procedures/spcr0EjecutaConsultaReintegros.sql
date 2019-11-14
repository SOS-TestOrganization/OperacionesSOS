
/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spcr0EjecutaConsultaReintegros
* Desarrollado por		: <\A Jairo Valencia								A\>
* Descripcion			: <\D Este procedimiento crea y ejecuta la cadena donde se tiene los criterios para seleccionar las notas  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2013 / 10 / 01											FC\>
*
*---------------------------------------------------------------------------------*/
CREATE  PROCEDURE [dbo].[spcr0EjecutaConsultaReintegros]
			
			

As

Declare
@ldfechaSistema	datetime,
@Instruccion		Nvarchar(4000),
@Parametros			Nvarchar(1000),
@lcJoin				NVarchar(1000),
@lcCadena1			NVarchar(1000)


		
Update 	#tmpNotasDebito
Set	 rzn_scl	 =  c.rzn_scl
From 	#tmpNotasDebito	 a	,bdafiliacion..tbempleadores b,	bdafiliacion..tbempresas c --,	tbclasesempleador d
Where	a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte 
And	a.nmro_unco_idntfccn_empldr		=	c.nmro_unco_idntfccn
--And	a.vldo				=	'S'


Update 	#tmpNotasDebito
Set	 rzn_scl	 =   nmbre_scrsl 
From   #tmpNotasDebito	 a
Where (a.rzn_scl = '' or a.rzn_scl is null)


Update 	#tmpNotasDebito
Set	  nmbre_sde = ltrim(rtrim(isnull(dscrpcn_sde,'')))
From bdAfiliacion..tbSedes
where tbSedes.cnsctvo_cdgo_sde = #tmpNotasDebito.cnsctvo_cdgo_sde



Select @Instruccion	=  	'SELECT       nmro_nta,				 dscrpcn_estdo_nta,		 cdgo_tpo_idntfccn, 	nmro_idntfccn, 			dscrpcn_clse_aprtnte,
					        nmbre_scrsl, 			rzn_scl,		vlr_nta, 	
					       usro_crcn,	     fcha_incl_prdo_lqdcn,		 fcha_fnl_prdo_lqdcn, 			
				                     nmro_unco_idntfccn_empldr, 	cnsctvo_scrsl, 			cnsctvo_cdgo_clse_aprtnte, 	vlr_iva, 
					        sldo_nta, 				dscrpcn_tpo_idntfccn, 
    				 	        cnsctvo_cdgo_tpo_idntfccn, 
					        cnsctvo_cdgo_tpo_nta,
					        cnsctvo_cdgo_estdo_nta,fcha_crcn_nta,fcha_entrga_nta,cnsctvo_cdgo_pgo,cntro_csts,nmbre_sde,dscrpcn_cncpto_lqdcn,fcha_pgo_acrddo, isnull(cnsctvo_cdgo_tpo_dcmnto_nta_rntgro,1) as dcmnto_nta_rntgro '
					+   'From   #tmpNotasDebito a
					Where    ' 

  
Select @lcJoin	 =	'      1	=	1	'
Select @lcCadena1	= ' '

Select @Instruccion = @Instruccion + @lcCadena1 +  @lcJoin

Exec  Sp_executesql     @Instruccion

