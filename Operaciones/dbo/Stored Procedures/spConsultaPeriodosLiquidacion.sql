/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spConsultaPeriodosLiquidacion
* Desarrollado por		: <\A Ing. Julian Fernando Bonilla A.									A\>
* Descripcion			: <\D Este procedimiento consulta los periodos de liquidacion				  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P 													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2013/01/04 											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  	 FM\>
*---------------------------------------------------------------------------------*/
Create PROCEDURE [dbo].[spConsultaPeriodosLiquidacion]
As

Set Nocount On

Declare @fechareferencia datetime
Set @fechareferencia = getdate()

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
Where	 @fechareferencia between inco_vgnca and fn_vgnca
and cnsctvo_cdgo_prdo_lqdcn not in (99999,0)
order by cnsctvo_cdgo_prdo_lqdcn desc