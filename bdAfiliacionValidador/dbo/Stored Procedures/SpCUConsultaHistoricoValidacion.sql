

/*---------------------------------------------------------------------------------
* Metodo o PRG 	       	 :   SpCUConsultaHistoricoValidacion
* Desarrollado por		 :  <\A   Alvaro Zapata			A\>
* Descripcion			 :  <\D  						D\>
* Descripcion			 :  <\D   						D\>
* Observaciones		     :  <\O							O\>
* Parametros			 :  <\P   						P\>
                         :  <\P    				        P\>
                         :  <\P   						P\>
* Variables			 	 :  <\V							V\>
* Fecha Creacion		 :  <\FC 	20031022 		    FC\>
*  
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------  
* Modificado Por		 : <\AM Andrés Taborda  						AM\>
* Descripcion			 : <\DM Inclusion para Consultar tbLog_Cuentas  DM\>
* Nuevos Parametros	 	 : <\PM   										PM\>
* Nuevas Variables		 : <\VM   										VM\>
* Fecha Modificacion	 : <\FM  2006/05/25 							FM\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------  
* Modificado Por		 : <\AM Ing. Cesar García  						AM\>
* Descripcion			 : <\DM Se excluye consulta tbLog_Cuentas		DM\>
* Nuevos Parametros	 	 : <\PM   										PM\>
* Nuevas Variables		 : <\VM   										VM\>
* Fecha Modificacion	 : <\FM  2015-07-07 							FM\>
*---------------------------------------------------------------------------------*/
CREATE	Procedure [dbo].[SpCUConsultaHistoricoValidacion]
@Nui				Udtconsecutivo,
@lcTipo				char(3),
@lcNumeroId			char(23),
@ldFechaDesde		Datetime,
@ldFechaHasta		Datetime

As
Set NoCount On

/*
Declare
@Nui			Udtconsecutivo,
@ldFechaDesde		Datetime,
@ldFechaHasta		Datetime

Set	@Nui			=  31875421
Set	@ldFechaDesde	= '20020101'
Set	@ldFechaHasta	= '20061031'
*/

Declare @consecutivo int

select	@consecutivo = t.cnsctvo_cdgo_tpo_idntfccn  
from	bdAfiliacionValidador.dbo.tbTiposIdentificacion t
Where	t.cdgo_tpo_idntfccn = @lcTipo

Select	a.nmro_vrfccn,			space(10) as orgn_lrgo,			space(150) as dscrpcn_ofcna,	a.fcha_vldcn,
		a.cnsctvo_cdgo_pln,		a.cnsctvo_cdgo_ofcna,			a.obsrvcns,
		space(150) as dscrpcn_pln,	space(150) as dscrpcn_estdo_drcho,	a.nmro_unco_idntfccn_afldo,
		a.cnsctvo_cdgo_estdo_afldo,	a.orgn,					a.cnsctvo_cdgo_tpo_idntfccn,	a.nmro_idntfccn,
		Space(50) as mtvo_vldcn
Into	#tmpHistoricoValidacion
From	bdSisalud.dbo.tbLog a
Where	(a.fcha_vldcn BETWEEN @ldFechaDesde AND @ldFechaHasta+1)
--And	a.nmro_unco_idntfccn_afldo	= @Nui
And	((a.nmro_unco_idntfccn_afldo	= @Nui and a.nmro_unco_idntfccn_afldo <> 0 )
     OR (a.cnsctvo_cdgo_tpo_idntfccn = @consecutivo  and a.nmro_idntfccn = @lcNumeroId ) )

