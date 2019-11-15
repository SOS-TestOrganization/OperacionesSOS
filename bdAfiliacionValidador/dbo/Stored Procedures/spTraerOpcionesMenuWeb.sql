
/*---------------------------------------------------------------------------------
* Metodo o PRG 	               : spTraerOpcionesConsultaUnificada
* Desarrollado por		 :  <\A    Ing. Samuel Muñoz										A\>
* Descripcion			 :  <\D   Trae un cursor con los registros de las opciones de los menu WEB.				D\>
* Observaciones		              :  <\O													O\>
* Parametros			 :  <\P   													P\>
* Variables			 :  <\V													V\>
* Fecha Creacion		 :  <\FC  2005/02/09											FC\>
*  
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------  
* Modificado Por		              : <\AM   AM\>
* Descripcion			 : <\DM   DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM   FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[spTraerOpcionesMenuWeb]
@lcCodigoModulo		char(4),
@lcCodigoOpcion		char(20)
As

Set Nocount On


Select	cnsctvo_cdgo_opcn, 	cdgo_opcn, 	dscrpcn_opcn, 
	cmndo, 			estdo,		opcn_admn
From    bdSeguridad..tbOpcionesModulosWeb     
Where   brrdo			= 'N'
And 	cdgo_mdlo		= @lcCodigoModulo
And 	cdgo_opcn_pdre	= @lcCodigoOpcion
Order by ordn

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerOpcionesMenuWeb] TO [Desarrollo]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerOpcionesMenuWeb] TO [webusr]
    AS [dbo];

