/*---------------------------------------------------------------------------------
* Metodo o PRG 	              :   SpPmTraerSedes
* Desarrollado por		 :  <\A    Ing. Rolando Simbaqueva									A\>
* Descripcion			 :  <\D   Trae un cursor con los registros de sedes los cuales corresponden a los parametros ingresados.	D\>
* Observaciones		              :  <\O													O\>
* Parametros			 :  <\P    Fecha a la cual se valida la vigencia de la sede							P\>
                                                      :  <\P    Caracteres ingresados por el usuario para realizar la busqueda					P\>
                                                      :  <\P    Codigo de la sede a traer										P\>
* Variables			 :  <\V													V\>
* Fecha Creacion		 :  <\FC  2002/06/20											FC\>
*  
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------  
* Modificado Por		              : <\AM Ing. Carlos Andrés López Ramírez 								AM\>
* Descripcion			 : <\DM Por cambios en las estructuras de las tablas, se ajusta el sp 						DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM 2003/03/19 FM\>
*---------------------------------------------------------------------------------*/

Create  PROCEDURE SpPmTraerSedes

@lcCodigoSede		udtSede	= NULL,
@ldFechaReferencia	datetime	= NULL,
@lcCadenaSeleccion	udtDescripcion	= NULL,
@vsble_usro		udtLogico	= NULL

AS

Set Nocount On

If @vsble_usro is null
	set @vsble_usro='S'

If @lcCodigoSede is NULL
Begin
	If @lcCadenaSeleccion = '+' or @lcCadenaSeleccion is null
	Begin
		If @ldFechaReferencia is NULL
		Begin
			--Selecciona todos los registros de  la tabla  tbsedes donde el campo borrado sea 'N' y este
			--dentro de un rango vigente.
			Select	cdgo_sde,dscrpcn_sde,cnsctvo_cdgo_sde
			From	tbSedes
			Where	(vsble_usro		= 	'S' or @vsble_usro='S')
		End
		Else
		Begin
			--Selecciona todos los registros de  la tabla  tbsedes donde el campo borrado sea 'N' y este
			--dentro de un rango vigente.
			Select	cdgo_sde,dscrpcn_sde,cnsctvo_cdgo_sde
			From	tbSedes_Vigencias
			Where	(@ldFechaReferencia  between inco_vgnca   And    fn_vgnca )
			And	(vsble_usro		= 	'S' or @vsble_usro='S')
		End
	End
	Else
	Begin
		If @ldFechaReferencia is NULL
		Begin
			--Selecciona todos los registros de  la tabla  tbsedes donde el campo borrado sea 'N'  y este
			--dentro de un rango vigente  ademas que   el campo descripcion  contenga el parametro de seleccion.
			Select	cdgo_sde,dscrpcn_sde,cnsctvo_cdgo_sde
			From	tbSedes
			Where	dscrpcn_sde     like  '%' +    ltrim(rtrim(@lcCadenaSeleccion) + '%' )
			And	(vsble_usro		= 	'S' or @vsble_usro='S')
		End
		Else
		Begin
			--Selecciona todos los registros de  la tabla  tbsedes donde el campo borrado sea 'N'  y este
			--dentro de un rango vigente  ademas que   el campo descripcion  contenga el parametro de seleccion.
			Select	cdgo_sde,dscrpcn_sde,cnsctvo_cdgo_sde
			From	tbSedes_Vigencias
			Where	(@ldFechaReferencia  between inco_vgnca        And   fn_vgnca )
			And	dscrpcn_sde     like  '%' +    ltrim(rtrim(@lcCadenaSeleccion) + '%' )
			And	(vsble_usro		= 	'S' or @vsble_usro='S')
		End
	End
End
Else
Begin
	If @ldFechaReferencia is NULL
	Begin
		--Selecciona todos los registros de  la tabla  tbsedes donde el campo borrado sea 'N'  y este
		--dentro de un rango vigente  ademas  donde el codigo sea igual al parametro  @lcCodigoSede
		Select	cdgo_sde,dscrpcn_sde,cnsctvo_cdgo_sde
		From       tbSedes
		Where	cdgo_sde = @lcCodigoSede
		And	(vsble_usro = 'S' or @vsble_usro = 'S')
	End
	Else
	Begin
		--Selecciona todos los registros de  la tabla  tbsedes donde el campo borrado sea 'N'  y este
		--dentro de un rango vigente  ademas  donde el codigo sea igual al parametro  @lcCodigoSede
		Select	cdgo_sde,dscrpcn_sde,cnsctvo_cdgo_sde
		From       tbSedes_Vigencias
		Where	(@ldFechaReferencia  between inco_vgnca    And     fn_vgnca )
		And	cdgo_sde = @lcCodigoSede
		And	(vsble_usro = 'S' or @vsble_usro = 'S')
	End
End



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerSedes] TO [cna_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerSedes] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerSedes] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerSedes] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerSedes] TO [autsalud_rol]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerSedes] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerSedes] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerSedes] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerSedes] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerSedes] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerSedes] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerSedes] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerSedes] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerSedes] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerSedes] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerSedes] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerSedes] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerSedes] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerSedes] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerSedes] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerSedes] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerSedes] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerSedes] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpPmTraerSedes] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