/*
--Adicionamos Datos TbLog_Cuentas
Insert Into #tmpHistoricoValidacion (
		nmro_vrfccn,						fcha_vldcn,				cnsctvo_cdgo_pln,
		cnsctvo_cdgo_ofcna,					obsrvcns,				nmro_unco_idntfccn_afldo,
		cnsctvo_cdgo_estdo_afldo,			orgn,					cnsctvo_cdgo_tpo_idntfccn,
		nmro_idntfccn					
)
select 	a1.nmro_vrfccn, 					a1.fcha_vldcn, 			a1.cnsctvo_cdgo_pln,
		a1.cnsctvo_cdgo_ofcna,				a1.obsrvcns, 			a1.nmro_unco_idntfccn_afldo,
		a1.cnsctvo_cdgo_estdo_afldo,		a1.orgn,				a1.cnsctvo_cdgo_tpo_idntfccn,
		a1.nmro_idntfccn					
From 	bdSisalud.dbo.tbLog_cuentas a1
Where	(a1.fcha_vldcn BETWEEN @ldFechaDesde AND @ldFechaHasta+1)
--And		a1.nmro_unco_idntfccn_afldo	= @Nui
And	((a1.nmro_unco_idntfccn_afldo	= @Nui and a1.nmro_unco_idntfccn_afldo<>0 )
     OR (a1.cnsctvo_cdgo_tpo_idntfccn = @consecutivo and a1.nmro_idntfccn = @lcNumeroId ) )
*/

Update	#tmpHistoricoValidacion
Set		dscrpcn_ofcna			= b.dscrpcn_ofcna
From	#tmpHistoricoValidacion	a, bdAfiliacionValidador.dbo.tbOficinas b
Where	a.cnsctvo_cdgo_ofcna		= b.cnsctvo_cdgo_ofcna


Update	#tmpHistoricoValidacion
Set	orgn_lrgo			= substring(b.dscrpcn_tpo_vldcn,1,10) --b.dscrpcn_tpo_vldcn
--From	#tmpHistoricoValidacion a, [Newton\Actuario].bdSiSalud.dbo.tbTiposValidacion_Vigencias b
From	#tmpHistoricoValidacion a, bdSisalud.dbo.tbTiposValidacion_Vigencias b
Where	b.cdgo_tpo_vldcn		= a.orgn
And		(Convert(Char(10),Getdate(),111) Between b.inco_vgnca And b.fn_vgnca)


Update	#tmpHistoricoValidacion
Set	dscrpcn_pln			= b.dscrpcn_pln
From	#tmpHistoricoValidacion a, bdAfiliacionValidador.dbo.tbPlanes b
Where	a.cnsctvo_cdgo_pln		= b.cnsctvo_cdgo_pln

Update	#tmpHistoricoValidacion
Set		dscrpcn_estdo_drcho		= b.dscrpcn_estdo_drcho
From	#tmpHistoricoValidacion a, bdAfiliacionValidador.DBO.tbEstadosDerechoValidador b
Where	a.cnsctvo_cdgo_estdo_afldo	= b.cnsctvo_cdgo_estdo_drcho


Update	#tmpHistoricoValidacion
Set		mtvo_vldcn			= b.dscrpcn_mtvo_ordn_espcl
--From	#tmpHistoricoValidacion a,  [Newton\Actuario].bdSisalud.dbo.tbInfAfiliadosEspeciales c, 
--		[Newton\Actuario].bdSisalud.dbo.tbMotivoOrdenEspecial b
From	#tmpHistoricoValidacion a,  bdSisalud.dbo.tbInfAfiliadosEspeciales c, 
		bdSisalud.dbo.tbMotivoOrdenEspecial b
Where	a.cnsctvo_cdgo_tpo_idntfccn	= c.cnsctvo_cdgo_tpo_idntfccn
And	a.nmro_idntfccn			= c.nmro_idntfccn
And	c.cnsctvo_cdgo_mtvo		= b.cnsctvo_cdgo_mtvo_ordn_espcl

Select	*
from	#tmpHistoricoValidacion

Drop Table #tmpHistoricoValidacion
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaHistoricoValidacion] TO [900011 Consultor Administrador]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaHistoricoValidacion] TO [310010 Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaHistoricoValidacion] TO [Consultor Administrativo]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaHistoricoValidacion] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaHistoricoValidacion] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaHistoricoValidacion] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaHistoricoValidacion] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaHistoricoValidacion] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaHistoricoValidacion] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaHistoricoValidacion] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaHistoricoValidacion] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaHistoricoValidacion] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaHistoricoValidacion] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaHistoricoValidacion] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaHistoricoValidacion] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaHistoricoValidacion] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpCUConsultaHistoricoValidacion] TO [Consultor Auditor]
    AS [dbo];

