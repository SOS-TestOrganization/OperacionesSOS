/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spCreaContratosEstadosCuenta
* Desarrollado por		: <\A Ing. ROLANDO SIMBAQUEVA LASSO								A\>
* Descripcion			: <\D Este procedimiento realiza una la creacion de los contratos de  estados de cuenta		  	D\>
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

CREATE PROCEDURE [dbo].[spCreaContratosEstadosCuenta]
(
	@cnsctvo_cdgo_lqdcn		udtconsecutivo,
	@lcControlaError		int Output	
)
As 
Begin	
	Set Nocount On;

	Declare		@lnMaximoConsecutivoContratoEstadoCuenta	udtConsecutivo


               
	Select	@lnMaximoConsecutivoContratoEstadoCuenta = isnull(max(cnsctvo_estdo_cnta_cntrto) ,0)
	From	dbo.TbEstadosCuentaContratos


	Update	#Tmpcontratos
	Set		cnsctvo_estdo_cnta	=	b.cnsctvo_estdo_cnta
	From	#Tmpcontratos	a,  dbo.tbEstadosCuenta b
	Where	a.nmro_unco_idntfccn_aprtnte	=	b.nmro_unco_idntfccn_empldr
	And	a.cnsctvo_cdgo_clse_aprtnte			=	b.cnsctvo_cdgo_clse_aprtnte
	And	a.cnsctvo_scrsl_ctznte				=	b.cnsctvo_scrsl
	And	b.cnsctvo_cdgo_lqdcn				=	@cnsctvo_cdgo_lqdcn
	And a.nmro_unco_idntfccn_aprtnte not in (select nmro_unco_idntfccn_empldr  
												from #tmpResponsablesPorPlan )

	Update	#Tmpcontratos
	Set		cnsctvo_estdo_cnta	=	b.cnsctvo_estdo_cnta
	From	#Tmpcontratos	a,  dbo.tbEstadosCuenta b
	Where	a.nmro_unco_idntfccn_aprtnte	=	b.nmro_unco_idntfccn_empldr
	And		a.cnsctvo_cdgo_clse_aprtnte		=	b.cnsctvo_cdgo_clse_aprtnte
	And		a.cnsctvo_scrsl_ctznte			=	b.cnsctvo_scrsl
	And		a.cnsctvo_cdgo_pln				= b.dgto_chqo
	And		b.cnsctvo_cdgo_lqdcn			=	@cnsctvo_cdgo_lqdcn
	And		a.nmro_unco_idntfccn_aprtnte  in (select nmro_unco_idntfccn_empldr  
												from #tmpResponsablesPorPlan )


	Insert into	dbo.TbEstadosCuentaContratos
	(
		cnsctvo_estdo_cnta_cntrto,
		cnsctvo_estdo_cnta,
		cnsctvo_cdgo_tpo_cntrto,
		nmro_cntrto,
		vlr_cbrdo,
		sldo,
		sldo_fvr,
		cntdd_bnfcrs,
		fcha_ultma_mdfccn,
		usro_ultma_mdfccn
	)
	Select 		
			ID_Num +  @lnMaximoConsecutivoContratoEstadoCuenta ,
			cnsctvo_estdo_cnta,
			cnsctvo_cdgo_tpo_cntrto,
			nmro_cntrto,
			vlr_ttl_cntrto , -- vlr_cbrdo
			vlr_ttl_cntrto, --sldo
			0,		--Sldo_fvr  del contrato
			cntdd_ttl_bnfcrs , --cntdd_bnfcrs
			Null,
			Null
	From	 	#Tmpcontratos

	If  @@error!=0  
	Begin 
		Set	@lcControlaError	=	1
		Return -1
	end

End