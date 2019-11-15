
/*---------------------------------------------------------------------------------
* Metodo o PRG		: SpGrabarReintegro
* Desarrollado por	: <\A Ing. Rolando simbaqueva Lasso				A\>
* Descripcion		: <\D Este procedimiento grabar una nota debito			D\>
* Observaciones		: <\O  								O\>
* Parametros		: <\P								P\>
* Variables		: <\V  								V\>
* Fecha Creacion	: <\FC 2003/03/04						FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por	: <\AM	Ing. Andres Camelo (illustrato ltda)		AM\>
* Descripcion		: <\DM	Se modifica para que guarde los datos adicionales cuando el tipo de documento es solicitud de pago		DM\>
* Nuevos Parametros	: <\PM	PM\>
* Nuevas Variables	: <\VM	VM\>
* Fecha Modificacion	: <\FM	2013/10/31						FM\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por	: <\AM	Ing. Andres Camelo (illustrato ltda)		AM\>
* Descripcion		: <\DM	Se modifica para consulta el iva que le corresponde a cada documento como estado de cuenta o notas debito segun la fecha de creacion de estos,
 comparando estas fechas contra el rango en que este segun los campos inicio y fin vigencia de la tabla  tbConceptosLiquidacion_Vigencias	DM\>
* Nuevos Parametros	: <\PM	PM\>
* Nuevas Variables	: <\VM	VM\>
*---------------------------------------------------------------------------------*/
CREATE  PROCEDURE [dbo].[SpGrabarReintegro]

@lcTipoNota			UdtConsecutivo,
@lnNivel			UdtConsecutivo,	
@lnValorTotalNota		UdtValorGrande,
@lcObservaciones		Varchar(250),
@nmro_unco_idntfccn_empldr	UdtConsecutivo,
@cnsctvo_scrsl			UdtConsecutivo,
@cnsctvo_cdgo_clse_aprtnte	UdtConsecutivo,	
@lcUsuario			UdtUsuario,
@lnProcesoExitoso		Int		Output,
@lcMensaje			Char(200)	Output,
@nmro_nta			Varchar(15)	Output,
@cnsctvo_cdgo_prdo_lqdcn int = null,
@lndocumento             Varchar(50) = null


As

Declare	@vlr_actl				              Int,
	@vlr_antrr								  Int,
	@cnsctvo_cdgo_estdo_nta					  Udtconsecutivo,
	@cnsctvo_cdgo_tpo_aplccn_nta		      Udtconsecutivo,
	@lnConsecutivoCodigoPeriodoLiquidacion	  Udtconsecutivo,
	@ldFechaSistema				              Datetime,	
	@ldFechaEvaluarPeriodo					  Datetime,
	@lnNumeroPeriodosEvaluados				  Int,
	@lnMax_cnsctvo_estdo_nta				  UdtConsecutivo,
	@lnMax_Cnsctvo_nta_cncpto				  UdtConsecutivo,
	@lnMax_cnsctvo_nta_cntrto				  UdtConsecutivo,
	@Valor_iva_nota							  UdtValorGrande,
	@Valor_saldo_nota						  UdtValorGrande,
	@Valor_Porcentaje_Iva			          UdtValorDecimales,
	@MaximoConsecutivoContrato				  UdtConsecutivo,
	@MaximoConsecutivoResponsable			  UdtConsecutivo,
    @lnValorTotalAntIvaNota		              udtValorGrande,
	@exstnca_aprtnte                          int,
    @nmro_unco_idntfccn_afldo				  int        
    

Set Nocount On

Set @ldFechaSistema		= Getdate()
Set @ldFechaEvaluarPeriodo	= DATEADD(Month,1,@ldFechaSistema)
Set @cnsctvo_cdgo_estdo_nta	= 1  	-- estado ingresada.
Set @cnsctvo_cdgo_tpo_aplccn_nta= 2	-- tipo de aplicacion , aplicar proximo periodo
Set @lnProcesoExitoso		= 0
Set @Valor_Porcentaje_Iva	= 0
SET @exstnca_aprtnte        = 1

