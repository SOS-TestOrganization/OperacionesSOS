CREATE PROCEDURE [dbo].[spPmConsultaAfiliado_Historico]
@cnsctvo_cdgo_tpo_idntfccn 	udtConsecutivo,
@nmro_idntfccn				Varchar(23),
@cnsctvo_cdgo_pln 			udtConsecutivo,
@fcha_vldccn				datetime	= NULL,
@mnsje						varchar(80)	Output,
@lfFechaReferencia			datetime	Output

/*
Set	@cnsctvo_cdgo_tpo_idntfccn	= 1
Set	@nmro_idntfccn				= '94526804'
Set	@cnsctvo_cdgo_pln			= 1--8
set	@fcha_vldccn			=	'2015-05-01'
Set	@mnsje						= ''
--Set	@origen					= null
Set	@lfFechaReferencia		= ''
*/

As
Set NoCount On

-- Declaración de variables
Declare		@Nui_Afldo					UdtConsecutivo,
			@Bd 						char(1),
			@inco_vgnca_bnfcro			Datetime,
			@fcha_ultma_mdfccn			Datetime,
			--@lfFechaReferencia		datetime,
			@dFcha_pvte					datetime,
			@Historico					char(1),
			@fecha_minima				datetime,
			@maximafechabeneficiario	datetime,
			@fcha_mxma_rprte			datetime, /*campo adicionado 20150511*/
			@nmbre_srvdr				VarChar(50),
			@hst_nme					VarChar(50),
			@cdna_vrble_hstrco_bnfcro	VarChar(250)

---- ORENDA
Select		@nmbre_srvdr = Ltrim(Rtrim(vlr_prmtro))  
From		tbtablaParametros  With(NoLock)
Where		cnsctvo_prmtro = 5

Select		@hst_nme = Ltrim(Rtrim(Convert(Varchar(30), SERVERPROPERTY('machinename'))))
Set			@Bd = null
Set			@cdna_vrble_hstrco_bnfcro	=	char(39)+'cdgo_intrno'+char(39)+','+char(39)+'cnsctvo_cdgo_prntsco'+char(39)+','+char(39)+'cnsctvo_cdgo_tpo_afldo'+char(39)+','+
											char(39)+'fcha_ncmnto'+char(39)+','+char(39)+'smns_ctzds'+char(39)+','+char(39)+'smns_ctzds_antrr_eps'+char(39)

Declare	@tb_tmpAfiliado Table
		(	prmr_aplldo					varchar(50),	sgndo_aplldo				varchar(50),		prmr_nmbre				varchar(20),		sgndo_nmbre					varchar(20),
			cnsctvo_cdgo_tpo_idntfccn	int,			nmro_idntfccn				varchar(23),		fcha_ncmnto				datetime,			cnsctvo_cdgo_sxo			int,
			cdgo_sxo					char(2),		edd							int,				edd_mss 				int,				edd_ds 						int,
			cnsctvo_cdgo_tpo_undd		int,			orgn						char(1),			cnsctvo_cdgo_tpo_cntrto	int,				nmro_cntrto					char(15),
			cnsctvo_cdgo_pln			int,			nmro_unco_idntfccn_afldo	int,				inco_vgnca_bnfcro		datetime,			fn_vgnca_bnfcro				datetime,
			cnsctvo_cdgo_prntsco		int,			dscrpcn_prntsco				varchar(150),		cnsctvo_cdgo_tpo_afldo 	int, 				dscrpcn_tpo_afldo			varchar(150),
			cnsctvo_cdgo_rngo_slrl 		int,			dscrpcn_rngo_slrl 			varchar(150),		cnsctvo_cdgo_pln_pc		int,				dscrpcn_pln_pc				varchar(150),
			smns_ctzds_ss_ps			int,			smns_ctzds_eps_ps			int,				smns_ctzds_ss_pc		int,				smns_ctzds_eps_pc			int,
			cdgo_ips_prmra				char(8),		dscrpcn_ips_prmra			varchar(150),		cnsctvo_bnfcro			int,				cdgo_eapb					varchar(3) null,
			nmro_unco_idntfccn_ctznte 	int,			cnsctvo_cdgo_tpo_cntrto_psc	int,				nmro_cntrto_psc			char(15),			ds_ctzds					numeric,
			cnsctvo_cdgo_sde_ips		int default 0,	dscrpcn_tpo_cntrto			varchar(150),		cnsctvo_cdgo_csa_drcho	int,				cnsctvo_cdgo_estdo_drcho	int,
			dscrpcn_estdo_drcho			varchar(150),	dscrpcn_csa_drcho			varchar(150),		dscrpcn_drcho			varchar(150),		dscrpcn_pln					varchar(150),
			dscrpcn_tpo_ctznte			varchar(150),	prmr_nmbre_ctznte			char(20),			sgndo_nmbre_ctznte		char(20),			prmr_aplldo_ctznte			char(50),
			sgndo_aplldo_ctznte			char(50),		drccn_rsdnca				varchar(80),		tlfno_rsdnca			char(30),			cnsctvo_cdgo_cdd_rsdnca 	int,
			dscrpcn_cdd_rsdnca 			varchar(150),	cnsctvo_cdgo_estdo_cvl 		int,				dscrpcn_estdo_cvl 		varchar(150),		cnsctvo_cdgo_tpo_frmlro		Int,
			nmro_frmlro					Char(15),		cdgo_tpo_idntfccn			char(3),			cnsctvo_cdgo_afp		int,				fcha_dsde					datetime,
			fcha_hsta					datetime,		flg_enble_nmro_vldcn		char default 'N',	drcho					char,				cdgo_afp					char(8),
			cnsctvo_tpo_vldcn_actva		int Default 3,	cfcha_ncmnto				char(10),			smns_aflcn_ss_ps		int DEFAULT 0,		smns_aflcn_eps_ps			int DEFAULT 0,
			smns_aflcn_ss_pc			int DEFAULT 0,	smns_aflcn_eps_pc			int DEFAULT 0,		smns_ctzds_eps			int DEFAULT 0,		cdgo_tpo_prntsco  			char(3),
			cdgo_cdd 					char(8) , 		cdgo_rngo_slrl 				char(3),			cdgo_tpo_afldo 			char(3), 			cdgo_tpo_idntfccn_ctznte 	char(3),
			nmro_idntfccn_ctznte 		char(15),		cnsctvo_tpo_idntfccn_ctznte	int,				cnsctvo_dcmnto_gnrdo	int DEFAULT 0,		nmro_dcmnto					Char(50) DEFAULT '',
			cdgo_estdo_drcho			char(2),		eml							varchar(50)  --Adicion de Campo 2009/12/11 sisatv01
	)

Set @lfFechaReferencia = @fcha_vldccn

Create Table #tmpBeneficiariosValidador
		(
			cnsctvo_cdgo_tpo_cntrto		Int NOT NULL,
			nmro_cntrto					VarChar(15) NOT NULL,
			cnsctvo_bnfcro				Int NOT NULL,
			nmro_unco_idntfccn_afldo	Int NOT NULL,
			cnsctvo_cdgo_tpo_idntfccn	Int NOT NULL,
			nmro_idntfccn				VarChar(20) NOT NULL,
			inco_vgnca_bnfcro			Datetime NOT NULL,
			fn_vgnca_bnfcro				Datetime NOT NULL,
			cnsctvo_cdgo_tpo_afldo		Int NOT NULL,
			cnsctvo_cdgo_prntsco		Int NOT NULL,
			estdo						Char(1) NOT NULL,
			prmr_aplldo					VarChar(50) NOT NULL,
			sgndo_aplldo				VarChar(50) NOT NULL,
			prmr_nmbre					VarChar(20) NOT NULL,
			sgndo_nmbre					VarChar(20) NOT NULL,
			smns_ctzds					Int NOT NULL,
			smns_ctzds_antrr_eps		Int NOT NULL,
			tlfno_rsdnca				VarChar(30) NOT NULL,
			drccn_rsdnca				VarChar(80) NOT NULL,
			cnsctvo_cdgo_cdd_rsdnca		Int NOT NULL,
			cdgo_intrno					Char(8) NULL,
			cnsctvo_cdgo_sxo			Int NOT NULL,
			cnsctvo_cdgo_estdo_cvl		Int NOT NULL,
			fcha_ncmnto					Datetime NOT NULL,
			cnsctvo_cdgo_brro			Int NOT NULL,
			cnsctvo_cdgo_estrto_sccnmco	Int NOT NULL,
			smns_aflcn					Int NOT NULL,
			smns_aflcn_antrr_eps		Int NOT NULL,
			eml							VarChar(50) NULL
		)

Create Clustered Index [idx_bnfcro]
On	#tmpBeneficiariosValidador	([cnsctvo_cdgo_tpo_cntrto], [nmro_cntrto], [cnsctvo_bnfcro])

Create Table #tmpVigenciasBeneficiariosValidador
		(
			cnsctvo_cdgo_tpo_cntrto	Int,
			nmro_cntrto				VarChar(15),
			cnsctvo_bnfcro			Int,
			inco_vgnca_estdo_bnfcro	DateTime,
			fn_vgnca_estdo_bnfcro	DateTime,
			estdo					Char(1)
		)

Create Clustered Index [idx_bnfcro]
On	#tmpVigenciasBeneficiariosValidador	([cnsctvo_cdgo_tpo_cntrto], [nmro_cntrto], [cnsctvo_bnfcro])

