/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :   SpImprimirNota
* Desarrollado por		 :  <\A	Ing. Rolando Simbaqueva Lasso						A\>
* Descripcion			 :  <\D   Inserta la informacion de la nota para imprimir				D\>
* Observaciones		              :  <\O										O\>
* Parametros			 :  <\P    									P\>
* Variables			 :  <\V										V\>
* Fecha Creacion		 :  <\FC  2002/10/07								FC\>
* 
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION  
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------  
* Modificado Por		 : <\AM Jairo Valencia   AM\>
* Descripcion			 : <\DM Se añade los datos de los beneficiarios  DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion	 : <\FM  2013/05/24 FM\>
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------  
* Modificado Por		 : <\AM Andres camelo (illustrato ltda)   AM\>
* Descripcion			 : <\DM  se agrega join para que cosulten los consecutivos de las sedes de la tabla TbDatosAportanteNotaReintegro por numero de nota DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion	 : <\FM  2013/10/31 FM\>
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------  
* Modificado Por		 : <\AM Andres camelo (illustrato ltda)   AM\>
* Descripcion			 : <\DM  Se modifica para que los valores que aplican cuando el nivel fue sucursal se asignen vacios (cdgo_tpo_idntfccn_bnfcro,nmro_idntfccn_bnfcro,nmro_idntfccn_contrato,vlr_iva_bnfcro,nmro_idntfccn_contrato,cdgo_tpo_idntfccn_contrato) DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion	 : <\FM  2013/11/12 FM\>
*  
*  
*   
*---------------------------------------------------------------------------------*/
-- exec [SpImprimirNota] 3,'764' exec [SpImprimirNota] 1,'82541'
CREATE   PROCEDURE  [dbo].[SpImprimirNota]
		@lnConsecutivoTipoNota		udtConsecutivo,
		@lnNumeroNota				Varchar(15)
AS	declare

@lnNivelContrato					int


Set  Nocount On


Set	@lnNivelContrato	=	0


-- Se crea una tabla temporal para ingresar los totales
CREATE TABLE #Tmptotales (cnsctvo_nta_cntrto numeric(12),cnsctvo_nta_cncpto numeric(12),nmro_cntrto numeric(12),total_bnfcro numeric(12), total_iva_bnfcro numeric(12))

CREATE TABLE #tmpContratosNotas (cnsctvo_cdgo_tpo_cntrto	udtConsecutivo
,nmro_cntrto	udtNumeroFormulario
,nmro_unco_idntfccn_afldo	numeric(12)
,vlr	udtValorGrande
,nmro_idntfccn	udtNumeroIdentificacionLargo
,cdgo_tpo_idntfccn		char(3)
,cnsctvo_nta_cncpto	udtConsecutivo
,valor_contrato_concepto numeric(12)
,cnsctvo_nta_cntrto	udtConsecutivo
,nmbre_afldo	varchar(200)
,vlr_iva	udtValorGrande)


CREATE TABLE #TmpConceptosNotas( nmro_unco_idntfccn_empldr	udtConsecutivo
,cnsctvo_scrsl	udtConsecutivo
,cnsctvo_cdgo_clse_aprtnte	udtConsecutivo
,cnsctvo_cdgo_cncpto_lqdcn	udtConsecutivo
,valor_total_nota	udtValorGrande
,valor_nota_concepto	udtValorGrande
,cdgo_cncpto_lqdcn	char(5)
,Dscrpcn_cncpto_lqdcn	udtDescripcion
,nmro_idntfccn	varchar(50)
,cdgo_tpo_idntfccn	char(3)
,cnsctvo_nta_cncpto	udtConsecutivo
,nmbre_scrsl	varchar(150)
,drccn	varchar(80)
,tlfno	char(30)
,dscrpcn_cdd	varchar(150)
,rzn_scl	varchar(200)
,Cantidad_contratos_concepto	numeric(12)
,usro_crcn	udtUsuario
,cnsctvo_cdgo_estdo_nta	udtConsecutivo
,vlr_iva	udtValorGrande
,sldo_nta	udtValorGrande
,obsrvcns	varchar(500)
,fcha_crcn_nta	datetime
,cnsctvo_prdo	udtConsecutivo
,prdo_lqdcn	varchar(100)
)


