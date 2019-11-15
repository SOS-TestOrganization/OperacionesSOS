


/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spEjecutaConsDetEmpleador
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento para generar el reporte del Estadistico de facturacion			 	D\>
* Observaciones		: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003/02/10											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM  Ing. Fernando Valencia EAM\>
* Descripcion			: <\DM  Generar todas las sucursales al seleccionar 999999999 Inexistente en el clienteDM\>
* Descripcion			: <\DM  Al ignorar la sede saca todas las sedes                                                          DM\>
* Descripcion			: <\DM  Se agrega el campo valor ants de iva                                                          DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM 2006/03/30 FM\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM  Ing. Juan manuel Victoria EAM\>
* Descripcion			: <\DM  Optimizacion query DM\>

* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM 2019/07/04 FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[spEjecutaConsLiquidacionPrevia] with recompile


As

begin

Declare
@tbla					varchar(128),
@cdgo_cmpo 				varchar(128),
@oprdr 					varchar(2),
@vlr 					varchar(250),
@cmpo_rlcn 				varchar(128),
@cmpo_rlcn_prmtro 			varchar(128),
@cnsctvo				Numeric(4),
@IcInstruccion				Nvarchar(4000),
@IcInstruccion1				Nvarchar(4000),
@IcInstruccion2				Nvarchar(4000),
@lcAlias				char(2),
@lnContador				Int,
@ldFechaSistema				Datetime,
@Fecha_Corte				Datetime,
@Fecha_Caracter				varchar(15),
@lnValorIva				numeric(12,2),
@cnsctvo_cdgo_sde  			int,
@cnsctvo_cdgo_clse_aprtnte 		int,
@nmro_unco_idntfccn_empldr  		int, 
@cnsctvo_cdgo_lqdcn 				int,
@prdo 					int,
@Valor_Porcentaje_Iva			int

Set Nocount On

Select	@ldFechaSistema	=	Getdate()

Select	@Valor_Porcentaje_Iva	= prcntje
From	bdCarteraPac.dbo.tbConceptosLiquidacion_Vigencias with(nolock)
Where	cnsctvo_cdgo_cncpto_lqdcn	= 3
And	@ldFechaSistema	Between inco_vgnca And 	fn_vgnca


--Se cruzan los contratos asociados a las sucursales y se traer las sucursales finales para liquidar


Set	@cnsctvo_cdgo_sde  			=	 NULL
Set	@cnsctvo_cdgo_clse_aprtnte 		=	 NULL
Set	@nmro_unco_idntfccn_empldr  		=	 NULL
Set	@prdo 					=	NULL

/*

Set	@cnsctvo_cdgo_sde  			=	 7
Set	@cnsctvo_cdgo_clse_aprtnte 		=	 1
Set	@nmro_unco_idntfccn_empldr  		=	 100003
Set	@cnsctvo_scrsl 			=	 1
Set	@prdo 					=	200907*/
/*
select * from bdafiliacion.dbo.tbVinculados v where v.nmro_idntfccn = '805001157'
select * from bdafiliacion.dbo.tbSucursalesAportante sa where sa.nmro_unco_idntfccn_empldr = 100003
*/


Select 	@cnsctvo_cdgo_lqdcn	 		=	vlr	
From 	#tbCriteriosTmp
Where 	cdgo_cmpo 	 		= 	'cnsctvo_cdgo_lqdcn' 

-- Contador de condiciones
Select @lnContador = 1

-- se crea la tabla temporal con la infromacion de las sucursales que s epuedan liquidar

select    bdRecaudos.dbo.fnCalculaPeriodo (a.fcha_incl_prdo_lqdcn) 	prdo,
	 cnsctvo_cdgo_lqdcn
into 	#tmpLiquidacionPrevia
from 	dbo.tbperiodosliquidacion_vigencias a with(nolock)
inner join dbo.tbliquidaciones b with(nolock) on a.cnsctvo_cdgo_prdo_lqdcn	=	b.cnsctvo_cdgo_prdo_lqdcn
where	b.cnsctvo_cdgo_estdo_lqdcn	IN	(2,5,6)
and  b.cnsctvo_cdgo_lqdcn	 = 	@cnsctvo_cdgo_lqdcn	 
--select * from 		dbo.tbliquidaciones

