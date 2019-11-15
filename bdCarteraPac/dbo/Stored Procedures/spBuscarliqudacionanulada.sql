

/*---------------------------------------------------------------------------------
* Metodo o PRG 		:  spBuscarliqudacionanulada
* Desarrollado por		: <\A Ing. Fernando Valencia E 									A\>
* Descripcion			: <\D Este procedimiento devuelve el estado  del ec	 	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2008/01/30											FC\>
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

create   procedure  spBuscarliqudacionanulada
@nmro_lqdcn_ini int,  
@cnsctvo_cdgo_estdo_lqdcn int out

as 	

select @cnsctvo_cdgo_estdo_lqdcn =cnsctvo_cdgo_estdo_lqdcn from tbliquidaciones 
where cnsctvo_cdgo_lqdcn=@nmro_lqdcn_ini

