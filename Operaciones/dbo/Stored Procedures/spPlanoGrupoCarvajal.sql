



/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spPlanoGrupoCarvajal
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
* Modificado Por		: <\AM Ing. Fernando Valencia E>
* Descripcion			: <\DM  Pasar el codigo  empresa 65 a la empresa 1, cambiar codigo empresa 69 a 4 y a la  empresa 1   
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM 2006/03/23  FM\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM Ing. Fernando Valencia E>
* Descripcion			: <\DM  Se realizan modificaciones segun sau 54278   
                                        SAU 98104 Se agrega la empresa NIT 900279984 Carvajal  Servicios SA con codigo 98 empresa 1(para que salga en el archivo 1)
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM 2006/09/25  FM\>
*---------------------------------------------------------------------------------*/
CREATE      PROCEDURE  [dbo].[spPlanoGrupoCarvajal]
As

Declare
@tbla				varchar(128),
@cdgo_cmpo 			varchar(128),
@oprdr 			varchar(2),
@vlr 				varchar(250),
@cmpo_rlcn 			varchar(128),
@cmpo_rlcn_prmtro 		varchar(128),
@cnsctvo			Numeric(4),
@IcInstruccion			Nvarchar(4000),
@IcInstruccion1		Nvarchar(4000),
@IcInstruccion2		Nvarchar(4000),
@lcAlias			char(2),
@lnContador			Int,
@ldFechaSistema		Datetime,
@cnsctvo_cdgo_plza_antrr	int,
@lnValoPorcentajeIva		Numeric(9,2),
@cnsctvo_cdgo_lqdcn_in		int,
@cnsctvo_cdgo_lqdcn_fn		int


Set	@cnsctvo_cdgo_plza_antrr	=	120
	
Set Nocount On


Select	@ldFechaSistema	=	Getdate()

-- Contador de condiciones
Select @lnContador = 1


Select  @cnsctvo_cdgo_lqdcn_in   = vlr 
From  #tbCriteriosTmp
Where  cdgo_cmpo   =  'cnsctvo_cdgo_lqdcn' 
And oprdr      =  '>='

