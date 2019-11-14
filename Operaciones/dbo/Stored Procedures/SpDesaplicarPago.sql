
/*---------------------------------------------------------------------------------
* Metodo o PRG		:  SpDesaplicarPago
* Desarrollado por	: <\A Ing. Rolando simbaqueva Lasso				A\>
* Descripcion		: <\D Este procedimiento  permite desaplicar el pago		D\>
* Observaciones		: <\O  								O\>
* Parametros		: <\P								P\>
* Variables		: <\V  								V\>
* Fecha Creacion	: <\FC 2003/03/04						FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por	: <\AM	Ing. Jorge Ivan Rivera Gallego				AM\>
* Descripcion		: <\DM	Aplicación proceso optimización técnica			DM\>
* Nuevos Parametros	: <\PM	PM\>
* Nuevas Variables	: <\VM	VM\>
* Fecha Modificacion	: <\FM	2005/09/12						FM\>
*---------------------------------------------------------------------------------*/
CREATE  PROCEDURE SpDesaplicarPago
	
@nmro_Pgo			UdtConsecutivo,
@nmro_unco_idntfccn_empldr	UdtConsecutivo,
@cnsctvo_scrsl			UdtConsecutivo,
@cnsctvo_cdgo_clse_aprtnte	UdtConsecutivo,	
@lnInicializaNui		UdtConsecutivo,
@lcUsuario			UdtUsuario,
@lnProcesoExitoso		Int		Output,
@lcMensaje			Char(200)	Output
	
As

Declare
@ldFechaSistema				Datetime,
@lnTotalValorNotasDebito		numeric(12,0),
@lntotalValorEstadosCuenta		numeric(12,0),
@cnsctvo_hstrco_abno_cntrto_dsplcdo	udtconsecutivo,
@cnsctvo_hstrco_estdo_pgo		udtconsecutivo,
@cnsctvo_hstrco_abno_nta_cntrto_dsplcdo	udtconsecutivo,
@lnEstadoActualPago			udtconsecutivo,
@lnAplicadaComision			udtconsecutivo

Set  nocount on

-- Se crea la tabla temporal #tmpPagos en lugar de utilizarla como una tabla derivada ya que es
-- necesario utilizarla en varios pasos del proceso.

Create	table #tmpPagos
	(cnsctvo_estdo_cnta udtConsecutivo,	vlr_abno udtValorGrande)

-- Se crea la tabla temporal #tmpPagosNotas en lugar de utilizarla como una tabla derivada ya que es
-- necesario utilizarla en varios pasos del proceso.
Create	table #tmpPagosNotas
	(nmro_nta Varchar(15),	cnsctvo_cdgo_tpo_nta udtConsecutivo,
	 vlr udtValorGrande)

-- Se crea la tabla temporal #tmpPagosNotas en lugar de utilizarla como una tabla derivada ya que es
-- necesario utilizarla en varios pasos del proceso.
Create	Table #tmpAbonosContrato
	(cnsctvo_estdo_cnta_cntrto udtConsecutivo,	vlr_abno_cta udtValorGrande,
	 vlr_abno_iva udtValorGrande)

--Se crea una tabla temporal con la informacion del pago que se desea desaplicar

Create	table #tmpHistoricoAbonosContrato
	(nmro_rgstro Int IDENTITY(1,1),			cnsctvo_cdgo_pgo udtConsecutivo,
	 cnsctvo_estdo_cnta_cntrto udtConsecutivo,	vlr_abno_cta udtValorGrande,
	 vlr_abno_iva udtValorGrande)

Create	table #tmpHistoricoAbonoNotaContratoDesaplicado
	(nmro_rgstro Int IDENTITY(1,1),		cnsctvo_cdgo_pgo udtConsecutivo,
	 cnsctvo_nta_cntrto udtConsecutivo,	vlr_nta_cta udtValorGrande,
	 vlr_nta_iva udtValorGrande)

Set @ldFechaSistema	= Getdate()

Set @lnProcesoExitoso	= 0

Select	@lnEstadoActualPago	= cnsctvo_cdgo_estdo_pgo
From	bdCarteraPac.dbo.tbPagos
Where	cnsctvo_cdgo_pgo	= @nmro_Pgo


If @lnEstadoActualPago	= 1	--No se puede desaplicar un pago que su estado este sin aplicar
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'No se puede desaplicar el pago su estado no lo permite'
	Return -1
