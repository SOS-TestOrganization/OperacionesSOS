/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spTraerEstadoNotas
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento arma y ejecuta la cadena donde se tiene los criterios para seleccionar los promotores y sus sucursales 	D\>
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
CREATE  PROCEDURE spTraerEstadoNotas
		@lnTipoNota	udtconsecutivo

As


Select  a.cnsctvo_cdgo_estdo_nta, a.cdgo_estdo_nta,a.dscrpcn_estdo_nta
From    tbEstadosNota a , tbestadosxtipoNota b
Where	a.cnsctvo_cdgo_estdo_nta=b.cnsctvo_cdgo_estdo_nta
And	b.cnsctvo_cdgo_tpo_nta = @lnTipoNota



