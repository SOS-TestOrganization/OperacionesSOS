/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spTraerPeriodoLiquidacion
* Desarrollado por		: <\A Ing. Rolandosimbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento realiza una busqueda de un periodo de liquidacion				  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P 													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/02 											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  Rolando Simbaqueva LassoAM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  2002/09/10	 FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE spTraerPeriodoLiquidacion
As

Set Nocount On


select	cnsctvo_vgnca_prdo_lqdcn,
	cnsctvo_cdgo_prdo_lqdcn,
	cdgo_prdo_lqdcn,
	dscrpcn_prdo_lqdcn,
	inco_vgnca,
	fn_vgnca,
	fcha_crcn,
	usro_crcn,
	obsrvcns,
	fcha_mxma_pgo,
	fcha_crte,
	fcha_pgo,
	intrss_mra_mnsl,
	cnsctvo_cdgo_estdo_prdo,
	cnsctvo_grpo_lqdcn,
	fcha_incl_prdo_lqdcn,
	fcha_fnl_prdo_lqdcn
From	 tbperiodosliquidacion_vigencias
Where	 cnsctvo_cdgo_estdo_prdo	=	2 --   estado abierto para el periodo de liquidacion