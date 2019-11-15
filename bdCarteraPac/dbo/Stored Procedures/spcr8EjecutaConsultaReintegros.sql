
/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spcr8EjecutaConsultaReintegros
* Desarrollado por		: <\A Ing. Andres camelo (illustrato ltda)								A\>
* Descripcion			: <\D Este procedimiento consulta los reintregos que se han realizado por afiliados independientes 	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2014 / 03 / 11											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  		AM\>
* Descripcion			: <\DM 	DM\>
* Nuevos Parametros		: <\PM 		 PM\>
* Nuevos Parametros		: <\PM   	 PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM   FM\>
*---------------------------------------------------------------------------------
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------
*---------------------------------------------------------------------------------*/
create  PROCEDURE [dbo].[spcr8EjecutaConsultaReintegros]
    @tipoIdentificacion         int,
	@lnNumeroIdentificacion		numeric(18)
			
			

As


Set Nocount On


SELECT      a.nmro_nta,
		    e.dscrpcn_estdo_nta,
		    isnull(f.cdgo_tpo_idntfccn,g.cdgo_tpo_idntfccn) cdgo_tpo_idntfccn,
		    cast( g.nmro_idntfccn as varchar(29)) nmro_idntfccn,
 			isnull(i.dscrpcn_clse_aprtnte,'INDEPENDIENTE') dscrpcn_clse_aprtnte,
		    isnull(ltrim(rtrim(prmr_nmbre)),' ') + ' ' +isnull(ltrim(rtrim(sgndo_nmbre)),' ') + ' ' + isnull(ltrim(rtrim(prmr_aplldo)),' ') + ' ' + isnull(ltrim(rtrim(sgndo_aplldo)),' ') nmbre_scrsl,
 			a.vlr_nta, 	
			h.fcha_incl_prdo_lqdcn,
    		h.fcha_fnl_prdo_lqdcn, 	
			a.usro_crcn,		
			a.nmro_unco_idntfccn_empldr,
		 	a.cnsctvo_scrsl,
	 		a.cnsctvo_cdgo_clse_aprtnte,
		 	a.vlr_iva, 
			a.sldo_nta,
			f.dscrpcn_tpo_idntfccn,
			SPACE(200) AS rzn_scl,
	 		isnull(f.cnsctvo_cdgo_tpo_idntfccn,1) cnsctvo_cdgo_tpo_idntfccn, 
			a.cnsctvo_cdgo_tpo_nta,
			a.cnsctvo_cdgo_estdo_nta,
			a.fcha_crcn_nta,
			a.fcha_entrga_nta,
			a.cnsctvo_cdgo_tpo_dcmnto_nta_rntgro,
			g.cnsctvo_cdgo_pgo,
			g.cntro_csts,
			g.cnsctvo_cdgo_sde,
			SPACE(200) AS nmbre_sde,
			(select top 1 f.dscrpcn_cncpto_lqdcn nombre_concep
			from  tbNotasConceptos e,TbconceptosLiquidacion f
			where e.cnsctvo_cdgo_cncpto_lqdcn = f.cnsctvo_cdgo_cncpto_lqdcn
			and e.nmro_nta = a.nmro_nta
			AND e.cnsctvo_cdgo_tpo_nta = a.cnsctvo_cdgo_tpo_nta) AS dscrpcn_cncpto_lqdcn,
			g.fcha_pgo_acrddo
into #tmpNotasDebito
FROM        tbNotasPac a Left JOIN
   		    tbPeriodosliquidacion_Vigencias h 			ON 	a.cnsctvo_prdo 			= h.cnsctvo_cdgo_prdo_lqdcn Left JOIN
			bdAfiliacion.dbo.tbClasesAportantes i 		ON 	a.cnsctvo_cdgo_clse_aprtnte 	= i.cnsctvo_cdgo_clse_aprtnte Left JOIN
			tbEstadosNota e 							ON 	a.cnsctvo_cdgo_estdo_nta 	= e.cnsctvo_cdgo_estdo_nta  
			Left JOIN bdCarteraPac.dbo.TbDatosAportanteNotaReintegro g ON a.nmro_nta = g.nmro_nta Left JOIN
			bdAfiliacion.dbo.tbTiposIdentificacion f 	ON 	g.cdgo_tpo_idntfccn  	= f.cdgo_tpo_idntfccn 

WHERE       a.cnsctvo_cdgo_tpo_nta			=	3  
And	        (g.nmro_idntfccn = @lnNumeroIdentificacion)
And         f.cnsctvo_cdgo_tpo_idntfccn  = @tipoIdentificacion

 

exec spcr0EjecutaConsultaReintegros

drop table #tmpNotasDebito


