

/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spEjecutaConsDetEmpleadorAnterior
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
CREATE PROCEDURE [dbo].[spEjecutaConsDetEmpleadorAnterior]

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
				
select    bdrecaudos.dbo.fnCalculaPeriodo (a.fcha_incl_prdo_lqdcn) 	prdo,
	 cnsctvo_cdgo_lqdcn
into 	#tmpLiquidacionesFinalizadas
from 	tbperiodosliquidacion_vigencias a, tbliquidaciones b
Where   a.cnsctvo_cdgo_prdo_lqdcn	=	b.cnsctvo_cdgo_prdo_lqdcn
And	b.cnsctvo_cdgo_estdo_lqdcn	=	3
		
     
				
-- primero se hace para estados de cuenta
select  	prdo,
	nmro_unco_idntfccn_empldr,
	cnsctvo_cdgo_clse_aprtnte,
	cnsctvo_scrsl,
	a.cnsctvo_estdo_cnta,
	space(200)	nmbre_scrsl,
	a.nmro_estdo_cnta
into	#tmpDetEmpleador
from	TbestadosCuenta a, 
	TbEstadosCuentaContratos  c,
	#tmpLiquidacionesFinalizadas  d 
where	 a.cnsctvo_estdo_cnta		=	c.cnsctvo_estdo_cnta
And	a.cnsctvo_cdgo_lqdcn		=	d.cnsctvo_cdgo_lqdcn	
And	 1	=	2


Select  @IcInstruccion	=  				'Insert	into	#tmpDetEmpleador
							SELECT    	prdo,
									a.nmro_unco_idntfccn_empldr,
									a.cnsctvo_cdgo_clse_aprtnte,
									a.cnsctvo_scrsl,
									a.cnsctvo_estdo_cnta,
									b.nmbre_scrsl, a.nmro_estdo_cnta '
								
Set @IcInstruccion	 =	 @IcInstruccion + '	FROM      tbestadosCuenta a,	
								   #tmpLiquidacionesFinalizadas d ,
								   bdafiliacion..tbSucursalesAportante  b  ' + char(13)

Set    @IcInstruccion1 = 'Where 	 a.cnsctvo_cdgo_lqdcn			=	d.cnsctvo_cdgo_lqdcn  '

Set    @IcInstruccion2 = 	   	'And	  a.cnsctvo_cdgo_estdo_estdo_cnta	 != 	4	 ' + char(13)
			 +'   	And	  a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn_empldr  ' + char(13)
			+'	And	  a.cnsctvo_cdgo_clse_aprtnte		=	b.cnsctvo_cdgo_clse_aprtnte  ' + char(13)
			+'	And	  a.cnsctvo_scrsl			=	b.cnsctvo_scrsl     ' + char(13)

 				 
								   			
Update #tbCriteriosTmp
Set	tbla		=	'#tmpLiquidacionesFinalizadas',
	oprdr		=	'='
Where cdgo_cmpo	=	'prdo'

								   			


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

Select  prdo,
            nmro_unco_idntfccn_empldr,
            cnsctvo_cdgo_clse_aprtnte,
            cnsctvo_scrsl,
            a.cnsctvo_estdo_cnta,
            nmbre_scrsl ,
            space(3)			tpo_idntfccn_emprsa,
            space(15)		nmro_idntfccn_emprsa,
            space(3)  		tpo_idntfccn_bene,
            space(15)  		nmro_idntfccn_bene,
            space(3)  		tpo_idntfccn_coti,
            space(15)  		nmro_idntfccn_coti,
	0			nmro_unco_idntfccn_afldo,
       	c.nmro_unco_idntfccn_bnfcro,		
	c.cnsctvo_bnfcro,
	c.vlr,
	convert(datetime,null)	fcha_ncmnto,
	convert(datetime,null)	inco_vgnca_bnfcro,
	convert(datetime,null)	fn_vgnca_bnfcro,
	space(50)		nmbre_bene,
	space(50)		nmbre_coti,
	space(50)		dscrpcn_prntsco,
	0			cnsctvo_cdgo_prntscs,
	b.nmro_cntrto,
	b.cnsctvo_cdgo_tpo_cntrto,
	0			cnsctvo_cdgo_pln,
	space(50)		dscrpcn_pln,
	0	edd_bnfcro,
	a.nmro_estdo_cnta
into	#tmpDetEmpleadorFinal	
From	#tmpDetEmpleador a,	tbEstadosCuentaContratos b,
	tbCuentasContratosBeneficiarios c,
	tbCuentasBeneficiariosConceptos d
Where 	a.cnsctvo_estdo_cnta			=	b.cnsctvo_estdo_cnta
And	b.cnsctvo_estdo_cnta_cntrto		=	c.cnsctvo_estdo_cnta_cntrto
And	c.cnsctvo_estdo_cnta_cntrto_bnfcro	= 	d.cnsctvo_estdo_cnta_cntrto_bnfcro
And	d.cnsctvo_cdgo_cncpto_lqdcn		=	4


Update #tmpDetEmpleadorFinal
Set	cnsctvo_cdgo_pln		=	b.cnsctvo_cdgo_pln,
	nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn_afldo
From	#tmpDetEmpleadorFinal a, bdafiliacion..tbcontratos b
Where  a.nmro_cntrto			=	b.nmro_cntrto
And       a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto


-- Identifico planes BIENESTAR PLUS
Update	#tmpDetEmpleadorFinal
Set	cnsctvo_cdgo_pln		= 3
from #tmpDetEmpleadorFinal f 
Inner join bdCarteraPac.dbo.tbEstadosCuenta e
on f.cnsctvo_estdo_cnta = e.cnsctvo_estdo_cnta
inner join tbEstadosCuentaConceptos b
on e.cnsctvo_estdo_cnta = b.cnsctvo_estdo_cnta
inner join tbConceptosLiquidacion cl
on cl.cnsctvo_cdgo_cncpto_lqdcn = b.cnsctvo_cdgo_cncpto_lqdcn
where b.cnsctvo_cdgo_cncpto_lqdcn = 346


-- Identifico planes PBS PLUS
Update	#tmpDetEmpleadorFinal
Set	cnsctvo_cdgo_pln		= 13
from #tmpDetEmpleadorFinal f 
Inner join bdCarteraPac.dbo.tbEstadosCuenta e
on f.cnsctvo_estdo_cnta = e.cnsctvo_estdo_cnta
inner join tbEstadosCuentaConceptos b
on e.cnsctvo_estdo_cnta = b.cnsctvo_estdo_cnta
inner join tbConceptosLiquidacion cl
on cl.cnsctvo_cdgo_cncpto_lqdcn = b.cnsctvo_cdgo_cncpto_lqdcn
where b.cnsctvo_cdgo_cncpto_lqdcn = 345



Update #tmpDetEmpleadorFinal
Set	dscrpcn_pln		=	b.dscrpcn_pln
From	#tmpDetEmpleadorFinal a, bdplanbeneficios..tbplanes b
Where  a.cnsctvo_cdgo_pln	=	b.cnsctvo_cdgo_pln

Update #tmpDetEmpleadorFinal
Set	cnsctvo_cdgo_prntscs		=	b.cnsctvo_cdgo_prntsco,
	inco_vgnca_bnfcro		=	b.inco_vgnca_bnfcro,
	fn_vgnca_bnfcro		=	b.fn_vgnca_bnfcro
From	#tmpDetEmpleadorFinal a, bdafiliacion..tbbeneficiarios b
Where  a.nmro_cntrto			=	b.nmro_cntrto
And	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.cnsctvo_bnfcro		=	b.cnsctvo_bnfcro
And	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn_bnfcro


Update #tmpDetEmpleadorFinal
Set	dscrpcn_prntsco		=	b.dscrpcn_prntsco
From	#tmpDetEmpleadorFinal a, bdafiliacion..tbparentescos b
Where   a.cnsctvo_cdgo_prntscs	=	b.cnsctvo_cdgo_prntscs


Update #tmpDetEmpleadorFinal
Set	tpo_idntfccn_bene		=	c.cdgo_tpo_idntfccn,
        	nmro_idntfccn_bene		=	b.nmro_idntfccn
From	#tmpDetEmpleadorFinal a, 	bdafiliacion..tbvinculados  b ,
	bdafiliacion..tbtiposidentificacion 	c
Where   a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn
And	b.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn

Update #tmpDetEmpleadorFinal
Set	tpo_idntfccn_coti		=	c.cdgo_tpo_idntfccn,
        	nmro_idntfccn_coti		=	b.nmro_idntfccn
From	#tmpDetEmpleadorFinal a, 	bdafiliacion..tbvinculados  b ,
	bdafiliacion..tbtiposidentificacion 	c
Where   a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn
And	b.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn

Update #tmpDetEmpleadorFinal
Set	tpo_idntfccn_emprsa		=	c.cdgo_tpo_idntfccn,
        	nmro_idntfccn_emprsa		=	b.nmro_idntfccn
From	#tmpDetEmpleadorFinal a, 	bdafiliacion..tbvinculados  b ,
	bdafiliacion..tbtiposidentificacion 	c
Where   a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn
And	b.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn


Update #tmpDetEmpleadorFinal
Set	fcha_ncmnto			=	b.fcha_ncmnto
From	#tmpDetEmpleadorFinal a, 	bdafiliacion..tbpersonas  b 
Where   a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn



update #tmpDetEmpleadorFinal	
Set	edd_bnfcro	=	BDAFILIACION.DBO.fnCalcularTiempo (fcha_ncmnto,GETDATE(),1,2)

Update  #tmpDetEmpleadorFinal
Set	nmbre_bene			=	  ltrim(rtrim(e.prmr_aplldo))  + ' ' + ltrim(rtrim(e.sgndo_aplldo)) + ' ' + ltrim(rtrim(e.sgndo_nmbre)) + ' ' + ltrim(rtrim(e.prmr_Nmbre)) 
From	#tmpDetEmpleadorFinal a,  bdAfiliacion..tbpersonas e
Where	  a.nmro_unco_idntfccn_bnfcro	=            e.nmro_unco_idntfccn

Update  #tmpDetEmpleadorFinal
Set	nmbre_coti			=	  ltrim(rtrim(e.prmr_aplldo))  + ' ' + ltrim(rtrim(e.sgndo_aplldo)) + ' ' + ltrim(rtrim(e.sgndo_nmbre)) + ' ' + ltrim(rtrim(e.prmr_Nmbre)) 
From	#tmpDetEmpleadorFinal a,  bdAfiliacion..tbpersonas e
Where	  a.nmro_unco_idntfccn_afldo	=            e.nmro_unco_idntfccn


Select  * from #tmpDetEmpleadorFinal order by nmbre_scrsl , nmbre_coti


