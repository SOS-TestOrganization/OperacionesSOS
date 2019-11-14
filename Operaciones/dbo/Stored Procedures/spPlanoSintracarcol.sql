
/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spPlanoSintracarcol
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento para generar el plano del aportante sintracarcol				 	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003/02/10											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM Ing. Fernando Valencia E AM\>
* Descripcion			: <\DM Se cambia el nmro_unco_idntfccn_empldr y  cnsctvo_scrsl segun sau 52042 DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  2006/08/18 FM\>
*---------------------------------------------------------------------------------*/
CREATE  PROCEDURE spPlanoSintracarcol

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
@Valor_Porcentaje_Iva	udtValorDecimales



Set Nocount On

Select	@ldFechaSistema	=	Getdate()

Select	@Valor_Porcentaje_Iva	= prcntje
From	bdCarteraPac.dbo.tbConceptosLiquidacion_Vigencias
Where	cnsctvo_cdgo_cncpto_lqdcn	= 3
And	@ldFechaSistema	Between inco_vgnca And 	fn_vgnca

--Se cruzan los contratos asociados a las sucursales y se traer las sucursales finales para liquidar



 
-- Contador de condiciones

Select @lnContador = 1

-- se crea la tabla temporal con la infromacion de las sucursales que s epuedan liquidar

-- primero se hace para estados de cuenta

select 	b.cnsctvo_cdgo_tpo_cntrto,
	b.nmro_cntrto,
	b.vlr_cbrdo,
	a.Fcha_crcn , 
	a.cnsctvo_cdgo_lqdcn,
	a.cnsctvo_scrsl ,
	a.nmro_unco_idntfccn_empldr ,
	a.cnsctvo_cdgo_clse_aprtnte,
	fcha_incl_prdo_lqdcn,
	e.nmro_unco_idntfccn_bnfcro	
into	#tmpPlanoSintracarcol
from 	 tbestadosCuenta a, tbestadoscuentacontratos  b,
	 tbliquidaciones c, tbperiodosliquidacion_vigencias p,
	 tbcuentasContratosBeneficiarios e
where	 a.cnsctvo_estdo_cnta		=	b.cnsctvo_estdo_cnta
And	 a.cnsctvo_cdgo_lqdcn		=	c.cnsctvo_cdgo_lqdcn
And	 c.cnsctvo_cdgo_prdo_lqdcn	=	p.cnsctvo_cdgo_prdo_lqdcn
And	 b.cnsctvo_estdo_cnta_cntrto	=	e.cnsctvo_estdo_cnta_cntrto
And	 1				=	2


Select  @IcInstruccion	=  				'Insert	into	#tmpPlanoSintracarcol
							SELECT  b.cnsctvo_cdgo_tpo_cntrto,
								b.nmro_cntrto,
								b.vlr_cbrdo,
							  	a.Fcha_crcn , 
	                                                        a.cnsctvo_cdgo_lqdcn ,
				   				a.cnsctvo_scrsl ,
								a.nmro_unco_idntfccn_empldr ,
								a.cnsctvo_cdgo_clse_aprtnte 	,
								fcha_incl_prdo_lqdcn,
								e.nmro_unco_idntfccn_bnfcro  '+ char(13)	
Set @IcInstruccion	 =	 @IcInstruccion + '	FROM       tbestadosCuenta a,	
								    tbestadoscuentacontratos b,
								    tbperiodosliquidacion_vigencias p,
								   Tbliquidaciones   c	,
								     tbcuentasContratosBeneficiarios e 	 ' 	+ 	char(13)

		

Set    @IcInstruccion1 = 'Where 	   a.nmro_unco_idntfccn_empldr	=	100519'

--100519 Sintracarcol
--30049601 Cartón Colombia

Set    @IcInstruccion2 = 	 +'	And	  a.cnsctvo_cdgo_lqdcn	=	c.cnsctvo_cdgo_lqdcn   ' + char(13)
			+'	And	 c.cnsctvo_cdgo_prdo_lqdcn	=	p.cnsctvo_cdgo_prdo_lqdcn       ' + char(13)
			+'	And	  a.cnsctvo_estdo_cnta		=	b.cnsctvo_estdo_cnta         ' + char(13)
			+'	And	  b.cnsctvo_estdo_cnta_cntrto	=	e.cnsctvo_estdo_cnta_cntrto   ' + char(13)
			+'	And	    c.cnsctvo_cdgo_estdo_lqdcn	=	3		  ' + char(13)
			+'	And	a.cnsctvo_scrsl			=	1' + Char(13)



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

