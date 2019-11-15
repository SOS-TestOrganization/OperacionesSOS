
/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spConsultaDocumentosDebito
* Desarrollado por		: <\A Ing. ROLANDO SIMBAQUEVA LASSO								A\>
* Descripcion			: <\D Este procedimiento realiza una la creacion de los contratos de  estados de cuenta		  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P 													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/02 											FC\>

* N.A   Andres Camelo illustrato (ltda) Se modifica para que traga los reintegros que tenga estados AUTORIZADA - APLICADA
**/
-- exec [spConsultaDocumentosDebitoXContrato] '2013/01/01','2014/12/01',2,4861 7606
CREATE  PROCEDURE [dbo].[spConsultaDocumentosDebitoXContrato]
	@Fecha_Inicial			Datetime	= NULL,
	@Fecha_Final			Datetime	= NULL,
	@cnsctvo_cdgo_tpo_cntrto	udtConsecutivo	=	NULL,
	@nmro_cntrto			udtNumeroFormulario	= NULL



As  			
set nocount on				

CREATE TABLE #tmpDocumentoDebito (
Dscrpcn_tpo_dcmnto	udtDescripcion
,nmro_dcto	varchar(100)
,fcha_gnrcn	datetime
,ttl_dcmnto	udtValorGrande
,Total_notas_credito	numeric
,total_Acumulado_Reintegro	numeric
,Valor_disponible	numeric
,vlr_rntgro	numeric
,cnsctvo_cdgo_tpo_dcmnto	udtConsecutivo
,Consecutivo_documento_origen	udtConsecutivo
,cnsctvo_cdgo_lqdcn udtConsecutivo
,nmro_dcto_pgado udtConsecutivo
,cnsctvo_cdgo_prdo_lqdcn numeric
,nmro_cntrto udtNumeroFormulario)


CREATE TABLE #tmpAcumuladoNotas(
cnsctvo_estdo_cnta_cntrto udtConsecutivo
,cnsctvo_prdo	udtConsecutivo
,nmro_cntrto	udtNumeroFormulario
,Acumulado_reintegro	numeric)

	
-- se trae la informacion de los estado de cuenta		
INSERT Into	#tmpDocumentoDebito
Select Dscrpcn_tpo_dcmnto,
	nmro_estdo_cnta  nmro_dcto,
	p.fcha_incl_prdo_lqdcn fcha_gnrcn,
	b.vlr_cbrdo ttl_dcmnto,
	convert(numeric(12,0),0)	Total_notas_credito,
	convert(numeric(12,0),0)	total_Acumulado_Reintegro,
	convert(numeric(12,0),0) Valor_disponible,
	convert(numeric(12,0),0) vlr_rntgro,
	cnsctvo_cdgo_tpo_dcmnto,
	cnsctvo_estdo_cnta_cntrto  Consecutivo_documento_origen,
	a.cnsctvo_cdgo_lqdcn,
	nmro_estdo_cnta  nmro_dcto_pgado,
	p.cnsctvo_cdgo_prdo_lqdcn,
	b.nmro_cntrto
From    tbestadosCuenta a, 	tbEstadosCuentaContratos b , tbtipodocumentos  c
,tbliquidaciones l, tbperiodosliquidacion_vigencias p
Where	a.cnsctvo_estdo_cnta	=	b.cnsctvo_estdo_cnta
And	c.cnsctvo_cdgo_tpo_dcmnto	=	1
And	a.cnsctvo_cdgo_lqdcn		=	l.cnsctvo_cdgo_lqdcn
And	l.cnsctvo_cdgo_prdo_lqdcn	=	p.cnsctvo_cdgo_prdo_lqdcn
And	b.cnsctvo_cdgo_tpo_cntrto	=	@cnsctvo_cdgo_tpo_cntrto
And	b.nmro_cntrto			    =	@nmro_cntrto
And	p.fcha_incl_prdo_lqdcn	between	  @Fecha_Inicial	and @Fecha_Final
And	(b.sldo <=	0 or a.cnsctvo_cdgo_estdo_estdo_cnta	= 3) --- Cancelado total


-- se insertan la informacion de las notas debito pendiente
Insert into #tmpDocumentoDebito
Select Dscrpcn_tpo_dcmnto,
	a.nmro_nta nmro_dcto,
	p.fcha_incl_prdo_lqdcn,
	b.vlr + b.vlr_iva ttl_dcmnto,
	convert(numeric(12,0),0) Total_notas_credito,
	convert(numeric(12,0),0) total_Acumulado_Reintegro,
	convert(numeric(12,0),0) Valor_disponible,
	convert(numeric(12,0),0) vlr_rntgro,
	cnsctvo_cdgo_tpo_dcmnto,
	cnsctvo_nta_cntrto	Consecutivo_documento_origen,
	a.cnsctvo_prdo,
	cnsctvo_estdo_cnta_cntrto  nmro_dcto_pgado,
	p.cnsctvo_cdgo_prdo_lqdcn,
	b.nmro_cntrto
