/*---------------------------------------------------------------------------------
* Metodo o PRG 		:  SpGrabarNotaCredito
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento grabar una nota credito								D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003/03/04											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  Rolando Simbaqueva LassoAM\>
* Descripcion			: <\DM  Aplicacion tecnicas de optimizacion DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM 2005 / 09 /26  FM\>
----------------------------------------------------------------------------------
* Modificado Por			: <\AM Andres Camelo (illustrato ltda) AM\>
* Descripcion			: <\DM   Se modifica para actualizar la fecha de ultima modificacion en la tabla tbCuentasContratoReintegro cuando el tipo nota es REI, 
                                 se agrega sentencia de insercion sobre la nueva tabla tbRelacionNotasCreditoReiNotasReintegro para relacionar  una nota credito REI con una nota Reintegro
DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM 2013/11/12 FM\>
*   
----------------------------------------------------------------------------------
* Modificado Por			: <\AM Andres Camelo (illustrato ltda) AM\>
* Descripcion			: <\DM  Se agrega sentencia de inserccion sobre la nueva tabla tbRelacionNotasCreditoReiNotasReintegro para relacionar  una nota credito REI con una nota Reintegro
DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM 22/11/2013 FM\> 
*   
----------------------------------------------------------------------------------
* Modificado Por			: <\AM Janeth Barrera AM\>
* Descripcion			: <\DM  Se incluye calculo de datos DIAN procedimiento spCalcularDatosFExNotaPAC DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM 31/07/2019 FM\> 
*   
*---------------------------------------------------------------------------------*/
CREATE    PROCEDURE [dbo].[SpGrabarNotaCredito]
	@lcTipoNota					udtConsecutivo,
	@lnTipoAplicacion			udtConsecutivo,	
	@lnValorIvaEstadoCuenta		numeric(12,3),
	@cnsctvo_estdo_cnta			udtConsecutivo,
	@lnValorTotalNota			udtValorGrande,
	@lcObservaciones			varchar(500),
	@nmro_unco_idntfccn_empldr	udtconsecutivo,
	@cnsctvo_scrsl				udtconsecutivo,
	@cnsctvo_cdgo_clse_aprtnte	udtconsecutivo,	
	@lcUsuario					udtUsuario,
	@lnSldoEstadoCuenta			udtValorGrande,
	@lntipoDocumento			int,
	@lnProcesoExitoso			int		output,
	@lcMensaje					char(200)	output,
	@nmro_nta					Varchar(15)	output,
	@cnsctvo_cdgo_prdo_lqdcn    int,
    @lnNumeroReintegro          udtconsecutivo = null

As	Declare
	@vlr_actl					int,
	@vlr_antrr					int,
	@cnsctvo_cdgo_estdo_nta			udtconsecutivo,
	@cnsctvo_cdgo_tpo_aplccn_nta			udtconsecutivo,
	@lnConsecutivoCodigoPeriodoLiquidacion	udtconsecutivo,
	@ldFechaSistema				datetime,	
	@ldFechaEvaluarPeriodo			datetime,
	@lnNumeroPeriodosEvaluados			int,
	@lnMax_cnsctvo_estdo_nta			udtconsecutivo,
	@lnMax_Cnsctvo_nta_cncpto			udtconsecutivo,
	@lnMax_cnsctvo_nta_cntrto			udtconsecutivo,
	@Valor_iva_nota				udtValorGrande,
	@NuevoSaldoEstadoCuenta			udtValorGrande,
	@Valor_saldo_nota				udtValorGrande,
	@lnValorInicialSaldoNota			udtValorGrande,
	@Valor_Porcentaje_Iva				udtValorDecimales,
	@MaximoConsecutivoContrato			udtConsecutivo,
	@MaximoConsecutivoResponsable		udtConsecutivo,
	@EstadoEstadoCuentaCanceladoTotal		udtConsecutivo,
	@Cantidad_Contratos_Pac			int,
	@lnCambioSaldoEstadoCuenta			int,
	@lnSumSaldocontrato				udtValorGrande,
	@cnsctvo_nta_aplcda_max			int,	
	@lnTipoDocumentoFactura				int,
	@lnTipo							int
	
	set @lnTipoDocumentoFactura = 6 -- Factura

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
 vlr numeric(12,0))