Select  a.cnsctvo_cdgo_tpo_cntrto,
	a.nmro_cntrto,
	a.vlr_cbrdo,
	a.nmro_unco_idntfccn_empldr,
	b.nmro_unco_idntfccn_afldo,
	a.nmro_unco_idntfccn_bnfcro,
	'F'		Tipo_Dato,
	space(15)	nmro_idntfccn_empldr,
	space(1)	tpo_aflcn,
	space(3)	tpo_idntfccn_afldo,
	space(20)	nmro_idntfccn_afldo,
	space(20)	nmbre_cntrtnte,
	space(15)	prmr_aplldo_cntrtnte,
	space(15)	sgndo_aplldo_cntrtnte,
	space(2)	cdgo_pln,
	0		Vlr_aprts_grpo_bsco,
	0		vlr_aprts_grpo_adcnl,
	0		vlr_ttl_aprts,
	space(3)	tpo_idntfccn_bnfcnro,
	space(20)	nmro_idntfccn_bnfcnro,
	space(20)	nmbre_bnfcro,
	space(15)	prmr_aplldo_bnfcro,
	space(15)	sgndo_aplldo_bnfcro,
	space(1)	prntsco,
	' '		Grpo_bsco_bnfcro,
	inco_vgnca_cntrto,
        fn_vgnca_cntrto,
	cnsctvo_cdgo_pln,
	0	cnsctvo_cdgo_tpo_idntfccn_afldo,
	0	cnsctvo_cdgo_tpo_idntfccn_bfcro,
	0	cnsctvo_cdgo_prntsco ,
	a.fcha_incl_prdo_lqdcn,
	a.cnsctvo_cdgo_lqdcn,
	0	cnsctvo_cdgo_grpo,
	Space(1)	Grpo -- A-> Adicional; B-> Básico
into	#tmpPlanoSintracarcolFinal
From	 #tmpPlanoSintracarcol  a, bdafiliacion..tbcontratos  b
Where	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto

--Actualiza el nit del empleador
Update #tmpPlanoSintracarcolFinal
Set	nmro_idntfccn_empldr		=	b.nmro_idntfccn
From	#tmpPlanoSintracarcolFinal a,  bdafiliacion..tbvinculados b
Where	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn

--Actualiza el tipo  de Afiliacion
Update #tmpPlanoSintracarcolFinal
Set	tpo_aflcn		=	case when cnsctvo_cdgo_pln = 2  then 'C' else 'I' end

--Actualiza el tipo y numero de identificacion del afiliado
Update #tmpPlanoSintracarcolFinal
Set	nmro_idntfccn_afldo		=	b.nmro_idntfccn,
	cnsctvo_cdgo_tpo_idntfccn_afldo	=	b.cnsctvo_cdgo_tpo_idntfccn
From	#tmpPlanoSintracarcolFinal a,  bdafiliacion..tbvinculados b
Where	a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn

--actualiza el  tipo de identitifacion del afiliado

Update #tmpPlanoSintracarcolFinal
Set	tpo_idntfccn_afldo		=	ltrim(rtrim(b.cdgo_tpo_idntfccn))
From	#tmpPlanoSintracarcolFinal a,  bdafiliacion..tbtiposidentificacion b
Where	a.cnsctvo_cdgo_tpo_idntfccn_afldo	=	b.cnsctvo_cdgo_tpo_idntfccn

--Actualiza el tipo y numero de identificacion del beneficiario

Update #tmpPlanoSintracarcolFinal
Set	nmro_idntfccn_bnfcnro		=	b.nmro_idntfccn,
	cnsctvo_cdgo_tpo_idntfccn_bfcro	=	b.cnsctvo_cdgo_tpo_idntfccn
From	#tmpPlanoSintracarcolFinal a,  bdafiliacion..tbvinculados b
Where	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn

Update #tmpPlanoSintracarcolFinal
Set	tpo_idntfccn_bnfcnro		=	ltrim(rtrim(b.cdgo_tpo_idntfccn))
From	#tmpPlanoSintracarcolFinal a,  bdafiliacion..tbtiposidentificacion b
Where	a.cnsctvo_cdgo_tpo_idntfccn_bfcro=	b.cnsctvo_cdgo_tpo_idntfccn


--Actualiza el nombre del contratante

Update #tmpPlanoSintracarcolFinal
Set	nmbre_cntrtnte		=	convert(varchar(20),ltrim(rtrim(prmr_nmbre)) + ' ' + ltrim(rtrim(sgndo_nmbre))),
	prmr_aplldo_cntrtnte	=	convert(varchar(15),ltrim(rtrim(prmr_aplldo))),
	sgndo_aplldo_cntrtnte	=	convert(varchar(15),ltrim(rtrim(sgndo_aplldo)))
