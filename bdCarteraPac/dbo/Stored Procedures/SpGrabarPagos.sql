/*---------------------------------------------------------------------------------
* Metodo o PRG 		:  SpGrabarPagos
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento grabar los pagos que existen en tesoreria						D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003/03/04											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
QUICK									Analista			Descripcion
2014-00001-000002492		sismpr01			El sistema debe respetar la marca de pago extemporáneo del primer pago por ejm: si el primer pago tiene extemporaneo igual a N. 
																	Cuando ingrese el pago del ajuste, si este es menor a $10.000 debe dejarlo en estado N asi sea extemporaneo.
																	2014/01/29
*---------------------------------------------------------------------------------*/
CREATE                PROCEDURE [dbo].[SpGrabarPagos]
	@lnTipoProceso					int,
	@Max_cnsctvo_prcso				udtConsecutivo	output, 
	@lcUsuario						udtUsuario,
	@CantidadPagos					int		output,
	@ValorTotalPagos				udtValorGrande	output,
	@CantidadRegistrosAplicados		int		output,
	@CantidadRegistrosNoaplicados	int		output,
	@lnProcesoExitoso				int		output,
	@lcMensaje						char(200)	output
	

As	Declare
@Fecha_Inicio_Proceso					Datetime,
@Fecha_Fin_Proceso						Datetime,
@ldFechaSistema							Datetime,
@max_cnsctvo_cdgo_pgo					int,
@MaximoConsecutivoContrato				int,
@MaximoConsecutivoResponsable			int,
@maximoConsecutivoPagoConcepto			int,
@Tipo_Presentacion_Estado_Cuenta		int,
@Tipo_Presentacion_Nota_Debito			int,
@Tipo_nota_Debito						int,
@Estado_Pago_Aplicado_Total				int,
@cnsctvo_hstrco_estdo_pgo				int,
@lconsecutivoliquidacion				int,
@lcestadoactual							int,
@Valor_Porcentaje_Iva int

SET NOCOUNT ON
  

Set	@lnProcesoExitoso			=	0
Set	@Tipo_Presentacion_Estado_Cuenta	=	8
Set	@Tipo_Presentacion_Nota_Debito		=	11
Set	@Tipo_nota_Debito			=	1
Set	@Estado_Pago_Aplicado_Total		=	3

--Se conculta el maximo consecutivo del proceso
Select	@Max_cnsctvo_prcso		=	isnull(cnsctvo_prcso,0)	+	1
From	TbProcesosCarteraPac

Set	@Fecha_Inicio_Proceso		=	Getdate()
Set	@ldFechaSistema		=	Getdate()


set	@CantidadPagos				=	0
set	@ValorTotalPagos				=	0
set	@CantidadRegistrosAplicados			=	0
set	@CantidadRegistrosNoaplicados			=	0



Select	@Valor_Porcentaje_Iva	=  convert(int,prcntje)
From	bdCarteraPac.dbo.tbConceptosLiquidacion_Vigencias
Where	cnsctvo_cdgo_cncpto_lqdcn	= 3
And	getdate()	Between inco_vgnca And 	fn_vgnca

----------------------------------------------------------
-- Para controlar que no se puedan grabar pagos  mientas se tenga una liquidacion de prueba
select  @lconsecutivoliquidacion= max(cnsctvo_Cdgo_lqdcn) 
from tbLiquidaciones

select  @lcestadoactual=cnsctvo_cdgo_estdo_lqdcn 
from tbLiquidaciones
where cnsctvo_Cdgo_lqdcn=@lconsecutivoliquidacion


if	@lcestadoactual	in (5,6)
	Begin 
	  Set	@lnProcesoExitoso	=	1
	  Set	@lcMensaje		=	'Existe una liquidación de pruebas y no se puede grabar el pago'
	  Return -1
end	

Begin Tran 


---------------------------------------------------------------------------


--graba el consecutivo del proceso
Insert	into TbProcesosCarteraPac Values
		(@Max_cnsctvo_prcso,
		@lnTipoProceso,
		@Fecha_Inicio_Proceso,
		NULL,
		@lcUsuario)

If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error Insertando el inicio del proceso'
		Rollback tran 
		Return -1
	end


--traer la informacion de  los pagos de planes complementarios donde no sean pasado al modulo  de cartera..
--drop table #tmpPagosPac
select  	IDENTITY(Int, 1 ,1) 	AS		nmro_rgstro ,
	a.cnsctvo_rcdo_cncldo,
	a.nmro_dcmnto,
	a.fcha_rcdo,
             a.vlr_dcmnto,
	a.nmro_lna,
	a.nmro_rmsa,
	a.prdo_rmsa,
	1	 cnsctvo_cdgo_estdo_pgo,  -- por defecto deben estar sin aplicar
	2	cnsctvo_cdgo_tpo_pgo, -- por defecto todos son manuales,
	0	cnsctvo_cdgo_pgo,	--consecutivo del pago que se actualiza mas adelante
	a.vlr_dcmnto	sldo_pgo,
	a.cnsctvo_cdgo_tpo_prsntcn,	-- si es estado de cuenta = 8 y si es nota debito = 11
	0	nmro_unco_idntfccn_empldr,
	0	cnsctvo_scrsl,
	0	cnsctvo_cdgo_clse_aprtnte,
	0	Automatico,
   0 Mrca
into 	#tmpPagosPac
from 	bdAdmonRecaudo..tbRecaudoConciliado a ,  bdAdmonRecaudo..tbRemesasConciliadas b
where	a.trspso_crtra_pc ='N'
and	a.cnsctvo_cdgo_tps_dcmnto		=	2	--pagos pac
and	(a.cnsctvo_cdgo_estdo_rcdo_cncldo	<>	3	and 	a.cnsctvo_cdgo_estdo_rcdo_cncldo <> 5 )  	--estado anulado
And	a.nmro_rmsa				=	b.nmro_rmsa		
And	a.prdo_rmsa				=	b.prdo_rmsa
And	a.cnsctvo_cdgo_tpo_prsntcn		=	b.cnsctvo_cdgo_tpo_prsntcn
And	b.cnsctvo_cdgo_estdo_rmsa 		=	 5		-- Revisada
And	a.nmro_rmsa				>	0
And	convert(varchar(15),a.nmro_dcmnto)		!=	'0'
--and	a.fcha_rcdo				<=		'20040831'

 
--Se debe de actualizar los campos del responsabel del pago
--para cuando el pago hace referencia a un estado de cuenta

Update   #tmpPagosPac
Set	nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl			=	b.cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
From	#tmpPagosPac	a,	tbEstadosCuenta	b
Where	ltrim(rtrim(b.nmro_estdo_cnta))	=	ltrim(rtrim(a.nmro_dcmnto))
And	a.cnsctvo_cdgo_tpo_prsntcn	= 	@Tipo_Presentacion_Estado_Cuenta

--Se debe de actualizar los campos del responsabel del pago
--para cuando el pago hace referencia a un estado de cuenta manual
Update   #tmpPagosPac
Set	nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl			=	b.cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
From	#tmpPagosPac	a,	tbcuentasManuales	b
Where	b.nmro_estdo_cnta		=	a.nmro_dcmnto
And	a.cnsctvo_cdgo_tpo_prsntcn	=  @Tipo_Presentacion_Estado_Cuenta


--Se debe de actualizar los campos del responsabel del pago
--para cuando el pago hace referencia a una nota debito

Update  #tmpPagosPac
Set	nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl			=	b.cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
From	#tmpPagosPac	a,	TbNotasPac	b
Where	b.nmro_nta			=	a.nmro_dcmnto
And	b.cnsctvo_cdgo_tpo_nta		=  @Tipo_nota_Debito
And	a.cnsctvo_cdgo_tpo_prsntcn	= @Tipo_Presentacion_Nota_Debito


