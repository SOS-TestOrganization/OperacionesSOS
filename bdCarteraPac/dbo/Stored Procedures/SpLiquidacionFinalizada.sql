/*---------------------------------------------------------------------------------
* Metodo o PRG		:  SpLiquidacionFinalizada
* Desarrollado por	: <\A Ing. Rolando Simbaqueva							A\> 
* Descripcion		: <\D Permite finalizar y actualizar el numero del estado de cuenta			D\>
* Observaciones		: <\O										O\>
* Parametros		: <\P 										P\>
* Variables		: <\V Instruccion Sql  a ejecutar							V\>
			: <\V Parmetros que condicionan la consulta					V\>
			: <\V Fecha que se convierte de date a caracter					V\>
			* Fecha Creacion: <\FC 2002/06/21						FC\>
*
*--------------------------------------------------------------------------------- 
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM Rolando Simbaqueva Lasso  AM\>
* Descripcion			: <\DM  Aplicacion y tecnicas de Optimizacion DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  2005-09-20 FM\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM Francisco Eduardo Riaño L. - Qvision S.A  AM\>
* Descripcion			: <\DM  se realizan ajustes para facturacion electronica DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  2019-04-26 FM\>
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM	Ing. Jean Paul Villaquiran Madrigal  AM\>
* Descripcion				: <\DM  en bloque donde se inserta en tabla temporal de estados cuenta se orden los daos DM\>
*							: <\DM  antes de que sean insertados DM\>
* Nuevos Parametros			: <\PM  PM\>
* Nuevas Variables			: <\VM  VM\>
* Fecha Modificacion		: <\FM  2019-04-26 FM\>
*---------------------------------------------------------------------------------
execute bdcarterapac.dbo.[SpLiquidacionFinalizada] 2, 0, 12742, 'premizeyrr', 0,0,0,0,''
select * from [bdseguridad].[dbo].[tbusuarios] where lgn_usro = 'premizeyrr'
*/
CREATE PROCEDURE [dbo].[SpLiquidacionFinalizada]
	@lnTipoProceso					int,
	@Max_cnsctvo_prcso				udtConsecutivo	output,
	@cnsctvo_cdgo_lqdcn				udtconsecutivo,
	@lcUsuario						udtusuario,
	@CantidadContratos				int	output,
	@NumeroEstadosCuenta			int	output,
	@Valortotalcobrado				UdtValorGrande	output,
	@lnProcesoExitoso				int	output,
	@lcMensaje						char(200)	output