/*******************************CREACIÓN TABLAS TEMPORALES*************************************/
Create	Table #TMPConceptoNotaDebitoFinal
	(nmro_rgstro Int IDENTITY(1,1),		nmro_nta Varchar(15),
	 cnsctvo_cdgo_tpo_nta udtConsecutivo,	cnsctvo_cdgo_cncpto_lqdcn udtConsecutivo,
	 vlr_nta udtValorGrande,		cnsctvo_cdgo_autrzdr_espcl udtConsecutivo,
	 cnsctvo_nta_cncpto udtConsecutivo)

-- Se crea la tabla temporal de l valor total por cada contrato  para controlar el numero del consecutivo
Create	Table #TMPcontratosresponsableFinal
	(nmro_rgstro Int IDENTITY(1,1),			nmro_nta Varchar(15),
	 cnsctvo_cdgo_tpo_nta udtConsecutivo,		cnsctvo_estdo_cnta_cntrto udtConsecutivo,
	 cnsctvo_cdgo_tpo_cntrto udtConsecutivo,	nmro_cntrto udtNumeroFormulario,
	 vlr udtValorGrande, iva numeric(14,4))


Declare @documentos table(
vlr udtValorGrande,
iva numeric(14,4),
consecutivo  int
 )





-- se calcula el saldo de la nota valor de la nota  mas el valor del iva de la nota

--Set @Valor_saldo_nota	= @lnValorTotalAntIvaNota	+	@Valor_iva_nota

If @lnNivel	= 3 -- si es a nivel de responsable el pago no existente
  begin
	
	set @Valor_saldo_nota = @lnValorTotalNota
	select @lnValorTotalAntIvaNota = vlr_ant_iva, @Valor_iva_nota = vlr_iva
	from #TMPAportanteNotaReintegro
 
  end



-- Se verifica con la cantidad de registros que existan con la consulta
--Se verifica que le periodo que tiene el estado abierto sea el siguiente al periodo actual

Select	@lnNumeroPeriodosEvaluados	= Count(1)
From	bdCarteraPac.dbo.tbPeriodosliquidacion_Vigencias
Where	Datediff(Day,fcha_incl_prdo_lqdcn,@ldFechaEvaluarPeriodo) >= 0
And	Datediff(Day,@ldFechaEvaluarPeriodo,fcha_fnl_prdo_lqdcn) >= 0 -- que sea el siguiente del periodo a evaluar
And	@ldFechaSistema Between inco_vgnca And fn_vgnca
And	cnsctvo_cdgo_estdo_prdo	= 2	-- estado del periodo abierto

if isnull(@cnsctvo_cdgo_prdo_lqdcn,0) = 0
   begin

	If @lnNumeroPeriodosEvaluados <> 1
	Begin
		Set @lnProcesoExitoso	= 1
		Set @lcMensaje		= 'El periodo esta en un rango que no se puede liquidar'
		Return -1
	End
   
	--Se traer el consecutivo del periodo de liquidacion

	select	@lnConsecutivoCodigoPeriodoLiquidacion	= cnsctvo_cdgo_prdo_lqdcn
	From	bdCarteraPac.dbo.tbPeriodosliquidacion_Vigencias
	Where	Datediff(Day,fcha_incl_prdo_lqdcn,@ldFechaEvaluarPeriodo) >= 0
	And	Datediff(Day,@ldFechaEvaluarPeriodo,fcha_fnl_prdo_lqdcn) >= 0 -- que sea el siguiente del periodo a evaluar
	And	@ldFechaSistema Between inco_vgnca And fn_vgnca
	And	cnsctvo_cdgo_estdo_prdo	= 2	-- estado del periodo abierto

  end
else 
set	@lnConsecutivoCodigoPeriodoLiquidacion = @cnsctvo_cdgo_prdo_lqdcn

-- se consulta el consecutivo actual del estado de cuenta y consecutivo anterior

Select	@vlr_actl	= Isnull(vlr_actl,0) + 1,
	@vlr_antrr	= vlr_actl
