



/*-----------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 			: spTraerPrestadorVigenciasIdentificacion
* Desarrollado por		: <\A Ing. Camilo Torres Gallego  							A\>
* Descripcion			: <\D Este procedimiento realiza la consulta del prestador, sus sucursales y vigencias	D\>
				  <\D dependiendo de un parametro de entrada.						D\>
* Observaciones			: <\O  											O\>
* Parametros			: <\P Número de identificacion prestador   	udtNumeroIdentificacionLargo		P\>
				  <\P Consecutivo código tipo de identificación udtConsecutivo				P\>
				  <\P Tipo Prestador 				udtLogico 			 	P\>
				  <\P 		 									P\>
* Variables			: <\V  											V\>
* Fecha Creacion		: <\FC 2004/05/11 									FC\>
*
*------------------------------------------------------------------------------------------------------------------------  
* DATOS DE MODIFICACION
*------------------------------------------------------------------------------------------------------------------------
* Modificado Por		 : <\AM AM\>
* Descripcion			 : <\DM DM\>
* Nuevos Parametros	 	 : <\PM PM\>
* Nuevas Variables		 : <\VM VM\>
* Fecha Modificacion		 : <\FM FM\>
*-----------------------------------------------------------------------------------------------------------------------*/

CREATE procedure  spTraerPrestadorVigenciasIdentificacion 
    @lnNumeroId  udtNumeroIdentificacionLargo,
    @lnTipoDoc	 udtConsecutivo
 As 
    
Select a.nmro_unco_idntfccn_prstdr,a.cnsctvo_cdgo_tpo_idntfccn,a.nmro_idntfccn,a.dgto_vrfccn,
       a.vldo,a.prstdr_gnrco,b.prncpl,b.nmbre_scrsl,b.drccn,
	b.tlfno,b.cnsctvo_cdgo_cdd,b.cntcto,c.inco_vgnca,c.fn_vgnca from 
   bdSiSalud..tbPrestadores a Inner join bdSiSalud..tbDireccionesPrestador b on(a.nmro_unco_idntfccn_prstdr = b.nmro_unco_idntfccn_prstdr)
   inner join bdSiSalud..tbDireccionesPrestador_Vigencias c on(b.cdgo_intrno = c.cdgo_intrno)
 where (a.cnsctvo_cdgo_tpo_idntfccn = @lnTipoDoc and a.nmro_idntfccn = @lnNumeroId)







GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerPrestadorVigenciasIdentificacion] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerPrestadorVigenciasIdentificacion] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerPrestadorVigenciasIdentificacion] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerPrestadorVigenciasIdentificacion] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerPrestadorVigenciasIdentificacion] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerPrestadorVigenciasIdentificacion] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];

