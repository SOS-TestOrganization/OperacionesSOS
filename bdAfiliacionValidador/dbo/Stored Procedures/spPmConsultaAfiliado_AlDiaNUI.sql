/*---------------------------------------------------------------------------------------------------------------------------------------
* Procedimiento:		spPmConsultaAfiliado_AlDiaNUI
* Desarrollado por:		<\A Ing. Samuel Muñoz	A\>
* Descripción:			<\D		D\>
* Observaciones:		<\O		O\>
* Parámetros:			<\P		P\>
* Variables:			<\V		V\>
* Fecha Creación:		<\FC 2003/00/00	FC\>
*
*---------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------------------------------------------------------------
* Modificado Por			:	<\AM	Ing. Maria Janeth Barrera																AM\>
* Descripcion				:	<\D		Se ajusta procedimiento asignando la fecha de referencia que entra como parámetro al sp	D\>
							:	<\D		a la variable @fcha_vldccn																D\>
							:	<\PM  																							PM\>
* Nuevas Variables			:	<\VM  																							VM\>
* Fecha Modificación		:	<\FM	2018-10-24																				FM\>
*-----------------------------------------------------------------------------------------------------------------------------------*/
CREATE procedure [dbo].[spPmConsultaAfiliado_AlDiaNUI]
@nmro_unco_idntfccn 	udtConsecutivo, 
@mnsje					varchar(80)		output,
@origen					char(1),
@lfFechaReferencia		datetime		output

AS
Set NoCount On

/*
Set	@cnsctvo_cdgo_tpo_idntfccn	= 1
Set	@nmro_idntfccn			= '30285559'
Set	@cnsctvo_cdgo_pln		= 1
Set	@mnsje				= ''
Set	@origen				= null
Set	@lfFechaReferencia		= ''
*/

