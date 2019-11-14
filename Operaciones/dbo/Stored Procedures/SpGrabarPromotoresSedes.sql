/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :   SpGrabarAsociacionModelos
* Desarrollado por		 :  <\A	Ing. Rolando Simbaqueva Lasso						A\>
* Descripcion			 :  <\D   Inserta la informacion en tbpromotoresSedes 				D\>
* Observaciones		              :  <\O										O\>
* Parametros			 :  <\P    tabla tempora # tmpSedesPromotores					P\>
* Variables			 :  <\V										V\>
* Fecha Creacion		 :  <\FC  2002/10/07								FC\>
* 
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION  
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------  
* Modificado Por		              : <\AM    AM\>
* Descripcion			 : <\DM   DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM   FM\>
*---------------------------------------------------------------------------------*/
CREATE        PROCEDURE  SpGrabarPromotoresSedes
			@lcUsuarioModifica			udtusuario,
			@lnConsecutivoPromotor	int,	
			@lnProcesoExitoso		int  	Output
AS	Declare
@lcUsuario					Char(30),
@lnConceutivoCodigoPromotor			UdtConsecutivo,
@Cantidad					UdtConsecutivo,
@cantidadRegistros				int


Set  Nocount On	
Set	@lnProcesoExitoso	=	0

Select	 @cantidadRegistros	 =	 count(*)
From	 #tmpSedesPromotores



Select	 @lnConceutivoCodigoPromotor	=	 cnsctvo_cdgo_prmtr
From	 #tmpSedesPromotores

Select @Cantidad		=	count(*)
From  tbpromotoresSedes		a,	#tmpSedesPromotores   b
Where a.cnsctvo_cdgo_sde	=	b.cnsctvo_cdgo_sde
And     a.ultmo_digto		=	b.ultmo_digto		
And    a.brrdo		     =	 'N'		
And	@lnConceutivoCodigoPromotor	<> a.cnsctvo_cdgo_prmtr

If	@Cantidad	>	0
	Begin
		Set	@lnProcesoExitoso	=	2
		Return -1
	End	


Begin Tran Uno
-----------------------------------------INICIO PROCESO ACTUALIZACION EN tbpromotoresSedes------------------------------------------------------------------------------							
---- 1 ) PROCESO
------------REGISTROS	 IGUALES   QUE SE ENCUENTREN CON LA TABLA TEMPORAL    #tmpSedesPromotores

if 	@cantidadRegistros	=	0
	begin
		Update	tbpromotoresSedes
		Set	fcha_ultma_mdfccn    = getdate(),
			usro_ultma_mdfccn   = @lcUsuarioModifica,
			brrdo		     = 'S'	
		From	tbpromotoresSedes a
		Where	a.cnsctvo_cdgo_prmtr		=	@lnConsecutivoPromotor

		If  @@error!=0  
			Begin 
				Set	@lnProcesoExitoso	=	1
				Rollback tran uno
				Return -1
			End	

	end



Update	tbpromotoresSedes
Set	fcha_ultma_mdfccn    = getdate(),
	usro_ultma_mdfccn   = b. usro_ultma_mdfccn,
	brrdo		     = 'N'	
From	tbpromotoresSedes a   , 	#tmpSedesPromotores b
Where	a.cnsctvo_cdgo_sde		=	b.cnsctvo_cdgo_sde
And	a.cnsctvo_cdgo_prmtr		=	b.cnsctvo_cdgo_prmtr
And	a.ultmo_digto			=	a.ultmo_digto

If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Rollback tran uno
		Return -1
	End	
			
--- 2 ) PROCESO
--REGISTROS	QUE ESTABAN COMO SELECCIONADOS ANTERIORMENTE Y YA NO
--SE ENCUENTRAN EN LA TABLA TEMPORAL	#tmpSedesPromotores

select  @lcUsuario = usro_ultma_mdfccn From #tmpSedesPromotores

Update	tbpromotoresSedes
Set	fcha_ultma_mdfccn    = getdate(),
	usro_ultma_mdfccn   =@lcUsuario,
	brrdo		     = 'S'	
From	tbpromotoresSedes a   
Where	cnsctvo_cdgo_prmtr	=	@lnConceutivoCodigoPromotor
And	ltrim(rtrim(str(cnsctvo_cdgo_sde))) +ltrim(rtrim(str(cnsctvo_cdgo_prmtr))) + ltrim(rtrim(str(ultmo_digto)))
Not In (Select ltrim(rtrim(str(cnsctvo_cdgo_sde))) +ltrim(rtrim(str(cnsctvo_cdgo_prmtr))) + ltrim(rtrim(str(ultmo_digto))) From #tmpSedesPromotores)

If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Rollback tran uno
		Return -1
	end	
							
--3 ) PROCESO
--REGISTROS NUEVOS  EN  #tmpSedesPromotores
--EN ESTA TABLA SE GUARDAN LOS REGISTROS NUEVOS ES DECIR 
--QUE NO ESTAN EN LA TABLA tbpromotoresSedes  Y QUE SE
--ENCUENTRAN EL LA TABLA TEMPORAL CREADA EN EL CLIENTE
Insert Into tbpromotoresSedes
Select    cnsctvo_cdgo_prmtr,	 cnsctvo_cdgo_sde,	 ultmo_digto	,'N',
	Getdate(),                          @lcUsuario,		Getdate(),
             @lcUsuario,		NULL
From	#tmpSedesPromotores
Where	ltrim(rtrim(str(cnsctvo_cdgo_sde))) +ltrim(rtrim(str(cnsctvo_cdgo_prmtr))) + ltrim(rtrim(str(ultmo_digto)))
Not In (Select ltrim(rtrim(str(cnsctvo_cdgo_sde))) +ltrim(rtrim(str(cnsctvo_cdgo_prmtr))) + ltrim(rtrim(str(ultmo_digto))) From tbpromotoresSedes)


If  @@error!=0  	Begin 
		Set	@lnProcesoExitoso	=	1
		Rollback tran uno
		Return -1
	End	

Commit tran uno