From	bdCarteraPac.dbo.tbTiposConsecutivo_Vigencias
Where	cnsctvo_cdgo_tpo_cnsctvo = 4  -- consecutivos dereintegros

Begin Tran 

--Actualizamos el consecutivo del estado  de cuenta

Update	bdCarteraPac.dbo.tbTiposConsecutivo_Vigencias
Set	vlr_actl	= @vlr_actl,
	vlr_antrr	= @vlr_antrr
Where	cnsctvo_cdgo_tpo_cnsctvo = 4 -- actualizamos el consecutivo de nota debito

If @@error!=0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error Actualizando el tipo de conseuctivo'
	Rollback Tran
	Return -1
End

Set @nmro_nta	= Convert(Varchar(15),@vlr_actl)




IF @nmro_unco_idntfccn_empldr = 0 
   SET @exstnca_aprtnte = 2



-- insertamos la nota reintegro
Insert Into bdCarteraPac.dbo.tbNotasPac
	(nmro_nta,			cnsctvo_cdgo_tpo_nta,
	 vlr_nta,			vlr_iva,
	 sldo_nta,			cnsctvo_prdo,
	 fcha_crcn_nta,			cnsctvo_cdgo_estdo_nta,
	 cnsctvo_cdgo_tpo_aplccn_nta,	obsrvcns,
	 usro_crcn,			nmro_unco_idntfccn_empldr,
	 cnsctvo_scrsl,			cnsctvo_cdgo_clse_aprtnte,
	 cnsctvo_cdgo_exstnca_aprtnte,cnsctvo_cdgo_tpo_dcmnto_nta_rntgro)
Values	(@nmro_nta,			@lcTipoNota,
	 0,		0,
	 0,		@lnConsecutivoCodigoPeriodoLiquidacion,
	 @ldFechaSistema,		@cnsctvo_cdgo_estdo_nta,
	 @cnsctvo_cdgo_tpo_aplccn_nta,	@lcObservaciones,
	 @lcUsuario,			@nmro_unco_idntfccn_empldr,
	 @cnsctvo_scrsl,		@cnsctvo_cdgo_clse_aprtnte,
	 @exstnca_aprtnte,      @lndocumento)

If @@Error!= 0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error creando la nota'
	Rollback Tran
	Return -1
End

--Se consulta el numero siguiente del concepto y nota

Select	@lnMax_Cnsctvo_nta_cncpto	= Isnull(Max(Cnsctvo_nta_cncpto),0)
From	bdCarteraPac.dbo.tbNotasConceptos

-- se crea una tabla temporal con un contador  para que de esta forma poder asociar de una forma mas facil
-- el consecutivo del registro en tbnotasconceptos

Insert	Into #TMPConceptoNotaDebitoFinal
	(nmro_nta,			cnsctvo_cdgo_tpo_nta,
	 cnsctvo_cdgo_cncpto_lqdcn,	vlr_nta,
	 cnsctvo_cdgo_autrzdr_espcl,	cnsctvo_nta_cncpto)
Select	@nmro_nta,			@lcTipoNota,
	cnsctvo_cdgo_cncpto_lqdcn,	valor,
	cnsctvo_cdgo_autrzdr_espcl,	0
From	#TMPConceptoNotaDebito
Where	 valor		>	0


--Se graba los conceptos de la nota debito
Insert	Into bdCarteraPac.dbo.tbNotasConceptos
	(Cnsctvo_nta_cncpto,				nmro_nta,
	 cnsctvo_cdgo_tpo_nta,				cnsctvo_cdgo_cncpto_lqdcn,
	 vlr_nta)
Select 	(nmro_rgstro + @lnMax_Cnsctvo_nta_cncpto),	nmro_nta,
	cnsctvo_cdgo_tpo_nta,				cnsctvo_cdgo_cncpto_lqdcn,
	vlr_nta
From	#TMPConceptoNotaDebitoFinal

If @@Error!= 0
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

If  @@Error!=0
Begin
	Set @lnProcesoExitoso	= 1
	Set @lcMensaje		= 'Error insertando los autorizadores  por nota'
	Rollback Tran
	Return -1
