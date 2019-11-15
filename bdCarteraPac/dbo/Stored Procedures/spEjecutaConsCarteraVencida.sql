


/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spEjecutaConsCarteraVencida
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento para generar el reporte de la cartera vebcida		 	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003/02/10											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM  Ing. Fernando Valencia E AM\>
* Descripcion			: <\DM  Se cambia  el orden de salida de lso campos DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  FM\>
*---------------------------------------------------------------------------------
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM  Ing. Fernando Valencia E AM\>
* Descripcion			: <\DM  Se implementa el manejo de responsable de pago en el campo sucursal 999999999 DM\>
* Descripcion			: <\DM  para realizar impresión  o exportar datos de todas las sucursales sAU 48368 DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  2006/08/18FM\>
*---------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[spEjecutaConsCarteraVencida]

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
@IcInstruccion1	Nvarchar(4000),
@IcInstruccion2	Nvarchar(4000),
@IcInstruccion3	Nvarchar(4000),
@IcInstruccion4	Nvarchar(4000),
@lcAlias		char(2),
@lnContador		Int,
@ldFechaSistema	Datetime,
@Fecha_Corte		Datetime,
@cnsctvo_scrsl 	int,
@Fecha_Caracter	varchar(15)	


Set Nocount On
/*
select top 100 * 
from dbo.tbEstadosCuenta ec where ec.sldo_estdo_cnta > 0
and  ec.fcha_gnrcn > '20070501'
select * from bdafiliacion.dbo.tbEmpleadores
*/
Select	@ldFechaSistema	=	Getdate()


--Se cruzan los contratos asociados a las sucursales y se traer las sucursales finales para liquidar

-- Contador de condiciones

Select @lnContador = 1

-- se crea la tabla temporal con la infromacion de las sucursales que s epuedan liquidar
				
						
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
	e.fcha_incl_prdo_lqdcn	fcha_crte	
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

Select  @IcInstruccion	=  				'Insert	into	#tmpEstadosCuenta
							SELECT   a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte ,
							  	   a.Fcha_crcn , bdrecaudos.dbo.fnCalculaPeriodo (a.Fcha_crcn) Periodo,
								   c.sldo ,
								   b.prmtr_crtra_pc,
								   b.sde_crtra_pc   ,
								   c.cnsctvo_cdgo_tpo_cntrto,
								   c.nmro_cntrto	,
								    1	cnsctvo_cdgo_tpo_dcmnto,
								    a.nmro_estdo_cnta , c.cntdd_bnfcrs , e.fcha_incl_prdo_lqdcn	fcha_crte	 '	+ char(13)	
Set @IcInstruccion	 =	 @IcInstruccion + '	FROM      tbestadosCuenta a,	
								   bdafiliacion..tbSedes s ,
								   tbpromotores  p,	
								   bdafiliacion..tbSucursalesAportante b  ,
								   TbEstadosCuentaContratos  c,
								   Tbliquidaciones d ,
								   Tbperiodosliquidacion_vigencias e ,
								   bdAfiliacion.dbo.tbClasesAportantes l ' + char(13)

Set    @IcInstruccion1 = 'Where 	   c.sldo 	>	 0 '

Set    @IcInstruccion2 = 	 +'   	And	  a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr  ' + char(13)
			+'	And	  a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte  ' + char(13)
			+'	And	  a.cnsctvo_scrsl		=	b.cnsctvo_scrsl     ' + char(13)
			+'	And	  b.sde_crtra_pc			=	s.cnsctvo_cdgo_sde  ' + char(13)
			+'	And	  a.cnsctvo_estdo_cnta		=	c.cnsctvo_estdo_cnta  ' + char(13)
			+'	And	  b.prmtr_crtra_pc		=	p.cnsctvo_cdgo_prmtr  ' + char(13)
			+'	And	  d.cnsctvo_cdgo_estdo_lqdcn	=	3	  ' + char(13)
			+'	And	  e.cnsctvo_cdgo_prdo_lqdcn	=	d.cnsctvo_cdgo_prdo_lqdcn  ' + char(13)
			+'	And	  a.cnsctvo_cdgo_lqdcn		=	d.cnsctvo_cdgo_lqdcn  ' + char(13)
			+'  And   a.cnsctvo_cdgo_estdo_estdo_cnta  != 4 ' + char(13)  --anulado
			+'	And	  b.cnsctvo_cdgo_clse_aprtnte	=	l.cnsctvo_cdgo_clse_aprtnte' + Char(13)

							   			
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

