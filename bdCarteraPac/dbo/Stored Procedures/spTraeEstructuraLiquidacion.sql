/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spTraeEstructuraLiquidacion
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento arma y ejecuta la cadena donde se tiene los criterios para seleccionar los promotoresr 	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003/02/10											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  FM\>
*---------------------------------------------------------------------------------*/
CREATE  PROCEDURE spTraeEstructuraLiquidacion
		@lnTipo		int
		 
As

IF 	@lnTipo	=	1  -- trae el estado de cuenta
	BEGIN
	select	cnsctvo_estdo_cnta,
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
		fcha_imprsn
	From	 tbEstadosCuenta
	Where 	 1=2
	END



IF 	@lnTipo	=	2  -- trae los conceptos del estado cuenta
	BEGIN
		select	cnsctvo_estdo_cnta_cncpto,
			cnsctvo_estdo_cnta,
			cnsctvo_cdgo_cncpto_lqdcn,
			vlr_cbrdo,
			sldo,
			cntdd
		From	TbEstadosCuentaConceptos 
		Where 		1=2
	END





IF 	@lnTipo	=	3   -- trae los contratos
	BEGIN
	select	cnsctvo_estdo_cnta_cntrto,
		cnsctvo_estdo_cnta,
		cnsctvo_cdgo_tpo_cntrto,
		nmro_cntrto,
		vlr_cbrdo,
		sldo,
		cntdd_bnfcrs
	From	TbEstadosCuentaContratos
	Where   1 = 2
	END



IF 	@lnTipo	=	4  --traer los beneficiarios
	BEGIN
		Select	cnsctvo_estdo_cnta_cntrto_bnfcro,
			cnsctvo_estdo_cnta_cntrto,
			cnsctvo_bnfcro,
			nmro_unco_idntfccn_bnfcro,
			Vlr
		From 	TbCuentasContratosBeneficiarios
		Where 	1	=	2




    	END
IF 	@lnTipo	=	5  --traer los conceptos de los  beneficiarios
	BEGIN
		Select	cnsctvo_estdo_cnta_cntrto_bnfcro,
			cnsctvo_cdgo_cncpto_lqdcn,
			vlr
		From	TbCuentasBeneficiariosConceptos a
		Where	1	=	 2


    	END