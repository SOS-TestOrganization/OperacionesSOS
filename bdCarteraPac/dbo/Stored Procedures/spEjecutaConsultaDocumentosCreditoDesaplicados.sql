﻿

/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spEjecutaConsultaDocumentosCreditoDesaplicados
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento arma y ejecuta la cadena donde se tiene los criterios para seleccionar las notas  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003/02/10											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[spEjecutaConsultaDocumentosCreditoDesaplicados]
			@lntipoNota		udtConsecutivo,
			@lntipoDocumento	udtConsecutivo,
			@lnNumeroInicial	varchar(15),
			@lnnumeroFinal		varchar(15)

As

Declare
@tbla			varchar(128),
@cdgo_cmpo 		varchar(128),
@oprdr 		varchar(2),
@vlr 			varchar(250),
@cmpo_rlcn 		varchar(128),
@cmpo_rlcn_prmtro 	varchar(128),
@cnsctvo		Numeric(4),
@IcInstruccion		Nvarchar(4000),
@IcInstruccion1		Nvarchar(4000),
@IcInstruccion2		Nvarchar(4000),
@ldfechaSistema	datetime,
@lcAlias		char(2),
@lnContador		Int

Set Nocount On
Set	@ldfechaSistema	=	getdate()
	-- Contador de condiciones
	Select @lnContador = 1
	


select    cnsctvo_cdgo_pgo,
	nmro_dcmnto,
	vlr_dcmnto,
	sldo_pgo,
	usro_crcn,
	fcha_crcn,
	cnsctvo_cdgo_estdo_pgo,
	0 nmro_unco_idntfccn_empldr,
	0 cnsctvo_scrsl,
	0 cnsctvo_cdgo_clse_aprtnte
into #tmpPagos1	
From    tbpagos
where   cnsctvo_cdgo_estdo_pgo 	<>  1 -- y esten aplicados
And	cnsctvo_cdgo_tpo_pgo	 =  2 ---manuales
and	usro_crcn		<> 'Migracion01'


update   #tmpPagos1
Set	 nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr,
	 cnsctvo_scrsl			=	b.cnsctvo_scrsl,
	 cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
From	 #tmpPagos1 a, tbEstadosCuenta b
Where    a.nmro_dcmnto	=	b.nmro_estdo_cnta


update   #tmpPagos1
Set	 nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr,
	 cnsctvo_scrsl			=	b.cnsctvo_scrsl,
	 cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
From	 #tmpPagos1 a, tbNotasPac b
Where    a.nmro_dcmnto			=	b.nmro_nta
And	 b.cnsctvo_cdgo_tpo_nta		=	1  ---tipo de nota debito
and      a.nmro_unco_idntfccn_empldr	=	0



SELECT         a.nmro_nta         nmro_dcmto,	 e.dscrpcn_estdo_nta 	dscrpcn_Estdo_dcmnto,	
 	          f.cdgo_tpo_idntfccn, 	              d.nmro_idntfccn, 			i.dscrpcn_clse_aprtnte,
	          b.nmbre_scrsl, 			a.vlr_nta      Vlr_Dcmnto , 	
	         h.fcha_incl_prdo_lqdcn,		 h.fcha_fnl_prdo_lqdcn, 	
	         a.usro_crcn,		
                      a.nmro_unco_idntfccn_empldr, 	a.cnsctvo_scrsl, 		a.cnsctvo_cdgo_clse_aprtnte, 	a.vlr_iva, 
	         a.sldo_nta sldo_dcmnto , 					f.dscrpcn_tpo_idntfccn, 
                       a.fcha_crcn_nta         fcha_crcn ,
	         SPACE(200) AS rzn_scl, 		d.cnsctvo_cdgo_tpo_idntfccn, 
	         a.cnsctvo_cdgo_tpo_nta,
	         a.cnsctvo_cdgo_estdo_nta,
	         d.dgto_vrfccn,
	        a.fcha_crcn_nta,
		        3		  cnsctvo_cdgo_tpo_dcmnto         	   --- notas credito
