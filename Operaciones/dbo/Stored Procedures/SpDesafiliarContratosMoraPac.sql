
/*---------------------------------------------------------------------------------
* Metodo o PRG		:  SpDesafiliarContratosMoraPac
* Desarrollado por	: <\A Ing. Rolando Simbaqueva							A\> 
* Descripcion		: <\D Permite Activar desafiliar los contratos por mora Pac				D\>
* Observaciones		: <\O										O\>
* Parametros		: <\P 										P\>
* Variables		: <\V 										V\>
			: <\V Parmetros que condicionan la consulta					V\>
			: <\V Fecha que se convierte de date a caracter					V\>
			* Fecha Creacion: <\FC 2002/06/21						FC\>
*
*--------------------------------------------------------------------------------- 
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  FM\>
*---------------------------------------------------------------------------------*/
CREATE                   PROCEDURE    SpDesafiliarContratosMoraPac 
		@ldFechaActual		Datetime,
		@lcUsuario		udtUsuario
		

AS    Declare
@lnProceso				int,
@lnError				int

 
Set Nocount On

Create table #tmpInformacionNovedad (	
	cnsctvo_cdgo_tpo_cntrto		udtConsecutivo,			nmro_cntrto			udtNumeroFormulario,						
	nmro_unco_idntfccn			udtConsecutivo,			cnsctvo_idntfcdr		udtConsecutivo,
	cnsctvo_cdgo_tpo_nvdd		udtConsecutivo,			cnsctvo_cdgo_csa_nvdd	udtConsecutivo,
	fcha_nvdd					Datetime,				adcnl					udtLogico,
	usro							udtUsuario,				cnsctvo_cdgo_tpo_cntrto_psc	udtConsecutivo,		
	nmro_cntrto_psc				udtNumeroFormulario,		cnsctvo_cdgo_estdo_cvl		udtConsecutivo,
	cnsctvo_cdgo_sb_csa_nvdd		udtConsecutivo,			estdo					udtLogico,
	cnsctvo_cdgo_cncpto_nvdd		udtConsecutivo,			cnsctvo_nvdd				udtNumeroFormulario,
	nmro_unco_idntfccn_ctznte		udtConsecutivo,			cnsctvo_cdgo_clse_aprtnte	udtConsecutivo,
	cnsctvo_plnlla					udtConsecutivo,			cnsctvo_lna				udtConsecutivo,				
	cnsctvo_dtlle_nvdd_gnrda		udtConsecutivo,			es_msva 				udtLogico,
 	cnsctvo_cdgo_tpo_cbrnza_bnfcro	udtConsecutivo,
	crer_tds_bnfcrs  udtLogico DEFAULT 'S',
 cnsctvo_cdgo_csa_mvldd udtConsecutivo DEFAULT 0

)
	
If  @@error	!=	0 
Begin 
	Return -1
End

Insert	Into	#TmpInformacionNovedad
Select 	Distinct 
	a.cnsctvo_cdgo_tpo_cntrto,	a.nmro_cntrto,			
	b.nmro_unco_idntfccn_afldo,	-- beneficiario para ex-ben, cot para ex-emp
	a.cnsctvo_cbrnza,		-- cobranza para ex-emp.
	8,		-- desafiliacion de la Eps
	65,		-- Mora Mayor a la establecida por la ley
	@ldFechaActual,  -- Fecha de Novead, se recibe por parámetro
	'N',		-- Adicional S/N indica si es un Ben Ad. para ex beneficiarios
	@lcUsuario,	-- Usuario que ejecuta el proceso
	0,		-- Tipo Contrato Posc  = 0
	0,		-- Num contrato posc = 0
	0,		-- estado civil =0
	0,		-- Subcausa novedad = 0	
	'A',		-- estado, siempre = 'A'
	0,		-- Concepto Novedad
	0,		-- consecutivo novedad
	b.nmro_unco_idntfccn_afldo, -- cotizante del beneficiario, para ex-ben
	0,		-- Clase aportante 
	0,		-- Cons planilla
	0,		-- Nul lin
	0,		-- cons detalle novedad generada = 0
	'S',		-- Es masiva s/n
	0,	-- Tipo Cobranza beneficiario = 0 (se calcula en la novedad)
	'S', --crer_tds_bnfcrs  
0 -- cnsctvo_cdgo_csa_mvldd 
From	TbcontratosdesafiliadosXmoraPac a , bdafiliacion.dbo.tbcontratos b,
	bdcarteraPac.dbo.tbliquidaciones c
Where	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto
And	a.dsfldo			=	'N'
And	a.cnsctvo_cdgo_lqdcn		=	c.cnsctvo_cdgo_lqdcn
and	c.cnsctvo_cdgo_estdo_lqdcn	=	3


If  @@error	!=	0 
Begin 
	Return 
End



If Exists(	Select	1
	From	#TmpInformacionNovedad)
Begin
	
	Exec @lnError	=	bdafiliacion.dbo.spAdmonNovedadDesafiliacion	'0',	
						2,	---- Novedad Realizada x Proceso
						@lcUsuario,	
						@lnProceso	Output	
						
	If  @@error	!=	0 	Or	 @lnError	 != 	0
	Begin 
		Print  'Error en la ejecucion  novedad Desafiliacion'
		Return -1	
	End
--select '#TmpInformacionNovedad1',* from 	#TmpInformacionNovedad
End


Update bdcarterapac.dbo.TbcontratosdesafiliadosXmoraPac
Set	estdo		=	b.estdo,
	fcha_nvdd	=	b.fcha_nvdd,
	dsfldo		=	'S'
From	 bdcarterapac.dbo.TbcontratosdesafiliadosXmoraPac a,  #TmpInformacionNovedad b
Where	a.cnsctvo_cdgo_tpo_cntrto	= 	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto
And	a.cnsctvo_cbrnza		=	b.cnsctvo_idntfcdr
And	a.dsfldo				=	'N'
