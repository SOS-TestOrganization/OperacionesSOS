
/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spEjecutaConsCarta30DiasPac
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
* Modificado Por			: <\AM  Ing. Fernando Valencia EAM\>
* Descripcion			: <\DM Se adiconan  a la consulta las notas debito que no esten en estado 6 y 3   DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  2006/11/28 Sau  58316  FM\>
*---------------------------------------------------------------------------------*/
CREATE  PROCEDURE [dbo].[spEjecutaConsCarta30DiasPac]

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
@ldFechaSistema	Datetime,
@prdo 			int,
@fecha 		datetime,
@ds int

Set Nocount On

Select	@ldFechaSistema	=	Getdate()
Set	@fecha =getdate()
Set	@prdo 					=	NULL
Set	@ds 					=	0

Select 	@prdo 	 =	vlr	
From 	#tbCriteriosTmp
Where 	cdgo_cmpo 	 = 	'cnsctvo_cdgo_prdo_lqdcn' 

Select 	@ds 	 =	vlr	
From 	#tbCriteriosTmp
Where 	cdgo_cmpo 	 = 	'ds_crta' 



SELECT    d.nmro_unco_idntfccn_empldr,
	  d.cnsctvo_cdgo_clse_aprtnte,
	  d.cnsctvo_scrsl,
	  d.cnsctvo_estdo_cnta,
          sum(e.sldo)   saldo,
	  bdrecaudos.dbo.fnCalculaPeriodo (d.Fcha_crcn) Periodo
into 	  #tmpResposableSaldo
FROM      tbLiquidaciones c,
	  tbEstadosCuenta d,
	  tbEstadosCuentaContratos e,
	  tbperiodosliquidacion_vigencias f
Where 	  d.cnsctvo_cdgo_lqdcn 		=	c.cnsctvo_cdgo_lqdcn 
And	  d.cnsctvo_estdo_cnta		= 	e.cnsctvo_estdo_cnta 
And	  c.cnsctvo_cdgo_estdo_lqdcn 	=	3
And	  c.cnsctvo_cdgo_prdo_lqdcn	=	f.cnsctvo_cdgo_prdo_lqdcn
AND	  e.sldo 				> 	1000	 
And	  f.cnsctvo_cdgo_prdo_lqdcn	<= @prdo
Group by  d.nmro_unco_idntfccn_empldr,
	  d.cnsctvo_cdgo_clse_aprtnte,
	  d.cnsctvo_scrsl,
	  d.cnsctvo_estdo_cnta,
	  d.Fcha_crcn



SELECT    d.nmro_unco_idntfccn_empldr,
	  d.cnsctvo_cdgo_clse_aprtnte,
	  d.cnsctvo_scrsl,
	  d.nmro_nta,
 	  SUM(e.sldo_nta_cntrto) sldo,
                bdrecaudos.dbo.fnCalculaPeriodo (d.Fcha_crcn_nta) Periodo
into 	  #tmpResposableSaldo_notas
FROM      tbLiquidaciones c,
	  tbnotasPac d,
	  tbNOtasContrato e,
	  tbperiodosliquidacion_vigencias f
Where 	  d.cnsctvo_prdo 		=	c.cnsctvo_cdgo_lqdcn 
And	  d.nmro_nta			= 	e.nmro_nta 
And	  c.cnsctvo_cdgo_estdo_lqdcn 	=	3
And	  c.cnsctvo_cdgo_prdo_lqdcn	=	f.cnsctvo_cdgo_prdo_lqdcn
AND	  e.sldo_nta_cntrto			> 	1000	 
And	  f.cnsctvo_cdgo_prdo_lqdcn	<=  @prdo
and         d.cnsctvo_cdgo_estdo_nta	not in (6,3)
and 	  e.cnsctvo_cdgo_tpo_nta	=1
and         d.cnsctvo_cdgo_tpo_nta	=1
Group by  d.nmro_unco_idntfccn_empldr,
	  d.cnsctvo_cdgo_clse_aprtnte,
	  d.cnsctvo_scrsl,
	  d.nmro_nta,
	  d.Fcha_crcn_nta


insert into #tmpResposableSaldo 
select * from #tmpResposableSaldo_notas


