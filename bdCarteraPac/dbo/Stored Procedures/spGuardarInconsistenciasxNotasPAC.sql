/*--------------------------------------------------------------------------------------
* Método o PRG		:		dbo.spGuardarInconsistenciasxNotasPAC							
* Desarrollado por	: <\A	Francisco E. Riaño L. - Qvision S.A	 A\>	
* Descripción		: <\D	Guardar uno o varios log de incosistencias en notas PAC	D\>
* Observaciones		: <\O   Create Table #tmpParametrosRecibidosIncosistenciasxNotasPAC
							(
								nmro_nta							varchar(50),
								cnsctvo_cdgo_tpo_nta				udtConsecutivo,
								nmbre_cmpo							varchar(50),
								nmbre_tbla							varchar(50),
								cnsctvo_cdgo_tpo_incnsstnca_fe		udtConsecutivo,
								cnsctvo_prcso						udtConsecutivo,
								cnsctvo_cdgo_tpo_prcso				udtConsecutivo,
								fcha_crcn							datetime,
								usro_crcn							udtUsuario,
								cnsctvo_incnsstnca_x_nta_pc			udtConsecutivo
							) O\>	
* Parámetros		: <\P 	P\>	
* Variables			: <\V	V\>	
* Fecha Creación	: <\FC	2019-08-28 FC\>
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION    
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Modificado Por     : <\AM  AM\>    
* Descripcion        : <\D	 D\> 
* Nuevas Variables   : <\VM  VM\>     
* Fecha Modificacion : <\FM  FM\>    
*-----------------------------------------------------------------------------------------------------------------------------------------------------------------*/

-- exec bdCarteraPAC.dbo.spGuardarInconsistenciasxNotasPAC

CREATE PROCEDURE  [dbo].[spGuardarInconsistenciasxNotasPAC](
	@nmro_nta							varchar(50)		= null,
	@cnsctvo_cdgo_tpo_nta				udtConsecutivo	= null,
	@nmbre_cmpo							varchar(50)		= null,
	@nmbre_tbla							varchar(50)		= null,
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
	If (@nmro_nta is not null)
	Begin
		-- Creamos temporal
		Create Table #tmpParametrosRecibidosIncosistenciasxNotasPAC
		(
			nmro_nta							varchar(50),
			cnsctvo_cdgo_tpo_nta				udtConsecutivo,
			nmbre_cmpo							varchar(50),
			nmbre_tbla							varchar(50),
			cnsctvo_cdgo_tpo_incnsstnca_fe		udtConsecutivo,
			cnsctvo_prcso						udtConsecutivo,
			cnsctvo_cdgo_tpo_prcso				udtConsecutivo,
			fcha_crcn							datetime,
			usro_crcn							udtUsuario,
			cnsctvo_incnsstnca_x_nta_pc			udtConsecutivo
		)

		create nonclustered	index IX_#tmpParametrosRecibidosIncosistenciasxNotasPAC
			on  #tmpParametrosRecibidosIncosistenciasxNotasPAC
        (
            nmro_nta
        )

		-- Insertamos parámetros para inconsistencias
		Insert #tmpParametrosRecibidosIncosistenciasxNotasPAC
		(
			nmro_nta,
			cnsctvo_cdgo_tpo_nta,
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
			@nmro_nta,
			@cnsctvo_cdgo_tpo_nta,
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

	Insert  dbo.tbInconsistenciasxNotasPAC
	(
			nmro_nta,
			cnsctvo_cdgo_tpo_nta,
			nmbre_cmpo,
			nmbre_tbla,
			cnsctvo_cdgo_tpo_incnsstnca_fe,
			cnsctvo_prcso,
			cnsctvo_cdgo_tpo_prcso,
			fcha_crcn,
			usro_crcn	
	)
	Output Inserted.cnsctvo_incnsstnca_x_nta_pc Into #tmpParametrosRecibidosIncosistenciasxNotasPAC (cnsctvo_incnsstnca_x_nta_pc)
	Select
			nmro_nta,
			cnsctvo_cdgo_tpo_nta,
			nmbre_cmpo,
			nmbre_tbla,
			cnsctvo_cdgo_tpo_incnsstnca_fe,
			cnsctvo_prcso,
			cnsctvo_cdgo_tpo_prcso,
			fcha_crcn,
			usro_crcn	
	From	#tmpParametrosRecibidosIncosistenciasxNotasPAC

	If  @@Error!=0
		Begin
			Rollback Tran
			Return -1
		End

	Commit tran

End
