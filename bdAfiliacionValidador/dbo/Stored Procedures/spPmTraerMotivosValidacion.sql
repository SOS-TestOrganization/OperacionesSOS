

/*---------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	             		:  spCUTraerMotivosValidacion
* Desarrollado por		:  <\A    Ing. Yasmin Ramirez						A\>
* Descripcion		 	:  <\D    Consulta los Motivos parametrizados para ingresar un especial	D\>
* Observaciones		              	:  <\O	Se puede consultar por codigo o parte del nombre del motivo	 O\>
* Parametros			:  <\P 	Codigo del Motivo 						P\>
* 				:  <\P 	Descripcion del Motivo 						P\>
* Fecha Creacion		:  <\FC  2003/09/01							FC\>
*
*---------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------------------------------------------------------------
* Modificado Por			: <\AM Ing. Carlos Andr‚s L¢pez Ram¡rez AM\>
* Descripci¢n			: <\DM  DM\>
* Nuevos Par metros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificaci¢n		: <\FM 2003/10/11 FM\>
*-------------------------------------------------------------------------------------------------------------------------------------*/
CREATE procedure [dbo].[spPmTraerMotivosValidacion]
--@cnsctvo_cdgo_mtvo_ordn_espcl	udtConsecutivo = Null,
@cdgo_mtvo 		char(2) = NULL , 
@dscrpcn_mtvo		varchar(50) = NULL
AS

-- Declaraci¢n y definici¢n de constantes

-- Declaraci¢n de variables

Set NoCount On

-- Programa

--set ansi_nulls on
--set ansi_warnings on

--If @cnsctvo_cdgo_mtvo_ordn_espcl is Null

If @cdgo_mtvo is Null
Begin
	If 	@dscrpcn_mtvo 	= 	'+'	OR	@dscrpcn_mtvo 	IS 	NULL
		Select	cdgo_mtvo_ordn_espcl,dscrpcn_mtvo_ordn_espcl,cnsctvo_cdgo_mtvo_ordn_espcl,fcha_crcn,usro_crcn
		From	dbo.tbMotivoOrdenEspecial
		Where	vsble_usro	= 'S'
	Else
		Select	cdgo_mtvo_ordn_espcl,dscrpcn_mtvo_ordn_espcl,cnsctvo_cdgo_mtvo_ordn_espcl,fcha_crcn,usro_crcn
		From	dbo.tbMotivoOrdenEspecial
		Where	dscrpcn_mtvo_ordn_espcl LIKE '%' + LTRIM(RTRIM(@dscrpcn_mtvo)) + '%'
		And	vsble_usro	= 'S'
End
Else
Begin
	Select	cdgo_mtvo_ordn_espcl,dscrpcn_mtvo_ordn_espcl,cnsctvo_cdgo_mtvo_ordn_espcl,fcha_crcn,usro_crcn
	From	dbo.tbMotivoOrdenEspecial
	Where	cdgo_mtvo_ordn_espcl	= @cdgo_mtvo
	And	vsble_usro			= 'S'
End






GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerMotivosValidacion] TO [310010 Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerMotivosValidacion] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerMotivosValidacion] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerMotivosValidacion] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerMotivosValidacion] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerMotivosValidacion] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerMotivosValidacion] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerMotivosValidacion] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerMotivosValidacion] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerMotivosValidacion] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerMotivosValidacion] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerMotivosValidacion] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerMotivosValidacion] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

