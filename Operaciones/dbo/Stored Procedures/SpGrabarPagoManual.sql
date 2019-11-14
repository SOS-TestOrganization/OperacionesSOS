/*---------------------------------------------------------------------------------
* Metodo o PRG 		:  SpGrabarPagoManual
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento grabar el pago manual								D\>
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
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM Ing. Juan Manuel Victoria AM\>
* Descripcion			: <\DM Se realiza optimización, Se incluyen campos de deducciones e impuestos y aplicacion de conceptos  DM\>
* Nuevos Parametros		: <\PM PM\>
* Nuevas Variables		: <\VM VM\>
* Fecha Modificacion	: <\FM 2019/07/03 FM\>
*---------------------------------------------------------------------------------*/
CREATE    PROCEDURE [dbo].[SpGrabarPagoManual]
	@cnsctvo_cdgo_pgo				udtConsecutivo/*Corresponde al pago o a la nota credito o saldo a favor*/,
	@lnNumero_Unico_Identificacion			udtConsecutivo,
	@lnConsecutivoSucursal				udtConsecutivo,
	@lnClaseAportante				udtConsecutivo,
	@lcUsuario					udtUsuario,
	@ln_cnsctvo_cdgo_tpo_dcmnto udtConsecutivo,
	@lnProcesoExitoso				int		output,
	@lcMensaje					char(200)	output
	
As

begin

Declare


@ldFechaSistema						Datetime,
@MaximoConsecutivoContrato			int,
@MaximoConsecutivoResponsable		int,
@Max_Valor_aplicado					udtValorGrande,
@Porcentaje_Valor_iva				udtValorDecimales,
@ldFechaRecuado						Datetime,
@lnEstado_Pago						udtconsecutivo,
@lnEstadoPagoSinAplicar				udtconsecutivo,
@cnsctvo_hstrco_estdo_pgo			udtconsecutivo,
@SaldoEstadosCuentaDiferente		int,
@SaldoNotasDebito					int,
@lconsecutivoliquidacion			int,
@lcestadoactual						int,
@ln_cnsctvo_cdgo_tpo_nta			udtConsecutivo

SET NOCOUNT ON
Set	@lnProcesoExitoso			=	0
set @ln_cnsctvo_cdgo_tpo_nta = 0
--Se conculta el maximo consecutivo del proceso

if @ln_cnsctvo_cdgo_tpo_dcmnto <> 4
begin
	select @ln_cnsctvo_cdgo_tpo_nta = case when @ln_cnsctvo_cdgo_tpo_dcmnto = 3 then 2 when @ln_cnsctvo_cdgo_tpo_dcmnto = 7 then 7 end
end

Set	@ldFechaSistema		=	Getdate()
Set	@lnEstadoPagoSinAplicar	=	1

--SE calcula la fecha de recaudo del pago
Select	@ldFechaRecuado	=	fcha_rcdo,	@lnEstado_Pago	=	cnsctvo_cdgo_estdo_pgo
From	dbo.TbPagos with(nolock)
Where	cnsctvo_cdgo_pgo	=	@cnsctvo_cdgo_pgo

---------------------------------------------------------------------------
-- Para controlar que no se puedan grabar pagos  mientas se tenga una liquidacion de prueba
select  @lconsecutivoliquidacion= max(cnsctvo_Cdgo_lqdcn) 
from	dbo.tbLiquidaciones with(nolock)

select  @lcestadoactual=cnsctvo_cdgo_estdo_lqdcn 
from dbo.tbLiquidaciones with(nolock)
where cnsctvo_Cdgo_lqdcn=@lconsecutivoliquidacion


if	@lcestadoactual	in (5,6)
	Begin 
	  Set	@lnProcesoExitoso	=	1
	  Set	@lcMensaje		=	'Existe una liquidación de pruebas y no se puede grabar el pago'
	  Return -1
end	

-----------------------------------------------------------------------------


if	@lnEstado_Pago	=	3	--aplicado total
	begin
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='No se puede actualizar el pago su estado no lo permite'
		Return -1
		
	end



Begin Tran 

Select   *
into 	#TMPdocumentosdebitoFinal
From	#TMPdocumentosdebito
Where	vlr_aplcr	>	0

Select  @Max_Valor_aplicado =  sum(vlr_aplcr)
From	#TMPdocumentosdebitoFinal

Update  #TMPdocumentosdebitoFinal
Set	estado_documento		=	case  when  ttl_dcmnto > (vlr_aplcr+vlr_rte_fnte+vlr_rte_ica+vlr_estmplls+vlr_otrs)	then  2  else  3 end
Where 	cnsctvo_cdgo_tpo_dcmnto	in (1,6) -- estados cuenta, Factura

Update  #TMPdocumentosdebitoFinal
Set	estado_documento		=	case  when  ttl_dcmnto > (vlr_aplcr+vlr_rte_fnte+vlr_rte_ica+vlr_estmplls+vlr_otrs)	then  2  else  3 end
Where 	cnsctvo_cdgo_tpo_dcmnto	=	2 --notas debito 


--nuevo  14 julio
Select 	0 saldo, 	nmro_dcto , 0	cnsctvo_estdo_cnta,  ttl_dcmnto
into	#tmpSaldosEstadoCuenta
From	#TMPdocumentosdebitoFinal
where 	cnsctvo_cdgo_tpo_dcmnto		in (1,6)		--estados cuenta, Factura

Update a
Set	cnsctvo_estdo_cnta	=	b.cnsctvo_estdo_cnta
From	#tmpSaldosEstadoCuenta a
inner join dbo.tbestadoscuenta b with(nolock) on ltrim(rtrim(a.nmro_dcto))		=	ltrim(rtrim(b.nmro_estdo_cnta))

