
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	        :   SpConsultaContratosEstadoCuenta
* Desarrollado por		:  <\A	Ing. Rolando Simbaqueva Lasso		A\>
* Descripcion			:  <\D   trae la informacion de los l contratos del estado de cuenta	D\>
* Observaciones			:  <\O	O\>
* Parametros			:  <\P  P\>
* Variables				:  <\V	V\>
* Fecha Creacion		:  <\FC 2002/10/07	FC\>
* 
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION  
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------  
* Modificado Por		: <\AM   Ing. Sandra Milena Ruiz Reyes 	AM\>
* Descripcion			: <\DM   Aplicacion de tecnicas de optimizacion	DM\>
* Nuevos Parametros	 	: <\PM   PM\>
* Nuevas Variables		: <\VM   VM\>
* Fecha Modificacion		: <\FM   13/09/2005	FM\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION  
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM   Francisco E. Riaño L - Qvision S.A		AM\>
* Descripcion			: <\DM   Se realizan ajustes para traer informacion de:
								fcha_crcn_nta,cnsctvo_cdgo_lqdcn, cnsctvo_cdgo_prdo_lqdcn,
								dscrpcn_prdo_lqdcn,fcha_incl_prdo_lqdcn DM\>
* Nuevos Parametros	 	: <\PM   PM\>
* Nuevas Variables		: <\VM   VM\>
* Fecha Modificacion	: <\FM   2019/08/02	FM\>
*---------------------------------------------------------------------------------
exec bdcarterapac.[dbo].[SpConsultaContratosEstadoCuenta] '2592593'
*/

