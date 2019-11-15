
/*---------------------------------------------------------------------------------
* Metodo o PRG		: spEjecutaConsCarteraCastigar 
* Desarrollado por	: <\A Ing. Fernando Valencia Echeverri						A\> 
* Descripcion		: <\D Permite consultar la cartera a castigar segun la fecha de corte especificada						D\>
* Observaciones		: <\O										O\>
* Parametros		: <\P 										P\>
* Variables		: <\V 							V\>a
			: <\V 					V\>
			: <\V 					V\>
			* Fecha Creacion: <\FC 2008/02/06						FC\>
Quick 2013-001-008412 Sisdgb01 04/04/2013 Se ajusta agregando la validacion de que el estado de los EC sea diferente de 4 ANULADO

*--------------------------------------------------------------------------------- 
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------
*---------------------------------------------------------------------------------*/


CREATE PROCEDURE [dbo].[spEjecutaConsCarteraCastigar] @fcha datetime

as  declare 
 
 
@tbla				varchar(128),
@cdgo_cmpo 			varchar(128),
@oprdr 				varchar(2),
@vlr 				varchar(250),
@cmpo_rlcn 			varchar(128),
@cmpo_rlcn_prmtro 	varchar(128),
@cnsctvo			Numeric(4),
@IcInstruccion		Nvarchar(4000),
@IcInstruccion1		Nvarchar(4000),
@IcInstruccion2		Nvarchar(4000),
@IcInstruccion3		Nvarchar(4000),
@IcInstruccion4		Nvarchar(4000),
@lcAlias			char(2),
@lnContador			Int,
@ldFechaSistema		Datetime,
@Fecha_Corte		Datetime,
@cnsctvo_scrsl 		int,
@Fecha_Caracter		varchar(15)


Set Nocount On

Select	@ldFechaSistema	=	Getdate()



						
-- primero se hace para estados de cuenta

select  	a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte ,
	a.Fcha_crcn , bdrecaudos.dbo.fnCalculaPeriodo (a.Fcha_crcn) Periodo,
	c.sldo,
	b.prmtr_crtra_pc	  cnsctvo_cdgo_prmtr ,           
	b.sde_crtra_pc     Cnsctvo_cdgo_sde ,
	c.cnsctvo_cdgo_tpo_cntrto,
	c.nmro_cntrto,
	1	cnsctvo_cdgo_tpo_dcmnto,
	a.nmro_estdo_cnta	 nmro_dcmnto,
	c.cntdd_bnfcrs,
	e.fcha_incl_prdo_lqdcn	fcha_crte,
	a.cnsctvo_estdo_cnta cnsctvo
into	#tmpEstadosCuenta
from	TbestadosCuenta a, bdafiliacion..tbsucursalesaportante  b,
	TbEstadosCuentaContratos  c,
	tbliquidaciones d ,
	tbperiodosliquidacion_vigencias e	 
where	 c.sldo		 >	 0
And	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
And	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl
And	a.cnsctvo_estdo_cnta		=	c.cnsctvo_estdo_cnta
And	a.cnsctvo_cdgo_lqdcn		=	d.cnsctvo_cdgo_lqdcn	
And	e.cnsctvo_cdgo_prdo_lqdcn	=	d.cnsctvo_cdgo_prdo_lqdcn
And	a.cnsctvo_cdgo_lqdcn		=	d.cnsctvo_cdgo_lqdcn	
And	 1	=	2

Insert	into	#tmpEstadosCuenta
SELECT   a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte ,
a.Fcha_crcn , bdrecaudos.dbo.fnCalculaPeriodo (a.Fcha_crcn) Periodo,
								   c.sldo ,
								   b.prmtr_crtra_pc,
								   b.sde_crtra_pc   ,
								   c.cnsctvo_cdgo_tpo_cntrto,
								   c.nmro_cntrto	,
								    1	cnsctvo_cdgo_tpo_dcmnto,
								    a.nmro_estdo_cnta , c.cntdd_bnfcrs , e.fcha_incl_prdo_lqdcn	fcha_crte, a.cnsctvo_estdo_cnta	
	FROM      tbestadosCuenta a,	
								   bdafiliacion..tbSedes s ,
								   tbpromotores  p,	
								   bdafiliacion..tbSucursalesAportante b  ,
								   TbEstadosCuentaContratos  c,
								   Tbliquidaciones d ,
								   Tbperiodosliquidacion_vigencias e ,
								   bdAfiliacion.dbo.tbClasesAportantes l 
