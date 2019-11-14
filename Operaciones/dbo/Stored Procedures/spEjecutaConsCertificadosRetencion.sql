

/*--------------------------------------------------------------------------------- 
* Metodo o PRG 		: spEjecutaConsCertificadosRetencion 
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
* Modificado Por		: <\AM  Ing. Fernando Valencia E  AM\> 
* Descripcion			: <\DM  DM\> 
* Nuevos Parametros		: <\PM  PM\> 
* Nuevas Variables		: <\VM  VM\> 
* Fecha Modificacion		: <\FM  FM\> 

Quick 2013-001-008412 Sisdgb01 04/04/2013 Se ajusta agregando la validacion de que el estado de los EC sea diferente de 4 ANULADO
*--------------------------------------------------------------------------------- 
* DATOS DE MODIFICACION 
*--------------------------------------------------------------------------------- 
* Modificado Por		: <\AM  Ing. Juan Manuel Victoria  AM\> 
* Descripcion			: <\DM se adiciona nui de afiliado DM\> 
* Nuevos Parametros		: <\PM  PM\> 
* Nuevas Variables		: <\VM  VM\> 
* Fecha Modificacion		: <\FM 2018-08-24 FM\> 

*---------------------------------------------------------------------------------*/ 
CREATE PROCEDURE [dbo].[spEjecutaConsCertificadosRetencion]
 
As 


Declare 
@tbla			varchar(128), 
@cdgo_cmpo 		varchar(128), 
@oprdr 			varchar(2), 
@vlr 			varchar(250), 
@cmpo_rlcn 		varchar(128), 
@cmpo_rlcn_prmtro 	varchar(128), 
@cnsctvo		Numeric(4), 
@IcInstruccion		Nvarchar(4000), 
@IcInstruccion1		Nvarchar(4000), 
@IcInstruccion2		Nvarchar(4000), 
@lcAlias		char(2), 
@lnContador		Int, 
@nmro_rdcn_incl		Int, 
@nmro_rdcn_fnl		Int, 
@ldFechaSistema		Datetime, 
@Fecha_ini		datetime, 
@Fecha_fin		datetime, 
@Fcha_Crtro_incl	Datetime, 
@Fcha_Crtro_fnl		Datetime, 
@cdgo_tpo_idntfccn	Char(15), 
@nmro_idntfccn		Char(20)	 ,
@lcNuiCotizante				char(1),
@nmro_unco_idntfccn_ctznte	udtConsecutivo,
@lnNumeroCotizante			udtNumeroIdentificacion,
@nuiResponsablePago int,
@lcTipoCotizante				Varchar(3)
Set Nocount On 
 
Select	@ldFechaSistema	=	Getdate() 
 

--select * from #tbCriteriosTmp 

 
Select 	@Fcha_Crtro_incl  	=	vlr+' 00:00:00'  
From 	 #tbCriteriosTmp 
Where 	cmpo_rlcn 		= 	'fcha_crcn'  
And	oprdr	           	= 	'>=' 
 
 
Select  @Fcha_Crtro_fnl 	=	vlr+' 23:59:59'  
From 	#tbCriteriosTmp 
Where 	cmpo_rlcn 		= 	'fcha_crcn'  
And	oprdr	    		= 	'<=' 
 
 set @lcNuiCotizante = 'S'

-- Obtiene los criterios proporcionados por el usuario.
If Exists (Select	*
	From	#tbCriteriosTmp 
	Where 	cmpo_rlcn_prmtro 	= 	'nmro_unco_idntfccn_ctznte')
Begin
	Select  	@lcTipoCotizante 	=  Vlr
	From 	#tbCriteriosTmp
	Where 	cmpo_rlcn_prmtro 	= 	'nmro_unco_idntfccn_ctznte'
	And 	isnumeric(vlr) 	= 	0 -- indica que no es un numero

	Select  	@lnNumeroCotizante 	=  Vlr
	From 	#tbCriteriosTmp
	Where 	cmpo_rlcn_prmtro 	= 	'nmro_unco_idntfccn_ctznte'
	And 	isnumeric(vlr) 	= 	1 -- indica que es un numero
	
	delete from #tbCriteriosTmp where cmpo_rlcn_prmtro = 	'nmro_unco_idntfccn_ctznte'
	
End
Else
Begin
--	Select	@nmro_unco_idntfccn_empldr 	=	Null
Set @lcNuiCotizante = 'N'
End
  
Select 	@cdgo_tpo_idntfccn	 =	vlr 
From 	#tbCriteriosTmp 
Where 	cmpo_rlcn 		 = 'cdgo_tpo_idntfccn'  
 
Select 	@nmro_idntfccn		 =	vlr 
From 	#tbCriteriosTmp 
Where 	cmpo_rlcn 		 = 'nmro_idntfccn'  
 
 
Select 	@nmro_rdcn_incl		 =	vlr 
From 	#tbCriteriosTmp 
Where 	cmpo_rlcn 		 = 'nmro_rdcn'  
and 	oprdr			 = '>=' 
 
Select 	@nmro_rdcn_fnl		 =	vlr 
From 	#tbCriteriosTmp 
Where 	cmpo_rlcn 		 = 'nmro_rdcn'  
and 	oprdr			 =	'<=' 
 
-- Contador de condiciones 
Select @lnContador = 1 
 
