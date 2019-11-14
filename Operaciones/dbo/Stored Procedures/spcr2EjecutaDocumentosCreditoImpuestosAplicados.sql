
/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spcr2EjecutaDocumentosCreditoImpuestosAplicados
* Desarrollado por		: <\A Ing. FERNANDO VALENCIA E								A\>
* Descripcion			: <\D Este procedimiento trae la informacion de los documentos credito de impuestos  aplicados			  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P 													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2006/12/18 		
*-------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[spcr2EjecutaDocumentosCreditoImpuestosAplicados]
			@lnNumeroNotaIni		varchar(15),
			@lnNumeroNotaFin		varchar(15)


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
select  b.dscrpcn_tpo_dcmnto,
           a.nmro_nta,
           c.dscrpcn_estdo_nta,
           (a.vlr_nta+ a.vlr_iva),
           f.cdgo_tpo_idntfccn,
           e.nmro_idntfccn,
           i.dscrpcn_clse_aprtnte,
           d.nmbre_scrsl,
           space(100),
           a.fcha_crcn_nta,
           a.usro_crcn,
           a.nmro_unco_idntfccn_empldr,
           a.cnsctvo_scrsl,
           a.cnsctvo_cdgo_clse_aprtnte,
           a.cnsctvo_cdgo_tpo_nta,
           a.cnsctvo_cdgo_estdo_nta ,
           dgto_vrfccn,
           a.fcha_crcn_nta,
           5,
          a.sldo_nta
FROM         bdcarteraPac.dbo.tbNotasPac a INNER JOIN
                      bdcarteraPac.dbo.tbEstadosNota c ON a.cnsctvo_cdgo_estdo_nta = c.cnsctvo_cdgo_estdo_nta INNER JOIN
                      bdAfiliacion.dbo.tbSucursalesAportante d ON a.nmro_unco_idntfccn_empldr = d.nmro_unco_idntfccn_empldr AND a.cnsctvo_scrsl = d.cnsctvo_scrsl AND
                       a.cnsctvo_cdgo_clse_aprtnte = d.cnsctvo_cdgo_clse_aprtnte INNER JOIN
                      bdAfiliacion.dbo.tbVinculados e ON a.nmro_unco_idntfccn_empldr = e.nmro_unco_idntfccn INNER JOIN
                      bdAfiliacion.dbo.tbTiposIdentificacion f ON e.cnsctvo_cdgo_tpo_idntfccn = f.cnsctvo_cdgo_tpo_idntfccn INNER JOIN
                      bdAfiliacion.dbo.tbClasesAportantes i ON a.cnsctvo_cdgo_clse_aprtnte = i.cnsctvo_cdgo_clse_aprtnte CROSS JOIN
                      bdcarteraPac.dbo.tbTipoDocumentos b
WHERE     (a.cnsctvo_cdgo_estdo_nta = 4 OR
                      a.cnsctvo_cdgo_estdo_nta = 7) AND (a.usro_crcn <> 'Migracion01') AND (a.fcha_crcn_nta >= '20040209') AND (b.cnsctvo_cdgo_tpo_dcmnto = 5) AND 
                      (a.cnsctvo_cdgo_tpo_nta = 4)
And	  	(a.nmro_nta> = 	@lnNumeroNotaIni and  a.nmro_nta < =  @lnNumeroNotaFin)

			


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
 From	#TmpDocumentoCredito



