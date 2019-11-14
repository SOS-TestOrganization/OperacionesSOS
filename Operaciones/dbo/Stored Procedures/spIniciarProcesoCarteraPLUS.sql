
/*------------------------------------------------------------------------------------------------------------------------------------------
* MÃ©todo o PRG		:		spIniciarProcesoCarteraPLUS							
* Desarrollado por	: <\A	Carlos Vela - Qvision	A\>	
* DescripciÃ³n		: <\D	Registra el inicio del proceso de cartera plus y retorna el id del proceso D\>
* Observaciones		: <\O 	O\>	
* ParÃ¡metros		: <\P 	P\>	
* Variables			: <\V	V\>	
* Fecha CreaciÃ³n	: <\FC	2019/05/22	FC\>
*------------------------------------------------------------------------------------------------------------------------------------------*/
CREATE Procedure [dbo].[spIniciarProcesoCarteraPLUS]
	@lcUsuario	udtUsuario,
	@lnTipoProceso			int,
	@id_cnsctvo_prcso udtConsecutivo Output,
	@mnsje_slda				varchar(750)	Output,
	@cdgo_slda				udtCodigo		Output	
As
Begin
	Set Nocount On

	Declare @Max_cnsctvo_prcso udtConsecutivo,
		    @Fecha_Inicio_Proceso	Datetime

	Begin Try 
	
		Set @mnsje_slda	= '';
		Set @cdgo_slda = 0;

			--Si el periodo es valido se registra el inicio del proceso 
		Select	@Max_cnsctvo_prcso		=	max(cnsctvo_prcso)+	1
		From	bdcarteraPac.dbo.TbProcesosCarteraPac  With (NoLock)

		Set	@Fecha_Inicio_Proceso		=	Getdate()

		-- Se inicia la ejecuciÃ³n del proceso individual de PAC PLUS
		Insert	into dbo.TbProcesosCarteraPac Values
				(@Max_cnsctvo_prcso,
				@lnTipoProceso,
				@Fecha_Inicio_Proceso,
				NULL,
				@lcUsuario)
		
		Set @id_cnsctvo_prcso=@Max_cnsctvo_prcso

		Set @mnsje_slda	= 'Se genero el id de proceso '+cast(@Max_cnsctvo_prcso as varchar(12))+', exitosamente.';

	End Try
	Begin Catch
		Set @mnsje_slda	= ERROR_PROCEDURE()+'  '+ERROR_MESSAGE()+ ' '+ERROR_PROCEDURE()+ ' '+ERROR_LINE();
		Set @cdgo_slda	= 1;
	End Catch
	
End