End





If @lnNivel	= 1 -- si es a nivel de contrato
Begin
	--Se calcula el valor maximo de cada contrato

	Insert	Into #TMPcontratosresponsableFinal
		(nmro_nta,			cnsctvo_cdgo_tpo_nta,
		 cnsctvo_estdo_cnta_cntrto,	cnsctvo_cdgo_tpo_cntrto,
		 nmro_cntrto,			vlr)
	Select  @nmro_nta,			@lcTipoNota,
		0,				a.cnsctvo_cdgo_tpo_cntrto,
		a.nmro_cntrto,			a.vlr    
	From	(Select	cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,
			Sum(valor) vlr
		 From	#TMPcontratosresponsable
		 Group by cnsctvo_cdgo_tpo_cntrto,nmro_cntrto) a
	Where	a.vlr	> 0


 
    --  Se modifica para consulta el iva que le corresponde a cada documento como estado de cuenta y nota debito segun la fecha de creacion de estos,
  --  comparando estas fechas contra el rango en que este segun los campos inicio y fin vigencia de la tabla  tbConceptosLiquidacion_Vigencias
   update #TMPcontratosresponsableFinal set iva = e.prcntje 
    From  #TMPcontratosresponsableFinal a 
    inner join #TMPDocumentosDebitosFinal b
    on    (a.nmro_cntrto  = b.nmro_cntrto)
    inner join tbEstadosCuentaContratos c with (nolock)
    on     (b.Consecutivo_documento_origen =  c.cnsctvo_estdo_cnta_cntrto)
    inner join tbestadosCuenta d  with (nolock)
    on     (d.cnsctvo_estdo_cnta =  c.cnsctvo_estdo_cnta)
    inner join  tbConceptosLiquidacion_Vigencias e with (nolock)
    on     (e.cnsctvo_cdgo_cncpto_lqdcn	= 3 aND  d.Fcha_crcn Between e.inco_vgnca	And 	e.fn_vgnca)
    where   b.cnsctvo_cdgo_tpo_dcmnto	= 1   -- estados de cuenta 

    update #TMPcontratosresponsableFinal set iva = e.prcntje 
    From  #TMPcontratosresponsableFinal a 
    inner join #TMPDocumentosDebitosFinal b
    on    (a.nmro_cntrto  = b.nmro_cntrto)
    inner join tbNotasContrato c with (nolock)
    on     (c.cnsctvo_nta_cntrto    =  b.Consecutivo_documento_origen) 
    inner join tbNotasPac d  with (nolock)
    on    (c.nmro_nta     = d.nmro_nta
    and    c.cnsctvo_cdgo_tpo_nta  = d.cnsctvo_cdgo_tpo_nta)    
    inner join  tbConceptosLiquidacion_Vigencias e with (nolock)
    on     (e.cnsctvo_cdgo_cncpto_lqdcn	= 3 AND  d.fcha_crcn_nta Between e.inco_vgnca	And 	e.fn_vgnca)
    where   b.cnsctvo_cdgo_tpo_dcmnto	= 2 -- notas debito
    and    d.cnsctvo_cdgo_tpo_nta       = 1 -- nota debito  


 -- se busca el maximo del consecutivo nota contrato
   Select	@lnMax_cnsctvo_nta_cntrto	= Isnull(Max(cnsctvo_nta_cntrto),0)
	From	bdCarteraPac.dbo.tbNotasContrato



 	-- se inserta la informacion a nivel de contrato de la nota
	Insert	Into bdCarteraPac.dbo.tbNotasContrato
		(cnsctvo_nta_cntrto,				nmro_nta,
		 cnsctvo_cdgo_tpo_nta,				cnsctvo_estdo_cnta_cntrto,
		 cnsctvo_cdgo_tpo_cntrto,			nmro_cntrto,
		 vlr,						vlr_iva,
		 sldo_nta_cntrto,				fcha_ultma_mdfccn,
		 usro_ultma_mdfccn)
	Select	(nmro_rgstro + @lnMax_cnsctvo_nta_cntrto),	nmro_nta,
		 cnsctvo_cdgo_tpo_nta,				cnsctvo_estdo_cnta_cntrto,
		 cnsctvo_cdgo_tpo_cntrto,			nmro_cntrto,
		 convert(numeric(12,0), (vlr * 100))    / convert(numeric(12,0), (100 + isnull(iva,0) )),
		 convert(numeric(12,0), (vlr * isnull(iva,0))) /  convert(numeric(12,0), (100 + iva )),
		 convert(numeric(12,0), (vlr * 100))    / convert(numeric(12,0), (100 + isnull(iva,0) )) + convert(numeric(12,0), (vlr * isnull(iva,0))) /  convert(numeric(12,0), (100 + isnull(iva,0) )),
		 Null,
		 Null
	From	#TMPcontratosresponsableFinal


   -- calculamos los valores totales de la nota y del iva  
   select @lnValorTotalAntIvaNota = sum(isnull(vlr,0)),
          @Valor_iva_nota         = sum(isnull(vlr_iva,0))
   from    tbNotasContrato
   where  nmro_nta              = @nmro_nta
   and    cnsctvo_cdgo_tpo_nta  = @lcTipoNota
 
   
   

	If  @@Error!=0
	Begin
		Set @lnProcesoExitoso	= 1
		Set @lcMensaje		= 'Error insertando los contratos por nota'
		Rollback Tran
		Return -1
	End



				

	-- Se crea una tabla temporal con la informacion  del valor de cada concepto para cada contrato
	-- y luego poder actualizar el concpeto asociadoa a la nota

	-- se inserta la informacion de cada contrato y cada concepto
	Insert	Into bdCarteraPac.dbo.tbNotasContratoxConcepto
		(cnsctvo_nta_cntrto,		cnsctvo_nta_cncpto,
		 vlr)
	Select	a.cnsctvo_nta_cntrto,		a.Cnsctvo_nta_cncpto,
		a.valor
	From	(Select	b.cnsctvo_nta_cntrto,		a.Valor,
			c.cnsctvo_nta_cncpto,		a.cnsctvo_cdgo_cncpto_lqdcn
		 From	#TMPcontratosresponsable	a Inner Join
			bdCarteraPac.dbo.tbNotasContrato b
		 On	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		 And	a.nmro_cntrto			=	b.nmro_cntrto Inner Join
			bdCarteraPac.dbo.tbNotasConceptos c
		 On	a.cnsctvo_cdgo_cncpto_lqdcn	=	c.cnsctvo_cdgo_cncpto_lqdcn
		 And	b.cnsctvo_cdgo_tpo_nta		=	c.cnsctvo_cdgo_tpo_nta
		 And	b.nmro_nta			=	c.nmro_nta
		 Where	c.nmro_nta			=	@nmro_nta
		 And	c.cnsctvo_cdgo_tpo_nta		=	@lcTipoNota
		 And	a.valor				>	0) a

	If  @@Error!= 0
	Begin
		Set @lnProcesoExitoso	= 1
		Set @lcMensaje		= 'Error insertando contrato del concepto de la nota'
		Rollback Tran
		Return -1
	End

	-- se crea una tabla con la infromacion de los estados de cuenta de cada contrato

	-- se inserta la infromacion en la tabla principal

	Insert	Into bdCarteraPac.dbo.tbCuentasContratoReintegro
		(cnsctvo_nta_cntrto,		cnsctvo_nta_cncpto,
		 cnsctvo_estdo_cnta_cntrto,	vlr_rntgro,cnsctvo_cdgo_tpo_dcmnto)
	Select	a.cnsctvo_nta_cntrto,		a.cnsctvo_nta_cncpto,
		a.cnsctvo_estdo_cnta_cntrto,	a.vlr_rntgro, a.cnsctvo_cdgo_tpo_dcmnto
	From	(Select	d.Consecutivo_documento_origen	cnsctvo_estdo_cnta_cntrto,
			b.cnsctvo_nta_cntrto,	b.cnsctvo_nta_cncpto,
			d.Vlr_rntgro,		d.cnsctvo_cdgo_cncpto_lqdcn, d.cnsctvo_cdgo_tpo_dcmnto 
			From	bdCarteraPac.dbo.tbNotasContrato a 
					Inner Join bdCarteraPac.dbo.tbNotasContratoxConcepto b
					On	a.cnsctvo_nta_cntrto		=	b.cnsctvo_nta_cntrto 
					Inner Join	bdCarteraPac.dbo.tbNotasConceptos c
					On	b.cnsctvo_nta_cncpto		=	c.cnsctvo_nta_cncpto
					And	a.nmro_nta			=	c.nmro_nta
					And	a.cnsctvo_cdgo_tpo_nta		=	c.cnsctvo_cdgo_tpo_nta Inner Join
					#TMPDocumentosDebitosFinal d
					On	c.cnsctvo_cdgo_cncpto_lqdcn	=	d.cnsctvo_cdgo_cncpto_lqdcn
					 Where	c.nmro_nta			=	@nmro_nta
					 And	c.cnsctvo_cdgo_tpo_nta		=	@lcTipoNota
					 And	d.vlr_rntgro			> 0
					 And	d.cnsctvo_cdgo_tpo_dcmnto	= 1	-- documentos nestados de cuenta
		 ) a







	If  @@Error!= 0
	Begin 
		Set @lnProcesoExitoso	= 1
		Set @lcMensaje		= 'Error insertando estado cuentas contrato'
		Rollback Tran
		Return -1
	End




	--ahora se hace para los documentos nota debito	
	--Se crea la tabla temporal de los documentos debito asociados al reintegro
	-- se inserta la infromacion en la tabla principal

	Insert	Into bdCarteraPac.dbo.tbCuentasContratoReintegro
		(cnsctvo_nta_cntrto,		cnsctvo_nta_cncpto,
		 cnsctvo_estdo_cnta_cntrto,	vlr_rntgro,cnsctvo_cdgo_tpo_dcmnto)
	Select	 a.cnsctvo_nta_cntrto,		a.cnsctvo_nta_cncpto,
		 a.cnsctvo_nta_cntrto_rntgro,	a.vlr_rntgro,a.cnsctvo_cdgo_tpo_dcmnto
	From	(Select	d.Consecutivo_documento_origen	cnsctvo_nta_cntrto_rntgro,
			b.cnsctvo_nta_cntrto,
			b.cnsctvo_nta_cncpto,
			d.Vlr_rntgro,
			d.cnsctvo_cdgo_cncpto_lqdcn,
			d.cnsctvo_cdgo_tpo_dcmnto
		 From	bdCarteraPac.dbo.tbNotasContrato a Inner Join
			bdCarteraPac.dbo.tbNotasContratoxConcepto b
		 On	a.cnsctvo_nta_cntrto		= b.cnsctvo_nta_cntrto Inner Join
			bdCarteraPac.dbo.tbNotasConceptos c
		 On	b.cnsctvo_nta_cncpto		= c.cnsctvo_nta_cncpto
		 And	a.nmro_nta			= c.nmro_nta
		 And	a.cnsctvo_cdgo_tpo_nta		= c.cnsctvo_cdgo_tpo_nta Inner Join
			#TMPDocumentosDebitosFinal d
		 On	d.cnsctvo_cdgo_cncpto_lqdcn	= c.cnsctvo_cdgo_cncpto_lqdcn
		 Where	c.nmro_nta			= @nmro_nta
		 And	c.cnsctvo_cdgo_tpo_nta		= @lcTipoNota
		 And	d.vlr_rntgro			> 0
		 And	d.cnsctvo_cdgo_tpo_dcmnto	= 2	-- documentos notas debito
		) a


	If  @@Error!= 0
	Begin
		Set @lnProcesoExitoso	= 1
		Set @lcMensaje		= 'Error insertando Notas debito '
		Rollback Tran
		Return -1
	End

