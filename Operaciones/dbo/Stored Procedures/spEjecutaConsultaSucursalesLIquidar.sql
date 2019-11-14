/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spEjecutaConsultaSucursalesLIquidar
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
CREATE  PROCEDURE spEjecutaConsultaSucursalesLIquidar

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
--se traen los contratos de planes complementarios y activos
--falta asociarle el consecutivo del estado del beneficiario

-------------------------------------------------
/*
Select cnsctvo_cdgo_tpo_cntrto, 
       nmro_cntrto,
       cnsctvo_bnfcro,
       nmro_unco_idntfccn_bnfcro,
       inco_vgnca_bnfcro,
       fn_vgnca_bnfcro
Into #tmpBeneficiarios                        
from bdafiliacion..tbBeneficiarios
Where cnsctvo_cdgo_tpo_cntrto = 2

--Se crea la tabla temporal con la informacion delos beneficiarios que se encuentran activos y tambien pueden estar suspendidos
Select   cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	cnsctvo_bnfcro,
	nmro_unco_idntfccn_bnfcro,
	cnsctvo_cdgo_estdo_bfcro
Into 	#tmpHistoricoEstadosBeneficiario 
from  	bdafiliacion..tbHistoricoEstadosBeneficiario
Where 	cnsctvo_cdgo_tpo_cntrto = 	 2
And	hbltdo			=	'S'
and 	(cnsctvo_cdgo_estdo_bfcro = 1 or cnsctvo_cdgo_estdo_bfcro  = 5 )
And	@ldFechaSistema between inco_vgnca_estdo_bnfcro and fn_vgnca_estdo_bnfcro


--Como un beneficiario puede tener 2 estados a la vez activos o suspendidos
--hay que identificar que solamente tengan el estado activo
--Se crea una tabla temporal de los benefciarios activos  de la consulta anterior

Select 	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
        	cnsctvo_bnfcro,
	nmro_unco_idntfccn_bnfcro,
	cnsctvo_cdgo_estdo_bfcro,
	0	Suspendido
into	#tmpBeneficiariosEstadoActivos
From	#tmpHistoricoEstadosBeneficiario
Where 	cnsctvo_cdgo_estdo_bfcro	=	1


--Se crea una tabla temporal de los benefciarios SuspendidosSelect 	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
        	cnsctvo_bnfcro,
	nmro_unco_idntfccn_bnfcro,
	cnsctvo_cdgo_estdo_bfcro
into	#tmpBeneficiariosEstadoSuspendidos
From	#tmpHistoricoEstadosBeneficiario
Where 	cnsctvo_cdgo_estdo_bfcro	=	5



--si existen registros que esten en ambas tablas es porque puede estar suspendido a la vez.
Update 	#tmpBeneficiariosEstadoActivos
Set	suspendido	=	1
From	#tmpBeneficiariosEstadoActivos a, 	#tmpBeneficiariosEstadoSuspendidos b
Where   a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto
And	a.cnsctvo_bnfcro		=	b.cnsctvo_bnfcro
And	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn_bnfcro



--Se trae todos los contratos activos
Select    cnsctvo_cdgo_tpo_cntrto  , nmro_cntrto
into 	  #tmpContratos
From 	  bdafiliacion..tbcontratos
Where 	  cnsctvo_cdgo_tpo_cntrto 		=	2
And	  @ldFechaSistema	  between  inco_vgnca_cntrto	  and 	 fn_vgnca_cntrto




Select  a.cnsctvo_cdgo_tpo_cntrto,	 a.nmro_cntrto
into   #tmpContratosActivospac
From   #tmpBeneficiariosEstadoActivos a,  #tmpBeneficiarios b  , #tmpContratos c
Where	  a.suspendido			= 0
And	  a.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
And	  a.nmro_cntrto 			= b.nmro_cntrto
And	  a.cnsctvo_bnfcro		= b.cnsctvo_bnfcro
And	  a.nmro_unco_idntfccn_bnfcro	= b.nmro_unco_idntfccn_bnfcro	
And       a.cnsctvo_cdgo_tpo_cntrto	= c.cnsctvo_cdgo_tpo_cntrto
And	  a.nmro_cntrto 			= c.nmro_cntrto
Group by a.cnsctvo_cdgo_tpo_cntrto,	 a.nmro_cntrto

select  * 
into 	#tmpVigenciasCobranzas
from 	bdafiliacion..tbVigenciasCobranzas
where 	cnsctvo_cdgo_tpo_cntrto = 2
And	@ldFechaSistema  between  inco_vgnca_cbrnza 	  and	 fn_vgnca_cbrnza


Select  cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	cnsctvo_cbrnza,
	nmro_unco_idntfccn_aprtnte,
	cnsctvo_cdgo_clse_aprtnte,
	cnsctvo_cdgo_tpo_cbrnza
into  #tmpcobranzas
From	bdafiliacion..tbcobranzas
Where  cnsctvo_cdgo_tpo_cntrto 		=	2




--Se traen las sucursales de planes complementearios  asociados a los contratos activos de pac
select    b.nmro_unco_idntfccn_aprtnte,      c.cnsctvo_scrsl_ctznte,	b.cnsctvo_cdgo_clse_aprtnte
into #TmpSucursalesContratosPac
From 	#tmpContratosActivospac  a,		#tmpcobranzas  b ,	#tmpVigenciasCobranzas c 
Where   a.cnsctvo_cdgo_tpo_cntrto 	= b.cnsctvo_cdgo_tpo_cntrto
And 	a.nmro_cntrto		  	= b.nmro_cntrto
And	c.cnsctvo_cdgo_tpo_cntrto 	= b.cnsctvo_cdgo_tpo_cntrto
And	c.nmro_cntrto		  	= b.nmro_cntrto
And	c.cnsctvo_cbrnza	 	= b.cnsctvo_cbrnza
And	a.cnsctvo_cdgo_tpo_cntrto 	=	2	--Contratos de planes complementarios
Group by     b.nmro_unco_idntfccn_aprtnte,      c.cnsctvo_scrsl_ctznte,	b.cnsctvo_cdgo_clse_aprtnte



*/

