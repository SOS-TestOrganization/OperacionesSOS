
/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spEjecutaConsCarteraXEdades
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento para generar el reporte de la cartera por edades				 	D\>
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

/*
Use bdCarteraPac
Go

CREATE TABLE #tbCriteriosTmp	(
	tbla Char(128), cdgo_cmpo Char(128), oprdr Char(2), vlr Char(250), cmpo_rlcn Char(128) NULL, 
	cmpo_rlcn_prmtro Char(128) NULL, cnsctvo Numeric(4))


Insert Into #tbCriteriosTmp Values('#TmpCarteraXEdades','fcha_crcn','>','2012/01/31','fcha_crcn','',1)

-- Truncate table #tbCriteriosTmp
*/

CREATE PROCEDURE [dbo].[spEjecutaConsCarteraXEdades]


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
@lcAlias		char(2),
@lnContador		Int,
@ldFechaSistema	Datetime,
@Fecha_Corte		Datetime,
@Fecha_Caracter	varchar(15)	

Set Nocount On

Select	@ldFechaSistema	=	Getdate()



--Se cruzan los contratos asociados a las sucursales y se traer las sucursales finales para liquidar



 
-- Contador de condiciones
Select @lnContador = 1

-- se crea la tabla temporal con la infromacion de las sucursales que s epuedan liquidar
				
					
		
-- primero se hace para estados de cuenta
select  	a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte ,
	a.Fcha_crcn , bdrecaudos.dbo.fnCalculaPeriodo (a.Fcha_crcn) Periodo,
	a.sldo_estdo_cnta,
	b.prmtr_crtra_pc	  cnsctvo_cdgo_prmtr ,           
	b.sde_crtra_pc     Cnsctvo_cdgo_sde 
into	#tmpEstadosCuenta
from tbestadosCuenta a, bdafiliacion..tbsucursalesaportante  b
where	 sldo_estdo_cnta		 >	 0
And	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
And	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl
And	 1	=	2

Select  @IcInstruccion	=  				'Insert	into	#tmpEstadosCuenta
							SELECT   a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte ,
							  	   a.Fcha_crcn , bdrecaudos.dbo.fnCalculaPeriodo (a.Fcha_crcn) Periodo,
								   a.sldo_estdo_cnta ,
								   b.prmtr_crtra_pc,
								   b.sde_crtra_pc   '+ char(13)	
Set @IcInstruccion	 =	 @IcInstruccion + '	FROM      tbestadosCuenta a,	
								   bdafiliacion..tbSedes s ,
								   tbpromotores  p,
								   Tbliquidaciones   d	,
								   bdafiliacion..tbSucursalesAportante b  ' + char(13)

		

Set    @IcInstruccion1 = 'Where 	   a.sldo_estdo_cnta 	>	 1000 '

Set    @IcInstruccion2 = 	 +'   	And	  a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr  ' + char(13)
			+'	And	  a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte  ' + char(13)
			+'	And	  a.cnsctvo_scrsl		=	b.cnsctvo_scrsl     ' + char(13)
			+'	And	  a.cnsctvo_cdgo_lqdcn		=	d.cnsctvo_cdgo_lqdcn     ' + char(13)
			+'	And	  d.cnsctvo_cdgo_estdo_lqdcn	=	3		  ' + char(13)
			+'	And	  a.cnsctvo_cdgo_estdo_estdo_cnta	!=	4	' + char(13)
			+'	And	  b.sde_crtra_pc			=	s.cnsctvo_cdgo_sde  ' + char(13)
			+'	And	  b.prmtr_crtra_pc		=	p.cnsctvo_cdgo_prmtr  ' + char(13)
			

 				 
								   			
Update #tbCriteriosTmp
Set	tbla		=	'tbestadosCuenta',
	oprdr		=	'<='
Where cdgo_cmpo	=	'fcha_crcn'

								   			
Update #tbCriteriosTmp
Set	tbla		=	'tbSedes'
Where cdgo_cmpo	=	'cnsctvo_cdgo_sde'

Update #tbCriteriosTmp
Set	tbla		=	'tbpromotores'
Where cdgo_cmpo	=	'cnsctvo_cdgo_prmtr'


Select	@Fecha_Caracter	=		 substring(ltrim(rtrim(vlr)),1,4) + 	substring(ltrim(rtrim(vlr)),6,2) + substring(ltrim(rtrim(vlr)),9,2)
From	#tbCriteriosTmp
Where    cdgo_cmpo	=	'fcha_crcn'