-- primero se hace para estados de cuenta
CREATE TABLE #tmpDetEmpleador(
	[prdo] [int] NULL,
	[nmro_unco_idntfccn_empldr] [int] NOT NULL,
	[cnsctvo_cdgo_clse_aprtnte] [int] NOT NULL,
	[cnsctvo_scrsl] [int] NOT NULL,
	[cnsctvo_estdo_cnta] [int] NOT NULL,
	[nmbre_scrsl] [varchar](200) NULL,
	[nmro_estdo_cnta] [varchar](15) NOT NULL,
	[cdgo_sde] [varchar](30) NULL,
	[dscrpcn_sde] [varchar](100) NULL,
	[drccn] [varchar](80) NULL,
	[tlfno] [varchar](30) NULL,
	[cnsctvo_cdgo_lqdcn] [int] NOT NULL
) 



INSERT INTO #tmpDetEmpleador
           ([prdo]
           ,[nmro_unco_idntfccn_empldr]
           ,[cnsctvo_cdgo_clse_aprtnte]
           ,[cnsctvo_scrsl]
           ,[cnsctvo_estdo_cnta]
           ,[nmbre_scrsl]
           ,[nmro_estdo_cnta]
           ,[cdgo_sde]
           ,[dscrpcn_sde]
           ,[drccn]
           ,[tlfno]
           ,[cnsctvo_cdgo_lqdcn])
  	SELECT    	prdo,
			a.nmro_unco_idntfccn_empldr,
			a.cnsctvo_cdgo_clse_aprtnte,
			a.cnsctvo_scrsl,
			a.cnsctvo_estdo_cnta,
			b.nmbre_scrsl, a.nmro_estdo_cnta,
			null cdgo_sde,
			null dscrpcn_sde,
			b.drccn ,
			b.tlfno,
			d.cnsctvo_cdgo_lqdcn
	FROM   #tmpLiquidacionPrevia d 
	inner join dbo.TbestadosCuenta a  with(nolock)	on a.cnsctvo_cdgo_lqdcn			=	d.cnsctvo_cdgo_lqdcn
	inner join bdafiliacion.dbo.tbSucursalesAportante  b with(nolock)	on a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn_empldr  
	And	 a.cnsctvo_cdgo_clse_aprtnte		=	b.cnsctvo_cdgo_clse_aprtnte  
	And	 a.cnsctvo_scrsl				=	b.cnsctvo_scrsl 
	Where a.cnsctvo_cdgo_estdo_estdo_cnta	!= 	4	

--select * from #tmpDetEmpleador
--drop table #tmpDetEmpleadorFinal	
Select DISTINCT   a.prdo,
            	a.nmro_unco_idntfccn_empldr,
            	a.cnsctvo_cdgo_clse_aprtnte,
            	a.cnsctvo_scrsl,
            	a.cnsctvo_estdo_cnta,
            	a.nmbre_scrsl ,
            	space(3)		tpo_idntfccn_emprsa,
            	space(15)		nmro_idntfccn_emprsa,
            	space(3)  		tpo_idntfccn_bene,
            	space(15)  		nmro_idntfccn_bene,
            	space(3)  		tpo_idntfccn_coti,
            	space(15)  		nmro_idntfccn_coti,
	0			nmro_unco_idntfccn_afldo,
       	c.nmro_unco_idntfccn_bnfcro,		
	c.cnsctvo_bnfcro,
	c.vlr,
	convert(datetime,null)	fcha_ncmnto,
	convert(datetime,null)	inco_vgnca_bnfcro,
	convert(datetime,null)	fn_vgnca_bnfcro,
	space(150)		nmbre_bene,
	space(150)		nmbre_coti,
	space(50)		dscrpcn_prntsco,
	0			cnsctvo_cdgo_prntscs,
	b.nmro_cntrto,
	b.cnsctvo_cdgo_tpo_cntrto,
	0			cnsctvo_cdgo_pln,
	space(50)		dscrpcn_pln,
	0	edd_bnfcro,
	a.nmro_estdo_cnta,
	a.cdgo_sde,
	a.dscrpcn_sde,
	a.drccn ,	
	a.tlfno,
	d.vlr as vlr_ants_iva,
	a.cnsctvo_cdgo_lqdcn,
	hp.grupo,
	dg.dscrpcn_dtlle_grpo,
	hp.cnsctvo_mdlo,
	m.dscrpcn_mdlo,
	hp.cnsctvo_prdcto,
	pr.dscrpcn_prdcto
