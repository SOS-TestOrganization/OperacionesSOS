
/*---------------------------------------------------------------------------------
* Metodo o PRG 	             	 :   spCuConsultaPrestacionesMedicasEmpleador
* Desarrollado por		 :  <\A   Ing. Cesar García					A\>
* Descripcion			 :  <\D   Dependiendo de la fecha desde y la fecha  hasta 		D\>
* Descripcion			 :  <\D   Carga la Consulta 					D\>
* Observaciones		              :  <\O								O\>
* Parametros			 :  <\P    Fecha Desde 						P\>
                                 :  <\P     Fecha Hasta					              P\>
                                                      :  <\P   								P\>
* Variables			 :  <\V								V\>
* Fecha Creacion		 :  <\FC 20090109	 		          			 FC\>
*  
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------  
* Modificado Por		 : <\AM   AM\>
* Descripcion			 : <\DM   DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM   FM\>
*---------------------------------------------------------------------------------*/
CREATE	Procedure [dbo].[spCuConsultaPrestacionesMedicasEmpleador]
@lnNumeroAtencion	Numeric,
@lcCodigoOficina	char(5),
@ldFechaDesde		datetime,
@ldFechaHasta		datetime,
@lnNui			udtConsecutivo


As	 	
/*
Declare
@lnNumeroAtencion	Numeric,
@lcCodigoOficina	char(5),
@ldFechaDesde		datetime,
@ldFechaHasta		datetime,
@lnNui			udtConsecutivo

Set	@lnNumeroAtencion	= 194541
Set	@lcCodigoOficina	= 65
Set	@ldFechaDesde		= null --'20000104'
Set	@ldFechaHasta		= null --'20040310' 
Set	@lnNui			= 100003  
*/

Set Nocount On

declare
@lcCodigoOficinaReal	udtconsecutivo


select		@lcCodigoOficinaReal		= cnsctvo_cdgo_ofcna
From		bdAfiliacionValidador.DBO.tbOficinas_Vigencias
Where		cdgo_ofcna			= @lcCodigoOficina
And			(Getdate() BETWEEN Inco_vgnca	And Fn_vgnca)

Select		space(150) as dscrpcn_ofcna,		Convert(char(10),a.nuam,121) nuam,	space(3) as tpo_idntfccn,
			a.nmro_idntfccn,			ltrim(rtrim(Isnull(a.prmr_aplldo,'')))+' '+ltrim(rtrim(Isnull(a.sgndo_aplldo,'')))+' '+ltrim(rtrim(Isnull(a.prmr_nmbre,'')))+' '+ltrim(rtrim(Isnull(a.sgndo_nmbre,'')))nmbre,
			c.fcha_expdcn,				space(35) as dscrpcn_cntngnca,		space(150) as dscrpcn_pln,
			space(150) as tpo_afldo,		space(150) as dscrpcn_tpo_atncn,		space(15) as dscrpcn_estdo,
			a.cnsctvo_cdgo_tpo_afldo,		a.cnsctvo_cdgo_ofcna,			a.cnsctvo_cdgo_pln,
			a.cnsctvo_cdgo_tpo_idntfccn,		c.cnsctvo_cdgo_cntngnca,		c.cnsctvo_cdgo_tpo_atncn,
			c.cnsctvo_cdgo_estdo	
Into		#tmpPrestacionesMedicasEmpleador
--From	bdConsulta.dbo.tbActua a Inner Join [Newton\Actuario].bdSisalud.dbo.tbInfEmpresasxAfiliado b 
From		bdSisalud.dbo.tbActua a
Inner Join	bdSisalud.dbo.tbInfEmpresasxAfiliado	b	On 		a.nuam 					= b.nuam
														And		a.cnsctvo_cdgo_ofcna	= b.cnsctvo_cdgo_ofcna
Inner Join	bdSisalud.dbo.tbAtencionOps				c	On		b.nuam					= c.nuam
														And		b.cnsctvo_cdgo_ofcna	= c.cnsctvo_cdgo_ofcna
