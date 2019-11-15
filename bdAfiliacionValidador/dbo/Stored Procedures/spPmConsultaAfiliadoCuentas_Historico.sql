/*---------------------------------------------------------------------------------------------------------------------------------------
* Procedimiento			: spPmConsultaAfiliadoCuentas_Historico
* Desarrollado por		: <\A Ing. Samuel Muñoz							A\>
* Descripción			: <\D									D\>
* Observaciones			: <\O									O\>
* Parámetros			: <\P  									P\>
* Variables			: <\V  									V\>
* Fecha Creación		: <\FC 2003/00/00  							FC\>
*
*---------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------------------------------------------------------------
* Modificado Por			: <\AM Ing. Cesar García																	AM\>
* Descripcion				:	Se ajusta procedimiento incluyendo la consulta de las vigencias de los beneficiarios
							: <\PM  																					PM\>
* Nuevas Variables			: <\VM  																					VM\>
* Fecha Modificación		: <\FM	2015-04-29																			FM\>
*---------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------------------------------------------------------------
* Modificado Por			: <\AM Ing. Cesar García																	AM\>
* Descripcion				:	Se ajusta procedimiento incluyendo el cálculo de causa y estado de derecho para usuarios
								marcados como no existentes en el sistema
							: <\PM  																					PM\>
* Nuevas Variables			: <\VM  																					VM\>
* Fecha Modificación		: <\FM	2015-05-21																			FM\>
*-----------------------------------------------------------------------------------------------------------------------------------*/
/*
Declare
@m	varchar(80),
@f	datetime
--Exec spPmConsultaAfiliado_Historico 1,'16686026',1,'2004/04/21',@m,@f
Exec spPmConsultaAfiliadoCuentas_Historico 2,'95022220323',1,'2013/07/01',@m,@f
print @m
print @f
*/
CREATE	procedure [dbo].[spPmConsultaAfiliadoCuentas_Historico]
@cnsctvo_cdgo_tpo_idntfccn 	udtConsecutivo, 
@nmro_idntfccn			Varchar(23), 	--udtNumeroIdentificacion,
@cnsctvo_cdgo_pln 		udtConsecutivo, 
@fcha_vldccn			datetime	= NULL,
@mnsje					varchar(80)	output,
@lfFechaReferencia		datetime	output

AS
Set NoCount On
-- Declaración de variables

Declare
@Nui_Afldo					UdtConsecutivo,
@Bd 						char(1),
@inco_vgnca_bnfcro			Datetime,
@fcha_ultma_mdfccn			Datetime,	
--@lfFechaReferencia	datetime,
@dFcha_pvte					datetime,
@Historico					char(1),
@fecha_minima				datetime,
@maximafechabeneficiario	datetime

/*
--test
@cnsctvo_cdgo_tpo_idntfccn 	udtConsecutivo, 
@nmro_idntfccn				Varchar(23), 	--udtNumeroIdentificacion,
@cnsctvo_cdgo_pln 			udtConsecutivo, 
@fcha_vldccn				datetime,
@mnsje						varchar(80)  ,
@lfFechaReferencia			datetime 

set @cnsctvo_cdgo_tpo_idntfccn=2
set @nmro_idntfccn=95022220323
Set @cnsctvo_cdgo_pln=1
set @fcha_vldccn='2013/07/01'
set @lfFechaReferencia='2013/07/01'*/

Set	@Bd = null