Set  @nuiResponsablePago = (Select	v.nmro_unco_idntfccn
							from	bdafiliacion.dbo.tbVinculados v with(nolock)
							Inner Join bdafiliacion.dbo.tbTiposIdentificacion ti with(nolock) On v.cnsctvo_cdgo_tpo_idntfccn = ti.cnsctvo_cdgo_tpo_idntfccn
							Where	ltrim(rtrim(v.nmro_idntfccn))	= ltrim(rtrim(@nmro_idntfccn)) 
							And		ti.cdgo_tpo_idntfccn			= ltrim(rtrim(@cdgo_tpo_idntfccn)) 	
							And		v.vldo							= 'S')

 
-- se crea la tabla temporal con la infromacion de las sucursales que s epuedan liquidar 
				 
select  a.fcha_incl_prdo_lqdcn 	fcha_crcn,	b.cnsctvo_cdgo_prdo_lqdcn, 
		cnsctvo_cdgo_lqdcn,					a.fcha_fnl_prdo_lqdcn 
into 	#tmpLiquidacionesFinalizadas 
from 	dbo.tbperiodosliquidacion_vigencias a with(nolock)
inner join dbo.tbliquidaciones b with(nolock) on a.cnsctvo_cdgo_prdo_lqdcn	=	b.cnsctvo_cdgo_prdo_lqdcn 
where b.cnsctvo_cdgo_estdo_lqdcn	=	3  And		a.fcha_incl_prdo_lqdcn between @Fcha_Crtro_incl and @Fcha_Crtro_fnl			 
      
      
				 
-- Primero se hace para estados de cuenta 

CREATE TABLE #tmpCertificadosAux	(
	[nmro_unco_idntfccn_empldr] [int] NOT NULL,
	[cnsctvo_scrsl] [int] NOT NULL,
	[cnsctvo_cdgo_clse_aprtnte] [int] NOT NULL,
	[cnsctvo_cdgo_tpo_cntrto] [int] NOT NULL,
	[nmro_cntrto] [char](15) NOT NULL,
	[vlr_abno_cta] [numeric](19, 6) NULL,
	[vlr_abno_iva] [numeric](20, 6) NULL,
	[cnsctvo_cdgo_pln] [int] NOT NULL,
	[nmro_unco_idntfccn_afldo] [int] NOT NULL,
	[nmro_unco_idntfccn_bnfcro] [int] NOT NULL,
	[fcha_crcn] [datetime] NOT NULL,
	[pgo] [varchar](1) NOT NULL,
	[tpo_dcmnto] [varchar](2) NOT NULL,
	[cnsctvo_nta_bnfcro_cntrto] [int] NOT NULL
)
 
--Insterta registtos de los pagos realizados a estados de cuenta 

Insert	Into	 #tmpCertificadosAux 
SELECT    DISTINCT 
		  nmro_unco_idntfccn_empldr, 
		  cnsctvo_scrsl, 
 		  cnsctvo_cdgo_clse_aprtnte, 
		  cnsctvo_cdgo_tpo_cntrto ,
		  nmro_cntrto, 
		  round((f.Vlr/1.1),0), 
		  round((f.Vlr-f.Vlr/1.1),0), 
		  0	As cnsctvo_cdgo_pln, 
  		  0	As nmro_unco_idntfccn_afldo, 
		  f.nmro_unco_idntfccn_bnfcro, 
		  b.fcha_crcn, 
		  ' ' As pgo,  
		  'PD' As tpo_dcmnto, --P Pago 	 
		  0 cnsctvo_nta_bnfcro_cntrto
FROM	#tmpLiquidacionesFinalizadas b 
Inner Join dbo.tbEstadosCuenta c with(nolock) On 	  b.cnsctvo_cdgo_lqdcn	  	= 	c.cnsctvo_cdgo_lqdcn		
Inner Join dbo.Tbestadoscuentacontratos   		d  with(nolock) On 	 c.cnsctvo_estdo_cnta		=	d.cnsctvo_estdo_cnta 
Inner Join dbo.tbCuentasContratosBeneficiarios	f with(nolock) On d.cnsctvo_estdo_cnta_cntrto	=	f.cnsctvo_estdo_cnta_cntrto
left outer join dbo.Tbabonoscontrato  			e with(nolock) On d.cnsctvo_estdo_cnta_cntrto	=	e.cnsctvo_estdo_cnta_cntrto  
Where	c.nmro_unco_idntfccn_empldr			=  @nuiResponsablePago
and		c.cnsctvo_cdgo_estdo_estdo_cnta		!= 4
 
 
--Inserta registros de las Notas Debito

Insert	Into	 #tmpCertificadosAux 
SELECT	DISTINCT 
		nmro_unco_idntfccn_empldr, 
		cnsctvo_scrsl, 
		cnsctvo_cdgo_clse_aprtnte, 
		cnsctvo_cdgo_tpo_cntrto , 
		nmro_cntrto, 
		--round((d.vlr),0) , round((d.vlr_iva),0), 
		Case when f.nmro_unco_idntfccn_bnfcro Is Null then round((d.vlr)*(1),0) Else round((f.vlr_nta_bnfcro)*(1),0) End, 
		Case when f.nmro_unco_idntfccn_bnfcro Is Null then round((d.vlr_iva)*(1),0) Else round((f.vlr_iva)*(1),0) End, 
		0 As cnsctvo_cdgo_pln, 
		0 As nmro_unco_idntfccn_afldo, 
		Case When f.nmro_unco_idntfccn_bnfcro Is Null Then 0 Else f.nmro_unco_idntfccn_bnfcro End As nmro_unco_idntfccn_bnfcro, 
		h.fcha_incl_prdo_lqdcn, --c.fcha_crcn_nta,
		' ' As pgo, 
		'ND' As tpo_dcmnto, --Nota Debito 	 
		0 As cnsctvo_nta_bnfcro_cntrto
