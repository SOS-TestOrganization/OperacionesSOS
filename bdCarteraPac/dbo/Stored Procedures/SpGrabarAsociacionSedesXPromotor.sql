/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :   SpGrabarAsociacionSedesXPromotor
* Desarrollado por		 :  <\A	Ing. Rolando Simbaqueva Lasso						A\>
* Descripcion			 :  <\D   Inserta la informacion de sedes de promotor a otro promotor			D\>
* Observaciones		              :  <\O										O\>
* Parametros			 :  <\P    									P\>
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
CREATE        PROCEDURE  SpGrabarAsociacionSedesXPromotor
		@lnConsecutivoPromotorFuente		int,
		@lnConsecutivoPromotorDestino		int,
		@lcUsuario				udtusuario,
		@lnProcesoExitoso			int  	Output
AS	
Set nocount on


	
Set	@lnProcesoExitoso	=	0

begin tran uno

Select    @lnConsecutivoPromotorDestino   cnsctvo_cdgo_prmtr,
	 cnsctvo_cdgo_sde,
	 ultmo_digto
Into   #tmpPromotoresSedes
From tbpromotoressedes
Where cnsctvo_cdgo_prmtr = @lnConsecutivoPromotorFuente
And 	brrdo	=	'N'


-- Se actualizan los que ya existen

Update  tbpromotoressedes
Set        brrdo 		= 	'N',
             	fcha_ultma_mdfccn	=	getdate(),
	usro_ultma_mdfccn	=	@lcUsuario
From	 tbpromotoressedes a , 	#tmpPromotoresSedes  b
Where	a. cnsctvo_cdgo_sde	=	b.cnsctvo_cdgo_sde
And	a.ultmo_digto		=	b.ultmo_digto
And	a.cnsctvo_cdgo_prmtr	=	b.cnsctvo_cdgo_prmtr

If  @@error!=0  	Begin 
		Set	@lnProcesoExitoso	=	1
		Rollback tran uno
		Return -1
	End	


--Se insertan los que no estan


Insert into tbpromotoressedes
Select    cnsctvo_cdgo_prmtr,
	cnsctvo_cdgo_sde,
	ultmo_digto,
	'N',
	getdate(),
	@lcUsuario,
	getdate(),
	@lcUsuario,
	Null
From	#tmpPromotoresSedes
Where Ltrim(Rtrim(Str(cnsctvo_cdgo_prmtr))) +  Ltrim(Rtrim(Str(cnsctvo_cdgo_sde)))  +  Ltrim(Rtrim(Str(ultmo_digto)))  
Not In	( Select Ltrim(Rtrim(Str(cnsctvo_cdgo_prmtr))) +  Ltrim(Rtrim(Str(cnsctvo_cdgo_sde)))  +  Ltrim(Rtrim(Str(ultmo_digto)))  
	 From 	tbpromotoressedes)
				
If  @@error!=0  	Begin 
		Set	@lnProcesoExitoso	=	1
		Rollback tran uno
		Return -1
	End	


--Se Actualiza el campo borrado para aquellos donde no existe existe en el promotor origen
Update  tbpromotoressedes
Set        brrdo 		= 	'S'
From	tbpromotoressedes
Where   cnsctvo_cdgo_prmtr = @lnConsecutivoPromotorDestino
And	Ltrim(Rtrim(Str(cnsctvo_cdgo_prmtr))) +  Ltrim(Rtrim(Str(cnsctvo_cdgo_sde)))  +  Ltrim(Rtrim(Str(ultmo_digto)))  
Not In	(Select Ltrim(Rtrim(Str(cnsctvo_cdgo_prmtr))) +  Ltrim(Rtrim(Str(cnsctvo_cdgo_sde)))  +  Ltrim(Rtrim(Str(ultmo_digto)))  
	 From 	#tmpPromotoresSedes)
	

Commit tran uno