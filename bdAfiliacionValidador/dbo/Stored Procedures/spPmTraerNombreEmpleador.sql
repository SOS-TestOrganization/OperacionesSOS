/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spPmTraerNombreEmpleador
* Desarrollado por		: <\A Ing. Maria Liliana Prieto  										A\>
* Descripcion			: <\D Este procedimiento realiza una busqueda de un empleador en la estructura definitiva de empresa.  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P Consecutivo tipo Identificacion Empresa								P\>
				  <\P Numero Identificacion Empresa 									P\>
				  <\P Clase empleador											P\>
				  <\P Descripcion											P\>
				  <\P Digito Verficacion			 								P\>
				  <\P Numero Unico de Identificacion 	 								P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/02 											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  Rolando Simbaqueva LassoAM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  2002/09/10	 FM\>
*---------------------------------------------------------------------------------*/
CREATE  PROCEDURE spPmTraerNombreEmpleador
	@lcConsecutivoTipoIdentificacion		UdtConsecutivo,
	@lnNumeroIdentificacion			UdtNumeroIdentificacion,
	@lcDescripcion				Varchar(200)		= Null Output,
	@lnDigitoVerificacion			Int			= Null Output,
	@lnNui					UdtConsecutivo		= Null Output,
	@lcCodigoActividadEconomica		Char(4)			= Null Output
--	@lcCodigoClaseEmpleador		UdtCodigo		= Null Output  no se necesita este parametro 
As
Set Nocount On
-- Inicializacion de variables
Select 	@lcDescripcion	 	= NULL,
	@lnDigitoVerificacion 	= NULL,
	@lnNui 			= NULL

Set @lnDigitoVerificacion = BdSisalud.dbo.fnCalcularDigitoVerificacion(@lnNumeroIdentificacion)

Select	@lnNui		= a.nmro_unco_idntfccn_aprtnte,
	@lcDescripcion	= a.rzn_scl,
	@lcCodigoActividadEconomica	= e.cdgo_actvdd_ecnmca--,cnsctvo_cdgo_tpo_emprsa
From	dbo.tbAportanteValidador a,dbo.tbActividadesEconomicas e
Where	a.cnsctvo_cdgo_tpo_idntfccn_empldr	= @lcConsecutivoTipoIdentificacion
And	a.nmro_idntfccn_empldr			= @lnNumeroIdentificacion
And	a.cnsctvo_cdgo_actvdd_ecnmca		= e.cnsctvo_cdgo_actvdd_ecnmca


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleador] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleador] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleador] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleador] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleador] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleador] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleador] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleador] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleador] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleador] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleador] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleador] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleador] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleador] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleador] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleador] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleador] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleador] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleador] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleador] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleador] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