FROM	dbo.TbnotasPac c with(nolock)
Inner Join dbo.Tbnotascontrato d with(nolock) On c.nmro_nta = d.nmro_nta And c.cnsctvo_cdgo_tpo_nta	= d.cnsctvo_cdgo_tpo_nta
Left Outer Join dbo.tbNotasBeneficiariosContratos f with(nolock) On d.cnsctvo_nta_cntrto				=	f.cnsctvo_nta_cntrto
Inner Join dbo.TbAbonosNotasContrato  e with(nolock) On  d.cnsctvo_nta_cntrto				=	e.cnsctvo_nta_cntrto
Inner Join dbo.tbPeriodosliquidacion_Vigencias h with(nolock) On 	c.cnsctvo_prdo 			= h.cnsctvo_cdgo_prdo_lqdcn 
Where 	c.nmro_unco_idntfccn_empldr		= @nuiResponsablePago	    
And		Convert(varchar(10), h.fcha_incl_prdo_lqdcn,111) between Convert(varchar(10),@Fcha_Crtro_incl,111) And Convert(varchar(10),@Fcha_Crtro_Fnl,111) 
And 	d.cnsctvo_cdgo_tpo_nta			= 1 --Notas debito  			 
 
 --c.fcha_crcn_nta Se cabia por h.fcha_incl_prdo_lqdcn


-- Inserta registros de las Notas Credito

Insert	Into	 #tmpCertificadosAux 
SELECT	DISTINCT 
		nmro_unco_idntfccn_empldr, 
		cnsctvo_scrsl, 
		cnsctvo_cdgo_clse_aprtnte, 
		cnsctvo_cdgo_tpo_cntrto,
		nmro_cntrto, 
		
		--round((d.vlr)*(-1),0) , round((d.vlr_iva)*(-1),0), 
		Case when f.nmro_unco_idntfccn_bnfcro Is Null then round((d.vlr)*(-1),0) Else round((f.vlr_nta_bnfcro)*(-1),0) End, 
		Case when f.nmro_unco_idntfccn_bnfcro Is Null then round((d.vlr_iva)*(-1),0) Else round((f.vlr_iva)*(-1),0) End, 

		0 As cnsctvo_cdgo_pln, 
		0 As nmro_unco_idntfccn_afldo, 
		Case when f.nmro_unco_idntfccn_bnfcro Is Null Then 0  Else f.nmro_unco_idntfccn_bnfcro End As nmro_unco_idntfccn_bnfcro, 
		h.fcha_incl_prdo_lqdcn, --c.fcha_crcn_nta,
		' ' As pgo, 
		'NC' As tpo_dcmnto, --Nota Credito
		0 cnsctvo_nta_bnfcro_cntrto 
FROM	dbo.TbnotasPac c with(nolock) 
Inner Join dbo.Tbnotascontrato d with(nolock) On	c.nmro_nta				= d.nmro_nta And c.cnsctvo_cdgo_tpo_nta	= d.cnsctvo_cdgo_tpo_nta
Left Outer Join dbo.tbNotasBeneficiariosContratos f with(nolock) On d.cnsctvo_nta_cntrto		=	f.cnsctvo_nta_cntrto
Inner Join dbo.tbPeriodosliquidacion_Vigencias h with(nolock) On 	c.cnsctvo_prdo 			= h.cnsctvo_cdgo_prdo_lqdcn 
Where	c.nmro_unco_idntfccn_empldr		=	 @nuiResponsablePago	       
And		Convert(varchar(10), h.fcha_incl_prdo_lqdcn,111) between Convert(varchar(10),@Fcha_Crtro_incl,111) And Convert(varchar(10),@Fcha_Crtro_Fnl,111) 
And		c.cnsctvo_cdgo_tpo_nta			= 2 --Notas Credito	 
and		c.cnsctvo_cdgo_estdo_nta 		= 4 --Aplicadas  		 



--Inserta registros de las Notas de Reitegro

Insert	Into	 #tmpCertificadosAux 
SELECT    DISTINCT 
 	  c.nmro_unco_idntfccn_empldr, 
	  c.cnsctvo_scrsl, 
 	  c.cnsctvo_cdgo_clse_aprtnte, 
	  d.cnsctvo_cdgo_tpo_cntrto, 
	  d.nmro_cntrto, 
	  Case when e.nmro_unco_idntfccn_bnfcro Is Null then round((d.vlr)*(-1),0) Else round((e.vlr_nta_bnfcro)*(-1),0) End, 
	  Case when e.nmro_unco_idntfccn_bnfcro Is Null then round((d.vlr_iva)*(-1),0) Else round((e.vlr_iva)*(-1),0) End, 
	  0	As cnsctvo_cdgo_pln, 
  	  0	As nmro_unco_idntfccn_afldo, 
	  IsNull(e.nmro_unco_idntfccn_bnfcro,0) As nmro_unco_idntfccn_bnfcro, 
 	  j.fcha_incl_prdo_lqdcn, --c.fcha_crcn_nta,
      ' ' As pgo, 
	  'NR' As  tpo_dcmnto, --NOTA REINTEGRO 
	  e.cnsctvo_nta_bnfcro_cntrto
