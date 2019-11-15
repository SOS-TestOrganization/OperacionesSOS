
/*------------------------------------------------------------------------------------------------------------------------------------------
* MÃ©todo o PRG		:		spFinalizarProcesoCarteraPLUS							
* Desarrollado por	: <\A	Carlos Vela - Qvision	A\>	
* DescripciÃ³n		: <\D	Actualiza la fecha de finalizacion del proceso D\>
* Observaciones		: <\O 	O\>	
* ParÃ¡metros		: <\P 	P\>	
* Variables			: <\V	V\>	
* Fecha CreaciÃ³n	: <\FC	2019/05/22	FC\>
*------------------------------------------------------------------------------------------------------------------------------------------*/
CREATE Procedure [dbo].[spFinalizarProcesoCarteraPLUS]
	@idProcesoCarteraPAC udtConsecutivo,
	@mnsje_slda				varchar(750)	Output,
	@cdgo_slda				udtCodigo		Output	
As
Begin
	Set Nocount On

	Begin Try 
	
		Set @mnsje_slda	= '';
		Set @cdgo_slda = 0;

		update dbo.TbProcesosCarteraPac set fcha_fn_prcso=getdate()
		where cnsctvo_prcso=@idProcesoCarteraPAC

		Set @mnsje_slda	= 'Se finalizo el proceso de cartera pac, con cnsctvo_prcso: '+cast(@idProcesoCarteraPAC as varchar(12));

	End Try
	Begin Catch
		Set @mnsje_slda	= ERROR_PROCEDURE()+'-'+Concat(ERROR_MESSAGE(), ' ', ERROR_PROCEDURE(), ' ', ERROR_LINE());
		Set @cdgo_slda	= 1;
	End Catch
	
End