select  a.nmro_unco_idntfccn_empldr , 
	a.cnsctvo_cdgo_clse_aprtnte,
	a.cnsctvo_scrsl,
	0	dfrnca_mra,
	0	vlr_cta_0,
	0	vlr_cta_1,
	0	vlr_cta_2,
	0	vlr_cta_3,
	0	vlr_cta_4,
	0	vlr_cta_5,
	0	vlr_cta_6,
	0	vlr_cta_7,
	0	vlr_cta_8,
	0	vlr_cta_9,
	0	vlr_cta_10,
	a.saldo  Valor,
	space(15)	NI,
	Space(3)	TI,
	space(100)	Direccion,
	space(100)	Telefono,
	Space(100)	Ciudad,
	space(100)  Departamento,
	space(100)	nombre_Sede,
	0		cnsctvo_cdgo_cdd,
	0		Sede_pac,
	space(100)	nombre_aportante,
	Periodo,
        cnsctvo_estdo_cnta,
	0   Envio_sin_Abogado
into	#tmpCuotasAportante
From	#tmpResposableSaldo a   



Update 	#tmpCuotasAportante
Set	NI 	=	v.nmro_idntfccn,
	TI 	=	f.cdgo_tpo_idntfccn
From	#tmpCuotasAportante a, bdAfiliacion.dbo.tbVinculados v, 
	bdAfiliacion.dbo.tbTiposIdentificacion f
Where   a.nmro_unco_idntfccn_empldr 	= 	v.nmro_unco_idntfccn	 
AND	   v.cnsctvo_cdgo_tpo_idntfccn 	=	f.cnsctvo_cdgo_tpo_idntfccn


Update 	#tmpCuotasAportante
Set	nombre_aportante	=	s.nmbre_scrsl,
	Sede_pac		=	s.sde_crtra_pc,
	Direccion		=	s.drccn	,
	Telefono		=	s.tlfno,
	cnsctvo_cdgo_cdd	=	s.cnsctvo_cdgo_cdd,
	Envio_sin_Abogado	=	1
From	#tmpCuotasAportante a, bdafiliacion..tbSucursalesAportante s  
Where      a.nmro_unco_idntfccn_empldr	=	s.nmro_unco_idntfccn_empldr 
And	   a.cnsctvo_cdgo_clse_aprtnte	=	s.cnsctvo_cdgo_clse_aprtnte 
And        a.cnsctvo_scrsl		=	s.cnsctvo_scrsl 
And	  prmtr_crtra_pc!=12
-- Diferente  de Abogada

delete  from #tmpCuotasAportante where Envio_sin_Abogado = 0


Update 	#tmpCuotasAportante
Set	Ciudad			=	s.dscrpcn_cdd,
Departamento = d.dscrpcn_dprtmnto
From	#tmpCuotasAportante a inner join  bdafiliacion..tbciudades s
on      a.cnsctvo_cdgo_cdd	=	s.cnsctvo_cdgo_cdd 
inner join bdafiliacion.dbo.tbDepartamentos d
on substring(s.cdgo_cdd ,1,2) = d.cdgo_dprtmnto

Update 	#tmpCuotasAportante
Set	nombre_Sede			=	S.dscrpcn_sde
From	#tmpCuotasAportante a, bdafiliacion..TBSEDES S
Where      a.Sede_pac	=	s.cnsctvo_cdgo_sde 


Update #tmpCuotasAportante
Set	dfrnca_mra	=	Datediff(Month,Convert(varchar(6), Periodo)+'01',Substring(convert(varchar(8),@fecha,112),1,6)+ '01')


Update	#tmpCuotasAportante--#tmp1
Set	vlr_cta_0 	= 	Case      dfrnca_mra when 0 Then Valor Else 0 end,
	vlr_cta_1	=	Case 	  dfrnca_mra when 1 Then Valor Else 0 end,
	vlr_cta_2	=	Case 	  dfrnca_mra when 2 Then Valor Else 0 end,
	vlr_cta_3	=	Case 	  dfrnca_mra when 3 Then Valor Else 0 end,
	vlr_cta_4	=	Case 	  dfrnca_mra when 4 Then Valor Else 0 end,
	Vlr_cta_5	=	Case 	  dfrnca_mra when 5 Then Valor Else 0 end,
	Vlr_cta_6	=	Case 	  dfrnca_mra when 6 Then Valor Else 0 end,
	Vlr_cta_7	=	Case 	  dfrnca_mra when 7 Then Valor Else 0 end,
	Vlr_cta_8	=	Case 	  dfrnca_mra when 8 Then Valor Else 0 end,
	vlr_cta_9	=	Case 	  when dfrnca_mra	>=9	 and dfrnca_mra <=12    	Then Valor Else 0 end,
	vlr_cta_10	=	Case 	  when dfrnca_mra  	> 12 				Then Valor Else 0 end


delete #tmpCuotasAportante 
where 	vlr_cta_0>0 ---Para que no salgan 
and 	vlr_cta_1=0
and	vlr_cta_2=0
and	vlr_cta_3=0
and	vlr_cta_4=0
and	vlr_cta_5=0
and	vlr_cta_6=0
and	vlr_cta_7=0
and	vlr_cta_8=0
and	vlr_cta_9=0
and	vlr_cta_10=0


