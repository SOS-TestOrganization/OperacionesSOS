CREATE PROCEDURE  [dbo].[spConsultaAfiliadoNui]
@nui 		udtConsecutivo

AS
set nocount on

Declare	@tb_result	Table
	(	cnsctvo_cdgo_tpo_idntfccn	int,
		nmro_idntfccn				Varchar(20),
		inco_vgnca_bnfcro			datetime,
		fn_vgnca_bnfcro				datetime,
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					Varchar(15),
		cnsctvo_bnfcro				int,
		cnsctvo_cdgo_pln			int,
		orgn_bsqda					int Default 0
	)

Declare	@fcha_MAX	datetime

Insert Into @tb_result
		(	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,				inco_vgnca_bnfcro,
			fn_vgnca_bnfcro,			cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,
			cnsctvo_bnfcro
		)
Select		cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,				inco_vgnca_bnfcro,
			fn_vgnca_bnfcro,			cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,
			cnsctvo_bnfcro
From	BDAfiliacionValidador.dbo.tbBeneficiariosValidador	With(NoLock)
Where	nmro_unco_idntfccn_afldo = @nui

If Exists	(	Select	1
				from	@tb_result
				Where	getdate() Between inco_vgnca_bnfcro And fn_vgnca_bnfcro
				And		fn_vgnca_bnfcro	<> '9999/12/31'
			)
	Begin
		Delete
		From	@tb_result
		Where	getdate() < inco_vgnca_bnfcro

		Delete
		From	@tb_result
		Where	getdate() > fn_vgnca_bnfcro

		Delete
		From	@tb_result
		Where	fn_vgnca_bnfcro	= '9999/12/31'
	End

Select	@fcha_MAX	= Max(fn_vgnca_bnfcro)
from	@tb_result

If @fcha_MAX Is Not Null
	Delete
	From	@tb_result
	Where	fn_vgnca_bnfcro	<> @fcha_MAX

Update		@tb_result
Set			cnsctvo_cdgo_pln	= c.cnsctvo_cdgo_pln
From		@tb_result										r
Inner Join	BDAfiliacionValidador.dbo.tbContratosValidador	c	With(NoLock)	On	c.cnsctvo_cdgo_tpo_cntrto	=	r.cnsctvo_cdgo_tpo_cntrto
																				And	c.nmro_cntrto				=	r.nmro_cntrto

If Exists	(	Select	1
				from	@tb_result
				Where	cnsctvo_cdgo_tpo_cntrto	= 1
			)
	Delete
	from	@tb_result
	Where	cnsctvo_cdgo_tpo_cntrto	<> 1

Select	cnsctvo_cdgo_tpo_idntfccn,			nmro_idntfccn,				inco_vgnca_bnfcro,				fn_vgnca_bnfcro,
		cnsctvo_cdgo_tpo_cntrto,			nmro_cntrto,				cnsctvo_bnfcro,					cnsctvo_cdgo_pln,
		orgn_bsqda
From	@tb_result


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaAfiliadoNui] TO PUBLIC
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaAfiliadoNui] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaAfiliadoNui] TO [portal_rol]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaAfiliadoNui] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaAfiliadoNui] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaAfiliadoNui] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaAfiliadoNui] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];