Update	#tbCriteriosTmp
Set	tbla = 'tbClasesAportantes'
Where	cdgo_cmpo	= 'cnsctvo_cdgo_clse_aprtnte'

Select 	@cnsctvo_scrsl	 		=	vlr	
From 	#tbCriteriosTmp
Where 	cdgo_cmpo 	 		= 	'cnsctvo_scrsl' 

if @cnsctvo_scrsl = 999999999
  Begin
  	delete #tbCriteriosTmp where cdgo_cmpo='cnsctvo_scrsl' and vlr='999999999'
  end	
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
					Else
					Begin
						If  CHARINDEX('tbClasesAportantes',@tbla,1) != 0
						Begin
		
							-- si tabla es tbTiposIdentificacion se asigna como alias e
							Select @lcAlias = 'l.'
						End
					End
				End
			End
		End

		-- se le adicionan adelante y atras comillas simples al valor de la condicion cuando es diferente el campo de nmro_nta
		
		if CHARINDEX('cnsctvo_cdgo_pgo',@cdgo_cmpo,1) = 0 
			Select @vlr = char(39) + rtrim(ltrim(@vlr)) + char(39) 

/*		If CHARINDEX('cnsctvo_cdgo_clse_aprtnte',@cdgo_cmpo,1) = 0
			Select @vlr = char(39) + rtrim(ltrim(@vlr)) + char(39) */		
	
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
			
				if @cnsctvo_scrsl = 999999999 ---Si viene de sucursal inexistente debe cambiar  la clase aportante y el nui  a la tabla a
					begin
						if ltrim(rtrim(@cdgo_cmpo))='l.cnsctvo_cdgo_clse_aprtnte'
						begin	                                                                                                       
							set @cdgo_cmpo='a.cnsctvo_cdgo_clse_aprtnte'
						end
						if ltrim(rtrim(@cdgo_cmpo))='b.nmro_unco_idntfccn_empldr'
						begin	                                                                                                       
							set @cdgo_cmpo='a.nmro_unco_idntfccn_empldr'
						end	
		
						Select @IcInstruccion1= @IcInstruccion1 + '  And ' +   ltrim(rtrim(@cdgo_cmpo)) + space(1) +  ltrim(rtrim(@oprdr)) + space(1) + ltrim(rtrim(@vlr)) + char(13)
					end
				else 
					begin
						Select @IcInstruccion1= @IcInstruccion1 + '  And ' +   ltrim(rtrim(@cdgo_cmpo)) + space(1) +  ltrim(rtrim(@oprdr)) + space(1) + ltrim(rtrim(@vlr)) + char(13)
					end
		End
	
		
		Set @lnContador = @lnContador + 1
		Fetch crCriterios Into @tbla ,@cdgo_cmpo ,@oprdr ,@vlr ,@cmpo_rlcn ,@cmpo_rlcn_prmtro,	 @cnsctvo
	End
	-- se cierra el cursor
	Close crCriterios
	Deallocate crCriterios
	
	Select @IcInstruccion = @IcInstruccion+char(13)+ @IcInstruccion1+char(13)+@IcInstruccion2
	

/*	SELECT 'cadena1',substring(ltrim(rtrim(@IcInstruccion)),1,250)
	Select substring(ltrim(rtrim(@IcInstruccion)),251,250)
	Select 'cadena2',substring(ltrim(rtrim(@IcInstruccion)),501,250)
	select substring(ltrim(rtrim(@IcInstruccion)),751,250)
	Select 'cadena3',substring(ltrim(rtrim(@IcInstruccion)),1001,250)  
	Select substring(ltrim(rtrim(@IcInstruccion)),1251,250)*/

Exec sp_executesql     @IcInstruccion
--print @IcInstruccion

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
	e.fcha_incl_prdo_lqdcn	fcha_crte	
