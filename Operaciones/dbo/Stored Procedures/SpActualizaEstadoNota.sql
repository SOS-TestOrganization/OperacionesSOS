/*---------------------------------------------------------------------------------
* Metodo o PRG 		:  SpActualizaEstadoNota
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento actualiza el estado de la nota						D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003/03/04											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM andres camnelo (illustrato ltda)  AM\>
* Descripcion			: <\DM  Se agrega instruccion para actualizar los tipos de notas reintegro a estado aplicado DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM 31/10/2013 FM\>
*---------------------------------------------------------------------------------*/
CREATE  PROCEDURE [dbo].[SpActualizaEstadoNota]
	
	@lnNumeroNota					varchar(15),
	@lnConsecutivoEstadoNota			udtConsecutivo,
	@lnTipoNota					udtconsecutivo,
	@lcUsuario					udtUsuario,
	@lnProcesoExitoso				int		output,
	@lcMensaje					char(200)	output

As	Declare
@MaximoEstadoEstadoXNota				int,
@lnValorNota						UdtValorGrande,
@lnValorIva						UdtValorGrande,
@lnSaldoNota						UdtValorGrande,
@ldFechaSistema					datetime,	
@nmro_unco_idntfccn_empldr				udtconsecutivo,
@cnsctvo_scrsl						udtconsecutivo,
@cnsctvo_cdgo_clse_aprtnte				udtconsecutivo,
@ValorNota						UdtValorGrande,
@Cnsctvo_estdo_nta_actl				udtconsecutivo		

	
Set Nocount On		

Set	@ldFechaSistema		=	Getdate()

Select 	@lnValorNota			=	vlr_nta,
	@lnValorIva			=	vlr_iva,
	@lnSaldoNota			=	sldo_nta,
	@Cnsctvo_estdo_nta_actl	=	cnsctvo_cdgo_estdo_nta
From	TbNotasPac
Where	nmro_nta			=	@lnNumeroNota
And	cnsctvo_cdgo_tpo_nta		=	@lnTipoNota

If	@lnTipoNota			=	1	--si el  tipo de nota es debito
	begin
		if  ( @Cnsctvo_estdo_nta_actl	=	2 or 	@Cnsctvo_estdo_nta_actl	=	3	or @Cnsctvo_estdo_nta_actl	=	6)
			begin

				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje		=	'No se puede actualizar la nota  su estado no lo permite'
				Return -1

			end
	end

If	@lnTipoNota			=	2	--si el  tipo de nota es Credito
	begin
		if  ( @Cnsctvo_estdo_nta_actl	=	4 or 	@Cnsctvo_estdo_nta_actl	=	7	or @Cnsctvo_estdo_nta_actl	=	6)
			begin

				Set	@lnProcesoExitoso	=	1
				Set	@lcMensaje		=	'No se puede actualizar la nota  su estado no lo permite'
				Return -1

			end
	end

		
		


Begin Tran Uno
	
Set	@lnProcesoExitoso		=	0

Update 	TbNotasPac
Set	cnsctvo_cdgo_estdo_nta		=	@lnConsecutivoEstadoNota
Where 	nmro_nta			=	@lnNumeroNota
And	cnsctvo_cdgo_tpo_nta		=	@lnTipoNota
			
If  @@error!=0  
		Begin 
			Set	@lnProcesoExitoso	=	1
			Set	@lcMensaje		=	'Error Actualizando estado de la nota'
			Rollback tran uno
			Return -1
		end	

Select 	@MaximoEstadoEstadoXNota	=	isnull(max(cnsctvo_estdo_nta),0) + 1	From	tbestadosXnota
Insert into		tbestadosXnota
			(cnsctvo_estdo_nta,
			 nmro_nta,
			 cnsctvo_cdgo_tpo_nta,
			 cnsctvo_cdgo_estdo_nta,			
			 vlr_nta,
			 vlr_iva,
			 sldo_nta,
			 fcha_cmbo_estdo,
			usro_cmbo_estdo)
		Values	(
			@MaximoEstadoEstadoXNota,
			@lnNumeroNota,
			@lnTipoNota,
			@lnConsecutivoEstadoNota,
			@lnValorNota,
			@lnValorIva,
			@lnSaldoNota,
			@ldFechaSistema,
			@lcUsuario)		
