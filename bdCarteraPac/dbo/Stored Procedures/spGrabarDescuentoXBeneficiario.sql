/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spGrabarDescuentoXBeneficiario
* Desarrollado por		: <\A Ing. Rolando Simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento es el encargado de grabar el grupo de tarifas para el aportante			D\>
* Observaciones			: <\O	O\>
* Parametros			: <\P Variable que permite identificar el tipo de operacion a realizar						P\>
*				  <\P Fecha de elaboracion de la novedad									P\>
*				  <\P Fecha de recibido de la novedad									P\>
*				  <\P Numero de radicación de la novedad								P\>
*				  <\P Consecutivo del estado de la novedad								P\>
*				  <\P Tipo de Novedad que se realizará									P\>
*				  <\P Consecutivo de la causa de la Novedad								P\>
*				  <\P Usuario de radicación de la novedad									P\>
*				  <\P Observaciones de la novedad									P\>
*				  <\P consecutivo de la novedad si es una actualizacion							P\>
*				  <\P 0 si el proceso fue exitoso, en caso contrario 1							P\>
* Fecha Creacion		: <\FC 2003/07/01 											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  FM\>
*---------------------------------------------------------------------------------*/
CREATE  PROCEDURE spGrabarDescuentoXBeneficiario
@lnOperacion						Int,
@lnOperacionVigencia					int,	
@ldFechaIncoVgenca					Datetime,
@ldFechaFinVignca					Datetime,
@lnnmro_unco_idntfccn					Int,
@lncnsctvo_scrsl					Int,
@lncnsctvo_cdgo_clse_aprtnte				Int,
@lncnsctvo_cdgo_dscto					int,
@lncnsctvo_cdgo_rspnsble_dscnto			int,
@lcUsuario						UdtUsuario,
@lnconsecutivoVigencia					int,
@lnConsecutivoautorizador				int	
AS Declare
@lnMaxcnsctvo_cdgo_rspnsble_dscnto			Int,
@lnMaxVigenciascnsctvo_vgnca_rspnsble_dscnto	Int

Set Nocount On
Begin Tran 

if	@lnOperacion	=	1
	--Nuevo
	Begin
		
		Select 	@lnMaxcnsctvo_cdgo_rspnsble_dscnto	 = 		isnull(max(cnsctvo_cdgo_rspnsble_dscnto),0)  + 1	From	bdcarteraPac..tbResponsableXDescuento
		
		Insert into	bdcarteraPac..tbResponsableXDescuento
				(cnsctvo_cdgo_rspnsble_dscnto,		fcha_crcn,			usro_crcn,
				 cnsctvo_cdgo_dscnto,			nmro_unco_idntfccn,		cnsctvo_scrsl,
				cnsctvo_cdgo_clse_aprtnte)
			Values  (@lnMaxcnsctvo_cdgo_rspnsble_dscnto,	 getdate(),			@lcUsuario,
				@lncnsctvo_cdgo_dscto,		@lnnmro_unco_idntfccn,		@lncnsctvo_scrsl,
				@lncnsctvo_cdgo_clse_aprtnte)

		If  @@error!=0  
			Begin 
				Rollback tran uno
				Return -1
			end	


		Select 	@lnMaxVigenciascnsctvo_vgnca_rspnsble_dscnto	 =	 isnull(max(cnsctvo_vgnca_rspnsble_dscnto),0)  + 1	From	bdcarteraPac..tbResponsableXDescuento_vigencias
		
		Insert into	bdcarteraPac..tbResponsableXDescuento_vigencias
				(cnsctvo_vgnca_rspnsble_dscnto,			cnsctvo_cdgo_rspnsble_dscnto,		inco_vgnca,
				fn_vgnca,						fcha_crcn,				usro_crcn,
				cnsctvo_cdgo_dscnto,					nmro_unco_idntfccn,			cnsctvo_scrsl,
				cnsctvo_cdgo_clse_aprtnte,				cnsctvo_cdgo_bse_aplcda,		cnsctvo_cdgo_autrzdr_espcl,
				nmro_idntfccn,						cnsctvo_cdgo_tpo_idntfccn)

			Values  (@lnMaxVigenciascnsctvo_vgnca_rspnsble_dscnto,	 @lnMaxcnsctvo_cdgo_rspnsble_dscnto,	@ldFechaIncoVgenca,			
				@ldFechaFinVignca,					getdate(),				@lcUsuario,
				@lncnsctvo_cdgo_dscto,				@lnnmro_unco_idntfccn,			@lncnsctvo_scrsl,
				@lncnsctvo_cdgo_clse_aprtnte,				1,					@lnConsecutivoautorizador,
				Null,							Null)

		If  @@error!=0  
			Begin 
				Rollback tran uno
				Return -1
			end	


	end	

