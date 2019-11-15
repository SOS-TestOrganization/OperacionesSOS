
/*---------------------------------------------------------------------------------
* Metodo o PRG 		:  SpGrabarLiquidacion
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento grabar una liquidacion dependiendo del tipo de operacion  uno nuevo  o actualizar	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003/03/04											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  Rolando Simbaqueva Lasso AM\>
* Descripcion			: <\DM Aplicacion tecnicas de optimizacion DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  2005 /09 / 26  FM\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM  Francisco Eduardo Riaño L. - Qvision S.A AM\>
* Descripcion			: <\DM Ajustes Facturacion electronica DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion	: <\FM  2019-05-10 FM\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM  Francisco Eduardo Riaño L. - Qvision S.A AM\>
* Descripcion			: <\DM Ajustes control de cambio que permite seleccionar el periodo a liquidar DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion	: <\FM  2019-07-18 FM\>
*---------------------------------------------------------------------------------
declare @lnProcesoExitoso int,
			@lcMensaje varchar(max);
	
exec dbo.[spGrabarLiquidacion] '2',2,'',0,'carcfh01',@lnProcesoExitoso,@lcMensaje,233

select @lnProcesoExitoso, @lcMensaje

*/
CREATE PROCEDURE [dbo].[spGrabarLiquidacion]
(	
	@lcTipoOperacion						char(1),
	@lnConsecutivoTipoProceso				udtConsecutivo,
	@lcObservaciones						varchar(250),
	@lnNumeroLiquidacion					udtconsecutivo,	
	@lcUsuario								udtUsuario,
	@lnProcesoExitoso						int		output,
	@lcMensaje								char(200)	output,
	@lnConsecutivoCodigoPeriodoLiquidacion	udtconsecutivo
)
As	
Begin
	Set Nocount On;

	Declare		@lnConsecutivoEstadoLiquidacion			udtconsecutivo = 1,
				@lnConsecutivoCodigoLiquidacion			udtconsecutivo,
				@ldFechaSistema							datetime =	getdate(),	
				@ldFechaEvaluarPeriodo					datetime, 
				@lnCantidadPeriodosEstadoAbierto		int,
				@lnNumeroPeriodosEvaluados				int,
   				@lnCnsctvo_cdgo_crtro_lqdcn				int,
				@lnConsecutivoTipoProcesoAnterior		Int,
				@MaximoEstadoHistoricoLiquidacion		udtConsecutivo,
				@lcestadoactual							int,
				@lnconsecutivoliquidacion				int	
	
	Set	@ldFechaEvaluarPeriodo	=	DATEADD ( month , 1, @ldFechaSistema ) ;

	Select  @lnconsecutivoliquidacion = max(cnsctvo_Cdgo_lqdcn) 
	From	dbo.tbLiquidaciones with(nolock)

	Select  @lcestadoactual		= cnsctvo_cdgo_estdo_lqdcn 
	From	dbo.tbLiquidaciones with(nolock)
	Where	cnsctvo_Cdgo_lqdcn	= @lnconsecutivoliquidacion

	If	@lcestadoactual	in (5,6)
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Existe una liquidación procesada o finalizada de pruebas y no se puede grabar la liquidación'
		Return -1
	End	

	-- Creacion de tablas temporales
	Create table #TmpSucursalesLIquidarFinal
	(
		nmro_rgstro					int IDENTITY(1,1), 
		cnsctvo_cdgo_sde			int,
		nmro_unco_idntfccn_empldr	int,
		cnsctvo_scrsl				int,
		cnsctvo_cdgo_clse_aprtnte	int
	 )

	Create table #TmpSucursalesLIquidarNuevos
	(
		nmro_rgstro					int IDENTITY(1,1), 
		cnsctvo_cdgo_sde			int,
		nmro_unco_idntfccn_empldr	int,
		cnsctvo_scrsl				int,
		cnsctvo_cdgo_clse_aprtnte	int
	)
		

	Create table #TmpSucursalesLIquidarFinalNuevos1	
	(
		nmro_rgstro					int IDENTITY(1,1), 
		cnsctvo_cdgo_sde			int,
		nmro_unco_idntfccn_empldr	int,
		cnsctvo_scrsl				int,
		cnsctvo_cdgo_clse_aprtnte	int
	)
					
	Set	@lnProcesoExitoso				=	0

	-- se calcula el numero de periodos con estado abierto
	Select	@lnCantidadPeriodosEstadoAbierto	=	 count(*)	
	From	dbo.Tbperiodosliquidacion_vigencias with(nolock)
	Where  	cnsctvo_cdgo_estdo_prdo	=	2

	-- se verifica la validacion del numero de peridos con estado abierto
	If  @lnCantidadPeriodosEstadoAbierto=0  -- or @lnCantidadPeriodosEstadoAbierto>=2
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'No existe un solo periodo con estado abierto para generar la liquidación'
		Return -1
	end	

	--Se verifica que le periodo que tiene el estado abierto sea el siguiente al periodo actual
	Select	 @lnNumeroPeriodosEvaluados	=	count(*)  
	From	 dbo.tbperiodosliquidacion_vigencias with(nolock)
	Where	(bdrecaudos.dbo.fncalculaperiodo(@ldFechaEvaluarPeriodo)	  > = 	bdrecaudos.dbo.fncalculaperiodo(fcha_incl_prdo_lqdcn)
			And		bdrecaudos.dbo.fncalculaperiodo(@ldFechaEvaluarPeriodo)	   <= 	bdrecaudos.dbo.fncalculaperiodo(fcha_fnl_prdo_lqdcn))
	and  	@ldFechaSistema 	   	between  inco_vgnca   		and      fn_vgnca
	and  	cnsctvo_cdgo_estdo_prdo	=	2	-- estado del periodo abierto

	If  @lnNumeroPeriodosEvaluados <>	1		
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'El periodo esta en un rango no que no se puede liquidar'
		Return -1
	end	

	--Se traer el consecutivo del periodo de liquidacion
	--select	@lnConsecutivoCodigoPeriodoLiquidacion	 =	 cnsctvo_cdgo_prdo_lqdcn  
	--from	dbo.tbperiodosliquidacion_vigencias with(nolock)
	--Where	(bdrecaudos.dbo.fncalculaperiodo(@ldFechaEvaluarPeriodo)	  > = 	bdrecaudos.dbo.fncalculaperiodo(fcha_incl_prdo_lqdcn)
	-- And         bdrecaudos.dbo.fncalculaperiodo(@ldFechaEvaluarPeriodo)	   <= 	bdrecaudos.dbo.fncalculaperiodo(fcha_fnl_prdo_lqdcn))
	--and  	  @ldFechaSistema 	   	between  inco_vgnca   		and      fn_vgnca
	--and  	  cnsctvo_cdgo_estdo_prdo	=	2	-- estado del periodo abierto

	Select  @lnConsecutivoCodigoLiquidacion = isnull(max(cnsctvo_cdgo_lqdcn),0)	
	From	dbo.tbliquidaciones with(nolock)

	Begin Tran Uno

	If	@lcTipoOperacion	=	'1'	-- seleccino nueva
	Begin
		Insert into dbo.tbliquidaciones
		(
			cnsctvo_cdgo_lqdcn,				 cnsctvo_cdgo_prdo_lqdcn,			cnsctvo_cdgo_estdo_lqdcn,
			cnsctvo_cdgo_tpo_prcso,			 nmro_estds_cnta,					vlr_lqddo,
			nmro_cntrts,					 fcha_crcn,							usro_crcn,
			fcha_inco_prcso,				 fcha_fnl_prcso,					obsrvcns
		)
		Values
		(
			(@lnConsecutivoCodigoLiquidacion  + 1),	@lnConsecutivoCodigoPeriodoLiquidacion,	@lnConsecutivoEstadoLiquidacion,
			 @lnConsecutivoTipoProceso,				0,										0,
			 0,										getdate(),								@lcUsuario,
			 Null,									Null,									@lcObservaciones
		)

		If  @@error!=0  
		Begin 
			Set	@lnProcesoExitoso	=	1
			Set	@lcMensaje		=	'Error creando la liquidacion'
			Rollback tran uno
			Return -1
		end	
	
		If	@lnConsecutivoTipoProceso	=	1 -- individual
		Begin 
			-- se crea la tabla temporal para  porder contralar el consecutivo de la tabla
			Insert into	#TmpSucursalesLIquidarFinal  
			Select	cnsctvo_cdgo_sde,
					nmro_unco_idntfccn_empldr,
					cnsctvo_scrsl,
					cnsctvo_cdgo_clse_aprtnte
			From	#TMPsucursalesLiquidarSeleccionadas
		
			--	Drop table #TMPsucursalesLiquidarSeleccionadas
			-- se calcula em maximo numero que sigue de la tabla
			Select	@lnCnsctvo_cdgo_crtro_lqdcn	= isnull(max(Cnsctvo_cdgo_crtro_lqdcn),0)
			From	dbo.tbcriteriosliquidacion  with(nolock)
			-- se insertan los registros en la tabla tbcriteriosliquidacion

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
					(nmro_rgstro	+	@lnCnsctvo_cdgo_crtro_lqdcn ),
					(@lnConsecutivoCodigoLiquidacion  + 1),	
					cnsctvo_cdgo_sde,
					nmro_unco_idntfccn_empldr,
					cnsctvo_scrsl,
					cnsctvo_cdgo_clse_aprtnte
			From	#TmpSucursalesLIquidarFinal  

			If  @@error!=0  
			Begin 
				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje		=	'Error creando los criterios de liquidacion'
				Rollback tran uno
				Return -1
			end	

		end	

		--Se inserta el estado de la liquidacion	
		Select 	@MaximoEstadoHistoricoLiquidacion	=	isnull(max(cnsctvo_hstrco_estdo_lqdcn),0) + 1	
		From	dbo.tbHistoricoEstadoLiquidacion

		Insert into	dbo.tbHistoricoEstadoLiquidacion
		(
			cnsctvo_hstrco_estdo_lqdcn,
			cnsctvo_cdgo_estdo_lqdcn,
			cnsctvo_cdgo_lqdcn,
			nmro_estds_cnta,			
			vlr_lqddo,
			nmro_cntrts,
			usro_crcn,
			fcha_crcn
		)
		Values	
		(
			@MaximoEstadoHistoricoLiquidacion,
			@lnConsecutivoEstadoLiquidacion,
			@lnConsecutivoCodigoLiquidacion  + 1,
			0,
			0,
			0,
			@lcUsuario,
			@ldFechaSistema
		)
						
	end

	If 	@lcTipoOperacion	=	'2'	
	-- se actualiza  la liquidacion
	Begin

		Select  @lnConsecutivoTipoProcesoAnterior	=	cnsctvo_cdgo_tpo_prcso		
		From	dbo.tbliquidaciones
		Where 	cnsctvo_cdgo_lqdcn	=	@lnNumeroLiquidacion
			
		Update 	dbo.tbliquidaciones
		Set		obsrvcns				=	@lcObservaciones,
				cnsctvo_cdgo_tpo_prcso	=   @lnConsecutivoTipoProceso
		Where 	cnsctvo_cdgo_lqdcn		=	@lnNumeroLiquidacion
			
		If  @@error!=0  
		Begin 
			Set	@lnProcesoExitoso	=	1
			Set	@lcMensaje			=	'Error Actualizando la liquidacion'
			Rollback tran uno
			Return -1
		end	

		If	@lnConsecutivoTipoProcesoAnterior 	=	@lnConsecutivoTipoProceso	and		@lnConsecutivoTipoProceso	=	1
		Begin			
			Update		a
			Set			cnsctvo_cdgo_sde	 =	 b.cnsctvo_cdgo_sde
			From		dbo.tbcriteriosliquidacion				a 
			inner join	#TMPsucursalesLiquidarSeleccionadas		b
				on		(a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
						And	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl
						And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte)
			Where		cnsctvo_cdgo_lqdcn		=	@lnNumeroLiquidacion

			If  @@error!=0  
			Begin 
				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje		=	'Error Actualizando los criterios liquidacion'
				Rollback tran uno
				Return -1
			end	


			Delete	from dbo.tbcriteriosliquidacion
			From	dbo.tbcriteriosliquidacion	
			Where 	cnsctvo_cdgo_lqdcn		=	@lnNumeroLiquidacion
			And	 ltrim(rtrim(str(nmro_unco_idntfccn_empldr))) 	           +	  ltrim(rtrim(str(cnsctvo_scrsl))) +    ltrim(rtrim(str(cnsctvo_cdgo_clse_aprtnte))) 
				 not in (Select ltrim(rtrim(str(nmro_unco_idntfccn_empldr))) +  ltrim(rtrim(str(cnsctvo_scrsl))) +    ltrim(rtrim(str(cnsctvo_cdgo_clse_aprtnte)))  From	#TMPsucursalesLiquidarSeleccionadas)
				
			If  @@error!=0  
			Begin 
				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje		=	'Error eliminado los criterios'
				Rollback tran uno
				Return -1
			end	

			-- se crea una tabla temporal con los nuevos registros 
			Insert into #TmpSucursalesLIquidarNuevos
			(
				cnsctvo_cdgo_sde,
				nmro_unco_idntfccn_empldr,
				cnsctvo_scrsl,
				cnsctvo_cdgo_clse_aprtnte
			)
			Select	cnsctvo_cdgo_sde,
					nmro_unco_idntfccn_empldr,
					cnsctvo_scrsl,
					cnsctvo_cdgo_clse_aprtnte
			From	#TMPsucursalesLiquidarSeleccionadas
			Where 	ltrim(rtrim(str(nmro_unco_idntfccn_empldr))) 	    +  ltrim(rtrim(str(cnsctvo_scrsl))) +    ltrim(rtrim(str(cnsctvo_cdgo_clse_aprtnte))) 
			 not in (Select ltrim(rtrim(str(nmro_unco_idntfccn_empldr))) +  ltrim(rtrim(str(cnsctvo_scrsl))) +    ltrim(rtrim(str(cnsctvo_cdgo_clse_aprtnte))) 
			            From	dbo.tbcriteriosliquidacion
						Where	cnsctvo_cdgo_lqdcn		=	@lnNumeroLiquidacion) 

			--drop table #TMPsucursalesLiquidarSeleccionadas
			-- se calcula em maximo numero que sigue de la tabla
			Select	@lnCnsctvo_cdgo_crtro_lqdcn	= isnull(max(Cnsctvo_cdgo_crtro_lqdcn),0)
			From	dbo.tbcriteriosliquidacion  


			-- se insertan los registros en la tabla tbcriteriosliquidacion para los del tipo de proceso individual
			Insert into dbo.tbcriteriosliquidacion
			(
				cnsctvo_cdgo_crtro_lqdcn,
				cnsctvo_cdgo_lqdcn,
				cnsctvo_cdgo_sde,
				nmro_unco_idntfccn_empldr,
				cnsctvo_scrsl,
				cnsctvo_cdgo_clse_aprtnte
			)
			Select	
					(nmro_rgstro	+	@lnCnsctvo_cdgo_crtro_lqdcn ),
					@lnNumeroLiquidacion,
					cnsctvo_cdgo_sde,
					nmro_unco_idntfccn_empldr,
					cnsctvo_scrsl,
					cnsctvo_cdgo_clse_aprtnte
			From	#TmpSucursalesLIquidarNuevos  

			If  @@error!=0  
			Begin 
				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje		=	'Error creando los nuevos  criterios'
				Rollback tran uno
				Return -1
			end	

		End
		Else	
		Begin
			If 	@lnConsecutivoTipoProcesoAnterior	=	1	AND 	@lnConsecutivoTipoProceso	=	2
			--individual 								masivo
			Begin
				-- como el anterior era individual y ahora es masivo se deben de borrar los criterios anteriores
				Delete	from dbo.tbcriteriosliquidacion
				From	dbo.tbcriteriosliquidacion	
				Where 	cnsctvo_cdgo_lqdcn		=	@lnNumeroLiquidacion

				If  @@error!=0  
				Begin 
					Set	@lnProcesoExitoso	=	1
					Set	@lcMensaje		=	'Error borrando los creterios del proceso individual'
					Rollback tran uno
					Return -1
				end	

			 End
			 Else
			 Begin

				Insert into	#TmpSucursalesLIquidarFinalNuevos1  
				Select	cnsctvo_cdgo_sde,
						nmro_unco_idntfccn_empldr,
						cnsctvo_scrsl,
						cnsctvo_cdgo_clse_aprtnte
				From	#TMPsucursalesLiquidarSeleccionadas

				--drop table #TMPsucursalesLiquidarSeleccionadas

				-- se calcula em maximo numero que sigue de la tabla
				Select	@lnCnsctvo_cdgo_crtro_lqdcn	= isnull(max(Cnsctvo_cdgo_crtro_lqdcn),0)
				From	dbo.tbcriteriosliquidacion  

				-- se insertan los registros en la tabla tbcriteriosliquidacion
		
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
						(nmro_rgstro	+	@lnCnsctvo_cdgo_crtro_lqdcn ),
						@lnNumeroLiquidacion,	
						cnsctvo_cdgo_sde,
						nmro_unco_idntfccn_empldr,
						cnsctvo_scrsl,
						cnsctvo_cdgo_clse_aprtnte
				From	#TmpSucursalesLIquidarFinalNuevos1  

				If  @@error!=0  
				Begin 
					Set	@lnProcesoExitoso	=	1
					Set	@lcMensaje		=	'Error creando los criterios nuevos  de liquidacion'
					Rollback tran uno
					Return -1
				end	


			End
		End
				
	    Select 	@MaximoEstadoHistoricoLiquidacion	=	isnull(max(cnsctvo_hstrco_estdo_lqdcn),0) + 1	
		From	dbo.tbHistoricoEstadoLiquidacion with(nolock)
		
		Insert into	dbo.tbHistoricoEstadoLiquidacion
		(
			cnsctvo_hstrco_estdo_lqdcn,
			cnsctvo_cdgo_estdo_lqdcn,
			cnsctvo_cdgo_lqdcn,
			nmro_estds_cnta,			
			vlr_lqddo,
			nmro_cntrts,
			usro_crcn,
			fcha_crcn
		)
		Values	
		(
			@MaximoEstadoHistoricoLiquidacion,
			@lnConsecutivoEstadoLiquidacion,
			@lnNumeroLiquidacion,
			0,
			0,
			0,
			@lcUsuario,
			@ldFechaSistema
		)
					
	End	
	Commit tran uno

End