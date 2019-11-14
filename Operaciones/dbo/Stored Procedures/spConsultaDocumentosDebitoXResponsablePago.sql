
/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spConsultaDocumentosDebitoXResponsablePago
* Desarrollado por		: <\A Ing. ROLANDO SIMBAQUEVA LASSO								A\>
* Descripcion			: <\D Este procedimiento realiza una la creacion de los contratos de  estados de cuenta		  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P 													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/02 											FC\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por	: <\AM	Ing. Andres Camelo (illustrato ltda)			AM\>
* Descripcion		: <\DM	Se modifica para el valor disponible se actualice 			DM\>
* Nuevos Parametros	: <\PM	PM\>
* Nuevas Variables	: <\VM	VM\>
* Fecha Modificacion	: <\FM	2013/10/21						FM\>  
*---------------------------------------------------------------------------------
* Modificado Por	: <\AM	Ing. Andres Camelo (illustrato ltda)			AM\>
* Descripcion		: <\DM	modificacion para la consulta de los estados de cuenta traiga la fecha del periodo de liquidacion		DM\>
* Nuevos Parametros	: <\PM	PM\>
* Nuevas Variables	: <\VM	VM\>
* Fecha Modificacion	: <\FM	2013/10/15						FM\>  

*---------------------------------------------------------------------------------
* Modificado Por	: <\AM	Ing. Andres Camelo (illustrato ltda)			AM\>
* Descripcion		: <\DM	 modificacion para la consulta de las notas debito y los estados de cuenta consuelte el valor facturado con iva	DM\>
* Nuevos Parametros	: <\PM	PM\>
* Nuevas Variables	: <\VM	VM\>
* Fecha Modificacion	: <\FM	2013/10/18						FM\>  

*---------------------------------------------------------------------------------
* Modificado Por	: <\AM	Ing. Andres Camelo (illustrato ltda)			AM\>
* Descripcion		: <\DM	Se modifica para la consulta solo retorne las notas bedito por sucursal		DM\>
* Nuevos Parametros	: <\PM	PM\>
* Nuevas Variables	: <\VM	VM\>
* Fecha Modificacion	: <\FM	2013/11/20						FM\>  

**/
--exec [spConsultaDocumentosDebitoXResponsablePago] '20110101','20131201',1,30045029,1
CREATE PROCEDURE [dbo].[spConsultaDocumentosDebitoXResponsablePago]
	@Fecha_Inicial			Datetime	= NULL,
	@Fecha_Final			Datetime	= NULL,
	@cnsctvo_cdgo_clse_aprtnte	udtConsecutivo	=	NULL,
	@nmro_unco_idntfccn_empldr	udtConsecutivo	=	NUll,
	@cnsctvo_scrsl 			udtConsecutivo	=	NULL
	



As  			
set nocount on				

create table #tmpDocumentoDebito(
Dscrpcn_tpo_dcmnto            varchar(150),
nmro_dcto                     int,
fcha_gnrcn                    datetime,
ttl_dcmnto                    numeric(12,0),
Total_notas_credito           numeric(12,0),
Total_reintegro               numeric(12,0),
Valor_disponible              numeric(12,0),
vlr_rntgro                    numeric(12,0),
cnsctvo_cdgo_tpo_dcmnto       int,
Consecutivo_documento_origen  int,
total_Acumulado_Reintegro     numeric(12,0)
) 

	
/* Andres Camelo (illustrato ltda) 07/11/2013*/
/* Se actualiza el Valor disponible	*/
/* se insertan la informacion de las notas debito pendiente*/
Insert into #tmpDocumentoDebito
Select	c.Dscrpcn_tpo_dcmnto,
     	a.nmro_nta nmro_dcto,
        a.fcha_crcn_nta,
      	a.vlr_nta + a.vlr_iva	 ttl_dcmnto,
        convert(numeric(12,0),0)	Total_notas_credito,
        convert(numeric(12,0),0) Total_reintegro,
        convert(numeric(12,0),0) Valor_disponible,
        convert(numeric(12,0),0) vlr_rntgro,
 		c.cnsctvo_cdgo_tpo_dcmnto,
 	    convert(int,nmro_nta)	Consecutivo_documento_origen,
	    0
from	tbNotasPac a,  tbtipodocumentos  c
Where  	c.cnsctvo_cdgo_tpo_dcmnto	=	2		/*notas debito*/
And	a.nmro_unco_idntfccn_empldr	=	@nmro_unco_idntfccn_empldr
And	a.cnsctvo_scrsl			=	@cnsctvo_scrsl
And	a.cnsctvo_cdgo_clse_aprtnte	=	@cnsctvo_cdgo_clse_aprtnte
And	a.fcha_crcn_nta		between 	 @Fecha_Inicial	and @Fecha_Final
And	a.cnsctvo_cdgo_estdo_nta	=	3	/*cancelada total*/
and a.cnsctvo_cdgo_tpo_nta      =   1  /*notas debito*/
order by a.fcha_crcn_nta asc	


/* Andres Camelo (illustrato ltda) 20/11/2013*/
-- se eliminan las notas que aplican a contrato
Delete a from  #tmpDocumentoDebito a 
inner join tbNotasContrato b
on (a.Consecutivo_documento_origen   = b.nmro_nta)
where b.cnsctvo_cdgo_tpo_nta = 1   


/* Andres Camelo (illustrato ltda) 31/10/2013*/
/* Se actualiza el Valor disponible	*/
Update #tmpDocumentoDebito
set  Valor_disponible = ttl_dcmnto - Total_notas_credito - total_Acumulado_Reintegro
From	#tmpDocumentoDebito a


Select Dscrpcn_tpo_dcmnto,
nmro_dcto,
fcha_gnrcn,
ttl_dcmnto,
Total_notas_credito,
Total_reintegro,
Valor_disponible,
vlr_rntgro,
cnsctvo_cdgo_tpo_dcmnto,
Consecutivo_documento_origen,
total_Acumulado_Reintegro
from #tmpDocumentoDebito

drop table #tmpDocumentoDebito





/****** Objeto:  StoredProcedure [dbo].[spTraerDocumentosCreditoXDebito]    Fecha de la secuencia de comandos: 11/25/2013 10:53:24 ******/
SET ANSI_NULLS ON
