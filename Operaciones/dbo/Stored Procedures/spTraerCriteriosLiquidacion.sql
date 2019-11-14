/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spTraerCriteriosLiquidacion
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento arma y ejecuta la cadena donde se tiene los criterios para seleccionar los promotores y sus sucursales 	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003/02/10											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  FM\>
*---------------------------------------------------------------------------------*/
CREATE  PROCEDURE spTraerCriteriosLiquidacion
		@cnsctvo_cdgo_lqdcn	udtConsecutivo

As



--Se trae informacion de la liquidacion
SELECT     b.cnsctvo_scrsl,			 a.cdgo_tpo_idntfccn, 		d.nmro_idntfccn,		 c.dscrpcn_clse_aprtnte, 
                   b.nmbre_scrsl, 			 'SELECCIONADO'  	 accn ,
            	      b.sde_crtra_pc	 		cnsctvo_cdgo_sde , 
	     a.dscrpcn_tpo_idntfccn,		 SPACE(200) AS rzn_scl, 
	     d.cnsctvo_cdgo_tpo_idntfccn,		 b.nmro_unco_idntfccn_empldr, 
                  b.cnsctvo_cdgo_clse_aprtnte
FROM         bdAfiliacion.dbo.tbTiposIdentificacion a INNER JOIN       bdAfiliacion.dbo.tbVinculados d 
				ON a.cnsctvo_cdgo_tpo_idntfccn = d.cnsctvo_cdgo_tpo_idntfccn
						 INNER JOIN       bdAfiliacion.dbo.tbSucursalesAportante b
				ON d.nmro_unco_idntfccn = b.nmro_unco_idntfccn_empldr
						  INNER JOIN tbcriteriosliquidacion    e
				On  e.nmro_unco_idntfccn_empldr =	b.nmro_unco_idntfccn_empldr	And
				       e.cnsctvo_scrsl		=  	b.cnsctvo_scrsl			And
				       e.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte		
					 	 INNER JOIN       bdAfiliacion.dbo.tbClasesAportantes c 
				ON b.cnsctvo_cdgo_clse_aprtnte = c.cnsctvo_cdgo_clse_aprtnte 
Where 	e.cnsctvo_cdgo_lqdcn	=	@cnsctvo_cdgo_lqdcn