--Se actualiza cuales registros van a cruzar automaticos
-- es decir que es el mismo numero de documento y el valor a pagar
Update 	#tmpPagosPac
Set	Automatico	=	1
From	#tmpPagosPac	a, 	TbEstadosCuenta b
where 	ltrim(rtrim(a.nmro_dcmnto))	=	ltrim(rtrim(b.nmro_estdo_cnta))
And	a.vlr_dcmnto			=	b.ttl_pgr
And	a.cnsctvo_cdgo_tpo_prsntcn	=	@Tipo_Presentacion_Estado_Cuenta
And	b.sldo_antrr 			=	0
And	b.sldo_estdo_cnta		>	0
And	(b.ttl_fctrdo +  b.vlr_iva)     	=       	b.sldo_estdo_cnta


--- Nueva Condicion # 1 para Aplicacion de PAGOS 

/*update #tmpPagosPac set Automatico	=	0,
        Mrca = 0*/

insert into  bdcarterapac.dbo.tmppagosautomaticosPAC 
select 1 as nmro_rgstro ,
	a.cnsctvo_rcdo_cncldo,
	a.nmro_dcmnto,
	a.fcha_rcdo,
    a.vlr_dcmnto,
	a.nmro_lna,
	a.nmro_rmsa,
	a.prdo_rmsa,
	a.cnsctvo_cdgo_estdo_pgo,  -- por defecto deben estar sin aplicar
	a.cnsctvo_cdgo_tpo_pgo, -- por defecto todos son manuales,
	a.cnsctvo_cdgo_pgo,	--consecutivo del pago que se actualiza mas adelante
	a.sldo_pgo,
	a.cnsctvo_cdgo_tpo_prsntcn,	-- si es estado de cuenta = 8 y si es nota debito = 11
	a.nmro_unco_idntfccn_empldr,
	a.cnsctvo_scrsl,
	a.cnsctvo_cdgo_clse_aprtnte,
    1    as automatico --,
--  ti.cdgo_tpo_idntfccn,
--v.nmro_idntfccn
from #tmpPagosPac	a inner join 	TbEstadosCuenta b
on 	ltrim(rtrim(a.nmro_dcmnto))	=	ltrim(rtrim(b.nmro_estdo_cnta))
And	a.vlr_dcmnto			=	b.sldo_estdo_cnta
/*inner join bdafiliacion.dbo.tbvinculados v on
a.nmro_unco_idntfccn_empldr = v.nmro_unco_idntfccn
inner join bdafiliacion.dbo.tbtiposidentificacion ti
on v.cnsctvo_cdgo_tpo_idntfccn = ti.cnsctvo_cdgo_tpo_idntfccn*/
where 	a.cnsctvo_cdgo_tpo_prsntcn	=	@Tipo_Presentacion_Estado_Cuenta
And	b.sldo_antrr 			=	0
And	b.sldo_estdo_cnta		>	0
And a.automatico = 0

/*
select a.*, ti.cdgo_tpo_idntfccn, v.nmro_idntfccn from #tmppagossegundacondicion a inner join bdafiliacion.dbo.tbvinculados v
on a.nmro_unco_idntfccn_empldr = v.nmro_unco_idntfccn
inner join bdafiliacion.dbo.tbtiposidentificacion ti
on v.cnsctvo_cdgo_tpo_idntfccn = ti.cnsctvo_cdgo_tpo_idntfccn*/


Update 	#tmpPagosPac
Set	Automatico	=	1,
        Mrca = 1
From	#tmpPagosPac	a, 	TbEstadosCuenta b
where 	ltrim(rtrim(a.nmro_dcmnto))	=	ltrim(rtrim(b.nmro_estdo_cnta))
And	a.vlr_dcmnto			=	b.sldo_estdo_cnta
And	a.cnsctvo_cdgo_tpo_prsntcn	=	@Tipo_Presentacion_Estado_Cuenta
And	b.sldo_antrr 			=	0
And	b.sldo_estdo_cnta		>	0
and Automatico	=	0



insert into  bdcarterapac.dbo.tmppagosautomaticosPAC 
select 2 as nmro_rgstro ,
	a.cnsctvo_rcdo_cncldo,
	a.nmro_dcmnto,
	a.fcha_rcdo,
    a.vlr_dcmnto,
	a.nmro_lna,
	a.nmro_rmsa,
	a.prdo_rmsa,
	a.cnsctvo_cdgo_estdo_pgo,  -- por defecto deben estar sin aplicar
	a.cnsctvo_cdgo_tpo_pgo, -- por defecto todos son manuales,
	a.cnsctvo_cdgo_pgo,	--consecutivo del pago que se actualiza mas adelante
	a.sldo_pgo,
	a.cnsctvo_cdgo_tpo_prsntcn,	-- si es estado de cuenta = 8 y si es nota debito = 11
	a.nmro_unco_idntfccn_empldr,
	a.cnsctvo_scrsl,
	a.cnsctvo_cdgo_clse_aprtnte,
    1    as automatico --,
 --  ti.cdgo_tpo_idntfccn,
  -- v.nmro_idntfccn
from #tmpPagosPac	a inner join 	TbEstadosCuenta b
on 	ltrim(rtrim(a.nmro_dcmnto))	=	ltrim(rtrim(b.nmro_estdo_cnta))
And	a.vlr_dcmnto			>  b.ttl_pgr
/*inner join bdafiliacion.dbo.tbvinculados v on
a.nmro_unco_idntfccn_empldr = v.nmro_unco_idntfccn
inner join bdafiliacion.dbo.tbtiposidentificacion ti
on v.cnsctvo_cdgo_tpo_idntfccn = ti.cnsctvo_cdgo_tpo_idntfccn*/
where 	(a.vlr_dcmnto		- b.ttl_pgr) between 1 and 769
and a.cnsctvo_cdgo_tpo_prsntcn	=	@Tipo_Presentacion_Estado_Cuenta
And	b.sldo_antrr 			=	0
And	b.sldo_estdo_cnta		>	0
and Automatico	=	0


Update 	#tmpPagosPac
Set	Automatico	=	1,
        Mrca = 2
From	#tmpPagosPac	a inner join 	TbEstadosCuenta b
on 	ltrim(rtrim(a.nmro_dcmnto))	=	ltrim(rtrim(b.nmro_estdo_cnta))
And	a.vlr_dcmnto			>  b.ttl_pgr
where 	(a.vlr_dcmnto		- b.ttl_pgr) between 1 and 769
and a.cnsctvo_cdgo_tpo_prsntcn	=	@Tipo_Presentacion_Estado_Cuenta
And	b.sldo_antrr 			=	0
And	b.sldo_estdo_cnta		>	0
and Automatico	=	0


select ltrim(rtrim(a.nmro_dcmnto)) as nmro_estdo_cnta, c.cnsctvo_estdo_cnta, count(nmro_cntrto) as cantidad  
into #tmpPagosConMasContratos
from 	#tmpPagosPac	a
inner join dbo.tbestadoscuenta b
on 	ltrim(rtrim(a.nmro_dcmnto))	=	ltrim(rtrim(b.nmro_estdo_cnta))
inner join dbo.tbestadoscuentacontratos c
on b.cnsctvo_estdo_cnta = c.cnsctvo_estdo_cnta
where  Mrca = 2
group by ltrim(rtrim(a.nmro_dcmnto))  , c.cnsctvo_estdo_cnta
having count(nmro_cntrto)  > 1


Update 	#tmpPagosPac
Set	Automatico	=	0,
        Mrca = 0
