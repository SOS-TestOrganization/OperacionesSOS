/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spEjecutaConsultaSucursalesXPromotores
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
CREATE  PROCEDURE spEjecutaConsultaSucursalesXPromotores

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
@lnContador		Int

Set Nocount On




Select  b.cnsctvo_scrsl,	b.nmro_unco_idntfccn_empldr,	b.cnsctvo_cdgo_clse_aprtnte,
	nmbre_scrsl,	space(3) cdgo_tpo_idntfccn , 	space(15) nmro_idntfccn, 
	space(200)rzn_scl  , space(1) encntrdo_emprsa, a.cnsctvo_cdgo_prmtr, a.cdgo_prmtr, convert(varchar(200) , (ltrim(rtrim(isnull(a.prmr_aplldo,''))) + ''  +   ltrim(rtrim(isnull(a.sgndo_aplldo,' ' ))) +   ' '  +  ltrim(rtrim(isnull(a.prmr_nmbre,' '))) +  ' '  +  ltrim(rtrim(isnull(a.sgndo_nmbre,''))) +  '  '  +  ltrim(rtrim(isnull(a.rzn_scl,'')))) ) dscrpcn_prmtr 
into #tmpSucursales
from bdcarterapac..tbpromotores_vigentes a ,bdafiliacion..tbsucursalesaportante b
Where	 prmtr_crtra_pc = cnsctvo_cdgo_prmtr
And	 a.brrdo='N'	

--Actualizamos el tipo y numero de identificacion
Update  #tmpSucursales
Set	cdgo_tpo_idntfccn = c.cdgo_tpo_idntfccn,
	nmro_idntfccn	  = b.nmro_idntfccn
From	#tmpSucursales a, bdafiliacion..tbvinculados b, bdafiliacion..tbTiposIdentificacion c
Where 	a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn
And	b.Cnsctvo_cdgo_tpo_idntfccn = c.Cnsctvo_cdgo_tpo_idntfccn
And	b.vldo	=	'S'


--Actualizamos la razon social de empresas
Update  #tmpSucursales
Set  	rzn_scl	     =  c.rzn_scl,
	encntrdo_emprsa = '1'
From 	#tmpSucursales	 a ,  bdafiliacion..tbempleadores b,	bdafiliacion..tbempresas c
Where 	a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn
And	a.nmro_unco_idntfccn_empldr		=	c.nmro_unco_idntfccn 



--Actualizamos la razon social de personas
Update 	#tmpSucursales
Set  	rzn_scl	     =   ltrim(rtrim(isnull(c.prmr_aplldo,'')))  + ' ' + ltrim(rtrim(isnull(c.sgndo_aplldo,''))) + ' ' + ltrim(rtrim(isnull(c.prmr_nmbre,''))) + ' ' + ltrim(rtrim(isnull(c.sgndo_nmbre,'')))
From 	#tmpSucursales a	,bdafiliacion..tbempleadores b,	bdafiliacion..tbpersonas c--,	tbclasesempleador d
Where	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn
And	a.nmro_unco_idntfccn_empldr	=	c.nmro_unco_idntfccn
And	a.encntrdo_emprsa		<> 	'1'


	-- Contador de condiciones
	Select @lnContador = 1
	

Select  @IcInstruccion	=  	'Select   c.cdgo_prmtr,
					  c.dscrpcn_prmtr,
					  c.cdgo_tpo_idntfccn,
					  c.nmro_idntfccn,
					  c.rzn_scl,
					  c.nmbre_scrsl,
					     '  +   Char(39) + 'NO SELECCIONADO' +  Char(39) + ' accn ,  c.cnsctvo_cdgo_prmtr, c.nmro_unco_idntfccn_empldr,c.cnsctvo_cdgo_clse_aprtnte,c.cnsctvo_scrsl ' + char(13)	 	

Set @IcInstruccion	 =	 @IcInstruccion + 'From #tmpSucursales c where '  + char(13)

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
	

		-- se realiza la asignacion del alias
		If  CHARINDEX('#tmpSucursales ',@tbla,1) != 0
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
	Select 'cadena3',substring(ltrim(rtrim(@IcInstruccion)),1001,1250) */

	Exec sp_executesql     @IcInstruccion