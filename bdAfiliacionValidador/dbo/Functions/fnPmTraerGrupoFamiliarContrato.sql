CREATE Function [dbo].[fnPmTraerGrupoFamiliarContrato]
(	@lnConsecutivoCodigoTipoIdentificacion	udtConsecutivo,
	@lnNumeroIdentificacion					udtNumeroIdentificacion,
	@ffechaValidacion						datetime
)
Returns @GrupoFamiliarContrato Table
	(	cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					char(15),
		cnsctvo_bnfcro				int,
		cnsctvo_cdgo_tpo_idntfccn	int,
		nmro_idntfccn				varchar(15),
		nmro_unco_idntfccn_afldo	int,
		Nmbre_Afldo					varchar(250),
		inco_vgnca_bnfcro			datetime,
		fn_vgnca_bnfcro				datetime,
		cnsctvo_cdgo_tpo_afldo		int,
		cnsctvo_cdgo_prntsco		int,
		estdo						char(12),
		fcha_ncmnto					datetime,
		cnsctvo_cdgo_pln			int
	)

--sp_help tbbeneficiariosValidador
As
Begin
	Declare	@fcha_rfrnca	datetime,
			@nui		int

	Declare	@Contrato Table
		(	nmro_cntrto	varchar(15)
		)

	Declare	 @tmpBeneficiariosValidador Table
		(
			nmro_unco_idntfccn_afldo	Int,
			cnsctvo_cdgo_tpo_idntfccn	Int,
			nmro_idntfccn				VarChar(20),
			cnsctvo_cdgo_tpo_cntrto		Int,
			nmro_cntrto					VarChar(15),
			cnsctvo_bnfcro				Int,
			inco_vgnca_bnfcro			DateTime,
			fn_vgnca_bnfcro				DateTime,
			cnsctvo_cdgo_prntsco		Int,
			cnsctvo_cdgo_tpo_afldo		Int,
			fcha_ncmnto					DateTime,
			prmr_nmbre					VarChar(20),
			sgndo_nmbre					VarChar(20),
			prmr_aplldo					VarChar(50),
			sgndo_aplldo				VarChar(50)
		)

	Declare	@tmpContratosValidador Table
		(
			cnsctvo_cdgo_tpo_cntrto		Int,
			nmro_cntrto					VarChar(15),
			cnsctvo_cdgo_pln			Int,
			nmro_unco_idntfccn_afldo	Int
		)

	Insert Into	@tmpBeneficiariosValidador
	Select		a.nmro_unco_idntfccn_afldo,		a.cnsctvo_cdgo_tpo_idntfccn,		a.nmro_idntfccn,	a.cnsctvo_cdgo_tpo_cntrto,		a.nmro_cntrto,
				a.cnsctvo_bnfcro,				a.inco_vgnca_bnfcro,				a.fn_vgnca_bnfcro,	a.cnsctvo_cdgo_prntsco,			a.cnsctvo_cdgo_tpo_afldo,
				a.fcha_ncmnto,					a.prmr_nmbre,						a.sgndo_nmbre,		a.prmr_aplldo,					a.sgndo_aplldo
	From		bdAfiliacionValidador.dbo.tbBeneficiariosValidador	a	With(NoLock)
	Inner Join	(	Select		nmro_unco_idntfccn_afldo,		cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,		cnsctvo_cdgo_tpo_cntrto,		nmro_cntrto,
								cnsctvo_bnfcro,					inco_vgnca_bnfcro,				fn_vgnca_bnfcro,	cnsctvo_cdgo_prntsco,			cnsctvo_cdgo_tpo_afldo,
								fcha_ncmnto,					prmr_nmbre,						sgndo_nmbre,		prmr_aplldo,					sgndo_aplldo
					From		bdAfiliacionValidador.dbo.tbBeneficiariosValidador	With(NoLock)
					Where		cnsctvo_cdgo_tpo_idntfccn	= @lnConsecutivoCodigoTipoIdentificacion
					And			nmro_idntfccn				= @lnNumeroIdentificacion
				)	b	On	b.cnsctvo_cdgo_tpo_cntrto	=	a.cnsctvo_cdgo_tpo_cntrto
						And	b.nmro_cntrto				=	a.nmro_cntrto

	Insert Into		@tmpContratosValidador
	Select Distinct	b.cnsctvo_cdgo_tpo_cntrto,		b.nmro_cntrto,		c.cnsctvo_cdgo_pln,	c.nmro_unco_idntfccn_afldo
	From			bdAfiliacionValidador.dbo.tbContratosValidador	c	With(NoLock)
	Inner Join		@tmpBeneficiariosValidador						b	On	b.cnsctvo_cdgo_tpo_cntrto	=	c.cnsctvo_cdgo_tpo_cntrto
																		And	b.nmro_cntrto				=	c.nmro_cntrto

	Select		@fcha_rfrnca	= Max(fn_vgnca_bnfcro),
				@nui			= Max(nmro_unco_idntfccn_afldo)
	From		@tmpBeneficiariosValidador
	Where		cnsctvo_cdgo_tpo_cntrto		= 1

	If @fcha_rfrnca Is Not Null
		Begin
			Declare	@nmro_cntrto	udtNumeroFormulario

			Set		@nmro_cntrto = NULL

			Select	@nmro_cntrto	= nmro_cntrto
			From	@tmpBeneficiariosValidador
			Where	fn_vgnca_bnfcro			= @fcha_rfrnca
			And		cnsctvo_cdgo_tpo_cntrto	= 1

			If @nmro_cntrto Is Not Null
				Begin
					Insert Into	@GrupoFamiliarContrato
							(	cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,			nmro_unco_idntfccn_afldo,
								cnsctvo_cdgo_tpo_cntrto,		nmro_cntrto,			cnsctvo_bnfcro,
								inco_vgnca_bnfcro,				fn_vgnca_bnfcro,
								Nmbre_Afldo,
								fcha_ncmnto,					estdo,
								cnsctvo_cdgo_pln,				cnsctvo_cdgo_prntsco,	cnsctvo_cdgo_tpo_afldo
							)
					Select		b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,		b.nmro_unco_idntfccn_afldo,
								b.cnsctvo_cdgo_tpo_cntrto,		b.nmro_cntrto,			b.cnsctvo_bnfcro,
								b.inco_vgnca_bnfcro,			b.fn_vgnca_bnfcro,
								rtrim(ltrim(b.prmr_nmbre)) + ' ' + rtrim(ltrim(b.sgndo_nmbre)) + ' ' + rtrim(ltrim(b.prmr_aplldo)) + ' ' + rtrim(ltrim(b.sgndo_aplldo)),
								b.fcha_ncmnto,					CASE	WHEN b.fn_vgnca_bnfcro < @ffechaValidacion THEN 'INACTIVO'
																		WHEN b.inco_vgnca_bnfcro > @ffechaValidacion THEN 'INACTIVO'
																		ELSE	'AFILIADO'
																END,
								c.cnsctvo_cdgo_pln,				b.cnsctvo_cdgo_prntsco,	b.cnsctvo_cdgo_tpo_afldo
					From		@tmpBeneficiariosValidador	b
					Inner Join	@tmpContratosValidador		c	On	c.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
																And	c.nmro_cntrto				= b.nmro_cntrto
					Where		b.cnsctvo_cdgo_tpo_cntrto	= 1
					And			b.nmro_cntrto				= @nmro_cntrto
	
					Insert Into	@Contrato
							(	nmro_cntrto
							)
					Select		nmro_cntrto_psc
					From		bdAfiliacionValidador.dbo.tbRelacionPosCValidador b	With(NoLock)
					Where		cnsctvo_cdgo_tpo_cntrto	=  1
					And			nmro_cntrto				=  @nmro_cntrto
					And			cntrto_psc				= 'N'
					And			b.inco_vgnca_rlcn_psc	<= @ffechaValidacion
					And			b.fn_vgnca_rlcn_psc		>= @ffechaValidacion

					Insert Into	@GrupoFamiliarContrato
							(	cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,			nmro_unco_idntfccn_afldo,
								cnsctvo_cdgo_tpo_cntrto,		nmro_cntrto,			cnsctvo_bnfcro,
								inco_vgnca_bnfcro,				fn_vgnca_bnfcro,
								Nmbre_Afldo,
								fcha_ncmnto,					estdo,
								cnsctvo_cdgo_pln,				cnsctvo_cdgo_prntsco,	cnsctvo_cdgo_tpo_afldo
					)
					Select		b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,		b.nmro_unco_idntfccn_afldo,
								b.cnsctvo_cdgo_tpo_cntrto,		b.nmro_cntrto,			b.cnsctvo_bnfcro,
								b.inco_vgnca_bnfcro,			b.fn_vgnca_bnfcro,
								rtrim(ltrim(b.prmr_nmbre)) + ' ' + rtrim(ltrim(b.sgndo_nmbre)) + ' ' + rtrim(ltrim(b.prmr_aplldo)) + ' ' + rtrim(ltrim(b.sgndo_aplldo)),
								b.fcha_ncmnto,					CASE	WHEN b.fn_vgnca_bnfcro < @ffechaValidacion THEN 'INACTIVO'
																		WHEN b.inco_vgnca_bnfcro > @ffechaValidacion THEN 'INACTIVO'
																		ELSE	'AFILIADO'
																END,
								c.cnsctvo_cdgo_pln,				b.cnsctvo_cdgo_prntsco,	b.cnsctvo_cdgo_tpo_afldo
					From		@tmpBeneficiariosValidador	b
					Inner Join	@tmpContratosValidador		c	On	c.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
																And	c.nmro_cntrto				= b.nmro_cntrto
					Inner Join	@Contrato					cp	On	cp.nmro_cntrto				= c.nmro_cntrto
					Where		b.cnsctvo_cdgo_tpo_cntrto	= 1
			---------------------------------------------------------------------------------------
			---	Eliminar Alifiados que actualmente tienen un contratos activo
				End
		End

		/*POS SUBSIDIADO INICIO*/
		Set		@fcha_rfrnca = NULL

		Select	@fcha_rfrnca	= Max(fn_vgnca_bnfcro),
				@nui			= Max(nmro_unco_idntfccn_afldo)
		From	@tmpBeneficiariosValidador
		Where	cnsctvo_cdgo_tpo_cntrto		= 3

		If @fcha_rfrnca Is Not Null
			Begin
				Set		@nmro_cntrto = NULL

				Select	@nmro_cntrto	= nmro_cntrto
				From	@tmpBeneficiariosValidador
				Where	fn_vgnca_bnfcro				= @fcha_rfrnca
				And		cnsctvo_cdgo_tpo_cntrto		= 3

				If @nmro_cntrto Is Not Null
					Begin
						Insert Into	@GrupoFamiliarContrato
								(	cnsctvo_cdgo_tpo_idntfccn,			nmro_idntfccn,			nmro_unco_idntfccn_afldo,		cnsctvo_cdgo_tpo_cntrto,
									nmro_cntrto,						cnsctvo_bnfcro,			inco_vgnca_bnfcro,				fn_vgnca_bnfcro,
									Nmbre_Afldo,
									fcha_ncmnto,						estdo,
									cnsctvo_cdgo_pln,					cnsctvo_cdgo_prntsco,	cnsctvo_cdgo_tpo_afldo
						)
						Select		b.cnsctvo_cdgo_tpo_idntfccn,		b.nmro_idntfccn,		b.nmro_unco_idntfccn_afldo,		b.cnsctvo_cdgo_tpo_cntrto,
									b.nmro_cntrto,						b.cnsctvo_bnfcro,		b.inco_vgnca_bnfcro,			b.fn_vgnca_bnfcro,
									rtrim(ltrim(b.prmr_nmbre)) + ' ' + rtrim(ltrim(b.sgndo_nmbre)) + ' ' + rtrim(ltrim(b.prmr_aplldo)) + ' ' + rtrim(ltrim(b.sgndo_aplldo)),
									b.fcha_ncmnto,						CASE	WHEN b.fn_vgnca_bnfcro < @ffechaValidacion THEN 'INACTIVO'
																				WHEN b.inco_vgnca_bnfcro > @ffechaValidacion THEN 'INACTIVO'
																				ELSE	'AFILIADO'
																		END,
									c.cnsctvo_cdgo_pln,					b.cnsctvo_cdgo_prntsco,	b.cnsctvo_cdgo_tpo_afldo
						From		@tmpBeneficiariosValidador	b
						Inner Join	@tmpContratosValidador		c	On	c.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
																	And	c.nmro_cntrto				= b.nmro_cntrto
						Where		b.cnsctvo_cdgo_tpo_cntrto	= 3
						And			b.nmro_cntrto				= @nmro_cntrto
	
						Insert Into	@GrupoFamiliarContrato
								(	cnsctvo_cdgo_tpo_idntfccn,			nmro_idntfccn,			nmro_unco_idntfccn_afldo,		cnsctvo_cdgo_tpo_cntrto,
									nmro_cntrto,						cnsctvo_bnfcro,			inco_vgnca_bnfcro,				fn_vgnca_bnfcro,
									Nmbre_Afldo,
									fcha_ncmnto,						estdo,
									cnsctvo_cdgo_pln,					cnsctvo_cdgo_prntsco,	cnsctvo_cdgo_tpo_afldo
								)
						Select		b.cnsctvo_cdgo_tpo_idntfccn,		b.nmro_idntfccn,		b.nmro_unco_idntfccn_afldo,		b.cnsctvo_cdgo_tpo_cntrto,
									b.nmro_cntrto,						b.cnsctvo_bnfcro,		b.inco_vgnca_bnfcro,			b.fn_vgnca_bnfcro,
									rtrim(ltrim(b.prmr_nmbre)) + ' ' + rtrim(ltrim(b.sgndo_nmbre)) + ' ' + rtrim(ltrim(b.prmr_aplldo)) + ' ' + rtrim(ltrim(b.sgndo_aplldo)),
									b.fcha_ncmnto,						CASE	WHEN b.fn_vgnca_bnfcro < @ffechaValidacion THEN 'INACTIVO'
																				WHEN b.inco_vgnca_bnfcro > @ffechaValidacion THEN 'INACTIVO'
																				ELSE	'AFILIADO'
																		END,
									c.cnsctvo_cdgo_pln,					b.cnsctvo_cdgo_prntsco,	b.cnsctvo_cdgo_tpo_afldo
						From		@tmpBeneficiariosValidador	b
						Inner Join	@tmpContratosValidador		c	On	c.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
																	And	c.nmro_cntrto				= b.nmro_cntrto
						Inner Join	@Contrato					cp	On	cp.nmro_cntrto				= c.nmro_cntrto
						Where		b.cnsctvo_cdgo_tpo_cntrto	= 3
				---------------------------------------------------------------------------------------
				---	Eliminar Alifiados que actualmente tienen un contratos activo
					End
			End

			/*POS SUBSIDIADO FIN*/

	Delete	@Contrato

	Insert Into		@Contrato
			(		nmro_cntrto
			)
	Select Distinct	b.nmro_cntrto
	From			@tmpBeneficiariosValidador	b
	Inner Join		@GrupoFamiliarContrato		g	On	g.cnsctvo_cdgo_tpo_idntfccn	=	b.cnsctvo_cdgo_tpo_idntfccn
													And	g.nmro_idntfccn				=	b.nmro_idntfccn
	Where			b.cnsctvo_cdgo_tpo_cntrto	= 2

	Insert Into		@Contrato
			(		nmro_cntrto
			)
	Select			c.nmro_cntrto
	From			@tmpContratosValidador	c
	Left Join		@Contrato				i	On	i.nmro_cntrto	= c.nmro_cntrto
	Where			c.nmro_unco_idntfccn_afldo	= @nui
	And				c.cnsctvo_cdgo_tpo_cntrto	= 2
	And				i.nmro_cntrto Is Null

	--si el afiliado es un pac que no tiene pos (2010/06/15)
	--
	Insert  @Contrato(
	nmro_cntrto
	)
	Select		c.nmro_cntrto
	From		@tmpBeneficiariosValidador	c
	Left Join	@Contrato					i	On	i.nmro_cntrto	= c.nmro_cntrto
	Where		c.cnsctvo_cdgo_tpo_cntrto	= 2
	And			i.nmro_cntrto Is Null

	Insert Into	@GrupoFamiliarContrato
			(	cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,			nmro_unco_idntfccn_afldo,
				cnsctvo_cdgo_tpo_cntrto,		nmro_cntrto,			cnsctvo_bnfcro,
				inco_vgnca_bnfcro,				fn_vgnca_bnfcro,
				Nmbre_Afldo,
				fcha_ncmnto,					estdo,
				cnsctvo_cdgo_pln,				cnsctvo_cdgo_prntsco,	cnsctvo_cdgo_tpo_afldo
			)
	Select		b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,		b.nmro_unco_idntfccn_afldo,
				b.cnsctvo_cdgo_tpo_cntrto,		b.nmro_cntrto,			b.cnsctvo_bnfcro,
				b.inco_vgnca_bnfcro,			b.fn_vgnca_bnfcro,
				rtrim(ltrim(b.prmr_nmbre)) + ' ' + rtrim(ltrim(b.sgndo_nmbre)) + ' ' + rtrim(ltrim(b.prmr_aplldo)) + ' ' + rtrim(ltrim(b.sgndo_aplldo)),
				b.fcha_ncmnto,					CASE	WHEN b.fn_vgnca_bnfcro < @ffechaValidacion THEN 'INACTIVO'
														WHEN b.inco_vgnca_bnfcro > @ffechaValidacion THEN 'INACTIVO'
														ELSE	'AFILIADO'
												END,
				c.cnsctvo_cdgo_pln,				b.cnsctvo_cdgo_prntsco,	b.cnsctvo_cdgo_tpo_afldo
	From		@tmpBeneficiariosValidador	b
	Inner Join	@tmpContratosValidador		c	On	c.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
												And	c.nmro_cntrto				=	b.nmro_cntrto
	Inner Join	@Contrato					cp	On	cp.nmro_cntrto				=	c.nmro_cntrto
	Where		b.cnsctvo_cdgo_tpo_cntrto	= 2
	Return
End