Select @cnsctvo_cdgo_lqdcn_fn  = vlr 
From  #tbCriteriosTmp
Where  cdgo_cmpo   =  'cnsctvo_cdgo_lqdcn' 
And oprdr       =  '<='



	
--drop table #tmpEmpresasCarvajar
Create table #tmpEmpresasCarvajar (nmro_unco_idntfccn_empldr int, cnsctvo_scrsl int,cnsctvo_cdgo_clse_aprtnte int,nmro_idntfccn char(20), cdgo_emprsa char(2), empresa int)
insert into #tmpEmpresasCarvajar values (30049562,1,1,'890300005','1',1)--carvajal s.a.
insert into #tmpEmpresasCarvajar values (30049562,2,1,'890300005','1',1)--carvajal s.a.
insert into #tmpEmpresasCarvajar values (30050157,1,1,'890308931','2',1)--editorial norma s.a.
insert into #tmpEmpresasCarvajar values (30050157,2,1,'890308931','2',1)--editorial norma s.a.
insert into #tmpEmpresasCarvajar values (30050157,3,1,'890308931','2',1)--editorial norma s.a.
insert into #tmpEmpresasCarvajar values (30050157,4,1,'890308931','2',1)--editorial norma s.a.
insert into #tmpEmpresasCarvajar values (30050157,5,1,'890308931','2',1)--editorial norma s.a.
--insert into #tmpEmpresasCarvajar values (30043785,6,1,'800099903 ','25',1)--BICO INTERNACIONAL S A                                                                                                                                
--insert into #tmpEmpresasCarvajar values (30050157,6,1,'890308931','2',1)--editorial norma s.a.
insert into #tmpEmpresasCarvajar values (30051157,1,1,'890329872','3',1)--plegacol 
insert into #tmpEmpresasCarvajar values (30051157,2,1,'890329872','3',1)--plegacol 
insert into #tmpEmpresasCarvajar values (30051157,3,1,'890329872','3',1)--plegacol 
insert into #tmpEmpresasCarvajar values (30051157,4,1,'890329872','3',1)--plegacol 
--insert into #tmpEmpresasCarvajar values (30051157,5,1,'890329872','3',1)--Plegacol
insert into #tmpEmpresasCarvajar values (30050590,1,1,'890319047','5',1)--carpak
insert into #tmpEmpresasCarvajar values (30050590,2,1,'890319047','5',1)--carpak
insert into #tmpEmpresasCarvajar values (30050590,3,1,'890319047','5',1)--carpak
insert into #tmpEmpresasCarvajar values (30050590,4,1,'890319047','5',1)--carpak
insert into #tmpEmpresasCarvajar values (30050590,5,1,'890319047','5',1)--carpak
insert into #tmpEmpresasCarvajar values (30050664,1,1,'890320250','6',1)--comolsa
insert into #tmpEmpresasCarvajar values (30050664,2,1,'890320250','6',1)--comolsa
insert into #tmpEmpresasCarvajar values (30050664,3,1,'890320250','6',1)--comolsa
insert into #tmpEmpresasCarvajar values (30042887,1,1,'800016998','15',1)--productos el Cid
insert into #tmpEmpresasCarvajar values (30042887,2,1,'800016998','15',1)--productos el Cid
insert into #tmpEmpresasCarvajar values (30042887,3,1,'800016998','15',1)--productos el Cid
--insert into #tmpEmpresasCarvajar values (30042737,1,1,'800003097','16',0)--Recsa
insert into #tmpEmpresasCarvajar values (30050404,1,1,'890314970','22',2)--fundacion carvajal
insert into #tmpEmpresasCarvajar values (30050404,2,1,'890314970','22',2)--fundacion carvajal
insert into #tmpEmpresasCarvajar values (30050404,3,1,'890314970','22',2)--fundacion carvajal
insert into #tmpEmpresasCarvajar values (30050404,4,1,'890314970','22',2)--Funfacion Carvajal
--insert into #tmpEmpresasCarvajar values (30050404,5,1,'890314970','22',2)--Funfacion Carvajal
insert into #tmpEmpresasCarvajar values (30043785,1,1,'800099903','25',1)--bico internacional
insert into #tmpEmpresasCarvajar values (30043785,2,1,'800099903','25',1)--bico internacional
insert into #tmpEmpresasCarvajar values (30043785,3,1,'800099903','25',1)--bico internacional
insert into #tmpEmpresasCarvajar values (30043785,4,1,'800099903','25',1)--bico internacional
insert into #tmpEmpresasCarvajar values (30043785,5,1,'800099903','25',1)--bico internacional
insert into #tmpEmpresasCarvajar values (30043752,1,1,'800096812','27',1)--CARGRAPHICS
insert into #tmpEmpresasCarvajar values (30043752,2,1,'800096812','27',1)--CARGRAPHICS
insert into #tmpEmpresasCarvajar values (30043752,3,1,'800096812','27',1)--CARGRAPHICS

--- Inclusion Quick 2011-001-027448
insert into #tmpEmpresasCarvajar values (32774028,1,1,'830127551','74',1)--CARGRAPHICS LOGISTIC