End

--se hace para estado de cuentas

Select	@lnAplicadaComision	= Count(1)
From	bdCarteraPac.dbo.tbAbonosContrato
Where	cnsctvo_cdgo_pgo	= @nmro_Pgo
And	Pgdo_Cmsn		= 'S'

If @lnAplicadaComision	>= 1	--No se puede desaplicar un pago que su estado este sin aplicar
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'No se puede desaplicar el pago a un estado de cuenta  tiene aplicada comision'
	Return -1
End

--ahora se hace para notas debito

Select	@lnAplicadaComision	= Count(1)
From	bdCarteraPac.dbo.TbAbonosNotasContrato
Where	cnsctvo_cdgo_pgo	= @nmro_Pgo
And	Pgdo_Cmsn		= 'S'

If @lnAplicadaComision	>= 1	--No se puede desaplicar un pago que su estado este sin aplicar
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'No se puede desaplicar el pago a una nota tiene aplicada comision'
	Return -1
End

Begin Tran

--trae los abonos de los estados de cuenta

Insert	Into #tmpPagos
	(cnsctvo_estdo_cnta,	vlr_abno)
Select	cnsctvo_estdo_cnta, 	vlr_abno
From 	bdCarteraPac.dbo.tbAbonos
Where	cnsctvo_cdgo_pgo	= @nmro_Pgo

--trae las notas de los pagos

Insert	Into #tmpPagosNotas
	(nmro_nta,	cnsctvo_cdgo_tpo_nta,
	 vlr)
Select	nmro_nta,	cnsctvo_cdgo_tpo_nta,
	vlr
From	bdCarteraPac.dbo.tbPagosNotas
Where 	cnsctvo_cdgo_pgo	=	@nmro_Pgo

--calcula el valor total por estadoa de cuenta asociadas al pago que se va reversar

Select	@lntotalValorEstadosCuenta	= IsNull(Sum(vlr_abno),0)
From	#tmpPagos

--Se calcula el valor total por notas debito asociadas al pago

Select	@lnTotalValorNotasDebito	= IsNull(Sum(vlr),0)
From	#tmpPagosNotas

--se actualiza para los estados de cuenta

Update	bdCarteraPac.dbo.tbEstadosCuenta
Set	sldo_estdo_cnta	= sldo_estdo_cnta + vlr_abno
From	bdCarteraPac.dbo.tbEstadosCuenta a Inner Join
	#tmpPagos b
On	a.cnsctvo_estdo_cnta	= b.cnsctvo_estdo_cnta

If @@error!= 0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error Actualizando el saldo del estado de cuenta'
	Rollback Tran
	Return -1
End

Update	bdCarteraPac.dbo.tbEstadosCuenta
Set	cnsctvo_cdgo_estdo_estdo_cnta	= 1
From	bdCarteraPac.dbo.tbEstadosCuenta a Inner Join
	#tmpPagos b
On	a.cnsctvo_estdo_cnta	= b.cnsctvo_estdo_cnta
And	a.ttl_pgr		= a.sldo_estdo_cnta

If @@error!= 0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error Actualizando el estado del estado de cuuenta'
	Rollback Tran
	Return -1
End

--se actualiza para las notas debito

Update	bdCarteraPac.dbo.tbNotasPac
Set	sldo_nta	= sldo_nta + vlr
From	bdCarteraPac.dbo.tbNotasPac a Inner Join
	#tmpPagosNotas b
On	a.nmro_nta		= b.nmro_nta
And	a.cnsctvo_cdgo_tpo_nta	= b.cnsctvo_cdgo_tpo_nta

If @@error!= 0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error Actualizando el saldo de la nota'
	Rollback Tran
	Return -1
End


Update	bdCarteraPac.dbo.tbNotasPac
Set	cnsctvo_cdgo_estdo_nta	= 1
From	bdCarteraPac.dbo.tbNotasPac a Inner Join
	#tmpPagosNotas b
On	a.nmro_nta		= b.nmro_nta
And	a.cnsctvo_cdgo_tpo_nta	= b.cnsctvo_cdgo_tpo_nta
And	a.vlr_nta + a.vlr_iva  	= a.sldo_nta

If @@error!= 0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error Actualizando el estado de la nota'
	Rollback Tran
	Return -1
End

-- seleciona los contratos que tiene asociado el   pago