from 	#tmpPagosPac	a inner join #tmpPagosConMasContratos b
on ltrim(rtrim(a.nmro_dcmnto))	=	ltrim(rtrim(b.nmro_estdo_cnta))
where a.Mrca = 2



/*"Numero de documento en el pago = Numero de estado de cuenta
Total pago > Total a Pagar en el estado de cuenta
Valor de Tolerancia : La diferencia entre el valor del pago y el total a pagar  debe ser entre 1 y 769 pesos este valor se determino ya que la diferencia entre el valor del plan familiar (grupo basico + trabajador) y el plan bienestar (persona menor de 60 años) ambos con POS en SOS es de 770 por este motivo no puede aceptarse una tolerancia por un valor mayor.
Saldo anterior para el estado de cuenta = 0
Saldo del estado de cuenta > 0
El estado de cuenta debe tener solo un contrato asociado."
*/

--actualiza los estados de cuenta que cruzaron a cancelado total

Update  TbEstadosCuenta
Set	cnsctvo_cdgo_estdo_estdo_cnta	=	3, --Cancelada total
	sldo_estdo_cnta			= sldo_estdo_cnta	- vlr_dcmnto  -- actualiza el saldo del documento
From	TbEstadosCuenta a , #tmpPagosPac b
Where   a.ttl_pgr				=	b.vlr_dcmnto
And	ltrim(rtrim(a.nmro_estdo_cnta))	=	ltrim(rtrim(b.nmro_dcmnto))
And	b.cnsctvo_cdgo_tpo_prsntcn	=	@Tipo_Presentacion_Estado_Cuenta
And	a.sldo_antrr 			=	0
And	a.sldo_estdo_cnta		>	0
And	b.Automatico			=	1
And  b.Mrca = 0


Update  TbEstadosCuenta
Set	cnsctvo_cdgo_estdo_estdo_cnta	=	3, --Cancelada total
	sldo_estdo_cnta			= sldo_estdo_cnta	- vlr_dcmnto  -- actualiza el saldo del documento
From	TbEstadosCuenta a , #tmpPagosPac b
Where  b.vlr_dcmnto			=	a.sldo_estdo_cnta
And	ltrim(rtrim(a.nmro_estdo_cnta))	=	ltrim(rtrim(b.nmro_dcmnto))
And	b.cnsctvo_cdgo_tpo_prsntcn	= 	@Tipo_Presentacion_Estado_Cuenta
And	a.sldo_antrr 			=	0
And	a.sldo_estdo_cnta		>	0
And	b.Automatico			=	1
And  b.Mrca = 1

Update  TbEstadosCuenta
Set	cnsctvo_cdgo_estdo_estdo_cnta	=	3, --Cancelada total
	sldo_estdo_cnta			= sldo_estdo_cnta	- vlr_dcmnto  -- actualiza el saldo del documento
From	TbEstadosCuenta a , #tmpPagosPac b
Where   b.vlr_dcmnto			>  a.ttl_pgr
And	ltrim(rtrim(a.nmro_estdo_cnta))	=	ltrim(rtrim(b.nmro_dcmnto))
and (b.vlr_dcmnto - a.ttl_pgr) between 1 and 769
And	b.cnsctvo_cdgo_tpo_prsntcn	=	@Tipo_Presentacion_Estado_Cuenta
And	a.sldo_antrr 			=	0
--And	a.sldo_estdo_cnta		>	0
And	b.Automatico			=	1
And  b.Mrca = 2

--actualiza los pagos que cruzaron a aplicado total
-- y automatico
Update #tmpPagosPac
Set	cnsctvo_cdgo_estdo_pgo	=	3,  --aplicado total
	cnsctvo_cdgo_tpo_pgo		=	1,   -- automatico	
	sldo_pgo			=	0  -- elsaldo se actualiza a cero	
From	TbEstadosCuenta a , #tmpPagosPac b
Where   a.ttl_pgr				=	b.vlr_dcmnto
And	ltrim(rtrim(a.nmro_estdo_cnta))	=	ltrim(rtrim(b.nmro_dcmnto))
And	b.cnsctvo_cdgo_tpo_prsntcn	= @Tipo_Presentacion_Estado_Cuenta
And	a.sldo_antrr 			=	0
And	b.Automatico			=	1
And b.Mrca = 0

Update #tmpPagosPac
Set	cnsctvo_cdgo_estdo_pgo	=	3,  --aplicado total
	cnsctvo_cdgo_tpo_pgo		=	1,   -- automatico	
	sldo_pgo			=	0  -- elsaldo se actualiza a cero	
From	TbEstadosCuenta a , #tmpPagosPac b
Where  ltrim(rtrim(a.nmro_estdo_cnta))	=	ltrim(rtrim(b.nmro_dcmnto))
And	b.cnsctvo_cdgo_tpo_prsntcn	=	 @Tipo_Presentacion_Estado_Cuenta
And	a.sldo_antrr 			=	0
And	b.Automatico			=	1
And b.Mrca  in (1,2)


/*
Update #tmpPagosPac
Set	cnsctvo_cdgo_estdo_pgo	=	3,  --aplicado total
	cnsctvo_cdgo_tpo_pgo		=	1,   -- automatico	
	sldo_pgo			= 0 -- elsaldo se actualiza a cero	
From	TbEstadosCuenta a , #tmpPagosPac b
Where   b.vlr_dcmnto			>  a.ttl_pgr
And	ltrim(rtrim(a.nmro_estdo_cnta))	=	ltrim(rtrim(b.nmro_dcmnto))
and (b.vlr_dcmnto - a.ttl_pgr) between 1 and 769
And	b.cnsctvo_cdgo_tpo_prsntcn	=	@Tipo_Presentacion_Estado_Cuenta
And	a.sldo_antrr 			=	0
--And a.sldo_estdo_cnta		>	0
And	b.Automatico			=	1
And b.Mrca = 2
*/




Select	@CantidadPagos		=  isnull( count(*),0),
	@ValorTotalPagos		=  isnull(sum(vlr_dcmnto)	,0)
From	#tmpPagosPac

Select 	@CantidadRegistrosAplicados	= isnull(count(*),0)
From	#tmpPagosPac		
Where  cnsctvo_cdgo_estdo_pgo		=	3

Select 	@CantidadRegistrosNoaplicados	= isnull(count(*),0)
From	#tmpPagosPac		
Where  cnsctvo_cdgo_estdo_pgo		=	1

	
Select 	@max_cnsctvo_cdgo_pgo	=	isnull(max(cnsctvo_cdgo_pgo),0)
From	Tbpagos


Insert into Tbpagos
Select 	(@max_cnsctvo_cdgo_pgo	+	nmro_rgstro),
	cnsctvo_cdgo_estdo_pgo,
	cnsctvo_cdgo_tpo_pgo,
	@ldFechaSistema,
	case when cnsctvo_cdgo_estdo_pgo  =  3   then   @ldFechaSistema   else  Null end,   -- los registros que fueron aplicados se guarda la fecha de aplicacion de lo contrario le asigna null
	case when cnsctvo_cdgo_estdo_pgo  =  3   then   @lcUsuario   else  Null end,   -- los registros que fueron aplicados se guarda la fecha de aplicacion de lo contrario le asigna null
	@lcUsuario,
	cnsctvo_rcdo_cncldo,
	fcha_rcdo,
	nmro_dcmnto,
	vlr_dcmnto,
	nmro_rmsa,
	prdo_rmsa,
	nmro_lna,
	@Max_cnsctvo_prcso,	--se inserta consecutivo del proceso 
	sldo_pgo,
	cnsctvo_cdgo_tpo_prsntcn,	-- tipo de presentacion si es estado de cuenta o nota debito
	nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte,
	Null
