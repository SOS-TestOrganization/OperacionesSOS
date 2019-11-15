

/*------------------------------------------------------------------------------------------------------------------------------------------
* MÃ©todo o PRG		:		spControladorEstadoCuenta							
* Desarrollado por	: <\A	Carlos Vela - Qvision	A\>	
* DescripciÃ³n		: <\D	Permite obtener el identificador de liquidacion y la fecha de corte D\>
* Observaciones		: <\O 	O\>	
* ParÃ¡metros		: <\P 	P\>	
* Variables			: <\V	V\>	
* Fecha CreaciÃ³n	: <\FC	2019/05/22	FC\>
*------------------------------------------------------------------------------------------------------------------------------------------*/
CREATE Procedure [dbo].[spObtenerInfoPeriodoLiquidacionPLUS]
	@ldfechaCorte				datetime		Output	,
	@lnConsCodigoPeriodoLiq   udtConsecutivo	Output	,
	@mnsje_slda				varchar(750)	Output	,
	@cdgo_slda				udtCodigo		Output	
As
Begin
	Set Nocount On

	Declare @lnCantidadPeriodosEstadoAbierto	int,
		@ESTADO_ABIERTO int = 2,
		@lcMensaje		char(500),
		@lnNumeroPeriodosEvaluados	int,
		@ldFechaEvaluarPeriodo	datetime,
		@ldFechaSistema		datetime =	getdate(),
		@lnConsecutivoCodigoPeriodoLiquidacion	udtconsecutivo


	Begin Try 
	
		Set @mnsje_slda	= '';
		Set @cdgo_slda	= 0; -- 0k

		-- se calcula el numero de periodos con estado abierto
		Select	@lnCantidadPeriodosEstadoAbierto	=	 count(*)	
		From	dbo.Tbperiodosliquidacion_vigencias  With (NoLock)
		Where  	cnsctvo_cdgo_estdo_prdo	= @ESTADO_ABIERTO

		-- se verifica la validacion del numero de peridos con estado abierto
		If  @lnCantidadPeriodosEstadoAbierto=0   or @lnCantidadPeriodosEstadoAbierto>=2
			Begin 
			Set	@cdgo_slda	=	1
			Set	@mnsje_slda		=	'No existe un solo periodo con estado abierto para generar la liquidaciÃ³n'
			Return
			End
		Else 
			Begin
				select  @lnConsCodigoPeriodoLiq=cnsctvo_cdgo_prdo_lqdcn,
						@ldFechaCorte		=	fcha_incl_prdo_lqdcn
				from [dbo].[tbPeriodosliquidacion_vigencias]  With (NoLock)
				where  cnsctvo_cdgo_estdo_prdo = @ESTADO_ABIERTO
				
				Set	@mnsje_slda		=	'El periodo de corte es: '+CONVERT(varchar, @ldFechaCorte, 23)
				return;
			End	

	End Try
	Begin Catch
		Set @mnsje_slda	= ERROR_PROCEDURE()+' '+Concat(ERROR_MESSAGE(), ' ', ERROR_PROCEDURE(), ' ', ERROR_LINE());
		Set @cdgo_slda	= 1;
	End Catch
	
End
