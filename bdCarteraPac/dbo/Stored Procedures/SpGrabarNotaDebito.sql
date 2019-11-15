
/*---------------------------------------------------------------------------------
* Metodo o PRG		:  SpGrabarNotaDebito
* Desarrollado por	: <\A Ing. Rolando simbaqueva Lasso			A\>
* Descripcion		: <\D Este procedimiento grabar una nota debito		D\>
* Observaciones		: <\O  							O\>
* Parametros		: <\P							P\>
* Variables		: <\V  							V\>
* Fecha Creacion	: <\FC 2003/03/04					FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por	: <\AM	Ing. Jorge Ivan Rivera Gallego			AM\>
* Descripcion		: <\DM	Aplicación proceso optimización técnica		DM\>
* Nuevos Parametros	: <\PM	PM\>
* Nuevas Variables	: <\VM	VM\>
* Fecha Modificacion	: <\FM	2005/09/05					FM\>
*---------------------------------------------------------------------------------

*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por	: <\AM	Ing. Fernando Valencia E					AM\>
* Descripcion		: <\DM	Se amplia el tamaño de la variable @lcObservaciones	 a 500	DM\>
* Nuevos Parametros	: <\PM	PM\>
* Nuevas Variables	: <\VM	VM\>
* Fecha Modificacion	: <\FM	2006/08/15							FM\>
*---------------------------------------------------------------------------------*/


CREATE  PROCEDURE [dbo].[SpGrabarNotaDebito]
@lcTipoNota			udtConsecutivo,
@lnNivel			udtConsecutivo,	
@lnValorTotalNota		udtValorGrande,
@lcObservaciones		Varchar(500),
@nmro_unco_idntfccn_empldr	udtconsecutivo,
@cnsctvo_scrsl			udtconsecutivo,
@cnsctvo_cdgo_clse_aprtnte	udtconsecutivo,	
@lcUsuario			udtUsuario,
@lnProcesoExitoso		Int		Output,
@lcMensaje			Char(200)	Output,
@nmro_nta			Varchar(15)	Output,
@cnsctvo_cdgo_prdo_lqdcn int

As
Declare	@vlr_actl				Int,
	@vlr_antrr				Int,
	@cnsctvo_cdgo_estdo_nta			UdtConsecutivo,
	@cnsctvo_cdgo_tpo_aplccn_nta		UdtConsecutivo,
	@lnConsecutivoCodigoPeriodoLiquidacion	UdtConsecutivo,
	@ldFechaSistema				Datetime,	
	@ldFechaEvaluarPeriodo			Datetime,
	@lnNumeroPeriodosEvaluados		Int,
	@lnMax_cnsctvo_estdo_nta		UdtConsecutivo,
	@lnMax_Cnsctvo_nta_cncpto		UdtConsecutivo,
	@lnMax_cnsctvo_nta_cntrto		UdtConsecutivo,
	@Valor_iva_nota				UdtValorGrande,
	@Valor_saldo_nota			UdtValorGrande,
	@Valor_Porcentaje_Iva			UdtValorDecimales,
	@MaximoConsecutivoContrato		UdtConsecutivo,
	@MaximoConsecutivoResponsable		UdtConsecutivo,
	@Cantidad_Contratos_Pac			Int,
	@AcumTotalIvaContrato			UdtValorGrande,
	@AcumTotalSaldoNotaContrato		UdtValorGrande,
    @PagoCarteraCastigada int,
    @lnValorTotalAntIvaNota		udtValorGrande

Set Nocount On

Create	table #TMPConceptoNotaDebitoFinal
	(nmro_rgstro Int IDENTITY(1,1),		nmro_nta Varchar(15),
	 cnsctvo_cdgo_tpo_nta udtConsecutivo,	cnsctvo_cdgo_cncpto_lqdcn udtConsecutivo,
	 vlr_nta udtValorGrande,		cnsctvo_cdgo_autrzdr_espcl udtConsecutivo,
	 cnsctvo_nta_cncpto udtConsecutivo)

Create	Table #tmpContratosResponsableTotal
	(nmro_rgstro Int IDENTITY(1,1),			nmro_nta Varchar(15),
	 cnsctvo_cdgo_tpo_nta udtConsecutivo,		cnsctvo_estdo_cnta_cntrto udtConsecutivo,
	 cnsctvo_cdgo_tpo_cntrto udtConsecutivo,	nmro_cntrto udtNumeroFormulario,
	 vlr udtValorGrande)

