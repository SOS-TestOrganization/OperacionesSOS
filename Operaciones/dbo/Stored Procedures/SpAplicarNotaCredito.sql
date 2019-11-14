
/*---------------------------------------------------------------------------------
* Metodo o PRG		:  SpAplicarNotaCredito
* Desarrollado por	: <\A Ing. Rolando simbaqueva Lasso				A\>
* Descripcion		: <\D Este procedimiento grabar una nota credito		D\>
* Observaciones		: <\O  								O\>
* Parametros		: <\P								P\>
* Variables		: <\V  								V\>
* Fecha Creacion	: <\FC 2003/03/04						FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por	: <\AM	Ing. Jorge Ivan Rivera					AM\>
* Descripcion		: <\DM  Aplicación proceso optimización técnica			DM\>
* Nuevos Parametros	: <\PM  PM\>
* Nuevas Variables	: <\VM  VM\>
* Fecha Modificacion	: <\FM  2005/09/14						FM\>
*---------------------------------------------------------------------------------*/

CREATE  PROCEDURE SpAplicarNotaCredito

@lcTipoNota			udtConsecutivo,
@nmro_nta			Varchar(15),	
@sldo_nta			udtValorGrande,
@lnTotalValorAplicado		udtValorGrande,
@nmro_unco_idntfccn_empldr	udtConsecutivo,
@cnsctvo_scrsl			udtConsecutivo,
@cnsctvo_cdgo_clse_aprtnte	udtConsecutivo,	
@lcUsuario			udtUsuario,
@lnProcesoExitoso		Int		Output,
@lcMensaje			Char(200)	Output


As	Declare

@ldFechaSistema			Datetime,
@lnConsecutivoTipoNotaDebito	udtConsecutivo,
@lnMax_cnsctvo_nta_aplcda	udtConsecutivo,
@lnMax_cnsctvo_estdo_nta	udtConsecutivo,
@valor_nota			udtValorGrande,
@Valor_iva_nota			udtValorGrande,
@Valor_saldo_nota		udtValorGrande,
@lnNuevoEstadoNotaCredito	udtConsecutivo,
@lnActualEstadoNotaCredito	udtConsecutivo,
@MaximoConsecutivoResponsable	Int

Set Nocount On

Create	Table #TmpdocumentosdebitoAplicar
	(nmro_rgstro Int IDENTITY(1,1),			nmro_nta_aplcda Varchar(15),
	 cnsctvo_cdgo_tpo_nta_aplcda udtConsecutivo,	vlr_aplcr udtValorGrande)

--se crea uan tabla temporal con todas las notas que tiene movimiento

Create	Table #tmpEstadosXtipoNota
	(nmro_rgstro Int IDENTITY(1,1),		nmro_nta Varchar(15),
	 cnsctvo_cdgo_tpo_nta udtConsecutivo,	cnsctvo_cdgo_estdo_nta udtConsecutivo,
	 vlr_nta udtValorGrande,		vlr_iva udtValorGrande,
	 sldo_nta udtValorGrande)

-- Se crea una tabla temporal que va contener los responsables del pago
/*
Create	Table #TmpSaldosResponsable
	(cnsctvo_acmldo_scrsl_aprtnte udtConsecutivo,	nmro_unco_idntfccn_empldr udtConsecutivo,
	 cnsctvo_scrsl udtConsecutivo,			cnsctvo_cdgo_clse_aprtnte udtConsecutivo,
	 tpo_dcmnto udtConsecutivo,			nmro_dcmnto Varchar(15),
	 dbts udtValorGrande,				crdts udtValorGrande,
	 vlr_sldo udtValorGrande,			intrs_mra udtValorGrande,
	 cntdd_fctrs_mra udtValorPequeno,		fcha_ultmo_pgo Datetime,
	 fcha_ultma_fctra Datetime,			fcha_mra Datetime,
	 ultma_oprcn udtValorPequeno,			nmro_nta Int,
	 sldo_nta udtValorGrande,			fcha_crcn_nta Datetime,
	 ID_Num Int IDENTITY(1,1))
*/
Set @ldFechaSistema			= Getdate()
Set @lnConsecutivoTipoNotaDebito	= 1
Set @lnProcesoExitoso			= 0

If @sldo_nta = 0
	Set @lnNuevoEstadoNotaCredito	= 4
Else
 	Set @lnNuevoEstadoNotaCredito	= 7

Select	@lnActualEstadoNotaCredito	= cnsctvo_cdgo_estdo_nta
From	bdCarteraPac.dbo.tbNotasPac  a
Where	a.nmro_nta			= @nmro_nta
And	a.cnsctvo_cdgo_tpo_nta		= @lcTipoNota