---select * from dbo.tbvinculados where nmro_idntfccn = '805007805'
--insert into #tmpEmpresasCarvajar values (30043896,3,1,'800111093','30',0)--SYCOM
insert into #tmpEmpresasCarvajar values (30050716,1,1,'890321151','32',1)--FESA
insert into #tmpEmpresasCarvajar values (30050716,2,1,'890321151','32',1)--FESA
insert into #tmpEmpresasCarvajar values (30050297,1,1,'890311274','35',1)--MEPAL
insert into #tmpEmpresasCarvajar values (30050297,2,1,'890311274','35',1)--MEPAL
insert into #tmpEmpresasCarvajar values (30050297,3,1,'890311274','35',1)--MEPAL
--insert into #tmpEmpresasCarvajar values (30050297,4,1,'890311274','35',1)--MEPAL
insert into #tmpEmpresasCarvajar values (30050297,5,1,'890311274','35',1)--MEPAL
--insert into #tmpEmpresasCarvajar values (30045760,3,1,'800247824','36',1)--IBC COLOMBIA S A 
insert into #tmpEmpresasCarvajar values (30045760,1,1,'800247824','36',1)--IBC COLOMBIA S A 
insert into #tmpEmpresasCarvajar values (30045760,2,1,'800247824','36',1)--IBC COLOMBIA S A 
insert into #tmpEmpresasCarvajar values (30048415,1,1,'817000339','46',1)--TECAR
insert into #tmpEmpresasCarvajar values (30048415,2,1,'817000339','46',1)--TECAR
insert into #tmpEmpresasCarvajar values (30048415,3,1,'817000339','46',1)--TECAR
insert into #tmpEmpresasCarvajar values (30047444,1,1,'805015560','48',1)--NORMA COMUNICACIONES S A       
insert into #tmpEmpresasCarvajar values (30047444,2,1,'805015560','48',1)--NORMA COMUNICACIONES S A       
insert into #tmpEmpresasCarvajar values (30047444,4,1,'805015560','48',1)--NORMA COMUNICACIONES S A       
insert into #tmpEmpresasCarvajar values (30048764,1,1,'830059918','65',1)--INTEGRAR S A    
insert into #tmpEmpresasCarvajar values (30048764,2,1,'830059918','65',1)--INTEGRAR S A    
insert into #tmpEmpresasCarvajar values (30048764,3,1,'830059918','65',1)--INTEGRAR S A    
insert into #tmpEmpresasCarvajar values (30048764,3,1,'830059918','65',1)--INTEGRAR S A    
--insert into #tmpEmpresasCarvajar values (30048764,4,1,'830059918','65',1)--INTEGRAR S A    
insert into #tmpEmpresasCarvajar values (30048764,5,1,'830059918','65',1)--INTEGRAR S A   
 
insert into #tmpEmpresasCarvajar values (33313387,1,1,'900023386','79',1)-- OD COLOMBIA
insert into #tmpEmpresasCarvajar values (33313387,2,1,'900023386','79',1)-- OD COLOMBIA

--QUICK QUICK 2011-001-006595 
insert into #tmpEmpresasCarvajar values (33384137,1,1,'900386417','99',1)-- Valores Plasticar 



--QUICK QUICK 2011-001-006595 
insert into #tmpEmpresasCarvajar values (33481809,1,1,'900483014','29',1) -- FLEXA



insert into #tmpEmpresasCarvajar values (30048511,1,1,'817002858','66',1)--IMPRELIBROS
insert into #tmpEmpresasCarvajar values (30048511,2,1,'817002858','66',1)--IMPRELIBROS
insert into #tmpEmpresasCarvajar values (30048901,1,1,'860001317','4',1)--PUBLICAR  S A   
insert into #tmpEmpresasCarvajar values (30048901,2,1,'860001317','4',1)--PUBLICAR  S A   
insert into #tmpEmpresasCarvajar values (30048901,3,1,'860001317','4',1)--PUBLICAR  S A   
insert into #tmpEmpresasCarvajar values (30048901,4,1,'860001317','4',1)--PUBLICAR  S A   
--insert into #tmpEmpresasCarvajar values (31182078,1,1,'805024308','80',1)--GC2 CARVAJAL S A 
insert into #tmpEmpresasCarvajar values (31942284,1,1,'890321150','76',1)	--SERTESA S A 
insert into #tmpEmpresasCarvajar values (30049224,1,1,'860047239','21',3)	--MUSICAR 
insert into #tmpEmpresasCarvajar values (30049224,2,1,'860047239','21',3)	--MUSICAR 
insert into #tmpEmpresasCarvajar values (30049224,3,1,'860047239','21',3)	--MUSICAR 
insert into #tmpEmpresasCarvajar values (30049224,4,1,'860047239','21',3)	--MUSICAR 
--insert into #tmpEmpresasCarvajar values (30049224,5,1,'860047239','21',1)	--MUSICAR 
-- SAU 98104
insert into #tmpEmpresasCarvajar values (33081828,1,1,'900279984','98',1) -- CARVAJAL SERVICIOS S A
insert into #tmpEmpresasCarvajar values (33258172,1,1,'900156826','79',1) -- OFIXPRES S A S
insert into #tmpEmpresasCarvajar values (30046763,1,1,'805007805','59',2) -- ESCARSA