CREATE TABLE #tmpBeneficiarios( cnsctvo_nta_cntrto numeric(12)
,cnsctvo_nta_cncpto  numeric(12)
,nmro_unco_idntfccn_bnfcro numeric(12)
,nmro_cntrto udtNumeroFormulario
,cdgo_tpo_idntfccn_bnfcro udtTipoIdentificacion
,nmro_idntfccn_bnfcro udtNumeroIdentificacionLargo
,nmbre_bnfcro varchar(200)
,dscrpcn_prntsco varchar(100)
,vlr_nta_bnfcro udtValorGrande
,vlr_iva_bnfcro udtValorGrande
,cnsctvo_dcmnto udtConsecutivo
,cnsctvo_cdgo_tpo_dcmnto udtConsecutivo
)


CREATE TABLE #TmpDatosNota (nmro_nta Varchar(15)
,fcha_crcn_nta datetime
,nmbre_scrsl varchar(150)
,drccn varchar(80)
,tlfno char(30)
,dscrpcn_cdd varchar(150)
,cdgo_tpo_idntfccn_responsable char(3) 
,nmro_idntfccn_responsable varchar(50)
,valor_total_nota udtValorGrande
,vlr_iva udtValorGrande
,prdo_lqdcn varchar(100)
,nmro_cntrto udtNumeroFormulario
,nmbre_afldo   varchar(200)
,cdgo_tpo_idntfccn_bnfcro udtTipoIdentificacion
,nmro_idntfccn_bnfcro udtNumeroIdentificacionLargo
,nmbre_bnfcro varchar(300)
,dscrpcn_prntsco varchar(100)
,vlr_nta_bnfcro udtValorGrande
,vlr_iva_bnfcro udtValorGrande
,valor_contrato	numeric(12)	
,nmro_idntfccn_contrato udtNumeroIdentificacionLargo
,cdgo_tpo_idntfccn_contrato  char(3)
,cnsctvo_nta_cncpto udtConsecutivo
,valor_contrato_concepto udtValorGrande
,valor_nota_concepto udtValorGrande 
,cdgo_cncpto_lqdcn char(5)
,Dscrpcn_cncpto_lqdcn	udtDescripcion		
,rzn_scl varchar(200)		
,Cantidad_contratos_concepto numeric(12)
,usro_crcn udtUsuario
,cnsctvo_cdgo_estdo_nta udtConsecutivo 	
,sldo_nta udtValorGrande
,obsrvcns varchar(500)
,cnsctvo_nta_cntrto udtConsecutivo
,cnsctvo_dcmnto udtConsecutivo
,cnsctvo_cdgo_tpo_dcmnto udtConsecutivo
,cnsctvo_cdgo_cdd udtConsecutivo
,nmbr_cdd varchar(200)
,cnsctvo_cdgo_sde udtConsecutivo
,nmbre_sde_nta  varchar(200))


-- se crea uan tabla temporal con la informacion de los contratos asociados a la nota
insert into 	#tmpContratosNotas
Select  a.cnsctvo_cdgo_tpo_cntrto,
	a.nmro_cntrto,
	nmro_unco_idntfccn_afldo,
	a.vlr,
	nmro_idntfccn,
	cdgo_tpo_idntfccn , 
	e.cnsctvo_nta_cncpto,
	case when	(@lnConsecutivoTipoNota = 3)	then  a.vlr  else   (e.vlr) end		 valor_contrato_concepto,   
    a.cnsctvo_nta_cntrto,
	space(200) nmbre_afldo,
	a.vlr_iva
From	tbNotasContrato a	,	bdafiliacion..Tbcontratos	b ,
	bdafiliacion..tbVinculados	c , bdafiliacion..tbtiposIdentificacion d,
	tbNotasContratoxConcepto	e
Where 	a.nmro_nta			=	@lnNumeroNota
And	a.cnsctvo_cdgo_tpo_nta		=	@lnConsecutivoTipoNota
And	a.nmro_cntrto			=	b.nmro_cntrto
And	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	b.nmro_unco_idntfccn_afldo	=	c.nmro_unco_idntfccn
And	c.cnsctvo_cdgo_tpo_idntfccn	=	d.cnsctvo_cdgo_tpo_idntfccn
And	a.cnsctvo_nta_cntrto		=	e.cnsctvo_nta_cntrto