Insert	Into #tmpAbonosContrato
	(cnsctvo_estdo_cnta_cntrto,	vlr_abno_cta,
	 vlr_abno_iva)
Select	cnsctvo_estdo_cnta_cntrto,	vlr_abno_cta,
	vlr_abno_iva
From 	bdCarteraPac.dbo.tbAbonosContrato
Where   cnsctvo_cdgo_pgo	=	@nmro_Pgo

--actualiza el saldo del estado  a los contratos asociados al pago

Update	bdCarteraPac.dbo.tbEstadosCuentaContratos
Set	sldo			= sldo + b.vlr_abno_cta	+ b.vlr_abno_iva,
	fcha_ultma_mdfccn	= @ldFechaSistema,
	usro_ultma_mdfccn	= @lcUsuario
From	bdCarteraPac.dbo.tbEstadosCuentaContratos a Inner Join
	#tmpAbonosContrato b
On	a.cnsctvo_estdo_cnta_cntrto	= b.cnsctvo_estdo_cnta_cntrto

If @@error!= 0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error Actualizando los contratos del estado de cuenta'
	Rollback Tran
	Return -1
End

Select	@cnsctvo_hstrco_abno_cntrto_dsplcdo	= IsNull(Max(cnsctvo_hstrco_abno_cntrto_dsplcdo),0)
From	bdCarteraPac.dbo.tbHistoricoAbonoContratoDesaplicado

Insert	Into #tmpHistoricoAbonosContrato
	(cnsctvo_cdgo_pgo,	cnsctvo_estdo_cnta_cntrto,
	 vlr_abno_cta,		vlr_abno_iva)
Select	cnsctvo_cdgo_pgo,	cnsctvo_estdo_cnta_cntrto,
	vlr_abno_cta,		vlr_abno_iva
From	bdCarteraPac.dbo.tbAbonosContrato
Where  cnsctvo_cdgo_pgo	= @nmro_Pgo

If @@Error!= 0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error creando la historia del pago'
	Rollback Tran
	Return -1
End

--Se inserta la historia del del abono del pago

Insert	Into bdCarteraPac.dbo.tbHistoricoAbonoContratoDesaplicado
	(cnsctvo_hstrco_abno_cntrto_dsplcdo,			cnsctvo_cdgo_pgo,
	 cnsctvo_estdo_cnta_cntrto,				vlr_abno_cta,
	 vlr_abno_iva,						fcha_crcn,
	 usro_crcn)
Select	(nmro_rgstro + @cnsctvo_hstrco_abno_cntrto_dsplcdo),	cnsctvo_cdgo_pgo,
	cnsctvo_estdo_cnta_cntrto,				vlr_abno_cta,
	vlr_abno_iva,						@ldFechaSistema,
	@lcUsuario
From	#tmpHistoricoAbonosContrato

If @@Error!= 0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error inserta la historia del abono de desaplicado'
	Rollback Tran
	Return -1
End

--Se borra la infroamcion de los abonos de cada contrato asociado al pago

Delete From bdCarteraPac.dbo.tbAbonosContrato Where cnsctvo_cdgo_pgo	= @nmro_Pgo

If @@Error!= 0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error Eliminando Abonos del Contrato'
	Rollback Tran
	Return -1
End

Delete From bdCarteraPac.dbo.tbAbonos	Where cnsctvo_cdgo_pgo	= @nmro_Pgo

If @@Error!= 0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error Eliminando Abonos del Estado de Cuenta'
	Rollback Tran
	Return -1
End

--Ahora se hace para las notas que tiene asociado el pago


--actualiza el saldo de la nota de cada contrato afectado

Update tbNotasContrato
Set	sldo_nta_cntrto	=	sldo_nta_cntrto	 + 	b.vlr_nta_cta	+	b.vlr_nta_iva,
	fcha_ultma_mdfccn	=	@ldFechaSistema,
	usro_ultma_mdfccn	=	@lcUsuario
From	tbNotasContrato	 a Inner Join
	(Select	cnsctvo_nta_cntrto,	vlr_nta_cta,
		vlr_nta_iva
	 From	bdCarteraPac.dbo.TbAbonosNotasContrato
	 Where	cnsctvo_cdgo_pgo	= @nmro_Pgo) b
On	a.cnsctvo_nta_cntrto	= b.cnsctvo_nta_cntrto

