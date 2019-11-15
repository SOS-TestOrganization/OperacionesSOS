/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spTraerDocumentosDebitosAplicadosXPago
* Desarrollado por		: <\A Ing. ROLANDO SIMBAQUEVA LASSO								A\>
* Descripcion			: <\D Este procedimiento Consulta los documentos debitos que tiene aplicado  el pago			  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P 													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/02 											FC\>
**/

CREATE PROCEDURE spTraerDocumentosDebitosAplicadosXPago
		@cnsctvo_cdgo_pgo 	UdtConsecutivo
	


As  			
set nocount on				
	





-- se trae la informacion de los estado de cuenta		
Select 	 Dscrpcn_tpo_dcmnto,	nmro_estdo_cnta	 nmro_dcto,	(vlr_abno)	 ttl_dcmnto   ,cnsctvo_cdgo_tpo_dcmnto ,	 
	 c.cnsctvo_estdo_cnta 	 Consecutivo_documento_origen , cnsctvo_cdgo_estdo_estdo_cnta  estado_documento 
Into	#tmpDocumentoDebitoAplicados
From 	tbAbonos  a	,	 tbtipoDocumentos  b  ,  tbEstadoscuenta  c
Where	b.cnsctvo_cdgo_tpo_dcmnto	=	1	-- estados de cuenta
And	a.cnsctvo_estdo_cnta		=	c.cnsctvo_estdo_cnta
And	a.cnsctvo_cdgo_pgo		=	@cnsctvo_cdgo_pgo





-- se insertan la informacion de las notas debito pendiente
Insert into #tmpDocumentoDebitoAplicados
Select	Dscrpcn_tpo_dcmnto,	a.nmro_nta   nmro_dcto,	 vlr	 ttl_dcmnto   ,  	cnsctvo_cdgo_tpo_dcmnto,	
	convert(int,a.nmro_nta)	Consecutivo_documento_origen  , 	cnsctvo_cdgo_estdo_nta	estado_documento
From	TbPagosNotas a  , tbtipoDocumentos b , tbnotasPac c
Where  	b.cnsctvo_cdgo_tpo_dcmnto	=	2		--notas debito
And	a.cnsctvo_cdgo_tpo_nta		=	c.cnsctvo_cdgo_tpo_nta
And	a.nmro_nta			=	c.nmro_nta
And	a.cnsctvo_cdgo_pgo		=	@cnsctvo_cdgo_pgo




Select * from #tmpDocumentoDebitoAplicados