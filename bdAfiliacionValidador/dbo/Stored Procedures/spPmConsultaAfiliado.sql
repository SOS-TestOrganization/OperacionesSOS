
/*---------------------------------------------------------------------------------------------------------------------------------------
* Procedimiento			: spPmConsultaAfiliado 
* Desarrollado por		: <\A Ing. Samuel Muñoz							A\>
* Descripción			: <\D									D\>
* Observaciones			: <\O									O\>
* Parámetros			: <\P  									P\>
* Variables			: <\V  									V\>
* Fecha Creación		: <\FC 2003/00/00  							FC\>
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
CREATE      procedure  spPmConsultaAfiliado
@cnsctvo_cdgo_tpo_idntfccn 	udtConsecutivo, 
@nmro_idntfccn			Varchar(23), 	--udtNumeroIdentificacion,
@cnsctvo_cdgo_pln 		udtConsecutivo, 
@fcha_vldccn			datetime			= NULL,
@mnsje				varchar(80)  output,
@Bd 				char(1) ,
--@origen				char(1),
@lfFechaReferencia		datetime output--,
--@lFlag				char output
AS
-- Declaración de variables
Declare
@fechaHstrco	datetime

Set @fechaHstrco = getdate()

select @fechaHstrco = isnull(Cast(rtrim(ltrim(a.vlr_prmtro)) as datetime),getdate())
from tbTablaParametros a
where cnsctvo_prmtro = 3

--Set @lFlag	= 'N'
If datediff(dd,@fcha_vldccn,getdate()) = 0 Or datediff(dd,@fechaHstrco,getdate()) = 0
	Exec dbo.spPmConsultaAfiliado_AlDia @cnsctvo_cdgo_tpo_idntfccn,@nmro_idntfccn,@cnsctvo_cdgo_pln,@mnsje output,@Bd,@lfFechaReferencia output
Else
	Exec dbo.spPmConsultaAfiliado_Historico @cnsctvo_cdgo_tpo_idntfccn,@nmro_idntfccn,@cnsctvo_cdgo_pln,@fcha_vldccn,@mnsje output,@lfFechaReferencia output
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [300202 Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [340010 Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [pe_soa]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [cna_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [vafss_role]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [outbts01]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [portal_rol]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [proceso3047_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [at3047_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [procesope_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