--QUICK QUICK 2012-001-011936
insert into #tmpEmpresasCarvajar values (33516429,1,1,'900461844','26',1) -- DVALOR SAS



-- primero se hace para estados de cuenta
select  	b.cnsctvo_cdgo_tpo_cntrto,
	b.nmro_cntrto,
	b.vlr_cbrdo,
	a.Fcha_crcn , 
	a.cnsctvo_cdgo_lqdcn,
	a.nmro_unco_idntfccn_empldr ,
	a.cnsctvo_scrsl,
	a.cnsctvo_cdgo_clse_aprtnte,
	b.cntdd_bnfcrs,
	convert(datetime,null)	fcha_incl_prdo_lqdcn,	
	space(2)		cdgo_emprsa,
	b.cnsctvo_estdo_cnta_cntrto,
	convert(numeric(9,2),0) Porcentaje_iva,
	0 		empresa
into	#tmpPlanoGrupoCarvajal
from tbestadosCuenta a, tbestadoscuentacontratos  b
where	 a.cnsctvo_estdo_cnta		=	b.cnsctvo_estdo_cnta
And	 1	=	2

Select  @IcInstruccion	=  				'Insert	into	#tmpPlanoGrupoCarvajal
							SELECT   b.cnsctvo_cdgo_tpo_cntrto,
								   b.nmro_cntrto,
							  	   0 vlr_cbrdo,
							  	   a.Fcha_crcn , 
								   a.cnsctvo_cdgo_lqdcn ,
								   a.nmro_unco_idntfccn_empldr  ,
								   a.cnsctvo_scrsl,
								   a.cnsctvo_cdgo_clse_aprtnte,		
								   b.cntdd_bnfcrs,
								   p.fcha_incl_prdo_lqdcn,
								   f.cdgo_emprsa,
								   b.cnsctvo_estdo_cnta_cntrto, 
								   ((convert(numeric(12,2),a.vlr_iva) / convert(numeric(12,2),a.ttl_fctrdo)) * 100)  ,  	empresa '+ char(13)	
Set @IcInstruccion	 =	 @IcInstruccion + '	FROM      tbestadosCuenta a,	
								   tbestadoscuentacontratos b,
								   Tbliquidaciones   d	, #tmpEmpresasCarvajar f ,
								    bdcarteraPac..tbPeriodosliquidacion_Vigencias  p ' + char(13)

		

Set    @IcInstruccion1 = 'Where 	  a.nmro_unco_idntfccn_empldr	=	f.nmro_unco_idntfccn_empldr  '

Set    @IcInstruccion2 = 	 +'	And	  a.cnsctvo_scrsl		=	f.cnsctvo_scrsl     ' + char(13)
			 +'	And	  a.cnsctvo_cdgo_clse_aprtnte	=	f.cnsctvo_cdgo_clse_aprtnte     ' + char(13)
			 +'	And	  a.cnsctvo_cdgo_lqdcn		=	d.cnsctvo_cdgo_lqdcn     ' + char(13)
			 +'	And	  d.cnsctvo_cdgo_prdo_lqdcn	=	p.cnsctvo_cdgo_prdo_lqdcn     ' + char(13)
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


