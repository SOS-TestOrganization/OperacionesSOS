
/*---------------------------------------------------------------------------------
* Metodo o PRG   :  spTraerDocumentosCreditoXDebito
* Desarrollado por  : <\A Ing. Rolando Simbaqueva Lasso       A\>
* Descripcion   : <\D Este procedimiento lista la notas debito, credito, reintegros e impuestos de un estado de cuenta        D\>
* Observaciones  : <\O               O\>
* Parametros   : <\P             P\>
* Variables   : <\V               V\>
* Fecha Creacion  : <\FC 2003/10/16 
* Sau  Analista  Descripción
* 55938 Fernando Valencia E Se agrega las notas credito de impuestos  
* N.A   Andres Camelo (illustrato ltda)   Se agrega consulta de para las tipo de notas credito REI  31/10/2013  FC\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION    
*----------------------------------------------------------------------------------
* Modificado Por     : <\AM Francisco E. Riaño L. - Qvision S.A AM\>    
* Descripcion        : <\D Ajuste para mostras notas creditoFE D\> 
* Nuevas Variables   : <\VM VM\>    
* Fecha Modificacion : <\FM 2019-08-26 FM\>    
*----------------------------------------------------------------------------------
*/
--exec [spTraerDocumentosCreditoXDebito] 2777526,1,2,1993566,1365073
-- exec [spTraerDocumentosCreditoXDebito] 82550,2,1,0,0,9,800197268