Create table #TMPcontratosresponsableFinal
( nmro_rgstro int IDENTITY(1,1), 
  nmro_nta varchar(15),
  cnsctvo_cdgo_tpo_nta int,
  cnsctvo_estdo_cnta_cntrto int,
  cnsctvo_cdgo_tpo_cntrto int,
  nmro_cntrto varchar(20),
  vlr numeric(12,0))

Create table #tmpnotasContratoxConcepto
(cnsctvo_nta_cntrto int,
 Valor numeric(12,0),
 Cnsctvo_nta_cncpto int,
 cnsctvo_cdgo_cncpto_lqdcn int)







if	@lnTipoAplicacion	=	1		-- si para aplicar ahora

	Begin

/*
		
		Select	@lnCambioSaldoEstadoCuenta		=	isnull(count(*),0)
		From	TbestadosCuenta 
		Where	cnsctvo_estdo_cnta			=	@cnsctvo_estdo_cnta
		And	@lnSldoEstadoCuenta			!=	sldo_estdo_cnta

		If 	@lnCambioSaldoEstadoCuenta 		>	0
			Begin 
				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje		=	'Error el Saldo del Estado cuenta Cambio  por favor vuelva a consultarlo'
				Return -1
			End	
		
*/	

		IF 	@lntipoDocumento			=	9
			Begin				
				Select	@lnSumSaldocontrato			=	sum(isnull(b.sldo,0))
				From	bdcarteraPac.dbo.TbestadosCuenta a inner join bdcarteraPac.dbo.tbestadoscuentacontratos b
					on (a.cnsctvo_estdo_cnta		=	b.cnsctvo_estdo_cnta)
				Where	a.cnsctvo_estdo_cnta			=	@cnsctvo_estdo_cnta
				And	isnull(b.sldo,0)			>	0


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
--Set	@ldFechaEvaluarPeriodo		=	DATEADD ( month , 1, @ldFechaSistema ) 
Set	@EstadoEstadoCuentaCanceladoTotal	=	3
set	@Cantidad_Contratos_Pac		=	0

select @ldFechaEvaluarPeriodo = fcha_incl_prdo_lqdcn 
From	bdCarteraPac.dbo.tbPeriodosliquidacion_Vigencias
Where	cnsctvo_cdgo_prdo_lqdcn = @cnsctvo_cdgo_prdo_lqdcn

If	@lnTipoAplicacion			=	1           
								 -- es para aplicar ahora  y se amarra al estado de cuenta
	Set	@cnsctvo_cdgo_estdo_nta	=	4  	-- estado 	aplicada 
else
	Set	@cnsctvo_cdgo_estdo_nta	=	5  	-- estado 	sin aplicar

-- se valida que existan  contratos de planes complementarios
/* se quita para prueba 20010131
	
select   * 
into 	 #tmpCobranzas
From	 bdafiliacion..tbCobranzas
where 	 nmro_unco_idntfccn_aprtnte 	=	 @nmro_unco_idntfccn_empldr
and 	 cnsctvo_cdgo_clse_aprtnte 	= 	@cnsctvo_cdgo_clse_aprtnte

Select 	 cnsctvo_cdgo_tpo_cntrto,	 nmro_cntrto
into	 #tmpContratosCobranzas
From	#tmpCobranzas
Group by cnsctvo_cdgo_tpo_cntrto, 	nmro_cntrto

select  	@Cantidad_Contratos_Pac	=  Count(*) 
from 	bdafiliacion..tbVigenciasCobranzas  a, #tmpContratosCobranzas  b
where 	a.cnsctvo_cdgo_tpo_cntrto = 2
And	getdate()  between  inco_vgnca_cbrnza 	  and	 fn_vgnca_cbrnza
and	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto
and	a.cnsctvo_scrsl_ctznte		=	@cnsctvo_scrsl

If  @Cantidad_Contratos_Pac	=	0
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'La Sucursal no tiene asociado planes Complementarios'
		Return -1
	end	





*/

	
Set	@cnsctvo_cdgo_tpo_aplccn_nta	=	@lnTipoAplicacion	-- tipo de aplicacion , aplicar ahora  o   aplicar proximo periodo
Set	@lnProcesoExitoso		=	0
Set	@Valor_Porcentaje_Iva		=	0

