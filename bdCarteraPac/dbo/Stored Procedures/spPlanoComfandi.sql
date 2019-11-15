
/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spPlanoComfandi
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento para generar el plano del ingenio Providencia				 	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003/02/10											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM  Ing. Fernando Valencia EAM\>
* Descripcion			: <\DM  Se incluyen los planes quimbaya en el plan 268 por la fusion de comfacartagoa comfandi DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  2006/08/25 FM\>
*---------------------------------------------------------------------------------*/
CREATE    PROCEDURE spPlanoComfandi
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
@ldFechaSistema	Datetime


	



Set Nocount On



Select	@ldFechaSistema	=	Getdate()



-- Contador de condiciones
Select @lnContador = 1

	


-- primero se hace para estados de cuenta
select  	b.cnsctvo_cdgo_tpo_cntrto,
	b.nmro_cntrto,
	b.vlr_cbrdo,
	a.Fcha_crcn , 
	a.cnsctvo_cdgo_lqdcn,
	a.nmro_unco_idntfccn_empldr ,
	b.cntdd_bnfcrs
into	#tmpPlanoComfandi
from tbestadosCuenta a, tbestadoscuentacontratos  b
where	 a.cnsctvo_estdo_cnta		=	b.cnsctvo_estdo_cnta
And	 1	=	2

Select  @IcInstruccion	=  				'Insert	into	#tmpPlanoComfandi
							SELECT   b.cnsctvo_cdgo_tpo_cntrto,
								   b.nmro_cntrto,
							  	   b.vlr_cbrdo,
							  	   a.Fcha_crcn , 
								   a.cnsctvo_cdgo_lqdcn ,
								   a.nmro_unco_idntfccn_empldr  ,
								   b.cntdd_bnfcrs '+ char(13)	
Set @IcInstruccion	 =	 @IcInstruccion + '	FROM      tbestadosCuenta a,	
								   tbestadoscuentacontratos b,
								   Tbliquidaciones   d	 ' + char(13)

		


Set    @IcInstruccion1 = 'Where 	   a.nmro_unco_idntfccn_empldr	=	100419 '

Set    @IcInstruccion2 = 	 +'	And	  a.cnsctvo_cdgo_lqdcn		=	d.cnsctvo_cdgo_lqdcn     ' + char(13)
			+'	And	  a.cnsctvo_estdo_cnta		=	b.cnsctvo_estdo_cnta     ' + char(13)
			--+'	And	  d.cnsctvo_cdgo_estdo_lqdcn	=	3		  ' + char(13)
			
				 
								   			
Update #tbCriteriosTmp
Set	tbla		=	'tbestadosCuenta'

	
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



Select   a.cnsctvo_cdgo_tpo_cntrto,
	a.nmro_cntrto,
	a.vlr_cbrdo ,
	a.nmro_unco_idntfccn_empldr ,
	b.nmro_unco_idntfccn_afldo,
	space(20)	nmro_idntfccn,
	'000'	planC,
	b.cnsctvo_cdgo_pln,
	a.Fcha_crcn,
	a.cntdd_bnfcrs
into	#tmpPlanoConfamdiFinal
From	 #tmpPlanoComfandi a, bdafiliacion..tbcontratos  b
Where	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto

Update #tmpPlanoConfamdiFinal
Set	planC	=	'268'
From	#tmpPlanoConfamdiFinal
Where	cnsctvo_cdgo_pln	in (2,6)  --2  familiar   6 Quimbaya


Update #tmpPlanoConfamdiFinal
Set	planC	=	'230'
From	#tmpPlanoConfamdiFinal
Where	cnsctvo_cdgo_pln	=	8  -- bienestar


Update #tmpPlanoConfamdiFinal
Set	planC	=	'266'
From	#tmpPlanoConfamdiFinal
Where	cnsctvo_cdgo_pln	=	5  -- Excelencia

Update 	#tmpPlanoConfamdiFinal
Set	nmro_idntfccn		=	b.nmro_idntfccn
From	#tmpPlanoConfamdiFinal a,  bdafiliacion..tbVinculados   b
Where	a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn


Select	right(replicate('0',11)+ltrim(rtrim(nmro_idntfccn)),11) 	nmro_idntfccn,
	'00000'								lnCeros,
	planC,
	right(replicate('0',9)+ltrim(rtrim(Sum(vlr_cbrdo))),9) 		valor,
	substring(rtrim(ltrim(convert(char(10),Fcha_crcn,111))),1,4) 	Periodo,
	convert(int,substring(rtrim(ltrim(convert(char(10),Fcha_crcn,111))),6,2))	mes,
	sum(cntdd_bnfcrs)	cntdd_bnfcrs
into	#tmpPlanoConfamdiReporte
from #tmpPlanoConfamdiFinal
Group by nmro_idntfccn , planC, Fcha_crcn



Update	#tmpPlanoConfamdiReporte
Set	mes	=	(2 * mes ) - 1
From	#tmpPlanoConfamdiReporte




Select	nmro_idntfccn,
	lnCeros,
	planC,
	valor,
	right(replicate('0',2)+ltrim(rtrim(mes)),2) 		Mes,
	right(replicate('0',4)+ltrim(rtrim(Periodo)),4) 	Periodo,
	right(replicate('0',5)+ltrim(rtrim(cntdd_bnfcrs)),5) 	cntdd_bnfcrs,
	'D'	ValorFijo
From	#tmpPlanoConfamdiReporte
order by nmro_idntfccn

