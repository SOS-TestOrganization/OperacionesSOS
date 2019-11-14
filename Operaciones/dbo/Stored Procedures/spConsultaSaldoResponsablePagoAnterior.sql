


CREATE  PROCEDURE spConsultaSaldoResponsablePagoAnterior
	@cnsctvo_cdgo_clse_aprtnte	udtConsecutivo	=	NULL,
	@nmro_unco_idntfccn_empldr	udtConsecutivo	=	NULL,
	@cnsctvo_scrsl 			udtConsecutivo	=	NULL,
	@SaldoResponsable		numeric(12,0)	output
	



As  			
set nocount on				
	

-- se trae la informacion de los estado de cuenta		
Select  Dscrpcn_tpo_dcmnto,	nmro_estdo_cnta nmro_dcto,	
	p.fcha_incl_prdo_lqdcn  Fcha_dcmnto,	dscrpcn_estdo_estdo_cnta,
	a.ttl_pgr	ttl_dcmnto,
	a.sldo_estdo_cnta	 sldo_dcmnto  ,
	case when nmro_estdo_cnta <> '0'  then 1 else 0	end estado  
Into	#tmpDocumentoDebito
From    tbestadosCuenta a, 	 tbtipodocumentos  c, tbestadosEstadosCuenta b,
	tbliquidaciones l, tbperiodosliquidacion_vigencias p
Where	c.cnsctvo_cdgo_tpo_dcmnto	=	1	-- estados de cuenta
And	a.nmro_unco_idntfccn_empldr	=	@nmro_unco_idntfccn_empldr
And	a.cnsctvo_scrsl			=	@cnsctvo_scrsl
And	a.cnsctvo_cdgo_clse_aprtnte	=	@cnsctvo_cdgo_clse_aprtnte
And	a.cnsctvo_cdgo_estdo_estdo_cnta	=	b.cnsctvo_cdgo_estdo_estdo_cnta
And	a.cnsctvo_cdgo_lqdcn		=	l.cnsctvo_cdgo_lqdcn
And	l.cnsctvo_cdgo_prdo_lqdcn	=	p.cnsctvo_cdgo_prdo_lqdcn
And	a.sldo_estdo_cnta		>	0
And	a.cnsctvo_estdo_cnta		>   	0
And	l.cnsctvo_cdgo_estdo_lqdcn	=	3   --Finalizada..
And	a.cnsctvo_cdgo_estdo_estdo_cnta	<>	4	--Anulada



-- se insertan la informacion de las notas debito pendiente
Insert into #tmpDocumentoDebito
Select	Dscrpcn_tpo_dcmnto,	a.nmro_nta nmro_dcto,
	fcha_crcn_nta, 		dscrpcn_estdo_nta,
	(vlr_nta +   vlr_iva),  
	sldo_nta,
	1	
from	tbNotasPac a,  tbtipodocumentos  c , TbestadosNota b
Where  	c.cnsctvo_cdgo_tpo_dcmnto	=	2		--notas debito
And	a.nmro_unco_idntfccn_empldr	=	@nmro_unco_idntfccn_empldr
And	a.cnsctvo_scrsl			=	@cnsctvo_scrsl
And	a.cnsctvo_cdgo_clse_aprtnte	=	@cnsctvo_cdgo_clse_aprtnte
And	a.cnsctvo_cdgo_estdo_nta	=	b.cnsctvo_cdgo_estdo_nta
and	a.cnsctvo_cdgo_tpo_nta		=	1	--notas debito
And	sldo_nta				>	0
And	a.cnsctvo_cdgo_estdo_nta	<>	6	--Anulada

Select	@SaldoResponsable		=	isnull(vlr_sldo,0)
From	tbAcumuladosSucursalAportante
Where	nmro_unco_idntfccn_empldr	=	@nmro_unco_idntfccn_empldr	
And	cnsctvo_scrsl			=	@cnsctvo_scrsl
And	cnsctvo_cdgo_clse_aprtnte	=	@cnsctvo_cdgo_clse_aprtnte
And	ultma_oprcn			=	1

	

Select * from #tmpDocumentoDebito