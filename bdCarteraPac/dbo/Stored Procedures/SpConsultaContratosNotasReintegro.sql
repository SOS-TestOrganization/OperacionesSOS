

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :   SpConsultaContratosNotasDebito
* Desarrollado por		 :  <\A	Ing. Rolando Simbaqueva Lasso						A\>
* Descripcion			 :  <\D   trae la informacion de los l contratos del estado de cuenta			D\>
* Observaciones		              :  <\O										O\>
* Parametros			 :  <\P    									P\>
* Variables			 :  <\V										V\>
* Fecha Creacion		 :  <\FC  2002/10/07								FC\>
* 
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION  
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------  
* Modificado Por		              : <\AM  Andres camelo (illustrato ltda) AM\>
* Descripcion			 : <\DM  Se realiza consulta para los reintegros a nivel de sucursal   DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM  2013/11/20   FM\>
*---------------------------------------------------------------------------------*/
CREATE        PROCEDURE  [dbo].[SpConsultaContratosNotasReintegro]
		@lnNumeroNota		Varchar(15)
		
AS		Declare	
		@Saldo_Nta	numeric(12,0)



Set  Nocount On

CREATE TABLE #tmpEstadosCuentaContrato (
cnsctvo_estdo_cnta	int
,nmro_unco_idntfccn_empldr	udtConsecutivo
,cnsctvo_scrsl	udtConsecutivo
,cnsctvo_cdgo_clse_aprtnte	udtConsecutivo
,ttl_fctrdo	udtValorGrande
,vlr_iva	udtValorGrande
,ttl_pgr	numeric
,nmro_estdo_cnta	varchar(100)
,cnsctvo_cdgo_tpo_cntrto	udtConsecutivo
,nmro_cntrto	udtNumeroFormulario
,nmbre_afldo	varchar(100)
,nmbre_scrsl	varchar(100)
,rzn_scl	varchar(100)
,dgto_vrfccn	int
,nmro_idntfccn_empldr	varchar(100)
,cdgo_tpo_idntfccn_empldr	varchar(100)
,cnsctvo_cdgo_tpo_idntfccn_Empldr	int
,cdgo_tpo_idntfccn	char(30)
,nmro_idntfccn	varchar(100)
,accn	varchar(100)
,cnsctvo_cdgo_pln	int
,nmro_unco_idntfccn_afldo	int
,cnsctvo_cdgo_estdo_estdo_cnta	udtConsecutivo
,sldo_estdo_cnta	udtValorGrande
,vlr_cbrdo_cntrto	numeric
,sldo_cntrto	udtValorGrande
,cnsctvo_estdo_cnta_cntrto udtConsecutivo)


-- se crea la tabla temporal con la informacion del  estado cuenta y sus contratos
INSERT into #tmpEstadosCuentaContrato
SELECT 	convert(int,a.nmro_nta) cnsctvo_estdo_cnta ,        a.nmro_unco_idntfccn_empldr,       a.cnsctvo_scrsl ,
		a.cnsctvo_cdgo_clse_aprtnte , (a.vlr_nta )  ttl_fctrdo ,			a.vlr_iva ,
		(a.vlr_nta +       a.vlr_iva)  ttl_pgr ,		        a.nmro_nta  nmro_estdo_cnta , 
		b.cnsctvo_cdgo_tpo_cntrto,    b.nmro_cntrto,                   
		space(200) 	nmbre_afldo,
		space(200) 	nmbre_scrsl,
		space(200) 	rzn_scl,
		0		dgto_vrfccn,
		space(20)  	nmro_idntfccn_empldr	 ,
		space(3)	cdgo_tpo_idntfccn_empldr,
		0		cnsctvo_cdgo_tpo_idntfccn_Empldr,
		d.cdgo_tpo_idntfccn,
		e.nmro_idntfccn,
		'NO SELECCIONADO'		accn,
		c.cnsctvo_cdgo_pln,
		c.nmro_unco_idntfccn_afldo,
		a.cnsctvo_cdgo_estdo_nta	cnsctvo_cdgo_estdo_estdo_cnta,
		a.sldo_nta 	sldo_estdo_cnta,
		(b.vlr + b.vlr_iva   )	  vlr_cbrdo_cntrto,
		b.sldo_nta_cntrto 	 sldo_cntrto,
		cnsctvo_nta_cntrto	cnsctvo_estdo_cnta_cntrto
FROM    tbnotaspac 	a  WITH(NOLOCK),  tbnotascontrato b ,
	bdafiliacion..Tbcontratos		c ,
	bdafiliacion..tbtiposIdentificacion 	d ,	
	bdafiliacion..tbVinculados		e
Where   a.nmro_nta			 =	 b.nmro_nta
and	a.cnsctvo_cdgo_tpo_nta		=	b.cnsctvo_cdgo_tpo_nta
And	ltrim(rtrim(a.nmro_nta))		=	ltrim(rtrim(@lnNumeroNota))
And	b.nmro_cntrto			=	c.nmro_cntrto
And	b.cnsctvo_cdgo_tpo_cntrto	=	c.cnsctvo_cdgo_tpo_cntrto
And	c.nmro_unco_idntfccn_afldo	=	e.nmro_unco_idntfccn
And	e.cnsctvo_cdgo_tpo_idntfccn	=	d.cnsctvo_cdgo_tpo_idntfccn
And	a.cnsctvo_cdgo_tpo_nta		=	3	
--and	a.cnsctvo_cdgo_estdo_nta	=	8  -- el estado sea AUTORIZADO
And	b.sldo_nta_cntrto		>	0
And	a.cnsctvo_cdgo_estdo_nta 	!=	6 -- el estado sea ANULADA

--

Select	@Saldo_Nta			=	isnull(sum(sldo_cntrto),0)
From	#tmpEstadosCuentaContrato
Where 	sldo_cntrto			>	0


Update #tmpEstadosCuentaContrato
Set	sldo_estdo_cnta			=	@Saldo_Nta

--
--Update #tmpEstadosCuentaContrato
--Set	cnsctvo_cdgo_estdo_estdo_cnta	=	2
--where	sldo_estdo_cnta			>	0

--


-- se actualiza el nombre del afiliado
Update #tmpEstadosCuentaContrato
Set	nmbre_afldo	=	ltrim(rtrim(d.prmr_aplldo)) + ' ' + ltrim(rtrim(d.sgndo_aplldo)) + ' ' + ltrim(rtrim(d.prmr_nmbre)) + ' ' +ltrim(rtrim(sgndo_nmbre)) 
From	#tmpEstadosCuentaContrato  a, bdafiliacion..tbpersonas  d
Where	a.nmro_unco_idntfccn_afldo	=	d.nmro_unco_idntfccn