-- Hasta aqui era el informe anterior donde salia todo
select  NI,
	TI,
		cnsctvo_scrsl,
	Direccion,nombre_aportante,
	Telefono,
	Ciudad,
	Departamento,
	nombre_Sede,
	sum(vlr_cta_1) mora_30,
	sum(vlr_cta_2) mora_60,
	sum(vlr_cta_3) mora_90,
	sum(vlr_cta_4) mora_120,
	sum(vlr_cta_5) mora_150,
	sum(vlr_cta_6) mora_180,
	sum(vlr_cta_7) mora_210,
	sum(vlr_cta_8) mora_240,
	sum(vlr_cta_9) mora_mayor_240_y_menor_360,
	sum(vlr_cta_10) mora_mayor_360,
 0 as ds_mra
into #tmpFinalCuotasAportante
from #tmpCuotasAportante
Group by NI,
	TI,
			cnsctvo_scrsl,
	Direccion,nombre_aportante,
	Telefono,
	Ciudad,
	Departamento,
	nombre_Sede
ORDER BY ni


-- Cuando se agrego el nuevo criterio de dias de mora para enviar la carta
update #tmpFinalCuotasAportante 
set 	ds_mra  = 0

--- Se actuaiza la marca con 90 dias si tiene valor mora_90 sin importar si tiene 30 ó 60 , se debe enviar la carta con la mora mas antigua.
update #tmpFinalCuotasAportante 
set 	ds_mra  = 90
where  mora_30 >=0
and mora_60 >=0
and mora_90 > 0
and mora_120 = 0
and mora_150 = 0
and mora_180 = 0
and mora_210 = 0
and mora_240 = 0
and mora_mayor_240_y_menor_360 = 0
and mora_mayor_360 = 0


update #tmpFinalCuotasAportante 
set 	ds_mra  = 60
where  mora_30 >=0
and mora_60 > 0
and mora_90 = 0
and mora_120 = 0
and mora_150 = 0
and mora_180 = 0
and mora_210 = 0
and mora_240 = 0
and mora_mayor_240_y_menor_360 = 0
and mora_mayor_360 = 0
and ds_mra  = 0 -- Esta condicion para evitar si tiene valor en los tres campos de mora 30- 60- 90 vuelva y me actualice



update #tmpFinalCuotasAportante 
set 	ds_mra  = 30
where  mora_30 > 0
and mora_60 = 0
and mora_90 = 0
and mora_120 = 0
and mora_150 = 0
and mora_180 = 0
and mora_210 = 0
and mora_240 = 0
and mora_mayor_240_y_menor_360 = 0
and mora_mayor_360 = 0
and ds_mra  = 0

IF @ds in  (30,60,90) 
begin
select TI,
          NI,
	        nombre_aportante,
		     cnsctvo_scrsl,
	       Direccion,
				 	Telefono,
	        Ciudad,
	       Departamento,
       	 nombre_Sede,
					mora_30,
					mora_60,
					mora_90,
					mora_120,
					mora_150,
					mora_180,
					mora_210,
						mora_240,
					mora_mayor_240_y_menor_360,
					mora_mayor_360
from #tmpFinalCuotasAportante
where  ds_mra  = @ds
Group by TI,
          NI,
	        nombre_aportante,
		     cnsctvo_scrsl,
	       Direccion,
				 	Telefono,
	        Ciudad,
	       Departamento,
       	 nombre_Sede,
					mora_30,
					mora_60,
					mora_90,
					mora_120,
					mora_150,
					mora_180,
					mora_210,
						mora_240,
					mora_mayor_240_y_menor_360,
					mora_mayor_360
ORDER BY ni
end
else 
begin 
select  TI,
          NI,
	        nombre_aportante,
		     cnsctvo_scrsl,
	       Direccion,
				 	Telefono,
	        Ciudad,
	       Departamento,
       	 nombre_Sede,
					mora_30,
					mora_60,
					mora_90,
					mora_120,
					mora_150,
					mora_180,
					mora_210,
						mora_240,
					mora_mayor_240_y_menor_360,
					mora_mayor_360
from #tmpFinalCuotasAportante
Group by TI,
          NI,
	        nombre_aportante,
		     cnsctvo_scrsl,
	       Direccion,
				 	Telefono,
	        Ciudad,
	       Departamento,
       	 nombre_Sede,
					mora_30,
					mora_60,
					mora_90,
					mora_120,
					mora_150,
					mora_180,
					mora_210,
						mora_240,
					mora_mayor_240_y_menor_360,
					mora_mayor_360
ORDER BY ni
end
