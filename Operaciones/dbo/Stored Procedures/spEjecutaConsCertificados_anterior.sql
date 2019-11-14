
/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spEjecutaConsCertificados_anterior
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
CREATE  PROCEDURE spEjecutaConsCertificados_anterior

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
@Fecha_ini		datetime,
@Fecha_fin		datetime


Set Nocount On

Select	@ldFechaSistema	=	Getdate()



--Se cruzan los contratos asociados a las sucursales y se traer las sucursales finales para liquidar



 
-- Contador de condiciones
Select @lnContador = 1

-- se crea la tabla temporal con la infromacion de las sucursales que s epuedan liquidar
				
			
select    a.fcha_incl_prdo_lqdcn 	fcha_crcn,	b.cnsctvo_cdgo_prdo_lqdcn,
	 cnsctvo_cdgo_lqdcn
into 	#tmpLiquidacionesFinalizadas
from 	tbperiodosliquidacion_vigencias a, tbliquidaciones b
Where   a.cnsctvo_cdgo_prdo_lqdcn	=	b.cnsctvo_cdgo_prdo_lqdcn
And	b.cnsctvo_cdgo_estdo_lqdcn	=	3
		
     
				
-- primero se hace para estados de cuenta
Select   nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte,
	cnsctvo_cdgo_tpo_cntrto ,nmro_cntrto, vlr_abno_cta , vlr_abno_iva,
	0	cnsctvo_cdgo_pln,
	0	nmro_unco_idntfccn_afldo,
	b.fcha_crcn	
into    	#tmpCertificadosAux	
From 	Tbperiodosliquidacion_vigencias a,
     	#tmpLiquidacionesFinalizadas 		b,
     	Tbestadoscuenta 		c,
     	Tbestadoscuentacontratos   	d,
     	Tbabonoscontrato  		e		
where   1	=	2


Select  @IcInstruccion	=  				'Insert	into	#tmpCertificadosAux
							SELECT    	 nmro_unco_idntfccn_empldr,
									cnsctvo_scrsl,
									cnsctvo_cdgo_clse_aprtnte,
									cnsctvo_cdgo_tpo_cntrto ,nmro_cntrto, vlr_abno_cta , vlr_abno_iva,
									0	cnsctvo_cdgo_pln,
									0	nmro_unco_idntfccn_afldo,
									b.fcha_crcn				'					
Set @IcInstruccion	 =	 @IcInstruccion + '	FROM     Tbperiodosliquidacion_vigencias	a,
							     	  #tmpLiquidacionesFinalizadas 		b,
							     	  Tbestadoscuenta 			c,
							     	  Tbestadoscuentacontratos   		d,
							     	  Tbabonoscontrato  			e,
								  bdafiliacion..tbtiposidentificacion	              t,
								  bdafiliacion..tbvinculados                          v	  ' + char(13)

Set    @IcInstruccion1 = '	Where 		a.cnsctvo_cdgo_prdo_lqdcn 	= 	b.cnsctvo_cdgo_prdo_lqdcn  '
Set    @IcInstruccion2 = 	  ' 	And		b.cnsctvo_cdgo_lqdcn	  	= 	c.cnsctvo_cdgo_lqdcn		 ' + char(13)
			 +'   	And		c.cnsctvo_estdo_cnta		=	d.cnsctvo_estdo_cnta	 	'  + char(13)
			 +'	And		d.cnsctvo_estdo_cnta_cntrto	=	e.cnsctvo_estdo_cnta_cntrto       '  + char(13)
			 +'	And		t.cnsctvo_cdgo_tpo_idntfccn	=	v.cnsctvo_cdgo_tpo_idntfccn       '  + char(13)
			 +'	And		c.nmro_unco_idntfccn_empldr	=	v.nmro_unco_idntfccn       '  + char(13)

 			

 
								   			
