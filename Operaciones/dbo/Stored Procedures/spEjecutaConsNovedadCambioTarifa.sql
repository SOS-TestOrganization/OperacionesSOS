


/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spEjecutaConsNovedadCambioTarifa
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
CREATE PROCEDURE [dbo].[spEjecutaConsNovedadCambioTarifa]

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
				
					
		
select  a.nmro_unco_idntfccn_empldr, 
	a.cnsctvo_scrsl, 
	a.cnsctvo_cdgo_clse_aprtnte ,
	a.Fcha_crcn , 
	a.cnsctvo_cdgo_tpo_cntrto,
	a.nmro_cntrto,
	a.cnsctvo_bnfcro,
	a.nmro_unco_idntfccn_bnfcro,
	a.cnsctvo_cdgo_lqdcn,
	a.vlr_upc_antrr,
	a.vlr_upc_nvo,
	a.vlr_rl_pgo_antrr,
	a.vlr_rl_pgo_nvo,
	b.sde_crtra_pc 		    Cnsctvo_cdgo_sde ,
	space(10)		    cdgo_sde,
	space(30)		    dscrpcn_sde	,
	b.nmbre_scrsl ,
	a.nmro_unco_idntfccn_afldo
into	#tmpNovedadCambioTarifa
From	 TbHistoricoTarifaxBeneficiario  a,
	 bdafiliacion..tbsucursalesaportante  b,
	 tbliquidaciones c 
Where	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
And	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl
And	a.cnsctvo_cdgo_lqdcn		=	c.cnsctvo_cdgo_lqdcn
And	 1				=	2

Select  @IcInstruccion	=  				'Insert	into	#tmpNovedadCambioTarifa
							select  a.nmro_unco_idntfccn_empldr, 
								a.cnsctvo_scrsl, 
								a.cnsctvo_cdgo_clse_aprtnte ,
								a.Fcha_crcn , 
								a.cnsctvo_cdgo_tpo_cntrto,
								a.nmro_cntrto,
								a.cnsctvo_bnfcro,
								a.nmro_unco_idntfccn_bnfcro,
								a.cnsctvo_cdgo_lqdcn,
								a.vlr_upc_antrr,
								a.vlr_upc_nvo,
								a.vlr_rl_pgo_antrr,
								a.vlr_rl_pgo_nvo,
								b.sde_crtra_pc 	,
								s.cdgo_sde,
								s.dscrpcn_sde   ,
								b.nmbre_scrsl,
								a.nmro_unco_idntfccn_afldo   '+ char(13)	
Set @IcInstruccion	 =	 @IcInstruccion + '	FROM      TbHistoricoTarifaxBeneficiario a,	
								   bdafiliacion..tbSedes s ,
								   Tbliquidaciones   d	,
								   bdafiliacion..tbSucursalesAportante b  ' + char(13)

		

Set    @IcInstruccion1 = 'Where 	  a.cnsctvo_cdgo_lqdcn		=	d.cnsctvo_cdgo_lqdcn  '

Set    @IcInstruccion2 = 	 +'   	And	  a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr  ' + char(13)
			+'	And	  a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte  ' + char(13)
			+'	And	  a.cnsctvo_scrsl		=	b.cnsctvo_scrsl     ' + char(13)
			+'	And	  b.sde_crtra_pc			=	s.cnsctvo_cdgo_sde  ' + char(13)
			
			

 				 
								   			
Update #tbCriteriosTmp
Set	tbla		=	'TbHistoricoTarifaxBeneficiario'
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
		If  CHARINDEX('TbHistoricoTarifaxBeneficiario',@tbla,1) != 0
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
		IF CHARINDEX('cnsctvo_cdgo_lqdcn11',@cdgo_cmpo,1) = 0
				Select @cdgo_cmpo =  @lcAlias +Ltrim(Rtrim(@cdgo_cmpo))
			
		
		
		
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




select  b.nmro_idntfccn		nmro_idntfccn_scrsl, 
           c.cdgo_tpo_idntfccn	cdgo_tpo_idntfccn_scrsl ,
	nmro_unco_idntfccn_empldr, 
           cnsctvo_scrsl, 
           cnsctvo_cdgo_clse_aprtnte ,
           a.Fcha_crcn , 
           cnsctvo_cdgo_tpo_cntrto,
           nmro_cntrto,
          cnsctvo_bnfcro,
          nmro_unco_idntfccn_bnfcro,
          cnsctvo_cdgo_lqdcn,
          vlr_upc_antrr,
          vlr_upc_nvo,
          vlr_rl_pgo_antrr,
          vlr_rl_pgo_nvo,
             cdgo_sde,
               cnsctvo_cdgo_sde,
             dscrpcn_sde ,
	nmbre_scrsl,
	space(20)  	nmro_idntfccn_ctznte,
	space(100)	nmbre_ctznte,
	space(10)	cdgo_tpo_idntfccn_ctznte,
	space(20)	dscrpcn_pln,
	right(replicate('0',20)+ltrim(rtrim(nmro_unco_idntfccn_empldr)),20) + right(replicate('0',2)+ltrim(rtrim(cnsctvo_scrsl)),2) + right(replicate('0',2)+ltrim(rtrim(cnsctvo_cdgo_clse_aprtnte)),2)	Responsable,
	space(50)	dscrpcn_prntsco,
	space(20)  	nmro_idntfccn_bnfcro,
	space(100)	nmbre_bnfcro,
	space(10)	cdgo_tpo_idntfccn_bnfcro,
	a.nmro_unco_idntfccn_afldo
