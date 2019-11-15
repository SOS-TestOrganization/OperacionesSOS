
/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spEjecutaConsRelacionEstadosCuenta
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
* Modificado Por		: <\A Ing. Fernando Valencia E   AM\>
* Descripcion			: <\D Se modifica para que no tenga en cuenta los estados de cuenta 4 M\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\F 2006/06/21  FM\>


* Modificado Por		: <\A Ing. Diana Lorena Gomez   AM\>
* Descripcion			: <\D Se modifica que no salgan datos repetidos al finalizar el informe M\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\F 2008/03/13  FM\>
*---------------------------------------------------------------------------------*/
CREATE   PROCEDURE [dbo].[spEjecutaConsRelacionEstadosCuenta]

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

-- Creacion de tablas temporales

-- Quick: 2013-00001-000026555 
-- Por: Francisco J. Gonzalez R.
-- Descripcion: Favor al informe de Gestión del aplicativo Cartera PAC, RELACIÓN ESTADOS DE CUENTA, agreagar una columna de los contratos liquidados 
-- y total de beneficiarios liquidados (por cada responsable de pago - sucursal).

Create table #tmpcontratos	(
	nmro_unco_idntfccn_empldr		Int,				cnsctvo_scrsl			Int,					nmro_estdo_cnta		varchar(15),
	cnsctvo_estdo_cnta_cntrto		Int,				nmro_cntrto				udtNumeroFormulario,	cntdd_bnfcrs		Int	)

Create table #tmpbeneficiarios	(cnsctvo_estdo_cnta_cntrto		Int,				cantidad			Int	)

Create Table #tmpConteoFinal (
	nmro_unco_idntfccn_empldr		Int,				cnsctvo_scrsl			Int,					nmro_estdo_cnta		varchar(15),
	contratantes					Int,				beneficiarios			Int)


--Se cruzan los contratos asociados a las sucursales y se traer las sucursales finales para liquidar



 
-- Contador de condiciones
Select @lnContador = 1

-- se crea la tabla temporal con la infromacion de las sucursales que s epuedan liquidar
				
					
		
select  a.nmro_unco_idntfccn_empldr, 
	a.cnsctvo_scrsl, 
	a.cnsctvo_cdgo_clse_aprtnte ,
	a.Fcha_crcn , 
	a.cnsctvo_cdgo_lqdcn,
	b.sde_crtra_pc 		    Cnsctvo_cdgo_sde ,
	space(10)		    cdgo_sde,
	space(30)		    dscrpcn_sde	,
	b.nmbre_scrsl ,
	b.drccn , 
	b.tlfno ,
	ci.cdgo_cdd, 
	ci.dscrpcn_cdd ,
	dp.dscrpcn_dprtmnto,
	a.nmro_estdo_cnta,
	a.ttl_fctrdo,
	a.vlr_iva,
	a.ttl_pgr,
	b.eml
into	#tmpRelacionEstadosCuenta
From	 TbEstadosCuenta  a,
	 bdafiliacion..tbsucursalesaportante  b,
	 tbliquidaciones c ,
	 bdafiliacion..tbciudades_Vigencias		ci,
	 bdafiliacion..tbDepartamentos			dp	
Where	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
And	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl
And	a.cnsctvo_cdgo_lqdcn		=	c.cnsctvo_cdgo_lqdcn
And	b.cnsctvo_cdgo_cdd		=	ci.cnsctvo_cdgo_cdd
And	ci.cnsctvo_cdgo_dprtmnto	=	dp.cnsctvo_cdgo_dprtmnto
And	 1				=	2

Select  @IcInstruccion	=  				'Insert	into	#tmpRelacionEstadosCuenta
							select  a.nmro_unco_idntfccn_empldr, 
								a.cnsctvo_scrsl, 
								a.cnsctvo_cdgo_clse_aprtnte ,
								a.Fcha_crcn , 
								a.cnsctvo_cdgo_lqdcn,
								b.sde_crtra_pc 	,
								s.cdgo_sde,
								s.dscrpcn_sde   ,
								b.nmbre_scrsl ,
								b.drccn , 
								b.tlfno ,
								ci.cdgo_cdd, 
								ci.dscrpcn_cdd  ,
								dp.dscrpcn_dprtmnto,
								a.nmro_estdo_cnta,
								a.ttl_fctrdo,
								a.vlr_iva,
								a.ttl_pgr,
								b.eml   '+ char(13)	
Set @IcInstruccion	 =	 @IcInstruccion + '	FROM      TbEstadosCuenta a,	
								   bdafiliacion..tbSedes s ,
								   Tbliquidaciones   d	,
								   bdafiliacion..tbSucursalesAportante 		b ,
							  	   bdafiliacion..tbciudades_vigencias		ci,
								   bdafiliacion..tbDepartamentos dp' + char(13)

		

Set    @IcInstruccion1 = 'Where 	  a.cnsctvo_cdgo_lqdcn		=	d.cnsctvo_cdgo_lqdcn  '

