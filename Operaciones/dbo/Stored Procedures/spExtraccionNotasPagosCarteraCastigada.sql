




/*---------------------------------------------------------------------------------
* Metodo o PRG   : spExtraccionNotasPagosCarteraCastigada
* Desarrollado por  : <\A Ing. Diana Lorena Gomez Betancourt        A\>
* Descripcion   : <\D Este procedimiento para generar la extraccion de Notas creadas para Pagos de Cartera Castigada D\>
* Observaciones   : <\O               O\>
* Parametros   : <\P             P\>
* Variables   : <\V               V\>
* Fecha Creacion  : <\FC 2011/02/10           FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por   : <\AM  AM\>
* Descripcion   : <\DM  DM\>
* Nuevos Parametros  : <\PM  PM\>
* Nuevas Variables  : <\VM  VM\>
* Fecha Modificacion  : <\FM  FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[spExtraccionNotasPagosCarteraCastigada]

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
  tpo									char(15))



Set @fcha_crcn_ini			=NULL
Set @fcha_crcn_fn			=NULL
Set @cnsctvo_cdgo_sde		=NULL
--Set @cnsctvo_cdgo_tpo_nta	=NULL
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
/*
Select  @cnsctvo_cdgo_tpo_nta = vlr
From  #tbCriteriosTmp
Where  cmpo_rlcn = 'cnsctvo_cdgo_tpo_nta' 
*/

Select  @cnsctvo_cdgo_pln  = vlr
From  #tbCriteriosTmp
Where  cmpo_rlcn   = 'cnsctvo_cdgo_pln' 
            


-- No se tienen en cuenta las notas credito en estado SIN APLICAR porque no han afectado
-- ningun saldo


 Insert into #tmpNotasPac
 SELECT  a.nmro_nta,
    c.vlr , 
	c.vlr_iva , 
	(c.vlr + c.vlr_iva) total,
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
	'Contrato'
 FROM  tbnotasPac     a, 
     bdafiliacion..tbSedes    s ,
     bdAfiliacion..tbSucursalesAportante  b  ,
     tbnotasContrato     c,
     tbtiposNotas     d ,
     bdAfiliacion..tbcontratos  ct,
     tbEstadosxtiponota   en,
     bdplanbeneficios..tbplanes  p 
 Where  a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn_empldr   
 And a.cnsctvo_cdgo_clse_aprtnte = b.cnsctvo_cdgo_clse_aprtnte  
 And a.cnsctvo_scrsl  = b.cnsctvo_scrsl     
 And b.sde_crtra_pc   = s.cnsctvo_cdgo_sde  
 And a.nmro_nta   = c.nmro_nta  
 And a.cnsctvo_cdgo_tpo_nta = c.cnsctvo_cdgo_tpo_nta  
 And c.cnsctvo_cdgo_tpo_cntrto = ct.cnsctvo_cdgo_tpo_cntrto  
 And c.nmro_cntrto   = ct.nmro_cntrto 
 And a.cnsctvo_cdgo_tpo_nta = d.cnsctvo_cdgo_tpo_nta  
 And p.cnsctvo_cdgo_pln  = ct.cnsctvo_cdgo_pln  
 And a.cnsctvo_cdgo_tpo_nta = en.cnsctvo_cdgo_tpo_nta  
 And a.cnsctvo_cdgo_estdo_nta = en.cnsctvo_cdgo_estdo_nta 
 And en.cnsctvo_cdgo_estdo_nta != 6  
 And en.cnsctvo_cdgo_estdo_nta != 5  
 And (@fcha_crcn_ini is null or (@fcha_crcn_ini is not null and a.fcha_crcn_nta  between @fcha_crcn_ini and @fcha_crcn_fn))
 And (@cnsctvo_cdgo_sde is null or (@cnsctvo_cdgo_sde is not null and s.cnsctvo_cdgo_sde = @cnsctvo_cdgo_sde))
 And  a.cnsctvo_cdgo_tpo_nta = 1
 And (@cnsctvo_cdgo_pln is null or (@cnsctvo_cdgo_pln is not null and p.cnsctvo_cdgo_pln = @cnsctvo_cdgo_pln))
 And (@nmro_nta_ini is null or (@nmro_nta_ini is not null and convert(int,a.nmro_nta)  between convert(int,@nmro_nta_ini) and convert(int,@nmro_nta_fn)))
     

 -- Adiciona notas por sucursal
