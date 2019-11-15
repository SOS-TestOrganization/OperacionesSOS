


/*---------------------------------------------------------------------------------
* Metodo o PRG 		:  SpActualizaEstadoLiquidacionn
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento actualiza el estado de la liquidacion						D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003/03/04											FC\>
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
CREATE  PROCEDURE [dbo].[SpActualizaEstadoLiquidacion]
	
	@lnNumeroLiquidacion								udtconsecutivo,
	@lnConsecutivoEstadoLiquidacion			udtConsecutivo,
	@lcUsuario													udtUsuario,
	@lnProcesoExitoso										int		output,
	@lnConsecutivoEstadoLiquidacionActual		udtConsecutivo,
	@lcMensaje													char(200)	output

As	Declare
@MaximoEstadoHistoricoLiquidacion			int,
@CantidadContratos					int,	
@NumeroEstadosCuenta				int,	
@Valortotalcobrado					UdtValorGrande,
@ldFechaSistema							datetime	

	
Set Nocount On		


---Si el estado del estado de cuenta es 6 finalizada de prueba debe dejar todo como estaba 
if @lnConsecutivoEstadoLiquidacionActual = 6 --Liquidacion Finalizada de prueba  
Begin 
 
   	update tbEstadosCuenta
 	set 	ttl_fctrdo				= 	a.ttl_fctrdo,
	    	sldo_fvr					= 	a.sldo_fvr,
	    	ttl_pgr						= 	a.ttl_pgr,
	    	sldo_estdo_cnta		= 	a.sldo_estdo_cnta,
	    	sldo_antrr				= 	a.sldo_antrr,
	    	Cts_Cnclr					= 	a.Cts_Cnclr,
	        Cts_sn_Cnclr			= 	a.Cts_sn_Cnclr
       	from   	tbEstadosCuentaPrevia a inner join 	tbEstadosCuenta b
       	on     	a.cnsctvo_estdo_cnta		= 	b.cnsctvo_estdo_cnta
       
	update  bdCarteraPac.dbo.tbEstadosCuentaContratos
		set vlr_cbrdo			=	a.vlr_cbrdo,
		sldo				=	a.sldo,
		sldo_fvr 		= a.sldo_fvr
     	from    tbEstadosCuentaContratosPrevia a inner Join tbEstadosCuentaContratos b
   	on 	a.cnsctvo_estdo_cnta_cntrto	=	b.cnsctvo_estdo_cnta_cntrto


	update tbEstadosCuenta
 	set 	cnsctvo_cdgo_estdo_estdo_cnta	=	4
    from   	tbEstadosCuentaPrevia a inner join 	tbEstadosCuenta b
     	on     	a.cnsctvo_estdo_cnta		= 	b.cnsctvo_estdo_cnta
	AND  	b.cnsctvo_Cdgo_lqdcn		=	@lnNumeroLiquidacion
       

   	delete from  tbEstadosCuentaPrevia
   	delete from  tbEstadosCuentaContratosPrevia
end 
if @lnConsecutivoEstadoLiquidacionActual in (5,6) --para que borre todo el modelo de datos 
  ----Borrado en cascada del modelo de estados de cuenta
	begin 

	begin tran

	select ec.cnsctvo_estdo_cnta
	into #tmpEstadosCuenta 
	from TbEstadosCuenta ec with (nolock)
	where cnsctvo_cdgo_lqdcn = @lnNumeroLiquidacion

	
	create index ix_EstadoCuenta on #tmpEstadosCuenta (cnsctvo_estdo_cnta)


	delete tbCuentasBeneficiariosConceptos
	from dbo.tbEstadosCuentaContratos ecc inner join #tmpEstadosCuenta ec 
	on ecc.cnsctvo_estdo_cnta = ec.cnsctvo_estdo_cnta
	inner join dbo.tbCuentasContratosBeneficiarios ccb
	on ccb.cnsctvo_estdo_cnta_cntrto = ecc.cnsctvo_estdo_cnta_cntrto
	inner join dbo.tbCuentasBeneficiariosConceptos cbc
	on cbc.cnsctvo_estdo_cnta_cntrto_bnfcro = ccb.cnsctvo_estdo_cnta_cntrto_bnfcro

	delete tbCuentasContratosBeneficiarios
	from dbo.tbEstadosCuentaContratos ecc inner join #tmpEstadosCuenta ec 
	on ecc.cnsctvo_estdo_cnta = ec.cnsctvo_estdo_cnta
	inner join dbo.tbCuentasContratosBeneficiarios ccb
	on ccb.cnsctvo_estdo_cnta_cntrto = ecc.cnsctvo_estdo_cnta_cntrto

	delete tbAbonosContrato
	from dbo.tbEstadosCuentaContratos ecc inner join #tmpEstadosCuenta ec 
	on ecc.cnsctvo_estdo_cnta = ec.cnsctvo_estdo_cnta
	inner join dbo.tbAbonosContrato ac
	on ac.cnsctvo_estdo_cnta_cntrto = ecc.cnsctvo_estdo_cnta_cntrto


	delete tbCuentasContratoReintegro
	from dbo.tbEstadosCuentaContratos ecc inner join #tmpEstadosCuenta ec 
	on ecc.cnsctvo_estdo_cnta = ec.cnsctvo_estdo_cnta
	inner join dbo.tbCuentasContratoReintegro ac
	on ac.cnsctvo_estdo_cnta_cntrto = ecc.cnsctvo_estdo_cnta_cntrto

	delete tbAbonos
	from dbo.tbAbonos ecc inner join #tmpEstadosCuenta ec 
	on ecc.cnsctvo_estdo_cnta = ec.cnsctvo_estdo_cnta

	delete tbEstadosCuentaContratos
	from #tmpEstadosCuenta ec  inner join dbo.tbEstadosCuentaContratos ecc
	on  ec.cnsctvo_estdo_cnta = ecc.cnsctvo_estdo_cnta


	delete tbNotasEstadoCuenta
	from dbo.tbNotasEstadoCuenta ecc inner join #tmpEstadosCuenta ec 
	on ecc.cnsctvo_estdo_cnta = ec.cnsctvo_estdo_cnta

	delete TbPagosConceptos
	from dbo.tbEstadosCuentaConceptos ecc inner join #tmpEstadosCuenta ec 
	on ecc.cnsctvo_estdo_cnta = ec.cnsctvo_estdo_cnta
	inner join dbo.TbPagosConceptos pc
	on pc.cnsctvo_estdo_cnta_cncpto = ecc.cnsctvo_estdo_cnta_cncpto

	delete tbEstadosCuentaConceptos
	from dbo.tbEstadosCuentaConceptos ecc inner join #tmpEstadosCuenta ec 
	on ecc.cnsctvo_estdo_cnta = ec.cnsctvo_estdo_cnta

	delete TbEstadosCuenta 
	from TbEstadosCuenta ec inner join  #tmpEstadosCuenta ec2
	on ec.cnsctvo_estdo_cnta = ec2.cnsctvo_estdo_cnta

	delete tbHistoricoEstadoLiquidacion 
	where cnsctvo_cdgo_lqdcn=@lnNumeroLiquidacion
    	
	delete tbCriteriosLiquidacion
	where cnsctvo_cdgo_lqdcn=@lnNumeroLiquidacion


	delete tbLogliquidacionesContratos
	where cnsctvo_cdgo_lqdcn=@lnNumeroLiquidacion

	delete tbhistoricotarificacionxproceso
	where cnsctvo_cdgo_lqdcn=@lnNumeroLiquidacion

   commit tran

end

Begin Tran Uno

Set	@ldFechaSistema		=	Getdate()

Select 	@CantidadContratos		=	nmro_cntrts,
	@NumeroEstadosCuenta		=	nmro_estds_cnta,
	@Valortotalcobrado		=	vlr_lqddo
From	tbliquidaciones
Where	cnsctvo_cdgo_lqdcn		=	@lnNumeroLiquidacion

Set	@lnProcesoExitoso	=	0
Update 	tbliquidaciones
Set	cnsctvo_cdgo_estdo_lqdcn	=	@lnConsecutivoEstadoLiquidacion
Where 	cnsctvo_cdgo_lqdcn		=	@lnNumeroLiquidacion
			
If  @@error!=0  
		Begin 
			Set	@lnProcesoExitoso	=	1
			Set	@lcMensaje		=	'Error Actualizando estado de la liquidacion'
			Rollback tran uno
			Return -1
		end	

Select 	@MaximoEstadoHistoricoLiquidacion	=	isnull(max(cnsctvo_hstrco_estdo_lqdcn),0) + 1	From	tbHistoricoEstadoLiquidacion
Insert into	tbHistoricoEstadoLiquidacion
			(cnsctvo_hstrco_estdo_lqdcn,
			 cnsctvo_cdgo_estdo_lqdcn,
			 cnsctvo_cdgo_lqdcn,
			 nmro_estds_cnta,			
			 vlr_lqddo,
			nmro_cntrts,
			 usro_crcn,
			 fcha_crcn)
		Values	(
			@MaximoEstadoHistoricoLiquidacion,
			@lnConsecutivoEstadoLiquidacion,
			@lnNumeroLiquidacion,
			@NumeroEstadosCuenta,
			@Valortotalcobrado,
			@CantidadContratos,
			@lcUsuario,
			@ldFechaSistema)

		
If  @@error!=0  
		Begin 
			Set	@lnProcesoExitoso	=	1
			Set	@lcMensaje		=	'Error Insertando el historico de la liquidacion'
			Rollback tran uno
			Return -1
		end	

Commit tran uno


