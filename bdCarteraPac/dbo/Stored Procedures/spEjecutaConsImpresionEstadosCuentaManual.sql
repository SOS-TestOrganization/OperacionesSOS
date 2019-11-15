

---------------------------------------------------
/*---------------------------------------------------------------------------------
* Metodo o PRG 			: spEjecutaConsImpresionEstadosCuentaManual
* Desarrollado por		: <\A Ing. Fernando Valencia E								A\>
* Descripcion			: <\D Este procedimiento para generar el reporte del la fecha de impresion de estados de cuenta manual 	D\>
* Observaciones			: <\O  														O\>
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
CREATE PROCEDURE [dbo].[spEjecutaConsImpresionEstadosCuentaManual]

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



Select 	@fcha_crcn_ini 	 =	vlr	+' 00:00:00' 
From 	#tbCriteriosTmp
Where 	cmpo_rlcn 	 = 	'fcha_crcn' 
And	oprdr	   	 = 	'>='


Select	@fcha_crcn_fn 	=	vlr	+' 23:59:59' 
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
		space(3) 	tpo_idntfccn, -- Se cambio tamaño por migracion
		space(20) 	nmro_idntfccn, -- se cambio tamaño por migracion
		cnsctvo_cdgo_clse_aprtnte,
		cnsctvo_scrsl,
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
from	TbCuentasManuales 		a, 
		tbCuentasManualesContrato  	c,
		#tmpLiquidacionesFinalizadas  	d 
where	a.nmro_estdo_cnta		=	c.nmro_estdo_cnta
And		a.cnsctvo_cdgo_prdo_lqdcn	=	d.cnsctvo_cdgo_lqdcn	
And		1	=	2


Insert	into	#tmpDetEmpleador
SELECT  a.nmro_unco_idntfccn_empldr,
	null tpo_idntfccn,
	null nmro_idntfccn,
	a.cnsctvo_cdgo_clse_aprtnte,
	a.cnsctvo_scrsl,
	b.nmbre_scrsl, 
	a.nmro_estdo_cnta,	
	b.sde_crtra_pc,
	null cdgo_sde,
	null dscrpcn_sde,
	b.drccn ,
	b.tlfno,
	a.fcha_imprsn,
        a.usro_imprsn
FROM   tbCuentasManuales a,	
#tmpLiquidacionesFinalizadas d ,
bdafiliacion.dbo.tbSucursalesAportante  b
Where 	 a.cnsctvo_cdgo_prdo_lqdcn		=	d.cnsctvo_cdgo_lqdcn  
And	 a.cnsctvo_cdgo_estdo_estdo_cnta	!= 	4	 
And	 a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn_empldr  
And	 a.cnsctvo_cdgo_clse_aprtnte		=	b.cnsctvo_cdgo_clse_aprtnte  
And	 a.cnsctvo_scrsl			=	b.cnsctvo_scrsl     
And	(@cnsctvo_cdgo_sde  is null or (@cnsctvo_cdgo_sde is not null and b.sde_crtra_pc = @cnsctvo_cdgo_sde))
And	(@fcha_crcn_ini is null or (@fcha_crcn_ini is not null and a.fcha_imprsn  between @fcha_crcn_ini and @fcha_crcn_fn))


Update #tmpDetEmpleador
Set	tpo_idntfccn			=	ltrim(rtrim(c.cdgo_tpo_idntfccn)),
        nmro_idntfccn			=	ltrim(rtrim(b.nmro_idntfccn))
From	#tmpDetEmpleador a, 	bdafiliacion.dbo.tbvinculados  b ,
	bdafiliacion.dbo.tbtiposidentificacion 	c
Where   a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn
And	b.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn



----Para actualizar las sedes 
Update  #tmpDetEmpleador
Set	cdgo_sde			= ltrim(rtrim(c.cdgo_sde)),
	dscrpcn_sde			= ltrim(rtrim(c.dscrpcn_sde))
From	#tmpDetEmpleador a  	inner join bdAfiliacion.dbo.tbSucursalesAportante e
On 	a.nmro_unco_idntfccn_empldr	= e.nmro_unco_idntfccn_empldr
and	a.cnsctvo_cdgo_clse_aprtnte	= e.cnsctvo_cdgo_clse_aprtnte
and	a.cnsctvo_scrsl			= e.cnsctvo_scrsl 	
					inner join  bdAfiliacion.dbo.tbsedes c
On          e.sde_crtra_pc		=  c.cnsctvo_cdgo_sde	
where a.cdgo_sde is null and a.dscrpcn_sde is null


Select  * from #tmpDetEmpleador 


