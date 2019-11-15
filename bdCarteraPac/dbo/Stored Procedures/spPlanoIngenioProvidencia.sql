/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spPlanoIngenioProvidencia
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
* Modificado Por			: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  FM\>
*---------------------------------------------------------------------------------*/
CREATE  PROCEDURE spPlanoIngenioProvidencia
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
@lnPorcentajeIva	numeric(12,3)



Set Nocount On

Select	@ldFechaSistema	=	Getdate()



--Se cruzan los contratos asociados a las sucursales y se traer las sucursales finales para liquidar


-- Contador de condiciones
Select @lnContador = 1

				
Select	    nmro_unco_idntfccn_empldr 		
into	   #TmpProvidencia
From	   TbPlanoFichaProvidencia
Group by  nmro_unco_idntfccn_empldr	
		
-- primero se hace para estados de cuenta
select  	b.cnsctvo_cdgo_tpo_cntrto,
	b.nmro_cntrto,
	convert(numeric(12,3),b.vlr_cbrdo)		vlr_cbrdo,
	a.Fcha_crcn , 
	a.cnsctvo_cdgo_lqdcn,
	a.nmro_unco_idntfccn_empldr ,
	convert(numeric(12,3),a.ttl_fctrdo)		ttl_fctrdo,
	convert(numeric(12,3),a.vlr_iva)		vlr_iva
into	#tmpPlanoProvidencia
from tbestadosCuenta a, tbestadoscuentacontratos  b, #TmpProvidencia c
where	 a.cnsctvo_estdo_cnta		=	b.cnsctvo_estdo_cnta
And	 a.nmro_unco_idntfccn_empldr	=	c.nmro_unco_idntfccn_empldr
And	 1	=	2

Select  @IcInstruccion	=  				'Insert	into	#tmpPlanoProvidencia
							SELECT   b.cnsctvo_cdgo_tpo_cntrto,
								   b.nmro_cntrto,
							  	   b.vlr_cbrdo,
							  	   a.Fcha_crcn , 
								   a.cnsctvo_cdgo_lqdcn ,
								   a.nmro_unco_idntfccn_empldr ,
								   a.ttl_fctrdo,
								   a.vlr_iva  '+ char(13)	
Set @IcInstruccion	 =	 @IcInstruccion + '	FROM      tbestadosCuenta a,	
								   tbestadoscuentacontratos b,
								   #TmpProvidencia  c,
								   Tbliquidaciones   d	 ' + char(13)

		

Set    @IcInstruccion1 = 'Where 	   a.nmro_unco_idntfccn_empldr	=	c.nmro_unco_idntfccn_empldr  '

Set    @IcInstruccion2 = 	 +'	And	  a.cnsctvo_cdgo_lqdcn		=	d.cnsctvo_cdgo_lqdcn     ' + char(13)
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

Select	@lnPorcentajeIva	=	(vlr_iva	/	ttl_fctrdo) 	* 	100
From	#tmpPlanoProvidencia

Select   a.cnsctvo_cdgo_tpo_cntrto,
	a.nmro_cntrto,
	a.vlr_cbrdo ,
	a.nmro_unco_idntfccn_empldr ,
	b.nmro_unco_idntfccn_afldo,
	space(20)	nmro_fcha,
	space(1)	tpo_empldo,
	(vlr_cbrdo * 100) / (100 + @lnPorcentajeIva ) 		      Valor_plan,
	(vlr_cbrdo * @lnPorcentajeIva) / (100 + @lnPorcentajeIva )  Valor_iva,
	b.inco_vgnca_cntrto,
	space(20)	nmro_idntfccn,
	space(100)	nombre
into	#tmpPlanoProvidenciaFinal
From	 #tmpPlanoProvidencia a, bdafiliacion..tbcontratos  b
Where	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto

Update 	#tmpPlanoProvidenciaFinal
Set	nmro_fcha	=	b.nmro_fcha,
	tpo_empldo	=	b.tpo_empldo
From	#tmpPlanoProvidenciaFinal a,  TbPlanoFichaProvidencia  b
Where	a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn
And	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr

-- Se actuliza el numero de identificacion
Update 	#tmpPlanoProvidenciaFinal
Set	nmro_idntfccn		=	b.nmro_idntfccn
From	#tmpPlanoProvidenciaFinal a,  bdafiliacion..tbVinculados   b
Where	a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn

Update 	#tmpPlanoProvidenciaFinal
Set	nombre		=	ltrim(rtrim(d.prmr_aplldo)) + ' ' + ltrim(rtrim(d.sgndo_aplldo)) + ' ' + ltrim(rtrim(d.prmr_nmbre)) + ' ' +ltrim(rtrim(sgndo_nmbre)) 
From	#tmpPlanoProvidenciaFinal a,  bdafiliacion..tbpersonas d
Where	a.nmro_unco_idntfccn_afldo	=	d.nmro_unco_idntfccn

Select 	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	convert(int,vlr_cbrdo) vlr_cbrdo,
	nmro_unco_idntfccn_empldr 
	nmro_unco_idntfccn_afldo,
	nmro_fcha,
	tpo_empldo,
	convert(int,Valor_plan)	 Valor_plan,	
	convert(int,Valor_iva)	 Valor_iva,	
	inco_vgnca_cntrto,
	nmro_idntfccn,
	nombre
into	#tmpPlanoProvidenciaReporte
From	#tmpPlanoProvidenciaFinal

Select  * from #tmpPlanoProvidenciaReporte