End	-- Fin de a nivel de contrato



If @lnNivel	= 2		-- si es a nivel de responsable el pago
Begin
    
    -- realizamos el proeceso para consultar el valor del iva y el total de la nota
    --  Se modifica para consulta el iva que le corresponde a cada documento nota debito segun la fecha de creacion de estos,
    --  comparando estas fechas contra el rango en que este segun los campos inicio y fin vigencia de la tabla  tbConceptosLiquidacion_Vigencias
   insert into @documentos (
    iva,
    vlr,  
    consecutivo)
    select distinct 
    (b.vlr_rntgro * e.prcntje) /  (100 + e.prcntje ),
    (b.vlr_rntgro * 100) /  (100 + e.prcntje ),
     b.Consecutivo_documento_origen 
    From #TMPDocumentosSucursal b
    inner join tbNotasPac d  with (nolock)
    on     (d.nmro_nta               =  b.Consecutivo_documento_origen)
    inner join  tbConceptosLiquidacion_Vigencias e
    on     (e.cnsctvo_cdgo_cncpto_lqdcn	= 3 AND  d.fcha_crcn_nta Between e.inco_vgnca	And 	e.fn_vgnca)
    where   b.cnsctvo_cdgo_tpo_dcmnto	= 2  -- nota debito
    and     d.cnsctvo_cdgo_tpo_nta      = 1 -- nota debito



 select @lnValorTotalAntIvaNota  = sum(isnull(vlr,0) ),
        @Valor_iva_nota          = sum(isnull(iva,0))
        from @documentos 
 

