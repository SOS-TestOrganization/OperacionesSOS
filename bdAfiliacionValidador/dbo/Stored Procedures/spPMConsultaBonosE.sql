
/*---------------------------------------------------------------------------------------------------------------------------------------
* Procedimiento			: spPMConsultaBonosE 
* Desarrollado por		: <\A Ing. Alvaro Zapata						A\>
* Descripción			: <\D Consulta los bonos electronicos utilizados del afiliado consultado D\>
* Observaciones			: <\O									O\>
* Parámetros			: <\P  									P\>
* Variables			: <\V  									V\>
* Fecha Creación		: <\FC 2006/08/08  							FC\>
*
*---------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------------------------------------------------------------
* Modificado Por			: <\AM 				*					AM\>
* Descripción			: <\DM									DM\>
* 				: <\DM									DM\>
* Nuevos Parámetros		: <\PM  							>
* Nuevas Variables		: <\VM  									VM\>
* Fecha Modificación		: <\FM									FM\>
*-----------------------------------------------------------------------------------------------------------------------------------*/
CREATE procedure  spPMConsultaBonosE
@nmro_unco_idntfccn Int
AS
Set Nocount On

Select	space(150) as ofcna , Cast(a.nmro_vrfccn as int) as nmro_vrfccn, Convert(char(10),a.fcha_utlzcn_bno,103) as fcha_utlzcn_bno, dav.nmro_dcmnto,
	Space(150) as dscrpcn_itm_prspsto, a.cnsctvo_cdgo_ofcna, Isnull(a.cdgo_itm_prspsto,0) as cdgo_itm_prspsto
Into	#tmpBonos
From	bdSiSalud.dbo.tbLogBonos a inner join dbo.tbDocumentosAfiliacionValidador dav
ON	a.cnsctvo_dcmnto_gnrdo	= dav.cnsctvo_dcmnto_gnrdo
Where	dav.nmro_unco_idntfccn 	= @nmro_unco_idntfccn
And	a.cdgo_itm_prspsto		!= '999'
And	dav.fcha_utlzcn_bno is not null

Update	#tmpBonos
Set	ofcna		= o.dscrpcn_ofcna
From	#tmpBonos b inner join bdAfiliacionValidador.dbo.tbOficinas o
ON	b.cnsctvo_cdgo_ofcna	= o.cnsctvo_cdgo_ofcna

Update	#tmpBonos
Set	dscrpcn_itm_prspsto		= ip.dscrpcn_itm_prspsto
From	#tmpBonos b inner join bdSisalud.dbo.tbItemsPresupuesto_Vigencias  ip
ON	b.cdgo_itm_prspsto = ip.cdgo_itm_prspsto

Select	* From	#tmpBonos
Drop table #tmpBonos

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMConsultaBonosE] TO [300202 Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMConsultaBonosE] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMConsultaBonosE] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMConsultaBonosE] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMConsultaBonosE] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMConsultaBonosE] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMConsultaBonosE] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMConsultaBonosE] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMConsultaBonosE] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMConsultaBonosE] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMConsultaBonosE] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMConsultaBonosE] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMConsultaBonosE] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMConsultaBonosE] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMConsultaBonosE] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMConsultaBonosE] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMConsultaBonosE] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMConsultaBonosE] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMConsultaBonosE] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

