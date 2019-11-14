

/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spEjecutaConsCarta30DiasPacAnterior
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento arma y ejecuta la cadena donde se tiene los criterios para seleccionar los promotores y sus sucursales 	D\>
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
CREATE PROCEDURE [dbo].[spEjecutaConsCarta30DiasPacAnterior]

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
				
					
		

SELECT  e.cnsctvo_cdgo_tpo_cntrto, 
	   e.nmro_cntrto ,
	   d.nmro_unco_idntfccn_empldr,
	   d.cnsctvo_cdgo_clse_aprtnte,
   	   d.cnsctvo_scrsl,
	   s.sde_crtra_pc 		 cnsctvo_cdgo_sde, 
	   f.cdgo_tpo_idntfccn, 	
	  v.nmro_idntfccn, 
	   i.dscrpcn_clse_aprtnte,
	   s.nmbre_scrsl,		
	   b.dscrpcn_prdo_lqdcn	,
	   convert(numeric(12,0),0)   sldo
	  
into	  #tmpCartaMora60Dias
FROM       tbPeriodosliquidacion_Vigencias b,	
	   tbLiquidaciones c,
	   tbEstadosCuenta d,
	   tbEstadosCuentaContratos e,
	    bdAfiliacion.dbo.tbVinculados v, 
	    bdAfiliacion.dbo.tbTiposIdentificacion f	,	
	    bdAfiliacion.dbo.tbClasesAportantes i  ,
	    bdafiliacion..tbSucursalesAportante s,
	    bdAfiliacion.dbo.Tbsedes
Where	  1	=	2

Select  @IcInstruccion	=  				'Insert	into	#tmpCartaMora60Dias
							SELECT  e.cnsctvo_cdgo_tpo_cntrto, 				   e.nmro_cntrto ,
								   d.nmro_unco_idntfccn_empldr,				   d.cnsctvo_cdgo_clse_aprtnte,
						   		   d.cnsctvo_scrsl,					   s.sde_crtra_pc ,
								    f.cdgo_tpo_idntfccn, 	
								    v.nmro_idntfccn, 
							 	    i.dscrpcn_clse_aprtnte,
								    s.nmbre_scrsl,	
								    b.dscrpcn_prdo_lqdcn	,
								   sum(e.sldo)   ' + char(13)	
Set @IcInstruccion	 =	 @IcInstruccion + '	FROM       tbPeriodosliquidacion_Vigencias b,	
								    tbLiquidaciones c,
								    tbEstadosCuenta d,
								    tbEstadosCuentaContratos e,
								    bdAfiliacion.dbo.Tbsedes	 t 	,
								    bdAfiliacion.dbo.tbVinculados v, 
		 						    bdAfiliacion.dbo.tbTiposIdentificacion f	,	
								    bdAfiliacion.dbo.tbClasesAportantes i  ,
								    bdafiliacion..tbSucursalesAportante s  ' + char(13)

		

Set    @IcInstruccion1 = 'Where 	   d.cnsctvo_cdgo_lqdcn 	=	 c.cnsctvo_cdgo_lqdcn '