Where 	   c.sldo 	>	 0
And	  a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr  
And	  a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte  
And	  a.cnsctvo_scrsl		=	b.cnsctvo_scrsl   
And	  b.sde_crtra_pc			=	s.cnsctvo_cdgo_sde  
And	  a.cnsctvo_estdo_cnta		=	c.cnsctvo_estdo_cnta  
And	  b.prmtr_crtra_pc		=	p.cnsctvo_cdgo_prmtr 
And	  d.cnsctvo_cdgo_estdo_lqdcn	=	3	 
And	  e.cnsctvo_cdgo_prdo_lqdcn	=	d.cnsctvo_cdgo_prdo_lqdcn  
And	  a.cnsctvo_cdgo_lqdcn		=	d.cnsctvo_cdgo_lqdcn  
And	  b.cnsctvo_cdgo_clse_aprtnte	=	l.cnsctvo_cdgo_clse_aprtnte
And   a.fcha_crcn <= convert(char(10),@fcha,111) 
and   cnsctvo_cdgo_estdo_estdo_cnta != 4

--Segundo se hace para Notas Debito

select  	a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte ,
	a.Fcha_crcn_nta , bdrecaudos.dbo.fnCalculaPeriodo (a.Fcha_crcn_nta) Periodo,
	c.sldo_nta_cntrto,
	b.prmtr_crtra_pc	  cnsctvo_cdgo_prmtr ,           
	b.sde_crtra_pc     Cnsctvo_cdgo_sde ,
	c.cnsctvo_cdgo_tpo_cntrto,
	c.nmro_cntrto,
	2	cnsctvo_cdgo_tpo_dcmnto,
	a.nmro_nta	nmro_dcmnto,
	0	cntdd_bnfcrs,
	e.fcha_incl_prdo_lqdcn	fcha_crte,
	a.nmro_nta	cnsctvo
into	#tmpNotasDebito
from 	tbnotasPac a, bdafiliacion..tbsucursalesaportante  b,
	tbnotasContrato c,
	tbperiodosliquidacion_vigencias e
where	 c.sldo_nta_cntrto		 >	 1000
And	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
And	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl
And	a.nmro_nta			=	c.nmro_nta
And	a.cnsctvo_cdgo_tpo_nta		=	c.cnsctvo_cdgo_tpo_nta
And	e.cnsctvo_cdgo_prdo_lqdcn	=	a.cnsctvo_prdo
And	 1				=	2

Insert	into	#tmpNotasDebito
SELECT   a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte ,
							  	   a.Fcha_crcn_nta , bdrecaudos.dbo.fnCalculaPeriodo (a.Fcha_crcn_nta) Periodo,
								   c.sldo_nta_cntrto,
								   b.prmtr_crtra_pc,
								   b.sde_crtra_pc   ,
								   c.cnsctvo_cdgo_tpo_cntrto,
							  	   c.nmro_cntrto,
								    2	cnsctvo_cdgo_tpo_dcmnto,
								    a.nmro_nta ,   0    cntdd_bnfcrs, 	e.fcha_incl_prdo_lqdcn	fcha_crte, a.nmro_nta 		
										FROM      tbnotasPac a,	
		  	  bdafiliacion..tbSedes s ,
  		    tbpromotores  p,	
					bdafiliacion..tbSucursalesAportante b , tbnotasContrato c,
					tbperiodosliquidacion_vigencias e ,
					bdAfiliacion.dbo.tbClasesAportantes l 

Where 	   c.sldo_nta_cntrto 	>	 0 
And	  a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr 
And	  a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte 
And	  a.cnsctvo_scrsl		=	b.cnsctvo_scrsl     
And	  b.sde_crtra_pc		=	s.cnsctvo_cdgo_sde 
And	  a.nmro_nta			=	c.nmro_nta     
And	  a.cnsctvo_cdgo_tpo_nta	=	c.cnsctvo_cdgo_tpo_nta 
And	  a.cnsctvo_cdgo_tpo_nta	=	1  
And	  a.cnsctvo_cdgo_estdo_nta	!=	6      --Estado diferente de anulada
And	  b.prmtr_crtra_pc		=	p.cnsctvo_cdgo_prmtr 
And	  e.cnsctvo_cdgo_prdo_lqdcn	=	a.cnsctvo_prdo  
And	b.cnsctvo_cdgo_clse_aprtnte	=	l.cnsctvo_cdgo_clse_aprtnte
And   a.fcha_crcn_nta <= convert(char(10),@fcha,111)

---ahora se cruzan todos los documentos debito y credito


