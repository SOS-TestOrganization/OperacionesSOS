

/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spPlanoIngenioManuelita
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento para generar el plano del ingenio manuelita				 	D\>
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
CREATE    PROCEDURE spPlanoIngenioManuelita

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



--Se cruzan los contratos asociados a las sucursales y se traer las sucursales finales para liquidar



 
-- Contador de condiciones
Select @lnContador = 1

-- se crea la tabla temporal con la infromacion de las sucursales que s epuedan liquidar
				
Select	 cnsctvo_scrsl ,nmro_unco_idntfccn_empldr ,cnsctvo_cdgo_clse_aprtnte , cdgo_aprtnte					
into	#TmpManuelita
From	 TbPlanoFichaManuelita
Group by  cnsctvo_scrsl ,nmro_unco_idntfccn_empldr ,cnsctvo_cdgo_clse_aprtnte 		, cdgo_aprtnte			
		
-- primero se hace para estados de cuenta
select  	b.cnsctvo_cdgo_tpo_cntrto,
	b.nmro_cntrto,
	b.vlr_cbrdo,
	a.Fcha_crcn , 
	a.cnsctvo_cdgo_lqdcn,
	a.cnsctvo_scrsl ,
	a.nmro_unco_idntfccn_empldr ,
	a.cnsctvo_cdgo_clse_aprtnte 		,
	c.cdgo_aprtnte		
into	#tmpPlanoManuelita
from tbestadosCuenta a, tbestadoscuentacontratos  b, #TmpManuelita c
where	 a.cnsctvo_estdo_cnta		=	b.cnsctvo_estdo_cnta
And	 a.cnsctvo_scrsl			=	c.cnsctvo_scrsl
And	 a.nmro_unco_idntfccn_empldr	=	c.nmro_unco_idntfccn_empldr
And	 a.cnsctvo_cdgo_clse_aprtnte	=	c.cnsctvo_cdgo_clse_aprtnte
And	 1	=	2

Select  @IcInstruccion	=  				'Insert	into	#tmpPlanoManuelita
							SELECT   b.cnsctvo_cdgo_tpo_cntrto,
								   b.nmro_cntrto,
							  	   b.vlr_cbrdo,
							  	   a.Fcha_crcn , 
								   a.cnsctvo_cdgo_lqdcn ,
								   a.cnsctvo_scrsl ,
							 	   a.nmro_unco_idntfccn_empldr ,
								   a.cnsctvo_cdgo_clse_aprtnte 	,
								  c.cdgo_aprtnte	  '+ char(13)	
Set @IcInstruccion	 =	 @IcInstruccion + '	FROM      tbestadosCuenta a,	
								   tbestadoscuentacontratos b,
								   #TmpManuelita  c,
								   Tbliquidaciones   d	 ' + char(13)

		

Set    @IcInstruccion1 = 'Where 	   a.nmro_unco_idntfccn_empldr	=	c.nmro_unco_idntfccn_empldr  '

Set    @IcInstruccion2 = 	 +'	And	  a.cnsctvo_cdgo_clse_aprtnte	=	c.cnsctvo_cdgo_clse_aprtnte  ' + char(13)
			+'	And	  a.cnsctvo_scrsl		=	c.cnsctvo_scrsl     ' + char(13)
			+'	And	  a.cnsctvo_cdgo_lqdcn		=	d.cnsctvo_cdgo_lqdcn     ' + char(13)
			+'	And	  a.cnsctvo_estdo_cnta		=	b.cnsctvo_estdo_cnta     ' + char(13)
			+'	And	  d.cnsctvo_cdgo_estdo_lqdcn	=	3		  ' + char(13)
			

 				 
								   			
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
	a.vlr_cbrdo,
	a.cnsctvo_scrsl ,
	a.nmro_unco_idntfccn_empldr ,
	a.cnsctvo_cdgo_clse_aprtnte ,
	b.nmro_unco_idntfccn_afldo,
	space(20)	nmro_fcha,
	space(1)	tpo_empldo,
	a.cdgo_aprtnte,
	(a.vlr_cbrdo/2)  Valor_quincenal ,		
	(a.vlr_cbrdo/4)  Valor_Semanal 		
into	#tmpPlanoManuelitaFinal
From	 #tmpPlanoManuelita a, bdafiliacion..tbcontratos  b
Where	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto

Update 	#tmpPlanoManuelitaFinal
Set	nmro_fcha	=	b.nmro_fcha,
	tpo_empldo	=	b.tpo_empldo
From	#tmpPlanoManuelitaFinal a,  TbPlanoFichaManuelita b
Where	a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn
And	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
And	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl
	

Select * from #tmpPlanoManuelitaFinal order by convert(int,nmro_fcha)