Set	@Fecha_Corte	=	convert(datetime,@Fecha_Caracter)

	
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
		If  CHARINDEX('tbestadosCuenta',@tbla,1) != 0
		Begin
			-- si tabla es tbTiposPagoNotas se asigna como alias b
			Select @lcAlias = 'a.'
		End
		Else
		Begin
			If  CHARINDEX('tbSucursalesAportante',@tbla,1) != 0
			Begin
				-- si tabla es tbVinculados se asigna como alias c
				Select @lcAlias = 'b.'
			End
			Else  
			Begin
				If  CHARINDEX('tbSedes',@tbla,1) != 0
				Begin
					-- si tabla es tbEstadosNotas se asigna como alias d
					Select @lcAlias = 's.'
				End
				Else  
				Begin
					If  CHARINDEX('tbpromotores',@tbla,1) != 0
					Begin
	
						-- si tabla es tbTiposIdentificacion se asigna como alias e
						Select @lcAlias = 'p.'
					End
				End					
			End	
		End	
		-- se le adicionan adelante y atras comillas simples al valor de la condicion cuando es diferente el campo de nmro_nta
		
		if CHARINDEX('cnsctvo_cdgo_pgo',@cdgo_cmpo,1) = 0 
			Select @vlr = char(39) + rtrim(ltrim(@vlr)) + char(39) 
	
		If CHARINDEX('fcha',@cdgo_cmpo,1) != 0
			Select @cdgo_cmpo = 'Convert(varchar(10),'+ @lcAlias +Ltrim(Rtrim(@cdgo_cmpo))+',111)'

		Else
		Begin
			-- se le pone el alias cuando el campo es diferente de nmro de nota
			IF CHARINDEX('cnsctvo_cdgo_pgo',@cdgo_cmpo,1) = 0
				Select @cdgo_cmpo =  @lcAlias +Ltrim(Rtrim(@cdgo_cmpo))
			
		End
		
		
		If ltrim(rtrim(@oprdr)) ='N'
		Begin
			Select @IcInstruccion1= @IcInstruccion1 +  ' And ' +  ltrim(rtrim(@cdgo_cmpo))+' Is null '+char(13)
		End
		Else
		Begin
			If ltrim(rtrim(@oprdr)) ='NN'
				Select @IcInstruccion1= @IcInstruccion1 + '  And ' +  ltrim(rtrim(@cdgo_cmpo))+' Is Not null '+char(13)
			Else
				Select @IcInstruccion1= @IcInstruccion1 + '  And ' +   ltrim(rtrim(@cdgo_cmpo)) + space(1) +  ltrim(rtrim(@oprdr)) + space(1) + ltrim(rtrim(@vlr)) + char(13)
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
	Select substring(ltrim(rtrim(@IcInstruccion)),251,250)
	Select 'cadena2',substring(ltrim(rtrim(@IcInstruccion)),501,250)
	select substring(ltrim(rtrim(@IcInstruccion)),751,250)
	Select 'cadena3',substring(ltrim(rtrim(@IcInstruccion)),1001,250)  
	Select substring(ltrim(rtrim(@IcInstruccion)),1251,250)*/

Exec sp_executesql     @IcInstruccion


--Segundo se hace para Notas Debito
select  	a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte ,
	a.Fcha_crcn_nta , bdrecaudos.dbo.fnCalculaPeriodo (a.Fcha_crcn_nta) Periodo,
	a.sldo_nta,
	b.prmtr_crtra_pc	  cnsctvo_cdgo_prmtr ,           
	b.sde_crtra_pc     Cnsctvo_cdgo_sde 
into	#tmpNotasDebito
from tbnotasPac a, bdafiliacion..tbsucursalesaportante  b
where	 sldo_nta		 >	 0
And	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
And	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl
And	 1	=	2

Select  @IcInstruccion	=  				'Insert	into	#tmpNotasDebito
							SELECT   a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte ,
							  	   a.Fcha_crcn_nta , bdrecaudos.dbo.fnCalculaPeriodo (a.Fcha_crcn_nta) Periodo,
								   a.sldo_nta ,
								   b.prmtr_crtra_pc,
								   b.sde_crtra_pc   '+ char(13)	
Set @IcInstruccion	 =	 @IcInstruccion + '	FROM      tbnotasPac a,	
								   bdafiliacion..tbSedes s ,
								   tbpromotores  p,	
								   bdafiliacion..tbSucursalesAportante b  ' + char(13)

		

Set    @IcInstruccion1 = 'Where 	   a.sldo_nta 	>	 1000 '

Set    @IcInstruccion2 = 	 +'   	And	  a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr  ' + char(13)
			+'	And	  a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte  ' + char(13)
			+'	And	  a.cnsctvo_scrsl		=	b.cnsctvo_scrsl     ' + char(13)
			+'	And	  b.sde_crtra_pc			=	s.cnsctvo_cdgo_sde  ' + char(13)
			+'	And	  a.cnsctvo_cdgo_tpo_nta	=	1  ' + char(13)    --Nota Debito
			+'	And	  a.cnsctvo_cdgo_estdo_nta	!=	6  ' + char(13)    --Estado diferente de anulada
			+'	And	  b.prmtr_crtra_pc		=	p.cnsctvo_cdgo_prmtr  ' + char(13)
			

 				 
								   			
Update  #tbCriteriosTmp
Set	 tbla		 =	'tbnotasPac',
	 oprdr		 =	'<=',
	 cdgo_cmpo	 =	'Fcha_crcn_nta'