Create	Table #tmpnotasContratoxConcepto
	(cnsctvo_nta_cntrto udtConsecutivo,		Valor udtValorGrande,
	 Cnsctvo_nta_cncpto udtConsecutivo,		cnsctvo_cdgo_cncpto_lqdcn udtConsecutivo)
/*
Create	Table #TmpSaldosContrato
	(Cnsctvo_Acmldo_cntrto udtConsecutivo,		cnsctvo_cdgo_tpo_cntrto udtConsecutivo,
	 nmro_cntrto udtNumeroFormulario,		tpo_dcmnto udtConsecutivo,
	 nmro_dcmnto Varchar(15),			dbts udtValorGrande,
	 crdts udtValorGrande,				vlr_sldo udtValorGrande,
	 cntdd_fctrs_mra udtValorPequeno,		fcha_ultmo_pgo Datetime,
	 fcha_ultma_fctra Datetime,			fcha_mra Datetime,
	 ultma_oprcn udtValorPequeno,			cnsctvo_nta_cntrto udtConsecutivo,
	 vlr udtValorGrande,				fcha_crcn_nta Datetime,
	 nmro_unco_idntfccn_empldr udtConsecutivo,	cnsctvo_scrsl udtConsecutivo,
	 cnsctvo_cdgo_clse_aprtnte udtConsecutivo,	ID_Num Int IDENTITY(1,1))

-- se crea una tabla temporal que va contener los responsables del pago

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
	 ID_Num	Int IDENTITY(1,1))
*/

Set @ldFechaSistema			= Getdate()
--Set @ldFechaEvaluarPeriodo		= DATEADD (Month,1,@ldFechaSistema)
Set @cnsctvo_cdgo_estdo_nta		= 1  	-- estado ingresada.
Set @cnsctvo_cdgo_tpo_aplccn_nta	= 2	-- tipo de aplicacion , aplicar proximo periodo
Set @lnProcesoExitoso			= 0
Set @Valor_Porcentaje_Iva		= 0


select @ldFechaEvaluarPeriodo = fcha_incl_prdo_lqdcn 
From	bdCarteraPac.dbo.tbPeriodosliquidacion_Vigencias
Where	cnsctvo_cdgo_prdo_lqdcn = @cnsctvo_cdgo_prdo_lqdcn

-- fin de la validacion que existan contratos de planes complementarios

-- trae el valor del porcentaje  para aplicar

Select	@Valor_Porcentaje_Iva		= prcntje
From	bdCarteraPac.dbo.tbConceptosLiquidacion_Vigencias
Where	cnsctvo_cdgo_cncpto_lqdcn	= 3
And	@ldFechaEvaluarPeriodo	Between inco_vgnca And 	fn_vgnca

If  @Valor_Porcentaje_Iva	= 0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'No existe parametrizacion de iva para procesar'
	Return -1
End


-- se calcula el valor de la iva de la nota
select  @PagoCarteraCastigada = isnull(count(*),0) from  #TMPConceptoNotaDebito where cnsctvo_cdgo_cncpto_lqdcn in(231,232,233,234) and	valor	> 0

If @PagoCarteraCastigada > 0  and @PagoCarteraCastigada is not null
begin
set @Valor_Porcentaje_Iva = 0
end


-- Set @Valor_iva_nota	= @lnValorTotalNota	*	@Valor_Porcentaje_Iva	/ 100 --*** Jairo Valencia **  Se reemplaza por:
Set @lnValorTotalAntIvaNota	= convert(numeric(12,0), (@lnValorTotalNota * 100))    / convert(numeric(12,0), (100 + @Valor_Porcentaje_Iva ))
set @Valor_iva_nota     = convert(numeric(12,0), (@lnValorTotalNota * @Valor_Porcentaje_Iva)) /  convert(numeric(12,0), (100 + @Valor_Porcentaje_Iva ))

-- se calcula el saldo de la nota valor de la nota  mas el valor del iva de la nota

Set @Valor_saldo_nota	= @lnValorTotalAntIvaNota	+	@Valor_iva_nota