If @@Error!= 0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error Actualizando la informacion del saldo de la nota del contrato'
	Rollback Tran
	Return -1
End

--Buscamos el maximo consecutivo de  la historia

Select	@cnsctvo_hstrco_abno_nta_cntrto_dsplcdo	= Isnull(Max(cnsctvo_hstrco_abno_nta_cntrto_dsplcdo),0)
From	bdCarteraPac.dbo.tbHistoricoAbonoNotaContratoDesaplicado

--Se crea una tabla temporal con la informacion del pago que se desea desaplicar para la nota

Insert	Into #tmpHistoricoAbonoNotaContratoDesaplicado
	(cnsctvo_cdgo_pgo,	cnsctvo_nta_cntrto,
	 vlr_nta_cta,		vlr_nta_iva)
Select	cnsctvo_cdgo_pgo,	cnsctvo_nta_cntrto,
	vlr_nta_cta,		vlr_nta_iva
From	bdCarteraPac.dbo.TbAbonosNotasContrato
Where	cnsctvo_cdgo_pgo	= @nmro_Pgo

If @@Error!= 0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error creando la historia del pago de la nota'
	Rollback Tran
	Return -1
End

--Se inserta la historia del del abono del pago

Insert	Into bdCarteraPac.dbo.tbHistoricoAbonoNotaContratoDesaplicado
	(cnsctvo_hstrco_abno_nta_cntrto_dsplcdo,		cnsctvo_cdgo_pgo,
	 cnsctvo_nta_cntrto,					vlr_nta_cta,
	 vlr_nta_iva,						fcha_crcn,
	 usro_crcn)
Select	(nmro_rgstro + @cnsctvo_hstrco_abno_nta_cntrto_dsplcdo),cnsctvo_cdgo_pgo,
	 cnsctvo_nta_cntrto,					vlr_nta_cta,
	 vlr_nta_iva,						@ldFechaSistema,
	 @lcUsuario
From	#tmpHistoricoAbonoNotaContratoDesaplicado

If @@Error!= 0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error inserta la historia del abono de la nota desaplicado'
	Rollback Tran
	Return -1
End

-- se borra la informacio de las pagos con la nota credito

Delete From bdCarteraPac.dbo.TbAbonosNotasContrato Where cnsctvo_cdgo_pgo = @nmro_Pgo

If @@Error!= 0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error Eliminando notas  del pago'
	Rollback Tran
	Return -1
End

Delete From bdCarteraPac.dbo.tbPagosNotas Where cnsctvo_cdgo_pgo = @nmro_Pgo

If @@Error!= 0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error Eliminando notas  del pago'
	Rollback Tran
	Return -1
End

--Se actualiza el  pago

Update	bdCarteraPac.dbo.tbPagos
Set	fcha_aplccn		= NULL,
	usro_aplccn		= NULL,
	sldo_pgo		= vlr_dcmnto,
	cnsctvo_cdgo_estdo_pgo	= 1, --Sin aplicar,
	nmro_unco_idntfccn_empldr =	Case When	@lnInicializaNui = 1	Then 0
					Else		nmro_unco_idntfccn_empldr End,
	cnsctvo_scrsl		=	Case When	@lnInicializaNui = 1	Then 0
					Else		cnsctvo_scrsl End,
	cnsctvo_cdgo_clse_aprtnte =	Case When	@lnInicializaNui = 1	Then 0
					Else		cnsctvo_cdgo_clse_aprtnte End
Where	cnsctvo_cdgo_pgo	= @nmro_Pgo

If @@Error!= 0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error Actualizando el Estado del Pago'
	Rollback Tran
	Return -1
End

--Se guarda la historia del pago

--Se calcula el maximo consecutivo del pago

Select	@cnsctvo_hstrco_estdo_pgo	= Isnull(Max(cnsctvo_hstrco_estdo_pgo),0)
From	bdCarteraPac.dbo.TbHistoricoEstadoXPago

Insert	Into bdCarteraPac.dbo.TbHistoricoEstadoXPago
	(cnsctvo_hstrco_estdo_pgo,		cnsctvo_cdgo_estdo_pgo,
	 cnsctvo_cdgo_pgo,			sldo_pgo,
	 nmro_unco_idntfccn_empldr,		cnsctvo_scrsl,
	 cnsctvo_cdgo_clse_aprtnte,		usro_crcn,
	 fcha_crcn)