Update #tbCriteriosTmp
Set	tbla		=	'#tmpLiquidacionesFinalizadas'
Where cdgo_cmpo	=	'fcha_crcn'

				   			


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
		If  CHARINDEX('Tbperiodosliquidacion_vigencias',@tbla,1) != 0
		Begin
			-- si tabla es tbTiposPagoNotas se asigna como alias b
			Select @lcAlias = 'a.'
		End
		Else
		Begin
			If  CHARINDEX('#tmpLiquidacionesFinalizadas',@tbla,1) != 0
			Begin
				-- si tabla es tbVinculados se asigna como alias c
				Select @lcAlias = 'b.'
			End
			Else  
			Begin
				If  CHARINDEX('tbvinculados',@tbla,1) != 0
				Begin
					-- si tabla es tbEstadosNotas se asigna como alias d
					Select @lcAlias = 'v.'
				End
				Else  
				Begin
					If  CHARINDEX('tbtiposidentificacion',@tbla,1) != 0
					Begin
	
						-- si tabla es tbTiposIdentificacion se asigna como alias e
						Select @lcAlias = 't.'
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


update #tmpCertificadosAux
Set	cnsctvo_cdgo_pln		=	b.cnsctvo_cdgo_pln,
	nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn_afldo
From	#tmpCertificadosAux a, bdafiliacion..tbcontratos b
where   a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto




Select   nmro_unco_idntfccn_afldo,
	cnsctvo_cdgo_tpo_cntrto,
       	nmro_cntrto,
	cnsctvo_cdgo_pln
into  	 #tmpContratosPac
From   #tmpCertificadosAux
group by nmro_unco_idntfccn_afldo ,
	 cnsctvo_cdgo_tpo_cntrto,
	  nmro_cntrto,
	 cnsctvo_cdgo_pln

select     a.nmro_unco_idntfccn_afldo ,b.nmro_unco_idntfccn_bnfcro,	b.cnsctvo_cdgo_prntsco , 
	a.cnsctvo_cdgo_pln,
	a.cnsctvo_cdgo_tpo_cntrto,
	a.nmro_cntrto
into    #tmpBeneficiarios
from	#tmpContratosPac a, bdafiliacion..tbbeneficiarios b
where  a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto
and	b.cnsctvo_bnfcro		<=	4




select  nmro_unco_idntfccn_afldo ,nmro_unco_idntfccn_bnfcro,	cnsctvo_cdgo_prntsco , 
	cnsctvo_cdgo_pln,
	0	cantidad_bene
into    #tmpBeneficiariosXPlan
from	#tmpBeneficiarios a
Group by nmro_unco_idntfccn_afldo ,nmro_unco_idntfccn_bnfcro,	cnsctvo_cdgo_prntsco , 
	 cnsctvo_cdgo_pln


Select  cnsctvo_cdgo_pln,
	nmro_unco_idntfccn_afldo,
	nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte,
	Sum(vlr_abno_cta + vlr_abno_iva) Valor_total_plan
into	#tmpTotalCotizantePlan
From	#tmpCertificadosAux
Group by cnsctvo_cdgo_pln,
	nmro_unco_idntfccn_afldo,
	nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte

Select  @Fecha_ini	=	min(fcha_crcn)  from #tmpCertificadosAux
Select  @Fecha_fin	=	max(fcha_crcn)  from #tmpCertificadosAux

select  a.cnsctvo_cdgo_pln,
	a.nmro_unco_idntfccn_afldo,
	a.nmro_unco_idntfccn_empldr,
	a.cnsctvo_scrsl,
	a.cnsctvo_cdgo_clse_aprtnte,
	a.Valor_total_plan,
	space(3)	TI_coti,
	space(15)	NI_coti,
	space(100)	nombre_Coti,
	space(3)	TI_bene,
	space(15)	NI_bene,
	space(100)	nombre_bene,
	space(30)	dscrpcn_prntsco,
	space(30)	dscrpcn_pln,
	@Fecha_ini	Fecha_ini,
	@Fecha_fin	Fecha_fin,
	b.nmro_unco_idntfccn_bnfcro,
	b.cnsctvo_cdgo_prntsco,
	0	estado
