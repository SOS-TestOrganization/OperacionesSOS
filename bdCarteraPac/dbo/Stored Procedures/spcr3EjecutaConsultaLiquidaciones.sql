

/*---------------------------------------------------------------------------------
* Metodo o PRG		: spcr1EjecutaConsultaLiquidaciones
* Desarrollado por	: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion		: <\D Este procedimiento selecciona las liquidaciones con base	D\>
*			  <\D en los parámetros ingresados				D\>
* Observaciones		: <\O  								O\>
* Parametros		: <\P Consecutivo estado liquidación				P\>
* Variables		: <\V								V\>
* Fecha Creacion	: <\FC 2003/02/10						FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por	: <\AM	Ing. Jorge Ivan Rivera Gallego				AM\>
* Descripcion		: <\DM	Se modifica el spEjecutaConsultaLiquidaciones por el	DM\>
*			  <\DM	proceso de optimización técnica.			DM\>
* Nuevos Parametros	: <\PM	PM\>
* Nuevas Variables	: <\VM	VM\>
* Fecha Modificacion	: <\FM	2005/08/31						FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE spcr3EjecutaConsultaLiquidaciones
@ldFechaCreacionDesde Datetime,
@ldFechaCreacionHasta Datetime

As

Set Nocount On

Select	a.cnsctvo_cdgo_lqdcn,		d.dscrpcn_tpo_prcso,
	c.dscrpcn_estdo_lqdcn,		a.vlr_lqddo,
	a.nmro_cntrts,			a.nmro_estds_cnta,
	b.fcha_incl_prdo_lqdcn,		b.fcha_fnl_prdo_lqdcn,
	a.usro_crcn,			d.cnsctvo_cdgo_tpo_prcso,
	c.cnsctvo_cdgo_estdo_lqdcn,	a.obsrvcns
From	bdCarteraPac.dbo.tbLiquidaciones a Inner Join
	bdCarteraPac.dbo.tbTipoProceso d
On	a.cnsctvo_cdgo_tpo_prcso	= d.cnsctvo_cdgo_tpo_prcso Inner Join
	bdCarteraPac.dbo.tbEstadosLiquidacion c
On	a.cnsctvo_cdgo_estdo_lqdcn	= c.cnsctvo_cdgo_estdo_lqdcn Inner Join
	bdCarteraPac.dbo.tbPeriodosliquidacion_Vigencias b
On	a.cnsctvo_cdgo_prdo_lqdcn	= b.cnsctvo_cdgo_prdo_lqdcn
Where	DateDiff(Day,@ldFechaCreacionDesde,a.fcha_crcn)	>= 0
And	Datediff(Day,a.fcha_crcn,@ldFechaCreacionHasta)	>= 0
				


