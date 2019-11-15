

/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              	 :  fnPmTraerGrupoFamiliarFormulario
* Desarrollado por		 :  <\A    Ing. Nilson Mossos Vivas									A\>
* Descripcion			 :  <\D  Trae la informacion del grupo familiar de un afiliado en el ultimo contrato POS y PAC	D\>
* Observaciones		         :  <\O												O\>
* Parametros			 :  <\P 	Numero Unico de Identificacion del afiliado 								P\>
*				    <\P													P\>
* Fecha Creacion		 :  <\FC  2003/03/12											FC\>
*  
*---------------------------------------------------------------------------------*/
CREATE function dbo.fnPmTraerGrupoFamiliarFormulario(
@lnConsecutivoCodigoTipoIdentificacion		udtConsecutivo,
@lnNumeroIdentificacion				udtNumeroIdentificacion,
@ffechaValidacion datetime )
Returns  @GrupoFamiliarFormulario Table(
			cnsctvo_cdgo_tpo_frmlro		int,
			nmro_frmlro			char(15),
			cnsctvo_bnfcro			int,
			cnsctvo_cdgo_tpo_idntfccn	int,
			nmro_idntfccn			varchar(15),
			nmro_unco_idntfccn_afldo	int,
			Nmbre_Afldo			varchar(250),
			inco_vgnca_bnfcro		datetime,
			fn_vgnca_bnfcro			datetime,
			cnsctvo_cdgo_tpo_afldo		int,
			cnsctvo_cdgo_prntsco		int,
			estdo				char(12),
			fcha_ncmnto			datetime,
			cnsctvo_cdgo_pln		int
			)

As
Begin

Declare
@cnsctvo_cdgo_tpo_frmlro	udtConsecutivo,
@nmro_frmlro			udtNumeroFormulario--,
--@fcha_rfrnca			datetime

Declare
@Contrato Table(
nmro_frmlro	varchar(15)
)

Set @cnsctvo_cdgo_tpo_frmlro	= null
Set @nmro_frmlro		= null
--sp_help	tbBeneficiariosFormularioValidador


Select	@cnsctvo_cdgo_tpo_frmlro	= cnsctvo_cdgo_tpo_frmlro,
	@nmro_frmlro			= nmro_frmlro
From	tbBeneficiariosFormularioValidador
Where	cnsctvo_tpo_idntfccn_bnfcro	= @lnConsecutivoCodigoTipoIdentificacion
And	nmro_idntfccn_bnfcro		= @lnNumeroIdentificacion
And	fcha_hsta			= '9999/12/31'

If @nmro_frmlro Is Not Null
Begin
	Insert @GrupoFamiliarFormulario(
	cnsctvo_cdgo_tpo_frmlro,	nmro_frmlro,		cnsctvo_bnfcro,
	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,		nmro_unco_idntfccn_afldo,
	Nmbre_Afldo,			inco_vgnca_bnfcro,	fn_vgnca_bnfcro,
	cnsctvo_cdgo_tpo_afldo,		cnsctvo_cdgo_prntsco,	estdo,
	fcha_ncmnto,			cnsctvo_cdgo_pln
	)
	Select
	cnsctvo_cdgo_tpo_frmlro,	nmro_frmlro,		cnsctvo_bnfcro,
	cnsctvo_tpo_idntfccn_bnfcro,	nmro_idntfccn_bnfcro,	null,
	ltrim(rtrim(prmr_nmbre)) + ' ' + ltrim(rtrim(sgndo_nmbre)) + ' ' + ltrim(rtrim(prmr_aplldo)) + ' ' + ltrim(rtrim(sgndo_aplldo)),
	inco_vgnca_bnfcro,		fn_vgnca_bnfcro,
	cnsctvo_cdgo_tpo_afldo,		cnsctvo_cdgo_prntsco,
	CASE
	WHEN fn_vgnca_bnfcro < @ffechaValidacion THEN 'INACTIVO'
	WHEN inco_vgnca_bnfcro > @ffechaValidacion THEN 'INACTIVO'
	ELSE 'EN PROCESO'
	END,
	fcha_ncmnto,			cnsctvo_cdgo_pln
	From	tbBeneficiariosFormularioValidador
	Where	cnsctvo_cdgo_tpo_frmlro	= @cnsctvo_cdgo_tpo_frmlro
	And	nmro_frmlro			= @nmro_frmlro
	And	cnsctvo_cdgo_estdo_frmlro	!= 6