into	#tmpResporteNovedadCambioTarifa
From  #tmpNovedadCambioTarifa	 a, bdafiliacion..tbvinculados 		b,
	 bdafiliacion..tbTiposidentificacion 	c
where     b.nmro_unco_idntfccn		=	a.nmro_unco_idntfccn_empldr
And	 b.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn

--actualiza inf  del  cotizante
Update	#tmpResporteNovedadCambioTarifa
Set	nmro_idntfccn_ctznte		=	b.nmro_idntfccn,
	cdgo_tpo_idntfccn_ctznte	=	c.cdgo_tpo_idntfccn
From	#tmpResporteNovedadCambioTarifa a,	bdafiliacion..tbvinculados 		b,
	 bdafiliacion..tbTiposidentificacion 	c
where     b.nmro_unco_idntfccn		=	a.nmro_unco_idntfccn_afldo
And	 b.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn

--Actualiza nombre del cotizante
Update	#tmpResporteNovedadCambioTarifa
Set	nmbre_ctznte 			=	ltrim(rtrim(prmr_nmbre)) + ' ' +  ltrim(rtrim(sgndo_nmbre)) + ' ' + ltrim(rtrim(prmr_aplldo)) + ' '  + ltrim(rtrim(sgndo_aplldo))
From	#tmpResporteNovedadCambioTarifa a,	bdAfiliacion..tbpersonas  b
Where   a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn

--actualiza inf del beneficiario
Update	#tmpResporteNovedadCambioTarifa
Set	nmro_idntfccn_bnfcro		=	b.nmro_idntfccn,
	cdgo_tpo_idntfccn_bnfcro	=	c.cdgo_tpo_idntfccn
From	#tmpResporteNovedadCambioTarifa a,	bdafiliacion..tbvinculados 		b,
	 bdafiliacion..tbTiposidentificacion 	c
where     b.nmro_unco_idntfccn		=	a.nmro_unco_idntfccn_bnfcro
And	 b.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn

--Actualiza nombre del beneficiario
Update	#tmpResporteNovedadCambioTarifa
Set	nmbre_bnfcro 			=	ltrim(rtrim(prmr_nmbre)) + ' ' +  ltrim(rtrim(sgndo_nmbre)) + ' ' + ltrim(rtrim(prmr_aplldo)) + ' '  + ltrim(rtrim(sgndo_aplldo))
From	#tmpResporteNovedadCambioTarifa a,	bdAfiliacion..tbpersonas  b
Where   a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn

	
--Actualiza descripcion del plan
update	#tmpResporteNovedadCambioTarifa
Set	dscrpcn_pln			=	p.dscrpcn_pln
From	#tmpResporteNovedadCambioTarifa	a,
	bdAfiliacion..tbcontratos c,  bdplanBeneficios..tbplanes p
where 	a.nmro_cntrto			=	c.nmro_cntrto
And	a.cnsctvo_cdgo_tpo_cntrto	=	c.cnsctvo_cdgo_tpo_cntrto
And	c.cnsctvo_cdgo_pln		=	p.cnsctvo_cdgo_pln

update	#tmpResporteNovedadCambioTarifa
Set	dscrpcn_prntsco			=	p.dscrpcn_prntsco
From	#tmpResporteNovedadCambioTarifa	a,
	bdafiliacion..tbbeneficiarios c,  bdafiliacion..tbparentescos p
where 	a.nmro_cntrto			=	c.nmro_cntrto
And	a.cnsctvo_cdgo_tpo_cntrto	=	c.cnsctvo_cdgo_tpo_cntrto
And	a.cnsctvo_bnfcro		=	c.cnsctvo_bnfcro
And	c.cnsctvo_cdgo_prntsco		=	p.cnsctvo_cdgo_prntscs



select  * from #tmpResporteNovedadCambioTarifa
order by cnsctvo_cdgo_lqdcn,  cdgo_sde,dscrpcn_pln, Responsable,nmro_cntrto,nmbre_ctznte




