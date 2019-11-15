

/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spcr5EjecutaConsultaReintegros
* Desarrollado por		: <\A Jairo Valencia									A\>
* Descripcion			: <\D Este procedimiento arma y ejecuta la cadena donde se tiene los criterios para seleccionar las notas  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2013 / 10 / 01											FC\>
*
*---------------------------------------------------------------------------------*/
CREATE   PROCEDURE [dbo].[spcr5EjecutaConsultaReintegros]
	@lnnmro_unco_idntfccn_afldo		udtConsecutivo
			
			

As

Declare
@ldfechaSistema	datetime

Set Nocount On
Set	@ldfechaSistema	=	getdate()
	

select a.nmro_nta,a.cnsctvo_cdgo_tpo_nta
into #NotasComtrato
from tbNotasContrato a,bdafiliacion..Tbcontratos b
WHERE a.cnsctvo_cdgo_tpo_nta = 3  			
and a.nmro_cntrto = b.nmro_cntrto
and	a.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
and	a.cnsctvo_cdgo_tpo_cntrto	= 2
and b.nmro_unco_idntfccn_afldo = @lnnmro_unco_idntfccn_afldo



SELECT      a.nmro_nta,
		    e.dscrpcn_estdo_nta,
		    isnull(f.cdgo_tpo_idntfccn,g.cdgo_tpo_idntfccn) cdgo_tpo_idntfccn,
		 	isnull(d.nmro_idntfccn,g.nmro_idntfccn) nmro_idntfccn,
 			isnull(i.dscrpcn_clse_aprtnte,'INDEPENDIENTE') dscrpcn_clse_aprtnte,
			isnull(b.nmbre_scrsl,(isnull(ltrim(rtrim(prmr_nmbre)),' ') + ' ' +isnull(ltrim(rtrim(sgndo_nmbre)),' ') + ' ' + isnull(ltrim(rtrim(prmr_aplldo)),' ') + ' ' + isnull(ltrim(rtrim(sgndo_aplldo)),' '))) nmbre_scrsl,
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
	 		isnull(d.cnsctvo_cdgo_tpo_idntfccn,1) cnsctvo_cdgo_tpo_idntfccn, 
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
			bdAfiliacion.dbo.tbSucursalesAportante b 	ON 	a.nmro_unco_idntfccn_empldr 	= b.nmro_unco_idntfccn_empldr AND a.cnsctvo_scrsl = b.cnsctvo_scrsl AND
															a.cnsctvo_cdgo_clse_aprtnte 	= b.cnsctvo_cdgo_clse_aprtnte Left JOIN
			bdAfiliacion.dbo.tbVinculados d 	      	ON 	a.nmro_unco_idntfccn_empldr 	= d.nmro_unco_idntfccn Left JOIN
			bdAfiliacion.dbo.tbTiposIdentificacion f 	ON 	isnull(d.cnsctvo_cdgo_tpo_idntfccn,1) 	= f.cnsctvo_cdgo_tpo_idntfccn Left JOIN
			tbPeriodosliquidacion_Vigencias h 			ON 	a.cnsctvo_prdo 			= h.cnsctvo_cdgo_prdo_lqdcn Left JOIN
			bdAfiliacion.dbo.tbClasesAportantes i 		ON 	b.cnsctvo_cdgo_clse_aprtnte 	= i.cnsctvo_cdgo_clse_aprtnte Left JOIN
			tbEstadosNota e 							ON 	a.cnsctvo_cdgo_estdo_nta 	= e.cnsctvo_cdgo_estdo_nta INNER JOIN  
			#NotasComtrato                              ON  (#NotasComtrato.nmro_nta = a.nmro_nta and #NotasComtrato.cnsctvo_cdgo_tpo_nta = a.cnsctvo_cdgo_tpo_nta) 
			Left JOIN bdCarteraPac.dbo.TbDatosAportanteNotaReintegro g ON a.nmro_nta = g.nmro_nta
WHERE       a.cnsctvo_cdgo_tpo_nta			=	3  


exec spcr0EjecutaConsultaReintegros

drop table #tmpNotasDebito
drop table #NotasComtrato