CREATE PROCEDURE  [dbo].[SpConsultaContratosEstadoCuenta] (
		@lnNumeroEstadoCuenta		Varchar(15)
)
AS
Begin 
	Set  Nocount On;
	Declare		@Saldo_estdo_cnta							numeric(12,0),
				@fcha_actl									datetime = getdate(),
				@lnConsecutivoEstadoCuentaAnulado			udtConsecutivo	= 4,
				@lnConsecutivoEstadoCuentaDePrueba			udtConsecutivo	= 5,
				@lnConsecutivoEstadoCuentaCanceladaParcial	udtConsecutivo	= 2,
				@lnConsecutivoEstadoCuentaCanceladaTotal	udtConsecutivo	= 3;


	Create table #tmpEstadosCuentaContrato(
		cnsctvo_estdo_cnta					udtConsecutivo,
		nmro_unco_idntfccn_empldr			udtConsecutivo,
		cnsctvo_scrsl						udtConsecutivo,
		cnsctvo_cdgo_clse_aprtnte			udtConsecutivo,
		ttl_fctrdo							udtValorGrande,
		vlr_iva								udtValorGrande,
		ttl_pgr								udtValorGrande,
		nmro_estdo_cnta						varchar(15),
		cnsctvo_cdgo_tpo_cntrto				udtConsecutivo,
		nmro_cntrto							udtNumeroFormulario,
		nmbre_afldo							varchar(200),
		nmbre_scrsl							varchar(200),
		rzn_scl								varchar(200),
		dgto_vrfccn							int,
		nmro_idntfccn_empldr				varchar(20),
		cdgo_tpo_idntfccn_empldr			varchar(3),
		cnsctvo_cdgo_tpo_idntfccn_Empldr	int,	
		cdgo_tpo_idntfccn					udtTipoIdentificacion,
		nmro_idntfccn						udtNumeroIdentificacionLargo,
		accn								varchar(15),
		cnsctvo_cdgo_pln					udtConsecutivo,
		nmro_unco_idntfccn_afldo			udtConsecutivo,
		cnsctvo_cdgo_estdo_estdo_cnta		udtConsecutivo,
		sldo_estdo_cnta						udtValorGrande,
		vlr_cbrdo_cntrto					udtValorGrande,
		sldo_cntrto							udtValorGrande,
		cnsctvo_estdo_cnta_cntrto			udtConsecutivo,	
		fcha_crcn_nta						datetime,
		cnsctvo_cdgo_lqdcn					udtConsecutivo,
		cnsctvo_cdgo_prdo_lqdcn				udtConsecutivo,
		dscrpcn_prdo_lqdcn					varchar(200),
		fcha_incl_prdo_lqdcn				datetime		
	)	

	-- se crea la tabla temporal con la informacion del  estado cuenta y sus contratos

	Insert Into #tmpEstadosCuentaContrato
	SELECT		a.cnsctvo_estdo_cnta,		
				a.nmro_unco_idntfccn_empldr,		
				a.cnsctvo_scrsl,
				a.cnsctvo_cdgo_clse_aprtnte,	
				a.ttl_fctrdo,				
				a.vlr_iva,
				a.ttl_pgr,			
				a.nmro_estdo_cnta , 
				b.cnsctvo_cdgo_tpo_cntrto,	
				b.nmro_cntrto,                         
				ltrim(rtrim(f.prmr_aplldo)) + ' ' + ltrim(rtrim(f.sgndo_aplldo)) + ' ' + ltrim(rtrim(f.prmr_nmbre)) + ' ' +ltrim(rtrim(f.sgndo_nmbre)) nmbre_afldo,
				space(200) 	nmbre_scrsl,
				space(200) 	rzn_scl,
				0			dgto_vrfccn,
				space(20)  	nmro_idntfccn_empldr,
				space(3)	cdgo_tpo_idntfccn_empldr,
				0			cnsctvo_cdgo_tpo_idntfccn_Empldr,
				d.cdgo_tpo_idntfccn,
				e.nmro_idntfccn,
				'NO SELECCIONADO'	accn,
				c.cnsctvo_cdgo_pln,
				c.nmro_unco_idntfccn_afldo,
				a.cnsctvo_cdgo_estdo_estdo_cnta,
				a.sldo_estdo_cnta,
				b.vlr_cbrdo	  		vlr_cbrdo_cntrto,
				b.sldo 	 			sldo_cntrto,
				b.cnsctvo_estdo_cnta_cntrto,
				a.fcha_gnrcn,
				a.cnsctvo_cdgo_lqdcn,
				g.cnsctvo_cdgo_prdo_lqdcn,
				h.dscrpcn_prdo_lqdcn,
				h.fcha_incl_prdo_lqdcn
	FROM		dbo.tbEstadosCuenta a  with(nolock)
	INNER JOIN  dbo.tbEstadosCuentaContratos b with(nolock)
		ON 		a.cnsctvo_estdo_cnta = b.cnsctvo_estdo_cnta 
	INNER JOIN  bdAfiliacion.dbo.tbContratos  c  with(nolock)
		ON 		b.nmro_cntrto = c.nmro_cntrto 
		AND 	b.cnsctvo_cdgo_tpo_cntrto 	= c.cnsctvo_cdgo_tpo_cntrto 
	INNER JOIN  bdAfiliacion.dbo.tbVinculados e with(nolock)
		ON 		c.nmro_unco_idntfccn_afldo 	= e.nmro_unco_idntfccn 
	INNER JOIN  bdAfiliacion.dbo.tbTiposIdentificacion d with(nolock)
		ON 		e.cnsctvo_cdgo_tpo_idntfccn 	= d.cnsctvo_cdgo_tpo_idntfccn 
	INNER JOIN	bdAfiliacion.dbo.tbPersonas  f with(nolock)
		ON		c.nmro_unco_idntfccn_afldo	=	f.nmro_unco_idntfccn 
	Inner Join  dbo.tbLiquidaciones g with(nolock)
		On		a.cnsctvo_cdgo_lqdcn = g.cnsctvo_cdgo_lqdcn
	Inner join	dbo.tbPeriodosliquidacion_Vigencias h with(nolock)
		On		g.cnsctvo_cdgo_prdo_lqdcn = h.cnsctvo_cdgo_prdo_lqdcn
	WHERE		a.nmro_estdo_cnta = @lnNumeroEstadoCuenta
	AND			@fcha_actl	between h.inco_vgnca and h.fn_vgnca
	--AND 		b.sldo > 0

	Select	@Saldo_estdo_cnta		=	isnull(sum(sldo_cntrto),0)
	From	#tmpEstadosCuentaContrato
	Where 	sldo_cntrto			>	0

	Update	#tmpEstadosCuentaContrato
	Set		sldo_estdo_cnta			=	@Saldo_estdo_cnta

	Update	#tmpEstadosCuentaContrato
	Set		cnsctvo_cdgo_estdo_estdo_cnta	=	@lnConsecutivoEstadoCuentaCanceladaParcial
	where	sldo_estdo_cnta			>	0
	and     cnsctvo_cdgo_estdo_estdo_cnta not in (@lnConsecutivoEstadoCuentaAnulado,@lnConsecutivoEstadoCuentaDePrueba) 

	-- se actualiza los datos basicos del responsable pago
	Update		#tmpEstadosCuentaContrato
	Set			nmro_idntfccn_empldr			 =	b.nmro_idntfccn,
				dgto_vrfccn						 =	b.dgto_vrfccn,
				cnsctvo_cdgo_tpo_idntfccn_Empldr =	b.cnsctvo_cdgo_tpo_idntfccn
	From		#tmpEstadosCuentaContrato		a 
	Inner join	bdafiliacion.dbo.tbVinculados	b with(nolock)
		On   	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn	
	
	Update		#tmpEstadosCuentaContrato
	Set			cdgo_tpo_idntfccn_empldr	=	b.cdgo_tpo_idntfccn
	From		#tmpEstadosCuentaContrato				a 
	Inner join	bdafiliacion.dbo.tbtiposIdentificacion	b with(nolock)
		On 		a.cnsctvo_cdgo_tpo_idntfccn_Empldr	=	b.cnsctvo_cdgo_tpo_idntfccn

	-- actualiza la razon social
	Update 		#tmpEstadosCuentaContrato
	Set			rzn_scl	 =  c.rzn_scl
	FROM		#tmpEstadosCuentaContrato a 
	INNER JOIN	bdAfiliacion.dbo.tbEmpleadores b with(nolock)
		ON 		a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn 
		AND		a.cnsctvo_cdgo_clse_aprtnte = b.cnsctvo_cdgo_clse_aprtnte 
	INNER JOIN	bdAfiliacion.dbo.tbEmpresas c with(nolock)
		ON 		a.nmro_unco_idntfccn_empldr = c.nmro_unco_idntfccn

	Update		#tmpEstadosCuentaContrato
	Set			rzn_scl	 =   ltrim(rtrim(isnull(prmr_aplldo,'')))  + ' ' + ltrim(rtrim(isnull(sgndo_aplldo,''))) + ' ' + ltrim(rtrim(isnull(prmr_nmbre,''))) + ' ' + ltrim(rtrim(isnull(sgndo_nmbre,'')))
	FROM		#tmpEstadosCuentaContrato a 
	INNER JOIN  bdAfiliacion.dbo.tbEmpleadores b with(nolock)
		ON 		a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn 
		AND     a.cnsctvo_cdgo_clse_aprtnte = b.cnsctvo_cdgo_clse_aprtnte 
	INNER JOIN  bdAfiliacion.dbo.tbPersonas c with(nolock)
		ON 		a.nmro_unco_idntfccn_empldr = c.nmro_unco_idntfccn
	WHERE		a.rzn_scl = ''

	--actualiza el nombre de la sucursal
	Update		#tmpEstadosCuentaContrato
	Set 		nmbre_scrsl	=	b.nmbre_scrsl
	FROM		#tmpEstadosCuentaContrato a 
	INNER JOIN  bdAfiliacion.dbo.tbSucursalesAportante b with(nolock)
		ON		a.cnsctvo_scrsl = b.cnsctvo_scrsl 
		AND 	a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn_empldr 
		AND     a.cnsctvo_cdgo_clse_aprtnte = b.cnsctvo_cdgo_clse_aprtnte


	Select  cnsctvo_estdo_cnta,			
			nmro_unco_idntfccn_empldr,		
			cnsctvo_scrsl,
			cnsctvo_cdgo_clse_aprtnte,		
			ttl_fctrdo,				
			vlr_iva,
			ttl_pgr,				
			nmro_estdo_cnta,			
			cnsctvo_cdgo_tpo_cntrto,
			nmro_cntrto,				
			nmbre_afldo,				
			nmbre_scrsl,
			rzn_scl,				
			dgto_vrfccn,				
			nmro_idntfccn_empldr,
			cdgo_tpo_idntfccn_empldr,		
			cnsctvo_cdgo_tpo_idntfccn_Empldr,	
			cdgo_tpo_idntfccn,
			nmro_idntfccn,				
			accn,					
			cnsctvo_cdgo_pln,
			nmro_unco_idntfccn_afldo,		
			cnsctvo_cdgo_estdo_estdo_cnta,		
			sldo_estdo_cnta,
			vlr_cbrdo_cntrto,			
			sldo_cntrto,				
			cnsctvo_estdo_cnta_cntrto,fcha_crcn_nta,
			cnsctvo_cdgo_lqdcn,		
			cnsctvo_cdgo_prdo_lqdcn,		
			dscrpcn_prdo_lqdcn,
			fcha_incl_prdo_lqdcn			
	From	#tmpEstadosCuentaContrato

End