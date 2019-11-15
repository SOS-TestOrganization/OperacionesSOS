
/*---------------------------------------------------------------------------------------------------------------------------------------
* Procedimiento			: spCUConsultaDetEmpleadoresAfiliado
* Desarrollado por		: <\A Ing. Yasmin Alexandra Ramirez Cuellar				A\>
* Descripción			: <\D									D\>
* Observaciones			: <\O									O\>
* Parámetros			: <\P  									P\>
* Variables			: <\V  									V\>
* Fecha Creación		: <\FC 2003/09/25  							FC\>
*
*---------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------------------------------------------------------------
* Modificado Por			: <\AM Ing. Carlos Andrés López Ramírez					AM\>
* Descripción			: <\DM Se comentario parte del código el cual no es indispensable.		DM\>
* Nuevos Parámetros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificación		: <\FM 2003/09/25							FM\>
*-------------------------------------------------------------------------------------------------------------------------------------*/
/*
Exec spPmConsultaDetEmpleadoresAfiliado 1,'369547','2011/06/02',1,1,'1061710809',null,null,null,null
*/
CREATE	procedure [dbo].[spPmConsultaDetEmpleadoresAfiliado]
@cnsctvo_cdgo_tpo_cntrto	UdtConsecutivo = NULL, 
@nmro_cntrto			UdtNumeroFormulario = NULL,
@fcha_Vldcn			datetime,
@cnsctvo_cdgo_pln   		UdtConsecutivo	= NULL,		--Para buscar estados de Famisanar
@cnsctvo_tpo_idntfccn       	UdtConsecutivo = NULL,		--Para buscar estados de Famisanar
@nmro_idntfccn   		UdtNumeroIdentificacion= NULL, 	--Para buscar estados de Famisanar
@cdgo_eapb			char(1)= NULL ,				--Para buscar estados de Famisanar
@cnsctvo_cdgo_tpo_frmlro	UdtConsecutivo = null,		-- Para Buscar Estados de Formularios
@nmro_frmlro			UdtNumeroFormulario = null,	-- Para Buscar Estados de Formularios
@fcha_rfrnca			datetime = Null

AS
-- Declaración y definición de constantes
-- Declaración de variables
Set NoCount On

Begin
	Declare	@f_hstrco	datetime

	-- 2011/06/02 (sisatv01) Inconsistencia detectada No muestra informacion del empleador
	if isnull(@fcha_rfrnca,'') = ''
		set @fcha_rfrnca=@fcha_Vldcn


	Exec dbo.spPmFechaHistorico @f_hstrco output


	If Cast(convert(char(10),@fcha_rfrnca,111) As datetime) < Cast(convert(char(10),getdate(),111) As datetime) And
	  Cast(convert(char(10),@f_hstrco,111) As datetime) < Cast(convert(char(10),getdate(),111) As datetime)
		Exec dbo.spPmConsultaDetEmpleadoresAfiliado_Historico @cnsctvo_cdgo_tpo_cntrto, @nmro_cntrto,@fcha_Vldcn,@cnsctvo_cdgo_pln,
		@cnsctvo_tpo_idntfccn,@nmro_idntfccn,@cdgo_eapb,@cnsctvo_cdgo_tpo_frmlro,
		@nmro_frmlro
	Else
		Exec dbo.spPmConsultaDetEmpleadoresAfiliado_alDia @cnsctvo_cdgo_tpo_cntrto, @nmro_cntrto,@fcha_Vldcn,@cnsctvo_cdgo_pln,
		@cnsctvo_tpo_idntfccn,@nmro_idntfccn,@cdgo_eapb,@cnsctvo_cdgo_tpo_frmlro,
		@nmro_frmlro
	--	Exec spPmConsultaDetEmpleadoresAfiliado_alDia @cnsctvo_cdgo_tpo_cntrto, @nmro_cntrto,@fcha_Vldcn,@cnsctvo_cdgo_pln,
	--	@cnsctvo_tpo_idntfccn,@nmro_idntfccn,@cdgo_eapb,@cnsctvo_cdgo_tpo_frmlro,
	--	@nmro_frmlro
End


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [300202 Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [340010 Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [cna_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [vafss_role]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [outbts01]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [portal_rol]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [proceso3047_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [autsalud_rol]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [procesope_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