Set    @IcInstruccion2 = 	 +'   	And	   c.cnsctvo_cdgo_prdo_lqdcn 	= 	b.cnsctvo_cdgo_prdo_lqdcn  ' + char(13)
			+'	And	   d.cnsctvo_estdo_cnta		= 	e.cnsctvo_estdo_cnta ' + char(13)
			+'	And	   d.nmro_unco_idntfccn_empldr	=	s.nmro_unco_idntfccn_empldr ' + char(13)
			+'	And	   d.cnsctvo_cdgo_clse_aprtnte	=	s.cnsctvo_cdgo_clse_aprtnte ' + char(13)
			+'	And          d.cnsctvo_scrsl		=	s.cnsctvo_scrsl ' + char(13)
			+ ' 	AND	   s.nmro_unco_idntfccn_empldr 	= 	v.nmro_unco_idntfccn	 ' + char(13)
			+ ' 	AND	   v.cnsctvo_cdgo_tpo_idntfccn 	=	f.cnsctvo_cdgo_tpo_idntfccn	' + char(13)
			+ '	 AND  	   d.cnsctvo_cdgo_clse_aprtnte 		=	 i.cnsctvo_cdgo_clse_aprtnte ' + char(13)
			+ ' 	AND	   t.cnsctvo_cdgo_sde	 	=	s.sde_crtra_pc	 ' + char(13)
			+ ' 	AND	 e.sldo 	> 0	 ' + char(13)
			+' 	And	 ( Getdate()   between 	fcha_incl_prdo_lqdcn            and                       fcha_fnl_prdo_lqdcn ) ' + char(13)
			+'	Group by    e.cnsctvo_cdgo_tpo_cntrto, 	  ' 	+ char(13)
			+'		     e.nmro_cntrto , ' 			+ char(13) 
			+'		     d.nmro_unco_idntfccn_empldr,	 ' 	+ char(13)
			+'		      d.cnsctvo_cdgo_clse_aprtnte , ' 	+ char(13)
			+'		     d.cnsctvo_scrsl, ' 			+ char(13)
			+'		     s.sde_crtra_pc , ' 			+ char(13)
			+'		     f.cdgo_tpo_idntfccn ,  ' 		+ char(13)
			+'		    v.nmro_idntfccn,   ' 			+ char(13)
			+'	 	    i.dscrpcn_clse_aprtnte,  ' 		+ char(13)
			+'		    s.nmbre_scrsl ,   b.dscrpcn_prdo_lqdcn	  ' 		+ char(13)
			+'	 Having	   count(e.cnsctvo_estdo_cnta_cntrto) = 1		 '

 				 
								   			


	
	
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
		If  CHARINDEX('tbPeriodosliquidacion_Vigencias',@tbla,1) != 0
		Begin
			-- si tabla es tbTiposPagoNotas se asigna como alias b
			Select @lcAlias = 'b.'
		End
		Else
		Begin
			If  CHARINDEX('tbLiquidaciones',@tbla,1) != 0
			Begin
				-- si tabla es tbVinculados se asigna como alias c
				Select @lcAlias = 'c.'
			End
			Else  
			Begin
				If  CHARINDEX('tbEstadosCuenta',@tbla,1) != 0
				Begin
					-- si tabla es tbEstadosNotas se asigna como alias d
					Select @lcAlias = 'd.'
				End
				Else  
				Begin
					If  CHARINDEX('tbEstadosCuentaContratos',@tbla,1) != 0
					Begin
	
						-- si tabla es tbTiposIdentificacion se asigna como alias e
						Select @lcAlias = 'e.'
					End
					Else
					Begin
						--select @tbla, CHARINDEX('tbParametrosProgramacion',@tbla,1)
						If  CHARINDEX('Tbsedes',@tbla,1) != 0
						Begin	
							-- si tabla es tbTiposNotas se asigna como alias f
							Select @lcAlias = 't.'
						End
						Else
						Begin
							If  CHARINDEX('tbsucursalesaportante',@tbla,1) != 0
							Begin
	
								-- si tabla es tbSedes se asigna como alias g
								Select @lcAlias = 's.'
							End
							Else
							Begin
								If  CHARINDEX('tbVinculados',@tbla,1) != 0
								Begin
		
									-- si tabla es tbPlanillas se asigna como alias h
									Select @lcAlias = 'v.'
								End
								Else
								Begin
	
									If  CHARINDEX('tbTiposIdentificacion',@tbla,1) != 0 		
									Begin
										-- si tabla es tbNotas se asigna como alias a
										Select @lcAlias = 'f.'
									End
									Else

									Begin
	
										If  CHARINDEX('tbClasesAportantes',@tbla,1) != 0 		
											Begin
												-- si tabla es tbNotas se asigna como alias a
												Select @lcAlias = 'i.'
											End
										/*else
										
											Begin
												If  CHARINDEX('tbsedes',@tbla,1) != 0 		
													Begin
														-- si tabla es tbNotas se asigna como alias a
														Select @lcAlias = 's.'
													End

	
											end		*/	


									End				


								End	
							End	
						End
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