FROM	dbo.TbnotasPac c with(nolock)
Inner Join dbo.Tbnotascontrato d with(nolock) on	c.nmro_nta = d.nmro_nta  and c.cnsctvo_cdgo_tpo_nta	 = d.cnsctvo_cdgo_tpo_nta
Inner Join dbo.tbNotasBeneficiariosContratos e with(nolock) On	e.cnsctvo_nta_cntrto			= d.cnsctvo_nta_cntrto
Inner Join dbo.tbEstadosCuentaContratos ecc with(nolock) ON 	ecc.cnsctvo_estdo_cnta_cntrto 	= e.cnsctvo_dcmnto
Inner Join	dbo.tbestadosCuenta ec with(nolock) ON	ec.cnsctvo_estdo_cnta			= ecc.cnsctvo_estdo_cnta
Inner Join dbo.tbliquidaciones l with(nolock) ON	l.cnsctvo_cdgo_lqdcn			= ec.cnsctvo_cdgo_lqdcn
Inner Join dbo.tbperiodosliquidacion_Vigencias j with(nolock) ON	l.cnsctvo_cdgo_prdo_lqdcn	=	j.cnsctvo_cdgo_prdo_lqdcn
Where		c.nmro_unco_idntfccn_empldr		=	 @nuiResponsablePago	       
And			Convert(varchar(10),j.fcha_incl_prdo_lqdcn,111) between Convert(varchar(10),@Fcha_Crtro_incl,111) And Convert(varchar(10),@Fcha_Crtro_Fnl,111) 
And 		c.cnsctvo_cdgo_tpo_nta			= 3 --NOTA REINTEGRO
and 		c.cnsctvo_cdgo_estdo_nta 		In (4, 8) -- APLICADA, AUTORIZADO	

	
update	a 
Set		pgo='S' 
From	#tmpCertificadosAux a
Where	vlr_abno_cta > 0 
						 
		   			 
Update	#tbCriteriostmp 
Set		tbla			=	' #tmpLiquidacionesFinalizadas' 
Where	cdgo_cmpo		=	'fcha_crcn' 
 
				   			 
---Se actualiza el codigo del plan  
 
update  a 
	Set	cnsctvo_cdgo_pln			=	b.cnsctvo_cdgo_pln, 
		nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn_afldo 
From	#tmpCertificadosAux a
inner join bdafiliacion.dbo.tbcontratos b with(nolock)  on a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto And a.nmro_cntrto =	b.nmro_cntrto 
 
 
 
 
---Se agrupan por contrato y plan 
Select	nmro_unco_idntfccn_afldo, 
		cnsctvo_cdgo_tpo_cntrto, 
		nmro_cntrto, 
		cnsctvo_cdgo_pln 
into		#tmpContratosPac 
From	#tmpCertificadosAux 
group by nmro_unco_idntfccn_afldo, 
		 cnsctvo_cdgo_tpo_cntrto, 
		 nmro_cntrto, 
		 cnsctvo_cdgo_pln 

 
---Se crea una tabla de beneficiarios 

select  a.nmro_unco_idntfccn_afldo,			b.nmro_unco_idntfccn_bnfcro,				b.cnsctvo_cdgo_prntsco,  
		a.cnsctvo_cdgo_pln,					a.cnsctvo_cdgo_tpo_cntrto,					a.nmro_cntrto 
into    #tmpBeneficiarios 
from	#tmpContratosPac a
inner join bdafiliacion.dbo.tbbeneficiarios b  with(nolock) on a.cnsctvo_cdgo_tpo_cntrto			=	b.cnsctvo_cdgo_tpo_cntrto 
And		a.nmro_cntrto						=	b.nmro_cntrto 
where b.cnsctvo_cdgo_prntsco 				in 	(1,2,3) --Cotizante, Conygue  
And		(Convert(varchar(10), b.fn_vgnca_bnfcro,111)	>=  	Convert(varchar(10),@Fcha_Crtro_incl,111) ) 
And		(Convert(varchar(10), b.inco_vgnca_bnfcro,111)	<  	Convert(varchar(10),@Fcha_Crtro_Fnl,111) ) 
 

-------------------------------------------------------------- 
--Adecuaciones realizdas para el año 2007 sau 59924 
-------------------------------------------------------------- 
 
---Se crea una tabla con los beneficiarios hijos y padres del cotizante  
select  a.nmro_unco_idntfccn_afldo,	
		b.nmro_unco_idntfccn_bnfcro,	
		b.cnsctvo_cdgo_prntsco,
		a.cnsctvo_cdgo_pln, 
		a.cnsctvo_cdgo_tpo_cntrto, 
		a.nmro_cntrto, 
		b.cnsctvo_bnfcro, 
		0 As cnsctvo_bnfcro_aux, 
		0 As cantidad, 
		2 As prsnta_pgs --no presenta pagos   
into    #tmpBeneficiariosHijos 
from	#tmpContratosPac a
inner join bdafiliacion.dbo.tbbeneficiarios b with(nolock) on a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto 
And		a.nmro_cntrto				=	b.nmro_cntrto 
where b.cnsctvo_cdgo_prntsco 		In (4, 5)
And		(Convert(varchar(10), b.fn_vgnca_bnfcro,111)	>=  	Convert(varchar(10),@Fcha_Crtro_incl,111) ) 
And		(Convert(varchar(10), b.inco_vgnca_bnfcro,111)	<  	Convert(varchar(10),@Fcha_Crtro_Fnl,111) ) 
 
 
--Se actualiza si tiene pagos--------------------  
 
