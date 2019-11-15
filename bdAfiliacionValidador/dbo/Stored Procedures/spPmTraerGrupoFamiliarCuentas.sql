


/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spPmTraerGrupoFamiliarCuentas
* Desarrollado por		: <\A Ing. Samuel Muñoz
* Descripcion			: <\D 	D\>
* Observaciones			: <\O  						O\>
* Parametros			: <\P 						P\> 
* Variables			: <\V  						V\>
* Fecha Creacion		: <\FC 2002/06/20 				FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		              : <\AM Ing. Carlos Andrés López Ramírez					AM\>
* Descripcion			 : <\DM Se adicionan campos consecutivos en la senetencia Select.	DM\>
* Nuevos Parametros	 	 : <\PM									PM\>
* Nuevas Variables		 : <\VM d.cnsctvo_cdgo_tpo_idntfccn,f.cnsctvo_cdgo_pln			VM\>
* Fecha Modificacion		 : <\FM 2003/10/03							FM\>
*---------------------------------------------------------------------------------*/
CREATE    procedure  [dbo].[spPmTraerGrupoFamiliarCuentas]
@lnConsecutivoCodigoTipoIdentificacion		udtConsecutivo,
@lnNumeroIdentificacion				udtNumeroIdentificacion
AS
Declare
@fcha_vldcn	datetime,
@fcha_rfrnca	datetime

Set NoCount On

Set @fcha_vldcn = getdate()

Declare @tmpGrupoFamiliar table(
	dscrpcn_pln			varchar(150),
	Orgn				varchar(15),
	cdgo_tpo_idntfccn		varchar(3),
	nmro_idntfccn			varchar(20),
	Nmbre_Afldo			varchar(150),
	dscrpcn_prntsco			varchar(150),
	nmro_cntrto			char(15),
	inco_vgnca_bnfcro		datetime,
	fn_vgnca_bnfcro			datetime,
	estdo				varchar(8),
	cnsctvo_cdgo_pln		int,
	nmro_unco_idntfccn_bnfcro	int,
	cnsctvo_cdgo_tpo_idntfccn	int,
	cnsctvo_cdgo_prntsco		int,
	cnsctvo_cdgo_tpo_afldo		int,
	tpo_afldo			varchar(20),
	Bd				Char(1),
	fcha_ncmnto			datetime
	)


Insert Into @tmpGrupoFamiliar(
Orgn,		Bd,
cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,	nmro_cntrto,
inco_vgnca_bnfcro,	fn_vgnca_bnfcro,
Nmbre_Afldo,	fcha_ncmnto,			estdo,		cnsctvo_cdgo_pln,
cnsctvo_cdgo_prntsco,	cnsctvo_cdgo_tpo_afldo,	nmro_unco_idntfccn_bnfcro
)
Select	'CONTRATOS',	1,
	b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,	b.nmro_cntrto,
	b.inco_vgnca_bnfcro,		b.fn_vgnca_bnfcro,
	Nmbre_Afldo,	b.fcha_ncmnto,
	CASE
	WHEN b.fn_vgnca_bnfcro < @fcha_vldcn THEN 'INACTIVO'
	WHEN b.inco_vgnca_bnfcro > @fcha_vldcn THEN 'INACTIVO'
	ELSE	'AFILIADO'
	END,					b.cnsctvo_cdgo_pln,
	b.cnsctvo_cdgo_prntsco,	b.cnsctvo_cdgo_tpo_afldo,	b.nmro_unco_idntfccn_afldo
From	dbo.fnPmTraerGrupoFamiliarContrato(@lnConsecutivoCodigoTipoIdentificacion,@lnNumeroIdentificacion,@fcha_vldcn) as b



Insert Into @tmpGrupoFamiliar(
Orgn,		Bd,
cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,	nmro_cntrto,
inco_vgnca_bnfcro,	fn_vgnca_bnfcro,
Nmbre_Afldo,	fcha_ncmnto,			estdo,		cnsctvo_cdgo_pln,
cnsctvo_cdgo_prntsco,	cnsctvo_cdgo_tpo_afldo,	nmro_unco_idntfccn_bnfcro
)
Select	'FORMULARIO',	2,
	b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,	b.nmro_frmlro,
	b.inco_vgnca_bnfcro,		b.fn_vgnca_bnfcro,
	Nmbre_Afldo,	b.fcha_ncmnto,
	CASE
	WHEN b.fn_vgnca_bnfcro < @fcha_vldcn THEN 'INACTIVO'
	WHEN b.inco_vgnca_bnfcro > @fcha_vldcn THEN 'INACTIVO'
	ELSE	'AFILIADO'
	END,					b.cnsctvo_cdgo_pln,
	b.cnsctvo_cdgo_prntsco,	b.cnsctvo_cdgo_tpo_afldo,	b.nmro_unco_idntfccn_afldo