CREATE TABLE #tmpContratosValidador
		(
			cnsctvo_cdgo_tpo_cntrto		Int	NOT NULL,
			nmro_cntrto					VarChar(15) NOT NULL,
			nmro_unco_idntfccn_afldo	Int NOT NULL,
			cnsctvo_cdgo_tpo_idntfccn	Int NOT NULL,
			nmro_idntfccn				VarChar(20) NOT NULL,
			cnsctvo_cdgo_pln			Int NOT NULL,
			prmr_aplldo					VarChar(50) NOT NULL,
			sgndo_aplldo				VarChar(50) NOT NULL,
			prmr_nmbre					VarChar(20) NOT NULL,
			sgndo_nmbre					VarChar(20) NOT NULL,
			inco_vgnca_cntrto			Datetime NOT NULL,
			fn_vgnca_cntrto				Datetime NOT NULL,
			cnsctvo_cdgo_rngo_slrl		Int NOT NULL,
			cnsctvo_cdgo_afp			Int NOT NULL
		)

Create Clustered Index [idx_cntrto]
On	#tmpContratosValidador	([cnsctvo_cdgo_tpo_cntrto], [nmro_cntrto])

Create Table	#tmpHistoricoBeneficiariosValidador
	(
		cnsctvo_cdgo_tpo_cntrto	Int,
		nmro_cntrto				VarChar(15),
		cnsctvo_bnfcro			Int,
		dscrpcn_cmpo			VarChar(150),
		vlr_cmpo				VarChar(150),
		inco_vgnca				Datetime,
		fn_vgnca				Datetime
	)

Insert Into	#tmpBeneficiariosValidador
Select		cnsctvo_cdgo_tpo_cntrto,			nmro_cntrto,					cnsctvo_bnfcro,								nmro_unco_idntfccn_afldo,
			cnsctvo_cdgo_tpo_idntfccn,			nmro_idntfccn,					Convert(char(10),inco_vgnca_bnfcro,111),	Convert(char(10),fn_vgnca_bnfcro,111),
			cnsctvo_cdgo_tpo_afldo,				cnsctvo_cdgo_prntsco,			estdo,										Ltrim(Rtrim(prmr_aplldo)),
			Ltrim(Rtrim(sgndo_aplldo)),			Ltrim(Rtrim(prmr_nmbre)),		Ltrim(Rtrim(sgndo_nmbre)),					smns_ctzds,
			smns_ctzds_antrr_eps,				tlfno_rsdnca,					drccn_rsdnca,								cnsctvo_cdgo_cdd_rsdnca,
			cdgo_intrno,						cnsctvo_cdgo_sxo,				cnsctvo_cdgo_estdo_cvl,						fcha_ncmnto,
			cnsctvo_cdgo_brro,					cnsctvo_cdgo_estrto_sccnmco,	smns_aflcn,									smns_aflcn_antrr_eps,
			eml
From		BDAfiliacionValidador.dbo.tbBeneficiariosValidador	With(NoLock)
Where		cnsctvo_cdgo_tpo_idntfccn	= @cnsctvo_cdgo_tpo_idntfccn
And			nmro_idntfccn				= @nmro_idntfccn

Insert Into #tmpVigenciasBeneficiariosValidador
Select		v.cnsctvo_cdgo_tpo_cntrto,							v.nmro_cntrto,			v.cnsctvo_bnfcro,	Convert(char(10),v.inco_vgnca_estdo_bnfcro,111),
			Convert(char(10),v.fn_vgnca_estdo_bnfcro,111),		a.estdo
From		BDAfiliacionValidador.dbo.tbVigenciasBeneficiariosValidador	v	With(NoLock)
Inner Join	#tmpBeneficiariosValidador									a	With(NoLock)	On	a.cnsctvo_cdgo_tpo_cntrto	=	v.cnsctvo_cdgo_tpo_cntrto
																							And	a.nmro_cntrto				=	v.nmro_cntrto
																							And	a.cnsctvo_bnfcro			=	v.cnsctvo_bnfcro
Where		@fcha_vldccn Between v.inco_vgnca_estdo_bnfcro And v.fn_vgnca_estdo_bnfcro

Insert Into	#tmpContratosValidador
Select		c.cnsctvo_cdgo_tpo_cntrto,			c.nmro_cntrto,					c.nmro_unco_idntfccn_afldo,						c.cnsctvo_cdgo_tpo_idntfccn,
			c.nmro_idntfccn,					c.cnsctvo_cdgo_pln,				Ltrim(Rtrim(c.prmr_aplldo)),					Ltrim(Rtrim(c.sgndo_aplldo)),
			Ltrim(Rtrim(c.prmr_nmbre)),			Ltrim(Rtrim(c.sgndo_nmbre)),	Convert(char(10),c.inco_vgnca_cntrto,111),		Convert(char(10),c.fn_vgnca_cntrto,111),
			c.cnsctvo_cdgo_rngo_slrl,			c.cnsctvo_cdgo_afp
From		BDAfiliacionValidador.dbo.tbContratosValidador	c	With(NoLock)
Inner Join	#tmpBeneficiariosValidador						a	With(NoLock)	On	a.cnsctvo_cdgo_tpo_cntrto	=	c.cnsctvo_cdgo_tpo_cntrto
																				And	a.nmro_cntrto				=	c.nmro_cntrto

Insert Into	#tmpHistoricoBeneficiariosValidador
Select		t.cnsctvo_cdgo_tpo_cntrto,			t.nmro_cntrto,				t.cnsctvo_bnfcro,				b.dscrpcn_cmpo,
			b.vlr_cmpo,							b.inco_vgnca,				b.fn_vgnca
From		tbHistoricoBeneficiariosValidador	b	With(NoLock)
Inner Join	#tmpBeneficiariosValidador			t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
													And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
													And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
Where		b.dscrpcn_cmpo	In	(@cdna_vrble_hstrco_bnfcro)

If @Bd Is Null
	If Exists	(	Select		1
					From		#tmpBeneficiariosValidador				a	With(NoLock)
					Inner Join	#tmpContratosValidador					b	With(NoLock)	On	a.nmro_cntrto				=	b.nmro_cntrto
																							And	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
					Inner Join	#tmpVigenciasBeneficiariosValidador		c	With(NoLock)	On	c.cnsctvo_cdgo_tpo_cntrto	=	a.cnsctvo_cdgo_tpo_cntrto
																							And	c.nmro_cntrto				=	a.nmro_cntrto
																							And	c.cnsctvo_bnfcro			=	a.cnsctvo_bnfcro
					Where		--a.cnsctvo_cdgo_tpo_idntfccn	= @cnsctvo_cdgo_tpo_idntfccn
					--And			a.nmro_idntfccn				= @nmro_idntfccn
								b.cnsctvo_cdgo_pln			= @cnsctvo_cdgo_pln
					--And			@fcha_vldccn Between c.inco_vgnca_estdo_bnfcro And c.fn_vgnca_estdo_bnfcro
				)
		Begin
			Select @Bd 	= '1'  -- Contratos
			Select @mnsje 	= 'CONTRATOS HISTORICOS'
		End
	Else
		Begin
			Select @Bd = '4'  -- Ninguna
			Select @mnsje 	= 'No existe en el Sistema'
		End
Else
	Begin
		Select @mnsje 	=	Case	@bd	When	'1' Then 'CONTRATOS'
										When	'2' Then 'FAMISANAR'
										When	'3' Then 'FORMULARIOS'
										When	'4' Then 'NO EXISTE EN EL SISTEMA'
							End
	End

--Set	@bd = '1'
--Set @mnsje = 'CONTRATOS'

