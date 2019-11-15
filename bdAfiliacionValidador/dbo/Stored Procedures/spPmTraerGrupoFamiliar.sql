CREATE procedure  [dbo].[spPmTraerGrupoFamiliar]
@lnConsecutivoCodigoTipoIdentificacion	udtConsecutivo,
@lnNumeroIdentificacion					udtNumeroIdentificacion

AS
Set NoCount On

/*
Declare
@lnConsecutivoCodigoTipoIdentificacion	udtConsecutivo,
@lnNumeroIdentificacion					udtNumeroIdentificacion

Set	@lnConsecutivoCodigoTipoIdentificacion = 1
Set	@lnNumeroIdentificacion = '94526804'
*/

Declare		@fcha_vldcn		datetime,
			@fcha_rfrnca	datetime,
			@srvdr			VarChar(20)

Set			@fcha_vldcn =	getdate()
Set			@srvdr		=	ltrim(rtrim(CONVERT(varchar(30), SERVERPROPERTY('machinename'))))

Declare @tmpGrupoFamiliar table
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
		fcha_ncmnto					datetime
	)

If Exists	(	Select	1
				From	bdAfiliacionValidador.dbo.tbtablaParametros	With(NoLock)
				Where	vlr_prmtro	=	@srvdr
			)

	Begin
		Insert Into @tmpGrupoFamiliar
				(	Orgn,					Bd,						cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,				nmro_cntrto,
					inco_vgnca_bnfcro,		fn_vgnca_bnfcro,		Nmbre_Afldo,					fcha_ncmnto,				estdo,
					cnsctvo_cdgo_pln,		cnsctvo_cdgo_prntsco,	cnsctvo_cdgo_tpo_afldo,			nmro_unco_idntfccn_bnfcro
				)
		Select		'CONTRATOS',			1,						b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,			b.nmro_cntrto,
					b.inco_vgnca_bnfcro,	b.fn_vgnca_bnfcro,		Nmbre_Afldo,					b.fcha_ncmnto,				CASE	WHEN b.fn_vgnca_bnfcro < @fcha_vldcn THEN 'INACTIVO'
																																		WHEN b.inco_vgnca_bnfcro > @fcha_vldcn THEN 'INACTIVO'
																																		ELSE	'AFILIADO'
																																END,
					b.cnsctvo_cdgo_pln,		b.cnsctvo_cdgo_prntsco,	b.cnsctvo_cdgo_tpo_afldo,		b.nmro_unco_idntfccn_afldo
		From		bdAfiliacionValidador.dbo.fnPmTraerGrupoFamiliarContrato(@lnConsecutivoCodigoTipoIdentificacion,@lnNumeroIdentificacion,@fcha_vldcn)	b


		Insert Into @tmpGrupoFamiliar
				(	Orgn,									Bd,						cnsctvo_cdgo_tpo_idntfccn,				nmro_idntfccn,				inco_vgnca_bnfcro,
					fn_vgnca_bnfcro,						Nmbre_Afldo,
					fcha_ncmnto,							estdo,					cnsctvo_cdgo_pln,						cnsctvo_cdgo_prntsco,		cnsctvo_cdgo_tpo_afldo,
					nmro_unco_idntfccn_bnfcro
		)
		Select		Substring(a.dscrpcn_eapb,1,15),			3,						b.cnsctvo_cdgo_tpo_idntfccn_bnfcro,		b.nmro_idntfccn_bnfcro,		b.inco_vgnca,
					b.fn_vgnca,								ltrim(rtrim(prmr_nmbre_bnfcro)) + ' ' + ltrim(rtrim(sgndo_nmbre_bnfcro)) + ' ' + ltrim(rtrim(prmr_aplldo_bnfcro)) + ' ' + ltrim(rtrim(sgndo_aplldo_bnfcro)),
					b.fcha_ncmnto,							'INACTIVO',				b.cnsctvo_cdgo_pln,						b.prntsco,					b.cnsctvo_cdgo_tpo_afldo,
					null
		--Select	*
		From		bdAfiliacionValidador.dbo.tbEapb					b	With(NoLock)
		Inner Join	bdAfiliacionValidador.dbo.tbDetalleEapb_vigencias	a	With(NoLock)	On	a.cdgo_eapb	=	b.cdgo_eapb
		Where		getdate() between b.inco_vgnca		and b.fn_vgnca
		And			b.cnsctvo_cdgo_tpo_idntfccn_bnfcro	= @lnConsecutivoCodigoTipoIdentificacion
		And			b.nmro_idntfccn_bnfcro				= @lnNumeroIdentificacion
		And			getdate() between a.inco_vgnca and a.fn_vgnca
		----------------------------------------------------------------
		--   Actualizacion de datos
		Update		@tmpGrupoFamiliar
		Set			cdgo_tpo_idntfccn = i.cdgo_tpo_idntfccn
		From		bdAfiliacionValidador.dbo.tbTiposIdentificacion_Vigencias	i	With(NoLock)
		INNER JOIN	@tmpGrupoFamiliar											t	On	i.cnsctvo_cdgo_tpo_idntfccn	= t.cnsctvo_cdgo_tpo_idntfccn
		Where		vsble_usro			= 'S'
		And			@fcha_vldcn Between inco_vgnca And fn_vgnca

		Update		@tmpGrupoFamiliar
		Set			dscrpcn_prntsco = p.dscrpcn_prntsco
		From		@tmpGrupoFamiliar									t
		INNER JOIN	bdAfiliacionValidador.dbo.tbParentescos_vigencias	p	With(NoLock)	On	t.cnsctvo_cdgo_prntsco = p.cnsctvo_cdgo_prntscs
		Where		@fcha_vldcn Between p.inco_vgnca And p.fn_vgnca

		Update		@tmpGrupoFamiliar
		Set			tpo_afldo = a.dscrpcn
		From		@tmpGrupoFamiliar									t
		INNER JOIN	bdAfiliacionValidador.dbo.tbTiposAfiliado_vigencias	a	With(NoLock)	On	t.cnsctvo_cdgo_tpo_afldo	= a.cnsctvo_cdgo_tpo_afldo
		Where		@fcha_vldcn Between inco_vgnca And fn_vgnca

		Update		@tmpGrupoFamiliar
		Set			dscrpcn_pln	= p.dscrpcn_pln
		From		@tmpGrupoFamiliar								t
		INNER JOIN	bdAfiliacionValidador.dbo.tbPlanes_Vigencias	p	With(NoLock)	On	t.cnsctvo_cdgo_pln	= p.cnsctvo_cdgo_pln
		Where		@fcha_vldcn Between p.inco_vgnca And p.fn_vgnca
	end
