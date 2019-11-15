
/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spcr1EjecutaConsultaDocumentosCreditoXaplicar
* Desarrollado por		: <\A Ing. ROLANDO SIMBAQUEVA LASSO								A\>
* Descripcion			: <\D Este procedimiento realiza la consulta de los documentos credito				  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P 													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/02 											FC\>

* Modificado  por		: <\A Ing. ROLANDO SIMBAQUEVA LASSO								A\>
* Descripcion			: <\D Aplicacion de tecnicas de optimizacion							  	D\>
* Observaciones			: <\O Empleador y fecha de creacion 													O\>
* Parametros			: <\P 													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/02 											FC\>

**/

CREATE PROCEDURE [dbo].[spcr1EjecutaConsultaDocumentosCreditoXaplicar]
			@Nui		int,
			@FechaIni	Datetime,
			@FechaFin	Datetime
		
As  			
set nocount on				
	
-- sin aplicar	
-- aplicada parcial
--notas Credito	
Create Table #tmpDocumentosCredito
(  nmro_nta varchar(15), 	dscrpcn_estdo_nta varchar(50),  cdgo_tpo_idntfccn char(4),  nmro_idntfccn varchar(20),
dscrpcn_clse_aprtnte  varchar(50),
   nmbre_scrsl varchar(150) ,  vlr_nta numeric(12,0),  fcha_incl_prdo_lqdcn datetime,  fcha_fnl_prdo_lqdcn datetime,
   usro_crcn char(30), nmro_unco_idntfccn_empldr int,	cnsctvo_scrsl int,  cnsctvo_cdgo_clse_aprtnte int,
   vlr_iva numeric(12,0),	sldo_nta numeric (12,0) , dscrpcn_tpo_idntfccn varchar(50) ,
   fcha_crcn_nta 	datetime,  rzn_scl  varchar(200), cnsctvo_cdgo_tpo_idntfccn int,
   cnsctvo_cdgo_tpo_nta int,
   cnsctvo_cdgo_estdo_nta	int,
   dgto_vrfccn   int,
   ExisteContratos int	  )

   	
Insert  into  #tmpDocumentosCredito
SELECT         a.nmro_nta,				 e.dscrpcn_estdo_nta,		 f.cdgo_tpo_idntfccn, 	d.nmro_idntfccn, 			i.dscrpcn_clse_aprtnte,
	          b.nmbre_scrsl, 			a.vlr_nta, 	
	         h.fcha_incl_prdo_lqdcn,		 h.fcha_fnl_prdo_lqdcn, 	
	         a.usro_crcn,		
                      a.nmro_unco_idntfccn_empldr, 	a.cnsctvo_scrsl, 		a.cnsctvo_cdgo_clse_aprtnte, 	a.vlr_iva, 
	         a.sldo_nta, 					f.dscrpcn_tpo_idntfccn, 
                       a.fcha_crcn_nta,
	         SPACE(200) AS rzn_scl, 		d.cnsctvo_cdgo_tpo_idntfccn, 
	         a.cnsctvo_cdgo_tpo_nta,
	         a.cnsctvo_cdgo_estdo_nta,
	         d.dgto_vrfccn,
	         0	ExisteContratos	
FROM            bdcarteraPac.dbo.tbNotasPac a INNER JOIN
                      bdAfiliacion.dbo.tbSucursalesAportante b 	ON 	a.nmro_unco_idntfccn_empldr 	= b.nmro_unco_idntfccn_empldr AND a.cnsctvo_scrsl = b.cnsctvo_scrsl AND
                   						    	a.cnsctvo_cdgo_clse_aprtnte 	= b.cnsctvo_cdgo_clse_aprtnte INNER JOIN
                      bdAfiliacion.dbo.tbVinculados d 	      	ON 	a.nmro_unco_idntfccn_empldr 	= d.nmro_unco_idntfccn INNER JOIN
	         bdAfiliacion.dbo.tbTiposIdentificacion f 	ON 	d.cnsctvo_cdgo_tpo_idntfccn 	= f.cnsctvo_cdgo_tpo_idntfccn INNER JOIN
                      bdcarteraPac.dbo.tbPeriodosliquidacion_Vigencias h 		ON 	a.cnsctvo_prdo 			= h.cnsctvo_cdgo_prdo_lqdcn INNER JOIN
                      bdAfiliacion.dbo.tbClasesAportantes i 	ON 	b.cnsctvo_cdgo_clse_aprtnte 	= i.cnsctvo_cdgo_clse_aprtnte INNER JOIN
                      tbEstadosNota e 				ON 	a.cnsctvo_cdgo_estdo_nta 	= e.cnsctvo_cdgo_estdo_nta  