If  @Bd = '1' -- Contratos
	Begin
		Insert Into @tb_tmpAfiliado
		(			prmr_aplldo,					sgndo_aplldo,					prmr_nmbre,						sgndo_nmbre,				cnsctvo_cdgo_tpo_idntfccn,
					nmro_idntfccn,					fcha_ncmnto,					cnsctvo_cdgo_sxo,				orgn,						cnsctvo_cdgo_tpo_cntrto,
					nmro_cntrto,					cnsctvo_cdgo_pln,				nmro_unco_idntfccn_afldo,		inco_vgnca_bnfcro,			fn_vgnca_bnfcro,
					cnsctvo_cdgo_prntsco,			cnsctvo_cdgo_tpo_afldo,			cnsctvo_cdgo_rngo_slrl,			cdgo_ips_prmra,				cnsctvo_bnfcro,
					cnsctvo_cdgo_afp,				fcha_dsde,						fcha_hsta,						tlfno_rsdnca,				drccn_rsdnca,
					cnsctvo_cdgo_cdd_rsdnca,		prmr_nmbre_ctznte,				sgndo_nmbre_ctznte,				prmr_aplldo_ctznte,			sgndo_aplldo_ctznte,
					cnsctvo_tpo_idntfccn_ctznte,	nmro_idntfccn_ctznte,			nmro_unco_idntfccn_ctznte,		eml
		)
		Select		b.prmr_aplldo,					b.sgndo_aplldo,					b.prmr_nmbre,					b.sgndo_nmbre,				b.cnsctvo_cdgo_tpo_idntfccn,
					b.nmro_idntfccn,				b.fcha_ncmnto,					b.cnsctvo_cdgo_sxo,				'1',						b.cnsctvo_cdgo_tpo_cntrto,
					b.nmro_cntrto,					c.cnsctvo_cdgo_pln,				b.nmro_unco_idntfccn_afldo,		a.inco_vgnca_estdo_bnfcro,	a.fn_vgnca_estdo_bnfcro,
					b.cnsctvo_cdgo_prntsco,			b.cnsctvo_cdgo_tpo_afldo,		c.cnsctvo_cdgo_rngo_slrl,		b.cdgo_intrno,				a.cnsctvo_bnfcro,
					c.cnsctvo_cdgo_afp,				a.inco_vgnca_estdo_bnfcro,		a.fn_vgnca_estdo_bnfcro,		b.tlfno_rsdnca,				b.drccn_rsdnca,
					b.cnsctvo_cdgo_cdd_rsdnca,		c.prmr_aplldo,					c.sgndo_aplldo,					c.prmr_nmbre,				c.sgndo_nmbre,
					c.cnsctvo_cdgo_tpo_idntfccn,	c.nmro_idntfccn,				c.nmro_unco_idntfccn_afldo,		isnull(b.eml,'') as eml
		From		#tmpBeneficiariosValidador				b	With(NoLock)
		Inner Join	#tmpContratosValidador					c	With(NoLock)	On	b.nmro_cntrto				=	c.nmro_cntrto
																				And	b.cnsctvo_cdgo_tpo_cntrto	=	c.cnsctvo_cdgo_tpo_cntrto
		Inner Join	#tmpVigenciasBeneficiariosValidador		a	With(NoLock)	On	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
																				And	a.nmro_cntrto				=	b.nmro_cntrto
																				And	a.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro
		Where		c.cnsctvo_cdgo_pln			= @cnsctvo_cdgo_pln
	--	And			b.cnsctvo_cdgo_tpo_idntfccn	= @cnsctvo_cdgo_tpo_idntfccn
	--	And			b.nmro_idntfccn				= @nmro_idntfccn
	--	And			@fcha_vldccn Between a.inco_vgnca_estdo_bnfcro And a.fn_vgnca_estdo_bnfcro
	
		Update		@tb_tmpAfiliado
		Set			cdgo_ips_prmra	= rtrim(ltrim(b.vlr_cmpo))
		From		#tmpHistoricoBeneficiariosValidador	b	With(NoLock)
		Inner Join	@tb_tmpAfiliado						t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
															And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
															And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
		Where		b.dscrpcn_cmpo			= 'cdgo_intrno'
		And			@fcha_vldccn between b.inco_vgnca and b.fn_vgnca

		IF @@RowCount = 0
			Begin
				select		@fecha_minima = min(b.inco_vgnca)
				From		#tmpHistoricoBeneficiariosValidador	b	With(NoLock)
				Inner Join	@tb_tmpAfiliado						t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																	And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																	And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
				Where		b.dscrpcn_cmpo			= 'cdgo_intrno'
				and			b.inco_vgnca > @fcha_vldccn

				Update		@tb_tmpAfiliado
				Set			cdgo_ips_prmra	= rtrim(ltrim(b.vlr_cmpo))
				From		#tmpHistoricoBeneficiariosValidador	b
				Inner Join	@tb_tmpAfiliado						t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																	And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																	And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
				Where		b.dscrpcn_cmpo			= 'cdgo_intrno'
				And			@fecha_minima	between	b.inco_vgnca	and	b.fn_vgnca
			End

		Update		@tb_tmpAfiliado
		Set			cnsctvo_cdgo_prntsco	= rtrim(ltrim(b.vlr_cmpo))
		From		#tmpHistoricoBeneficiariosValidador	b	With(NoLock)
		Inner Join	@tb_tmpAfiliado						t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
															And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
															And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
		Where		b.dscrpcn_cmpo			= 'cnsctvo_cdgo_prntsco'
		And			@fcha_vldccn between b.inco_vgnca and b.fn_vgnca
	
		IF @@RowCount = 0
			Begin
				select		@fecha_minima = min(b.inco_vgnca)
				From		#tmpHistoricoBeneficiariosValidador	b	With(NoLock)
				Inner Join	@tb_tmpAfiliado						t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																	And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																	And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
				Where		b.dscrpcn_cmpo			= 'cnsctvo_cdgo_prntsco'
				And			b.inco_vgnca > @fcha_vldccn

				Update		@tb_tmpAfiliado
				Set			cnsctvo_cdgo_prntsco	= rtrim(ltrim(b.vlr_cmpo))
				From		#tmpHistoricoBeneficiariosValidador	b	With(NoLock)
				Inner Join	@tb_tmpAfiliado						t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																	And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																	And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
				Where		b.dscrpcn_cmpo			= 'cnsctvo_cdgo_prntsco'
				And			@fecha_minima	between	b.inco_vgnca	and	b.fn_vgnca
			End
	
		Update		@tb_tmpAfiliado
		Set			cnsctvo_cdgo_tpo_afldo	= rtrim(ltrim(b.vlr_cmpo))
		From		#tmpHistoricoBeneficiariosValidador	b	With(NoLock)
		Inner Join	@tb_tmpAfiliado						t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
															And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
															And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
		Where		b.dscrpcn_cmpo			= 'cnsctvo_cdgo_tpo_afldo'
		And			@fcha_vldccn between b.inco_vgnca and b.fn_vgnca
	
		IF @@RowCount = 0
			Begin
				select		@fecha_minima = min(b.inco_vgnca)
				From		#tmpHistoricoBeneficiariosValidador	b	With(NoLock)
				Inner Join	@tb_tmpAfiliado						t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																	And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																	And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
				Where		b.dscrpcn_cmpo			= 'cnsctvo_cdgo_tpo_afldo'
				and			b.inco_vgnca > @fcha_vldccn

				Update		@tb_tmpAfiliado
				Set			cnsctvo_cdgo_tpo_afldo	= rtrim(ltrim(b.vlr_cmpo))
				From		#tmpHistoricoBeneficiariosValidador	b	With(NoLock)
				Inner Join	@tb_tmpAfiliado						t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																	And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																	And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
				Where		b.dscrpcn_cmpo			= 'cnsctvo_cdgo_tpo_afldo'
				And			@fecha_minima between b.inco_vgnca and b.fn_vgnca
			End

		Update		@tb_tmpAfiliado
		Set			fcha_ncmnto	= rtrim(ltrim(b.vlr_cmpo))
		From		#tmpHistoricoBeneficiariosValidador	b	With(NoLock)
		Inner Join	@tb_tmpAfiliado						t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
															And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
															And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
		Where		b.dscrpcn_cmpo			= 'fcha_ncmnto'
		And			@fcha_vldccn between b.inco_vgnca and b.fn_vgnca
	

		IF @@RowCount = 0
			Begin
				select		@fecha_minima = min(b.inco_vgnca)
				From		#tmpHistoricoBeneficiariosValidador	b	With(NoLock)
				Inner Join	@tb_tmpAfiliado						t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																	And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																	And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
				Where		b.dscrpcn_cmpo			= 'fcha_ncmnto'
				and			b.inco_vgnca > @fcha_vldccn

				Update		@tb_tmpAfiliado
				Set			fcha_ncmnto	= rtrim(ltrim(b.vlr_cmpo))
				From		#tmpHistoricoBeneficiariosValidador	b	With(NoLock)
				Inner Join	@tb_tmpAfiliado						t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																	And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																	And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
				Where		b.dscrpcn_cmpo			= 'fcha_ncmnto'
				And			@fecha_minima between b.inco_vgnca and b.fn_vgnca
			End
	
		Update		@tb_tmpAfiliado
		Set			smns_ctzds_ss_ps	= rtrim(ltrim(b.vlr_cmpo))
		From		#tmpHistoricoBeneficiariosValidador	b	With(NoLock)
		Inner Join	@tb_tmpAfiliado						t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
															And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
															And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
		Where		b.dscrpcn_cmpo			= 'smns_ctzds'
		And			@fcha_vldccn between b.inco_vgnca and b.fn_vgnca

		IF @@RowCount = 0
			Begin
				select		@fecha_minima = min(b.inco_vgnca)
				From		#tmpHistoricoBeneficiariosValidador	b	With(NoLock)
				Inner Join	@tb_tmpAfiliado						t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																	And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																	And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
				Where		b.dscrpcn_cmpo			= 'smns_ctzds'
				and			b.inco_vgnca > @fcha_vldccn

				Update		@tb_tmpAfiliado
				Set			smns_ctzds_ss_ps	= rtrim(ltrim(b.vlr_cmpo))
				From		#tmpHistoricoBeneficiariosValidador	b	With(NoLock)
				Inner Join	@tb_tmpAfiliado						t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																	And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																	And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
				Where		b.dscrpcn_cmpo			= 'smns_ctzds'
				And			@fecha_minima between b.inco_vgnca and b.fn_vgnca
			End
	
		Update		@tb_tmpAfiliado
		Set			smns_ctzds_eps_ps	= rtrim(ltrim(b.vlr_cmpo))
		From		#tmpHistoricoBeneficiariosValidador	b	With(NoLock)
		Inner Join	@tb_tmpAfiliado						t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
															And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
															And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
		Where		b.dscrpcn_cmpo			= 'smns_ctzds_antrr_eps'
		And			@fcha_vldccn between b.inco_vgnca and b.fn_vgnca

		IF @@RowCount = 0
			Begin
				select		@fecha_minima = min(b.inco_vgnca)
				From		#tmpHistoricoBeneficiariosValidador	b	With(NoLock)
				Inner Join	@tb_tmpAfiliado						t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																	And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																	And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
				Where		b.dscrpcn_cmpo			= 'smns_ctzds_antrr_eps'
				and			b.inco_vgnca > @fcha_vldccn

				Update		@tb_tmpAfiliado
				Set			smns_ctzds_eps_ps	= rtrim(ltrim(b.vlr_cmpo))
				From		#tmpHistoricoBeneficiariosValidador	b	With(NoLock)
				Inner Join	@tb_tmpAfiliado						t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																	And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																	And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
				Where		b.dscrpcn_cmpo			= 'smns_ctzds_antrr_eps'
				And			@fecha_minima between b.inco_vgnca and b.fn_vgnca
			End
	
		Update		@tb_tmpAfiliado
		Set			cnsctvo_cdgo_rngo_slrl	= rtrim(ltrim(c.vlr_cmpo))
		From		tbHistoricoContratosValidador	c	With(NoLock)
		Inner Join	@tb_tmpAfiliado					t	On	c.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
														And	c.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
		Where		c.dscrpcn_cmpo			= 'cnsctvo_cdgo_rngo_slrl'
		And			@fcha_vldccn between c.inco_vgnca and c.fn_vgnca
	
		Update		@tb_tmpAfiliado
		Set			cnsctvo_cdgo_estdo_drcho	= m.cnsctvo_cdgo_estdo_drcho,
					cnsctvo_cdgo_csa_drcho		= m.cnsctvo_cdgo_csa_drcho,
					dscrpcn_csa_drcho		= isnull(c.dscrpcn_csa_drcho,' ')
		From		@tb_tmpAfiliado				t
		Inner Join	TbMatrizDerechosValidador	m	With(NoLock)	On	m.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																	And	m.nmro_cntrto				= t.nmro_cntrto --COLLATE SQL_Latin1_General_CP1_CI_AS              
																	And	m.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
		Inner Join	tbCausasDerechoValidador	c	With(NoLock)	On	m.cnsctvo_cdgo_estdo_drcho	= c.cnsctvo_cdgo_estdo_drcho
																	And	m.cnsctvo_cdgo_csa_drcho	= c.cnsctvo_cdgo_csa_drcho              
		Where		@fcha_vldccn Between inco_vgnca_estdo_drcho And	fn_vgnca_estdo_drcho
	
		IF @@RowCount = 0
			Begin
				Update		@tb_tmpAfiliado
				Set			cnsctvo_cdgo_estdo_drcho	= m.cnsctvo_cdgo_estdo_drcho,
							cnsctvo_cdgo_csa_drcho		= m.cnsctvo_cdgo_csa_drcho,
							dscrpcn_csa_drcho		= isnull(c.dscrpcn_csa_drcho,' ')
				From		@tb_tmpAfiliado					t
				Inner Join	TbMatrizDerechosValidador_at	m	With(NoLock)	On	m.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																				And	m.nmro_cntrto				= t.nmro_cntrto --COLLATE SQL_Latin1_General_CP1_CI_AS              
																				And	m.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
				Inner Join	tbCausasDerechoValidador		c	With(NoLock)	On	m.cnsctvo_cdgo_estdo_drcho	= c.cnsctvo_cdgo_estdo_drcho
																				And	m.cnsctvo_cdgo_csa_drcho	= c.cnsctvo_cdgo_csa_drcho              
				Where		@fcha_vldccn Between inco_vgnca_estdo_drcho And	fn_vgnca_estdo_drcho
			End
	
		Update		@tb_tmpAfiliado
		Set			prmr_nmbre_ctznte	= b.prmr_aplldo,
					sgndo_nmbre_ctznte	= b.sgndo_aplldo,
					prmr_aplldo_ctznte	= b.prmr_nmbre,
					sgndo_aplldo_ctznte	= b.sgndo_nmbre,
					cnsctvo_tpo_idntfccn_ctznte	= b.cnsctvo_cdgo_tpo_idntfccn,
					nmro_idntfccn_ctznte		= b.nmro_idntfccn -- ,
					--se comenta 
					--    smns_aflcn_eps_ps    =     smns_aflcn,
					--    smns_aflcn_ss_ps    = smns_aflcn_antrr_eps   
		From		@tb_tmpAfiliado				a
		Inner Join	#tmpBeneficiariosValidador	b	With(NoLock)	On	a.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
																	And	a.nmro_cntrto				= b.nmro_cntrto
		Where		b.cnsctvo_bnfcro		= 1
	
		Update		@tb_tmpAfiliado
		Set			cnsctvo_cdgo_pln_pc	= c.cnsctvo_cdgo_pln,
					smns_ctzds_ss_pc	= b.smns_ctzds,
					smns_ctzds_eps_pc	= b.smns_ctzds_antrr_eps,
					--adicion calculo semanas pac
					smns_aflcn_eps_pc    =     b.smns_aflcn,
					smns_aflcn_ss_pc   = b.smns_aflcn_antrr_eps
		From		#tmpContratosValidador					c	With(NoLock)
		Inner Join	#tmpBeneficiariosValidador				b	With(NoLock)	On	b.cnsctvo_cdgo_tpo_cntrto	=	c.cnsctvo_cdgo_tpo_cntrto
																				And	b.nmro_cntrto				=	c.nmro_cntrto
		Inner Join	#tmpVigenciasBeneficiariosValidador		a	With(NoLock)	On	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
																				And	a.nmro_cntrto				=	b.nmro_cntrto
																				And	a.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro
		Inner Join	@tb_tmpAfiliado							t					On	b.nmro_unco_idntfccn_afldo	=	t.nmro_unco_idntfccn_afldo
		Where		c.cnsctvo_cdgo_tpo_cntrto	=  2--t.cnsctvo_cdgo_pln
		And			@fcha_vldccn Between a.inco_vgnca_estdo_bnfcro And a.fn_vgnca_estdo_bnfcro
	
		--Calculamos  la edad y la unidad de la edad
		Update		@tb_tmpAfiliado
		Set 		edd 		= isnull(dbo.fnCalcularTiempo(fcha_ncmnto,@fcha_vldccn,1,2),0),
	 				edd_mss 	= isnull(dbo.fnCalcularTiempo(fcha_ncmnto,@fcha_vldccn,2,2),0),
					edd_ds 		= isnull(dbo.fnCalcularTiempo(fcha_ncmnto,@fcha_vldccn,3,2),0)
	
		Update		@tb_tmpAfiliado
		Set			cnsctvo_cdgo_tpo_undd	= 1
		Where		edd_ds	> 0
	
		Update		@tb_tmpAfiliado
		Set			cnsctvo_cdgo_tpo_undd	= 3
		Where		edd_mss	> 0
	
		Update		@tb_tmpAfiliado
		Set			cnsctvo_cdgo_tpo_undd	= 4
		Where		edd	> 0

		Update		@tb_tmpAfiliado
		Set 		dscrpcn_prntsco = p.dscrpcn_prntsco,
					cdgo_tpo_prntsco= p.cdgo_prntscs
		From		@tb_tmpAfiliado			t
		Inner Join	tbParentescos_vigencias p	With(NoLock)	On	t.cnsctvo_cdgo_prntsco = p.cnsctvo_cdgo_prntscs
		Where		@fcha_vldccn Between p.inco_vgnca And p.fn_vgnca
	
		Update		@tb_tmpAfiliado
		Set 		dscrpcn_tpo_afldo = a.dscrpcn,
					cdgo_tpo_afldo	  = a.cdgo_tpo_afldo 
		From		@tb_tmpAfiliado				t
		Inner Join	tbTiposAfiliado_vigencias	a	With(NoLock)	On	t.cnsctvo_cdgo_tpo_afldo	= a.cnsctvo_cdgo_tpo_afldo
		Where		@fcha_vldccn Between inco_vgnca And fn_vgnca
	
		Update		@tb_tmpAfiliado
		Set 		dscrpcn_rngo_slrl = r.dscrpcn_rngo_slrl,
					cdgo_rngo_slrl	  = r.cdgo_rngo_slrl 
		From		@tb_tmpAfiliado					t
		Inner Join	tbRangosSalariales_vigencias	r	With(NoLock)	On	t.cnsctvo_cdgo_rngo_slrl	= r.cnsctvo_cdgo_rngo_slrl
		Where		@fcha_vldccn Between r.inco_vgnca And r.fn_vgnca
	
		Update		@tb_tmpAfiliado
		Set			dscrpcn_pln_pc = isnull(p.dscrpcn_pln,'') 
		From		@tb_tmpAfiliado		t
		Inner Join	tbPlanes_vigencias	p	With(NoLock)	On	t.cnsctvo_cdgo_pln_pc = p.cnsctvo_cdgo_pln
	
		Update		@tb_tmpAfiliado
		Set			dscrpcn_ips_prmra = i.nmbre_scrsl
		From		@tb_tmpAfiliado				t
		Inner Join	bdAfiliacionValidador.dbo.tbIpsPrimarias_vigencias	i	With(NoLock)	On	t.cdgo_ips_prmra	= i.cdgo_intrno --COLLATE SQL_Latin1_General_CP1_CI_AS
	
		Update		@tb_tmpAfiliado
		Set 		dscrpcn_estdo_drcho			= edv.dscrpcn_estdo_drcho,
					dscrpcn_drcho				= edv.dscrpcn_drcho,
					cnsctvo_cdgo_estdo_drcho	= edv.cnsctvo_cdgo_estdo_drcho,
					cdgo_estdo_drcho			= edv.cdgo_estdo_drcho
		From		tbEstadosDerechoValidador	edv	With(NoLock)
		Inner Join	@tb_tmpAfiliado				a	On	a.cnsctvo_cdgo_estdo_drcho 	= edv.cnsctvo_cdgo_estdo_drcho
	
		Update		@tb_tmpAfiliado
		Set			cdgo_tpo_idntfccn	= i.cdgo_tpo_idntfccn
		From		@tb_tmpAfiliado					t
		Inner Join	tbTiposIdentificacion_vigencias i	With(NoLock)	On	t.cnsctvo_cdgo_tpo_idntfccn	= i.cnsctvo_cdgo_tpo_idntfccn
		Where		@fcha_vldccn Between i.inco_vgnca And i.fn_vgnca
	
		Update		@tb_tmpAfiliado
		Set			cdgo_tpo_idntfccn_ctznte	= i.cdgo_tpo_idntfccn
		From		@tb_tmpAfiliado					t
		Inner Join	tbTiposIdentificacion_vigencias i	With(NoLock)	On	t.cnsctvo_tpo_idntfccn_ctznte	= i.cnsctvo_cdgo_tpo_idntfccn
		Where		@fcha_vldccn Between i.inco_vgnca And i.fn_vgnca
	
		Update		@tb_tmpAfiliado
		Set			cdgo_sxo	= s.cdgo_sxo
		From		@tb_tmpAfiliado		t
		Inner Join	tbSexos_vigencias	s	With(NoLock)	On	t.cnsctvo_cdgo_sxo	= s.cnsctvo_cdgo_sxo
		Where		@fcha_vldccn Between s.inco_vgnca And s.fn_vgnca
	
		Update		@tb_tmpAfiliado
		Set			dscrpcn_pln	= p.dscrpcn_pln
		From		@tb_tmpAfiliado t
		Inner Join	tbPlanes		p	With(NoLock)	On	t.cnsctvo_cdgo_pln	= p.cnsctvo_cdgo_pln
	
		--cnsctvo_cdgo_sde_ips
		Update		@tb_tmpAfiliado
		Set			cnsctvo_cdgo_sde_ips	= d.cnsctvo_cdgo_sde_ips
		From		bdAfiliacionValidador.dbo.tbIpsPrimarias_vigencias	d	With(NoLock)
		Inner Join	@tb_tmpAfiliado										t	On	d.cdgo_intrno	= t.cdgo_ips_prmra
		Where		@fcha_vldccn Between d.inco_vgnca And d.fn_vgnca
	
		--cnsctvo_cdgo_sde_ips para afiliado PAC
		Update		@tb_tmpAfiliado
 		set			cnsctvo_cdgo_sde_ips  = c.cnsctvo_sde_inflnca
		from		@tb_tmpAfiliado				t
		Inner Join	dbo.tbCiudades_Vigencias	c	With(NoLock)	On t.cnsctvo_cdgo_cdd_rsdnca = c.cnsctvo_cdgo_cdd
		Where		t.cnsctvo_cdgo_tpo_cntrto=2  --Solo Para Plan PAC
	
		Update		@tb_tmpAfiliado
		Set			cdgo_afp	= cdgo_entdd
		From		tbEntidades_Vigencias	e	With(NoLock)
		Inner Join	@tb_tmpAfiliado			t	On	t.cnsctvo_cdgo_afp	= e.cnsctvo_cdgo_entdd
		Where		@fcha_vldccn Between e.inco_vgnca And e.fn_vgnca
	
		Update		@tb_tmpAfiliado
		Set			cfcha_ncmnto	= convert(char(10),fcha_ncmnto,111)
	
		Select		@lfFechaReferencia	= fn_vgnca_bnfcro
		From		@tb_tmpAfiliado
		Where		fn_vgnca_bnfcro	< @fcha_vldccn
	End

