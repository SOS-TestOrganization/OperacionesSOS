/*---------------------------------------------------------------------------------
* Metodo o PRG 		: fnCalculaFechaFinalPeriodo
* Desarrollado por		: <\A Ing. Janeth Barrera  											A\>
* Descripcion			: <\D Esta función retorna el rango etareo correspondiente a la edad y sexo ingresados vigentes al periodo ingresado 	D\>
* Observaciones			: <\O  														O\>
* Parametros			: <\P 	@lnPeriodo - Periodo al que se evalua la vigencia , @lnEdad Edad, @lnSexo consecutivo del sexo		P\>
* Variables			: <\V  														V\>
* Fecha Creacion		: <\FC 2003/06/25												FC\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  FM\>
*---------------------------------------------------------------------------------*/
CREATE FUNCTION fnCalculaFechaFinalPeriodo (@lnPeriodo int)
RETURNS Datetime
 AS  
BEGIN 
	Declare @ldFechaFinal			Datetime,
		 @ldFechaSiguiente		Datetime,
		@ldFechaInicialMesSiguiente	Datetime,
		@ldFechaInicial			Datetime

	Set	@ldFechaInicial				=	convert(datetime, convert(varchar(6),@lnPeriodo) + '01')
	Set	@ldFechaSiguiente			=	DATEADD ( month , 1, @ldFechaInicial)
	Set	@ldFechaInicialMesSiguiente		=	convert(datetime,SUBSTRing (convert(varchar(10), @ldFechaSiguiente, 111),1,4) + '/' + SUBSTRing (convert(varchar(10), @ldFechaSiguiente, 111),6,2) + '/01')
	Set	@ldFechaFinal				=	DATEADD ( day , -1, @ldFechaInicialMesSiguiente	 )

	Return @ldFechaFinal
END