Select	@lnValoPorcentajeIva	=	Porcentaje_iva
From	#tmpPlanoGrupoCarvajal


--Select 	@cnsctvo_cdgo_lqdcn	=	cnsctvo_cdgo_lqdcn
--From	#tmpPlanoGrupoCarvajal
				
--actualiza el valor
select 	a.cnsctvo_estdo_cnta ,b.cnsctvo_estdo_cnta_cntrto ,sum(d.vlr) valor_cobrado
into 	#tmpValoresSinIVa
from 	tbestadoscuenta a, tbestadoscuentacontratos b,
     	tbCuentasContratosBeneficiarios c , tbCuentasBeneficiariosConceptos d,	
	#tmpPlanoGrupoCarvajal f
where	a.cnsctvo_estdo_cnta = b.cnsctvo_estdo_cnta
and	b.cnsctvo_estdo_cnta_cntrto = c.cnsctvo_estdo_cnta_cntrto
and	c.cnsctvo_estdo_cnta_cntrto_bnfcro = d.cnsctvo_estdo_cnta_cntrto_bnfcro
And	b.cnsctvo_estdo_cnta_cntrto	=	f.cnsctvo_estdo_cnta_cntrto
and 	a.cnsctvo_cdgo_lqdcn between  @cnsctvo_cdgo_lqdcn_in and @cnsctvo_cdgo_lqdcn_fn
And	cnsctvo_cdgo_cncpto_lqdcn = 4
Group by a.cnsctvo_estdo_cnta ,b.cnsctvo_estdo_cnta_cntrto


update #tmpPlanoGrupoCarvajal
Set	vlr_cbrdo	=	valor_cobrado
From	#tmpPlanoGrupoCarvajal a, #tmpValoresSinIVa b
where	a.cnsctvo_estdo_cnta_cntrto = b.cnsctvo_estdo_cnta_cntrto

Select  3 	cdgo_entdad,
	cdgo_emprsa,
	convert(varchar(10),fcha_incl_prdo_lqdcn,111)	fcha_incl_prdo_lqdcn,
	space(10)	Fecha_proceso,
	space(20)	Nmbre_Plno,
 	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	cnsctvo_estdo_cnta_cntrto ,
	0	nmro_unco_idntfccn_afldo,
	space(11)	nmro_idntfccn,
	space(50)	nmbre_fldo,
	--convert(numeric(12,0), (vlr_cbrdo * 100/(100+@lnValoPorcentajeIva)))	vlr_cbrdo,
	vlr_cbrdo,
	'N'	Ps_Ss,
	'N'	tpo_afldo,
	0	Bene_Menor_60_antiguo_servimedico,
	0	Bene_Menor_60_Nuevo_servimedico,
	0	Bene_Mayor_60_antiguo_servimedico,
	0	Bene_Mayor_60_Nuevo_servimedico,
	empresa
into 	#tmpPlanoGrupoCarvajalFinal
From #tmpPlanoGrupoCarvajal
 
--- Se actualiza el nui el cotizante
Update #tmpPlanoGrupoCarvajalFinal
Set	nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn_afldo
From	#tmpPlanoGrupoCarvajalFinal a, bdafiliacion..tbcontratos b
Where   ltrim(rtrim(a.nmro_cntrto))  	=    ltrim(rtrim(b.nmro_cntrto))  
And	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	b.cnsctvo_cdgo_pln		!=	2