-- verificamos si es hay contratos
if	@@ROWCOUNT		=	0
	Set	@lnNivelContrato	=	0
else
	Set	@lnNivelContrato	=	1


--actualiza el nombre del afiliado

Update	#tmpContratosNotas
Set	nmbre_afldo		=   ltrim(rtrim(e.prmr_aplldo))  + ' ' + ltrim(rtrim(e.sgndo_aplldo)) + ' ' + ltrim(rtrim(e.prmr_Nmbre )) + ' ' + ltrim(rtrim(e.sgndo_nmbre)) 
From    #tmpContratosNotas a , 	bdafiliacion..tbpersonas e 
Where   a.nmro_unco_idntfccn_afldo  	=    e.nmro_unco_idntfccn



--se crea una tabla temporal de los conceptos de las notas
Insert Into	#TmpConceptosNotas
Select  a.nmro_unco_idntfccn_empldr,
	a.cnsctvo_scrsl, 
	a.cnsctvo_cdgo_clse_aprtnte,
	b.cnsctvo_cdgo_cncpto_lqdcn,
	a.vlr_nta 	valor_total_nota,  -- aqui debe reemplazar el valor de del saldo de la nota
--	convert(numeric(12),((b.vlr_nta + (b.vlr_nta * ( a.vlr_iva / a.vlr_nta) ))))	valor_nota_concepto,  --  si requiere con iva
	b.vlr_nta	valor_nota_concepto,
	c.cdgo_cncpto_lqdcn,
	c.Dscrpcn_cncpto_lqdcn,
	d.nmro_idntfccn,
	e.cdgo_tpo_idntfccn ,
	b.cnsctvo_nta_cncpto,
	f.nmbre_scrsl,
	f.drccn,
	f.tlfno,
	g.dscrpcn_cdd,
	 space(200) rzn_scl,
	0	Cantidad_contratos_concepto,
	a.usro_crcn,
    a.cnsctvo_cdgo_estdo_nta,
	a.vlr_iva,
	a.sldo_nta,
	a.obsrvcns,
	a.fcha_crcn_nta,
	a.cnsctvo_prdo,
	space(100) prdo_lqdcn
From TbnotasPac	a Left join	TbNotasConceptos b       on (	a.nmro_nta = b.nmro_nta And	a.cnsctvo_cdgo_tpo_nta =	b.cnsctvo_cdgo_tpo_nta)
	 Left join TbconceptosLiquidacion c              on (b.cnsctvo_cdgo_cncpto_lqdcn	=	c.cnsctvo_cdgo_cncpto_lqdcn)
	 Left join bdafiliacion..tbVinculados d          on (a.nmro_unco_idntfccn_empldr	=	d.nmro_unco_idntfccn)
	 Left join bdafiliacion..tbtiposIdentificacion e on (d.cnsctvo_cdgo_tpo_idntfccn =	e.cnsctvo_cdgo_tpo_idntfccn	)
	 Left join bdafiliacion..tbsucursalesaportante f on (f.cnsctvo_scrsl			=	a.cnsctvo_scrsl	
														 And	f. nmro_unco_idntfccn_empldr	=	a.nmro_unco_idntfccn_empldr
														 And	f. cnsctvo_cdgo_clse_aprtnte	=	a.cnsctvo_cdgo_clse_aprtnte)
	 Left join bdafiliacion..tbciudades  g           on (f.cnsctvo_cdgo_cdd		=	g.cnsctvo_cdgo_cdd)
Where a.nmro_nta			=	@lnNumeroNota
And	a.cnsctvo_cdgo_tpo_nta		=	@lnConsecutivoTipoNota	



update #TmpConceptosNotas
Set prdo_lqdcn = b.dscrpcn_prdo_lqdcn
From tbperiodosliquidacion b 
inner join #TmpConceptosNotas a
on a.cnsctvo_prdo = b.cnsctvo_cdgo_prdo_lqdcn