-- Se verifica con la cantidad de registros que existan con la consulta
--Se verifica que le periodo que tiene el estado abierto sea el siguiente al periodo actual
/*
Select	@lnNumeroPeriodosEvaluados	= Count(1)
From	bdCarteraPac.dbo.tbPeriodosliquidacion_Vigencias
Where	Datediff(Day,fcha_incl_prdo_lqdcn,@ldFechaEvaluarPeriodo) >= 0
And	Datediff(Day,@ldFechaEvaluarPeriodo,fcha_fnl_prdo_lqdcn) >= 0 -- que sea el siguiente del periodo a evaluar
And	@ldFechaSistema	Between inco_vgnca And fn_vgnca
And	cnsctvo_cdgo_estdo_prdo	=	2	-- estado del periodo abierto

If @lnNumeroPeriodosEvaluados <> 1
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'El periodo esta en un rango no que no se puede liquidar'
	Return -1
End

--Se traer el consecutivo del periodo de liquidacion

Select	@lnConsecutivoCodigoPeriodoLiquidacion	= cnsctvo_cdgo_prdo_lqdcn
From	bdCarteraPac.dbo.tbPeriodosliquidacion_Vigencias
Where	Datediff(Day,fcha_incl_prdo_lqdcn,@ldFechaEvaluarPeriodo) >= 0
And	Datediff(Day,@ldFechaEvaluarPeriodo,fcha_fnl_prdo_lqdcn) >= 0 -- que sea el siguiente del periodo a evaluar
And	@ldFechaSistema Between inco_vgnca And fn_vgnca
And	cnsctvo_cdgo_estdo_prdo	= 2 -- estado del periodo abierto
*/
-- se consulta el consecutivo actual del estado de cuenta y consecutivo anterior

Set @lnConsecutivoCodigoPeriodoLiquidacion = @cnsctvo_cdgo_prdo_lqdcn

Select	@vlr_actl	= Isnull(vlr_actl,0) + 1,
	@vlr_antrr	= vlr_actl
From	bdCarteraPac.dbo.tbTiposConsecutivo_Vigencias
Where	cnsctvo_cdgo_tpo_cnsctvo	= 3  -- consecutivos de nota debito


Begin Tran

--Actualizamos el consecutivo del estado  de cuenta

Update	bdCarteraPac.dbo.tbTiposConsecutivo_Vigencias
Set	vlr_actl	= @vlr_actl,
	vlr_antrr	= @vlr_antrr
Where	cnsctvo_cdgo_tpo_cnsctvo = 3 -- actualizamos el consecutivo de nota debito

If @@error!=0  
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error Actualizando el tipo de conseuctivo'
	Rollback tran
	Return -1
End


Set @nmro_nta	= Convert(varchar(15),@vlr_actl)


Insert	Into bdCarteraPac.dbo.tbNotasPac
	(nmro_nta,			cnsctvo_cdgo_tpo_nta,
	 vlr_nta,			vlr_iva,
	 sldo_nta,			cnsctvo_prdo,
	 fcha_crcn_nta,			cnsctvo_cdgo_estdo_nta,
	 cnsctvo_cdgo_tpo_aplccn_nta,	obsrvcns,
	 usro_crcn,			nmro_unco_idntfccn_empldr,
	 cnsctvo_scrsl,			cnsctvo_cdgo_clse_aprtnte,
	fcha_prdo_nta)
Values	(@nmro_nta,			@lcTipoNota,
	 @lnValorTotalAntIvaNota,		@Valor_iva_nota,
	 @Valor_saldo_nota,		@lnConsecutivoCodigoPeriodoLiquidacion,
	 @ldFechaSistema,		@cnsctvo_cdgo_estdo_nta,
	 @cnsctvo_cdgo_tpo_aplccn_nta,	@lcObservaciones,
	 @lcUsuario,			@nmro_unco_idntfccn_empldr,
	 @cnsctvo_scrsl,		@cnsctvo_cdgo_clse_aprtnte,
	 @ldFechaEvaluarPeriodo)


If  @@error!=0  
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error creando la nota'
	Rollback Tran
	Return -1
End

--Se consulta el numero siguiente del concepto y nota

Select 	@lnMax_Cnsctvo_nta_cncpto	= Isnull(Max(Cnsctvo_nta_cncpto),0)
From	bdCarteraPac.dbo.tbNotasConceptos

-- se crea una tabla temporal con un contador  para que de esta forma poder asociar de una forma mas facil
-- el consecutivo del registro en tbnotasconceptos

