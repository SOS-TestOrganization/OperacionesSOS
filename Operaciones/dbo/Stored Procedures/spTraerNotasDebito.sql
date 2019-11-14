/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spTraerNotasDebito
* Desarrollado por		: <\A Ing. Rolando Simbaqueva Lasso									A\>
* Descripcion			: <\D Retorna los datos de las debito 								 	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P Fecha a la cual se valida la vigencia									P\>
				  <\P consecutivo del promotor que se desea localizar							P\>				 
				  <\P cadena de busqueda por descripcion								P\>				 
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/10/01											FC\>
*
*---------------------------------------------------------------------------------
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*--------------------------------------------------------------------------------- 
* Modificado Por			: <\AM Ing. Juan Manuel Victoria AM\>
* Descripcion			: <\DM DEvolver el numero de la nota tipo numerico DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM 2015-07-21 FM\>
*---------------------------------------------------------------------------------*/
CREATE    PROCEDURE	[dbo].[spTraerNotasDebito]

@lConsecutivonota		varchar(15)		=NULL,
@lcEstadoNota			udtConsecutivo		= Null,
@ldFechaReferencia		datetime			=null,
@lnTipoNota			udtConsecutivo		=NULL



As	Declare

@Instruccion			Nvarchar(4000),
@Parametros			Nvarchar(1000),
@lcJoin				NVarchar(1000),
@lcCadena1			NVarchar(1000),
@lcOrder			NVarchar(1000),
@ldfechaSistema		datetime



Set Nocount On

Set	@ldfechaSistema	=	getdate()


SELECT       convert(numeric(20,0),a.nmro_nta) as nmro_nta,				 e.dscrpcn_estdo_nta,		 f.cdgo_tpo_idntfccn, 	d.nmro_idntfccn, 			i.dscrpcn_clse_aprtnte,
	        b.nmbre_scrsl, 			a.vlr_nta, 	
	         h.fcha_incl_prdo_lqdcn,		 h.fcha_fnl_prdo_lqdcn, 	
	         a.usro_crcn,		
                      a.nmro_unco_idntfccn_empldr, 	a.cnsctvo_scrsl, 		a.cnsctvo_cdgo_clse_aprtnte, 	a.vlr_iva, 
	         a.sldo_nta, 					f.dscrpcn_tpo_idntfccn, 
                     
	         SPACE(200) AS rzn_scl, 		d.cnsctvo_cdgo_tpo_idntfccn, 
	         a.cnsctvo_cdgo_tpo_nta,
	         a.cnsctvo_cdgo_estdo_nta
into #tmpNotasDebito
FROM         tbNotasPac a INNER JOIN
                      bdAfiliacion.dbo.tbSucursalesAportante b 	ON 	a.nmro_unco_idntfccn_empldr 	= b.nmro_unco_idntfccn_empldr AND a.cnsctvo_scrsl = b.cnsctvo_scrsl AND
                   						    	a.cnsctvo_cdgo_clse_aprtnte 	= b.cnsctvo_cdgo_clse_aprtnte INNER JOIN
                      bdAfiliacion.dbo.tbVinculados d 	      	ON 	a.nmro_unco_idntfccn_empldr 	= d.nmro_unco_idntfccn INNER JOIN
                      bdAfiliacion.dbo.tbTiposIdentificacion f 	ON 	d.cnsctvo_cdgo_tpo_idntfccn 	= f.cnsctvo_cdgo_tpo_idntfccn INNER JOIN
                      tbPeriodosliquidacion_Vigencias h 		ON 	a.cnsctvo_prdo 			= h.cnsctvo_cdgo_prdo_lqdcn INNER JOIN
                      bdAfiliacion.dbo.tbClasesAportantes i 	ON 	b.cnsctvo_cdgo_clse_aprtnte 	= i.cnsctvo_cdgo_clse_aprtnte INNER JOIN
                      tbEstadosNota e 				ON 	a.cnsctvo_cdgo_estdo_nta 	= e.cnsctvo_cdgo_estdo_nta  
WHERE       (a.cnsctvo_cdgo_estdo_nta 		=	@lcEstadoNota	)
And	        a.cnsctvo_cdgo_tpo_nta			=	@lnTipoNota	
And	        @ldfechaSistema	between	h.inco_vgnca	and	h.fn_vgnca





Update 	#tmpNotasDebito
Set	 rzn_scl	 =  c.rzn_scl
From 	#tmpNotasDebito	 a	,bdafiliacion..tbempleadores b,	bdafiliacion..tbempresas c --,	tbclasesempleador d
Where	a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte 
And	a.nmro_unco_idntfccn_empldr		=	c.nmro_unco_idntfccn
--And	a.vldo				=	'S'


Update 	#tmpNotasDebito
Set	 rzn_scl	 =   ltrim(rtrim(isnull(prmr_aplldo,'')))  + ' ' + ltrim(rtrim(isnull(sgndo_aplldo,''))) + ' ' + ltrim(rtrim(isnull(prmr_nmbre,''))) + ' ' + ltrim(rtrim(isnull(sgndo_nmbre,'')))
From 	#tmpNotasDebito	 a	, bdafiliacion..tbempleadores b,	bdafiliacion..tbpersonas c
Where	a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte 
And	a.nmro_unco_idntfccn_empldr		=	c.nmro_unco_idntfccn
And	rzn_scl=''




	





Select @Instruccion	=  	'SELECT       nmro_nta,				 dscrpcn_estdo_nta,		 cdgo_tpo_idntfccn, 	nmro_idntfccn, 			dscrpcn_clse_aprtnte,
					        nmbre_scrsl, 			rzn_scl,		vlr_nta, 	
					        fcha_incl_prdo_lqdcn,		 fcha_fnl_prdo_lqdcn, 	
					        usro_crcn,		
				                     nmro_unco_idntfccn_empldr, 	cnsctvo_scrsl, 			cnsctvo_cdgo_clse_aprtnte, 	vlr_iva, 
					        sldo_nta, 				dscrpcn_tpo_idntfccn, 
    				 	        cnsctvo_cdgo_tpo_idntfccn, 
					        cnsctvo_cdgo_tpo_nta,
					        cnsctvo_cdgo_estdo_nta  '
					+   'From   #tmpNotasDebito a
					Where    ' 

  


Select @lcJoin	 =	'      1	=	1	'


Select @lcCadena1	= ''
select @lcOrder		= Space(1)+'order by  a.nmro_nta desc'  +  Space(1)


If @ldFechaReferencia Is Not Null
Begin
	Select @lcCadena1	= Char(39) + Convert(Varchar(10),@ldFechaReferencia,111) + Char(39) + Space(1) + '=' + Space(1) + 'Convert(Varchar(10),a.fcha_crcn,111)'  + Space(1) +  'And'
End

If @lConsecutivonota Is Not Null
Begin
	Select @lcCadena1	= @lcCadena1 + Space(1)+ ' a.nmro_nta = ' + char(39)  +  ltrim(rtrim(@lConsecutivonota))  + char(39) +  Space(1) +  'And'
End


If @lcEstadoNota Is Not Null 
Begin  
	Select @lcCadena1	= @lcCadena1 + Space(1)+ ' a.cnsctvo_cdgo_estdo_nta = '+ Convert(Varchar(10),@lcEstadoNota)	+ Space(1) +  'And'
End



--select substring(@Instruccion,1,250)
--select substring(@Instruccion,251,500)
--select @lcCadena1
--select @lcjoin

Select @Instruccion = @Instruccion + @lcCadena1 +  @lcJoin+ @lcOrder

Exec  Sp_executesql     @Instruccion