If @lnActualEstadoNotaCredito	= 4	--esta aplicada en su totalidad entonces no debe permitir
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'No se puede actualizar la nota credito su estado no lo permite'
	Return -1
End

Begin Tran

-- se insertan los que tienen  estados de cuenta como documento debito

Insert	Into bdCarteraPac.dbo.tbNotasEstadoCuenta
	(nmro_nta,			cnsctvo_cdgo_tpo_nta,
	 cnsctvo_estdo_cnta,		vlr,
	 fcha_aplccn,			usro_aplccn)
Select	@nmro_nta,			@lcTipoNota,
	Consecutivo_documento_origen,	vlr_aplcr,
	@ldFechaSistema,		@lcUsuario
From 	#Tmpdocumentosdebito
Where	cnsctvo_cdgo_tpo_dcmnto	= 1
And	vlr_aplcr		> 0

If @@Error!= 0
Begin 
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error insertando los estados de cuenta'
	Rollback Tran
	Return -1
End

--actualiza el saldo de los estados de cuenta

Update 	bdCarteraPac.dbo.tbEstadosCuenta
Set	sldo_estdo_cnta		= sldo_estdo_cnta - vlr_aplcr
From	bdCarteraPac.dbo.tbEstadosCuenta  a Inner Join
	#Tmpdocumentosdebito  b
On	a.cnsctvo_estdo_cnta	= b.Consecutivo_documento_origen
Where	cnsctvo_cdgo_tpo_dcmnto	= 1
And	vlr_aplcr		> 0

If @@Error!= 0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error actualizando  el saldo de los estados de cuenta'
	Rollback Tran
	Return -1
End

--actualiza el  estado del	 los estados de cuenta

Update	bdCarteraPac.dbo.tbEstadosCuenta
Set	cnsctvo_cdgo_estdo_estdo_cnta	= Case	When sldo_estdo_cnta	= 0	Then 3 Else 2 End  -- o queda cancelada total o cancelada parcial
From	bdCarteraPac.dbo.tbEstadosCuenta  a Inner Join
	#Tmpdocumentosdebito b
On	a.cnsctvo_estdo_cnta	= b.Consecutivo_documento_origen
Where	cnsctvo_cdgo_tpo_dcmnto	= 1
And	vlr_aplcr		> 0

If @@Error!= 0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error actualizando  el estado de los  estados de cuenta de cuenta'
	Rollback Tran
	Return -1
End

-- se crea una tabal temporal con las notas debito

Insert	Into #TmpdocumentosdebitoAplicar
	(nmro_nta_aplcda,				cnsctvo_cdgo_tpo_nta_aplcda,
	 vlr_aplcr)
Select	Convert(Varchar(15),Consecutivo_documento_origen), @lnConsecutivoTipoNotaDebito,
	vlr_aplcr
From	#Tmpdocumentosdebito
Where	cnsctvo_cdgo_tpo_dcmnto	= 2   --notas debito
And	vlr_aplcr		> 0


-- se calcula le maximo consecutivo de notas aplicadas

Select	@lnMax_cnsctvo_nta_aplcda	= IsNull(Max(cnsctvo_nta_aplcda),0)
From	bdCarteraPac.dbo.tbNotasAplicadas

-- se inserta la informacion de tbnotasaplicadas

Insert	Into bdCarteraPac.dbo.tbNotasAplicadas
	(cnsctvo_nta_aplcda,			nmro_nta,
	 cnsctvo_cdgo_tpo_nta,			nmro_nta_aplcda,
	 cnsctvo_cdgo_tpo_nta_aplcda,		vlr_aplcdo,
	 fcha_crcn,				usro_crcn)
Select	nmro_rgstro + @lnMax_cnsctvo_nta_aplcda,@nmro_nta,
	@lcTipoNota,				nmro_nta_aplcda,
	cnsctvo_cdgo_tpo_nta_aplcda,		vlr_aplcr,
	@ldFechaSistema,			@lcUsuario
From	#TmpdocumentosdebitoAplicar

If @@Error!= 0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error insertando las notas debito'
	Rollback Tran
	Return -1
End

--actualiza el saldo de las notas debito

Update	bdCarteraPac.dbo.tbNotasPac
Set	sldo_nta	= sldo_nta - vlr_aplcr
From	bdCarteraPac.dbo.tbNotasPac a Inner Join
	#Tmpdocumentosdebito b
On	a.nmro_nta		= b.Consecutivo_documento_origen
Where	a.cnsctvo_cdgo_tpo_nta	= 1
And	cnsctvo_cdgo_tpo_dcmnto	= 2	-- documento nota debito
And	vlr_aplcr		> 0

