--------------------

--Adecuaciones para que al crear el estado de cuenta ponga en N en campo impreso

/*---------------------------------------------------------------------------------
* Metodo o PRG 			: spCreaEstadosCuenta
* Desarrollado por		: <\A Ing. ROLANDO SIMBAQUEVA LASSO								A\>
* Descripcion			: <\D Este procedimiento realiza una la creacion de los estados de cuenta				  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P 													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/02 											FC\>
*--------------------------------------------------------------------------------- 
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM Francisco Eduardo Riaño L. - Qvision S.A  AM\>
* Descripcion			: <\DM Ajustes Facturacion Electronica  DM\>
* Nuevos Parametros		: <\PM   PM\>
* Nuevas Variables		: <\VM   VM\>
* Fecha Modificacion	: <\FM 2019-05-08  FM\>
*---------------------------------------------------------------------------------*/

CREATE  PROCEDURE [dbo].[spCreaEstadosCuenta]
(
	@cnsctvo_cdgo_lqdcn		udtconsecutivo,
	@lcUsuarioCreacion		udtUsuario,
	@lcControlaError		int  	output
)	
As 
Begin
	Set Nocount On;
	Declare		@lnMaximoConsecutivoEstadoCuenta		udtConsecutivo,
				@nConsecutivoResolucionDianPac			udtConsecutivo	= 2,
				@nConsecutivoTipoDocumentoFactura		udtConsecutivo	= 6,
				@nConsecutivoEstadoDocumentoIngresado	udtConsecutivo	= 1,
				@vNmroEstadoCuentaPreviaDefault			varchar(15)		= '999';

               
	Select	@lnMaximoConsecutivoEstadoCuenta = isnull(max(cnsctvo_estdo_cnta) ,0)
	From	dbo.tbEstadosCuenta

	Insert into	dbo.tbEstadosCuenta
	(
		cnsctvo_estdo_cnta,
		cnsctvo_cdgo_lqdcn,
		fcha_gnrcn,
		nmro_unco_idntfccn_empldr,
		cnsctvo_scrsl,
		cnsctvo_cdgo_clse_aprtnte,
		ttl_fctrdo,
		vlr_iva,
		sldo_fvr,
		ttl_pgr,
		sldo_estdo_cnta,
		sldo_antrr,
		Cts_Cnclr,
		Cts_sn_Cnclr,
		nmro_estdo_cnta,
		cnsctvo_cdgo_estdo_estdo_cnta,
		usro_crcn,
		Fcha_crcn,
		fcha_imprsn,
		cnsctvo_cdgo_prdcdd_prpgo,
		dgto_chqo,
		imprso,
		usro_imprsn,
		cnsctvo_cdgo_rslcn_dn,
		cnsctvo_cdgo_tpo_dcmnto,
		cnsctvo_cdgo_estdo_dcmnto_fe
	)
	Select 		
			ID_Num +  @lnMaximoConsecutivoEstadoCuenta ,
			@cnsctvo_cdgo_lqdcn,
			getdate(),  --fcha_gnrcn,
			nmro_unco_idntfccn_aprtnte,
			cnsctvo_scrsl_ctznte,
			cnsctvo_cdgo_clse_aprtnte,
			0,--ttl_fctrdo
			0,--vlr_iva
			0,--sldo_fvr
			0,--ttl_pgr
			0,--sldo_estdo_cnta
			sldo_antrr,	--sldo_antrr
			0,--Cts_Cnclr
			Cts_sn_cnclar,	--Cts_sn_Cnclr
			@vNmroEstadoCuentaPreviaDefault,--nmro_estdo_cnta
			1 , --cnsctvo_cdgo_estdo_estdo_cta
			@lcUsuarioCreacion , --usro_crcn
			getdate()	,--Fcha_crcn
			null , --fcha_imprsn
			cnsctvo_cdgo_prdcdd_prpgo,
			'0',		--digito de chequeo
			'N',		--Impreso
			Null,		--Usuario de creacion	
			@nConsecutivoResolucionDianPac,
			@nConsecutivoTipoDocumentoFactura,
			@nConsecutivoEstadoDocumentoIngresado		
	From	#tmpResponsablesPago
	where   nmro_unco_idntfccn_aprtnte  not in (select nmro_unco_idntfccn_empldr  
												from #tmpResponsablesPorPlan )

	Insert into	dbo.tbEstadosCuenta
	(
			cnsctvo_estdo_cnta,
			cnsctvo_cdgo_lqdcn,
			fcha_gnrcn,
			nmro_unco_idntfccn_empldr,
			cnsctvo_scrsl,
			cnsctvo_cdgo_clse_aprtnte,
			ttl_fctrdo,
			vlr_iva,
			sldo_fvr,
			ttl_pgr,
			sldo_estdo_cnta,
			sldo_antrr,
			Cts_Cnclr,
			Cts_sn_Cnclr,
			nmro_estdo_cnta,
			cnsctvo_cdgo_estdo_estdo_cnta,
			usro_crcn,
			Fcha_crcn,
			fcha_imprsn,
			cnsctvo_cdgo_prdcdd_prpgo,
			dgto_chqo,
			imprso,
			usro_imprsn,
			cnsctvo_cdgo_rslcn_dn,
			cnsctvo_cdgo_tpo_dcmnto,
			cnsctvo_cdgo_estdo_dcmnto_fe
	)
	Select 		
			ID_Num +  @lnMaximoConsecutivoEstadoCuenta ,
			@cnsctvo_cdgo_lqdcn,
			getdate(),  --fcha_gnrcn,
			nmro_unco_idntfccn_aprtnte,
			cnsctvo_scrsl_ctznte,
			cnsctvo_cdgo_clse_aprtnte,
			0,--ttl_fctrdo
			0,--vlr_iva
			0,--sldo_fvr
			0,--ttl_pgr
			0,--sldo_estdo_cnta
			sldo_antrr,	--sldo_antrr
			0,--Cts_Cnclr
			Cts_sn_cnclar,	--Cts_sn_Cnclr
			@vNmroEstadoCuentaPreviaDefault,--nmro_estdo_cnta
			1 , --cnsctvo_cdgo_estdo_estdo_cta
			@lcUsuarioCreacion , --usro_crcn
			getdate()	,--Fcha_crcn
			null , --fcha_imprsn
			cnsctvo_cdgo_prdcdd_prpgo,
			cnsctvo_cdgo_pln,		--digito de chequeo , se coloca el plan aqui para el requerimiento de facturacion por plan 
			'N',		--Impreso
			Null,		--Usuario de creacion
			@nConsecutivoResolucionDianPac,
			@nConsecutivoTipoDocumentoFactura,
			@nConsecutivoEstadoDocumentoIngresado		
	From	#tmpResponsablesPago
	where   nmro_unco_idntfccn_aprtnte   in (select nmro_unco_idntfccn_empldr  
											from #tmpResponsablesPorPlan )

	If  @@error!=0  
	Begin 
		Set	@lcControlaError	=	1
		Return -1
	End

End