into	#tmpNotasDebito
from 	tbnotasPac a, bdafiliacion..tbsucursalesaportante  b,
	tbnotasContrato c,
	tbperiodosliquidacion_vigencias e
where	 c.sldo_nta_cntrto		 >	 0
And	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
And	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl
And	a.nmro_nta			=	c.nmro_nta
And	a.cnsctvo_cdgo_tpo_nta		=	c.cnsctvo_cdgo_tpo_nta
And	e.cnsctvo_cdgo_prdo_lqdcn	=	a.cnsctvo_prdo
And	 1				=	2

Select  @IcInstruccion	=  				'Insert	into	#tmpNotasDebito
							SELECT   a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte ,
							  	   a.Fcha_crcn_nta , bdrecaudos.dbo.fnCalculaPeriodo (a.Fcha_crcn_nta) Periodo,
								   c.sldo_nta_cntrto,
								   b.prmtr_crtra_pc,
								   b.sde_crtra_pc   ,
								   c.cnsctvo_cdgo_tpo_cntrto,
							  	   c.nmro_cntrto,
								    2	cnsctvo_cdgo_tpo_dcmnto,
								    a.nmro_nta ,   0    cntdd_bnfcrs, 	e.fcha_incl_prdo_lqdcn	fcha_crte		'+ char(13)	
Set @IcInstruccion	 =	 @IcInstruccion + '	FROM      tbnotasPac a,	
								   bdafiliacion..tbSedes s ,
								   tbpromotores  p,	
								   bdafiliacion..tbSucursalesAportante b , tbnotasContrato c,
								   tbperiodosliquidacion_vigencias e ,
								   bdAfiliacion.dbo.tbClasesAportantes l ' + char(13)

		

Set    @IcInstruccion1 = 'Where 	   c.sldo_nta_cntrto 	>	 0 '

Set    @IcInstruccion2 = 	 +'   	And	  a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr  ' + char(13)
			+'	And	  a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte  ' + char(13)
			+'	And	  a.cnsctvo_scrsl		=	b.cnsctvo_scrsl     ' + char(13)
			+'	And	  b.sde_crtra_pc		=	s.cnsctvo_cdgo_sde  ' + char(13)
			+'	And	  a.nmro_nta			=	c.nmro_nta     ' + char(13)
			+'	And	  a.cnsctvo_cdgo_tpo_nta	=	c.cnsctvo_cdgo_tpo_nta  ' + char(13)
			+'	And	  a.cnsctvo_cdgo_tpo_nta	=	1  ' + char(13)    --Nota Debito
			+'	And	  a.cnsctvo_cdgo_estdo_nta	!=	6  ' + char(13)    --Estado diferente de anulada
			+'	And	  b.prmtr_crtra_pc		=	p.cnsctvo_cdgo_prmtr  ' + char(13)
			+'	And	  e.cnsctvo_cdgo_prdo_lqdcn	=	a.cnsctvo_prdo  ' + char(13)
			+'	And	b.cnsctvo_cdgo_clse_aprtnte	=	l.cnsctvo_cdgo_clse_aprtnte' + Char(13)




   			
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
					Else
					Begin
						If  CHARINDEX('tbClasesAportantes',@tbla,1) != 0
						Begin
		
							-- si tabla es tbTiposIdentificacion se asigna como alias e
							Select @lcAlias = 'l.'
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
			--Sau 48368 terminado  (2006/08/18)
			if @cnsctvo_scrsl = 999999999 ---Si viene de sucursal inexistente debe cambiar  la clase aportante y el nui  a la tabla a
				begin
					if ltrim(rtrim(@cdgo_cmpo))='l.cnsctvo_cdgo_clse_aprtnte'
					begin	                                                                                                       
						set @cdgo_cmpo='a.cnsctvo_cdgo_clse_aprtnte'
					end
					if ltrim(rtrim(@cdgo_cmpo))='b.nmro_unco_idntfccn_empldr'
					begin	                                                                                                       
						set @cdgo_cmpo='a.nmro_unco_idntfccn_empldr'
					end	
					Select @IcInstruccion1= @IcInstruccion1 + '  And ' +   ltrim(rtrim(@cdgo_cmpo)) + space(1) +  ltrim(rtrim(@oprdr)) + space(1) + ltrim(rtrim(@vlr)) + char(13)
				end
				else 
				begin
					Select @IcInstruccion1= @IcInstruccion1 + '  And ' +   ltrim(rtrim(@cdgo_cmpo)) + space(1) +  ltrim(rtrim(@oprdr)) + space(1) + ltrim(rtrim(@vlr)) + char(13)
				end
		End
		Set @lnContador = @lnContador + 1
		Fetch crCriterios Into @tbla ,@cdgo_cmpo ,@oprdr ,@vlr ,@cmpo_rlcn ,@cmpo_rlcn_prmtro,	 @cnsctvo
	End
	-- se cierra el cursor
	Close crCriterios
	Deallocate crCriterios
	
	-- se crea el select
	
	Select @IcInstruccion = @IcInstruccion+char(13)+ @IcInstruccion1+char(13) +@IcInstruccion2
	/*SELECT 'cadena1',substring(ltrim(rtrim(@IcInstruccion)),1,250)
	Select substring(ltrim(rtrim(@IcInstruccion)),251,250)
	Select 'cadena2',substring(ltrim(rtrim(@IcInstruccion)),501,250)
	select substring(ltrim(rtrim(@IcInstruccion)),751,250)
	Select 'cadena3',substring(ltrim(rtrim(@IcInstruccion)),1001,250)  
	Select substring(ltrim(rtrim(@IcInstruccion)),1251,250)*/