into	#tmpDetEmpleadorFinal	
From	#tmpDetEmpleador a
inner join dbo.tbEstadosCuentaContratos b with(nolock) on a.cnsctvo_estdo_cnta			=	b.cnsctvo_estdo_cnta
inner join dbo.tbCuentasContratosBeneficiarios c with(nolock) on b.cnsctvo_estdo_cnta_cntrto		=	c.cnsctvo_estdo_cnta_cntrto
inner join dbo.tbCuentasBeneficiariosConceptos d with(nolock) on c.cnsctvo_estdo_cnta_cntrto_bnfcro	= 	d.cnsctvo_estdo_cnta_cntrto_bnfcro
inner join dbo.tbhistoricotarificacionxproceso hp with(nolock) on c.nmro_unco_idntfccn_bnfcro = hp.nmro_unco_idntfccn 
																  and a.cnsctvo_cdgo_lqdcn = hp.cnsctvo_cdgo_lqdcn
inner join bdafiliacion.dbo.tbdetgrupos dg with(nolock) on hp.grupo = dg.cnsctvo_cdgo_dtlle_grpo
inner join bdplanbeneficios.dbo.tbmodelos m with(nolock) on  hp.cnsctvo_mdlo = m.cnsctvo_mdlo
inner join bdplanbeneficios.dbo.tbproductos pr with(nolock) on hp.cnsctvo_prdcto = pr.cnsctvo_prdcto
Where d.cnsctvo_cdgo_cncpto_lqdcn		=	4


Update a
Set	cnsctvo_cdgo_pln		=	b.cnsctvo_cdgo_pln,
	nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn_afldo
From	#tmpDetEmpleadorFinal a
inner join bdafiliacion.dbo.tbcontratos b with(nolock) on a.nmro_cntrto			=	b.nmro_cntrto
														  And       a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto



Update a
Set	dscrpcn_pln		=	b.dscrpcn_pln
From	#tmpDetEmpleadorFinal a
inner join bdplanbeneficios.dbo.tbplanes b with(nolock) on a.cnsctvo_cdgo_pln	=	b.cnsctvo_cdgo_pln

Update a
Set	cnsctvo_cdgo_prntscs		=	b.cnsctvo_cdgo_prntsco,
	inco_vgnca_bnfcro		=	b.inco_vgnca_bnfcro,
	fn_vgnca_bnfcro		=	b.fn_vgnca_bnfcro
From	#tmpDetEmpleadorFinal a
inner join bdafiliacion.dbo.tbbeneficiarios b with(nolock) on a.nmro_cntrto			=	b.nmro_cntrto
And	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.cnsctvo_bnfcro		=	b.cnsctvo_bnfcro
And	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn_bnfcro


Update a
Set	dscrpcn_prntsco		=	b.dscrpcn_prntsco
From	#tmpDetEmpleadorFinal a
inner join bdafiliacion.dbo.tbparentescos b with(nolock) on a.cnsctvo_cdgo_prntscs	=	b.cnsctvo_cdgo_prntscs


Update a
Set	tpo_idntfccn_bene		=	c.cdgo_tpo_idntfccn,
        	nmro_idntfccn_bene		=	b.nmro_idntfccn
From	#tmpDetEmpleadorFinal a
inner join bdafiliacion.dbo.tbvinculados  b with(nolock) on a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn
inner join bdafiliacion.dbo.tbtiposidentificacion 	c with(nolock) on b.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn

Update a
Set	tpo_idntfccn_coti		=	c.cdgo_tpo_idntfccn,
        	nmro_idntfccn_coti		=	b.nmro_idntfccn
From	#tmpDetEmpleadorFinal a
inner join bdafiliacion.dbo.tbvinculados  b with(nolock) on a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn
inner join bdafiliacion.dbo.tbtiposidentificacion 	c with(nolock) on b.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn

Update a
Set	tpo_idntfccn_emprsa		=	c.cdgo_tpo_idntfccn,
        	nmro_idntfccn_emprsa		=	b.nmro_idntfccn
From	#tmpDetEmpleadorFinal a
inner join bdafiliacion.dbo.tbvinculados  b with(nolock) on a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn
inner join bdafiliacion.dbo.tbtiposidentificacion 	c with(nolock) on b.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn


Update a
Set	fcha_ncmnto			=	b.fcha_ncmnto
From	#tmpDetEmpleadorFinal a
inner join bdafiliacion.dbo.tbpersonas  b with(nolock) on a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn



update #tmpDetEmpleadorFinal	
Set	edd_bnfcro	=	BDAFILIACION.DBO.fnCalcularTiempo (fcha_ncmnto,GETDATE(),1,2)

