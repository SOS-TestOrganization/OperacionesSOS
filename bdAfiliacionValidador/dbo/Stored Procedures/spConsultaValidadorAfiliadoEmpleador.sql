CREATE PROCEDURE [dbo].[spConsultaValidadorAfiliadoEmpleador](
	@cnsctvo_cdgo_tpo_cntrto	UdtConsecutivo, 
	@nmro_cntrto				UdtNumeroFormulario,
	@fcha_Vldcn					datetime,
	@cnsctvo_cdgo_pln   		UdtConsecutivo,
	@cnsctvo_tpo_idntfccn       UdtConsecutivo,
	@nmro_idntfccn   			UdtNumeroIdentificacion,
	@cdgo_eapb					char(1),
	@cnsctvo_cdgo_tpo_frmlro	UdtConsecutivo,
	@nmro_frmlro				UdtNumeroFormulario,
	@cnsctvo_cdgo_rngo_slrl     Udtconsecutivo, 
	@cnsctvo_cdgo_tpo_afldo     Udtconsecutivo,
	@fcha_vldcn_cnvno			datetime
)
AS

/*
Declare @cnsctvo_cdgo_tpo_cntrto	UdtConsecutivo, 
		@nmro_cntrto				UdtNumeroFormulario,
		@fcha_Vldcn					datetime,
		@cnsctvo_cdgo_pln   		UdtConsecutivo,
		@cnsctvo_tpo_idntfccn       UdtConsecutivo,
		@nmro_idntfccn   			UdtNumeroIdentificacion,
		@cdgo_eapb					char(1),
		@cnsctvo_cdgo_tpo_frmlro	UdtConsecutivo,
		@nmro_frmlro				UdtNumeroFormulario,
		@cnsctvo_cdgo_rngo_slrl     Udtconsecutivo, 
		@cnsctvo_cdgo_tpo_afldo     Udtconsecutivo,
		@fcha_vldcn_cnvno			datetime

Set		@cnsctvo_cdgo_tpo_cntrto	= 1--2 
Set		@nmro_cntrto				= '1138291'--'824990'--274695         --370379
Set		@fcha_Vldcn					= '2017-05-11 13:07:41.317'
Set		@cnsctvo_cdgo_pln   		= 1--2
Set		@cnsctvo_tpo_idntfccn       = 1
Set		@nmro_idntfccn   			= '1130627868'--'10023048'--31256043          --94501259
Set		@cdgo_eapb					= NULL --es char null?
Set		@cnsctvo_cdgo_tpo_frmlro	= 0
Set		@nmro_frmlro				= NULL --es string null?
Set		@cnsctvo_cdgo_rngo_slrl     = 2--1--3--4 
Set		@cnsctvo_cdgo_tpo_afldo     = 1--2--3--1
Set		@fcha_vldcn_cnvno			= '2017-05-11 11:07:41.317'
*/