From	#tmpPagosPac 

 

If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error insertando la informacion de los pagos '
		Rollback tran 
		Return -1
	end


--Se actualiza  el consecutivo del pago
Update #tmpPagosPac
Set	cnsctvo_cdgo_pgo	=	b.cnsctvo_cdgo_pgo
From	#tmpPagosPac  a,   Tbpagos  b
Where   a.cnsctvo_rcdo_cncldo	=	b.cnsctvo_rcdo_cncldo


--Se calcula el maximo consecutivo del pago
Select	@cnsctvo_hstrco_estdo_pgo	=	isnull(max(cnsctvo_hstrco_estdo_pgo),0)
From	TbHistoricoEstadoXPago


--- se inserta la historia  de los estados del pago
insert	into	TbHistoricoEstadoXPago
Select 	(@cnsctvo_hstrco_estdo_pgo	+	nmro_rgstro),
	cnsctvo_cdgo_estdo_pgo,
	cnsctvo_cdgo_pgo,
	sldo_pgo,
	nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte,
	@lcUsuario,
	@ldFechaSistema,
	Null
From	#tmpPagosPac 


If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error insertando la historia del estado del pago'
		Rollback tran 
		Return -1
	end

-- Inicia Ajuste 2014-00001-000002492

--Se inserta la informacion de los abonos y se verifica si el pago es estemporaneo o no

Select 	b.cnsctvo_cdgo_pgo,
	a.cnsctvo_estdo_cnta,
	b.vlr_dcmnto vlr_abno,
		case when fcha_rcdo > fcha_mxma_pgo  and d.cnsctvo_cdgo_prdo_lqdcn < = 162 then 'S' 
		 when fcha_rcdo > dateadd(dd,1,fcha_mxma_pgo) and d.cnsctvo_cdgo_prdo_lqdcn > 162 then 'S' 
    else 'N' end extmprno
Into		#tmpInsertaAbonos
From	TbEstadosCuenta a ,	 #tmpPagosPac b,
	TbPeriodosliquidacion_vigencias	c,
	Tbliquidaciones	d
Where   a.ttl_pgr				=	b.vlr_dcmnto
And	ltrim(rtrim(a.nmro_estdo_cnta))	=	ltrim(rtrim(b.nmro_dcmnto))
And	a.sldo_antrr 			=	0
And	c.cnsctvo_cdgo_prdo_lqdcn	=	d.cnsctvo_cdgo_prdo_lqdcn
And	d.cnsctvo_cdgo_lqdcn		=	a.cnsctvo_cdgo_lqdcn
And	b.cnsctvo_cdgo_tpo_prsntcn	= 8--	@Tipo_Presentacion_Estado_Cuenta
And	b.Automatico			=	1
and b.mrca = 0

Insert	Into		#tmpInsertaAbonos
Select 	b.cnsctvo_cdgo_pgo,		a.cnsctvo_estdo_cnta,		b.vlr_dcmnto vlr_abno,
	case when fcha_rcdo > fcha_mxma_pgo  and d.cnsctvo_cdgo_prdo_lqdcn < = 162 then 'S' 
		 when fcha_rcdo > dateadd(dd,1,fcha_mxma_pgo) and d.cnsctvo_cdgo_prdo_lqdcn > 162 then 'S' 
    else 'N' end extmprno
From	TbEstadosCuenta a ,	 #tmpPagosPac b,
	TbPeriodosliquidacion_vigencias	c,
	Tbliquidaciones	d
Where  	ltrim(rtrim(b.nmro_dcmnto))	=	ltrim(rtrim(a.nmro_estdo_cnta))
--And	b.vlr_dcmnto			=	a.sldo_estdo_cnta
And	a.sldo_antrr 			=	0
And	c.cnsctvo_cdgo_prdo_lqdcn	=	d.cnsctvo_cdgo_prdo_lqdcn
And	d.cnsctvo_cdgo_lqdcn		=	a.cnsctvo_cdgo_lqdcn
And	b.cnsctvo_cdgo_tpo_prsntcn	= 8--@Tipo_Presentacion_Estado_Cuenta
And	b.Automatico			=	1
and b.mrca in (1,2)


/*
insert  into tbabonos
Select 	b.cnsctvo_cdgo_pgo,
	a.cnsctvo_estdo_cnta,
	b.vlr_dcmnto,
		case when fcha_rcdo > fcha_mxma_pgo  and d.cnsctvo_cdgo_prdo_lqdcn < = 162 then 'S' 
		 when fcha_rcdo > dateadd(dd,1,fcha_mxma_pgo) and d.cnsctvo_cdgo_prdo_lqdcn > 162 then 'S' 
    else 'N' end,
	Null
From	TbEstadosCuenta a ,	 #tmpPagosPac b,
	TbPeriodosliquidacion_vigencias	c,
	Tbliquidaciones	d
Where   a.ttl_pgr				=	b.vlr_dcmnto
And	ltrim(rtrim(a.nmro_estdo_cnta))	=	ltrim(rtrim(b.nmro_dcmnto))
And	a.sldo_antrr 			=	0
And	c.cnsctvo_cdgo_prdo_lqdcn	=	d.cnsctvo_cdgo_prdo_lqdcn
And	d.cnsctvo_cdgo_lqdcn		=	a.cnsctvo_cdgo_lqdcn
And	b.cnsctvo_cdgo_tpo_prsntcn	= 8--	@Tipo_Presentacion_Estado_Cuenta
And	b.Automatico			=	1
and b.mrca = 0


insert  into tbabonos
Select 	b.cnsctvo_cdgo_pgo,
	a.cnsctvo_estdo_cnta,
	b.vlr_dcmnto,
	case when fcha_rcdo > fcha_mxma_pgo  and d.cnsctvo_cdgo_prdo_lqdcn < = 162 then 'S' 
		 when fcha_rcdo > dateadd(dd,1,fcha_mxma_pgo) and d.cnsctvo_cdgo_prdo_lqdcn > 162 then 'S' 
    else 'N' end,
	Null
From	TbEstadosCuenta a ,	 #tmpPagosPac b,
	TbPeriodosliquidacion_vigencias	c,
	Tbliquidaciones	d
Where  	ltrim(rtrim(b.nmro_dcmnto))	=	ltrim(rtrim(a.nmro_estdo_cnta))
--And	b.vlr_dcmnto			=	a.sldo_estdo_cnta
And	a.sldo_antrr 			=	0
And	c.cnsctvo_cdgo_prdo_lqdcn	=	d.cnsctvo_cdgo_prdo_lqdcn
And	d.cnsctvo_cdgo_lqdcn		=	a.cnsctvo_cdgo_lqdcn
And	b.cnsctvo_cdgo_tpo_prsntcn	= 8--@Tipo_Presentacion_Estado_Cuenta
And	b.Automatico			=	1
and b.mrca in (1,2)
*/

Select		Distinct cnsctvo_estdo_cnta
Into			#tmpEstadoCuenta
From		#tmpInsertaAbonos

Select		a.cnsctvo_cdgo_pgo	,a.cnsctvo_estdo_cnta,	a.vlr_abno	,a.extmprno,
				(				Select	fcha_rcdo 					FROM tbpagos p					WHERE p.cnsctvo_cdgo_pgo = a.cnsctvo_cdgo_pgo				) fcha_rcdo
Into			#tmpAbonosEstadoCuenta
From		#tmpEstadoCuenta ec
					Inner Join  [dbo].[tbAbonos]	a
						On	a.cnsctvo_estdo_cnta	=ec.cnsctvo_estdo_cnta
Order by 2,5