Set    @IcInstruccion2 = 	 +'   	And	  a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr  ' + char(13)
			+'	And	  a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte  '	+ char(13)
			+'	And	  a.cnsctvo_scrsl		=	b.cnsctvo_scrsl     ' 		+ char(13)
			+'	And	  b.sde_crtra_pc		=	s.cnsctvo_cdgo_sde  ' 		+ char(13)
			+'	And	  ci.cnsctvo_cdgo_cdd		=	b.cnsctvo_cdgo_cdd     ' 	+ char(13)
			+'	And 	  ci.cnsctvo_cdgo_dprtmnto	=	dp.cnsctvo_cdgo_dprtmnto    ' 	+ char(13)
			+'      And       d.cnsctvo_cdgo_estdo_lqdcn  != 4'					+ char(13)		
           	 +  '	And	  a.cnsctvo_cdgo_estdo_estdo_cnta	 != 4	 ' + char(13)

 				 
								   			
Update #tbCriteriosTmp
Set	tbla		=	'TbEstadosCuenta'
Where cdgo_cmpo	=	'fcha_crcn'

								   			
Update #tbCriteriosTmp
Set	tbla		=	'tbSedes'
Where cdgo_cmpo	=	'cnsctvo_cdgo_sde'

Update #tbCriteriosTmp
Set	tbla		=	'Tbliquidaciones'
Where cdgo_cmpo	=	'cnsctvo_cdgo_lqdcn'



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
		If  CHARINDEX('TbEstadosCuenta',@tbla,1) != 0
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
					If  CHARINDEX('Tbliquidaciones',@tbla,1) != 0
					Begin
	
						-- si tabla es tbTiposIdentificacion se asigna como alias e
						Select @lcAlias = 'd.'
					End
				End					
			End	
		End	
		-- se le adicionan adelante y atras comillas simples al valor de la condicion cuando es diferente el campo de nmro_nta
		
		
					-- se le pone el alias cuando el campo es diferente de nmro de nota
		if CHARINDEX('cnsctvo_cdgo_lqdcn11',@cdgo_cmpo,1) = 0 
			Select @vlr = char(39) + rtrim(ltrim(@vlr)) + char(39) 
	
		If CHARINDEX('fcha',@cdgo_cmpo,1) != 0
			Select @cdgo_cmpo = 'Convert(varchar(10),'+ @lcAlias +Ltrim(Rtrim(@cdgo_cmpo))+',111)'

		Else
		Begin
			-- se le pone el alias cuando el campo es diferente de nmro de nota
			IF CHARINDEX('cnsctvo_cdgo_lqdcn11',@cdgo_cmpo,1) = 0
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

-- Quick: 2013-00001-000026555 
-- Por: Francisco J. Gonzalez R.
-- Descripcion: Favor al informe de Gestión del aplicativo Cartera PAC, RELACIÓN ESTADOS DE CUENTA, agreagar una columna de los contratos liquidados 
-- y total de beneficiarios liquidados (por cada responsable de pago - sucursal).


-- Consultan los estados de cuenta contrato
Insert	#tmpcontratos	(
		nmro_unco_idntfccn_empldr,				cnsctvo_scrsl,					nmro_estdo_cnta, 
		cnsctvo_estdo_cnta_cntrto,				nmro_cntrto,					cntdd_bnfcrs )
Select	Distinct
		ec.nmro_unco_idntfccn_empldr,			ec.cnsctvo_scrsl,					ec.nmro_estdo_cnta, 
		ecc.cnsctvo_estdo_cnta_cntrto,			ecc.nmro_cntrto,					0 as cntdd_bnfcrs 
--		,ec.ttl_fctrdo, ec.vlr_iva, ec.vlr_iva,ecc.vlr_cbrdo,  ecc.cnsctvo_cdgo_tpo_cntrto, ecc.nmro_cntrto, 0 pln, space(50) descripcion, space(150) cdd
From	dbo.tbEstadosCuenta ec Inner Join dbo.tbEstadosCuentaContratos ecc
			On ec.cnsctvo_estdo_cnta = ecc.cnsctvo_estdo_cnta
		Inner Join #tmpRelacionEstadosCuenta a
			On	a.cnsctvo_cdgo_lqdcn	= ec.cnsctvo_cdgo_lqdcn
			And	a.nmro_estdo_cnta		= ec.nmro_estdo_cnta


-- Buscamos los benenficiarios por contrato
--drop table  #tmpbeneficiarios

Insert Into	#tmpbeneficiarios	(
			cnsctvo_estdo_cnta_cntrto,				cantidad	)
Select		ccb.cnsctvo_estdo_cnta_cntrto,			count(ccb.cnsctvo_estdo_cnta_cntrto_bnfcro) cantidad
From	dbo.tbCuentasContratosBeneficiarios ccb 
Where	ccb.cnsctvo_estdo_cnta_cntrto in (select cnsctvo_estdo_cnta_cntrto from #tmpcontratos )
Group By cnsctvo_estdo_cnta_cntrto


-- Se actualizan la cantidad de Beneficiarios

Update  c
Set		cntdd_bnfcrs = cantidad
From	#tmpcontratos c Inner Join  #tmpbeneficiarios  b
			On c.cnsctvo_estdo_cnta_cntrto = b.cnsctvo_estdo_cnta_cntrto


--drop table  #tmpInformeFin
Insert Into #tmpConteoFinal	(
		nmro_unco_idntfccn_empldr,				cnsctvo_scrsl,						nmro_estdo_cnta,
		contratantes,							beneficiarios	)