From	#tmpPlanoSintracarcolFinal a,  bdafiliacion..tbpersonas b
Where	a.nmro_unco_idntfccn_afldo=	b.nmro_unco_idntfccn


-- Actualiza el nombre del beneficiario

Update #tmpPlanoSintracarcolFinal
Set	nmbre_bnfcro		=	convert(varchar(20),ltrim(rtrim(prmr_nmbre)) + ' ' + ltrim(rtrim(sgndo_nmbre))),
	prmr_aplldo_bnfcro	=	convert(varchar(15),ltrim(rtrim(prmr_aplldo))),
	sgndo_aplldo_bnfcro	=	convert(varchar(15),ltrim(rtrim(sgndo_aplldo)))
From	#tmpPlanoSintracarcolFinal a,  bdafiliacion..tbpersonas b
Where	a.nmro_unco_idntfccn_bnfcro=	b.nmro_unco_idntfccn

/*
Update  #tmpPlanoSintracarcolFinal
Set	Vlr_aprts_grpo_bsco	=	vlr_cbrdo
Where   cnsctvo_cdgo_pln 	= 	2*/

/*Update  #tmpPlanoSintracarcolFinal
Set	vlr_ttl_aprts		=	vlr_cbrdo*/


Update  #tmpPlanoSintracarcolFinal
Set	vlr_ttl_aprts		=	Ceiling(h.vlr_upc + (h.vlr_upc * @Valor_Porcentaje_Iva/100))
From	#tmpPlanoSintracarcolFinal p Inner Join
	bdCarteraPac.dbo.tbHistoricoTarificacionXProceso h
On	p.cnsctvo_cdgo_lqdcn = h.cnsctvo_cdgo_lqdcn
And	p.cnsctvo_cdgo_tpo_cntrto = h.cnsctvo_cdgo_tpo_cntrto
And	p.nmro_cntrto = h.nmro_cntrto
And	p.nmro_unco_idntfccn_bnfcro = h.nmro_unco_idntfccn

Update  #tmpPlanoSintracarcolFinal
Set	Vlr_aprts_grpo_bsco	=	vlr_ttl_aprts
Where   cnsctvo_cdgo_pln 	= 	2	

--Actualiza el parentesco del beneficiario
update  #tmpPlanoSintracarcolFinal
Set	cnsctvo_cdgo_prntsco	=	b.cnsctvo_cdgo_prntsco
From	#tmpPlanoSintracarcolFinal a, bdafiliacion..tbbeneficiarios b
Where   a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto
And	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn_bnfcro



update  #tmpPlanoSintracarcolFinal
Set	prntsco	=	b.cnsctvo_cdgo_prntscs
From	#tmpPlanoSintracarcolFinal a, bdafiliacion..tbparentescos b
Where   a.cnsctvo_cdgo_prntsco	=	b.cnsctvo_cdgo_prntscs

Update #tmpPlanoSintracarcolFinal
Set	cdgo_pln		=	b.cdgo_pln
From	#tmpPlanoSintracarcolFinal a,  bdplanbeneficios..tbplanes b
Where	a.cnsctvo_cdgo_pln	=	b.cnsctvo_cdgo_pln


Update #tmpPlanoSintracarcolFinal
Set	cdgo_pln		=	'01'
where	cdgo_pln		=	'02'


Update #tmpPlanoSintracarcolFinal
Set	cdgo_pln		=	'06'
where	cdgo_pln		=	'07'

Update	#tmpPlanoSintracarcolFinal
Set	Grpo = 'B'
From	#tmpPlanoSintracarcolFinal  p Inner Join
	bdCarteraPac.dbo.tbHistoricoTarificacionXProceso h
On	p.cnsctvo_cdgo_lqdcn = h.cnsctvo_cdgo_lqdcn
And	p.cnsctvo_cdgo_tpo_cntrto = h.cnsctvo_cdgo_tpo_cntrto
And	p.nmro_cntrto = h.nmro_cntrto
And	p.nmro_unco_idntfccn_bnfcro = h.nmro_unco_idntfccn
Where	h.cnsctvo_cdgo_prntsco In (1,2,3)

Update	#tmpPlanoSintracarcolFinal
Set	Grpo = 'B'
From	#tmpPlanoSintracarcolFinal  p Inner Join
	bdCarteraPac.dbo.tbHistoricoTarificacionXProceso h
