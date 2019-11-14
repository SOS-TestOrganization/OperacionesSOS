
/*---------------------------------------------------------------------------------
* Metodo o PRG 			:  SpGrabarNotaCreditoCastigo
* Desarrollado por	: <\A Ing. Fernando Valencia E										A\>
* Descripcion				: <\D Este procedimiento grabar una nota credito	D\>
* Observaciones			: <\O  																						O\>
* Parametros				: <\P																							P\>
* Variables					: <\V  																						V\>
* Fecha Creacion		: <\FC 2008/02/07																	FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  Rolando Simbaqueva LassoAM\>
* Descripcion					: <\DM  Aplicacion tecnicas de optimizacion DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion	: <\FM 2005 / 09 /26  FM\>

Quick 2013-001-008412 Sisdgb01 04/04/2013 Se ajusta agregando la validacion de que el estado de los EC sea diferente de 4 ANULADO

*---------------------------------------------------------------------------------*/
CREATE  PROCEDURE [dbo].[SpGrabarNotaCreditoCastigo]
	@lcTipoNota					udtConsecutivo,
	@lnTipoAplicacion				udtConsecutivo,	
	@lnValorIvaEstadoCuenta				numeric(12,3),
	@cnsctvo_estdo_cnta				udtConsecutivo,
	@lnValorTotalNota				udtValorGrande,
	@lcObservaciones				varchar(500),
	@nmro_unco_idntfccn_empldr			udtconsecutivo,
	@cnsctvo_scrsl					udtconsecutivo,
	@cnsctvo_cdgo_clse_aprtnte			udtconsecutivo,	
	@lcUsuario					udtUsuario,
	@lnSldoEstadoCuenta				udtValorGrande,
	@lntipoDocumento				int,
	@lnProcesoExitoso				int		output,
	@lcMensaje					char(200)	output,
	@nmro_nta					Varchar(15)	output

As	Declare
	@vlr_actl					int,
	@vlr_antrr					int,
	@cnsctvo_cdgo_estdo_nta				udtconsecutivo,
	@cnsctvo_cdgo_tpo_aplccn_nta			udtconsecutivo,
	@lnConsecutivoCodigoPeriodoLiquidacion		udtconsecutivo,
	@ldFechaSistema					datetime,	
	@ldFechaEvaluarPeriodo				datetime,
	@lnNumeroPeriodosEvaluados			int,
	@lnMax_cnsctvo_estdo_nta			udtconsecutivo,
	@lnMax_Cnsctvo_nta_cncpto			udtconsecutivo,
	@lnMax_cnsctvo_nta_cntrto			udtconsecutivo,
	@Valor_iva_nota					udtValorGrande,
	@NuevoSaldoEstadoCuenta				udtValorGrande,
	@Valor_saldo_nota				udtValorGrande,
	@lnValorInicialSaldoNota			udtValorGrande,
	@Valor_Porcentaje_Iva				udtValorDecimales,
	@MaximoConsecutivoContrato			udtConsecutivo,
	@MaximoConsecutivoResponsable			udtConsecutivo,
	@EstadoEstadoCuentaCanceladoTotal		udtConsecutivo,
	@Cantidad_Contratos_Pac				int,
	@lnCambioSaldoEstadoCuenta			int,
	@lnSumSaldocontrato				udtValorGrande,
	@cnsctvo_nta_aplcda_max				int
	
Set Nocount On

-- Creacion de tablas temporales
Create table #TMPConceptoNotaDebitoFinal
( nmro_rgstro int IDENTITY(1,1), 
  nmro_nta varchar(15),
  cnsctvo_cdgo_tpo_nta int,
  cnsctvo_cdgo_cncpto_lqdcn int,
  vlr_nta numeric(12,0),
  cnsctvo_cdgo_autrzdr_espcl int,
  cnsctvo_nta_cncpto int)

Create table #tmpContratosResponsableTotal
(cnsctvo_cdgo_tpo_cntrto int,
 nmro_cntrto varchar(20),
 cnsctvo_estdo_cnta_cntrto int,
 vlr numeric(12),
 vlr_iva numeric(12))