Select	(@cnsctvo_hstrco_estdo_pgo + 1),	cnsctvo_cdgo_estdo_pgo,
	cnsctvo_cdgo_pgo,			sldo_pgo,
	nmro_unco_idntfccn_empldr,		cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte,		@lcUsuario,
	@ldFechaSistema
From	bdCarteraPac.dbo.tbPagos
Where	cnsctvo_cdgo_pgo	= @nmro_Pgo

If @@Error!= 0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error Insertando la historia del pago'
	Rollback Tran
	Return -1
End

-- se debe de actualizar el saldo del contrato para ese responsable tanto de las
-- notas debito como los estados de cuenta

/*
Update	bdCarteraPac.dbo.tbAcumuladosContrato
Set	vlr_sldo	= a.vlr_sldo + b.vlr_nta_cta + b.vlr_nta_iva
From	bdCarteraPac.dbo.tbAcumuladosContrato	a Inner Join
	(Select	a.cnsctvo_cdgo_tpo_cntrto,	a.nmro_cntrto,
		b.vlr_nta_cta,			b.vlr_nta_iva
	 From 	bdCarteraPac.dbo.tbNotasContrato a Inner Join
		(Select	cnsctvo_nta_cntrto,	vlr_nta_cta,
			vlr_nta_iva
		 From	bdCarteraPac.dbo.TbAbonosNotasContrato
		 Where	cnsctvo_cdgo_pgo= @nmro_Pgo)  b
	 On	a.cnsctvo_nta_cntrto	= b.cnsctvo_nta_cntrto) b
On	a.cnsctvo_cdgo_tpo_cntrto 	= b.cnsctvo_cdgo_tpo_cntrto 
And	a.nmro_cntrto			= b.nmro_cntrto
And	a.ultma_oprcn 			= 1
And	a.nmro_unco_idntfccn_empldr	= @nmro_unco_idntfccn_empldr
And	a.cnsctvo_scrsl			= @cnsctvo_scrsl
And	a.cnsctvo_cdgo_clse_aprtnte	= @cnsctvo_cdgo_clse_aprtnte

If @@Error!= 0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error Actualizando el saldo del contrato de las notas debito'
	Rollback Tran
	Return -1
End

Update	bdCarteraPac.dbo.tbAcumuladosContrato
Set	vlr_sldo	= a.vlr_sldo + b.vlr_abno_cta +	b.vlr_abno_iva
From	bdCarteraPac.dbo.tbAcumuladosContrato	a Inner Join
	(Select	a.cnsctvo_cdgo_tpo_cntrto,	a.nmro_cntrto,
		b.vlr_abno_cta,			b.vlr_abno_iva
	 From	bdCarteraPac.dbo.tbEstadosCuentaContratos a Inner Join
		#tmpAbonosContrato b
	 On	a.cnsctvo_estdo_cnta_cntrto	= b.cnsctvo_estdo_cnta_cntrto) b
On	a.cnsctvo_cdgo_tpo_cntrto 	= b.cnsctvo_cdgo_tpo_cntrto 
And	a.nmro_cntrto			= b.nmro_cntrto
And	a.ultma_oprcn 			= 1
And	a.nmro_unco_idntfccn_empldr	= @nmro_unco_idntfccn_empldr
And	a.cnsctvo_scrsl			= @cnsctvo_scrsl
And	a.cnsctvo_cdgo_clse_aprtnte	= @cnsctvo_cdgo_clse_aprtnte

If  @@Error!= 0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error Actualizando el saldo del contrato de los estados de cuenta'
	Rollback Tran
	Return -1
End

--Se debe de actualizar el saldo a nivel del resposable del pago tanto el valor de notas debito como estados de cuenta

Update	bdCarteraPac.dbo.tbAcumuladosSucursalAportante
Set	vlr_sldo	= vlr_sldo + @lnTotalValorNotasDebito +	@lntotalValorEstadosCuenta
Where	nmro_unco_idntfccn_empldr	= @nmro_unco_idntfccn_empldr
And	cnsctvo_scrsl			= @cnsctvo_scrsl
And	cnsctvo_cdgo_clse_aprtnte	= @cnsctvo_cdgo_clse_aprtnte
And	ultma_oprcn			= 1

If @@Error!= 0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error Actualizando el saldo del responsable  del Pago'
	Rollback Tran
	Return -1
End
*/

Commit Tran