update a 
set		prsnta_pgs = 1 
From	#tmpBeneficiariosHijos a 
inner join #tmpCertificadosAux b On	a.nmro_unco_idntfccn_bnfcro = b.nmro_unco_idntfccn_bnfcro 
where pgo							= 'S' 

----------------------------------------------- 
 
select *  
into #tmpBeneficiariosHijos_def 
from #tmpBeneficiariosHijos 
order by nmro_unco_idntfccn_afldo, prsnta_pgs, nmro_unco_idntfccn_bnfcro, cnsctvo_cdgo_pln, cnsctvo_cdgo_tpo_cntrto, nmro_cntrto asc  

------------------------------------------------------------------------- 
 
--se crea una estructura que contenga registros agrupados por nui 
select 	nmro_unco_idntfccn_afldo, IDENTITY(int, 1,1) AS ID_Num 
into 	 #afiliados  
from 	 #tmpBeneficiariosHijos_def 
group by nmro_unco_idntfccn_afldo 
 
 
--Se recalcula el cosncutivo de beneficiario 
declare @contador  int,  
	@contador2 int, 
	@nui	   int	 
select 	@contador = count(*) from   #afiliados 
 
set 	@contador2= 1 
 
while 	@contador2 <= @contador 
	 
   begin  
 
	select @nui=nmro_unco_idntfccn_afldo 
	From   	  #afiliados       
 	Where   ID_Num    		= @contador2     
 
	CREATE TABLE dbo. #tmpBeneficiariosHijos_aux ( 
	nmro_unco_idntfccn_afldo 	int NOT NULL , 
	nmro_unco_idntfccn_bnfcro 	int NOT NULL , 
	cnsctvo_cdgo_prntsco 		int NOT NULL , 
	cnsctvo_cdgo_pln 		int NOT NULL , 
	cnsctvo_cdgo_tpo_cntrto 	udtConsecutivo NOT NULL , 
	nmro_cntrto 			udtNumeroFormulario NOT NULL , 
	cnsctvo_axlr 			int IDENTITY(1,1)  
	) 
	insert into   #tmpBeneficiariosHijos_aux  
	(nmro_unco_idntfccn_afldo,  
	nmro_unco_idntfccn_bnfcro,  
	cnsctvo_cdgo_prntsco, 
	cnsctvo_cdgo_pln,  
	cnsctvo_cdgo_tpo_cntrto,  
	nmro_cntrto) 
 
	select 	nmro_unco_idntfccn_afldo,  
		nmro_unco_idntfccn_bnfcro,  
		cnsctvo_cdgo_prntsco, 
		cnsctvo_cdgo_pln,  
		cnsctvo_cdgo_tpo_cntrto, nmro_cntrto  
	from     #tmpBeneficiariosHijos_def 
	where 	nmro_unco_idntfccn_afldo=@nui 
 
	update  #tmpBeneficiariosHijos_def 
	set cnsctvo_bnfcro_aux 		= cnsctvo_axlr 
	from  #tmpBeneficiariosHijos_def a  
	inner join  #tmpBeneficiariosHijos_aux b 
	on  a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn_afldo 
	and a.nmro_unco_idntfccn_bnfcro = 	b.nmro_unco_idntfccn_bnfcro 
	where a.nmro_unco_idntfccn_afldo=	@nui 
	set @contador2 =@contador2+1 
	drop table  #tmpBeneficiariosHijos_aux 
 
   end 
 
 
--para contar la cantidad de beneficiarios 
-------------------------------------------------------------------------------------------------------- 
select count(*) as cntdd_bnfcrs, nmro_unco_idntfccn_afldo, cnsctvo_cdgo_pln, cnsctvo_cdgo_tpo_cntrto, nmro_cntrto 
into	#tmpCantidad 
from	#tmpBeneficiariosHijos_def 
group by  nmro_unco_idntfccn_afldo, cnsctvo_cdgo_pln, cnsctvo_cdgo_tpo_cntrto, nmro_cntrto 
--------------------------------------------------------------------------------------------------------- 
 
update #tmpBeneficiariosHijos_Def 
set cantidad = cntdd_bnfcrs 
from	#tmpBeneficiariosHijos_def a inner join #tmpCantidad b 
On 		a.nmro_unco_idntfccn_afldo	= b.nmro_unco_idntfccn_afldo 
And		a.cnsctvo_cdgo_pln			= b.cnsctvo_cdgo_pln 
And		a.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto 
And		a.nmro_cntrto				= b.nmro_cntrto 
 


-- Quick 2013-00001-000035554
-- Descripcion: Se comentarea, ya que deben salir todos los usuarios.
------------------------------------------------------ 
-- Delete from #tmpBeneficiariosHijos_def 
-- Where (cnsctvo_bnfcro_aux > 2 and prsnta_pgs=2) --Borra los mayoes del consecutivo 2 que no tiene pagos  
--------------------------------------------------------------------------------------------------------- 
 