else
	Begin
		Insert Into @tmpGrupoFamiliar
				(	Orgn,					Bd,							cnsctvo_cdgo_tpo_idntfccn,			nmro_idntfccn,		nmro_cntrto,		inco_vgnca_bnfcro,
					fn_vgnca_bnfcro,		Nmbre_Afldo,				fcha_ncmnto,						estdo,
					cnsctvo_cdgo_pln,		cnsctvo_cdgo_prntsco,		cnsctvo_cdgo_tpo_afldo,				nmro_unco_idntfccn_bnfcro
		)
		Select		'CONTRATOS',			1,							b.cnsctvo_cdgo_tpo_idntfccn,		b.nmro_idntfccn,	b.nmro_cntrto,		b.inco_vgnca_bnfcro,
					b.fn_vgnca_bnfcro,		Nmbre_Afldo,				b.fcha_ncmnto,						CASE	WHEN b.fn_vgnca_bnfcro < @fcha_vldcn THEN 'INACTIVO'
																													WHEN b.inco_vgnca_bnfcro > @fcha_vldcn THEN 'INACTIVO'
																													ELSE	'AFILIADO'
																											END,
					b.cnsctvo_cdgo_pln,		b.cnsctvo_cdgo_prntsco,		b.cnsctvo_cdgo_tpo_afldo,			b.nmro_unco_idntfccn_afldo
		From		bdAfiliacionValidador.dbo.fnPmTraerGrupoFamiliarContrato(@lnConsecutivoCodigoTipoIdentificacion,@lnNumeroIdentificacion,@fcha_vldcn)	b

		Insert Into @tmpGrupoFamiliar
				(	Orgn,								Bd,				cnsctvo_cdgo_tpo_idntfccn,				nmro_idntfccn,			inco_vgnca_bnfcro,
					fn_vgnca_bnfcro,					Nmbre_Afldo,	
					fcha_ncmnto,						estdo,			cnsctvo_cdgo_pln,						cnsctvo_cdgo_prntsco,	cnsctvo_cdgo_tpo_afldo,
					nmro_unco_idntfccn_bnfcro
		)
		Select		Substring(a.dscrpcn_eapb,1,15),		3,				b.cnsctvo_cdgo_tpo_idntfccn_bnfcro,		b.nmro_idntfccn_bnfcro,	b.inco_vgnca,
					b.fn_vgnca,							ltrim(rtrim(prmr_nmbre_bnfcro)) + ' ' + ltrim(rtrim(sgndo_nmbre_bnfcro)) + ' ' + ltrim(rtrim(prmr_aplldo_bnfcro)) + ' ' + ltrim(rtrim(sgndo_aplldo_bnfcro)),
					b.fcha_ncmnto,						'INACTIVO',		b.cnsctvo_cdgo_pln,						b.prntsco,				b.cnsctvo_cdgo_tpo_afldo,
					null
		From		bdSISalud.dbo.tbEapb					b	With(NoLock)
		Inner Join	bdSiSalud.dbo.tbDetalleEapb_vigencias	a	With(NoLock)	On	a.cdgo_eapb	=	b.cdgo_eapb
		Where		getdate() between b.inco_vgnca and b.fn_vgnca
		And			b.cnsctvo_cdgo_tpo_idntfccn_bnfcro	= @lnConsecutivoCodigoTipoIdentificacion
		And			b.nmro_idntfccn_bnfcro				= @lnNumeroIdentificacion
		and			getdate() between a.inco_vgnca and a.fn_vgnca
		----------------------------------------------------------------
		--   Actualizacion de datos
		Update		@tmpGrupoFamiliar
		Set			cdgo_tpo_idntfccn = i.cdgo_tpo_idntfccn
		From		bdAfiliacionValidador.dbo.tbTiposIdentificacion_Vigencias	i	With(NoLock)
		INNER JOIN	@tmpGrupoFamiliar											t	On	i.cnsctvo_cdgo_tpo_idntfccn	= t.cnsctvo_cdgo_tpo_idntfccn
		Where		vsble_usro			= 'S'
		And			@fcha_vldcn Between inco_vgnca And fn_vgnca

		Update		@tmpGrupoFamiliar
		Set			dscrpcn_prntsco = p.dscrpcn_prntsco
		From		@tmpGrupoFamiliar									t
		INNER JOIN	bdAfiliacionValidador.dbo.tbParentescos_vigencias	p	With(NoLock)	On	t.cnsctvo_cdgo_prntsco = p.cnsctvo_cdgo_prntscs
		Where		@fcha_vldcn Between p.inco_vgnca And p.fn_vgnca

		Update		@tmpGrupoFamiliar
		Set			tpo_afldo = a.dscrpcn
		From		@tmpGrupoFamiliar									t
		INNER JOIN	bdAfiliacionValidador.dbo.tbTiposAfiliado_vigencias	a	With(NoLock)	On	t.cnsctvo_cdgo_tpo_afldo	= a.cnsctvo_cdgo_tpo_afldo
		Where		@fcha_vldcn Between inco_vgnca And fn_vgnca

		Update		@tmpGrupoFamiliar
		Set			dscrpcn_pln	= p.dscrpcn_pln
		From		@tmpGrupoFamiliar								t
		INNER JOIN	bdAfiliacionValidador.dbo.tbPlanes_Vigencias	p	With(NoLock)	On	t.cnsctvo_cdgo_pln	= p.cnsctvo_cdgo_pln
		Where		@fcha_vldcn Between p.inco_vgnca And p.fn_vgnca
	END

Select		dscrpcn_pln,				cdgo_tpo_idntfccn,			nmro_idntfccn,					Nmbre_Afldo,				tpo_afldo,
			fcha_ncmnto,				dscrpcn_prntsco,			nmro_cntrto,					inco_vgnca_bnfcro,			fn_vgnca_bnfcro,
			estdo,						cnsctvo_cdgo_pln,			nmro_unco_idntfccn_bnfcro,		cnsctvo_cdgo_tpo_idntfccn,	cnsctvo_cdgo_prntsco,
			cnsctvo_cdgo_tpo_afldo,		Orgn,						Bd
from		@tmpGrupoFamiliar


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [portal_rol]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [autsalud_rol]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliar] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

