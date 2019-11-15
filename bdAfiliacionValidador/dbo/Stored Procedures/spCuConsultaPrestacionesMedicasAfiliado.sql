
/*---------------------------------------------------------------------------------
* Metodo o PRG                 :   spCuConsultaPrestacionesMedicasAfiliado
* Desarrollado por   :  <\A   Alvaro Zapata   A\>
* Descripcion    :  <\D    D\>
* Descripcion    :  <\D       D\>
* Observaciones                :  <\O     O\>
* Parametros    :  <\P        P\>
                 :  <\P                      P\>
                 :  <\P        P\>
* Variables    :  <\V     V\>
* Fecha Creacion   :  <\FC 20031101              FC\>
*  
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------  
* Modificado Por                : <\AM   AM\>
* Descripcion    : <\DM   DM\>
* Nuevos Parametros    : <\PM   PM\>
* Nuevas Variables   : <\VM   VM\>
* Fecha Modificacion   : <\FM   FM\>
*---------------------------------------------------------------------------------*/
CREATE Procedure [dbo].[spCuConsultaPrestacionesMedicasAfiliado]
@lnNumeroAtencion		Numeric,
@lcCodigoOficina		Char(5),
@ldFechaDesde			Datetime,
@ldFechaHasta			Datetime,
@lnCodigoPlan			UdtCodigo,
@lcCodigoTipoAtencion	Char(3),
@lnCodigoContingencia	Char(3),
@lnNui					UdtConsecutivo

As


/*
--spCuConsultaPrestacionesMedicasAfiliado
Declare
@lnNumeroAtencion Numeric,
@lcCodigoOficina Char(5),
@ldFechaDesde  datetime,
@ldFechaHasta  datetime,
@lnCodigoPlan  udtCodigo,
@lcCodigoTipoAtencion Char(3),
@lnCodigoContingencia Char(3),
@lnNui   udtConsecutivo

Set @lnNumeroAtencion		=	Null --273366
Set @lcCodigoOficina		=	'08' --2
Set @ldFechaDesde			=	'20090101'
Set @ldFechaHasta			=	'20090930' 
Set @lnCodigoPlan			=	1
Set @lcCodigoTipoAtencion	=	Null --01, 22
Set @lnCodigoContingencia	=	Null --01
Set @lnNui					=	32212783
*/

Set Nocount On

Declare		@lcCodigoOficinaReal	Udtconsecutivo,
			@cnsctvo_cdgo_tpo_atncn Udtconsecutivo,
			@cnsctvo_cdgo_cntngnca	UdtConsecutivo

Select		@lcCodigoOficinaReal  = cnsctvo_cdgo_ofcna
From		bdAfiliacionValidador.dbo.tbOficinas
Where		cdgo_ofcna   = @lcCodigoOficina

--Se calcula el consecutivo ya que en la tabla se guarda es el consecutivo
Select		@cnsctvo_cdgo_tpo_atncn  = cnsctvo_cdgo_tpo_atncn
From		bdSiSalud.dbo.tbTiposAtencion 
Where		cdgo_tpo_atncn   = @lcCodigoTipoAtencion

--Se calcula el consecutivo ya que en la tabla se guarda es el consecutivo
Select		@cnsctvo_cdgo_cntngnca  = cnsctvo_cdgo_cntngnca
From		bdSisalud.DBO.tbContingencias 
Where		cdgo_cntngnca   = @lnCodigoContingencia


Select		space(150) as dscrpcn_ofcna,    Convert(char(10),a.nmro_atncn,121) nmro_atncn, a.nuam, 
			Convert(char(10),a.fcha_expdcn,111) as fcha_expdcn , space(150) as dscrpcn_tpo_atncn,  space(50) as dscrpcn_estdo,
			space(150) as dscrpcn_pln,    space(150) as nmbre_mdco,   space(150) as dscrpcn_clse_atncn,
			space(35) as dscrpcn_cntngnca,    space(200) as rzn_scl_ips,   a.cnsctvo_cdgo_ofcna,
			a.cnsctvo_cdgo_tpo_atncn,    a.cnsctvo_cdgo_estdo,    a.cnsctvo_cdgo_pln,
			a.nmro_unco_idntfccn_mdco,    a.cnsctvo_cdgo_clse_atncn,   a.cnsctvo_cdgo_cntngnca,
			a.nmro_unco_idntfccn_ips,    a.nmro_unco_idntfccn_afldo
