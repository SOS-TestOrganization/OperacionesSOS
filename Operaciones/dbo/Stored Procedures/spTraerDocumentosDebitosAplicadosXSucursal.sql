/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spTraerDocumentosDebitosAplicadosXSucursal
* Desarrollado por		: <\A Ing. ROLANDO SIMBAQUEVA LASSO								A\>
* Descripcion			: <\D Este procedimiento Consulta los documentos debitos que tiene aplicado  para aplicar los credito			  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P 													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/02 											FC\>
**/

CREATE PROCEDURE spTraerDocumentosDebitosAplicadosXSucursal
		@nmro_nta 			Varchar(15),
		@cnsctvo_cdgo_tpo_nta		UdtConsecutivo
	



As  			
set nocount on				
	
-- se trae la informacion de los estado de cuenta		
Select 	 Dscrpcn_tpo_dcmnto,	nmro_estdo_cnta	 nmro_dcto,	 vlr	 ttl_dcmnto   ,cnsctvo_cdgo_tpo_dcmnto ,	 
	c.cnsctvo_estdo_cnta 	 Consecutivo_documento_origen , cnsctvo_cdgo_estdo_estdo_cnta  estado_documento 
Into	#tmpDocumentoDebitoAplicados
From 	  tbnotasEstadoCuenta  a	,	 tbtipoDocumentos  b  ,  tbEstadoscuenta  c
Where	b.cnsctvo_cdgo_tpo_dcmnto	=	1	-- estados de cuenta
And	a.nmro_nta			=	@nmro_nta
And	a.cnsctvo_cdgo_tpo_nta		=	@cnsctvo_cdgo_tpo_nta
And	a.cnsctvo_estdo_cnta		=	c.cnsctvo_estdo_cnta



-- se insertan la informacion de las notas debito pendiente
Insert into #tmpDocumentoDebitoAplicados
Select	Dscrpcn_tpo_dcmnto,	a.nmro_nta_aplcda   nmro_dcto,	 vlr_aplcdo	 ttl_dcmnto   ,  	cnsctvo_cdgo_tpo_dcmnto,	
	convert(int,a.nmro_nta_aplcda)	Consecutivo_documento_origen  , 	cnsctvo_cdgo_estdo_nta	estado_documento
from	tbnotasaplicadas a  , tbtipoDocumentos b , tbnotasPac c
Where  	b.cnsctvo_cdgo_tpo_dcmnto	=	2		--notas debito
And	a.nmro_nta			=	@nmro_nta
And	a.cnsctvo_cdgo_tpo_nta		=	@cnsctvo_cdgo_tpo_nta
And	a.nmro_nta_aplcda		=	c.nmro_nta
and	a.cnsctvo_cdgo_tpo_nta_aplcda		=	1	--notas debito
And	a.cnsctvo_cdgo_tpo_nta_aplcda	=	c.cnsctvo_cdgo_tpo_nta



Select * from #tmpDocumentoDebitoAplicados