Select	nmro_unco_idntfccn_empldr,				cnsctvo_scrsl,						nmro_estdo_cnta, 
		count(nmro_cntrto) contratantes,		sum(cntdd_bnfcrs) as beneficiarios
From #tmpcontratos
Group by nmro_unco_idntfccn_empldr, cnsctvo_scrsl, nmro_estdo_cnta

-- Fin Quick: 2013-00001-000026555 




Select  b.nmro_idntfccn		nmro_idntfccn_scrsl, 
		c.cdgo_tpo_idntfccn	cdgo_tpo_idntfccn_scrsl ,
		a.nmro_unco_idntfccn_empldr, 
		a.cnsctvo_scrsl, 
		cnsctvo_cdgo_clse_aprtnte ,
		a.Fcha_crcn , 
		cnsctvo_cdgo_lqdcn,
		cdgo_sde,
		cnsctvo_cdgo_sde,
		dscrpcn_sde ,
		nmbre_scrsl,
		right(replicate('0',20)+ltrim(rtrim(a.nmro_unco_idntfccn_empldr)),20) + right(replicate('0',2)+ltrim(rtrim(a.cnsctvo_scrsl)),2) + right(replicate('0',2)+ltrim(rtrim(cnsctvo_cdgo_clse_aprtnte)),2)	Responsable,
		drccn , 
		tlfno ,
		cdgo_cdd, 
		dscrpcn_cdd ,
		dscrpcn_dprtmnto,
		a.nmro_estdo_cnta,
		a.ttl_fctrdo,
		a.vlr_iva,
		a.ttl_pgr,
		d.contratantes As cntdd_cntrts,
		d.beneficiarios As cntdd_bnfcrs,
		a.eml as eml_empldr,
		e.eml as eml_afldo
into	#tmpReporteRelacionEstadosCuenta
From	#tmpRelacionEstadosCuenta a
		inner join  bdafiliacion.dbo.tbvinculados b with(nolock) on b.nmro_unco_idntfccn		=	a.nmro_unco_idntfccn_empldr
		inner join  bdafiliacion.dbo.tbTiposidentificacion c with(nolock) on b.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn
		inner join	#tmpConteoFinal d on	a.nmro_unco_idntfccn_empldr	=	d.nmro_unco_idntfccn_empldr
											And		a.cnsctvo_scrsl				=	d.cnsctvo_scrsl
											And		a.nmro_estdo_cnta			=	d.nmro_estdo_cnta
		left join	bdAfiliacion.dbo.tbPersonas e with(nolock) on b.nmro_unco_idntfccn = e.nmro_unco_idntfccn
 

/*
select * from #tmpReporteRelacionEstadosCuenta
order by cnsctvo_cdgo_lqdcn,  cdgo_sde, Responsable
*/



-- SAU 82408

Select	nmro_idntfccn_scrsl, 
		cdgo_tpo_idntfccn_scrsl ,
		nmro_unco_idntfccn_empldr, 
		cnsctvo_scrsl, 
		cnsctvo_cdgo_clse_aprtnte ,
        Fcha_crcn , 
        cnsctvo_cdgo_lqdcn,
        cdgo_sde,
        cnsctvo_cdgo_sde,
        dscrpcn_sde ,
		nmbre_scrsl,
		Responsable,
		drccn , 
		tlfno ,
		cdgo_cdd, 
		dscrpcn_cdd ,
		dscrpcn_dprtmnto,
		nmro_estdo_cnta,
		ttl_fctrdo,
		vlr_iva,
		ttl_pgr,
		cntdd_cntrts,
		cntdd_bnfcrs,
		eml_empldr,
		eml_afldo
From #tmpReporteRelacionEstadosCuenta
Group by	nmro_idntfccn_scrsl, 
          	cdgo_tpo_idntfccn_scrsl ,
			nmro_unco_idntfccn_empldr, 
            cnsctvo_scrsl, 
            cnsctvo_cdgo_clse_aprtnte ,
			Fcha_crcn , 
            cnsctvo_cdgo_lqdcn,
            cdgo_sde,
            cnsctvo_cdgo_sde,
            dscrpcn_sde ,
			nmbre_scrsl,
			Responsable,
			drccn , 
			tlfno ,
			cdgo_cdd, 
			dscrpcn_cdd ,
			dscrpcn_dprtmnto,
			nmro_estdo_cnta,
			ttl_fctrdo,
			vlr_iva,
			ttl_pgr,
			cntdd_cntrts,
			cntdd_bnfcrs,
			eml_empldr,
			eml_afldo
Order By cnsctvo_cdgo_lqdcn,  cdgo_sde, Responsable


Drop table #tmpcontratos
Drop table #tmpbeneficiarios
Drop Table #tmpConteoFinal
