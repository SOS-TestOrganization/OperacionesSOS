
/*------------------------------------------------------------------------------------------ 
* Método o PRG		:	spActualizarIdentificacionAfiliado										 
* Desarrollado por	: <\A	Ing. Cesar García											A\>	 
* Descripción		: <\D	Proceso que actualiza las identificaciones en Salud			D\>	 
* Observaciones		: <\O																O\>	 
* Parámetros		: <\P																P\>	 
* Variables			: <\V																V\>	 
* Fecha Creación	: <\	2015-09-03													FC\> 
*------------------------------------------------------------------------------------------- 
* DATOS DE MODIFICACIÓN																		 
*------------------------------------------------------------------------------------------- 
* Modificado Por	: <\AM																AM\> 
* Descripción		: <\DM																DM\> 
* Nuevos Parámetros	: <\PM																PM\> 
* Nuevas Variables	: <\VM																VM\> 
* Fecha Modificación: <\FM																FM\>
*-----------------------------------------------------------------------------------------*/ 
CREATE Procedure [dbo].[spActualizarIdentificacionAfiliado]

As
Set NoCount On

Create Table #tmpActualizarIdentificaciones
(
	cnsctvo_cdgo_tpo_idntfccn		Int,
	nmro_idntfccn					VarChar(20),
	nmro_unco_idntfccn_afldo		Int,
	cnsctvo_cdgo_tpo_idntfccn_antrr	Int,
	nmro_idntfccn_antrr				VarChar(20),
	fcha_ultma_mdfccn				DateTime,
	fcha_vldcn						DateTime,
	fcha_ultma_mdfccn_rsgo			DateTime,
	fcha_vldcn_hsptlzcn				DateTime,
	inco_vgnca_bnfcro				DateTime,
	cnsctvo_bnfcro					Int
)

Create Table #tmpActualizarIdentificacionesFinal
(
	cnsctvo							Int Identity(1,1),
	cnsctvo_cdgo_tpo_idntfccn		Int,
	nmro_idntfccn					VarChar(20),
	nmro_unco_idntfccn_afldo		Int,
	fcha_ultma_mdfccn				DateTime,
	fcha_vldcn						DateTime,
	fcha_ultma_mdfccn_rsgo			DateTime,
	fcha_vldcn_hsptlzcn				DateTime,
	inco_vgnca_bnfcro				DateTime,
	cnsctvo_bnfcro					Int
)

Declare		@cntdd			Int,
			@fcha_mdfccn	DateTime,
			@fcha_actlzcn	DateTime

Set			@cntdd			=	1
Set			@fcha_mdfccn	=	convert(varchar(10),dateadd(dd,-1,GETDATE()),111)
Set			@fcha_actlzcn	=	GETDATE()

Insert Into		#tmpActualizarIdentificaciones
Select distinct	cnsctvo_cdgo_tpo_idntfccn, nmro_idntfccn, nmro_unco_idntfccn_afldo,
				NULL,	NULL,	NULL,	NULL,	NULL,	NULL, MAX(inco_vgnca_bnfcro) inco_vgnca_bnfcro,
				cnsctvo_bnfcro
From			bdAfiliacionValidador.dbo.tbBeneficiariosValidador With(NoLock)
Group By		cnsctvo_cdgo_tpo_idntfccn, nmro_idntfccn, nmro_unco_idntfccn_afldo, cnsctvo_bnfcro

Update			#tmpActualizarIdentificaciones
Set				cnsctvo_cdgo_tpo_idntfccn_antrr	=	b.cnsctvo_cdgo_tpo_idntfccn,
				nmro_idntfccn_antrr				=	b.nmro_idntfccn,
				fcha_ultma_mdfccn				=	b.fcha_ultma_mdfccn
From			#tmpActualizarIdentificaciones					a
Inner Join		(	Select		cnsctvo_cdgo_tpo_idntfccn, nmro_idntfccn, nmro_unco_idntfccn_afldo, nmro_bnfcro,
								Max(fcha_ultma_mdfccn) fcha_ultma_mdfccn
					From		bdsisalud..tbActua		With(NoLock)
					Where		fcha_ultma_mdfccn	>=	@fcha_mdfccn
					Group By	cnsctvo_cdgo_tpo_idntfccn, nmro_idntfccn, nmro_unco_idntfccn_afldo, nmro_bnfcro
				) b	On	b.nmro_unco_idntfccn_afldo	=	a.nmro_unco_idntfccn_afldo

Update			#tmpActualizarIdentificaciones
Set				cnsctvo_cdgo_tpo_idntfccn_antrr	=	b.cnsctvo_cdgo_tpo_idntfccn,
				nmro_idntfccn_antrr				=	b.nmro_idntfccn,
				fcha_vldcn						=	b.fcha_vldcn	