Select	*,	ROW_NUMBER() OVER(PARTITION BY cnsctvo_estdo_cnta ORDER BY fcha_rcdo )  cont
Into		#tmpAbonosOrdenadosEstadoCuenta
From	#tmpAbonosEstadoCuenta

Update	ia
Set			extmprno	= 'N'
From		#tmpInsertaAbonos ia					
Where		extmprno	=	'S'
And			vlr_abno		<	10000
And			Exists ( Select		1
							From		#tmpAbonosOrdenadosEstadoCuenta a
							Where		a.cnsctvo_estdo_cnta	=	ia.cnsctvo_estdo_cnta
							And			a.cnsctvo_cdgo_pgo	!=	ia.cnsctvo_cdgo_pgo
							And			a.extmprno		=	'N'
							And			a.cont				= 1
							)

-- fin Ajuste 2014-00001-000002492

--se inserta los estados de cuenta asociados al pago
Insert  into tbabonos
Select 	cnsctvo_cdgo_pgo,		cnsctvo_estdo_cnta,	vlr_abno,		extmprno,	Null
From	#tmpInsertaAbonos

/*
insert  into tbabonos
Select 	b.cnsctvo_cdgo_pgo,
	a.cnsctvo_estdo_cnta,
	b.vlr_dcmnto,
	case when fcha_rcdo >	fcha_mxma_pgo  then 'S' else 'N' end,
	Null
From	TbEstadosCuenta a ,	 #tmpPagosPac b,
	TbPeriodosliquidacion_vigencias	c,
	Tbliquidaciones	d
Where   	ltrim(rtrim(a.nmro_estdo_cnta))	=	ltrim(rtrim(b.nmro_dcmnto))
And b.vlr_dcmnto			>  a.ttl_pgr
And	a.sldo_antrr 			=	0
--And	a.sldo_estdo_cnta		>	0
And	c.cnsctvo_cdgo_prdo_lqdcn	=	d.cnsctvo_cdgo_prdo_lqdcn
And	d.cnsctvo_cdgo_lqdcn		=	a.cnsctvo_cdgo_lqdcn
And	b.cnsctvo_cdgo_tpo_prsntcn	=	8--@Tipo_Presentacion_Estado_Cuenta
And	b.Automatico			=	1
And (b.vlr_dcmnto - a.ttl_pgr) between 1 and 769
and b.mrca = 2
*/


-- se deben de cancelar las facturas anteriore que tengan pendientes...  


If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error insertando la los pagos de cada estado de cuenta'
		Rollback tran 
		Return -1
	end

Select 	@maximoConsecutivoPagoConcepto	=	isnull(max(cnsctvo_pgo_cncpto),0)
From	tbpagosConceptos


--se inserta la informacion de los conceptos  de pagos
Select 	    IDENTITY(int, 1,1) AS ID_Num	 , cnsctvo_estdo_cnta_cncpto, 	vlr_cbrdo , 	cnsctvo_cdgo_tpo_cncpto_opsto_lqdcn  cnsctvo_cdgo_cncpto_lqdcn,
	   cnsctvo_cdgo_pgo
into 	    #tmpPagosConceptos
From	    tbestadoscuenta a, tbestadoscuentaconceptos b  , TbConceptosLiquidacion_vigencias c,
	    #tmpPagosPac  d
Where  a.cnsctvo_estdo_cnta		=	b.cnsctvo_estdo_cnta
And    	b.cnsctvo_cdgo_cncpto_lqdcn	=	c.cnsctvo_cdgo_cncpto_lqdcn
And    	a.ttl_pgr				=	d.vlr_dcmnto
And    	ltrim(rtrim(a.nmro_estdo_cnta))	=	ltrim(rtrim(d.nmro_dcmnto))
And	a.sldo_antrr 			=	0
And    	d.cnsctvo_cdgo_tpo_prsntcn	=	 @Tipo_Presentacion_Estado_Cuenta
And	d.Automatico			=	1
And d.mrca in (0,1)
And    getdate()	between 	c.inco_vgnca      and             c.fn_vgnca 	



insert into #tmpPagosConceptos
Select 	   cnsctvo_estdo_cnta_cncpto, 	vlr_cbrdo , 	cnsctvo_cdgo_tpo_cncpto_opsto_lqdcn  cnsctvo_cdgo_cncpto_lqdcn,
	   cnsctvo_cdgo_pgo
From	    tbestadoscuenta a, tbestadoscuentaconceptos b  , TbConceptosLiquidacion_vigencias c,
	    #tmpPagosPac  d
Where  a.cnsctvo_estdo_cnta		=	b.cnsctvo_estdo_cnta
And    	b.cnsctvo_cdgo_cncpto_lqdcn	=	c.cnsctvo_cdgo_cncpto_lqdcn
--And    	a.sldo_estdo_cnta				=	d.vlr_dcmnto
And    	ltrim(rtrim(a.nmro_estdo_cnta))	=	ltrim(rtrim(d.nmro_dcmnto))
And	a.sldo_antrr 			=	0
And    	d.cnsctvo_cdgo_tpo_prsntcn	=	 @Tipo_Presentacion_Estado_Cuenta
And	d.Automatico			=	1
And d.mrca = 1
And    getdate()	between 	c.inco_vgnca      and             c.fn_vgnca 	



insert into #tmpPagosConceptos
Select 	   cnsctvo_estdo_cnta_cncpto, 	vlr_cbrdo , 	cnsctvo_cdgo_tpo_cncpto_opsto_lqdcn  cnsctvo_cdgo_cncpto_lqdcn,
	   cnsctvo_cdgo_pgo
From	    tbestadoscuenta a, tbestadoscuentaconceptos b  , TbConceptosLiquidacion_vigencias c,
	    #tmpPagosPac  d
Where  a.cnsctvo_estdo_cnta		=	b.cnsctvo_estdo_cnta
And    	b.cnsctvo_cdgo_cncpto_lqdcn	=	c.cnsctvo_cdgo_cncpto_lqdcn
And    	a.ttl_pgr				<	d.vlr_dcmnto
And    	ltrim(rtrim(a.nmro_estdo_cnta))	=	ltrim(rtrim(d.nmro_dcmnto))
And	a.sldo_antrr 			=	0
And    	d.cnsctvo_cdgo_tpo_prsntcn	=	 @Tipo_Presentacion_Estado_Cuenta
And	d.Automatico			=	1
And d.mrca = 2
And    getdate()	between 	c.inco_vgnca      and             c.fn_vgnca 	


Update 	tbestadoscuentaconceptos
Set	sldo	=	0
From	tbestadoscuentaconceptos a, #tmpPagosConceptos  b
Where 	a.cnsctvo_estdo_cnta_cncpto	=	b.cnsctvo_estdo_cnta_cncpto

If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error actualizando el saldo de los  conceptos del estado de cuenta'
		Rollback tran 
		Return -1
	end

-- se adiciona los conceptos   de los pagos
Insert into tbpagosConceptos
Select	(@maximoConsecutivoPagoConcepto + ID_Num),
	cnsctvo_cdgo_cncpto_lqdcn,
	cnsctvo_cdgo_pgo,
	cnsctvo_estdo_cnta_cncpto,
	vlr_cbrdo,
	Null
From	#tmpPagosConceptos

If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error insertando los pagos del concepto del estado de cuenta'
		Rollback tran 
		Return -1
	end


--selecciona la informacion de los contratos   que cruzaron para estados de cuenta
select      d.cnsctvo_estdo_cnta,	a.cnsctvo_estdo_cnta_cntrto ,	vlr_cbrdo, 	sum(b.vlr)  valor_iva ,  e.cnsctvo_cdgo_pgo, e.mrca
into          #TmpAbonosContratos
from   TbCuentasContratosBeneficiarios a, TbCuentasBeneficiariosConceptos b , TbEstadosCuentaContratos c,
          TbEstadosCuenta d,  #tmpPagosPac e