Where    cdgo_cmpo	 =	'fcha_crcn'

						   			


	
	
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
		If  CHARINDEX('tbnotasPac',@tbla,1) != 0
		Begin
			-- si tabla es tbTiposPagoNotas se asigna como alias b
			Select @lcAlias = 'a.'
		End
		Else
		Begin
			If  CHARINDEX('tbSucursalesAportante',@tbla,1) != 0
			Begin
				-- si tabla es tbVinculados se asigna como alias c
				Select @lcAlias = 'b.'
			End
			Else  
			Begin
				If  CHARINDEX('tbSedes',@tbla,1) != 0
				Begin
					-- si tabla es tbEstadosNotas se asigna como alias d
					Select @lcAlias = 's.'
				End
				Else  
				Begin
					If  CHARINDEX('tbpromotores',@tbla,1) != 0
					Begin
	
						-- si tabla es tbTiposIdentificacion se asigna como alias e
						Select @lcAlias = 'p.'
					End
				End					
			End	
		End	
		-- se le adicionan adelante y atras comillas simples al valor de la condicion cuando es diferente el campo de nmro_nta
		
		if CHARINDEX('cnsctvo_cdgo_pgo',@cdgo_cmpo,1) = 0 
			Select @vlr = char(39) + rtrim(ltrim(@vlr)) + char(39) 
	
		If CHARINDEX('fcha',@cdgo_cmpo,1) != 0
			Select @cdgo_cmpo = 'Convert(varchar(10),'+ @lcAlias +Ltrim(Rtrim(@cdgo_cmpo))+',111)'

		Else
		Begin
			-- se le pone el alias cuando el campo es diferente de nmro de nota
			IF CHARINDEX('cnsctvo_cdgo_pgo',@cdgo_cmpo,1) = 0
				Select @cdgo_cmpo =  @lcAlias +Ltrim(Rtrim(@cdgo_cmpo))
			
		End
		
		
		If ltrim(rtrim(@oprdr)) ='N'
		Begin
			Select @IcInstruccion1= @IcInstruccion1 +  ' And ' +  ltrim(rtrim(@cdgo_cmpo))+' Is null '+char(13)
		End
		Else
		Begin
			If ltrim(rtrim(@oprdr)) ='NN'
				Select @IcInstruccion1= @IcInstruccion1 + '  And ' +  ltrim(rtrim(@cdgo_cmpo))+' Is Not null '+char(13)
			Else
				Select @IcInstruccion1= @IcInstruccion1 + '  And ' +   ltrim(rtrim(@cdgo_cmpo)) + space(1) +  ltrim(rtrim(@oprdr)) + space(1) + ltrim(rtrim(@vlr)) + char(13)
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
	Select substring(ltrim(rtrim(@IcInstruccion)),251,250)
	Select 'cadena2',substring(ltrim(rtrim(@IcInstruccion)),501,250)
	select substring(ltrim(rtrim(@IcInstruccion)),751,250)
	Select 'cadena3',substring(ltrim(rtrim(@IcInstruccion)),1001,250)  
	Select substring(ltrim(rtrim(@IcInstruccion)),1251,250)*/

Exec sp_executesql     @IcInstruccion





--Tercero se hace para Notas Debito
select  	a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte ,
	a.Fcha_crcn_nta , bdrecaudos.dbo.fnCalculaPeriodo (a.Fcha_crcn_nta) Periodo,
	a.sldo_nta,
	b.prmtr_crtra_pc	  cnsctvo_cdgo_prmtr ,           
	b.sde_crtra_pc     Cnsctvo_cdgo_sde 
into	#tmpNotasCredito
from tbnotasPac a, bdafiliacion..tbsucursalesaportante  b
where	 sldo_nta		 >	 0
And	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
And	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl
And	 1	=	2

Select  @IcInstruccion	=  				'Insert	into	#tmpNotasCredito
							SELECT   a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte ,
							  	   a.Fcha_crcn_nta , bdrecaudos.dbo.fnCalculaPeriodo (a.Fcha_crcn_nta) Periodo,
								   a.sldo_nta ,
								   b.prmtr_crtra_pc,
								   b.sde_crtra_pc   '+ char(13)	
Set @IcInstruccion	 =	 @IcInstruccion + '	FROM      tbnotasPac a,	
								   bdafiliacion..tbSedes s ,
								   tbpromotores  p,	
								   bdafiliacion..tbSucursalesAportante b  ' + char(13)

		

Set    @IcInstruccion1 = 'Where 	   a.sldo_nta 	>	 0 '

Set    @IcInstruccion2 = 	 +'   	And	  a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr  ' + char(13)
			+'	And	  a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte  ' + char(13)
			+'	And	  a.cnsctvo_scrsl		=	b.cnsctvo_scrsl     ' + char(13)
			+'	And	  b.sde_crtra_pc			=	s.cnsctvo_cdgo_sde  ' + char(13)
			+'	And	  a.cnsctvo_cdgo_tpo_nta	=	2  ' + char(13)    --Nota Credito
			+'	And	 1				=	2 ' + char(13)
			+'	And	  a.cnsctvo_cdgo_estdo_nta	!=	6  ' + char(13)    --Estado diferente de anulada
			+'	And	  b.prmtr_crtra_pc		=	p.cnsctvo_cdgo_prmtr  ' + char(13)
			

 				 

	
	
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
		If  CHARINDEX('tbnotasPac',@tbla,1) != 0
		Begin
			-- si tabla es tbTiposPagoNotas se asigna como alias b
			Select @lcAlias = 'a.'
		End
		Else
		Begin
			If  CHARINDEX('tbSucursalesAportante',@tbla,1) != 0
			Begin
				-- si tabla es tbVinculados se asigna como alias c
				Select @lcAlias = 'b.'
			End
			Else  
			Begin
				If  CHARINDEX('tbSedes',@tbla,1) != 0
				Begin
					-- si tabla es tbEstadosNotas se asigna como alias d
					Select @lcAlias = 's.'
				End
				Else  
				Begin
					If  CHARINDEX('tbpromotores',@tbla,1) != 0
					Begin
	
						-- si tabla es tbTiposIdentificacion se asigna como alias e
						Select @lcAlias = 'p.'
					End
				End					
			End	
		End	
		-- se le adicionan adelante y atras comillas simples al valor de la condicion cuando es diferente el campo de nmro_nta
		
		if CHARINDEX('cnsctvo_cdgo_pgo',@cdgo_cmpo,1) = 0 
			Select @vlr = char(39) + rtrim(ltrim(@vlr)) + char(39) 
	
		If CHARINDEX('fcha',@cdgo_cmpo,1) != 0
			Select @cdgo_cmpo = 'Convert(varchar(10),'+ @lcAlias +Ltrim(Rtrim(@cdgo_cmpo))+',111)'

		Else
		Begin
			-- se le pone el alias cuando el campo es diferente de nmro de nota
			IF CHARINDEX('cnsctvo_cdgo_pgo',@cdgo_cmpo,1) = 0
				Select @cdgo_cmpo =  @lcAlias +Ltrim(Rtrim(@cdgo_cmpo))
			
		End
		
		
		If ltrim(rtrim(@oprdr)) ='N'
		Begin
			Select @IcInstruccion1= @IcInstruccion1 +  ' And ' +  ltrim(rtrim(@cdgo_cmpo))+' Is null '+char(13)
		End
		Else
		Begin
			If ltrim(rtrim(@oprdr)) ='NN'
				Select @IcInstruccion1= @IcInstruccion1 + '  And ' +  ltrim(rtrim(@cdgo_cmpo))+' Is Not null '+char(13)
			Else
				Select @IcInstruccion1= @IcInstruccion1 + '  And ' +   ltrim(rtrim(@cdgo_cmpo)) + space(1) +  ltrim(rtrim(@oprdr)) + space(1) + ltrim(rtrim(@vlr)) + char(13)
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
	Select substring(ltrim(rtrim(@IcInstruccion)),251,250)
	Select 'cadena2',substring(ltrim(rtrim(@IcInstruccion)),501,250)
	select substring(ltrim(rtrim(@IcInstruccion)),751,250)
	Select 'cadena3',substring(ltrim(rtrim(@IcInstruccion)),1001,250)  
	Select substring(ltrim(rtrim(@IcInstruccion)),1251,250)*/

