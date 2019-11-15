

/*---------------------------------------------------------------------------------------------------------------------------------------
* Función			: fnCalcularTiempo
* Desarrollado por		: <\A Ing. Carlos Andrés López Ramírez					A\>
* Descripción			: <\D Calcula la cantidad de tiempo de acuerdo a una unidad solicitada.	D\>
*				: <\D Ideal para calcular la edad exacta de una persona.			D\>
* Observaciones			: <\O Calcula años, meses y días. También la fración de los mismos.	O\>
*				: <\O En modo acumulado sólo tiene en cuenta la parte de la fecha		O\>
*				: <\O correspondiente.							O\>
*				: <\O Los años exactos se calcula con @lnUnidadTiempo=1 y		O\>
*				: <\O @lnTipoOperacion=2						O\>
* Parámetros			: <\P @ldFechaInicial: Fecha inicial del cálculo.				P\>
*				: <\P @ldFechaFinal: Fecha final del cálculo.				P\>
*				: <\P @lnUnidadTiempo: 1=Años, 2=Meses, 3=Días			P\>
*				: <\P @lnTipoOperacion: 1=Acumulado,2=Fracción			P\>
* Variables			: <\V @lnTiempo: Cantidad de tiempo solicitado.				V\>
*				: <\V @ldCumpleMeses: Fecha del último ciclo mensual.			V\>
* 				: <\V @ldCumpleAnos: Fecha del último ciclo anual.			V\>
* Fecha Creación		: <\FC 2003/09/30  							FC\>
*
*---------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------------------------------------------------------------
* Modificado Por			: <\AM  AM\>
* Descripción			: <\DM  DM\>
* Nuevos Parámetros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificación		: <\FM  FM\>
*-------------------------------------------------------------------------------------------------------------------------------------*/

CREATE function fnCalcularTiempo (@ldFechaInicial datetime,@ldFechaFinal datetime,@lnUnidadTiempo int,@lnTipoOperacion int)
RETURNS int AS  
BEGIN

-- Declaración y definición de constantes
Declare
@Anos		int,
@Meses	int,
@Dias		int,
@Acumulado	int,
@Residuo	int

Set @Anos		= 1
Set @Meses		= 2
Set @Dias		= 3
Set @Acumulado	= 1
Set @Residuo		= 2

-- Declaración de variables
Declare
@lnTiempo		int,
@ldCumpleMeses	datetime,
@ldCumpleAnos		datetime

-- Calcula el acumulado en años.
If @lnUnidadTiempo=@Anos And @lnTipoOperacion=@Acumulado
Begin
	Set @lnTiempo=datediff(year,@ldFechaInicial,@ldFechaFinal)
End

-- Calcula el acumulado en meses.
If @lnUnidadTiempo=@Meses And @lnTipoOperacion=@Acumulado
Begin
	Set @lnTiempo=datediff(month,@ldFechaInicial,@ldFechaFinal)
End

-- Calcula el acumulado en días.
If @lnUnidadTiempo=@Dias And @lnTipoOperacion=@Acumulado
Begin
	Set @lnTiempo=datediff(day,@ldFechaInicial,@ldFechaFinal)
End

-- Calcula los años cumplidos.
If @lnUnidadTiempo=@Anos And @lnTipoOperacion=@Residuo
Begin
	If (dateadd(year,datediff(year,@ldFechaInicial,@ldFechaFinal),@ldFechaInicial)>@ldFechaFinal)
	Begin
		Set @lnTiempo=datediff(year,@ldFechaInicial,@ldFechaFinal)-1
	End
	Else
	Begin
		Set @lnTiempo=datediff(year,@ldFechaInicial,@ldFechaFinal)
	End
End

-- Calcula la fracción en meses desde el último ciclo anual..
If @lnUnidadTiempo=@Meses And @lnTipoOperacion=@Residuo
Begin
	If (dateadd(year,datediff(year,@ldFechaInicial,@ldFechaFinal),@ldFechaInicial)>@ldFechaFinal)
	Begin
		Set @ldCumpleAnos=dateadd(year,datediff(year,@ldFechaInicial,@ldFechaFinal)-1,@ldFechaInicial)
	End
	Else
	Begin
		Set @ldCumpleAnos=dateadd(year,datediff(year,@ldFechaInicial,@ldFechaFinal),@ldFechaInicial)
	End

	If (dateadd(month,datediff(month,@ldCumpleAnos,@ldFechaFinal),@ldCumpleAnos)>@ldFechaFinal)
	Begin
		Set @lnTiempo=datediff(month,@ldCumpleAnos,@ldFechaFinal)-1
	End
	Else
	Begin
		Set @lnTiempo=datediff(month,@ldCumpleAnos,@ldFechaFinal)
	End
End

-- Calcula la fracción en días desde el último ciclo mensual..
If @lnUnidadTiempo=@Dias And @lnTipoOperacion=@Residuo
Begin
	If (dateadd(month,datediff(month,@ldFechaInicial,@ldFechaFinal),@ldFechaInicial)>@ldFechaFinal)
	Begin
		Set @ldCumpleMeses=dateadd(month,datediff(month,@ldFechaInicial,@ldFechaFinal)-1,@ldFechaInicial)
	End
	Else
	Begin
		Set @ldCumpleMeses=dateadd(month,datediff(month,@ldFechaInicial,@ldFechaFinal),@ldFechaInicial)
	End

	Set @lnTiempo=datediff(day,@ldCumpleMeses,@ldFechaFinal)
End

Return(@lnTiempo)
END



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTiempo] TO [Analistas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTiempo] TO [cna_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTiempo] TO [vafss_role]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTiempo] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTiempo] TO [enigma]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTiempo] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTiempo] TO [outbts01]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTiempo] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTiempo] TO [portal_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTiempo] TO [proceso3047_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTiempo] TO [AdminScripts_Cambios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTiempo] TO [at3047_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTiempo] TO [autsalud_rol]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTiempo] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTiempo] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTiempo] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTiempo] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTiempo] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTiempo] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTiempo] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTiempo] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTiempo] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTiempo] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTiempo] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTiempo] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTiempo] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTiempo] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTiempo] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularTiempo] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

