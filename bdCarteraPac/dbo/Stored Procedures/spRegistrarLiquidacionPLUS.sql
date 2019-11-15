
/*------------------------------------------------------------------------------------------------------------------------------------------
* MÃ©todo o PRG		:		spRegistrarLiquidacionPLUS							
* Desarrollado por	: <\A	Carlos Vela - Qvision	A\>	
* DescripciÃ³n		: <\D	Registra la liquidacion D\>
* Observaciones		: <\O 	O\>	
* ParÃ¡metros		: <\P 	P\>	
* Variables			: <\V	V\>	
* Fecha CreaciÃ³n	: <\FC	2019/05/23	FC\>
*------------------------------------------------------------------------------------------------------------------------------------------*/
CREATE Procedure [dbo].[spRegistrarLiquidacionPLUS]
	@lcUsuario	udtUsuario,
	@lnConsecutivoCodigoPeriodoLiquidacion	int,
	@lnNuevoConsCodigoLiquidacion udtConsecutivo Output,
	@mnsje_slda				varchar(750)	Output,
	@cdgo_slda				udtCodigo		Output	
As
Begin
	Set Nocount On

	Declare @lnConsecutivoCodigoLiquidacion udtConsecutivo,
			@lnConsecutivoEstadoLiquidacion	udtconsecutivo = 1,
			@lcObservaciones				varchar(250)='Proceso Generado por Quick Web',
			@lnConsecutivoTipoProceso		udtConsecutivo=1

	Begin Try 
	
		Set @mnsje_slda	= '';
		Set @cdgo_slda = 0;

		Select  @lnConsecutivoCodigoLiquidacion = isnull(max(cnsctvo_cdgo_lqdcn),0)+1	
		From	dbo.tbliquidaciones

			Insert into dbo.tbliquidaciones
			(
				cnsctvo_cdgo_lqdcn,				 
				cnsctvo_cdgo_prdo_lqdcn,			
				cnsctvo_cdgo_estdo_lqdcn,
				cnsctvo_cdgo_tpo_prcso,			 
				nmro_estds_cnta,					
				vlr_lqddo,
				nmro_cntrts,					 
				fcha_crcn,							
				usro_crcn,
				fcha_inco_prcso,				 
				fcha_fnl_prcso,					
				obsrvcns
			)
			Values
			(
				 @lnConsecutivoCodigoLiquidacion,	
				 @lnConsecutivoCodigoPeriodoLiquidacion,
				 @lnConsecutivoEstadoLiquidacion,
				 @lnConsecutivoTipoProceso,				
				 0,										
				 0,
				 0,										
				 getdate(),
				 @lcUsuario,
				 GETDATE(),
				 Null,
				 @lcObservaciones
			)

		set @lnNuevoConsCodigoLiquidacion=@lnConsecutivoCodigoLiquidacion 

		Set @mnsje_slda	= 'Se genero el id de liquidaciÃ³n: '+cast(@lnNuevoConsCodigoLiquidacion as varchar(12)); 


	End Try
	Begin Catch
		Set @mnsje_slda	= OBJECT_NAME(@@PROCID)+' '+Concat(ERROR_MESSAGE(), ' ', ERROR_PROCEDURE(), ' ', ERROR_LINE());
		Set @cdgo_slda	= 1;
	End Catch
	
End
