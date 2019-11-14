
-----------------------



/*---------------------------------------------------------------------------------
* Metodo o PRG 			: spEjecutaConsImpresionEstadosCuenta
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento para generar el reporte del fecha de impresion de estado de cuenta 	 	D\>
* Observaciones		: <\O  														O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003/02/10											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Descripcion			: <\DM  DM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  FM\>
*---------------------------------------------------------------------------------*/
CREATE  PROCEDURE [dbo].[spEjecutaConsImpresionEstadosCuenta]

As

Declare
@tbla					varchar(128),
@cdgo_cmpo 				varchar(128),
@oprdr 					varchar(2),
@vlr 					varchar(250),
@cmpo_rlcn 				varchar(128),
@cmpo_rlcn_prmtro 			varchar(128),
@cnsctvo				Numeric(4),
@lnContador				Int,
@fcha_crcn_ini				Datetime,
@fcha_crcn_fn				Datetime,
@ldFechaSistema				Datetime,
@Fecha_Corte				Datetime,
@Fecha_Caracter				varchar(15),
@lnValorIva				numeric(12,2),
@cnsctvo_cdgo_sde  			int,
@cnsctvo_cdgo_clse_aprtnte 		int,
@nmro_unco_idntfccn_empldr  		int, 
@cnsctvo_scrsl 				int,
@prdo 					int,
@Valor_Porcentaje_Iva			int

Set Nocount On

Select	@ldFechaSistema	=	Getdate()

--Se cruzan los contratos asociados a las sucursales y se traer las sucursales finales para liquidar

Set	@cnsctvo_cdgo_sde  			=	 NULL
Set	@cnsctvo_cdgo_clse_aprtnte 		=	 NULL
Set	@nmro_unco_idntfccn_empldr  		=	 NULL
Set	@cnsctvo_scrsl 				=	 NULL
Set	@prdo 					=	 NULL



Select 	@fcha_crcn_ini 	 =	vlr	 
From 	#tbCriteriosTmp
Where 	cmpo_rlcn 	 = 	'fcha_crcn' 
And	oprdr	   	 = 	'>='


Select	@fcha_crcn_fn 	=	vlr	 
From 	#tbCriteriosTmp
Where 	cmpo_rlcn 		= 	'fcha_crcn' 
And	oprdr	    		= 	'<='


Select 	@cnsctvo_cdgo_sde 	 =	vlr	
From 	#tbCriteriosTmp
Where 	cdgo_cmpo 	 = 	'cnsctvo_cdgo_sde' 


-- Contador de condiciones


select    bdrecaudos.dbo.fnCalculaPeriodo (a.fcha_incl_prdo_lqdcn) 	prdo,
	  cnsctvo_cdgo_lqdcn
into 	  #tmpLiquidacionesFinalizadas
from 	  tbperiodosliquidacion_vigencias a, tbliquidaciones b
Where     a.cnsctvo_cdgo_prdo_lqdcn	=	b.cnsctvo_cdgo_prdo_lqdcn
And	  b.cnsctvo_cdgo_estdo_lqdcn	=	3
--select * from 		#tmpLiquidacionesFinalizadas
     
				
-- primero se hace para estados de cuenta

Select  nmro_unco_idntfccn_empldr,
	space(3) 	tpo_idntfccn,
	space(15) 	nmro_idntfccn,
	cnsctvo_cdgo_clse_aprtnte,
	cnsctvo_scrsl,
	a.cnsctvo_estdo_cnta,
	space(200)	nmbre_scrsl,
	a.nmro_estdo_cnta,
	0 		sde_crtra_pc,
	space(30)	cdgo_sde,
	space(100)	dscrpcn_sde,
	space(80)	drccn ,
	space(30)	tlfno,
	a.fcha_imprsn,
	a.usro_imprsn
into	#tmpDetEmpleador
from	TbestadosCuenta 		a, 
	TbEstadosCuentaContratos  	c,
	#tmpLiquidacionesFinalizadas  	d 
where	a.cnsctvo_estdo_cnta		=	c.cnsctvo_estdo_cnta
And	a.cnsctvo_cdgo_lqdcn		=	d.cnsctvo_cdgo_lqdcn	
And	1	=	2



Insert	into	#tmpDetEmpleador
SELECT  a.nmro_unco_idntfccn_empldr,
	null tpo_idntfccn,
	null nmro_idntfccn,
	a.cnsctvo_cdgo_clse_aprtnte,
	a.cnsctvo_scrsl,
	a.cnsctvo_estdo_cnta,
	b.nmbre_scrsl, a.nmro_estdo_cnta,	
	b.sde_crtra_pc,
	null cdgo_sde,
	null dscrpcn_sde,
	b.drccn ,
	b.tlfno,
	a.fcha_imprsn,
        a.usro_imprsn
FROM   tbestadosCuenta a,	
#tmpLiquidacionesFinalizadas d ,
bdafiliacion.dbo.tbSucursalesAportante  b
Where 	 a.cnsctvo_cdgo_lqdcn			=	d.cnsctvo_cdgo_lqdcn  
And	 a.cnsctvo_cdgo_estdo_estdo_cnta	!= 	4	 
And	 a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn_empldr  
And	 a.cnsctvo_cdgo_clse_aprtnte		=	b.cnsctvo_cdgo_clse_aprtnte  
And	 a.cnsctvo_scrsl			=	b.cnsctvo_scrsl     
And	(@cnsctvo_cdgo_sde  is null or (@cnsctvo_cdgo_sde is not null and b.sde_crtra_pc = @cnsctvo_cdgo_sde))
And	(@fcha_crcn_ini is null or convert(char(10),@fcha_crcn_ini,111) is not null and convert(char(10),a.fcha_imprsn,111)  between convert(char(10),@fcha_crcn_ini,111) and convert(char(10),@fcha_crcn_fn,111))
And 	a.imprso='S'



Update #tmpDetEmpleador
Set	tpo_idntfccn			=	c.cdgo_tpo_idntfccn,
        nmro_idntfccn			=	b.nmro_idntfccn
From	#tmpDetEmpleador a, 	bdafiliacion.dbo.tbvinculados  b ,
	bdafiliacion.dbo.tbtiposidentificacion 	c
Where   a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn
And	b.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn



----Para actualizar las sedes 
Update  #tmpDetEmpleador
Set	cdgo_sde			= c.cdgo_sde,
	dscrpcn_sde			= c.dscrpcn_sde
From	#tmpDetEmpleador a  	inner join bdAfiliacion.dbo.tbSucursalesAportante e
On 	a.nmro_unco_idntfccn_empldr	= e.nmro_unco_idntfccn_empldr
and	a.cnsctvo_cdgo_clse_aprtnte	= e.cnsctvo_cdgo_clse_aprtnte
and	a.cnsctvo_scrsl			= e.cnsctvo_scrsl 	
					inner join  bdAfiliacion.dbo.tbsedes c
On          e.sde_crtra_pc		=  c.cnsctvo_cdgo_sde	
where a.cdgo_sde is null and a.dscrpcn_sde is null


Select  * from #tmpDetEmpleador 