Begin
	-- Declaración de variables
	Declare
	@fcha_vldccn				datetime,
	@Nui_Afldo					UdtConsecutivo,
	@Bd 						char(1),
	@inco_vgnca_bnfcro			Datetime,
	@fcha_ultma_mdfccn			Datetime,	
	--@lfFechaReferencia	datetime,
	@dFcha_pvte					datetime,
	@Historico					char(1),
	@fcha_mxma_rprte			datetime,
	@maximafechabeneficiario	datetime

	--20181024  Se incluye asignacion de la fecha de referencia sisjbv01
	set @fcha_vldccn = @lfFechaReferencia

	Declare	@tb_tmpAfiliado Table
		(	prmr_aplldo					varchar(50),		sgndo_aplldo				varchar(50),		
			prmr_nmbre					varchar(20),		sgndo_nmbre					varchar(20),		
			cnsctvo_cdgo_tpo_idntfccn	int,				nmro_idntfccn				varchar(23),
			fcha_ncmnto					datetime,			cnsctvo_cdgo_sxo			int,
			cdgo_sxo					char(2),			edd 						int,
			edd_mss 					int,				edd_ds 						int,
			cnsctvo_cdgo_tpo_undd		int,				orgn						char(1),
			cnsctvo_cdgo_tpo_cntrto		int,				nmro_cntrto					char(15),
			cnsctvo_cdgo_pln			int,				nmro_unco_idntfccn_afldo	int,
			inco_vgnca_bnfcro			datetime,			fn_vgnca_bnfcro				datetime,
			cnsctvo_cdgo_prntsco		int,				dscrpcn_prntsco				varchar(150),
			cnsctvo_cdgo_tpo_afldo 		int, 				dscrpcn_tpo_afldo			varchar(150),
			cnsctvo_cdgo_rngo_slrl 		int,				dscrpcn_rngo_slrl 			varchar(150),		
			cnsctvo_cdgo_pln_pc			int,				dscrpcn_pln_pc				varchar(150),		
			smns_ctzds_ss_ps			int,				smns_ctzds_eps_ps			int,
			smns_ctzds_ss_pc			int,				smns_ctzds_eps_pc			int,			
			cdgo_ips_prmra				char(8),			dscrpcn_ips_prmra			varchar(150),	
			cnsctvo_bnfcro				int,				cdgo_eapb					varchar(3) null,
			nmro_unco_idntfccn_ctznte 	int,				cnsctvo_cdgo_tpo_cntrto_psc	int,
			nmro_cntrto_psc				char(15),			ds_ctzds					numeric,
			cnsctvo_cdgo_sde_ips		int default 0,		dscrpcn_tpo_cntrto			varchar(150),
			cnsctvo_cdgo_csa_drcho		int,				cnsctvo_cdgo_estdo_drcho	int,
			dscrpcn_estdo_drcho			varchar(150),		dscrpcn_csa_drcho			varchar(150),
			dscrpcn_drcho				varchar(150),		dscrpcn_pln					varchar(150),
			dscrpcn_tpo_ctznte			varchar(150),		prmr_nmbre_ctznte			char(20),
			sgndo_nmbre_ctznte			char(20),			prmr_aplldo_ctznte			char(50),
			sgndo_aplldo_ctznte			char(50),			drccn_rsdnca				varchar(80),
			tlfno_rsdnca				char(30),			cnsctvo_cdgo_cdd_rsdnca 	int,
			dscrpcn_cdd_rsdnca 			varchar(150),		cnsctvo_cdgo_estdo_cvl 		int,
			dscrpcn_estdo_cvl 			varchar(150),		cnsctvo_cdgo_tpo_frmlro		Int,
			nmro_frmlro					Char(15),			cdgo_tpo_idntfccn			char(3),
			cnsctvo_cdgo_afp			int,				fcha_dsde					datetime,
			fcha_hsta					datetime,			flg_enble_nmro_vldcn		char default 'N',
			drcho						char,				cdgo_afp					char(8),
			cnsctvo_tpo_vldcn_actva		int Default 3,		cfcha_ncmnto				char(10),
			smns_aflcn_ss_ps			int DEFAULT 0,		smns_aflcn_eps_ps			int DEFAULT 0,
			smns_aflcn_ss_pc			int DEFAULT 0,		smns_aflcn_eps_pc			int DEFAULT 0,
			smns_ctzds_eps				int DEFAULT 0,		cdgo_tpo_prntsco  			char(3),
			cdgo_cdd 					char(8), 			cdgo_rngo_slrl 				char(3),
			cdgo_tpo_afldo 				char(3) , 			cdgo_tpo_idntfccn_ctznte 	char(3),
			nmro_idntfccn_ctznte 		char(20),			cnsctvo_tpo_idntfccn_ctznte	int,
			cnsctvo_dcmnto_gnrdo		int default 0,		nmro_dcmnto					Char(50) default ' ',
			eml							varchar(50)
		--	fcha_mxma_rprte char(10) DEFAULT convert(char(10),getdate()+15,111) NOT NULL 
		)

	Declare	@tiempoAfiliacion Table
		(	smns_ctzds				int,
			smns_aflcn				int,
			smns_ctzds_antrr_eps	int,
			smns_aflcn_antrr_eps	int,
			cnsctvo_cdgo_tpo_cntrto	int,
			nmro_cntrto				varchar(15),
			inco_vgnca_bnfcro		datetime,
			fn_vgnca_bnfcro			datetime,
			cnsctvo_bnfcro			Int
		)

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
	Where		nmro_unco_idntfccn_afldo	= @nmro_unco_idntfccn

	Insert Into #tmpVigenciasBeneficiariosValidador
	Select		v.cnsctvo_cdgo_tpo_cntrto,							v.nmro_cntrto,			v.cnsctvo_bnfcro,	Convert(char(10),v.inco_vgnca_estdo_bnfcro,111),
				Convert(char(10),v.fn_vgnca_estdo_bnfcro,111),		a.estdo
	From		BDAfiliacionValidador.dbo.tbVigenciasBeneficiariosValidador	v	With(NoLock)
	Inner Join	#tmpBeneficiariosValidador									a	With(NoLock)	On	a.cnsctvo_cdgo_tpo_cntrto	=	v.cnsctvo_cdgo_tpo_cntrto
																								And	a.nmro_cntrto				=	v.nmro_cntrto
																								And	a.cnsctvo_bnfcro			=	v.cnsctvo_bnfcro
	--Where		@lfFechaReferencia Between v.inco_vgnca_estdo_bnfcro And v.fn_vgnca_estdo_bnfcro

	Insert Into	#tmpContratosValidador
	Select		c.cnsctvo_cdgo_tpo_cntrto,			c.nmro_cntrto,					c.nmro_unco_idntfccn_afldo,						c.cnsctvo_cdgo_tpo_idntfccn,
				c.nmro_idntfccn,					c.cnsctvo_cdgo_pln,				Ltrim(Rtrim(c.prmr_aplldo)),					Ltrim(Rtrim(c.sgndo_aplldo)),
				Ltrim(Rtrim(c.prmr_nmbre)),			Ltrim(Rtrim(c.sgndo_nmbre)),	Convert(char(10),c.inco_vgnca_cntrto,111),		Convert(char(10),c.fn_vgnca_cntrto,111),
				c.cnsctvo_cdgo_rngo_slrl,			c.cnsctvo_cdgo_afp
	From		BDAfiliacionValidador.dbo.tbContratosValidador	c	With(NoLock)
	Inner Join	#tmpBeneficiariosValidador						a	With(NoLock)	On	a.cnsctvo_cdgo_tpo_cntrto	=	c.cnsctvo_cdgo_tpo_cntrto
																					And	a.nmro_cntrto				=	c.nmro_cntrto

	set		@Bd = @origen

	If Isnull(@Bd,'') =' ' Or @bd = '1'
		Begin
			Insert Into @tb_tmpAfiliado
					(	prmr_aplldo,			sgndo_aplldo,				prmr_nmbre,						sgndo_nmbre,								cnsctvo_cdgo_tpo_idntfccn,
						nmro_idntfccn,			fcha_ncmnto,				cnsctvo_cdgo_sxo,				orgn,										cnsctvo_cdgo_tpo_cntrto,
						nmro_cntrto,			cnsctvo_cdgo_pln,			nmro_unco_idntfccn_afldo,		inco_vgnca_bnfcro,							fn_vgnca_bnfcro,
						cnsctvo_cdgo_prntsco,	cnsctvo_cdgo_tpo_afldo,		cnsctvo_cdgo_rngo_slrl,			smns_ctzds_ss_ps,							smns_ctzds_eps_ps,
						cdgo_ips_prmra,			cnsctvo_bnfcro,				cnsctvo_cdgo_afp,				fcha_dsde,									fcha_hsta,
						tlfno_rsdnca,			drccn_rsdnca,				cnsctvo_cdgo_cdd_rsdnca,		prmr_nmbre_ctznte,							sgndo_nmbre_ctznte,
						prmr_aplldo_ctznte,		sgndo_aplldo_ctznte,		cnsctvo_tpo_idntfccn_ctznte,	nmro_idntfccn_ctznte,						nmro_unco_idntfccn_ctznte,
						eml
			)
			Select		b.prmr_aplldo,			b.sgndo_aplldo,				b.prmr_nmbre,					b.sgndo_nmbre,								b.cnsctvo_cdgo_tpo_idntfccn,
						b.nmro_idntfccn,		b.fcha_ncmnto,				b.cnsctvo_cdgo_sxo,				'1',										b.cnsctvo_cdgo_tpo_cntrto,
						b.nmro_cntrto,			c.cnsctvo_cdgo_pln,			b.nmro_unco_idntfccn_afldo,		v.inco_vgnca_estdo_bnfcro,					v.fn_vgnca_estdo_bnfcro,
						b.cnsctvo_cdgo_prntsco,	b.cnsctvo_cdgo_tpo_afldo,	c.cnsctvo_cdgo_rngo_slrl,		b.smns_ctzds_antrr_eps,						b.smns_ctzds,
						b.cdgo_intrno,			b.cnsctvo_bnfcro,			c.cnsctvo_cdgo_afp,				Convert(char(10),b.inco_vgnca_bnfcro,111),	Convert(char(10),b.fn_vgnca_bnfcro,111),
						b.tlfno_rsdnca,			b.drccn_rsdnca,				b.cnsctvo_cdgo_cdd_rsdnca,		c.prmr_aplldo,								c.sgndo_aplldo,
						c.prmr_nmbre,			c.sgndo_nmbre,				c.cnsctvo_cdgo_tpo_idntfccn,	c.nmro_idntfccn,							c.nmro_unco_idntfccn_afldo,
						isnull(b.eml,'') as eml --adicion de campo
			From		#tmpBeneficiariosValidador			b	With(NoLock)
			INNER JOIN	#tmpContratosValidador				c	With(NoLock)	On	b.nmro_cntrto				=	c.nmro_cntrto
																				And	b.cnsctvo_cdgo_tpo_cntrto	=	c.cnsctvo_cdgo_tpo_cntrto
			Inner Join	#tmpVigenciasBeneficiariosValidador	v	With(NoLock)	On	v.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
																				And	v.nmro_cntrto				=	b.nmro_cntrto
																				And	v.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro
			Where		@lfFechaReferencia Between v.inco_vgnca_estdo_bnfcro And v.fn_vgnca_estdo_bnfcro
			If @@ROWCOUNT = 0
				Begin
					Set	@bd = '5'
				End
			Else
				Begin
					if Exists	(	Select	1
									From	@tb_tmpAfiliado
									Where	@fcha_vldccn Between inco_vgnca_bnfcro And fn_vgnca_bnfcro
								)
					Begin
						Delete	@tb_tmpAfiliado
						Where	inco_vgnca_bnfcro > @fcha_vldccn 

						Delete	@tb_tmpAfiliado
						Where	@fcha_vldccn > fn_vgnca_bnfcro

						Set @bd 	= '1'  -- Contratos
					End
				End
		End

	If @bd = '4'
	Begin
		Set @mnsje = 'AUDITORIA'
	End

	If  @bd = '5'
	Begin
		Set @mnsje = 'NO EXISTE EN EL SISTEMA'

		--Select * From @tb_tmpAfiliado
		--return
	End

	/*******************************************************************************
	***	Se escoge el ultimo registro actualizado
	*******************************************************************************/
	Set		@bd = null
	Set		@dFcha_pvte = null

	Select	@dFcha_pvte = Max(fcha_hsta)
	From	@tb_tmpAfiliado
	Where	@fcha_vldccn Between inco_vgnca_bnfcro And fn_vgnca_bnfcro
	And		fn_vgnca_bnfcro	<> '9999/12/31'
	And		orgn	= '1'

	If @dFcha_pvte Is Null
		Select	@dFcha_pvte = Max(fcha_hsta)
		From	@tb_tmpAfiliado

	Select	@bd = Min(orgn)
	From	@tb_tmpAfiliado
	Where	fcha_hsta	= @dFcha_pvte

	If @bd Is Null
		Begin
			Set @bd 		= '5'  -- No existe en el sistema
			Set @mnsje 		= 'NO EXISTE EN EL SISTEMA'
			--Select * From @tb_tmpAfiliado
			--return
		End
	Else
		Begin
			Delete
			From	@tb_tmpAfiliado
			Where	fcha_hsta	<> @dFcha_pvte

			Delete
			From	@tb_tmpAfiliado
			Where	orgn		<> @bd

			Set @mnsje = Case @bd
					When '1' Then 'CONTRATOS'
					When '2' Then 'FORMULARIOS'
					When '3' Then 'FAMISANAR'
					End

			Select		@mnsje 		= Rtrim(Ltrim(dscrpcn_eapb))
			From		bdAfiliacionValidador.dbo.tbDetalleEapb_Vigencias	a	With(NoLock)
			Inner Join	@tb_tmpAfiliado										b	On	a.cdgo_eapb	= b.cdgo_eapb
			Where		orgn		= '3'
		End


	/*******************************************************************************
	***	Se actualizan los datos restantes
	*******************************************************************************/
	If  @bd = '1' -- Contratos
		Begin
			Insert into @tiempoAfiliacion
					(	smns_ctzds,					smns_aflcn,					smns_ctzds_antrr_eps,		smns_aflcn_antrr_eps,
						cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,				inco_vgnca_bnfcro,			fn_vgnca_bnfcro,
						cnsctvo_bnfcro
					)
			Select		b.smns_ctzds,				b.smns_aflcn,				b.smns_ctzds_antrr_eps,		smns_aflcn_antrr_eps,
						b.cnsctvo_cdgo_tpo_cntrto,	b.nmro_cntrto,				c.inco_vgnca_estdo_bnfcro,	c.fn_vgnca_estdo_bnfcro,
						b.cnsctvo_bnfcro
			From		@tb_tmpAfiliado							t
			Inner Join	#tmpBeneficiariosValidador				b	With(NoLock)	On	b.nmro_unco_idntfccn_afldo	=	t.nmro_unco_idntfccn_afldo
			Inner Join	#tmpVigenciasBeneficiariosValidador		c	With(NoLock)	On	c.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
																					And	c.nmro_cntrto				=	b.nmro_cntrto
																					And	c.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro
			And			@lfFechaReferencia Between c.inco_vgnca_estdo_bnfcro And c.fn_vgnca_estdo_bnfcro

			If Exists	(	Select	1
							FRom	@tiempoAfiliacion
							Where	cnsctvo_cdgo_tpo_cntrto	= 1
							And		@fcha_vldccn Between inco_vgnca_bnfcro And fn_vgnca_bnfcro
						)
				Begin
					Update		@tb_tmpAfiliado
					Set			smns_ctzds_ss_ps		= b.smns_ctzds,
								smns_ctzds_eps_ps		= b.smns_ctzds_antrr_eps,
								smns_aflcn_eps_ps  		= b.smns_aflcn,
								smns_aflcn_ss_ps  		= b.smns_aflcn_antrr_eps,
		 						smns_ctzds_eps			= b.smns_ctzds
					From		@tb_tmpAfiliado		t
					Inner Join	@tiempoAfiliacion	b	On	b.cnsctvo_cdgo_tpo_cntrto	=	t.cnsctvo_cdgo_tpo_cntrto
														And	b.nmro_cntrto				=	t.nmro_cntrto
														And	b.cnsctvo_bnfcro			=	t.cnsctvo_bnfcro
					Where		b.cnsctvo_cdgo_tpo_cntrto	= 1
					And			@fcha_vldccn Between b.inco_vgnca_bnfcro And b.fn_vgnca_bnfcro
				End
			Else
				Begin
					Update		@tb_tmpAfiliado
					Set			smns_ctzds_ss_ps		= b.smns_ctzds,
								smns_ctzds_eps_ps		= b.smns_ctzds_antrr_eps,
								smns_aflcn_eps_ps  		= b.smns_aflcn,
								smns_aflcn_ss_ps  		= b.smns_aflcn_antrr_eps,
		 						smns_ctzds_eps			= b.smns_ctzds
					From		@tb_tmpAfiliado		t
					Inner Join	@tiempoAfiliacion	b	On	b.cnsctvo_cdgo_tpo_cntrto	=	t.cnsctvo_cdgo_tpo_cntrto
														And	b.nmro_cntrto				=	t.nmro_cntrto
														And	b.cnsctvo_bnfcro			=	t.cnsctvo_bnfcro
					Where		b.cnsctvo_cdgo_tpo_cntrto	= 1
					And			t.fn_vgnca_bnfcro Between b.inco_vgnca_bnfcro And b.fn_vgnca_bnfcro
		
					If @@ROWCOUNT = 0
						Begin
							Update		@tb_tmpAfiliado
							Set			smns_ctzds_ss_ps		= b.smns_ctzds,
										smns_ctzds_eps_ps		= b.smns_ctzds_antrr_eps,
										smns_aflcn_eps_ps  		= b.smns_aflcn,
										smns_aflcn_ss_ps  		= b.smns_aflcn_antrr_eps,
			 							smns_ctzds_eps			= b.smns_ctzds
							From		@tb_tmpAfiliado		t
							Inner Join	@tiempoAfiliacion	b	On	b.cnsctvo_cdgo_tpo_cntrto	=	t.cnsctvo_cdgo_tpo_cntrto
																And	b.nmro_cntrto				=	t.nmro_cntrto
																And	b.cnsctvo_bnfcro			=	t.cnsctvo_bnfcro
							Inner Join	(	Select	Max(fn_vgnca_bnfcro) as fn_vgnca_bnfcro
											From	@tiempoAfiliacion
											Where	cnsctvo_cdgo_tpo_cntrto	= 1
										)	g	On	g.fn_vgnca_bnfcro	=	b.fn_vgnca_bnfcro
							Where		b.cnsctvo_cdgo_tpo_cntrto	= 1
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
					Inner Join	#tmpContratosValidador		c	On	b.cnsctvo_cdgo_tpo_cntrto	= c.cnsctvo_cdgo_tpo_cntrto
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
					Inner Join	#tmpContratosValidador		c	On	b.cnsctvo_cdgo_tpo_cntrto	= c.cnsctvo_cdgo_tpo_cntrto
																And	b.nmro_cntrto				= c.nmro_cntrto
					Where		c.cnsctvo_cdgo_tpo_cntrto	= 2
					And			t.fn_vgnca_bnfcro Between b.inco_vgnca_bnfcro And b.fn_vgnca_bnfcro

					if @@ROWCOUNT = 0
						Begin
							Update		@tb_tmpAfiliado
							Set			cnsctvo_cdgo_pln_pc	= c.cnsctvo_cdgo_pln,
										smns_ctzds_ss_pc	= b.smns_ctzds,
										smns_ctzds_eps_pc	= b.smns_ctzds_antrr_eps,
										smns_aflcn_ss_pc	= b.smns_aflcn_antrr_eps,
										smns_aflcn_eps_pc	= b.smns_aflcn
							From		@tb_tmpAfiliado				t,
										@tiempoAfiliacion			b
							Inner Join	#tmpContratosValidador		c	On	b.cnsctvo_cdgo_tpo_cntrto	= c.cnsctvo_cdgo_tpo_cntrto
																		And	b.nmro_cntrto				= c.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
							Inner Join	(	Select	Max(fn_vgnca_bnfcro) as fn_vgnca_bnfcro
											From	@tiempoAfiliacion
											Where	cnsctvo_cdgo_tpo_cntrto	= 1
										)	g	On	g.fn_vgnca_bnfcro	=	b.fn_vgnca_bnfcro
							Where		c.cnsctvo_cdgo_tpo_cntrto	= 2
						End
				End

			Update		@tb_tmpAfiliado
			Set			cnsctvo_cdgo_estdo_drcho	= m.cnsctvo_cdgo_estdo_drcho,
						cnsctvo_cdgo_csa_drcho		= m.cnsctvo_cdgo_csa_drcho,
						dscrpcn_csa_drcho		= isnull(c.dscrpcn_csa_drcho,' ')
			From		@tb_tmpAfiliado										t
			INNER JOIN	bdAfiliacionValidador.dbo.TbMatrizDerechosValidador	m	With(index(IX_TbMatrizDerechosValidador_inco_fin_v))	on	m.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																																		And	m.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS = t.nmro_cntrto --COLLATE SQL_Latin1_General_CP1_CI_AS              
																																		And	m.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
			INNER JOIN	bdAfiliacionValidador.dbo.tbCausasDerechoValidador	c	With(NoLock)											On	m.cnsctvo_cdgo_estdo_drcho	= c.cnsctvo_cdgo_estdo_drcho
																																		And	m.cnsctvo_cdgo_csa_drcho	= c.cnsctvo_cdgo_csa_drcho
		End

	-- INICIO NUEVA VALIDACIÓN - 20150507 - SISCGM01 --
	if @Bd = '5' --Marca No existe en el Sistema
		begin
			-- Se busca la maxima vigencia para el estado valido
			Select		@maximafechabeneficiario	=	Max(v.fn_vgnca_estdo_bnfcro)  
			From		#tmpBeneficiariosValidador				b	With(NoLock)
			INNER JOIN	#tmpContratosValidador					c	With(NoLock)	On	b.nmro_cntrto				=	c.nmro_cntrto
																					And	b.cnsctvo_cdgo_tpo_cntrto	=	c.cnsctvo_cdgo_tpo_cntrto
			Inner Join	#tmpVigenciasBeneficiariosValidador		v	With(NoLock)	On	v.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
																					And	v.nmro_cntrto				=	b.nmro_cntrto
																					And	v.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro

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
			From		#tmpBeneficiariosValidador				b	With(NoLock)
			Inner Join	#tmpContratosValidador					c	With(NoLock)	On	b.nmro_cntrto				=	c.nmro_cntrto
																					And	b.cnsctvo_cdgo_tpo_cntrto	=	c.cnsctvo_cdgo_tpo_cntrto
			Inner Join	#tmpVigenciasBeneficiariosValidador		v	With(NoLock)	On	v.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
																					And	v.nmro_cntrto				=	b.nmro_cntrto
																					And	v.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro
			Where		@maximafechabeneficiario Between v.inco_vgnca_estdo_bnfcro And v.fn_vgnca_estdo_bnfcro

			if (select count(1) from 	@tb_tmpAfiliado) >	0 
				begin
					set @mnsje 	= 'USUARIO RETIRADO'

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
				end
			ELSE
				BEGIN
					Set @mnsje 	= 'NO EXISTE EN EL SISTEMA'
					Select	*
					From	@tb_tmpAfiliado
					return
				END
		END
	-- FIN NUEVA VALIDACIÓN - 20150507 - SISCGM01 --

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
	From		@tb_tmpAfiliado										t
	INNER JOIN	bdAfiliacionValidador.dbo.tbParentescos_vigencias	p	With(NoLock)	On	t.cnsctvo_cdgo_prntsco = p.cnsctvo_cdgo_prntscs

	Update		@tb_tmpAfiliado
	Set 		dscrpcn_tpo_afldo = a.dscrpcn,
				cdgo_tpo_afldo	  = a.cdgo_tpo_afldo 
	From		@tb_tmpAfiliado										t
	INNER JOIN	bdAfiliacionValidador.dbo.tbTiposAfiliado_vigencias	a	With(NoLock)	On	t.cnsctvo_cdgo_tpo_afldo	= a.cnsctvo_cdgo_tpo_afldo

	Update		@tb_tmpAfiliado
	Set			cnsctvo_cdgo_rngo_slrl	= 4
	Where		cnsctvo_cdgo_rngo_slrl	= 0
	And			cnsctvo_cdgo_tpo_cntrto	!= 1

	Update		@tb_tmpAfiliado
	Set 		dscrpcn_rngo_slrl = r.dscrpcn_rngo_slrl,
				cdgo_rngo_slrl	  = r.cdgo_rngo_slrl 
	From		@tb_tmpAfiliado											t
	INNER JOIN	bdAfiliacionValidador.dbo.tbRangosSalariales_vigencias	r	With(NoLock)	On	t.cnsctvo_cdgo_rngo_slrl	= r.cnsctvo_cdgo_rngo_slrl

	Update		@tb_tmpAfiliado
	Set			dscrpcn_pln_pc = isnull(p.dscrpcn_pln,'') 
	From		@tb_tmpAfiliado									t
	INNER JOIN	bdAfiliacionValidador.dbo.tbPlanes_vigencias	p	With(NoLock)	On	t.cnsctvo_cdgo_pln_pc = p.cnsctvo_cdgo_pln

	--Ajuste Calculo de Sede
	Update		@tb_tmpAfiliado
	Set			dscrpcn_ips_prmra = i.nmbre_scrsl,
				cnsctvo_cdgo_sde_ips = i.cnsctvo_cdgo_sde_ips --Adicion Campo sede 
	From		@tb_tmpAfiliado										t
	INNER JOIN	bdAfiliacionValidador.dbo.tbIpsPrimarias_vigencias	i	With(NoLock)	On	t.cdgo_ips_prmra	= i.cdgo_intrno --COLLATE SQL_Latin1_General_CP1_CI_AS

	Update		@tb_tmpAfiliado
	set			cnsctvo_cdgo_sde_ips  = c.cnsctvo_sde_inflnca
	from		@tb_tmpAfiliado									t
	INNER JOIN	bdAfiliacionValidador.dbo.tbCiudades_Vigencias	c	With(NoLock)	On	t.cnsctvo_cdgo_cdd_rsdnca = c.cnsctvo_cdgo_cdd 
	Where		t.cnsctvo_cdgo_tpo_cntrto=2  --Solo Para Plan PAC

	Update		@tb_tmpAfiliado
	Set 		dscrpcn_estdo_drcho			= edv.dscrpcn_estdo_drcho,
				dscrpcn_drcho				= edv.dscrpcn_drcho,
				cnsctvo_cdgo_estdo_drcho	= edv.cnsctvo_cdgo_estdo_drcho,
				drcho = edv.drcho
	From		bdAfiliacionValidador.dbo.tbEstadosDerechoValidador	edv	With(NoLock)
	INNER JOIN	@tb_tmpAfiliado										a	On	a.cnsctvo_cdgo_estdo_drcho 	= edv.cnsctvo_cdgo_estdo_drcho

	Update		@tb_tmpAfiliado
	Set			cdgo_tpo_idntfccn	= i.cdgo_tpo_idntfccn
	From		@tb_tmpAfiliado												t
	INNER JOIN	bdAfiliacionValidador.dbo.tbTiposIdentificacion_vigencias	i	With(NoLock)	On	t.cnsctvo_cdgo_tpo_idntfccn	= i.cnsctvo_cdgo_tpo_idntfccn

	Update		@tb_tmpAfiliado
	Set			cdgo_tpo_idntfccn_ctznte	= i.cdgo_tpo_idntfccn
	From		@tb_tmpAfiliado												t
	INNER JOIN	bdAfiliacionValidador.dbo.tbTiposIdentificacion_vigencias	i	With(NoLock)	On	t.cnsctvo_tpo_idntfccn_ctznte	= i.cnsctvo_cdgo_tpo_idntfccn

	Update		@tb_tmpAfiliado
	Set			cdgo_sxo	= s.cdgo_sxo
	From		@tb_tmpAfiliado								t
	INNER JOIN	bdAfiliacionValidador.dbo.tbSexos_vigencias	s	With(NoLock)	On	t.cnsctvo_cdgo_sxo	= s.cnsctvo_cdgo_sxo

	Update		@tb_tmpAfiliado
	Set			dscrpcn_pln	= p.dscrpcn_pln
	From		@tb_tmpAfiliado						t
	INNER JOIN	bdAfiliacionValidador.dbo.tbPlanes	p	With(NoLock)	On	t.cnsctvo_cdgo_pln	= p.cnsctvo_cdgo_pln

	--cnsctvo_cdgo_sde_ips
	Update		@tb_tmpAfiliado
	Set			cnsctvo_cdgo_sde_ips	= d.cnsctvo_cdgo_sde_ips
	From		bdAfiliacionValidador.dbo.tbIpsPrimarias_vigencias	d	With(NoLock)
	INNER JOIN	@tb_tmpAfiliado										t	On	d.cdgo_intrno	= t.cdgo_ips_prmra
	Where		@fcha_vldccn Between d.inco_vgnca And d.fn_vgnca

	Update		@tb_tmpAfiliado
	set			cnsctvo_cdgo_sde_ips  = c.cnsctvo_sde_inflnca
	from		@tb_tmpAfiliado									t
	INNER JOIN	bdAfiliacionValidador.dbo.tbCiudades_Vigencias	c	With(NoLock)	On	t.cnsctvo_cdgo_cdd_rsdnca = c.cnsctvo_cdgo_cdd 
	Where		t.cnsctvo_cdgo_tpo_cntrto=2  --Solo Para Plan PAC

	Update		@tb_tmpAfiliado
	Set			flg_enble_nmro_vldcn	= 'S'
	Where		cnsctvo_cdgo_estdo_drcho In (6,7,8)	--In (8) Suspendido (7) Retirado (6) En Proceso

	Update		@tb_tmpAfiliado
	Set			cnsctvo_tpo_vldcn_actva	= 2
	Where		orgn					= '2'	--Formularios

	Update		@tb_tmpAfiliado
	Set			cnsctvo_tpo_vldcn_actva		=	2
	Where		orgn						=	'1'	--Contratos
	And			cnsctvo_cdgo_estdo_drcho	in (6,7,8)	-- 6 EN PROCESO 7 Retirado, 8 suspendido

	Update		@tb_tmpAfiliado
	Set			cnsctvo_tpo_vldcn_actva		= 1
	From		@tb_tmpAfiliado	a
	Left Join	(	Select	cnsctvo_cdgo_estdo_drcho
					From	@tb_tmpAfiliado
					Where	cnsctvo_cdgo_estdo_drcho In (6,7,8)	-- 6 EN PROCESO 7 Retirado, 8 suspendido
				)	b	On	b.cnsctvo_cdgo_estdo_drcho	=	a.cnsctvo_cdgo_estdo_drcho
	Where		orgn	= '1'	--Contratos
	And			b.cnsctvo_cdgo_estdo_drcho Is Null

	Update		@tb_tmpAfiliado
	Set			cnsctvo_tpo_vldcn_actva	= 1
	Where		orgn				= '3'	--Famisanar

	Update		@tb_tmpAfiliado
	Set			dscrpcn_cdd_rsdnca	= c.dscrpcn_cdd,
				cdgo_cdd			= c.cdgo_cdd
	From		bdAfiliacionValidador.dbo.tbCiudades	c	With(NoLock)
	INNER JOIN	@tb_tmpAfiliado							t	On	c.cnsctvo_cdgo_cdd	= t.cnsctvo_cdgo_cdd_rsdnca

	Update		@tb_tmpAfiliado
	Set			cdgo_afp	= cdgo_entdd
	From		bdAfiliacionValidador.dbo.tbEntidades_Vigencias	e	With(NoLock)
	INNER JOIN	@tb_tmpAfiliado									t	On	t.cnsctvo_cdgo_afp	= e.cnsctvo_cdgo_entdd	

	Update		@tb_tmpAfiliado
	Set			cfcha_ncmnto	= convert(char(10),fcha_ncmnto,111)

	Select		@lfFechaReferencia	= fn_vgnca_bnfcro
	From		@tb_tmpAfiliado
	Where		Convert(char(10),fn_vgnca_bnfcro,111)	< @fcha_vldccn
	And			orgn		= '1'	--Contratos

	Select		@lfFechaReferencia	= fcha_hsta
	From		@tb_tmpAfiliado
	Where		Convert(char(10),fcha_hsta,111)	< @fcha_vldccn
	And			orgn		!= '1'	--Contratos

	Select		prmr_aplldo,				sgndo_aplldo,					prmr_nmbre,							sgndo_nmbre,						cnsctvo_cdgo_tpo_idntfccn,
				nmro_idntfccn,				fcha_ncmnto,					cnsctvo_cdgo_sxo,					cdgo_sxo,							edd,
				edd_mss,					edd_ds,							cnsctvo_cdgo_tpo_undd,				orgn,								cnsctvo_cdgo_tpo_cntrto,
				nmro_cntrto,				cnsctvo_cdgo_pln,				nmro_unco_idntfccn_afldo,			inco_vgnca_bnfcro,					fn_vgnca_bnfcro,
				cnsctvo_cdgo_prntsco,		dscrpcn_prntsco,				cnsctvo_cdgo_tpo_afldo,				dscrpcn_tpo_afldo,					cnsctvo_cdgo_rngo_slrl,
				dscrpcn_rngo_slrl,			cnsctvo_cdgo_pln_pc,			dscrpcn_pln_pc,						smns_ctzds_ss_ps,					smns_ctzds_eps_ps,
				smns_ctzds_ss_pc,			smns_ctzds_eps_pc,				cdgo_ips_prmra,						dscrpcn_ips_prmra,					cnsctvo_bnfcro,
				cdgo_eapb,					nmro_unco_idntfccn_ctznte,		cnsctvo_cdgo_tpo_cntrto_psc,		nmro_cntrto_psc,					ds_ctzds,
				cnsctvo_cdgo_sde_ips,		dscrpcn_tpo_cntrto,				cnsctvo_cdgo_csa_drcho,				cnsctvo_cdgo_estdo_drcho,			dscrpcn_estdo_drcho,
				dscrpcn_csa_drcho,			dscrpcn_drcho,					dscrpcn_pln,						dscrpcn_tpo_ctznte,					prmr_nmbre_ctznte,
				sgndo_nmbre_ctznte,			prmr_aplldo_ctznte,				sgndo_aplldo_ctznte,				drccn_rsdnca,						tlfno_rsdnca,
				cnsctvo_cdgo_cdd_rsdnca,	dscrpcn_cdd_rsdnca,				cnsctvo_cdgo_estdo_cvl,				dscrpcn_estdo_cvl,					cnsctvo_cdgo_tpo_frmlro,
				nmro_frmlro,				cdgo_tpo_idntfccn,				cnsctvo_cdgo_afp,					fcha_dsde,							fcha_hsta,
				flg_enble_nmro_vldcn,		drcho,							cdgo_afp,							cnsctvo_tpo_vldcn_actva,			cfcha_ncmnto,
				smns_aflcn_ss_ps,			smns_aflcn_eps_ps,				smns_aflcn_ss_pc,					smns_aflcn_eps_pc,					smns_ctzds_eps,
				cdgo_tpo_prntsco,			cdgo_cdd,						cdgo_rngo_slrl,						cdgo_tpo_afldo,						cdgo_tpo_idntfccn_ctznte,
				nmro_idntfccn_ctznte,		cnsctvo_tpo_idntfccn_ctznte,	@lfFechaReferencia fcha_rfrnca,		@fcha_mxma_rprte fcha_mxma_rprte,	cnsctvo_dcmnto_gnrdo,
				nmro_dcmnto,				eml
	From		@tb_tmpAfiliado

	Drop Table	#tmpBeneficiariosValidador
	Drop Table	#tmpVigenciasBeneficiariosValidador
	Drop Table	#tmpContratosValidador
End


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDiaNUI] TO [330004 Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDiaNUI] TO [330001 Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDiaNUI] TO [330007 Liquidador Facturas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDiaNUI] TO [SOS\330008 Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDiaNUI] TO [autsalud_rol]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDiaNUI] TO [webusr]
    AS [dbo];