--*******************************************************************************************************************************
/*
--Se comenta etse bloque para que no consulte formularios y tbeapb
If  @bd = '2' --Formularios
	Begin
		INSERT INTO @tb_tmpAfiliado (
		nmro_idntfccn, 
		prmr_aplldo, 
		sgndo_aplldo, 
		prmr_nmbre, 
		sgndo_nmbre, 
		cnsctvo_cdgo_tpo_idntfccn, 
		nmro_unco_idntfccn_afldo, 
		fcha_ncmnto, 
		cdgo_ips_prmra, 
--		cnsctvo_cdgo_brro, 
		cnsctvo_cdgo_tpo_afldo, 
		nmro_cntrto, 
		cnsctvo_bnfcro, 
		cnsctvo_cdgo_tpo_cntrto, 
		cnsctvo_cdgo_sxo, 
		cnsctvo_cdgo_cdd_rsdnca, 
		smns_ctzds_eps, --ds_ss, 
		smns_aflcn_ss_ps, --ds_sgsss, 
		orgn, 
		cnsctvo_cdgo_rngo_slrl, 
		cnsctvo_cdgo_pln,
		cdgo_eapb,
		inco_vgnca_bnfcro,
		fn_vgnca_bnfcro,
		cnsctvo_cdgo_prntsco) 	

		SELECT a.nmro_idntfccn_bnfcro, -- AS nmro_idntfccn_afldo, 
		a.prmr_aplldo , --AS prmr_aplldo_afldo, 
		a.sgndo_aplldo , --AS sgndo_aplldo_afldo, 
		a.prmr_nmbre , --AS prmr_nmbre_afldo, 
		a.sgndo_nmbre , --AS sgndo_nmbre_afldo, 
		a.cnsctvo_tpo_idntfccn_bnfcro , --AS cnsctvo_cdgo_tpo_idntfccn, 
		0 , --AS nmro_unco_idntfccn_afldo, 
		a.fcha_ncmnto, 
		--'0' , --AS cdgo_intrno,  
		a.cnsctvo_cdgo_ips , --AS cdgo_intrno, Ajuste por Calculo Sede IPS Primaria
--		0 , --AS cnsctvo_cdgo_brro, 
		a.cnsctvo_cdgo_tpo_afldo, 
		'000000000000000' , --AS nmro_cntrto, 
		0 , --as cnsctvo_bnfcro, 
		0 , --AS cnsctvo_cdgo_tpo_cntrto, 
		a.cnsctvo_cdgo_sxo,
		a.cnsctvo_cdgo_cdd_rsdnca, 
		a.smns_ctzds , --AS ds_ss, 
		0  , --AS ds_sgsss, 
		'2', --@cdgo_orgn, --'F' AS orgn, --Formularios
		a.rngo_slrl, --0 , --AS cnsctvo_cdgo_rngo_slrl,			
		a.cnsctvo_cdgo_pln,
		0,
		a.inco_vgnca_bnfcro,
		a.fn_vgnca_bnfcro,
		a.cnsctvo_cdgo_prntsco 
		FROM 	bdAfiliacionValidador.dbo.tbBeneficiariosFormularioValidador a  
		WHERE 	a.cnsctvo_tpo_idntfccn_bnfcro 	= @cnsctvo_cdgo_tpo_idntfccn 
		AND 	a.nmro_idntfccn_bnfcro 		= @nmro_idntfccn
		And	a.cnsctvo_cdgo_pln		= @cnsctvo_cdgo_pln
		And	@fcha_vldccn			>= a.inco_vgnca_bnfcro
		And	@fcha_vldccn			<= a.fcha_hsta
--		And	(@fcha_vldccn Between a.fcha_dsde and a.fcha_hsta)


	End
--*******************************************************************************************************************************
*/
if @Bd = '3' --Otras Eps (Famisanar)
	Begin
		Insert Into @tb_tmpAfiliado
				(	prmr_aplldo, 						sgndo_aplldo, 												prmr_nmbre,
					sgndo_nmbre,						cnsctvo_cdgo_tpo_idntfccn,									nmro_idntfccn,
					fcha_ncmnto, 						cdgo_sxo,													cnsctvo_cdgo_sxo,
					cnsctvo_cdgo_prntsco,				cnsctvo_cdgo_pln,											cnsctvo_cdgo_tpo_afldo,
					cnsctvo_cdgo_rngo_slrl,				inco_vgnca_bnfcro,											fn_vgnca_bnfcro,
					smns_aflcn_eps_ps,					smns_aflcn_ss_ps,											smns_aflcn_eps_pc,
					smns_aflcn_ss_pc,					cnsctvo_cdgo_estdo_drcho,									cdgo_ips_prmra,
					cdgo_eapb,							cnsctvo_cdgo_tpo_cntrto, 									nmro_cntrto,
					orgn,								fcha_dsde,													fcha_hsta,
					tlfno_rsdnca,						drccn_rsdnca
				)
		Select 		a.prmr_aplldo_bnfcro, 				isnull(a.sgndo_aplldo_bnfcro,'') as sgndo_aplldo_bnfcro,	a.prmr_nmbre_bnfcro,
					a.sgndo_nmbre_bnfcro,				a.cnsctvo_cdgo_tpo_idntfccn_bnfcro,							a.nmro_idntfccn_bnfcro,
					a.fcha_ncmnto, 						a.sxo,														a.cnsctvo_cdgo_sxo,
					a.cnsctvo_cdgo_prntscs,				a.cnsctvo_cdgo_pln,											a.cnsctvo_cdgo_tpo_afldo,
					a.cnsctvo_cdgo_rngo_slrl,			convert(char(10),a.inco_vgnca, 111) as inco_vgnca,			convert(char(10),a.fn_vgnca, 111) as fn_vgnca,
					0,									a.smns_ctzds,												0,
					0,									a.estdo as cnsctvo_cdgo_estdo_drcho,						a.ips,
					a.cdgo_eapb,						0,															0,
					'3',								fcha_dsde,													fcha_hsta,
					tlfno,								drccn
		From 		dbo.tbEapb					a	With(NoLock)
		Inner Join	dbo.tbDetalleeapb_Vigencias b	With(NoLock)	On	a.cdgo_eapb	=	b.cdgo_eapb
		Where 		a.nmro_idntfccn_bnfcro 				= @nmro_idntfccn
		And			a.cnsctvo_cdgo_tpo_idntfccn_bnfcro	= @cnsctvo_cdgo_tpo_idntfccn
		And			a.cnsctvo_cdgo_pln					= @cnsctvo_cdgo_pln
		And			(@fcha_vldccn Between Convert(char(10),b.inco_vgnca,111) and Convert(char(10),b.fn_vgnca,111))
		And			b.vsble_vlddr						= 'S'

		If Exists	(	Select 1
						From	@tb_tmpAfiliado
						Where	@fcha_vldccn Between inco_vgnca_bnfcro And fn_vgnca_bnfcro
						And		@Bd	= '2'
					)

			Begin
				Delete	@tb_tmpAfiliado
				Where	inco_vgnca_bnfcro	>	@fcha_vldccn 

				Delete	@tb_tmpAfiliado
				Where	@fcha_vldccn	>	fn_vgnca_bnfcro

			--		Or	orgn	!= '3' --Se comentarea para analisis
				Set @Bd 	= '2'  -- FAMISANAR
			End
	End

