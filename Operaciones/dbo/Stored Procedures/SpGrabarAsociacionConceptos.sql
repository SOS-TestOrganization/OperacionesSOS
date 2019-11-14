/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :   SpGrabarAsociacionConceptos
* Desarrollado por		 :  <\A	Ing. Rolando Simbaqueva Lasso						A\>
* Descripcion			 :  <\D   Inserta la informacion en tbGruposConcepto				D\>
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
CREATE        PROCEDURE  SpGrabarAsociacionConceptos
		@lnConsecutivoGrupoFuente		int,
		@lnConsecutivoGrupoDestino		int,
		@lcUsuario				udtusuario,
		@lnProcesoExitoso			int  	Output
AS	declare

@MaximoGrupoConcepto	int,
@ldFechaSistema		Datetime,
@Maximo_vigencias_Grupo_concepto	int	
	
Set	@lnProcesoExitoso	=	0
Set	@ldFechaSistema	=	Getdate()

begin tran uno

Select    cnsctvo_grpo_cncpto,
	inco_vgnca,
	fn_vgnca,
	fcha_crcn,
	usro_crcn,
	@lnConsecutivoGrupoDestino   cnsctvo_cdgo_grpo_lqdcn,
	cnsctvo_cdgo_cncpto_lqdcn,
	prcntje
Into   #tmpGrupoConceptos
From tbGruposXConcepto_vigencias
Where cnsctvo_cdgo_grpo_lqdcn = @lnConsecutivoGrupoFuente
And	@ldFechaSistema between inco_vgnca and fn_vgnca
/*
Delete from  tbGruposXConcepto_vigencias 
Where cnsctvo_cdgo_grpo_lqdcn = @lnConsecutivoGrupoDestino
And	@ldFechaSistema between inco_vgnca and fn_vgnca */


-- Se actualizan los que ya existen
--no  se deben actualiza los registros existentes porque crea vigencias
/*
Update  tbGruposXConcepto_vigencias
Set        inco_vgnca	=	b.inco_vgnca,
	fn_vgnca	=	b.fn_vgnca,
	fcha_crcn	=	getdate(),
	usro_crcn	=	@lcUsuario,
	prcntje		=	b.prcntje
From	 tbGruposXConcepto_vigencias  a , 	#tmpGrupoConceptos b
Where	a. cnsctvo_cdgo_grpo_lqdcn	=	b.cnsctvo_cdgo_grpo_lqdcn
And	a.cnsctvo_cdgo_cncpto_lqdcn	=	b.cnsctvo_cdgo_cncpto_lqdcn
And	a. cnsctvo_cdgo_grpo_lqdcn	=	@lnConsecutivoGrupoDestino
And	@ldFechaSistema between a.inco_vgnca 	and 	a.fn_vgnca

*/

If  @@error!=0  	Begin 
		Set	@lnProcesoExitoso	=	1
		Rollback tran uno
		Return -1
	End	


--Se insertan los que no estan


Select	IDENTITY(Int, 1 ,1) 	AS		nmro_rgstro ,
             inco_vgnca,
	fn_vgnca,
	Getdate() fcha_crcn,
	@lcUsuario  usro_crcn,
	cnsctvo_cdgo_grpo_lqdcn,
	cnsctvo_cdgo_cncpto_lqdcn,
	prcntje
INTO	#tmpGrupoConceptosnuevos
From 	#tmpGrupoConceptos
Where   	Ltrim(Rtrim(Str(cnsctvo_cdgo_grpo_lqdcn))) +  Ltrim(Rtrim(Str(cnsctvo_cdgo_cncpto_lqdcn))) 
Not In	(Select	Ltrim(Rtrim(Str(cnsctvo_cdgo_grpo_lqdcn))) +  Ltrim(Rtrim(Str(cnsctvo_cdgo_cncpto_lqdcn)))  
	 From 	tbGruposXConcepto)

-- se calcula el maximo de la tabla de relacion				
Select	@MaximoGrupoConcepto		=	Isnull(Max(cnsctvo_grpo_cncpto),0)  	
From	tbGruposXConcepto

-- se calcula el maximo consecutivo de vigencias
Select  @Maximo_vigencias_Grupo_concepto	= 	isnull(max(cnsctvo_vgnca_grpo_cncpto),0)
From	tbGruposXConcepto_vigencias








-- se insertan  los registros en la tbal de relacion
Insert into tbGruposXConcepto
Select	(@MaximoGrupoConcepto + nmro_rgstro ) cnsctvo_grpo_cncpto,	
	Getdate() fcha_crcn,
	@lcUsuario  usro_crcn,
	cnsctvo_cdgo_grpo_lqdcn,
	cnsctvo_cdgo_cncpto_lqdcn
From	#tmpGrupoConceptosnuevos

If  @@error!=0  	Begin 
		Set	@lnProcesoExitoso	=	1
		Rollback tran uno
		Return -1
	End	


-- se insertan las vigencias de la tabla de relacion
Insert	into tbGruposXConcepto_Vigencias
Select	(@Maximo_vigencias_Grupo_concepto  + nmro_rgstro ) cnsctvo_vgnca_grpo_cncpto,	
	(@MaximoGrupoConcepto + nmro_rgstro ) cnsctvo_grpo_cncpto,	
	inco_vgnca,
	fn_vgnca,
	Getdate() fcha_crcn,
	@lcUsuario  usro_crcn,
	cnsctvo_cdgo_grpo_lqdcn,
	cnsctvo_cdgo_cncpto_lqdcn,
	prcntje,
	Null
From	#tmpGrupoConceptosnuevos

If  @@error!=0  	Begin 
		Set	@lnProcesoExitoso	=	1
		Rollback tran uno
		Return -1
	End	



	

Commit tran uno