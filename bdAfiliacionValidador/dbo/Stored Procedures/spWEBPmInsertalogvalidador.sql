CREATE	procedure [dbo].[spWEBPmInsertalogvalidador]
(
@cdgo_usro 							UdtUsuario, 
@cnsctvo_cdgo_pln 					UdtConsecutivo, 
@cdgo_ips 							UdtCodigoIps	, 
@cnsctvo_cdgo_tpo_idntfccn			UdtConsecutivo, 
@nmro_idntfccn						UdtNumeroIdentificacion, 
@nmro_unco_idntfccn_afldo			UdtConsecutivo, 
@prmr_aplldo						UdtApellido, 
@sgndo_aplldo						UdtApellido,
@prmr_nmbre 						UdtNombre, 
@sgndo_nmbre 						UdtNombre, 
@fcha_ncmnto						datetime,
@edd 								int,
@edd_mss							int,
@edd_ds								int,
@cnsctvo_cdgo_tpo_undd 				UdtConsecutivo, 
@cnsctvo_cdgo_sxo 					UdtConsecutivo, 
@cnsctvo_cdgo_prntscs 				UdtConsecutivo, 
@inco_vgnca_bnfcro					datetime  ,
@fn_vgna_bnfcro						datetime,
@cnsctvo_cdgo_rngo_slrl				UdtConsecutivo,
@cnsctvo_cdgo_tpo_idntfccn_aprtnte	UdtConsecutivo, 
@nmro_idntfccn_aprtnte				UdtNumeroIdentificacion, 
@nmro_unco_idntfccn_aprtnte			UdtConsecutivo, 
@rzn_scl							varchar(200), 
@cnsctvo_cdgo_pln_pac				UdtConsecutivo, 
@cptdo								Udtlogico,
@cdgo_ips_cptcn						UdtCodigoIps,
@cnsctvo_cdgo_estdo_afldo			UdtConsecutivo, 
@smns_aflcn_ps						numeric,
@smns_aflcn_antrr_eps_ps			numeric,
@smns_aflcn_pc						numeric,
@smns_aflcn_antrr_eps_pc			numeric,
@smns_ctzds							numeric,
@txto_cta							varchar(50), 		
@txto_cpgo							varchar(50),
@drcho	      						udtDescripcion,
@cnsctvo_cdgo_tpo_afldo				UdtConsecutivo	,
@mdlo								udtConsecutivo,
@cnsctvo_cdgo_tpo_cntrto			UdtConsecutivo	,
@nmro_cntrto						UdtNumeroFormulario ,
@cnsctvo_bnfcro						UdtConsecutivo,	
@obsrvcns							UdtObservacion,
@orgn 								char(1),
@cnsctvo_cdgo_sde					UdtConsecutivo,
@nmro_atrzcn_espcl					UdtConsecutivo,
@cnsctvo_cdgo_csa_drcho				UdtConsecutivo,
@cnsctvo_prdcto_scrsl				UdtConsecutivo,
@cnsctvo_cdgo_mtvo					int	= null
)

AS
SET NOCOUNT ON

Begin
	Declare		@numero_verificacion	numeric(20,0), --out
				@usuario_oficina		varchar(100),  --out
				@codigo_oficina 		char(5),       --out
				@fcha_trnsmsn			datetime,
				@cnsctvo_cdgo_ofcna		UdtConsecutivo,
				@mdlo_var				varchar(100),
				@nmro_vrfcn_fnl		Varchar(20)

	set			@mdlo_var = convert(varchar(5),@mdlo)

	CREATE table	#tpWSConsultaFechaDatos
			(	lfFechaReferencia datetime
			)
	CREATE table	#tpWSConsultaOficinaUsuarioWeb
			(	cnsctvo_cdgo_ofcna	int,
				cdgo_ofcna			char(5),
				dscrpcn_ofcna		varchar(150)
			)

	insert into #tpWSConsultaFechaDatos
			(	lfFechaReferencia
			)
	exec		spPmFechaActualizacionDatos @fcha_trnsmsn output

	insert into #tpWSConsultaOficinaUsuarioWeb
			(	cnsctvo_cdgo_ofcna,cdgo_ofcna,	dscrpcn_ofcna
			)
	exec		spWSConsultaOficinaUsuarioWeb  @cdgo_usro

	select		@cnsctvo_cdgo_ofcna = cnsctvo_cdgo_ofcna
	from		#tpWSConsultaOficinaUsuarioWeb	With(NoLock)

	set		@txto_cta = isNull(@txto_cta,'')
	set		@txto_cpgo = isNull(@txto_cpgo,'')

	if	(isNull(@nmro_unco_idntfccn_aprtnte,0) > 0)
		Begin
			exec spPminsertalogvalidadorSipres	@cnsctvo_cdgo_ofcna,			@numero_verificacion	output,		@usuario_oficina	output,
												@cdgo_usro,						@cnsctvo_cdgo_pln,					@cdgo_ips,
												@cnsctvo_cdgo_tpo_idntfccn,		@nmro_idntfccn,						@nmro_unco_idntfccn_afldo,
												@prmr_aplldo,					@sgndo_aplldo,						@prmr_nmbre,
												@sgndo_nmbre,					@fcha_ncmnto,						@edd,
												@edd_mss,						@edd_ds,							@cnsctvo_cdgo_tpo_undd,
												@cnsctvo_cdgo_sxo,				@cnsctvo_cdgo_prntscs,				@inco_vgnca_bnfcro,
												@fn_vgna_bnfcro,				@cnsctvo_cdgo_rngo_slrl,			@cnsctvo_cdgo_tpo_idntfccn_aprtnte,
												@nmro_idntfccn_aprtnte,			@nmro_unco_idntfccn_aprtnte,		@rzn_scl,
												@cnsctvo_cdgo_pln_pac,			@cptdo,								@cdgo_ips_cptcn,
												@cnsctvo_cdgo_estdo_afldo,		@smns_aflcn_ps,						@smns_aflcn_antrr_eps_ps,
												@smns_aflcn_pc,					@smns_aflcn_antrr_eps_pc,			@smns_ctzds,
												@txto_cta,						@txto_cpgo,							@drcho,
												@cnsctvo_cdgo_tpo_afldo,		@mdlo_var,							@cnsctvo_cdgo_tpo_cntrto,
												@nmro_cntrto,					@cnsctvo_bnfcro,					@obsrvcns,
												@fcha_trnsmsn,					@orgn,								@cnsctvo_cdgo_sde,
												@nmro_atrzcn_espcl,				@cnsctvo_cdgo_csa_drcho,			@cnsctvo_prdcto_scrsl,
												@codigo_oficina	output,			@cnsctvo_cdgo_mtvo,					null,
												null,							null,								@nmro_vrfcn_fnl	output
		end

	Drop Table	#tpWSConsultaFechaDatos
	Drop Table	#tpWSConsultaOficinaUsuarioWeb
End




GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spWEBPmInsertalogvalidador] TO PUBLIC
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spWEBPmInsertalogvalidador] TO [Consultor Servicio al Cliente]
    AS [dbo];