Where		(a.nuam	= @lnNumeroAtencion And a.cnsctvo_cdgo_ofcna = @lcCodigoOficinaReal Or (@lnNumeroAtencion Is Null and  @lcCodigoOficinaReal Is Null))
--And	(a.cnsctvo_cdgo_ofcna		= @lcCodigoOficinaReal Or @lcCodigoOficinaReal Is Null)
And			(b.nmro_unco_idntfccn_empldr	= @lnNui)
And			(Convert(char(10),c.fcha_expdcn,121) BETWEEN @ldFechaDesde AND @ldFechaHasta Or  (@ldFechaDesde IS NULL  And @ldFechaHasta IS NULL)) 

--oficina
Update		#tmpPrestacionesMedicasEmpleador
Set			dscrpcn_ofcna				= b.dscrpcn_ofcna
From		bdAfiliacionValidador.DBO.tbOficinas b, #tmpPrestacionesMedicasEmpleador a
Where		a.cnsctvo_cdgo_ofcna			= b.cnsctvo_cdgo_ofcna
And			(a.cnsctvo_cdgo_ofcna			= @lcCodigoOficinaReal Or @lcCodigoOficinaReal Is Null)

-- tipo de identificacion
Update		#tmpPrestacionesMedicasEmpleador
set			tpo_idntfccn			= b.cdgo_tpo_idntfccn
From		#tmpPrestacionesMedicasEmpleador a, bdAfiliacionValidador.DBO.tbTiposIdentificacion b
Where		a.cnsctvo_cdgo_tpo_idntfccn	= b.cnsctvo_cdgo_tpo_idntfccn


--Calcula la Contingencia 
Update		#tmpPrestacionesMedicasEmpleador
Set			dscrpcn_cntngnca				= b.dscrpcn_cntngnca
From		bdSisalud.dbo.tbContingencias b, #tmpPrestacionesMedicasEmpleador a
Where		b.cnsctvo_cdgo_cntngnca				= a.cnsctvo_cdgo_cntngnca

-- descripcion del plan
Update		#tmpPrestacionesMedicasEmpleador
Set			dscrpcn_pln				= c.dscrpcn_pln
From		bdAfiliacionValidador.dbo.tbplanes c, bdSisalud.dbo.tbAtencionOps b, #tmpPrestacionesMedicasEmpleador a
Where		c.cnsctvo_cdgo_pln			= b.cnsctvo_cdgo_pln
And			a.nuam						= b.nuam
And			a.cnsctvo_cdgo_ofcna				= b.cnsctvo_cdgo_ofcna	

--Calcula el plan
Update		#tmpPrestacionesMedicasEmpleador
Set			tpo_afldo					= b.dscrpcn
From		bdAfiliacionValidador.DBO.tbTiposAfiliado b, #tmpPrestacionesMedicasEmpleador a
Where		a.cnsctvo_cdgo_tpo_afldo			= b.cnsctvo_cdgo_tpo_afldo


--Calcula el Tipo de atención
Update		#tmpPrestacionesMedicasEmpleador
Set			dscrpcn_tpo_atncn				= b.dscrpcn_tpo_atncn
From		bdSiSalud.dbo.tbTiposAtencion b, #tmpPrestacionesMedicasEmpleador a
where		b.cnsctvo_cdgo_tpo_atncn				= a.cnsctvo_cdgo_tpo_atncn


--Calcula el estado de atención
Update		#tmpPrestacionesMedicasEmpleador
Set			dscrpcn_estdo					= b.dscrpcn_estdo_atncn
From		bdSiSalud.dbo.tbEstadosAtencion b, #tmpPrestacionesMedicasEmpleador a
Where		a.cnsctvo_cdgo_estdo				= b.cnsctvo_cdgo_estdo_atncn



Select * from #tmpPrestacionesMedicasEmpleador
Drop Table #tmpPrestacionesMedicasEmpleador

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCuConsultaPrestacionesMedicasEmpleador] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCuConsultaPrestacionesMedicasEmpleador] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCuConsultaPrestacionesMedicasEmpleador] TO [Consultor Administrador]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCuConsultaPrestacionesMedicasEmpleador] TO [Consultor Auditor]
    AS [dbo];