-- INICIO NUEVA VALIDACIÓN - 20150507 - SISCGM01 --
if @Bd = '4' --Marca No existe en el Sistema
	Begin
		-- Se busca la maxima vigencia para el estado valido
		Select		@Nui_Afldo					=	b.nmro_unco_idntfccn_afldo,
					@maximafechabeneficiario	=	Max(v.fn_vgnca_estdo_bnfcro)  
		From		#tmpBeneficiariosValidador				b	With(NoLock)
		INNER JOIN	#tmpContratosValidador					c	With(NoLock)	On	b.nmro_cntrto				=	c.nmro_cntrto
																				And	b.cnsctvo_cdgo_tpo_cntrto	=	c.cnsctvo_cdgo_tpo_cntrto
		Inner Join	#tmpVigenciasBeneficiariosValidador		v	With(NoLock)	On	v.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
																				And	v.nmro_cntrto				=	b.nmro_cntrto
																				And	v.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro
		--Where		b.cnsctvo_cdgo_tpo_idntfccn	= @cnsctvo_cdgo_tpo_idntfccn
		--And			b.nmro_idntfccn				= @nmro_idntfccn
		Where		c.cnsctvo_cdgo_pln			= @cnsctvo_cdgo_pln
		Group by	b.nmro_unco_idntfccn_afldo

		If @maximafechabeneficiario is null 
			Begin
				If @hst_nme = @nmbre_srvdr
					Begin
						Select	@Nui_Afldo=nmro_unco_idntfccn_afldo
						From	BDIpsTransaccional.dbo.tbactua	With(NoLock)
						Where	cnsctvo_cdgo_tpo_idntfccn	=	@cnsctvo_cdgo_tpo_idntfccn
						And		nmro_idntfccn				=	@nmro_idntfccn
					End
				Else
					Begin
						print 'entra salud'
						--Select	@Nui_Afldo=nmro_unco_idntfccn_afldo
						--From	bdsisalud.dbo.tbactua	With(NoLock)
						--Where	cnsctvo_cdgo_tpo_idntfccn	=	@cnsctvo_cdgo_tpo_idntfccn
						--And		nmro_idntfccn				=	@nmro_idntfccn
					End

				Set		@maximafechabeneficiario = (	Select		max(v.fn_vgnca_estdo_bnfcro)  
														From		#tmpBeneficiariosValidador				b	With(NoLock)
														INNER JOIN	#tmpContratosValidador					c	With(NoLock)	On	b.nmro_cntrto				=	c.nmro_cntrto
																																And	b.cnsctvo_cdgo_tpo_cntrto	=	c.cnsctvo_cdgo_tpo_cntrto
														Inner Join	#tmpVigenciasBeneficiariosValidador		v	With(NoLock)	On	v.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
																																And	v.nmro_cntrto				=	b.nmro_cntrto
																																And	v.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro
														Where		b.nmro_unco_idntfccn_afldo	=	@Nui_Afldo
														--And			b.nmro_idntfccn				=	@nmro_idntfccn
														--And			b.cnsctvo_cdgo_tpo_idntfccn	=	@cnsctvo_cdgo_tpo_idntfccn
														And			c.cnsctvo_cdgo_pln			=	@cnsctvo_cdgo_pln
													)
				If @maximafechabeneficiario Is Not Null
					Begin
						set @mnsje 	= 'USUARIO RETIRADO'
					End
			End
		Else
			Begin
				set @mnsje 	= 'USUARIO RETIRADO'
			End

	End