into #tmpDocumentosCredito
FROM         tbNotasPac a INNER JOIN
                      bdAfiliacion.dbo.tbSucursalesAportante b 	ON 	a.nmro_unco_idntfccn_empldr 	= b.nmro_unco_idntfccn_empldr AND a.cnsctvo_scrsl = b.cnsctvo_scrsl AND
                   						    	a.cnsctvo_cdgo_clse_aprtnte 	= b.cnsctvo_cdgo_clse_aprtnte INNER JOIN
                      bdAfiliacion.dbo.tbVinculados d 	      	ON 	a.nmro_unco_idntfccn_empldr 	= d.nmro_unco_idntfccn INNER JOIN
                      bdAfiliacion.dbo.tbTiposIdentificacion f 	ON 	d.cnsctvo_cdgo_tpo_idntfccn 	= f.cnsctvo_cdgo_tpo_idntfccn INNER JOIN
                      tbPeriodosliquidacion_Vigencias h 		ON 	a.cnsctvo_prdo 			= h.cnsctvo_cdgo_prdo_lqdcn INNER JOIN
                      bdAfiliacion.dbo.tbClasesAportantes i 	ON 	b.cnsctvo_cdgo_clse_aprtnte 	= i.cnsctvo_cdgo_clse_aprtnte INNER JOIN
                      tbEstadosNota e 				ON 	a.cnsctvo_cdgo_estdo_nta 	= e.cnsctvo_cdgo_estdo_nta  
WHERE         a.cnsctvo_cdgo_tpo_nta			=		2	--notas Credito	
And	         a.usro_crcn <> 'Migracion01'
Union
SELECT       convert(varchar(15), cnsctvo_cdgo_pgo)   	 nmro_dcmnto ,			 e.dscrpcn_estdo_pgo 	dscrpcn_Estdo_dcmnto,		 f.cdgo_tpo_idntfccn, 	d.nmro_idntfccn, 			i.dscrpcn_clse_aprtnte,
	          b.nmbre_scrsl, 				a.vlr_dcmnto, 	
	         Null ,		 			Null,
	         a.usro_crcn,		
                      a.nmro_unco_idntfccn_empldr, 	a.cnsctvo_scrsl, 		a.cnsctvo_cdgo_clse_aprtnte, 	0  vlr_iva, 
	         a.sldo_pgo  sldo_dcmto, 					f.dscrpcn_tpo_idntfccn, 
                       a.fcha_crcn,
	         SPACE(200) AS rzn_scl, 		d.cnsctvo_cdgo_tpo_idntfccn, 
	         0 cnsctvo_cdgo_tpo_nta,
	         0 cnsctvo_cdgo_estdo_nta,
	         d.dgto_vrfccn,
	         a.fcha_crcn   fcha_crcn_nta         	,
                    4		  cnsctvo_cdgo_tpo_dcmnto         	   --- Pagos
FROM           #tmpPagos1 a INNER JOIN
                      bdAfiliacion.dbo.tbSucursalesAportante b 	ON 	a.nmro_unco_idntfccn_empldr 	= b.nmro_unco_idntfccn_empldr AND a.cnsctvo_scrsl = b.cnsctvo_scrsl AND
                   						    	a.cnsctvo_cdgo_clse_aprtnte 	= b.cnsctvo_cdgo_clse_aprtnte INNER JOIN
                      bdAfiliacion.dbo.tbVinculados d 	      	ON 	a.nmro_unco_idntfccn_empldr 	= d.nmro_unco_idntfccn INNER JOIN
                      bdAfiliacion.dbo.tbTiposIdentificacion f 	ON 	d.cnsctvo_cdgo_tpo_idntfccn 	= f.cnsctvo_cdgo_tpo_idntfccn INNER JOIN
                      bdAfiliacion.dbo.tbClasesAportantes i 	ON 	b.cnsctvo_cdgo_clse_aprtnte 	= i.cnsctvo_cdgo_clse_aprtnte INNER JOIN
                      TbEstadosPago			 e	ON 	a.cnsctvo_cdgo_estdo_pgo 	= e.cnsctvo_cdgo_estdo_pgo  






Update 	#tmpDocumentosCredito
Set	 rzn_scl	 =  c.rzn_scl
From 	#tmpDocumentosCredito	 a	,bdafiliacion..tbempleadores b,	bdafiliacion..tbempresas c --,	tbclasesempleador d
Where	a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte 
And	a.nmro_unco_idntfccn_empldr		=	c.nmro_unco_idntfccn
--And	a.vldo				=	'S'


Update 	#tmpDocumentosCredito
Set	 rzn_scl	 =   ltrim(rtrim(isnull(prmr_aplldo,'')))  + ' ' + ltrim(rtrim(isnull(sgndo_aplldo,''))) + ' ' + ltrim(rtrim(isnull(prmr_nmbre,''))) + ' ' + ltrim(rtrim(isnull(sgndo_nmbre,'')))
From 	#tmpDocumentosCredito	 a	, bdafiliacion..tbempleadores b,	bdAfiliacion..tbpersonas c
Where	a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte 
And	a.nmro_unco_idntfccn_empldr		=	c.nmro_unco_idntfccn
And	rzn_scl=''