BEGIN
	SET NOCOUNT ON;

	Declare @empleadores table
		(	idntfccn_cmplta_empldr		varchar(30),
			rzn_scl						varchar(200),
			nmro_idntfccn				varchar(23),
			cnsctvo_cdgo_tpo_idntfccn	int,
			nmro_unco_idntfccn_aprtnte	int,
			cdgo_tpo_idntfccn			varchar(3),
			prncpl 						char,
			cnsctvo_scrsl_ctznte		int,
			cnsctvo_cdgo_crgo_empldo	int,
			cnsctvo_cdgo_clse_aprtnte	int,
			cnsctvo_cdgo_tpo_ctznte		int,
			inco_vgnca_cbrnza			datetime,
			fn_vgnca_cbrnza				datetime,
			cnsctvo_cdgo_tpo_cbrnza		int,
			cnsctvo_cbrnza				int,
			slro_bsco					int,
			cnsctvo_cdgo_tpo_cntrto		int,
			nmro_cntrto					varchar(15),
			cnsctvo_prdcto_scrsl		int,
			cnsctvo_scrsl				int,
			cnsctvo_cdgo_actvdd_ecnmca	int,
			cnsctvo_cdgo_arp			int,
			drccn						varchar(80),
			tlfno						varchar(30),
			cdgo_actvdd_ecnmca			char(4),
			dscrpcn_actvdd_ecnmca		varchar(150),
			cdgo_crgo					char(4),
			dscrpcn_crgo				varchar(150),
			cdgo_entdd					char(8),
			dscrpcn_entdd				varchar(150),
			cdgo_tpo_ctznte				char(2),
			dscrpcn_tpo_ctznte			varchar(150),
			nmbre_cntcto				varchar(140),
			tlfno_cntcto				udtTelefono,
			eml_cntcto					udtEmail,
			cnsctvo_cdgo_cdd			udtconsecutivo,
			cdgo_cdd					char(8),
			dscrpcn_cdd					udtDescripcion,
			cnsctvo_cdgo_dprtmnto		udtConsecutivo,
			cdgo_dprtmnto				char(3),
			dscrpcn_dprtmnto			udtDescripcion,
			eml							udtEmail,
			cdgo_cnvno_cmrcl			char(2),
			dscrpcn_cnvno_cmrcl			char(150),
			txto_cpgo_cta_mdrdra		varchar(500),
			txto_cpgo					varchar(200),  
			txto_cta_mdrdra				varchar(200)
		);

	Declare @tmpFinalTexto table(
		txto_cpgo_cta_mdrdra			varchar(500),
		txto_cpgo						varchar(200),  
		txto_cta_mdrdra					varchar(200),
		cnsctvo_mdlo					int,	
		dscrpcn_txto_cpgo				varchar(150), 
		dscrpcn_cdgo_txto_cta_mdrdra	varchar(150), 
		cnsctvo_cdgo_rngo_slrl			int, 
		cnsctvo_cdgo_tpo_afldo			int,
		cnsctvo_cdgo_txto_cpgo			int, 
		cnsctvo_cdgo_txto_cta_mdrdra	int,
		txto_adcnl						varchar(150),
		cnsctvo_prdcto_scrsl			Int
	);

	Create Table #tmpParametros
		(
			cnsctvo_prdcto_scrsl		Int,
			cnsctvo_cdgo_rngo_slrl		Int,
			cnsctvo_cdgo_tpo_afldo		Int
		);

	INSERT INTO	@empleadores
			(	cdgo_tpo_idntfccn,					nmro_idntfccn, rzn_scl,				idntfccn_cmplta_empldr,			cnsctvo_cdgo_tpo_idntfccn,
				nmro_unco_idntfccn_aprtnte,			prncpl,								cnsctvo_scrsl_ctznte,			cnsctvo_cdgo_crgo_empldo,
				cnsctvo_cdgo_clse_aprtnte,			cnsctvo_cdgo_tpo_ctznte,			inco_vgnca_cbrnza,				fn_vgnca_cbrnza,
				cnsctvo_cdgo_tpo_cbrnza,			cnsctvo_cbrnza,						slro_bsco,						cnsctvo_cdgo_tpo_cntrto,
				nmro_cntrto,						cnsctvo_prdcto_scrsl,				cnsctvo_scrsl,					cnsctvo_cdgo_actvdd_ecnmca,
				cnsctvo_cdgo_arp,					drccn,								tlfno,							cdgo_actvdd_ecnmca,
				dscrpcn_actvdd_ecnmca,				cdgo_crgo,							dscrpcn_crgo,					cdgo_entdd,
				dscrpcn_entdd,						cdgo_tpo_ctznte,					dscrpcn_tpo_ctznte,				nmbre_cntcto,
				tlfno_cntcto,						eml_cntcto,							cnsctvo_cdgo_cdd,				cdgo_cdd,
				dscrpcn_cdd,						cnsctvo_cdgo_dprtmnto,				cdgo_dprtmnto,					dscrpcn_dprtmnto,
				eml,								cdgo_cnvno_cmrcl,					dscrpcn_cnvno_cmrcl
	)
	EXEC [dbo].[spPmConsultaDetEmpleadoresAfiliado]	@cnsctvo_cdgo_tpo_cntrto	= @cnsctvo_cdgo_tpo_cntrto, 
													@nmro_cntrto				= @nmro_cntrto,
													@fcha_Vldcn					= @fcha_Vldcn,
													@cnsctvo_cdgo_pln   		= @cnsctvo_cdgo_pln,
													@cnsctvo_tpo_idntfccn       = @cnsctvo_tpo_idntfccn,
													@nmro_idntfccn   			= @nmro_idntfccn,
													@cdgo_eapb					= @cdgo_eapb,
													@cnsctvo_cdgo_tpo_frmlro	= @cnsctvo_cdgo_tpo_frmlro,
													@nmro_frmlro				= @nmro_frmlro;
	Insert Into	#tmpParametros
	Select		cnsctvo_prdcto_scrsl,	@cnsctvo_cdgo_rngo_slrl,	@cnsctvo_cdgo_tpo_afldo
	From		@empleadores;

	INSERT INTO @tmpFinalTexto
	EXEC		[dbo].[spWSInformacionConvenioCaja]	@cnsctvo_cdgo_pln,	@fcha_Vldcn

	Update		@empleadores
	Set			txto_cpgo_cta_mdrdra	= t.txto_cpgo_cta_mdrdra,
				txto_cpgo				= t.txto_cpgo,
				txto_cta_mdrdra			= t.txto_cta_mdrdra
	From		@empleadores	e
	Inner Join	@tmpFinalTexto	t	On	t.cnsctvo_prdcto_scrsl	=	e.cnsctvo_prdcto_scrsl

	SELECT	e.cdgo_tpo_idntfccn,		e.nmro_idntfccn,		e.rzn_scl,					e.cnsctvo_cdgo_tpo_idntfccn,		e.nmro_unco_idntfccn_aprtnte,
			e.inco_vgnca_cbrnza,		e.fn_vgnca_cbrnza,		e.cnsctvo_prdcto_scrsl,		e.cnsctvo_scrsl,					e.cdgo_actvdd_ecnmca,
			e.dscrpcn_actvdd_ecnmca,	e.cdgo_crgo,			e.dscrpcn_crgo,				e.cdgo_entdd,						e.dscrpcn_entdd,
			e.cdgo_tpo_ctznte,			e.dscrpcn_tpo_ctznte,	e.drccn,					tlfno,								e.cdgo_cdd,
			e.dscrpcn_cdd,				e.cdgo_dprtmnto,		e.dscrpcn_dprtmnto,			e.cdgo_cnvno_cmrcl,					e.dscrpcn_cnvno_cmrcl,
			e.eml,						e.txto_cpgo_cta_mdrdra, e.txto_cpgo,				e.txto_cta_mdrdra
	From	@empleadores e;
END

Drop Table #tmpParametros;


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaValidadorAfiliadoEmpleador] TO [webusr]
    AS [dbo];

