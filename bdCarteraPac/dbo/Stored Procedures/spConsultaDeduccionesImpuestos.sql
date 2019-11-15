
/*----------------------------------------------------------------------------------------
* Metodo o PRG : spConsultaDeduccionesImpuestos
* Desarrollado por : <\A Ing. Juan Manuel Victoria A\>
* Descripcion  : <\D Sp Consulta Conceptos de Liquidacion de Decciones o Impuestos D\>    
* Observaciones : <\O O\>    
* Parametros  : <\P P\>
* Variables   : <\V V\>
* Fecha Creacion : <\FC 2019/06/13 FC\>
* Ejemplo: 
    <\EJ
        Incluir un ejemplo de invocacion al procedimiento almacenado
        EXEC [spConsultaDeduccionesImpuestos] ...
    EJ\>
*-----------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[spConsultaDeduccionesImpuestos]

as

begin

set nocount on

select cnsctvo_cdgo_cncpto_lqdcn,	cdgo_cncpto_lqdcn,	dscrpcn_cncpto_lqdcn, prcntje_min, prcntje prcntje_max 
-- select *
from bdCarteraPAC.dbo.tbConceptosLiquidacion_vigencias a with(nolock)
where getdate() between inco_vgnca and fn_vgnca
and cnsctvo_cdgo_tpo_mvmnto = 5
and oprcn = 4
and vsble_usro = 'S'
and prcntje > 0

end