From			#tmpActualizarIdentificaciones					a
Inner Join		(	Select		cnsctvo_cdgo_tpo_idntfccn, nmro_idntfccn, nmro_unco_idntfccn nmro_unco_idntfccn_afldo, nmro_bnfcro,
								Max(fcha_vldcn) fcha_vldcn
					From		bdSisalud.dbo.tbActuaNotificacion		With(NoLock)
					Where		fcha_vldcn	>=	@fcha_mdfccn
					Group By	cnsctvo_cdgo_tpo_idntfccn, nmro_idntfccn, nmro_unco_idntfccn, nmro_bnfcro
				) b	On	b.nmro_unco_idntfccn_afldo	=	a.nmro_unco_idntfccn_afldo
Where			a.cnsctvo_cdgo_tpo_idntfccn_antrr Is Null
And				a.nmro_idntfccn_antrr Is Null

Update			#tmpActualizarIdentificaciones
Set				cnsctvo_cdgo_tpo_idntfccn_antrr	=	b.cnsctvo_cdgo_tpo_idntfccn,
				nmro_idntfccn_antrr				=	b.nmro_idntfccn,
				fcha_ultma_mdfccn_rsgo			=	b.fcha_ultma_mdfccn	
From			#tmpActualizarIdentificaciones					a
Inner Join		(	Select		cnsctvo_cdgo_tpo_idntfccn, nmro_idntfccn, nmro_unco_idntfccn nmro_unco_idntfccn_afldo, Max(fcha_ultma_mdfccn) fcha_ultma_mdfccn
					From		bdsisalud.dbo.tbAfiliadosRiesgos		With(NoLock)
					Where		fcha_ultma_mdfccn	>=	@fcha_mdfccn
					Group By	cnsctvo_cdgo_tpo_idntfccn, nmro_idntfccn, nmro_unco_idntfccn
				)	b	On	b.nmro_unco_idntfccn_afldo	=	a.nmro_unco_idntfccn_afldo
Where			a.cnsctvo_cdgo_tpo_idntfccn_antrr Is Null
And				a.nmro_idntfccn_antrr Is Null

Update			#tmpActualizarIdentificaciones
Set				cnsctvo_cdgo_tpo_idntfccn_antrr	=	b.cnsctvo_cdgo_tpo_idntfccn,
				nmro_idntfccn_antrr				=	b.nmro_idntfccn,
				fcha_vldcn_hsptlzcn				=	b.fcha_vldcn	
From			#tmpActualizarIdentificaciones					a
Inner Join		(	Select		cnsctvo_cdgo_tpo_idntfccn, nmro_idntfccn, nmro_unco_idntfccn nmro_unco_idntfccn_afldo, nmro_bnfcro,
								Max(fcha_vldcn) fcha_vldcn
					From		bdhospitalizacionmovil..tbmnsncdatosafiliado		With(NoLock)
					Where		fcha_vldcn	>=	@fcha_mdfccn
					Group By	cnsctvo_cdgo_tpo_idntfccn, nmro_idntfccn, nmro_unco_idntfccn, nmro_bnfcro
				) b	On	b.nmro_unco_idntfccn_afldo	=	a.nmro_unco_idntfccn_afldo
Where			a.cnsctvo_cdgo_tpo_idntfccn_antrr Is Null
And				a.nmro_idntfccn_antrr Is Null

-- ELIMINA LOS AFILIADOS QUE NO REQUIEREN ACTUALIZACIÓN
Delete
From			#tmpActualizarIdentificaciones
Where			cnsctvo_cdgo_tpo_idntfccn_antrr Is Null
And				nmro_idntfccn_antrr Is Null

-- INSERTA LOS AFILIADOS QUE REQUIEREN ACTUALIZACIÓN EN LA TABLA FINAL A PROCESAR
Insert Into		#tmpActualizarIdentificacionesFinal
Select Distinct	cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,				nmro_unco_idntfccn_afldo,			fcha_ultma_mdfccn,
				fcha_vldcn,						fcha_ultma_mdfccn_rsgo,		fcha_vldcn_hsptlzcn,				inco_vgnca_bnfcro,
				cnsctvo_bnfcro
From			#tmpActualizarIdentificaciones With(NoLock)

Declare			@cnsctvo		Int,
				@cntdd_rgstrs	Int

Set				@cnsctvo	=	1

Select			@cntdd_rgstrs	=	COUNT(*)
From			#tmpActualizarIdentificacionesFinal	With(NoLock)