Exec sp_executesql     @IcInstruccion

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
		fcha_crte
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
	   fcha_crte
into	  #tmpDocumentosDebitos
From	  #tmpEstadosCuenta



Update #tmpDocumentosDebitos
Set	dfrnca_mra	=	Datediff(Month,Convert(varchar(6), Periodo)+'01',Substring(convert(varchar(8),@Fecha_Corte,112),1,6)+ '01')


Select  	   nmro_unco_idntfccn_empldr, 
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
	   fcha_crte
into	   #tmpCarteraVencidaTotal
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
	 convert(datetime,null)	fn_vgnca_cntrto,
	 convert(char(10),fcha_crte,111) as fcha_crte,
	 e.cnsctvo_cdgo_sde,
	 0 cnsctvo_cdgo_tpo_idntfccn_empldr,
	space(10) As cdgo_assr,	
	space(150) As nmbre_assr,		
	space(150) As nmbre_crdndr,
	Convert(Datetime,Null) As fcha_inco_cntrto_prdo,
	Convert(Datetime,Null) As fcha_fn_cntrto_prdo	
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
	inco_vgnca_cntrto		=	b.inco_vgnca_cntrto,
	fn_vgnca_cntrto = b.fn_vgnca_cntrto
From	#tmpInfomeCarteraFinal  a,  bdAfiliacion..tbcontratos b
Where   a.nmro_cntrto			=	b.nmro_cntrto
And	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto



Update	#tmpInfomeCarteraFinal
Set	fcha_inco_cntrto_prdo		= b.inco_vgnca_cntrto,
	fcha_fn_cntrto_prdo			= b.fn_vgnca_cntrto
From	#tmpInfomeCarteraFinal  a,  
		bdAfiliacion.dbo.tbcontratos b,
		bdAfiliacion.dbo.tbVigenciasContrato c
Where   a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn_afldo
And		b.cnsctvo_cdgo_tpo_cntrto	=	1	-- POS 
And		b.nmro_cntrto				=	c.nmro_cntrto
And		b.cnsctvo_cdgo_tpo_cntrto	=	c.cnsctvo_cdgo_tpo_cntrto
And		c.estdo_rgstro				=	'S'
And		a.fcha_crte					>=	c.inco_vgnca_estdo_cntrto
And		a.fcha_crte					<=	c.fn_vgnca_estdo_cntrto



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




Select	fc.nmro_frmlro,			
	fc.cnsctvo_cdgo_tpo_frmlro,
	com.cnsctvo_cdgo_assr,
	space(150) As nmbre_assr,		
	space(10) As cdgo_assr,			
	space(150) As nmbre_crdndr,		
	com.cnsctvo_cdgo_tpo_cntrto,		
	com.nmro_cntrto