Insert into	#tmpEstadosCuenta
Select		nmro_unco_idntfccn_empldr, 
		cnsctvo_scrsl, 
		cnsctvo_cdgo_clse_aprtnte ,
		Fcha_crcn_nta , 
		Periodo,
		sldo_nta_cntrto,
		cnsctvo_cdgo_prmtr,
		Cnsctvo_cdgo_sde   ,
		cnsctvo_cdgo_tpo_cntrto,
		nmro_cntrto,
		cnsctvo_cdgo_tpo_dcmnto,
		nmro_dcmnto,
		cntdd_bnfcrs,
		fcha_crte,
		cnsctvo
From		#tmpNotasDebito


SELECT   nmro_unco_idntfccn_empldr, 
	   cnsctvo_scrsl, 
	   cnsctvo_cdgo_clse_aprtnte,
 	   Fcha_crcn ,  
	   Periodo,
	   sldo ,
	   cnsctvo_cdgo_prmtr,
	   Cnsctvo_cdgo_sde   ,
       cnsctvo_cdgo_tpo_cntrto,
       nmro_cntrto	,
       cnsctvo_cdgo_tpo_dcmnto,
	   0	dfrnca_mra,
	   nmro_dcmnto,
	   cntdd_bnfcrs,
	   fcha_crte,
		 cnsctvo
into	  #tmpDocumentosDebitos
From	  #tmpEstadosCuenta

Update #tmpDocumentosDebitos
Set	dfrnca_mra	=	Datediff(Month,Convert(varchar(6), Periodo)+'01',Substring(convert(varchar(8),@Fcha,112),1,6)+ '01')



Select nmro_unco_idntfccn_empldr, 
	   cnsctvo_scrsl, 
	   cnsctvo_cdgo_clse_aprtnte,
 	   Fcha_crcn ,  
	   Periodo,
	   sldo ,
	   cnsctvo_cdgo_prmtr,
	   Cnsctvo_cdgo_sde   ,
       cnsctvo_cdgo_tpo_cntrto,
       nmro_cntrto	,
       cnsctvo_cdgo_tpo_dcmnto,
	   nmro_dcmnto	,
	   cntdd_bnfcrs,
	   fcha_crte,
	   cnsctvo
into   #tmpCarteraVencidaTotal
From	   #tmpDocumentosDebitos
where 	   dfrnca_mra	>	0



Select  Nmro_idntfccn, 		
	Nmbre_scrsl,
	cdgo_tpo_idntfccn ,
	Space(100) 		nmbre_prmtr,
	prmtr_crtra_pc,
	dscrpcn_sde,
	cdgo_sde,
	sldo,
	d.drccn,
	d.tlfno,
	d.cnsctvo_cdgo_cdd,
	ci.dscrpcn_cdd,
	Space(20)	nmro_idntfccn_ctznte,
	Space(10)	tpo_idntfccn_ctznte,
	Space(100)	nmbre_ctznte,
	b.cnsctvo_cdgo_tpo_cntrto,
           b.nmro_cntrto,
           0		cnsctvo_cdgo_pln,
	Space(30)	dscrpcn_pln,
	Space(100)	drccn_ctznte,
	Space(50)	tlfno_ctznte,
	Space(100) 	dscrpcn_cdd_ctznte,
	 b.nmro_dcmnto,
	 0 	nmro_unco_idntfccn_afldo,
	 0 	cnsctvo_cdgo_tpo_idntfccn,
	 d.nmro_unco_idntfccn_empldr, 
	 d.cnsctvo_scrsl, 
	 d.cnsctvo_cdgo_clse_aprtnte,
	 cnsctvo_cdgo_tpo_dcmnto,
	 cntdd_bnfcrs,
	 convert(datetime,null)	inco_vgnca_cntrto,
	 convert(char(10),fcha_crte,111) as fcha_crte,
	 e.cnsctvo_cdgo_sde,
	 0 cnsctvo_cdgo_tpo_idntfccn_empldr,
	 cnsctvo
Into	 #tmpInfomeCarteraFinal
FRom	 bdafiliacion..tbvinculados 		a,
	 #tmpCarteraVencidaTotal 		b,
	 bdafiliacion..tbTiposidentificacion 	c,
	 bdafiliacion..tbsucursalesaportante 	d,
	 bdafiliacion..tbsedes  		e,
	 bdafiliacion..tbciudades  	ci
Where	 a.nmro_unco_idntfccn		=	b.nmro_unco_idntfccn_empldr
And	 a.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn
And	 b.nmro_unco_idntfccn_empldr	=	d.nmro_unco_idntfccn_empldr
And	 b.cnsctvo_cdgo_clse_aprtnte	=	d.cnsctvo_cdgo_clse_aprtnte
And	 b.cnsctvo_scrsl		=	d.cnsctvo_scrsl
And	 d.sde_crtra_pc			=	e.cnsctvo_cdgo_sde
And	 d.cnsctvo_cdgo_cdd		=	ci.cnsctvo_cdgo_cdd