---se crea una tabal temporal para que guarde los registros que finalmetne se van a almecenar 
CREATE TABLE dbo. #tmpBeneficiariosHijos_aux1 ( 
nmro_unco_idntfccn_afldo 	int NOT NULL , 
nmro_unco_idntfccn_bnfcro 	int NOT NULL , 
cnsctvo_cdgo_prntsco 		int NOT NULL , 
cnsctvo_cdgo_pln 		int NOT NULL , 
cnsctvo_cdgo_tpo_cntrto 	udtConsecutivo NOT NULL , 
nmro_cntrto 			udtNumeroFormulario NOT NULL , 
) 
 
 
select 	@contador = count(*) from   #afiliados 
set 	@contador2= 1 
while 	@contador2 <= @contador 
   begin  

	select @nui=nmro_unco_idntfccn_afldo 
	From   	  #afiliados       
 	Where   ID_Num    		= @contador2     

	insert into  #tmpBeneficiariosHijos_aux1 
	(nmro_unco_idntfccn_afldo,  
	nmro_unco_idntfccn_bnfcro,  
	cnsctvo_cdgo_prntsco, 
	cnsctvo_cdgo_pln,  
	cnsctvo_cdgo_tpo_cntrto,  
	nmro_cntrto) 
--	select	top 2 ----Para inserta  
	select		  ----Para inserta  -- Quick 2013-00001-000035554 debe salir todos los hijos y los padres del cotizante
 	nmro_unco_idntfccn_afldo,  
	nmro_unco_idntfccn_bnfcro,  
	cnsctvo_cdgo_prntsco, 
	cnsctvo_cdgo_pln,  
	cnsctvo_cdgo_tpo_cntrto,  
	nmro_cntrto 
	from 	 #tmpBeneficiariosHijos_def 
	where 	nmro_unco_idntfccn_afldo=@nui 
	set @contador2 =@contador2+1 
   end 
 
--Se insertan los beneficiarios Hijos  
insert into  #tmpBeneficiarios 
	(nmro_unco_idntfccn_afldo,  
	nmro_unco_idntfccn_bnfcro,  
	cnsctvo_cdgo_prntsco, 
	cnsctvo_cdgo_pln,  
	cnsctvo_cdgo_tpo_cntrto,  
	nmro_cntrto) 
 
select	nmro_unco_idntfccn_afldo,  
	nmro_unco_idntfccn_bnfcro,  
	cnsctvo_cdgo_prntsco, 
	cnsctvo_cdgo_pln,  
	cnsctvo_cdgo_tpo_cntrto,  
	nmro_cntrto 
from 	#tmpBeneficiariosHijos_aux1 
-- Se adiciona la linea solo para parentezcos cotizante , conyuge , compañero e hijos 
 
----------------------- 
 
update #tmpCertificadosAux 
Set		nmro_unco_idntfccn_bnfcro=nmro_unco_idntfccn_afldo 
From	#tmpCertificadosAux 
Where	nmro_unco_idntfccn_bnfcro=0 
And		tpo_dcmnto in ('NC','ND','NR','NE') 
 
/* 
select *  
into tmpCertificadosAux 
from #tmpCertificadosAux 
 
select *  
into tmpBeneficiarios 
from #tmpBeneficiarios 
*/ 
 
-- En un cursor meto los registros que necesitop copiar despues del proximo borrado 
 
Select * 
into  #tmpCertificadosAux_1 
from #tmpCertificadosAux    
where tpo_dcmnto in ('NC','ND''NR','NE')  
 
 
Delete from  #tmpCertificadosAux 
From	     #tmpCertificadosAux 
Where 	     #tmpCertificadosAux.nmro_unco_idntfccn_bnfcro not in (Select nmro_unco_idntfccn_bnfcro from  #tmpBeneficiarios) 
 
 
insert into #tmpCertificadosAux 
select * from #tmpCertificadosAux_1 
 
 
drop table #tmpCertificadosAux_1 
 
 
select nmro_unco_idntfccn_empldr, 
		cnsctvo_scrsl, 
		cnsctvo_cdgo_clse_aprtnte, 
     	cnsctvo_cdgo_tpo_cntrto ,
		nmro_cntrto, 
		vlr_abno_cta  , 
		vlr_abno_iva, 
		cnsctvo_cdgo_pln, 
		nmro_unco_idntfccn_afldo, 
		nmro_unco_idntfccn_bnfcro, 
		fcha_crcn, 
		pgo,
		tpo_dcmnto,
		cnsctvo_nta_bnfcro_cntrto
into #tmpAgruparNotas
from #tmpCertificadosAux   
where tpo_dcmnto in ('NC','ND''NR','NE') 
group by	nmro_unco_idntfccn_empldr, 
			cnsctvo_scrsl, 
			cnsctvo_cdgo_clse_aprtnte, 
     		cnsctvo_cdgo_tpo_cntrto ,
			nmro_cntrto, 
			vlr_abno_cta  , 
			vlr_abno_iva, 
			cnsctvo_cdgo_pln, 
			nmro_unco_idntfccn_afldo, 
			nmro_unco_idntfccn_bnfcro, 
			fcha_crcn, 
			pgo,
			tpo_dcmnto,
			cnsctvo_nta_bnfcro_cntrto


 delete from #tmpCertificadosAux  where  tpo_dcmnto in ('NC','ND''NR','NE')  
 
 Insert into #tmpCertificadosAux   
  Select * from #tmpAgruparNotas
	
 
/*select * into tmpCertificadosAux 
from #tmpCertificadosAux 
 */
 
---Se agrupa por nui de beneficiario, parentesco y plan Beneficiario x Plan 
select   nmro_unco_idntfccn_afldo ,nmro_unco_idntfccn_bnfcro,	cnsctvo_cdgo_prntsco ,  
	 cnsctvo_cdgo_pln, 
	 0	cantidad_bene 
into     #tmpBeneficiariosXPlan 
from	 #tmpBeneficiarios a 
Group by nmro_unco_idntfccn_afldo ,nmro_unco_idntfccn_bnfcro,	cnsctvo_cdgo_prntsco ,  
	 cnsctvo_cdgo_pln 

 
