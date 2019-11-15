CREATE Procedure [dbo].[spBuscarAfiliadoxTipoyNumeroIdentificacion]
  @lnTipoIdentificacion       udtConsecutivo				= Null,
  @lcCodigoTipoIdentificacion Char(3)						= Null,
  @lcNumeroIdentificacion     udtNumeroIdentificacionLargo,
  @ldfehaConsulta			  Datetime						= Null,
  @lnTipoPrioridadMax		  udtLogico						= 'N'

AS
SET NOCOUNT ON

/*
Declare	@lnTipoIdentificacion		udtConsecutivo,
			@lcCodigoTipoIdentificacion	Char(3),
			@lcNumeroIdentificacion		udtNumeroIdentificacionLargo,
			@ldfehaConsulta				Datetime,
			@lnTipoPrioridadMax			udtLogico

Set			@lnTipoIdentificacion = Null
Set			@lcCodigoTipoIdentificacion = 'CC'
Set			@lcNumeroIdentificacion = '66847870'
Set			@ldfehaConsulta = getDate()
Set			@lnTipoPrioridadMax = 'N'
*/  

Begin
    Declare @ldFechaActual  Datetime,
	        @lnTipoContrato Int,
			@lcPlan			Int,
			@cntdd_vgnts	Int,
			@prddxpln_slcccnda Int

	Set @ldFechaActual	= getDate()
	Set @ldfehaConsulta =  ISNULL(@ldfehaConsulta,@ldFechaActual)

    If (@lnTipoIdentificacion Is Null Or @lnTipoIdentificacion = '')
		Begin
			Select @lnTipoIdentificacion = cnsctvo_cdgo_tpo_idntfccn
			From   tbTiposIdentificacion_vigencias With(NoLock)
			Where  cdgo_tpo_idntfccn = @lcCodigoTipoIdentificacion
			And    @ldFechaActual Between inco_vgnca And fn_vgnca
		End
	
	
	Declare @tmpContratosAfiliado Table
			(
				cnsctvo_cdgo_tpo_idntfccn	Int,
				nmro_idntfccn				udtNumeroIdentificacion,
				nmro_unco_idntfccn_afldo	Int,
				cnsctvo_cdgo_tpo_cntrto		Int, 
				nmro_cntrto					udtNumeroFormulario,
				nmbre_afldo					varchar(140),
				cnsctvo_cdgo_pln			Int, 
				cdgo_pln					varchar(2),
				dscrpcn_pln					varchar(150),
				clclo_vgnca					udtLogico,
				prmr_nmbre					udtNombre,
				sgndo_nmbre					udtNombre,
				prmr_aplldo					udtApellido,
				sgndo_aplldo				udtApellido,
				prdd						Int
			)
	Declare @tmpPrioridadxTipoContratos Table
			(
				cnsctvo_cdgo_tpo_cntrto		Int,
				prdd						Int,
				nmbre_pln					varchar(23)
			)

	/* Prioridades x Plan */
	Insert @tmpPrioridadxTipoContratos(cnsctvo_cdgo_tpo_cntrto, prdd, nmbre_pln)
	Select							   1,				1,   'POS' Union
	Select 							   3,				2,	 'POS Subsidiado' Union
	Select 							   2,				3,	 'PAC' 

	/* Inicio Calcular Plan */
	Insert Into	@tmpContratosAfiliado
				(	cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,				nmro_unco_idntfccn_afldo,
					cnsctvo_cdgo_tpo_cntrto,		nmro_cntrto,				nmbre_afldo,
					clclo_vgnca,					prmr_nmbre,					sgndo_nmbre,
					prmr_aplldo,					sgndo_aplldo
				)
	Select Distinct	@lnTipoIdentificacion,			@lcNumeroIdentificacion,	b.nmro_unco_idntfccn_afldo,
					b.cnsctvo_cdgo_tpo_cntrto,		b.nmro_cntrto,				Rtrim(Ltrim(b.prmr_nmbre)) + ' ' + Rtrim(Ltrim(b.sgndo_nmbre)) + ' ' + Rtrim(Ltrim(b.prmr_aplldo)) + ' ' + Rtrim(Ltrim(b.sgndo_aplldo)),
					Case	When @ldfehaConsulta Between b.inco_vgnca_bnfcro And b.fn_vgnca_bnfcro then 'S'
							Else 'N'
					End,							prmr_nmbre,					sgndo_nmbre,
					prmr_aplldo,					sgndo_aplldo
	From			bdAfiliacionValidador.dbo.tbBeneficiariosValidador	b	With(NoLock)
	Where			b.cnsctvo_cdgo_tpo_idntfccn	= @lnTipoIdentificacion
	And				b.nmro_idntfccn				= @lcNumeroIdentificacion
	
	Select		@cntdd_vgnts = Count(*)
	From		@tmpContratosAfiliado
	Where		clclo_vgnca = 'S'

	--Si el afiliado no tiene ningun plan vigente, la consulta debe retornar algun plan, por lo tanto se calcula entre todos los planes
	If(@cntdd_vgnts = 0)
		Begin
			Update	@tmpContratosAfiliado
			Set		clclo_vgnca = 'S'
		End

	Update		@tmpContratosAfiliado
	Set			cnsctvo_cdgo_pln	= a.cnsctvo_cdgo_pln
	From		bdAfiliacionValidador.dbo.tbContratosValidador	a	With(NoLock)
	Inner Join	@tmpContratosAfiliado							b	On	a.nmro_cntrto				= b.nmro_cntrto
																	And	a.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
	
	-- se asigna la prioridad que tiene cada tipo de contrato
	Update		@tmpContratosAfiliado
	Set			prdd	= b.prdd
	From		@tmpContratosAfiliado		a 
	Inner Join	@tmpPrioridadxTipoContratos b	On	a.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
	
	-- Si la prioridad que se requiere no es la maxima, sino la minima, luego se consultara el tipo de contrato que tenga la dicha prioridad, la minima
	If	(@lnTipoPrioridadMax = 'N')
		Begin
		  Select	@prddxpln_slcccnda = min(prdd)
		  From		@tmpContratosAfiliado
		  Where		clclo_vgnca = 'S' 
		End
	-- Si la prioridad que se requiere es la maxima, luego se consultara el tipo de contrato que tenga la dicha prioridad, la maxima
	If	(@lnTipoPrioridadMax = 'S')
		Begin
		  Select	@prddxpln_slcccnda = max(prdd)
		  From		@tmpContratosAfiliado
		  Where		clclo_vgnca = 'S' 
		End

	Select	@lcPlan			= cnsctvo_cdgo_pln, 
			@lnTipoContrato = cnsctvo_cdgo_tpo_cntrto 
	From	@tmpContratosAfiliado 
	where	prdd = @prddxpln_slcccnda

	/* Fin Calcular Plan */
	Update		@tmpContratosAfiliado
	Set			dscrpcn_pln = p.dscrpcn_pln,
				cdgo_pln	= p.cdgo_pln
	From		bdAfiliacionValidador.dbo.tbPlanes	p	With(NoLock)
	Inner Join	@tmpContratosAfiliado				c	On	p.cnsctvo_cdgo_pln = c.cnsctvo_cdgo_pln
	
	Select Top 1	nmro_unco_idntfccn_afldo, nmro_idntfccn, nmbre_afldo, cnsctvo_cdgo_pln ,cdgo_pln,dscrpcn_pln, prmr_nmbre,sgndo_nmbre,prmr_aplldo,sgndo_aplldo
	From			@tmpContratosAfiliado 
	Where			cnsctvo_cdgo_tpo_idntfccn	= @lnTipoIdentificacion
	And				nmro_idntfccn				= @lcNumeroIdentificacion
	And				cnsctvo_cdgo_tpo_cntrto		= @lnTipoContrato 
	And				cnsctvo_cdgo_pln			= @lcPlan
End


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spBuscarAfiliadoxTipoyNumeroIdentificacion] TO [websos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spBuscarAfiliadoxTipoyNumeroIdentificacion] TO [pe_soa]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spBuscarAfiliadoxTipoyNumeroIdentificacion] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spBuscarAfiliadoxTipoyNumeroIdentificacion] TO [ctc_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spBuscarAfiliadoxTipoyNumeroIdentificacion] TO [at3047_webusr]
    AS [dbo];