-- se consulta la cantidad de contratos asociados
Select	b.cnsctvo_nta_cncpto ,	count(cnsctvo_nta_cntrto) 	cantidad_contratos_Concepto
into	#TmpCantidadContratosConcepto
From	tbNotasConceptos  a,	 tbNotasContratoxConcepto  b
Where		a.Cnsctvo_nta_cncpto		=	b.Cnsctvo_nta_cncpto
And		a.nmro_nta			=	@lnNumeroNota
And		a.cnsctvo_cdgo_tpo_nta		=	@lnConsecutivoTipoNota	
Group by 	b.cnsctvo_nta_cncpto

-- se actualiza  la cantidad de contratos para el concepto
Update 	#TmpConceptosNotas
Set	Cantidad_contratos_concepto	= 	b.cantidad_contratos_Concepto
From	#TmpConceptosNotas	a,	#TmpCantidadContratosConcepto b
Where	a.Cnsctvo_nta_cncpto		=	b.Cnsctvo_nta_cncpto



-- se actualiza la razon social

Update 	#TmpConceptosNotas
Set	 rzn_scl	 =  c.rzn_scl
From 	#TmpConceptosNotas	 a	,bdafiliacion..tbempleadores b,	bdafiliacion..tbempresas c --,	tbclasesempleador d
Where	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte 
And	a.nmro_unco_idntfccn_empldr	=	c.nmro_unco_idntfccn
--And	a.vldo				=	'S'



Update 	#TmpConceptosNotas
Set	 rzn_scl	 =   ltrim(rtrim(isnull(prmr_aplldo,'')))  + ' ' + ltrim(rtrim(isnull(sgndo_aplldo,''))) + ' ' + ltrim(rtrim(isnull(prmr_nmbre,''))) + ' ' + ltrim(rtrim(isnull(sgndo_nmbre,'')))
From 	#TmpConceptosNotas	 a	, bdafiliacion..tbempleadores b,	bdafiliacion..tbpersonas c
Where	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte 
And	a.nmro_unco_idntfccn_empldr	=	c.nmro_unco_idntfccn
And	rzn_scl				=	''



-- Trae los beneficiarios de la Nota *** Jairo Valencia ***
insert into #tmpBeneficiarios
select h.cnsctvo_nta_cntrto,
	   h.cnsctvo_nta_cncpto,
	   h.nmro_unco_idntfccn_bnfcro,
	   a.nmro_cntrto,
	   e.cdgo_tpo_idntfccn    cdgo_tpo_idntfccn_bnfcro,
	   d.nmro_idntfccn nmro_idntfccn_bnfcro,
	   ltrim(rtrim(prmr_aplldo)) +    ' '  +ltrim(Rtrim(sgndo_aplldo)) + ' ' + ltrim(rtrim(prmr_nmbre))  + ' ' + ltrim(rtrim(sgndo_nmbre)) nmbre_bnfcro,
	   f.dscrpcn_prntsco,
	   ISNULL(h.vlr_nta_bnfcro,0) vlr_nta_bnfcro,
	   ISNULL(h.vlr_iva,0) vlr_iva_bnfcro,
	   h.cnsctvo_dcmnto,
	   h.cnsctvo_cdgo_tpo_dcmnto
from tbNotasBeneficiariosContratos h,#tmpContratosNotas a
,bdafiliacion..tbpersonas b,bdafiliacion..tbVinculados d,bdafiliacion..tbtiposIdentificacion e
,bdafiliacion..tbbeneficiarios c,bdafiliacion..tbparentescos f
where h.cnsctvo_nta_cntrto = a.cnsctvo_nta_cntrto
and h.nmro_unco_idntfccn_bnfcro	=	d.nmro_unco_idntfccn
And	d.cnsctvo_cdgo_tpo_idntfccn	=	e.cnsctvo_cdgo_tpo_idntfccn	
and h.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn
and h.nmro_unco_idntfccn_bnfcro =   c.nmro_unco_idntfccn_bnfcro 
and c.nmro_cntrto = a.nmro_cntrto
And c.cnsctvo_cdgo_prntsco	=	f.cnsctvo_cdgo_prntscs
and h.cnsctvo_nta_cncpto = a.cnsctvo_nta_cncpto



---- Se totaliza por contrato y beneficiario ** Jairo Valencia **
--Insert into #Tmptotales
--SELECT cnsctvo_nta_cntrto,cnsctvo_nta_cncpto,nmro_cntrto,SUM(vlr_nta_bnfcro) ,SUM(vlr_iva_bnfcro) 
--FROM #tmpBeneficiarios
--GROUP BY cnsctvo_nta_cntrto,nmro_cntrto,cnsctvo_nta_cncpto


If	@lnNivelContrato	=	0
    begin

   -- Andres camelo (illustrato ltda) Se modifica para que los valores que aplican cuando el nivel fue sucursal se asignen vacios (cdgo_tpo_idntfccn_bnfcro,nmro_idntfccn_bnfcro,nmro_idntfccn_contrato,vlr_iva_bnfcro,nmro_idntfccn_contrato,cdgo_tpo_idntfccn_contrato)
    insert into #TmpDatosNota 
    Select @lnNumeroNota nmro_nta,
		b.fcha_crcn_nta,
		isnull(b.nmbre_scrsl,isnull(ltrim(rtrim(c.prmr_nmbre)),' ')+ ' ' +isnull(ltrim(rtrim(c.sgndo_nmbre)),' ') + ' ' + isnull(ltrim(rtrim(c.prmr_aplldo)),' ') + ' ' + isnull(ltrim(rtrim(c.sgndo_aplldo)),' ')) nmbre_scrsl,
		isnull(b.drccn,c.drccn_aprtnte) drccn,
		isnull(b.tlfno,c.tlfno_aprtnte) tlfno,
		b.dscrpcn_cdd,
	    isnull(b.cdgo_tpo_idntfccn,c.cdgo_tpo_idntfccn)  cdgo_tpo_idntfccn_responsable ,
		isnull(b.nmro_idntfccn,c.nmro_idntfccn) 	nmro_idntfccn_responsable,
		b.valor_total_nota,
		b.vlr_iva,
		b.prdo_lqdcn,
		isnull(nmro_cntrto,0) nmro_cntrto,
		isnull(ltrim(rtrim(prmr_nmbre)),' ') + ' ' +isnull(ltrim(rtrim(sgndo_nmbre)),' ') + ' ' + isnull(ltrim(rtrim(prmr_aplldo)),' ') + ' ' + isnull(ltrim(rtrim(sgndo_aplldo)),' ') nmbre_afldo,
		'' cdgo_tpo_idntfccn_bnfcro, 
		'' nmro_idntfccn_bnfcro,
		isnull(ltrim(rtrim(prmr_nmbre)),' ') + ' ' +isnull(ltrim(rtrim(sgndo_nmbre)),' ') + ' ' + isnull(ltrim(rtrim(prmr_aplldo)),' ') + ' ' + isnull(ltrim(rtrim(sgndo_aplldo)),' ') nmbre_bnfcro,
		'' dscrpcn_prntsco,
		0 vlr_nta_bnfcro, 
		0 vlr_iva_bnfcro, 
		b.valor_nota_concepto valor_contrato ,		
		'' nmro_idntfccn_contrato,
		'' cdgo_tpo_idntfccn_contrato, 
		b.cnsctvo_nta_cncpto cnsctvo_nta_cncpto,
	    b.valor_total_nota  valor_contrato_concepto ,
		b.valor_nota_concepto,
		b.cdgo_cncpto_lqdcn,
		b.Dscrpcn_cncpto_lqdcn,			
		b.rzn_scl,		
		b.Cantidad_contratos_concepto,
		b.usro_crcn,
		b.cnsctvo_cdgo_estdo_nta,		
		b.sldo_nta,
		b.obsrvcns,
		isnull(a.cnsctvo_nta_cntrto,0) cnsctvo_nta_cntrto,
		0,
		0,
		cnsctvo_cdgo_cdd,
		space(200) ciudad,
		cnsctvo_cdgo_sde,
		space(200)nmbre_sde_nta       
	From 	#TmpConceptosNotas	b LEFT OUTER JOIN  #tmpContratosNotas a 
	on	 (b.cnsctvo_nta_cncpto	=	a.cnsctvo_nta_cncpto)
	LEFT OUTER JOIN bdCarteraPac.dbo.TbDatosAportanteNotaReintegro c on (@lnNumeroNota = c.nmro_nta)
	order by	b.cdgo_cncpto_lqdcn,  a.nmro_cntrto
		
		UPDATE #TmpDatosNota
		SET dscrpcn_cdd = a.dscrpcn_cdd
		from bdAfiliacion..tbCiudades a
		where a.cdgo_cdd = #TmpDatosNota.cnsctvo_cdgo_cdd   
		
		UPDATE #TmpDatosNota
		SET #TmpDatosNota.nmbre_sde_nta =  bdAfiliacion.dbo.tbSedes.dscrpcn_sde
		FROM bdAfiliacion.dbo.tbSedes
		WHERE bdAfiliacion.dbo.tbSedes.cdgo_sde = right( '000' + cast( #TmpDatosNota.cnsctvo_cdgo_sde AS varchar(2)), 3 )

	-- Se totaliza por contrato y beneficiario ** Jairo Valencia **
			Insert into #Tmptotales
			SELECT cnsctvo_nta_cntrto,cnsctvo_nta_cncpto,nmro_cntrto,SUM(vlr_nta_bnfcro) ,SUM(vlr_iva_bnfcro) 
			FROM #TmpDatosNota
			GROUP BY cnsctvo_nta_cntrto,nmro_cntrto,cnsctvo_nta_cncpto

	--** Se Adiciona el valor total por contrato **  Jairo Valencia --
 		select a.*,0 total_bnfcro,0 total_iva_bnfcro, '' prdo_lqdcn_nota
		from #TmpDatosNota a LEFT OUTER JOIN #Tmptotales b
		on (a.cnsctvo_nta_cntrto = b.cnsctvo_nta_cntrto
			and a.nmro_cntrto = b.nmro_cntrto
			and a.cnsctvo_nta_cncpto = b.cnsctvo_nta_cncpto)
   end
  
Else
	begin
		insert into #TmpDatosNota
		Select   @lnNumeroNota		nmro_nta,
			b.fcha_crcn_nta,
			b.nmbre_scrsl,
			b.drccn,
			b.tlfno,
			b.dscrpcn_cdd,
			b.cdgo_tpo_idntfccn  cdgo_tpo_idntfccn_responsable ,
			b.nmro_idntfccn 	nmro_idntfccn_responsable,
			b.valor_total_nota,
			b.vlr_iva,
			b.prdo_lqdcn,
			a.nmro_cntrto,
			a.nmbre_afldo , 
			isnull(c.cdgo_tpo_idntfccn_bnfcro,b.cdgo_tpo_idntfccn),
			isnull(c.nmro_idntfccn_bnfcro,b.nmro_idntfccn),
			isnull(c.nmbre_bnfcro,a.nmbre_afldo),
			isnull(c.dscrpcn_prntsco,'COTIZANTE'),
			isnull(c.vlr_nta_bnfcro,a.vlr) vlr_nta_bnfcro,
			isnull(c.vlr_iva_bnfcro,a.vlr_iva) vlr_iva_bnfcro,
			a.valor_contrato_concepto valor_contrato,		
			a.nmro_idntfccn 		nmro_idntfccn_contrato,
			a.cdgo_tpo_idntfccn 	cdgo_tpo_idntfccn_contrato , 
			a.cnsctvo_nta_cncpto,
    		a.valor_contrato_concepto,
			b.valor_nota_concepto,
			b.cdgo_cncpto_lqdcn,
			b.Dscrpcn_cncpto_lqdcn,			
			b.rzn_scl,		
			b.Cantidad_contratos_concepto,
			b.usro_crcn,
			b.cnsctvo_cdgo_estdo_nta,		
			b.sldo_nta,
			b.obsrvcns,
			a.cnsctvo_nta_cntrto,
			c.cnsctvo_dcmnto,
			c.cnsctvo_cdgo_tpo_dcmnto,
			0,
			space(200) ciudad,
			cnsctvo_cdgo_sde,
		    space(200)nmbre_sde_nta
		From 	#TmpConceptosNotas	b inner join  #tmpContratosNotas a 
			 on	(b.cnsctvo_nta_cncpto	=	a.cnsctvo_nta_cncpto)
			 LEFT OUTER JOIN  #tmpBeneficiarios c 
			 on (a.cnsctvo_nta_cntrto = c.cnsctvo_nta_cntrto AND a.cnsctvo_nta_cncpto = c.cnsctvo_nta_cncpto)
             LEFT OUTER JOIN bdCarteraPac.dbo.TbDatosAportanteNotaReintegro e on (@lnNumeroNota = e.nmro_nta)
		order by	b.cdgo_cncpto_lqdcn,  a.nmro_cntrto,c.cnsctvo_dcmnto,c.dscrpcn_prntsco
	    

		UPDATE #TmpDatosNota
		SET #TmpDatosNota.nmbre_sde_nta =  bdAfiliacion.dbo.tbSedes.dscrpcn_sde
		FROM bdAfiliacion.dbo.tbSedes
		WHERE bdAfiliacion.dbo.tbSedes.cdgo_sde = right( '000' + cast( #TmpDatosNota.cnsctvo_cdgo_sde AS varchar(2)), 3 )


		-- Se totaliza por contrato y beneficiario ** Jairo Valencia **
			Insert into #Tmptotales
			SELECT cnsctvo_nta_cntrto,cnsctvo_nta_cncpto,nmro_cntrto,SUM(vlr_nta_bnfcro) ,SUM(vlr_iva_bnfcro) 
			FROM #TmpDatosNota
			GROUP BY cnsctvo_nta_cntrto,nmro_cntrto,cnsctvo_nta_cncpto

	--** Se Adiciona el valor total por contrato **  Jairo Valencia --

		select a.*,isnull(total_bnfcro,0) total_bnfcro,isnull(total_iva_bnfcro,0) total_iva_bnfcro
			,isnull((select j.dscrpcn_prdo_lqdcn
			from tbNotasContrato c,tbNotasPac d,tbperiodosliquidacion j
			Where c.nmro_nta				=	d.nmro_nta
			And	  c.cnsctvo_cdgo_tpo_nta		=	d.cnsctvo_cdgo_tpo_nta
			And	  d.cnsctvo_prdo				=	j.cnsctvo_cdgo_prdo_lqdcn
			and   2 = a.cnsctvo_cdgo_tpo_dcmnto
			and   c.cnsctvo_nta_cntrto = a.cnsctvo_dcmnto)
			,
			(select j.dscrpcn_prdo_lqdcn
			from tbEstadosCuentaContratos e,tbestadosCuenta f,tbliquidaciones l,tbperiodosliquidacion j
			where f.cnsctvo_estdo_cnta	=	e.cnsctvo_estdo_cnta
			And	  f.cnsctvo_cdgo_lqdcn		=	l.cnsctvo_cdgo_lqdcn
			And	  l.cnsctvo_cdgo_prdo_lqdcn	=	j.cnsctvo_cdgo_prdo_lqdcn
			And   1 = a.cnsctvo_cdgo_tpo_dcmnto
			And   e.cnsctvo_estdo_cnta_cntrto= a.cnsctvo_dcmnto)) prdo_lqdcn_nota
		from #TmpDatosNota a LEFT OUTER JOIN #Tmptotales b
		on (a.cnsctvo_nta_cntrto = b.cnsctvo_nta_cntrto
			and a.nmro_cntrto = b.nmro_cntrto
			and a.cnsctvo_nta_cncpto = b.cnsctvo_nta_cncpto)
		 

		update #TmpConceptosNotas
		Set prdo_lqdcn = b.dscrpcn_prdo_lqdcn
		From tbperiodosliquidacion b 
		inner join #TmpConceptosNotas a
		on a.cnsctvo_prdo = b.cnsctvo_cdgo_prdo_lqdcn			


    end   

DROP TABLE #Tmptotales
DROP TABLE #tmpContratosNotas
DROP TABLE #TmpConceptosNotas
DROP TABLE #tmpBeneficiarios
DROP TABLE #TmpDatosNota
DROP TABLE #TmpCantidadContratosConcepto