Exec sp_executesql     @IcInstruccion






--	Cuarto se hace para Pagos
select  	a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte ,
	a.Fcha_rcdo , bdrecaudos.dbo.fnCalculaPeriodo (a.Fcha_rcdo) Periodo,
	a.sldo_pgo,
	b.prmtr_crtra_pc	  cnsctvo_cdgo_prmtr ,           
	b.sde_crtra_pc     Cnsctvo_cdgo_sde 
into	#tmpPagos
from tbpagos a, bdafiliacion..tbsucursalesaportante  b
where	 sldo_pgo		 >	 0
And	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
And	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl
And	 1	=	2

Select  @IcInstruccion	=  				'Insert	into	#tmpPagos
							SELECT   a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte ,
							  	   a.Fcha_rcdo , bdrecaudos.dbo.fnCalculaPeriodo (a.Fcha_rcdo) Periodo,
								   a.sldo_pgo ,
								   b.prmtr_crtra_pc,
								   b.sde_crtra_pc   '+ char(13)	
Set @IcInstruccion	 =	 @IcInstruccion + '	FROM      tbpagos a,	
								   bdafiliacion..tbSedes s ,
								   tbpromotores  p,	
								   bdafiliacion..tbSucursalesAportante b  ' + char(13)

		

Set    @IcInstruccion1 = 'Where 	   a.sldo_pgo 	>	 0 '

Set    @IcInstruccion2 = 	 +'   	And	  a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr  ' + char(13)
			+'	And	  a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte  ' + char(13)
			+'	And	  a.cnsctvo_scrsl		=	b.cnsctvo_scrsl     ' + char(13)
			+'	And	  b.sde_crtra_pc			=	s.cnsctvo_cdgo_sde  ' + char(13)
			+'	And	 1				=	2 ' + char(13)
			+'	And	  b.prmtr_crtra_pc		=	p.cnsctvo_cdgo_prmtr  ' + char(13)
			


								   			
Update  #tbCriteriosTmp
Set	 tbla		 =	'tbpagos',
	 oprdr		 =	'<=',
	 cdgo_cmpo	 =	'Fcha_rcdo'
Where    cdgo_cmpo	 =	'Fcha_crcn_nta' 				 

	
	
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
		If  CHARINDEX('tbpagos',@tbla,1) != 0
		Begin
			-- si tabla es tbTiposPagoNotas se asigna como alias b
			Select @lcAlias = 'a.'
		End
		Else
		Begin
			If  CHARINDEX('tbSucursalesAportante',@tbla,1) != 0
			Begin
				-- si tabla es tbVinculados se asigna como alias c
				Select @lcAlias = 'b.'
			End
			Else  
			Begin
				If  CHARINDEX('tbSedes',@tbla,1) != 0
				Begin
					-- si tabla es tbEstadosNotas se asigna como alias d
					Select @lcAlias = 's.'
				End
				Else  
				Begin
					If  CHARINDEX('tbpromotores',@tbla,1) != 0
					Begin
	
						-- si tabla es tbTiposIdentificacion se asigna como alias e
						Select @lcAlias = 'p.'
					End
				End					
			End	
		End	
		-- se le adicionan adelante y atras comillas simples al valor de la condicion cuando es diferente el campo de nmro_nta
		
		if CHARINDEX('cnsctvo_cdgo_pgo',@cdgo_cmpo,1) = 0 
			Select @vlr = char(39) + rtrim(ltrim(@vlr)) + char(39) 
	
		If CHARINDEX('fcha',@cdgo_cmpo,1) != 0
			Select @cdgo_cmpo = 'Convert(varchar(10),'+ @lcAlias +Ltrim(Rtrim(@cdgo_cmpo))+',111)'

		Else
		Begin
			-- se le pone el alias cuando el campo es diferente de nmro de nota
			IF CHARINDEX('cnsctvo_cdgo_pgo',@cdgo_cmpo,1) = 0
				Select @cdgo_cmpo =  @lcAlias +Ltrim(Rtrim(@cdgo_cmpo))
			
		End
		
		
		If ltrim(rtrim(@oprdr)) ='N'
		Begin
			Select @IcInstruccion1= @IcInstruccion1 +  ' And ' +  ltrim(rtrim(@cdgo_cmpo))+' Is null '+char(13)
		End
		Else
		Begin
			If ltrim(rtrim(@oprdr)) ='NN'
				Select @IcInstruccion1= @IcInstruccion1 + '  And ' +  ltrim(rtrim(@cdgo_cmpo))+' Is Not null '+char(13)
			Else
				Select @IcInstruccion1= @IcInstruccion1 + '  And ' +   ltrim(rtrim(@cdgo_cmpo)) + space(1) +  ltrim(rtrim(@oprdr)) + space(1) + ltrim(rtrim(@vlr)) + char(13)
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
	Select substring(ltrim(rtrim(@IcInstruccion)),251,250)
	Select 'cadena2',substring(ltrim(rtrim(@IcInstruccion)),501,250)
	select substring(ltrim(rtrim(@IcInstruccion)),751,250)
	Select 'cadena3',substring(ltrim(rtrim(@IcInstruccion)),1001,250)  
	Select substring(ltrim(rtrim(@IcInstruccion)),1251,250)*/

Exec sp_executesql     @IcInstruccion



---ahora se cruzan todos los documentos debito y credito


Select  nmro_unco_idntfccn_empldr, cnsctvo_scrsl, cnsctvo_cdgo_clse_aprtnte,
             Periodo,
	sldo_estdo_cnta sldo
into	#tmpDebitos
From	#tmpEstadosCuenta

insert into	#tmpDebitos
Select	nmro_unco_idntfccn_empldr, cnsctvo_scrsl, cnsctvo_cdgo_clse_aprtnte ,
	periodo,
	sldo_nta
from	#tmpNotasDebito

Select  nmro_unco_idntfccn_empldr, cnsctvo_scrsl, cnsctvo_cdgo_clse_aprtnte,
       	Periodo, sum(sldo) TotalSaldo,
	0	Existe
into	#tmpTotalDebitos
FRom  	#tmpDebitos
Group by nmro_unco_idntfccn_empldr, cnsctvo_scrsl, cnsctvo_cdgo_clse_aprtnte,
	 Periodo
		
Select	nmro_unco_idntfccn_empldr, cnsctvo_scrsl, cnsctvo_cdgo_clse_aprtnte ,
	periodo,
	sldo_nta	sldo
into	#tmpCredito
From	#tmpNotasCredito

insert into	#tmpCredito
Select	nmro_unco_idntfccn_empldr, cnsctvo_scrsl, cnsctvo_cdgo_clse_aprtnte ,
	periodo,
	sldo_pgo
From	#tmpPagos


Select  nmro_unco_idntfccn_empldr, cnsctvo_scrsl, cnsctvo_cdgo_clse_aprtnte,
             Periodo, sum(sldo) TotalSaldo,
	0	Existe
into	#tmpTotalCreditos
FRom  	#tmpCredito
Group by nmro_unco_idntfccn_empldr, cnsctvo_scrsl, cnsctvo_cdgo_clse_aprtnte,
	 Periodo



update	#tmpTotalDebitos
Set	TotalSaldo	=	a.TotalSaldo	- b.TotalSaldo,
	Existe	=	1
From	#tmpTotalDebitos a, #tmpTotalCreditos b
Where	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
And	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
And	a.Periodo			=	b.Periodo


update	#tmpTotalCreditos
Set	Existe	=	1
From	#tmpTotalDebitos a, #tmpTotalCreditos b
Where	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
And	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
And	a.Periodo			=	b.Periodo


Select nmro_unco_idntfccn_empldr,cnsctvo_scrsl,cnsctvo_cdgo_clse_aprtnte,Periodo,TotalSaldo,
	0	dfrnca_mra,
	0	vlr_cta_0,
	0	vlr_cta_1,
	0	vlr_cta_2,
	0	vlr_cta_3,
	0	vlr_cta_4,
	0	vlr_cta_5,
	0	vlr_cta_6

into	#tmpSaldototal
From   #tmpTotalDebitos 	


insert	into	#tmpSaldototal
Select	nmro_unco_idntfccn_empldr,cnsctvo_scrsl,cnsctvo_cdgo_clse_aprtnte,Periodo,(TotalSaldo*-1) ,
	0	dfrnca_mra,
	0	vlr_cta_0,
	0	vlr_cta_1,
	0	vlr_cta_2,
	0	vlr_cta_3,
	0	vlr_cta_4,
	0	vlr_cta_5,
	0	vlr_cta_6

From	#tmpTotalCreditos
Where	Existe	=	0

Update #tmpSaldototal
Set	dfrnca_mra	=	Datediff(Month,Convert(varchar(6), Periodo)+'01',Substring(convert(varchar(8),@Fecha_Corte,112),1,6)+ '01')

--Select Datediff(Month,Convert(varchar(6), Periodo)+'01',Substring(convert(varchar(8),Getdate(),112),1,6)+ '01'), * from #tmpSaldototal