--	And	fcha_hsta			= '9999/12/31'
End

/*
If @fcha_rfrnca Is Not Null
Begin
	Declare
	@nmro_frmlro	udtNumeroFormulario

	Select	@nmro_frmlro	= nmro_frmlro
	From	tbBeneficiariosValidador
	Where	cnsctvo_cdgo_tpo_idntfccn	= @lnConsecutivoCodigoTipoIdentificacion
	And	nmro_idntfccn			= @lnNumeroIdentificacion
	And	fn_vgnca_bnfcro			= @fcha_rfrnca
	And	cnsctvo_cdgo_tpo_cntrto		= 1

	If @fcha_rfrnca Is Not Null
	Begin
		Insert @GrupoFamiliarFormulario(
		cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,		nmro_unco_idntfccn_afldo,
		cnsctvo_cdgo_tpo_cntrto,	nmro_frmlro,		cnsctvo_bnfcro,
		inco_vgnca_bnfcro,	fn_vgnca_bnfcro,
		Nmbre_Afldo,
		fcha_ncmnto,			estdo,		cnsctvo_cdgo_pln,
		cnsctvo_cdgo_prntsco,	cnsctvo_cdgo_tpo_afldo--,	nmro_unco_idntfccn_bnfcro
		)
		Select	b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,	b.nmro_unco_idntfccn_afldo,
			b.cnsctvo_cdgo_tpo_cntrto,	b.nmro_frmlro,		b.cnsctvo_bnfcro,
			b.inco_vgnca_bnfcro,		b.fn_vgnca_bnfcro,
			rtrim(ltrim(b.prmr_nmbre)) + ' ' + rtrim(ltrim(b.sgndo_nmbre)) + ' ' + rtrim(ltrim(b.prmr_aplldo)) + ' ' + rtrim(ltrim(b.sgndo_aplldo)),
			b.fcha_ncmnto,
			CASE
			WHEN b.fn_vgnca_bnfcro < @ffechaValidacion THEN 'INACTIVO'
			WHEN b.inco_vgnca_bnfcro > @ffechaValidacion THEN 'INACTIVO'
			ELSE	'AFILIADO'
			END,					c.cnsctvo_cdgo_pln,
			b.cnsctvo_cdgo_prntsco,	b.cnsctvo_cdgo_tpo_afldo--,	b.nmro_unco_idntfccn_afldo
		From	tbBeneficiariosValidador b,	tbContratosValidador c
		Where	b.cnsctvo_cdgo_tpo_cntrto	= c.cnsctvo_cdgo_tpo_cntrto
		And	b.nmro_frmlro			= c.nmro_frmlro
		And	b.fn_vgnca_bnfcro		= @fcha_rfrnca
		And	b.cnsctvo_cdgo_tpo_cntrto	= 1
		And	b.nmro_frmlro			= @nmro_frmlro

		Insert @Contrato(
		nmro_frmlro
		)
		Select	nmro_frmlro
		From	dbo.tbRelacionPosCValidador 
		Where	nmro_frmlro_psc	= @nmro_frmlro
		And	cdgo_tpo_cntrto_psc	= 1
		Union
		Select	nmro_frmlro_psc
		From	dbo.tbRelacionPosCValidador
		Where	nmro_frmlro	= @nmro_frmlro
		And	cnsctvo_cdgo_tpo_cntrto	= 1


		Insert @GrupoFamiliarFormulario(
		cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,		nmro_unco_idntfccn_afldo,
		cnsctvo_cdgo_tpo_cntrto,	nmro_frmlro,		cnsctvo_bnfcro,
		inco_vgnca_bnfcro,	fn_vgnca_bnfcro,
		Nmbre_Afldo,
		fcha_ncmnto,			estdo,		cnsctvo_cdgo_pln,
		cnsctvo_cdgo_prntsco,	cnsctvo_cdgo_tpo_afldo--,	nmro_unco_idntfccn_bnfcro
		)
		Select	b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,	b.nmro_unco_idntfccn_afldo,
			b.cnsctvo_cdgo_tpo_cntrto,	b.nmro_frmlro,		b.cnsctvo_bnfcro,
			b.inco_vgnca_bnfcro,		b.fn_vgnca_bnfcro,
			rtrim(ltrim(b.prmr_nmbre)) + ' ' + rtrim(ltrim(b.sgndo_nmbre)) + ' ' + rtrim(ltrim(b.prmr_aplldo)) + ' ' + rtrim(ltrim(b.sgndo_aplldo)),
			b.fcha_ncmnto,
			CASE
			WHEN b.fn_vgnca_bnfcro < @ffechaValidacion THEN 'INACTIVO'
			WHEN b.inco_vgnca_bnfcro > @ffechaValidacion THEN 'INACTIVO'
			ELSE	'AFILIADO'
			END,					c.cnsctvo_cdgo_pln,
			b.cnsctvo_cdgo_prntsco,	b.cnsctvo_cdgo_tpo_afldo--,	b.nmro_unco_idntfccn_afldo
		From	tbBeneficiariosValidador b,	tbContratosValidador c,@Contrato cp
		Where	b.cnsctvo_cdgo_tpo_cntrto	= c.cnsctvo_cdgo_tpo_cntrto
		And	b.nmro_frmlro			= c.nmro_frmlro
		And	cp.nmro_frmlro			= c.nmro_frmlro
		--And	b.fn_vgnca_bnfcro		= @fcha_rfrnca
		And	b.cnsctvo_cdgo_tpo_cntrto	= 1
---------------------------------------------------------------------------------------
---	Eliminar Alifiados que actualmente tienen un contratos activo
	End
End

Delete @Contrato

Insert @Contrato(
nmro_frmlro
)
Select	Distinct b.nmro_frmlro
From	@GrupoFamiliarFormulario g, tbBeneficiariosValidador b
Where	b.cnsctvo_cdgo_tpo_cntrto	= 2
And	g.cnsctvo_cdgo_tpo_idntfccn	= b.cnsctvo_cdgo_tpo_idntfccn
And	g.nmro_idntfccn			= b.nmro_idntfccn


Insert @GrupoFamiliarFormulario(
cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,		nmro_unco_idntfccn_afldo,
cnsctvo_cdgo_tpo_cntrto,	nmro_frmlro,		cnsctvo_bnfcro,
inco_vgnca_bnfcro,	fn_vgnca_bnfcro,
Nmbre_Afldo,
fcha_ncmnto,			estdo,		cnsctvo_cdgo_pln,
cnsctvo_cdgo_prntsco,	cnsctvo_cdgo_tpo_afldo--,	nmro_unco_idntfccn_bnfcro
)
Select	b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,	b.nmro_unco_idntfccn_afldo,
	b.cnsctvo_cdgo_tpo_cntrto,	b.nmro_frmlro,		b.cnsctvo_bnfcro,
	b.inco_vgnca_bnfcro,		b.fn_vgnca_bnfcro,
	rtrim(ltrim(b.prmr_nmbre)) + ' ' + rtrim(ltrim(b.sgndo_nmbre)) + ' ' + rtrim(ltrim(b.prmr_aplldo)) + ' ' + rtrim(ltrim(b.sgndo_aplldo)),
	b.fcha_ncmnto,
	CASE
	WHEN b.fn_vgnca_bnfcro < @ffechaValidacion THEN 'INACTIVO'
	WHEN b.inco_vgnca_bnfcro > @ffechaValidacion THEN 'INACTIVO'
	ELSE	'AFILIADO'
	END,					c.cnsctvo_cdgo_pln,
	b.cnsctvo_cdgo_prntsco,	b.cnsctvo_cdgo_tpo_afldo--,	b.nmro_unco_idntfccn_afldo
From	tbBeneficiariosValidador b,	tbContratosValidador c,@Contrato cp
Where	b.cnsctvo_cdgo_tpo_cntrto	= c.cnsctvo_cdgo_tpo_cntrto
And	b.nmro_frmlro			= c.nmro_frmlro
And	cp.nmro_frmlro			= c.nmro_frmlro
--And	b.fn_vgnca_bnfcro		= @fcha_rfrnca
And	b.cnsctvo_cdgo_tpo_cntrto	= 2


*/

Return
End