----Se agrupan cotizantes x plan  
Select  cnsctvo_cdgo_pln, 
	nmro_unco_idntfccn_afldo, 
	nmro_unco_idntfccn_empldr, 
	Sum(vlr_abno_cta + vlr_abno_iva) Valor_total_plan 
into	 #tmpTotalCotizantePlan 
From	 #tmpCertificadosAux 
Group by cnsctvo_cdgo_pln, 
	nmro_unco_idntfccn_afldo, 
	nmro_unco_idntfccn_empldr 
 
Select  @Fecha_ini	=	min(fcha_crcn)  from  #tmpCertificadosAux 
Select  @Fecha_fin	=	max(fcha_crcn)  from  #tmpCertificadosAux 
 
 
Select  @Fecha_fin 	= 	Dateadd(month,1,@Fecha_fin) 
 
Select	@Fecha_fin	=	Dateadd(day,-1,Convert(varchar(6),bdRecaudos.dbo.fncalculaperiodo(@Fecha_fin))+'01') 
 
----Beneficairios x abonos  
select  a.cnsctvo_cdgo_pln, 
	a.nmro_unco_idntfccn_afldo, 
	a.nmro_unco_idntfccn_empldr, 
	a.Valor_total_plan, 
	space(3)	TI_coti, 
	space(15)	NI_coti, 
	space(100)	nombre_Coti, 
	space(3)	TI_bene, 
	space(15)	NI_bene, 
	space(100)	nombre_bene, 
	space(30)	dscrpcn_prntsco, 
	space(30)	dscrpcn_pln, 
	@Fecha_ini	Fecha_ini, 
	@Fecha_fin	Fecha_fin, 
	b.nmro_unco_idntfccn_bnfcro, 
	b.cnsctvo_cdgo_prntsco, 
	0	estado,
	0 cnsctvo_cdgo_tpo_idntfccn
into 	 #tmpbeneficiariosXabonos 
from 	 #tmpTotalCotizantePlan a
inner join #tmpBeneficiariosXPlan b  on a.cnsctvo_cdgo_pln 		= b.cnsctvo_cdgo_pln 
and	a.nmro_unco_idntfccn_afldo	= b.nmro_unco_idntfccn_afldo 
 
----Se actualizan los datos de los beneficiarios x abonos  
Update 	 a 
Set	TI_coti		=	c.cdgo_tpo_idntfccn, 
	NI_coti		=	b.nmro_idntfccn,
	cnsctvo_cdgo_tpo_idntfccn = c.cnsctvo_cdgo_tpo_idntfccn
From	 #tmpbeneficiariosXabonos a
inner join bdafiliacion.dbo.tbvinculados  b with(nolock) on a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn 
inner join bdafiliacion.dbo.tbtiposidentificacion c  with(nolock) on b.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn 
 
Update 	 a 
Set	TI_bene		=	c.cdgo_tpo_idntfccn, 
	NI_bene		=	b.nmro_idntfccn 
From	 #tmpbeneficiariosXabonos a
inner join bdafiliacion.dbo.tbvinculados  b with(nolock) on a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn 
inner join bdafiliacion.dbo.tbtiposidentificacion c  with(nolock) on b.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn 
 
Update  a 
Set	nombre_Coti	=	convert(varchar(50),ltrim(rtrim(prmr_aplldo)) + ' ' + ltrim(rtrim(sgndo_aplldo)) + ' ' + ltrim(rtrim(prmr_nmbre)) + ' '  + ltrim(rtrim(sgndo_nmbre))) 
From	 #tmpbeneficiariosXabonos a
inner join bdafiliacion.dbo.tbPersonas b with(nolock) on a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn 
 
Update  a 
Set	nombre_bene	=	convert(varchar(50),ltrim(rtrim(prmr_aplldo)) + ' ' + ltrim(rtrim(sgndo_aplldo)) + ' ' + ltrim(rtrim(prmr_nmbre)) + ' '  + ltrim(rtrim(sgndo_nmbre))) 
From	 #tmpbeneficiariosXabonos a
inner join bdafiliacion.dbo.tbPersonas b with(nolock) on a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn 
 
Update  a 
Set	dscrpcn_prntsco	=	b.dscrpcn_prntsco 
From	 #tmpbeneficiariosXabonos a
inner join bdafiliacion.dbo.tbparentescos b with(nolock) on a.cnsctvo_cdgo_prntsco	=	b.cnsctvo_cdgo_prntscs 
 
 
Update  a 
Set	dscrpcn_pln		=	b.dscrpcn_pln 
From	 #tmpbeneficiariosXabonos a
inner join bdplanbeneficios.dbo.tbplanes b with(nolock) on a.cnsctvo_cdgo_pln	=	b.cnsctvo_cdgo_pln 
 
 
update  #tmpbeneficiariosXabonos 
set	estado = 1 
where   cnsctvo_cdgo_prntsco in (1,2,3,4,5) 
 
 

select  0 nmro_rdcn, 
	TI_coti, 
	NI_coti, 
	nombre_Coti, 
	convert(varchar(10),Fecha_ini,111)	Fecha_ini, 
	convert(varchar(10),Fecha_fin,111)	Fecha_fin, 
        convert(int,Valor_total_plan)		Valor_total_plan, 
        TI_bene, 
	NI_bene, 
        nombre_bene, 
        dscrpcn_prntsco, 
        dscrpcn_pln, 
	cnsctvo_cdgo_pln, 
	right(replicate('0',20)+ltrim(rtrim(NI_coti)),20) + right(replicate('0',2)+ltrim(rtrim(cnsctvo_cdgo_pln)),2) 	AfiliadoPlan,
	nmro_unco_idntfccn_afldo,
	cnsctvo_cdgo_tpo_idntfccn