Update	#tmpSaldototal--#tmp1
Set	vlr_cta_0 	= 	Case    dfrnca_mra when 0 Then TotalSaldo 		Else 0 end,
	vlr_cta_1	=	Case 	        dfrnca_mra when 1 Then TotalSaldo 		Else 0 end,--30
	vlr_cta_2	=	Case 	        dfrnca_mra when 2 Then TotalSaldo 		Else 0 end,--60
	vlr_cta_3	=	Case 	        dfrnca_mra when 3 Then TotalSaldo 		Else 0 end, --90
	vlr_cta_4	=	Case 	  when  dfrnca_mra in(4,5,6) Then TotalSaldo 	Else 0 end, --91 a  180
	vlr_cta_5	=	Case 	  when  dfrnca_mra  > 6 and dfrnca_mra <=12   Then TotalSaldo Else 0 end,  --mas de 180 y menor que 360
	vlr_cta_6	=	Case 	  when  dfrnca_mra  > 12 Then TotalSaldo Else 0 end --mas de 360




select  nmro_unco_idntfccn_empldr,cnsctvo_scrsl,cnsctvo_cdgo_clse_aprtnte,
	sum(vlr_cta_0) vlr_cta_0,
	sum(vlr_cta_1) vlr_cta_1,
	sum(vlr_cta_2) vlr_cta_2,
	sum(vlr_cta_3) vlr_cta_3,
	sum(vlr_cta_4) vlr_cta_4,
	sum(vlr_cta_5) vlr_cta_5,
	sum(vlr_cta_6) vlr_cta_6
Into	#tmpInfomeCartera
from #tmpSaldototal
Group by nmro_unco_idntfccn_empldr,cnsctvo_scrsl,cnsctvo_cdgo_clse_aprtnte


Select	nmro_idntfccn, nmbre_scrsl,cdgo_tpo_idntfccn ,
		vlr_cta_0,
		vlr_cta_1,
		vlr_cta_2,
		vlr_cta_3,
		vlr_cta_4,
 		vlr_cta_5,
		vlr_cta_6,
		space(100) nmbre_prmtr,
		prmtr_crtra_pc,
		dscrpcn_sde,
		cdgo_sde,
		e.cnsctvo_cdgo_sde,
		a.cnsctvo_cdgo_tpo_idntfccn,
		d.cnsctvo_scrsl,
		d.drccn,
		d.tlfno,
		d.fx,
		d.eml,
		Space(150) As drccn_envo_crspndca,
		0 As cnsctvo_cdgo_cdd_crrspndnca,
		Space(8) As cdgo_cdd_envo_crspndca,
		Space(150) As dscrpccn_cdd_envo_crspndca,
		Space(30) As tlfno_envo_crspndca,
		b.nmro_unco_idntfccn_empldr,
		d.cnsctvo_cdgo_clse_aprtnte,
		0 As nmro_unco_idntfccn_aprtnte_ps_indpndnte,
		0 As cnsctvo_cdgo_clse_aprtnte_ps_indpndnte,
		Space(23) As nmro_idntfccn_aprtnte_ps_indpndnte, 
		Space(3) As cdgo_tpo_idntfccn_aprtnte_ps_indpndnte,
		Space(150) As rzn_scl_aprtnte_ps_indpndnte,
		Space(150) As drccn_aprtnte_ps_indpndnte,
		Space(30) As tlfno_aprtnte_ps_indpndnte,
		0 As cnsctvo_cdgo_cdd_aprtnte_ps_indpndnte,
		Space(150) As dscrpcn_cdgo_cdd_aprtnte_ps_indpndnte,
		0 As cnsctvo_scrsl_ctznte,
		0 As cnsctvo_cdgo_tpo_cntrto,
		Space(16) As nmro_cntrto,
		0 As cnsctvo_cbrnza,
		0 As cnsctvo_cdgo_lgr_crrspndnca
into	#tmpInfomeCarteraFinal
FRom	bdafiliacion..tbvinculados a,
		#tmpInfomeCartera b,
		bdafiliacion..tbTiposidentificacion c,
		bdafiliacion..tbsucursalesaportante d,
		bdafiliacion..tbsedes e
Where	a.nmro_unco_idntfccn		=	b.nmro_unco_idntfccn_empldr
And		a.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn
And		b.nmro_unco_idntfccn_empldr	=	d.nmro_unco_idntfccn_empldr
And		b.cnsctvo_cdgo_clse_aprtnte	=	d.cnsctvo_cdgo_clse_aprtnte
And		b.cnsctvo_scrsl				=	d.cnsctvo_scrsl
And		d.sde_crtra_pc				=	e.cnsctvo_cdgo_sde


Update #tmpInfomeCarteraFinal
Set	nmbre_prmtr	=	case	when (cnsctvo_cdgo_clse_empldr	=	1) 
					then ltrim(rtrim(prmr_aplldo)) + ltrim(rtrim(sgndo_aplldo)) + ltrim(rtrim(prmr_nmbre)) + ' '  + ltrim(rtrim(sgndo_nmbre))
					else
					ltrim(rtrim(rzn_scl)) end
From	#tmpInfomeCarteraFinal a, tbpromotores_vigencias b
Where   a.prmtr_crtra_pc	=	b.cnsctvo_cdgo_prmtr


Update	a
Set		eml								= b.eml
From	#tmpInfomeCarteraFinal a,
		bdAfiliacion.dbo.tbPersonas b
