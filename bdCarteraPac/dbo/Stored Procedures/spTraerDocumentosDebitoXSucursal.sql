/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spConsultaDocumentosDebitoXResponsablePago
* Desarrollado por		: <\A Ing. ROLANDO SIMBAQUEVA LASSO								A\>
* Descripcion			: <\D Este procedimiento Consulta los documentos debitos para aplicar los credito			  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P 													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/02 											FC\>
**/

CREATE PROCEDURE spTraerDocumentosDebitoXSucursal
	@cnsctvo_cdgo_clse_aprtnte	udtConsecutivo	=	NULL,
	@nmro_unco_idntfccn_empldr	udtConsecutivo	=	NULL,
	@cnsctvo_scrsl 			udtConsecutivo	=	NULL
	



As  			
set nocount on				
	
-- se trae la informacion de los estado de cuenta		
Select  Dscrpcn_tpo_dcmnto,	nmro_estdo_cnta nmro_dcto,	 a.sldo_estdo_cnta	 ttl_dcmnto   , convert(numeric(12,0),0) vlr_aplcr	,cnsctvo_cdgo_tpo_dcmnto ,	 cnsctvo_estdo_cnta 	 Consecutivo_documento_origen ,
	1	contiene_contratos
Into	#tmpDocumentoDebito
From    tbestadosCuenta a, 	 tbtipodocumentos  c,
	tbliquidaciones l 
Where	c.cnsctvo_cdgo_tpo_dcmnto	=	1	-- estados de cuenta
And	a.nmro_unco_idntfccn_empldr	=	@nmro_unco_idntfccn_empldr
And	a.cnsctvo_scrsl			=	@cnsctvo_scrsl
And	a.cnsctvo_cdgo_clse_aprtnte	=	@cnsctvo_cdgo_clse_aprtnte
And	a.cnsctvo_cdgo_lqdcn		=	l.cnsctvo_cdgo_lqdcn
And	l.cnsctvo_cdgo_estdo_lqdcn	=	3   --Finalizada..
And	a.sldo_estdo_cnta		>	0
And	a.cnsctvo_estdo_cnta	>   0



-- se insertan la informacion de las notas debito pendiente

Select	Dscrpcn_tpo_dcmnto,	a.nmro_nta nmro_dcto,	 sldo_nta	 ttl_dcmnto   ,  convert(numeric(12,0),0) vlr_aplcr,		cnsctvo_cdgo_tpo_dcmnto,	convert(int,nmro_nta)	Consecutivo_documento_origen,
	0	contiene_contratos
into	#tmpNotasDebito
from	tbNotasPac a,  tbtipodocumentos  c
Where  	c.cnsctvo_cdgo_tpo_dcmnto	=	2		--notas debito
And	a.nmro_unco_idntfccn_empldr	=	@nmro_unco_idntfccn_empldr
And	a.cnsctvo_scrsl			=	@cnsctvo_scrsl
And	a.cnsctvo_cdgo_clse_aprtnte	=	@cnsctvo_cdgo_clse_aprtnte
and	a.cnsctvo_cdgo_tpo_nta		=	1	--notas debito
And	a.cnsctvo_cdgo_estdo_nta	<>	6	--Anulada
And	sldo_nta				>	0


-- Se verifica si las notas debito tiene asociado contratos
Update #tmpNotasDebito
Set	contiene_contratos	=	1
From	#tmpNotasDebito a,  tbnotasContrato b
Where	ltrim(rtrim(a.nmro_dcto))		=	rtrim(ltrim(b.nmro_nta))
And	b.cnsctvo_cdgo_tpo_nta		=	1


Insert into #tmpDocumentoDebito
Select	Dscrpcn_tpo_dcmnto,	 nmro_dcto,	  ttl_dcmnto   ,   vlr_aplcr,		cnsctvo_cdgo_tpo_dcmnto,		Consecutivo_documento_origen,
	contiene_contratos
from	#tmpNotasDebito


Select * from #tmpDocumentoDebito