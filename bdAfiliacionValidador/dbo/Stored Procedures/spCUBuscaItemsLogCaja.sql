

/*---------------------------------------------------------------------------------
* Metodo o PRG 	             	 :   spCUBuscaItemsLogCaja
* Desarrollado por		 :  <\A   Alvaro Zapata			A\>
* Descripcion			 :  <\D  		D\>
* Descripcion			 :  <\D   				D\>
* Observaciones		              :  <\O					O\>
* Parametros			 :  <\P   					P\>
                                 		:  <\P    				              P\>
                                                      :  <\P   					P\>
* Variables			 :  <\V					V\>
* Fecha Creacion		 :  <\FC 20040124 		          	 FC\>
*  
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------  
* Modificado Por		 : <\AM Cambio Estructuras Tablas Salud  AM\>
* Descripcion			 : <\DM   DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM 2005/01/17  FM\>
*---------------------------------------------------------------------------------*/
CREATE	Procedure [dbo].[spCUBuscaItemsLogCaja]
@cnsctvo_cdgo_ofcna 	UdtConsecutivo, 
@nmro_vrfccn		numeric,
@cdgo_cnvno		numeric

As	 	

Set Nocount On

/* Codigo Anterior
Declare
@cnsctvo_cdgo_ofcna 	UdtConsecutivo, 
@nmro_vrfccn		numeric,
@cdgo_cnvno		numeric

Set	@cnsctvo_cdgo_ofcna	= '01'
Set	@nmro_vrfccn		= 259715
Set	@cdgo_cnvno		= 1


select 	a.cdgo_itm_cptcn,
	a.accn as accion,
	b.dscrpcn_itm_cptcn
from 	[Newton].bdPrestaMedicas.dbo.tblogservicios a,
	bdConsulta.DBO.tbitemcapitacion b
where 	cnsctvo_cdgo_ofcna 	=	 @cnsctvo_cdgo_ofcna
and    	nmro_vrfccn 		= 	@nmro_vrfccn
And	cdgo_cnvno		= 	@cdgo_cnvno
and    	a.cdgo_itm_cptcn	=	b.cdgo_itm_cptcn
UNION
select 	a.cdgo_itm_cptcn,
	a.accn as accion,
	b.dscrpcn_itm_cptcn
from 	[Newton].bdCuentasMedicas.dbo.tblogservicios a,
	bdConsulta.DBO.tbitemcapitacion b
where 	cnsctvo_cdgo_ofcna 	=	 @cnsctvo_cdgo_ofcna
and    	nmro_vrfccn 		= 	@nmro_vrfccn
And	cdgo_cnvno		= 	@cdgo_cnvno
and    	a.cdgo_itm_cptcn	=	b.cdgo_itm_cptcn
*/

-- Nuevo Query Por cambios Tablas Salud
select 	a.cnsctvo_cdgo_itm_cptcn,
	a.accn as accion,
	b.dscrpcn_itm_cptcn
from 	bdSisalud.DBO.tblogservicios a,
		bdSisalud.DBO.tbitemcapitacion b
where 	a.cnsctvo_cdgo_ofcna 	=	@cnsctvo_cdgo_ofcna
and    	a.nmro_vrfccn 		= 	@nmro_vrfccn
And	a.cnsctvo_cdgo_cnvno	= 	@cdgo_cnvno
And	a.cnsctvo_cdgo_itm_cptcn =	b.cnsctvo_cdgo_itm_cptcn
UNION
select 	a.cnsctvo_cdgo_itm_cptcn,
	a.accn as accion,
	b.dscrpcn_itm_cptcn
From 	bdSisalud.DBO.tblog_servicios_cuentas a,
		bdSisalud.DBO.tbitemcapitacion b
where 	cnsctvo_cdgo_ofcna 	=	@cnsctvo_cdgo_ofcna
and    	nmro_vrfccn 		= 	@nmro_vrfccn
And	a.cnsctvo_cdgo_cnvno	= 	@cdgo_cnvno
And	a.cnsctvo_cdgo_itm_cptcn =	b.cnsctvo_cdgo_itm_cptcn






GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUBuscaItemsLogCaja] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUBuscaItemsLogCaja] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUBuscaItemsLogCaja] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUBuscaItemsLogCaja] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUBuscaItemsLogCaja] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUBuscaItemsLogCaja] TO [Consulta]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUBuscaItemsLogCaja] TO [Consultor Administrador]
    AS [dbo];

