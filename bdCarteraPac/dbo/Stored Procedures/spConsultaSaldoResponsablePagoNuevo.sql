
CREATE  PROCEDURE [dbo].[spConsultaSaldoResponsablePagoNuevo]
(
	@cnsctvo_cdgo_clse_aprtnte	udtConsecutivo	=	NULL,
	@nmro_unco_idntfccn_empldr	udtConsecutivo	=	NULL,
	@cnsctvo_scrsl 			udtConsecutivo	=	NULL,
	@SaldoResponsable		numeric(12,0)	output
)
As  			
set nocount on					

Select		Dscrpcn_tpo_dcmnto,	nmro_estdo_cnta 	nmro_dcto,	
			p.fcha_incl_prdo_lqdcn   Fcha_dcmnto,		dscrpcn_estdo_estdo_cnta,
			a.ttl_pgr			ttl_dcmnto,
			a.sldo_estdo_cnta	sldo_dcmnto  ,
			case when nmro_estdo_cnta <> '0'  then 1 else 0	end estado,
			c.cnsctvo_cdgo_tpo_dcmnto,
			a.cnsctvo_estdo_cnta  	cnsctvo_dcmnto
Into		#tmpDocumentoDebito
From		tbestadosCuenta a	 
inner join	tbtipodocumentos  c
on			a.cnsctvo_cdgo_tpo_dcmnto = c.cnsctvo_cdgo_tpo_dcmnto
inner join	tbestadosEstadosCuenta b
on			a.cnsctvo_cdgo_estdo_estdo_cnta = b.cnsctvo_cdgo_estdo_estdo_cnta
inner join	tbliquidaciones l
on			a.cnsctvo_cdgo_lqdcn = l.cnsctvo_cdgo_lqdcn
inner join	tbperiodosliquidacion_vigencias p
on			l.cnsctvo_cdgo_prdo_lqdcn = p.cnsctvo_cdgo_prdo_lqdcn
Where		c.cnsctvo_cdgo_tpo_dcmnto in (1,6)	-- estados de cuenta o factura
And			a.nmro_unco_idntfccn_empldr =	@nmro_unco_idntfccn_empldr
And			a.cnsctvo_scrsl = @cnsctvo_scrsl
And			a.cnsctvo_cdgo_clse_aprtnte =	@cnsctvo_cdgo_clse_aprtnte
And			a.cnsctvo_estdo_cnta > 0
And			l.cnsctvo_cdgo_estdo_lqdcn in	(3,6)   --Finalizada..
And			a.cnsctvo_cdgo_estdo_estdo_cnta	<>	4	--Anulada



-- se insertan la informacion de las notas debito pendiente
Insert into #tmpDocumentoDebito
Select	Dscrpcn_tpo_dcmnto,	a.nmro_nta nmro_dcto,
	fcha_crcn_nta, 		dscrpcn_estdo_nta,
	(vlr_nta +   vlr_iva),  
	sldo_nta,
	1	,
	c.cnsctvo_cdgo_tpo_dcmnto,
	convert(int,nmro_nta)  
from	tbNotasPac a,  tbtipodocumentos  c , TbestadosNota b
Where  	c.cnsctvo_cdgo_tpo_dcmnto	=	2		--notas debito
And	a.nmro_unco_idntfccn_empldr	=	@nmro_unco_idntfccn_empldr
And	a.cnsctvo_scrsl			=	@cnsctvo_scrsl
And	a.cnsctvo_cdgo_clse_aprtnte	=	@cnsctvo_cdgo_clse_aprtnte
And	a.cnsctvo_cdgo_estdo_nta	=	b.cnsctvo_cdgo_estdo_nta
and	a.cnsctvo_cdgo_tpo_nta		=	1	--notas debito
--And	sldo_nta				>	0
And	a.cnsctvo_cdgo_estdo_nta	<>	6	--Anulada

-- 2013-12-19 Andres Camelo (illustrato ltda)	
-- actualizacion de estados segun el saldo de los documentos
Update #tmpDocumentoDebito
Set	dscrpcn_estdo_estdo_cnta	=	'CANCELADA TOTAL'
Where	sldo_dcmnto			<=	0


Update #tmpDocumentoDebito
Set	dscrpcn_estdo_estdo_cnta	=	'CANCELADA PARCIAL'
Where	sldo_dcmnto			>	0
AND	ttl_dcmnto			>	sldo_dcmnto

Update #tmpDocumentoDebito
Set	dscrpcn_estdo_estdo_cnta	=	'INGRESADA'
Where	sldo_dcmnto			>	0
AND	ttl_dcmnto			=	sldo_dcmnto
and     dscrpcn_estdo_estdo_cnta	<>     'INGRESADA DE PRUEBA'


Update #tmpDocumentoDebito
Set	sldo_dcmnto	=	0
Where 	sldo_dcmnto      <	0

Select	@SaldoResponsable		=	isnull(sum(sldo_dcmnto),0)
From	#tmpDocumentoDebito


Select * from #tmpDocumentoDebito