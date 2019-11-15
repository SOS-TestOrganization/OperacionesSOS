

/*---------------------------------------------------------------------------------
* Metodo o PRG 	              :   SpPmTraerNombrexLogin
* Desarrollado por		 :  <\A    Ing. ÁLvaro Zapata									A\>
* Descripcion			 :  <\D   Consulta los auxiliar parametrizadosD\>
* Observaciones		              :  <\O													O\>
* Parametros			 :  <\P    Fecha a la cual se valida la vigencia de la sede							P\>
                                                      :  <\P    Caracteres ingresados por el usuario para realizar la busqueda					P\>
                                                      :  <\P    Codigo de la sede a traer										P\>
* Variables			 :  <\V													V\>
* Fecha Creacion		 :  <\FC  2006/09/05											FC\>
*  
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------  
* Modificado Por		              : <\AM\>
* Descripcion			 : <\DM 		DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM 2003/03/19 FM\>
*---------------------------------------------------------------------------------*/
CREATE  PROCEDURE dbo.SpPmTraerNombrexLogin
@lcCodigoAuxiliar	UdtUsuario	= NULL,
@lcCadenaSeleccion	udtDescripcion	= NULL

/*
declare
@lcCodigoAuxiliar	UdtUsuario	, --= NULL,
@lcCadenaSeleccion	udtDescripcion	--= NULL

Set	@lcCodigoAuxiliar	= Null --'sisala01'
Set	@lcCadenaSeleccion	= 'al'
*/

AS

Set Nocount On


If @lcCodigoAuxiliar is NULL
  Begin
	If @lcCadenaSeleccion = '+' or @lcCadenaSeleccion is null
		Begin

			Select	lgn_usro, Isnull(Ltrim(rtrim(prmr_nmbre_usro)),'')+ ' '+ Isnull(Ltrim(Rtrim(sgndo_nmbre_usro)),'') + ' '+ Isnull(Ltrim(Rtrim(prmr_aplldo_usro)),'') + ' '+ Isnull(Ltrim(Rtrim(sgndo_aplldo_usro)),'') as nmbre
			From	bdSeguridad.dbo.tbUsuarios
		End

	Else

		Begin

			Select	lgn_usro, Isnull(Ltrim(rtrim(prmr_nmbre_usro)),'')+ ' '+ Isnull(Ltrim(Rtrim(sgndo_nmbre_usro)),'') + ' '+ Isnull(Ltrim(Rtrim(prmr_aplldo_usro)),'') + ' '+ Isnull(Ltrim(Rtrim(sgndo_aplldo_usro)),'') as nmbre
			From	bdSeguridad.dbo.tbUsuarios
			Where	Isnull(Ltrim(rtrim(prmr_nmbre_usro)),'') like  + ltrim(rtrim(@lcCadenaSeleccion) + '%' )
		End

  End

Else
  Begin
	Select	lgn_usro, Isnull(Ltrim(rtrim(prmr_nmbre_usro)),'')+ ' '+ Isnull(Ltrim(Rtrim(sgndo_nmbre_usro)),'') + ' '+ Isnull(Ltrim(Rtrim(prmr_aplldo_usro)),'') + ' '+ Isnull(Ltrim(Rtrim(sgndo_aplldo_usro)),'') as nmbre
	From	bdSeguridad.dbo.tbUsuarios
	Where	lgn_usro = @lcCodigoAuxiliar
  End



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerNombrexLogin] TO [300202 Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerNombrexLogin] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerNombrexLogin] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerNombrexLogin] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerNombrexLogin] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerNombrexLogin] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerNombrexLogin] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerNombrexLogin] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerNombrexLogin] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerNombrexLogin] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerNombrexLogin] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerNombrexLogin] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerNombrexLogin] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerNombrexLogin] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerNombrexLogin] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerNombrexLogin] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerNombrexLogin] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerNombrexLogin] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