/* se desactiva porque solo se guardaran notas debito cuando es por sucursal 
	Insert	Into	bdCarteraPac.dbo.tbNotasEstadoCuenta
		(nmro_nta,			cnsctvo_cdgo_tpo_nta,
		 cnsctvo_estdo_cnta,		vlr,
		 fcha_aplccn,			usro_aplccn)
	Select	@nmro_nta,			@lcTipoNota,
		Consecutivo_documento_origen,	vlr_rntgro,
		@ldFechaSistema,		@lcUsuario
	From	#TMPDocumentosSucursal
	Where	vlr_rntgro		> 0
	And	cnsctvo_cdgo_tpo_dcmnto	= 1  -- estado de cuenta

	If  @@error!=0  
	Begin 
		Set @lnProcesoExitoso	= 1
		Set @lcMensaje		= 'Error insertando Estados de cuenta del Responsable'
		Rollback Tran
		Return -1
	End
*/

     -- Andres camelo (illustrato ltda) 15/11/2013 insertamos los registros de la notas debito
	Insert	Into  tbRelacionNotasXNotaDebito
		(nmro_nta,			         cnsctvo_cdgo_tpo_nta,
		 nmro_nta_dbto,		         cnstvo_cdgo_tpo_nta_dbto,
         vlr,                        vlr_iva, 
         fcha_aplccn,		         usro_aplccn)
	Select	
        @nmro_nta,		              @lcTipoNota,
		Consecutivo_documento_origen, 2, -- nota debito 
        0,                            0,
     	@ldFechaSistema,        	  @lcUsuario
	From	#TMPDocumentosSucursal
	Where	vlr_rntgro		> 0
	And	cnsctvo_cdgo_tpo_dcmnto	= 2  -- notas  debito

     -- actualizamos los valores de las notas
      update a set   a.vlr      =  b.vlr,
                     a.vlr_iva  =  b.iva
      from  tbRelacionNotasXNotaDebito a
      inner join @documentos b
      on (b.consecutivo   =  a.nmro_nta_dbto)
     where fcha_aplccn    =  @ldFechaSistema

	If  @@error!=0  
	Begin 
		Set @lnProcesoExitoso	= 1
		Set @lcMensaje		= 'Error insertando las notas debito'
		Rollback Tran
		Return -1
	End