Update  #tmpDetEmpleadorFinal
Set	nmbre_bene			=	  ltrim(rtrim(e.prmr_aplldo))  + ' ' + ltrim(rtrim(e.sgndo_aplldo)) + ' ' + ltrim(rtrim(e.prmr_Nmbre )) + ' ' + ltrim(rtrim(e.sgndo_nmbre)) 
From	#tmpDetEmpleadorFinal a
inner join bdafiliacion.dbo.tbpersonas  e with(nolock) on a.nmro_unco_idntfccn_bnfcro	=	e.nmro_unco_idntfccn

Update  #tmpDetEmpleadorFinal
Set	nmbre_coti			=	  ltrim(rtrim(e.prmr_aplldo))  + ' ' + ltrim(rtrim(e.sgndo_aplldo)) + ' ' + ltrim(rtrim(e.prmr_Nmbre)) + ' ' + ltrim(rtrim(e.sgndo_nmbre)) 
From	#tmpDetEmpleadorFinal a
inner join bdAfiliacion.dbo.tbpersonas e with(nolock) on a.nmro_unco_idntfccn_afldo	=            e.nmro_unco_idntfccn

----Para actualizar las sedes 
Update  a
Set	cdgo_sde			= c.cdgo_sde,
	dscrpcn_sde			= c.dscrpcn_sde
From	#tmpDetEmpleadorFinal a  	
inner join bdAfiliacion.dbo.tbSucursalesAportante e with(nolock)
On 	a.nmro_unco_idntfccn_empldr	= e.nmro_unco_idntfccn_empldr
and	a.cnsctvo_cdgo_clse_aprtnte	= e.cnsctvo_cdgo_clse_aprtnte
and	a.cnsctvo_scrsl			= e.cnsctvo_scrsl 	
					inner join  bdAfiliacion.dbo.tbsedes c with(nolock)
On          e.sde_crtra_pc			=  c.cnsctvo_cdgo_sde	
where a.cdgo_sde is null and a.dscrpcn_sde is null


--Update  #tmpDetEmpleadorFinal
--Set	vlr_ants_iva= vlr/(Convert(Float,(10 + convert(Int,@Valor_Porcentaje_Iva)))/Convert(Float,10))
--Select  * from #tmpDetEmpleadorFinal order by nmbre_scrsl , nmbre_coti

select tpo_idntfccn_coti as TIPO_ID,
nmro_idntfccn_coti  as NRO_ID_COT,
nmbre_coti as NOMBRE_COTIZANTE,
tpo_idntfccn_bene as TIPO_ID_BENEF,
nmro_idntfccn_bene	as NRO_ID_BENEF,
nmbre_bene as NOMBRE_BENEFICIARIO,
vlr_ants_iva as VLR_SIN_IVA,
--convert(numeric(12,0),(vlr_ants_iva * convert(Int,@Valor_Porcentaje_Iva)/100)) as IVA,
vlr as VLR_TOTAL,
dscrpcn_prntsco AS  PARENTESCO,
edd_bnfcro AS EDAD,
dscrpcn_pln,
nmro_cntrto,
cnsctvo_scrsl,
prdo,
nmro_unco_idntfccn_empldr,
cnsctvo_cdgo_clse_aprtnte,
cnsctvo_estdo_cnta,
nmbre_scrsl,
tpo_idntfccn_emprsa,
nmro_idntfccn_emprsa,
nmro_unco_idntfccn_afldo,
nmro_unco_idntfccn_bnfcro,
cnsctvo_bnfcro,
fcha_ncmnto,
inco_vgnca_bnfcro,
fn_vgnca_bnfcro,
cnsctvo_cdgo_prntscs,
cnsctvo_cdgo_tpo_cntrto,
cnsctvo_cdgo_pln,
nmro_estdo_cnta,
cdgo_sde,	
dscrpcn_sde,
drccn,
tlfno,
cnsctvo_cdgo_lqdcn,
	grupo AS CODIGO_GRUPO,
	dscrpcn_dtlle_grpo as NOMBRE_GRUPO,
	cnsctvo_mdlo AS MODELO_TARIFAS,
	dscrpcn_mdlo AS NOMBRE_MODELO,
	cnsctvo_prdcto AS  PRODUCTO,
	dscrpcn_prdcto AS NOMBRE_PRODUCTO
from #tmpDetEmpleadorFinal
order by  cnsctvo_scrsl, nmbre_coti

end
