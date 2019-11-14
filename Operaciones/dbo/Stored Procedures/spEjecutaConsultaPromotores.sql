
/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spEjecutaConsultaPromotores
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
CREATE  PROCEDURE spEjecutaConsultaPromotores

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
	

Select  @IcInstruccion	=  	'Select     c.cdgo_prmtr,
				d.cdgo_tpo_idntfccn,
				c.nmro_idntfccn_prmtr,
				convert(varchar(200) , (ltrim(rtrim(isnull(c.prmr_aplldo,' +  Char(39) + ' ' + char(39) + '  ))) + '  +  Char(39)  +  ' '  + Char(39)   +  '  + ltrim(rtrim(isnull(c.sgndo_aplldo,' +  Char(39) + ' ' + char(39) + ' ))) + '  +  Char(39)  +  ' '  + Char(39)   + ' +  ltrim(rtrim(isnull(c.prmr_nmbre,' +  Char(39) + ' ' + char(39) + '))) + '  +  Char(39)  +  ' '  + Char(39)   +   ' +  ltrim(rtrim(isnull(c.sgndo_nmbre,' +  Char(39) + ' ' + char(39) + '))) + '   +    Char(39)  +  '  '  + Char(39)   +   ' +   ltrim(rtrim(isnull(c.rzn_scl,' +  Char(39) + ' ' + char(39) + ')))) ) nombre ,
				c.inco_vgnca,
				c.fn_vgnca,
				convert(char(20),replace(convert(char(20),c.fcha_crcn,120), ' +   Char(39) + '-' + char(39) + ','   + Char(39) + '/' + Char(39) + ' )) fcha_crcn_hra,
				c.usro_crcn,
				c.cnsctvo_cdgo_tpo_idntfccn,
				c.cnsctvo_cdgo_cdd,
				c.tlfno,
				c.drccn,
				c.eml,
				c.cnsctvo_cdgo_estdo_prmtr,
				c.cnsctvo_cdgo_tpo_prmtr , c.dgto_vrfccn, b.dscrpcn_tpo_prmtr,
				a.dscrpcn_estdo_prmtr, c.cnsctvo_cdgo_prmtr,  '  +   Char(39) + 'NO SELECCIONADO' +  Char(39) + ' accn ' + char(13)
Set @IcInstruccion	 =	 @IcInstruccion + 'From tbpromotores_vigencias c , tbestadospromotor a, tbtipospromotor b,  bdafiliacion..tbtiposidentificacion d ' +char(13)
Set    @IcInstruccion1 = 'Where  ' 

		Set    @IcInstruccion2 = '  And a.cnsctvo_cdgo_estdo_prmtr 	=	 c.cnsctvo_cdgo_estdo_prmtr' + char(13)
   			       +   ' and   b.cnsctvo_cdgo_tpo_prmtr 		=	 c.cnsctvo_cdgo_tpo_prmtr' + char(13)
			      + '  and   c.cnsctvo_cdgo_tpo_idntfccn 	=	 d.cnsctvo_cdgo_tpo_idntfccn '  + char(13)
--			+  '  and   c.brrdo 	= ' + Char(39) + 	  'N' + Char(39) 




Update #tbCriteriosTmp
Set  cdgo_cmpo = 'usro_crcn'
Where tbla ='tbpromotores'
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
		If  CHARINDEX('tbpromotores',@tbla,1) != 0
		Begin
			-- si tabla es tbTiposNotas se asigna como alias b
			Select @lcAlias = 'c.'
		End
		Else
		Begin
			If  CHARINDEX('tbestadospromotor',@tbla,1) != 0
			Begin
				-- si tabla es tbSedes se asigna como alias c
				Select @lcAlias = 'a.'
			End
			Else  
			Begin
				If  CHARINDEX('bdafiliacion..tbTiposIdentificacion',@tbla,1) != 0
				Begin

					-- si tabla es tbCausasAnulacionNotas se asigna como alias e
					Select @lcAlias = 'd.'
				End
				Else
				Begin
					If  CHARINDEX('tbtipospromotor',@tbla,1) != 0 

					Begin
						-- si tabla es tbNotas se asigna como alias a
						Select @lcAlias = 'b.'
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
