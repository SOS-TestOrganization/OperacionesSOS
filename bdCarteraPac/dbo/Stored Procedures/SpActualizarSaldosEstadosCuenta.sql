
/*---------------------------------------------------------------------------------
* Metodo o PRG		:  SpActualizarSaldosEstadosCuenta
* Desarrollado por	: <\A Francisco Eduardo Riaño L - Qvision S.A			A\> 
* Descripcion		: <\D Permite realizar la actualizacion de los saldos de estado de cuentas D\>
* Observaciones		: <\O	O\>
* Parametros		: <\P 	P\>
* Variables			: <\V	V\>
* Fecha Creacion	: <\FC 30/04/2019	FC\>
*
*--------------------------------------------------------------------------------- 
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM   AM\>
* Descripcion			: <\DM   DM\>
* Nuevos Parametros		: <\PM   PM\>
* Nuevas Variables		: <\VM   VM\>
* Fecha Modificacion	: <\FM   FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[SpActualizarSaldosEstadosCuenta]
(
	@Anterior_cnsctvo_cdgo_lqdcn	int,
	@cnsctvo_cdgo_lqdcn				udtconsecutivo,
	@lnEstadoLiquidacionActual		int
)
AS
Begin

	Set Nocount On;

	Insert Into #tmpContratosInicialesSaldoAFavor
	Select		a.cnsctvo_estdo_cnta_cntrto,
				a.cnsctvo_estdo_cnta,
				a.cnsctvo_cdgo_tpo_cntrto,
				a.nmro_cntrto,
				a.vlr_cbrdo,
				a.sldo,
				a.cntdd_bnfcrs,
				nmro_unco_idntfccn_empldr, 
				cnsctvo_scrsl, 
				cnsctvo_cdgo_clse_aprtnte, 
				Sldo_estdo_cnta
	From  		dbo.tbestadoscuentacontratos	a With(NoLock)
	Inner Join	dbo.tbestadoscuenta				b With(NoLock)
		On		(a.cnsctvo_estdo_cnta = b.cnsctvo_estdo_cnta)
	Where 		sldo < 0
	And			cnsctvo_cdgo_lqdcn = @Anterior_cnsctvo_cdgo_lqdcn

	--Fuente original
	Insert Into #tmpContratosAprocesarSF
	Select		b.Cnsctvo_estdo_cnta, 
				b.cnsctvo_estdo_cnta_cntrto, 
				b.sldo, 
				0		cnsctvo_cdgo_pgo,
				convert(numeric(12,0),0)	vlr_abno_cta,
				convert(numeric(12,0),0)	vlr_abno_iva,
				convert(numeric(12,0),0)	vlr_abno,
				convert(numeric(12,0),0)	vlr_abno_nvo,
				b.Sldo_estdo_cnta,
				b.cnsctvo_cdgo_tpo_cntrto,	
				b.nmro_cntrto,
				b.nmro_unco_idntfccn_empldr, 
				b.cnsctvo_scrsl, 
				b.cnsctvo_cdgo_clse_aprtnte,
				convert(numeric(12,0),0)	vlr_abno_cta_nvo,
				convert(numeric(12,0),0)	vlr_abno_iva_nvo,
				0	Actualizar,
				0	ok1,
				'N'	Pgdo_Cmsn,
				0 inconsistencia
	From		#tmpContratosInicialesSaldoAFavor  b

	Insert Into #tmpEstadosCuentaCon
	Select 		Cnsctvo_estdo_cnta,
				cnsctvo_estdo_cnta_cntrto
	From		#tmpContratosAprocesarSF
	Group by	Cnsctvo_estdo_cnta, cnsctvo_estdo_cnta_cntrto

	Insert Into #tmpEstadosContratosSaldoA
	Select		a.cnsctvo_cdgo_pgo,	
				b.Cnsctvo_estdo_cnta, 
				0	vlr_abno, 
				convert(datetime,null) fcha_aplccn, 
				0 Activo,
				a.cnsctvo_estdo_cnta_cntrto
	From		dbo.tbabonosContrato	a  With(NoLock)
	Inner Join  #tmpEstadosCuentaCon	b
		On		(a.cnsctvo_estdo_cnta_cntrto	=	b.cnsctvo_estdo_cnta_cntrto)

	Update		b
	Set			fcha_aplccn = a.fcha_aplccn
	From		dbo.tbpagos					a With(NoLock)
	Inner Join  #tmpEstadosContratosSaldoA	b
		On		(a.cnsctvo_cdgo_pgo	=	b.cnsctvo_cdgo_pgo)

	Update		a
	Set			vlr_abno		=	b.vlr_abno
	From		#tmpEstadosContratosSaldoA	a 
	Inner Join	dbo.tbabonos				b With(NoLock)
		On		(a.Cnsctvo_estdo_cnta 	= b.Cnsctvo_estdo_cnta
		And		a.cnsctvo_cdgo_pgo	=	b.cnsctvo_cdgo_pgo)

	Insert Into #tmpPagoMaximo
	Select		Cnsctvo_estdo_cnta, 
				cnsctvo_estdo_cnta_cntrto,
				max(fcha_aplccn) max_fecha
	From  		#tmpEstadosContratosSaldoA
	Group by	Cnsctvo_estdo_cnta, cnsctvo_estdo_cnta_cntrto

	Update		a
	Set			Activo	=	1
	From		#tmpEstadosContratosSaldoA	a 
	Inner Join  #tmpPagoMaximo				b
		On		(a.Cnsctvo_estdo_cnta	=	b.Cnsctvo_estdo_cnta
		And		a.fcha_aplccn		=	max_fecha)

	Insert Into #tmpPagosBuenos
	Select		cnsctvo_cdgo_pgo,
				Cnsctvo_estdo_cnta,
				vlr_abno,
				fcha_aplccn,
				Activo,
				cnsctvo_estdo_cnta_cntrto
	From		#tmpEstadosContratosSaldoA 
	Where		Activo	=	1

	--tabla fuente
	Update		a
	Set			vlr_abno		 =	b.vlr_abno,	
				cnsctvo_cdgo_pgo =	b.cnsctvo_cdgo_pgo,
				ok1				 =	1	
	From		#tmpContratosAprocesarSF	a 
	Inner Join  #tmpPagosBuenos				b
		On		(a.Cnsctvo_estdo_cnta		=	b.Cnsctvo_estdo_cnta
		And		a.cnsctvo_estdo_cnta_cntrto 	= b.cnsctvo_estdo_cnta_cntrto)

	Insert Into #tmpcontratosSaldoAFavor
	Select		cnsctvo_cdgo_tpo_cntrto, 
				nmro_cntrto,
	            nmro_unco_idntfccn_empldr, 
				cnsctvo_scrsl, 
				cnsctvo_cdgo_clse_aprtnte
	From		#tmpContratosAprocesarSF
	where		ok1	=	1
	Group by	cnsctvo_cdgo_tpo_cntrto , nmro_cntrto,
		         nmro_unco_idntfccn_empldr, cnsctvo_scrsl, cnsctvo_cdgo_clse_aprtnte 

	Update		a
	Set			vlr_abno_cta	=	b.vlr_abno_cta,
				vlr_abno_iva	=	b.vlr_abno_iva,
				Pgdo_Cmsn		=	b.Pgdo_Cmsn,
				inconsistencia	=	1
	From		#tmpContratosAprocesarSF	a 
	Inner Join  dbo.tbabonoscontrato		b With(NoLock)
		On		(a.cnsctvo_cdgo_pgo		=	b.cnsctvo_cdgo_pgo
		And		a.cnsctvo_estdo_cnta_cntrto	=	b.cnsctvo_estdo_cnta_cntrto)

	Delete from #tmpContratosAprocesarSF where inconsistencia = 0

	Update 	#tmpContratosAprocesarSF
	Set		vlr_abno_cta_nvo	=	convert( numeric(12,3),(vlr_abno_cta + vlr_abno_iva + sldo)) * convert(numeric(12,3),100) / convert(numeric(12,3),107) ,
			vlr_abno_iva_nvo	=	convert( numeric(12,3),(vlr_abno_cta + vlr_abno_iva + sldo)) * convert(numeric(12,3),7)   / convert(numeric(12,3),107)

	Update 	#tmpContratosAprocesarSF
	Set		vlr_abno_nvo		=	vlr_abno_cta_nvo + vlr_abno_iva_nvo

	--se crea la facturacion definitiva
	Insert into #tmpFacturasDef
	Select		a.nmro_unco_idntfccn_empldr,
				a.cnsctvo_scrsl,
				a.cnsctvo_cdgo_clse_aprtnte,
				b.cnsctvo_cdgo_tpo_cntrto,
				b.nmro_cntrto,
				a.cnsctvo_estdo_cnta
	From 		dbo.Tbestadoscuenta				a With(NoLock)
	Inner Join  dbo.tbestadoscuentaContratos	b With(NoLock)
		On		(a.cnsctvo_estdo_cnta		=	b.cnsctvo_estdo_cnta)
	where 		cnsctvo_cdgo_lqdcn			= 	@cnsctvo_cdgo_lqdcn
	And			cnsctvo_cdgo_estdo_estdo_cnta	in	(1,5)

	Insert Into #tmpcontratosAdescontarSaldo
	Select		cnsctvo_estdo_cnta
	From		#tmpFacturasDef				a 
	Inner Join  #tmpcontratosSaldoAFavor	b
		On		(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto				=	b.nmro_cntrto
		And		a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
		And		a.cnsctvo_scrsl				=	b.cnsctvo_scrsl
		And		a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte)
	Group by	cnsctvo_estdo_cnta

	Insert Into #tmpUltimaFactura
	Select		a.Cnsctvo_estdo_cnta,
				b.cnsctvo_estdo_cnta_cntrto,
				b.vlr_cbrdo,
				b.sldo,
				b.cnsctvo_cdgo_tpo_cntrto,
				b.nmro_cntrto,
				b.sldo	nuevo_saldo,
				0	cnsctvo_cdgo_pgo,
				convert(numeric(12,0),0)	valor_pgo,
				convert(numeric(12,0),0)	vlr_abno_cta_nvo,
				convert(numeric(12,0),0)	vlr_abno_iva_nvo,
				a.nmro_unco_idntfccn_empldr,
				a.cnsctvo_scrsl,
				a.cnsctvo_cdgo_clse_aprtnte,
				0	ok1,
				'N'	Pgdo_Cmsn
	From 		dbo.Tbestadoscuenta				a With(NoLock)
	Inner Join	dbo.tbestadoscuentaContratos	b With(NoLock)
		On		(a.cnsctvo_estdo_cnta			=	b.cnsctvo_estdo_cnta) 
	Inner Join	#tmpcontratosAdescontarSaldo	c
		On		(a.cnsctvo_estdo_cnta			=	c.cnsctvo_estdo_cnta)	
	Where 		cnsctvo_cdgo_lqdcn				=	@cnsctvo_cdgo_lqdcn
	And			cnsctvo_cdgo_estdo_estdo_cnta	in	(1,5)

	Update		a
	Set			nuevo_saldo			=	a.sldo + b.sldo,
				cnsctvo_cdgo_pgo	=	b.cnsctvo_cdgo_pgo,
				valor_pgo			=	(-1) *b.sldo,
				ok1					=	1,
				Pgdo_Cmsn			=	b.Pgdo_Cmsn
	From		#tmpUltimaFactura			a 
	Inner Join	#tmpContratosAprocesarSF	b
		On		(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto				=	b.nmro_cntrto
		And		a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
		And		a.cnsctvo_scrsl				=	b.cnsctvo_scrsl
		And		a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte)
	Where		b.ok1					=	1

	Update		#tmpContratosAprocesarSF
	Set			Actualizar	=	1
	From		#tmpContratosAprocesarSF	a 
	Inner Join	#tmpUltimaFactura			b
		On		(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto				=	b.nmro_cntrto
		And		a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
		And		a.cnsctvo_scrsl				=	b.cnsctvo_scrsl
		And		a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte)
	Where		a.ok1				=	1

	Update 	#tmpUltimaFactura
	Set		vlr_abno_cta_nvo	=	convert(numeric(12,0),convert( numeric(12,3),(valor_pgo)) * convert(numeric(12,3),100) / convert(numeric(12,3),110)) ,
			vlr_abno_iva_nvo	=	convert(numeric(12,0),convert( numeric(12,3),(valor_pgo)) * convert(numeric(12,3),10)   / convert(numeric(12,3),110))

	--Para insertar en tbabonosContrato
	Insert Into #tmpAbonosContrato
	Select		cnsctvo_cdgo_pgo,
				cnsctvo_estdo_cnta_cntrto,
				vlr_abno_cta_nvo,
				vlr_abno_iva_nvo ,
				Pgdo_Cmsn
	From		#tmpUltimaFactura
	Where		ok1		=	1

	--Para insertar en tbAbonos
	Insert Into #tmpAbonos
	Select 		Cnsctvo_estdo_cnta,
				Cnsctvo_cdgo_pgo,
				Sum(vlr_abno_cta_nvo + vlr_abno_iva_nvo) vlr_abno
	From		#tmpUltimaFactura
	Where		ok1	=	1
	Group by	Cnsctvo_estdo_cnta , Cnsctvo_cdgo_pgo

	--actualiza los abonos a nivel de contrato anterior
	Insert Into #tmpActualizacionAbonosContrato
	Select 		cnsctvo_estdo_cnta_cntrto,
	       		cnsctvo_cdgo_pgo,
	       		vlr_abno_cta_nvo,
	       		vlr_abno_iva_nvo	
	From 		#tmpContratosAprocesarSF
	Where		Actualizar	=	1

	Insert Into	#tmpActualizacionAbonos
	Select		cnsctvo_cdgo_pgo,
				cnsctvo_estdo_cnta, 
				sum(vlr_abno_nvo)  vlr_abno_nvo
	From		#tmpContratosAprocesarSF
	Where		Actualizar	=	1
	Group by	cnsctvo_cdgo_pgo, cnsctvo_estdo_cnta

	--se inserta en las tablas
	--Para insertar en tbabonosContrato
	If @lnEstadoLiquidacionActual =  2
	Begin
		Insert Into dbo.tbabonosContrato
		(
			cnsctvo_cdgo_pgo,
			cnsctvo_estdo_cnta_cntrto,
			vlr_abno_cta,
			vlr_abno_iva,
			Pgdo_Cmsn
		)
		Select	cnsctvo_cdgo_pgo,
				cnsctvo_estdo_cnta_cntrto,
				vlr_abno_cta_nvo,
				vlr_abno_iva_nvo, 
				Pgdo_Cmsn
		From	#tmpAbonosContrato

		--Se inserta en tbAbonos
		Insert Into dbo.tbAbonos
		(
			cnsctvo_cdgo_pgo,
			cnsctvo_estdo_cnta,
			vlr_abno,
			extmprno
		)
		Select		cnsctvo_cdgo_pgo,
					Cnsctvo_estdo_cnta,
					vlr_abno,
					'N'
		From		#tmpAbonos
		
		Update		a
		Set			vlr_abno_cta	=	vlr_abno_cta_nvo,
					vlr_abno_iva	=	vlr_abno_iva_nvo
		From		dbo.tbAbonoscontrato			a With(RowLock)
		Inner Join	#tmpActualizacionAbonosContrato b
			On		(a.cnsctvo_estdo_cnta_cntrto	=	b.cnsctvo_estdo_cnta_cntrto
			And		a.cnsctvo_cdgo_pgo	=	b.cnsctvo_cdgo_pgo)

		Insert Into	#tmpActualizacionAbonosFinal
		Select		sum(vlr_abno_cta + vlr_abno_iva) vlr_abno_nvo,
					a.cnsctvo_estdo_cnta,
					a.cnsctvo_cdgo_pgo
		From		#tmpActualizacionAbonos			a 
		Inner Join	dbo.tbestadoscuentaContratos	b With(NoLock)
			On		a.cnsctvo_estdo_cnta		=	b.cnsctvo_estdo_cnta
		Inner Join	dbo.tbabonosContrato			c With(NoLock)
			On		b.cnsctvo_estdo_cnta_cntrto	=	c.cnsctvo_estdo_cnta_cntrto
			And		a.cnsctvo_cdgo_pgo		=	c.cnsctvo_cdgo_pgo    
		Group by a.cnsctvo_estdo_cnta, 	a.cnsctvo_cdgo_pgo

		Update		a
		Set			vlr_abno	=	vlr_abno_nvo
		From		dbo.tbAbonos a With(RowLock)
		Inner Join	#tmpActualizacionAbonosFinal b
			On		(a.cnsctvo_cdgo_pgo	=	b.cnsctvo_cdgo_pgo
			And		a.cnsctvo_estdo_cnta	=	b.cnsctvo_estdo_cnta)
	End

	--Actualiza los contratos de los estados de cuenta anteriores
	Update		a
	Set			sldo		  		=	0
	From		dbo.tbEstadoscuentaContratos	a With(RowLock)
	Inner Join	#tmpContratosAprocesarSF		b
		On		(a.cnsctvo_estdo_cnta		=	b.cnsctvo_estdo_cnta
		And		a.cnsctvo_estdo_cnta_cntrto	=	b.cnsctvo_estdo_cnta_cntrto)
	Where 	   	Actualizar			=	1

	--ojo
	Insert 	Into #tmpFacturasanteriores
	Select		 cnsctvo_estdo_cnta
	From		 #tmpContratosAprocesarSF b
	Where 		 Actualizar			=	1
	Group by	cnsctvo_estdo_cnta

	Insert Into #tmpNuevosSaldosAnteriores
	Select		a.cnsctvo_estdo_cnta,
				sum(sldo) saldo
	From 		#tmpFacturasanteriores		 a 
	Inner Join	dbo.tbEstadoscuentaContratos b With(NoLock)
	 	On		(a.cnsctvo_estdo_cnta	=	b.cnsctvo_estdo_cnta )
	Group by	a.cnsctvo_estdo_cnta

	Update		a
	Set			sldo_estdo_cnta	 	 =	saldo
	From		dbo.TbEstadoscuenta			a With(RowLock)
	Inner Join  #tmpNuevosSaldosAnteriores	b
		On		(a.cnsctvo_estdo_cnta =	b.cnsctvo_estdo_cnta)

	--falta la actualizacion de los datos de la ultima factura
	Update 		a
	Set			sldo	=	nuevo_saldo
	From		dbo.tbEstadoscuentacontratos	a With(RowLock)
	Inner Join	#tmpUltimaFactura				b
		On		(a.Cnsctvo_estdo_cnta		=	b.Cnsctvo_estdo_cnta
		And		a.cnsctvo_estdo_cnta_cntrto	=	b.cnsctvo_estdo_cnta_cntrto)
	Where 		ok1				=	1

	Insert Into #tmpNuevosSaldoEstadoCuenta
	Select		Cnsctvo_estdo_cnta,	
				sum(nuevo_saldo) Saldo
	From		#tmpUltimaFactura 
	Group by	Cnsctvo_estdo_cnta

	Insert Into	#tmpNuevosSaldoEstadoCuentaContrato
	Select		Cnsctvo_estdo_cnta_cntrto,	
				sum(nuevo_saldo) Saldo
	From		#tmpUltimaFactura 
	Group by	Cnsctvo_estdo_cnta_cntrto

	Update		a
	Set			sldo_estdo_cnta	=	Saldo
	From		dbo.tbEstadoscuenta			a With(RowLock)
	Inner Join	#tmpNuevosSaldoEstadoCuenta b
		On		(a.Cnsctvo_estdo_cnta	=	b.Cnsctvo_estdo_cnta)

	----------------------
	--nuevo

	Update		a
	Set			sldo_fvr	=	saldo_favor
	From		dbo.tbEstadoscuenta a With(RowLock) 
	Inner Join ( Select 		a.cnsctvo_estdo_cnta , 
								sum( b.vlr_cbrdo - (case when b.sldo < 0 then 0 else b.sldo end )) saldo_favor
				    From		#tmpNuevosSaldoEstadoCuenta a 
					Inner Join	dbo.tbestadoscuentacontratos b With(NoLock)
						On		a.cnsctvo_estdo_cnta	=	b.cnsctvo_estdo_cnta	
				    Group by a.cnsctvo_estdo_cnta) tmpsaldoFavor
		On 		a.Cnsctvo_estdo_cnta	=	tmpsaldoFavor.Cnsctvo_estdo_cnta

	Update		a
	Set			sldo_fvr	=	saldo_favor
	From		dbo.tbEstadoscuentaContratos a With(RowLock)
	Inner Join	( Select 		a.cnsctvo_estdo_cnta_cntrto, 
								sum( b.vlr_cbrdo - (case when b.sldo < 0 then 0 else b.sldo end )) saldo_favor
				    From		#tmpNuevosSaldoEstadoCuentaContrato a 
					Inner Join	dbo.tbestadoscuentacontratos		b With(NoLock)
						On       a.cnsctvo_estdo_cnta_cntrto	=	b.cnsctvo_estdo_cnta_cntrto	
				    Group by a.cnsctvo_estdo_cnta_cntrto) tmpsaldoFavorContrato
		On 		a.Cnsctvo_estdo_cnta_cntrto	=	tmpsaldoFavorContrato.Cnsctvo_estdo_cnta_cntrto

	Update		a
	Set			ttl_pgr		=	(ttl_fctrdo +   vlr_iva    + sldo_antrr )  - sldo_fvr  
	From		dbo.tbEstadoscuenta			a With(RowLock)
	Inner Join  #tmpNuevosSaldoEstadoCuenta b
		On		(a.Cnsctvo_estdo_cnta	=	b.Cnsctvo_estdo_cnta)

	Update		a
	Set			ttl_pgr			=	0
	From		dbo.tbEstadoscuenta			a With(RowLock)
	Inner Join	#tmpNuevosSaldoEstadoCuenta b
		On		(a.Cnsctvo_estdo_cnta	=	b.Cnsctvo_estdo_cnta)
	Where 		ttl_pgr 	<	0

	Update		a
	Set			cnsctvo_cdgo_estdo_estdo_cnta	=	1 
	From		dbo.tbEstadoscuenta			a With(RowLock) 
	Inner Join	#tmpNuevosSaldoEstadoCuenta b
		On		(a.Cnsctvo_estdo_cnta	=	b.Cnsctvo_estdo_cnta)
	Where 		(ttl_fctrdo +   vlr_iva) 	=	 sldo_estdo_cnta

	Update		a
	Set			cnsctvo_cdgo_estdo_estdo_cnta	=	2 
	From		dbo.tbEstadoscuenta a With(RowLock)
	Inner Join	#tmpNuevosSaldoEstadoCuenta b
		On		(a.Cnsctvo_estdo_cnta	=	b.Cnsctvo_estdo_cnta)
	Where 		(ttl_fctrdo +   vlr_iva   ) > sldo_estdo_cnta
	And			sldo_estdo_cnta >	0

	Update		a
	Set			cnsctvo_cdgo_estdo_estdo_cnta	=	2 
	From		dbo.tbEstadoscuenta			a With(RowLock)
	Inner Join	#tmpNuevosSaldoEstadoCuenta b
		On		(a.Cnsctvo_estdo_cnta	=	b.Cnsctvo_estdo_cnta)
	Where 		(ttl_fctrdo +   vlr_iva   ) > sldo_estdo_cnta
	And			sldo_estdo_cnta 	<=	0
	And			ttl_pgr			>	0

	Update		a
	Set			cnsctvo_cdgo_estdo_estdo_cnta	=	3
	From		dbo.tbEstadoscuenta			a With(RowLock)
	Inner Join	#tmpNuevosSaldoEstadoCuenta b
		On		(a.Cnsctvo_estdo_cnta	=	b.Cnsctvo_estdo_cnta)
	Where 		sldo_estdo_cnta <=	0
	And			ttl_pgr		<=	0

	-- fin nuevo
	-----------------------------
End