Create table #TMPcontratosresponsableFinal
( nmro_rgstro int IDENTITY(1,1), 
  nmro_nta varchar(15),
  cnsctvo_cdgo_tpo_nta int,
  cnsctvo_estdo_cnta_cntrto int,
  cnsctvo_cdgo_tpo_cntrto int,
  nmro_cntrto varchar(20),
  vlr numeric(12),
  vlr_iva numeric (12),)

Create table #tmpnotasContratoxConcepto
(cnsctvo_nta_cntrto int,
 Valor numeric(12),
 Cnsctvo_nta_cncpto int,
 cnsctvo_cdgo_cncpto_lqdcn int,
vlr_ants_iva numeric(12),
vlr_iva numeric(12))


if	@lnTipoAplicacion	=	1		-- si para aplicar ahora

	Begin

		IF 	@lntipoDocumento			=	9
			Begin				
				Select	@lnSumSaldocontrato			=	sum(isnull(b.sldo,0))
				From	bdcarteraPac.dbo.TbestadosCuenta a inner join bdcarteraPac.dbo.tbestadoscuentacontratos b
					on (a.cnsctvo_estdo_cnta		=	b.cnsctvo_estdo_cnta)
				Where	a.cnsctvo_estdo_cnta			=	@cnsctvo_estdo_cnta
				And	isnull(b.sldo,0)			>	0
                and a.cnsctvo_cdgo_estdo_estdo_cnta != 4

				If 	@lnSumSaldocontrato	 		!=	@lnSldoEstadoCuenta
					Begin 
						Set	@lnProcesoExitoso	=	1
						Set	@lcMensaje		=	'Error el Saldo del Estado cuenta Cambio  por favor vuelva a consultarlo'
						Return -1
					End	
			end

		IF 	@lntipoDocumento			=	10
			Begin				
				Select	@lnSumSaldocontrato		=	sum(isnull(b.sldo_nta_cntrto,0))
				From	bdcarteraPac.dbo.tbnotasPac a inner join bdcarteraPac.dbo.tbnotasContrato b
					on     (a.nmro_nta			=	b.nmro_nta
					And	a.cnsctvo_cdgo_tpo_nta		=	b.cnsctvo_cdgo_tpo_nta	)
				Where	a.cnsctvo_cdgo_tpo_nta		=	1
				And	a.nmro_nta			=	convert(varchar(15),@cnsctvo_estdo_cnta) -- se utiliza la misma variable para notas debito
				And	isnull(b.sldo_nta_cntrto,0)	>	0


				If 	@lnSumSaldocontrato	 		!=	@lnSldoEstadoCuenta
					Begin 
						Set	@lnProcesoExitoso	=	1
						Set	@lcMensaje		=	'Error el Saldo de la nota debito Cambio  por favor vuelva a consultarlo'
						Return -1
					End	
			end

	End


Set	@ldFechaSistema			=	Getdate()
Set	@ldFechaEvaluarPeriodo		=	DATEADD ( month , 1, @ldFechaSistema ) 
Set	@EstadoEstadoCuentaCanceladoTotal	=	3
set	@Cantidad_Contratos_Pac		=	0

If	@lnTipoAplicacion			=	1           
								 -- es para aplicar ahora  y se amarra al estado de cuenta
	Set	@cnsctvo_cdgo_estdo_nta	=	4  	-- estado 	aplicada 
else
	Set	@cnsctvo_cdgo_estdo_nta	=	5  	-- estado 	sin aplicar


Set	@cnsctvo_cdgo_tpo_aplccn_nta	=	@lnTipoAplicacion	-- tipo de aplicacion , aplicar ahora  o   aplicar proximo periodo
Set	@lnProcesoExitoso		=	0
Set	@Valor_Porcentaje_Iva		=	0

-- trae el valor del porcentaje  para aplicar
Select 	@Valor_Porcentaje_Iva		=	prcntje
From	bdcarteraPac.dbo.tbconceptosliquidacion_vigencias
where   cnsctvo_cdgo_cncpto_lqdcn	=	3
And	@ldFechaSistema  between inco_vgnca	and 	fn_vgnca