Where	a.nmro_unco_idntfccn_empldr		= b.nmro_unco_idntfccn
And		a.cnsctvo_cdgo_clse_aprtnte		= 4		-- INDEPENDIENTE
And		Ltrim(Rtrim(IsNull(a.eml,'')))	= ''

-- Actualiza el Email de los independientes

Update	a
Set		cnsctvo_cdgo_lgr_crrspndnca		= b.cnsctvo_cdgo_lgr_crrspndnca,
		cnsctvo_cdgo_cdd_crrspndnca		= IsNull(CASE	When b.cnsctvo_cdgo_lgr_crrspndnca = 3 then b.cnsctvo_cdgo_cdd_rsdnca 
												When b.cnsctvo_cdgo_lgr_crrspndnca = 4 then b.cnsctvo_cdgo_cdd_crrspndnca End,0),
		drccn_envo_crspndca				= IsNull(CASE	When b.cnsctvo_cdgo_lgr_crrspndnca = 3 then b.drccn_rsdnca 
												When b.cnsctvo_cdgo_lgr_crrspndnca = 4 then b.drccn_crrspndnca End,''),
		tlfno_envo_crspndca				= IsNull(CASE	When b.cnsctvo_cdgo_lgr_crrspndnca = 3 then b.tlfno_rsdnca 
												When b.cnsctvo_cdgo_lgr_crrspndnca = 4 then b.tlfno_crrspndnca End,'')
From	#tmpInfomeCarteraFinal a,
		bdAfiliacion.dbo.tbPersonas b
Where	a.nmro_unco_idntfccn_empldr		= b.nmro_unco_idntfccn
And		a.cnsctvo_cdgo_clse_aprtnte		= 4		-- INDEPENDIENTE




-- Actualiza la ciuad de correspondecia

Update a
Set		cdgo_cdd_envo_crspndca		= b.cdgo_cdd,
		dscrpccn_cdd_envo_crspndca	= b.dscrpcn_cdd
From			#tmpInfomeCarteraFinal a
Inner Join		BDAfiliacion.dbo.tbCiudades_Vigencias b		On	IsNull(a.cnsctvo_cdgo_cdd_crrspndnca,0) = b.cnsctvo_cdgo_cdd
															And Getdate() BetWeen b.inco_vgnca And b.fn_vgnca



-- Actualiza los datos del empleador para los independientes que tienen un Pos activo en Sos

/*
Select	a.nmro_unco_idntfccn_empldr,
		a.cnsctvo_cdgo_clse_aprtnte,
		c.*
From	#tmpInfomeCarteraFinal a,
		bdAfiliacion.dbo.tbContratos b,
		bdAfiliacion.dbo.tbCobranzas c
Where	a.cnsctvo_cdgo_clse_aprtnte		= 4		-- INDEPENDIENTE
And		a.nmro_unco_idntfccn_empldr		= b.nmro_unco_idntfccn_afldo
And		b.cnsctvo_cdgo_pln				= 1		-- POS
--And		a.cnsctvo_cdgo_clse_aprtnte		= b.cnsctvo_cdgo_clse_aprtnte
And		b.estdo_cntrto					= 'A'
And		b.cnsctvo_cdgo_tpo_cntrto		= c.cnsctvo_cdgo_tpo_cntrto
And		b.nmro_cntrto					= c.nmro_cntrto
And		c.estdo							= 'A'
*/

Update	a
Set		nmro_unco_idntfccn_aprtnte_ps_indpndnte	= c.nmro_unco_idntfccn_aprtnte,
		cnsctvo_cdgo_clse_aprtnte_ps_indpndnte	= c.cnsctvo_cdgo_clse_aprtnte,
		cnsctvo_cdgo_tpo_cntrto					= c.cnsctvo_cdgo_tpo_cntrto,
		nmro_cntrto								= c.nmro_cntrto,
		cnsctvo_cbrnza							= c.cnsctvo_cbrnza
From	#tmpInfomeCarteraFinal a,
		bdAfiliacion.dbo.tbContratos b,
		bdAfiliacion.dbo.tbCobranzas c
Where	a.cnsctvo_cdgo_clse_aprtnte		= 4		-- INDEPENDIENTE
And		a.nmro_unco_idntfccn_empldr		= b.nmro_unco_idntfccn_afldo
And		b.cnsctvo_cdgo_pln				= 1		-- POS
And		b.estdo_cntrto					= 'A'
And		b.cnsctvo_cdgo_tpo_cntrto		= c.cnsctvo_cdgo_tpo_cntrto
And		b.nmro_cntrto					= c.nmro_cntrto
And		c.estdo							= 'A'


-- Se actualiza la sucursal vigente del cotizante

Update	a
Set		cnsctvo_scrsl_ctznte					= d.cnsctvo_scrsl_ctznte
From	#tmpInfomeCarteraFinal a,
		bdAfiliacion.dbo.tbVigenciasCobranzas d
Where	a.cnsctvo_cdgo_clse_aprtnte		= 4		-- INDEPENDIENTE
And		a.cnsctvo_cdgo_tpo_cntrto		= d.cnsctvo_cdgo_tpo_cntrto
And		a.nmro_cntrto					= d.nmro_cntrto
And		a.cnsctvo_cbrnza				= d.cnsctvo_cbrnza
And		d.estdo_rgstro					= 'S'
And		Getdate()						>= d.inco_vgnca_cbrnza
And		Getdate()						<= d.fn_vgnca_cbrnza
And		IsNull(a.nmro_cntrto,'')		!= ''