Insert	Into #TMPConceptoNotaDebitoFinal
	(nmro_nta,				cnsctvo_cdgo_tpo_nta,
	 cnsctvo_cdgo_cncpto_lqdcn,		vlr_nta,
	 cnsctvo_cdgo_autrzdr_espcl,		cnsctvo_nta_cncpto)
Select	@nmro_nta,			@lcTipoNota,
	cnsctvo_cdgo_cncpto_lqdcn,	valor,
	cnsctvo_cdgo_autrzdr_espcl,	0
From	#TMPConceptoNotaDebito
Where	valor	> 0

--Se graba los conceptos de la nota debito

Insert	Into bdCarteraPac.dbo.tbNotasConceptos
	(Cnsctvo_nta_cncpto,			nmro_nta,
	 cnsctvo_cdgo_tpo_nta,			cnsctvo_cdgo_cncpto_lqdcn,
	 vlr_nta)
Select	nmro_rgstro + @lnMax_Cnsctvo_nta_cncpto, nmro_nta,
	cnsctvo_cdgo_tpo_nta,			cnsctvo_cdgo_cncpto_lqdcn,
	vlr_nta
From	#TMPConceptoNotaDebitoFinal

If  @@error!=0  
Begin 
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error insertando el concepto por nota'
	Rollback Tran
	Return -1
End

Update	#TMPConceptoNotaDebitoFinal
Set	cnsctvo_nta_cncpto	= b.cnsctvo_nta_cncpto
From	#TMPConceptoNotaDebitoFinal a Inner Join
	bdCarteraPac.dbo.tbNotasConceptos b
On	a.cnsctvo_cdgo_cncpto_lqdcn	= b.cnsctvo_cdgo_cncpto_lqdcn
Where	b.nmro_nta			= @nmro_nta
And	b.cnsctvo_cdgo_tpo_nta		= @lcTipoNota

Insert	Into bdCarteraPac.dbo.tbAutorizacionesNotas
	(cnsctvo_nta_cncpto,		cnsctvo_cdgo_autrzdr_espcl)
Select	cnsctvo_nta_cncpto,		cnsctvo_cdgo_autrzdr_espcl
From	#TMPConceptoNotaDebitoFinal
Where	cnsctvo_cdgo_autrzdr_espcl	> 0

If  @@error!=0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error insertando los autorizadores  por nota'
	Rollback Tran
	Return -1
End

If @lnNivel	= 1	-- si es a nivel de contrato
Begin

	-- se crea la tabla temporal de l valor total por cada contrato  para controlar el numero del consecutivo

	Insert	Into #tmpContratosResponsableTotal
		(nmro_nta,			cnsctvo_cdgo_tpo_nta,
		 cnsctvo_estdo_cnta_cntrto,	cnsctvo_cdgo_tpo_cntrto,
		 nmro_cntrto,			vlr)
	Select	@nmro_nta,			@lcTipoNota,
		0,				cnsctvo_cdgo_tpo_cntrto,
		nmro_cntrto,			Sum(valor)
	From	#TMPcontratosresponsable
	Group by cnsctvo_cdgo_tpo_cntrto, nmro_cntrto

	-- se busca el maximo del consecutivo nota contrato

	Select	@lnMax_cnsctvo_nta_cntrto	= Isnull(Max(cnsctvo_nta_cntrto),0)
	From	bdCarteraPac.dbo.tbNotasContrato

	-- se inserta la informacion a nivel de contrato de la nota

	Insert	Into bdCarteraPac.dbo.tbNotasContrato
		(cnsctvo_nta_cntrto,			nmro_nta,
		 cnsctvo_cdgo_tpo_nta,			cnsctvo_estdo_cnta_cntrto,
		 cnsctvo_cdgo_tpo_cntrto,		nmro_cntrto,
		 vlr,					vlr_iva,
		 sldo_nta_cntrto,			fcha_ultma_mdfccn,
		 usro_ultma_mdfccn)
	Select	(a.nmro_rgstro + @lnMax_cnsctvo_nta_cntrto), a.nmro_nta,
		a.cnsctvo_cdgo_tpo_nta,			a.cnsctvo_estdo_cnta_cntrto,
		a.cnsctvo_cdgo_tpo_cntrto,		a.nmro_cntrto,
		isnull(convert(numeric(12,0), (a.vlr * 100))    / convert(numeric(12,0), (100 + @Valor_Porcentaje_Iva )),0),
		isnull(convert(numeric(12,0), (a.vlr * @Valor_Porcentaje_Iva)) /  convert(numeric(12,0), (100 + @Valor_Porcentaje_Iva )),0),
		a.vlr,  --saldo a nivel de contrato
		Null,					Null
	From	#tmpContratosResponsableTotal a
	Where	a.vlr > 0

	If  @@Error!=0
	Begin
		Set @lnProcesoExitoso	= 1
		Set @lcMensaje		= 'Error insertando los contratos por nota'
		Rollback Tran
		Return -1
	End


	--Actualiza la nota a nivel de contrato
	Select	@AcumTotalIvaContrato		= sum(vlr_iva),
		@AcumTotalSaldoNotaContrato	= sum(sldo_nta_cntrto)
	From	bdCarteraPac.dbo.tbNotasContrato
	Where	nmro_nta			= @nmro_nta
	And	cnsctvo_cdgo_tpo_nta		= @lcTipoNota