End


If @lnNivel	= 3		-- si es a nivel de responsable el pago no existente
  Begin
	
    
	insert into bdCarteraPac.dbo.TbDatosAportanteNotaReintegro (
		 nmro_nta
		,cnsctvo_cdgo_pgo
		,cnsctvo_cdgo_atrzdr_nta
		,cdgo_tpo_idntfccn
		,nmro_idntfccn
		,prmr_nmbre
		,sgndo_nmbre
		,prmr_aplldo
		,sgndo_aplldo
		,drccn_aprtnte
		,tlfno_aprtnte
		,cnsctvo_cdgo_cdd
		,cntro_csts
		,fcha_pgo_acrddo
		,sldo_pgo
		,fcha_crcn
		,usro_crcn
		,cnsctvo_cdgo_sde
	   )
	select @nmro_nta
		 ,cnsctvo_cdgo_pgo
		 ,cnsctvo_cdgo_atrzdr
		 ,cdgo_tpo_idntfccn
		 ,nmro_idntfccn
		 ,prmr_nmbre_aprtnte
		 ,sgndo_nmbre_aprtnte
		 ,prmr_aplldo_aprtnte
		 ,sgndo_aplldo_aprtnte
		 ,Substring(Rtrim(Ltrim(drccn_aprtnte)),1,50)
		 ,tlfno_aprtnte
		 ,cnsctvo_cdgo_cdd
		 ,cntro_csts
		 ,fcha_pgo_acrddo
		 ,sldo_pgo
		 ,fcha_crcn
		 ,usro_crcn
	    ,cnsctvo_cdgo_sde
	from #TMPAportanteNotaReintegro



    UPDATE tbPagos
	SET cnsctvo_cdgo_estdo_pgo = 4
	FROM #TMPcrpagosfiltro
	WHERE #TMPcrpagosfiltro.cnsctvo_cdgo_pgo  = bdCarteraPac.dbo.tbPagos.cnsctvo_cdgo_pgo 



   

 End  