If @@Error!= 0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error actualizando  el saldo de las notas debito'
	Rollback Tran
	Return -1
End

--actualiza el  estado del	 los estados de cuenta

Update 	bdCarteraPac.dbo.tbNotasPac
Set	cnsctvo_cdgo_estdo_nta	= Case	When sldo_nta =	0 Then 3 Else 2 End  -- o queda cancelada total o cancelada parcial
From	bdCarteraPac.dbo.tbNotasPac a Inner Join
	#Tmpdocumentosdebito b
On	a.nmro_nta		= b.Consecutivo_documento_origen
Where	a.cnsctvo_cdgo_tpo_nta	= 1
And	cnsctvo_cdgo_tpo_dcmnto	= 2	-- documento nota debito
And	vlr_aplcr		> 0

If @@Error!= 0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error actualizando  el estado de la notas debito'
	Rollback Tran
	Return -1
End

-- se actualiza los estados de las notas

Insert	Into #tmpEstadosXtipoNota
	(nmro_nta,			cnsctvo_cdgo_tpo_nta,
	 cnsctvo_cdgo_estdo_nta,	vlr_nta,
	 vlr_iva,			sldo_nta)
Select	nmro_nta,			cnsctvo_cdgo_tpo_nta,
	cnsctvo_cdgo_estdo_nta,		vlr_nta,
	vlr_iva,			sldo_nta
From	bdCarteraPac.dbo.tbNotasPac a Inner Join
	#Tmpdocumentosdebito b
On	a.nmro_nta		= b.Consecutivo_documento_origen
Where	a.cnsctvo_cdgo_tpo_nta	= 1
And	cnsctvo_cdgo_tpo_dcmnto	= 2	-- documento nota debito
And	vlr_aplcr		> 0

-- se consulta el maximo consecutivo que siguie para el estado por nota
-- se guardan todos los estado por nota

Select	@lnMax_cnsctvo_estdo_nta	= IsNull(Max(cnsctvo_estdo_nta),0)
From	bdCarteraPac.dbo.tbEstadosxNota

Insert	Into bdCarteraPac.dbo.tbEstadosxNota
	(cnsctvo_estdo_nta,			nmro_nta,
	 cnsctvo_cdgo_tpo_nta,			cnsctvo_cdgo_estdo_nta,
	 vlr_nta,				vlr_iva,
	 sldo_nta,				fcha_cmbo_estdo,
	 usro_cmbo_estdo)
Select	nmro_rgstro + @lnMax_cnsctvo_estdo_nta,	nmro_nta,
	cnsctvo_cdgo_tpo_nta,			cnsctvo_cdgo_estdo_nta,
	vlr_nta,				vlr_iva,
	sldo_nta,				@ldFechaSistema,
	@lcUsuario
From	#tmpEstadosXtipoNota

If  @@Error!= 0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error insertando historico los  estado de  la nota'
	Rollback Tran
	Return -1
End

--Se actiualiza el saldo del documento credito

Update	bdCarteraPac.dbo.tbNotasPac
Set	sldo_nta		= @sldo_nta,	-- aplicada Tota ,, -- aplicada parcial
	cnsctvo_cdgo_estdo_nta	= @lnNuevoEstadoNotaCredito
Where	nmro_nta		= @nmro_nta
And	cnsctvo_cdgo_tpo_nta	= @lcTipoNota

If @@Error!= 0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error actualizando  el saldo del documento credito'
	Rollback Tran
	Return -1
End

--se actualiza el  historico del estado de la nota credito
-- se consulta el maximo consecutivo que siguie para el estado por nota
-- se guardan todos los estado por nota

Select	@lnMax_cnsctvo_estdo_nta	= Isnull(Max(cnsctvo_estdo_nta),0)
From	bdCarteraPac.dbo.tbEstadosxNota

Select	@valor_nota		= vlr_nta,
	@Valor_iva_nota  	= vlr_iva,
	@Valor_saldo_nota	= sldo_nta
From	TbnotasPac  a
Where	a.nmro_nta		= @nmro_nta
And	a.cnsctvo_cdgo_tpo_nta	= @lcTipoNota

Insert	Into bdCarteraPac.dbo.tbEstadosxNota
	(cnsctvo_estdo_nta,		nmro_nta,
	 cnsctvo_cdgo_tpo_nta,		cnsctvo_cdgo_estdo_nta,
	 vlr_nta,			vlr_iva,
	 sldo_nta,			fcha_cmbo_estdo,
	 usro_cmbo_estdo)
Values	(@lnMax_cnsctvo_estdo_nta + 1,	@nmro_nta,
	 @lcTipoNota,			@lnNuevoEstadoNotaCredito,
	 @valor_nota,			@Valor_iva_nota,
	 @Valor_saldo_nota,		@ldFechaSistema,
	 @lcUsuario)