-- FIN NUEVA VALIDACIÓN - 20150507 - SISCGM01 --

Update		@tb_tmpAfiliado
Set 		edd 		= isnull(dbo.fnCalcularTiempo(fcha_ncmnto,@fcha_vldccn,1,2),0),
 			edd_mss 	= isnull(dbo.fnCalcularTiempo(fcha_ncmnto,@fcha_vldccn,2,2),0),
			edd_ds 		= isnull(dbo.fnCalcularTiempo(fcha_ncmnto,@fcha_vldccn,3,2),0)

Update		@tb_tmpAfiliado
Set			cnsctvo_cdgo_tpo_undd	= 1
Where		edd_ds	> 0

Update		@tb_tmpAfiliado
Set			cnsctvo_cdgo_tpo_undd	= 3
Where		edd_mss	> 0

Update		@tb_tmpAfiliado
Set			cnsctvo_cdgo_tpo_undd	= 4
Where		edd	> 0

Update		@tb_tmpAfiliado
Set 		dscrpcn_prntsco = p.dscrpcn_prntsco,
			cdgo_tpo_prntsco= p.cdgo_prntscs
From		@tb_tmpAfiliado				t
Inner Join	dbo.tbParentescos_vigencias p	With(NoLock)	On	t.cnsctvo_cdgo_prntsco = p.cnsctvo_cdgo_prntscs
Where		@fcha_vldccn Between p.inco_vgnca And p.fn_vgnca

Update		@tb_tmpAfiliado
Set 		dscrpcn_tpo_afldo = a.dscrpcn,
			cdgo_tpo_afldo	  = a.cdgo_tpo_afldo 
From		@tb_tmpAfiliado					t
Inner Join	dbo.tbTiposAfiliado_vigencias	a	With(NoLock)	On	t.cnsctvo_cdgo_tpo_afldo	= a.cnsctvo_cdgo_tpo_afldo
Where		@fcha_vldccn Between a.inco_vgnca And a.fn_vgnca

Update		@tb_tmpAfiliado
Set			cnsctvo_cdgo_rngo_slrl	= 4
Where		cnsctvo_cdgo_rngo_slrl	= 0
And			cnsctvo_cdgo_tpo_cntrto	!= 1

Update		@tb_tmpAfiliado
Set 		dscrpcn_rngo_slrl = r.dscrpcn_rngo_slrl,
			cdgo_rngo_slrl	  = r.cdgo_rngo_slrl 
From		@tb_tmpAfiliado						t
Inner Join	dbo.tbRangosSalariales_vigencias	r	With(NoLock)	On	t.cnsctvo_cdgo_rngo_slrl	= r.cnsctvo_cdgo_rngo_slrl
Where		@fcha_vldccn Between r.inco_vgnca And r.fn_vgnca

Update		@tb_tmpAfiliado
Set			dscrpcn_pln_pc = isnull(p.dscrpcn_pln,'') 
From		@tb_tmpAfiliado			t
Inner Join	dbo.tbPlanes_vigencias	p	With(NoLock)	On	t.cnsctvo_cdgo_pln_pc = p.cnsctvo_cdgo_pln

Update		@tb_tmpAfiliado
Set			dscrpcn_ips_prmra = i.nmbre_scrsl
From		@tb_tmpAfiliado					t
Inner Join	bdAfiliacionValidador.dbo.tbIpsPrimarias_vigencias	i	With(NoLock)	On	t.cdgo_ips_prmra	= i.cdgo_intrno --COLLATE SQL_Latin1_General_CP1_CI_AS

Update		@tb_tmpAfiliado
Set 		dscrpcn_estdo_drcho			= edv.dscrpcn_estdo_drcho,
			dscrpcn_drcho				= edv.dscrpcn_drcho,
			cnsctvo_cdgo_estdo_drcho	= edv.cnsctvo_cdgo_estdo_drcho,
			drcho 						= edv.drcho,
			cdgo_estdo_drcho			= edv.cdgo_estdo_drcho
From		dbo.tbEstadosDerechoValidador	edv	With(NoLock)
Inner Join	@tb_tmpAfiliado					a	On	a.cnsctvo_cdgo_estdo_drcho 	= edv.cnsctvo_cdgo_estdo_drcho

Update		@tb_tmpAfiliado
Set			cdgo_tpo_idntfccn	= i.cdgo_tpo_idntfccn
From		@tb_tmpAfiliado						t
Inner Join	dbo.tbTiposIdentificacion_vigencias i	With(NoLock)	On	t.cnsctvo_cdgo_tpo_idntfccn	= i.cnsctvo_cdgo_tpo_idntfccn
Where		@fcha_vldccn Between i.inco_vgnca And i.fn_vgnca

Update		@tb_tmpAfiliado
Set			cdgo_tpo_idntfccn_ctznte	= i.cdgo_tpo_idntfccn
From		@tb_tmpAfiliado						t
Inner Join	dbo.tbTiposIdentificacion_vigencias i	With(NoLock)	On	t.cnsctvo_tpo_idntfccn_ctznte	= i.cnsctvo_cdgo_tpo_idntfccn
Where		@fcha_vldccn Between i.inco_vgnca And i.fn_vgnca