On	p.cnsctvo_cdgo_lqdcn = h.cnsctvo_cdgo_lqdcn
And	p.cnsctvo_cdgo_tpo_cntrto = h.cnsctvo_cdgo_tpo_cntrto
And	p.nmro_cntrto = h.nmro_cntrto
And	p.nmro_unco_idntfccn_bnfcro = h.nmro_unco_idntfccn
Where	h.cnsctvo_cdgo_prntsco = 4
And	((h.edd_bnfcro < 18) Or (h.Estdnte = 'S' And h.edd_bnfcro < 25) Or (h.Dscpctdo = 'S' And h.edd_bnfcro < 25))

Update	#tmpPlanoSintracarcolFinal
Set	Grpo = 'A'
From	#tmpPlanoSintracarcolFinal  p Inner Join
	bdCarteraPac.dbo.tbHistoricoTarificacionXProceso h
On	p.cnsctvo_cdgo_lqdcn = h.cnsctvo_cdgo_lqdcn
And	p.cnsctvo_cdgo_tpo_cntrto = h.cnsctvo_cdgo_tpo_cntrto
And	p.nmro_cntrto = h.nmro_cntrto
And	p.nmro_unco_idntfccn_bnfcro = h.nmro_unco_idntfccn
Where	p.grpo = ''

Update	#tmpPlanoSintracarcolFinal
Set	Grpo = 'B'
From	#tmpPlanoSintracarcolFinal p Inner Join
	bdCarteraPac.dbo.tbHistoricoTarificacionXProceso h
On	p.cnsctvo_cdgo_lqdcn = h.cnsctvo_cdgo_lqdcn
And	p.cnsctvo_cdgo_tpo_cntrto = h.cnsctvo_cdgo_tpo_cntrto
And	p.nmro_cntrto = h.nmro_cntrto
And	p.nmro_unco_idntfccn_bnfcro = h.nmro_unco_idntfccn
Where	h.grupo In (120,121,136,137,138,139,200,201)

Update	#tmpPlanoSintracarcolFinal
Set	Grpo = 'A'
From	#tmpPlanoSintracarcolFinal p Inner Join
	bdCarteraPac.dbo.tbHistoricoTarificacionXProceso h
On	p.cnsctvo_cdgo_lqdcn = h.cnsctvo_cdgo_lqdcn
And	p.cnsctvo_cdgo_tpo_cntrto = h.cnsctvo_cdgo_tpo_cntrto
And	p.nmro_cntrto = h.nmro_cntrto
And	p.nmro_unco_idntfccn_bnfcro = h.nmro_unco_idntfccn
Where	h.grupo In (122,123,124,125,126,127,128,129,130,131,132,133)

select  substring(convert(varchar(10),fcha_incl_prdo_lqdcn ,101),4,2) + substring(convert(varchar(10),fcha_incl_prdo_lqdcn ,101),7,4) prdo_fctrcn, 
	Tipo_Dato,
	right(replicate('0',11)+ltrim(rtrim(nmro_idntfccn_empldr)),11) 		nmro_idntfccn_empldr,
	tpo_aflcn,
	tpo_idntfccn_afldo,
	right(replicate('0',10)+ltrim(rtrim(nmro_idntfccn_afldo)),10) 		nmro_idntfccn_afldo,
	nmbre_cntrtnte,
	prmr_aplldo_cntrtnte,
	sgndo_aplldo_cntrtnte,
	right(replicate('0',2)+ltrim(rtrim(cdgo_pln)),2) 			cdgo_pln,
	right(replicate('0',12)+ltrim(rtrim(Vlr_aprts_grpo_bsco)),12) 		Vlr_aprts_grpo_bsco,
	right(replicate('0',12)+ltrim(rtrim(vlr_aprts_grpo_adcnl)),12) 		vlr_aprts_grpo_adcnl,
	right(replicate('0',15)+ltrim(rtrim(vlr_ttl_aprts)),15) 		vlr_ttl_aprts,
	tpo_idntfccn_bnfcnro,
	right(replicate('0',10)+ltrim(rtrim(nmro_idntfccn_bnfcnro)),10) 		nmro_idntfccn_bnfcnro,
	nmbre_bnfcro,
	prmr_aplldo_bnfcro,
	sgndo_aplldo_bnfcro,
	prntsco,
	Grpo_bsco_bnfcro,
	convert(varchar(10),inco_vgnca_cntrto,111) inco_vgnca_cntrto,
	 convert(varchar(10),fn_vgnca_cntrto,111) fn_vgnca_cntrto,
	convert(int,nmro_idntfccn_afldo)	nmro_idntfccn_afldo_ord,
	nmro_cntrto,
	grpo
From 	#tmpPlanoSintracarcolFinal