where		  a.cnsctvo_estdo_cnta_cntrto_bnfcro	=	b.cnsctvo_estdo_cnta_cntrto_bnfcro
and  		  a.cnsctvo_estdo_cnta_cntrto		=	c.cnsctvo_estdo_cnta_cntrto
And 		  c.cnsctvo_estdo_cnta			=	d.cnsctvo_estdo_cnta
and   		  b.cnsctvo_cdgo_cncpto_lqdcn		=	3
And    		  d.ttl_pgr				=	e.vlr_dcmnto
And   		  ltrim(rtrim(d.nmro_estdo_cnta))		=	ltrim(rtrim(e.nmro_dcmnto))
And		  d.sldo_antrr 				=	0
And		  e.Automatico				=	1
And		  e.cnsctvo_cdgo_tpo_prsntcn		= 	@Tipo_Presentacion_Estado_Cuenta
And         e.mrca =0
Group by 	  d.cnsctvo_estdo_cnta,	a.cnsctvo_estdo_cnta_cntrto,	vlr_cbrdo ,e.cnsctvo_cdgo_pgo,  e.mrca



--se inserta la informacion de los abonos de cada contrato para los aplicados

Insert into tbabonosContrato
Select 	cnsctvo_cdgo_pgo,
	cnsctvo_estdo_cnta_cntrto,
	(vlr_cbrdo -   valor_iva),
	valor_iva,
	'N',
	Null
From	#TmpAbonosContratos
where mrca= 0


select      d.cnsctvo_estdo_cnta,	a.cnsctvo_estdo_cnta_cntrto ,	 convert(INT,ROUND((c.sldo/1.1),-1)) as vlr, 	 CONVERT(INT,round((c.sldo/1.1) *0.10,-1)) as vlr_iva ,  e.cnsctvo_cdgo_pgo, e.mrca
into          #TmpAbonosContratos2
from   TbCuentasContratosBeneficiarios a, TbCuentasBeneficiariosConceptos b , TbEstadosCuentaContratos c,
          TbEstadosCuenta d,  #tmpPagosPac e
where		  a.cnsctvo_estdo_cnta_cntrto_bnfcro	=	b.cnsctvo_estdo_cnta_cntrto_bnfcro
and  		  a.cnsctvo_estdo_cnta_cntrto		=	c.cnsctvo_estdo_cnta_cntrto
And 		  c.cnsctvo_estdo_cnta			=	d.cnsctvo_estdo_cnta
and   		  b.cnsctvo_cdgo_cncpto_lqdcn		=	3
--And    		  d.ttl_pgr				=	e.vlr_dcmnto
And   		  ltrim(rtrim(d.nmro_estdo_cnta))		=	ltrim(rtrim(e.nmro_dcmnto))
And		  d.sldo_antrr 				=	0
And		  e.Automatico				=	1
And		  e.cnsctvo_cdgo_tpo_prsntcn		= 8-- @Tipo_Presentacion_Estado_Cuenta
and          e.mrca = 1
Group by 	  d.cnsctvo_estdo_cnta,	a.cnsctvo_estdo_cnta_cntrto,	c.sldo ,e.cnsctvo_cdgo_pgo,  e.mrca


Insert into tbabonosContrato
Select 	cnsctvo_cdgo_pgo,
	cnsctvo_estdo_cnta_cntrto,
	vlr,
	vlr_iva,
	'N',
	Null
From	  #TmpAbonosContratos2
where mrca = 1


select      d.cnsctvo_estdo_cnta,	a.cnsctvo_estdo_cnta_cntrto ,	 convert(INT,ROUND((e.vlr_dcmnto  * 100 ) / (100 +  10),-1)) as vlr, 	 CONVERT(INT,round((e.vlr_dcmnto  * 10 ) / (100 +  10),-1)) as vlr_iva ,  e.cnsctvo_cdgo_pgo, e.mrca
into          #TmpAbonosContratos3
from   TbCuentasContratosBeneficiarios a, TbCuentasBeneficiariosConceptos b , TbEstadosCuentaContratos c,
          TbEstadosCuenta d,  #tmpPagosPac e
where		  a.cnsctvo_estdo_cnta_cntrto_bnfcro	=	b.cnsctvo_estdo_cnta_cntrto_bnfcro
and  		  a.cnsctvo_estdo_cnta_cntrto		=	c.cnsctvo_estdo_cnta_cntrto
And 		  c.cnsctvo_estdo_cnta			=	d.cnsctvo_estdo_cnta
and   		  b.cnsctvo_cdgo_cncpto_lqdcn		=	3
And    			e.vlr_dcmnto >  d.ttl_pgr			
And (e.vlr_dcmnto - d.ttl_pgr) between 1 and 769
And   		  ltrim(rtrim(d.nmro_estdo_cnta))		=	ltrim(rtrim(e.nmro_dcmnto))
And		  d.sldo_antrr 				=	0
And		  e.Automatico				=	1
And		  e.cnsctvo_cdgo_tpo_prsntcn		=   @Tipo_Presentacion_Estado_Cuenta
and         e.mrca = 2
Group by 	  d.cnsctvo_estdo_cnta,	a.cnsctvo_estdo_cnta_cntrto,	e.vlr_dcmnto ,e.cnsctvo_cdgo_pgo,  e.mrca


Insert into tbabonosContrato
Select 	cnsctvo_cdgo_pgo,
	cnsctvo_estdo_cnta_cntrto,
	vlr,
	vlr_iva,
	'N',
	Null
From	  #TmpAbonosContratos3
where mrca = 2


If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error insertando la informacion de los pagos de los contratos'
		Rollback tran 
		Return -1
	end

Update  TbEstadosCuentaContratos
Set	sldo			=	0,
	fcha_ultma_mdfccn	=	@ldFechaSistema,
	usro_ultma_mdfccn	=	@lcUsuario
From	TbEstadosCuentaContratos a , #TmpAbonosContratos b
Where  a.cnsctvo_estdo_cnta_cntrto	=	b.cnsctvo_estdo_cnta_cntrto


Update  TbEstadosCuentaContratos
Set	sldo			=	0,
	fcha_ultma_mdfccn	=	@ldFechaSistema,
	usro_ultma_mdfccn	=	@lcUsuario
From	TbEstadosCuentaContratos a , #TmpAbonosContratos2 b
Where  a.cnsctvo_estdo_cnta_cntrto	=	b.cnsctvo_estdo_cnta_cntrto


Update  TbEstadosCuentaContratos
Set	sldo			=	sldo - (b.vlr +	b.vlr_iva),
	fcha_ultma_mdfccn	=	@ldFechaSistema,
	usro_ultma_mdfccn	=	@lcUsuario
From	TbEstadosCuentaContratos a , #TmpAbonosContratos3 b
Where  a.cnsctvo_estdo_cnta_cntrto	=	b.cnsctvo_estdo_cnta_cntrto



If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error Actualizando el saldo de los contratos'
		Rollback tran 
		Return -1
	end


-- se actualiza los registros traspasado en tesoreria
Update bdAdmonRecaudo..tbRecaudoConciliado
Set	trspso_crtra_pc				=	'S',
	cnsctvo_cdgo_estdo_rcdo_cncldo	=	5

From    bdAdmonRecaudo..tbRecaudoConciliado a,  #tmpPagosPac  b
Where 	a.cnsctvo_rcdo_cncldo	=	b.cnsctvo_rcdo_cncldo
And	a.cnsctvo_cdgo_tps_dcmnto	=	2