Select    dscrpcn_tpo_dcmnto,	 a.nmro_dcmto,  	dscrpcn_estdo_dcmnto , a.vlr_dcmnto  ,  a.cdgo_tpo_idntfccn, 	a.nmro_idntfccn, 			a.dscrpcn_clse_aprtnte,
	a.nmbre_scrsl, 	a.rzn_scl,	
	convert(char(20),replace(convert(char(20),a.fcha_crcn,120),'-','/'))	 fcha_crcn	,a.usro_crcn,sldo_dcmnto,
	a.cnsctvo_cdgo_estdo_nta  ,a.cnsctvo_cdgo_tpo_nta,
             a.nmro_unco_idntfccn_empldr, 	a.cnsctvo_scrsl, 		a.cnsctvo_cdgo_clse_aprtnte ,  dgto_vrfccn	,
	a.fcha_crcn_nta , a.cnsctvo_cdgo_tpo_dcmnto
into	#tmpDocumentosCreditoFinal
 from	 #tmpDocumentosCredito a,  tbtipodocumentos  b
Where	a.cnsctvo_cdgo_tpo_dcmnto	=	b.cnsctvo_cdgo_tpo_dcmnto





if 	@lntipoDocumento	=	1

	SELECT       dscrpcn_tpo_dcmnto,	 	nmro_dcmto, 		dscrpcn_Estdo_dcmnto, 
		       vlr_dcmnto , cdgo_tpo_idntfccn, 	nmro_idntfccn, 			dscrpcn_clse_aprtnte,
		        nmbre_scrsl, 			rzn_scl,			fcha_crcn ,
		        usro_crcn,		


		        nmro_unco_idntfccn_empldr, 	cnsctvo_scrsl, 		cnsctvo_cdgo_clse_aprtnte, 	
		        cnsctvo_cdgo_tpo_nta,
		        cnsctvo_cdgo_estdo_nta , 		 		dgto_vrfccn, a.fcha_crcn_nta , cnsctvo_cdgo_tpo_dcmnto ,
		        sldo_dcmnto
	From	        #tmpDocumentosCreditoFinal  a 
	Where	        cnsctvo_cdgo_tpo_dcmnto	=	4
	And	        nmro_dcmto>=@lnNumeroInicial and  nmro_dcmto<=@lnnumeroFinal
else
	SELECT       dscrpcn_tpo_dcmnto,	 	nmro_dcmto, 		dscrpcn_Estdo_dcmnto, 
		        vlr_dcmnto , 		 	cdgo_tpo_idntfccn, 	nmro_idntfccn, 			dscrpcn_clse_aprtnte,
		        nmbre_scrsl, 			rzn_scl,			fcha_crcn ,
		        usro_crcn,		
		        nmro_unco_idntfccn_empldr, 	cnsctvo_scrsl, 		cnsctvo_cdgo_clse_aprtnte, 	
		        cnsctvo_cdgo_tpo_nta,
		        cnsctvo_cdgo_estdo_nta , 		 		dgto_vrfccn, a.fcha_crcn_nta , cnsctvo_cdgo_tpo_dcmnto ,
		        sldo_dcmnto
	From	        #tmpDocumentosCreditoFinal  a 
	Where	        cnsctvo_cdgo_tpo_dcmnto	=	3
	And	        nmro_dcmto>=@lnNumeroInicial and  nmro_dcmto<=@lnnumeroFinal





