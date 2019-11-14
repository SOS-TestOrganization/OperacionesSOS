

/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spEjecutaConsultaPagos
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento arma y ejecuta la cadena donde se tiene los criterios para seleccionar los pagos  	D\>
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
CREATE PROCEDURE [dbo].[spEjecutaConsultaPagos]

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
	


Select		a.cnsctvo_cdgo_pgo,	a.nmro_dcmnto, 		vlr_dcmnto,	0	nmro_unco_idntfccn_empldr,	0 cnsctvo_scrsl,		0	 cnsctvo_cdgo_clse_aprtnte,
		fcha_rcdo, 
		nmro_rmsa,
		nmro_lna,
		cnsctvo_cdgo_estdo_pgo,  
		cnsctvo_cdgo_tpo_pgo,
		usro_crcn,
		a.sldo_pgo	
into		#TmpPagos
From		tbPagos  a



Update 		#TmpPagos
Set		nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr,
		cnsctvo_scrsl			=	b.cnsctvo_scrsl,
		cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
From		#TmpPagos   a,  	 TbEstadoscuenta  b
Where		a.nmro_dcmnto			=	b.nmro_estdo_cnta



Update 		#TmpPagos
Set		nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr,
		cnsctvo_scrsl			=	b.cnsctvo_scrsl,
		cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
From		#TmpPagos   a,  	 tbcuentasmanuales  b
Where		a.nmro_dcmnto			=	b.nmro_estdo_cnta



SELECT         a.cnsctvo_cdgo_pgo,			 e.dscrpcn_estdo_pgo,		t.dscrpcn_tpo_pgo,
	          f.cdgo_tpo_idntfccn, 			d.nmro_idntfccn, 			i.dscrpcn_clse_aprtnte,
	          b.nmbre_scrsl,	 			 a.vlr_dcmnto, 			a.fcha_rcdo,
	          a.nmro_unco_idntfccn_empldr, 		 a.cnsctvo_scrsl, 		a.cnsctvo_cdgo_clse_aprtnte,
	         f.dscrpcn_tpo_idntfccn, 
                         SPACE(200) AS rzn_scl, 			d.cnsctvo_cdgo_tpo_idntfccn, 
	         a.cnsctvo_cdgo_estdo_pgo,
	         a.cnsctvo_cdgo_tpo_pgo,
	         d.dgto_vrfccn,
	         a.nmro_rmsa,
	         a.nmro_lna,
	         a.nmro_dcmnto,	
	         a.usro_crcn,
	         a.sldo_pgo		
into #tmpPagosFinal
FROM         #TmpPagos	 a INNER JOIN
                      bdAfiliacion.dbo.tbSucursalesAportante b 	ON 	a.nmro_unco_idntfccn_empldr 	= b.nmro_unco_idntfccn_empldr AND a.cnsctvo_scrsl = b.cnsctvo_scrsl AND
                   						    	a.cnsctvo_cdgo_clse_aprtnte 	= b.cnsctvo_cdgo_clse_aprtnte INNER JOIN
                      bdAfiliacion.dbo.tbVinculados d 	      	ON 	a.nmro_unco_idntfccn_empldr 	= d.nmro_unco_idntfccn INNER JOIN
                      bdAfiliacion.dbo.tbTiposIdentificacion f 	ON 	d.cnsctvo_cdgo_tpo_idntfccn 	= f.cnsctvo_cdgo_tpo_idntfccn INNER JOIN
                      bdAfiliacion.dbo.tbClasesAportantes i 	ON 	b.cnsctvo_cdgo_clse_aprtnte 	= i.cnsctvo_cdgo_clse_aprtnte INNER JOIN
                      tbestadospago e 				ON 	a.cnsctvo_cdgo_estdo_pgo 	= e.cnsctvo_cdgo_estdo_pgo  INNER JOIN
	        tbTipospago      T				ON	a.cnsctvo_cdgo_tpo_pgo		= t.cnsctvo_cdgo_tpo_pgo	






Update 	#tmpPagosFinal
Set	 rzn_scl	 =  c.rzn_scl
From 	#tmpPagosFinal	 a	,bdafiliacion..tbempleadores b,	bdafiliacion..tbempresas c --,	tbclasesempleador d
Where	a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte 
And	a.nmro_unco_idntfccn_empldr		=	c.nmro_unco_idntfccn
--And	a.vldo				=	'S'


Update 	#tmpPagosFinal
Set	 rzn_scl	 =   ltrim(rtrim(isnull(prmr_aplldo,'')))  + ' ' + ltrim(rtrim(isnull(sgndo_aplldo,''))) + ' ' + ltrim(rtrim(isnull(prmr_nmbre,''))) + ' ' + ltrim(rtrim(isnull(sgndo_nmbre,'')))
From 	#tmpPagosFinal	 a	, bdafiliacion..tbempleadores b,	bdAfiliacion..tbpersonas c
Where	a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte 
And	a.nmro_unco_idntfccn_empldr		=	c.nmro_unco_idntfccn
And	rzn_scl=''



Select @IcInstruccion	=  	'Select    a.cnsctvo_cdgo_pgo,	 	a.dscrpcn_estdo_pgo,			a.dscrpcn_tpo_pgo , 		vlr_dcmnto,	a.cdgo_tpo_idntfccn, 	
				a.nmro_idntfccn, 		 	a.dscrpcn_clse_aprtnte,			a.nmbre_scrsl, 				a.rzn_scl,	
				convert(char(20),replace(convert(char(20),a.fcha_rcdo,120), ' +   Char(39) + '-' + char(39) + ','   + Char(39) + '/' + Char(39) + ' )) fcha_rcdo, 
				a.nmro_rmsa,	a.nmro_lna,	a.nmro_dcmnto,				a.usro_crcn,
				a.cnsctvo_cdgo_estdo_pgo,
				a.cnsctvo_cdgo_tpo_pgo,
			             a.nmro_unco_idntfccn_empldr, 	a.cnsctvo_scrsl, 			a.cnsctvo_cdgo_clse_aprtnte, 	  	dgto_vrfccn, a.sldo_pgo	
				From	 #tmpPagosFinal a  '



Set	@IcInstruccion1	=	'Where    ' 

  
Set    @IcInstruccion2 =' 	'	




Update #tbCriteriosTmp
Set  cdgo_cmpo = 'usro_crcn'
Where tbla ='#tmpPagos'
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
		If  CHARINDEX('#tmpPagosFinal',@tbla,1) != 0
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
	
	/*SELECT 'cadena1',substring(ltrim(rtrim(@IcInstruccion)),1,250)
	Select substring(ltrim(rtrim(@IcInstruccion)),251,500)
	Select 'cadena2',substring(ltrim(rtrim(@IcInstruccion)),501,750)
	select substring(ltrim(rtrim(@IcInstruccion)),751,1000)
	Select 'cadena3',substring(ltrim(rtrim(@IcInstruccion)),1001,1250) */

	Exec sp_executesql     @IcInstruccion