--
--	Update	bdCarteraPac.dbo.tbNotasPac
--	Set	vlr_iva   			= @AcumTotalIvaContrato,
--		sldo_nta			= @AcumTotalSaldoNotaContrato
--	Where	nmro_nta			= @nmro_nta
--	And	cnsctvo_cdgo_tpo_nta		= @lcTipoNota

	If  @@Error!=0
	Begin
		Set @lnProcesoExitoso	= 1
		Set @lcMensaje		= 'Error Actualizando el saldo de la nota  contrato'
		Rollback Tran
		Return -1
	End

	-- Se crea una tabla temporal con la informacion  del valor de cada concepto para cada contrato
	-- y luego poder actualizar el concpeto asociadoa a la nota

/*	Create	Table #tmpnotasContratoxConcepto
		(cnsctvo_nta_cntrto udtConsecutivo,		Valor udtValorGrande,
		 Cnsctvo_nta_cncpto udtConsecutivo,		cnsctvo_cdgo_cncpto_lqdcn udtConsecutivo)*/

	Insert	Into #tmpnotasContratoxConcepto
		(cnsctvo_nta_cntrto,		Valor,
		 Cnsctvo_nta_cncpto,		cnsctvo_cdgo_cncpto_lqdcn)
	Select	b.cnsctvo_nta_cntrto,		a.Valor,
		0 Cnsctvo_nta_cncpto,		cnsctvo_cdgo_cncpto_lqdcn
	From	#TMPcontratosresponsable	a Inner Join
		bdCarteraPac.dbo.tbNotasContrato b
	On	a.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
	And	a.nmro_cntrto			= b.nmro_cntrto
	Where	b.nmro_nta			= @nmro_nta
	And	b.cnsctvo_cdgo_tpo_nta		= @lcTipoNota
	And	a.valor				> 0


	-- actualiza el valor del concepto por nota

	Update	#tmpnotasContratoxConcepto
	Set	cnsctvo_nta_cncpto		= b.Cnsctvo_nta_cncpto
	From	#tmpnotasContratoxConcepto a Inner Join
		bdCarteraPac.dbo.tbNotasConceptos b
	On	a.cnsctvo_cdgo_cncpto_lqdcn	= b.cnsctvo_cdgo_cncpto_lqdcn
	And	b.nmro_nta			= @nmro_nta
	And	b.cnsctvo_cdgo_tpo_nta		= @lcTipoNota

	-- se inserta la informacion de cada contrato y cada concepto

	Insert	Into bdCarteraPac.dbo.tbNotasContratoxConcepto
		(cnsctvo_nta_cntrto,		cnsctvo_nta_cncpto,
		 vlr)
	Select	cnsctvo_nta_cntrto,		Cnsctvo_nta_cncpto,
		valor
	From	#tmpnotasContratoxConcepto

	If  @@error!=0  
	Begin 
		Set @lnProcesoExitoso	= 1
		Set @lcMensaje		= 'Error insertando contrato del concepto de la nota'
		Rollback Tran
		Return -1
	End
End	-- Fin de a nivel de contrato

-- se consulta el maximo consecutivo que siguie para el estado por nota
-- se guardan todos los estado por nota