into 	#tmpbeneficiariosXabonos
from 	#tmpTotalCotizantePlan a,  #tmpBeneficiariosXPlan b
where   a.cnsctvo_cdgo_pln 		= b.cnsctvo_cdgo_pln
and	a.nmro_unco_idntfccn_afldo	= b.nmro_unco_idntfccn_afldo


Update 	#tmpbeneficiariosXabonos
Set	TI_coti		=	c.cdgo_tpo_idntfccn,
	NI_coti		=	b.nmro_idntfccn
From	#tmpbeneficiariosXabonos a, bdafiliacion..tbvinculados  b , bdafiliacion..tbtiposidentificacion c
where   a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn
And	b.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn

Update 	#tmpbeneficiariosXabonos
Set	TI_bene		=	c.cdgo_tpo_idntfccn,
	NI_bene		=	b.nmro_idntfccn
From	#tmpbeneficiariosXabonos a, bdafiliacion..tbvinculados  b , bdafiliacion..tbtiposidentificacion c
where   a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn
And	b.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn

Update #tmpbeneficiariosXabonos
Set	nombre_Coti	=	convert(varchar(50),ltrim(rtrim(prmr_aplldo)) + ' ' + ltrim(rtrim(sgndo_aplldo)) + ' ' + ltrim(rtrim(prmr_nmbre)) + ' '  + ltrim(rtrim(sgndo_nmbre)))
From	#tmpbeneficiariosXabonos a, bdafiliacion..tbPersonas b
Where 	a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn

Update #tmpbeneficiariosXabonos
Set	nombre_bene	=	convert(varchar(50),ltrim(rtrim(prmr_aplldo)) + ' ' + ltrim(rtrim(sgndo_aplldo)) + ' ' + ltrim(rtrim(prmr_nmbre)) + ' '  + ltrim(rtrim(sgndo_nmbre)))
From	#tmpbeneficiariosXabonos a, bdafiliacion..tbPersonas b
Where 	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn

Update #tmpbeneficiariosXabonos
Set	dscrpcn_prntsco	=	b.dscrpcn_prntsco
From	#tmpbeneficiariosXabonos a, bdafiliacion..tbparentescos b
Where 	a.cnsctvo_cdgo_prntsco	=	b.cnsctvo_cdgo_prntscs


Update #tmpbeneficiariosXabonos
Set	dscrpcn_pln	=	b.dscrpcn_pln
From	#tmpbeneficiariosXabonos a, bdplanbeneficios..tbplanes b
Where 	a.cnsctvo_cdgo_pln	=	b.cnsctvo_cdgo_pln


update #tmpbeneficiariosXabonos
set	estado = 1
where   cnsctvo_cdgo_prntsco in (1,2,3,4)



select    TI_coti,
	NI_coti,
	nombre_Coti,
	convert(varchar(10),Fecha_ini,111)	Fecha_ini,
	convert(varchar(10),Fecha_fin,111)	Fecha_fin,
        	convert(int,Valor_total_plan)		Valor_total_plan,
        	TI_bene,
	NI_bene,
        	nombre_bene,
        	dscrpcn_prntsco,
        	dscrpcn_pln,
	cnsctvo_cdgo_pln,
	right(replicate('0',20)+ltrim(rtrim(NI_coti)),20) + right(replicate('0',2)+ltrim(rtrim(cnsctvo_cdgo_pln)),2) 	AfiliadoPlan
Into	#tmpbeneficiariosXabonosFinal
From 	#tmpbeneficiariosXabonos 
Where 	estado = 1


Select  *
from #tmpbeneficiariosXabonosFinal
order by AfiliadoPlan