-- trae el valor del porcentaje  para aplicar
Select 	@Valor_Porcentaje_Iva		=	prcntje
From	bdcarteraPac.dbo.tbconceptosliquidacion_vigencias
where   cnsctvo_cdgo_cncpto_lqdcn	=	3
And	@ldFechaEvaluarPeriodo  between inco_vgnca	and 	fn_vgnca

If  @Valor_Porcentaje_Iva	=	0
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'No existe parametrizacion de iva para procesar'
		Return -1
	end	


IF	@lnTipoAplicacion	=	1		-- si para aplicar ahora
	Begin
		Set	@Valor_Porcentaje_Iva		=	@lnValorIvaEstadoCuenta

		Select   @lnValorTotalNota 	= 	sum(convert(numeric(12,0), (valor * 100))    / convert(numeric(12,0), (100 + @Valor_Porcentaje_Iva ))) ,
			@Valor_iva_nota	=	sum(convert(numeric(12,0), (valor * @Valor_Porcentaje_Iva)) /  convert(numeric(12,0), (100 + @Valor_Porcentaje_Iva )))
		From	#TMPcontratosresponsable
		Where	valor	>	0

	End
Else
	Begin
		Set 	@Valor_iva_nota		=	((@lnValorTotalNota	*	@Valor_Porcentaje_Iva) 	/	100)
	End

-- se calcula el saldo de la nota valor de la nota  mas el valor del iva de la nota
Set 	@Valor_saldo_nota		=	@lnValorTotalNota	+	@Valor_iva_nota
Set	@lnValorInicialSaldoNota	=	@Valor_saldo_nota


/*
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
select	 @lnConsecutivoCodigoPeriodoLiquidacion	 =	 cnsctvo_cdgo_prdo_lqdcn  
from	  bdcarteraPac.dbo.tbperiodosliquidacion_vigencias
Where	 convert(varchar(10),@ldFechaEvaluarPeriodo,111) 	
	between convert(varchar(10),fcha_incl_prdo_lqdcn,111)       and
	convert(varchar(10),fcha_fnl_prdo_lqdcn,111) -- que sea el siguiente del periodo a evaluar
and  	 @ldFechaSistema 	   	between  inco_vgnca   		and      fn_vgnca
and  	  cnsctvo_cdgo_estdo_prdo	=	2	-- estado del periodo abierto

*/

Set @lnConsecutivoCodigoPeriodoLiquidacion = @cnsctvo_cdgo_prdo_lqdcn

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
				cnsctvo_scrsl,		cnsctvo_cdgo_clse_aprtnte, fcha_prdo_nta)
			Values
				(@nmro_nta,		@lcTipoNota,			@lnValorTotalNota,
				@Valor_iva_nota,	@lnValorInicialSaldoNota,	@lnConsecutivoCodigoPeriodoLiquidacion,					
				@ldFechaSistema,	@cnsctvo_cdgo_estdo_nta,	@cnsctvo_cdgo_tpo_aplccn_nta,
				@lcObservaciones,	@lcUsuario,			@nmro_unco_idntfccn_empldr,
				@cnsctvo_scrsl,		@cnsctvo_cdgo_clse_aprtnte, @ldFechaEvaluarPeriodo)


				If  @@error!=0  
					Begin 
						Set	@lnProcesoExitoso	=	1
						Set	@lcMensaje		=	'Error creando la nota'
						Rollback tran 
						Return -1
					end	