CREATE PROCEDURE [dbo].[spTraerDocumentosCreditoXDebito](
	@cnsctvo_dcmnto					udtConsecutivo	= NULL,
	@cnsctvo_cdgo_tpo_dcmnto		udtConsecutivo	= NULL,
	@NivelAplica					udtConsecutivo	= NULL,    
	@nmro_dcmnto					udtConsecutivo	= NULL,
	@nmro_cntrto					udtNumeroFormulario	= NULL,
	@tipoIdentifiacionEmpleador		int         = NULL,
	@numeroIdentificacionEmpleador	varchar(23) = NULL
)
As    
Begin 
	Set nocount on ;

	Declare @fechaActual					datetime = getdate(),
			@nmro_unco_idntfccn				int,
			@lnTipoDocumentoEstadoCuenta	udtConsecutivo = 1,
			@lnTipoDocumentoNotaDebito		udtConsecutivo = 2,
			@lnTipoDocumentoFactura			udtConsecutivo = 6,
			@lnTipoNotaCredito				udtConsecutivo = 2,
			@lnTipoNotaReintegro			udtConsecutivo = 3,
			@lnTipoNotaCreditoRei			udtConsecutivo = 6,
			@lnTipoNotaCreditoxImpuestos	udtConsecutivo = 4,
			@lnEstadoNotaAplicada			udtConsecutivo = 4,
			@lnEstadoNotaAplicadaParcial	udtConsecutivo = 7,
			@lnEstadoNotaCanceladaParcial	udtConsecutivo = 3,
			@lnEstadoNotaIngresada			udtConsecutivo = 1,
			@lnEstadoNotaAutorizada			udtConsecutivo = 8,
			@lnTipoNotaAplicadaAhora		udtConsecutivo = 1;

	Create table #TiposDocumentosFactura 
	(
		cnsctvo_cdgo_tpo_dcmnto udtConsecutivo
	)

	Insert into #TiposDocumentosFactura (cnsctvo_cdgo_tpo_dcmnto) values (@lnTipoDocumentoEstadoCuenta),(@lnTipoDocumentoFactura);

	-- si la consulta es por responsable de pago consultamos el NUI
	If(@tipoIdentifiacionEmpleador > 0 And @numeroIdentificacionEmpleador != '')
	Begin  	
		Select	@nmro_unco_idntfccn = nmro_unco_idntfccn
		From	bdAfiliacion.dbo.tbVinculados with(nolock)
		Where	cnsctvo_cdgo_tpo_idntfccn = @tipoIdentifiacionEmpleador
		And		nmro_idntfccn             = @numeroIdentificacionEmpleador
	End

	--Se crea la tabla temporal
	Select  space(50)  TPO_DCMTO,
			a.cnsctvo_cdgo_pgo,
			(a.vlr_abno_cta +  a.vlr_abno_iva) valor_abono,
	        convert(varchar(10),fcha_rcdo,111) Fecha_Recaudo,      
			convert(varchar(11),fcha_aplccn,111) fcha_aplccn,  
			usro_aplccn, 
	        b.fcha_crcn,
			usro_crcn
	Into    #tmpPagosNotasCredito
	From	dbo.tbAbonosContrato a with(nolock), dbo.tbPagos b with(nolock)
	Where   1 = 2

	IF @NivelAplica = 2 ----Para consula de saldo por cotizante
	Begin
		-- Documento Estado de cuenta
		IF exists(select top 1 1 from #TiposDocumentosFactura where cnsctvo_cdgo_tpo_dcmnto = @cnsctvo_cdgo_tpo_dcmnto )
		Begin
			Insert into #tmpPagosNotasCredito
			Select		'PAGO          ' TPO_DCMTO, 
						a.cnsctvo_cdgo_pgo , 
						(a.vlr_abno_cta +  a.vlr_abno_iva) valor_abono,
						convert(varchar(10),fcha_rcdo,111) Fecha_Recaudo,
						convert(varchar(10),fcha_aplccn,111), 
						usro_aplccn, 
						b.fcha_crcn, 
						usro_crcn
			From		dbo.tbAbonosContrato a with (nolock)
			Inner Join	dbo.tbPagos b with (nolock)
				On		a.cnsctvo_cdgo_pgo  = b.cnsctvo_cdgo_pgo
			Where		cnsctvo_estdo_cnta_cntrto = @cnsctvo_dcmnto

			Insert into #tmpPagosNotasCredito
			Select		'NOTA CREDITO', 
						convert(int,a.nmro_nta), 
						(a.vlr       +     a.vlr_iva),
						'NO APLICA', 
						convert(varchar(10),fcha_crcn_nta,111), 
						usro_crcn, 
						convert(varchar(10),fcha_crcn_nta,111),
						usro_crcn
			From		dbo.tbnotascontrato a with (nolock) 
			Inner Join	dbo.tbnotasPac b with (nolock)
				On		a.cnsctvo_cdgo_tpo_nta = b.cnsctvo_cdgo_tpo_nta
				And		a.nmro_nta   = b.nmro_nta
			where		a.cnsctvo_cdgo_tpo_nta = @lnTipoNotaCredito
			And			a.cnsctvo_estdo_cnta_cntrto = @cnsctvo_dcmnto
			And			b.cnsctvo_cdgo_estdo_nta in  (@lnEstadoNotaIngresada,@lnEstadoNotaCanceladaParcial,@lnEstadoNotaAplicada,@lnEstadoNotaAplicadaParcial)  

			Insert into #tmpPagosNotasCredito
			Select		'REINTEGRO', 
						convert(int,c.nmro_nta) , 
						(a.vlr_rntgro) ,
						'NO APLICA' , 
						isnull(convert(varchar(10),b.fcha_ultma_mdfccn,111),'NO APLICA') ,
						isnull(b.usro_ultma_mdfccn,'NO APLICA'), 
						convert(varchar(10),C.fcha_crcn_nta,111) ,
						C.usro_crcn 
			From		dbo.tbCuentasContratoReintegro a with (nolock) 
			Inner Join	dbo.tbnotascontrato b with (nolock)
				On		a.cnsctvo_nta_cntrto   =  b.cnsctvo_nta_cntrto
			Inner Join	dbo.tbnotasPac c with (nolock)
				On		b.cnsctvo_cdgo_tpo_nta =  c.cnsctvo_cdgo_tpo_nta
				And		b.nmro_nta   =  c.nmro_nta
			 where      a.vlr_rntgro > 0
			 And		b.cnsctvo_cdgo_tpo_nta =  @lnTipoNotaReintegro
			 And		a.cnsctvo_estdo_cnta_cntrto = @cnsctvo_dcmnto
			 And		c.cnsctvo_cdgo_estdo_nta in (@lnEstadoNotaAplicada,@lnEstadoNotaAutorizada)   
			 And		b.nmro_cntrto  = @nmro_cntrto

			Insert into #tmpPagosNotasCredito ---sau 55938
			Select		'NOTA IMPUESTOS', 
						convert(int,a.nmro_nta), 
						(a.vlr     +     a.vlr_iva),  
						'NO APLICA', 
						convert(varchar(10),fcha_crcn_nta,111), 
						usro_crcn, 
						convert(varchar(10),fcha_crcn_nta,111),
						usro_crcn
			From		dbo.tbnotascontrato a with (nolock) 
			Inner Join	dbo.tbnotasPac b with (nolock)
				On		a.cnsctvo_cdgo_tpo_nta = b.cnsctvo_cdgo_tpo_nta
				And		a.nmro_nta   = b.nmro_nta
			where       a.cnsctvo_cdgo_tpo_nta = 4
			And			a.cnsctvo_estdo_cnta_cntrto = @cnsctvo_dcmnto
			And			b.cnsctvo_cdgo_estdo_nta in  (@lnEstadoNotaAplicada,@lnEstadoNotaAplicadaParcial)    
       
			-- notas RIE para estados de cuenta
			Insert into #tmpPagosNotasCredito
			Select		c.dscrpcn_tpo_nta, 
						convert(int,a.nmro_nta) ,
						b.vlr + b.vlr_iva,  --,(a.vlr_nta + a.vlr_iva ) ,
						'NO APLICA', 
						convert(varchar(10),a.fcha_crcn_nta,111), 
						a.usro_crcn, 
						convert(varchar(10),a.fcha_crcn_nta,111),
						a.usro_crcn 
			From		dbo.tbnotasPac a with (nolock)
			Inner join	dbo.tbnotascontrato b with (nolock)
				On		a.nmro_nta =  b.nmro_nta
			Inner join  dbo.tbtiposnotas_vigencias c with (nolock)
				On		a.cnsctvo_cdgo_tpo_nta = c.cnsctvo_cdgo_tpo_nta
			where		a.vlr_nta    > 0
			And			a.cnsctvo_cdgo_tpo_nta =  @lnTipoNotaCreditoRei
			And			b.cnsctvo_estdo_cnta_cntrto = @cnsctvo_dcmnto
			And			a.cnsctvo_cdgo_estdo_nta in (@lnEstadoNotaAplicada,@lnEstadoNotaAutorizada) 
			And			@fechaActual between c.inco_vgnca And c.fn_vgnca
			And			b.nmro_cntrto  = @nmro_cntrto
		End
		Else
		Begin
			Insert into #tmpPagosNotasCredito
			Select		'PAGO          ' TPO_DCMTO , 
						a.cnsctvo_cdgo_pgo , 
						(a.vlr_nta_cta +  a.vlr_nta_iva) valor_abono,
						convert(varchar(10),fcha_rcdo,111) Fecha_Recaudo,
						convert(varchar(10),fcha_aplccn,111), 
						usro_aplccn , 
						convert(varchar(10),fcha_crcn,111), 
						usro_crcn
			From		dbo.tbabonosNotasContrato a with (nolock)
			Inner Join	dbo.tbPagos b with (nolock)
				On		a.cnsctvo_cdgo_pgo  = b.cnsctvo_cdgo_pgo
			Where		cnsctvo_nta_cntrto  = @cnsctvo_dcmnto

			Insert into #tmpPagosNotasCredito
			Select		'NOTA CREDITO', 
						convert(int,y.nmro_nta), 
						(y.vlr       +     y.vlr_iva),
						'NO APLICA', 
						convert(varchar(11),z.fcha_crcn_nta,111), 
						z.usro_crcn, 
						convert(varchar(10),z.fcha_crcn_nta,111),
						z.usro_crcn
			From		dbo.tbNotasCreditoContratosxNotasDebito x with (nolock) 
			Inner join  dbo.tbNotasContrato y with (nolock)
				On		x.cnsctvo_nta_cntrto_cdto = y.cnsctvo_nta_cntrto
			Inner Join  dbo.tbNotasPac z with (nolock)
				On		z.cnsctvo_cdgo_tpo_nta    = y.cnsctvo_cdgo_tpo_nta
				And     z.nmro_nta          = y.nmro_nta
			Where		z.cnsctvo_cdgo_tpo_nta = @lnTipoNotaCredito
			And			z.cnsctvo_cdgo_estdo_nta in  (@lnEstadoNotaIngresada,@lnEstadoNotaCanceladaParcial,@lnEstadoNotaAplicada,@lnEstadoNotaAplicadaParcial)  
			And			x.cnsctvo_nta_cntrto_dbto  = @cnsctvo_dcmnto
        
			Insert into #tmpPagosNotasCredito ---sau 55938
			Select		'NOTA IMPUESTOS', 
						convert(int,a.nmro_nta), 
						(a.vlr_aplcdo),  
						'NO APLICA', 
						convert(varchar(10),fcha_crcn_nta,111), 
						b.usro_crcn , 
						convert(varchar(10),b.fcha_crcn_nta,111),
						b.usro_crcn
			From		dbo.tbnotasaplicadas a with (nolock)
			Inner Join	dbo.tbnotasPac b with (nolock)
				On		a.cnsctvo_cdgo_tpo_nta = b.cnsctvo_cdgo_tpo_nta
				And		a.nmro_nta   = b.nmro_nta
			where		a.cnsctvo_cdgo_tpo_nta = @lnTipoNotaCreditoxImpuestos
			And			convert(int,a.nmro_nta_aplcda) = @nmro_dcmnto
			And			a.cnsctvo_cdgo_tpo_nta_aplcda = @lnTipoNotaAplicadaAhora 
			And			b.cnsctvo_cdgo_estdo_nta  in  (@lnEstadoNotaAplicada,@lnEstadoNotaAplicadaParcial)  
    
			-- notas RIE para notas debito
			Insert into #tmpPagosNotasCredito
			Select		c.dscrpcn_tpo_nta, 
						convert(int,a.nmro_nta),
						b.vlr + b.vlr_iva,  
						'NO APLICA', 
						convert(varchar(10),a.fcha_crcn_nta,111), 
						a.usro_crcn, 
						convert(varchar(10),a.fcha_crcn_nta,111),
						a.usro_crcn 
			From		dbo.tbnotasPac a with (nolock)
			Inner join	dbo.tbnotascontrato b with (nolock)
				On		a.nmro_nta =  b.nmro_nta
			Inner join	dbo.tbtiposnotas_vigencias c with (nolock)
				On		a.cnsctvo_cdgo_tpo_nta = c.cnsctvo_cdgo_tpo_nta
			INNER JOIN	dbo.tbNotasCreditoContratosxNotasDebito  d with (nolock)
				On		d.cnsctvo_nta_cntrto_cdto = b.cnsctvo_nta_cntrto
			where		a.vlr_nta    > 0
			And			a.cnsctvo_cdgo_tpo_nta =  @lnTipoNotaCreditoRei
			And			a.cnsctvo_cdgo_estdo_nta in (@lnEstadoNotaAplicada,@lnEstadoNotaAutorizada) 
			And			@fechaActual between c.inco_vgnca And c.fn_vgnca   
			And			b.nmro_cntrto  = @nmro_cntrto
			and			d.cnsctvo_nta_cntrto_dbto = @cnsctvo_dcmnto

			Insert into #tmpPagosNotasCredito
			Select		'REINTEGRO', 
						convert(int,c.nmro_nta), 
						(a.vlr_rntgro),
						'NO APLICA' , 
						isnull(convert(varchar(10),b.fcha_ultma_mdfccn,111),'NO APLICA') ,
						isnull(b.usro_ultma_mdfccn,'NO APLICA'), 
						convert(varchar(10),C.fcha_crcn_nta,111),
						C.usro_crcn 
			From		dbo.tbCuentasContratoReintegro a with (nolock) 
			Inner Join	dbo.tbnotascontrato b with (nolock)
				On		a.cnsctvo_nta_cntrto   =  b.cnsctvo_nta_cntrto
			Inner Join	dbo.tbnotasPac c with (nolock)
				On		b.cnsctvo_cdgo_tpo_nta =  c.cnsctvo_cdgo_tpo_nta
				And		b.nmro_nta   =  c.nmro_nta
			where		a.vlr_rntgro > 0
			And			b.cnsctvo_cdgo_tpo_nta =  @lnTipoNotaReintegro
			And			a.cnsctvo_estdo_cnta_cntrto = @cnsctvo_dcmnto
			And			c.cnsctvo_cdgo_estdo_nta in (@lnEstadoNotaAplicada,@lnEstadoNotaAutorizada)   
			And			b.nmro_cntrto  = @nmro_cntrto

		End
	End
	Else ----Nivel que aplica 2
	Begin
		-- Documento Estado de cuenta
		IF exists(select top 1 1 from #TiposDocumentosFactura where cnsctvo_cdgo_tpo_dcmnto = @cnsctvo_cdgo_tpo_dcmnto )
		Begin
			Insert into #tmpPagosNotasCredito
			Select		'PAGO          ' TPO_DCMTO , 
						a.cnsctvo_cdgo_pgo , 
						a.vlr_abno  valor_abono,
						convert(varchar(10),fcha_rcdo,111) Fecha_Recaudo,
						convert(varchar(10),b.fcha_aplccn,111), 
						b.usro_aplccn, 
						convert(varchar(10),b.fcha_crcn,111), 
						b.usro_crcn
			From		dbo.tbAbonos a with (nolock) 
			Inner Join  dbo.tbPagos b with (nolock)
				On		a.cnsctvo_cdgo_pgo  = b.cnsctvo_cdgo_pgo
			Where		cnsctvo_estdo_cnta  = @cnsctvo_dcmnto
 
			Insert into #tmpPagosNotasCredito
			Select		'NOTA CREDITO', 
						convert(int,a.nmro_nta) , 
						a.vlr ,
						'NO APLICA' , 
						convert(varchar(10),b.fcha_crcn_nta,111) , 
						b.usro_crcn , 
						convert(varchar(10),b.fcha_crcn_nta,111) ,
						b.usro_crcn
			From		dbo.tbnotasestadocuenta  a with (nolock) 
			Inner Join	dbo.tbnotasPac b with (nolock)
				On		a.cnsctvo_cdgo_tpo_nta = b.cnsctvo_cdgo_tpo_nta
				And		a.nmro_nta   = b.nmro_nta
			where		a.cnsctvo_cdgo_tpo_nta = @lnTipoNotaCredito
			And			a.cnsctvo_estdo_cnta  = @cnsctvo_dcmnto
			And			b.cnsctvo_cdgo_estdo_nta in  (@lnEstadoNotaIngresada,@lnEstadoNotaCanceladaParcial,@lnEstadoNotaAplicada,@lnEstadoNotaAplicadaParcial)  

			Insert into #tmpPagosNotasCredito ---sau 55938
			Select		'NOTA IMPUESTOS', 
						convert(int,a.nmro_nta) , 
						(a.vlr),  		   
						'NO APLICA' , 
						convert(varchar(10),fcha_crcn_nta,111) , 
						usro_crcn , 
						fcha_crcn_nta ,
						usro_crcn
			From		dbo.tbnotasestadocuenta a with (nolock) 
			Inner Join	dbo.tbnotasPac b with (nolock)
				On		a.cnsctvo_cdgo_tpo_nta = b.cnsctvo_cdgo_tpo_nta
				And		a.nmro_nta   = b.nmro_nta
			where		a.cnsctvo_cdgo_tpo_nta = @lnTipoNotaCreditoxImpuestos
			And			a.cnsctvo_estdo_cnta  = @cnsctvo_dcmnto
			And			b.cnsctvo_cdgo_estdo_nta in  (@lnEstadoNotaAplicada,@lnEstadoNotaAplicadaParcial) 

			-- notas Reintegro
			Insert into #tmpPagosNotasCredito 
			Select		e.dscrpcn_tpo_nta, 
						convert(int,d.nmro_nta) ,
						sum(a.vlr_rntgro) ,--sum(a.vlr_rntgro), 
						'NO APLICA' , 
						isnull(convert(varchar(10),c.fcha_ultma_mdfccn,111),'NO APLICA') ,
						isnull(c.usro_ultma_mdfccn,'NO APLICA'), 
						convert(varchar(10),d.fcha_crcn_nta,111) ,
						d.usro_crcn 
			From		dbo.tbCuentasContratoReintegro  a with (nolock)
			Inner join	dbo.tbestadoscuentacontratos b with (nolock)
				On		a.cnsctvo_estdo_cnta_cntrto = b.cnsctvo_estdo_cnta_cntrto  
			Inner join	dbo.tbnotascontrato c with (nolock)
				On		a.cnsctvo_nta_cntrto = c.cnsctvo_nta_cntrto
				And		b.nmro_cntrto = c.nmro_cntrto
			Inner join	dbo.tbnotasPac d with (nolock)
				On		(c.nmro_nta             = d.nmro_nta
				And		c.cnsctvo_cdgo_tpo_nta = d.cnsctvo_cdgo_tpo_nta)  
			Inner join	dbo.tbtiposnotas_vigencias e with (nolock)
				On		(e.cnsctvo_cdgo_tpo_nta = d.cnsctvo_cdgo_tpo_nta)
			Inner join	#TiposDocumentosFactura tdf 
				On		a.cnsctvo_cdgo_tpo_dcmnto = tdf.cnsctvo_cdgo_tpo_dcmnto
			where		b.cnsctvo_estdo_cnta = @cnsctvo_dcmnto -- consecutivo estado cuenta
			--and		a.cnsctvo_cdgo_tpo_dcmnto = 1 -- estadocuenta
			And			d.nmro_unco_idntfccn_empldr =@nmro_unco_idntfccn
			And			d.cnsctvo_cdgo_tpo_nta = @lnTipoNotaReintegro
			And			d.cnsctvo_cdgo_estdo_nta in (@lnEstadoNotaAplicada,@lnEstadoNotaAutorizada) 
			group  by	e.dscrpcn_tpo_nta ,d.nmro_nta,c.fcha_ultma_mdfccn,c.usro_ultma_mdfccn,d.fcha_crcn_nta ,d.usro_crcn

			-- notas credito REI
			Insert into #tmpPagosNotasCredito
			Select		c.dscrpcn_tpo_nta,
						convert(int,a.nmro_nta),
						sum(b.vlr)+ sum(b.vlr_iva), --,(a.vlr_nta + a.vlr_iva ) ,
						'NO APLICA' ,
						convert(varchar(10),a.fcha_crcn_nta,111),
						a.usro_crcn, 
						convert(varchar(10),a.fcha_crcn_nta,111),
						a.usro_crcn
			From		dbo.tbnotasPac a with (nolock)
			Inner join	dbo.tbnotascontrato b with (nolock)
				On		(a.nmro_nta = b.nmro_nta)
			Inner join	dbo.tbtiposnotas_vigencias c with (nolock)
				On		(a.cnsctvo_cdgo_tpo_nta = c.cnsctvo_cdgo_tpo_nta)
			INNER JOIN	dbo.tbestadosCuenta e with (nolock)
				On		(e.nmro_unco_idntfccn_empldr = a.nmro_unco_idntfccn_empldr)
			Inner join	dbo.tbnotasestadocuenta ne with (nolock)
			    On		e.cnsctvo_estdo_cnta   = ne.cnsctvo_estdo_cnta
				and		a.nmro_nta             = ne.nmro_nta 
			    and		a.cnsctvo_cdgo_tpo_nta = ne.cnsctvo_cdgo_tpo_nta
			where		a.vlr_nta   > 0
			And			a.cnsctvo_cdgo_tpo_nta= @lnTipoNotaCreditoRei
			and			e.cnsctvo_estdo_cnta  =  @cnsctvo_dcmnto
			--			And   b.cnsctvo_estdo_cnta_cntrto =  @cnsctvo_dcmnto
			And			a.cnsctvo_cdgo_estdo_nta in(@lnEstadoNotaAplicada,@lnEstadoNotaAutorizada)
			And			@fechaActual between c.inco_vgnca And c.fn_vgnca
			And			a.nmro_unco_idntfccn_empldr =@nmro_unco_idntfccn
			GROUP BY	c.dscrpcn_tpo_nta,a.nmro_nta,a.fcha_crcn_nta,a.usro_crcn,a.fcha_crcn_nta,a.usro_crcn
			    --and    e.cnsctvo_estdo_cnta = @cnsctvo_dcmnto
		End
		Else
		Begin
			-- se verifica  las notas asociadas a los pagos
			insert into #tmpPagosNotasCredito
			Select		'PAGO          ' TPO_DCMTO , 
						a.cnsctvo_cdgo_pgo , 
						a.vlr   valor_abono,
						convert(varchar(10),fcha_rcdo,111) Fecha_Recaudo, 
						convert(varchar(10),b.fcha_aplccn,111), 
						b.usro_aplccn , 
						convert(varchar(10),b.fcha_crcn,111), 
						b.usro_crcn
			From		dbo.tbpagosnotas  a with (nolock) 
			Inner Join	dbo.tbPagos b with (nolock)
				On		a.cnsctvo_cdgo_pgo  = b.cnsctvo_cdgo_pgo
			where		convert(int,nmro_nta)  = @cnsctvo_dcmnto
			and			a.cnsctvo_cdgo_tpo_nta  = 1

			Insert into #tmpPagosNotasCredito
			Select		'NOTA CREDITO', 
						convert(int,a.nmro_nta) , 
						a.vlr_aplcdo ,
						'NO APLICA' , 
						convert(varchar(10),fcha_crcn_nta,111)  , 
						b.usro_crcn , 
						convert(varchar(10),b.fcha_crcn_nta,111) ,
						b.usro_crcn
			From		dbo.tbnotasaplicadas  a with (nolock) 
			Inner Join	dbo.tbnotasPac b with (nolock)
				On		a.cnsctvo_cdgo_tpo_nta  = b.cnsctvo_cdgo_tpo_nta
				And		a.nmro_nta    = b.nmro_nta
			where		a.cnsctvo_cdgo_tpo_nta  = @lnTipoNotaCredito
			And			convert(int,a.nmro_nta_aplcda)  = @cnsctvo_dcmnto
			And			a.cnsctvo_cdgo_tpo_nta_aplcda = @lnTipoNotaAplicadaAhora 
			And			b.cnsctvo_cdgo_estdo_nta  in  (@lnEstadoNotaIngresada,@lnEstadoNotaCanceladaParcial,@lnEstadoNotaAplicada,@lnEstadoNotaAplicadaParcial)
			
			
			Insert into #tmpPagosNotasCredito ---sau 55938
			Select		'NOTA IMPUESTOS', 
						convert(int,a.nmro_nta) , 
						(a.vlr_aplcdo),  
						'NO APLICA' , 
						convert(varchar(10), fcha_crcn_nta,111)  , 
						b.usro_crcn , 
						convert(varchar(10),b.fcha_crcn_nta,111) ,
						b.usro_crcn
			From		dbo.tbnotasaplicadas a with (nolock) 
			Inner Join	dbo.tbnotasPac b with (nolock)
				On		a.cnsctvo_cdgo_tpo_nta = b.cnsctvo_cdgo_tpo_nta
				And		a.nmro_nta   = b.nmro_nta
			where		a.cnsctvo_cdgo_tpo_nta = @lnTipoNotaCreditoxImpuestos
			And			convert(int,a.nmro_nta_aplcda)  = @cnsctvo_dcmnto
			And			a.cnsctvo_cdgo_tpo_nta_aplcda = @lnTipoNotaAplicadaAhora 
			And			b.cnsctvo_cdgo_estdo_nta  in  (@lnEstadoNotaAplicada,@lnEstadoNotaAplicadaParcial) 

			---Consultar notas reintegro
			Insert into #tmpPagosNotasCredito 
			Select		e.dscrpcn_tpo_nta, 
						convert(int,d.nmro_nta) , 
						sum(a.vlr_rntgro) ,
						'NO APLICA' , 
						isnull(convert(varchar(10),c.fcha_ultma_mdfccn,111),'NO APLICA') ,
						isnull(c.usro_ultma_mdfccn,'NO APLICA'), 
						convert(varchar(10),d.fcha_crcn_nta,111) ,
						d.usro_crcn 
   			from		dbo.tbCuentasContratoReintegro  a with (nolock)
			Inner join	dbo.tbnotascontrato b with (nolock)
				On		a.cnsctvo_estdo_cnta_cntrto = b.cnsctvo_nta_cntrto --- Nota Debito
			Inner join	dbo.tbnotascontrato c with (nolock)
				On		a.cnsctvo_nta_cntrto = c.cnsctvo_nta_cntrto
				And		b.nmro_cntrto = c.nmro_cntrto
			Inner join	dbo.tbnotasPac d with (nolock)
				On		(c.nmro_nta             = d.nmro_nta
				And		c.cnsctvo_cdgo_tpo_nta = d.cnsctvo_cdgo_tpo_nta)  
			Inner join	dbo.tbtiposnotas_vigencias e with (nolock)
				On		(e.cnsctvo_cdgo_tpo_nta = d.cnsctvo_cdgo_tpo_nta)
			where		b.nmro_nta = @cnsctvo_dcmnto -- debito
			And			c.cnsctvo_cdgo_tpo_nta    = @lnTipoNotaReintegro
			And			a.cnsctvo_cdgo_tpo_dcmnto = @lnTipoDocumentoNotaDebito 
			And			d.nmro_unco_idntfccn_empldr =@nmro_unco_idntfccn 
			And			d.cnsctvo_cdgo_estdo_nta in (@lnEstadoNotaAplicada,@lnEstadoNotaAutorizada) 
			group  by	e.dscrpcn_tpo_nta ,d.nmro_nta,c.fcha_ultma_mdfccn,c.usro_ultma_mdfccn,d.fcha_crcn_nta ,d.usro_crcn

			-- notas RIE para notas debito
			Insert into #tmpPagosNotasCredito
			Select		c.dscrpcn_tpo_nta, 
						convert(int,a.nmro_nta) , 
						sum(a.vlr_aplcdo) ,
						'NO APLICA' , 
						convert(varchar(10),fcha_crcn_nta,111) , 
						b.usro_crcn , 
						convert(varchar(10),b.fcha_crcn_nta,111) ,
						b.usro_crcn
			From		dbo.tbnotasaplicadas  a with (nolock)
			Inner join	dbo.tbnotasPac b with (nolock)
				On		a.cnsctvo_cdgo_tpo_nta  = b.cnsctvo_cdgo_tpo_nta
				And		a.nmro_nta    = b.nmro_nta
			Inner join	dbo.tbtiposnotas_vigencias c with (nolock)
				On		(a.cnsctvo_cdgo_tpo_nta = c.cnsctvo_cdgo_tpo_nta)
			where		a.cnsctvo_cdgo_tpo_nta  = @lnTipoNotaCreditoRei
			And			convert(int,a.nmro_nta_aplcda)  = @cnsctvo_dcmnto
			And			a.cnsctvo_cdgo_tpo_nta_aplcda = @lnTipoNotaAplicadaAhora 
			And			b.cnsctvo_cdgo_estdo_nta  in  (@lnEstadoNotaAplicada,@lnEstadoNotaAplicadaParcial)
			And			b.nmro_unco_idntfccn_empldr = @nmro_unco_idntfccn   
			group by	c.dscrpcn_tpo_nta, a.nmro_nta, b.fcha_crcn_nta,b.usro_crcn 

			--  notas reintegro notas debito
			insert into #tmpPagosNotasCredito
			Select	distinct d.dscrpcn_tpo_nta, 
							convert(int,b.nmro_nta) , (a.vlr  + a.vlr_iva) ,
							'NO APLICA' , 
							isnull(convert(varchar(11),c.fcha_cmbo_estdo,111),'NO APLICA') as fechaAplicacion,
							isnull(c.usro_cmbo_estdo,'NO APLICA') as usuarioAplicacion, 
							convert(varchar(10),b.fcha_crcn_nta,111) ,
							b.usro_crcn 
			From			dbo.tbRelacionNotasXNotaDebito a with (nolock)
			inner join		dbo.tbnotasPac b with (nolock)
				On			b.nmro_nta             =  a.nmro_nta
				And			b.cnsctvo_cdgo_tpo_nta =  a.cnsctvo_cdgo_tpo_nta
			Left join		dbo.tbEstadosxNota c with (nolock)
				On			b.nmro_nta             =  a.nmro_nta_dbto
				And			b.cnsctvo_cdgo_tpo_nta =  a.cnsctvo_cdgo_tpo_nta
			Inner join		dbo.tbtiposnotas_vigencias d with (nolock)
				On			(d.cnsctvo_cdgo_tpo_nta = b.cnsctvo_cdgo_tpo_nta)
			where			b.vlr_nta      > 0
			And				b.cnsctvo_cdgo_tpo_nta =  @lnTipoNotaReintegro
			And				b.cnsctvo_cdgo_estdo_nta in (@lnEstadoNotaAplicada,@lnEstadoNotaAutorizada) 
			And				a.nmro_nta_dbto = @cnsctvo_dcmnto
    
		End
	End

	Select  * from #tmpPagosNotasCredito

End
