CREATE  PROCEDURE [dbo].[spWEBConsultaAfiliado_AlDia]
(
 	@nui  			udtConsecutivo,
	@tpo_idntfccn 	varchar(50)  	= NULL, 
	@nmro_idntfccn	varchar(23) 	= NULL, 	--udtNumeroIdentificacion,
	@pln 			varchar(100)	= NULL,
	@fechaConsulta	datetime		= NULL,
    @incluirEventoAfiliado udtLogico = 'N'
)

AS

BEGIN
	SET NOCOUNT ON

	DECLARE	@cnsctvo_cdgo_tpo_idntfccn	udtConsecutivo,
			@cnsctvo_cdgo_pln 			udtConsecutivo


	if(((@tpo_idntfccn is null) OR (@nmro_idntfccn is null) OR (@pln is null)) AND @nui is not null) 
		begin
			CREATE table	#tmpWebTerna
					(		cnsctvo_cdgo_tpo_idntfccn 	int, 
							nmro_idntfccn				varchar(23), 	--udtNumeroIdentificacion,
							inco_vgnca_bnfcro           varchar(10),
							fn_vgnca_bnfcro             varchar(10),
							cnsctvo_cdgo_tpo_cntrto 	int,
							nmro_cntrto     			varchar(15),
							cnsctvo_bnfcro 				int,
							cnsctvo_cdgo_pln 			int,
							orgn_bsqda  				int
					)
	
			insert into #tmpWebTerna
					(	cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,				inco_vgnca_bnfcro,
						fn_vgnca_bnfcro,				cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,
						cnsctvo_bnfcro,					cnsctvo_cdgo_pln,			orgn_bsqda
					)
			exec 	spConsultaAfiliadoNUI @nui
			select  @cnsctvo_cdgo_tpo_idntfccn	= cnsctvo_cdgo_tpo_idntfccn,
					@nmro_idntfccn 				= nmro_idntfccn,
					@cnsctvo_cdgo_pln 			= cnsctvo_cdgo_pln  
			from 	#tmpWebTerna

			Drop Table	#tmpWebTerna
		end
	else
		begin
			Create table	#tpWSTraerTipoIdentificacion
					(		cdgo_tpo_idntfccn 			char(2),	
							dscrpcn_tpo_idntfccn 		varchar(150),
							cnsctvo_cdgo_tpo_idntfccn	int,	
							rngo_infrr 					varchar(20), --???
							rngo_sprr  					varchar(20)  --???
					)
			Create table #tpWSTraerPlan
					(
							cnsctvo_cdgo_pln			int
					)
	
	
			insert into #tpWSTraerTipoIdentificacion
					(	cdgo_tpo_idntfccn,		dscrpcn_tpo_idntfccn,				cnsctvo_cdgo_tpo_idntfccn,
						rngo_infrr,				rngo_sprr
					)
			exec    dbo.spWSTraerTipoIdentificacion  @tpo_idntfccn
	
			insert into #tpWSTraerPlan (cnsctvo_cdgo_pln)
			exec	dbo.spWSTraerPlan @pln

			select  @cnsctvo_cdgo_tpo_idntfccn = cnsctvo_cdgo_tpo_idntfccn 
			from  	#tpWSTraerTipoIdentificacion	With(NoLock)
	
			select  @cnsctvo_cdgo_pln = cnsctvo_cdgo_pln 
			from 	#tpWSTraerPlan	With(NoLock)

			Drop Table	#tpWSTraerTipoIdentificacion
			Drop Table	#tpWSTraerPlan
		end

	--select @cnsctvo_cdgo_pln
	If(@fechaConsulta Is Not Null)
		Begin
			exec BDAfiliacionValidador.dbo.spPmConsultaAfiliado_Historico @cnsctvo_cdgo_tpo_idntfccn, @nmro_idntfccn, @cnsctvo_cdgo_pln, @fechaConsulta, null, @fechaConsulta
		End
	Else
		Begin
			Set @fechaConsulta = isNull(@fechaConsulta,getDate())
			exec BDAfiliacionValidador.dbo.spPmConsultaAfiliado_AlDia @cnsctvo_cdgo_tpo_idntfccn, @nmro_idntfccn, @cnsctvo_cdgo_pln, null, null, @fechaConsulta
		End
	
	exec BDAfiliacionValidador.dbo.spPmDatosAdicionalesAfiliado @cnsctvo_cdgo_tpo_idntfccn,@nmro_idntfccn,@fechaConsulta

	IF @incluirEventoAfiliado = 'S'
		BEGIN
			exec BDAfiliacionValidador.dbo.spConsultaEventoAfiliadoWeb	@lnTipoIdAfiliado   = @cnsctvo_cdgo_tpo_idntfccn,    
																		@lnNmroIdAfiliado   = @nmro_idntfccn,    
																		@fcha_dsde          = null,    
																		@fcha_hsta          = @fechaConsulta;
		END
END


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spWEBConsultaAfiliado_AlDia] TO PUBLIC
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spWEBConsultaAfiliado_AlDia] TO [portal_rol]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spWEBConsultaAfiliado_AlDia] TO [Consultor Servicio al Cliente]
    AS [dbo];

