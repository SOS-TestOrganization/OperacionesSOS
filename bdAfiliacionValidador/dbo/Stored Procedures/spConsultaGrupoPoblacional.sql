/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	         :   spConsultaGrupoPoblacional
* Desarrollado por		 :  <\A   Claudia Rubio		A\>
* Descripcion			 :  <\D  Consulta el Grupo Poblacional de un afiliado
							
							
							D\>
* Observaciones		     :  <\O								O\>
* Parametros			 :  <\P   									P\>		
* Fecha Creacion		 :  <\FC  2015/03/28						FC\>
*  
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION   
*---------------------------------------------------------------------------------  
* Modificado Por		 : <\AM   AM\>
* Descripcion			 : <\DM   DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion	 : <\FM   FM\>
*---------------------------------------------------------------------------------*/
--execute spConsultaGrupoPoblacional 31208229
CREATE PROCEDURE [dbo].[spConsultaGrupoPoblacional]
@nmro_unco_idntfccn_afldo int

As


Select			b.cdgo_grpo_pblcnl,			b.dscrpcn_grpo_pblcnl,			
				a.inco_vgnca,				a.fn_vgnca
From			bdAfiliacionValidador.[dbo].[tbGruposPoblacionesAfiliados] a With(NoLock)
Inner Join		bdAfiliacionValidador.[dbo].[tbGrupoPoblacional_Vigencias] b With(NoLock)	
	On a.cnsctvo_cdgo_grpo_pblcnl = b.cnsctvo_cdgo_grpo_pblcnl
Where			a.nmro_unco_idntfccn_afldo = @nmro_unco_idntfccn_afldo
And				Getdate()  Between  a.inco_vgnca and b.fn_vgnca
And				Getdate()  Between  b.inco_vgnca and b.fn_vgnca
And				a.estdo_rgstro				= 'S'
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [300202 Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [900002 Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [900011 Consultor Administrador]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [340010 Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [cna_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [vafss_role]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [900001 Consultor Administrativo]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [900008 Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [outbts01]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [900007 Consultor Administrativo Novedades]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [900003 Consultor Asesor Cartera]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [900005 Consultor Asesor Comercial]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [900004 Consultor Coordinador Comercial]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [970004 Consultor General Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [900006 Consultor Comercial Privilegiado]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [970003 Consultor Jefaturas Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [970005 Consultor Web Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [970006 Consultor Kiosko Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [autsalud_rol]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaGrupoPoblacional] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

