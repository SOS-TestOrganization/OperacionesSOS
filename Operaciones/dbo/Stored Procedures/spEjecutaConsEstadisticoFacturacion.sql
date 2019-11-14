

/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spEjecutaConsEstadisticoFacturacion
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento para generar el reporte del Estadistico de facturacion			 	D\>
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
CREATE PROCEDURE [dbo].[spEjecutaConsEstadisticoFacturacion]

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
@Fecha_Caracter	varchar(15),
@lnValorIva		numeric(12,2)	

Set Nocount On

Select	@ldFechaSistema	=	Getdate()



--Se cruzan los contratos asociados a las sucursales y se traer las sucursales finales para liquidar



 
-- Contador de condiciones
Select @lnContador = 1

-- se crea la tabla temporal con la infromacion de las sucursales que s epuedan liquidar
				
select    bdrecaudos.dbo.fnCalculaPeriodo (a.fcha_incl_prdo_lqdcn) 	fcha_incl_prdo_lqdcn,
	 cnsctvo_cdgo_lqdcn
into 	#tmpLiquidacionesFinalizadas
from 	tbperiodosliquidacion_vigencias a, tbliquidaciones b
Where   a.cnsctvo_cdgo_prdo_lqdcn	=	b.cnsctvo_cdgo_prdo_lqdcn
And	b.cnsctvo_cdgo_estdo_lqdcn	=	3
		
     
				
-- primero se hace para estados de cuenta
select  	fcha_incl_prdo_lqdcn,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	 vlr_cbrdo,   
	 cntdd_bnfcrs,
	nmro_unco_idntfccn_empldr,
	cnsctvo_cdgo_clse_aprtnte,
	cnsctvo_scrsl,
	0		sde_crtra_pc,
	convert(numeric(12,2),vlr_iva) / convert(numeric(12,2),ttl_fctrdo) * 100  Valor_iva,
	space(50)	dscrpcn_sde,
	space(10)	cdgo_sde
into	#tmpEstadisticoFacturacion
from	TbestadosCuenta a, 
	TbEstadosCuentaContratos  c,
	#tmpLiquidacionesFinalizadas  d 
where	 a.cnsctvo_estdo_cnta		=	c.cnsctvo_estdo_cnta
And	a.cnsctvo_cdgo_lqdcn		=	d.cnsctvo_cdgo_lqdcn	
And	 1	=	2

Select  @IcInstruccion	=  				'Insert	into	#tmpEstadisticoFacturacion
							SELECT    	fcha_incl_prdo_lqdcn,
									cnsctvo_cdgo_tpo_cntrto,
									nmro_cntrto,
				   				             vlr_cbrdo,   
									 cntdd_bnfcrs,
									a.nmro_unco_idntfccn_empldr,
									a.cnsctvo_cdgo_clse_aprtnte,
									a.cnsctvo_scrsl,
									0	 , 
									convert(numeric(12,2),vlr_iva) / convert(numeric(12,2),ttl_fctrdo) * 100  Valor_iva,' + 
									 char(39)  + ' ' + char(39)  + ',' + char(39) + ' ' + char(39)  + 	 char(13)	

Set @IcInstruccion	 =	 @IcInstruccion + '	FROM      tbestadosCuenta a,	
								   TbEstadosCuentaContratos  c,
								   #tmpLiquidacionesFinalizadas d  ' + char(13)

Set    @IcInstruccion1 = 'Where 	 a.cnsctvo_estdo_cnta		=	c.cnsctvo_estdo_cnta  '

Set    @IcInstruccion2 = 	   '	And	  a.cnsctvo_cdgo_lqdcn			=	d.cnsctvo_cdgo_lqdcn  ' + char(13)
			 +  '	And	  a.cnsctvo_cdgo_estdo_estdo_cnta	 != 4	 ' + char(13)

 				 
								   			
Update #tbCriteriosTmp
Set	tbla		=	'#tmpLiquidacionesFinalizadas',
	oprdr		=	'='
Where cdgo_cmpo	=	'fcha_incl_prdo_lqdcn'

								   			
Update #tbCriteriosTmp
Set	tbla		=	'tbSedes'
Where cdgo_cmpo	=	'cnsctvo_cdgo_sde'



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
					If  CHARINDEX('#tmpLiquidacionesFinalizadas',@tbla,1) != 0
					Begin
	
						-- si tabla es tbTiposIdentificacion se asigna como alias e
						Select @lcAlias = 'd.'
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


Select		@lnValorIva	=	Valor_iva
From		#tmpEstadisticoFacturacion

Update 		#tmpEstadisticoFacturacion
Set		sde_crtra_pc			=	b.sde_crtra_pc
From		#tmpEstadisticoFacturacion	a,    	bdafiliacion..tbSucursalesAportante b  
Where 		a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
And		a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
And		a.cnsctvo_scrsl			=	b.cnsctvo_scrsl


Update 		#tmpEstadisticoFacturacion
Set		dscrpcn_sde	=	s.dscrpcn_sde,
		cdgo_sde	=	s.cdgo_sde
From		#tmpEstadisticoFacturacion a,     bdafiliacion..tbSedes s 
Where 		a.sde_crtra_pc		=	s.cnsctvo_cdgo_sde	



SELECT    	fcha_incl_prdo_lqdcn,
		cnsctvo_cdgo_tpo_cntrto,
		nmro_cntrto,
	             vlr_cbrdo,   
	             cntdd_bnfcrs,
		dscrpcn_sde,
		cdgo_sde,
		space(50)  dscrpcn_pln,
		0	cnsctvo_cdgo_pln,
		convert(numeric(12,2),0)  valor_iva,
		convert(numeric(12,2),0)  valor_Fctrdo
into 	#tmpEstadisticoFacturacionFinal
From	#tmpEstadisticoFacturacion


Update #tmpEstadisticoFacturacionFinal
Set	valor_iva	=	convert(numeric(12,2),vlr_cbrdo)*@lnValorIva/(100+@lnValorIva),
	valor_Fctrdo	=	convert(numeric(12,2),vlr_cbrdo)*100/(100+@lnValorIva)


Update	#tmpEstadisticoFacturacionFinal
Set	cnsctvo_cdgo_pln		=	b.cnsctvo_cdgo_pln
From	#tmpEstadisticoFacturacionFinal  a,  bdAfiliacion..tbcontratos b
Where   a.nmro_cntrto			=	b.nmro_cntrto
And	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto


Update	#tmpEstadisticoFacturacionFinal
Set	dscrpcn_pln			=	b.dscrpcn_pln
From	#tmpEstadisticoFacturacionFinal  a,  	bdplanbeneficios..tbplanes  b
Where   a.cnsctvo_cdgo_pln		=	b.cnsctvo_cdgo_pln

Select   cdgo_sde,
	dscrpcn_sde,
	fcha_incl_prdo_lqdcn,
	dscrpcn_pln,
	sum(cntdd_bnfcrs)	cntdd_bnfcrs,
	count(nmro_cntrto)	Cntdd_Cntrts,
	convert(int,sum(vlr_cbrdo))		vlr_cbrdo,
	convert(int,sum(valor_iva))		valor_iva,
	convert(int,sum(valor_Fctrdo))		valor_Fctrdo
From	#tmpEstadisticoFacturacionFinal
Group by cdgo_sde,
	  dscrpcn_sde,
	  fcha_incl_prdo_lqdcn,
	  dscrpcn_pln
order by cdgo_sde , dscrpcn_pln