-- Actualiza el tipo y numero de identificacion para los independientes que tienen un Pos activo en Sos

Update	a
Set		nmro_idntfccn_aprtnte_ps_indpndnte		= b.nmro_idntfccn, 
		cdgo_tpo_idntfccn_aprtnte_ps_indpndnte	= c.cdgo_tpo_idntfccn
From	#tmpInfomeCarteraFinal a,
		bdAfiliacion.dbo.tbVinculados b,
		bdAfiliacion.dbo.tbTiposIdentificacion c
Where	nmro_unco_idntfccn_aprtnte_ps_indpndnte = b.nmro_unco_idntfccn
And		b.vldo									= 'S'
And		b.cnsctvo_cdgo_tpo_idntfccn				= c.cnsctvo_cdgo_tpo_idntfccn



-- Actualiza el tipo y numero de identificacion para los independientes 

Update	a
Set		rzn_scl_aprtnte_ps_indpndnte			= ltrim(rtrim(Isnull(b.prmr_nmbre,'')))+' '+ltrim(rtrim(Isnull(b.sgndo_nmbre,'')))+' '+ltrim(rtrim(Isnull(b.prmr_aplldo,'')))+' '+ltrim(rtrim(Isnull(b.sgndo_aplldo,''))),
		drccn_aprtnte_ps_indpndnte				= b.drccn_rsdnca,
		tlfno_aprtnte_ps_indpndnte				= b.tlfno_rsdnca,
		cnsctvo_cdgo_cdd_aprtnte_ps_indpndnte	= b.cnsctvo_cdgo_cdd_rsdnca,
		dscrpcn_cdgo_cdd_aprtnte_ps_indpndnte	= c.dscrpcn_cdd
From	#tmpInfomeCarteraFinal a,
		bdAfiliacion.dbo.tbPersonas b,
		bdAfiliacion.dbo.tbCiudades c
Where	nmro_unco_idntfccn_aprtnte_ps_indpndnte = b.nmro_unco_idntfccn
And		cnsctvo_cdgo_clse_aprtnte_ps_indpndnte	= 4	-- Independiente
And		b.cnsctvo_cdgo_cdd_rsdnca				= c.cnsctvo_cdgo_cdd


-- Actualiza el tipo y numero de identificacion para las AFP o Entidad Agrupadora

Update a 
Set		rzn_scl_aprtnte_ps_indpndnte			= x.nmbre_scrsl,
		drccn_aprtnte_ps_indpndnte				= x.drccn,
		cnsctvo_cdgo_cdd_aprtnte_ps_indpndnte	= x.cnsctvo_cdgo_cdd,
		tlfno_aprtnte_ps_indpndnte				= x.tlfno,
		dscrpcn_cdgo_cdd_aprtnte_ps_indpndnte	= c.dscrpcn_cdd
From	#tmpInfomeCarteraFinal a, 
		bdAfiliacion.dbo.tbSucursalesAportante x,
		bdAfiliacion.dbo.tbCiudades c
Where	a.nmro_unco_idntfccn_aprtnte_ps_indpndnte	= x.nmro_unco_idntfccn_empldr
And		a.cnsctvo_cdgo_clse_aprtnte_ps_indpndnte	= x.cnsctvo_cdgo_clse_aprtnte
And		a.cnsctvo_scrsl_ctznte						= x.cnsctvo_scrsl
And		x.cnsctvo_cdgo_cdd							= c.cnsctvo_cdgo_cdd




select  nmro_idntfccn,							nmbre_scrsl,								cdgo_tpo_idntfccn,
		vlr_cta_0,								vlr_cta_1,									vlr_cta_2,
		vlr_cta_3,								vlr_cta_4,									vlr_cta_5,
		vlr_cta_6,								nmbre_prmtr,								prmtr_crtra_pc,
		dscrpcn_sde,							cdgo_sde,									cnsctvo_scrsl,	
		drccn As drccn_scrsl,					tlfno  As tlfno_scrsl,						fx As fx_scrsl,	
		eml,									
		drccn_envo_crspndca,					cdgo_cdd_envo_crspndca,						dscrpccn_cdd_envo_crspndca, 
		tlfno_envo_crspndca, 
		nmro_idntfccn_aprtnte_ps_indpndnte,		cdgo_tpo_idntfccn_aprtnte_ps_indpndnte,
		rzn_scl_aprtnte_ps_indpndnte,			drccn_aprtnte_ps_indpndnte,					tlfno_aprtnte_ps_indpndnte,
		dscrpcn_cdgo_cdd_aprtnte_ps_indpndnte,	cnsctvo_scrsl_ctznte,						nmro_cntrto,
		@Fecha_Corte Fecha_Corte,				cnsctvo_cdgo_sde
from #tmpInfomeCarteraFinal a
order by cdgo_sde, cdgo_tpo_idntfccn, nmbre_scrsl --, nmro_idntfccn

--order by nmbre_prmtr , cnsctvo_cdgo_sde, cdgo_tpo_idntfccn, nmro_idntfccn


/*

select  a.*
from #tmpInfomeCarteraFinal a
Where	nmro_idntfccn = '31483881'

*/




drop table #tmpEstadosCuenta
drop table #tmpNotasDebito
drop table #tmpNotasCredito
drop table #tmpPagos
drop table #tmpCredito
drop table #tmpDebitos
Drop table #tmpSaldototal
Drop table #tmpTotalDebitos
Drop table #tmpTotalCreditos
Drop table #tmpInfomeCarteraFinal
drop table #tmpInfomeCartera





