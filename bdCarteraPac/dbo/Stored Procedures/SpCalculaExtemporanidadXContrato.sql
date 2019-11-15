/*---------------------------------------------------------------------------------
* Metodo o PRG 		: SpCalculaExtemporanidadXContrato
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento Calcula la extempranidad de un contrato						D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003/02/10											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  FM\>
*---------------------------------------------------------------------------------*/
CREATE  PROCEDURE SpCalculaExtemporanidadXContrato
		@ldFechaReferencia	datetime
			
As	


Set nocount on


--Trae la informacion de las facturas de un detrminado periodo
SELECT a.nmro_estdo_cnta,	 		a.cnsctvo_estdo_cnta,
 	 h.fcha_incl_prdo_lqdcn,	 h.fcha_fnl_prdo_lqdcn
into 	 #tmpEstadosCuenta
FROM	tbEstadosCuenta a , tbliquidaciones g,
	tbPeriodosliquidacion_Vigencias h 	
Where 	a.cnsctvo_cdgo_lqdcn 		= 	g.cnsctvo_cdgo_lqdcn
And	g.cnsctvo_cdgo_prdo_lqdcn 	=	h.cnsctvo_cdgo_prdo_lqdcn
and	g.cnsctvo_cdgo_estdo_lqdcn	=	3
And	@ldFechaReferencia	between 	h.fcha_incl_prdo_lqdcn	and	h.fcha_fnl_prdo_lqdcn


-- se crea una tabla temporal con al infromacion 
Select 	cnsctvo_cdgo_tpo_cntrto, nmro_cntrto, 'N'	extmprno ,case when sldo > 0 then 	'S' else 'N' end mra,
	cnsctvo_estdo_cnta_cntrto,
	a.cnsctvo_estdo_cnta, 0	cnsctvo_cdgo_pgo
into	#TmpestadosCuentacontratos
From	#tmpEstadosCuenta a, tbestadosCuentacontratos b
Where	a.cnsctvo_estdo_cnta	=	b.cnsctvo_estdo_cnta

--calcula el  ultimo pago para esa factura porque de lo contrario si tiene pagos estaria en mora para esos periodos
select  max(a.cnsctvo_cdgo_pgo) cnsctvo_cdgo_pgo , a.cnsctvo_estdo_cnta_cntrto
into	#TmpPagosContrato
From 	tbabonosContrato a, #TmpestadosCuentacontratos b
Where	a.cnsctvo_estdo_cnta_cntrto	=	b.cnsctvo_estdo_cnta_cntrto
Group by a.cnsctvo_estdo_cnta_cntrto

--se actualiza el pago
update #TmpestadosCuentacontratos
Set	cnsctvo_cdgo_pgo	=	a.cnsctvo_cdgo_pgo
From	#TmpPagosContrato a,	#TmpestadosCuentacontratos b
Where	a.cnsctvo_estdo_cnta_cntrto	=	b.cnsctvo_estdo_cnta_cntrto

--se actualiza la  extemporanidad
Update 	#TmpestadosCuentacontratos
Set	extmprno	=	b.extmprno
From	#TmpestadosCuentacontratos a,	tbabonos b
Where 	a.cnsctvo_estdo_cnta	=	b.cnsctvo_estdo_cnta
And	a.cnsctvo_cdgo_pgo	=	b.cnsctvo_cdgo_pgo


--actualiza la tabla temporal que ya debe existir antes de entrar al sp.
Update #tmpContratosExtemporanos
Set	extmprno	=	b.extmprno,
	mra		=	b.mra
FRom	#tmpContratosExtemporanos a, #TmpestadosCuentacontratos b
Where 	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto