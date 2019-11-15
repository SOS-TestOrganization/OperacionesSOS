CREATE	procedure [dbo].[spPmDatosAdicionalesAfiliado]
@cnsctvo_cdgo_tpo_idntfccn	udtConsecutivo,
@nmro_idntfccn			varchar(20),
@fcha_vldcn			datetime

As
Set Nocount On

/*
set @cnsctvo_cdgo_tpo_idntfccn = 1
set @nmro_idntfccn = '94526804'
set @fcha_vldcn = '20170509'
*/

Declare	@fcha	datetime

Declare	@tbinfoAfiliado Table
	(	cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(15),
		nmro_unco_idntfccn_afldo	int,
		cnsctvo_cdgo_estdo_cvl		int,
		cnsctvo_cdgo_cdd_rsdnca		int,
		drccn_rsdnca				varchar(80),
		tlfno_rsdnca				varchar(80),
		cnsctvo_cdgo_afp			int,
		cdgo_cdd					char(8),
		cdgo_ips					char(8),
		cnsctvo_cdgo_brro			int,
		cdgo_brro					char(10),
		ctza						char,
		cdgo_estdo_cvl				char(2),
		dscrpcn_estdo_cvl			varchar(150),
		nmbre_scrsl_ips				varchar(150),
		cdgo_afp					char(8),
		dscrpcn_afp					varchar(150),
		dscrpcn_brro				varchar(150),
		dscrpcn_cdd					varchar(150),
		dscrpcn_dprtmnto			varchar(150),
		smns_ctzds					int,
		inco_vgnca_bnfcro			datetime,
		fn_vgnca_bnfcro				datetime,
		cnsctvo_bnfcro				int,  --Adicion de Campo Nuevo 
		eml							varchar(50),	 --Adicion campo (sisatv01) 2009/11/30
		dscrpcn_cmna				varchar(150)
	)

--sp_help tbCiudades_Vigencias

Insert	@tbinfoAfiliado
	(	cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,				nmro_unco_idntfccn_afldo,
		cnsctvo_cdgo_estdo_cvl,		cnsctvo_cdgo_cdd_rsdnca,	drccn_rsdnca,
		tlfno_rsdnca,				cnsctvo_cdgo_brro,			ctza,
		smns_ctzds,					inco_vgnca_bnfcro,			fn_vgnca_bnfcro,
		cnsctvo_bnfcro,				eml
	)
Select	cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,				nmro_unco_idntfccn_afldo,
		cnsctvo_cdgo_estdo_cvl,		cnsctvo_cdgo_cdd_rsdnca,	drccn_rsdnca,
		tlfno_rsdnca,				cnsctvo_cdgo_brro,			case cnsctvo_cdgo_tpo_afldo	when 1	then 'S'
																							when 2	then 'S'
																							else	'N'
																							end,
		smns_ctzds,					inco_vgnca_bnfcro,			fn_vgnca_bnfcro,
		cnsctvo_bnfcro,				isnull(eml,'')
From	bdAfiliacionValidador.dbo.tbBeneficiariosValidador	With(NoLock)
Where	cnsctvo_cdgo_tpo_idntfccn	=	@cnsctvo_cdgo_tpo_idntfccn
And		nmro_idntfccn				=	@nmro_idntfccn


If Exists(	Select	1
			From	@tbinfoAfiliado
			Where	@fcha_vldcn Between inco_vgnca_bnfcro And fn_vgnca_bnfcro
		)
	Begin
		Delete
		From	@tbinfoAfiliado
		Where	inco_vgnca_bnfcro	> @fcha_vldcn

		Delete
		From	@tbinfoAfiliado
		Where	fn_vgnca_bnfcro		< @fcha_vldcn
	End
Else
	If Exists	(	Select	1
					From	@tbinfoAfiliado
					Where	fn_vgnca_bnfcro	< @fcha_vldcn
				)
		Begin
			Select	@fcha	= Max(fn_vgnca_bnfcro)
			From	@tbinfoAfiliado
			Where	fn_vgnca_bnfcro	< @fcha_vldcn

			if @fcha is Null
				Select	@fcha	= Max(fn_vgnca_bnfcro)
				From	@tbinfoAfiliado

			Delete
			From	@tbinfoAfiliado
			Where	fn_vgnca_bnfcro	<> @fcha
		End

Update		@tbinfoAfiliado
Set			cnsctvo_cdgo_afp	= c.cnsctvo_cdgo_afp
From		@tbinfoAfiliado			a
Inner Join	bdAfiliacionValidador.dbo.tbContratosValidador	c	With(NoLock)	On	a.cnsctvo_cdgo_tpo_cntrto	= c.cnsctvo_cdgo_tpo_cntrto
																				And	a.nmro_cntrto				= c.nmro_cntrto

Update		@tbinfoAfiliado
Set			cdgo_ips	= a.cdgo_ips
From		@tbinfoAfiliado											i
Inner Join	bdAfiliacionValidador.dbo.tbActuarioCapitacionValidador	a	With(NoLock)	On	a.nmro_unco_idntfccn		= i.nmro_unco_idntfccn_afldo
																						And	a.cnsctvo_cdgo_tpo_cntrto	= i.cnsctvo_cdgo_tpo_cntrto
Where		@fcha_vldcn between fcha_dsde and fcha_hsta

Update		@tbinfoAfiliado
Set			dscrpcn_estdo_cvl	= e.dscrpcn_estdo_cvl,
			cdgo_estdo_cvl		= e.cdgo_estdo_cvl
From		@tbinfoAfiliado								i
Inner Join	bdAfiliacionValidador.dbo.tbEstadosCiviles	e	With(NoLock)	On	e.cnsctvo_cdgo_estdo_cvl	= i.cnsctvo_cdgo_estdo_cvl

Update		@tbinfoAfiliado
Set			nmbre_scrsl_ips	= i.nmbre_scrsl
From		bdAfiliacionValidador.dbo.tbIPSPrimarias_vigencias	i	With(NoLock)
Inner Join	@tbinfoAfiliado										a	On	i.cdgo_intrno	= a.cdgo_ips
Where		@fcha_vldcn between i.inco_vgnca and i.fn_vgnca

Update		@tbinfoAfiliado
Set			dscrpcn_afp	= e.dscrpcn_entdd,
			cdgo_afp	= e.cdgo_entdd
From		@tbinfoAfiliado									a
Inner Join	bdAfiliacionValidador.dbo.tbEntidades_vigencias	e	With(NoLock)	On	a.cnsctvo_cdgo_afp	= e.cnsctvo_cdgo_entdd
Where		@fcha_vldcn between e.inco_vgnca and e.fn_vgnca  

Update		@tbinfoAfiliado
Set			dscrpcn_brro = b.dscrpcn_brro,
			cdgo_brro	= b.cdgo_brro,
			dscrpcn_cmna = isnull(c.dscrpcn_cmna,'')
From		bdAfiliacionValidador.dbo.tbBarrios_Vigencias	b	With(NoLock)
inner join	@tbinfoAfiliado									i					on	i.cnsctvo_cdgo_brro	= b.cnsctvo_cdgo_brro
left join	bdAfiliacionValidador.dbo.tbComunas				c	With(NoLock)	on	b.cnsctvo_cdgo_cmna = c.cnsctvo_cdgo_cmna
Where		@fcha_vldcn between b.inco_vgnca and b.fn_vgnca

Update		@tbinfoAfiliado
Set			cdgo_cdd		= c.cdgo_cdd,
			dscrpcn_cdd		= c.dscrpcn_cdd,
			dscrpcn_dprtmnto	= d.dscrpcn_dprtmnto
from		@tbinfoAfiliado										i
Inner Join	bdAfiliacionValidador.dbo.tbCiudades_Vigencias		c	With(NoLock)	On	i.cnsctvo_cdgo_cdd_rsdnca	= c.cnsctvo_cdgo_cdd
Inner Join	bdAfiliacionValidador.dbo.tbDepartamentos_Vigencias	d	With(NoLock)	On	c.cnsctvo_cdgo_dprtmnto		= d.cnsctvo_cdgo_dprtmnto
Where		@fcha_vldcn between c.inco_vgnca and c.fn_vgnca
And			@fcha_vldcn between d.inco_vgnca and d.fn_vgnca

--Feb/02/2009 actualizar Semanas Cotizadas  de acuerdo a la fecha de validacion (sisatv01) 
Update		@tbinfoAfiliado
Set			smns_ctzds	= rtrim(ltrim(b.vlr_cmpo))
From		bdAfiliacionValidador.dbo.tbHistoricoBeneficiariosValidador	b	With(NoLock)
INNER JOIN	@tbinfoAfiliado												t					On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																							And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																							And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
Where		b.dscrpcn_cmpo			= 'smns_ctzds'
And			@fcha_vldcn between b.inco_vgnca and b.fn_vgnca

Select Top 1 cnsctvo_cdgo_tpo_cntrto,			nmro_cntrto,			nmro_unco_idntfccn_afldo,				cnsctvo_cdgo_estdo_cvl,
			cnsctvo_cdgo_cdd_rsdnca,			drccn_rsdnca,			tlfno_rsdnca,							cnsctvo_cdgo_afp,
			cdgo_cdd,							cdgo_ips,				cnsctvo_cdgo_brro,						cdgo_brro,
			ctza,								cdgo_estdo_cvl,			dscrpcn_estdo_cvl,						nmbre_scrsl_ips,
			cdgo_afp,							dscrpcn_afp,			dscrpcn_brro,							dscrpcn_cdd,
			dscrpcn_dprtmnto,					smns_ctzds,				inco_vgnca_bnfcro,						fn_vgnca_bnfcro,
			cnsctvo_bnfcro,						eml,					dscrpcn_cmna
From		@tbinfoAfiliado


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmDatosAdicionalesAfiliado] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmDatosAdicionalesAfiliado] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmDatosAdicionalesAfiliado] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmDatosAdicionalesAfiliado] TO [portal_rol]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmDatosAdicionalesAfiliado] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmDatosAdicionalesAfiliado] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmDatosAdicionalesAfiliado] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmDatosAdicionalesAfiliado] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmDatosAdicionalesAfiliado] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmDatosAdicionalesAfiliado] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmDatosAdicionalesAfiliado] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmDatosAdicionalesAfiliado] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmDatosAdicionalesAfiliado] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmDatosAdicionalesAfiliado] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmDatosAdicionalesAfiliado] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmDatosAdicionalesAfiliado] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmDatosAdicionalesAfiliado] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmDatosAdicionalesAfiliado] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmDatosAdicionalesAfiliado] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmDatosAdicionalesAfiliado] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