--Se recupera la nota de reintegro y se modifica  Tipo de aplicación, se asigna APLICADA
	if @lcTipoNota = 6 
	begin
	   update TbNotasPac
      
	   set cnsctvo_cdgo_estdo_nta = 4
	   where nmro_nta = @lnNumeroReintegro
	   and   cnsctvo_cdgo_tpo_nta = 3

        -- andres camelo  (illustrato ltda)  22/11/2013)
       -- asociamos la nota rei a la nota reintegro
       INSERT INTO [tbRelacionNotasCreditoReiNotasReintegro]
           ([nmro_nta_ri]
           ,[cnsctvo_cdgo_tpo_nta_ri]
           ,[nmro_nta_rntgro]
           ,[cnsctvo_cdgo_tpo_nta_rntgro]
           ,[rntgro_aplcdo]
           ,[fcha_crcn]
           ,[usro_crcn])
         VALUES
           (@nmro_nta
           ,@lcTipoNota
           ,@lnNumeroReintegro
           ,3
           ,'S'
           ,@ldFechaSistema
           ,@lcUsuario)
    
      -- andres camelo  (illustrato ltda)  08/11/2013)
     update a set a.fcha_ultma_mdfccn = @ldFechaSistema,
                  a.usro_ultma_mdfccn = @lcUsuario
      from  tbnotascontrato a
      inner join tbCuentasContratoReintegro b
      on  (a.cnsctvo_nta_cntrto   =  b.cnsctvo_nta_cntrto)
      where  a.nmro_nta = @lnNumeroReintegro

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
Where	 valor		>	0


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
			Sum(valor)		vlr
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
		convert(numeric(12,3),vlr)	vlr
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
				convert(numeric(12,0), (vlr * 100))    / convert(numeric(12,0), (100 + @Valor_Porcentaje_Iva )) ,
				convert(numeric(12,0), (vlr * @Valor_Porcentaje_Iva)) /  convert(numeric(12,0), (100 + @Valor_Porcentaje_Iva )),
				 0,	--	vlr,  --saldo de la nota
				Null,
				Null,
				Null
		From		#TMPcontratosresponsableFinal

	else

		insert into	 bdcarteraPac.dbo.TbnotasContrato
		Select 		(nmro_rgstro	+	@lnMax_cnsctvo_nta_cntrto),
				nmro_nta,
				cnsctvo_cdgo_tpo_nta,
				 0,
				 cnsctvo_cdgo_tpo_cntrto,
				 nmro_cntrto,
				convert(numeric(12,0), (vlr * 100))    / convert(numeric(12,0), (100 + @Valor_Porcentaje_Iva )) ,
				convert(numeric(12,0), (vlr * @Valor_Porcentaje_Iva)) /  convert(numeric(12,0), (100 + @Valor_Porcentaje_Iva )),
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
		a.Valor,
		0	Cnsctvo_nta_cncpto,
		cnsctvo_cdgo_cncpto_lqdcn
	From	#TMPcontratosresponsable a inner join	bdcarteraPac.dbo.TbnotasContrato b
		on (a.cnsctvo_cdgo_tpo_cntrto		=	b.cnsctvo_cdgo_tpo_cntrto
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


	-- se inserta la informacion de cada contrato y cada concepto
	insert into	bdcarteraPac.dbo.tbnotasContratoxConcepto	
	Select	cnsctvo_nta_cntrto,
		Cnsctvo_nta_cncpto,
		valor,
		0,
		0,
		Null	
	From	#tmpnotasContratoxConcepto

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
						Values	(@nmro_nta,	@lcTipoNota,	@cnsctvo_estdo_cnta,	(@lnValorTotalNota+@Valor_iva_nota),	@ldFechaSistema,@lcUsuario  )

			If  @@error!=0  
				Begin 
					Set	@lnProcesoExitoso	=	1
					Set	@lcMensaje		=	'Error insertando la nota del estado cuenta'
					Rollback tran 
					Return -1
				end	



			-- se disminuye el saldo de los contratos  del estado de cuenta
			Update	bdcarteraPac.dbo.tbestadoscuentacontratos
			Set	sldo	=	a.sldo	-	(b.vlr + b.vlr_iva),		-- se debe de colocar incluido el iva b.vlr
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
			Select		@NuevoSaldoEstadoCuenta	=	sldo_estdo_cnta	-		@Valor_saldo_nota
			From		bdcarteraPac.dbo.tbestadoscuenta
			Where		cnsctvo_estdo_cnta		=	@cnsctvo_estdo_cnta

			Update	bdcarteraPac.dbo.tbestadoscuenta
			Set	sldo_estdo_cnta			=	sldo_estdo_cnta		-		@Valor_saldo_nota
			Where	cnsctvo_estdo_cnta		=	@cnsctvo_estdo_cnta

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
		
					If  @@error!=0  
						Begin 
							Set	@lnProcesoExitoso	=	1
							Set	@lcMensaje		=	'Error Actualizando el  estado del estado de cuenta'
							Rollback tran 
							Return -1
						end	
				End
	
		End	


	IF	 @lntipoDocumento		=	10  --and @lcTipoNota = 2  -- Nota debito
		begin	
		

                        	
			Select     @cnsctvo_nta_aplcda_max	  = 	isnull(max(cnsctvo_nta_aplcda),0) + 1
			From	 bdcarteraPac.dbo.TbNotasAplicadas

			Insert	into	bdcarteraPac.dbo.tbNotasAplicadas	(cnsctvo_nta_aplcda,nmro_nta,cnsctvo_cdgo_tpo_nta,nmro_nta_aplcda,
								cnsctvo_cdgo_tpo_nta_aplcda,vlr_aplcdo,fcha_crcn,usro_crcn)
			Values	(@cnsctvo_nta_aplcda_max, @nmro_nta,	@lcTipoNota,	
				convert(varchar(15),@cnsctvo_estdo_cnta),	1,(@lnValorTotalNota+@Valor_iva_nota),	@ldFechaSistema,@lcUsuario  )

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
				vlr,
				Null
			 From	 #TMPcontratosresponsableFinal


			-- se disminuye el saldo de los contratos  de la nota debito
			Update	bdcarteraPac.dbo.tbnotascontrato
			Set	sldo_nta_cntrto		=	a.sldo_nta_cntrto - tmpNotaCredito.vlr ,
				fcha_ultma_mdfccn	=	@ldFechaSistema,
				usro_ultma_mdfccn	=	@lcUsuario
			From	bdcarteraPac.dbo.tbnotascontrato	a,	(Select 	 cnsctvo_estdo_cnta_cntrto 		   cnsctvo_nta_cntrto,
								vlr
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
			Select	@NuevoSaldoEstadoCuenta	=	sldo_nta	-		@Valor_saldo_nota
			From	bdcarteraPac.dbo.tbnotasPac
			Where	ltrim(rtrim(nmro_nta))		=	ltrim(rtrim(convert(varchar(15),@cnsctvo_estdo_cnta)))
			And	cnsctvo_cdgo_tpo_nta		=	1


			Update	bdcarteraPac.dbo.tbnotasPac
			Set	sldo_nta			=	sldo_nta		-		@Valor_saldo_nota
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
			Set	cnsctvo_cdgo_estdo_nta	=	case when 	sldo_nta		<=	0 then  3 else 2 end
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
		@cnsctvo_cdgo_estdo_nta,	@lnValorTotalNota,	@Valor_iva_nota,
		@Valor_saldo_nota,		@ldFechaSistema,	@lcUsuario)
		


	If  @@error!=0  
					Begin 
						Set	@lnProcesoExitoso	=	1
						Set	@lcMensaje		=	'Error insertando historico del estado de  la nota'
						Rollback tran 
						Return -1
					end	
	
-- Se actualiza informacion DIAN
select @lnTipo   = ec.cnsctvo_cdgo_tpo_dcmnto
from tbNotasPAC np inner join tbNotasEstadoCuenta b
on np.cnsctvo_cdgo_tpo_nta  = b.cnsctvo_cdgo_tpo_nta
and np.nmro_nta  = b.nmro_nta
inner join tbEstadosCuenta ec
on ec.cnsctvo_estdo_cnta = b.cnsctvo_estdo_cnta

-- Si el documento asociado a la nota  es una factura se debe actualizar la informacion DIAN
if @lnTipo = @lnTipoDocumentoFactura
Begin
	exec spCalcularDatosFExNotaPAC @lcTipoNota, @nmro_nta
End
		 
-- Se actualiza el saldo a nivel de contrato

-- se comenta porque la consulta de saldo se realiza directamente de los documentos debito y credito
-- no hay necesidad de verificar los movimientos en esta tabla
/*
if	@lnTipoAplicacion	=	1		-- si el tipo de aplicacion es ahora

	Begin
		--se calcula el maximo  numero 
		Select	@MaximoConsecutivoContrato	 	=	 isnull(max(Cnsctvo_Acmldo_cntrto) ,0)
		From	TbAcumuladosContrato


		Select 	       a.Cnsctvo_Acmldo_cntrto,		a.cnsctvo_cdgo_tpo_cntrto,	a.nmro_cntrto,
		       a.tpo_dcmnto,			a.nmro_dcmnto,
		       a.dbts,				a.crdts,					a.vlr_sldo,
		       a.cntdd_fctrs_mra,			a.fcha_ultmo_pgo,			a.fcha_ultma_fctra,
		       a.fcha_mra,				a.ultma_oprcn,
		       c.cnsctvo_nta_cntrto,			c.vlr,					b.fcha_crcn_nta,
		       b.nmro_unco_idntfccn_empldr, 	
		       b.cnsctvo_scrsl, 
		       b.cnsctvo_cdgo_clse_aprtnte ,
		       IDENTITY(int, 1,1) AS ID_Num	
		Into 	#TmpSaldosContrato
		From   TbAcumuladosContrato	  a,	TbNotasPac		b,		tbNotasContrato	c
		Where 	1 	=	2	


		-- se insertan los registros que contengan contratos para esa nota debito
		Insert	into 	#TmpSaldosContrato
		Select    0,				cnsctvo_cdgo_tpo_cntrto,		nmro_cntrto,
			3, 				a.nmro_nta,					--nota Credito
			0,				(b.vlr + b.vlr_iva),				0,
			0,				Null,					fcha_crcn_nta,
			Null,				0,
			b.cnsctvo_nta_cntrto,		(b.vlr + b.vlr_iva),			fcha_crcn_nta,
		             a.nmro_unco_idntfccn_empldr, 	
		             a.cnsctvo_scrsl, 		--se adiciona la sucursal aportante

		       	a.cnsctvo_cdgo_clse_aprtnte 
	

		From 	tbNotasPac	a,	tbNotasContrato b
		Where 	a.cnsctvo_cdgo_tpo_nta	=	b.cnsctvo_cdgo_tpo_nta
		And	a.nmro_nta		=	b.nmro_nta
		And	a.cnsctvo_cdgo_tpo_nta	=	@lcTipoNota
		And	a.nmro_nta		=	@nmro_nta




		Update #TmpSaldosContrato
		Set	Cnsctvo_Acmldo_cntrto		=	a.Cnsctvo_Acmldo_cntrto,
			cntdd_fctrs_mra			=	a.cntdd_fctrs_mra,
			fcha_ultmo_pgo			=	a.fcha_ultmo_pgo,
			fcha_ultma_fctra			=	a.fcha_ultma_fctra,
			fcha_mra			=	a.fcha_mra,
			vlr_sldo				=	a.vlr_sldo
		From	TbAcumuladosContrato		a,	#TmpSaldosContrato	b
		Where	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And	a.nmro_cntrto			=	b.nmro_cntrto
		And	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr ---se adiciona la sucursal aportante
		And	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl
		And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
		And	a.ultma_oprcn			=	1	

		Update	TbAcumuladosContrato
		Set		ultma_oprcn		=	0
		From	TbAcumuladosContrato	a,	#TmpSaldosContrato	b
		Where	a.Cnsctvo_Acmldo_cntrto		=	b.Cnsctvo_Acmldo_cntrto



		Insert	into	TbAcumuladosContrato
		Select	(ID_Num	+	@MaximoConsecutivoContrato),		3,				nmro_dcmnto,      -- nota credito
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
			

		-- fin de actualizar el saldo  a nivel de contrato

		--Actualiza el saldo del responsable del pago
		Select	@MaximoConsecutivoResponsable 	=	 isnull(max(cnsctvo_acmldo_scrsl_aprtnte) ,0)
		From	TbAcumuladosSucursalAportante




		-- Se crea una tabla temporal que va contener los responsables del pago
		Select 	       a.cnsctvo_acmldo_scrsl_aprtnte,	a.nmro_unco_idntfccn_empldr,	a.cnsctvo_scrsl,
			       a.cnsctvo_cdgo_clse_aprtnte,	a.tpo_dcmnto,			a.nmro_dcmnto,
			       a.dbts,				a.crdts,				a.vlr_sldo,
			       a.intrs_mra,
			       a.cntdd_fctrs_mra,			a.fcha_ultmo_pgo,		a.fcha_ultma_fctra,
			       a.fcha_mra,				a.ultma_oprcn,
			       convert(int,b.nmro_nta)  nmro_nta,				b.sldo_nta,	b.fcha_crcn_nta,
			       IDENTITY(int, 1,1) AS ID_Num	
		Into 	#TmpSaldosResponsable
		From   TbAcumuladosSucursalAportante  a,	TbNotasPac	b
		Where 	1 	=	2	


		-- se inserta en la tabla tempora la informacion del resposable  que tiene aociado la nota
		Insert	into 	#TmpSaldosResponsable
		Select  0,				nmro_unco_idntfccn_empldr,	cnsctvo_scrsl,
			cnsctvo_cdgo_clse_aprtnte,	3,				nmro_nta,   -- nota credito
			0,				(vlr_nta    +    vlr_iva),				0,

			0,
			0,				Null,				fcha_crcn_nta,
			Null,				0,
			convert(int,nmro_nta) nmro_nta,	(vlr_nta    +    vlr_iva),			fcha_crcn_nta	
		From 	TbNotasPac
		Where 	nmro_nta		=	@nmro_nta
		And	cnsctvo_cdgo_tpo_nta	=	@lcTipoNota
	

		-- se actualiza la informacion de la ultima transacion para no perder los valores anteriores
		Update #TmpSaldosResponsable
		Set	cnsctvo_acmldo_scrsl_aprtnte	=	a.cnsctvo_acmldo_scrsl_aprtnte,
			intrs_mra			=	a.intrs_mra,
			cntdd_fctrs_mra			=	a.cntdd_fctrs_mra,
			fcha_ultma_fctra			=	a.fcha_ultma_fctra,
			fcha_ultmo_pgo			=	a.fcha_ultmo_pgo,
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
			cnsctvo_cdgo_clse_aprtnte,					3,				nmro_dcmnto,   --- Nota Credito
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



	End  




*/


Commit tran
