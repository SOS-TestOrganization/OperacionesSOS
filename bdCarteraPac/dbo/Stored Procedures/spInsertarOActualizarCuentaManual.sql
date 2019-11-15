/*---------------------------------------------------------------------------------
* Metodo o PRG			:  spInsertarOActualizarCuentaManual
* Desarrollado por		: <\A Ing. Jean Paul Villaquiran Madrigal A\> 
* Descripcion			: <\D Permite inserta y actualizar una cuenta manual D\>
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
CREATE procedure dbo.spInsertarOActualizarCuentaManual
(
	@tipoMovimiento					int,
	@numeroEstadoCuenta				varchar(15),
	@ldFechaInicialFacturacion		datetime,
	@ldFechaFinalFacturacion		datetime,
	@ldFechaLimitePago				datetime,
	@nmro_prds						int,
	@lcUsuario						udtUsuario,
	@cnsctvo_cdgo_prdo				int,
	@lcUsuarioAutorizador			UdtConsecutivo,
	@lnPorcentajeIncremento			UdtValorDecimales,
	@cnsctvo_cdgo_prdo_lqdcn		int,
	@cnsctvo_cdgo_estdo_estdo_cnta	int
)
as
begin
	set nocount on;

	declare		@ldFechaSistema							datetime	= getdate(),
				@consecutivoEstadoDocumentoIngresado	int			= 1;

	If @tipoMovimiento	= 1	-- si es nuevo lo inserta y luego lo actualiza al final
		Begin
			--Se crea el estado de cuenta manual
			Insert	Into dbo.tbCuentasManuales
			(
					nmro_estdo_cnta,		
					fcha_incl_fctrcn,
					fcha_fnl_fctrcn,		
					fcha_lmte_pgo,
					nmro_unco_idntfccn_empldr,	
					cnsctvo_scrsl,
					cnsctvo_cdgo_clse_aprtnte,	
					cnsctvo_cdgo_tpo_idntfccn,
					nmro_idntfccn_rspnsble_pgo,	
					dgto_vrfccn,
					nmbre_empldr,			
					nmbre_scrsl,
					cts_cnclr,			
					cts_sn_cnclr,
					drccn,				
					cnsctvo_cdgo_cdd,
					tlfno,				
					ttl_fctrdo,
					vlr_iva,			
					sldo_fvr,
					sldo_antrr,			
					ttl_pgr,
					fcha_crcn,			
					usro_crcn,
					cnsctvo_cdgo_prdo,		
					cnsctvo_cdgo_autrzdr_espcl,
					prcntje_incrmnto,		
					cnsctvo_cdgo_prdo_lqdcn,
					cnsctvo_cdgo_estdo_estdo_cnta,	
					exste_cntrto,
					sldo_estdo_cnta,		
					usro_ultma_mdfccn,
					fcha_ultma_mdfccn,		
					dgto_chqo,
					cnsctvo_cdgo_estdo_dcmnto_fe
			)
			Select	@numeroEstadoCuenta,		
					@ldFechaInicialFacturacion,
					@ldFechaFinalFacturacion,	
					@ldFechaLimitePago,
					nmro_unco_idntfccn_aprtnte,	
					cnsctvo_scrsl_ctznte,
					cnsctvo_cdgo_clse_aprtnte,	
					cnsctvo_cdgo_tpo_idntfccn,
					nmro_idntfccn_rspnsble_pgo,	
					dgto_vrfccn,
					nmbre_empldr,			
					nmbre_scrsl,
					@nmro_prds,			
					0,
					drccn,				
					cnsctvo_cdgo_cdd,
					tlfno,				
					0,
					0,				
					0,
					0,				
					0,
					@ldFechaSistema,		
					@lcUsuario,
					@cnsctvo_cdgo_prdo,		
					@lcUsuarioAutorizador,
					@lnPorcentajeIncremento,	
					@cnsctvo_cdgo_prdo_lqdcn,
					@cnsctvo_cdgo_estdo_estdo_cnta,	
					'S', -- es porque no existe contrato
					0,				
					@lcUsuario,
					@ldFechaSistema,		
					'0',
					@consecutivoEstadoDocumentoIngresado
			From	#tmpResponsablesPago
	
			If @@error!= 0
			Begin
				;throw 51000,'Error Creando el estado de cuenta',1
			End
		End

		If @tipoMovimiento	= 2	-- se modifica  luego lo actualiza al final
		Begin
			--Se crea el estado de cuenta manual

			Update	dbo.tbCuentasManuales
			Set		fcha_incl_fctrcn			= @ldFechaInicialFacturacion,
					fcha_fnl_fctrcn				= @ldFechaFinalFacturacion,
					fcha_lmte_pgo				= @ldFechaLimitePago,
					nmro_unco_idntfccn_empldr	= b.nmro_unco_idntfccn_aprtnte,
					cnsctvo_scrsl				= b.cnsctvo_scrsl_ctznte,
					cnsctvo_cdgo_clse_aprtnte	= b.cnsctvo_cdgo_clse_aprtnte,
					cnsctvo_cdgo_tpo_idntfccn	= b.cnsctvo_cdgo_tpo_idntfccn,
					nmro_idntfccn_rspnsble_pgo	= b.nmro_idntfccn_rspnsble_pgo,
					dgto_vrfccn					= b.dgto_vrfccn,
					nmbre_empldr				= b.nmbre_empldr,
					nmbre_scrsl					= b.nmbre_scrsl,
					cts_cnclr					= @nmro_prds,
					cts_sn_cnclr				= 0,
					drccn						= b.drccn,
					cnsctvo_cdgo_cdd			= b.cnsctvo_cdgo_cdd,
					tlfno						= b.tlfno,
					ttl_fctrdo					= 0,
					vlr_iva						= 0,
					sldo_fvr					= 0,
					sldo_antrr					= 0,
					ttl_pgr						= 0,
					fcha_ultma_mdfccn			= @ldFechaSistema,
					usro_ultma_mdfccn			= @lcUsuario,
					cnsctvo_cdgo_prdo			= @cnsctvo_cdgo_prdo,
					cnsctvo_cdgo_autrzdr_espcl	= @lcUsuarioAutorizador,
					prcntje_incrmnto			= @lnPorcentajeIncremento,
					cnsctvo_cdgo_prdo_lqdcn		= @cnsctvo_cdgo_prdo_lqdcn,
					sldo_estdo_cnta				= 0
			From	#tmpResponsablesPago b
			Where	nmro_estdo_cnta		= @numeroEstadoCuenta
		
			If @@error!= 0
			Begin
				;throw 51000,'Error Actualizando el estado de cuenta manual',1;
			End
		End
end