If  @@error!=0  
		Begin 
			Set	@lnProcesoExitoso	=	1
			Set	@lcMensaje		=	'Error Insertando el historico del estado de la nota'
			Rollback tran uno
			Return -1
		end	


if 	@lnConsecutivoEstadoNota	=	6     -- si se anula la nota  se debe actualizar el saldo 
	Begin
		-- se consulta los datos del responsable de la nota 
		Select	@nmro_unco_idntfccn_empldr		=	nmro_unco_idntfccn_empldr,
			@cnsctvo_scrsl				=	cnsctvo_scrsl,
			@cnsctvo_cdgo_clse_aprtnte		=	cnsctvo_cdgo_clse_aprtnte,		
			@ValorNota				=	sldo_nta
		From	TbnotasPac
		Where	nmro_nta				=	@lnNumeroNota
		And	cnsctvo_cdgo_tpo_nta			=	@lnTipoNota


		-- se trae la informacion de contratos asociados a la nota

		Select   cnsctvo_cdgo_tpo_cntrto,
       			nmro_cntrto,
			sldo_nta_cntrto
		into	#TmpNotasContrato
		From      tbNotasContrato
		where    nmro_nta  		=	@lnNumeroNota
		And        cnsctvo_cdgo_tpo_nta	=	@lnTipoNota


		
		if	@lnTipoNota				=	1	--nota debito	
			Begin
				-- se actualiza a borrado el movimiento de la nota debito

				--se actualiza el saldo a nivel de responsable
				Update	tbAcumuladosSucursalAportante
				Set	brrdo		=	 'S'
				where	tpo_dcmnto	=	  2   ---  documento nota debito  en movimientos
				And	nmro_dcmnto	=	@lnNumeroNota

				If  @@error!=0  
					Begin 
						Set	@lnProcesoExitoso	=	1
						Set	@lcMensaje='Error Actualizando el acumulado del aportante'
						Rollback tran 
						Return -1
					end

				Update	tbAcumuladosSucursalAportante
				Set	vlr_sldo	=	vlr_sldo		-	@ValorNota
				where	nmro_unco_idntfccn_empldr	=	@nmro_unco_idntfccn_empldr
				And	cnsctvo_scrsl			=	@cnsctvo_scrsl
				And	cnsctvo_cdgo_clse_aprtnte	=	@cnsctvo_cdgo_clse_aprtnte
				And	ultma_oprcn			=	1

				If  @@error!=0  
					Begin 
						Set	@lnProcesoExitoso	=	1
						Set	@lcMensaje='Error Actualizando el acumulado del aportante'
						Rollback tran 
						Return -1
					end



				-- se actualiza el saldo a nivel de contrato
				Update	TbAcumuladosContrato
				Set	brrdo				=	'S'
				where	tpo_dcmnto			=	 2   ---  documento nota debito  en movimientos
				And	nmro_dcmnto			=	@lnNumeroNota
				And	nmro_unco_idntfccn_empldr	=	@nmro_unco_idntfccn_empldr
				And	cnsctvo_scrsl			=	@cnsctvo_scrsl
				And	cnsctvo_cdgo_clse_aprtnte	=	@cnsctvo_cdgo_clse_aprtnte		

				If  @@error!=0  
					Begin 
						Set	@lnProcesoExitoso	=	1
						Set	@lcMensaje='Error Actualizando el acumulado del contrato'
						Rollback tran 
						Return -1
					end


				Update	TbAcumuladosContrato
				Set	vlr_sldo		=	vlr_sldo		-	sldo_nta_cntrto
				From	TbAcumuladosContrato	a,	#TmpNotasContrato	b
				where	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
				And	a.nmro_cntrto			=	b.nmro_cntrto
				And	a.ultma_oprcn			=	1
				And	a.nmro_unco_idntfccn_empldr	=	@nmro_unco_idntfccn_empldr
				And	a.cnsctvo_scrsl			=	@cnsctvo_scrsl
				And	a.cnsctvo_cdgo_clse_aprtnte	=	@cnsctvo_cdgo_clse_aprtnte		


				If  @@error!=0  
					Begin 
						Set	@lnProcesoExitoso	=	1
						Set	@lcMensaje='Error Actualizando el acumulado del contrato'
						Rollback tran 
						Return -1
					end






			End	


		if	@lnTipoNota				=	2	--	nota credito

			Begin
				Update	tbAcumuladosSucursalAportante
				Set	brrdo		=	'S'
				where	tpo_dcmnto	=	  3   ---  documento nota credito  en movimientos
				And	nmro_dcmnto	=	@lnNumeroNota

				If  @@error!=0  
					Begin 
						Set	@lnProcesoExitoso	=	1
						Set	@lcMensaje='Error Actualizando el acumulado del aportante'
						Rollback tran 
						Return -1
					end

				/*
				-- se actualiza el saldo del responsable
				Update	tbAcumuladosSucursalAportante
				Set	vlr_sldo	=	vlr_sldo		+	@ValorNota
				where	nmro_unco_idntfccn_empldr	=	@nmro_unco_idntfccn_empldr
				And	cnsctvo_scrsl			=	@cnsctvo_scrsl
				And	cnsctvo_cdgo_clse_aprtnte	=	@cnsctvo_cdgo_clse_aprtnte
				And	ultma_oprcn			=	1

				If  @@error!=0  
					Begin 
						Set	@lnProcesoExitoso	=	1
						Set	@lcMensaje='Error Actualizando el acumulado del aportante'
						Rollback tran 
						Return -1
					end
				*/



				-- se actualiza el saldo a nivel de contrato
				Update	TbAcumuladosContrato
				Set	brrdo		=	'S'
				where	tpo_dcmnto			=	 3   ---  documento nota credito   en movimientos
				And	nmro_dcmnto			=	@lnNumeroNota
				And	nmro_unco_idntfccn_empldr	=	@nmro_unco_idntfccn_empldr
				And	cnsctvo_scrsl			=	@cnsctvo_scrsl
				And	cnsctvo_cdgo_clse_aprtnte	=	@cnsctvo_cdgo_clse_aprtnte		


				If  @@error!=0  
					Begin 
						Set	@lnProcesoExitoso	=	1
						Set	@lcMensaje='Error Actualizando el acumulado del contrato'
						Rollback tran 
						Return -1
					end
				/*

				Update	TbAcumuladosContrato
				Set	vlr_sldo		=	vlr_sldo		+	sldo_nta_cntrto
				From	TbAcumuladosContrato	a,	#TmpNotasContrato	b
				where	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
				And	a.nmro_cntrto			=	b.nmro_cntrto
				And	a.ultma_oprcn			=	1
				And	a.nmro_unco_idntfccn_empldr	=	@nmro_unco_idntfccn_empldr
				And	a.cnsctvo_scrsl			=	@cnsctvo_scrsl
				And	a.cnsctvo_cdgo_clse_aprtnte	=	@cnsctvo_cdgo_clse_aprtnte	

				If  @@error!=0  
					Begin 
						Set	@lnProcesoExitoso	=	1
						Set	@lcMensaje='Error Actualizando el acumulado del contrato'
						Rollback tran 
						Return -1
					end

				*/

			End

          if  @lnTipoNota				=	3	--Nota reintegro

           begin
             update  a set a.cnsctvo_cdgo_estdo_pgo = 1  
             from tbPagos a 
             inner join TbDatosAportanteNotaReintegro b with (nolock)
             on (a.cnsctvo_cdgo_pgo = b.cnsctvo_cdgo_pgo)
             where b.nmro_nta = @lnNumeroNota
          end
         

	End
Commit tran uno


