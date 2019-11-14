
/*------------------------------------------------------------------------------------------------------------------------------------------
* MÃ©todo o PRG		:		spRegistrarCriteriosLiquidacionPLUS							
* Desarrollado por	: <\A	Carlos Vela - Qvision	A\>	
* DescripciÃ³n		: <\D	Registra los criterios de liquidaciÃ³n D\>
* Observaciones		: <\O 	O\>	
* ParÃ¡metros		: <\P 	P\>	
* Variables			: <\V	V\>	
* Fecha CreaciÃ³n	: <\FC	2019/05/23	FC\>
*------------------------------------------------------------------------------------------------------------------------------------------*/
CREATE Procedure [dbo].[spRegistrarCriteriosLiquidacionPLUS]
	@lnNuevoConsCodigoLiquidacion udtConsecutivo,
	@mnsje_slda				varchar(750)	Output,
	@cdgo_slda				udtCodigo		Output	
As
Begin
	Set Nocount On

	Declare @lnMaxCnsctvo_cdgo_crtro_lqdcn int=0,
			@filasAfectadas INT=0

	Begin Try 
	
		Set @mnsje_slda	= '';
		Set @cdgo_slda = 0;

		Select @lnMaxCnsctvo_cdgo_crtro_lqdcn=isnull(max(cnsctvo_cdgo_crtro_lqdcn),0) From dbo.tbcriteriosliquidacion;

		insert into dbo.tbcriteriosliquidacion
		(
			cnsctvo_cdgo_crtro_lqdcn,
			cnsctvo_cdgo_lqdcn,
			cnsctvo_cdgo_sde,
			nmro_unco_idntfccn_empldr,
			cnsctvo_scrsl,
			cnsctvo_cdgo_clse_aprtnte
		)
		Select	
				(nmro_rgstro	+	@lnMaxCnsctvo_cdgo_crtro_lqdcn ),
				@lnNuevoConsCodigoLiquidacion,	
				cnsctvo_cdgo_sde,
				nmro_unco_idntfccn_empldr,
				cnsctvo_scrsl,
				cnsctvo_cdgo_clse_aprtnte
		From	#tmpSucursalesProducto  

		SET @filasAfectadas=@@ROWCOUNT

		Set @mnsje_slda	= 'Se crearon '+CAST(@filasAfectadas AS VARCHAR(12))+ ' criterios de liquidacion'; 


	End Try
	Begin Catch
		Set @mnsje_slda	= OBJECT_NAME(@@PROCID)+' '+Concat(ERROR_MESSAGE(), ' ', ERROR_PROCEDURE(), ' ', ERROR_LINE());
		Set @cdgo_slda	= 1;
	End Catch
	
End