If  @Valor_Porcentaje_Iva	=	0
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'No existe parametrizacion de iva para procesar'
		Return -1
	end	


IF	@lnTipoAplicacion	=	1		-- si para aplicar ahora
	Begin
		Set	@Valor_Porcentaje_Iva		=	@lnValorIvaEstadoCuenta
		select  @lnValorTotalNota 	= sum(isnull(vlr_sn_iva,0)) 	from #TMPcontratosresponsable
		--select	 @Valor_iva_nota	=	 convert(numeric,round(sum(convert(float, (valor * @Valor_Porcentaje_Iva)) /  convert(float,(100 + @Valor_Porcentaje_Iva ))),0))
		Where	valor	>	0

 		select 	@Valor_iva_nota 	= sum(isnull(vlr_iva,0)) 		from #TMPcontratosresponsable
		Where	valor	>	0

	End
Else
	Begin
		Set 	@Valor_iva_nota		=	isnull(((@lnValorTotalNota	*	@Valor_Porcentaje_Iva) 	/	100),0)
	End

-- se calcula el saldo de la nota valor de la nota  mas el valor del iva de la nota
Set 	@Valor_saldo_nota		=	@lnValorTotalNota	--+	@Valor_iva_nota
Set	@lnValorInicialSaldoNota	=	@Valor_saldo_nota


-- Se verifica con la cantidad de registros que existan con la consulta
--Se verifica que le periodo que tiene el estado abierto sea el siguiente al periodo actual
select	 @lnNumeroPeriodosEvaluados	=	count(*)  
from	  bdcarteraPac.dbo.tbperiodosliquidacion_vigencias
Where	 convert(varchar(10),@ldFechaEvaluarPeriodo,111) 	
	between convert(varchar(10),fcha_incl_prdo_lqdcn,111)       and
	convert(varchar(10),fcha_fnl_prdo_lqdcn,111) -- que sea el siguiente del periodo a evaluar
and  	 @ldFechaSistema 	   	between  inco_vgnca   		and      fn_vgnca
and  	  cnsctvo_cdgo_estdo_prdo	=	2	-- estado del periodo abierto


If  @lnNumeroPeriodosEvaluados <>	1	
	Begin 

		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'El periodo esta en un rango no que no se puede liquidar'
		Return -1
	end	

--Se traer el consecutivo del periodo de liquidacion
select	@lnConsecutivoCodigoPeriodoLiquidacion	 =	 cnsctvo_cdgo_prdo_lqdcn  
from	bdcarteraPac.dbo.tbperiodosliquidacion_vigencias
Where	convert(varchar(10),@ldFechaEvaluarPeriodo,111) 	
	between convert(varchar(10),fcha_incl_prdo_lqdcn,111)       and
	convert(varchar(10),fcha_fnl_prdo_lqdcn,111) -- que sea el siguiente del periodo a evaluar
and  	@ldFechaSistema 	   	between  inco_vgnca   		and      fn_vgnca
and  	cnsctvo_cdgo_estdo_prdo	=	2	-- estado del periodo abierto



-- se consulta el consecutivo actual del estado de cuenta y consecutivo anterior
Select    @vlr_actl	=	isnull(vlr_actl,0) + 1,
	 @vlr_antrr	=	vlr_actl
From	 bdcarteraPac.dbo.tbtiposconsecutivo_vigencias
Where	 cnsctvo_cdgo_tpo_cnsctvo = 2  -- consecutivos de nota credito


Begin Tran 

--Actualizamos el consecutivo del estado  de cuenta
update  bdcarteraPac.dbo.tbtiposconsecutivo_vigencias
Set 	vlr_actl		=	@vlr_actl,
	vlr_antrr		=	@vlr_antrr
Where	 cnsctvo_cdgo_tpo_cnsctvo = 2 -- actualizamos el consecutivo de nota credito