From	dbo.fnPmTraerGrupoFamiliarFormulario(@lnConsecutivoCodigoTipoIdentificacion,@lnNumeroIdentificacion,@fcha_vldcn) as b


Insert Into @tmpGrupoFamiliar(
Orgn,		Bd,
cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,	--nmro_cntrto,
inco_vgnca_bnfcro,	fn_vgnca_bnfcro,
Nmbre_Afldo,	fcha_ncmnto,			estdo,		cnsctvo_cdgo_pln,
cnsctvo_cdgo_prntsco,	cnsctvo_cdgo_tpo_afldo,	nmro_unco_idntfccn_bnfcro
)
Select	'FAMISANAR',	3,
	b.cnsctvo_cdgo_tpo_idntfccn_bnfcro,	b.nmro_idntfccn_bnfcro,	--b.nmro_frmlro,
	b.inco_vgnca,		b.fn_vgnca,
	ltrim(rtrim(prmr_nmbre_bnfcro)) + ' ' + ltrim(rtrim(sgndo_nmbre_bnfcro)) + ' ' + ltrim(rtrim(prmr_aplldo_bnfcro)) + ' ' + ltrim(rtrim(sgndo_aplldo_bnfcro)),
	b.fcha_ncmnto,			'INACTIVO',		b.cnsctvo_cdgo_pln,
	b.prntsco,	b.cnsctvo_cdgo_tpo_afldo,	null--b.nmro_unco_idntfccn_afldo
--Select	*
From	bdSISalud..tbEapb b
Where	fcha_hsta	= '9999/12/31'
And	b.cnsctvo_cdgo_tpo_idntfccn_bnfcro	= @lnConsecutivoCodigoTipoIdentificacion
And	b.nmro_idntfccn_bnfcro			= @lnNumeroIdentificacion

----------------------------------------------------------------
--   Actualizacion de datos


Update	@tmpGrupoFamiliar
Set	cdgo_tpo_idntfccn = i.cdgo_tpo_idntfccn
From	tbTiposIdentificacion_Vigencias i INNER JOIN @tmpGrupoFamiliar t
	On i.cnsctvo_cdgo_tpo_idntfccn	= t.cnsctvo_cdgo_tpo_idntfccn
Where	vsble_usro			= 'S'
And	@fcha_vldcn Between inco_vgnca And fn_vgnca


Update	@tmpGrupoFamiliar
Set	dscrpcn_prntsco = p.dscrpcn_prntsco
From	@tmpGrupoFamiliar t INNER JOIN tbParentescos_vigencias p
	On t.cnsctvo_cdgo_prntsco = p.cnsctvo_cdgo_prntscs
Where	@fcha_vldcn Between p.inco_vgnca And p.fn_vgnca

Update	@tmpGrupoFamiliar
Set	tpo_afldo = a.dscrpcn
From	@tmpGrupoFamiliar t INNER JOIN tbTiposAfiliado_vigencias a
	On t.cnsctvo_cdgo_tpo_afldo	= a.cnsctvo_cdgo_tpo_afldo
Where	@fcha_vldcn Between inco_vgnca And fn_vgnca


Update	@tmpGrupoFamiliar
Set	dscrpcn_pln	= p.dscrpcn_pln
From	@tmpGrupoFamiliar t INNER JOIN tbPlanes_Vigencias p
	On t.cnsctvo_cdgo_pln	= p.cnsctvo_cdgo_pln
Where	@fcha_vldcn Between p.inco_vgnca And p.fn_vgnca


Select	dscrpcn_pln,
	cdgo_tpo_idntfccn,
	nmro_idntfccn,
	Nmbre_Afldo,
	tpo_afldo,
	fcha_ncmnto,
	dscrpcn_prntsco,
	nmro_cntrto,
	inco_vgnca_bnfcro,
	fn_vgnca_bnfcro,
	estdo,
	cnsctvo_cdgo_pln,
	nmro_unco_idntfccn_bnfcro,
	cnsctvo_cdgo_tpo_idntfccn,
	cnsctvo_cdgo_prntsco,
	cnsctvo_cdgo_tpo_afldo,
	Orgn,
	Bd
from	@tmpGrupoFamiliar



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliarCuentas] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliarCuentas] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliarCuentas] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliarCuentas] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliarCuentas] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliarCuentas] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliarCuentas] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliarCuentas] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliarCuentas] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerGrupoFamiliarCuentas] TO [Radicador Recobros]
    AS [dbo];

