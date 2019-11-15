


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :   spTraerParentescos
* Desarrollado por		 :  <\A    Ing. Alexander Yela Reyes						A\>
* Descripcion			 :  <\D   Traer todos los Parentescos			.			D\>
* Observaciones		              :  <\O										O\>
* Parametros			 :  <\P  Consecutivo Codigo Parentesco	l					P\>		
* Fecha Creacion		 :  <\FC  2002/10/18								FC\>
*  
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION   
*---------------------------------------------------------------------------------  
* Modificado Por		              : <\AM Ing. Carlos Andrés López Ramírez 			AM\>
* Descripcion			 : <\DM Por cambios en las estructuras de las tablas, se ajusta el sp 	DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM 2003/03/20 FM\>
*---------------------------------------------------------------------------------*/
CREATE procedure   spTraerParentescos
@lnConsecutivoParentesco	udtConsecutivo 	=	Null,
@lcTraerTodosVisibleUsuario	udtLogico	=	'N',
@lcTraerCotizante		udtLogico	=	'S'
AS
Set Nocount On

Select 	dscrpcn_prntsco,	cnsctvo_cdgo_prntscs,	cdgo_prntscs, 	cnsctvo_cdgo_rlcn_ctznte
From 	tbParentescos_Vigencias 
Where	(cnsctvo_cdgo_prntscs	=	@lnConsecutivoParentesco  	Or 	@lnConsecutivoParentesco Is Null )
And 	(Vsble_Usro		= 	'S' 	Or 	@lcTraerTodosVisibleUsuario = 'S')
And	(cnsctvo_cdgo_prntscs	!=	1	Or	@lcTraerCotizante = 'S')
And 	GetDate()	Between	inco_vgnca	And	fn_vgnca





GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParentescos] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParentescos] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParentescos] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParentescos] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParentescos] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParentescos] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParentescos] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParentescos] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParentescos] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParentescos] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParentescos] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParentescos] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParentescos] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParentescos] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParentescos] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParentescos] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParentescos] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParentescos] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParentescos] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParentescos] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