Select   cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	cnsctvo_cdgo_pln,
	cnsctvo_cdgo_tpo_aflcn,
	inco_vgnca_cntrto,
	fn_vgnca_cntrto,
	estdo_cntrto,
	cnsctvo_cdgo_tpo_frmlro,
	nmro_frmlro,
	nmro_unco_idntfccn_afldo
into    	#tmpContratosActivospac
From   	bdafiliacion..tbcontratos  a
where   	cnsctvo_cdgo_tpo_cntrto = 	2
And	estdo_cntrto		  =	'A'


Select  	cnsctvo_vgnca_cbrnza,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	cnsctvo_cbrnza,
	cnsctvo_scrsl_ctznte,
	inco_vgnca_cbrnza,
	fn_vgnca_cbrnza,
	ingrso_bse,
	ingrso_bse_ps,
	cta_mnsl,
	vlr_msda_pnsnl,
	estdo_rgstro,
	inco_drcn_rgstro,
	fn_drcn_rgstro
Into 	#tmpVigenciasCobranzas
from 	bdafiliacion..tbVigenciasCobranzas
where 	cnsctvo_cdgo_tpo_cntrto 	=	 2
--And	@ldFechaSistema  between  inco_vgnca_cbrnza 	  and	 fn_vgnca_cbrnza


Select  	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	cnsctvo_cbrnza,
	nmro_unco_idntfccn_aprtnte,
	cnsctvo_cdgo_clse_aprtnte,
	cnsctvo_cdgo_tpo_cbrnza
into 	 #tmpcobranzas
From	bdafiliacion..tbcobranzas
Where  cnsctvo_cdgo_tpo_cntrto 		=	2




--Se traen las sucursales de planes complementearios  asociados a los contratos activos de pac
select    b.nmro_unco_idntfccn_aprtnte,      c.cnsctvo_scrsl_ctznte,	b.cnsctvo_cdgo_clse_aprtnte
into #TmpSucursalesContratosPac
From 	#tmpContratosActivospac  a,		#tmpcobranzas  b ,	#tmpVigenciasCobranzas c 
Where   a.cnsctvo_cdgo_tpo_cntrto 	= b.cnsctvo_cdgo_tpo_cntrto
And 	a.nmro_cntrto		  	= b.nmro_cntrto
And	c.cnsctvo_cdgo_tpo_cntrto 	= b.cnsctvo_cdgo_tpo_cntrto
And	c.nmro_cntrto		  	= b.nmro_cntrto
And	c.cnsctvo_cbrnza	 	= b.cnsctvo_cbrnza
And	a.cnsctvo_cdgo_tpo_cntrto 	=	2	--Contratos de planes complementarios
Group by     b.nmro_unco_idntfccn_aprtnte,      c.cnsctvo_scrsl_ctznte,	b.cnsctvo_cdgo_clse_aprtnte

--Se cruzan los contratos asociados a las sucursales y se traer las sucursales finales para liquidar


-- Contador de condiciones
Select @lnContador = 1

-- se crea la tabla temporal con la infromacion de las sucursales que s epuedan liquidar

SELECT     b.cnsctvo_scrsl,			 a.cdgo_tpo_idntfccn, 		d.nmro_idntfccn,		 c.dscrpcn_clse_aprtnte, 
                   b.nmbre_scrsl, 			 ' NO SELECCIONADO'  	 accn ,
            	      b.sde_crtra_pc	 		cnsctvo_cdgo_sde , 
	     a.dscrpcn_tpo_idntfccn,		 SPACE(200) AS rzn_scl, 
	     d.cnsctvo_cdgo_tpo_idntfccn,		 b.nmro_unco_idntfccn_empldr, 
                  b.cnsctvo_cdgo_clse_aprtnte