If @Bd Is Null
	Begin
		Select		@Nui_Afldo	=	a.nmro_unco_idntfccn_afldo
		From		bdAfiliacionValidador.DBO.tbBeneficiariosValidador	a	With(NoLock)
		Inner Join	bdAfiliacionValidador.DBO.tbContratosValidador		b	With(NoLock)	On	b.nmro_cntrto				=	a.nmro_cntrto
																							And	b.cnsctvo_cdgo_tpo_cntrto	=	a.cnsctvo_cdgo_tpo_cntrto
		Inner Join	dbo.tbVigenciasBeneficiariosValidador				c	With(NoLock)	On	c.cnsctvo_cdgo_tpo_cntrto	=	a.cnsctvo_cdgo_tpo_cntrto
																							And	c.nmro_cntrto				=	a.nmro_cntrto
																							And	c.cnsctvo_bnfcro			=	a.cnsctvo_bnfcro
		Where		a.cnsctvo_cdgo_tpo_idntfccn	= @cnsctvo_cdgo_tpo_idntfccn
		And			a.nmro_idntfccn				= @nmro_idntfccn
		And			b.cnsctvo_cdgo_pln			= @cnsctvo_cdgo_pln
		And			@fcha_vldccn Between c.inco_vgnca_estdo_bnfcro And c.fn_vgnca_estdo_bnfcro
		--And	@fcha_vldccn Between a.inco_vgnca_bnfcro And a.fn_vgnca_bnfcro
		
		If @@Rowcount>0	
			Begin
				Select @Bd 	= '1'  -- Contratos
				Select @mnsje 	= 'CONTRATOS HISTORICOS'
			End
		Else
			Begin
				select	@Nui_Afldo	=	nmro_unco_idntfccn_afldo
				from	bdsisalud..tbactua	With(NoLock)
				where	cnsctvo_cdgo_tpo_idntfccn	=	@cnsctvo_cdgo_tpo_idntfccn
				And		nmro_idntfccn				=	@nmro_idntfccn

				If  Exists (	Select		1 
								from		bdAfiliacionValidador.DBO.tbBeneficiariosValidador	a	With(NoLock)
								Inner Join	bdAfiliacionValidador.DBO.tbContratosValidador		b	With(NoLock)	On	b.nmro_cntrto				=	a.nmro_cntrto
																													And	b.cnsctvo_cdgo_tpo_cntrto	=	a.cnsctvo_cdgo_tpo_cntrto
								Inner Join	dbo.tbVigenciasBeneficiariosValidador				c	With(NoLock)	On	c.cnsctvo_cdgo_tpo_cntrto	=	a.cnsctvo_cdgo_tpo_cntrto
																													And	c.nmro_cntrto				=	a.nmro_cntrto
																													And	c.cnsctvo_bnfcro			=	a.cnsctvo_bnfcro
								Where		a.nmro_unco_idntfccn_afldo	=	@Nui_Afldo
								And			b.cnsctvo_cdgo_pln			=	@cnsctvo_cdgo_pln
								And			@fcha_vldccn Between c.inco_vgnca_estdo_bnfcro And c.fn_vgnca_estdo_bnfcro
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
			End
	End
Else
	Begin
		Select @mnsje	=	Case	@bd	When	'1' Then 'CONTRATOS'
										When	'2' Then 'FAMISANAR'
										When	'3' Then 'FORMULARIOS'
										When	'4' Then 'NO EXISTE EN EL SISTEMA'
							End
	End

Declare @tb_tmpAfiliado Table
		(	prmr_aplldo			char(50),		sgndo_aplldo			char(50),		
			prmr_nmbre			char(20),		sgndo_nmbre			char(20),		
			cnsctvo_cdgo_tpo_idntfccn	int,			nmro_idntfccn			varchar(23),
			fcha_ncmnto			datetime,		cnsctvo_cdgo_sxo		int,
			cdgo_sxo			char(2),		edd 				int,
			edd_mss 			int,			edd_ds 				int,
			cnsctvo_cdgo_tpo_undd		int,			orgn				char(1),
			cnsctvo_cdgo_tpo_cntrto		int,
			nmro_cntrto			char(15),		cnsctvo_cdgo_pln		int,
			nmro_unco_idntfccn_afldo	int,			inco_vgnca_bnfcro		datetime,		
			fn_vgnca_bnfcro			datetime,
			cnsctvo_cdgo_prntsco		int,			dscrpcn_prntsco			varchar(150),
			cnsctvo_cdgo_tpo_afldo 		int, 			dscrpcn_tpo_afldo		varchar(150),
			cnsctvo_cdgo_rngo_slrl 		int,			dscrpcn_rngo_slrl 		varchar(150),		
			cnsctvo_cdgo_pln_pc		int,			dscrpcn_pln_pc			varchar(150),		
			smns_ctzds_ss_ps		int,			smns_ctzds_eps_ps		int,
			smns_ctzds_ss_pc		int,			smns_ctzds_eps_pc		int,			
			cdgo_ips_prmra			char(8),		dscrpcn_ips_prmra		varchar(150),	
			cnsctvo_bnfcro			int,
			cdgo_eapb			varchar(3) null,	nmro_unco_idntfccn_ctznte 	int,		
			cnsctvo_cdgo_tpo_cntrto_psc	int,			nmro_cntrto_psc			char(15),
			ds_ctzds			numeric,		cnsctvo_cdgo_sde_ips		int default 0,		
			dscrpcn_tpo_cntrto		varchar(150),
			cnsctvo_cdgo_csa_drcho		int,			cnsctvo_cdgo_estdo_drcho	int,
			dscrpcn_estdo_drcho		varchar(150),		dscrpcn_csa_drcho		varchar(150),
			dscrpcn_drcho			varchar(150),
			dscrpcn_pln			varchar(150),		dscrpcn_tpo_ctznte		varchar(150),
			prmr_nmbre_ctznte		char(20),		sgndo_nmbre_ctznte		char(20),
			prmr_aplldo_ctznte		char(50),		sgndo_aplldo_ctznte		char(50),
			drccn_rsdnca			varchar(80),		tlfno_rsdnca			char(30),
			cnsctvo_cdgo_cdd_rsdnca 	int,			dscrpcn_cdd_rsdnca 		varchar(150),
			cnsctvo_cdgo_estdo_cvl 		int,			dscrpcn_estdo_cvl 		varchar(150),
			cnsctvo_cdgo_tpo_frmlro		Int,			nmro_frmlro			Char(15),
			cdgo_tpo_idntfccn		char(3),		cnsctvo_cdgo_afp		int,
			fcha_dsde			datetime,		fcha_hsta			datetime,
			flg_enble_nmro_vldcn		char default 'N',	drcho				char,
			cdgo_afp			char(8),
			cnsctvo_tpo_vldcn_actva		int Default 3,		cfcha_ncmnto			char(10),
			smns_aflcn_ss_ps		int DEFAULT 0,		smns_aflcn_eps_ps		int DEFAULT 0,
			smns_aflcn_ss_pc		int DEFAULT 0,		smns_aflcn_eps_pc		int DEFAULT 0,
			smns_ctzds_eps			int DEFAULT 0,		cdgo_tpo_prntsco  		char(3),
			cdgo_cdd 			char(8) , 		cdgo_rngo_slrl 			char(3),
			cdgo_tpo_afldo 			char(3) , 		cdgo_tpo_idntfccn_ctznte 	char(3),
			nmro_idntfccn_ctznte 		char(15),		cnsctvo_tpo_idntfccn_ctznte	int,
			cnsctvo_dcmnto_gnrdo		int DEFAULT 0,		nmro_dcmnto			Char(50) DEFAULT '',
			cdgo_estdo_drcho		char(2) ,
			eml varchar(50),  --Adicion de Campo 2009/12/11 sisatv01
			ordenamientoxestado int
		)

Set		@lfFechaReferencia = @fcha_vldccn

--Set	@bd = '1'
--Set @mnsje = 'CONTRATOS'

If  @Bd = '1' -- Contratos
	Begin
		Insert Into @tb_tmpAfiliado(
		prmr_aplldo,			sgndo_aplldo,			prmr_nmbre,
		sgndo_nmbre,			cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
		fcha_ncmnto,			cnsctvo_cdgo_sxo,		orgn,
		cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,			cnsctvo_cdgo_pln,
		nmro_unco_idntfccn_afldo,	inco_vgnca_bnfcro,		fn_vgnca_bnfcro,
		cnsctvo_cdgo_prntsco,		cnsctvo_cdgo_tpo_afldo,		cnsctvo_cdgo_rngo_slrl,
		/*smns_ctzds_ss_ps,		smns_ctzds_eps_ps,*/		cdgo_ips_prmra,
		cnsctvo_bnfcro,			cnsctvo_cdgo_afp,
		fcha_dsde,			fcha_hsta,
		tlfno_rsdnca,			drccn_rsdnca,			cnsctvo_cdgo_cdd_rsdnca,
		eml
		)
		Select		b.prmr_aplldo,	b.sgndo_aplldo,	b.prmr_nmbre,
					b.sgndo_nmbre,			b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,
					b.fcha_ncmnto,			b.cnsctvo_cdgo_sxo,		'1',
					b.cnsctvo_cdgo_tpo_cntrto,	b.nmro_cntrto,			c.cnsctvo_cdgo_pln,
					b.nmro_unco_idntfccn_afldo,	v.inco_vgnca_estdo_bnfcro,		v.fn_vgnca_estdo_bnfcro,
					b.cnsctvo_cdgo_prntsco,		b.cnsctvo_cdgo_tpo_afldo,	c.cnsctvo_cdgo_rngo_slrl,
					/*b.smns_ctzds,			b.smns_ctzds_antrr_eps,*/		b.cdgo_intrno,
					b.cnsctvo_bnfcro,		c.cnsctvo_cdgo_afp,
					b.inco_vgnca_bnfcro,		b.fn_vgnca_bnfcro,
					b.tlfno_rsdnca,			b.drccn_rsdnca,			b.cnsctvo_cdgo_cdd_rsdnca,
					isnull(b.eml,'') as eml
		From		tbBeneficiariosValidador				b	With(NoLock)
		INNER JOIN	tbContratosValidador					c	With(NoLock)	On	b.nmro_cntrto				=	c.nmro_cntrto
																				And	b.cnsctvo_cdgo_tpo_cntrto	=	c.cnsctvo_cdgo_tpo_cntrto
		Inner Join	dbo.tbVigenciasBeneficiariosValidador	v	With(NoLock)	On	v.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
																				And	v.nmro_cntrto				=	b.nmro_cntrto
																				And	v.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro
		Where		c.cnsctvo_cdgo_pln			=	@cnsctvo_cdgo_pln
		And			b.nmro_unco_idntfccn_afldo	=	@Nui_Afldo
		And			@fcha_vldccn Between v.inco_vgnca_estdo_bnfcro And v.fn_vgnca_estdo_bnfcro
	
		Update		@tb_tmpAfiliado
		Set			cdgo_ips_prmra	= rtrim(ltrim(b.vlr_cmpo))
		From		bdAfiliacionValidador..tbHistoricoBeneficiariosValidador	b	With(NoLock)
		INNER JOIN	@tb_tmpAfiliado												t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																					And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																					And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
		Where		b.dscrpcn_cmpo			= 'cdgo_intrno'
		And			@fcha_vldccn between b.inco_vgnca and b.fn_vgnca

		IF @@RowCount = 0
			Begin
				Select		@fecha_minima = min(b.inco_vgnca)
				From		bdAfiliacionValidador..tbHistoricoBeneficiariosValidador	b	With(NoLock)
				Inner Join	@tb_tmpAfiliado												t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																							And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																							And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
				Where		b.dscrpcn_cmpo	= 'cdgo_intrno'
				and			b.inco_vgnca	> @fcha_vldccn

				Update		@tb_tmpAfiliado
				Set			cdgo_ips_prmra	= rtrim(ltrim(b.vlr_cmpo))
				From		bdAfiliacionValidador..tbHistoricoBeneficiariosValidador	b	With(NoLock)
				INNER JOIN	@tb_tmpAfiliado												t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																							And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																							And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
				Where		b.dscrpcn_cmpo			= 'cdgo_intrno'
				And			@fecha_minima	between	b.inco_vgnca	and	b.fn_vgnca
			End
	
		Update		@tb_tmpAfiliado
		Set			cnsctvo_cdgo_prntsco	= rtrim(ltrim(b.vlr_cmpo))
		From		bdAfiliacionValidador..tbHistoricoBeneficiariosValidador	b	With(NoLock)
		INNER JOIN	@tb_tmpAfiliado												t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																					And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																					And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
		Where		b.dscrpcn_cmpo			= 'cnsctvo_cdgo_prntsco'
		And			@fcha_vldccn between b.inco_vgnca and b.fn_vgnca

		IF @@RowCount = 0
			BEGIN
				select		@fecha_minima = min(b.inco_vgnca)
				From		bdAfiliacionValidador..tbHistoricoBeneficiariosValidador	b	With(NoLock)
				INNER JOIN	@tb_tmpAfiliado												t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																							And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																							And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
				Where		b.dscrpcn_cmpo			= 'cnsctvo_cdgo_prntsco'
				and			b.inco_vgnca > @fcha_vldccn

				Update		@tb_tmpAfiliado
				Set			cnsctvo_cdgo_prntsco	= rtrim(ltrim(b.vlr_cmpo))
				From		bdAfiliacionValidador..tbHistoricoBeneficiariosValidador	b	With(NoLock)
				INNER JOIN	@tb_tmpAfiliado												t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																							And		b.nmro_cntrto			= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																							And		b.cnsctvo_bnfcro		= t.cnsctvo_bnfcro
				Where		b.dscrpcn_cmpo			= 'cnsctvo_cdgo_prntsco'
				And			@fecha_minima	between	b.inco_vgnca	and	b.fn_vgnca
			END
	
		Update		@tb_tmpAfiliado
		Set			cnsctvo_cdgo_tpo_afldo	= rtrim(ltrim(b.vlr_cmpo))
		From		bdAfiliacionValidador..tbHistoricoBeneficiariosValidador	b	With(NoLock)
		INNER JOIN	@tb_tmpAfiliado												t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																					And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																					And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
		Where		b.dscrpcn_cmpo			= 'cnsctvo_cdgo_tpo_afldo'
		And			@fcha_vldccn between b.inco_vgnca and b.fn_vgnca
	
		IF @@RowCount = 0
			BEGIN
				select		@fecha_minima = min(b.inco_vgnca)
				From		bdAfiliacionValidador..tbHistoricoBeneficiariosValidador	b	With(NoLock)
				INNER JOIN	@tb_tmpAfiliado												t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																							And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																							And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
				Where		b.dscrpcn_cmpo			= 'cnsctvo_cdgo_tpo_afldo'
				and			b.inco_vgnca > @fcha_vldccn

				Update		@tb_tmpAfiliado
				Set			cnsctvo_cdgo_tpo_afldo	= rtrim(ltrim(b.vlr_cmpo))
				From		bdAfiliacionValidador..tbHistoricoBeneficiariosValidador	b	With(NoLock)
				INNER JOIN	@tb_tmpAfiliado												t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																							And		b.nmro_cntrto			= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																							And		b.cnsctvo_bnfcro		= t.cnsctvo_bnfcro
				Where		b.dscrpcn_cmpo			= 'cnsctvo_cdgo_tpo_afldo'
				And			@fecha_minima between b.inco_vgnca and b.fn_vgnca
			END

		Update		@tb_tmpAfiliado
		Set			fcha_ncmnto	= rtrim(ltrim(b.vlr_cmpo))
		From		bdAfiliacionValidador..tbHistoricoBeneficiariosValidador	b	With(NoLock)
		INNER JOIN	@tb_tmpAfiliado												t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																					And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																					And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
		Where		b.dscrpcn_cmpo			= 'fcha_ncmnto'
		And			@fcha_vldccn between b.inco_vgnca and b.fn_vgnca

		IF @@RowCount = 0
			BEGIN
				select		@fecha_minima = min(b.inco_vgnca)
				From		bdAfiliacionValidador..tbHistoricoBeneficiariosValidador	b	With(NoLock)
				INNER JOIN	@tb_tmpAfiliado												t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																							And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																							And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
				Where		b.dscrpcn_cmpo			= 'fcha_ncmnto'
				and			b.inco_vgnca > @fcha_vldccn

				Update		@tb_tmpAfiliado
				Set			fcha_ncmnto	= rtrim(ltrim(b.vlr_cmpo))
				From		bdAfiliacionValidador..tbHistoricoBeneficiariosValidador	b	With(NoLock)
				INNER JOIN	@tb_tmpAfiliado												t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																							And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																							And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
				Where		b.dscrpcn_cmpo			= 'fcha_ncmnto'
				And			@fecha_minima between b.inco_vgnca and b.fn_vgnca
			END
	
		Update		@tb_tmpAfiliado
		Set			smns_ctzds_ss_ps	= rtrim(ltrim(b.vlr_cmpo))
		From		bdAfiliacionValidador..tbHistoricoBeneficiariosValidador	b	With(NoLock)
		INNER JOIN	@tb_tmpAfiliado												t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																					And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																					And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
		Where		b.dscrpcn_cmpo			= 'smns_ctzds'
		And			@fcha_vldccn between b.inco_vgnca and b.fn_vgnca

		IF @@RowCount = 0
			BEGIN
				select		@fecha_minima = min(b.inco_vgnca)
				From		bdAfiliacionValidador..tbHistoricoBeneficiariosValidador	b	With(NoLock)
				INNER JOIN	@tb_tmpAfiliado												t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																							And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																							And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
				Where		b.dscrpcn_cmpo			= 'smns_ctzds'
				and			b.inco_vgnca > @fcha_vldccn

				Update		@tb_tmpAfiliado
				Set			smns_ctzds_ss_ps	= rtrim(ltrim(b.vlr_cmpo))
				From		bdAfiliacionValidador..tbHistoricoBeneficiariosValidador	b	With(NoLock)
				INNER JOIN	@tb_tmpAfiliado												t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																							And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																							And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
				Where	b.dscrpcn_cmpo			= 'smns_ctzds'
				And		@fecha_minima between b.inco_vgnca and b.fn_vgnca
			END
	
		Update		@tb_tmpAfiliado
		Set			smns_ctzds_eps_ps	= rtrim(ltrim(b.vlr_cmpo))
		From		bdAfiliacionValidador..tbHistoricoBeneficiariosValidador	b	With(NoLock)
		INNER JOIN	@tb_tmpAfiliado												t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																					And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																					And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
		Where		b.dscrpcn_cmpo			= 'smns_ctzds_antrr_eps'
		And			@fcha_vldccn between b.inco_vgnca and b.fn_vgnca

		IF @@RowCount = 0
			BEGIN
				select		@fecha_minima = min(b.inco_vgnca)
				From		bdAfiliacionValidador..tbHistoricoBeneficiariosValidador	b	With(NoLock)
				INNER JOIN	@tb_tmpAfiliado												t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																							And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																							And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
				Where		b.dscrpcn_cmpo			= 'smns_ctzds_antrr_eps'
				and			b.inco_vgnca > @fcha_vldccn

				Update		@tb_tmpAfiliado
				Set			smns_ctzds_eps_ps	= rtrim(ltrim(b.vlr_cmpo))
				From		bdAfiliacionValidador..tbHistoricoBeneficiariosValidador	b	With(NoLock)
				INNER JOIN	@tb_tmpAfiliado												t	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																							And	b.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
																							And	b.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
				Where		b.dscrpcn_cmpo			= 'smns_ctzds_antrr_eps'
				And			@fecha_minima between b.inco_vgnca and b.fn_vgnca
			END
	
		Update		@tb_tmpAfiliado
		Set			cnsctvo_cdgo_rngo_slrl	= rtrim(ltrim(c.vlr_cmpo))
		From		bdAfiliacionValidador..tbHistoricoContratosValidador	c	With(NoLock)
		INNER JOIN	@tb_tmpAfiliado											t	On	c.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																				And	c.nmro_cntrto				= t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
		Where		c.dscrpcn_cmpo			= 'cnsctvo_cdgo_rngo_slrl'
		And			@fcha_vldccn between c.inco_vgnca and c.fn_vgnca
	
		Update		@tb_tmpAfiliado
		Set			cnsctvo_cdgo_estdo_drcho	= m.cnsctvo_cdgo_estdo_drcho,
					cnsctvo_cdgo_csa_drcho		= m.cnsctvo_cdgo_csa_drcho,
					dscrpcn_csa_drcho		= isnull(c.dscrpcn_csa_drcho,' ')
		From		@tb_tmpAfiliado				t
		INNER JOIN	TbMatrizDerechosValidador	m	With(NoLock)	On	m.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																	And	m.nmro_cntrto				= t.nmro_cntrto --COLLATE SQL_Latin1_General_CP1_CI_AS              
																	And	m.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
		INNER JOIN	tbCausasDerechoValidador	c	With(NoLock)	On	m.cnsctvo_cdgo_estdo_drcho	= c.cnsctvo_cdgo_estdo_drcho
																	And	m.cnsctvo_cdgo_csa_drcho	= c.cnsctvo_cdgo_csa_drcho              
		Where		@fcha_vldccn Between inco_vgnca_estdo_drcho And	fn_vgnca_estdo_drcho
	
		IF @@RowCount = 0
			Begin
				Update		@tb_tmpAfiliado
				Set			cnsctvo_cdgo_estdo_drcho	= m.cnsctvo_cdgo_estdo_drcho,
							cnsctvo_cdgo_csa_drcho		= m.cnsctvo_cdgo_csa_drcho,
							dscrpcn_csa_drcho		= isnull(c.dscrpcn_csa_drcho,' ')
				From		@tb_tmpAfiliado					t
				INNER JOIN	TbMatrizDerechosValidador_at	m	With(NoLock)	On	m.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																				And	m.nmro_cntrto				= t.nmro_cntrto --COLLATE SQL_Latin1_General_CP1_CI_AS              
																				And	m.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
				INNER JOIN	tbCausasDerechoValidador		c	With(NoLock)	On	m.cnsctvo_cdgo_estdo_drcho	= c.cnsctvo_cdgo_estdo_drcho
																				And	m.cnsctvo_cdgo_csa_drcho	= c.cnsctvo_cdgo_csa_drcho              
				Where		@fcha_vldccn Between inco_vgnca_estdo_drcho And	fn_vgnca_estdo_drcho
			End
	
		Update		@tb_tmpAfiliado
		Set			prmr_nmbre_ctznte	= b.prmr_aplldo,
					sgndo_nmbre_ctznte	= b.sgndo_aplldo,
					prmr_aplldo_ctznte	= b.prmr_nmbre,
					sgndo_aplldo_ctznte	= b.sgndo_nmbre,
					cnsctvo_tpo_idntfccn_ctznte	= b.cnsctvo_cdgo_tpo_idntfccn,
					nmro_idntfccn_ctznte		= b.nmro_idntfccn
		From		@tb_tmpAfiliado				a
		INNER JOIN	tbBeneficiariosValidador	b	With(NoLock)	On	a.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
																	And	a.nmro_cntrto				= b.nmro_cntrto
		Where		b.cnsctvo_bnfcro		= 1
	
		Update		@tb_tmpAfiliado
		Set			cnsctvo_cdgo_pln_pc	= c.cnsctvo_cdgo_pln,
					smns_ctzds_ss_pc	= b.smns_ctzds,
					smns_ctzds_eps_pc	= b.smns_ctzds_antrr_eps
		From		tbContratosValidador					c	With(NoLock)
		INNER JOIN	tbBeneficiariosValidador				b	With(NoLock)	On	b.cnsctvo_cdgo_tpo_cntrto	=	c.cnsctvo_cdgo_tpo_cntrto
																				And	b.nmro_cntrto				=	c.nmro_cntrto
		Inner Join	dbo.tbVigenciasBeneficiariosValidador	v	With(NoLock)	On	v.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
																				And	v.nmro_cntrto				=	b.nmro_cntrto
																				And	v.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro
		INNER JOIN	@tb_tmpAfiliado							t					On	t.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn_afldo
		Where		c.cnsctvo_cdgo_tpo_cntrto	=  2--t.cnsctvo_cdgo_pln
		And			@fcha_vldccn Between v.inco_vgnca_estdo_bnfcro And v.fn_vgnca_estdo_bnfcro
	
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
		INNER JOIN	tbParentescos_vigencias p	With(NoLock)	On	t.cnsctvo_cdgo_prntsco = p.cnsctvo_cdgo_prntscs
		Where		@fcha_vldccn Between p.inco_vgnca And p.fn_vgnca
	
		Update		@tb_tmpAfiliado
		Set 		dscrpcn_tpo_afldo = a.dscrpcn,
					cdgo_tpo_afldo	  = a.cdgo_tpo_afldo 
		From		@tb_tmpAfiliado				t
		INNER JOIN	tbTiposAfiliado_vigencias	a	With(NoLock)	On	t.cnsctvo_cdgo_tpo_afldo	= a.cnsctvo_cdgo_tpo_afldo
		Where		@fcha_vldccn Between inco_vgnca And fn_vgnca
	
		Update		@tb_tmpAfiliado
		Set 		dscrpcn_rngo_slrl = r.dscrpcn_rngo_slrl,
					cdgo_rngo_slrl	  = r.cdgo_rngo_slrl 
		From		@tb_tmpAfiliado					t
		INNER JOIN	tbRangosSalariales_vigencias	r	With(NoLock)	On	t.cnsctvo_cdgo_rngo_slrl	= r.cnsctvo_cdgo_rngo_slrl
		Where		@fcha_vldccn Between r.inco_vgnca And r.fn_vgnca
	
		Update		@tb_tmpAfiliado
		Set			dscrpcn_pln_pc = isnull(p.dscrpcn_pln,'') 
		From		@tb_tmpAfiliado		t
		INNER JOIN	tbPlanes_vigencias	p	With(NoLock)	On	t.cnsctvo_cdgo_pln_pc = p.cnsctvo_cdgo_pln
	
		Update		@tb_tmpAfiliado
		Set			dscrpcn_ips_prmra = i.nmbre_scrsl
		From		@tb_tmpAfiliado						t
		INNER JOIN	bdSISalud..tbIpsPrimarias_vigencias i	With(NoLock)	On	t.cdgo_ips_prmra	= i.cdgo_intrno --COLLATE SQL_Latin1_General_CP1_CI_AS
	
		Update		@tb_tmpAfiliado
		Set 		dscrpcn_estdo_drcho		= edv.dscrpcn_estdo_drcho,
					dscrpcn_drcho			= edv.dscrpcn_drcho,
					cnsctvo_cdgo_estdo_drcho	= edv.cnsctvo_cdgo_estdo_drcho,
					cdgo_estdo_drcho		= edv.cdgo_estdo_drcho
		From		tbEstadosDerechoValidador	edv	With(NoLock)
		INNER JOIN	@tb_tmpAfiliado				a	On	a.cnsctvo_cdgo_estdo_drcho 	= edv.cnsctvo_cdgo_estdo_drcho
	
		Update		@tb_tmpAfiliado
		Set			cdgo_tpo_idntfccn	= i.cdgo_tpo_idntfccn
		From		@tb_tmpAfiliado					t
		INNER JOIN	tbTiposIdentificacion_vigencias i	With(NoLock)	On	t.cnsctvo_cdgo_tpo_idntfccn	= i.cnsctvo_cdgo_tpo_idntfccn
		Where		@fcha_vldccn Between i.inco_vgnca And i.fn_vgnca
	
		Update		@tb_tmpAfiliado
		Set			cdgo_tpo_idntfccn_ctznte	= i.cdgo_tpo_idntfccn
		From		@tb_tmpAfiliado					t
		INNER JOIN	tbTiposIdentificacion_vigencias i	With(NoLock)	On	t.cnsctvo_tpo_idntfccn_ctznte	= i.cnsctvo_cdgo_tpo_idntfccn
		Where		@fcha_vldccn Between i.inco_vgnca And i.fn_vgnca
	
		Update		@tb_tmpAfiliado
		Set			cdgo_sxo	= s.cdgo_sxo
		From		@tb_tmpAfiliado		t
		INNER JOIN	tbSexos_vigencias	s	With(NoLock)	On	t.cnsctvo_cdgo_sxo	= s.cnsctvo_cdgo_sxo
		Where		@fcha_vldccn Between s.inco_vgnca And s.fn_vgnca
	
		Update		@tb_tmpAfiliado
		Set			dscrpcn_pln	= p.dscrpcn_pln
		From		@tb_tmpAfiliado t
		INNER JOIN	tbPlanes		p	With(NoLock)	On	t.cnsctvo_cdgo_pln	= p.cnsctvo_cdgo_pln
	
		--cnsctvo_cdgo_sde_ips
		Update		@tb_tmpAfiliado
		Set			cnsctvo_cdgo_sde_ips	= d.cnsctvo_cdgo_sde
		From		bdSISalud..tbDireccionesPrestador	d	With(NoLock)
		INNER JOIN	@tb_tmpAfiliado						t	On	d.cdgo_intrno	= t.cdgo_ips_prmra
	
		--cnsctvo_cdgo_sde_ips para afiliado PAC
		Update		@tb_tmpAfiliado
		set			cnsctvo_cdgo_sde_ips  = c.cnsctvo_sde_inflnca
		from		@tb_tmpAfiliado									t
		INNER JOIN	bdAfiliacionvalidador.dbo.tbCiudades_Vigencias	c	With(NoLock)	On	t.cnsctvo_cdgo_cdd_rsdnca = c.cnsctvo_cdgo_cdd 
		Where		t.cnsctvo_cdgo_tpo_cntrto=2  --Solo Para Plan PAC
	
		Update		@tb_tmpAfiliado
		Set			cdgo_afp	= cdgo_entdd
		From		tbEntidades_Vigencias	e	With(NoLock)
		INNER JOIN	@tb_tmpAfiliado			t	On	t.cnsctvo_cdgo_afp	= e.cnsctvo_cdgo_entdd
		Where		@fcha_vldccn Between e.inco_vgnca And e.fn_vgnca
	
		Update		@tb_tmpAfiliado
		Set			cfcha_ncmnto	= convert(char(10),fcha_ncmnto,111)
	
		Select		@lfFechaReferencia	= fn_vgnca_bnfcro
		From		@tb_tmpAfiliado
		Where		fn_vgnca_bnfcro	< @fcha_vldccn
	End
--*******************************************************************************************************************************
If  @bd = '2' --Formularios
	Begin
	
/*
--Consulta el código del origen por el cual se realizo la consulta
	Select  @cdgo_orgn = cdgo_orgn
	From	bdSiSalud.dbo.tbDetalleOrigenBaseDatos
	where	cnsctvo_orgn = @bd*/

		INSERT INTO @tb_tmpAfiliado
				(
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
				cnsctvo_cdgo_prntsco
				) 	
		SELECT	a.nmro_idntfccn_bnfcro, -- AS nmro_idntfccn_afldo, 
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
		FROM 	bdAfiliacionValidador.dbo.tbBeneficiariosFormularioValidador a	With(NoLock)
		WHERE 	a.cnsctvo_tpo_idntfccn_bnfcro 	= @cnsctvo_cdgo_tpo_idntfccn 
		AND 	a.nmro_idntfccn_bnfcro 			= @nmro_idntfccn
		And		a.cnsctvo_cdgo_pln				= @cnsctvo_cdgo_pln
		And		@fcha_vldccn					>= a.inco_vgnca_bnfcro
		And		@fcha_vldccn					<= a.fcha_hsta
		--		And	(@fcha_vldccn Between a.fcha_dsde and a.fcha_hsta)
	End
--*******************************************************************************************************************************
if @Bd = '3' --Otras Eps (Famisanar)
	Begin
		Insert Into @tb_tmpAfiliado
					(	prmr_aplldo, 			sgndo_aplldo, 			prmr_nmbre, 
						sgndo_nmbre, 			cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
						fcha_ncmnto, 			cdgo_sxo,			cnsctvo_cdgo_sxo,
						cnsctvo_cdgo_prntsco,		cnsctvo_cdgo_pln,		cnsctvo_cdgo_tpo_afldo,
						cnsctvo_cdgo_rngo_slrl,		inco_vgnca_bnfcro,		fn_vgnca_bnfcro,
						smns_aflcn_eps_ps,		smns_aflcn_ss_ps,		smns_aflcn_eps_pc,
						smns_aflcn_ss_pc,		cnsctvo_cdgo_estdo_drcho,	cdgo_ips_prmra,
						cdgo_eapb,			cnsctvo_cdgo_tpo_cntrto, 	nmro_cntrto,
						orgn,				fcha_dsde,			fcha_hsta,
						tlfno_rsdnca,			drccn_rsdnca
					)
		Select 			a.prmr_aplldo_bnfcro, 		isnull(a.sgndo_aplldo_bnfcro,'') as sgndo_aplldo_bnfcro,	a.prmr_nmbre_bnfcro,
						a.sgndo_nmbre_bnfcro, 		a.cnsctvo_cdgo_tpo_idntfccn_bnfcro,	a.nmro_idntfccn_bnfcro,
						a.fcha_ncmnto, 			a.sxo,				a.cnsctvo_cdgo_sxo,
						a.cnsctvo_cdgo_prntscs,		a.cnsctvo_cdgo_pln,		a.cnsctvo_cdgo_tpo_afldo,
						a.cnsctvo_cdgo_rngo_slrl,	convert(char(10),a.inco_vgnca, 111) as inco_vgnca,		convert(char(10),a.fn_vgnca, 111) as fn_vgnca,
						0,				a.smns_ctzds,	0,			0,
						a.estdo as cnsctvo_cdgo_estdo_drcho,	 a.ips,
						a.cdgo_eapb,		0,		0,
						'3',				fcha_dsde,			fcha_hsta,
						tlfno,				drccn
		From 		bdSiSalud.dbo.tbEapb					a	With(NoLock)
		Inner Join	bdSisalud.dbo.tbDetalleeapb_Vigencias	b	With(NoLock)	On	b.cdgo_eapb	=	a.cdgo_eapb
		Where 		a.nmro_idntfccn_bnfcro 			= @nmro_idntfccn
		And			a.cnsctvo_cdgo_tpo_idntfccn_bnfcro	= @cnsctvo_cdgo_tpo_idntfccn
		And			a.cnsctvo_cdgo_pln			= @cnsctvo_cdgo_pln 
		And			(@fcha_vldccn Between Convert(char(10),b.inco_vgnca,111) and Convert(char(10),b.fn_vgnca,111))
		And			b.vsble_vlddr				= 'S'

		If Exists	(	Select	1
						From	@tb_tmpAfiliado
						Where	@fcha_vldccn Between Convert(char(10),inco_vgnca_bnfcro,111) And Convert(char(10),fn_vgnca_bnfcro,111)
						And	@Bd	= '2'
					)
			Begin
				Delete	@tb_tmpAfiliado
				Where	Convert(char(10),inco_vgnca_bnfcro,111) > @fcha_vldccn 
				Or		@fcha_vldccn > Convert(char(10),fn_vgnca_bnfcro,111)
			--		Or	orgn	!= '3' --Se comentarea para analisis
				Set		@Bd 	= '2'  -- FAMISANAR
			End
	End


/*20131021 Control de cambio Silcmed fase II verificar si el afiliado estuvo alguna vez con SOS */

if @Bd = '4' --Marca No existe en el Sistema
	begin
		-- Se busca la maxima vigencia para el estado valido
		Select		@Nui_Afldo					=	b.nmro_unco_idntfccn_afldo,
					@maximafechabeneficiario	=	Max(v.fn_vgnca_estdo_bnfcro)  
		From		dbo.tbBeneficiariosValidador			b	With(NoLock)
		INNER JOIN	tbContratosValidador					c	With(NoLock)	On	b.nmro_cntrto				=	c.nmro_cntrto
																				And	b.cnsctvo_cdgo_tpo_cntrto	=	c.cnsctvo_cdgo_tpo_cntrto
		Inner Join	dbo.tbVigenciasBeneficiariosValidador	v	With(NoLock)	On	v.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
																				And	v.nmro_cntrto				=	b.nmro_cntrto
																				And	v.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro
		Where		b.cnsctvo_cdgo_tpo_idntfccn	= @cnsctvo_cdgo_tpo_idntfccn
		And			b.nmro_idntfccn				= @nmro_idntfccn 
		And			c.cnsctvo_cdgo_pln			= @cnsctvo_cdgo_pln
		Group by	b.nmro_unco_idntfccn_afldo

		If @maximafechabeneficiario is null 
			Begin
				Select	@Nui_Afldo=nmro_unco_idntfccn_afldo
				From	bdsisalud..tbactua	With(NoLock)
				Where	cnsctvo_cdgo_tpo_idntfccn=@cnsctvo_cdgo_tpo_idntfccn
				And		nmro_idntfccn=@nmro_idntfccn

				Set		@maximafechabeneficiario = (	Select		max(v.fn_vgnca_estdo_bnfcro)  
														From		dbo.tbBeneficiariosValidador			b	With(NoLock)
														INNER JOIN	tbContratosValidador					c	With(NoLock)	On	b.nmro_cntrto				=	c.nmro_cntrto
																																And	b.cnsctvo_cdgo_tpo_cntrto	=	c.cnsctvo_cdgo_tpo_cntrto
														Inner Join	dbo.tbVigenciasBeneficiariosValidador	v	With(NoLock)	On	v.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
																																And	v.nmro_cntrto				=	b.nmro_cntrto
																																And	v.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro
														Where		b.nmro_unco_idntfccn_afldo	=	@Nui_Afldo
														And			c.cnsctvo_cdgo_pln			=	@cnsctvo_cdgo_pln
													) 
			End

		Insert Into @tb_tmpAfiliado
		(			prmr_aplldo,					sgndo_aplldo,					prmr_nmbre,
					sgndo_nmbre,					cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,
					fcha_ncmnto,					cnsctvo_cdgo_sxo,				orgn,
					cnsctvo_cdgo_tpo_cntrto,		nmro_cntrto,					cnsctvo_cdgo_pln,
					nmro_unco_idntfccn_afldo,		inco_vgnca_bnfcro,				fn_vgnca_bnfcro,
					cnsctvo_cdgo_prntsco,			cnsctvo_cdgo_tpo_afldo,			cnsctvo_cdgo_rngo_slrl,
					smns_ctzds_ss_ps,				smns_ctzds_eps_ps,				cdgo_ips_prmra,
					cnsctvo_bnfcro,					cnsctvo_cdgo_afp,
					fcha_dsde,						fcha_hsta,
					tlfno_rsdnca,					drccn_rsdnca,					cnsctvo_cdgo_cdd_rsdnca,
					prmr_nmbre_ctznte,				sgndo_nmbre_ctznte,				prmr_aplldo_ctznte,
					sgndo_aplldo_ctznte,			cnsctvo_tpo_idntfccn_ctznte,	nmro_idntfccn_ctznte,
					nmro_unco_idntfccn_ctznte,		eml --,							inco_vgnca_cntrto, 	fn_vgnca_cntrto,			cestdo_pra_fcha
		)
		Select		b.prmr_aplldo,					b.sgndo_aplldo,					b.prmr_nmbre,
					b.sgndo_nmbre,					b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,
					b.fcha_ncmnto,					b.cnsctvo_cdgo_sxo,				'1',
					b.cnsctvo_cdgo_tpo_cntrto,		b.nmro_cntrto,					c.cnsctvo_cdgo_pln,
					b.nmro_unco_idntfccn_afldo,		v.inco_vgnca_estdo_bnfcro,		v.fn_vgnca_estdo_bnfcro,
					b.cnsctvo_cdgo_prntsco,			b.cnsctvo_cdgo_tpo_afldo,		c.cnsctvo_cdgo_rngo_slrl,
					b.smns_ctzds_antrr_eps,			b.smns_ctzds,					b.cdgo_intrno,
					b.cnsctvo_bnfcro,				c.cnsctvo_cdgo_afp,
					b.inco_vgnca_bnfcro,			b.fn_vgnca_bnfcro,
					b.tlfno_rsdnca,					b.drccn_rsdnca,					b.cnsctvo_cdgo_cdd_rsdnca,
					c.prmr_aplldo,					c.sgndo_aplldo,					c.prmr_nmbre,
					c.sgndo_nmbre,					c.cnsctvo_cdgo_tpo_idntfccn,	c.nmro_idntfccn,
					c.nmro_unco_idntfccn_afldo,
					isnull(b.eml,'') As eml --,		c.inco_vgnca_cntrto,			c.fn_vgnca_cntrto,				'INACTIVO'
		From		dbo.tbBeneficiariosValidador			b	With(NoLock)
		Inner Join	dbo.tbContratosValidador				c	With(NoLock)	On	b.nmro_cntrto				=	c.nmro_cntrto
																				And	b.cnsctvo_cdgo_tpo_cntrto	=	c.cnsctvo_cdgo_tpo_cntrto
		Inner Join	dbo.tbVigenciasBeneficiariosValidador	v	With(NoLock)	On	v.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
																				And	v.nmro_cntrto				=	b.nmro_cntrto
																				And	v.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro
		Where		c.cnsctvo_cdgo_pln			=	@cnsctvo_cdgo_pln
		And			b.nmro_unco_idntfccn_afldo	=	@Nui_Afldo
		And			@maximafechabeneficiario Between v.inco_vgnca_estdo_bnfcro And v.fn_vgnca_estdo_bnfcro

		if (select count(1) from 	@tb_tmpAfiliado) >	0 
			begin
				set @mnsje 	= 'Estuvo Vigente Con SOS'

				Update		@tb_tmpAfiliado
				Set			cnsctvo_cdgo_estdo_drcho	= m.cnsctvo_cdgo_estdo_drcho,
							cnsctvo_cdgo_csa_drcho		= m.cnsctvo_cdgo_csa_drcho,
							dscrpcn_csa_drcho		= isnull(c.dscrpcn_csa_drcho,' ')
				From		@tb_tmpAfiliado				t
				INNER JOIN	TbMatrizDerechosValidador	m	With(NoLock)	On	m.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																			And	m.nmro_cntrto				= t.nmro_cntrto --COLLATE SQL_Latin1_General_CP1_CI_AS              
																			And	m.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
				INNER JOIN	tbCausasDerechoValidador	c	With(NoLock)	On	m.cnsctvo_cdgo_estdo_drcho	= c.cnsctvo_cdgo_estdo_drcho
																			And	m.cnsctvo_cdgo_csa_drcho	= c.cnsctvo_cdgo_csa_drcho              
	
				IF @@RowCount = 0
					Begin
						Update		@tb_tmpAfiliado
						Set			cnsctvo_cdgo_estdo_drcho	= m.cnsctvo_cdgo_estdo_drcho,
									cnsctvo_cdgo_csa_drcho		= m.cnsctvo_cdgo_csa_drcho,
									dscrpcn_csa_drcho		= isnull(c.dscrpcn_csa_drcho,' ')
						From		@tb_tmpAfiliado					t
						INNER JOIN	TbMatrizDerechosValidador_at	m	With(NoLock)	On	m.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																						And	m.nmro_cntrto				= t.nmro_cntrto --COLLATE SQL_Latin1_General_CP1_CI_AS              
																						And	m.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
						INNER JOIN	tbCausasDerechoValidador		c	With(NoLock)	On	m.cnsctvo_cdgo_estdo_drcho	= c.cnsctvo_cdgo_estdo_drcho
																						And	m.cnsctvo_cdgo_csa_drcho	= c.cnsctvo_cdgo_csa_drcho              
						Where		@fcha_vldccn Between inco_vgnca_estdo_drcho And	fn_vgnca_estdo_drcho
					End
			end
	END --edn bd4

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
INNER JOIN	dbo.tbParentescos_vigencias p	With(NoLock)	On	t.cnsctvo_cdgo_prntsco = p.cnsctvo_cdgo_prntscs
Where		@fcha_vldccn Between Convert(char(10),p.inco_vgnca,111) And Convert(char(10),p.fn_vgnca,111)

Update		@tb_tmpAfiliado
Set 		dscrpcn_tpo_afldo = a.dscrpcn,
			cdgo_tpo_afldo	  = a.cdgo_tpo_afldo 
From		@tb_tmpAfiliado					t
INNER JOIN	dbo.tbTiposAfiliado_vigencias	a	With(NoLock)	On	t.cnsctvo_cdgo_tpo_afldo	= a.cnsctvo_cdgo_tpo_afldo
Where		@fcha_vldccn Between Convert(char(10),a.inco_vgnca,111) And Convert(char(10),a.fn_vgnca,111)

Update		@tb_tmpAfiliado
Set			cnsctvo_cdgo_rngo_slrl	= 4
Where		cnsctvo_cdgo_rngo_slrl	= 0
And			cnsctvo_cdgo_tpo_cntrto	!= 1

Update		@tb_tmpAfiliado
Set 		dscrpcn_rngo_slrl = r.dscrpcn_rngo_slrl,
			cdgo_rngo_slrl	  = r.cdgo_rngo_slrl 
From		@tb_tmpAfiliado						t
INNER JOIN	dbo.tbRangosSalariales_vigencias	r	With(NoLock)	On	t.cnsctvo_cdgo_rngo_slrl	= r.cnsctvo_cdgo_rngo_slrl
Where		@fcha_vldccn Between Convert(char(10),r.inco_vgnca,111) And Convert(char(10),r.fn_vgnca,111)

Update		@tb_tmpAfiliado
Set			dscrpcn_pln_pc = isnull(p.dscrpcn_pln,'') 
From		@tb_tmpAfiliado			t
INNER JOIN	dbo.tbPlanes_vigencias	p	With(NoLock)	On	t.cnsctvo_cdgo_pln_pc = p.cnsctvo_cdgo_pln

Update		@tb_tmpAfiliado
Set			dscrpcn_ips_prmra = i.nmbre_scrsl
From		@tb_tmpAfiliado							t
INNER JOIN	bdSISalud.dbo.tbIpsPrimarias_vigencias	i	With(NoLock)	On	t.cdgo_ips_prmra	= i.cdgo_intrno --COLLATE SQL_Latin1_General_CP1_CI_AS

Update		@tb_tmpAfiliado
Set 		dscrpcn_estdo_drcho		= edv.dscrpcn_estdo_drcho,
			dscrpcn_drcho			= edv.dscrpcn_drcho,
			cnsctvo_cdgo_estdo_drcho	= edv.cnsctvo_cdgo_estdo_drcho,
			drcho 				= edv.drcho,
			cdgo_estdo_drcho		= edv.cdgo_estdo_drcho
From		dbo.tbEstadosDerechoValidador	edv	With(NoLock)
INNER JOIN	@tb_tmpAfiliado					a	On	a.cnsctvo_cdgo_estdo_drcho 	= edv.cnsctvo_cdgo_estdo_drcho

Update		@tb_tmpAfiliado
Set			cdgo_tpo_idntfccn	= i.cdgo_tpo_idntfccn
From		@tb_tmpAfiliado						t
INNER JOIN	dbo.tbTiposIdentificacion_vigencias i	With(NoLock)	On	t.cnsctvo_cdgo_tpo_idntfccn	= i.cnsctvo_cdgo_tpo_idntfccn
Where		@fcha_vldccn Between Convert(char(10),i.inco_vgnca,111) And Convert(char(10),i.fn_vgnca,111)

Update		@tb_tmpAfiliado
Set			cdgo_tpo_idntfccn_ctznte	= i.cdgo_tpo_idntfccn
From		@tb_tmpAfiliado						t
INNER JOIN	dbo.tbTiposIdentificacion_vigencias i	With(NoLock)	On	t.cnsctvo_tpo_idntfccn_ctznte	= i.cnsctvo_cdgo_tpo_idntfccn
Where		@fcha_vldccn Between Convert(char(10),i.inco_vgnca,111) And Convert(char(10),i.fn_vgnca,111)

Update		@tb_tmpAfiliado
Set			cdgo_sxo	= s.cdgo_sxo
From		@tb_tmpAfiliado			t
INNER JOIN	dbo.tbSexos_vigencias	s	With(NoLock)	On	t.cnsctvo_cdgo_sxo	= s.cnsctvo_cdgo_sxo
Where		@fcha_vldccn Between Convert(char(10),s.inco_vgnca,111) And Convert(char(10),s.fn_vgnca,111)

/*
Select	*
From	tbPlanes
*/
Update		@tb_tmpAfiliado
Set			dscrpcn_pln	= p.dscrpcn_pln
From		@tb_tmpAfiliado t
INNER JOIN	dbo.tbPlanes	p	With(NoLock)	On	t.cnsctvo_cdgo_pln	= p.cnsctvo_cdgo_pln

--cnsctvo_cdgo_sde_ips
Update		@tb_tmpAfiliado
Set			cnsctvo_cdgo_sde_ips	= d.cnsctvo_cdgo_sde
From		bdSISalud.dbo.tbDireccionesPrestador	d	With(NoLock)
INNER JOIN	@tb_tmpAfiliado							t	On	d.cdgo_intrno	= t.cdgo_ips_prmra

--cnsctvo_cdgo_sde_ips para afiliado PAC
Update		@tb_tmpAfiliado
set			cnsctvo_cdgo_sde_ips  = c.cnsctvo_sde_inflnca
from		@tb_tmpAfiliado									t
INNER JOIN	bdAfiliacionvalidador.dbo.tbCiudades_Vigencias	c	With(NoLock)	On t.cnsctvo_cdgo_cdd_rsdnca = c.cnsctvo_cdgo_cdd 
Where		t.cnsctvo_cdgo_tpo_cntrto=2  --Solo Para Plan PAC
		
Update		@tb_tmpAfiliado
Set			flg_enble_nmro_vldcn	= 'S'
Where		cnsctvo_cdgo_estdo_drcho	 = 8 --In (8) Suspendido
Or			cnsctvo_cdgo_estdo_drcho	 = 7 --Retirado

Update		@tb_tmpAfiliado
Set			dscrpcn_cdd_rsdnca	= c.dscrpcn_cdd,
			cdgo_cdd		= c.cdgo_cdd
From		dbo.tbCiudades	c	With(NoLock)
INNER JOIN	@tb_tmpAfiliado t	On	c.cnsctvo_cdgo_cdd	= t.cnsctvo_cdgo_cdd_rsdnca

Update		@tb_tmpAfiliado
Set			cdgo_afp	= cdgo_entdd
From		dbo.tbEntidades_Vigencias	e	With(NoLock)
INNER JOIN	@tb_tmpAfiliado				t	On	t.cnsctvo_cdgo_afp	= e.cnsctvo_cdgo_entdd
Where		@fcha_vldccn Between Convert(char(10),e.inco_vgnca,111) And Convert(char(10),e.fn_vgnca,111)

Update		@tb_tmpAfiliado
Set			cfcha_ncmnto	= convert(char(10),fcha_ncmnto,111)

--2013112013 Ajuste Detectado en la consulta de cuentas ya que en sipres tambien lo incorpora 
Update		@tb_tmpAfiliado
set			ordenamientoxestado	=	Case	When ltrim(rtrim(dscrpcn_drcho)) = 'DERECHO A TODOS LOS SERVICIOS'			Then	1
											When ltrim(rtrim(dscrpcn_drcho)) = 'SOLO URGENCIAS'							Then	2
											When ltrim(rtrim(dscrpcn_drcho)) = 'SOLO URGENCIAS - ACTIVIDADES DE PYP'	Then	3
											When ltrim(rtrim(dscrpcn_drcho)) = 'SOLO URGENCIAS - TRATAMIENTO EN CURSO'	Then	4
											When ltrim(rtrim(dscrpcn_drcho)) = 'SIN DERECHO A SERVICIO'					Then	5
											Else 6
									End

Select		prmr_aplldo,									sgndo_aplldo,								prmr_nmbre,							sgndo_nmbre,
			cnsctvo_cdgo_tpo_idntfccn,						nmro_idntfccn,								fcha_ncmnto,						cnsctvo_cdgo_sxo,
			cdgo_sxo,										edd,										edd_mss,							edd_ds,
			cnsctvo_cdgo_tpo_undd,							orgn,										cnsctvo_cdgo_tpo_cntrto,			nmro_cntrto,
			cnsctvo_cdgo_pln,								nmro_unco_idntfccn_afldo,					inco_vgnca_bnfcro,					fn_vgnca_bnfcro,
			cnsctvo_cdgo_prntsco,							dscrpcn_prntsco,							cnsctvo_cdgo_tpo_afldo,				dscrpcn_tpo_afldo,
			cnsctvo_cdgo_rngo_slrl,							dscrpcn_rngo_slrl,							cnsctvo_cdgo_pln_pc,				dscrpcn_pln_pc,
			smns_ctzds_ss_ps,								smns_ctzds_eps_ps,							smns_ctzds_ss_pc,					smns_ctzds_eps_pc,
			cdgo_ips_prmra,									dscrpcn_ips_prmra,							cnsctvo_bnfcro,						cdgo_eapb,
			nmro_unco_idntfccn_ctznte,						cnsctvo_cdgo_tpo_cntrto_psc,				nmro_cntrto_psc,					ds_ctzds,
			cnsctvo_cdgo_sde_ips,							dscrpcn_tpo_cntrto,							cnsctvo_cdgo_csa_drcho,				cnsctvo_cdgo_estdo_drcho,
			dscrpcn_estdo_drcho,							dscrpcn_csa_drcho,							dscrpcn_drcho,						dscrpcn_pln,
			dscrpcn_tpo_ctznte,								prmr_nmbre_ctznte,							sgndo_nmbre_ctznte,					prmr_aplldo_ctznte,
			sgndo_aplldo_ctznte,							drccn_rsdnca,								tlfno_rsdnca,						cnsctvo_cdgo_cdd_rsdnca,
			dscrpcn_cdd_rsdnca,								cnsctvo_cdgo_estdo_cvl,						dscrpcn_estdo_cvl,					cnsctvo_cdgo_tpo_frmlro,
			nmro_frmlro,									cdgo_tpo_idntfccn,							cnsctvo_cdgo_afp,					fcha_dsde,
			fcha_hsta,										flg_enble_nmro_vldcn,						drcho,								cdgo_afp,
			cnsctvo_tpo_vldcn_actva,						cfcha_ncmnto,								smns_aflcn_ss_ps,					smns_aflcn_eps_ps,
			smns_aflcn_ss_pc,								smns_aflcn_eps_pc,							smns_ctzds_eps,						cdgo_tpo_prntsco,
			cdgo_cdd, 										cdgo_rngo_slrl,								cdgo_tpo_afldo, 					cdgo_tpo_idntfccn_ctznte,
			nmro_idntfccn_ctznte,							cnsctvo_tpo_idntfccn_ctznte,				@lfFechaReferencia	as fcha_rfrnca,	cnsctvo_dcmnto_gnrdo,
			nmro_dcmnto,									cdgo_estdo_drcho,							eml --adicion de campo 2009/12/11 sisatv01
From		@tb_tmpAfiliado
order by	ordenamientoxestado,nmro_unco_idntfccn_afldo,cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas_Historico] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas_Historico] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas_Historico] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas_Historico] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas_Historico] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas_Historico] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas_Historico] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas_Historico] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas_Historico] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas_Historico] TO [Radicador Recobros]
    AS [dbo];