Into	#tmpbeneficiariosXabonosFinal 
From 	#tmpbeneficiariosXabonos  
Where 	1 = 2



 IF  @lcNuiCotizante = 'S'
 BEGIN
Insert into  #tmpbeneficiariosXabonosFinal 
select  0 nmro_rdcn, 
	TI_coti, 
	NI_coti, 
	nombre_Coti, 
	convert(varchar(10),Fecha_ini,111)	Fecha_ini, 
	convert(varchar(10),Fecha_fin,111)	Fecha_fin, 
        convert(int,Valor_total_plan)		Valor_total_plan, 
        TI_bene, 
	NI_bene, 
        nombre_bene, 
        dscrpcn_prntsco, 
        dscrpcn_pln, 
	cnsctvo_cdgo_pln, 
	right(replicate('0',20)+ltrim(rtrim(NI_coti)),20) + right(replicate('0',2)+ltrim(rtrim(cnsctvo_cdgo_pln)),2) 	AfiliadoPlan ,
	nmro_unco_idntfccn_afldo,
	cnsctvo_cdgo_tpo_idntfccn
From 	#tmpbeneficiariosXabonos  
Where 	estado = 1 
and (ltrim(rtrim(NI_coti)) =	@lnNumeroCotizante	and ltrim(rtrim(TI_coti)) = 	 @lcTipoCotizante)
end
else
begin 
Insert into  #tmpbeneficiariosXabonosFinal 
select  0 nmro_rdcn, 
	TI_coti, 
	NI_coti, 
	nombre_Coti, 
	convert(varchar(10),Fecha_ini,111)	Fecha_ini, 
	convert(varchar(10),Fecha_fin,111)	Fecha_fin, 
        convert(int,Valor_total_plan)		Valor_total_plan, 
        TI_bene, 
	NI_bene, 
        nombre_bene, 
        dscrpcn_prntsco, 
        dscrpcn_pln, 
	cnsctvo_cdgo_pln, 
	right(replicate('0',20)+ltrim(rtrim(NI_coti)),20) + right(replicate('0',2)+ltrim(rtrim(cnsctvo_cdgo_pln)),2) 	AfiliadoPlan ,
	nmro_unco_idntfccn_afldo,
	cnsctvo_cdgo_tpo_idntfccn
From 	#tmpbeneficiariosXabonos  
Where 	estado = 1 
end



--print  @lcNuiCotizante 
/*
 IF  @lcNuiCotizante = 'S'
 BEGIN
  Delete from #tmpbeneficiariosXabonosFinal 
where (ltrim(rtrim(NI_coti)) !=	@lnNumeroCotizante	and ltrim(rtrim(TI_coti)) != 	 @lcTipoCotizante)
 END
	*/	

--select * from #tmpbeneficiariosXabonosFinal 

--select *  into tmpbeneficiariosXabonos 
--from #tmpbeneficiariosXabonos 
 
 
delete #tmpbeneficiariosXabonosFinal 
where valor_total_plan <= 0 
 
------------------Para el numero de radicación del Centro de documentación---------------- 
 
select  ti_coti, ni_coti, cnsctvo_cdgo_pln, 0 as nmro_rdcn, IDENTITY(int, 1,1) as cnsctvo   
into #tmpConsecutivoRadicacion 
from #tmpbeneficiariosXabonosFinal  
group by ti_coti, ni_coti, cnsctvo_cdgo_pln 
 
create table #tmpconsecutivos ( 
nmro_rdcn int, 
cnsctvo	  int IDENTITY)	 
 
 
--set @nmro_rdcn_incl=@nmro_rdcn_incl-1 
 
while 	@nmro_rdcn_incl <= @nmro_rdcn_fnl 
   begin  
	insert into #tmpconsecutivos 
	(nmro_rdcn) 
	values  
	(@nmro_rdcn_incl) 
	set @nmro_rdcn_incl =@nmro_rdcn_incl+1 
   end 
 
 
Update  a 
Set	nmro_rdcn	=	b.nmro_rdcn 
From	#tmpConsecutivoRadicacion a
inner join #tmpconsecutivos b on a.cnsctvo	=	b.cnsctvo 
 
 
Update  a 
Set	nmro_rdcn	=	b.nmro_rdcn 
From	#tmpbeneficiariosXabonosFinal a
inner join #tmpConsecutivoRadicacion b  on a.ti_coti	=	b.ti_coti 
and 	a.ni_coti	=	b.ni_coti	 
and	a.cnsctvo_cdgo_pln=	b.cnsctvo_cdgo_pln 

------------------------------------------- 
--select  *  
--into tmpConsecutivoRadicacion 
--from #tmpConsecutivoRadicacion  
 
--select  * 
--into tmpbeneficiariosXabonosFinal 
--from  #tmpbeneficiariosXabonosFinal 
--where valor_total_plan > 0 
--order by TI_coti, NI_coti, dscrpcn_pln 

------------------------------------------ 


Select  * 
from  #tmpbeneficiariosXabonosFinal 
where valor_total_plan > 0 
order by nmro_rdcn, TI_coti, NI_coti, dscrpcn_pln 