If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error Actualizando el tipo de conseuctivo'
			Rollback tran 
			Return -1
		end	


Set	@nmro_nta	 = convert(varchar(15),@vlr_actl)

if	@lnTipoAplicacion	=	1		-- si para aplicar ahora
	Set	@lnValorInicialSaldoNota	=	0

Insert into 	bdcarteraPac.dbo.TbNotasPac	(nmro_nta,		cnsctvo_cdgo_tpo_nta,		vlr_nta,
				vlr_iva,			sldo_nta,			cnsctvo_prdo,
				fcha_crcn_nta,		cnsctvo_cdgo_estdo_nta,		cnsctvo_cdgo_tpo_aplccn_nta,
				obsrvcns,		usro_crcn,			nmro_unco_idntfccn_empldr,
				cnsctvo_scrsl,		cnsctvo_cdgo_clse_aprtnte)
			Values
				(@nmro_nta,		@lcTipoNota,			isnull(@lnValorTotalNota,0),
				isnull(@Valor_iva_nota,0),	isnull(@lnValorInicialSaldoNota,0),	@lnConsecutivoCodigoPeriodoLiquidacion,					
				@ldFechaSistema,	@cnsctvo_cdgo_estdo_nta,	@cnsctvo_cdgo_tpo_aplccn_nta,
				@lcObservaciones,	@lcUsuario,			@nmro_unco_idntfccn_empldr,
				@cnsctvo_scrsl,		@cnsctvo_cdgo_clse_aprtnte)


				If  @@error!=0  
					Begin 
						Set	@lnProcesoExitoso	=	1
						Set	@lcMensaje		=	'Error creando la nota'
						Rollback tran 
						Return -1
					end	
--Se consulta el numero siguiente del concepto y nota 

Select 	@lnMax_Cnsctvo_nta_cncpto	=	 isnull(max(Cnsctvo_nta_cncpto),0)	 
From	tbNotasConceptos

-- se crea una tabla temporal con un contador  para que de esta forma poder asociar de una forma mas facil
-- el consecutivo del registro en tbnotasconceptos

Insert into	#TMPConceptoNotaDebitoFinal
Select	@nmro_nta	nmro_nta,
	@lcTipoNota	cnsctvo_cdgo_tpo_nta,
	cnsctvo_cdgo_cncpto_lqdcn,
	valor		vlr_nta,
	cnsctvo_cdgo_autrzdr_espcl,
	0	cnsctvo_nta_cncpto
From	#TMPConceptoNotaDebito
--Where	 valor		>	0


--Se graba los conceptos de la nota debito
Insert into bdcarteraPac.dbo.tbNotasConceptos
Select 	(nmro_rgstro	+	@lnMax_Cnsctvo_nta_cncpto),
	nmro_nta,
	cnsctvo_cdgo_tpo_nta,
	cnsctvo_cdgo_cncpto_lqdcn,
	vlr_nta,
	Null
From	#TMPConceptoNotaDebitoFinal

If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error insertando el concepto por nota'
		Rollback tran 
		Return -1
	end	

Update #TMPConceptoNotaDebitoFinal
Set	cnsctvo_nta_cncpto		=	b.cnsctvo_nta_cncpto
From	#TMPConceptoNotaDebitoFinal	a inner join	tbNotasConceptos	b
	on (a.cnsctvo_cdgo_cncpto_lqdcn	=	b.cnsctvo_cdgo_cncpto_lqdcn)
Where	b.nmro_nta			=	@nmro_nta
And	b.cnsctvo_cdgo_tpo_nta		=	@lcTipoNota


Insert	into bdcarteraPac.dbo.tbautorizacionesnotas
Select	cnsctvo_nta_cncpto,
	cnsctvo_cdgo_autrzdr_espcl,
	Null	
From	#TMPConceptoNotaDebitoFinal
Where	cnsctvo_cdgo_autrzdr_espcl	>	0

If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error insertando los autorizadores  por nota'
		Rollback tran 
		Return -1
	end	


