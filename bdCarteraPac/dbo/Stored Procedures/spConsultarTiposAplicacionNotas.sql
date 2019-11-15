/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spConsultarTiposAplicacionNotas
* Desarrollado por	: <\A Francisco E. Riaño L. -  Qvision S.A		A\>
* Descripcion		: <\D Procedimiento el cual permite consultar los tipos de 
						aplicacion de una nota vigente		D\>
* Observaciones		: <\O   O\>
* Parametros		: <\P 	P\>				 
* Variables			: <\V  	V\>
* Fecha Creacion	: <\FC 2019/08/02	FC\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*--------------------------------------------------------------------------------- 
* Modificado Por		: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion	: <\FM 2019-08-02  FM\>
*---------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[spConsultarTiposAplicacionNotas] 

As
Begin

	Set NoCount On;

	Declare		@ldFechaSistema	 datetime	= getdate();
				

	select  cdgo_tpo_aplccn_nta,	
			dscrpcn_tpo_aplccn_nta,	
			cnsctvo_cdgo_tpo_aplccn_nta
	from	dbo.tbTiposAplicacionNota_vigencias a with(nolock)
	where   @ldFechaSistema between a.inco_vgnca and a.fn_vgnca

End
  