If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error actualizando el  traspaso en tesoreria'
		Rollback tran 
		Return -1
	end


-- Se Captura la fecha final proceso
Set	@Fecha_Fin_Proceso	=	Getdate()
-- Se Actualiza el fin del proceso
Update TbProcesosCarteraPac
Set	fcha_fn_prcso	=	@Fecha_Fin_Proceso
Where	cnsctvo_prcso	=	@Max_cnsctvo_prcso

If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error actualizando el  fin del proceso'
		Rollback tran 
		Return -1
	end



--se actualiza el saldo a nivel del contrato 


		--se calcula el maximo  numero 
Select	@MaximoConsecutivoContrato	 	=	 isnull(max(Cnsctvo_Acmldo_cntrto) ,0)
From	TbAcumuladosContrato
Select 	       a.Cnsctvo_Acmldo_cntrto,		a.cnsctvo_cdgo_tpo_cntrto,	a.nmro_cntrto,
	       a.tpo_dcmnto,			a.nmro_dcmnto,
	       a.dbts,				a.crdts,					a.vlr_sldo,
	       a.cntdd_fctrs_mra,			a.fcha_ultmo_pgo,			a.fcha_ultma_fctra,
	       a.fcha_mra,				a.ultma_oprcn,
	       c.cnsctvo_cdgo_pgo,		(c.vlr_abno_cta   + c.vlr_abno_iva)  vlr,		b.fcha_crcn,
	       0	nmro_unco_idntfccn_empldr, 	
	       0   	cnsctvo_scrsl, 
	       0	cnsctvo_cdgo_clse_aprtnte ,
	       IDENTITY(int, 1,1) AS ID_Num	
Into 	#TmpSaldosContrato
From   	TbAcumuladosContrato	  a,	TbPagos		b,		tbAbonosContrato	c
Where 		1 	=	2	



-- se insertan los registros que contengan contratos para  esos pagos
Insert	into 	#TmpSaldosContrato
Select    0,				c.cnsctvo_cdgo_tpo_cntrto,				c.nmro_cntrto,
	4, 				a.cnsctvo_cdgo_pgo,					--PAGOS
	0,				(b.vlr_abno_cta   + b.vlr_abno_iva) ,			0,
	0,				fcha_rcdo,					a.fcha_crcn,
	Null,				0,
	b.cnsctvo_cdgo_pgo,		(b.vlr_abno_cta   + b.vlr_abno_iva),		a.fcha_crcn,
       	d.nmro_unco_idntfccn_empldr, 	
	d.cnsctvo_scrsl, 
	d.cnsctvo_cdgo_clse_aprtnte 
From 	tbPagos		a,		tbAbonosContrato   b    ,				 tbEstadosCuentaContratos  c  , 
	tbestadoscuenta  d
Where 	a.cnsctvo_cdgo_pgo		=	b.cnsctvo_cdgo_pgo
And	b.cnsctvo_estdo_cnta_cntrto	=	c.cnsctvo_estdo_cnta_cntrto
And       d.ttl_pgr				=	a.vlr_dcmnto
And       d.nmro_estdo_cnta		=	a.nmro_dcmnto
And	d.sldo_antrr 			=	0
And	d.cnsctvo_estdo_cnta		=	c.cnsctvo_estdo_cnta
And	a.cnsctvo_prcso			=	@Max_cnsctvo_prcso
And	a.cnsctvo_cdgo_estdo_pgo	=	@Estado_Pago_Aplicado_Total	--Aplicados total
And	a.cnsctvo_cdgo_tpo_prsntcn	=	@Tipo_Presentacion_Estado_Cuenta

Update #TmpSaldosContrato
Set	Cnsctvo_Acmldo_cntrto		=	a.Cnsctvo_Acmldo_cntrto,
	cntdd_fctrs_mra			=	a.cntdd_fctrs_mra,
	fcha_ultma_fctra			=	a.fcha_ultma_fctra,
	fcha_mra			=	a.fcha_mra,
	vlr_sldo				=	a.vlr_sldo
From	TbAcumuladosContrato		a,	#TmpSaldosContrato	b
Where	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto
And	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr 	
And	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte 
And	a.ultma_oprcn			=	1	

Update	TbAcumuladosContrato
Set	ultma_oprcn			=	0
From	TbAcumuladosContrato	a,	#TmpSaldosContrato	b
Where	a.Cnsctvo_Acmldo_cntrto		=	b.Cnsctvo_Acmldo_cntrto


Insert	into	TbAcumuladosContrato
Select	(ID_Num	+	@MaximoConsecutivoContrato),		tpo_dcmnto,			nmro_dcmnto,      -- Pago
	dbts,								crdts,				vlr_sldo		-	crdts,
	@ldFechaSistema,
	@lcUsuario,
	cnsctvo_cdgo_tpo_cntrto,						nmro_cntrto,			1,
	cntdd_fctrs_mra,
	fcha_ultmo_pgo,
	fcha_ultma_fctra,
	fcha_mra,
	'N',
	nmro_unco_idntfccn_empldr, ---se adiciona la sucursal aportante
	cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte,
	Null
From	#TmpSaldosContrato



If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error insertando el acumulado del contrato'
			Rollback tran 
			Return -1
		end	
			

--Actualiza el saldo del responsable del pago

Select	@MaximoConsecutivoResponsable 	=	 isnull(max(cnsctvo_acmldo_scrsl_aprtnte) ,0)
From	TbAcumuladosSucursalAportante


-- se crea una tabla temporal que va contener los responsables del pago
Select 	       a.cnsctvo_acmldo_scrsl_aprtnte,	a.nmro_unco_idntfccn_empldr,	a.cnsctvo_scrsl,
	       a.cnsctvo_cdgo_clse_aprtnte,		a.tpo_dcmnto,			a.nmro_dcmnto,
	       a.dbts,				a.crdts,				a.vlr_sldo,
	       a.intrs_mra,
	       a.cntdd_fctrs_mra,			a.fcha_ultmo_pgo,		a.fcha_ultma_fctra,
	       a.fcha_mra,				a.ultma_oprcn,
	        b.cnsctvo_cdgo_pgo,		b.vlr_dcmnto,			b.fcha_crcn,
	       IDENTITY(int, 1,1) AS ID_Num	
Into 	#TmpSaldosResponsable
From   TbAcumuladosSucursalAportante  a,	tbPagos		b
Where 	1 	=	2	


     

-- se inserta en la tabla tempora la informacion del resposable  que tiene aociado la nota
Insert	into 	#TmpSaldosResponsable
Select  0,				b.nmro_unco_idntfccn_empldr,	b.cnsctvo_scrsl,
	b.cnsctvo_cdgo_clse_aprtnte,	4,				a.cnsctvo_cdgo_pgo,   -- pagos
	0,				a.vlr_dcmnto,				0,
	0,
	0,				a.fcha_rcdo,			@ldFechaSistema,
	Null,				0,
	a.cnsctvo_cdgo_pgo,		a.vlr_dcmnto,			@ldFechaSistema	
From 	#tmpPagosPac	  a,	 tbEstadoscuenta		b
Where 	ltrim(rtrim(a.nmro_dcmnto))	=	ltrim(rtrim(b.nmro_estdo_cnta))
And	a.cnsctvo_cdgo_estdo_pgo	=	@Estado_Pago_Aplicado_Total	--Aplicados total
And	b.sldo_antrr 			=	0
And	a.cnsctvo_cdgo_tpo_prsntcn	=	@Tipo_Presentacion_Estado_Cuenta
And	a.automatico			=	1

	