/*
Select @IcInstruccion	=  	'SELECT       dscrpcn_tpo_dcmnto,	 	nmro_dcmto, 		dscrpcn_Estdo_dcmnto , 
					        sldo_dcmnto , 			 	cdgo_tpo_idntfccn, 	nmro_idntfccn, 			dscrpcn_clse_aprtnte,
					        nmbre_scrsl, 			rzn_scl,			fcha_crcn ,
					        usro_crcn,		
				                     nmro_unco_idntfccn_empldr, 	cnsctvo_scrsl, 		cnsctvo_cdgo_clse_aprtnte, 	
					        cnsctvo_cdgo_tpo_nta,
					        cnsctvo_cdgo_estdo_nta , 		vlr_dcmnto , 		dgto_vrfccn, a.fcha_crcn_nta , cnsctvo_cdgo_tpo_dcmnto '
					       
					+   'From   #tmpDocumentosCreditoFinal  a '
Set	@IcInstruccion1	=	'Where    ' 
if	@lntipoDocumento	=	1	---Nota Credito
	Set	@IcInstruccion1	=	'Where  cnsctvo_cdgo_tpo_dcmnto = 3  ' 
else
  	Set	@IcInstruccion1	=	'Where  cnsctvo_cdgo_tpo_dcmnto =4  ' 
Set    @IcInstruccion2 =' 	'	




Update #tbCriteriosTmp
Set  cdgo_cmpo = 'usro_crcn'
Where tbla ='#tmpNotas'
and cdgo_cmpo='lgn_usro'


	
	
	
	-- Se recorre el cursor de criterios
	Declare crCriterios Cursor  For
	Select	*
	From	#tbCriteriosTmp 
	Order by cnsctvo 
	
	Open crCriterios
	
	Fetch crCriterios Into @tbla ,@cdgo_cmpo ,@oprdr ,@vlr ,@cmpo_rlcn ,@cmpo_rlcn_prmtro,	 @cnsctvo
	
	While @@fetch_status =  0 
	Begin
		Select @lcAlias = ''
		Select @tbla = Ltrim(Rtrim(@tbla))
	

		-- se realiza la asignacion del alias
		If  CHARINDEX('#tmpDocumentosCreditoFinal',@tbla,1) != 0
		Begin
			-- si tabla es tbTiposNotas se asigna como alias b
			Select @lcAlias = 'a.'
		End
		Else
		-- se le adicionan adelante y atras comillas simples al valor de la condicion cuando es diferente el campo de nmro_nta
		--if CHARINDEX('nmro_nta',@cdgo_cmpo,1) = 0 -- Ltrim(Rtrim(@cdgo_cmpo)) != 'convert(int,substring(nmro_nta,4,15))'
			Select @vlr = char(39) + rtrim(ltrim(@vlr)) + char(39) 
	
		If CHARINDEX('fcha',@cdgo_cmpo,1) != 0
			Select @cdgo_cmpo = 'Convert(varchar(10),'+ @lcAlias +Ltrim(Rtrim(@cdgo_cmpo))+',111)'
		Else
		Begin
			-- se le pone el alias cuando el campo es diferente de nmro de nota
			--IF CHARINDEX('nmro_nta',@cdgo_cmpo,1) = 0--Ltrim(Rtrim(@cdgo_cmpo)) != 'convert(int,substring(nmro_nta,4,15))'
				Select @cdgo_cmpo =  @lcAlias +Ltrim(Rtrim(@cdgo_cmpo))
			
		End
		
		If @lnContador = 1
	             Begin
			If ltrim(rtrim(@oprdr)) ='N'
			Begin
				Select @IcInstruccion1= @IcInstruccion1 +  ltrim(rtrim(@cdgo_cmpo))+' Is null '+char(13)
			End
			Else
			Begin
				If ltrim(rtrim(@oprdr)) ='NN'
					Select @IcInstruccion1= @IcInstruccion1 +  ltrim(rtrim(@cdgo_cmpo))+' Is not null '+char(13)	
				Else
					Select @IcInstruccion1= @IcInstruccion1 +  ltrim(rtrim(@cdgo_cmpo)) + space(1) +  ltrim(rtrim(@oprdr)) + space(1) + ltrim(rtrim(@vlr)) + char(13)
			End
	     	End
		Else
	     	Begin
			If ltrim(rtrim(@oprdr)) ='N'
			Begin
				Select @IcInstruccion1= @IcInstruccion1 + 'And ' +  ltrim(rtrim(@cdgo_cmpo))+' Is null '+char(13)
			End
			Else
			Begin
				If ltrim(rtrim(@oprdr)) ='NN'
					Select @IcInstruccion1= @IcInstruccion1 + 'And ' +  ltrim(rtrim(@cdgo_cmpo))+' Is Not null '+char(13)
				Else
					Select @IcInstruccion1= @IcInstruccion1 + 'And ' +   ltrim(rtrim(@cdgo_cmpo)) + space(1) +  ltrim(rtrim(@oprdr)) + space(1) + ltrim(rtrim(@vlr)) + char(13)
			End
	
	     	End
			
		
		Set @lnContador = @lnContador + 1
		Fetch crCriterios Into @tbla ,@cdgo_cmpo ,@oprdr ,@vlr ,@cmpo_rlcn ,@cmpo_rlcn_prmtro,	 @cnsctvo
	End
	-- se cierra el cursor
	Close crCriterios
	Deallocate crCriterios
	
	-- se crea el select
	Select @IcInstruccion = @IcInstruccion+char(13)+ @IcInstruccion1+char(13)+@IcInstruccion2
	*/
	--SELECT 'cadena1',substring(ltrim(rtrim(@IcInstruccion)),1,250)
	--Select substring(ltrim(rtrim(@IcInstruccion)),251,500)
	--Select 'cadena2',substring(ltrim(rtrim(@IcInstruccion)),501,750)
	--select substring(ltrim(rtrim(@IcInstruccion)),751,1000)
	--Select 'cadena3',substring(ltrim(rtrim(@IcInstruccion)),1001,1250) 

--	Exec sp_executesql     @IcInstruccion