Update		@tb_tmpAfiliado
Set			cdgo_sxo	= s.cdgo_sxo
From		@tb_tmpAfiliado			t
Inner Join	dbo.tbSexos_vigencias	s	With(NoLock)	On	t.cnsctvo_cdgo_sxo	= s.cnsctvo_cdgo_sxo
Where		@fcha_vldccn Between s.inco_vgnca And s.fn_vgnca

Update		@tb_tmpAfiliado
Set			dscrpcn_pln	= p.dscrpcn_pln
From		@tb_tmpAfiliado t
Inner Join	dbo.tbPlanes	p	With(NoLock)	On	t.cnsctvo_cdgo_pln	= p.cnsctvo_cdgo_pln

--cnsctvo_cdgo_sde_ips
Update		@tb_tmpAfiliado
Set			cnsctvo_cdgo_sde_ips	= d.cnsctvo_cdgo_sde_ips
From		bdAfiliacionValidador.dbo.tbIpsPrimarias_vigencias	d	With(NoLock)
Inner Join	@tb_tmpAfiliado					t	On	d.cdgo_intrno	= t.cdgo_ips_prmra
Where		@fcha_vldccn Between d.inco_vgnca And d.fn_vgnca

--cnsctvo_cdgo_sde_ips para afiliado PAC
Update		@tb_tmpAfiliado
set			cnsctvo_cdgo_sde_ips  = c.cnsctvo_sde_inflnca
from		@tb_tmpAfiliado				t
Inner Join	dbo.tbCiudades_Vigencias	c	With(NoLock)	On	t.cnsctvo_cdgo_cdd_rsdnca = c.cnsctvo_cdgo_cdd
Where		t.cnsctvo_cdgo_tpo_cntrto=2  --Solo Para Plan PAC

Update		@tb_tmpAfiliado
Set			flg_enble_nmro_vldcn	= 'S'
Where		cnsctvo_cdgo_estdo_drcho	 = 8 --In (8) Suspendido
Or			cnsctvo_cdgo_estdo_drcho	 = 7 --Retirado

--adicion calculo tipo validacion (2010/11/16)
Update		@tb_tmpAfiliado
Set			cnsctvo_tpo_vldcn_actva	= 2
Where		orgn					= '2'	--Formularios

Update		@tb_tmpAfiliado
Set			cnsctvo_tpo_vldcn_actva		=	2
Where		orgn						=	'1'	--Contratos
And			cnsctvo_cdgo_estdo_drcho	in (6,7,8)	-- 6 EN PROCESO 7 Retirado, 8 suspendido

Update		@tb_tmpAfiliado
Set			cnsctvo_tpo_vldcn_actva		= 1
Where		orgn						= '1'	--Contratos
And			cnsctvo_cdgo_estdo_drcho	not in (6,7,8)	-- 6 EN PROCESO 7 Retirado, 8 suspendido

Update		@tb_tmpAfiliado
Set			cnsctvo_tpo_vldcn_actva	= 1
Where		orgn					= '3'	--Famisanar

Update		@tb_tmpAfiliado
Set			dscrpcn_cdd_rsdnca	= c.dscrpcn_cdd,
			cdgo_cdd		= c.cdgo_cdd
From		dbo.tbCiudades	c	With(NoLock)
Inner Join	@tb_tmpAfiliado t	On	c.cnsctvo_cdgo_cdd	= t.cnsctvo_cdgo_cdd_rsdnca

Update		@tb_tmpAfiliado
Set			cdgo_afp	= cdgo_entdd
From		dbo.tbEntidades_Vigencias	e	With(NoLock)
Inner Join	@tb_tmpAfiliado				t	On	t.cnsctvo_cdgo_afp	= e.cnsctvo_cdgo_entdd
Where		@fcha_vldccn Between e.inco_vgnca And e.fn_vgnca

Update		@tb_tmpAfiliado
Set			cfcha_ncmnto	= convert(char(10),fcha_ncmnto,111)

-- se comenta el bloque adicionado por Angela
--Se realiza el calculo para semanas de afiliacion
--pos
Update		@tb_tmpAfiliado
Set			--afiliacion
			smns_aflcn_eps_ps  		= b.smns_aflcn,
			smns_aflcn_ss_ps  		= b.smns_aflcn_antrr_eps,
			--cotizacion
			smns_ctzds_eps			= b.smns_ctzds,
			smns_ctzds_ss_ps		= b.smns_ctzds,
			smns_ctzds_eps_ps		= b.smns_ctzds_antrr_eps	
From		@tb_tmpAfiliado							t
Inner Join 	#tmpBeneficiariosValidador				b	With(NoLock)	On	b.nmro_unco_idntfccn_afldo	=	t.nmro_unco_idntfccn_afldo
																		And b.cnsctvo_bnfcro			=	t.cnsctvo_bnfcro
																		And b.cnsctvo_cdgo_tpo_cntrto	=	t.cnsctvo_cdgo_tpo_cntrto
																		And b.nmro_cntrto				=	t.nmro_cntrto
Inner Join	#tmpVigenciasBeneficiariosValidador		c	With(NoLock)	On	c.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
																		And	c.nmro_cntrto				=	b.nmro_cntrto
																		And	c.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro
Where		t.cnsctvo_cdgo_tpo_cntrto	= 1
And			@lfFechaReferencia Between c.inco_vgnca_estdo_bnfcro And c.fn_vgnca_estdo_bnfcro

--pac
Update		@tb_tmpAfiliado
Set			--afiliacion
			smns_aflcn_ss_pc  		= b.smns_aflcn_antrr_eps,
			smns_aflcn_eps_pc  		= b.smns_aflcn
			--cotizacion
			--smns_ctzds_ss_pc		= b.smns_ctzds,
			--smns_ctzds_eps_pc		= b.smns_ctzds_antrr_eps	
From		@tb_tmpAfiliado							t
Inner Join 	#tmpBeneficiariosValidador				b	With(NoLock)	On	b.nmro_unco_idntfccn_afldo	=	t.nmro_unco_idntfccn_afldo
																		And b.cnsctvo_bnfcro			=	t.cnsctvo_bnfcro
																		And b.cnsctvo_cdgo_tpo_cntrto	=	t.cnsctvo_cdgo_tpo_cntrto
																		And b.nmro_cntrto				=	t.nmro_cntrto
Inner Join	#tmpVigenciasBeneficiariosValidador		c	With(NoLock)	On	c.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
																		And	c.nmro_cntrto				=	b.nmro_cntrto
																		And	c.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro
Where		t.cnsctvo_cdgo_tpo_cntrto	= 2
And			@lfFechaReferencia Between c.inco_vgnca_estdo_bnfcro And c.fn_vgnca_estdo_bnfcro

/*********** Agregado por Angela Sandoval el 2010-11-20 debido a que no calculaba estos datos anteriores **********/

/*******************************************************************************
***	Se actualizan los datos restantes
*******************************************************************************/
Declare	@tiempoAfiliacion Table
		(	smns_ctzds	int,
			smns_aflcn	int,
			smns_ctzds_antrr_eps	int,
			smns_aflcn_antrr_eps	int,
			cnsctvo_cdgo_tpo_cntrto	int,
			nmro_cntrto		varchar(15),
			inco_vgnca_bnfcro	datetime,
			fn_vgnca_bnfcro		datetime
		)

Insert into @tiempoAfiliacion
		(	smns_ctzds,						smns_aflcn,						smns_ctzds_antrr_eps,					smns_aflcn_antrr_eps,
			cnsctvo_cdgo_tpo_cntrto,		nmro_cntrto,					inco_vgnca_bnfcro,						fn_vgnca_bnfcro
		)
Select		b.smns_ctzds,					b.smns_aflcn,					b.smns_ctzds_antrr_eps,					smns_aflcn_antrr_eps,
			b.cnsctvo_cdgo_tpo_cntrto,		b.nmro_cntrto,					a.inco_vgnca_estdo_bnfcro,				a.fn_vgnca_estdo_bnfcro
From		@tb_tmpAfiliado							t
Inner Join	#tmpBeneficiariosValidador				b	With(NoLock)	On	b.nmro_unco_idntfccn_afldo	=	t.nmro_unco_idntfccn_afldo
Inner Join	#tmpVigenciasBeneficiariosValidador		a	With(NoLock)	On	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
																		And	a.nmro_cntrto				=	b.nmro_cntrto
																		And a.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro
Where		@lfFechaReferencia Between a.inco_vgnca_estdo_bnfcro and a.fn_vgnca_estdo_bnfcro

If Exists	(	Select	1
				FRom	@tiempoAfiliacion
				Where	cnsctvo_cdgo_tpo_cntrto	= 1
				And		@fcha_vldccn Between inco_vgnca_bnfcro And fn_vgnca_bnfcro
			)
	Begin
		Update	@tb_tmpAfiliado
		Set		smns_ctzds_ss_ps		= b.smns_ctzds,
				smns_ctzds_eps_ps		= b.smns_ctzds_antrr_eps,
				smns_aflcn_eps_ps  		= b.smns_aflcn,
				smns_aflcn_ss_ps  		= b.smns_aflcn_antrr_eps,
				smns_ctzds_eps			= b.smns_ctzds
		From	@tb_tmpAfiliado		t,
				@tiempoAfiliacion	b
		Where	b.cnsctvo_cdgo_tpo_cntrto	= 1
		And		@fcha_vldccn Between b.inco_vgnca_bnfcro And b.fn_vgnca_bnfcro
	End