from	tbNotasPac a, tbNotasContrato  b , tbtipodocumentos  c, tbperiodosliquidacion_vigencias p
Where   a.nmro_nta				=	b.nmro_nta
And	a.cnsctvo_cdgo_tpo_nta		=	b.cnsctvo_cdgo_tpo_nta
And	c.cnsctvo_cdgo_tpo_dcmnto	=	2
And	a.cnsctvo_cdgo_estdo_nta	=	3	--cancelada total
And	a.cnsctvo_prdo				=	p.cnsctvo_cdgo_prdo_lqdcn
And	b.cnsctvo_cdgo_tpo_cntrto	=	@cnsctvo_cdgo_tpo_cntrto
And	b.nmro_cntrto				=	@nmro_cntrto
And	p.fcha_incl_prdo_lqdcn	between	@Fecha_Inicial and @Fecha_Final


-- se calcula el valor acumulado de reintegros para los documentos

INSERT into	#tmpAcumuladoNotas
Select   a.cnsctvo_estdo_cnta_cntrto,0 'periodo',b.nmro_cntrto, sum(a.vlr_rntgro) Acumulado_reintegro
    From    tbCuentasContratoReintegro a, tbnotascontrato b,
       tbnotasPac c,#tmpDocumentoDebito d 
    where  a.vlr_rntgro > 0
    and   a.cnsctvo_nta_cntrto   =  b.cnsctvo_nta_cntrto
    And   b.cnsctvo_cdgo_tpo_nta =  c.cnsctvo_cdgo_tpo_nta
    And   b.nmro_nta             =  c.nmro_nta
    And   b.cnsctvo_cdgo_tpo_nta =  3  -- NOTA REINTEGRO
    And   a.cnsctvo_estdo_cnta_cntrto =  d.Consecutivo_documento_origen
    And   c.cnsctvo_cdgo_estdo_nta in  (4,8)  -- AUTORIZADA - APLICADA
--    And   d.cnsctvo_cdgo_tpo_dcmnto = 1
group by  a.cnsctvo_estdo_cnta_cntrto,b.nmro_cntrto





Update #tmpDocumentoDebito
Set	#tmpDocumentoDebito.total_Acumulado_Reintegro	=	b.Acumulado_reintegro
From	#tmpAcumuladoNotas  b
Where  rtrim(ltrim(#tmpDocumentoDebito.nmro_cntrto)) = rtrim(ltrim(b.nmro_cntrto))
And	    #tmpDocumentoDebito.Consecutivo_documento_origen	=	b.cnsctvo_estdo_cnta_cntrto


truncate table #tmpAcumuladoNotas

-- se calcula el valor acumulado de reintegros para los documentos
INSERT into	#tmpAcumuladoNotas
Select b.cnsctvo_estdo_cnta_cntrto,0 'a.cnsctvo_prdo',b.nmro_cntrto, sum(b.vlr + b.vlr_iva) Acumulado_reintegro
from	tbNotasPac a, tbNotasContrato  b,#tmpDocumentoDebito c
Where   a.nmro_nta    			=	b.nmro_nta
and	a.cnsctvo_cdgo_tpo_nta		=	b.cnsctvo_cdgo_tpo_nta
and a.cnsctvo_cdgo_tpo_nta      =   2  -- NOTA CREDITO
and b.cnsctvo_estdo_cnta_cntrto =   c.Consecutivo_documento_origen
--and c.cnsctvo_cdgo_lqdcn      =   a.cnsctvo_prdo
and b.nmro_cntrto               =   c.nmro_cntrto 
and a.cnsctvo_cdgo_estdo_nta in  (4,8)  
Group by   b.cnsctvo_estdo_cnta_cntrto,b.nmro_cntrto
union all
select c.Consecutivo_documento_origen,0,b.nmro_cntrto,sum(b.vlr + b.vlr_iva) Acumulado_reintegro
from tbNotasAplicadas a, tbNotasContrato b,#tmpDocumentoDebito c
where nmro_nta_aplcda = c.nmro_dcto
and a.nmro_nta        = b.nmro_nta
and b.nmro_cntrto     = c.nmro_cntrto 
and c.cnsctvo_cdgo_tpo_dcmnto = 2
and b.cnsctvo_cdgo_tpo_nta    = 2
group by c.Consecutivo_documento_origen,b.nmro_cntrto

Update #tmpDocumentoDebito
Set	#tmpDocumentoDebito.Total_notas_credito	=	b.Acumulado_reintegro
From	#tmpAcumuladoNotas  b
Where  rtrim(ltrim(#tmpDocumentoDebito.nmro_cntrto)) = rtrim(ltrim(b.nmro_cntrto))
And	    #tmpDocumentoDebito.Consecutivo_documento_origen	=	b.cnsctvo_estdo_cnta_cntrto



-- Se actualiza el Valor disponible	
Update #tmpDocumentoDebito
set  Valor_disponible = ttl_dcmnto - Total_notas_credito - total_Acumulado_Reintegro
From	#tmpDocumentoDebito a



Select Dscrpcn_tpo_dcmnto,
nmro_dcto,
fcha_gnrcn,
ttl_dcmnto,
Total_notas_credito,
total_Acumulado_Reintegro,
Valor_disponible,
vlr_rntgro,
cnsctvo_cdgo_tpo_dcmnto,
Consecutivo_documento_origen,
cnsctvo_cdgo_lqdcn,
nmro_cntrto
from #tmpDocumentoDebito


drop table #tmpDocumentoDebito
drop table #tmpAcumuladoNotas