Select	@lnMax_cnsctvo_estdo_nta	= Isnull(Max(cnsctvo_estdo_nta),0)
From	bdCarteraPac.dbo.tbEstadosxNota

Insert	Into bdCarteraPac.dbo.tbEstadosxNota
	(cnsctvo_estdo_nta,		nmro_nta,
	 cnsctvo_cdgo_tpo_nta,		cnsctvo_cdgo_estdo_nta,
	 vlr_nta,			vlr_iva,
	 sldo_nta,			fcha_cmbo_estdo,
	 usro_cmbo_estdo)
Values	(@lnMax_cnsctvo_estdo_nta + 1,	@nmro_nta,
	 @lcTipoNota,			@cnsctvo_cdgo_estdo_nta,
	 @lnValorTotalAntIvaNota,		@Valor_iva_nota,
	 @Valor_saldo_nota,		@ldFechaSistema,
	 @lcUsuario)


If  @@Error!=0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error insertando historico del estado de  la nota'
	Rollback Tran
	Return -1
End

-- Se actualiza el saldo a nivel de contrato

/*
If @lnNivel	= 1 -- si es a nivel de contrato
Begin
		--se calcula el maximo  numero

	Select	@MaximoConsecutivoContrato	 = Isnull(Max(Cnsctvo_Acmldo_cntrto),0)
	From	bdCarteraPac.dbo.tbAcumuladosContrato

	Insert	Into #TmpSaldosContrato
		(Cnsctvo_Acmldo_cntrto,		cnsctvo_cdgo_tpo_cntrto,
		 nmro_cntrto,			tpo_dcmnto,
		 nmro_dcmnto,			dbts,
		 crdts,				vlr_sldo,
		 cntdd_fctrs_mra,		fcha_ultmo_pgo,
		 fcha_ultma_fctra,		fcha_mra,
		 ultma_oprcn,			cnsctvo_nta_cntrto,
		 vlr,				fcha_crcn_nta,
		 nmro_unco_idntfccn_empldr,	cnsctvo_scrsl,
		 cnsctvo_cdgo_clse_aprtnte)
	Select	0,				cnsctvo_cdgo_tpo_cntrto,
		nmro_cntrto,			2,
		a.nmro_nta,			sldo_nta_cntrto,
		0,				0,
		0,				Null,
		fcha_crcn_nta,			Null,
		0,				b.cnsctvo_nta_cntrto,
		sldo_nta_cntrto,		fcha_crcn_nta,
		a.nmro_unco_idntfccn_empldr,	a.cnsctvo_scrsl, -- se adiciono la sucursal aportante
		a.cnsctvo_cdgo_clse_aprtnte
	From	bdCarteraPac.dbo.tbNotasPac a Inner Join
		bdCarteraPac.dbo.tbNotasContrato b
	On	a.cnsctvo_cdgo_tpo_nta	= b.cnsctvo_cdgo_tpo_nta
	And	a.nmro_nta		= b.nmro_nta
	Where	a.cnsctvo_cdgo_tpo_nta	= @lcTipoNota
	And	a.nmro_nta		= @nmro_nta

	Update	#TmpSaldosContrato
	Set	Cnsctvo_Acmldo_cntrto	= a.Cnsctvo_Acmldo_cntrto,
		cntdd_fctrs_mra		= a.cntdd_fctrs_mra,
		fcha_ultmo_pgo		= a.fcha_ultmo_pgo,
		fcha_ultma_fctra	= a.fcha_ultma_fctra,
		fcha_mra		= a.fcha_mra,
		vlr_sldo		= a.vlr_sldo
	From	bdCarteraPac.dbo.tbAcumuladosContrato	a Inner Join
		#TmpSaldosContrato b
	On	a.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
	And	a.nmro_cntrto			= b.nmro_cntrto
	And	a.nmro_unco_idntfccn_empldr	= b.nmro_unco_idntfccn_empldr
	And	a.cnsctvo_scrsl			= b.cnsctvo_scrsl	 -- se adiciono la sucursal aportante
	And	a.cnsctvo_cdgo_clse_aprtnte	= b.cnsctvo_cdgo_clse_aprtnte
	Where	a.ultma_oprcn			= 1

	Update	bdCarteraPac.dbo.tbAcumuladosContrato
	Set	ultma_oprcn		= 0
	From	bdCarteraPac.dbo.tbAcumuladosContrato a Inner Join
		#TmpSaldosContrato b
	On	a.Cnsctvo_Acmldo_cntrto	= b.Cnsctvo_Acmldo_cntrto

	Insert	Into bdCarteraPac.dbo.tbAcumuladosContrato
		(Cnsctvo_Acmldo_cntrto,				tpo_dcmnto,
		 nmro_dcmnto,					dbts,
		 crdts,						vlr_sldo,
		 fcha_crcn,					usro_crcn,
		 cnsctvo_cdgo_tpo_cntrto,			nmro_cntrto,
		 ultma_oprcn,					cntdd_fctrs_mra,
		 fcha_ultmo_pgo,				fcha_ultma_fctra,
		 fcha_mra,					brrdo,
		 nmro_unco_idntfccn_empldr,			cnsctvo_scrsl,
		 cnsctvo_cdgo_clse_aprtnte)
	Select	(ID_Num	+ @MaximoConsecutivoContrato),		2,
		 nmro_dcmnto,					dbts,
		 crdts,						vlr_sldo + dbts,
		 @ldFechaSistema,				@lcUsuario,
		 cnsctvo_cdgo_tpo_cntrto,			nmro_cntrto,
		 1,						cntdd_fctrs_mra,
		 fcha_ultmo_pgo,				fcha_ultma_fctra,
		 fcha_mra,					'N',
		 nmro_unco_idntfccn_empldr,			cnsctvo_scrsl,
		 cnsctvo_cdgo_clse_aprtnte -- se adiciono la sucursal aportante
	From	#TmpSaldosContrato


	If  @@Error!= 0
	Begin
		Set @lnProcesoExitoso	= 1
		Set @lcMensaje		= 'Error insertando el acumulado del contrato'
		Rollback Tran
		Return -1
	End


End


--Actualiza el saldo del responsable del pago

Select	@MaximoConsecutivoResponsable	= Isnull(Max(cnsctvo_acmldo_scrsl_aprtnte),0)
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
Select  0,				nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl,			cnsctvo_cdgo_clse_aprtnte,
	2,				nmro_nta,
	sldo_nta,			0,
	0,				0,
	0,				Null,
	fcha_crcn_nta,			Null,
	0,				Convert(Int,nmro_nta),
	sldo_nta,			fcha_crcn_nta
From 	bdCarteraPac.dbo.tbNotasPac
Where 	nmro_nta		= @nmro_nta
And	cnsctvo_cdgo_tpo_nta	= @lcTipoNota
	

-- se actualiza la informacion de la ultima transacion para no perder los valores anteriores
Update #TmpSaldosResponsable
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

-- se actualiza  la tabla principal para cerrar la ultima transacción

Update	bdCarteraPac.dbo.tbAcumuladosSucursalAportante
Set	ultma_oprcn	= 0
From	bdCarteraPac.dbo.tbAcumuladosSucursalAportante a Inner Join
	#TmpSaldosResponsable b
On	a.cnsctvo_acmldo_scrsl_aprtnte	= b.cnsctvo_acmldo_scrsl_aprtnte

-- se crea la ultima trasacion actualizada
-- para poder tener el ultimo movimiento

Insert	Into TbAcumuladosSucursalAportante
	(cnsctvo_acmldo_scrsl_aprtnte,			nmro_unco_idntfccn_empldr,
	 cnsctvo_scrsl,					cnsctvo_cdgo_clse_aprtnte,
	 tpo_dcmnto,					nmro_dcmnto,
	 dbts,						crdts,
	 vlr_sldo,					fcha_crcn,
	 usro_crcn,					intrs_mra,
	 cntdd_fctrs_mra,				fcha_ultmo_pgo,
	 fcha_ultma_fctra,				fcha_mra,
	 ultma_oprcn,					brrdo)
Select	(ID_Num	+ @MaximoConsecutivoResponsable),	nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl,					cnsctvo_cdgo_clse_aprtnte,
	2,						nmro_dcmnto,
	dbts,						crdts,
	vlr_sldo + dbts,				@ldFechaSistema,
	@lcUsuario,					intrs_mra,
	cntdd_fctrs_mra,				fcha_ultmo_pgo,
	fcha_ultma_fctra,				fcha_mra,
	1,						'N'
From	#TmpSaldosResponsable

*/

Commit tran