Else
	Begin
		Update	@tb_tmpAfiliado
		Set		smns_ctzds_ss_ps		= b.smns_ctzds,
				smns_ctzds_eps_ps		= b.smns_ctzds_antrr_eps,
				smns_aflcn_eps_ps  		= b.smns_aflcn,
				smns_aflcn_ss_ps  		= b.smns_aflcn_antrr_eps,
				smns_ctzds_eps			= b.smns_ctzds
		From	@tb_tmpAfiliado		t,
				@tiempoAfiliacion	b
		Where	b.cnsctvo_cdgo_tpo_cntrto	= 1
		And		t.fn_vgnca_bnfcro Between b.inco_vgnca_bnfcro And b.fn_vgnca_bnfcro
		
		If @@ROWCOUNT = 0
			Begin
				Update	@tb_tmpAfiliado
				Set		smns_ctzds_ss_ps		= b.smns_ctzds,
						smns_ctzds_eps_ps		= b.smns_ctzds_antrr_eps,
						smns_aflcn_eps_ps  		= b.smns_aflcn,
						smns_aflcn_ss_ps  		= b.smns_aflcn_antrr_eps,
						smns_ctzds_eps			= b.smns_ctzds
				From	@tb_tmpAfiliado		t,
						@tiempoAfiliacion	b,
						(	Select	Max(fn_vgnca_bnfcro) as fn_vgnca_bnfcro
							From	@tiempoAfiliacion
							Where	cnsctvo_cdgo_tpo_cntrto	= 1
						) as				g
				Where	b.cnsctvo_cdgo_tpo_cntrto	= 1
				And		b.fn_vgnca_bnfcro			= g.fn_vgnca_bnfcro
			End
	End

If Exists	(	Select	1
				FRom	@tiempoAfiliacion
				Where	cnsctvo_cdgo_tpo_cntrto	= 2
				And		@fcha_vldccn Between inco_vgnca_bnfcro And fn_vgnca_bnfcro
			)
	Begin
		Update		@tb_tmpAfiliado
		Set			cnsctvo_cdgo_pln_pc	= c.cnsctvo_cdgo_pln,
					smns_ctzds_ss_pc	= b.smns_ctzds,
					smns_ctzds_eps_pc	= b.smns_ctzds_antrr_eps,
					smns_aflcn_ss_pc	= b.smns_aflcn_antrr_eps,
					smns_aflcn_eps_pc	= b.smns_aflcn
		From		@tb_tmpAfiliado				t,
					@tiempoAfiliacion			b
		Inner Join	#tmpContratosValidador		c	With(NoLock)	On	b.cnsctvo_cdgo_tpo_cntrto	= c.cnsctvo_cdgo_tpo_cntrto
																	And	b.nmro_cntrto				= c.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
		Where		c.cnsctvo_cdgo_tpo_cntrto	= 2
		And			@lfFechaReferencia Between b.inco_vgnca_bnfcro And b.fn_vgnca_bnfcro
	End
Else
	Begin
		Update		@tb_tmpAfiliado
		Set			cnsctvo_cdgo_pln_pc	= c.cnsctvo_cdgo_pln,
					smns_ctzds_ss_pc	= b.smns_ctzds,
					smns_ctzds_eps_pc	= b.smns_ctzds_antrr_eps,
					smns_aflcn_ss_pc	= b.smns_aflcn_antrr_eps,
					smns_aflcn_eps_pc	= b.smns_aflcn
		From		@tb_tmpAfiliado				t,
					@tiempoAfiliacion			b
		Inner Join	#tmpContratosValidador		c	With(NoLock)	On	b.cnsctvo_cdgo_tpo_cntrto	= c.cnsctvo_cdgo_tpo_cntrto
																	And	b.nmro_cntrto				= c.nmro_cntrto
		Where		c.cnsctvo_cdgo_tpo_cntrto	= 2
		And			t.fn_vgnca_bnfcro Between b.inco_vgnca_bnfcro And b.fn_vgnca_bnfcro

		If @@ROWCOUNT = 0
			Begin
				Update		@tb_tmpAfiliado
				Set			cnsctvo_cdgo_pln_pc	= c.cnsctvo_cdgo_pln,
							smns_ctzds_ss_pc	= b.smns_ctzds,
							smns_ctzds_eps_pc	= b.smns_ctzds_antrr_eps,
							smns_aflcn_ss_pc	= b.smns_aflcn_antrr_eps,
							smns_aflcn_eps_pc	= b.smns_aflcn
				From		@tb_tmpAfiliado				t,
							@tiempoAfiliacion			b
				Inner Join	#tmpContratosValidador		c	With(NoLock)	On	b.cnsctvo_cdgo_tpo_cntrto	= c.cnsctvo_cdgo_tpo_cntrto
																			And	b.nmro_cntrto				= c.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS,
				(	Select	Max(fn_vgnca_bnfcro) as fn_vgnca_bnfcro
					From	@tiempoAfiliacion
					Where	cnsctvo_cdgo_tpo_cntrto	= 1
				)									as  g
				Where	c.cnsctvo_cdgo_tpo_cntrto	= 2
				And		b.fn_vgnca_bnfcro			= g.fn_vgnca_bnfcro
			End
	End
/************************* Fin de lo Agregado por Angela Sandoval  ******************/
Select		prmr_aplldo,								sgndo_aplldo,										prmr_nmbre,
			sgndo_nmbre,								cnsctvo_cdgo_tpo_idntfccn,							nmro_idntfccn,
			fcha_ncmnto,								cnsctvo_cdgo_sxo,									cdgo_sxo,
			edd,										edd_mss,											edd_ds,
			cnsctvo_cdgo_tpo_undd,						orgn,												cnsctvo_cdgo_tpo_cntrto,
			nmro_cntrto,								cnsctvo_cdgo_pln,									nmro_unco_idntfccn_afldo,
			inco_vgnca_bnfcro,							fn_vgnca_bnfcro,									cnsctvo_cdgo_prntsco,
			dscrpcn_prntsco,							cnsctvo_cdgo_tpo_afldo,								dscrpcn_tpo_afldo,
			cnsctvo_cdgo_rngo_slrl,						dscrpcn_rngo_slrl,									cnsctvo_cdgo_pln_pc,
			dscrpcn_pln_pc,								smns_ctzds_ss_ps,									smns_ctzds_eps_ps,
			smns_ctzds_ss_pc,							smns_ctzds_eps_pc,									cdgo_ips_prmra,
			dscrpcn_ips_prmra,							cnsctvo_bnfcro,										cdgo_eapb,
			nmro_unco_idntfccn_ctznte,					cnsctvo_cdgo_tpo_cntrto_psc,						nmro_cntrto_psc,
			ds_ctzds,									cnsctvo_cdgo_sde_ips,								dscrpcn_tpo_cntrto,
			cnsctvo_cdgo_csa_drcho,						cnsctvo_cdgo_estdo_drcho,							dscrpcn_estdo_drcho,
			dscrpcn_csa_drcho,							dscrpcn_drcho,										dscrpcn_pln,
			dscrpcn_tpo_ctznte,							prmr_nmbre_ctznte,									sgndo_nmbre_ctznte,
			prmr_aplldo_ctznte,							sgndo_aplldo_ctznte,								drccn_rsdnca,
			tlfno_rsdnca,								cnsctvo_cdgo_cdd_rsdnca,							dscrpcn_cdd_rsdnca,
			cnsctvo_cdgo_estdo_cvl,						dscrpcn_estdo_cvl,									cnsctvo_cdgo_tpo_frmlro,
			nmro_frmlro,								cdgo_tpo_idntfccn,									cnsctvo_cdgo_afp,
			fcha_dsde,									fcha_hsta,											flg_enble_nmro_vldcn,
			drcho,										cdgo_afp,											cnsctvo_tpo_vldcn_actva,
			cfcha_ncmnto,								smns_aflcn_ss_ps,									smns_aflcn_eps_ps,
			smns_aflcn_ss_pc,							smns_aflcn_eps_pc,									smns_ctzds_eps,
			cdgo_tpo_prntsco,							cdgo_cdd, 											cdgo_rngo_slrl,
			cdgo_tpo_afldo, 							cdgo_tpo_idntfccn_ctznte,							nmro_idntfccn_ctznte,
			cnsctvo_tpo_idntfccn_ctznte,				@lfFechaReferencia	as fcha_rfrnca,					@fcha_mxma_rprte as fcha_mxma_rprte,			
			cnsctvo_dcmnto_gnrdo,						nmro_dcmnto,										cdgo_estdo_drcho,									
			eml --adicion de campo 2009/12/11 sisatv01
From		@tb_tmpAfiliado

Drop Table	#tmpBeneficiariosValidador
Drop Table	#tmpVigenciasBeneficiariosValidador
Drop Table	#tmpContratosValidador
Drop Table	#tmpHistoricoBeneficiariosValidador

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_Historico] TO [340010 Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_Historico] TO [cna_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_Historico] TO [vafss_role]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_Historico] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_Historico] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_Historico] TO [outbts01]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_Historico] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_Historico] TO [portal_rol]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_Historico] TO [proceso3047_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_Historico] TO [at3047_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_Historico] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_Historico] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_Historico] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_Historico] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_Historico] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_Historico] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_Historico] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_Historico] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_Historico] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_Historico] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_Historico] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_Historico] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_Historico] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_Historico] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_Historico] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_Historico] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_Historico] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