into 	    #TmpSucursalesLiquidar
fROM         bdAfiliacion.dbo.tbTiposIdentificacion a INNER JOIN       bdAfiliacion.dbo.tbVinculados d 
								ON a.cnsctvo_cdgo_tpo_idntfccn = d.cnsctvo_cdgo_tpo_idntfccn
						 INNER JOIN       bdAfiliacion.dbo.tbSucursalesAportante b
								ON d.nmro_unco_idntfccn = b.nmro_unco_idntfccn_empldr
						  INNER JOIN #TmpSucursalesContratosPac    e
								On  e.nmro_unco_idntfccn_aprtnte =	b.nmro_unco_idntfccn_empldr	And
								       e.cnsctvo_scrsl_ctznte	=  	b.cnsctvo_scrsl			And
								       e.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte		
					 	 INNER JOIN       bdAfiliacion.dbo.tbClasesAportantes c 
								ON b.cnsctvo_cdgo_clse_aprtnte = c.cnsctvo_cdgo_clse_aprtnte 



Select  @IcInstruccion	=  	' SELECT         cnsctvo_scrsl,	 		cdgo_tpo_idntfccn, 	nmro_idntfccn,	 dscrpcn_clse_aprtnte, 
			                 	           nmbre_scrsl, 	    		accn ,                              cnsctvo_cdgo_sde , 
				                        dscrpcn_tpo_idntfccn, 		 rzn_scl, 
				     	           cnsctvo_cdgo_tpo_idntfccn, 	nmro_unco_idntfccn_empldr, 
			                  	           cnsctvo_cdgo_clse_aprtnte
				   FROM        #TmpSucursalesLiquidar c  where '



Set    @IcInstruccion1 =  '    ' 
Set    @IcInstruccion2 =  '    ' 

	
	
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
	

		If  CHARINDEX('#TmpSucursalesLiquidar',@tbla,1) != 0
		Begin
			-- si tabla es tbTiposNotas se asigna como alias b
			Select @lcAlias = 'c.'
		End
		Else
		-- se le adicionan adelante y atras comillas simples al valor de la condicion cuando es diferente el campo de nmro_nta
		--if CHARINDEX('nmro_nta',@cdgo_cmpo,1) = 0 -- Ltrim(Rtrim(@cdgo_cmpo)) != 'convert(int,substring(nmro_nta,4,15))'
			Select @vlr = char(39) + rtrim(ltrim(@vlr)) + char(39) 
	
		If CHARINDEX('fcha',@cdgo_cmpo,1) != 0
			Select @cdgo_cmpo = 'Convert(varchar(10),'+ @lcAlias +Ltrim(Rtrim(@cdgo_cmpo))+',111)'
		Else
		Begin
			-- se le pone el alias cuando el campo es diferente de nmro de nota
			--IF CHARINDEX('nmro_nta',@cdgo_cmpo,1) = 0--Ltrim(Rtrim(@cdgo_cmpo)) != 'convert(int,substring(nmro_nta,4,15))'
				Select @cdgo_cmpo =  @lcAlias +Ltrim(Rtrim(@cdgo_cmpo))
			
		End
		
		If @lnContador = 1
	             Begin
			If ltrim(rtrim(@oprdr)) ='N'
			Begin
				Select @IcInstruccion1= @IcInstruccion1 +  ltrim(rtrim(@cdgo_cmpo))+' Is null '+char(13)
			End
			Else
			Begin
				If ltrim(rtrim(@oprdr)) ='NN'
					Select @IcInstruccion1= @IcInstruccion1 +  ltrim(rtrim(@cdgo_cmpo))+' Is not null '+char(13)	
				Else
					Select @IcInstruccion1= @IcInstruccion1 +  ltrim(rtrim(@cdgo_cmpo)) + space(1) +  ltrim(rtrim(@oprdr)) + space(1) + ltrim(rtrim(@vlr)) + char(13)
			End
	     	End
		Else
	     	Begin
			If ltrim(rtrim(@oprdr)) ='N'
			Begin
				Select @IcInstruccion1= @IcInstruccion1 + 'And ' +  ltrim(rtrim(@cdgo_cmpo))+' Is null '+char(13)
			End
			Else
			Begin
				If ltrim(rtrim(@oprdr)) ='NN'
					Select @IcInstruccion1= @IcInstruccion1 + 'And ' +  ltrim(rtrim(@cdgo_cmpo))+' Is Not null '+char(13)
				Else
					Select @IcInstruccion1= @IcInstruccion1 + 'And ' +   ltrim(rtrim(@cdgo_cmpo)) + space(1) +  ltrim(rtrim(@oprdr)) + space(1) + ltrim(rtrim(@vlr)) + char(13)
			End
	
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
	Select substring(ltrim(rtrim(@IcInstruccion)),251,500)
	Select 'cadena2',substring(ltrim(rtrim(@IcInstruccion)),501,750)
	select substring(ltrim(rtrim(@IcInstruccion)),751,1000)
	Select 'cadena3',substring(ltrim(rtrim(@IcInstruccion)),1001,1250)*/

	Exec sp_executesql     @IcInstruccion