if	@lnTipoAplicacion	=	1		-- si para aplicar ahora
	Begin
	--Se calcula el valor maximo de cada contrato

	Insert 	into	#tmpContratosResponsableTotal
	Select 		cnsctvo_cdgo_tpo_cntrto,
			nmro_cntrto,
			cnsctvo_estdo_cnta_cntrto,
			Sum(vlr_sn_iva)	vlr_sn_iva,
			sum(vlr_iva)	vlr_iva
	From		#TMPcontratosresponsable
	Group by	 cnsctvo_cdgo_tpo_cntrto,
			nmro_cntrto,	cnsctvo_estdo_cnta_cntrto
	-- se crea la tabla temporal de l valor total por cada contrato  para controlar el numero del consecutivo
	
	Insert 	into 	#TMPcontratosresponsableFinal
	Select   @nmro_nta		nmro_nta,
		@lcTipoNota		cnsctvo_cdgo_tpo_nta,
		cnsctvo_estdo_cnta_cntrto,
		cnsctvo_cdgo_tpo_cntrto,
		nmro_cntrto,
		vlr,
		vlr_iva
		From	#tmpContratosResponsableTotal
	Where	Vlr	>	0
 
	-- se busca el maximo del consecutivo nota contrato
	Select 	@lnMax_cnsctvo_nta_cntrto	=	 isnull(max(cnsctvo_nta_cntrto),0)	 
	From	bdcarteraPac.dbo.tbnotasContrato

	if 	@lntipoDocumento	=	9
	
		-- se inserta la informacion a nivel de contrato de la nota
		insert into	 bdcarteraPac.dbo.TbnotasContrato
		Select 		(nmro_rgstro	+	@lnMax_cnsctvo_nta_cntrto),
				nmro_nta,
				cnsctvo_cdgo_tpo_nta,
				cnsctvo_estdo_cnta_cntrto,
				cnsctvo_cdgo_tpo_cntrto,
				nmro_cntrto,
				vlr,				
				vlr_iva,
				0,	--	vlr,  --saldo de la nota
				Null,
				Null,
				Null
		From		#TMPcontratosresponsableFinal

	else

		insert into	bdcarteraPac.dbo.TbnotasContrato
		Select 		(nmro_rgstro	+	@lnMax_cnsctvo_nta_cntrto),
				nmro_nta,
				cnsctvo_cdgo_tpo_nta,
				0,
				cnsctvo_cdgo_tpo_cntrto,
				nmro_cntrto,
				vlr,
				vlr_iva,
				0,	--	vlr,  --saldo de la nota
				Null,
				Null,
				Null
		From		#TMPcontratosresponsableFinal

	If  @@error!=0  
		Begin 
			Set	@lnProcesoExitoso	=	1
			Set	@lcMensaje		=	'Error insertando los contratos por nota'
			Rollback tran 
			Return -1
		end	


	-- Se crea una tabla temporal con la informacion  del valor de cada concepto para cada contrato
	-- y luego poder actualizar el concpeto asociadoa a la nota

	Insert 	Into	#tmpnotasContratoxConcepto	
	Select	b.cnsctvo_nta_cntrto,
		a.valor,
		0	Cnsctvo_nta_cncpto,
		a.cnsctvo_cdgo_cncpto_lqdcn,
		a.vlr_sn_iva,
		a.vlr_iva
	From	#TMPcontratosresponsable a inner join	bdcarteraPac.dbo.TbnotasContrato b
		on 	(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And	a.nmro_cntrto			=	b.nmro_cntrto)
		Where	b.nmro_nta			=	@nmro_nta
	And	b.cnsctvo_cdgo_tpo_nta		=	@lcTipoNota
	And	a.valor				>	0



	-- actualiza el valor del concepto por nota
	Update 	#tmpnotasContratoxConcepto
	Set	Cnsctvo_nta_cncpto		=	b.Cnsctvo_nta_cncpto
	From	#tmpnotasContratoxConcepto	a inner join	bdcarteraPac.dbo.tbNotasConceptos	b
		on (a.cnsctvo_cdgo_cncpto_lqdcn	=	b.cnsctvo_cdgo_cncpto_lqdcn)
	Where	b.nmro_nta			=	@nmro_nta
	And	b.cnsctvo_cdgo_tpo_nta		=	@lcTipoNota 

	Insert into bdcarteraPac.dbo.tbnotasContratoxConcepto
	Select	cnsctvo_nta_cntrto,
	Cnsctvo_nta_cncpto,
	valor,
	vlr_ants_iva,
	vlr_iva,
	Null	
	From	 #tmpnotasContratoxConcepto a
	Where 	Not Exists ( Select  1 From bdcarteraPac.dbo.tbnotasContratoxConcepto b
			    where   a.cnsctvo_nta_cntrto = b.cnsctvo_nta_cntrto
			     and    a.Cnsctvo_nta_cncpto = b.Cnsctvo_nta_cncpto)

	If  @@error!=0  
		Begin 
			Set	@lnProcesoExitoso	=	1
			Set	@lcMensaje		=	'Error insertando contrato del concepto de la nota'
			Rollback tran 
			Return -1
		end	


	IF	 @lntipoDocumento		=	9   -- Estado de cuenta
		begin	
		
	
			Insert	into	bdcarteraPac.dbo.tbnotasestadocuenta	(nmro_nta,       cnsctvo_cdgo_tpo_nta,	 cnsctvo_estdo_cnta, 	vlr,		fcha_aplccn ,  usro_aplccn)
					  Values	(@nmro_nta,	@lcTipoNota,	@cnsctvo_estdo_cnta,	(@lnValorTotalNota+isnull(@Valor_iva_nota,0)),	@ldFechaSistema,@lcUsuario  )	

			If  @@error!=0  
				Begin 
					Set	@lnProcesoExitoso	=	1
					Set	@lcMensaje		=	'Error insertando la nota del estado cuenta'
					Rollback tran 
					Return -1
				end	



			-- se disminuye el saldo de los contratos  del estado de cuenta
			Update	bdcarteraPac.dbo.tbestadoscuentacontratos
			Set	sldo	=	a.sldo	-	(b.vlr	+	b.vlr_iva),		-- se debe de colocar incluido el iva b.vlr
				fcha_ultma_mdfccn	=	@ldFechaSistema,
				usro_ultma_mdfccn	=	@lcUsuario
			From	bdcarteraPac.dbo.tbestadoscuentacontratos	a inner join	bdcarteraPac.dbo.tbnotascontrato	b
				on (a.cnsctvo_estdo_cnta_cntrto	=	b.cnsctvo_estdo_cnta_cntrto)
			Where	b.nmro_nta			=	@nmro_nta
			And	b.cnsctvo_cdgo_tpo_nta		=	@lcTipoNota

			If  @@error!=0  
				Begin 
					Set	@lnProcesoExitoso	=	1
					Set	@lcMensaje		=	'Error Actualizando el  saldo del contrato del estado cuenta'
					Rollback tran 
					Return -1
				end	

			--Se verifica el nuevo saldo
			Select		@NuevoSaldoEstadoCuenta		=	sldo_estdo_cnta	-		(@Valor_saldo_nota+ isnull(@Valor_iva_nota,0))
			From		bdcarteraPac.dbo.tbestadoscuenta
			Where		cnsctvo_estdo_cnta		=	@cnsctvo_estdo_cnta
            and   cnsctvo_cdgo_estdo_estdo_cnta != 4

			Update	bdcarteraPac.dbo.tbestadoscuenta
			Set	sldo_estdo_cnta			=	sldo_estdo_cnta		-		(@Valor_saldo_nota+ isnull(@Valor_iva_nota,0))
			Where	cnsctvo_estdo_cnta		=	@cnsctvo_estdo_cnta
             and   cnsctvo_cdgo_estdo_estdo_cnta != 4

			If  @@error!=0  
				Begin 
					Set	@lnProcesoExitoso	=	1
					Set	@lcMensaje		=	'Error Actualizando el  saldo del estado de cuenta'
					Rollback tran 
					Return -1
				end	


			Update	bdcarteraPac.dbo.tbestadoscuenta
			Set	cnsctvo_cdgo_estdo_estdo_cnta			=	case when 	sldo_estdo_cnta		<=	0 then  3 else 2 end
			Where	cnsctvo_estdo_cnta				=	@cnsctvo_estdo_cnta
              and   cnsctvo_cdgo_estdo_estdo_cnta != 4

			If  @@error!=0  
				Begin 
					Set	@lnProcesoExitoso	=	1
					Set	@lcMensaje		=	'Error Actualizando el  saldo del estado de cuenta'
					Rollback tran 
					Return -1
				end	

			if	@NuevoSaldoEstadoCuenta	=	0

				-- se actualiza el estado del estado de cuenta	 a cancelado total
				Begin
					Update 	bdcarteraPac.dbo.tbestadoscuenta
					Set	cnsctvo_cdgo_estdo_estdo_cnta	=	@EstadoEstadoCuentaCanceladoTotal
					Where	cnsctvo_estdo_cnta		=	@cnsctvo_estdo_cnta
		             and   cnsctvo_cdgo_estdo_estdo_cnta != 4

					If  @@error!=0  
						Begin 
							Set	@lnProcesoExitoso	=	1
							Set	@lcMensaje		=	'Error Actualizando el  estado del estado de cuenta'
							Rollback tran 
							Return -1
						end	
				End
	
		End	
	IF	 @lntipoDocumento		=	10   -- Nota debito
		begin	
		

                        	
			Select     @cnsctvo_nta_aplcda_max	  = 	isnull(max(cnsctvo_nta_aplcda),0) + 1
			From	 bdcarteraPac.dbo.TbNotasAplicadas

			Insert	into	bdcarteraPac.dbo.tbNotasAplicadas	(cnsctvo_nta_aplcda,nmro_nta,cnsctvo_cdgo_tpo_nta,nmro_nta_aplcda,
								cnsctvo_cdgo_tpo_nta_aplcda,vlr_aplcdo,fcha_crcn,usro_crcn)

			Values	(@cnsctvo_nta_aplcda_max, @nmro_nta,	@lcTipoNota,	
				convert(varchar(15),@cnsctvo_estdo_cnta),	1,isnull((@lnValorTotalNota+ isnull(@Valor_iva_nota,0)),0),	@ldFechaSistema,@lcUsuario  )

			If  @@error!=0  
				Begin 
					Set	@lnProcesoExitoso	=	1
					Set	@lcMensaje		=	'Error insertando la nota aplicada'
					Rollback tran 
					Return -1
				end	
		
 
			insert into bdcarteraPac.dbo.tbNotasCreditoContratosxNotasDebito	
			Select 	 (nmro_rgstro	+	@lnMax_cnsctvo_nta_cntrto),
				cnsctvo_estdo_cnta_cntrto,
				vlr+vlr_iva,
				Null
			 From	 #TMPcontratosresponsableFinal

			-- se disminuye el saldo de los contratos  de la nota debito
			Update	bdcarteraPac.dbo.tbnotascontrato
			Set	sldo_nta_cntrto		=	isnull(a.sldo_nta_cntrto - (tmpNotaCredito.vlr+tmpNotaCredito.vlr_iva),0) ,----OJO 
				fcha_ultma_mdfccn	=	@ldFechaSistema,
				usro_ultma_mdfccn	=	@lcUsuario
			From	bdcarteraPac.dbo.tbnotascontrato	a,	(Select  cnsctvo_estdo_cnta_cntrto   cnsctvo_nta_cntrto,
								vlr, vlr_iva
							 From	 #TMPcontratosresponsableFinal )  tmpNotaCredito  -- la nota credito creada
			Where	a.cnsctvo_nta_cntrto		=	tmpNotaCredito.cnsctvo_nta_cntrto
			And	a.cnsctvo_cdgo_tpo_nta		=	1

			If  @@error!=0  
				Begin 
					Set	@lnProcesoExitoso	=	1
					Set	@lcMensaje		=	'Error Actualizando el  saldo del contrato del  la nota debito'
					Rollback tran 
					Return -1
				end	

			--Se verifica el nuevo saldo
			Select	@NuevoSaldoEstadoCuenta		=	isnull(sldo_nta	-	(@Valor_saldo_nota+isnull(@Valor_iva_nota,0)),0)
			From	bdcarteraPac.dbo.tbnotasPac
			Where	ltrim(rtrim(nmro_nta))		=	ltrim(rtrim(convert(varchar(15),@cnsctvo_estdo_cnta)))
			And	cnsctvo_cdgo_tpo_nta		=	1


			Update	bdcarteraPac.dbo.tbnotasPac
			Set	sldo_nta			=	isnull(sldo_nta	-	(@Valor_saldo_nota+isnull(@Valor_iva_nota,0)),0)
			Where	ltrim(rtrim(nmro_nta))		=	ltrim(rtrim(convert(varchar(15),@cnsctvo_estdo_cnta)))
			And	cnsctvo_cdgo_tpo_nta		=	1


			If  @@error!=0  
				Begin 
					Set	@lnProcesoExitoso	=	1
					Set	@lcMensaje		=	'Error Actualizando el  saldo de la nota debito'
					Rollback tran 
					Return -1
				end	


			Update	bdcarteraPac.dbo.tbnotasPac
			Set	cnsctvo_cdgo_estdo_nta	=	case when 	isnull(sldo_nta,0)		<=	0 then  3 else 2 end
			Where	ltrim(rtrim(nmro_nta))		=	ltrim(rtrim(convert(varchar(15),@cnsctvo_estdo_cnta)))
			And	cnsctvo_cdgo_tpo_nta		=	1


			If  @@error!=0  
				Begin 
					Set	@lnProcesoExitoso	=	1
					Set	@lcMensaje		=	'Error Actualizando el  saldo de la nota debito'
					Rollback tran 
					Return -1
				end	

			if	@NuevoSaldoEstadoCuenta	=	0

				-- se actualiza el estado del estado de cuenta	 a cancelado total
				Begin
					Update 	bdcarteraPac.dbo.tbnotasPac
					Set	cnsctvo_cdgo_estdo_nta	=	@EstadoEstadoCuentaCanceladoTotal
					Where	ltrim(rtrim(nmro_nta))		=	ltrim(rtrim(convert(varchar(15),@cnsctvo_estdo_cnta)))
					And	cnsctvo_cdgo_tpo_nta		=	1
		
					If  @@error!=0  
						Begin 
							Set	@lnProcesoExitoso	=	1
							Set	@lcMensaje		=	'Error Actualizando el  estado de la nota debito'
							Rollback tran 
							Return -1
						end	
				End
	
		End	
End	-- Fin de aplicar ahora	




-- se consulta el maximo consecutivo que siguie para el estado por nota
-- se guardan todos los estado por nota
Select 	@lnMax_cnsctvo_estdo_nta	=	 isnull(max(cnsctvo_estdo_nta),0)	 
From	bdcarteraPac.dbo.tbestadosXnota

Insert into bdcarteraPac.dbo.TbestadosXnota
		(cnsctvo_estdo_nta,		nmro_nta,		cnsctvo_cdgo_tpo_nta,
		cnsctvo_cdgo_estdo_nta,		vlr_nta,			vlr_iva,
		sldo_nta,			fcha_cmbo_estdo,	usro_cmbo_estdo)
Values  	(@lnMax_cnsctvo_estdo_nta+1,	@nmro_nta,		@lcTipoNota,
		@cnsctvo_cdgo_estdo_nta,	isnull(@lnValorTotalNota,0),	isnull(@Valor_iva_nota,0),
		isnull(@Valor_saldo_nota,0),		@ldFechaSistema,	@lcUsuario)
		


	If  @@error!=0  
					Begin 
						Set	@lnProcesoExitoso	=	1
						Set	@lcMensaje		=	'Error insertando historico del estado de  la nota'
						Rollback tran 
						Return -1
					end	
	
Commit tran