-- 2013/11/20 Andres camelo (illustrato ltda) Se realiza consulta para los reintegros a nivel de sucursal
if not exists (select top 1 1 from #tmpEstadosCuentaContrato)
begin 

INSERT into #tmpEstadosCuentaContrato
SELECT 	convert(int,a.nmro_nta) cnsctvo_estdo_cnta ,        a.nmro_unco_idntfccn_empldr,       a.cnsctvo_scrsl ,
		a.cnsctvo_cdgo_clse_aprtnte , (a.vlr_nta )  ttl_fctrdo ,			a.vlr_iva ,
		(a.vlr_nta +       a.vlr_iva)  ttl_pgr ,		        a.nmro_nta  nmro_estdo_cnta , 
		0,    0,                   
		space(200) 	nmbre_afldo,
		space(200) 	nmbre_scrsl,
		space(200) 	rzn_scl,
		0		dgto_vrfccn,
		space(20)  	nmro_idntfccn_empldr	 ,
		space(3)	cdgo_tpo_idntfccn_empldr,
		0		cnsctvo_cdgo_tpo_idntfccn_Empldr,
		'' cdgo_tpo_idntfccn,
		0 nmro_idntfccn,
		'NO SELECCIONADO'		accn,
		2 cnsctvo_cdgo_pln, -- plan por defecto
		a.nmro_unco_idntfccn_empldr nmro_unco_idntfccn_afldo,
		a.cnsctvo_cdgo_estdo_nta	cnsctvo_cdgo_estdo_estdo_cnta,
		a.sldo_nta 	sldo_estdo_cnta,
		(a.vlr_nta + a.vlr_iva  )	  vlr_cbrdo_cntrto,
		 a.sldo_nta 	 sldo_cntrto,
		0	cnsctvo_estdo_cnta_cntrto
FROM    tbnotaspac 	a  WITH(NOLOCK) 
Where  ltrim(rtrim(a.nmro_nta))		=	ltrim(rtrim(@lnNumeroNota))
And	a.cnsctvo_cdgo_tpo_nta		=	3	
And	a.sldo_nta		>	0
And	a.cnsctvo_cdgo_estdo_nta 	!=	6 -- el estado sea ANULADA

end

-- se actualiza los datos basicos del responsable pago
Update  #tmpEstadosCuentaContrato
Set	nmro_idntfccn_empldr		=	b.nmro_idntfccn,
	dgto_vrfccn			=	b.dgto_vrfccn,
	cnsctvo_cdgo_tpo_idntfccn_Empldr=	b.cnsctvo_cdgo_tpo_idntfccn
From	#tmpEstadosCuentaContrato a, bdafiliacion..tbVinculados	  b
Where   a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn
	
	
Update	#tmpEstadosCuentaContrato
Set	cdgo_tpo_idntfccn_empldr		=	b.cdgo_tpo_idntfccn
From	#tmpEstadosCuentaContrato a, bdafiliacion..tbtiposIdentificacion b
Where 	a.cnsctvo_cdgo_tpo_idntfccn_Empldr	=	b.cnsctvo_cdgo_tpo_idntfccn


-- actualiza la razon social
Update 	#tmpEstadosCuentaContrato
Set	 rzn_scl	 =  c.rzn_scl
From 	#tmpEstadosCuentaContrato	 a	,bdafiliacion..tbempleadores b,	bdafiliacion..tbempresas c --,	tbclasesempleador d
Where	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte 
And	a.nmro_unco_idntfccn_empldr	=	c.nmro_unco_idntfccn
--And	a.vldo				=	'S'




Update 	#tmpEstadosCuentaContrato
Set	 rzn_scl	 =   ltrim(rtrim(isnull(prmr_aplldo,'')))  + ' ' + ltrim(rtrim(isnull(sgndo_aplldo,''))) + ' ' + ltrim(rtrim(isnull(prmr_nmbre,''))) + ' ' + ltrim(rtrim(isnull(sgndo_nmbre,'')))
From 	#tmpEstadosCuentaContrato	 a	, bdafiliacion..tbempleadores b,	bdafiliacion..tbpersonas c
Where	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte 
And	a.nmro_unco_idntfccn_empldr	=	c.nmro_unco_idntfccn
And	a.rzn_scl				=	''

--actualiza el nombre de la sucursal
Update #tmpEstadosCuentaContrato
Set 	nmbre_scrsl	=	b.nmbre_scrsl
From	#tmpEstadosCuentaContrato  a, bdafiliacion..tbsucursalesaportante  b
Where 	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl
And	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte



Select cnsctvo_estdo_cnta,
nmro_unco_idntfccn_empldr,
cnsctvo_scrsl,
cnsctvo_cdgo_clse_aprtnte,
ttl_fctrdo,
vlr_iva,
ttl_pgr,
nmro_estdo_cnta,
cnsctvo_cdgo_tpo_cntrto,
nmro_cntrto,
nmbre_afldo,
nmbre_scrsl,
rzn_scl,
dgto_vrfccn,
nmro_idntfccn_empldr,
cdgo_tpo_idntfccn_empldr,
cnsctvo_cdgo_tpo_idntfccn_Empldr,
cdgo_tpo_idntfccn,
nmro_idntfccn,
accn,
cnsctvo_cdgo_pln,
nmro_unco_idntfccn_afldo,
cnsctvo_cdgo_estdo_estdo_cnta,
sldo_estdo_cnta,
vlr_cbrdo_cntrto,
sldo_cntrto,
cnsctvo_estdo_cnta_cntrto
from  #tmpEstadosCuentaContrato

