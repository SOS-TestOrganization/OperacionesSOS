
/*------------------------------------------------------------------------------------------------------------------------------------------
* MÃ©todo o PRG		:		spEjecutarLiquidacionPLUS							
* Desarrollado por	: <\A	Carlos Vela - Qvision	A\>	
* DescripciÃ³n		: <\D	Ejecuta la liquidacion de planes plus, dado el concepto D\>
* Observaciones		: <\O 	O\>	
* ParÃ¡metros		: <\P 	P\>	
* Variables			: <\V	V\>	
* Fecha CreaciÃ³n	: <\FC	2019/05/30	FC\>

*------------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*-------------------------------------------------------------------------------------------------------------------------------
* Modificado Por:       <\AM Carlos Vela                                                                         AM\>
* Descripcion:          <\DM Se adjunta el log de liquidaciones al correo        DM\>
* Nuevos Parametros:    <\PM                                                                                             PM\>
* Nuevas Variables:     <\VM                                                                                             VM\>
* Fecha Modificacion:   <\FM 2019/06/05                                                                              FM\>
*--------------------------------------------------------------------------------------------------------------------------------
*/

CREATE Procedure [dbo].[spEjecutarLiquidacionPLUS]
	@lnConceptoLiquidacion	udtConsecutivo
As
Begin
	Set Nocount On

DECLARE  @lcUsuario dbo.udtUsuario,
		 @mnsje_slda varchar(1000),
		 @cdgo_slda int,
		 @mensaje VARCHAR(3000)='',  
		 @asunto VARCHAR(250)='Inicio proceso de liquidacion',
		 @detalleEjecucion varchar(5000),
		 @desConceptoLiquidacion udtDescripcion,
		 @lnConsCodigoLiquidacionGenerado udtConsecutivo =0,
		 @PERFIL_CORREO varchar(50),  
		 @USUARIOS_DESTINO varchar(250),
         @ldFechaSistema datetime=getdate(),
         @ARCHIVO_LOG_LIQ   varchar(50),
         @QUERY_RESULT_AS_FILE BIT = 1,
         @RESULT_SEPARATOR char(1) = ',',
         @RESULT_NO_PADDING BIT  = 1,
         @RESULT_WIDTH  int= 1000,
         @HTML_FORMAT varchar(20)='HTML'          
	 

	Begin Try 
		
		SELECT top 1 
			@lcUsuario=vlr_prmtro_crctr 
		FROM dbo.tbParametrosGenerales_vigencias With(NoLock) 
		WHERE dscrpcn_prmtro_gnrl='CARTERA_PLUS_USUARIO_CREACION' 
			And @ldFechaSistema between inco_vgnca and fn_vgnca;

		SELECT @lcUsuario= ISNULL(cast(SESSION_CONTEXT(N'quick_usro_crcn') as varchar(30)),@lcUsuario); 

		SELECT top 1 
			@USUARIOS_DESTINO=vlr_prmtro_crctr 
		FROM dbo.tbParametrosGenerales_vigencias With(NoLock) 
		WHERE dscrpcn_prmtro_gnrl='CARTERA_PLUS_CORREOS_DESTINATARIOS'
			And @ldFechaSistema between inco_vgnca and fn_vgnca

		SELECT top 1 
			@PERFIL_CORREO=vlr_prmtro_crctr 
		FROM dbo.tbParametrosGenerales_vigencias With(NoLock) 
		WHERE dscrpcn_prmtro_gnrl='CARTERA_PLUS_PERFIL_CORREO'
			And @ldFechaSistema between inco_vgnca and fn_vgnca

		--Llamamos al liquidador
		EXEC [dbo].[spControladorEstadoCuentaPLUS] 
		   @lcUsuario
		  ,@lnConceptoLiquidacion
		  ,@mnsje_slda OUTPUT
		  ,@cdgo_slda OUTPUT
		  ,@detalleEjecucion output
		  ,@lnConsCodigoLiquidacionGenerado Output

		 SET @mnsje_slda=ISNULL(@mnsje_slda,'mensaje nulo controlador');

		--Si se genero una liquidacion recuperamos el mensaje con el resumen del estado de cuenta
		If isnull(@lnConsCodigoLiquidacionGenerado,0)>0 
			begin
				
				EXEC dbo.spMensajeRespuestaLiquidacionPLUS
						@lnConsCodigoLiquidacionGenerado,
						@lnConceptoLiquidacion,
						@asunto Output,
						@mensaje Output	

			end 
		Else
			Begin

				-- Si no se genero la liquidaciÃ³n, se presenta el mensaje del controlador
				Select 
					@desConceptoLiquidacion  = dscrpcn_cncpto_lqdcn  
				from dbo.tbConceptosLiquidacion With(NoLock) 
				Where cnsctvo_cdgo_cncpto_lqdcn=@lnConceptoLiquidacion

				SET @asunto = 'ERROR: FinalizaciÃ³n proceso facturacion '+@desConceptoLiquidacion
				SET @mensaje =  @mnsje_slda
			End 


		--Si no fue posible generar el estado de cuenta, se concatena la razÃ³n tÃ©cnica.
		IF  @cdgo_slda = 1
			begin
				SET @mensaje = @mensaje+ @mnsje_slda
			end
			
		EXEC [msdb].[dbo].[spEnvioEmailGeneral]  @profile_name	= @PERFIL_CORREO,
													 @recipients	= @USUARIOS_DESTINO,        
												     @subject		= @asunto, 
													 @body			= @mensaje,
													 @body_format	= @HTML_FORMAT
		--Imprimimos el log de liquidaciones
				Select 
					cnsctvo_cdgo_lqdcn NumLiquidacion,
					cdgo_tpo_idntfccn TipoIdent,
					nmro_idntfccn NumIdent,
					nombre Nombre,
					causa Causa,
					nmro_cntrto NumContrato,
					convert(varchar, inco_vgnca_cntrto, 101) IniVigContrato,
					convert(varchar, fn_vgnca_cntrto, 101) FinVigContratro,
					nmro_unco_idntfccn_afldo NumIdentUnicoAfiliado,
					cdgo_pln CodigoPlan,
					dscrpcn_pln DescPlan,
					nmro_unco_idntfccn_aprtnte NumUnicoIdentAportante,
					nmbre_scrsl NombreSucursal,
					dscrpcn_clse_aprtnte DescClaseAportante,
					tpo_idntfccn_scrsl TipoIdentSucursal,
					nmro_idntfccn_scrsl NumIdentSucursal,
					cdgo_sde CodigoSede,
					dscrpcn_sde DescSede 
				From BDCarteraPAC.dbo.tbLogliquidacionesContratos With(NoLock) 
				Where cnsctvo_cdgo_lqdcn =@lnConsCodigoLiquidacionGenerado 


	End Try
	Begin Catch
		Set @mensaje	= 'ERROR: ' +ERROR_PROCEDURE()+' '+Concat(ERROR_MESSAGE(), ' ', ERROR_PROCEDURE(), ' ', ERROR_LINE());
		

            EXEC [msdb].[dbo].[spEnvioEmailGeneral]  @profile_name	= @PERFIL_CORREO,
													 @recipients	= @USUARIOS_DESTINO,        
												     @subject		= @asunto, 
													 @body			= @mensaje,
													 @body_format	= @HTML_FORMAT
													 
		SELECT @mensaje ERROR

	End Catch
End

