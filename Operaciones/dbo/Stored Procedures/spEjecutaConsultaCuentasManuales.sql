
/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spEjecutaConsultaCuentasManuales
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento arma y ejecuta la cadena donde se tiene los criterios para seleccionar los promotoresr 	D\>
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
CREATE  PROCEDURE spEjecutaConsultaCuentasManuales

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

	-- Contador de condiciones
	Select @lnContador = 1
	





Select  @IcInstruccion	=  'Select            a.nmro_estdo_cnta,
					b.cdgo_tpo_idntfccn,
					a.nmro_idntfccn_rspnsble_pgo ,
					c.dscrpcn_clse_aprtnte,
					a.nmbre_scrsl,
					a.nmbre_empldr,
					a.ttl_fctrdo,
					g.dscrpcn_estdo_estdo_cnta,
					a.fcha_incl_fctrcn,
					a.fcha_fnl_fctrcn,
					convert(char(20),replace(convert(char(20),a.fcha_crcn,120), ' +   Char(39) + '-' + char(39) + ','   + Char(39) + '/' + Char(39) + ' )) fcha_crcn_hra,  
					a.usro_crcn,
					 '   +   Char(39) + ' NO SELECCIONADO' +  Char(39) + ' accn ,  ' + char(13)  + '
					a.fcha_lmte_pgo,
					a.nmro_unco_idntfccn_empldr,
					a.cnsctvo_scrsl,
					a.cnsctvo_cdgo_clse_aprtnte,
					a.cnsctvo_cdgo_tpo_idntfccn,
					a.dgto_vrfccn,
					a.cts_cnclr,
					a.drccn,
					a.cnsctvo_cdgo_cdd,
					a.tlfno,
					a.vlr_iva,
					a.sldo_fvr,
					a.ttl_pgr,
					a.fcha_crcn,
					a.cnsctvo_cdgo_prdo,
					a.cnsctvo_cdgo_autrzdr_espcl,
					prcntje_incrmnto,
					a.cnsctvo_cdgo_prdo_lqdcn,
					a.cnsctvo_cdgo_estdo_estdo_cnta,
					b.dscrpcn_tpo_idntfccn,
					c.cdgo_clse_aprtnte,
					d.cdgo_prdo,
					d.dscrpcn_prdo,
					e.cdgo_prdo_lqdcn,
					e.dscrpcn_prdo_lqdcn,
					g.cdgo_estdo_estdo_cnta,
					convert(varchar(200) , (ltrim(rtrim(isnull(f.prmr_nmbre_usro,' +  Char(39) + ' ' + char(39) + '  ))) + '  +  Char(39)  +  ' '  + Char(39)   +  '  + ltrim(rtrim(isnull(f.sgndo_nmbre_usro,' +  Char(39) + ' ' + char(39) + ' ))) + '  +  Char(39)  +  ' '  + Char(39)   + ' +  ltrim(rtrim(isnull(f.prmr_aplldo_usro,' +  Char(39) + ' ' + char(39) + '))) + '  +  Char(39)  +  ' '  + Char(39)   +   ' +  ltrim(rtrim(isnull(f.sgndo_aplldo_usro,' +  Char(39) + ' ' + char(39) + ')))))   Usro_atrzdr ,
					f.cdgo_autrzdr_espcl, a.exste_cntrto '   
Set @IcInstruccion	 =	 @IcInstruccion + 'From    bdafiliacion..tbtiposidentificacion b, 
						bdafiliacion..tbclasesaportantes    c, 
						bdafiliacion..tbperiodos	    d, 
						tbPeriodosLiquidacion		    e, 	
						tbautorizadoresEspeciales_vigencias	    f,
						tbestadosestadoscuenta		g,	
						TbCuentasManuales a  ' +char(13)
Set    @IcInstruccion1 = 'Where  ' 

		Set    @IcInstruccion2 =' 		And  b.cnsctvo_cdgo_tpo_idntfccn 	= a.cnsctvo_cdgo_tpo_idntfccn
					And	c.cnsctvo_cdgo_clse_aprtnte	 = a.cnsctvo_cdgo_clse_aprtnte
					And	d.cnsctvo_cdgo_prdo		    = a.cnsctvo_cdgo_prdo
					And	e.cnsctvo_cdgo_prdo_lqdcn 	  = a.cnsctvo_cdgo_prdo_lqdcn
					And	f.cnsctvo_cdgo_autrzdr_espcl   = a.cnsctvo_cdgo_autrzdr_espcl
					And	g.cnsctvo_cdgo_estdo_estdo_cnta   = a.cnsctvo_cdgo_estdo_estdo_cnta '




Update #tbCriteriosTmp

Set  cdgo_cmpo = 'usro_crcn'
Where tbla ='TbCuentasManuales'
and cdgo_cmpo='lgn_usro'


	
	
	
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
		If  CHARINDEX('TbCuentasManuales',@tbla,1) != 0
		Begin
			-- si tabla es tbTiposNotas se asigna como alias b
			Select @lcAlias = 'a.'
		End
		Else
		Begin
			If  CHARINDEX('tbestadosestadoscuenta',@tbla,1) != 0
			Begin
				-- si tabla es tbSedes se asigna como alias c
				Select @lcAlias = 'g.'
			End
			Else  
			Begin
				If  CHARINDEX('bdafiliacion..tbTiposIdentificacion',@tbla,1) != 0
				Begin

					-- si tabla es tbCausasAnulacionNotas se asigna como alias e
					Select @lcAlias = 'b.'
				End
				Else
				Begin
					If  CHARINDEX('bdafiliacion..tbclasesaportantes',@tbla,1) != 0 

					Begin
						-- si tabla es tbNotas se asigna como alias a
						Select @lcAlias = 'c.'
					End	
                                                                   Else
					Begin
						If  CHARINDEX('bdafiliacion..tbperiodos',@tbla,1) != 0 

						Begin
							-- si tabla es tbNotas se asigna como alias a
							Select @lcAlias = 'd.'
						End	
					End

				
				End	
					
			End	
		End	
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