if	@lnOperacion	=	2
	--Modificar
	Begin
		
		Update 	bdcarteraPac..tbResponsableXDescuento
		Set	nmro_unco_idntfccn		=	@lnnmro_unco_idntfccn
		Where	cnsctvo_cdgo_rspnsble_dscnto	=	@lncnsctvo_cdgo_rspnsble_dscnto

		If  @@error!=0  
			Begin 
				Rollback tran uno
				Return -1
			end	

		Update	bdcarteraPac..tbResponsableXDescuento_vigencias
		Set	nmro_unco_idntfccn		=	@lnnmro_unco_idntfccn,
			cnsctvo_cdgo_autrzdr_espcl	=	@lnConsecutivoautorizador
		Where	cnsctvo_vgnca_rspnsble_dscnto	=	@lnconsecutivoVigencia

		If  @@error!=0  
			Begin 
				Rollback tran uno
				Return -1
			end	
	end	

 
IF	@lnOperacion	=	3
	--Vigencias
	Begin
		
		IF	@lnOperacionVigencia		=	1
			Begin	
					

				Select 	@lnMaxVigenciascnsctvo_vgnca_rspnsble_dscnto	 =	 isnull(max(cnsctvo_vgnca_rspnsble_dscnto),0)  + 1	From	bdcarteraPac..tbResponsableXDescuento_vigencias
		
				Insert into	bdcarteraPac..tbResponsableXDescuento_vigencias
						(cnsctvo_vgnca_rspnsble_dscnto,			cnsctvo_cdgo_rspnsble_dscnto,		inco_vgnca,
						fn_vgnca,						fcha_crcn,				usro_crcn,
						cnsctvo_cdgo_dscnto,					nmro_unco_idntfccn,			cnsctvo_scrsl,
						cnsctvo_cdgo_clse_aprtnte,				cnsctvo_cdgo_bse_aplcda,		cnsctvo_cdgo_autrzdr_espcl,
						nmro_idntfccn,						cnsctvo_cdgo_tpo_idntfccn)

				Values  (@lnMaxVigenciascnsctvo_vgnca_rspnsble_dscnto,		 @lncnsctvo_cdgo_rspnsble_dscnto,	@ldFechaIncoVgenca,			
					@ldFechaFinVignca,						getdate(),				@lcUsuario,
					@lncnsctvo_cdgo_dscto,					@lnnmro_unco_idntfccn,			@lncnsctvo_scrsl,
					@lncnsctvo_cdgo_clse_aprtnte,					1,					@lnConsecutivoautorizador,
					Null,								Null)

				If  @@error!=0  
					Begin 
						Rollback tran uno
						Return -1
					End	

			End	

		IF	@lnOperacionVigencia		=	2

			Begin
				Update	bdcarteraPac..tbResponsableXDescuento_vigencias
				Set	fn_vgnca				=	@ldFechaFinVignca
				Where	cnsctvo_vgnca_rspnsble_dscnto		=	@lnconsecutivoVigencia

				If  @@error!=0  
					Begin 
						Rollback tran uno
						Return -1
					End	

			End
		
		


	End	

Commit Tran