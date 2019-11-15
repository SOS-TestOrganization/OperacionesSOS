/*---------------------------------------------------------------------------------------------------------------------------------------
* Procedimiento			: SpValidaNumeroAutorizacion 
* Desarrollado por		: <\A Ing.Julian Hidalgo				A\>
* Descripción			: <\D Consulta Informacion de la ultima validacion por afiliado						D\>
* Observaciones			: <\O									O\>
* Parámetros			: <\P  									P\>
* Variables			    : <\V  									V\>
* Fecha Creación		: <\FC 2016/03/04  						FC\>
*
*---------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------------------------------------------------------------
* Modificado Por		: <\AM Luis Fernando Benavides 												AM\>
* Descripción			: <\DM 1. De acuerdo a solicitud de Lider de proyecto se retira validacion	DM\>
*				          <\DM por usuario que crea autorizacion									DM\>
*				        : <\DM 2. Adiciona codigo oficina en el resultado de la consulta		    DM\>
* Nuevos Parámetros		: <\PM  								PM\>
* Nuevas Variables		: <\VM  								VM\>
* Fecha Modificación	: <\FM 2016/05/07						FM\>
*-----------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------------------------------------------------------------
* Modificado Por		: <\AM Luis Fernando Benavides 												AM\>
* Descripción			: <\DM 1. Retiro en el Where filtro fecha de validacion de acuerdo caso de  DM\>
* 						  <\DM uso: MEGA_CU_025_RealizarValidaciónEspecial							 DM\>
* 						  <\DM 2. Retiro parametros de entrada: @fcha_vldcn y @cdgo_usro		 	DM\>
* Nuevos Parámetros		: <\PM  								PM\>
* Nuevas Variables		: <\VM  								VM\>
* Fecha Modificación	: <\FM 2016/05/27						FM\>
*-----------------------------------------------------------------------------------------------------------------------------------*/

/*
execute SpValidaNumeroAutorizacion 1,'16918093'
*/

CREATE  Procedure [dbo].[SpValidaNumeroAutorizacion]
@cnsctvo_cdgo_tpo_idntfccn 	Int,
@nmro_idntfccn 		Varchar(23)
As 

Begin 

Set Nocount On

Declare @dscrpcn_ofcna varchar(150),
        @fecha_desde       datetime, 
		@fecha_hasta       datetime
		
Select  top 1 
a.cnsctvo_cdgo_ofcna,
a.nmro_vrfccn,
a.cdgo_usro,fcha_vldcn,
b.cdgo_ofcna
From	bdIPSIntegracion.dbo.tbLog a with(nolock)
Inner join BDAfiliacionValidador.dbo.tbOficinas_Vigencias b
On a.cnsctvo_cdgo_ofcna = b.cnsctvo_cdgo_ofcna
Where   cnsctvo_cdgo_tpo_idntfccn = @cnsctvo_cdgo_tpo_idntfccn
And	a.nmro_idntfccn	  = @nmro_idntfccn
Order by fcha_vldcn desc


End 

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpValidaNumeroAutorizacion] TO [autsalud_rol]
    AS [dbo];