--Se crea una tabla con la informacion de los beneficiarios
Select   a.cnsctvo_estdo_cnta_cntrto ,	nmro_unco_idntfccn_bnfcro, convert(datetime,null) fcha_ncmnto ,
	0	edad, 		'N'	Ps_Ss,
	0	Bene_Menor_60_antiguo_servimedico,
	0	Bene_Menor_60_Nuevo_servimedico,
	0	Bene_Mayor_60_antiguo_servimedico,
	0	Bene_Mayor_60_Nuevo_servimedico,
	0	cnsctvo_cdgo_plza_antrr,
	'N'	tpo_afldo,
	nmro_unco_idntfccn_afldo
Into 	#tmpBeneficiariosContrato
From  	#tmpPlanoGrupoCarvajalFinal  a, TbCuentasContratosbeneficiarios b
Where  a.cnsctvo_estdo_cnta_cntrto	=	b.cnsctvo_estdo_cnta_cntrto

--Actualiza la fecha de  nacimiento
Update #tmpBeneficiariosContrato
Set	fcha_ncmnto		=	b.fcha_ncmnto
From	#tmpBeneficiariosContrato  a,   bdafiliacion..tbpersonas   b
Where  a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn


--Actualiza la edad del beneficiario
Update #tmpBeneficiariosContrato
Set	edad		=	BDAFILIACION.DBO.fnCalcularTiempo (b.fcha_ncmnto,GETDATE(),1,2) 
From	#tmpBeneficiariosContrato  a,   bdafiliacion..tbpersonas   b
Where  a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn

--Actualiza la eps anterior de cada beneficiario
Update #tmpBeneficiariosContrato
Set	cnsctvo_cdgo_plza_antrr		=	b.cnsctvo_cdgo_plza_antrr
From	#tmpBeneficiariosContrato  a,   bdafiliacion..tbafiliados   b
Where  a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn_afldo


Update #tmpBeneficiariosContrato
Set	Bene_Menor_60_antiguo_servimedico	=	1
Where   cnsctvo_cdgo_plza_antrr		=	@cnsctvo_cdgo_plza_antrr
And	edad   					<	60
And	nmro_unco_idntfccn_afldo		!=	nmro_unco_idntfccn_bnfcro  


Update #tmpBeneficiariosContrato
Set	Bene_Menor_60_Nuevo_servimedico	=	1
Where   cnsctvo_cdgo_plza_antrr		!=	@cnsctvo_cdgo_plza_antrr	
And	edad   					<	60
And	nmro_unco_idntfccn_afldo		!=	nmro_unco_idntfccn_bnfcro  


Update #tmpBeneficiariosContrato
Set	Bene_Mayor_60_antiguo_servimedico	=	1
Where   cnsctvo_cdgo_plza_antrr		=	@cnsctvo_cdgo_plza_antrr
And	edad   					>=	60
And	nmro_unco_idntfccn_afldo		!=	nmro_unco_idntfccn_bnfcro  


Update #tmpBeneficiariosContrato
Set	Bene_Mayor_60_Nuevo_servimedico	=	1
Where   cnsctvo_cdgo_plza_antrr		!=	@cnsctvo_cdgo_plza_antrr	
And	edad   					>=	60
And	nmro_unco_idntfccn_afldo		!=	nmro_unco_idntfccn_bnfcro  

--Actualiza el tipo de afiliado a cada beneficiario
Update 	#tmpBeneficiariosContrato
Set	tpo_afldo				=	'A'
Where 	(Bene_Menor_60_antiguo_servimedico	!=0 	or 	Bene_Mayor_60_antiguo_servimedico!=0)


--Actualiza si tiene pos con sos los beneficiarios
--Se crea una tabla temporal
Update #tmpBeneficiariosContrato
Set	Ps_Ss		=	'S'
From	#tmpBeneficiariosContrato  a,   bdafiliacion..tbbeneficiarios   b
Where  a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn_bnfcro
And	convert(varchar(10),getdate(),111) 	between convert(varchar(10),b.inco_vgnca_bnfcro,111)       and	convert(varchar(10),b.fn_vgnca_bnfcro,111) 
And	 b.estdo					=	'A'
And	 b.cnsctvo_cdgo_tpo_cntrto		=	1