update a
Set	saldo = ecc.valor_saldo_Estado_cnta
from	#tmpSaldosEstadoCuenta a
cross apply (Select b.cnsctvo_estdo_cnta , sum(b.sldo) 	valor_saldo_Estado_cnta
			 from dbo.tbestadoscuentacontratos b with(nolock)
			 Where a.cnsctvo_estdo_cnta = b.cnsctvo_estdo_cnta
				   And	b.sldo >	0 
			 Group by b.cnsctvo_estdo_cnta) ecc



Select   @SaldoEstadosCuentaDiferente	=	isnull(count(*),0)
From	#tmpSaldosEstadoCuenta
Where   saldo <> ttl_dcmnto
--	 fin nuevo



/*
--Se valida si el saldo del estado de cuenta cambio
Select   @SaldoEstadosCuentaDiferente	=	isnull(count(*),0)
from	tbestadoscuenta a,  #TMPdocumentosdebitoFinal b
Where  ltrim(rtrim(a.nmro_estdo_cnta))		=	ltrim(rtrim(b.nmro_dcto))
And	cnsctvo_cdgo_tpo_dcmnto		=	1		--estados cuenta
And	a.sldo_estdo_cnta			!=	b.ttl_dcmnto
*/

If  @SaldoEstadosCuentaDiferente >	0
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error Hay Estados de Cuenta que cambio el saldo original'
		Rollback tran 
		Return -1
	end

drop table #tmpSaldosEstadoCuenta

--Se valida si el saldo de la nota debito Cambio

Select 	@SaldoNotasDebito		=	isnull(count(*),0)
From	dbo.TbNotasPac a with(nolock)
inner join #TMPdocumentosdebitoFinal b on ltrim(rtrim(a.nmro_nta))		=	ltrim(rtrim(b.nmro_dcto))
where b.cnsctvo_cdgo_tpo_dcmnto	=	2		--nota debito
And	cnsctvo_cdgo_tpo_nta		=	1                        -- tipos de nota debito	
And	a.sldo_nta			<>	b.ttl_dcmnto


If  @SaldoNotasDebito	 >	0
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error Hay Notas Debito  que cambio el saldo original'
		Rollback tran 
		Return -1
	end




						-- cancelada parcial o cancelada total
--actualiza el estado y el saldo del estado de cuenta
Update a
Set	sldo_estdo_cnta				=	sldo_estdo_cnta - (vlr_aplcr+vlr_rte_fnte+vlr_rte_ica+vlr_estmplls+vlr_otrs),
	cnsctvo_cdgo_estdo_estdo_cnta		=	estado_documento
From	dbo.tbEstadosCuenta a with(nolock)
inner join #TMPdocumentosdebitoFinal b on ltrim(rtrim(a.nmro_estdo_cnta))		=	ltrim(rtrim(b.nmro_dcto))
where	b.cnsctvo_cdgo_tpo_dcmnto	in (1,6)		--estados cuenta, Facturas


--Actualiza el el responable del pago si el pago no tiene en esos momentos  responsable es decir que tiene los 
--campos numero de identificacion, clase aportante y consecutivo de la sucursal igual a cero..
if @ln_cnsctvo_cdgo_tpo_dcmnto = 4 /*Pagos*/
begin
	Update dbo.TbPagos
	Set	nmro_unco_idntfccn_empldr	=	@lnNumero_Unico_Identificacion,
		cnsctvo_scrsl			=	@lnConsecutivoSucursal,
		cnsctvo_cdgo_clse_aprtnte	=	@lnClaseAportante
	Where 	nmro_unco_idntfccn_empldr	=	0
	and	cnsctvo_cdgo_pgo		=	@cnsctvo_cdgo_pgo
			
	If  @@error!=0  
		Begin 
			Set	@lnProcesoExitoso	=	1
			Set	@lcMensaje='Error actualizando el Pago'
			Rollback tran 
			Return -1
		end
 end

--actualizamos  el estado del pago y el saldo del pago
if @ln_cnsctvo_cdgo_tpo_dcmnto = 4 /*Pagos*/
begin
	Update dbo.TbPagos
	Set	cnsctvo_cdgo_estdo_pgo		=	case when  sldo_pgo       =   	@Max_Valor_aplicado then  3  else  2 end,
										--aplicado total o aplicado parcial
		sldo_pgo			=	sldo_pgo		-	@Max_Valor_aplicado,
		fcha_aplccn                                   =	@ldFechaSistema,
		usro_aplccn			=	@lcUsuario
	Where 	cnsctvo_cdgo_pgo		=	@cnsctvo_cdgo_pgo

	If  @@error!=0  
		Begin 
			Set	@lnProcesoExitoso	=	1
			Set	@lcMensaje='Error actualizando el pago'
			Rollback tran 
			Return -1
		end
end
else
begin
	Update dbo.tbNotasPac
	Set	cnsctvo_cdgo_estdo_nta	=	case when  sldo_nta       =   	@Max_Valor_aplicado then 3   else  2 end,
		sldo_nta			=	sldo_nta		-	@Max_Valor_aplicado
	Where 	nmro_nta		=	@cnsctvo_cdgo_pgo
	and cnsctvo_cdgo_tpo_nta = @ln_cnsctvo_cdgo_tpo_nta

	If  @@error!=0  
		Begin 
			Set	@lnProcesoExitoso	=	1
			Set	@lcMensaje='Error actualizando La Nota Credito o Saldo a Favor'
			Rollback tran 
			Return -1
		end
end

if @ln_cnsctvo_cdgo_tpo_dcmnto = 4 /*Pagos*/
begin
--Se calcula  el maximo consecutivo
Select	@cnsctvo_hstrco_estdo_pgo	=	isnull(max(cnsctvo_hstrco_estdo_pgo),0)
From	dbo.TbHistoricoEstadoXPago with(nolock)


INSERT INTO [dbo].[TbHistoricoEstadoXPago]
           ([cnsctvo_hstrco_estdo_pgo]
           ,[cnsctvo_cdgo_estdo_pgo]
           ,[cnsctvo_cdgo_pgo]
           ,[sldo_pgo]
           ,[nmro_unco_idntfccn_empldr]
           ,[cnsctvo_scrsl]
           ,[cnsctvo_cdgo_clse_aprtnte]
           ,[usro_crcn]
           ,[fcha_crcn])
Select	(@cnsctvo_hstrco_estdo_pgo	+	1),
	cnsctvo_cdgo_estdo_pgo,
	cnsctvo_cdgo_pgo,
	sldo_pgo,
	nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte,
	@lcUsuario,
	@ldFechaSistema
From	dbo.tbpagos with(nolock)
Where	cnsctvo_cdgo_pgo	=	@cnsctvo_cdgo_pgo

end

--Actualiza el saldo del documento para notas debito
Update a
Set	 sldo_nta			=	sldo_nta		-	(vlr_aplcr+vlr_rte_fnte+vlr_rte_ica+vlr_estmplls+vlr_otrs),
	 cnsctvo_cdgo_estdo_nta		=	estado_documento
From	dbo.TbNotasPac a with(nolock)
inner join #TMPdocumentosdebitoFinal b on ltrim(rtrim(a.nmro_nta))			=	ltrim(rtrim(b.nmro_dcto))
where b.cnsctvo_cdgo_tpo_dcmnto	=	2		--nota debito
And	cnsctvo_cdgo_tpo_nta		=	1                        -- tipos de nota debito	

If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error actualizando  las notas debito'
		Rollback tran 
		Return -1
	end

---se insertan las notas asociadas a los pagos
if @ln_cnsctvo_cdgo_tpo_dcmnto = 4 /*Pagos*/
begin
	INSERT INTO [dbo].[tbPagosNotas]
			   ([nmro_nta]
			   ,[cnsctvo_cdgo_tpo_nta]
			   ,[cnsctvo_cdgo_pgo]
			   ,[vlr])
 
	Select 		 b.nmro_dcto , 	1 ,	@cnsctvo_cdgo_pgo	,	(vlr_aplcr+vlr_rte_fnte+vlr_rte_ica+vlr_estmplls+vlr_otrs)
	From		#TMPdocumentosdebitoFinal b
	where		 b.cnsctvo_cdgo_tpo_dcmnto 			=	2		-- nota debito

	If  @@error!=0  
		Begin 
			Set	@lnProcesoExitoso	=	1
			Set	@lcMensaje='Error insertantado los pagos de las notas'
			Rollback tran 
			Return -1
		end
end


		
--se debe de actualizar si el saldo  del estado de cuenta

Update 	a
Set	sldo			=	sldo	-	(vlr_aplcr+vlr_rtfnte+vlr_rtica+vlr_estmplls+vlr_otrs) ,
	fcha_ultma_mdfccn	=	@ldFechaSistema,
	usro_ultma_mdfccn	=	@lcUsuario
From	dbo.tbestadoscuentacontratos  a with(nolock)
inner join #TMPContratosXDocumentoFinal  b on a.cnsctvo_estdo_cnta_cntrto	=	b.cnsctvo_dcto 
where tpo_dcmto 			in (1,6)		--estados cuenta, Facturas

If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error actualizando los contratos del estado de cuenta'
		Rollback tran 
		Return -1
	end

-- se debe de actualizar el saldo de la nota de cada contrato
Update 	a
Set	sldo_nta_cntrto		=	sldo_nta_cntrto	-	(vlr_aplcr+vlr_rtfnte+vlr_rtica+vlr_estmplls+vlr_otrs) ,
	fcha_ultma_mdfccn	=	@ldFechaSistema,
	usro_ultma_mdfccn	=	@lcUsuario
From	dbo.tbnotascontrato  a with(nolock)
inner join #TMPContratosXDocumentoFinal  b  on cnsctvo_nta_cntrto		=	b.cnsctvo_dcto 
where	tpo_dcmto 			=	2		-- nota debito
And	cnsctvo_cdgo_tpo_nta		=	1		--tipo de nota debito

If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error actualizando las notas del contrato'
		Rollback tran 
		Return -1
	end


--inserta la informacion de la nota asociada al pago  a nivel de contrato
Select  	a.cnsctvo_nta_cntrto,
	convert(numeric(12,3),(b.vlr_aplcr+b.vlr_rtfnte+b.vlr_rtica+b.vlr_estmplls+b.vlr_otrs))	vlr_aplcr,
	convert(numeric(12,3),a.vlr)	vlr,
	convert(numeric(12,3),a.vlr_iva)	vlr_iva,
	convert(numeric(12,3),0)		porcentaje_iva_nota
into 	#TmpAbonosNotascontrato
From	dbo.tbnotascontrato  a with(nolock)
inner join #TMPContratosXDocumentoFinal  b on cnsctvo_nta_cntrto		=	b.cnsctvo_dcto 
where tpo_dcmto 			=	2		-- nota debito
And	cnsctvo_cdgo_tpo_nta		=	1		--tipo de nota debito

-- se actualiza el valor del iva original creada en las notas
Update 	#TmpAbonosNotascontrato
Set	porcentaje_iva_nota	=	(vlr_iva	/	vlr) 	* 	100


If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error calculando el valor del iva'
		Rollback tran 
		Return -1
	end

if @ln_cnsctvo_cdgo_tpo_dcmnto = 4 /*Pagos*/
begin
	INSERT INTO [dbo].[TbAbonosNotasContrato]
			   ([cnsctvo_cdgo_pgo]
			   ,[cnsctvo_nta_cntrto]
			   ,[vlr_nta_cta]
			   ,[vlr_nta_iva]
			   ,[Pgdo_Cmsn])
	Select	@cnsctvo_cdgo_pgo,	cnsctvo_nta_cntrto,
		(vlr_aplcr * 100) / (100 + porcentaje_iva_nota ),
		(vlr_aplcr * porcentaje_iva_nota) / (100 + porcentaje_iva_nota ),
		'N'
	From	#TmpAbonosNotascontrato


	If  @@error!=0  
		Begin 
			Set	@lnProcesoExitoso	=	1
			Set	@lcMensaje='Error insertando el pago de cada contrato nota'
			Rollback tran 
			Return -1
		end
end
--ahora se hace para los estados de cuenta
--selecciona la informacion de los contratos   del estado de cuenta original

Select      	c.cnsctvo_estdo_cnta,		
		a.cnsctvo_estdo_cnta_cntrto ,
	  	vlr_cbrdo, 
		sum(b.vlr)  valor_iva , 
	 	@cnsctvo_cdgo_pgo   cnsctvo_cdgo_pgo,
		convert(numeric(12,3),0)              porcentaje_valor_iva   
into         #TmpAbonosContratos
From	 #TMPContratosXDocumentoFinal  d
inner join dbo.TbEstadosCuentaContratos c with(nolock) on c.cnsctvo_estdo_cnta_cntrto		=	d.cnsctvo_dcto
inner join dbo.TbCuentasContratosBeneficiarios a with(nolock) on a.cnsctvo_estdo_cnta_cntrto		=	c.cnsctvo_estdo_cnta_cntrto
inner join dbo.TbCuentasBeneficiariosConceptos b with(nolock)  on a.cnsctvo_estdo_cnta_cntrto_bnfcro	=	b.cnsctvo_estdo_cnta_cntrto_bnfcro
where b.cnsctvo_cdgo_cncpto_lqdcn		=	3
and		  d.tpo_dcmto	 			in (1,6)		-- estado de  cuenta, Factura
Group by 	  c.cnsctvo_estdo_cnta,	a.cnsctvo_estdo_cnta_cntrto,	vlr_cbrdo  

If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error creando informacion del contrao'
		Rollback tran 
		Return -1
	end


--se Calcula el porcentaje de iva con base al valor de la cuota
Update 	#TmpAbonosContratos
Set	porcentaje_valor_iva	=	(valor_iva*(100))/(vlr_cbrdo - valor_iva )  


If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error calculando el valor del iva'
		Rollback tran 
		Return -1
	end

-- se calcula el  porcentaje de iva
Select  @Porcentaje_Valor_iva	=	porcentaje_valor_iva
From	#TmpAbonosContratos


Select 	@cnsctvo_cdgo_pgo cnsctvo_cdgo_pgo,	a.cnsctvo_estdo_cnta	cnsctvo_estdo_cnta,	b.vlr_aplcr	vlr_abno, b.vlr_rte_fnte, b.vlr_rte_ica, b.vlr_estmplls, b.vlr_otrs,
	Case		When @ldFechaRecuado > c.fcha_mxma_pgo  and d.cnsctvo_cdgo_prdo_lqdcn < = 162 
					Then 'S' 
				When @ldFechaRecuado > dateadd(dd,1,c.fcha_mxma_pgo) and d.cnsctvo_cdgo_prdo_lqdcn > 162 
					Then 'S' 
				Else 'N' 
	End extmprno
Into		#tmpInsertaAbonos
From	#TMPdocumentosdebitoFinal	b
Inner Join dbo.TbEstadosCuenta a with(nolock) On		ltrim(rtrim(a.nmro_estdo_cnta))		=	ltrim(rtrim(b.nmro_dcto))	
Inner Join dbo.Tbliquidaciones d with(nolock) On		d.cnsctvo_cdgo_lqdcn		=	a.cnsctvo_cdgo_lqdcn
Inner Join dbo.TbPeriodosliquidacion_vigencias	c with(nolock) On		c.cnsctvo_cdgo_prdo_lqdcn	=	d.cnsctvo_cdgo_prdo_lqdcn
where b.cnsctvo_cdgo_tpo_dcmnto	in (1,6)		--estados cuenta, Factura			
				


create table #tmpEstadoCuenta (cnsctvo_estdo_cnta udtConsecutivo)

insert into #tmpEstadoCuenta (cnsctvo_estdo_cnta)
Select		Distinct cnsctvo_estdo_cnta
From		#tmpInsertaAbonos

Select		a.cnsctvo_cdgo_pgo	,a.cnsctvo_estdo_cnta,	a.vlr_abno	,a.extmprno, p.fcha_rcdo
Into		#tmpAbonosEstadoCuenta
From		#tmpEstadoCuenta ec
Inner Join  [dbo].[tbAbonos] a with(nolock) On	a.cnsctvo_estdo_cnta	=ec.cnsctvo_estdo_cnta
inner join  dbo.tbpagos p with(nolock) on p.cnsctvo_cdgo_pgo = a.cnsctvo_cdgo_pgo
Order by 2,5

Select	*,	ROW_NUMBER() OVER(PARTITION BY cnsctvo_estdo_cnta ORDER BY fcha_rcdo )  cont
Into	#tmpAbonosOrdenadosEstadoCuenta
From	#tmpAbonosEstadoCuenta

Update	ia
Set			extmprno	= 'N'
From		#tmpInsertaAbonos ia					
Where		extmprno	=	'S'
And			vlr_abno		<	10000
And			Exists ( Select		1
							From		#tmpAbonosOrdenadosEstadoCuenta a
							Where		a.cnsctvo_estdo_cnta	=	ia.cnsctvo_estdo_cnta
							And			a.cnsctvo_cdgo_pgo	<>	ia.cnsctvo_cdgo_pgo
							And			a.extmprno		=	'N'
							And			a.cont				= 1
							)

-- fin Ajuste 2014-00001-000002492

--se inserta los estados de cuenta asociados al pago
if @ln_cnsctvo_cdgo_tpo_dcmnto = 4 /*Pagos*/
begin
	INSERT INTO [dbo].[tbAbonos]
			   ([cnsctvo_cdgo_pgo]
			   ,[cnsctvo_estdo_cnta]
			   ,[vlr_abno]
			   ,[extmprno]
			   ,[cnsctvo_cdgo_tpo_nta]
			   ,[nmro_nta],
			   cnsctvo_cdgo_tpo_dcmnto)
	Select 	cnsctvo_cdgo_pgo,		cnsctvo_estdo_cnta,	(vlr_abno + vlr_rte_fnte + vlr_rte_ica + vlr_estmplls + vlr_otrs),		extmprno,	Null, null, @ln_cnsctvo_cdgo_tpo_dcmnto
	From	#tmpInsertaAbonos

	If  @@error	!=0  
	Begin 
			Set	@lnProcesoExitoso	=	1
			Set	@lcMensaje='Error insertando la los pagos de cada estado de cuenta'
			Rollback tran 
			Return -1
	End
end
else
begin
	if @ln_cnsctvo_cdgo_tpo_dcmnto in (3,7) /*NC NSF*/
		begin
			INSERT INTO [dbo].[tbAbonos]
					   ([cnsctvo_cdgo_pgo]
					   ,[cnsctvo_estdo_cnta]
					   ,[vlr_abno]
					   ,[extmprno]
					   ,[cnsctvo_cdgo_tpo_nta]
					   ,[nmro_nta],
					   cnsctvo_cdgo_tpo_dcmnto)
			Select 	null,		cnsctvo_estdo_cnta,	(vlr_abno + vlr_rte_fnte + vlr_rte_ica + vlr_estmplls + vlr_otrs),		extmprno,	cnsctvo_cdgo_pgo, @ln_cnsctvo_cdgo_tpo_nta, @ln_cnsctvo_cdgo_tpo_dcmnto
			From	#tmpInsertaAbonos

			If  @@error	!=0  
			Begin 
					Set	@lnProcesoExitoso	=	1
					Set	@lcMensaje='Error insertando la los pagos de cada estado de cuenta'
					Rollback tran 
					Return -1
			End
		end
end

-- ahora se calcula el valor del iva con base al  valor aplicado..
--como el valor aplicado ya contiene el valor del iva entonces hay que calcula el valor 
Update 	a
Set	vlr_cbrdo		=	((b.vlr_aplcr + b.vlr_rtfnte + b.vlr_rtica + b.vlr_estmplls + b.vlr_otrs)  * 100 ) / (100 +  a.porcentaje_valor_iva),
	valor_iva		=	((b.vlr_aplcr + b.vlr_rtfnte + b.vlr_rtica + b.vlr_estmplls + b.vlr_otrs)  * a.porcentaje_valor_iva ) / (100 +  a.porcentaje_valor_iva)
From	#TmpAbonosContratos	a
inner join #TMPContratosXDocumentoFinal  b on a.cnsctvo_estdo_cnta_cntrto		=	b.cnsctvo_dcto  -- estado de cuenta


If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Actualizando el valor el iva'
		Rollback tran 
		Return -1
	end
	
--se inserta la informacion de los abonos de cada contrato 
if @ln_cnsctvo_cdgo_tpo_dcmnto = 4 /*Pagos*/
begin
	INSERT INTO [dbo].[tbAbonosContrato]
			   ([cnsctvo_cdgo_pgo]
			   ,[cnsctvo_estdo_cnta_cntrto]
			   ,[vlr_abno_cta]
			   ,[vlr_abno_iva]
			   ,[Pgdo_Cmsn]
			   ,[vlr_abno_rtfnte]
			   ,[vlr_abno_rtca]
			   ,[vlr_abno_estmpllas]
			   ,[vlr_abno_otrs]
			   ,[cnsctvo_abno]
			   ,[fcha_crcn])
	  Select 	a.cnsctvo_cdgo_pgo,
		cnsctvo_estdo_cnta_cntrto,
		a.vlr_cbrdo,
		a.valor_iva,
		'N',
		b.vlr_rtfnte,
		b.vlr_rtica,
		b.vlr_estmplls,
		b.vlr_otrs,
		c.[cnsctvo_abno],
		@ldFechaSistema
	From	#TmpAbonosContratos a
	inner join #TMPContratosXDocumentoFinal  b on a.cnsctvo_estdo_cnta_cntrto		=	b.cnsctvo_dcto
	inner join [dbo].[tbAbonos] c with(nolock) on a.cnsctvo_cdgo_pgo = c.cnsctvo_cdgo_pgo
												  and a.cnsctvo_estdo_cnta = c.cnsctvo_estdo_cnta

	If  @@error!=0  
		Begin 
			Set	@lnProcesoExitoso	=	1
			Set	@lcMensaje='Error insertando la informacion de los pagos de los contratos'
			Rollback tran 
			Return -1
		end
end
else
begin
	if @ln_cnsctvo_cdgo_tpo_dcmnto in (3,7) /*NC NSF*/
		begin
				INSERT INTO [dbo].[tbAbonosContrato]
				   ([cnsctvo_cdgo_pgo]
				   ,[cnsctvo_estdo_cnta_cntrto]
				   ,[vlr_abno_cta]
				   ,[vlr_abno_iva]
				   ,[Pgdo_Cmsn]
				   ,[vlr_abno_rtfnte]
				   ,[vlr_abno_rtca]
				   ,[vlr_abno_estmpllas]
				   ,[vlr_abno_otrs]
				   ,[cnsctvo_abno]
				   ,[fcha_crcn])
			  Select 	null,
				cnsctvo_estdo_cnta_cntrto,
				a.vlr_cbrdo,
				a.valor_iva,
				'N',
				b.vlr_rtfnte,
				b.vlr_rtica,
				b.vlr_estmplls,
				b.vlr_otrs,
				c.[cnsctvo_abno],
				@ldFechaSistema
			From	#TmpAbonosContratos a
			inner join #TMPContratosXDocumentoFinal  b on a.cnsctvo_estdo_cnta_cntrto		=	b.cnsctvo_dcto
			inner join [dbo].[tbAbonos] c with(nolock) on a.cnsctvo_cdgo_pgo = c.nmro_nta
														  and a.cnsctvo_estdo_cnta = c.cnsctvo_estdo_cnta
														  and c.cnsctvo_cdgo_tpo_dcmnto = @ln_cnsctvo_cdgo_tpo_dcmnto

			If  @@error!=0  
				Begin 
					Set	@lnProcesoExitoso	=	1
					Set	@lcMensaje='Error insertando la informacion de los pagos de los contratos'
					Rollback tran 
					Return -1
				end
		end
end
--- se crea una tabla temporal que contiene los valores de los saldos
-- porque se pueden cubrir estados de cuenta o  notas debito
Select  	a.cnsctvo_cdgo_pgo,
	a.cnsctvo_estdo_cnta_cntrto,
	a.vlr_cbrdo,
	a.valor_iva,
	b.cnsctvo_cdgo_tpo_cntrto,
	b.nmro_cntrto
into	#tmpSaldosContratosDocumentosDebito
From	#TmpAbonosContratos a
inner join dbo.TbEstadosCuentaContratos b with(nolock) on a.cnsctvo_estdo_cnta_cntrto	=	b.cnsctvo_estdo_cnta_cntrto

If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error insertando los saldos del contrato debito '
		Rollback tran 

		Return -1
	end

--ahora  se insertan las notas debito
Insert	into	#tmpSaldosContratosDocumentosDebito
Select	@cnsctvo_cdgo_pgo,
	a.cnsctvo_nta_cntrto,
	(a.vlr_aplcr * 100) / (100 + a.porcentaje_iva_nota ),
	(a.vlr_aplcr * a.porcentaje_iva_nota) / (100 + a.porcentaje_iva_nota ),
	b.cnsctvo_cdgo_tpo_cntrto,
	b.nmro_cntrto
From	#TmpAbonosNotascontrato a
inner join dbo.tbnotascontrato  b with(nolock) on a.cnsctvo_nta_cntrto		=	b.cnsctvo_nta_cntrto


If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error insertando los saldos del contrato debito '
		Rollback tran 
		Return -1
	end

--Se crea una tabla temporal con el valor total por contrato de todos los estados de cuenta y las notas debito
Select 	cnsctvo_cdgo_pgo ,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	sum(vlr_cbrdo + valor_iva)  total_contrato
into 	#TmpTotalAcumuladoContrato
From	#tmpSaldosContratosDocumentosDebito
Group by cnsctvo_cdgo_pgo ,
	  cnsctvo_cdgo_tpo_cntrto,
	 nmro_cntrto

If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje='Error insertando los saldos del contrato debito '
		Rollback tran 
		Return -1
	end
--se inserta la informacion a nivel del contratos para los doumentos nota debito




--se actualiza el saldo a nivel del contrato 
		--se calcula el maximo  numero 
Select	@MaximoConsecutivoContrato	 	=	 isnull(max(Cnsctvo_Acmldo_cntrto) ,0)
From	dbo.TbAcumuladosContrato with(nolock)

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
From   	dbo.TbAcumuladosContrato	  a with(nolock),	dbo.TbPagos		b with(nolock),		dbo.tbAbonosContrato	c with(nolock)
Where 		1 	=	2	


-- se inserta la infromacion acumulada de los documento debito para que queden en un solo movimiento del saldo
Insert	into 	#TmpSaldosContrato
Select    0,				b.cnsctvo_cdgo_tpo_cntrto,		b.nmro_cntrto,
	4, 				b.cnsctvo_cdgo_pgo,					--PAGOS
	0,				(b.total_contrato) ,			0,
	0,				a.fcha_rcdo,				a.fcha_crcn,
	Null,				0,
	b.cnsctvo_cdgo_pgo,		(total_contrato),				a.fcha_crcn,	
	@lnNumero_Unico_Identificacion, 	
	@lnConsecutivoSucursal, 
	@lnClaseAportante 
From 	dbo.tbPagos		a with(nolock)
inner join #TmpTotalAcumuladoContrato   b    on a.cnsctvo_cdgo_pgo		=	b.cnsctvo_cdgo_pgo



If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error actualizando  el acumulado por contrato'
			Rollback tran 
			Return -1
	end	



Update b
Set	Cnsctvo_Acmldo_cntrto		=	a.Cnsctvo_Acmldo_cntrto,
	cntdd_fctrs_mra			=	a.cntdd_fctrs_mra,
	fcha_ultma_fctra			=	a.fcha_ultma_fctra,
	fcha_mra			=	a.fcha_mra,
	vlr_sldo				=	a.vlr_sldo
From	dbo.TbAcumuladosContrato		a with(nolock)
inner join #TmpSaldosContrato	b on a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto
And	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr 	
And	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte 
where 	a.ultma_oprcn			=	1	

If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error actualizando  el acumulado por contrato'
			Rollback tran 
			Return -1
	end	

Update	a
Set	ultma_oprcn			=	0
From	dbo.TbAcumuladosContrato	a with(nolock)
inner join #TmpSaldosContrato	b on a.Cnsctvo_Acmldo_cntrto		=	b.Cnsctvo_Acmldo_cntrto

If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error actualizando  el acumulado por contrato'
			Rollback tran 
			Return -1
	end	

Insert	into	dbo.TbAcumuladosContrato
Select	(ID_Num	+	@MaximoConsecutivoContrato),		tpo_dcmnto,				nmro_dcmnto,      -- Pago
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
-- Se valida que  nunca se haya aplicado porque si tiene un saldo el pago vuelve y incrementa dos veces el saldo
--y se debe de hacer solo una ves y queda el saldo a  favor.
--If	@lnEstadoPagoSinAplicar	=	@lnEstado_Pago
--	Begin
		Select	@MaximoConsecutivoResponsable 	=	 isnull(max(cnsctvo_acmldo_scrsl_aprtnte) ,0)
		From	dbo.TbAcumuladosSucursalAportante with(nolock)

		-- se crea una tabla temporal que va contener los responsables del pago
		Select 	       a.cnsctvo_acmldo_scrsl_aprtnte,	a.nmro_unco_idntfccn_empldr,	a.cnsctvo_scrsl,
			       a.cnsctvo_cdgo_clse_aprtnte,	a.tpo_dcmnto,			a.nmro_dcmnto,
			       a.dbts,				a.crdts,				a.vlr_sldo,
			       a.intrs_mra,
			       a.cntdd_fctrs_mra,			a.fcha_ultmo_pgo,		a.fcha_ultma_fctra,
			       a.fcha_mra,				a.ultma_oprcn,
			        b.cnsctvo_cdgo_pgo,		b.vlr_dcmnto,			b.fcha_crcn,
			       IDENTITY(int, 1,1) AS ID_Num	
		Into 	#TmpSaldosResponsable
		From   dbo.TbAcumuladosSucursalAportante  a with(nolock), dbo.tbPagos		b with(nolock)
		Where 	1 	=	2	


	
     

		-- se inserta en la tabla tempora la informacion del resposable  que tiene aociado la nota
		Insert	into 	#TmpSaldosResponsable
		Select  0,				@lnNumero_Unico_Identificacion,	@lnConsecutivoSucursal,
			@lnClaseAportante,		4,					a.cnsctvo_cdgo_pgo,   -- pagos
			0,				@Max_Valor_aplicado,			0,
			0,
			0,				a.fcha_rcdo,				@ldFechaSistema,
			Null,				0,
			a.cnsctvo_cdgo_pgo,		a.vlr_dcmnto,				@ldFechaSistema	
		From 	dbo.TbPagos		  a	with(nolock)
		Where 	a.cnsctvo_cdgo_pgo		=	@cnsctvo_cdgo_pgo	

	

		-- se actualiza la informacion de la ultima transacion para no perder los valores anteriores
		Update b
		Set	cnsctvo_acmldo_scrsl_aprtnte	=	a.cnsctvo_acmldo_scrsl_aprtnte,
			intrs_mra			=	a.intrs_mra,
			cntdd_fctrs_mra			=	a.cntdd_fctrs_mra,
			fcha_ultma_fctra			=	a.fcha_ultma_fctra,
			fcha_mra			=	a.fcha_mra,
			vlr_sldo				=	a.vlr_sldo
		From	dbo.TbAcumuladosSucursalAportante	a with(nolock)
		inner join #TmpSaldosResponsable	b on a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
		And	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
		And	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl
		where	a.ultma_oprcn			=	1	

		If  @@error!=0  
			Begin 
				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje		=	'Error actualizando  lel acumulado por responsable'
				Rollback tran 
				Return -1
			end	

		-- se actualiza  la tabla principal para cerrar la ultima transacion
		UPDATE	a
		Set		ultma_oprcn	=	0
		From		dbo.TbAcumuladosSucursalAportante	a with(nolock)
		inner join #TmpSaldosResponsable	b on a.cnsctvo_acmldo_scrsl_aprtnte	=	b.cnsctvo_acmldo_scrsl_aprtnte

		If  @@error!=0  
			Begin 
				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje		=	'Error actualizando  lel acumulado por responsable'
				Rollback tran 
				Return -1
			end	


		-- se crea la ultima trasacion actualizada
		-- para poder tener el ultimo movimiento
		Insert	into	dbo.TbAcumuladosSucursalAportante
		Select	(ID_Num	+	@MaximoConsecutivoResponsable),	nmro_unco_idntfccn_empldr,	cnsctvo_scrsl,
			cnsctvo_cdgo_clse_aprtnte,					tpo_dcmnto,			nmro_dcmnto,   --- pago
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

		If  @@error!=0  
			Begin 
				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje		=	'Error insertando el acumulado del responsable'
				Rollback tran 
				Return -1
			end	

declare @ln_cnsctvo_pgo_cncpto udtConsecutivo

/* se comenta codigo ya uqe no se detrrmino relacion directa entre EC Contrato y el EC Concepto
select @ln_cnsctvo_pgo_cncpto = max([cnsctvo_pgo_cncpto]) from [dbo].[TbPagosConceptos] with(nolock)
INSERT INTO [dbo].[TbPagosConceptos]
           ([cnsctvo_pgo_cncpto]
           ,[cnsctvo_cdgo_cncpto_lqdcn]
           ,[cnsctvo_cdgo_pgo]
           ,[cnsctvo_estdo_cnta_cncpto]
           ,[vlr_pgo]
		   ,[fcha_crcn])
   select 
   ROW_NUMBER() OVER(ORDER BY d.[cnsctvo_cdgo_cncpto_lqdcn] ASC) + @ln_cnsctvo_pgo_cncpto,
   d.[cnsctvo_cdgo_cncpto_lqdcn],
   @cnsctvo_cdgo_pgo,
   d.cnsctvo_estdo_cnta_cncpto,
   sum(a.vlr_aplcr),
   @ldFechaSistema
   from #TMPContratosXDocumentoFinal a
   inner join dbo.tbEstadosCuenta ec with(nolock) on a.nmro_dcmto = ec.nmro_estdo_cnta
   inner join dbo.tbEstadosCuentaContratos ecc with(nolock) on ec.cnsctvo_estdo_cnta = ecc.cnsctvo_estdo_cnta and a.nmro_cntrto = ecc.nmro_cntrto
     inner join dbo.tbEstadosCuentaConceptos d with(nolock) on d.cnsctvo_estdo_cnta = ec.cnsctvo_estdo_cnta
   where d.cnsctvo_cdgo_cncpto_lqdcn <> 3
   group by d.[cnsctvo_cdgo_cncpto_lqdcn], d.cnsctvo_estdo_cnta_cncpto



	If  @@error <> 0  
			Begin 
				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje		=	'Error insertando en PagosConceptos'
				Rollback tran 
				Return -1
			end	
*/

declare @ln_sldo_pgo udtValorGrande, @ln_errr char(1)

if @ln_cnsctvo_cdgo_tpo_dcmnto = 4 /*Pagos*/
begin
select @ln_cnsctvo_pgo_cncpto = max([cnsctvo_pgo_cncpto]) from [dbo].[TbPagosConceptos] with(nolock)
INSERT INTO [dbo].[TbPagosConceptos]
           ([cnsctvo_pgo_cncpto]
           ,[cnsctvo_cdgo_cncpto_lqdcn]
           ,[cnsctvo_cdgo_pgo]
           ,[cnsctvo_estdo_cnta_cncpto]
           ,[vlr_pgo]
		   ,[fcha_crcn])
select ROW_NUMBER() OVER(ORDER BY nmro_dcmto ASC) + @ln_cnsctvo_pgo_cncpto,
   347,
   @cnsctvo_cdgo_pgo,
   null,
	sum(vlr_rtfnte), -- b.vlr_rte_ica + b.vlr_estmplls + b.vlr_otrs),
   @ldFechaSistema
  from #TMPContratosXDocumentoFinal a
  group by nmro_dcmto
  having sum(vlr_rtfnte) > 0
  

  	If  @@error <> 0  
			Begin 
				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje		=	'Error insertando en PagosConceptos'
				Rollback tran 
				Return -1
			end	

  select @ln_cnsctvo_pgo_cncpto = max([cnsctvo_pgo_cncpto]) from [dbo].[TbPagosConceptos] with(nolock)
INSERT INTO [dbo].[TbPagosConceptos]
           ([cnsctvo_pgo_cncpto]
           ,[cnsctvo_cdgo_cncpto_lqdcn]
           ,[cnsctvo_cdgo_pgo]
           ,[cnsctvo_estdo_cnta_cncpto]
           ,[vlr_pgo]
		   ,[fcha_crcn])
select ROW_NUMBER() OVER(ORDER BY nmro_dcmto ASC) + @ln_cnsctvo_pgo_cncpto,
   348,
   @cnsctvo_cdgo_pgo,
   null,
	sum(vlr_rtica), 
   @ldFechaSistema
  from #TMPContratosXDocumentoFinal a
    group by nmro_dcmto
    having sum(vlr_rtica) > 0

  	If  @@error <> 0  
			Begin 
				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje		=	'Error insertando en PagosConceptos'
				Rollback tran 
				Return -1
			end	

  select @ln_cnsctvo_pgo_cncpto = max([cnsctvo_pgo_cncpto]) from [dbo].[TbPagosConceptos] with(nolock)
INSERT INTO [dbo].[TbPagosConceptos]
           ([cnsctvo_pgo_cncpto]
           ,[cnsctvo_cdgo_cncpto_lqdcn]
           ,[cnsctvo_cdgo_pgo]
           ,[cnsctvo_estdo_cnta_cncpto]
           ,[vlr_pgo]
		   ,[fcha_crcn])
select ROW_NUMBER() OVER(ORDER BY nmro_dcmto ASC) + @ln_cnsctvo_pgo_cncpto,
   349,
   @cnsctvo_cdgo_pgo,
   null,
	sum(vlr_estmplls), 
   @ldFechaSistema
  from #TMPContratosXDocumentoFinal a
      group by nmro_dcmto
   having sum(vlr_estmplls) > 0

  	If  @@error <> 0  
			Begin 
				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje		=	'Error insertando en PagosConceptos'
				Rollback tran 
				Return -1
			end	

  select @ln_cnsctvo_pgo_cncpto = max([cnsctvo_pgo_cncpto]) from [dbo].[TbPagosConceptos] with(nolock)
INSERT INTO [dbo].[TbPagosConceptos]
           ([cnsctvo_pgo_cncpto]
           ,[cnsctvo_cdgo_cncpto_lqdcn]
           ,[cnsctvo_cdgo_pgo]
           ,[cnsctvo_estdo_cnta_cncpto]
           ,[vlr_pgo]
		   ,[fcha_crcn])
select ROW_NUMBER() OVER(ORDER BY nmro_dcmto ASC) + @ln_cnsctvo_pgo_cncpto,
   350,
   @cnsctvo_cdgo_pgo,
   null,
	sum(vlr_otrs), 
   @ldFechaSistema
  from #TMPContratosXDocumentoFinal a
      group by nmro_dcmto
  having sum(vlr_otrs) > 0
  
  	If  @@error <> 0  
			Begin 
				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje		=	'Error insertando en PagosConceptos'
				Rollback tran 
				Return -1
			end	


			

			set @ln_errr = '0'

			select @ln_sldo_pgo = sldo_pgo
			From 	dbo.TbPagos		  a	with(nolock)
			Where 	a.cnsctvo_cdgo_pgo		=	@cnsctvo_cdgo_pgo	

			if @ln_sldo_pgo > 0
			begin
				exec BDCarteraPAC.dbo.spGrabarNotaSaldoaFavor @cnsctvo_cdgo_pgo, @ln_sldo_pgo, @ln_cnsctvo_cdgo_tpo_dcmnto, @ln_cnsctvo_cdgo_tpo_nta, @ln_errr
				If  @@error <> 0 or @ln_errr <> '0'
				begin
					rollback tran
					return -1
				end
			end
end
else 
begin
	if @ln_cnsctvo_cdgo_tpo_dcmnto in (3,7)
	begin
		set @ln_errr = '0'
		select @ln_sldo_pgo = sldo_nta
		From 	dbo.tbNotasPac		  a	with(nolock)
		Where 	a.nmro_nta		=	@cnsctvo_cdgo_pgo
		and cnsctvo_cdgo_tpo_nta = @ln_cnsctvo_cdgo_tpo_nta

		if @ln_sldo_pgo > 0
			begin
				exec BDCarteraPAC.dbo.spGrabarNotaSaldoaFavor @cnsctvo_cdgo_pgo, @ln_sldo_pgo, @ln_cnsctvo_cdgo_tpo_dcmnto, @ln_cnsctvo_cdgo_tpo_nta, @ln_errr
				If  @@error <> 0 or @ln_errr <> '0'
				begin
					rollback tran
					return -1
				end
			end
	end
end
--------
Commit tran
--------------------------------------------------------------------------------
end