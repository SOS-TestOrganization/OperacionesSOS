

/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spcr2EjecutaConsultaReintegros
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento arma y ejecuta la cadena donde se tiene los criterios para seleccionar las notas  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003 / 02 / 10											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  Rolando Simbaqueva lasso		AM\>
* Descripcion			: <\DM aplicacion tecnicas de optimizacion 	DM\>
* Nuevos Parametros		: <\PM Nui del aportante 		 PM\>
* Nuevos Parametros		: <\PM Fecha de creacion inicial	  	 PM\>
* Nuevos Parametros		: <\PM Fecha de creacion final	  	 PM\>
* Nuevas Variables		: <\VM Empleador y fecha de creacion VM\>
* Fecha Modificacion		: <\FM  2005 / 08 / 24  FM\>
*---------------------------------------------------------------------------------*/
--exec spcr2EjecutaConsultaReintegros 100003,'20140304','20140306'
CREATE   PROCEDURE [dbo].[spcr2EjecutaConsultaReintegros]
	@lnNui				int,
	@lnFechaInicial			datetime,
	@lnFechaFinal			datetime
			
			

As

Declare
@ldfechaSistema	datetime

Set Nocount On
Set	@ldfechaSistema	=	getdate()
	

			


SELECT       a.nmro_nta,					e.dscrpcn_estdo_nta,			f.cdgo_tpo_idntfccn, 	d.nmro_idntfccn, 			i.dscrpcn_clse_aprtnte,
	         b.nmbre_scrsl, 				b.nmbre_scrsl  rzn_scl,			a.vlr_nta, 	
	         a.usro_crcn ,		
	         h.fcha_incl_prdo_lqdcn,		h.fcha_fnl_prdo_lqdcn, 	
             a.nmro_unco_idntfccn_empldr, 	a.cnsctvo_scrsl, 				a.cnsctvo_cdgo_clse_aprtnte, 	a.vlr_iva, 
	         a.sldo_nta, 					f.dscrpcn_tpo_idntfccn, 
  	         d.cnsctvo_cdgo_tpo_idntfccn, 
	         a.cnsctvo_cdgo_tpo_nta,
	         a.cnsctvo_cdgo_estdo_nta,
	         a.fcha_crcn_nta   fcha_crcn,
             g.fcha_pgo_acrddo
FROM        	 tbNotasPac a INNER JOIN
                      bdAfiliacion.dbo.tbSucursalesAportante b 	ON 	a.nmro_unco_idntfccn_empldr 	= b.nmro_unco_idntfccn_empldr AND a.cnsctvo_scrsl = b.cnsctvo_scrsl AND
                   						    	a.cnsctvo_cdgo_clse_aprtnte 	= b.cnsctvo_cdgo_clse_aprtnte INNER JOIN
                      bdAfiliacion.dbo.tbVinculados d 	      	ON 	a.nmro_unco_idntfccn_empldr 	= d.nmro_unco_idntfccn INNER JOIN
                      bdAfiliacion.dbo.tbTiposIdentificacion f 	ON 	d.cnsctvo_cdgo_tpo_idntfccn 	= f.cnsctvo_cdgo_tpo_idntfccn INNER JOIN
                      tbPeriodosliquidacion_Vigencias h 		ON 	a.cnsctvo_prdo 			= h.cnsctvo_cdgo_prdo_lqdcn INNER JOIN
                      bdAfiliacion.dbo.tbClasesAportantes i 	ON 	b.cnsctvo_cdgo_clse_aprtnte 	= i.cnsctvo_cdgo_clse_aprtnte INNER JOIN
                      tbEstadosNota e 				ON 	a.cnsctvo_cdgo_estdo_nta 	= e.cnsctvo_cdgo_estdo_nta  
                      Left JOIN bdCarteraPac.dbo.TbDatosAportanteNotaReintegro g ON a.nmro_nta = g.nmro_nta
WHERE    (datediff(dd,h.inco_vgnca,@ldfechaSistema)>=0  And datediff(dd,@ldfechaSistema,h.fn_vgnca)>=0 )
And	 cnsctvo_cdgo_tpo_nta			=	3  
And	 (datediff(dd,@lnFechaInicial,a.fcha_crcn_nta)>=0  And datediff(dd,a.fcha_crcn_nta,@lnFechaFinal)>=0 )
And	  a.nmro_unco_idntfccn_empldr		=	@lnNui	