-- se actualiza la informacion de la ultima transacion para no perder los valores anteriores
Update #TmpSaldosResponsable
Set	cnsctvo_acmldo_scrsl_aprtnte	=	a.cnsctvo_acmldo_scrsl_aprtnte,
	intrs_mra			=	a.intrs_mra,
	cntdd_fctrs_mra			=	a.cntdd_fctrs_mra,
	fcha_ultma_fctra			=	a.fcha_ultma_fctra,
	fcha_mra			=	a.fcha_mra,
	vlr_sldo				=	a.vlr_sldo
From	TbAcumuladosSucursalAportante	a,	#TmpSaldosResponsable	b
Where	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
And	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
And	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl
And	a.ultma_oprcn			=	1	

-- se actualiza  la tabla principal para cerrar la ultima transacion
UPDATE	TbAcumuladosSucursalAportante
Set		ultma_oprcn	=	0
From		TbAcumuladosSucursalAportante	a,	#TmpSaldosResponsable	b
Where		a.cnsctvo_acmldo_scrsl_aprtnte	=	b.cnsctvo_acmldo_scrsl_aprtnte


-- se crea la ultima trasacion actualizada
-- para poder tener el ultimo movimiento
Insert	into	TbAcumuladosSucursalAportante
Select	(ID_Num	+	@MaximoConsecutivoResponsable),	nmro_unco_idntfccn_empldr,	cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte,					tpo_dcmnto,			nmro_dcmnto,   --- Nota Credito
	dbts,								crdts,				vlr_sldo		-	crdts,
	@ldFechaSistema,
	@lcUsuario,
	intrs_mra,
	cntdd_fctrs_mra,
	fcha_ultmo_pgo,
	fcha_ultma_fctra,
	fcha_mra,
	1,	
	'N',
	Null
From	#TmpSaldosResponsable


-- se crea una tabla temporal con todos los beneficiarios que cruzaron
--para actualizar el numero de dias cotizados

/*Select a.nmro_unco_idntfccn_bnfcro , d.fcha_gnrcn 

	into #tmpPagosBeneficiarios
From   tbCuentasContratosBeneficiarios a,  tbpagos b , tbabonosContrato c  ,
	tbEstadosCuenta d,  tbestadoscuentaContratos  e
Where   a.cnsctvo_estdo_cnta_cntrto	=	c.cnsctvo_estdo_cnta_cntrto
And	b.cnsctvo_cdgo_pgo		=	c.cnsctvo_cdgo_pgo
And	a.cnsctvo_estdo_cnta_cntrto	=	e.cnsctvo_estdo_cnta_cntrto
And	d.cnsctvo_estdo_cnta		=	e.cnsctvo_estdo_cnta
And	b.cnsctvo_prcso			=	@Max_cnsctvo_prcso  
And       d.ttl_pgr				=	b.vlr_dcmnto
And       d.nmro_estdo_cnta		=	b.nmro_dcmnto    
 --solamente para los que cruzaron en igual valor
*/  

--se deben de actualizar el  numero de dias cotizados con la fecha de la generacion de la factura

 --en la tabla  tbtiemposafiliacion
--------
--calcula  los intereses
/*
SSelect  b.nmro_unco_idntfccn_empldr, b.cnsctvo_scrsl, b.cnsctvo_cdgo_clse_aprtnte,
	a.nmro_dcmnto   ,   	     a.vlr_dcmnto , a.fcha_rcdo  , b.fcha_gnrcn  , d.fcha_mxma_pgo,
	datediff(day,d.fcha_mxma_pgo,a.fcha_rcdo)  dias_mora ,
	0 Dias_mora_Especial,
	0 estado_mora,
	0  valor_Total_dias_mora 
into    #TmpValorMora
From	tbpagos  a ,  tbEstadosCuenta b ,      tbliquidaciones c , tbperiodosliquidacion_vigencias  d
Where   a.nmro_dcmnto			=	b.nmro_estdo_cnta
And	b.cnsctvo_cdgo_lqdcn		=	c.cnsctvo_cdgo_lqdcn
And	c.cnsctvo_cdgo_prdo_lqdcn	=	d.cnsctvo_cdgo_prdo_lqdcn	
And	cnsctvo_prcso			=	@Max_cnsctvo_prcso


Update  #TmpValorMora
Set	Dias_mora_Especial  = e.nmro_ds
From 	#TmpValorMora a , tbDiasCobromoraSucursal_vigencias b ,	tbdiasmora_vigencias e
Where	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
And	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
And	b.cnsctvo_cdgo_ds_mra		=	e.cnsctvo_cdgo_ds_mra
And	getdate() between  b.inco_vgnca  and b.fn_vgnca 
And	getdate() between  e.inco_vgnca  and e.fn_vgnca 


Update  #TmpValorMora
Set	estado_mora		=  1,
	valor_Total_dias_mora	=	dias_mora - Dias_mora_Especial
Where   dias_mora       >  Dias_mora_Especial
And	dias_mora	>  0

*/

select  	a.nmro_dcmnto,
	a.fcha_rcdo,
             a.vlr_dcmnto,
	a.cnsctvo_cdgo_estdo_pgo, 
	a.cnsctvo_cdgo_tpo_pgo, 
	a.cnsctvo_cdgo_pgo,
	b.dscrpcn_estdo_pgo,
	d.fcha_inco_prcso,
	r.rzn_scl		nmbre_scrsl,
	r.nmro_idntfccn,
	r.tpo_idntfccn	cdgo_tpo_idntfccn	,
	a.nmro_unco_idntfccn_empldr,
	a.cnsctvo_scrsl,
	a.cnsctvo_cdgo_clse_aprtnte,
	@CantidadPagos			CantidadPagos,
	@ValorTotalPagos			ValorTotalPagos,
	@CantidadRegistrosAplicados		CantidadRegistrosAplicados,
	@CantidadRegistrosNoaplicados		CantidadRegistrosNoaplicados
into	#tmpResultadosReporte
from       tbPagos  a,  TbEstadosPago b  ,  tbprocesosCarteraPac d , bdadmonRecaudo..tbrecaudoconciliado r
where	a.cnsctvo_cdgo_estdo_pgo	=	b.cnsctvo_cdgo_estdo_pgo
And	a.cnsctvo_prcso			=	d.cnsctvo_prcso
And	@Max_cnsctvo_prcso		=	a.cnsctvo_prcso
And	a.cnsctvo_rcdo_cncldo		=	r.cnsctvo_rcdo_cncldo
And	r.cnsctvo_cdgo_tps_dcmnto	=	2

update #tmpResultadosReporte
Set	nmbre_scrsl			=	e.nmbre_scrsl,
	nmro_idntfccn			=	f.nmro_idntfccn,
	cdgo_tpo_idntfccn		=	g.cdgo_tpo_idntfccn	
From       #tmpResultadosReporte  a,   TbEstadosCuenta  c ,
	bdafiliacion..TbSucursalesAportante  e,  bdafiliacion..tbVinculados f, bdafiliacion..tbtiposIdentificacion g
where	a.nmro_dcmnto			=	c.nmro_estdo_cnta
And	a.cnsctvo_scrsl			=	e.cnsctvo_scrsl
And	a.nmro_unco_idntfccn_empldr	=	e.nmro_unco_idntfccn_empldr
And	a.cnsctvo_cdgo_clse_aprtnte	=	e.cnsctvo_cdgo_clse_aprtnte
And	c.nmro_unco_idntfccn_empldr	=	f.nmro_unco_idntfccn
And	f.cnsctvo_cdgo_tpo_idntfccn	=	g.cnsctvo_cdgo_tpo_idntfccn
and	e.nmro_unco_idntfccn_empldr	<>	0


select  * from 	#tmpResultadosReporte

Commit tran