Select   	'N'	Ps_Ss,
	'N'	tpo_afldo,
	nmro_unco_idntfccn_afldo,
	sum(Bene_Menor_60_antiguo_servimedico)	Bene_Menor_60_antiguo_servimedico,
	Sum(Bene_Menor_60_Nuevo_servimedico)	Bene_Menor_60_Nuevo_servimedico,
	Sum(Bene_Mayor_60_antiguo_servimedico)	Bene_Mayor_60_antiguo_servimedico,
	Sum(Bene_Mayor_60_Nuevo_servimedico)	Bene_Mayor_60_Nuevo_servimedico
Into 	#tmpAfiliadosContrato
From  	#tmpBeneficiariosContrato
Group by 	nmro_unco_idntfccn_afldo




Select    nmro_unco_idntfccn_afldo
into	#tmpAfiliadosAntiguos
From	#tmpBeneficiariosContrato
Where   tpo_afldo	=	'A'

Update	#tmpAfiliadosContrato
Set	tpo_afldo	=	'A'	
From	#tmpAfiliadosContrato  a ,    #tmpAfiliadosAntiguos  b
Where  a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn_afldo


Select    nmro_unco_idntfccn_afldo
into	#tmpAfiliadosConPos
From	#tmpBeneficiariosContrato
Where   Ps_Ss	=	'S'



Update	#tmpAfiliadosContrato
Set	Ps_Ss	=	'S'	
From	#tmpAfiliadosContrato  a ,    #tmpAfiliadosConPos  b
Where  a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn_afldo

/*
Update #tmpPlanoGrupoCarvajalFinal
Set	Ps_Ss					=	b.Ps_Ss,
	tpo_afldo				=	b.tpo_afldo,
	Bene_Menor_60_antiguo_servimedico	=	b.Bene_Menor_60_antiguo_servimedico,
	Bene_Menor_60_Nuevo_servimedico	=	b.Bene_Menor_60_Nuevo_servimedico,
	Bene_Mayor_60_antiguo_servimedico	=	b.Bene_Mayor_60_antiguo_servimedico,
	Bene_Mayor_60_Nuevo_servimedico	=	b.Bene_Mayor_60_Nuevo_servimedico
From	#tmpPlanoGrupoCarvajalFinal a, #tmpAfiliadosContrato b
Where	a.nmro_unco_idntfccn_afldo		=	b.nmro_unco_idntfccn_afldo
*/



update #tmpPlanoGrupoCarvajalFinal
Set	Fecha_proceso	=	 substring(fcha_incl_prdo_lqdcn,1,4) + '-' +  substring(fcha_incl_prdo_lqdcn,6,2) + '-15' ,
	Nmbre_Plno	=	'PSPSOS' +   substring(fcha_incl_prdo_lqdcn,1,4) +   substring(fcha_incl_prdo_lqdcn,6,2) + '15' 



Update #tmpPlanoGrupoCarvajalFinal
Set	nmro_idntfccn	=	convert(varchar(11),b.nmro_idntfccn)
From	#tmpPlanoGrupoCarvajalFinal a, bdafiliacion..tbvinculados b
Where 	a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn


Update #tmpPlanoGrupoCarvajalFinal
Set	nmbre_fldo	=	convert(varchar(50),ltrim(rtrim(prmr_aplldo)) + ' ' + ltrim(rtrim(sgndo_aplldo)) + ' ' + ltrim(rtrim(prmr_nmbre)) + ' '  + ltrim(rtrim(sgndo_nmbre)))
From	#tmpPlanoGrupoCarvajalFinal a, bdafiliacion..tbPersonas b
Where 	a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn


Select    cdgo_entdad,
	cdgo_emprsa,
	fcha_incl_prdo_lqdcn,
	Fecha_proceso,
	Nmbre_Plno,
 	nmro_unco_idntfccn_afldo,
	nmro_idntfccn,
	nmbre_fldo,
	sum(vlr_cbrdo) vlr_cbrdo,
	Ps_Ss,
	tpo_afldo,
	sum(Bene_Menor_60_antiguo_servimedico)  Bene_Menor_60_antiguo_servimedico,
	sum(Bene_Menor_60_Nuevo_servimedico) Bene_Menor_60_Nuevo_servimedico,
	Sum(Bene_Mayor_60_antiguo_servimedico)  Bene_Mayor_60_antiguo_servimedico,
	sum(Bene_Mayor_60_Nuevo_servimedico) Bene_Mayor_60_Nuevo_servimedico,
	empresa	
into 	#tmpPlanoGrupoCarvajalFinal1
From #tmpPlanoGrupoCarvajalFinal
Group by   cdgo_entdad,
	cdgo_emprsa,
	fcha_incl_prdo_lqdcn,
	Fecha_proceso,
	Nmbre_Plno,
 	nmro_unco_idntfccn_afldo,
	nmro_idntfccn,
	nmbre_fldo,
	Ps_Ss,
	tpo_afldo,
	empresa



Update #tmpPlanoGrupoCarvajalFinal1
Set	Ps_Ss					=	b.Ps_Ss,
	tpo_afldo				=	b.tpo_afldo,
	Bene_Menor_60_antiguo_servimedico	=	b.Bene_Menor_60_antiguo_servimedico,
	Bene_Menor_60_Nuevo_servimedico	=	b.Bene_Menor_60_Nuevo_servimedico,
	Bene_Mayor_60_antiguo_servimedico	=	b.Bene_Mayor_60_antiguo_servimedico,
	Bene_Mayor_60_Nuevo_servimedico	=	b.Bene_Mayor_60_Nuevo_servimedico
From	#tmpPlanoGrupoCarvajalFinal1 a, #tmpAfiliadosContrato b
Where	a.nmro_unco_idntfccn_afldo		=	b.nmro_unco_idntfccn_afldo


Select   (ltrim(rtrim(cdgo_entdad))	 	+  char(124) +
	 ltrim(rtrim(cdgo_emprsa))	  	+  char(124) +
	 '96'  				+  char(124) + 
	 ltrim(rtrim(Fecha_proceso))  	+  char(124) +
	ltrim(rtrim(nmro_idntfccn))  	+  char(124) + 
	'0'				+  char(124) +
	ltrim(rtrim(nmbre_fldo))		+  char(124) +
	ltrim(rtrim(tpo_afldo))		+  char(124) +
	ltrim(rtrim(Ps_Ss))			+  char(124) +
	ltrim(rtrim(convert(varchar(12),vlr_cbrdo)))	+  char(124) +
	case when ( Bene_Menor_60_antiguo_servimedico  = 0) then '' else ltrim(rtrim(convert(varchar(12),Bene_Menor_60_antiguo_servimedico))) end	+  char(124)  +
	case when ( Bene_Menor_60_Nuevo_servimedico  = 0) then '' else ltrim(rtrim(convert(varchar(12),Bene_Menor_60_Nuevo_servimedico))) end	+  char(124)  +
	case when ( Bene_Mayor_60_antiguo_servimedico  = 0) then '' else ltrim(rtrim(convert(varchar(12),Bene_Mayor_60_antiguo_servimedico))) end	+  char(124)  +
	case when ( Bene_Mayor_60_Nuevo_servimedico  = 0) then '' else ltrim(rtrim(convert(varchar(12),Bene_Mayor_60_Nuevo_servimedico))) end	+  char(124)  +
	'0'  ) campo, 
	Nmbre_Plno,	
	empresa
From	#tmpPlanoGrupoCarvajalFinal1
Where 	nmro_unco_idntfccn_afldo	!=	0
order by convert(int,cdgo_emprsa) , convert(int,nmro_idntfccn)






