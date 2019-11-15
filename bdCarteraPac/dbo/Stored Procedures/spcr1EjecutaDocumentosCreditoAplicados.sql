

/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spcr1EjecutaDocumentosCreditoAplicados
* Desarrollado por		: <\A Ing. ROLANDO SIMBAQUEVA LASSO								A\>
* Descripcion			: <\D Este procedimiento trae la informacion de los documentos credito aplicados			  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P 													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/02 		

* Modificado	 por		: <\A Ing. ROLANDO SIMBAQUEVA LASSO								A\>
* Descripcion			: <\DAplicacion de tecnicas de optimizacion			  					D\>
* Observaciones			: <\O  	Numero de pago											O\>
* Parametros			: <\P 													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2004/08/25 											FC\>
**/

CREATE PROCEDURE [dbo].[spcr1EjecutaDocumentosCreditoAplicados]
			@lnNumeroPagoIni		udtConsecutivo,
			@lnNumeroPagoFin		udtConsecutivo


As  			
set nocount on				
	
Create table	#TmpDocumentoCredito
( dscrpcn_tpo_dcmnto varchar(50),
  nmro_dcmto  varchar(15),
  dscrpcn_Estdo_dcmnto varchar(50),
  vlr_dcmnto  numeric(12,0),
  cdgo_tpo_idntfccn char(3), 	
  nmro_idntfccn varchar(20),
  dscrpcn_clse_aprtnte varchar(50),
  nmbre_scrsl	     varchar(100)		,
  rzn_scl	     varchar(200)		,
  fcha_crcn datetime,
  usro_crcn  char(30),
  nmro_unco_idntfccn_empldr int,
  cnsctvo_scrsl int,
  cnsctvo_cdgo_clse_aprtnte int,
  cnsctvo_cdgo_tpo_nta	int,
  cnsctvo_cdgo_estdo_nta int,
  dgto_vrfccn int,
  fcha_crcn_nta  datetime,
  cnsctvo_cdgo_tpo_dcmnto int,
  sldo_dcmnto numeric(12,0))
	

insert	into #TmpDocumentoCredito
select    b.dscrpcn_tpo_dcmnto,
	convert(varchar(15),cnsctvo_cdgo_pgo),
	c.dscrpcn_estdo_pgo,
	a.vlr_dcmnto,
	f.cdgo_tpo_idntfccn,
	e.nmro_idntfccn,
	i.dscrpcn_clse_aprtnte,
	d.nmbre_scrsl,
	space(100),
	a.fcha_crcn,
	a.usro_crcn,
	a.nmro_unco_idntfccn_empldr,
	a.cnsctvo_scrsl,
	a.cnsctvo_cdgo_clse_aprtnte,
	0,
	0,
	dgto_vrfccn,
	a.fcha_crcn,
	4,
	a.sldo_pgo
FROM         bdcarteraPac.dbo.tbPagos a INNER JOIN
                      tbEstadosPago c ON a.cnsctvo_cdgo_estdo_pgo = c.cnsctvo_cdgo_estdo_pgo INNER JOIN
                      bdAfiliacion.dbo.tbSucursalesAportante d ON a.nmro_unco_idntfccn_empldr = d.nmro_unco_idntfccn_empldr AND a.cnsctvo_scrsl = d.cnsctvo_scrsl AND
                       a.cnsctvo_cdgo_clse_aprtnte = d.cnsctvo_cdgo_clse_aprtnte INNER JOIN
                      bdAfiliacion.dbo.tbVinculados e ON a.nmro_unco_idntfccn_empldr = e.nmro_unco_idntfccn INNER JOIN
                      bdAfiliacion.dbo.tbTiposIdentificacion f ON e.cnsctvo_cdgo_tpo_idntfccn = f.cnsctvo_cdgo_tpo_idntfccn INNER JOIN
                      bdAfiliacion.dbo.tbClasesAportantes i ON a.cnsctvo_cdgo_clse_aprtnte = i.cnsctvo_cdgo_clse_aprtnte CROSS JOIN
                      bdcarterapac.dbo.tbTipoDocumentos b
WHERE     (a.cnsctvo_cdgo_estdo_pgo <> 1) AND (a.usro_crcn <> 'Migracion01') AND (b.cnsctvo_cdgo_tpo_dcmnto = 4)
And	a.cnsctvo_cdgo_pgo >= @lnNumeroPagoIni and a.cnsctvo_cdgo_pgo < =  @lnNumeroPagoFin


Update 	#TmpDocumentoCredito
Set  	rzn_scl	     =  c.rzn_scl
From 	#TmpDocumentoCredito a inner join   bdAfiliacion.dbo.tbempleadores b
	on (a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn) 
	inner join  bdAfiliacion.dbo.tbempresas c
	on(a.nmro_unco_idntfccn_empldr		=	c.nmro_unco_idntfccn)


Update 	#TmpDocumentoCredito
Set  	rzn_scl	     =   ltrim(rtrim(isnull(prmr_aplldo,'')))  + ' ' + ltrim(rtrim(isnull(sgndo_aplldo,''))) + ' ' + ltrim(rtrim(isnull(prmr_nmbre,''))) + ' ' + ltrim(rtrim(isnull(sgndo_nmbre,'')))
From 	#TmpDocumentoCredito a	inner join bdAfiliacion.dbo.tbempleadores b
	on (a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn) 
	inner join		bdAfiliacion.dbo.tbpersonas c
	on (a.nmro_unco_idntfccn_empldr		=	c.nmro_unco_idntfccn)





select 	  dscrpcn_tpo_dcmnto,
	  nmro_dcmto ,
	  dscrpcn_Estdo_dcmnto ,
	  vlr_dcmnto ,
	  cdgo_tpo_idntfccn ,
	  nmro_idntfccn ,
	  dscrpcn_clse_aprtnte ,
	  nmbre_scrsl	     ,
	  rzn_scl	   ,
	  fcha_crcn ,
	  usro_crcn  ,
	  nmro_unco_idntfccn_empldr,
	  cnsctvo_scrsl ,
	  cnsctvo_cdgo_clse_aprtnte,
	  cnsctvo_cdgo_tpo_nta,
	  cnsctvo_cdgo_estdo_nta,
	  dgto_vrfccn,
	  fcha_crcn_nta  ,
	  cnsctvo_cdgo_tpo_dcmnto,
	  sldo_dcmnto 
 from	#TmpDocumentoCredito