Update #tmpInfomeCarteraFinal
Set	nmbre_prmtr	=	case	when (cnsctvo_cdgo_clse_empldr	=	1) 
					then ltrim(rtrim(prmr_aplldo)) + ' ' +  ltrim(rtrim(sgndo_aplldo)) + ' ' +  ltrim(rtrim(prmr_nmbre)) + ' '  + ltrim(rtrim(sgndo_nmbre))
					else
					ltrim(rtrim(rzn_scl)) end
From	#tmpInfomeCarteraFinal a, tbpromotores_vigencias b
Where   a.prmtr_crtra_pc	=	b.cnsctvo_cdgo_prmtr


Update	#tmpInfomeCarteraFinal
Set	nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn_afldo,
	cnsctvo_cdgo_pln		=	b.cnsctvo_cdgo_pln,
	inco_vgnca_cntrto		=	b.inco_vgnca_cntrto
From	#tmpInfomeCarteraFinal  a,  bdAfiliacion..tbcontratos b
Where   a.nmro_cntrto			=	b.nmro_cntrto
And	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto

Update	#tmpInfomeCarteraFinal
Set	dscrpcn_pln			=	b.dscrpcn_pln
From	#tmpInfomeCarteraFinal  a,  	bdplanbeneficios..tbplanes  b
Where   a.cnsctvo_cdgo_pln		=	b.cnsctvo_cdgo_pln

Update	#tmpInfomeCarteraFinal
Set	nmro_idntfccn_ctznte		=	ltrim(rtrim(b.nmro_idntfccn)),
	cnsctvo_cdgo_tpo_idntfccn	=	b.cnsctvo_cdgo_tpo_idntfccn
From	#tmpInfomeCarteraFinal  a,  	bdafiliacion..tbvinculados  b
Where   a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn

Update	#tmpInfomeCarteraFinal
Set	tpo_idntfccn_ctznte		=	ltrim(rtrim(b.cdgo_tpo_idntfccn))
From	#tmpInfomeCarteraFinal  a,  	bdafiliacion..tbtiposidentificacion  b
Where   a.cnsctvo_cdgo_tpo_idntfccn	=	b.cnsctvo_cdgo_tpo_idntfccn

Update	#tmpInfomeCarteraFinal
Set	nmbre_ctznte		=	ltrim(rtrim(prmr_aplldo)) + '  '  + ltrim(rtrim(sgndo_aplldo))+ '  ' + ltrim(rtrim(prmr_nmbre)) + '  ' + ltrim(rtrim(sgndo_nmbre)),

	drccn_ctznte		=	drccn_rsdnca,
	tlfno_ctznte		=	tlfno_rsdnca,
	dscrpcn_cdd_ctznte	=	ci.dscrpcn_cdd	
From	#tmpInfomeCarteraFinal  a,  	bdAfiliacion..tbpersonas  b,  
	 bdafiliacion..tbciudades  	ci
Where   a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn
And	 cnsctvo_cdgo_cdd_rsdnca		=	ci.cnsctvo_cdgo_cdd

Update	#tmpInfomeCarteraFinal
Set	cnsctvo_cdgo_tpo_idntfccn_empldr = v.cnsctvo_cdgo_tpo_idntfccn
From	#tmpInfomeCarteraFinal i Inner Join
	bdAfiliacion.dbo.tbVinculados v
On	i.nmro_unco_idntfccn_empldr = v.nmro_unco_idntfccn


select 
cdgo_tpo_idntfccn,	
Nmro_idntfccn,
Nmbre_scrsl,	
cnsctvo_scrsl,	
sldo,
tpo_idntfccn_ctznte,
nmro_idntfccn_ctznte,	
nmbre_ctznte,	
nmro_cntrto,	
nmro_dcmnto,
dscrpcn_tpo_dcmnto,
dscrpcn_pln,		
fcha_crte,	
dscrpcn_sde,
'SELECCIONADO   ' accn ,
a.nmro_unco_idntfccn_empldr, 
a.cnsctvo_cdgo_clse_aprtnte,
a.cnsctvo_cdgo_tpo_dcmnto,
cnsctvo
into #tmpDatosCastigar
From 	 #tmpInfomeCarteraFinal a ,  tbtipodocumentos b
Where	a.cnsctvo_cdgo_tpo_dcmnto	=	b.cnsctvo_cdgo_tpo_dcmnto
Order By a.nmbre_ctznte

select * from #tmpDatosCastigar ORDER BY nmro_dcmnto




