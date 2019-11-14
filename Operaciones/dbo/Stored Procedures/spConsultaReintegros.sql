
/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spConsultaReintegros
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
* DATOS DE MODIFICACION
*--------------------------------------------------------------------------------- 
* Modificado Por			: <\AM Ing. Juan Manuel Victoria AM\>
* Descripcion			: <\DM DEvolver el numero de la nota tipo numerico DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM 2015-07-14 FM\>
*---------------------------------------------------------------------------------*/
CREATE    PROCEDURE	[dbo].[spConsultaReintegros]

@lConsecutivonota		varchar(15)		    =NULL,
@lcEstadoNota			varchar(200)		= Null,
@ldFechaReferencia		datetime			=null,
@lnTipoNota			    udtConsecutivo		=NULL



As	
Declare

@InstruccionSelect	Nvarchar(4000),
@InstruccionWhere	Nvarchar(4000),
@InstruccionFrom	Nvarchar(4000),
@Parametros			Nvarchar(1000),
@lcJoin				NVarchar(1000),
@lcCadena1			NVarchar(1000),
@lcOrder			NVarchar(1000),
@ldfechaSistema		datetime


Set Nocount On

Set	@ldfechaSistema	=	getdate()

Create table #tmpNotasDebito
(
nmro_nta numeric (20,0), dscrpcn_estdo_nta udtDescripcion, cdgo_tpo_idntfccn udtTipoIdentificacion, nmro_idntfccn udtNumeroIdentificacionLargo, dscrpcn_clse_aprtnte udtDescripcion,
nmbre_scrsl varchar(250), vlr_nta udtValorGrande, fcha_incl_prdo_lqdcn datetime, fcha_fnl_prdo_lqdcn datetime, usro_crcn udtUsuario, nmro_unco_idntfccn_empldr udtconsecutivo,
cnsctvo_scrsl udtconsecutivo, cnsctvo_cdgo_clse_aprtnte udtconsecutivo, vlr_iva udtValorGrande, sldo_nta udtValorGrande, dscrpcn_tpo_idntfccn udtDescripcion, rzn_scl varchar(200),
cnsctvo_cdgo_tpo_idntfccn udtconsecutivo, cnsctvo_cdgo_tpo_nta udtconsecutivo, cnsctvo_cdgo_estdo_nta udtconsecutivo, fcha_crcn_nta datetime, fcha_entrga_nta datetime, 
cnsctvo_cdgo_tpo_dcmnto_nta_rntgro varchar(50), cnsctvo_cdgo_pgo udtconsecutivo, cntro_csts varchar(10), cnsctvo_cdgo_sde udtconsecutivo, nmbre_sde varchar(200),
dscrpcn_cncpto_lqdcn udtDescripcion, fcha_pgo_acrddo datetime
)

insert into #tmpNotasDebito
SELECT      convert(numeric(20,0),a.nmro_nta) as nmro_nta,
		    e.dscrpcn_estdo_nta,
		    isnull(f.cdgo_tpo_idntfccn,g.cdgo_tpo_idntfccn) cdgo_tpo_idntfccn,
		 	isnull(d.nmro_idntfccn,g.nmro_idntfccn) nmro_idntfccn,
 			isnull(i.dscrpcn_clse_aprtnte,'INDEPENDIENTE') dscrpcn_clse_aprtnte,
			isnull(b.nmbre_scrsl,(isnull(ltrim(rtrim(prmr_nmbre)),' ') + ' ' +isnull(ltrim(rtrim(sgndo_nmbre)),' ') + ' ' + isnull(ltrim(rtrim(prmr_aplldo)),' ') + ' ' + isnull(ltrim(rtrim(sgndo_aplldo)),' '))) nmbre_scrsl,
 			a.vlr_nta, 	
			h.fcha_incl_prdo_lqdcn,
    		h.fcha_fnl_prdo_lqdcn, 	
			a.usro_crcn,		
			a.nmro_unco_idntfccn_empldr,
		 	a.cnsctvo_scrsl,
	 		a.cnsctvo_cdgo_clse_aprtnte,
		 	a.vlr_iva, 
			a.sldo_nta,
			f.dscrpcn_tpo_idntfccn,
			null,
	 		isnull(d.cnsctvo_cdgo_tpo_idntfccn,1) cnsctvo_cdgo_tpo_idntfccn, 
			a.cnsctvo_cdgo_tpo_nta,
			a.cnsctvo_cdgo_estdo_nta,
			a.fcha_crcn_nta,
			a.fcha_entrga_nta,
			a.cnsctvo_cdgo_tpo_dcmnto_nta_rntgro,
			g.cnsctvo_cdgo_pgo,
			g.cntro_csts,
			g.cnsctvo_cdgo_sde,
			null,
			(select top 1 f.dscrpcn_cncpto_lqdcn nombre_concep
			from  tbNotasConceptos e,TbconceptosLiquidacion f
			where e.cnsctvo_cdgo_cncpto_lqdcn = f.cnsctvo_cdgo_cncpto_lqdcn
			and e.nmro_nta = a.nmro_nta
			AND e.cnsctvo_cdgo_tpo_nta = a.cnsctvo_cdgo_tpo_nta) AS dscrpcn_cncpto_lqdcn,
			g.fcha_pgo_acrddo
FROM        tbNotasPac a Left JOIN
			bdAfiliacion.dbo.tbSucursalesAportante b 	ON 	a.nmro_unco_idntfccn_empldr 	= b.nmro_unco_idntfccn_empldr AND a.cnsctvo_scrsl = b.cnsctvo_scrsl AND
															a.cnsctvo_cdgo_clse_aprtnte 	= b.cnsctvo_cdgo_clse_aprtnte Left JOIN
			bdAfiliacion.dbo.tbVinculados d 	      	ON 	a.nmro_unco_idntfccn_empldr 	= d.nmro_unco_idntfccn Left JOIN