WHERE       (a.cnsctvo_cdgo_estdo_nta 			=		5	  
 	        Or	        a.cnsctvo_cdgo_estdo_nta		=	 	7 )   
And	        a.cnsctvo_cdgo_tpo_nta			=		2	
And	        @Nui					=		a.nmro_unco_idntfccn_empldr
And	        (datediff(dd,@FechaIni,a.fcha_crcn_nta)>=0  And datediff(dd,a.fcha_crcn_nta,@FechaFin)>=0 )

	


--Verifica si la nota fue hecha a nivel de contrato, es decir tiene contratos asociados
Update #tmpDocumentosCredito
Set	ExisteContratos	=	1
From	#tmpDocumentosCredito a inner join  bdcarteraPac.dbo.TbnotasContrato b
	on (a.nmro_nta			=	b.nmro_nta
	and	a.cnsctvo_cdgo_tpo_nta		=	b.cnsctvo_cdgo_tpo_nta)



Update 	#tmpDocumentosCredito
Set	 rzn_scl	 =  c.rzn_scl
From 	#tmpDocumentosCredito	 a	inner join bdAfiliacion.dbo.tbempleadores b
	on 	(a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn
		And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte )
	inner join 	bdAfiliacion.dbo.tbempresas c  
	on (a.nmro_unco_idntfccn_empldr		=	c.nmro_unco_idntfccn)


Update 	#tmpDocumentosCredito
Set	 rzn_scl	 =   ltrim(rtrim(isnull(prmr_aplldo,'')))  + ' ' + ltrim(rtrim(isnull(sgndo_aplldo,''))) + ' ' + ltrim(rtrim(isnull(prmr_nmbre,''))) + ' ' + ltrim(rtrim(isnull(sgndo_nmbre,'')))
From 	#tmpDocumentosCredito	 a	inner join  bdAfiliacion.dbo.tbempleadores b
	on 	(a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn
		And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte ) 
	inner 	join 	bdAfiliacion.dbo.tbpersonas c 
	on 	(a.nmro_unco_idntfccn_empldr		=	c.nmro_unco_idntfccn)



Select    dscrpcn_tpo_dcmnto,	 	a.nmro_nta    nmro_dcmto, 			dscrpcn_estdo_nta      dscrpcn_Estdo_dcmnto, 			
	a.sldo_nta	 sldo_dcmnto  ,  	 a.cdgo_tpo_idntfccn, 	
	a.nmro_idntfccn, 		 	a.dscrpcn_clse_aprtnte,		a.nmbre_scrsl, 				a.rzn_scl,	
	convert(char(20),replace(convert(char(20),a.fcha_crcn_nta,120),'-','/'))		 fcha_crcn_nta	,	a.usro_crcn,
	a.cnsctvo_cdgo_estdo_nta  ,	a.cnsctvo_cdgo_tpo_nta,
             a.nmro_unco_idntfccn_empldr, 	a.cnsctvo_scrsl, 			a.cnsctvo_cdgo_clse_aprtnte, 		a.vlr_nta vlr_dcmnto ,  	dgto_vrfccn,
	b.cnsctvo_cdgo_tpo_dcmnto,
	a.ExisteContratos
From	 #tmpDocumentosCredito a,  bdcarterapac.dbo.tbtipodocumentos  b
Where	b.cnsctvo_cdgo_tpo_dcmnto	=	3