AS
Begin
	Set Nocount On;

    Declare		@lcControlaError					udtConsecutivo	= 0,
				@vlr_actl							int,
				@vlr_antrr							int,
				@ldFechaSistema						Datetime		= getdate(),
				@lnConsecutivoPeriodoLiquidacion	udtConsecutivo,
				@Fecha_Inicio_Proceso				Datetime = getdate(),
				@Fecha_Fin_Proceso					Datetime = getdate(),
				@MaximoEstadoHistoricoLiquidacion	udtConsecutivo,
				@lnEstadoLiquidacionActual			int,
				@lnTipoProcesoLiquidacion			int,	
				@periodoanterior					int,
				@Anterior_cnsctvo_cdgo_lqdcn		int,
				@nuiempleador						int,
				@cnsctvo_inco_usdo					udtConsecutivo = 0,
				@cnsctvo_fn_usdo					udtConsecutivo = 0,
				@vrngo_inco_atrzdo_atrzcn			varchar(15) = '0',
				@vrngo_fn_atrzdo_fctrcn				varchar(15) = '0',
				@fcha_fn_atrzcn_fctrcn				datetime,
				@registroValidoSi					varchar(1) = 'S',
				@id_num								int,
				@estadoLiquidacionDefinitiva		int = 3,
				@estadoCuentaAnulada				int = 4,
				@estadoCuentaIngresada				int = 1,
				@nmroCuentaDefaultPrevia			varchar(3) = '999',			
				@tipoProcesoLiquidacionProcesada	int = 1,
				@tipoProcesoLiquidacionFinalizada	int = 2;
	--Creacion de tablas temporales
	Create table #tmpSucursalesLiquidacionFinalizado
	(
		nmro_unco_idntfccn_empldr	int,
		cnsctvo_scrsl				int,
		cnsctvo_cdgo_clse_aprtnte	int
	)

	Create table #tmpSucursalesLiquidacionPrevia_a_Finalizar
	(
		cnsctvo_estdo_cnta			int, 
		nmro_unco_idntfccn_empldr	int,
		cnsctvo_scrsl				int,
		cnsctvo_cdgo_clse_aprtnte	int
	)

	Create table #TmpContratosNoFinalizados
	(
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20),
		causa						varchar(100),
		nmro_unco_idntfccn_empldr	int,
		cnsctvo_scrsl				int,
		cnsctvo_cdgo_clse_aprtnte	int 
	 )

	Create table #TmpEstadoCuenta
	(
		ID_Num						int IDENTITY(1,1), 
		cnsctvo_estdo_cnta			int,
		nmro_estdo_cnta				varchar(15)
	)

	Create table #tmpContratosInicialesSaldoAFavor 
	(
		cnsctvo_estdo_cnta_cntrto	int,
		cnsctvo_estdo_cnta			int,
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20),
		vlr_cbrdo					numeric(12,0),
		sldo						numeric(12,0),
		cntdd_bnfcrs				int,
		nmro_unco_idntfccn_empldr	int,
		cnsctvo_scrsl				int,
		cnsctvo_cdgo_clse_aprtnte	int,
		Sldo_estdo_cnta				numeric(12,0)
	)

	Create table #tmpContratosAprocesarSF
	(
		Cnsctvo_estdo_cnta			int,
		cnsctvo_estdo_cnta_cntrto	int,
		sldo						numeric(12,0),
		cnsctvo_cdgo_pgo			int,
		vlr_abno_cta				numeric(12,0),
		vlr_abno_iva				numeric(12,0),
		vlr_abno					numeric(12,0),
		vlr_abno_nvo				numeric(12,0),
		Sldo_estdo_cnta				numeric(12,0),
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20),
		nmro_unco_idntfccn_empldr	int,
		cnsctvo_scrsl				int,
		cnsctvo_cdgo_clse_aprtnte	int,
		vlr_abno_cta_nvo			numeric(12,0),
		vlr_abno_iva_nvo			numeric(12,0),
		Actualizar					int,
		ok1							int,
		Pgdo_Cmsn					char(1),
		inconsistencia				int
	)

	Create table #tmpEstadosCuentaCon
	(
		Cnsctvo_estdo_cnta			int,
		cnsctvo_estdo_cnta_cntrto	int
	)

	Create table #tmpEstadosContratosSaldoA
	(
		cnsctvo_cdgo_pgo			int,
		Cnsctvo_estdo_cnta			int ,
		vlr_abno					numeric(12,0),
		fcha_aplccn					datetime,
		Activo						int,
		cnsctvo_estdo_cnta_cntrto	int
	)

	Create table #tmpPagoMaximo
	(
		Cnsctvo_estdo_cnta			int,
		cnsctvo_estdo_cnta_cntrto	int,
		max_fecha					datetime
	)

	Create table #tmpPagosBuenos
	(
		cnsctvo_cdgo_pgo			int,
		Cnsctvo_estdo_cnta			int ,
		vlr_abno					numeric(12,0),
		fcha_aplccn					datetime,
		Activo						int,
		cnsctvo_estdo_cnta_cntrto	int
	)

	Create table #tmpcontratosSaldoAFavor
	(
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20),
		nmro_unco_idntfccn_empldr	int,
		cnsctvo_scrsl				int,
		cnsctvo_cdgo_clse_aprtnte	int
	)

	Create table #tmpFacturasDef
	(
		nmro_unco_idntfccn_empldr	int,
		cnsctvo_scrsl				int,
		cnsctvo_cdgo_clse_aprtnte	int,
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					int,
		cnsctvo_estdo_cnta			int
	)

	Create table #tmpcontratosAdescontarSaldo
	(
		cnsctvo_estdo_cnta			int
	)

	Create table #tmpUltimaFactura
	(
		Cnsctvo_estdo_cnta			int,
		cnsctvo_estdo_cnta_cntrto	int,
		vlr_cbrdo					int,
		sldo						int,
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					int,
		nuevo_saldo					numeric(12,0),
		cnsctvo_cdgo_pgo			int,
		valor_pgo					numeric(12,0),
		vlr_abno_cta_nvo			numeric(12,0),
		vlr_abno_iva_nvo			numeric(12,0),
		nmro_unco_idntfccn_empldr	int,
		cnsctvo_scrsl				int,
		cnsctvo_cdgo_clse_aprtnte	int,
		ok1							int,
		Pgdo_Cmsn					char(1)
	)

	Create table #tmpAbonosContrato
	(
		cnsctvo_cdgo_pgo			int,
		cnsctvo_estdo_cnta_cntrto	int,
		vlr_abno_cta_nvo			numeric(12,0),
		vlr_abno_iva_nvo			numeric(12,0),
		Pgdo_Cmsn					char(1)
	)

	Create table #tmpAbonos
	(
		Cnsctvo_estdo_cnta			int,
		Cnsctvo_cdgo_pgo			int,
		vlr_abno					numeric(12,0)
	)

	Create table #tmpActualizacionAbonosContrato
	(
		cnsctvo_estdo_cnta_cntrto	int,
		cnsctvo_cdgo_pgo			int,
		vlr_abno_cta_nvo			numeric(12,0),
		vlr_abno_iva_nvo			numeric(12,0)
	)	

	Create table #tmpActualizacionAbonos
	(
		cnsctvo_cdgo_pgo			int,
		cnsctvo_estdo_cnta			int,
		vlr_abno_nvo				numeric(12,0)
	)

	Create table #tmpActualizacionAbonosFinal
	(
		vlr_abno_nvo				numeric(12,0),
		cnsctvo_estdo_cnta			int,
		cnsctvo_cdgo_pgo			int
	)
	
	Create table  #tmpFacturasanteriores
	(
		cnsctvo_estdo_cnta			int
	)
		
	Create table #tmpNuevosSaldosAnteriores
	(
		cnsctvo_estdo_cnta			int,
		saldo						numeric(12,0)
	 )
	
	Create table #tmpNuevosSaldoEstadoCuenta
	(
		Cnsctvo_estdo_cnta			int,
		Saldo						numeric(12,0)
	)
	
	Create table #tmpNuevosSaldoEstadoCuentaContrato
	(
		Cnsctvo_estdo_cnta_cntrto	int,
		Saldo						numeric(12,0)
	)
		
	Create table #tmpResultadosLogFinal
	(
		nmro_cntrto					varchar(20),
		cdgo_tpo_idntfccn			varchar(3),
		nmro_idntfccn				varchar(20),
		nombre						varchar(200),
		cnsctvo_cdgo_pln			int,
		inco_vgnca_cntrto			datetime,
		fn_vgnca_cntrto				datetime,
		nmro_unco_idntfccn_afldo	int,
		cdgo_pln					varchar(6),
		dscrpcn_pln					varchar(50),
		causa						varchar(100),
		nmro_unco_idntfccn_empldr	int,
		cnsctvo_scrsl				int,
		cnsctvo_cdgo_clse_aprtnte	int,
		nmbre_scrsl					varchar(200),
		dscrpcn_clse_aprtnte		varchar(100),
		tpo_idntfccn_scrsl			varchar(3),
		nmro_idntfccn_scrsl			varchar(20),
		Responsable					varchar(100)
	)	
	
	Select	@lnConsecutivoPeriodoLiquidacion	=	cnsctvo_cdgo_prdo_lqdcn,
			@lnEstadoLiquidacionActual			=	cnsctvo_cdgo_estdo_lqdcn,
			@lnTipoProcesoLiquidacion			=	cnsctvo_cdgo_tpo_prcso
	From	dbo.tbliquidaciones With(NoLock)
	Where	cnsctvo_cdgo_lqdcn					=	@cnsctvo_cdgo_lqdcn


	If @lnEstadoLiquidacionActual = 5 --Liquidacion previa
	Begin 
		Delete From dbo.tbEstadosCuentaPrevia
		Delete From dbo.tbEstadosCuentaContratosPrevia

		INSERT INTO dbo.tbEstadosCuentaPrevia (
 				cnsctvo_estdo_cnta,
				cnsctvo_cdgo_lqdcn,
				ttl_fctrdo,
				sldo_fvr,
				ttl_pgr,
				sldo_estdo_cnta,
				sldo_antrr,
				Cts_Cnclr,
				Cts_sn_Cnclr
		)
		Select	a.cnsctvo_estdo_cnta,
				cnsctvo_cdgo_lqdcn,
				a.ttl_fctrdo,
				a.sldo_fvr,
				a.ttl_pgr,
				a.sldo_estdo_cnta,
				a.sldo_antrr,
				a.Cts_Cnclr,
				a.Cts_sn_Cnclr
		From	dbo.tbEstadosCuenta  a With(NoLock)

		INSERT INTO dbo.tbEstadosCuentaContratosPrevia (
				cnsctvo_estdo_cnta_cntrto,
				vlr_cbrdo,
				sldo,
				sldo_fvr
		)
		Select  a.cnsctvo_estdo_cnta_cntrto,
				a.vlr_cbrdo,
				a.sldo,
				a.sldo_fvr
		From    dbo.tbEstadosCuentaContratos a With(NoLock)
	End


	IF	@lnEstadoLiquidacionActual	in	(1,3,4)  
	Begin
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje			=	'la liquidacion no se puede Finalizar su estado no lo permite'
		Return 	-1
	End

	Begin Tran 

	--Se conculta el maximo consecutivo del proceso
	Select	@Max_cnsctvo_prcso		=	isnull(max(cnsctvo_prcso),0)+ 1
	From	dbo.TbProcesosCarteraPac

	Insert	into dbo.TbProcesosCarteraPac 
	Values(
		@Max_cnsctvo_prcso,
		@lnTipoProceso,
		@Fecha_Inicio_Proceso,
		NULL,
		@lcUsuario
	)

	--Como se va asignar el consecutivo del estado de cuenta, la sucursal aportante tan solo debe tener un solo estado de cuenta
	--entonces se verifica que tiene un estado de cuenta para ese periodo de liquidacion.
	
	Insert Into	 #tmpSucursalesLiquidacionFinalizado
	Select 		b.nmro_unco_idntfccn_empldr,	b.cnsctvo_scrsl,	 b.cnsctvo_cdgo_clse_aprtnte
	from 		dbo.tbliquidaciones				a With(NoLock)
	Inner Join	dbo.TbEstadosCuenta				b With(NoLock)
	    On		(a.cnsctvo_cdgo_lqdcn		=	b.cnsctvo_cdgo_lqdcn) 
	Inner Join	dbo.tbEstadosCuentaContratos	c With(NoLock)
		On		(b.cnsctvo_estdo_cnta		=	c.cnsctvo_estdo_cnta)
	Where		a.cnsctvo_cdgo_estdo_lqdcn	=	@estadoLiquidacionDefinitiva		
	And			b.cnsctvo_cdgo_estdo_estdo_cnta != @estadoCuentaAnulada	
	And			a.cnsctvo_cdgo_prdo_lqdcn	=	@lnConsecutivoPeriodoLiquidacion
	Group by	b.nmro_unco_idntfccn_empldr,	b.cnsctvo_scrsl,	 b.cnsctvo_cdgo_clse_aprtnte

	--Se traen todos los estados de cuenta que contienen las sucursales aportantes
	--donde ya tienen estado de  cuenta terminados
	
	Insert Into	#tmpSucursalesLiquidacionPrevia_a_Finalizar
	Select 		a.cnsctvo_estdo_cnta , 
				a.nmro_unco_idntfccn_empldr , a.cnsctvo_scrsl , a.cnsctvo_cdgo_clse_aprtnte
	From		dbo.TbEstadosCuenta					a With(NoLock)
	Inner Join	#tmpSucursalesLiquidacionFinalizado	b
		On 		(a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
		And		a.cnsctvo_scrsl					=	b.cnsctvo_scrsl
		And		a.cnsctvo_cdgo_clse_aprtnte		=	b.cnsctvo_cdgo_clse_aprtnte)
	    And		a.cnsctvo_cdgo_estdo_estdo_cnta not in (@estadoCuentaAnulada,@estadoCuentaIngresada)
	Where		a.cnsctvo_cdgo_lqdcn			=	@cnsctvo_cdgo_lqdcn

	Insert Into	#TmpContratosNoFinalizados
	Select		cnsctvo_cdgo_tpo_cntrto,		nmro_cntrto,	'CONTRATO FINALIZADO'   causa	,
				a.nmro_unco_idntfccn_empldr , a.cnsctvo_scrsl , a.cnsctvo_cdgo_clse_aprtnte
	From		#tmpSucursalesLiquidacionPrevia_a_Finalizar	a 
	Inner Join	dbo.TbEstadosCuentaContratos				b With(NoLock)
		On		(a.cnsctvo_estdo_cnta		=	b.cnsctvo_estdo_cnta)

	--Se borran todos los estados de cuenta de la liquidacion que se quiere procesar
	--porque ya contienen un estado de cuenta para ese periodo y ademas esta finalizado

	-- Se borra el cascada
	--primero los conceptos de los beneficiarios  
	Delete from dbo.TbCuentasBeneficiariosConceptos
	From		#tmpSucursalesLiquidacionPrevia_a_Finalizar a 
	Inner Join 	dbo.TbEstadosCuentaContratos				b With(NoLock)
		On		(a.cnsctvo_estdo_cnta				=	b.cnsctvo_estdo_cnta) 
	Inner Join	dbo.TbCuentasContratosBeneficiarios			c  With(NoLock)
		On		(b.cnsctvo_estdo_cnta_cntrto		=	c.cnsctvo_estdo_cnta_cntrto) 
	Inner Join	dbo.TbCuentasBeneficiariosConceptos			d 
		On		(c.cnsctvo_estdo_cnta_cntrto_bnfcro	=	d.cnsctvo_estdo_cnta_cntrto_bnfcro)

	If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error Eliminando los Conceptos  del Estado de Cuenta'
		Rollback tran 
		Return -1
	End	

	--Segundo los beneficiarios
	Delete from dbo.TbCuentasContratosBeneficiarios
	From		#tmpSucursalesLiquidacionPrevia_a_Finalizar a 
	Inner Join	dbo.TbEstadosCuentaContratos				b With(NoLock)
		On		(a.cnsctvo_estdo_cnta			=	b.cnsctvo_estdo_cnta) 
	Inner Join	dbo.TbCuentasContratosBeneficiarios			c With(NoLock)
		On		(b.cnsctvo_estdo_cnta_cntrto	=	c.cnsctvo_estdo_cnta_cntrto)

	If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error eliminando los Beneficiarios  del Estado de Cuenta'
		Rollback tran 
		Return -1
	end	

	--Tercero  se borran todos los contratos
	Delete from dbo.TbEstadosCuentaContratos
	From		#tmpSucursalesLiquidacionPrevia_a_Finalizar a 
	Inner Join	dbo.TbEstadosCuentaContratos				b With(NoLock)
		ON		(a.cnsctvo_estdo_cnta	=	b.cnsctvo_estdo_cnta)

	If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error Eliminando los contratos del estado de cuenta'
		Rollback tran 
		Return -1
	end	

	-- Cuarto se borran todos los conceptos  del estado de cuenta
	Delete from dbo.TbEstadosCuentaConceptos
	From		#tmpSucursalesLiquidacionPrevia_a_Finalizar a 
	Inner Join  dbo.TbEstadosCuentaConceptos				b With(NoLock)
		On		(a.cnsctvo_estdo_cnta	=	b.cnsctvo_estdo_cnta)

	If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error eliminando los conceptos del estado de cuenta'
		Rollback tran 
		Return -1
	end	

	-- se borran todos los estado de cuenta.
	Delete From dbo.tbEstadosCuenta
	From		dbo.tbEstadosCuenta							a With(NoLock) 
	Inner Join	#tmpSucursalesLiquidacionPrevia_a_Finalizar	b
		On		(a.cnsctvo_estdo_cnta	=	b.cnsctvo_estdo_cnta)

	If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error Eliminando los estados de cuenta'
		Rollback tran 
		Return -1
	end	

	Insert Into	#TmpEstadoCuenta
	Select 		cnsctvo_estdo_cnta,
				Convert(varchar(15),'0')	nmro_estdo_cnta
	From		dbo.tbEstadosCuenta a With(NoLock)
	inner join	BDAfiliacion.dbo.tbSucursalesAportante b
	on			a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn_empldr
	and			a.cnsctvo_scrsl = b.cnsctvo_scrsl
	inner join	BDAfiliacion.dbo.tbSedes c
	on			b.sde_crtra_pc = c.cnsctvo_cdgo_sde
	Where 		a.cnsctvo_cdgo_lqdcn 	= @cnsctvo_cdgo_lqdcn
	order by	c.cnsctvo_cdgo_sde

	If 	@@ROWCOUNT > 0
	Begin 
		--Hay Estados de cuenta para crear
		--Actualizamos el consecutivo del estado  de cuenta cuando es definitiva 
		If @lnEstadoLiquidacionActual = 2 
		Begin
			Update	a
			Set		a.nmro_estdo_cnta = Convert	(Varchar(15),(next value for dbo.seqNumeroEstadoCuentaDIAN))
			From	#TmpEstadoCuenta a
		End
		Else
		Begin
			Update	#TmpEstadoCuenta
			Set		nmro_estdo_cnta	=	@nmroCuentaDefaultPrevia
		End


		Select	@vlr_actl	=	max(nmro_estdo_cnta)
		From	#TmpEstadoCuenta
					
		Update		a
		Set			nmro_estdo_cnta			=	b.nmro_estdo_cnta,
					a.usro_crcn = @lcUsuario
		From		dbo.tbEstadosCuenta	a 
		Inner Join	#TmpEstadoCuenta	b
			On		(a.cnsctvo_estdo_cnta	=	b.cnsctvo_estdo_cnta)
				
		If  @@error!=0  
		Begin 
			Set	@lnProcesoExitoso	=	1
			Set	@lcMensaje='Error Actualizando el numero del Estado de Cuenta'
			Rollback tran 
			Return -1
		End	

	End	

	-- Se Actualiza el fin del proceso
	Update	dbo.TbProcesosCarteraPac
	Set		fcha_fn_prcso	=	getdate()
	Where	cnsctvo_prcso	=	@Max_cnsctvo_prcso

	If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error actualizando el  fin del proceso'
		Rollback tran 
		Return -1
	end

	--- sa calcula el numero de facturas y el valor total cobrado
	Select 	@NumeroEstadosCuenta	=	count(*),
			@Valortotalcobrado		=	isnull(sum(ttl_pgr),0)	
	From 	dbo.TbEstadosCuenta With(NoLock)
	Where 	cnsctvo_cdgo_lqdcn	=	@cnsctvo_cdgo_lqdcn

	-- actualiza el numero de contratos
	Select		@CantidadContratos		=	Count(cnsctvo_estdo_cnta_cntrto)
	From		dbo.TbEstadosCuentaContratos	a With(NoLock)
	Inner Join	dbo.TbEstadosCuenta				b With(NoLock)
		On		(a.cnsctvo_estdo_cnta	=	b.cnsctvo_estdo_cnta)
	Where		b.cnsctvo_cdgo_lqdcn	=	@cnsctvo_cdgo_lqdcn

	--Actualiza el estado de la  liquidacion y el valor total de contratos y el numero de estados de cuenta.
	If @lnEstadoLiquidacionActual =  2
	Begin
		Update 	dbo.Tbliquidaciones
		Set		cnsctvo_cdgo_estdo_lqdcn	=	@estadoLiquidacionDefinitiva,  
	 			nmro_estds_cnta				=	@NumeroEstadosCuenta,
	 			vlr_lqddo					=	@Valortotalcobrado,
				nmro_cntrts					=	@CantidadContratos
		Where	cnsctvo_cdgo_lqdcn			=	@cnsctvo_cdgo_lqdcn
	End
		
	If  @@error!=0  
	Begin 

		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error Actualizando estado de la liquidación'
		Rollback tran 
		Return -1
	end	

	--Actualiza el  historico estado de la liquidacion
	Select 	@MaximoEstadoHistoricoLiquidacion	=	isnull(max(cnsctvo_hstrco_estdo_lqdcn),0) + 1	
	From	dbo.tbHistoricoEstadoLiquidacion With(NoLock)

	Insert into	dbo.tbHistoricoEstadoLiquidacion (
			cnsctvo_hstrco_estdo_lqdcn,
			cnsctvo_cdgo_estdo_lqdcn,
			cnsctvo_cdgo_lqdcn,
			nmro_estds_cnta,
			vlr_lqddo,
			nmro_cntrts,
			usro_crcn,
			fcha_crcn
	)
	Values	(
			@MaximoEstadoHistoricoLiquidacion,
			@estadoLiquidacionDefinitiva,	
			@cnsctvo_cdgo_lqdcn,
			@NumeroEstadosCuenta,
			@Valortotalcobrado,
			@CantidadContratos,
			@lcUsuario,
			@ldFechaSistema
	)
		
	If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error Insertando el Historico de la liquidación'
		Rollback tran 
		Return -1
	end	

	---actualiza los saldos a favor

	If	@lnTipoProcesoLiquidacion	=	2
	Begin	
		Select  @Anterior_cnsctvo_cdgo_lqdcn = max(cnsctvo_cdgo_lqdcn) 
		From 	dbo.tbliquidaciones With(NoLock)
		Where 	cnsctvo_cdgo_estdo_lqdcn 	= @estadoLiquidacionDefinitiva
		And		cnsctvo_cdgo_tpo_prcso 		= @tipoProcesoLiquidacionFinalizada
		And		cnsctvo_cdgo_lqdcn 			!= @cnsctvo_cdgo_lqdcn  

		Select		a.cnsctvo_estdo_cnta, 	 
					@Anterior_cnsctvo_cdgo_lqdcn		liquidacion
		Into		#tmpFacinDepenSaldoanteriorInd
		From		dbo.tbestadoscuenta				a With(NoLock)
		Inner Join	dbo.tbliquidaciones				b With(NoLock)
			On		a.cnsctvo_cdgo_lqdcn 		= b.cnsctvo_cdgo_lqdcn
		Inner Join	dbo.tbestadoscuentacontratos	c With(NoLock)
			On		c.cnsctvo_estdo_cnta 		= a.cnsctvo_estdo_cnta
		Where		cnsctvo_cdgo_prdo_lqdcn		=  @lnConsecutivoPeriodoLiquidacion - 1
		And			cnsctvo_cdgo_estdo_lqdcn	= @estadoLiquidacionDefinitiva
		And			cnsctvo_cdgo_tpo_prcso 		= @tipoProcesoLiquidacionProcesada
		And			sldo < 0
		Group by	a.cnsctvo_estdo_cnta

		--actualiza alos estados de cuenta que fueron anteriores indivuduales y ahora se ejecutan en el masivo
		Update		a
		Set			cnsctvo_cdgo_lqdcn	=	b.liquidacion,
					a.usro_crcn = @lcUsuario
		From		dbo.tbestadoscuenta				a 
		Inner Join  #tmpFacinDepenSaldoanteriorInd	b
			On		a.cnsctvo_estdo_cnta	=	b.cnsctvo_estdo_cnta
				
		If  @@error!=0  
		Begin 
			Set	@lnProcesoExitoso	=	1
			Set	@lcMensaje		=	'Error actualizando numero de liquidación'
			Rollback tran 
			Return -1
		End	

		Execute dbo.SpActualizarSaldosEstadosCuenta @Anterior_cnsctvo_cdgo_lqdcn, @cnsctvo_cdgo_lqdcn, @lnEstadoLiquidacionActual;
	End

	If	@lnTipoProcesoLiquidacion	=	1
	Begin	
		--Para  sacar el cnsctvo_cdgo_prdo_lqdcn anterior 
		Select	@periodoanterior=max((cnsctvo_cdgo_prdo_lqdcn)-1) 
		From	dbo.tbliquidaciones With(NoLock)
		Where	cnsctvo_cdgo_lqdcn = @cnsctvo_cdgo_lqdcn

		--Para sacar el nui del empleador del estado del estado de cuenta de la liquidacion actual 
		Select 		@nuiempleador=nmro_unco_idntfccn_empldr
		From 		dbo.tbestadoscuenta a With(NoLock)
		Inner Join	dbo.tbliquidaciones b With(NoLock)
			On 		a.cnsctvo_cdgo_lqdcn 	= @cnsctvo_cdgo_lqdcn
			And  	cnsctvo_cdgo_tpo_prcso	= @tipoProcesoLiquidacionProcesada 

		--Anterior consecutivo de liquidación  de ese empleador del periodo pasado
		Select		@Anterior_cnsctvo_cdgo_lqdcn=max(b.cnsctvo_cdgo_lqdcn) 
		From		dbo.tbestadoscuenta	a With(NoLock)
		Inner Join	dbo.tbliquidaciones	b With(NoLock)
			On		a.cnsctvo_cdgo_lqdcn	= b.cnsctvo_cdgo_lqdcn
		Where		nmro_unco_idntfccn_empldr = @nuiempleador
		And			cnsctvo_cdgo_prdo_lqdcn = @periodoanterior

		Select		a.cnsctvo_estdo_cnta, 	 
					@Anterior_cnsctvo_cdgo_lqdcn		liquidacion
		Into		#tmpFacinDepenSaldoanteriorInd2
		From		dbo.tbestadoscuenta				a With(NoLock)
		Inner Join	dbo.tbliquidaciones				b With(NoLock)
			On		a.cnsctvo_cdgo_lqdcn = b.cnsctvo_cdgo_lqdcn
		Inner Join 	dbo.tbestadoscuentacontratos	c With(NoLock)
			On		c.cnsctvo_estdo_cnta = a.cnsctvo_estdo_cnta
		Where		cnsctvo_cdgo_prdo_lqdcn =  @lnConsecutivoPeriodoLiquidacion -1
		And			cnsctvo_cdgo_estdo_lqdcn = @estadoLiquidacionDefinitiva
		And			sldo < 0
		Group by	a.cnsctvo_estdo_cnta

		Execute dbo.SpActualizarSaldosEstadosCuenta @Anterior_cnsctvo_cdgo_lqdcn, @cnsctvo_cdgo_lqdcn, @lnEstadoLiquidacionActual;
	End

	-- Se realiza calculo de de texto de vencimiento de la factura
	Update	a
	Set		a.txto_vncmnto = 'INMEDIATO',
			a.usro_crcn = @lcUsuario
	From	dbo.tbEstadosCuenta a 
	where	a.sldo_antrr > 0
	And     a.cnsctvo_cdgo_lqdcn	=	@cnsctvo_cdgo_lqdcn;

	Update		a
	Set			a.txto_vncmnto = convert(date,h.fcha_pgo,103) ,
				a.usro_crcn = @lcUsuario
	From		dbo.tbEstadosCuenta									a 
	INNER JOIN  dbo.tbLiquidaciones									g With(NoLock) 
		ON		a.cnsctvo_cdgo_lqdcn = g.cnsctvo_cdgo_lqdcn 
	INNER JOIN  dbo.tbPeriodosliquidacion_Vigencias					h With(NoLock) 
		ON		g.cnsctvo_cdgo_prdo_lqdcn = h.cnsctvo_cdgo_prdo_lqdcn 
	Where		a.sldo_antrr <= 0
	And			a.cnsctvo_cdgo_lqdcn	=	@cnsctvo_cdgo_lqdcn;

	--Se realiza la actualizacion campo CUFE
	Create Table #tmpParametrosRecibidosCufe
	(
		   NmroCnta varchar(15),
		   NumFac varchar(30),
		   FecFac varchar(30),
		   ValFac varchar(30),
		   CodImp1 varchar(10),
		   ValImp1 varchar(30),
		   CodImp2 varchar(10),
		   ValImp2 varchar(30),
		   CodImp3 varchar(10),
		   ValImp3 varchar(30),
		   ValImp varchar(30),
		   NitOFE varchar(30),
		   TipAdq varchar(10),
		   NumAdq varchar(30),
		   CITec varchar(250)
	);

	Create Nonclustered Index IX_#tmpParametrosRecibidosCufe 
		on #tmpParametrosRecibidosCufe
    (
			NumFac
	)

	Insert	#tmpParametrosRecibidosCufe
	(
			NmroCnta,
			NumFac,								   
			FecFac,									
			ValFac,
			CodImp1,								
			ValImp1,								
			CodImp2,
			ValImp2,								
			CodImp3,								
			ValImp3,
			ValImp,									
			NitOFE,									
			TipAdq,
			NumAdq,									
			CITec			
	)
	Select		a.nmro_estdo_cnta,
				(convert(varchar,b.prfjo_atrzdo_fctrcn) + convert(varchar,a.nmro_estdo_cnta)), --NUMFAC
				Format(a.Fcha_crcn,'yyyyMMddHHmmss'), -- FECFAC
				cast(a.ttl_fctrdo as numeric(12,2)), -- VALFAC
				'01', --CODIMP1
				cast(a.vlr_iva as numeric(12,2)), -- VALIMP1
				'02', -- CODIMP2
				'0.00', -- VALIMP2
				'03', -- CODIMP3
				'0.00', -- VALIMP3
				cast(a.ttl_fctrdo as numeric(12,2)) + cast(a.vlr_iva as numeric(12,2)), -- VALIMP
				'805001157', -- NitOFE
				d.cdgo_dn, -- TIPADQ
				rtrim(ltrim(c.nmro_idntfccn)), -- NUMADQ
				b.clve_tcnca_dn -- CITec
	From		dbo.tbEstadosCuenta										a With(NoLock)
	Inner Join 	BDAfiliacionValidador.dbo.tbResolucionesDIAN_vigencias	b With(NoLock)
		On		b.cnsctvo_cdgo_rslcn_dn = a.cnsctvo_cdgo_rslcn_dn
	Inner Join  BDAfiliacion.dbo.tbVinculados							c With(NoLock)
		On		a.nmro_unco_idntfccn_empldr = c.nmro_unco_idntfccn
	Inner Join  dbo.tbCodigosDIAN_Vigencias								d With(NoLock)
		On		d.cnsctvo_cdgo_llve_sos = c.cnsctvo_cdgo_tpo_idntfccn
	Where		@ldFechaSistema Between b.inco_vgnca And b.fn_vgnca
	And			d.cnsctvo_cdgo_tpo_cdgo_dn = 1
	And         a.cnsctvo_cdgo_lqdcn	=	@cnsctvo_cdgo_lqdcn;

	Create Table #tmpCUFEGenerado
	(
		   NmroCnta varchar(15),
		   NumFac varchar(30),
		   CUFE varchar(250),
		   cCUFE varchar(250),
	)

	Insert	#tmpCUFEGenerado
	(
		   NmroCnta,
		   NumFac, 
		   CUFE,
		   cCUFE
	) 
	exec	BDAfiliacionValidador.dbo.spFEGenerarCUFE;

	Update		a
	Set			cufe = t.CUFE,
				a.usro_crcn = @lcUsuario
	From		dbo.tbEstadosCuenta a
	Inner Join	#tmpCUFEGenerado t
	On			t.NmroCnta = a.nmro_estdo_cnta
	where		a.cnsctvo_cdgo_lqdcn = @cnsctvo_cdgo_lqdcn;

	-- Se genera el codigo QR a partir de la informacion del cufe	
	Update		a
	Set			cdna_qr = concat('NumFac:',ltrim(rtrim(t.NumFac)),' ','FecFac:',ltrim(rtrim(t1.FecFac)),' ','NitFac:',ltrim(rtrim(t1.NitOFE)),' ','DocAdq:',ltrim(rtrim(t1.NumAdq)),' ','ValFac:',ltrim(rtrim(t1.ValFac)),' ','ValIva:',ltrim(rtrim(t1.ValImp1)),' ','ValOtroIm:','0.00',' ','ValFacIm:',ltrim(rtrim(t1.ValImp)),' ','CUFE:',t.cufe),
				a.usro_crcn = @lcUsuario
	From		dbo.tbEstadosCuenta a
	Inner Join	#tmpCUFEGenerado t
	On			t.NmroCnta = a.nmro_estdo_cnta
	Inner join  #tmpParametrosRecibidosCufe t1
	On          t.NumFac = t1.NumFac
	where		a.cnsctvo_cdgo_lqdcn = @cnsctvo_cdgo_lqdcn;

	--Se realiza el calculo del codigo de barras
	Update		a
	Set			a.cdgo_brrs='(' + LTRIM(RTRIM(c.idntfcdor_aplccn)) + ')' +  ltrim(rtrim(c.cdgo_ps)) + ltrim(rtrim(c.cdgo_emprsa_iac)) + ltrim(rtrim(c.idntfccn_tpo_rcdo)) + ltrim(rtrim(c.dgto_cntrl))  +
				'(' + ltrim(rtrim(c.idntfcdor_aplccn_usro)) + ')'  +  
				right(replicate('0',8)+ltrim(rtrim(a.nmro_estdo_cnta)),8) + 
				'(' + ltrim(rtrim(c.idntfcdor_aplccn_usro)) + ')'  +  
				right(replicate('0',12)+ltrim(rtrim(d.nmro_idntfccn)),12) + 
				 '(' + ltrim(rtrim(c.idntfcdor_aplccn_usro_ia1))  + ')' +
				right(replicate('0',10)+ltrim(rtrim(convert(varchar(12),ttl_pgr))),10) + 
				'(' + ltrim(rtrim(c.idntfcdor_aplccn_usro_ia2)) + ')' + convert(varchar(10),h.fcha_pgo,112)     			
	From 		dbo.tbEstadosCuenta						a
	INNER JOIN  bdAfiliacion.dbo.tbVinculados			d With(NoLock)
		ON		a.nmro_unco_idntfccn_empldr = d.nmro_unco_idntfccn 
	INNER JOIN  dbo.tbLiquidaciones						g With(NoLock)
		ON		a.cnsctvo_cdgo_lqdcn = g.cnsctvo_cdgo_lqdcn 
	INNER JOIN  dbo.tbPeriodosliquidacion_Vigencias		h With(NoLock)
		ON		g.cnsctvo_cdgo_prdo_lqdcn = h.cnsctvo_cdgo_prdo_lqdcn 
	INNER JOIN  dbo.TbEstructuraCodigoBarras_vigencias  c With(NoLock)
       on       @ldFechaSistema between c.inco_vgnca and c. fn_vgnca
    Inner Join  #tmpCUFEGenerado t
       On       t.NmroCnta = a.nmro_estdo_cnta
    Where		c.cnsctvo_vgnca_estrctra_cdgo_brrs = 1   -- consecutivo del  codigo de barras
	and			@ldFechaSistema between c.inco_vgnca and c.fn_vgnca
	and			a.cnsctvo_cdgo_lqdcn = @cnsctvo_cdgo_lqdcn;

	-- Se traer los contratos asociados al responsable que no se liquidaron 
	Insert into	#tmpResultadosLogFinal
	Select		a.nmro_cntrto,	
				f.cdgo_tpo_idntfccn,	
				e.nmro_idntfccn,
				ltrim(rtrim(d.prmr_aplldo)) + ' ' + ltrim(rtrim(d.sgndo_aplldo)) + ' ' + ltrim(rtrim(d.prmr_nmbre)) + ' ' +ltrim(rtrim(sgndo_nmbre)) nombre,
				a.cnsctvo_cdgo_pln,		
				a.inco_vgnca_cntrto,	
				a.fn_vgnca_cntrto,	
				a.nmro_unco_idntfccn_afldo,
				p.cdgo_pln,	
				p. dscrpcn_pln,	
				b.causa,
				b.nmro_unco_idntfccn_empldr,
				b.cnsctvo_scrsl,
				b.cnsctvo_cdgo_clse_aprtnte,
				space(200)	nmbre_scrsl,
				space(100)	dscrpcn_clse_aprtnte,
				space(3)	tpo_idntfccn_scrsl,
				space(20)	nmro_idntfccn_scrsl,
				right(replicate('0',20)+ltrim(rtrim(b.nmro_unco_idntfccn_empldr)),20) + right(replicate('0',2)+ltrim(rtrim(b.cnsctvo_scrsl)),2) + right(replicate('0',2)+ltrim(rtrim(b.cnsctvo_cdgo_clse_aprtnte)),2)	Responsable
	From 		bdafiliacion.dbo.tbcontratos a With(NoLock)
	Inner Join	#TmpContratosNoFinalizados  b 
		On		(a.cnsctvo_cdgo_tpo_cntrto 	=	 b.cnsctvo_cdgo_tpo_cntrto
		And 	a.nmro_cntrto		  	= 	 b.nmro_cntrto)
	Inner Join	bdafiliacion.dbo.tbpersonas d  With(NoLock)
		On		(a.nmro_unco_idntfccn_afldo	=	d.nmro_unco_idntfccn)
	Inner Join	bdafiliacion.dbo.tbvinculados  e With(NoLock)
		On		(d.nmro_unco_idntfccn		=	e.nmro_unco_idntfccn)
	Inner Join	bdafiliacion.dbo.tbtiposidentificacion f With(NoLock)
		On		(e.cnsctvo_cdgo_tpo_idntfccn	=	f.cnsctvo_cdgo_tpo_idntfccn)
	Inner Join	bdplanbeneficios.dbo.tbplanes	p With(NoLock)
		On		(a.cnsctvo_cdgo_pln		=	p.cnsctvo_cdgo_pln)
	Order By	d.prmr_aplldo ,d.sgndo_aplldo,d.prmr_nmbre,d.sgndo_nmbre

	Update		a
	Set			nmbre_scrsl				=	s.nmbre_scrsl,
				dscrpcn_clse_aprtnte	=	c.dscrpcn_clse_aprtnte,
				tpo_idntfccn_scrsl		=	t.cdgo_tpo_idntfccn,
				nmro_idntfccn_scrsl		=	v.nmro_idntfccn
	From		#tmpResultadosLogFinal a 
	Inner Join	bdafiliacion.dbo.tbsucursalesaportante s With(NoLock)
		On		(a.nmro_unco_idntfccn_empldr	= s.nmro_unco_idntfccn_empldr
		And		a.cnsctvo_scrsl					= s.cnsctvo_scrsl 
		And		a.cnsctvo_cdgo_clse_aprtnte		= s.cnsctvo_cdgo_clse_aprtnte)
	Inner Join  bdafiliacion.dbo.tbvinculados v With(NoLock)
		On		(s.nmro_unco_idntfccn_empldr	=	v.nmro_unco_idntfccn)
	Inner Join	bdafiliacion.dbo.tbtiposidentificacion  t With(NoLock)
		On		(t.cnsctvo_cdgo_tpo_idntfccn	=	v.cnsctvo_cdgo_tpo_idntfccn)	
	Inner Join  bdafiliacion.dbo.tbclasesaportantes c With(NoLock)
		On		(a.cnsctvo_cdgo_clse_aprtnte	=	c.cnsctvo_cdgo_clse_aprtnte)


	----Se actualiza  el estad de la liquidacion
	If @lnEstadoLiquidacionActual = 5 --Liquidacion previa
	Begin 
		Update	dbo.tbLiquidaciones
		Set		cnsctvo_cdgo_estdo_lqdcn = 6 ----Finalizada de prueba
		Where	cnsctvo_cdgo_lqdcn=@cnsctvo_cdgo_lqdcn 
	End

	-- se obtienen los los parametros generales y los numeros de secuencia inicial y final empleados
	Select top 1 @cnsctvo_inco_usdo = a.cnsctvo_estdo_cnta
    From		dbo.tbEstadosCuenta a with(nolock)
    Where		a.cnsctvo_cdgo_lqdcn = @cnsctvo_cdgo_lqdcn
    Order by	a.cnsctvo_estdo_cnta DESC;

	Select top 1 @cnsctvo_fn_usdo = a.cnsctvo_estdo_cnta
    From		dbo.tbEstadosCuenta a with(nolock)
    Where		a.cnsctvo_cdgo_lqdcn = @cnsctvo_cdgo_lqdcn
    Order by	a.cnsctvo_estdo_cnta ASC;

	Select	@vrngo_inco_atrzdo_atrzcn	= a.rngo_inco_atrzdo_fctrcn,
			@vrngo_fn_atrzdo_fctrcn		= a.rngo_fn_atrzdo_fctrcn,
			@fcha_fn_atrzcn_fctrcn		= a.fcha_fn_atrzcn_fctrcn
	From	BDAfiliacionValidador.dbo.tbResolucionesDIAN_Vigencias a with(nolock)
	Where   @ldFechaSistema between a.inco_vgnca and a.fn_vgnca
	And		a.vsble_usro				= @registroValidoSi

	Set @lcMensaje = 'Finalizó con éxito y Actualizo los saldos a Favor ' + char(13)+ char(13) +
					 '- Rango de Facturas generadas: ' + rtrim(ltrim(convert(varchar(15),@cnsctvo_inco_usdo))) + ' - ' + rtrim(ltrim(convert(varchar(15),@cnsctvo_fn_usdo))) + char(13) +
					 '- Rango numeración autorizada: ' + @vrngo_inco_atrzdo_atrzcn + ' - ' + @vrngo_fn_atrzdo_fctrcn + char(13) +
					 '- Fecha fin vigencia resolución: ' + convert(varchar(20),@fcha_fn_atrzcn_fctrcn,103) + char(13);

	Select		nmro_cntrto,
				cdgo_tpo_idntfccn, 
				nmro_idntfccn,
				nombre,
				cnsctvo_cdgo_pln,
				inco_vgnca_cntrto,
				fn_vgnca_cntrto,
				nmro_unco_idntfccn_afldo,
				cdgo_pln,
				dscrpcn_pln,  
				causa,
				nmro_unco_idntfccn_empldr,
				cnsctvo_scrsl,
				cnsctvo_cdgo_clse_aprtnte ,
				nmbre_scrsl ,
				dscrpcn_clse_aprtnte,
				tpo_idntfccn_scrsl ,
				nmro_idntfccn_scrsl ,
				Responsable
	From		#tmpResultadosLogFinal
	Order by 	nmbre_scrsl, nombre

	Commit tran

END