Into		#tmpPrestacionesMedicasAfiliado
From		bdSisalud.dbo.tbAtencionOps a
Where		(a.nuam    = @lnNumeroAtencion Or @lnNumeroAtencion Is Null) 
And			(a.cnsctvo_cdgo_ofcna		= @lcCodigoOficinaReal Or @lcCodigoOficinaReal Is Null)
And			(Convert(char(10),a.fcha_expdcn,121) BETWEEN @ldFechaDesde AND @ldFechaHasta Or  (@ldFechaDesde IS NULL  And @ldFechaHasta IS NULL)) 
And			(a.cnsctvo_cdgo_pln			= @lnCodigoPlan Or @lnCodigoPlan Is Null)
And			(a.cnsctvo_cdgo_tpo_atncn	= @cnsctvo_cdgo_tpo_atncn Or @cnsctvo_cdgo_tpo_atncn Is Null)
And			(a.cnsctvo_cdgo_cntngnca	= @cnsctvo_cdgo_cntngnca Or @cnsctvo_cdgo_cntngnca Is Null)
And			(a.nmro_unco_idntfccn_afldo = @lnNui)


Update		#tmpPrestacionesMedicasAfiliado
Set			dscrpcn_ofcna    = b.dscrpcn_ofcna
From		bdAfiliacionValidador.DBO.tbOficinas b, #tmpPrestacionesMedicasAfiliado a
Where		a.cnsctvo_cdgo_ofcna   = b.cnsctvo_cdgo_ofcna


Update		#tmpPrestacionesMedicasAfiliado
Set			dscrpcn_tpo_atncn   = b.dscrpcn_tpo_atncn
From		bdSiSalud.dbo.tbTiposAtencion b, #tmpPrestacionesMedicasAfiliado a
Where		a.cnsctvo_cdgo_tpo_atncn  = b.cnsctvo_cdgo_tpo_atncn


Update		#tmpPrestacionesMedicasAfiliado
Set			dscrpcn_estdo    = b.dscrpcn_estdo_atncn
From		bdSisalud.dbo.tbEstadosAtencion b, #tmpPrestacionesMedicasAfiliado a
Where		a.cnsctvo_cdgo_estdo   = b.cnsctvo_cdgo_estdo_atncn


Update		#tmpPrestacionesMedicasAfiliado
Set			dscrpcn_pln    = b.dscrpcn_pln
From		bdAfiliacionValidador.dbo.tbplanes b, #tmpPrestacionesMedicasAfiliado a
Where		a.cnsctvo_cdgo_pln   = b.cnsctvo_cdgo_pln


Update		#tmpPrestacionesMedicasAfiliado
Set			nmbre_mdco    = ltrim(rtrim(Isnull(b.prmr_aplldo,'')))+' '+ltrim(rtrim(Isnull(b.sgndo_aplldo,'')))+' '+ltrim(rtrim(Isnull(b.prmr_nmbre_afldo,'')))+' '+ltrim(rtrim(Isnull(b.sgndo_nmbre_afldo,'')))
From		bdSisalud.DBO.tbMedicos b, #tmpPrestacionesMedicasAfiliado a
Where		a.nmro_unco_idntfccn_mdco  = b.nmro_unco_idntfccn_prstdr


Update		#tmpPrestacionesMedicasAfiliado
Set			dscrpcn_clse_atncn   = b.dscrpcn_clse_atncn
From		bdSisalud.dbo.tbClasesAtencion b, #tmpPrestacionesMedicasAfiliado a
Where		a.cnsctvo_cdgo_clse_atncn  = b.cnsctvo_cdgo_clse_atncn


Update		#tmpPrestacionesMedicasAfiliado
Set			dscrpcn_cntngnca    = b.dscrpcn_cntngnca
From		bdSisalud.DBO.tbContingencias b, #tmpPrestacionesMedicasAfiliado a
Where		a.cnsctvo_cdgo_cntngnca   = b.cnsctvo_cdgo_cntngnca


Update		#tmpPrestacionesMedicasAfiliado
Set			rzn_scl_ips    = b. rzn_scl
From		bdSisalud.DBO.tbIps b, #tmpPrestacionesMedicasAfiliado a
Where		a.nmro_unco_idntfccn_ips  = b.nmro_unco_idntfccn_prstdr

Select		*
From		#tmpPrestacionesMedicasAfiliado

Drop Table	#tmpPrestacionesMedicasAfiliado














GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCuConsultaPrestacionesMedicasAfiliado] TO [900011 Consultor Administrador]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCuConsultaPrestacionesMedicasAfiliado] TO [310010 Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCuConsultaPrestacionesMedicasAfiliado] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCuConsultaPrestacionesMedicasAfiliado] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCuConsultaPrestacionesMedicasAfiliado] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCuConsultaPrestacionesMedicasAfiliado] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCuConsultaPrestacionesMedicasAfiliado] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCuConsultaPrestacionesMedicasAfiliado] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCuConsultaPrestacionesMedicasAfiliado] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCuConsultaPrestacionesMedicasAfiliado] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCuConsultaPrestacionesMedicasAfiliado] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCuConsultaPrestacionesMedicasAfiliado] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCuConsultaPrestacionesMedicasAfiliado] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCuConsultaPrestacionesMedicasAfiliado] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCuConsultaPrestacionesMedicasAfiliado] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCuConsultaPrestacionesMedicasAfiliado] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCuConsultaPrestacionesMedicasAfiliado] TO [Consultor Administrador]
    AS [dbo];