Into	#tmpFormulario
From		#tmpInfomeCarteraFinal icf inner join bdAfiliacion.DBO.tbformulariosxcontrato fc
on icf.cnsctvo_cdgo_tpo_cntrto = fc.cnsctvo_cdgo_tpo_cntrto
and icf.nmro_cntrto = fc.nmro_cntrto
inner join bdAfiliacion.DBO.tbformularioscomision com With(index(IX_Contrato))
on	fc.cnsctvo_cdgo_tpo_cntrto	= com.cnsctvo_cdgo_tpo_cntrto
And	fc.nmro_cntrto			= com.nmro_cntrto
And 	fc.cnsctvo_cdgo_tpo_frmlro = com.cnsctvo_cdgo_tpo_frmlro
And 	fc.nmro_frmlro = com.nmro_frmlro

Update	#tmpFormulario
Set	nmbre_assr 		= ltrim(rtrim(Isnull(a.prmr_nmbre,'')))+' '+ltrim(rtrim(Isnull(a.sgndo_nmbre,'')))+' '+ltrim(rtrim(Isnull(a.prmr_aplldo,'')))+' '+ltrim(rtrim(Isnull(a.sgndo_aplldo,''))),
    	cdgo_assr		= c.cdgo_assr
From	#tmpFormulario f inner join 	bdafiliacion.dbo.tbCodigosAsesor_Vigencias c
on f.cnsctvo_cdgo_assr		=	c.cnsctvo_cdgo_assr
inner join 	bdafiliacion.dbo.tbAsesoresComerciales a
on	c.cnsctvo_assr 			= 	a.cnsctvo_assr


update #tmpFormulario
set	nmbre_crdndr = ltrim(rtrim(Isnull(b.prmr_nmbre,'')))+' '+
			ltrim(rtrim(Isnull(b.sgndo_nmbre,'')))+' '+
			ltrim(rtrim(Isnull(b.prmr_aplldo,'')))+' '+
			ltrim(rtrim(Isnull(b.sgndo_aplldo,'')))
from	#tmpFormulario a , 
bdAfiliacion.DBO.tbAsesoresComerciales b ,
bdAfiliacion.DBO.tbCodigosAsesor_Vigencias c, 
bdAfiliacion.DBO.tbCodigosAsesor_Vigencias d
where 	a.cdgo_assr = c.cdgo_assr
And 	c.cnsctvo_cdgo_assr_jfe = d.cnsctvo_cdgo_assr
and	d.cnsctvo_assr		= b.cnsctvo_assr 
and	getdate() between c.inco_vgnca and c.fn_vgnca
and	getdate() between d.inco_vgnca and d.fn_vgnca



Update	icf
Set		icf.cdgo_assr = f.cdgo_assr, 
 				icf.nmbre_assr = f.nmbre_assr,		
	 			icf.nmbre_crdndr = f.nmbre_crdndr
From	#tmpInfomeCarteraFinal icf Inner Join #tmpFormulario f
on icf.cnsctvo_cdgo_tpo_cntrto = f.cnsctvo_cdgo_tpo_cntrto
and icf.nmro_cntrto = f.nmro_cntrto

Update	#tmpInfomeCarteraFinal
Set		cdgo_assr = ' ', 
 				nmbre_assr = ' ',		
	 			nmbre_crdndr = ' '
where ltrim(rtrim(cdgo_assr)) = '9999'




Select     a.*   , 	convert(char(10),@Fecha_Corte,111)	 Fecha_Corte,
	right(replicate('0',20)+ltrim(rtrim(nmro_unco_idntfccn_empldr)),20) + right(replicate('0',2)+ltrim(rtrim(cnsctvo_scrsl)),2) + right(replicate('0',2)+ltrim(rtrim(cnsctvo_cdgo_clse_aprtnte)),2)	Responsable,
	dscrpcn_tpo_dcmnto
	From 	 #tmpInfomeCarteraFinal a ,  tbtipodocumentos b
	Where	a.cnsctvo_cdgo_tpo_dcmnto	=	b.cnsctvo_cdgo_tpo_dcmnto
	Order By a.cnsctvo_scrsl,a.nmbre_ctznte, fcha_crte, a.cnsctvo_cdgo_pln, a.nmro_cntrto



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
Drop table #tmpInfomeCartera





