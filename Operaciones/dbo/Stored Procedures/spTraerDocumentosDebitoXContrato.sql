
CREATE  PROCEDURE spTraerDocumentosDebitoXContrato
	@numero_Contrato	udtnumeroFormulario	=	NULL,
	@tipo_contrato		udtConsecutivo		=	NULL
	



As  			
set nocount on				
	


-- se trae la informacion de los estado de cuenta		
Select  Dscrpcn_tpo_dcmnto,	nmro_estdo_cnta 	nmro_dcto,	
	p.fcha_incl_prdo_lqdcn   Fcha_dcmnto,		space (50)	dscrpcn_estdo_estdo_cnta,
	i.vlr_cbrdo			ttl_dcmnto,
	i.sldo	sldo_dcmnto  ,CONVERT(VARCHAR(10),'') PRDO,
	case when nmro_estdo_cnta <> '0'  then 1 else 0	end estado  ,
       	i.cnsctvo_estdo_cnta_cntrto	cnsctvo_dcmnto,
	c.cnsctvo_cdgo_tpo_dcmnto
Into	#tmpDocumentoDebito
From    tbestadosCuenta a, 	 tbtipodocumentos  c ,
	tbliquidaciones l, tbperiodosliquidacion_vigencias p,
	tbestadoscuentaContratos i
Where	c.cnsctvo_cdgo_tpo_dcmnto	=	1	-- estados de cuenta
And	a.cnsctvo_estdo_cnta		=	i.cnsctvo_estdo_cnta
and	i.Nmro_cntrto			=	@numero_Contrato
And	i.cnsctvo_cdgo_tpo_cntrto	=	@tipo_contrato
And	a.cnsctvo_cdgo_lqdcn		=	l.cnsctvo_cdgo_lqdcn
And	l.cnsctvo_cdgo_prdo_lqdcn	=	p.cnsctvo_cdgo_prdo_lqdcn
--And	a.sldo_estdo_cnta		>	0
And	a.cnsctvo_estdo_cnta		>   	0
And	l.cnsctvo_cdgo_estdo_lqdcn	=	3   --Finalizada..
And	a.cnsctvo_cdgo_estdo_estdo_cnta	<>	4	--Anulada


insert into #tmpDocumentoDebito
select Dscrpcn_tpo_dcmnto,	nmro_estdo_cnta 	nmro_dcto,	
	p.fcha_incl_prdo_lqdcn   Fcha_dcmnto,	'INGRESADA DE PRUEBA'	dscrpcn_estdo_estdo_cnta,
	i.vlr_cbrdo			ttl_dcmnto,
	i.sldo	sldo_dcmnto  ,CONVERT(VARCHAR(10),'') PRDO,
	case when nmro_estdo_cnta <> '0'  then 1 else 0	end estado  ,
       	i.cnsctvo_estdo_cnta_cntrto	cnsctvo_dcmnto,
	c.cnsctvo_cdgo_tpo_dcmnto
From    tbestadosCuenta a, 	 tbtipodocumentos  c ,
	tbliquidaciones l, tbperiodosliquidacion_vigencias p,
	tbestadoscuentaContratos i
Where	c.cnsctvo_cdgo_tpo_dcmnto	=	1	-- estados de cuenta
And	a.cnsctvo_estdo_cnta		=	i.cnsctvo_estdo_cnta
and	i.Nmro_cntrto			=	@numero_Contrato
And	i.cnsctvo_cdgo_tpo_cntrto	=	@tipo_contrato
And	a.cnsctvo_cdgo_lqdcn		=	l.cnsctvo_cdgo_lqdcn
And	l.cnsctvo_cdgo_prdo_lqdcn	=	p.cnsctvo_cdgo_prdo_lqdcn
And	a.cnsctvo_estdo_cnta		>   	0
And	l.cnsctvo_cdgo_estdo_lqdcn	=	6   --De prueba..
And	a.cnsctvo_cdgo_estdo_estdo_cnta	<>	4	--Anulada





-- se insertan la informacion de las notas debito pendiente
Insert into #tmpDocumentoDebito
Select	Dscrpcn_tpo_dcmnto,	a.nmro_nta nmro_dcto,
	fcha_crcn_nta, 		space(30)	dscrpcn_estdo_nta,
	(d.vlr +   d.vlr_iva),  
	sldo_nta_cntrto,
	convert(varchar(10),a.obsrvcns),
	1,
	d.cnsctvo_nta_cntrto,	
	c.cnsctvo_cdgo_tpo_dcmnto
from	tbNotasPac a, 	 tbtipodocumentos  c , TbestadosNota b,
	tbnotascontrato d
Where  	c.cnsctvo_cdgo_tpo_dcmnto	=	2		--notas debito
And	a.cnsctvo_cdgo_tpo_nta		=	d.cnsctvo_cdgo_tpo_nta
And	a.nmro_nta			=	d.nmro_nta
And	d.nmro_cntrto			=	@numero_Contrato
And	d.cnsctvo_cdgo_tpo_cntrto	=	@tipo_contrato	
And	a.cnsctvo_cdgo_estdo_nta	=	b.cnsctvo_cdgo_estdo_nta
and	a.cnsctvo_cdgo_tpo_nta		=	1	--notas debito
--And	sldo_nta				>	0
And	a.cnsctvo_cdgo_estdo_nta	<>	6	--Anulada

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


Select * from #tmpDocumentoDebito

