CREATE	PROCEDURE [dbo].[spPmBuscaPersonasxNombre]
@prmr_nmbre			udtNombre,
@sgndo_nmbre		udtNombre,
@prmr_aplldo		udtApellido,
@sgndo_aplldo		udtApellido,
@cnsctvo_cdgo_pln	udtConsecutivo	= NULL,
@cnsctvo_mdlo		udtConsecutivo = null

AS
Set NoCount On

--declare		@prmr_nmbre		udtNombre,
--			@sgndo_nmbre	udtNombre,
--			@prmr_aplldo	udtApellido,
--			@sgndo_aplldo	udtApellido,
--			@cnsctvo_cdgo_pln	int,
--			@cnsctvo_mdlo		int
--			--@opcn				Int

--set			@prmr_nmbre = 'LUCERO'
--set			@sgndo_nmbre = ''
--set			@prmr_aplldo = 'ESCOBAR'
--set			@sgndo_aplldo = 'GUARIN'
--set			@cnsctvo_mdlo	=	1
--set			@cnsctvo_cdgo_pln	=	NULL


Begin
	create table #tmpDatosEntrada
			(
				prmr_nmbre					varchar(20),
				sgndo_nmbre					varchar(20),
				prmr_aplldo					varchar(50),
				sgndo_aplldo				varchar(50)
			)

	create table #borrar
			(	cnsctvo_cdgo_pln			udtConsecutivo,
				nmro_unco_idntfccn_bnfcro	int,
				fn_vgnca_bnfcro				datetime
			)

	Declare		@fcha_vldcn								datetime,
				@fcha_rfrnca							datetime,
				@lnConsecutivoCodigoTipoIdentificacion	udtConsecutivo,
				@lnNumeroIdentificacion					udtNumeroIdentificacion,
				@opcn									Int

	Set			@fcha_vldcn			= getdate()
	Set			@cnsctvo_cdgo_pln	= isnull(@cnsctvo_cdgo_pln,0)
	
	If @sgndo_nmbre = ''
		Set	@sgndo_nmbre = NULL

	If @sgndo_aplldo = ''
		Set	@sgndo_aplldo = NULL

	If @prmr_nmbre Is Not Null And @sgndo_nmbre Is Not Null And @prmr_aplldo Is Not Null And @sgndo_aplldo Is Not Null
		Begin
			Set		@opcn = 1
			Insert Into	#tmpDatosEntrada	(	prmr_nmbre, sgndo_nmbre, prmr_aplldo, sgndo_aplldo)
			Values							(	Ltrim(Rtrim(@prmr_nmbre)),LTrim(Rtrim(@sgndo_nmbre)),LTrim(Rtrim(@prmr_aplldo)),Ltrim(Rtrim(@sgndo_aplldo)))
		End

	If @prmr_nmbre Is Not Null And @sgndo_nmbre Is Not Null And @prmr_aplldo Is Not Null And @sgndo_aplldo Is Null
		Begin
			Set		@opcn = 2
			Insert Into	#tmpDatosEntrada	(	prmr_nmbre, sgndo_nmbre, prmr_aplldo)
			Values							(	Ltrim(Rtrim(@prmr_nmbre)),LTrim(Rtrim(@sgndo_nmbre)),LTrim(Rtrim(@prmr_aplldo)))
		End

	If @prmr_nmbre Is Not Null And @sgndo_nmbre Is Not Null And @prmr_aplldo Is Null And @sgndo_aplldo Is Null
		Begin
			Set		@opcn = 3
			Insert Into	#tmpDatosEntrada	(	prmr_nmbre, sgndo_nmbre)
			Values							(	Ltrim(Rtrim(@prmr_nmbre)),LTrim(Rtrim(@sgndo_nmbre)))
		End

	If @prmr_nmbre Is Not Null And @sgndo_nmbre Is Null And @prmr_aplldo Is Null And @sgndo_aplldo Is Null
		Begin
			Set		@opcn = 4
			Insert Into	#tmpDatosEntrada	(	prmr_nmbre)
			Values				(	Ltrim(Rtrim(@prmr_nmbre)))
		End

	If @prmr_nmbre Is Null And @sgndo_nmbre Is Not Null And @prmr_aplldo Is Not Null And @sgndo_aplldo Is Not Null
		Begin
			Set		@opcn = 5
			Insert Into	#tmpDatosEntrada	(	sgndo_nmbre, prmr_aplldo, sgndo_aplldo)
			Values				(	Ltrim(Rtrim(@sgndo_nmbre)),LTrim(Rtrim(@prmr_aplldo)),LTrim(Rtrim(@sgndo_aplldo)))
		End

	If @prmr_nmbre Is Null And @sgndo_nmbre Is Not Null And @prmr_aplldo Is Null And @sgndo_aplldo Is Not Null
		Begin
			Set		@opcn = 6
			Insert Into	#tmpDatosEntrada	(	sgndo_nmbre, sgndo_aplldo)
			Values				(	Ltrim(Rtrim(@sgndo_nmbre)),LTrim(Rtrim(@sgndo_aplldo)))
		End

	If @prmr_nmbre Is Null And @sgndo_nmbre Is Not Null And @prmr_aplldo Is Null And @sgndo_aplldo Is Null
		Begin
			Set		@opcn = 7
			Insert Into	#tmpDatosEntrada	(	sgndo_nmbre)
			Values				(	Ltrim(Rtrim(@sgndo_nmbre)))
		End

	If @prmr_nmbre Is Null And @sgndo_nmbre Is Null And @prmr_aplldo Is Not Null And @sgndo_aplldo Is Not Null
		Begin
			Set		@opcn = 8
			Insert Into	#tmpDatosEntrada	(	prmr_aplldo, sgndo_aplldo)
			Values				(	Ltrim(Rtrim(@prmr_aplldo)),LTrim(Rtrim(@sgndo_aplldo)))
		End

	If @prmr_nmbre Is Null And @sgndo_nmbre Is Null And @prmr_aplldo Is Not Null And @sgndo_aplldo Is Null
		Begin
			Set		@opcn = 9
			Insert Into	#tmpDatosEntrada	(	prmr_aplldo)
			Values				(	Ltrim(Rtrim(@prmr_aplldo)))
		End

	If @prmr_nmbre Is Null And @sgndo_nmbre Is Null And @prmr_aplldo Is Null And @sgndo_aplldo Is Not Null
		Begin
			Set		@opcn = 10
			Insert Into	#tmpDatosEntrada	(	sgndo_aplldo)
			Values				(	Ltrim(Rtrim(@sgndo_aplldo)))
		End

	If @prmr_nmbre Is Not Null And @sgndo_nmbre Is Null And @prmr_aplldo Is Not Null And @sgndo_aplldo Is Null
		Begin
			Set		@opcn = 11
			Insert Into	#tmpDatosEntrada	(	prmr_nmbre, prmr_aplldo)
			Values				(	Ltrim(Rtrim(@prmr_nmbre)),LTrim(Rtrim(@prmr_aplldo)))
		End

	If @prmr_nmbre Is Not Null And @sgndo_nmbre Is Null And @prmr_aplldo Is Not Null And @sgndo_aplldo Is Not Null
		Begin
			Set		@opcn = 12
			Insert Into	#tmpDatosEntrada	(	prmr_nmbre, prmr_aplldo, sgndo_aplldo)
			Values				(	Ltrim(Rtrim(@prmr_nmbre)),LTrim(Rtrim(@prmr_aplldo)),LTrim(Rtrim(@sgndo_aplldo)))
		End

	if @prmr_aplldo IS Null And @sgndo_aplldo Is Null And @prmr_nmbre Is Null And @sgndo_nmbre Is Null
		Begin
			Return
		End


		PRINT @opcn

	if isnull(@cnsctvo_mdlo,22) != 22
		begin
			--print	'entra modulo'
			Declare @tmpGrupoFamiliar Table
				(	dscrpcn_pln					varchar(150),
					Orgn						varchar(15),
					cdgo_tpo_idntfccn			varchar(3),
					nmro_idntfccn				varchar(20),
					Nmbre_Afldo					varchar(150),
					dscrpcn_prntsco				varchar(150),
					nmro_cntrto					char(15),
					inco_vgnca_bnfcro			datetime,
					fn_vgnca_bnfcro				datetime,
					estdo						varchar(8),
					cnsctvo_cdgo_pln			int,
					nmro_unco_idntfccn_bnfcro	int,
					cnsctvo_cdgo_tpo_idntfccn	int,
					cnsctvo_cdgo_prntsco		int,
					cnsctvo_cdgo_tpo_afldo		int,
					tpo_afldo					varchar(20),
					Bd							Char(1),
					fcha_ncmnto					datetime,
					prmr_nmbre					varchar(20),
					sgndo_nmbre					varchar(20),
					prmr_aplldo					varchar(50),
					sgndo_aplldo				varchar(50)
				)

			if @cnsctvo_cdgo_pln != 0
				Begin
					--print	'entra plan'
					If @opcn = 1
						Begin
							--print 'entro 1'
							Insert Into @tmpGrupoFamiliar
									(	Orgn,						Bd,								cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,
										nmro_cntrto,				inco_vgnca_bnfcro,				fn_vgnca_bnfcro,				fcha_ncmnto,
										estdo,
										cnsctvo_cdgo_pln,			cnsctvo_cdgo_prntsco,			cnsctvo_cdgo_tpo_afldo,			nmro_unco_idntfccn_bnfcro,
										prmr_nmbre,					sgndo_nmbre,					prmr_aplldo,					sgndo_aplldo
								)
							Select		'CONTRATOS',				1,								b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,
										b.nmro_cntrto,				b.inco_vgnca_bnfcro,			b.fn_vgnca_bnfcro,				b.fcha_ncmnto,
										CASE	WHEN b.fn_vgnca_bnfcro < @fcha_vldcn THEN 'INACTIVO'
												WHEN b.inco_vgnca_bnfcro > @fcha_vldcn THEN 'INACTIVO'
												ELSE	'AFILIADO'
										END,
										c.cnsctvo_cdgo_pln,			b.cnsctvo_cdgo_prntsco,			b.cnsctvo_cdgo_tpo_afldo,		b.nmro_unco_idntfccn_afldo,
										ltrim(rtrim(b.prmr_nmbre)),	ltrim(rtrim(b.sgndo_nmbre)),	ltrim(rtrim(b.prmr_aplldo)),	ltrim(rtrim(b.sgndo_aplldo))
							From		bdAfiliacionValidador.dbo.tbBeneficiariosValidador	b	With(NoLock)
							inner join	bdAfiliacionValidador.dbo.tbContratosValidador		c	With(NoLock)	on	c.nmro_cntrto				= b.nmro_cntrto
																												And	c.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
							Inner Join	#tmpDatosEntrada									d	With(NoLock)	On	d.prmr_aplldo				= b.prmr_aplldo
																												And	d.sgndo_aplldo				= b.sgndo_aplldo
																												And	d.prmr_nmbre				= b.prmr_nmbre 
																												And	d.sgndo_nmbre				= b.sgndo_nmbre
							Where		 c.cnsctvo_cdgo_pln = @cnsctvo_cdgo_pln
						End

					If @opcn = 2
						begin
							--print 'entro 2'
							Insert Into @tmpGrupoFamiliar
									(	Orgn,						Bd,								cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,
										nmro_cntrto,				inco_vgnca_bnfcro,				fn_vgnca_bnfcro,				fcha_ncmnto,
										estdo,
										cnsctvo_cdgo_pln,			cnsctvo_cdgo_prntsco,			cnsctvo_cdgo_tpo_afldo,			nmro_unco_idntfccn_bnfcro,
										prmr_nmbre,					sgndo_nmbre,					prmr_aplldo,					sgndo_aplldo
								)
							Select		'CONTRATOS',				1,								b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,
										b.nmro_cntrto,				b.inco_vgnca_bnfcro,			b.fn_vgnca_bnfcro,				b.fcha_ncmnto,
										CASE	WHEN b.fn_vgnca_bnfcro < @fcha_vldcn THEN 'INACTIVO'
												WHEN b.inco_vgnca_bnfcro > @fcha_vldcn THEN 'INACTIVO'
												ELSE	'AFILIADO'
										END,
										c.cnsctvo_cdgo_pln,			b.cnsctvo_cdgo_prntsco,			b.cnsctvo_cdgo_tpo_afldo,		b.nmro_unco_idntfccn_afldo,
										ltrim(rtrim(b.prmr_nmbre)),	ltrim(rtrim(b.sgndo_nmbre)),	ltrim(rtrim(b.prmr_aplldo)),	ltrim(rtrim(b.sgndo_aplldo))
							From		bdAfiliacionValidador.dbo.tbBeneficiariosValidador	b	With(NoLock)
							inner join	bdAfiliacionValidador.dbo.tbContratosValidador		c	With(NoLock)	on	c.nmro_cntrto				= b.nmro_cntrto
																												And	c.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
							Inner Join	#tmpDatosEntrada									d	With(NoLock)	On	d.prmr_aplldo				= b.prmr_aplldo
																												And	d.prmr_nmbre				= b.prmr_nmbre 
																												And	d.sgndo_nmbre				= b.sgndo_nmbre
							Where		c.cnsctvo_cdgo_pln = @cnsctvo_cdgo_pln
						end

					If @opcn = 3
						begin
							--print 'entro 3'
							Insert Into @tmpGrupoFamiliar
									(	Orgn,						Bd,								cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,
										nmro_cntrto,				inco_vgnca_bnfcro,				fn_vgnca_bnfcro,				fcha_ncmnto,
										estdo,
										cnsctvo_cdgo_pln,			cnsctvo_cdgo_prntsco,			cnsctvo_cdgo_tpo_afldo,			nmro_unco_idntfccn_bnfcro,
										prmr_nmbre,					sgndo_nmbre,					prmr_aplldo,					sgndo_aplldo
								)
							Select		'CONTRATOS',				1,								b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,
										b.nmro_cntrto,				b.inco_vgnca_bnfcro,			b.fn_vgnca_bnfcro,				b.fcha_ncmnto,
										CASE	WHEN b.fn_vgnca_bnfcro < @fcha_vldcn THEN 'INACTIVO'
												WHEN b.inco_vgnca_bnfcro > @fcha_vldcn THEN 'INACTIVO'
												ELSE	'AFILIADO'
										END,
										c.cnsctvo_cdgo_pln,			b.cnsctvo_cdgo_prntsco,			b.cnsctvo_cdgo_tpo_afldo,		b.nmro_unco_idntfccn_afldo,
										ltrim(rtrim(b.prmr_nmbre)),	ltrim(rtrim(b.sgndo_nmbre)),	ltrim(rtrim(b.prmr_aplldo)),	ltrim(rtrim(b.sgndo_aplldo))
							From		bdAfiliacionValidador.dbo.tbBeneficiariosValidador	b	With(NoLock)
							inner join	bdAfiliacionValidador.dbo.tbContratosValidador		c	With(NoLock)	on	c.nmro_cntrto				= b.nmro_cntrto
																												And	c.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
							Inner Join	#tmpDatosEntrada									d	With(NoLock)	On	d.prmr_nmbre				= b.prmr_nmbre 
																												And	d.sgndo_nmbre				= b.sgndo_nmbre
							Where		c.cnsctvo_cdgo_pln = @cnsctvo_cdgo_pln
						End

					--4
					If @opcn = 4
						Begin
							--print 'entro 4'
							Insert Into @tmpGrupoFamiliar
									(	Orgn,						Bd,								cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,
										nmro_cntrto,				inco_vgnca_bnfcro,				fn_vgnca_bnfcro,				fcha_ncmnto,
										estdo,
										cnsctvo_cdgo_pln,			cnsctvo_cdgo_prntsco,			cnsctvo_cdgo_tpo_afldo,			nmro_unco_idntfccn_bnfcro,
										prmr_nmbre,					sgndo_nmbre,					prmr_aplldo,					sgndo_aplldo
								)
							Select		'CONTRATOS',				1,								b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,
										b.nmro_cntrto,				b.inco_vgnca_bnfcro,			b.fn_vgnca_bnfcro,				b.fcha_ncmnto,
										CASE	WHEN b.fn_vgnca_bnfcro < @fcha_vldcn THEN 'INACTIVO'
												WHEN b.inco_vgnca_bnfcro > @fcha_vldcn THEN 'INACTIVO'
												ELSE	'AFILIADO'
										END,
										c.cnsctvo_cdgo_pln,			b.cnsctvo_cdgo_prntsco,			b.cnsctvo_cdgo_tpo_afldo,		b.nmro_unco_idntfccn_afldo,
										ltrim(rtrim(b.prmr_nmbre)),	ltrim(rtrim(b.sgndo_nmbre)),	ltrim(rtrim(b.prmr_aplldo)),	ltrim(rtrim(b.sgndo_aplldo))
							From		bdAfiliacionValidador.dbo.tbBeneficiariosValidador	b	With(NoLock)
							inner join	bdAfiliacionValidador.dbo.tbContratosValidador		c	With(NoLock)	on	c.nmro_cntrto				= b.nmro_cntrto
																												And	c.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
							Inner Join	#tmpDatosEntrada									d	With(NoLock)	On	d.prmr_nmbre				= b.prmr_nmbre 
							Where		c.cnsctvo_cdgo_pln = @cnsctvo_cdgo_pln
						end

					If @opcn = 5
						begin
							--print 'entro 5'
							Insert Into @tmpGrupoFamiliar
									(	Orgn,						Bd,								cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,
										nmro_cntrto,				inco_vgnca_bnfcro,				fn_vgnca_bnfcro,				fcha_ncmnto,
										estdo,
										cnsctvo_cdgo_pln,			cnsctvo_cdgo_prntsco,			cnsctvo_cdgo_tpo_afldo,			nmro_unco_idntfccn_bnfcro,
										prmr_nmbre,					sgndo_nmbre,					prmr_aplldo,					sgndo_aplldo
								)
							Select		'CONTRATOS',				1,								b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,
										b.nmro_cntrto,				b.inco_vgnca_bnfcro,			b.fn_vgnca_bnfcro,				b.fcha_ncmnto,
										CASE	WHEN b.fn_vgnca_bnfcro < @fcha_vldcn THEN 'INACTIVO'
												WHEN b.inco_vgnca_bnfcro > @fcha_vldcn THEN 'INACTIVO'
												ELSE	'AFILIADO'
										END,
										c.cnsctvo_cdgo_pln,			b.cnsctvo_cdgo_prntsco,			b.cnsctvo_cdgo_tpo_afldo,		b.nmro_unco_idntfccn_afldo,
										ltrim(rtrim(b.prmr_nmbre)),	ltrim(rtrim(b.sgndo_nmbre)),	ltrim(rtrim(b.prmr_aplldo)),	ltrim(rtrim(b.sgndo_aplldo))
							From		bdAfiliacionValidador.dbo.tbBeneficiariosValidador	b	With(NoLock)
							inner join	bdAfiliacionValidador.dbo.tbContratosValidador		c	With(NoLock)	on	c.nmro_cntrto				= b.nmro_cntrto
																												And	c.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
							Inner Join	#tmpDatosEntrada									d	With(NoLock)	On	d.prmr_aplldo				= b.prmr_aplldo
																												And	d.sgndo_aplldo				= b.sgndo_aplldo
																												And	d.sgndo_nmbre				= b.sgndo_nmbre
							Where		c.cnsctvo_cdgo_pln = @cnsctvo_cdgo_pln
						end

					If @opcn = 6
						begin
							--print 'entro 6'
							Insert Into @tmpGrupoFamiliar
									(	Orgn,						Bd,								cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,
										nmro_cntrto,				inco_vgnca_bnfcro,				fn_vgnca_bnfcro,				fcha_ncmnto,
										estdo,
										cnsctvo_cdgo_pln,			cnsctvo_cdgo_prntsco,			cnsctvo_cdgo_tpo_afldo,			nmro_unco_idntfccn_bnfcro,
										prmr_nmbre,					sgndo_nmbre,					prmr_aplldo,					sgndo_aplldo
								)
							Select		'CONTRATOS',				1,								b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,
										b.nmro_cntrto,				b.inco_vgnca_bnfcro,			b.fn_vgnca_bnfcro,				b.fcha_ncmnto,
										CASE	WHEN b.fn_vgnca_bnfcro < @fcha_vldcn THEN 'INACTIVO'
												WHEN b.inco_vgnca_bnfcro > @fcha_vldcn THEN 'INACTIVO'
												ELSE	'AFILIADO'
										END,
										c.cnsctvo_cdgo_pln,			b.cnsctvo_cdgo_prntsco,			b.cnsctvo_cdgo_tpo_afldo,		b.nmro_unco_idntfccn_afldo,
										ltrim(rtrim(b.prmr_nmbre)),	ltrim(rtrim(b.sgndo_nmbre)),	ltrim(rtrim(b.prmr_aplldo)),	ltrim(rtrim(b.sgndo_aplldo))
							From		bdAfiliacionValidador.dbo.tbBeneficiariosValidador	b	With(NoLock)
							inner join	bdAfiliacionValidador.dbo.tbContratosValidador		c	With(NoLock)	on	c.nmro_cntrto				= b.nmro_cntrto
																												And	c.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
							Inner Join	#tmpDatosEntrada									d	With(NoLock)	On	d.sgndo_aplldo				= b.sgndo_aplldo
																												And	d.sgndo_nmbre				= b.sgndo_nmbre
							Where		c.cnsctvo_cdgo_pln = @cnsctvo_cdgo_pln
						end

					If @opcn = 7
						begin
							--print 'entro 7'
							Insert Into @tmpGrupoFamiliar
									(	Orgn,						Bd,								cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,
										nmro_cntrto,				inco_vgnca_bnfcro,				fn_vgnca_bnfcro,				fcha_ncmnto,
										estdo,
										cnsctvo_cdgo_pln,			cnsctvo_cdgo_prntsco,			cnsctvo_cdgo_tpo_afldo,			nmro_unco_idntfccn_bnfcro,
										prmr_nmbre,					sgndo_nmbre,					prmr_aplldo,					sgndo_aplldo
								)
							Select		'CONTRATOS',				1,								b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,
										b.nmro_cntrto,				b.inco_vgnca_bnfcro,			b.fn_vgnca_bnfcro,				b.fcha_ncmnto,
										CASE	WHEN b.fn_vgnca_bnfcro < @fcha_vldcn THEN 'INACTIVO'
												WHEN b.inco_vgnca_bnfcro > @fcha_vldcn THEN 'INACTIVO'
												ELSE	'AFILIADO'
										END,
										c.cnsctvo_cdgo_pln,			b.cnsctvo_cdgo_prntsco,			b.cnsctvo_cdgo_tpo_afldo,		b.nmro_unco_idntfccn_afldo,
										ltrim(rtrim(b.prmr_nmbre)),	ltrim(rtrim(b.sgndo_nmbre)),	ltrim(rtrim(b.prmr_aplldo)),	ltrim(rtrim(b.sgndo_aplldo))
							From		bdAfiliacionValidador.dbo.tbBeneficiariosValidador	b	With(NoLock)
							inner join	bdAfiliacionValidador.dbo.tbContratosValidador		c	With(NoLock)	on	c.nmro_cntrto				= b.nmro_cntrto
																												And	c.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
							Inner Join	#tmpDatosEntrada									d	With(NoLock)	On	d.sgndo_nmbre				= b.sgndo_nmbre
							Where		c.cnsctvo_cdgo_pln = @cnsctvo_cdgo_pln
						end

					if @opcn = 8
						begin
							--print 'entro 8'
							Insert Into @tmpGrupoFamiliar
									(	Orgn,						Bd,								cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,
										nmro_cntrto,				inco_vgnca_bnfcro,				fn_vgnca_bnfcro,				fcha_ncmnto,
										estdo,
										cnsctvo_cdgo_pln,			cnsctvo_cdgo_prntsco,			cnsctvo_cdgo_tpo_afldo,			nmro_unco_idntfccn_bnfcro,
										prmr_nmbre,					sgndo_nmbre,					prmr_aplldo,					sgndo_aplldo
								)
							Select		'CONTRATOS',				1,								b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,
										b.nmro_cntrto,				b.inco_vgnca_bnfcro,			b.fn_vgnca_bnfcro,				b.fcha_ncmnto,
										CASE	WHEN b.fn_vgnca_bnfcro < @fcha_vldcn THEN 'INACTIVO'
												WHEN b.inco_vgnca_bnfcro > @fcha_vldcn THEN 'INACTIVO'
												ELSE	'AFILIADO'
										END,
										c.cnsctvo_cdgo_pln,			b.cnsctvo_cdgo_prntsco,			b.cnsctvo_cdgo_tpo_afldo,		b.nmro_unco_idntfccn_afldo,
										ltrim(rtrim(b.prmr_nmbre)),	ltrim(rtrim(b.sgndo_nmbre)),	ltrim(rtrim(b.prmr_aplldo)),	ltrim(rtrim(b.sgndo_aplldo))
							From		bdAfiliacionValidador.dbo.tbBeneficiariosValidador	b	With(NoLock)
							inner join	bdAfiliacionValidador.dbo.tbContratosValidador		c	With(NoLock)	on	c.nmro_cntrto				= b.nmro_cntrto
																												And	c.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
							Inner Join	#tmpDatosEntrada									d	With(NoLock)	On	d.prmr_aplldo				= b.prmr_aplldo
																												And	d.sgndo_aplldo				= b.sgndo_aplldo
							Where		c.cnsctvo_cdgo_pln = @cnsctvo_cdgo_pln

						end

					if @opcn = 9
						begin
							--print 'entro 9'
							Insert Into @tmpGrupoFamiliar
									(	Orgn,						Bd,								cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,
										nmro_cntrto,				inco_vgnca_bnfcro,				fn_vgnca_bnfcro,				fcha_ncmnto,
										estdo,
										cnsctvo_cdgo_pln,			cnsctvo_cdgo_prntsco,			cnsctvo_cdgo_tpo_afldo,			nmro_unco_idntfccn_bnfcro,
										prmr_nmbre,					sgndo_nmbre,					prmr_aplldo,					sgndo_aplldo
								)
							Select		'CONTRATOS',				1,								b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,
										b.nmro_cntrto,				b.inco_vgnca_bnfcro,			b.fn_vgnca_bnfcro,				b.fcha_ncmnto,
										CASE	WHEN b.fn_vgnca_bnfcro < @fcha_vldcn THEN 'INACTIVO'
												WHEN b.inco_vgnca_bnfcro > @fcha_vldcn THEN 'INACTIVO'
												ELSE	'AFILIADO'
										END,
										c.cnsctvo_cdgo_pln,			b.cnsctvo_cdgo_prntsco,			b.cnsctvo_cdgo_tpo_afldo,		b.nmro_unco_idntfccn_afldo,
										ltrim(rtrim(b.prmr_nmbre)),	ltrim(rtrim(b.sgndo_nmbre)),	ltrim(rtrim(b.prmr_aplldo)),	ltrim(rtrim(b.sgndo_aplldo))
							From		bdAfiliacionValidador.dbo.tbBeneficiariosValidador	b	With(NoLock)
							inner join	bdAfiliacionValidador.dbo.tbContratosValidador		c	With(NoLock)	on	c.nmro_cntrto				= b.nmro_cntrto
																												And	c.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
							Inner Join	#tmpDatosEntrada									d	With(NoLock)	On	d.prmr_aplldo				= b.prmr_aplldo
							Where		c.cnsctvo_cdgo_pln = @cnsctvo_cdgo_pln
						end

					if @opcn = 10
						begin
							--print 'entro 10'
							Insert Into @tmpGrupoFamiliar
									(	Orgn,						Bd,								cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,
										nmro_cntrto,				inco_vgnca_bnfcro,				fn_vgnca_bnfcro,				fcha_ncmnto,
										estdo,
										cnsctvo_cdgo_pln,			cnsctvo_cdgo_prntsco,			cnsctvo_cdgo_tpo_afldo,			nmro_unco_idntfccn_bnfcro,
										prmr_nmbre,					sgndo_nmbre,					prmr_aplldo,					sgndo_aplldo
								)
							Select		'CONTRATOS',				1,								b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,
										b.nmro_cntrto,				b.inco_vgnca_bnfcro,			b.fn_vgnca_bnfcro,				b.fcha_ncmnto,
										CASE	WHEN b.fn_vgnca_bnfcro < @fcha_vldcn THEN 'INACTIVO'
												WHEN b.inco_vgnca_bnfcro > @fcha_vldcn THEN 'INACTIVO'
												ELSE	'AFILIADO'
										END,
										c.cnsctvo_cdgo_pln,			b.cnsctvo_cdgo_prntsco,			b.cnsctvo_cdgo_tpo_afldo,		b.nmro_unco_idntfccn_afldo,
										ltrim(rtrim(b.prmr_nmbre)),	ltrim(rtrim(b.sgndo_nmbre)),	ltrim(rtrim(b.prmr_aplldo)),	ltrim(rtrim(b.sgndo_aplldo))
							From		bdAfiliacionValidador.dbo.tbBeneficiariosValidador	b	With(NoLock)
							inner join	bdAfiliacionValidador.dbo.tbContratosValidador		c	With(NoLock)	on	c.nmro_cntrto				= b.nmro_cntrto
																												And	c.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
							Inner Join	#tmpDatosEntrada									d	With(NoLock)	On	d.sgndo_aplldo				= b.sgndo_aplldo
							Where		c.cnsctvo_cdgo_pln = @cnsctvo_cdgo_pln
						end

					if @opcn = 11
						begin
							--print 'entro 11'
							Insert Into @tmpGrupoFamiliar
									(	Orgn,						Bd,								cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,
										nmro_cntrto,				inco_vgnca_bnfcro,				fn_vgnca_bnfcro,				fcha_ncmnto,
										estdo,
										cnsctvo_cdgo_pln,			cnsctvo_cdgo_prntsco,			cnsctvo_cdgo_tpo_afldo,			nmro_unco_idntfccn_bnfcro,
										prmr_nmbre,					sgndo_nmbre,					prmr_aplldo,					sgndo_aplldo
								)
							Select		'CONTRATOS',				1,								b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,
										b.nmro_cntrto,				b.inco_vgnca_bnfcro,			b.fn_vgnca_bnfcro,				b.fcha_ncmnto,
										CASE	WHEN b.fn_vgnca_bnfcro < @fcha_vldcn THEN 'INACTIVO'
												WHEN b.inco_vgnca_bnfcro > @fcha_vldcn THEN 'INACTIVO'
												ELSE	'AFILIADO'
										END,
										c.cnsctvo_cdgo_pln,			b.cnsctvo_cdgo_prntsco,			b.cnsctvo_cdgo_tpo_afldo,		b.nmro_unco_idntfccn_afldo,
										ltrim(rtrim(b.prmr_nmbre)),	ltrim(rtrim(b.sgndo_nmbre)),	ltrim(rtrim(b.prmr_aplldo)),	ltrim(rtrim(b.sgndo_aplldo))
							From		bdAfiliacionValidador.dbo.tbBeneficiariosValidador	b	With(NoLock)
							inner join	bdAfiliacionValidador.dbo.tbContratosValidador		c	With(NoLock)	on	c.nmro_cntrto				= b.nmro_cntrto
																												And	c.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
							Inner Join	#tmpDatosEntrada									d	With(NoLock)	On	d.prmr_aplldo				= b.prmr_aplldo
																												And	d.prmr_nmbre				= b.prmr_nmbre
							Where		c.cnsctvo_cdgo_pln = @cnsctvo_cdgo_pln
						end

					if @opcn = 12
						begin
							--print 'entro 11'
							Insert Into @tmpGrupoFamiliar
									(	Orgn,						Bd,								cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,
										nmro_cntrto,				inco_vgnca_bnfcro,				fn_vgnca_bnfcro,				fcha_ncmnto,
										estdo,
										cnsctvo_cdgo_pln,			cnsctvo_cdgo_prntsco,			cnsctvo_cdgo_tpo_afldo,			nmro_unco_idntfccn_bnfcro,
										prmr_nmbre,					sgndo_nmbre,					prmr_aplldo,					sgndo_aplldo
								)
							Select		'CONTRATOS',				1,								b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,
										b.nmro_cntrto,				b.inco_vgnca_bnfcro,			b.fn_vgnca_bnfcro,				b.fcha_ncmnto,
										CASE	WHEN b.fn_vgnca_bnfcro < @fcha_vldcn THEN 'INACTIVO'
												WHEN b.inco_vgnca_bnfcro > @fcha_vldcn THEN 'INACTIVO'
												ELSE	'AFILIADO'
										END,
										c.cnsctvo_cdgo_pln,			b.cnsctvo_cdgo_prntsco,			b.cnsctvo_cdgo_tpo_afldo,		b.nmro_unco_idntfccn_afldo,
										ltrim(rtrim(b.prmr_nmbre)),	ltrim(rtrim(b.sgndo_nmbre)),	ltrim(rtrim(b.prmr_aplldo)),	ltrim(rtrim(b.sgndo_aplldo))
							From		bdAfiliacionValidador.dbo.tbBeneficiariosValidador	b	With(NoLock)
							inner join	bdAfiliacionValidador.dbo.tbContratosValidador		c	With(NoLock)	on	c.nmro_cntrto				= b.nmro_cntrto
																												And	c.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
							Inner Join	#tmpDatosEntrada									d	With(NoLock)	On	d.prmr_aplldo				= b.prmr_aplldo
																												And	d.sgndo_aplldo				= b.sgndo_aplldo
																												And	d.prmr_nmbre				= b.prmr_nmbre
							Where		c.cnsctvo_cdgo_pln = @cnsctvo_cdgo_pln
						end

					If Exists	(	Select	1
									From	@tmpGrupoFamiliar
								)
						Begin
							insert into #borrar
									(	cnsctvo_cdgo_pln,			nmro_unco_idntfccn_bnfcro,				fn_vgnca_bnfcro
									)
							Select		cnsctvo_cdgo_pln,			nmro_unco_idntfccn_bnfcro,				Max(fn_vgnca_bnfcro) as fn_vgnca_bnfcro
							From		@tmpGrupoFamiliar
							Group by	cnsctvo_cdgo_pln,	nmro_unco_idntfccn_bnfcro

							Delete		@tmpGrupoFamiliar
							From		@tmpGrupoFamiliar	f
							Left Join	#borrar				g	with(NoLock)	on	f.cnsctvo_cdgo_pln			= g.cnsctvo_cdgo_pln
																				And	f.nmro_unco_idntfccn_bnfcro	= g.nmro_unco_idntfccn_bnfcro
																				And	f.fn_vgnca_bnfcro			= g.fn_vgnca_bnfcro
							Where		g.cnsctvo_cdgo_pln is null
						End
					Else
						-- RUTA PARA BUSCAR EN ESTRUCTURA DE EAPB EN CASO DE NO ENCONTRARLO COMO CONTRATO
						Begin
							If @opcn = 1
								Begin
									Insert Into @tmpGrupoFamiliar
											(	Orgn,								Bd,									cnsctvo_cdgo_tpo_idntfccn,			nmro_idntfccn,
												inco_vgnca_bnfcro,					fn_vgnca_bnfcro,					fcha_ncmnto,						estdo,
												cnsctvo_cdgo_pln,					cnsctvo_cdgo_prntsco,				cnsctvo_cdgo_tpo_afldo,				nmro_unco_idntfccn_bnfcro,
												prmr_nmbre,							sgndo_nmbre,						prmr_aplldo,						sgndo_aplldo
									)	
									Select		'FAMISANAR',						3,									b.cnsctvo_cdgo_tpo_idntfccn_bnfcro,	b.nmro_idntfccn_bnfcro,
												b.inco_vgnca,						b.fn_vgnca,							b.fcha_ncmnto,						'INACTIVO',
												b.cnsctvo_cdgo_pln,					b.prntsco,							b.cnsctvo_cdgo_tpo_afldo,			null,
												ltrim(rtrim(b.prmr_nmbre_bnfcro)),	ltrim(rtrim(b.sgndo_nmbre_bnfcro)),	ltrim(rtrim(b.prmr_aplldo_bnfcro)),	ltrim(rtrim(b.sgndo_aplldo_bnfcro))
									From		bdAfiliacionValidador.dbo.tbEapb					b	With(NoLock)
									Inner Join	bdAfiliacionValidador.dbo.tbDetalleeapb_Vigencias	d	With(NoLock)	On	d.cdgo_eapb		= b.cdgo_eapb
									Inner Join	#tmpDatosEntrada									c	With(NoLock)	On	c.prmr_aplldo	= b.prmr_aplldo_bnfcro
																														And	c.sgndo_aplldo	= b.sgndo_aplldo_bnfcro
																														And	c.prmr_nmbre	= b.prmr_nmbre_bnfcro 
																														And	c.sgndo_nmbre	= b.sgndo_nmbre_bnfcro
									Where		fcha_hsta			= '9999/12/31'
									And			b.cnsctvo_cdgo_pln	= @cnsctvo_cdgo_pln
									And			@fcha_vldcn Between d.inco_vgnca And d.fn_vgnca
									And			d.vsble_vlddr		= 'S'
								End

							If @opcn = 2
								Begin
									Insert Into @tmpGrupoFamiliar
											(	Orgn,								Bd,									cnsctvo_cdgo_tpo_idntfccn,			nmro_idntfccn,
												inco_vgnca_bnfcro,					fn_vgnca_bnfcro,					fcha_ncmnto,						estdo,
												cnsctvo_cdgo_pln,					cnsctvo_cdgo_prntsco,				cnsctvo_cdgo_tpo_afldo,				nmro_unco_idntfccn_bnfcro,
												prmr_nmbre,							sgndo_nmbre,						prmr_aplldo,						sgndo_aplldo
									)	
									Select		'FAMISANAR',						3,									b.cnsctvo_cdgo_tpo_idntfccn_bnfcro,	b.nmro_idntfccn_bnfcro,
												b.inco_vgnca,						b.fn_vgnca,							b.fcha_ncmnto,						'INACTIVO',
												b.cnsctvo_cdgo_pln,					b.prntsco,							b.cnsctvo_cdgo_tpo_afldo,			null,
												ltrim(rtrim(b.prmr_nmbre_bnfcro)),	ltrim(rtrim(b.sgndo_nmbre_bnfcro)),	ltrim(rtrim(b.prmr_aplldo_bnfcro)),	ltrim(rtrim(b.sgndo_aplldo_bnfcro))
									From		bdAfiliacionValidador.dbo.tbEapb					b	With(NoLock)
									Inner Join	bdAfiliacionValidador.dbo.tbDetalleeapb_Vigencias	d	With(NoLock)	On	d.cdgo_eapb		= b.cdgo_eapb
									Inner Join	#tmpDatosEntrada									c	With(NoLock)	On	c.prmr_aplldo	= b.prmr_aplldo_bnfcro
																														And	c.prmr_nmbre	= b.prmr_nmbre_bnfcro 
																														And	c.sgndo_nmbre	= b.sgndo_nmbre_bnfcro
									Where		fcha_hsta			= '9999/12/31'
									And			b.cnsctvo_cdgo_pln	= @cnsctvo_cdgo_pln
									And			@fcha_vldcn Between d.inco_vgnca And d.fn_vgnca
									And			d.vsble_vlddr		= 'S'
								End

							If @opcn = 3
								Begin
									Insert Into @tmpGrupoFamiliar
											(	Orgn,								Bd,									cnsctvo_cdgo_tpo_idntfccn,			nmro_idntfccn,
												inco_vgnca_bnfcro,					fn_vgnca_bnfcro,					fcha_ncmnto,						estdo,
												cnsctvo_cdgo_pln,					cnsctvo_cdgo_prntsco,				cnsctvo_cdgo_tpo_afldo,				nmro_unco_idntfccn_bnfcro,
												prmr_nmbre,							sgndo_nmbre,						prmr_aplldo,						sgndo_aplldo
									)	
									Select		'FAMISANAR',						3,									b.cnsctvo_cdgo_tpo_idntfccn_bnfcro,	b.nmro_idntfccn_bnfcro,
												b.inco_vgnca,						b.fn_vgnca,							b.fcha_ncmnto,						'INACTIVO',
												b.cnsctvo_cdgo_pln,					b.prntsco,							b.cnsctvo_cdgo_tpo_afldo,			null,
												ltrim(rtrim(b.prmr_nmbre_bnfcro)),	ltrim(rtrim(b.sgndo_nmbre_bnfcro)),	ltrim(rtrim(b.prmr_aplldo_bnfcro)),	ltrim(rtrim(b.sgndo_aplldo_bnfcro))
									From		bdAfiliacionValidador.dbo.tbEapb					b	With(NoLock)
									Inner Join	bdAfiliacionValidador.dbo.tbDetalleeapb_Vigencias	d	With(NoLock)	On	d.cdgo_eapb		= b.cdgo_eapb
									Inner Join	#tmpDatosEntrada									c	With(NoLock)	On	c.prmr_nmbre	= b.prmr_nmbre_bnfcro 
																														And	c.sgndo_nmbre	= b.sgndo_nmbre_bnfcro
									Where		fcha_hsta			= '9999/12/31'
									And			b.cnsctvo_cdgo_pln	= @cnsctvo_cdgo_pln
									And			@fcha_vldcn Between d.inco_vgnca And d.fn_vgnca
									And			d.vsble_vlddr		= 'S'
								End

							If @opcn = 4
								Begin
									Insert Into @tmpGrupoFamiliar
											(	Orgn,								Bd,									cnsctvo_cdgo_tpo_idntfccn,			nmro_idntfccn,
												inco_vgnca_bnfcro,					fn_vgnca_bnfcro,					fcha_ncmnto,						estdo,
												cnsctvo_cdgo_pln,					cnsctvo_cdgo_prntsco,				cnsctvo_cdgo_tpo_afldo,				nmro_unco_idntfccn_bnfcro,
												prmr_nmbre,							sgndo_nmbre,						prmr_aplldo,						sgndo_aplldo
									)	
									Select		'FAMISANAR',						3,									b.cnsctvo_cdgo_tpo_idntfccn_bnfcro,	b.nmro_idntfccn_bnfcro,
												b.inco_vgnca,						b.fn_vgnca,							b.fcha_ncmnto,						'INACTIVO',
												b.cnsctvo_cdgo_pln,					b.prntsco,							b.cnsctvo_cdgo_tpo_afldo,			null,
												ltrim(rtrim(b.prmr_nmbre_bnfcro)),	ltrim(rtrim(b.sgndo_nmbre_bnfcro)),	ltrim(rtrim(b.prmr_aplldo_bnfcro)),	ltrim(rtrim(b.sgndo_aplldo_bnfcro))
									From		bdAfiliacionValidador.dbo.tbEapb					b	With(NoLock)
									Inner Join	bdAfiliacionValidador.dbo.tbDetalleeapb_Vigencias	d	With(NoLock)	On	d.cdgo_eapb		= b.cdgo_eapb
									Inner Join	#tmpDatosEntrada									c	With(NoLock)	On	c.prmr_nmbre	= b.prmr_nmbre_bnfcro
									Where		fcha_hsta			= '9999/12/31'
									And			b.cnsctvo_cdgo_pln	= @cnsctvo_cdgo_pln
									And			@fcha_vldcn Between d.inco_vgnca And d.fn_vgnca
									And			d.vsble_vlddr		= 'S'
								End

							If @opcn = 5
								Begin
									Insert Into @tmpGrupoFamiliar
											(	Orgn,								Bd,									cnsctvo_cdgo_tpo_idntfccn,			nmro_idntfccn,
												inco_vgnca_bnfcro,					fn_vgnca_bnfcro,					fcha_ncmnto,						estdo,
												cnsctvo_cdgo_pln,					cnsctvo_cdgo_prntsco,				cnsctvo_cdgo_tpo_afldo,				nmro_unco_idntfccn_bnfcro,
												prmr_nmbre,							sgndo_nmbre,						prmr_aplldo,						sgndo_aplldo
									)	
									Select		'FAMISANAR',						3,									b.cnsctvo_cdgo_tpo_idntfccn_bnfcro,	b.nmro_idntfccn_bnfcro,
												b.inco_vgnca,						b.fn_vgnca,							b.fcha_ncmnto,						'INACTIVO',
												b.cnsctvo_cdgo_pln,					b.prntsco,							b.cnsctvo_cdgo_tpo_afldo,			null,
												ltrim(rtrim(b.prmr_nmbre_bnfcro)),	ltrim(rtrim(b.sgndo_nmbre_bnfcro)),	ltrim(rtrim(b.prmr_aplldo_bnfcro)),	ltrim(rtrim(b.sgndo_aplldo_bnfcro))
									From		bdAfiliacionValidador.dbo.tbEapb					b	With(NoLock)
									Inner Join	bdAfiliacionValidador.dbo.tbDetalleeapb_Vigencias	d	With(NoLock)	On	d.cdgo_eapb		= b.cdgo_eapb
									Inner Join	#tmpDatosEntrada									c	With(NoLock)	On	c.prmr_aplldo	= b.prmr_aplldo_bnfcro
																														And	c.sgndo_aplldo	= b.sgndo_aplldo_bnfcro
																														And	c.sgndo_nmbre	= b.sgndo_nmbre_bnfcro
									Where		fcha_hsta			= '9999/12/31'
									And			b.cnsctvo_cdgo_pln	= @cnsctvo_cdgo_pln
									And			@fcha_vldcn Between d.inco_vgnca And d.fn_vgnca
									And			d.vsble_vlddr		= 'S'
								End

							If @opcn = 6
								Begin
									Insert Into @tmpGrupoFamiliar
											(	Orgn,								Bd,									cnsctvo_cdgo_tpo_idntfccn,			nmro_idntfccn,
												inco_vgnca_bnfcro,					fn_vgnca_bnfcro,					fcha_ncmnto,						estdo,
												cnsctvo_cdgo_pln,					cnsctvo_cdgo_prntsco,				cnsctvo_cdgo_tpo_afldo,				nmro_unco_idntfccn_bnfcro,
												prmr_nmbre,							sgndo_nmbre,						prmr_aplldo,						sgndo_aplldo
									)	
									Select		'FAMISANAR',						3,									b.cnsctvo_cdgo_tpo_idntfccn_bnfcro,	b.nmro_idntfccn_bnfcro,
												b.inco_vgnca,						b.fn_vgnca,							b.fcha_ncmnto,						'INACTIVO',
												b.cnsctvo_cdgo_pln,					b.prntsco,							b.cnsctvo_cdgo_tpo_afldo,			null,
												ltrim(rtrim(b.prmr_nmbre_bnfcro)),	ltrim(rtrim(b.sgndo_nmbre_bnfcro)),	ltrim(rtrim(b.prmr_aplldo_bnfcro)),	ltrim(rtrim(b.sgndo_aplldo_bnfcro))
									From		bdAfiliacionValidador.dbo.tbEapb					b	With(NoLock)
									Inner Join	bdAfiliacionValidador.dbo.tbDetalleeapb_Vigencias	d	With(NoLock)	On	d.cdgo_eapb		= b.cdgo_eapb
									Inner Join	#tmpDatosEntrada									c	With(NoLock)	On	c.sgndo_aplldo	= b.sgndo_aplldo_bnfcro
																														And	c.sgndo_nmbre	= b.sgndo_nmbre_bnfcro
									Where		fcha_hsta			= '9999/12/31'
									And			b.cnsctvo_cdgo_pln	= @cnsctvo_cdgo_pln
									And			@fcha_vldcn Between d.inco_vgnca And d.fn_vgnca
									And			d.vsble_vlddr		= 'S'
								End

							If @opcn = 7
								Begin
									Insert Into @tmpGrupoFamiliar
											(	Orgn,								Bd,									cnsctvo_cdgo_tpo_idntfccn,			nmro_idntfccn,
												inco_vgnca_bnfcro,					fn_vgnca_bnfcro,					fcha_ncmnto,						estdo,
												cnsctvo_cdgo_pln,					cnsctvo_cdgo_prntsco,				cnsctvo_cdgo_tpo_afldo,				nmro_unco_idntfccn_bnfcro,
												prmr_nmbre,							sgndo_nmbre,						prmr_aplldo,						sgndo_aplldo
									)	
									Select		'FAMISANAR',						3,									b.cnsctvo_cdgo_tpo_idntfccn_bnfcro,	b.nmro_idntfccn_bnfcro,
												b.inco_vgnca,						b.fn_vgnca,							b.fcha_ncmnto,						'INACTIVO',
												b.cnsctvo_cdgo_pln,					b.prntsco,							b.cnsctvo_cdgo_tpo_afldo,			null,
												ltrim(rtrim(b.prmr_nmbre_bnfcro)),	ltrim(rtrim(b.sgndo_nmbre_bnfcro)),	ltrim(rtrim(b.prmr_aplldo_bnfcro)),	ltrim(rtrim(b.sgndo_aplldo_bnfcro))
									From		bdAfiliacionValidador.dbo.tbEapb					b	With(NoLock)
									Inner Join	bdAfiliacionValidador.dbo.tbDetalleeapb_Vigencias	d	With(NoLock)	On	d.cdgo_eapb		= b.cdgo_eapb
									Inner Join	#tmpDatosEntrada									c	With(NoLock)	On	c.sgndo_nmbre	= b.sgndo_nmbre_bnfcro
									Where		fcha_hsta			= '9999/12/31'
									And			b.cnsctvo_cdgo_pln	= @cnsctvo_cdgo_pln
									And			@fcha_vldcn Between d.inco_vgnca And d.fn_vgnca
									And			d.vsble_vlddr		= 'S'
								End

							If @opcn = 8
								Begin
									Insert Into @tmpGrupoFamiliar
											(	Orgn,								Bd,									cnsctvo_cdgo_tpo_idntfccn,			nmro_idntfccn,
												inco_vgnca_bnfcro,					fn_vgnca_bnfcro,					fcha_ncmnto,						estdo,
												cnsctvo_cdgo_pln,					cnsctvo_cdgo_prntsco,				cnsctvo_cdgo_tpo_afldo,				nmro_unco_idntfccn_bnfcro,
												prmr_nmbre,							sgndo_nmbre,						prmr_aplldo,						sgndo_aplldo
									)	
									Select		'FAMISANAR',						3,									b.cnsctvo_cdgo_tpo_idntfccn_bnfcro,	b.nmro_idntfccn_bnfcro,
												b.inco_vgnca,						b.fn_vgnca,							b.fcha_ncmnto,						'INACTIVO',
												b.cnsctvo_cdgo_pln,					b.prntsco,							b.cnsctvo_cdgo_tpo_afldo,			null,
												ltrim(rtrim(b.prmr_nmbre_bnfcro)),	ltrim(rtrim(b.sgndo_nmbre_bnfcro)),	ltrim(rtrim(b.prmr_aplldo_bnfcro)),	ltrim(rtrim(b.sgndo_aplldo_bnfcro))
									From		bdAfiliacionValidador.dbo.tbEapb					b	With(NoLock)
									Inner Join	bdAfiliacionValidador.dbo.tbDetalleeapb_Vigencias	d	With(NoLock)	On	d.cdgo_eapb		= b.cdgo_eapb
									Inner Join	#tmpDatosEntrada									c	With(NoLock)	On	c.prmr_aplldo	= b.prmr_aplldo_bnfcro
																														And	c.sgndo_aplldo	= b.sgndo_aplldo_bnfcro
									Where		fcha_hsta			= '9999/12/31'
									And			b.cnsctvo_cdgo_pln	= @cnsctvo_cdgo_pln
									And			@fcha_vldcn Between d.inco_vgnca And d.fn_vgnca
									And			d.vsble_vlddr		= 'S'
								End

							If @opcn = 9
								Begin
									Insert Into @tmpGrupoFamiliar
											(	Orgn,								Bd,									cnsctvo_cdgo_tpo_idntfccn,			nmro_idntfccn,
												inco_vgnca_bnfcro,					fn_vgnca_bnfcro,					fcha_ncmnto,						estdo,
												cnsctvo_cdgo_pln,					cnsctvo_cdgo_prntsco,				cnsctvo_cdgo_tpo_afldo,				nmro_unco_idntfccn_bnfcro,
												prmr_nmbre,							sgndo_nmbre,						prmr_aplldo,						sgndo_aplldo
									)	
									Select		'FAMISANAR',						3,									b.cnsctvo_cdgo_tpo_idntfccn_bnfcro,	b.nmro_idntfccn_bnfcro,
												b.inco_vgnca,						b.fn_vgnca,							b.fcha_ncmnto,						'INACTIVO',
												b.cnsctvo_cdgo_pln,					b.prntsco,							b.cnsctvo_cdgo_tpo_afldo,			null,
												ltrim(rtrim(b.prmr_nmbre_bnfcro)),	ltrim(rtrim(b.sgndo_nmbre_bnfcro)),	ltrim(rtrim(b.prmr_aplldo_bnfcro)),	ltrim(rtrim(b.sgndo_aplldo_bnfcro))
									From		bdAfiliacionValidador.dbo.tbEapb					b	With(NoLock)
									Inner Join	bdAfiliacionValidador.dbo.tbDetalleeapb_Vigencias	d	With(NoLock)	On	d.cdgo_eapb		= b.cdgo_eapb
									Inner Join	#tmpDatosEntrada									c	With(NoLock)	On	c.prmr_aplldo	= b.prmr_aplldo_bnfcro
									Where		fcha_hsta			= '9999/12/31'
									And			b.cnsctvo_cdgo_pln	= @cnsctvo_cdgo_pln
									And			@fcha_vldcn Between d.inco_vgnca And d.fn_vgnca
									And			d.vsble_vlddr		= 'S'
								End

							If @opcn = 10
								Begin
									Insert Into @tmpGrupoFamiliar
											(	Orgn,								Bd,									cnsctvo_cdgo_tpo_idntfccn,			nmro_idntfccn,
												inco_vgnca_bnfcro,					fn_vgnca_bnfcro,					fcha_ncmnto,						estdo,
												cnsctvo_cdgo_pln,					cnsctvo_cdgo_prntsco,				cnsctvo_cdgo_tpo_afldo,				nmro_unco_idntfccn_bnfcro,
												prmr_nmbre,							sgndo_nmbre,						prmr_aplldo,						sgndo_aplldo
									)	
									Select		'FAMISANAR',						3,									b.cnsctvo_cdgo_tpo_idntfccn_bnfcro,	b.nmro_idntfccn_bnfcro,
												b.inco_vgnca,						b.fn_vgnca,							b.fcha_ncmnto,						'INACTIVO',
												b.cnsctvo_cdgo_pln,					b.prntsco,							b.cnsctvo_cdgo_tpo_afldo,			null,
												ltrim(rtrim(b.prmr_nmbre_bnfcro)),	ltrim(rtrim(b.sgndo_nmbre_bnfcro)),	ltrim(rtrim(b.prmr_aplldo_bnfcro)),	ltrim(rtrim(b.sgndo_aplldo_bnfcro))
									From		bdAfiliacionValidador.dbo.tbEapb					b	With(NoLock)
									Inner Join	bdAfiliacionValidador.dbo.tbDetalleeapb_Vigencias	d	With(NoLock)	On	d.cdgo_eapb		= b.cdgo_eapb
									Inner Join	#tmpDatosEntrada									c	With(NoLock)	On	c.sgndo_aplldo	= b.sgndo_aplldo_bnfcro
									Where		fcha_hsta			= '9999/12/31'
									And			b.cnsctvo_cdgo_pln	= @cnsctvo_cdgo_pln
									And			@fcha_vldcn Between d.inco_vgnca And d.fn_vgnca
									And			d.vsble_vlddr		= 'S'
								End

							If @opcn = 11
								Begin
									Insert Into @tmpGrupoFamiliar
											(	Orgn,								Bd,									cnsctvo_cdgo_tpo_idntfccn,			nmro_idntfccn,
												inco_vgnca_bnfcro,					fn_vgnca_bnfcro,					fcha_ncmnto,						estdo,
												cnsctvo_cdgo_pln,					cnsctvo_cdgo_prntsco,				cnsctvo_cdgo_tpo_afldo,				nmro_unco_idntfccn_bnfcro,
												prmr_nmbre,							sgndo_nmbre,						prmr_aplldo,						sgndo_aplldo
									)	
									Select		'FAMISANAR',						3,									b.cnsctvo_cdgo_tpo_idntfccn_bnfcro,	b.nmro_idntfccn_bnfcro,
												b.inco_vgnca,						b.fn_vgnca,							b.fcha_ncmnto,						'INACTIVO',
												b.cnsctvo_cdgo_pln,					b.prntsco,							b.cnsctvo_cdgo_tpo_afldo,			null,
												ltrim(rtrim(b.prmr_nmbre_bnfcro)),	ltrim(rtrim(b.sgndo_nmbre_bnfcro)),	ltrim(rtrim(b.prmr_aplldo_bnfcro)),	ltrim(rtrim(b.sgndo_aplldo_bnfcro))
									From		bdAfiliacionValidador.dbo.tbEapb					b	With(NoLock)
									Inner Join	bdAfiliacionValidador.dbo.tbDetalleeapb_Vigencias	d	With(NoLock)	On	d.cdgo_eapb		= b.cdgo_eapb
									Inner Join	#tmpDatosEntrada									c	With(NoLock)	On	c.prmr_aplldo	= b.prmr_aplldo_bnfcro
																														And	c.prmr_nmbre	= b.prmr_nmbre_bnfcro
									Where		fcha_hsta			= '9999/12/31'
									And			b.cnsctvo_cdgo_pln	= @cnsctvo_cdgo_pln
									And			@fcha_vldcn Between d.inco_vgnca And d.fn_vgnca
									And			d.vsble_vlddr		= 'S'
								End

							If @opcn = 12
								Begin
									Insert Into @tmpGrupoFamiliar
											(	Orgn,								Bd,									cnsctvo_cdgo_tpo_idntfccn,			nmro_idntfccn,
												inco_vgnca_bnfcro,					fn_vgnca_bnfcro,					fcha_ncmnto,						estdo,
												cnsctvo_cdgo_pln,					cnsctvo_cdgo_prntsco,				cnsctvo_cdgo_tpo_afldo,				nmro_unco_idntfccn_bnfcro,
												prmr_nmbre,							sgndo_nmbre,						prmr_aplldo,						sgndo_aplldo
									)	
									Select		'FAMISANAR',						3,									b.cnsctvo_cdgo_tpo_idntfccn_bnfcro,	b.nmro_idntfccn_bnfcro,
												b.inco_vgnca,						b.fn_vgnca,							b.fcha_ncmnto,						'INACTIVO',
												b.cnsctvo_cdgo_pln,					b.prntsco,							b.cnsctvo_cdgo_tpo_afldo,			null,
												ltrim(rtrim(b.prmr_nmbre_bnfcro)),	ltrim(rtrim(b.sgndo_nmbre_bnfcro)),	ltrim(rtrim(b.prmr_aplldo_bnfcro)),	ltrim(rtrim(b.sgndo_aplldo_bnfcro))
									From		bdAfiliacionValidador.dbo.tbEapb					b	With(NoLock)
									Inner Join	bdAfiliacionValidador.dbo.tbDetalleeapb_Vigencias	d	With(NoLock)	On	d.cdgo_eapb		= b.cdgo_eapb
									Inner Join	#tmpDatosEntrada									c	With(NoLock)	On	c.prmr_aplldo	= b.prmr_aplldo_bnfcro
																														And	c.sgndo_aplldo	= b.sgndo_aplldo_bnfcro
																														And	c.prmr_nmbre	= b.prmr_nmbre_bnfcro
									Where		fcha_hsta			= '9999/12/31'
									And			b.cnsctvo_cdgo_pln	= @cnsctvo_cdgo_pln
									And			@fcha_vldcn Between d.inco_vgnca And d.fn_vgnca
									And			d.vsble_vlddr		= 'S'
								End
						End
				
					Update		@tmpGrupoFamiliar
					Set			cdgo_tpo_idntfccn = i.cdgo_tpo_idntfccn
					From		@tmpGrupoFamiliar								t
					inner join	bdAfiliacionValidador.dbo.tbTiposIdentificacion	i	With(NoLock)	On	t.cnsctvo_cdgo_tpo_idntfccn	= i.cnsctvo_cdgo_tpo_idntfccn

					Update		@tmpGrupoFamiliar
					Set			dscrpcn_prntsco = p.dscrpcn_prntsco
					From		@tmpGrupoFamiliar							t
					INNER JOIN	bdAfiliacionValidador.dbo.tbParentescos		p	With(NoLock)	On	t.cnsctvo_cdgo_prntsco = p.cnsctvo_cdgo_prntscs

					Update		@tmpGrupoFamiliar
					Set			tpo_afldo = a.dscrpcn
					From		@tmpGrupoFamiliar							t
					INNER JOIN	bdAfiliacionValidador.dbo.tbTiposAfiliado	a	With(NoLock)	On	t.cnsctvo_cdgo_tpo_afldo	= a.cnsctvo_cdgo_tpo_afldo

					Update		@tmpGrupoFamiliar
					Set			dscrpcn_pln	= p.dscrpcn_pln
					From		@tmpGrupoFamiliar					t
					INNER JOIN	bdAfiliacionValidador.dbo.tbPlanes	p	With(NoLock)	On	t.cnsctvo_cdgo_pln	= p.cnsctvo_cdgo_pln

					Update		@tmpGrupoFamiliar
					Set			dscrpcn_pln	= 'FORMULARIO'
					Where		Bd	= 2

					Update		@tmpGrupoFamiliar
					Set			dscrpcn_pln	= 'FAMISANAR'
					Where		Bd	= 3

					Update		@tmpGrupoFamiliar
					Set			Nmbre_Afldo	=	IsNull(Ltrim(Rtrim(prmr_aplldo)),'')+' '+IsNull(Ltrim(Rtrim(sgndo_aplldo)),'')+' '+IsNull(Ltrim(Rtrim(prmr_nmbre)),'')+' '+IsNull(Ltrim(Rtrim(sgndo_nmbre)),'')

					Select		dscrpcn_pln,				cdgo_tpo_idntfccn,			nmro_idntfccn,				Nmbre_Afldo,
								tpo_afldo,					fcha_ncmnto,				dscrpcn_prntsco,			nmro_cntrto,
								inco_vgnca_bnfcro,			fn_vgnca_bnfcro,			estdo,						cnsctvo_cdgo_pln,
								nmro_unco_idntfccn_bnfcro,	cnsctvo_cdgo_tpo_idntfccn,	cnsctvo_cdgo_prntsco,		cnsctvo_cdgo_tpo_afldo,
								Orgn,						Bd
					From		@tmpGrupoFamiliar
					Order by	prmr_nmbre,sgndo_nmbre,prmr_aplldo,sgndo_aplldo

			End ----FINALIZACIÓN DEL BLOQUE CUANDO EL PLAN LLEGA COMO PARÁMETRO
	Else 
		Begin	----INICIO DEL BLOQUE CUANDO EL PLAN LLEGÓ VACÍO
			--print 'plan vacio'
			If @opcn = 1
				Begin
					--print 'entra 1'
					Insert Into @tmpGrupoFamiliar
							(	Orgn,						Bd,								cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,
								nmro_cntrto,				inco_vgnca_bnfcro,				fn_vgnca_bnfcro,				fcha_ncmnto,
								estdo,
								cnsctvo_cdgo_pln,			cnsctvo_cdgo_prntsco,			cnsctvo_cdgo_tpo_afldo,			nmro_unco_idntfccn_bnfcro,
								prmr_nmbre,					sgndo_nmbre,					prmr_aplldo,					sgndo_aplldo
						)
					Select		'CONTRATOS',				1,								b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,
								b.nmro_cntrto,				b.inco_vgnca_bnfcro,			b.fn_vgnca_bnfcro,				b.fcha_ncmnto,
								CASE	WHEN b.fn_vgnca_bnfcro < @fcha_vldcn THEN 'INACTIVO'
										WHEN b.inco_vgnca_bnfcro > @fcha_vldcn THEN 'INACTIVO'
										ELSE	'AFILIADO'
								END,
								c.cnsctvo_cdgo_pln,			b.cnsctvo_cdgo_prntsco,			b.cnsctvo_cdgo_tpo_afldo,		b.nmro_unco_idntfccn_afldo,
								ltrim(rtrim(b.prmr_nmbre)),	ltrim(rtrim(b.sgndo_nmbre)),	ltrim(rtrim(b.prmr_aplldo)),	ltrim(rtrim(b.sgndo_aplldo))
					From		bdAfiliacionValidador.dbo.tbBeneficiariosValidador	b	With(NoLock)
					inner join	bdAfiliacionValidador.dbo.tbContratosValidador		c	With(NoLock)	on	c.nmro_cntrto				= b.nmro_cntrto
																										And	c.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
					Inner Join	#tmpDatosEntrada									d	With(NoLock)	On	d.prmr_aplldo				= b.prmr_aplldo
																										And	d.sgndo_aplldo				= b.sgndo_aplldo
																										And	d.prmr_nmbre				= b.prmr_nmbre 
																										And	d.sgndo_nmbre				= b.sgndo_nmbre
				End

			If @opcn = 2
				begin
					--print 'entra 2'
					Insert Into @tmpGrupoFamiliar
							(	Orgn,						Bd,								cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,
								nmro_cntrto,				inco_vgnca_bnfcro,				fn_vgnca_bnfcro,				fcha_ncmnto,
								estdo,
								cnsctvo_cdgo_pln,			cnsctvo_cdgo_prntsco,			cnsctvo_cdgo_tpo_afldo,			nmro_unco_idntfccn_bnfcro,
								prmr_nmbre,					sgndo_nmbre,					prmr_aplldo,					sgndo_aplldo
						)
					Select		'CONTRATOS',				1,								b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,
								b.nmro_cntrto,				b.inco_vgnca_bnfcro,			b.fn_vgnca_bnfcro,				b.fcha_ncmnto,
								CASE	WHEN b.fn_vgnca_bnfcro < @fcha_vldcn THEN 'INACTIVO'
										WHEN b.inco_vgnca_bnfcro > @fcha_vldcn THEN 'INACTIVO'
										ELSE	'AFILIADO'
								END,
								c.cnsctvo_cdgo_pln,			b.cnsctvo_cdgo_prntsco,			b.cnsctvo_cdgo_tpo_afldo,		b.nmro_unco_idntfccn_afldo,
								ltrim(rtrim(b.prmr_nmbre)),	ltrim(rtrim(b.sgndo_nmbre)),	ltrim(rtrim(b.prmr_aplldo)),	ltrim(rtrim(b.sgndo_aplldo))
					From		bdAfiliacionValidador.dbo.tbBeneficiariosValidador	b	With(NoLock)
					inner join	bdAfiliacionValidador.dbo.tbContratosValidador		c	With(NoLock)	on	c.nmro_cntrto				= b.nmro_cntrto
																										And	c.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
					Inner Join	#tmpDatosEntrada									d	With(NoLock)	On	d.prmr_aplldo				= b.prmr_aplldo
																										And	d.prmr_nmbre				= b.prmr_nmbre 
																										And	d.sgndo_nmbre				= b.sgndo_nmbre
				end

			If @opcn = 3
				begin
					--print 'entro 3'
					Insert Into @tmpGrupoFamiliar
							(	Orgn,						Bd,								cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,
								nmro_cntrto,				inco_vgnca_bnfcro,				fn_vgnca_bnfcro,				fcha_ncmnto,
								estdo,
								cnsctvo_cdgo_pln,			cnsctvo_cdgo_prntsco,			cnsctvo_cdgo_tpo_afldo,			nmro_unco_idntfccn_bnfcro,
								prmr_nmbre,					sgndo_nmbre,					prmr_aplldo,					sgndo_aplldo
						)
					Select		'CONTRATOS',				1,								b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,
								b.nmro_cntrto,				b.inco_vgnca_bnfcro,			b.fn_vgnca_bnfcro,				b.fcha_ncmnto,
								CASE	WHEN b.fn_vgnca_bnfcro < @fcha_vldcn THEN 'INACTIVO'
										WHEN b.inco_vgnca_bnfcro > @fcha_vldcn THEN 'INACTIVO'
										ELSE	'AFILIADO'
								END,
								c.cnsctvo_cdgo_pln,			b.cnsctvo_cdgo_prntsco,			b.cnsctvo_cdgo_tpo_afldo,		b.nmro_unco_idntfccn_afldo,
								ltrim(rtrim(b.prmr_nmbre)),	ltrim(rtrim(b.sgndo_nmbre)),	ltrim(rtrim(b.prmr_aplldo)),	ltrim(rtrim(b.sgndo_aplldo))
					From		bdAfiliacionValidador.dbo.tbBeneficiariosValidador	b	With(NoLock)
					inner join	bdAfiliacionValidador.dbo.tbContratosValidador		c	With(NoLock)	on	c.nmro_cntrto				= b.nmro_cntrto
																										And	c.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
					Inner Join	#tmpDatosEntrada									d	With(NoLock)	On	d.prmr_nmbre				= b.prmr_nmbre 
																										And	d.sgndo_nmbre				= b.sgndo_nmbre
				End

			If @opcn = 4
				Begin
					--print 'entro 4'
					Insert Into @tmpGrupoFamiliar
							(	Orgn,						Bd,								cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,
								nmro_cntrto,				inco_vgnca_bnfcro,				fn_vgnca_bnfcro,				fcha_ncmnto,
								estdo,
								cnsctvo_cdgo_pln,			cnsctvo_cdgo_prntsco,			cnsctvo_cdgo_tpo_afldo,			nmro_unco_idntfccn_bnfcro,
								prmr_nmbre,					sgndo_nmbre,					prmr_aplldo,					sgndo_aplldo
						)
					Select		'CONTRATOS',				1,								b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,
								b.nmro_cntrto,				b.inco_vgnca_bnfcro,			b.fn_vgnca_bnfcro,				b.fcha_ncmnto,
								CASE	WHEN b.fn_vgnca_bnfcro < @fcha_vldcn THEN 'INACTIVO'
										WHEN b.inco_vgnca_bnfcro > @fcha_vldcn THEN 'INACTIVO'
										ELSE	'AFILIADO'
								END,
								c.cnsctvo_cdgo_pln,			b.cnsctvo_cdgo_prntsco,			b.cnsctvo_cdgo_tpo_afldo,		b.nmro_unco_idntfccn_afldo,
								ltrim(rtrim(b.prmr_nmbre)),	ltrim(rtrim(b.sgndo_nmbre)),	ltrim(rtrim(b.prmr_aplldo)),	ltrim(rtrim(b.sgndo_aplldo))
					From		bdAfiliacionValidador.dbo.tbBeneficiariosValidador	b	With(NoLock)
					inner join	bdAfiliacionValidador.dbo.tbContratosValidador		c	With(NoLock)	on	c.nmro_cntrto				= b.nmro_cntrto
																										And	c.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
					Inner Join	#tmpDatosEntrada									d	With(NoLock)	On	d.prmr_nmbre				= b.prmr_nmbre 
				end

			If @opcn = 5
				begin
					--print 'entro 5'
					Insert Into @tmpGrupoFamiliar
							(	Orgn,						Bd,								cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,
								nmro_cntrto,				inco_vgnca_bnfcro,				fn_vgnca_bnfcro,				fcha_ncmnto,
								estdo,
								cnsctvo_cdgo_pln,			cnsctvo_cdgo_prntsco,			cnsctvo_cdgo_tpo_afldo,			nmro_unco_idntfccn_bnfcro,
								prmr_nmbre,					sgndo_nmbre,					prmr_aplldo,					sgndo_aplldo
						)
					Select		'CONTRATOS',				1,								b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,
								b.nmro_cntrto,				b.inco_vgnca_bnfcro,			b.fn_vgnca_bnfcro,				b.fcha_ncmnto,
								CASE	WHEN b.fn_vgnca_bnfcro < @fcha_vldcn THEN 'INACTIVO'
										WHEN b.inco_vgnca_bnfcro > @fcha_vldcn THEN 'INACTIVO'
										ELSE	'AFILIADO'
								END,
								c.cnsctvo_cdgo_pln,			b.cnsctvo_cdgo_prntsco,			b.cnsctvo_cdgo_tpo_afldo,		b.nmro_unco_idntfccn_afldo,
								ltrim(rtrim(b.prmr_nmbre)),	ltrim(rtrim(b.sgndo_nmbre)),	ltrim(rtrim(b.prmr_aplldo)),	ltrim(rtrim(b.sgndo_aplldo))
					From		bdAfiliacionValidador.dbo.tbBeneficiariosValidador	b	With(NoLock)
					inner join	bdAfiliacionValidador.dbo.tbContratosValidador		c	With(NoLock)	on	c.nmro_cntrto				= b.nmro_cntrto
																										And	c.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
					Inner Join	#tmpDatosEntrada									d	With(NoLock)	On	d.prmr_aplldo				= b.prmr_aplldo
																										And	d.sgndo_aplldo				= b.sgndo_aplldo
																										And	d.sgndo_nmbre				= b.sgndo_nmbre
				end

			If @opcn = 6
				begin
					--print 'entro 6'
					Insert Into @tmpGrupoFamiliar
							(	Orgn,						Bd,								cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,
								nmro_cntrto,				inco_vgnca_bnfcro,				fn_vgnca_bnfcro,				fcha_ncmnto,
								estdo,
								cnsctvo_cdgo_pln,			cnsctvo_cdgo_prntsco,			cnsctvo_cdgo_tpo_afldo,			nmro_unco_idntfccn_bnfcro,
								prmr_nmbre,					sgndo_nmbre,					prmr_aplldo,					sgndo_aplldo
						)
					Select		'CONTRATOS',				1,								b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,
								b.nmro_cntrto,				b.inco_vgnca_bnfcro,			b.fn_vgnca_bnfcro,				b.fcha_ncmnto,
								CASE	WHEN b.fn_vgnca_bnfcro < @fcha_vldcn THEN 'INACTIVO'
										WHEN b.inco_vgnca_bnfcro > @fcha_vldcn THEN 'INACTIVO'
										ELSE	'AFILIADO'
								END,
								c.cnsctvo_cdgo_pln,			b.cnsctvo_cdgo_prntsco,			b.cnsctvo_cdgo_tpo_afldo,		b.nmro_unco_idntfccn_afldo,
								ltrim(rtrim(b.prmr_nmbre)),	ltrim(rtrim(b.sgndo_nmbre)),	ltrim(rtrim(b.prmr_aplldo)),	ltrim(rtrim(b.sgndo_aplldo))
					From		bdAfiliacionValidador.dbo.tbBeneficiariosValidador	b	With(NoLock)
					inner join	bdAfiliacionValidador.dbo.tbContratosValidador		c	With(NoLock)	on	c.nmro_cntrto				= b.nmro_cntrto
																										And	c.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
					Inner Join	#tmpDatosEntrada									d	With(NoLock)	On	d.sgndo_aplldo				= b.sgndo_aplldo
																										And	d.sgndo_nmbre				= b.sgndo_nmbre
				end

			If @opcn = 7
				begin
					--print 'entro 7'
					Insert Into @tmpGrupoFamiliar
							(	Orgn,						Bd,								cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,
								nmro_cntrto,				inco_vgnca_bnfcro,				fn_vgnca_bnfcro,				fcha_ncmnto,
								estdo,
								cnsctvo_cdgo_pln,			cnsctvo_cdgo_prntsco,			cnsctvo_cdgo_tpo_afldo,			nmro_unco_idntfccn_bnfcro,
								prmr_nmbre,					sgndo_nmbre,					prmr_aplldo,					sgndo_aplldo
						)
					Select		'CONTRATOS',				1,								b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,
								b.nmro_cntrto,				b.inco_vgnca_bnfcro,			b.fn_vgnca_bnfcro,				b.fcha_ncmnto,
								CASE	WHEN b.fn_vgnca_bnfcro < @fcha_vldcn THEN 'INACTIVO'
										WHEN b.inco_vgnca_bnfcro > @fcha_vldcn THEN 'INACTIVO'
										ELSE	'AFILIADO'
								END,
								c.cnsctvo_cdgo_pln,			b.cnsctvo_cdgo_prntsco,			b.cnsctvo_cdgo_tpo_afldo,		b.nmro_unco_idntfccn_afldo,
								ltrim(rtrim(b.prmr_nmbre)),	ltrim(rtrim(b.sgndo_nmbre)),	ltrim(rtrim(b.prmr_aplldo)),	ltrim(rtrim(b.sgndo_aplldo))
					From		bdAfiliacionValidador.dbo.tbBeneficiariosValidador	b	With(NoLock)
					inner join	bdAfiliacionValidador.dbo.tbContratosValidador		c	With(NoLock)	on	c.nmro_cntrto				= b.nmro_cntrto
																										And	c.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
					Inner Join	#tmpDatosEntrada									d	With(NoLock)	On	d.sgndo_nmbre				= b.sgndo_nmbre
				end

			if @opcn = 8
				begin
					--print 'entro 8'
					Insert Into @tmpGrupoFamiliar
							(	Orgn,						Bd,								cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,
								nmro_cntrto,				inco_vgnca_bnfcro,				fn_vgnca_bnfcro,				fcha_ncmnto,
								estdo,
								cnsctvo_cdgo_pln,			cnsctvo_cdgo_prntsco,			cnsctvo_cdgo_tpo_afldo,			nmro_unco_idntfccn_bnfcro,
								prmr_nmbre,					sgndo_nmbre,					prmr_aplldo,					sgndo_aplldo
						)
					Select		'CONTRATOS',				1,								b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,
								b.nmro_cntrto,				b.inco_vgnca_bnfcro,			b.fn_vgnca_bnfcro,				b.fcha_ncmnto,
								CASE	WHEN b.fn_vgnca_bnfcro < @fcha_vldcn THEN 'INACTIVO'
										WHEN b.inco_vgnca_bnfcro > @fcha_vldcn THEN 'INACTIVO'
										ELSE	'AFILIADO'
								END,
								c.cnsctvo_cdgo_pln,			b.cnsctvo_cdgo_prntsco,			b.cnsctvo_cdgo_tpo_afldo,		b.nmro_unco_idntfccn_afldo,
								ltrim(rtrim(b.prmr_nmbre)),	ltrim(rtrim(b.sgndo_nmbre)),	ltrim(rtrim(b.prmr_aplldo)),	ltrim(rtrim(b.sgndo_aplldo))
					From		bdAfiliacionValidador.dbo.tbBeneficiariosValidador	b	With(NoLock)
					inner join	bdAfiliacionValidador.dbo.tbContratosValidador		c	With(NoLock)	on	c.nmro_cntrto				= b.nmro_cntrto
																										And	c.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
					Inner Join	#tmpDatosEntrada									d	With(NoLock)	On	d.prmr_aplldo				= b.prmr_aplldo
																										And	d.sgndo_aplldo				= b.sgndo_aplldo
				end

			if @opcn = 9
				begin
					--print 'entro 9'
					Insert Into @tmpGrupoFamiliar
							(	Orgn,						Bd,								cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,
								nmro_cntrto,				inco_vgnca_bnfcro,				fn_vgnca_bnfcro,				fcha_ncmnto,
								estdo,
								cnsctvo_cdgo_pln,			cnsctvo_cdgo_prntsco,			cnsctvo_cdgo_tpo_afldo,			nmro_unco_idntfccn_bnfcro,
								prmr_nmbre,					sgndo_nmbre,					prmr_aplldo,					sgndo_aplldo
						)
					Select		'CONTRATOS',				1,								b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,
								b.nmro_cntrto,				b.inco_vgnca_bnfcro,			b.fn_vgnca_bnfcro,				b.fcha_ncmnto,
								CASE	WHEN b.fn_vgnca_bnfcro < @fcha_vldcn THEN 'INACTIVO'
										WHEN b.inco_vgnca_bnfcro > @fcha_vldcn THEN 'INACTIVO'
										ELSE	'AFILIADO'
								END,
								c.cnsctvo_cdgo_pln,			b.cnsctvo_cdgo_prntsco,			b.cnsctvo_cdgo_tpo_afldo,		b.nmro_unco_idntfccn_afldo,
								ltrim(rtrim(b.prmr_nmbre)),	ltrim(rtrim(b.sgndo_nmbre)),	ltrim(rtrim(b.prmr_aplldo)),	ltrim(rtrim(b.sgndo_aplldo))
					From		bdAfiliacionValidador.dbo.tbBeneficiariosValidador	b	With(NoLock)
					inner join	bdAfiliacionValidador.dbo.tbContratosValidador		c	With(NoLock)	on	c.nmro_cntrto				= b.nmro_cntrto
																										And	c.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
					Inner Join	#tmpDatosEntrada									d	With(NoLock)	On	d.prmr_aplldo				= b.prmr_aplldo
				end

			if @opcn = 10
				begin
					--print 'entro 10'
					Insert Into @tmpGrupoFamiliar
							(	Orgn,						Bd,								cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,
								nmro_cntrto,				inco_vgnca_bnfcro,				fn_vgnca_bnfcro,				fcha_ncmnto,
								estdo,
								cnsctvo_cdgo_pln,			cnsctvo_cdgo_prntsco,			cnsctvo_cdgo_tpo_afldo,			nmro_unco_idntfccn_bnfcro,
								prmr_nmbre,					sgndo_nmbre,					prmr_aplldo,					sgndo_aplldo
						)
					Select		'CONTRATOS',				1,								b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,
								b.nmro_cntrto,				b.inco_vgnca_bnfcro,			b.fn_vgnca_bnfcro,				b.fcha_ncmnto,
								CASE	WHEN b.fn_vgnca_bnfcro < @fcha_vldcn THEN 'INACTIVO'
										WHEN b.inco_vgnca_bnfcro > @fcha_vldcn THEN 'INACTIVO'
										ELSE	'AFILIADO'
								END,
								c.cnsctvo_cdgo_pln,			b.cnsctvo_cdgo_prntsco,			b.cnsctvo_cdgo_tpo_afldo,		b.nmro_unco_idntfccn_afldo,
								ltrim(rtrim(b.prmr_nmbre)),	ltrim(rtrim(b.sgndo_nmbre)),	ltrim(rtrim(b.prmr_aplldo)),	ltrim(rtrim(b.sgndo_aplldo))
					From		bdAfiliacionValidador.dbo.tbBeneficiariosValidador	b	With(NoLock)
					inner join	bdAfiliacionValidador.dbo.tbContratosValidador		c	With(NoLock)	on	c.nmro_cntrto				= b.nmro_cntrto
																										And	c.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
					Inner Join	#tmpDatosEntrada									d	With(NoLock)	On	d.sgndo_aplldo				= b.sgndo_aplldo
				end

			if @opcn = 11
				begin
					--print 'entro 11'
					Insert Into @tmpGrupoFamiliar
							(	Orgn,						Bd,								cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,
								nmro_cntrto,				inco_vgnca_bnfcro,				fn_vgnca_bnfcro,				fcha_ncmnto,
								estdo,
								cnsctvo_cdgo_pln,			cnsctvo_cdgo_prntsco,			cnsctvo_cdgo_tpo_afldo,			nmro_unco_idntfccn_bnfcro,
								prmr_nmbre,					sgndo_nmbre,					prmr_aplldo,					sgndo_aplldo
						)
					Select		'CONTRATOS',				1,								b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,
								b.nmro_cntrto,				b.inco_vgnca_bnfcro,			b.fn_vgnca_bnfcro,				b.fcha_ncmnto,
								CASE	WHEN b.fn_vgnca_bnfcro < @fcha_vldcn THEN 'INACTIVO'
										WHEN b.inco_vgnca_bnfcro > @fcha_vldcn THEN 'INACTIVO'
										ELSE	'AFILIADO'
								END,
								c.cnsctvo_cdgo_pln,			b.cnsctvo_cdgo_prntsco,			b.cnsctvo_cdgo_tpo_afldo,		b.nmro_unco_idntfccn_afldo,
								ltrim(rtrim(b.prmr_nmbre)),	ltrim(rtrim(b.sgndo_nmbre)),	ltrim(rtrim(b.prmr_aplldo)),	ltrim(rtrim(b.sgndo_aplldo))
					From		bdAfiliacionValidador.dbo.tbBeneficiariosValidador	b	With(NoLock)
					inner join	bdAfiliacionValidador.dbo.tbContratosValidador		c	With(NoLock)	on	c.nmro_cntrto				= b.nmro_cntrto
																										And	c.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
					Inner Join	#tmpDatosEntrada									d	With(NoLock)	On	d.prmr_aplldo				= b.prmr_aplldo
																										And	d.prmr_nmbre				= b.prmr_nmbre

				end

			if @opcn = 12
				begin
					--print 'entro 11'
					Insert Into @tmpGrupoFamiliar
							(	Orgn,						Bd,								cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,
								nmro_cntrto,				inco_vgnca_bnfcro,				fn_vgnca_bnfcro,				fcha_ncmnto,
								estdo,
								cnsctvo_cdgo_pln,			cnsctvo_cdgo_prntsco,			cnsctvo_cdgo_tpo_afldo,			nmro_unco_idntfccn_bnfcro,
								prmr_nmbre,					sgndo_nmbre,					prmr_aplldo,					sgndo_aplldo
						)
					Select		'CONTRATOS',				1,								b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,
								b.nmro_cntrto,				b.inco_vgnca_bnfcro,			b.fn_vgnca_bnfcro,				b.fcha_ncmnto,
								CASE	WHEN b.fn_vgnca_bnfcro < @fcha_vldcn THEN 'INACTIVO'
										WHEN b.inco_vgnca_bnfcro > @fcha_vldcn THEN 'INACTIVO'
										ELSE	'AFILIADO'
								END,
								c.cnsctvo_cdgo_pln,			b.cnsctvo_cdgo_prntsco,			b.cnsctvo_cdgo_tpo_afldo,		b.nmro_unco_idntfccn_afldo,
								ltrim(rtrim(b.prmr_nmbre)),	ltrim(rtrim(b.sgndo_nmbre)),	ltrim(rtrim(b.prmr_aplldo)),	ltrim(rtrim(b.sgndo_aplldo))
					From		bdAfiliacionValidador.dbo.tbBeneficiariosValidador	b	With(NoLock)
					inner join	bdAfiliacionValidador.dbo.tbContratosValidador		c	With(NoLock)	on	c.nmro_cntrto				= b.nmro_cntrto
																										And	c.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
					Inner Join	#tmpDatosEntrada									d	With(NoLock)	On	d.prmr_aplldo				= b.prmr_aplldo
																										And	d.sgndo_aplldo				= b.sgndo_aplldo
																										And	d.prmr_nmbre				= b.prmr_nmbre

				end

			If Exists	(	Select	1
							From	@tmpGrupoFamiliar
						)
				Begin
					print 'entra borrar'
					insert into	#borrar
							(	cnsctvo_cdgo_pln,			 nmro_unco_idntfccn_bnfcro,			 fn_vgnca_bnfcro
							)
					Select		cnsctvo_cdgo_pln,			nmro_unco_idntfccn_bnfcro,			Max(fn_vgnca_bnfcro) as fn_vgnca_bnfcro
					From		@tmpGrupoFamiliar
					Group by	cnsctvo_cdgo_pln,	nmro_unco_idntfccn_bnfcro

					Delete		@tmpGrupoFamiliar
					From		@tmpGrupoFamiliar	f
					left Join	#borrar				g	With(NoLock)	on f.cnsctvo_cdgo_pln			= g.cnsctvo_cdgo_pln
																		And	f.nmro_unco_idntfccn_bnfcro	= g.nmro_unco_idntfccn_bnfcro
																		And	f.fn_vgnca_bnfcro			= g.fn_vgnca_bnfcro
					where		g.cnsctvo_cdgo_pln is null
				End
			Else
				Begin
					If @opcn = 1
						--print 'entra 1'
						Begin
							Insert Into @tmpGrupoFamiliar
									(	Orgn,								Bd,									cnsctvo_cdgo_tpo_idntfccn,			nmro_idntfccn,
										inco_vgnca_bnfcro,					fn_vgnca_bnfcro,					fcha_ncmnto,						estdo,
										cnsctvo_cdgo_pln,					cnsctvo_cdgo_prntsco,				cnsctvo_cdgo_tpo_afldo,				nmro_unco_idntfccn_bnfcro,
										prmr_nmbre,							sgndo_nmbre,						prmr_aplldo,						sgndo_aplldo
							)	
							Select		'FAMISANAR',						3,									b.cnsctvo_cdgo_tpo_idntfccn_bnfcro,	b.nmro_idntfccn_bnfcro,
										b.inco_vgnca,						b.fn_vgnca,							b.fcha_ncmnto,						'INACTIVO',
										b.cnsctvo_cdgo_pln,					b.prntsco,							b.cnsctvo_cdgo_tpo_afldo,			null,
										ltrim(rtrim(b.prmr_nmbre_bnfcro)),	ltrim(rtrim(b.sgndo_nmbre_bnfcro)),	ltrim(rtrim(b.prmr_aplldo_bnfcro)),	ltrim(rtrim(b.sgndo_aplldo_bnfcro))
							From		bdAfiliacionValidador.dbo.tbEapb					b	With(NoLock)
							Inner Join	bdAfiliacionValidador.dbo.tbDetalleeapb_Vigencias	d	With(NoLock)	On	d.cdgo_eapb		= b.cdgo_eapb
							Inner Join	#tmpDatosEntrada									c	With(NoLock)	On	c.prmr_aplldo	= b.prmr_aplldo_bnfcro
																												And	c.sgndo_aplldo	= b.sgndo_aplldo_bnfcro
																												And	c.prmr_nmbre	= b.prmr_nmbre_bnfcro 
																												And	c.sgndo_nmbre	= b.sgndo_nmbre_bnfcro
							Where		fcha_hsta			= '9999/12/31'
							And			@fcha_vldcn Between d.inco_vgnca And d.fn_vgnca
							And			d.vsble_vlddr		= 'S'
						End

					If @opcn = 2
						Begin
							--print 'entra 2'
							Insert Into @tmpGrupoFamiliar
									(	Orgn,								Bd,									cnsctvo_cdgo_tpo_idntfccn,			nmro_idntfccn,
										inco_vgnca_bnfcro,					fn_vgnca_bnfcro,					fcha_ncmnto,						estdo,
										cnsctvo_cdgo_pln,					cnsctvo_cdgo_prntsco,				cnsctvo_cdgo_tpo_afldo,				nmro_unco_idntfccn_bnfcro,
										prmr_nmbre,							sgndo_nmbre,						prmr_aplldo,						sgndo_aplldo
							)	
							Select		'FAMISANAR',						3,									b.cnsctvo_cdgo_tpo_idntfccn_bnfcro,	b.nmro_idntfccn_bnfcro,
										b.inco_vgnca,						b.fn_vgnca,							b.fcha_ncmnto,						'INACTIVO',
										b.cnsctvo_cdgo_pln,					b.prntsco,							b.cnsctvo_cdgo_tpo_afldo,			null,
										ltrim(rtrim(b.prmr_nmbre_bnfcro)),	ltrim(rtrim(b.sgndo_nmbre_bnfcro)),	ltrim(rtrim(b.prmr_aplldo_bnfcro)),	ltrim(rtrim(b.sgndo_aplldo_bnfcro))
							From		bdAfiliacionValidador.dbo.tbEapb					b	With(NoLock)
							Inner Join	bdAfiliacionValidador.dbo.tbDetalleeapb_Vigencias	d	With(NoLock)	On	d.cdgo_eapb		= b.cdgo_eapb
							Inner Join	#tmpDatosEntrada									c	With(NoLock)	On	c.prmr_aplldo	= b.prmr_aplldo_bnfcro
																												And	c.prmr_nmbre	= b.prmr_nmbre_bnfcro 
																												And	c.sgndo_nmbre	= b.sgndo_nmbre_bnfcro
							Where		fcha_hsta			= '9999/12/31'
							And			@fcha_vldcn Between d.inco_vgnca And d.fn_vgnca
							And			d.vsble_vlddr		= 'S'
						End

					If @opcn = 3
						Begin
							--print 'entra 3'
							Insert Into @tmpGrupoFamiliar
									(	Orgn,								Bd,									cnsctvo_cdgo_tpo_idntfccn,			nmro_idntfccn,
										inco_vgnca_bnfcro,					fn_vgnca_bnfcro,					fcha_ncmnto,						estdo,
										cnsctvo_cdgo_pln,					cnsctvo_cdgo_prntsco,				cnsctvo_cdgo_tpo_afldo,				nmro_unco_idntfccn_bnfcro,
										prmr_nmbre,							sgndo_nmbre,						prmr_aplldo,						sgndo_aplldo
							)	
							Select		'FAMISANAR',						3,									b.cnsctvo_cdgo_tpo_idntfccn_bnfcro,	b.nmro_idntfccn_bnfcro,
										b.inco_vgnca,						b.fn_vgnca,							b.fcha_ncmnto,						'INACTIVO',
										b.cnsctvo_cdgo_pln,					b.prntsco,							b.cnsctvo_cdgo_tpo_afldo,			null,
										ltrim(rtrim(b.prmr_nmbre_bnfcro)),	ltrim(rtrim(b.sgndo_nmbre_bnfcro)),	ltrim(rtrim(b.prmr_aplldo_bnfcro)),	ltrim(rtrim(b.sgndo_aplldo_bnfcro))
							From		bdAfiliacionValidador.dbo.tbEapb					b	With(NoLock)
							Inner Join	bdAfiliacionValidador.dbo.tbDetalleeapb_Vigencias	d	With(NoLock)	On	d.cdgo_eapb		= b.cdgo_eapb
							Inner Join	#tmpDatosEntrada									c	With(NoLock)	On	c.prmr_nmbre	= b.prmr_nmbre_bnfcro 
																												And	c.sgndo_nmbre	= b.sgndo_nmbre_bnfcro
							Where		fcha_hsta			= '9999/12/31'
							And			@fcha_vldcn Between d.inco_vgnca And d.fn_vgnca
							And			d.vsble_vlddr		= 'S'
						End

					If @opcn = 4
						Begin
							--print 'entra 4'
							Insert Into @tmpGrupoFamiliar
									(	Orgn,								Bd,									cnsctvo_cdgo_tpo_idntfccn,			nmro_idntfccn,
										inco_vgnca_bnfcro,					fn_vgnca_bnfcro,					fcha_ncmnto,						estdo,
										cnsctvo_cdgo_pln,					cnsctvo_cdgo_prntsco,				cnsctvo_cdgo_tpo_afldo,				nmro_unco_idntfccn_bnfcro,
										prmr_nmbre,							sgndo_nmbre,						prmr_aplldo,						sgndo_aplldo
							)	
							Select		'FAMISANAR',						3,									b.cnsctvo_cdgo_tpo_idntfccn_bnfcro,	b.nmro_idntfccn_bnfcro,
										b.inco_vgnca,						b.fn_vgnca,							b.fcha_ncmnto,						'INACTIVO',
										b.cnsctvo_cdgo_pln,					b.prntsco,							b.cnsctvo_cdgo_tpo_afldo,			null,
										ltrim(rtrim(b.prmr_nmbre_bnfcro)),	ltrim(rtrim(b.sgndo_nmbre_bnfcro)),	ltrim(rtrim(b.prmr_aplldo_bnfcro)),	ltrim(rtrim(b.sgndo_aplldo_bnfcro))
							From		bdAfiliacionValidador.dbo.tbEapb					b	With(NoLock)
							Inner Join	bdAfiliacionValidador.dbo.tbDetalleeapb_Vigencias	d	With(NoLock)	On	d.cdgo_eapb		= b.cdgo_eapb
							Inner Join	#tmpDatosEntrada									c	With(NoLock)	On	c.prmr_nmbre	= b.prmr_nmbre_bnfcro
							Where		fcha_hsta			= '9999/12/31'
							And			@fcha_vldcn Between d.inco_vgnca And d.fn_vgnca
							And			d.vsble_vlddr		= 'S'
						End

					If @opcn = 5
						Begin
							--print 'entra 5'
							Insert Into @tmpGrupoFamiliar
									(	Orgn,								Bd,									cnsctvo_cdgo_tpo_idntfccn,			nmro_idntfccn,
										inco_vgnca_bnfcro,					fn_vgnca_bnfcro,					fcha_ncmnto,						estdo,
										cnsctvo_cdgo_pln,					cnsctvo_cdgo_prntsco,				cnsctvo_cdgo_tpo_afldo,				nmro_unco_idntfccn_bnfcro,
										prmr_nmbre,							sgndo_nmbre,						prmr_aplldo,						sgndo_aplldo
							)	
							Select		'FAMISANAR',						3,									b.cnsctvo_cdgo_tpo_idntfccn_bnfcro,	b.nmro_idntfccn_bnfcro,
										b.inco_vgnca,						b.fn_vgnca,							b.fcha_ncmnto,						'INACTIVO',
										b.cnsctvo_cdgo_pln,					b.prntsco,							b.cnsctvo_cdgo_tpo_afldo,			null,
										ltrim(rtrim(b.prmr_nmbre_bnfcro)),	ltrim(rtrim(b.sgndo_nmbre_bnfcro)),	ltrim(rtrim(b.prmr_aplldo_bnfcro)),	ltrim(rtrim(b.sgndo_aplldo_bnfcro))
							From		bdAfiliacionValidador.dbo.tbEapb					b	With(NoLock)
							Inner Join	bdAfiliacionValidador.dbo.tbDetalleeapb_Vigencias	d	With(NoLock)	On	d.cdgo_eapb		= b.cdgo_eapb
							Inner Join	#tmpDatosEntrada									c	With(NoLock)	On	c.prmr_aplldo	= b.prmr_aplldo_bnfcro
																												And	c.sgndo_aplldo	= b.sgndo_aplldo_bnfcro
																												And	c.sgndo_nmbre	= b.sgndo_nmbre_bnfcro
							Where		fcha_hsta			= '9999/12/31'
							And			@fcha_vldcn Between d.inco_vgnca And d.fn_vgnca
							And			d.vsble_vlddr		= 'S'
						End

					If @opcn = 6
						Begin
							--print 'entra 6'
							Insert Into @tmpGrupoFamiliar
									(	Orgn,								Bd,									cnsctvo_cdgo_tpo_idntfccn,			nmro_idntfccn,
										inco_vgnca_bnfcro,					fn_vgnca_bnfcro,					fcha_ncmnto,						estdo,
										cnsctvo_cdgo_pln,					cnsctvo_cdgo_prntsco,				cnsctvo_cdgo_tpo_afldo,				nmro_unco_idntfccn_bnfcro,
										prmr_nmbre,							sgndo_nmbre,						prmr_aplldo,						sgndo_aplldo
							)	
							Select		'FAMISANAR',						3,									b.cnsctvo_cdgo_tpo_idntfccn_bnfcro,	b.nmro_idntfccn_bnfcro,
										b.inco_vgnca,						b.fn_vgnca,							b.fcha_ncmnto,						'INACTIVO',
										b.cnsctvo_cdgo_pln,					b.prntsco,							b.cnsctvo_cdgo_tpo_afldo,			null,
										ltrim(rtrim(b.prmr_nmbre_bnfcro)),	ltrim(rtrim(b.sgndo_nmbre_bnfcro)),	ltrim(rtrim(b.prmr_aplldo_bnfcro)),	ltrim(rtrim(b.sgndo_aplldo_bnfcro))
							From		bdAfiliacionValidador.dbo.tbEapb					b	With(NoLock)
							Inner Join	bdAfiliacionValidador.dbo.tbDetalleeapb_Vigencias	d	With(NoLock)	On	d.cdgo_eapb		= b.cdgo_eapb
							Inner Join	#tmpDatosEntrada									c	With(NoLock)	On	c.sgndo_aplldo	= b.sgndo_aplldo_bnfcro
																												And	c.sgndo_nmbre	= b.sgndo_nmbre_bnfcro
							Where		fcha_hsta			= '9999/12/31'
							And			@fcha_vldcn Between d.inco_vgnca And d.fn_vgnca
							And			d.vsble_vlddr		= 'S'
						End

					If @opcn = 7
						Begin
							--print 'entra 7'
							Insert Into @tmpGrupoFamiliar
									(	Orgn,								Bd,									cnsctvo_cdgo_tpo_idntfccn,			nmro_idntfccn,
										inco_vgnca_bnfcro,					fn_vgnca_bnfcro,					fcha_ncmnto,						estdo,
										cnsctvo_cdgo_pln,					cnsctvo_cdgo_prntsco,				cnsctvo_cdgo_tpo_afldo,				nmro_unco_idntfccn_bnfcro,
										prmr_nmbre,							sgndo_nmbre,						prmr_aplldo,						sgndo_aplldo
							)	
							Select		'FAMISANAR',						3,									b.cnsctvo_cdgo_tpo_idntfccn_bnfcro,	b.nmro_idntfccn_bnfcro,
										b.inco_vgnca,						b.fn_vgnca,							b.fcha_ncmnto,						'INACTIVO',
										b.cnsctvo_cdgo_pln,					b.prntsco,							b.cnsctvo_cdgo_tpo_afldo,			null,
										ltrim(rtrim(b.prmr_nmbre_bnfcro)),	ltrim(rtrim(b.sgndo_nmbre_bnfcro)),	ltrim(rtrim(b.prmr_aplldo_bnfcro)),	ltrim(rtrim(b.sgndo_aplldo_bnfcro))
							From		bdAfiliacionValidador.dbo.tbEapb					b	With(NoLock)
							Inner Join	bdAfiliacionValidador.dbo.tbDetalleeapb_Vigencias	d	With(NoLock)	On	d.cdgo_eapb		= b.cdgo_eapb
							Inner Join	#tmpDatosEntrada									c	With(NoLock)	On	c.sgndo_nmbre	= b.sgndo_nmbre_bnfcro
							Where		fcha_hsta			= '9999/12/31'
							And			@fcha_vldcn Between d.inco_vgnca And d.fn_vgnca
							And			d.vsble_vlddr		= 'S'
						End

					If @opcn = 8
						Begin
							--print 'entra 8'
							Insert Into @tmpGrupoFamiliar
									(	Orgn,								Bd,									cnsctvo_cdgo_tpo_idntfccn,			nmro_idntfccn,
										inco_vgnca_bnfcro,					fn_vgnca_bnfcro,					fcha_ncmnto,						estdo,
										cnsctvo_cdgo_pln,					cnsctvo_cdgo_prntsco,				cnsctvo_cdgo_tpo_afldo,				nmro_unco_idntfccn_bnfcro,
										prmr_nmbre,							sgndo_nmbre,						prmr_aplldo,						sgndo_aplldo
							)	
							Select		'FAMISANAR',						3,									b.cnsctvo_cdgo_tpo_idntfccn_bnfcro,	b.nmro_idntfccn_bnfcro,
										b.inco_vgnca,						b.fn_vgnca,							b.fcha_ncmnto,						'INACTIVO',
										b.cnsctvo_cdgo_pln,					b.prntsco,							b.cnsctvo_cdgo_tpo_afldo,			null,
										ltrim(rtrim(b.prmr_nmbre_bnfcro)),	ltrim(rtrim(b.sgndo_nmbre_bnfcro)),	ltrim(rtrim(b.prmr_aplldo_bnfcro)),	ltrim(rtrim(b.sgndo_aplldo_bnfcro))
							From		bdAfiliacionValidador.dbo.tbEapb					b	With(NoLock)
							Inner Join	bdAfiliacionValidador.dbo.tbDetalleeapb_Vigencias	d	With(NoLock)	On	d.cdgo_eapb		= b.cdgo_eapb
							Inner Join	#tmpDatosEntrada									c	With(NoLock)	On	c.prmr_aplldo	= b.prmr_aplldo_bnfcro
																												And	c.sgndo_aplldo	= b.sgndo_aplldo_bnfcro
							Where		fcha_hsta			= '9999/12/31'
							And			@fcha_vldcn Between d.inco_vgnca And d.fn_vgnca
							And			d.vsble_vlddr		= 'S'
						End

					If @opcn = 9
						Begin
							--print 'entra 9'
							Insert Into @tmpGrupoFamiliar
									(	Orgn,								Bd,									cnsctvo_cdgo_tpo_idntfccn,			nmro_idntfccn,
										inco_vgnca_bnfcro,					fn_vgnca_bnfcro,					fcha_ncmnto,						estdo,
										cnsctvo_cdgo_pln,					cnsctvo_cdgo_prntsco,				cnsctvo_cdgo_tpo_afldo,				nmro_unco_idntfccn_bnfcro,
										prmr_nmbre,							sgndo_nmbre,						prmr_aplldo,						sgndo_aplldo
							)	
							Select		'FAMISANAR',						3,									b.cnsctvo_cdgo_tpo_idntfccn_bnfcro,	b.nmro_idntfccn_bnfcro,
										b.inco_vgnca,						b.fn_vgnca,							b.fcha_ncmnto,						'INACTIVO',
										b.cnsctvo_cdgo_pln,					b.prntsco,							b.cnsctvo_cdgo_tpo_afldo,			null,
										ltrim(rtrim(b.prmr_nmbre_bnfcro)),	ltrim(rtrim(b.sgndo_nmbre_bnfcro)),	ltrim(rtrim(b.prmr_aplldo_bnfcro)),	ltrim(rtrim(b.sgndo_aplldo_bnfcro))
							From		bdAfiliacionValidador.dbo.tbEapb					b	With(NoLock)
							Inner Join	bdAfiliacionValidador.dbo.tbDetalleeapb_Vigencias	d	With(NoLock)	On	d.cdgo_eapb		= b.cdgo_eapb
							Inner Join	#tmpDatosEntrada									c	With(NoLock)	On	c.prmr_aplldo	= b.prmr_aplldo_bnfcro
							Where		fcha_hsta			= '9999/12/31'
							And			@fcha_vldcn Between d.inco_vgnca And d.fn_vgnca
							And			d.vsble_vlddr		= 'S'
						End

					If @opcn = 10
						Begin
							--print 'entra 10'
							Insert Into @tmpGrupoFamiliar
									(	Orgn,								Bd,									cnsctvo_cdgo_tpo_idntfccn,			nmro_idntfccn,
										inco_vgnca_bnfcro,					fn_vgnca_bnfcro,					fcha_ncmnto,						estdo,
										cnsctvo_cdgo_pln,					cnsctvo_cdgo_prntsco,				cnsctvo_cdgo_tpo_afldo,				nmro_unco_idntfccn_bnfcro,
										prmr_nmbre,							sgndo_nmbre,						prmr_aplldo,						sgndo_aplldo
							)	
							Select		'FAMISANAR',						3,									b.cnsctvo_cdgo_tpo_idntfccn_bnfcro,	b.nmro_idntfccn_bnfcro,
										b.inco_vgnca,						b.fn_vgnca,							b.fcha_ncmnto,						'INACTIVO',
										b.cnsctvo_cdgo_pln,					b.prntsco,							b.cnsctvo_cdgo_tpo_afldo,			null,
										ltrim(rtrim(b.prmr_nmbre_bnfcro)),	ltrim(rtrim(b.sgndo_nmbre_bnfcro)),	ltrim(rtrim(b.prmr_aplldo_bnfcro)),	ltrim(rtrim(b.sgndo_aplldo_bnfcro))
							From		bdAfiliacionValidador.dbo.tbEapb					b	With(NoLock)
							Inner Join	bdAfiliacionValidador.dbo.tbDetalleeapb_Vigencias	d	With(NoLock)	On	d.cdgo_eapb		= b.cdgo_eapb
							Inner Join	#tmpDatosEntrada									c	With(NoLock)	On	c.sgndo_aplldo	= b.sgndo_aplldo_bnfcro
							Where		fcha_hsta			= '9999/12/31'
							And			@fcha_vldcn Between d.inco_vgnca And d.fn_vgnca
							And			d.vsble_vlddr		= 'S'
						End

					If @opcn = 11
						Begin
							--print 'entra 11'
							Insert Into @tmpGrupoFamiliar
									(	Orgn,								Bd,									cnsctvo_cdgo_tpo_idntfccn,			nmro_idntfccn,
										inco_vgnca_bnfcro,					fn_vgnca_bnfcro,					fcha_ncmnto,						estdo,
										cnsctvo_cdgo_pln,					cnsctvo_cdgo_prntsco,				cnsctvo_cdgo_tpo_afldo,				nmro_unco_idntfccn_bnfcro,
										prmr_nmbre,							sgndo_nmbre,						prmr_aplldo,						sgndo_aplldo
							)	
							Select		'FAMISANAR',						3,									b.cnsctvo_cdgo_tpo_idntfccn_bnfcro,	b.nmro_idntfccn_bnfcro,
										b.inco_vgnca,						b.fn_vgnca,							b.fcha_ncmnto,						'INACTIVO',
										b.cnsctvo_cdgo_pln,					b.prntsco,							b.cnsctvo_cdgo_tpo_afldo,			null,
										ltrim(rtrim(b.prmr_nmbre_bnfcro)),	ltrim(rtrim(b.sgndo_nmbre_bnfcro)),	ltrim(rtrim(b.prmr_aplldo_bnfcro)),	ltrim(rtrim(b.sgndo_aplldo_bnfcro))
							From		bdAfiliacionValidador.dbo.tbEapb					b	With(NoLock)
							Inner Join	bdAfiliacionValidador.dbo.tbDetalleeapb_Vigencias	d	With(NoLock)	On	d.cdgo_eapb		= b.cdgo_eapb
							Inner Join	#tmpDatosEntrada									c	With(NoLock)	On	c.prmr_aplldo	= b.prmr_aplldo_bnfcro
																												And	c.prmr_nmbre	= b.prmr_nmbre_bnfcro
							Where		fcha_hsta			= '9999/12/31'
							And			@fcha_vldcn Between d.inco_vgnca And d.fn_vgnca
							And			d.vsble_vlddr		= 'S'
						End

					If @opcn = 12
						Begin
							--print 'entra 11'
							Insert Into @tmpGrupoFamiliar
									(	Orgn,								Bd,									cnsctvo_cdgo_tpo_idntfccn,			nmro_idntfccn,
										inco_vgnca_bnfcro,					fn_vgnca_bnfcro,					fcha_ncmnto,						estdo,
										cnsctvo_cdgo_pln,					cnsctvo_cdgo_prntsco,				cnsctvo_cdgo_tpo_afldo,				nmro_unco_idntfccn_bnfcro,
										prmr_nmbre,							sgndo_nmbre,						prmr_aplldo,						sgndo_aplldo
							)	
							Select		'FAMISANAR',						3,									b.cnsctvo_cdgo_tpo_idntfccn_bnfcro,	b.nmro_idntfccn_bnfcro,
										b.inco_vgnca,						b.fn_vgnca,							b.fcha_ncmnto,						'INACTIVO',
										b.cnsctvo_cdgo_pln,					b.prntsco,							b.cnsctvo_cdgo_tpo_afldo,			null,
										ltrim(rtrim(b.prmr_nmbre_bnfcro)),	ltrim(rtrim(b.sgndo_nmbre_bnfcro)),	ltrim(rtrim(b.prmr_aplldo_bnfcro)),	ltrim(rtrim(b.sgndo_aplldo_bnfcro))
							From		bdAfiliacionValidador.dbo.tbEapb					b	With(NoLock)
							Inner Join	bdAfiliacionValidador.dbo.tbDetalleeapb_Vigencias	d	With(NoLock)	On	d.cdgo_eapb		= b.cdgo_eapb
							Inner Join	#tmpDatosEntrada									c	With(NoLock)	On	c.prmr_aplldo	= b.prmr_aplldo_bnfcro
																												And	c.sgndo_aplldo	= b.sgndo_aplldo_bnfcro
																												And	c.prmr_nmbre	= b.prmr_nmbre_bnfcro
							Where		fcha_hsta			= '9999/12/31'
							And			@fcha_vldcn Between d.inco_vgnca And d.fn_vgnca
							And			d.vsble_vlddr		= 'S'
						End
				End

			Update		@tmpGrupoFamiliar
			Set			cdgo_tpo_idntfccn = i.cdgo_tpo_idntfccn
			From		@tmpGrupoFamiliar								t
			inner join	bdAfiliacionValidador.dbo.tbTiposIdentificacion	i	With(NoLock)	On t.cnsctvo_cdgo_tpo_idntfccn	= i.cnsctvo_cdgo_tpo_idntfccn

			Update		@tmpGrupoFamiliar
			Set			dscrpcn_prntsco = p.dscrpcn_prntsco
			From		@tmpGrupoFamiliar							t
			INNER JOIN	bdAfiliacionValidador.dbo.tbParentescos		p	With(NoLock)	On t.cnsctvo_cdgo_prntsco = p.cnsctvo_cdgo_prntscs

			Update		@tmpGrupoFamiliar
			Set			tpo_afldo = a.dscrpcn
			From		@tmpGrupoFamiliar							t
			INNER JOIN	bdAfiliacionValidador.dbo.tbTiposAfiliado	a	With(NoLock)	On t.cnsctvo_cdgo_tpo_afldo	= a.cnsctvo_cdgo_tpo_afldo

			Update		@tmpGrupoFamiliar
			Set			dscrpcn_pln	= p.dscrpcn_pln
			From		@tmpGrupoFamiliar					t
			INNER JOIN	bdAfiliacionValidador.dbo.tbPlanes	p	With(NoLock)	On	t.cnsctvo_cdgo_pln	= p.cnsctvo_cdgo_pln

			Update		@tmpGrupoFamiliar
			Set			dscrpcn_pln	= 'FORMULARIO'
			Where		Bd	= 2

			Update		@tmpGrupoFamiliar
			Set			dscrpcn_pln	= 'FAMISANAR'
			Where		Bd	= 3

			Update		@tmpGrupoFamiliar
			Set			Nmbre_Afldo	=	IsNull(Ltrim(Rtrim(prmr_aplldo)),'')+' '+IsNull(Ltrim(Rtrim(sgndo_aplldo)),'')+' '+IsNull(Ltrim(Rtrim(prmr_nmbre)),'')+' '+IsNull(Ltrim(Rtrim(sgndo_nmbre)),'')


			Select		dscrpcn_pln,				cdgo_tpo_idntfccn,			nmro_idntfccn,				Nmbre_Afldo,
						tpo_afldo,					fcha_ncmnto,				dscrpcn_prntsco,			nmro_cntrto,
						inco_vgnca_bnfcro,			fn_vgnca_bnfcro,			estdo,						cnsctvo_cdgo_pln,
						nmro_unco_idntfccn_bnfcro,	cnsctvo_cdgo_tpo_idntfccn,	cnsctvo_cdgo_prntsco,		cnsctvo_cdgo_tpo_afldo,
						Orgn,						Bd
			from		@tmpGrupoFamiliar
			Order by	prmr_nmbre,sgndo_nmbre,prmr_aplldo,sgndo_aplldo
		end --@cnsctvo_cdgo_pln = 0
	End

	Drop table	#tmpDatosEntrada
	Drop Table	#borrar
End


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmBuscaPersonasxNombre] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmBuscaPersonasxNombre] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmBuscaPersonasxNombre] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmBuscaPersonasxNombre] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmBuscaPersonasxNombre] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmBuscaPersonasxNombre] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmBuscaPersonasxNombre] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmBuscaPersonasxNombre] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmBuscaPersonasxNombre] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmBuscaPersonasxNombre] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmBuscaPersonasxNombre] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmBuscaPersonasxNombre] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmBuscaPersonasxNombre] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmBuscaPersonasxNombre] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmBuscaPersonasxNombre] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmBuscaPersonasxNombre] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmBuscaPersonasxNombre] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmBuscaPersonasxNombre] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmBuscaPersonasxNombre] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmBuscaPersonasxNombre] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmBuscaPersonasxNombre] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmBuscaPersonasxNombre] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmBuscaPersonasxNombre] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmBuscaPersonasxNombre] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmBuscaPersonasxNombre] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmBuscaPersonasxNombre] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