--			bdAfiliacion.dbo.tbTiposIdentificacion f 	ON 	isnull(d.cnsctvo_cdgo_tpo_idntfccn,1) 	= f.cnsctvo_cdgo_tpo_idntfccn Left JOIN
			bdAfiliacion.dbo.tbTiposIdentificacion f 	ON 	d.cnsctvo_cdgo_tpo_idntfccn 	= f.cnsctvo_cdgo_tpo_idntfccn Left JOIN
			tbPeriodosliquidacion_Vigencias h 			ON 	a.cnsctvo_prdo 			= h.cnsctvo_cdgo_prdo_lqdcn Left JOIN
			bdAfiliacion.dbo.tbClasesAportantes i 		ON 	b.cnsctvo_cdgo_clse_aprtnte 	= i.cnsctvo_cdgo_clse_aprtnte Left JOIN
			tbEstadosNota e 							ON 	a.cnsctvo_cdgo_estdo_nta 	= e.cnsctvo_cdgo_estdo_nta  
			Left JOIN bdCarteraPac.dbo.TbDatosAportanteNotaReintegro g ON a.nmro_nta = g.nmro_nta
WHERE       a.cnsctvo_cdgo_tpo_nta			=	3	
And	        @ldfechaSistema	between	h.inco_vgnca	and	h.fn_vgnca


create table #NotasExcluir (nmro_nta_exclr numeric (20,0))

insert into #NotasExcluir
select nmro_nta from tbNotasPac where nmro_nta between 103 and 580 -- Proceso Viejo

Update 	#tmpNotasDebito
Set	 rzn_scl	 =  c.rzn_scl
From 	#tmpNotasDebito	 a	,bdafiliacion..tbempleadores b,	bdafiliacion..tbempresas c --,	tbclasesempleador d
Where	a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte 
And	a.nmro_unco_idntfccn_empldr		=	c.nmro_unco_idntfccn
--And	a.vldo				=	'S'


Update 	#tmpNotasDebito
Set	 rzn_scl	 =   nmbre_scrsl 
From   #tmpNotasDebito	 a
Where (a.rzn_scl = '' or a.rzn_scl is null)


Update 	#tmpNotasDebito
Set	  nmbre_sde = ltrim(rtrim(isnull(dscrpcn_sde,'')))
From bdAfiliacion..tbSedes
where tbSedes.cnsctvo_cdgo_sde = #tmpNotasDebito.cnsctvo_cdgo_sde

		

Select @InstruccionSelect	=  	'SELECT nmro_nta, dscrpcn_estdo_nta, cdgo_tpo_idntfccn, nmro_idntfccn, dscrpcn_clse_aprtnte, nmbre_scrsl,
								rzn_scl, vlr_nta, usro_crcn, fcha_incl_prdo_lqdcn, fcha_fnl_prdo_lqdcn, nmro_unco_idntfccn_empldr, 	
								cnsctvo_scrsl, cnsctvo_cdgo_clse_aprtnte, vlr_iva, sldo_nta, dscrpcn_tpo_idntfccn, cnsctvo_cdgo_tpo_idntfccn, 
								cnsctvo_cdgo_tpo_nta, cnsctvo_cdgo_estdo_nta, fcha_crcn_nta, fcha_entrga_nta, cnsctvo_cdgo_pgo, cntro_csts,
								nmbre_sde, dscrpcn_cncpto_lqdcn, fcha_pgo_acrddo, isnull(cnsctvo_cdgo_tpo_dcmnto_nta_rntgro,1) as dcmnto_nta_rntgro 
								From   #tmpNotasDebito a '



select @InstruccionWhere	=	'	Where    ' 


  
Select @lcJoin	 =	'      1	=	1	'


select @InstruccionFrom		=	' '

Select @lcCadena1	= ' '
select @lcOrder		= Space(1)+'order by  a.nmro_nta desc'  +  Space(1)

If @ldFechaReferencia Is Not Null
Begin
	Select @lcCadena1	= Char(39) + Convert(Varchar(10),@ldFechaReferencia,111) + Char(39) + Space(1) + '=' + Space(1) + 'Convert(Varchar(10),a.fcha_crcn,111)'  + Space(1) +  'And'
End
else
Begin
	select @InstruccionFrom		=	' left outer join  #NotasExcluir b on a.nmro_nta = b.nmro_nta_exclr '
	Select @lcCadena1 =   Space(1)+' b.nmro_nta_exclr is null '+  Space(1) +  'And'

End

If @lConsecutivonota Is Not Null
Begin
	Select @lcCadena1	= @lcCadena1 + Space(1)+ ' a.nmro_nta = ' + char(39)  +  ltrim(rtrim(@lConsecutivonota))  + char(39) +  Space(1) +  'And'
End


If @lcEstadoNota Is Not Null
 Begin  
 	Select @lcCadena1	= @lcCadena1 + Space(1)+ ' a.cnsctvo_cdgo_estdo_nta 	IN	(' + @lcEstadoNota +  ') ' + Space(1) +  'And'      
 End


--select substring(@Instruccion,1,250)
--select substring(@Instruccion,251,500)
--select @lcCadena1
--select @lcjoin

Select @InstruccionSelect = @InstruccionSelect + @InstruccionFrom + @InstruccionWhere + @lcCadena1 +  @lcJoin + @lcOrder

Exec  Sp_executesql     @InstruccionSelect

drop table #tmpNotasDebito