/*
 Insert into #tmpNotasPac
 Select
	a.nmro_nta,
    a.vlr_nta as vlr , 
	a.vlr_iva as vlr_iva , 
	(a.vlr_nta + a.vlr_iva) total,
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
	'Sucursal'
From tbnotasPac     a inner join bdconsulta..tbSucursalesAportante  b
On a.nmro_unco_idntfccn_empldr			= b.nmro_unco_idntfccn_empldr   
And a.cnsctvo_cdgo_clse_aprtnte			= b.cnsctvo_cdgo_clse_aprtnte  
And a.cnsctvo_scrsl						= b.cnsctvo_scrsl 
left outer join   tbnotasContrato c
on  a.nmro_nta							= c.nmro_nta  
And a.cnsctvo_cdgo_tpo_nta				= c.cnsctvo_cdgo_tpo_nta  
inner join bdafiliacion..tbSedes s
on b.sde_crtra_pc						= s.cnsctvo_cdgo_sde
Inner join tbtiposNotas d 
on a.cnsctvo_cdgo_tpo_nta				= d.cnsctvo_cdgo_tpo_nta 
Inner join tbEstadosxtiponota en
on  a.cnsctvo_cdgo_tpo_nta				= en.cnsctvo_cdgo_tpo_nta  
And a.cnsctvo_cdgo_estdo_nta			= en.cnsctvo_cdgo_estdo_nta 
Where c.nmro_nta is null
And en.cnsctvo_cdgo_estdo_nta			   != 6  
And en.cnsctvo_cdgo_estdo_nta			   != 5  
And (@fcha_crcn_ini is null or (@fcha_crcn_ini is not null and a.fcha_crcn_nta  between @fcha_crcn_ini and @fcha_crcn_fn))
And (@cnsctvo_cdgo_sde is null or (@cnsctvo_cdgo_sde is not null and s.cnsctvo_cdgo_sde = @cnsctvo_cdgo_sde))
And  a.cnsctvo_cdgo_tpo_nta = 1
And (@nmro_nta_ini is null or (@nmro_nta_ini is not null and convert(int,a.nmro_nta)  between convert(int,@nmro_nta_ini) and convert(int,@nmro_nta_fn)))
 */


 update #tmpNotasPac
 Set cnsctvo_nta_cncpto = b.cnsctvo_nta_cncpto
 From #tmpNotasPac a,  tbNotasContratoxConcepto b
 Where a.cnsctvo_nta_cntrto = b.cnsctvo_nta_cntrto

 update #tmpNotasPac
 Set cnsctvo_cdgo_cncpto_lqdcn = b.cnsctvo_cdgo_cncpto_lqdcn
 From #tmpNotasPac a,   tbNotasConceptos b
 Where a.Cnsctvo_nta_cncpto = b.Cnsctvo_nta_cncpto


delete from #tmpNotasPac where cnsctvo_cdgo_cncpto_lqdcn not in (231,232,233,234)


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
 From #tmpNotasPac a,   bdAfiliacion..tbvinculados b
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
 Set nmbre_ctznte  =   ltrim(rtrim(prmr_nmbre))  + ' ' + ltrim(rtrim(sgndo_nmbre)) + ' ' + ltrim(rtrim(prmr_aplldo)) + ' '+ ltrim(rtrim(sgndo_aplldo))
 From #tmpNotasPac a , bdAfiliacion..tbpersonas b
 Where   a.nmro_unco_idntfccn_afldo = b.nmro_unco_idntfccn




 select 
 nmro_nta,
 vlr,
 vlr_iva,
 total,
 fcha_crcn_nta,
 tiempresa,
 niempresa,
 nmbre_scrsl,
 nmro_cntrto,
 dscrpcn_pln,
 cnsctvo_cdgo_sde,
 dscrpcn_sde,
 ticotizante,
 nicotizante,
 nmbre_ctznte,
 dscrpcn_cncpto_lqdcn,
 cnsctvo_cdgo_tpo_nta,
 cnsctvo_cdgo_tpo_idntfccn_empresa,
 cnsctvo_cdgo_tpo_idntfccn_cotizante,
 nmro_unco_idntfccn_afldo,
 cnsctvo_cdgo_pln,
 dscrpcn_tpo_nta,
 cnsctvo_nta_cntrto,
 cnsctvo_nta_cncpto,
 cnsctvo_cdgo_cncpto_lqdcn,
 @Fecha_minima   Fecha_minima,
 @fecha_maxima   Fecha_maxima,
 nmro_unco_idntfccn_empldr,
 cnsctvo_scrsl,
 cnsctvo_cdgo_clse_aprtnte,
 usro_crcn,
 tpo
 From #tmpNotasPac 
 Order by  tpo, cnsctvo_cdgo_sde, cnsctvo_cdgo_pln, fcha_crcn_nta, cnsctvo_cdgo_tpo_nta, nmro_nta

 