While @cnsctvo <= @cntdd_rgstrs
BEGIN
	BEGIN TRAN
		BEGIN TRY
			Update		bdSisalud.dbo.tbActua
			Set			cnsctvo_cdgo_tpo_idntfccn	=	a.cnsctvo_cdgo_tpo_idntfccn,
						nmro_idntfccn				=	a.nmro_idntfccn,
						fcha_ultma_mdfccn			=	@fcha_actlzcn
			From		#tmpActualizarIdentificacionesFinal		a	With(NoLock)
			Inner Join	bdSisalud.dbo.tbActua					c	With(NoLock)	On	c.nmro_unco_idntfccn_afldo	=	a.nmro_unco_idntfccn_afldo
																					And	c.fcha_ultma_mdfccn			=	a.fcha_ultma_mdfccn
																					And	c.nmro_bnfcro				=	a.cnsctvo_bnfcro
			Where		a.cnsctvo_cdgo_tpo_idntfccn !=	c.cnsctvo_cdgo_tpo_idntfccn
			And			a.cnsctvo			=	@cnsctvo
			And			c.fcha_ultma_mdfccn	>=	@fcha_mdfccn

			If @@ROWCOUNT > @cntdd
				Begin
					RollBack Tran
					Return
				End

			Update		bdSisalud.dbo.tbActuaNotificacion
			Set			cnsctvo_cdgo_tpo_idntfccn	=	a.cnsctvo_cdgo_tpo_idntfccn,
						nmro_idntfccn				=	a.nmro_idntfccn,
						fcha_ultma_mdfccn			=	@fcha_actlzcn
			From		#tmpActualizarIdentificacionesFinal		a	With(NoLock)
			Inner Join	bdSisalud.dbo.tbActuaNotificacion		c	With(NoLock)	On	c.nmro_unco_idntfccn	=	a.nmro_unco_idntfccn_afldo
																					And	c.fcha_vldcn			=	a.fcha_vldcn
																					And	c.nmro_bnfcro			=	a.cnsctvo_bnfcro
			Where		a.cnsctvo_cdgo_tpo_idntfccn !=	c.cnsctvo_cdgo_tpo_idntfccn
			And			a.cnsctvo		=	@cnsctvo
			And			c.fcha_vldcn	>=	@fcha_mdfccn

			If @@ROWCOUNT > @cntdd
				Begin
					RollBack Tran
					Return
				End

			Update		bdsisalud.dbo.tbAfiliadosRiesgos
			Set			cnsctvo_cdgo_tpo_idntfccn	=	a.cnsctvo_cdgo_tpo_idntfccn,
						nmro_idntfccn				=	a.nmro_idntfccn,
						fcha_ultma_mdfccn			=	@fcha_actlzcn
			From		#tmpActualizarIdentificacionesFinal		a	With(NoLock)
			Inner Join	bdsisalud.dbo.tbAfiliadosRiesgos		c	With(NoLock)	On	c.nmro_unco_idntfccn	=	a.nmro_unco_idntfccn_afldo
																					And	c.fcha_ultma_mdfccn		=	a.fcha_ultma_mdfccn_rsgo
			Where		a.cnsctvo_cdgo_tpo_idntfccn !=	c.cnsctvo_cdgo_tpo_idntfccn
			And			a.cnsctvo			=	@cnsctvo
			And			c.fcha_ultma_mdfccn	>=	@fcha_mdfccn

			If @@ROWCOUNT > @cntdd
				Begin
					RollBack Tran
					Return
				End
							
			Update		bdhospitalizacionmovil..tbmnsncdatosafiliado
			Set			cnsctvo_cdgo_tpo_idntfccn	=	a.cnsctvo_cdgo_tpo_idntfccn,
						nmro_idntfccn				=	a.nmro_idntfccn,
						fcha_ultma_mdfccn			=	@fcha_actlzcn
			From		#tmpActualizarIdentificacionesFinal				a	With(NoLock)
			Inner Join	bdhospitalizacionmovil..tbmnsncdatosafiliado	c	With(NoLock)	On	c.nmro_unco_idntfccn	=	a.nmro_unco_idntfccn_afldo
																							And	c.fcha_vldcn			=	a.fcha_vldcn_hsptlzcn
																							And	c.nmro_bnfcro			=	a.cnsctvo_bnfcro
			Where		a.cnsctvo_cdgo_tpo_idntfccn !=	c.cnsctvo_cdgo_tpo_idntfccn
			And			a.cnsctvo		=	@cnsctvo
			And			c.fcha_vldcn	>=	@fcha_mdfccn

			If @@ROWCOUNT > @cntdd
				Begin
					RollBack Tran
					Return
				End
		END TRY

		BEGIN CATCH
			SELECT 
					ERROR_NUMBER() AS ErrorNumber
					,ERROR_SEVERITY() AS ErrorSeverity
					,ERROR_STATE() AS ErrorState
					,ERROR_PROCEDURE() AS ErrorProcedure
					,ERROR_LINE() AS ErrorLine
					,ERROR_MESSAGE() AS ErrorMessage;

			 IF @@TRANCOUNT > 0
				ROLLBACK TRANSACTION;
		END CATCH;

		IF @@TRANCOUNT > 0
			COMMIT TRANSACTION;

	Set	@cnsctvo	=	@cnsctvo + 1
END

Drop Table	#tmpActualizarIdentificaciones
Drop Table	#tmpActualizarIdentificacionesFinal