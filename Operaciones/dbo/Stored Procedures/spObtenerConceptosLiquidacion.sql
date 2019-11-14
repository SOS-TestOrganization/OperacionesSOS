/*---------------------------------------------------------------------------------
* Metodo o PRG			:  spObtenerConceptosLiquidacion
* Desarrollado por		: <\A Ing. Jean Paul Villaquiran Madrigal A\> 
* Descripcion			: <\D Obtener conceptos de liquidacion D\>
* Observaciones			: <\O O\>
* Parametros			: <\P P\>
* Variables				: <\VV\>
* Fecha Creacion		: <\FC 2019/09/05 FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM	AM\>
* Descripcion			: <\DM	DM\>
* Nuevos Parametros		: <\PM	PM\>
* Nuevas Variables		: <\VM	VM\>
* Fecha Modificacion	: <\FM	FM\>
*---------------------------------------------------------------------------------
* Scritp's de pruebas
*---------------------------------------------------------------------------------
--------------------------------------------------------------------------------*/
CREATE procedure [dbo].spObtenerConceptosLiquidacion
as
begin
	set nocount on;

	select	a.cnsctvo_cdgo_cncpto_lqdcn as cnsctvo_cdgo_cncpto_lqdcn,
			a.dscrpcn_cncpto_lqdcn as dscrpcn_cncpto_lqdcn
	from	BDCarteraPAC.dbo.tbConceptosLiquidacion_Vigencias a with(nolock)
	where	getdate() between a.inco_vgnca and a.fn_vgnca
	and		a.cnsctvo_cdgo_cncpto_lqdcn != 0
	and		a.cnsctvo_cdgo_cncpto_lqdcn != 9999;
end