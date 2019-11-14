
/*------------------------------------------------------------------------------------------------------------------------------------------
* MÃ©todo o PRG		:		spMensajeRespuestaLiquidacionPLUS							
* Desarrollado por	: <\A	Carlos Vela - Qvision	A\>	
* DescripciÃ³n		: <\D	Retorna el asunto y el cuerpo del mensaje del proceso de liquidacion D\>
* Observaciones		: <\O 	O\>	
* ParÃ¡metros		: <\P 	P\>	
* Variables			: <\V	V\>	
* Fecha CreaciÃ³n	: <\FC	2019/05/30	FC\>
*------------------------------------------------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[spMensajeRespuestaLiquidacionPLUS]
	@lnConsecutivoCodigoLiquidacion udtConsecutivo,
	@lnConceptoLiquidacion	udtConsecutivo	,
	@asunto					varchar(250) Output,
	@mensaje				varchar(2000) Output
As
Begin
	Set Nocount On

	DECLARE @textoHTML varchar(2000),
			@numEstadosCuenta int=0,
			@minNumEstadoCuenta int=0,
			@maxNumEstadoCuenta	int=0,
			@total udtValorDecimales=0,
			@desConceptoLiquidacion udtDescripcion='Concepto Nulo'

	IF OBJECT_ID('tempdb.dbo.#tmpEstadosCuentaResumen') IS NOT NULL 
		DROP TABLE #tmpEstadosCuentaResumen

	Begin Try 

		Select 
			@desConceptoLiquidacion  = dscrpcn_cncpto_lqdcn  
		from dbo.tbConceptosLiquidacion With(NoLock)
		Where cnsctvo_cdgo_cncpto_lqdcn=@lnConceptoLiquidacion

		SET @asunto= 'Finalizacion proceso facturacion '+@desConceptoLiquidacion

		select a.cnsctvo_estdo_cnta,a.nmro_estdo_cnta, a.ttl_fctrdo  
		into #tmpEstadosCuentaResumen
		from tbEstadosCuenta a With(NoLock)
		 where cnsctvo_cdgo_lqdcn = @lnConsecutivoCodigoLiquidacion

		--Estados de Cuenta Generados
		Select @numEstadosCuenta=isnull(count(*),0) 
		from #tmpEstadosCuentaResumen

		Select 
			@minNumEstadoCuenta = isnull(min(nmro_estdo_cnta),0), 
			@maxNumEstadoCuenta = isnull(max(nmro_estdo_cnta),0), 
			@total = isnull(sum(ttl_fctrdo),0)  
		From #tmpEstadosCuentaResumen
		
		SET @mensaje = '<p>El proceso de facturaci&oacute;n '+@desConceptoLiquidacion+'  finaliz&oacute; con los siguientes resultados :</p>'  
		SET @mensaje +='<p>N&uacute;mero de liquidaci&oacute;n: '+cast(@lnConsecutivoCodigoLiquidacion as varchar(12))+'<br/>'
		SET @mensaje +='Estados de cuenta generados: '+cast(@numEstadosCuenta as varchar(12))+'<br/>'
		SET @mensaje +='N&uacute;mero estado de cuenta : Del '+cast(@minNumEstadoCuenta as varchar(12))+' al '+cast(@maxNumEstadoCuenta as varchar(12))+'<br/>'
		SET @mensaje +='Valor total: '+isnull(FORMAT(@total, 'C', 'es-co'),'0')+'</p>'

	End Try
	Begin Catch
		Set @mensaje	= 'ERROR: ' +ERROR_PROCEDURE()+' '+Concat(ERROR_MESSAGE(), ' ', ERROR_PROCEDURE(), ' ', ERROR_LINE());

	End Catch

	IF OBJECT_ID('tempdb.dbo.#tmpEstadosCuentaResumen') IS NOT NULL 
		DROP TABLE #tmpEstadosCuentaResumen
	
End