Set @Valor_saldo_nota	= @lnValorTotalAntIvaNota	+	@Valor_iva_nota

-- insertamos la nota reintegro
update tbNotasPac set vlr_iva  = @Valor_iva_nota,
                      vlr_nta  = @lnValorTotalAntIvaNota,
                      sldo_nta = @Valor_saldo_nota
from tbNotasPac 
where nmro_nta              = @nmro_nta
and   cnsctvo_cdgo_tpo_nta  = @lcTipoNota

If  @@Error!=0
Begin
	Set @lnProcesoExitoso	= 1
	Set	@lcMensaje	= 'Error actualizando los valores de la nota'
	Rollback Tran
	Return -1
End


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
	Set	@lcMensaje	= 'Error insertando historico del estado de  la nota'
	Rollback Tran
	Return -1
End



  --guardamos los datos del aportante existente cuando el tipo de documento es solicitud de pago
 if (@lnNivel = 1 OR @lnNivel = 2 AND  ltrim(rtrim(@lndocumento))  = '2' )
 BEGIN

      insert into TbDatosAportanteNotaReintegro (
		 nmro_nta
		,cnsctvo_cdgo_pgo
		,cnsctvo_cdgo_atrzdr_nta
		,cdgo_tpo_idntfccn
		,nmro_idntfccn
		,prmr_nmbre
		,cntro_csts
		,fcha_pgo_acrddo
		,sldo_pgo
		,fcha_crcn
		,usro_crcn
		,cnsctvo_cdgo_sde
	    )
	  select 
         @nmro_nta
		 ,cnsctvo_cdgo_pgo
		 ,cnsctvo_cdgo_atrzdr
		 ,cdgo_tpo_idntfccn
		 ,nmro_idntfccn
		 ,prmr_nmbre_aprtnte
		 ,cntro_csts
		 ,fcha_pgo_acrddo
		 ,sldo_pgo
		 ,fcha_crcn
		 ,usro_crcn
	     ,cnsctvo_cdgo_sde
	  from #TMPAportanteNotaReintegro1


 END  

If  @@Error!=0
Begin
	Set @lnProcesoExitoso	= 1
	Set	@lcMensaje	= 'Error insertando los reintegros por aportante'
	Rollback Tran
	Return -1
End

Commit tran






