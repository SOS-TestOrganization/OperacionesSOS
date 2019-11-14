




/*---------------------------------------------------------------------------------
* Metodo o PRG		: spEjecutaConsNotasContablesXBeneficiario
* Desarrollado por  : <\A Ing. Francisco Javier Gonzalez R													A\>
* Descripcion		: <\D Este procedimiento para generar el reporte de notas contables x beneficairiso		D\>
* Observaciones		: <\O																					O\>
* Parametros		: <\P																					P\>
* Variables			: <\V																					V\>
* Fecha Creacion	: <\FC 2014/05/09																		FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por	: <\AM  AM\>
* Descripcion		: <\DM  DM\>
* Nuevos Parametros : <\PM  PM\>
* Nuevas Variables  : <\VM  VM\>
* Fecha Modificacion: <\FM  FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[spEjecutaConsNotasContablesXBeneficiario]

As

Set Nocount On

Declare
@tbla    varchar(128),
@cdgo_cmpo    varchar(128),
@oprdr     varchar(2),
@vlr     varchar(250),
@cmpo_rlcn    varchar(128),
@cmpo_rlcn_prmtro   varchar(128),
@cnsctvo   Numeric(4),
@IcInstruccion   Nvarchar(4000),
@IcInstruccion1   Nvarchar(4000),
@IcInstruccion2   Nvarchar(4000),
@lcAlias   char(2),
@lnContador   Int,
@ldFechaSistema  Datetime,
@Fecha_Corte   Datetime,
@Fecha_Caracter  varchar(15),
@Fecha_minima   datetime,
@Fecha_maxima  datetime,
@fcha_crcn_ini   Datetime,
@fcha_crcn_fn   Datetime,
@cnsctvo_cdgo_sde  int,
@cnsctvo_cdgo_tpo_nta int,
@cnsctvo_cdgo_pln  int,
@nmro_nta_ini   varchar(15),
@nmro_nta_fn   Varchar(15) 
 

Create table  #tmpNotasPac
( nmro_nta								varchar(15),
  vlr									udtValorGrande, 
  vlr_iva								udtValorGrande,
  total									udtValorGrande,
  nmro_unco_idntfccn_empldr				udtConsecutivo, 
  cnsctvo_scrsl							udtConsecutivo, 
  cnsctvo_cdgo_clse_aprtnte				udtConsecutivo,
  usro_crcn								udtUsuario, 
  fcha_crcn_nta							datetime,
  nmbre_scrsl							udtDescripcion,
  cnsctvo_cdgo_sde						udtConsecutivo,
  dscrpcn_sde							udtDescripcion,
  cnsctvo_cdgo_tpo_nta					udtConsecutivo,
  TIempresa								char(03),
  NIempresa								char(15),
  cnsctvo_cdgo_tpo_idntfccn_empresa		udtConsecutivo,
  TICotizante							char(03),
  NIcotizante							char(15),
  cnsctvo_cdgo_tpo_idntfccn_cotizante	udtConsecutivo,
  nmro_unco_idntfccn_afldo				udtConsecutivo,
  dscrpcn_pln							udtDescripcion,
  cnsctvo_cdgo_pln						udtConsecutivo,
  nmbre_ctznte							varchar(100),
  dscrpcn_tpo_nta						udtDescripcion,
  nmro_cntrto							udtNumeroFormulario,
  cnsctvo_nta_cntrto					udtConsecutivo,
  Cnsctvo_nta_cncpto					udtConsecutivo,
  cnsctvo_cdgo_cncpto_lqdcn				udtConsecutivo,
  dscrpcn_cncpto_lqdcn					varchar(200),
  tpo									char(15),
  drccn									Varchar(80),
  tlfno									Varchar(30),
  cnsctvo_cdgo_cdd_scrsl				Int,
  dscrpcn_cdd_scrsl						udtDescripcion,
  cnsctvo_cdgo_dprmnto_scrsl			Int,
  dscrpcn_dprmnto_scrsl					udtDescripcion,
  obsrvcns								Varchar(500),
  fcha_entrga_nta						Datetime,
  cnsctvo_cdgo_estdo_nta				Int,
  dscrpcn_estdo_nta						udtDescripcion,
  cnsctvo_cdgo_tpo_dcmnto_nta_rntgro	Int,
  dscrpcn_dcmnto_nta					udtDescripcion,

  cnsctvo_prdo							Int,
  nmro_unco_idntfccn_bnfcro				Int,
  dscrpcn_prdo_lqdcn					udtDescripcion,
  fcha_ncmnto_ctznte					Datetime,
  tpo_idntfccn_bnfcro					Char(3),
  nmro_idntfccn_bnfcro					Char(23),	
  nmbre_bnfcro							udtDescripcion,
  fcha_ncmnto_bnfcro					Datetime,

  cnsctvo_cdgo_cdd_rsdnca_bnfcro		Int,
  dscrpcn_cdd_rsdnca					udtDescripcion,
  cnsctvo_sde_inflnca_rsdnca			Int,
  dscrpcn_sde_inflnca_rsdnca			udtDescripcion,
  cnsctvo_cdgo_sde_atncn				Int,
  dscrpcn_sde_atncn						udtDescripcion,
  cnsctvo_cdgo_ips_bnfcro				Int,

  dscrpcn_sde_crtra_pc					udtDescripcion,
  cnsctvo_cdgo_tpo_idntfccn_bnfcro		Int,
  cnsctvo_cdgo_sde_ips_bnfcro			Int,
  dscrpcn_sde_ips_bnfcro				udtDescripcion
  
--		0								As cnsctvo_cdgo_sde_ips,
--		0								As cnsctvo_sde_aflcn,
--		Space(150)						As dscrpcn_sde_atncn,


  )



Set @fcha_crcn_ini			=NULL
Set @fcha_crcn_fn			=NULL
Set @cnsctvo_cdgo_sde		=NULL
Set @cnsctvo_cdgo_tpo_nta	=NULL
Set @cnsctvo_cdgo_pln		=NULL
Set @nmro_nta_ini			=NULL
Set @nmro_nta_fn			=NULL

Select @ldFechaSistema = Getdate()


Select  @fcha_crcn_ini   = vlr +' 00:00:00' 
From  #tbCriteriosTmp
Where  cmpo_rlcn   =  'fcha_crcn' 
And oprdr      =  '>='


Select @fcha_crcn_fn  = vlr +' 23:59:59' 
From  #tbCriteriosTmp
Where  cmpo_rlcn   =  'fcha_crcn' 
And oprdr       =  '<='

Select  @nmro_nta_ini   = vlr 
From  #tbCriteriosTmp
Where  cdgo_cmpo   =  'nmro_nta' 
And oprdr      =  '>='

Select @nmro_nta_fn  = vlr 
From  #tbCriteriosTmp
Where  cdgo_cmpo   =  'nmro_nta' 
And oprdr       =  '<='


Select  @cnsctvo_cdgo_sde = vlr
From  #tbCriteriosTmp
Where  cmpo_rlcn = 'cnsctvo_cdgo_sde' 

Select  @cnsctvo_cdgo_tpo_nta = vlr
From  #tbCriteriosTmp
Where  cmpo_rlcn = 'cnsctvo_cdgo_tpo_nta' 


Select  @cnsctvo_cdgo_pln  = vlr
From  #tbCriteriosTmp
Where  cmpo_rlcn   = 'cnsctvo_cdgo_pln' 
            


--Se cruzan los contratos asociados a las sucursales y se traer las sucursales finales para liquidar
--Select 'Tipo nota', @cnsctvo_cdgo_tpo_nta


if (@cnsctvo_cdgo_tpo_nta != 4 or @cnsctvo_cdgo_tpo_nta is null) -- 4 = NOTA CRÉDITO POR IMPUESTOS
 
begin 

	-- Contador de condiciones
	 Select @lnContador = 1
	     
	-- primero se hace para estados de cuenta
	 
	-- No se tienen en cuenta las notas credito en estado SIN APLICAR porque no han afectado
	-- ningun saldo


	 Insert into #tmpNotasPac
	 SELECT	a.nmro_nta,
--			c.vlr, 
--			c.vlr_iva, 
--			(c.vlr + c.vlr_iva) total,
			CASE When nbc.nmro_unco_idntfccn_bnfcro Is Null Then c.vlr Else nbc.vlr_nta_bnfcro End,
			CASE When nbc.nmro_unco_idntfccn_bnfcro Is Null Then c.vlr_iva Else nbc.vlr_iva End,
			CASE When nbc.nmro_unco_idntfccn_bnfcro Is Null Then (c.vlr + c.vlr_iva) Else (nbc.vlr_nta_bnfcro + nbc.vlr_iva) End total,
			a.nmro_unco_idntfccn_empldr, 
			a.cnsctvo_scrsl, 
			a.cnsctvo_cdgo_clse_aprtnte,
			a.usro_crcn, 
			a.fcha_crcn_nta,
			nmbre_scrsl,
			s.cnsctvo_cdgo_sde,
			s.dscrpcn_sde,
			a.cnsctvo_cdgo_tpo_nta,
			space(3) TIempresa,
			space(15) NIempresa,
			0 cnsctvo_cdgo_tpo_idntfccn_empresa,
			space(3) TICotizante,
			space(15) NIcotizante,
			0 cnsctvo_cdgo_tpo_idntfccn_cotizante,
			ct.nmro_unco_idntfccn_afldo,
			p.dscrpcn_pln,
			p.cnsctvo_cdgo_pln,
			space(100) nmbre_ctznte,
			ltrim(rtrim(d.dscrpcn_tpo_nta)) ,
			c.nmro_cntrto ,
			c.cnsctvo_nta_cntrto,  
			0 , 
			0 , 
			space(200) ,
			'Contrato',
			b.drccn,
			b.tlfno,
			b.cnsctvo_cdgo_cdd,
			'' as dscrpcn_cdd_scrsl,
			0 As cnsctvo_cdgo_dprmnto_scrsl,
			'' as dscrpcn_dprmnto_scrsl,
			a.obsrvcns,
			a.fcha_entrga_nta,
			a.cnsctvo_cdgo_estdo_nta,
			'' As dscrpcn_estdo_nta,
			a.cnsctvo_cdgo_tpo_dcmnto_nta_rntgro,
			'' as dscrpcn_dcmnto_nta,
			a.cnsctvo_prdo,
			nbc.nmro_unco_idntfccn_bnfcro,
			Null,
			Null,
			Null,
			Null,
			Null,
			Null,
			Null,
			Null,
			Null,
			Null,
			b.cnsctvo_cdgo_sde_atncn,
			Null,
			Null,
			Null,
			Null,
			Null,
			Null
		
	 FROM	dbo.tbnotasPac a, 
			bdafiliacion.dbo.tbSedes s,
			BDAfiliacion.dbo.tbSucursalesAportante b,
			dbo.tbnotasContrato c Left Outer Join dbo.tbNotasBeneficiariosContratos nbc
				On c.cnsctvo_nta_cntrto = nbc.cnsctvo_nta_cntrto,
			dbo.tbtiposNotas d,
			BDAfiliacion.dbo.tbcontratos ct,
			dbo.tbEstadosxtiponota en,
			bdplanbeneficios.dbo.tbplanes p
	 Where  a.nmro_unco_idntfccn_empldr		= b.nmro_unco_idntfccn_empldr   
	 And	a.cnsctvo_cdgo_clse_aprtnte		= b.cnsctvo_cdgo_clse_aprtnte  
	 And	a.cnsctvo_scrsl					= b.cnsctvo_scrsl     
	 And	b.sde_crtra_pc					= s.cnsctvo_cdgo_sde  
	 And	a.nmro_nta						= c.nmro_nta  
	 And	a.cnsctvo_cdgo_tpo_nta			= c.cnsctvo_cdgo_tpo_nta  
	 And	c.cnsctvo_cdgo_tpo_cntrto		= ct.cnsctvo_cdgo_tpo_cntrto  
	 And	c.nmro_cntrto					= ct.nmro_cntrto 
	 And	a.cnsctvo_cdgo_tpo_nta			= d.cnsctvo_cdgo_tpo_nta  
	 And	p.cnsctvo_cdgo_pln				= ct.cnsctvo_cdgo_pln  
	 And	a.cnsctvo_cdgo_tpo_nta			= en.cnsctvo_cdgo_tpo_nta  
	 And	a.cnsctvo_cdgo_estdo_nta		= en.cnsctvo_cdgo_estdo_nta 
	 And	en.cnsctvo_cdgo_estdo_nta		!= 6  
	 And	en.cnsctvo_cdgo_estdo_nta		!= 5  
	 And	(@fcha_crcn_ini is null or (@fcha_crcn_ini is not null and a.fcha_crcn_nta  between @fcha_crcn_ini and @fcha_crcn_fn))
	 And	(@cnsctvo_cdgo_sde is null or (@cnsctvo_cdgo_sde is not null and s.cnsctvo_cdgo_sde = @cnsctvo_cdgo_sde))
	 And	(@cnsctvo_cdgo_tpo_nta is null or ( @cnsctvo_cdgo_tpo_nta is not null and d.cnsctvo_cdgo_tpo_nta = @cnsctvo_cdgo_tpo_nta))
	 And	(@cnsctvo_cdgo_pln is null or (@cnsctvo_cdgo_pln is not null and p.cnsctvo_cdgo_pln = @cnsctvo_cdgo_pln))
	 And	(@nmro_nta_ini is null or (@nmro_nta_ini is not null and convert(int,a.nmro_nta)  between convert(int,@nmro_nta_ini) and convert(int,@nmro_nta_fn)))
	     

	 -- Adiciona notas por sucursal

	 Insert into #tmpNotasPac
	 Select
			a.nmro_nta,
--			a.vlr_nta as vlr , 
--			a.vlr_iva as vlr_iva , 
--			(a.vlr_nta + a.vlr_iva) total,
			CASE When nbc.nmro_unco_idntfccn_bnfcro Is Null Then a.vlr_nta Else nbc.vlr_nta_bnfcro End,
			CASE When nbc.nmro_unco_idntfccn_bnfcro Is Null Then a.vlr_iva Else nbc.vlr_iva End,
			CASE When nbc.nmro_unco_idntfccn_bnfcro Is Null Then (a.vlr_nta + a.vlr_iva) Else (nbc.vlr_nta_bnfcro + nbc.vlr_iva) End total,
			a.nmro_unco_idntfccn_empldr, 
			a.cnsctvo_scrsl, 
			a.cnsctvo_cdgo_clse_aprtnte,
			a.usro_crcn, 
			a.fcha_crcn_nta,
			nmbre_scrsl,
			s.cnsctvo_cdgo_sde,
			s.dscrpcn_sde,
			a.cnsctvo_cdgo_tpo_nta,
			space(3) TIempresa,
			space(15) NIempresa,
			0 cnsctvo_cdgo_tpo_idntfccn_empresa,
			space(3) TICotizante,
			space(15) NIcotizante,
			0 cnsctvo_cdgo_tpo_idntfccn_cotizante,
			0 as nmro_unco_idntfccn_afldo,
			'' as  dscrpcn_pln,
			0 as cnsctvo_cdgo_pln,
			space(100) nmbre_ctznte,
			ltrim(rtrim(d.dscrpcn_tpo_nta)) ,
			'' as nmro_cntrto ,
			0 as cnsctvo_nta_cntrto,  
			0 , 
			0 , 
			space(200),
			'Sucursal',
			b.drccn,
			b.tlfno,
			b.cnsctvo_cdgo_cdd,
			'' as dscrpcn_cdd_scrsl,
			0 As cnsctvo_cdgo_dprmnto_scrsl,
			'' as dscrpcn_dprmnto_scrsl,
			a.obsrvcns,
			a.fcha_entrga_nta,
			a.cnsctvo_cdgo_estdo_nta,
			'' As dscrpcn_estdo_nta,
			a.cnsctvo_cdgo_tpo_dcmnto_nta_rntgro,
			'' as dscrpcn_dcmnto_nta,
			a.cnsctvo_prdo,
			nbc.nmro_unco_idntfccn_bnfcro,
			Null,
			Null,
			Null,
			Null,
			Null,
			Null,
			Null,
			Null,
			Null,
			Null,
			b.cnsctvo_cdgo_sde_atncn,
			Null,
			Null,
			Null,
			Null,
			Null,
			Null
	From	tbnotasPac     a inner join BDAfiliacion..tbSucursalesAportante  b
				On a.nmro_unco_idntfccn_empldr			= b.nmro_unco_idntfccn_empldr   
				And a.cnsctvo_cdgo_clse_aprtnte			= b.cnsctvo_cdgo_clse_aprtnte  
				And a.cnsctvo_scrsl						= b.cnsctvo_scrsl 
			left outer join   tbnotasContrato c
				on  a.nmro_nta							= c.nmro_nta  
				And a.cnsctvo_cdgo_tpo_nta				= c.cnsctvo_cdgo_tpo_nta  
			Left Outer Join dbo.tbNotasBeneficiariosContratos nbc
				On c.cnsctvo_nta_cntrto = nbc.cnsctvo_nta_cntrto
			inner join bdafiliacion..tbSedes s
				on b.sde_crtra_pc						= s.cnsctvo_cdgo_sde
			Inner join tbtiposNotas d 
				on a.cnsctvo_cdgo_tpo_nta				= d.cnsctvo_cdgo_tpo_nta 
			Inner join tbEstadosxtiponota en
				on  a.cnsctvo_cdgo_tpo_nta				= en.cnsctvo_cdgo_tpo_nta  
				And a.cnsctvo_cdgo_estdo_nta			= en.cnsctvo_cdgo_estdo_nta 
	Where	c.nmro_nta is null
	And		en.cnsctvo_cdgo_estdo_nta			   != 6  
	And		en.cnsctvo_cdgo_estdo_nta			   != 5  
	And		(@fcha_crcn_ini is null or (@fcha_crcn_ini is not null and a.fcha_crcn_nta  between @fcha_crcn_ini and @fcha_crcn_fn))
	And		(@cnsctvo_cdgo_sde is null or (@cnsctvo_cdgo_sde is not null and s.cnsctvo_cdgo_sde = @cnsctvo_cdgo_sde))
	And		(@cnsctvo_cdgo_tpo_nta is null or ( @cnsctvo_cdgo_tpo_nta is not null and d.cnsctvo_cdgo_tpo_nta = @cnsctvo_cdgo_tpo_nta))
	--And (@cnsctvo_cdgo_pln is null or (@cnsctvo_cdgo_pln is not null and p.cnsctvo_cdgo_pln = @cnsctvo_cdgo_pln))
	And		(@nmro_nta_ini is null or (@nmro_nta_ini is not null and convert(int,a.nmro_nta)  between convert(int,@nmro_nta_ini) and convert(int,@nmro_nta_fn)))
	 
 
end

else 
 
  begin

	
  Insert into #tmpNotasPac 
  SELECT  
		a.nmro_nta,
--		e.vlr total,
--		0 as vlr_iva,
--		e.vlr  total,
		CASE When nbc.nmro_unco_idntfccn_bnfcro Is Null Then e.vlr Else nbc.vlr_nta_bnfcro End total,
		0 as vlr_iva,
		CASE When nbc.nmro_unco_idntfccn_bnfcro Is Null Then e.vlr Else nbc.vlr_nta_bnfcro End total,

		a.nmro_unco_idntfccn_empldr, 
		a.cnsctvo_scrsl, 
		a.cnsctvo_cdgo_clse_aprtnte,
		a.usro_crcn, 
		a.fcha_crcn_nta,
		nmbre_scrsl,
		s.cnsctvo_cdgo_sde,
		s.dscrpcn_sde,
		a.cnsctvo_cdgo_tpo_nta,
		space(3) TIempresa,
		space(15) NIempresa,
		0 cnsctvo_cdgo_tpo_idntfccn_empresa,
		space(3) TICotizante,
		space(15) NIcotizante,
		0 cnsctvo_cdgo_tpo_idntfccn_cotizante,
		ct.nmro_unco_idntfccn_afldo,
		p.dscrpcn_pln,
		p.cnsctvo_cdgo_pln,
		space(100) nmbre_ctznte,
		ltrim(rtrim(d.dscrpcn_tpo_nta)) ,
		c.nmro_cntrto ,
		c.cnsctvo_nta_cntrto,  
		e.Cnsctvo_nta_cncpto , 
		f.cnsctvo_cdgo_cncpto_lqdcn  , 
		space(200),
		'Contrato',
		b.drccn,
		b.tlfno,
		b.cnsctvo_cdgo_cdd,
		'' as dscrpcn_cdd_scrsl,
		0 As cnsctvo_cdgo_dprmnto_scrsl,
		'' as dscrpcn_dprmnto_scrsl,
		a.obsrvcns,
		a.fcha_entrga_nta,
		a.cnsctvo_cdgo_estdo_nta,
		'' As dscrpcn_estdo_nta,
		a.cnsctvo_cdgo_tpo_dcmnto_nta_rntgro,
		'' As dscrpcn_dcmnto_nta,
		a.cnsctvo_prdo,
		nbc.nmro_unco_idntfccn_bnfcro,
		Null,
		Null,
		Null,
		Null,
		Null,
		Null,
		Null,
		Null,
		Null,
		b.cnsctvo_cdgo_sde_atncn,
		Null,
		Null,
		Null,
		Null,
		Null,
		Null
 FROM	tbnotasPac							a , 
		bdafiliacion..tbSedes				s ,
		BDAfiliacion..tbSucursalesAportante	b ,
		tbnotasContrato c Left Outer Join dbo.tbNotasBeneficiariosContratos nbc
			On c.cnsctvo_nta_cntrto = nbc.cnsctvo_nta_cntrto,
		tbtiposNotas						d ,
		BDAfiliacion..tbcontratos				ct,
		tbEstadosxtiponota					en,
		bdplanbeneficios..tbplanes			p, 
		tbNotascontratoxconcepto			e,
		tbnotasconceptos					f
 Where	a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn_empldr   
 And	a.cnsctvo_cdgo_clse_aprtnte = b.cnsctvo_cdgo_clse_aprtnte  
 And	a.cnsctvo_scrsl  = b.cnsctvo_scrsl     
 And	b.sde_crtra_pc   = s.cnsctvo_cdgo_sde  
 And	a.nmro_nta   = c.nmro_nta  
 And	a.cnsctvo_cdgo_tpo_nta  = c.cnsctvo_cdgo_tpo_nta  
 And	c.cnsctvo_cdgo_tpo_cntrto = ct.cnsctvo_cdgo_tpo_cntrto  
 And	c.nmro_cntrto   = ct.nmro_cntrto 
 And	a.cnsctvo_cdgo_tpo_nta  = d.cnsctvo_cdgo_tpo_nta  
 And	p.cnsctvo_cdgo_pln  = ct.cnsctvo_cdgo_pln  
 And	a.cnsctvo_cdgo_tpo_nta  = en.cnsctvo_cdgo_tpo_nta  
 And	a.cnsctvo_cdgo_estdo_nta = en.cnsctvo_cdgo_estdo_nta
 And	c.cnsctvo_nta_cntrto   = e.cnsctvo_nta_cntrto
 And	e.cnsctvo_nta_cncpto  = f.cnsctvo_nta_cncpto
 And	en.cnsctvo_cdgo_estdo_nta != 6  
 And	en.cnsctvo_cdgo_estdo_nta != 5  
 And	(@fcha_crcn_ini is null or (@fcha_crcn_ini is not null and convert(varchar(10),a.fcha_crcn_nta,111)  between convert(varchar(10),@fcha_crcn_ini,111)  and convert(varchar(10),@fcha_crcn_fn,111) ))
 And	(@cnsctvo_cdgo_tpo_nta is null or ( @cnsctvo_cdgo_tpo_nta is not null and d.cnsctvo_cdgo_tpo_nta = @cnsctvo_cdgo_tpo_nta))

 -- Como las notas credito de impuesto siempre son a nivel de contrato no 
 -- buscamos notas por sucursal




end


 update #tmpNotasPac
 Set cnsctvo_nta_cncpto = b.cnsctvo_nta_cncpto
 From #tmpNotasPac a,  tbNotasContratoxConcepto b
 Where a.cnsctvo_nta_cntrto = b.cnsctvo_nta_cntrto


 update #tmpNotasPac
 Set cnsctvo_cdgo_cncpto_lqdcn = b.cnsctvo_cdgo_cncpto_lqdcn
 From #tmpNotasPac a,   tbNotasConceptos b
 Where a.Cnsctvo_nta_cncpto = b.Cnsctvo_nta_cncpto


 update  #tmpNotasPac
 Set dscrpcn_cncpto_lqdcn = b.dscrpcn_cncpto_lqdcn
 From #tmpNotasPac a,  tbconceptosliquidacion b
 Where a.cnsctvo_cdgo_cncpto_lqdcn = b.cnsctvo_cdgo_cncpto_lqdcn


 Select @Fecha_minima  =min(fcha_crcn_nta)
 From #tmpNotasPac

 Select @Fecha_maxima =max(fcha_crcn_nta)
 From #tmpNotasPac


 Update #tmpNotasPac
 Set NIempresa    = convert(varchar(11),b.nmro_idntfccn),
 cnsctvo_cdgo_tpo_idntfccn_empresa = b.cnsctvo_cdgo_tpo_idntfccn
 From #tmpNotasPac a,   bdAfiliacion..tbvinculados b
 Where  a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn


 Update #tmpNotasPac
 Set NIcotizante    = convert(varchar(11),b.nmro_idntfccn),
 cnsctvo_cdgo_tpo_idntfccn_cotizante = b.cnsctvo_cdgo_tpo_idntfccn
 From #tmpNotasPac a,   BDAfiliacion..tbvinculados b
 Where  a.nmro_unco_idntfccn_afldo = b.nmro_unco_idntfccn


 update  #tmpNotasPac
 Set TIempresa = b.cdgo_tpo_idntfccn
 From #tmpNotasPac a , bdafiliacion..tbtiposidentificacion b
 Where   a.cnsctvo_cdgo_tpo_idntfccn_empresa = b.cnsctvo_cdgo_tpo_idntfccn


 update  #tmpNotasPac
 Set TICotizante = b.cdgo_tpo_idntfccn
 From #tmpNotasPac a , bdafiliacion..tbtiposidentificacion b
 Where   a.cnsctvo_cdgo_tpo_idntfccn_cotizante = b.cnsctvo_cdgo_tpo_idntfccn


 Update  #tmpNotasPac
 Set nmbre_ctznte			=   ltrim(rtrim(prmr_nmbre))  + ' ' + ltrim(rtrim(sgndo_nmbre)) + ' ' + ltrim(rtrim(prmr_aplldo)) + ' '+ ltrim(rtrim(sgndo_aplldo)),
	 fcha_ncmnto_ctznte		= b.fcha_ncmnto
 From #tmpNotasPac a , BDAfiliacion..tbpersonas b
 Where   a.nmro_unco_idntfccn_afldo = b.nmro_unco_idntfccn


 Update	a
 Set	dscrpcn_cdd_scrsl			= b.dscrpcn_cdd,
		cnsctvo_cdgo_dprmnto_scrsl	= b.cnsctvo_cdgo_dprtmnto
 From #tmpNotasPac a , bdafiliacion..tbCiudades_Vigencias b
 Where   a.cnsctvo_cdgo_cdd_scrsl = b.cnsctvo_cdgo_cdd


 Update	a
 Set	dscrpcn_dprmnto_scrsl		= b.dscrpcn_dprtmnto
 From #tmpNotasPac a , bdafiliacion..tbDepartamentos b
 Where   a.cnsctvo_cdgo_dprmnto_scrsl = b.cnsctvo_cdgo_dprtmnto

 Update	a
 Set	dscrpcn_estdo_nta		= b.dscrpcn_estdo_nta
 From #tmpNotasPac a , [bdCarteraPac].[dbo].[tbEstadosNota_Vigencias] b
 Where   a.cnsctvo_cdgo_estdo_nta = b.cnsctvo_cdgo_estdo_nta

 Update	a
 Set	dscrpcn_dcmnto_nta		= b.dscrpcn_dcmnto_nta
 From #tmpNotasPac a , [bdCarteraPac].[dbo].[tbTipoDocumentoNotaReintegro_Vigencias] b
 Where   a.cnsctvo_cdgo_tpo_dcmnto_nta_rntgro = b.cnsctvo_cdgo_dcmnto_nta
 --And	 a.fcha_crcn_nta BetWeen b.inco_vgnca And b.fn_vgnca	



-- Actualiza el Periodo

Update	a
Set			dscrpcn_prdo_lqdcn		= b.dscrpcn_prdo_lqdcn
From	#tmpNotasPac a, bdcarteraPac.dbo.tbPeriodosliquidacion_Vigencias b 		
Where   a.cnsctvo_prdo = b.cnsctvo_cdgo_prdo_lqdcn


-- Actualiza Fecha Nacimiento Beneficiario

Update	a
Set		fcha_ncmnto_bnfcro				= b.fcha_ncmnto,
		nmbre_bnfcro					= ltrim(rtrim(prmr_nmbre))  + ' ' + ltrim(rtrim(sgndo_nmbre)) + ' ' + ltrim(rtrim(prmr_aplldo)) + ' '+ ltrim(rtrim(sgndo_aplldo)),
		cnsctvo_cdgo_cdd_rsdnca_bnfcro	= b.cnsctvo_cdgo_cdd_rsdnca
From	#tmpNotasPac a, bdAfiliacion.dbo.tbPersonas b
Where   a.nmro_unco_idntfccn_bnfcro = b.nmro_unco_idntfccn


-- Actualiza identificacion del beneficiario

 Update #tmpNotasPac
 Set	nmro_idntfccn_bnfcro				= convert(varchar(11),b.nmro_idntfccn),
		cnsctvo_cdgo_tpo_idntfccn_bnfcro	= b.cnsctvo_cdgo_tpo_idntfccn
 From	#tmpNotasPac a,   BDAfiliacion.dbo.tbvinculados b
 Where  a.nmro_unco_idntfccn_bnfcro = b.nmro_unco_idntfccn


 update  #tmpNotasPac
 Set tpo_idntfccn_bnfcro = b.cdgo_tpo_idntfccn
 From #tmpNotasPac a , bdafiliacion..tbtiposidentificacion b
 Where   a.cnsctvo_cdgo_tpo_idntfccn_bnfcro = b.cnsctvo_cdgo_tpo_idntfccn

------------------------------------------------------------------
-- Actualiza los datos de la ciudad de residencia del beneficiario
------------------------------------------------------------------

Update	a
Set		dscrpcn_cdd_rsdnca			= b.dscrpcn_cdd,
		cnsctvo_sde_inflnca_rsdnca	= b.cnsctvo_sde_inflnca
From	#tmpNotasPac a Left Outer Join bdafiliacion.dbo.tbciudades_vigencias b
			On	a.cnsctvo_cdgo_cdd_rsdnca_bnfcro	= b.cnsctvo_cdgo_cdd
			And	@ldFechaSistema						>= b.inco_vgnca
			And	@ldFechaSistema						<= b.fn_vgnca

-------------------------------------------------------------------------------------------------
-- Actualiza la descripcion de la sede de influencia par la ciudad de residencia del beneficiario
-------------------------------------------------------------------------------------------------

Update	a
Set		dscrpcn_sde_inflnca_rsdnca	= b.dscrpcn_sde
From	#tmpNotasPac a Left Outer Join bdafiliacion.dbo.tbsedes b
			On	a.cnsctvo_sde_inflnca_rsdnca	= b.cnsctvo_cdgo_sde


----------------------------------------------------------------
-- Actualiza la ips del beneficiario
----------------------------------------------------------------

-- Nui

Update	a
Set		cnsctvo_cdgo_ips_bnfcro		= b.cnsctvo_cdgo_ips
From	#tmpNotasPac a Left Outer Join bdafiliacion.dbo.tbAfiliados b
			On	a.nmro_unco_idntfccn_bnfcro	= b.nmro_unco_idntfccn_afldo

-- Consecutivo Sede de la Ips

Update	a
Set		cnsctvo_cdgo_sde_ips_bnfcro		= b.cnsctvo_cdgo_sde_ips
From	#tmpNotasPac a Left Outer Join BDSisalud.dbo.tbIpsPrimarias_Vigencias b
			On	a.cnsctvo_cdgo_ips_bnfcro	= b.cdgo_intrno
Where	b.cnsctvo_cdgo_sde_ips Is Not Null

-- Descripcion sede de la Ips

Update	a
Set		dscrpcn_sde_ips_bnfcro		= b.dscrpcn_sde
From	#tmpNotasPac a Left Outer Join bdafiliacion.dbo.tbsedes b
			On	a.cnsctvo_cdgo_sde_ips_bnfcro	= b.cnsctvo_cdgo_sde
Where	b.dscrpcn_sde Is Not Null


-- Actualizacion sede atencion

Update	a
Set		dscrpcn_sde_atncn			= b.dscrpcn_sde
From	#tmpNotasPac a Left Outer Join bdafiliacion.dbo.tbsedes b
			On	a.cnsctvo_cdgo_sde_atncn	= b.cnsctvo_cdgo_sde
Where	b.dscrpcn_sde Is Not Null



delete from #tmpNotasPac where cnsctvo_cdgo_cncpto_lqdcn in (231,232,233,234)



Select
nmro_nta,
dscrpcn_tpo_nta,
dscrpcn_estdo_nta,
dscrpcn_cncpto_lqdcn,
dscrpcn_dcmnto_nta,
vlr,
vlr_iva,
total,
fcha_crcn_nta,
dscrpcn_prdo_lqdcn,
nmbre_scrsl,
tiempresa,
niempresa,
nmro_cntrto,
dscrpcn_pln,
nmbre_ctznte,
ticotizante,
nicotizante,
DateDiff(Year, fcha_ncmnto_ctznte, fcha_crcn_nta) - 1 As edd_ctznte,
nmbre_bnfcro,
tpo_idntfccn_bnfcro,
nmro_idntfccn_bnfcro,
DateDiff(Year, fcha_ncmnto_bnfcro, fcha_crcn_nta) - 1 As edd_bnfcro,
usro_crcn,
dscrpcn_sde_inflnca_rsdnca,
dscrpcn_cdd_rsdnca,
dscrpcn_sde_atncn,
dscrpcn_sde_ips_bnfcro,

dscrpcn_sde As sde_crtra_pc,
@Fecha_minima   Fecha_minima,
@fecha_maxima   Fecha_maxima,

tpo,
fcha_entrga_nta,
Substring(obsrvcns,1,250) as obsrvcns,
drccn,
tlfno,
dscrpcn_cdd_scrsl,
dscrpcn_dprmnto_scrsl

cnsctvo_cdgo_tpo_nta,
cnsctvo_cdgo_tpo_idntfccn_empresa,
cnsctvo_cdgo_tpo_idntfccn_cotizante,
nmro_unco_idntfccn_afldo,
cnsctvo_cdgo_pln,
cnsctvo_nta_cntrto,
cnsctvo_nta_cncpto,
cnsctvo_cdgo_cncpto_lqdcn,
nmro_unco_idntfccn_empldr,
cnsctvo_scrsl,
cnsctvo_cdgo_clse_aprtnte,
nmro_unco_idntfccn_bnfcro,
cnsctvo_cdgo_sde As cnsctvo_cdgo_sde_crtra_pc
From #tmpNotasPac 
--Where	nmro_unco_idntfccn_bnfcro Is Not Null
Order by  tpo, cnsctvo_cdgo_sde, cnsctvo_cdgo_pln, fcha_crcn_nta, cnsctvo_cdgo_tpo_nta, nmro_nta




