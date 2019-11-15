/*--------------------------------------------------------------------------------------
* Método o PRG		:		dbo.spGuardarInconsistenciasxFacturasPAC							
* Desarrollado por	: <\A	Francisco E. Riaño L. - Qvision S.A	 A\>	
* Descripción		: <\D	Guardar uno o varios log de incosistencias en facturas PAC	D\>
* Observaciones		: <\O   Create Table #tmpParametrosRecibidosIncosistenciasxFacturasPAC
							(
								cnsctvo_estdo_cnta					udtConsecutivo,
								nmbre_cmpo							udtNombreObjeto,
								nmbre_tbla							udtNombreObjeto,
								cnsctvo_cdgo_tpo_incnsstnca_fe		udtConsecutivo,
								cnsctvo_prcso						udtConsecutivo,
								cnsctvo_cdgo_tpo_prcso				udtConsecutivo,
								fcha_crcn							datetime,
								usro_crcn							udtUsuario,
								cnsctvo_incnsstnca_x_estdo_cnta		udtConsecutivo
							) O\>	
* Parámetros		: <\P 	P\>	
* Variables			: <\V	V\>	
* Fecha Creación	: <\FC	2019-09-11 FC\>
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION    
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Modificado Por     : <\AM  AM\>    
* Descripcion        : <\D	 D\> 
* Nuevas Variables   : <\VM  VM\>     
* Fecha Modificacion : <\FM  FM\>    
*-----------------------------------------------------------------------------------------------------------------------------------------------------------------*/

-- exec bdCarteraPAC.dbo.spGuardarInconsistenciasxFacturasPAC

CREATE PROCEDURE  [dbo].[spGuardarInconsistenciasxFacturasPAC](
	@cnsctvo_estdo_cnta					udtConsecutivo	= null,
	@nmbre_cmpo							udtNombreObjeto	= null,
	@nmbre_tbla							udtNombreObjeto	= null,
	@cnsctvo_cdgo_tpo_incnsstnca_fe		udtConsecutivo	= null,
	@cnsctvo_prcso						udtConsecutivo	= null,
	@cnsctvo_cdgo_tpo_prcso				udtConsecutivo	= null,
	@usro_crcn							udtUsuario		= null
)
As
Begin
	Set NoCount On;

	Declare		@ldFechaActual datetime = getdate();

	-- Validamos si generamos inconsistencias por demanda o masivo
	If (@cnsctvo_estdo_cnta is not null)
	Begin
		-- Creamos temporal
		Create Table #tmpParametrosRecibidosIncosistenciasxFacturasPAC
		(
			cnsctvo_estdo_cnta					udtConsecutivo,
			nmbre_cmpo							udtNombreObjeto,
			nmbre_tbla							udtNombreObjeto,
			cnsctvo_cdgo_tpo_incnsstnca_fe		udtConsecutivo,
			cnsctvo_prcso						udtConsecutivo,
			cnsctvo_cdgo_tpo_prcso				udtConsecutivo,
			fcha_crcn							datetime,
			usro_crcn							udtUsuario,
			cnsctvo_incnsstnca_x_estdo_cnta		udtConsecutivo
		)

		create nonclustered	index IX_#tmpParametrosRecibidosIncosistenciasxFacturasPAC
			on  #tmpParametrosRecibidosIncosistenciasxFacturasPAC
        (
            cnsctvo_estdo_cnta
        )

		-- Insertamos parámetros para inconsistencias
		Insert #tmpParametrosRecibidosIncosistenciasxFacturasPAC
		(
			cnsctvo_estdo_cnta,
			nmbre_cmpo,
			nmbre_tbla,
			cnsctvo_cdgo_tpo_incnsstnca_fe,
			cnsctvo_prcso,
			cnsctvo_cdgo_tpo_prcso,
			fcha_crcn,
			usro_crcn								
		)
		Values
		(
			@cnsctvo_estdo_cnta,
			@nmbre_cmpo,
			@nmbre_tbla,
			@cnsctvo_cdgo_tpo_incnsstnca_fe,
			@cnsctvo_prcso,
			@cnsctvo_cdgo_tpo_prcso,
			@ldFechaActual,
			@usro_crcn	
		)
	End

	Begin Tran

	Insert  dbo.tbInconsistenciasxEstadoCuenta
	(
			cnsctvo_estdo_cnta,
			nmbre_cmpo,
			nmbre_tbla,
			cnsctvo_cdgo_tpo_incnsstnca_fe,
			cnsctvo_prcso,
			cnsctvo_cdgo_tpo_prcso,
			fcha_crcn,
			usro_crcn	
	)
	Output Inserted.cnsctvo_incnsstnca_x_estdo_cnta Into #tmpParametrosRecibidosIncosistenciasxFacturasPAC (cnsctvo_incnsstnca_x_estdo_cnta)
	Select
			cnsctvo_estdo_cnta,
			nmbre_cmpo,
			nmbre_tbla,
			cnsctvo_cdgo_tpo_incnsstnca_fe,
			cnsctvo_prcso,
			cnsctvo_cdgo_tpo_prcso,
			fcha_crcn,
			usro_crcn	
	From	#tmpParametrosRecibidosIncosistenciasxFacturasPAC

	If  @@Error!=0
		Begin
			Rollback Tran
			Return -1
		End

	Commit tran

End