If @@Error!= 0
Begin 
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error insertando historico del estado de  la nota credito'
	Rollback Tran
	Return -1
End

-- se actualiza el saldo del responsable del pago. y solamente las notas debito
/*
Select	@MaximoConsecutivoResponsable 	= IsNull(Max(cnsctvo_acmldo_scrsl_aprtnte),0)
From	bdCarteraPac.dbo.tbAcumuladosSucursalAportante

-- se inserta en la tabla tempora la informacion del resposable  que tiene aociado la nota
Insert	Into #TmpSaldosResponsable
	(cnsctvo_acmldo_scrsl_aprtnte,	nmro_unco_idntfccn_empldr,
	 cnsctvo_scrsl,			cnsctvo_cdgo_clse_aprtnte,
	 tpo_dcmnto,			nmro_dcmnto,
	 dbts,				crdts,
	 vlr_sldo,			intrs_mra,
	 cntdd_fctrs_mra,		fcha_ultmo_pgo,
	 fcha_ultma_fctra,		fcha_mra,
	 ultma_oprcn,			nmro_nta,
	 sldo_nta,			fcha_crcn_nta)
Select	0,				nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl,			cnsctvo_cdgo_clse_aprtnte,
	3,				nmro_nta,   -- nota credito
	0,				@lnTotalValorAplicado,
	0,				0,
	0,				Null,
	fcha_crcn_nta,			Null,
	0,				convert(Int,nmro_nta),
	@lnTotalValorAplicado,		fcha_crcn_nta
From	bdCarteraPac.dbo.tbNotasPac
Where	nmro_nta		= @nmro_nta
And	cnsctvo_cdgo_tpo_nta	= @lcTipoNota

-- se actualiza la informacion de la ultima transacion para no perder los valores anteriores

Update	#TmpSaldosResponsable
Set	cnsctvo_acmldo_scrsl_aprtnte	= a.cnsctvo_acmldo_scrsl_aprtnte,
	intrs_mra			= a.intrs_mra,
	cntdd_fctrs_mra			= a.cntdd_fctrs_mra,
	fcha_ultma_fctra		= a.fcha_ultma_fctra,
	fcha_ultmo_pgo			= a.fcha_ultmo_pgo,
	fcha_mra			= a.fcha_mra,
	vlr_sldo			= a.vlr_sldo
From	bdCarteraPac.dbo.tbAcumuladosSucursalAportante a Inner Join
	#TmpSaldosResponsable b
On	a.cnsctvo_cdgo_clse_aprtnte	= b.cnsctvo_cdgo_clse_aprtnte
And	a.nmro_unco_idntfccn_empldr	= b.nmro_unco_idntfccn_empldr
And	a.cnsctvo_scrsl			= b.cnsctvo_scrsl
Where	a.ultma_oprcn			= 1

-- se actualiza  la tabla principal para cerrar la ultima transacion

Update	bdCarteraPac.dbo.tbAcumuladosSucursalAportante
Set	ultma_oprcn	= 0
From	bdCarteraPac.dbo.tbAcumuladosSucursalAportante a Inner Join
	#TmpSaldosResponsable b
On	a.cnsctvo_acmldo_scrsl_aprtnte	= b.cnsctvo_acmldo_scrsl_aprtnte

-- se crea la ultima trasacion actualizada
-- para poder tener el ultimo movimiento

Insert	Into bdCarteraPac.dbo.tbAcumuladosSucursalAportante
	(cnsctvo_acmldo_scrsl_aprtnte,		nmro_unco_idntfccn_empldr,
	 cnsctvo_scrsl,				cnsctvo_cdgo_clse_aprtnte,
	 tpo_dcmnto,				nmro_dcmnto,
	 dbts,					crdts,
	 vlr_sldo,				fcha_crcn,
	 usro_crcn,				intrs_mra,
	 cntdd_fctrs_mra,			fcha_ultmo_pgo,
	 fcha_ultma_fctra,			fcha_mra,
	 ultma_oprcn,				brrdo)
Select	(ID_Num	+ @MaximoConsecutivoResponsable),nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl,				cnsctvo_cdgo_clse_aprtnte,
	3,					nmro_dcmnto,   --- Nota Credito
	dbts,					crdts,
	vlr_sldo - crdts,			@ldFechaSistema,
	@lcUsuario,				intrs_mra,
	cntdd_fctrs_mra,			fcha_ultmo_pgo,
	fcha_ultma_fctra,			fcha_mra,
	1,					'N'
From	#TmpSaldosResponsable
*/
Commit Tran