Select	IDENTITY(Int, 1 ,1) 	AS				    Responsable_pago ,
	nmro_unco_idntfccn_empldr,				   cnsctvo_cdgo_clse_aprtnte,
	cnsctvo_scrsl
Into	#TmpResponsablePago
From	#tmpCartaMora60Dias
Group by  nmro_unco_idntfccn_empldr,				   cnsctvo_cdgo_clse_aprtnte,
	   cnsctvo_scrsl		


Select   a.cnsctvo_cdgo_tpo_cntrto, 				   a.nmro_cntrto ,
	a.nmro_unco_idntfccn_empldr,				   a.cnsctvo_cdgo_clse_aprtnte,
	a.cnsctvo_scrsl,						   a.cnsctvo_cdgo_sde ,
	a.cdgo_tpo_idntfccn, 					   a.nmro_idntfccn, 
	a.dscrpcn_clse_aprtnte,					   a.nmbre_scrsl,	
             a.dscrpcn_prdo_lqdcn,		
	a.sldo,
	c.cdgo_cdd, 
	c.dscrpcn_cdd, 		
	b.drccn, 	
	b.tlfno, 	
	space(100)	nmbre_ctznte,
	space(3)	Tpo_Idntfccn_ctznte,
	space(20)	nmro_idntfccn_ctznte
into	#TmpContratosMora30Dias
From    #tmpCartaMora60Dias a ,  bdAfiliacion.dbo.tbCiudades c 	,	
	bdAfiliacion.dbo.tbSucursalesAportante b   
Where	a.cnsctvo_scrsl 			=	 b.cnsctvo_scrsl 
And	a.cnsctvo_cdgo_clse_aprtnte 	=	 b.cnsctvo_cdgo_clse_aprtnte
And	a.nmro_unco_idntfccn_empldr 	= 	 b.nmro_unco_idntfccn_empldr	
And	b.cnsctvo_cdgo_cdd		=	 c.cnsctvo_cdgo_cdd



Update  #TmpContratosMora30Dias
Set	nmbre_ctznte		=	  ltrim(rtrim(e.prmr_aplldo))  + ' ' + ltrim(rtrim(e.sgndo_aplldo)) + ' ' + ltrim(rtrim(e.sgndo_nmbre)) + ' ' + ltrim(rtrim(e.prmr_Nmbre)) ,
	nmro_idntfccn_ctznte	=	     c.nmro_idntfccn	,
	Tpo_Idntfccn_ctznte	=	    d.cdgo_tpo_idntfccn
From	#TmpContratosMora30Dias a, bdafiliacion..tbcontratos b ,   bdafiliacion..tbvinculados c,
	bdafiliacion..tbtiposidentificacion   d  , bdAfiliacion..tbpersonas e
Where	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto
And	b.nmro_unco_idntfccn_afldo	=	c.nmro_unco_idntfccn
And       c.cnsctvo_cdgo_tpo_idntfccn 	=    	d.cnsctvo_cdgo_tpo_idntfccn
And       b.nmro_unco_idntfccn_afldo	=            e.nmro_unco_idntfccn



Select	a.Responsable_pago,
	a.nmro_unco_idntfccn_empldr,	
	a.cnsctvo_cdgo_clse_aprtnte,
	a.cnsctvo_scrsl,
	b.cnsctvo_cdgo_tpo_cntrto, 				   
	b.nmro_cntrto ,
	b.cnsctvo_cdgo_sde ,
	b.cdgo_tpo_idntfccn, 
	b.nmro_idntfccn, 
	b.dscrpcn_clse_aprtnte,			
	b.nmbre_scrsl,	
             b.dscrpcn_prdo_lqdcn,		
	b.sldo,
	b.cdgo_cdd, 
	b.dscrpcn_cdd, 		
	b.drccn, 	
	b.tlfno, 	
	b.nmbre_ctznte,
	b.Tpo_Idntfccn_ctznte,
	b.nmro_idntfccn_ctznte
From	#TmpResponsablePago a,  #TmpContratosMora30Dias b
Where	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte

And	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl


