/*---------------------------------------------------------------------------------
* Metodo o PRG			:  spGestionarDetallesDeCuentaManual
* Desarrollado por		: <\A Ing. Jean Paul Villaquiran Madrigal A\> 
* Descripcion			: <\D Permite crear los contratos, beneficiarios, conceptos de beneficiarios D\>
* Observaciones			: <\O O\>
* Parametros			: <\P P\>
* Variables				: <\VV\>
* Fecha Creacion		: <\FC 2019/04/30 FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM	AM\>
* Descripcion			: <\DM	DM\>
* Nuevos Parametros		: <\PM	PM\>
* Nuevas Variables		: <\VM	VM\>
* Fecha Modificacion	: <\FM FM\>
*---------------------------------------------------------------------------------
* Scritp's de pruebas
*---------------------------------------------------------------------------------
--------------------------------------------------------------------------------*/
CREATE procedure dbo.spGestionarDetallesDeCuentaManual
(
	@nmro_estdo_cnta varchar(15),
	@lcUsuario udtUsuario			
)
as
begin
		set nocount on;
		declare @cnsctvo_cnta_mnls_cntrto	int,
				@ldFechaSistema				datetime = getdate();

		-- Se calcula el mayoy numero del consecutivo de la cuenta manual contrato
		Select	@cnsctvo_cnta_mnls_cntrto = Isnull(Max(cnsctvo_cnta_mnls_cntrto),0)
		From	dbo.tbCuentasManualesContrato
		
		-- se crean los contratos del estado de cuenta
		Insert	Into dbo.tbCuentasManualesContrato
		(
				cnsctvo_cnta_mnls_cntrto,		
				nmro_estdo_cnta,
				cnsctvo_cdgo_tpo_cntrto,		
				nmro_cntrto,
				vlr_cbrdo,				
				sldo,
				cntdd_bnfcrs,				
				cnsctvo_cdgo_pln,
				usro_crcn,				
				fcha_crcn
		)
		Select	
				ID_Num + @cnsctvo_cnta_mnls_cntrto,	
				@nmro_estdo_cnta,
				cnsctvo_cdgo_tpo_cntrto,		
				nmro_cntrto,
				vlr_ttl_cntrto,				
				vlr_ttl_cntrto, --sldo
				cntdd_ttl_bnfcrs,			
				cnsctvo_cdgo_pln,
				@lcUsuario,				
				@ldFechaSistema
		From	#Tmpcontratos

		If @@error!= 0
		Begin
			;throw 51000,'Error Creando los contratos del estado de cuenta',1
		End

		-- se crean los beneficiarios del estado de cuenta manual

		Update		a
		Set			cnsctvo_cnta_mnls_cntrto 	= b.cnsctvo_cnta_mnls_cntrto
		From		#tmpBeneficiarios				a 
		Inner Join	dbo.tbCuentasManualesContrato	b With(NoLock)
			On		a.nmro_cntrto				= b.nmro_cntrto
			And		a.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
		Where		b.nmro_estdo_cnta		= @nmro_estdo_cnta

		-- se inserta la informacion de los beneficiarios

		Insert Into	dbo.tbCuentasManualesBeneficiario
		(
				cnsctvo_cnta_mnls_cntrto,	
				cnsctvo_bnfcro,
				cnsctvo_cdgo_tpo_idntfccn,	
				nmro_idntfccn,
				prmr_aplldo,			
				sgndo_aplldo,
				prmr_Nmbre,			
				sgndo_nmbre,
				vlr,				
				nmro_unco_idntfccn_bnfcro,
				usro_crcn,			
				fcha_crcn
		)
		Select	cnsctvo_cnta_mnls_cntrto,	
				cnsctvo_bnfcro,
				cnsctvo_cdgo_tpo_idntfccn,	
				numero_identificacion,
				primer_apellido,		
				segundo_apellido,
				primer_nombre,			
				segundo_nombre,
				vlr_ttl_bnfcro,			
				nmro_unco_idntfccn_bnfcro,
				@lcUsuario,			
				@ldFechaSistema
		From	#tmpBeneficiarios

		If @@error!= 0
		Begin
			;throw 51000,'Error Creando los beneficiarios contratos del estado de cuenta',1
		End

		-- ahora se crean los conceptos de los beneficiarios
		Update		#tmpBeneficiariosConceptos
		Set			cnsctvo_cnta_mnls_cntrto 	= b.cnsctvo_cnta_mnls_cntrto
		From		#tmpBeneficiariosConceptos		a 
		Inner Join	dbo.tbCuentasManualesContrato	b With(NoLock)
			On		a.nmro_cntrto				= b.nmro_cntrto
			And		a.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
		Where		b.nmro_estdo_cnta		= @nmro_estdo_cnta

		-- se inserta informacion de los concpetos de los beneficiarios
	
		Insert Into	dbo.tbCuentasManualesBeneficiarioxConceptos
		(
				cnsctvo_cnta_mnls_cntrto,	
				cnsctvo_bnfcro,
				cnsctvo_cdgo_cncpto_lqdcn,	
				vlr,
				fcha_crcn,			
				usro_crcn
		)
		Select	cnsctvo_cnta_mnls_cntrto,	
				cnsctvo_bnfcro,
				cnsctvo_cdgo_cncpto_lqdcn,	
				valor,
				@ldFechaSistema,		
				@lcUsuario
		From	#tmpBeneficiariosConceptos
	
		If @@error!= 0
		Begin
			;throw 51000,'Error Creando los conceptos de los beneficiarios  del estado de cuenta',1
		End

		-- Se Crean Todos los conceptos de facturacion de cada plan de cada estado de cuenta
		-- y  ya la tabla temporal 	#Tmpcontratos tiene asociado el consecutivo estado cuenta

		Insert Into #TmpConceptosEstadoCuenta
		(
			nmro_estdo_cnta,	
			cnsctvo_cdgo_cncpto_lqdcn,
			Cantidad,		
			valor_total_concepto
		)
		Select		a.nmro_estdo_cnta,	
					b.cnsctvo_cdgo_cncpto_lqdcn,
					Count(1), 		
					Sum(vlr_ttl_cntrto_sn_iva)
		From		#Tmpcontratos				a 
		Inner Join	#tmpConceptosLiquidacion	b
			On		a.cnsctvo_cdgo_pln	= b.cnsctvo_cdgo_pln
			And		a.Grupo_Conceptos	= b.cnsctvo_cdgo_grpo_lqdcn
		Where		cnsctvo_cdgo_tpo_mvmnto	= 1	-- conceptos de facturacion
		Group By	a.nmro_estdo_cnta, b.cnsctvo_cdgo_cncpto_lqdcn

		Insert Into	#TmpConceptosEstadoCuenta
		(
			nmro_estdo_cnta,	
			cnsctvo_cdgo_cncpto_lqdcn,
			Cantidad,		
			valor_total_concepto
		)
		Select		a.nmro_estdo_cnta, 	
					b.cnsctvo_cdgo_cncpto_lqdcn,
 					0,			
					Sum(vlr_ttl_cntrto - vlr_ttl_cntrto_sn_iva)
		From		#Tmpcontratos a 
		Inner Join	#tmpConceptosLiquidacion b
			On		a.Grupo_Conceptos		= b.cnsctvo_cdgo_grpo_lqdcn
		Where		cnsctvo_cdgo_tpo_mvmnto		= 5	-- Movimientos de  impuestos
		And			b.cnsctvo_cdgo_cncpto_lqdcn	= 3	-- Concecutivo del Conceptos de  iva
		Group By	a.nmro_estdo_cnta, b.cnsctvo_cdgo_cncpto_lqdcn

		-- se insertan los conceptos del estado de cuenta manual

		Insert Into	dbo.tbCuentasManualesConcepto
		(
			nmro_estdo_cnta,	
			cnsctvo_cdgo_cncpto_lqdcn,
			cntdd,			
			vlr,
			sldo,			
			usro_crcn,
			usro_ultma_mdfccn,	
			fcha_crcn,
			fcha_ultma_mdfccn
		)
		Select	@nmro_estdo_cnta,	
				cnsctvo_cdgo_cncpto_lqdcn,
				Cantidad,		
				valor_total_concepto,
				valor_total_concepto,	
				@lcUsuario,
				@lcUsuario,		
				@ldFechaSistema,
				@ldFechaSistema
		From	#TmpConceptosEstadoCuenta

		If @@error!= 0
		Begin
			;throw 51000,'Error insertando conceptos de estado de cuenta manual',1;
		End

		--Se Actualiza el encabezado del estado  de  cuenta
		--Se actualiza el valor de la totalidad de la facturacion del estado de cuenta
		Update	dbo.tbCuentasManuales
		Set		ttl_fctrdo	= acum_total_facturado
		From	dbo.tbCuentasManuales a 
		Inner Join ( Select		a.nmro_estdo_cnta,	Sum(vlr) acum_total_facturado
					From		dbo.tbCuentasManuales a 
					Inner Join	dbo.tbCuentasManualesConcepto b With(Nolock)
						On		a.nmro_estdo_cnta	= b.nmro_estdo_cnta 
					Inner Join	dbo.tbConceptosLiquidacion_Vigencias c With(Nolock)
						On		b.cnsctvo_cdgo_cncpto_lqdcn	= c.cnsctvo_cdgo_cncpto_lqdcn
					Where		c.cnsctvo_cdgo_tpo_mvmnto 	= 	1   -- Total movimientos de facturacion
					And			Datediff(Day,c.inco_vgnca,Getdate())	>= 0
					And			Datediff(Day,Getdate(),c.fn_vgnca)	>= 0
					Group by	a.nmro_estdo_cnta
					) b
			On		a.nmro_estdo_cnta	= b.nmro_estdo_cnta
		Where		a.nmro_estdo_cnta	= @nmro_estdo_cnta

		If @@error!= 0
		Begin
			;throw 51000,'Error actualizando el total facturado',1;
		End

		--Se actualiza el valor del iva del estado de cuenta manual.

		Update		a
		Set			vlr_iva	= vlr
		From   		dbo.tbCuentasManuales			a With(RowLock)
		Inner Join	dbo.tbCuentasManualesConcepto	b With(NoLock)
			On		a.nmro_estdo_cnta 			= b.nmro_estdo_cnta
		Where		b.cnsctvo_cdgo_cncpto_lqdcn	= 3
		And			a.nmro_estdo_cnta			= @nmro_estdo_cnta

		If @@error!= 0
		Begin
			;throw 51000,'Error actualizando el valor del iva',1;
		End

		-- Se Actualiza el valor total apagar y el saldo del estado de cuenta y
		-- el numero de cuotas a  cancelar dependiendo de la periodicidad

		Update	dbo.tbCuentasManuales
		Set		ttl_pgr			= ttl_fctrdo + vlr_iva + sldo_antrr - sldo_fvr,
				sldo_estdo_cnta	= ttl_fctrdo + vlr_iva
		Where	nmro_estdo_cnta	= @nmro_estdo_cnta

		If @@error!= 0
		Begin
			;throw 51000,'Error actualizando el  el total a pagar',1;
		End
End
