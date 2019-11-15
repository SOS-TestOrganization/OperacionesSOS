CREATE procedure [dbo].[spPmConsultaAfiliado_AlDia]
@cnsctvo_cdgo_tpo_idntfccn 	udtConsecutivo, 
@nmro_idntfccn				Varchar(23),
@cnsctvo_cdgo_pln 			udtConsecutivo,
@mnsje						varchar(80)		output,
--@Bd 						char(1) =null,
@origen						char(1),
@lfFechaReferencia			datetime		output

AS
Set NoCount On

/*
Set	@cnsctvo_cdgo_tpo_idntfccn	= 1
Set	@nmro_idntfccn			= '94526804'
Set	@cnsctvo_cdgo_pln		= 8
Set	@mnsje					= ''
Set	@origen					= null
Set	@lfFechaReferencia		= ''
*/

-- Declaración de variables
Declare	@fcha_vldccn				datetime,
		@Nui_Afldo					UdtConsecutivo,
		@Bd 						char(1),
		@inco_vgnca_bnfcro			Datetime,
		@fcha_ultma_mdfccn			Datetime,	
		--@lfFechaReferencia		datetime,
		@dFcha_pvte					datetime,
		@Historico					char(1),
		@fcha_mxma_rprte			datetime,
		@maximafechabeneficiario	datetime,
		@nmbre_srvdr				VarChar(50),
		@hst_nme					VarChar(50)

Set		@fcha_vldccn = Convert(char(10),getDate(),111)
Set		@lfFechaReferencia = @fcha_vldccn

---- ORENDA
Select		@nmbre_srvdr = Ltrim(Rtrim(vlr_prmtro))  
From		BDAfiliacionValidador.dbo.tbtablaParametros  With(NoLock)
Where		cnsctvo_prmtro = 5

Select		@hst_nme = Ltrim(Rtrim(Convert(Varchar(30), SERVERPROPERTY('machinename'))))

-- Se crea función para calcular la fecha hasta para los reportes de validador de derechos, requerimiento segun gerencia, antes a la fecha del sistema se sumaba 5 días, ahora son 115
Select		@fcha_mxma_rprte = dbo.fnCalcularFechaReporteValidadorDerechos(@fcha_vldccn)

Declare @tb_Contrato Table
		(
			cnsctvo_cdgo_tpo_cntrto	int,
			nmro_cntrto				char(15),
			cnsctvo_bnfcro			int
		)

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
			cdgo_cdd 					char(8) , 			cdgo_rngo_slrl 				char(3),
			cdgo_tpo_afldo 				char(3) , 			cdgo_tpo_idntfccn_ctznte 	char(3),
			nmro_idntfccn_ctznte 		char(20),			cnsctvo_tpo_idntfccn_ctznte	int,
			cnsctvo_dcmnto_gnrdo		int default 0,		nmro_dcmnto					Char(50) default ' ',
			cdgo_estdo_drcho			char(2),			eml							varchar(50),
			inco_vgnca_cntrto			datetime,			fn_vgnca_cntrto				datetime
		--	fcha_mxma_rprte char(10) DEFAULT convert(char(10),getdate()+15,111) NOT NULL 
		)

Declare	@tiempoAfiliacion Table
		(
			smns_ctzds					int,
			smns_aflcn					int,
			smns_ctzds_antrr_eps		int,
			smns_aflcn_antrr_eps		int,
			cnsctvo_cdgo_tpo_cntrto		int,
			nmro_cntrto					varchar(15),
			inco_vgnca_bnfcro			datetime,
			fn_vgnca_bnfcro				datetime,
			nmro_unco_idntfccn_afldo	int
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
Where		cnsctvo_cdgo_tpo_idntfccn	= @cnsctvo_cdgo_tpo_idntfccn
And			nmro_idntfccn				= @nmro_idntfccn

Insert Into #tmpVigenciasBeneficiariosValidador
Select		v.cnsctvo_cdgo_tpo_cntrto,							v.nmro_cntrto,			v.cnsctvo_bnfcro,	Convert(char(10),v.inco_vgnca_estdo_bnfcro,111),
			Convert(char(10),v.fn_vgnca_estdo_bnfcro,111),		a.estdo
From		BDAfiliacionValidador.dbo.tbVigenciasBeneficiariosValidador	v	With(NoLock)
Inner Join	#tmpBeneficiariosValidador									a	With(NoLock)	On	a.cnsctvo_cdgo_tpo_cntrto	=	v.cnsctvo_cdgo_tpo_cntrto
																							And	a.nmro_cntrto				=	v.nmro_cntrto
																							And	a.cnsctvo_bnfcro			=	v.cnsctvo_bnfcro
Where		a.cnsctvo_cdgo_tpo_idntfccn	= @cnsctvo_cdgo_tpo_idntfccn
And			a.nmro_idntfccn				= @nmro_idntfccn

Insert Into	#tmpContratosValidador
Select		c.cnsctvo_cdgo_tpo_cntrto,			c.nmro_cntrto,					c.nmro_unco_idntfccn_afldo,						c.cnsctvo_cdgo_tpo_idntfccn,
			c.nmro_idntfccn,					c.cnsctvo_cdgo_pln,				Ltrim(Rtrim(c.prmr_aplldo)),					Ltrim(Rtrim(c.sgndo_aplldo)),
			Ltrim(Rtrim(c.prmr_nmbre)),			Ltrim(Rtrim(c.sgndo_nmbre)),	Convert(char(10),c.inco_vgnca_cntrto,111),		Convert(char(10),c.fn_vgnca_cntrto,111),
			c.cnsctvo_cdgo_rngo_slrl,			c.cnsctvo_cdgo_afp
From		BDAfiliacionValidador.dbo.tbContratosValidador	c	With(NoLock)
Inner Join	#tmpBeneficiariosValidador						a	With(NoLock)	On	a.cnsctvo_cdgo_tpo_cntrto	=	c.cnsctvo_cdgo_tpo_cntrto
																				And	a.nmro_cntrto				=	c.nmro_cntrto

--Modificacion sisdgb01 17/05/2013
SET	@maximafechabeneficiario = (	Select		max(c.fn_vgnca_estdo_bnfcro) 
									From		#tmpBeneficiariosValidador			a	With(NoLock)
									Inner Join	#tmpVigenciasBeneficiariosValidador	c	With(NoLock)	On	c.cnsctvo_cdgo_tpo_cntrto	=	a.cnsctvo_cdgo_tpo_cntrto
																										And	c.nmro_cntrto				=	a.nmro_cntrto
																										And	c.cnsctvo_bnfcro			=	a.cnsctvo_bnfcro
									Where		a.cnsctvo_cdgo_tpo_idntfccn	= @cnsctvo_cdgo_tpo_idntfccn
									And			a.nmro_idntfccn				= @nmro_idntfccn
									And			a.estdo = 'A'
								) 

--busco el numero unico del afiliado
if	@maximafechabeneficiario is not null 
	Begin
		SET @Nui_Afldo	=	(	select distinct nmro_unco_idntfccn_afldo
								From			#tmpBeneficiariosValidador	With(NoLock)
								Where			cnsctvo_cdgo_tpo_idntfccn		= @cnsctvo_cdgo_tpo_idntfccn
								And				nmro_idntfccn					= @nmro_idntfccn
								And				estdo = 'A' and fn_vgnca_bnfcro = @maximafechabeneficiario
							)
  -- Quick 2013-029-006915 Se estaba consultando NUI antiguos para el num de identificacion
	End
Else 
	Begin
		Set	@maximafechabeneficiario	=	(	Select		max(c.fn_vgnca_estdo_bnfcro)
												From		#tmpBeneficiariosValidador			a	With(NoLock)
												Inner Join	#tmpVigenciasBeneficiariosValidador	c	With(NoLock)	On	c.cnsctvo_cdgo_tpo_cntrto	=	a.cnsctvo_cdgo_tpo_cntrto
																													And	c.nmro_cntrto				=	a.nmro_cntrto
																													And	c.cnsctvo_bnfcro			=	a.cnsctvo_bnfcro
												Where		a.cnsctvo_cdgo_tpo_idntfccn	= @cnsctvo_cdgo_tpo_idntfccn
												And			a.nmro_idntfccn				= @nmro_idntfccn
												And			a.estdo = 'I'
											)

		Set @Nui_Afldo	=	(	Select distinct nmro_unco_idntfccn_afldo
								From			#tmpBeneficiariosValidador	With(NoLock)
								Where			cnsctvo_cdgo_tpo_idntfccn	= @cnsctvo_cdgo_tpo_idntfccn
								And				nmro_idntfccn				= @nmro_idntfccn
								And				estdo						= 'I'
								And				fn_vgnca_bnfcro = @maximafechabeneficiario
							)
	End

Set	@Bd = @origen	

If Isnull(@Bd,'') =' ' Or @bd = '1'
	Begin
		Insert Into @tb_tmpAfiliado
				(	prmr_aplldo,						sgndo_aplldo,					prmr_nmbre,
					sgndo_nmbre,						cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,
					fcha_ncmnto,						cnsctvo_cdgo_sxo,				orgn,
					cnsctvo_cdgo_tpo_cntrto,			nmro_cntrto,					cnsctvo_cdgo_pln,
					nmro_unco_idntfccn_afldo,			inco_vgnca_bnfcro,				fn_vgnca_bnfcro,
					cnsctvo_cdgo_prntsco,				cnsctvo_cdgo_tpo_afldo,			cnsctvo_cdgo_rngo_slrl,
					smns_ctzds_ss_ps,					smns_ctzds_eps_ps,				cdgo_ips_prmra,
					cnsctvo_bnfcro,						cnsctvo_cdgo_afp,				fcha_dsde,
					fcha_hsta,							tlfno_rsdnca,					drccn_rsdnca,
					cnsctvo_cdgo_cdd_rsdnca,			prmr_nmbre_ctznte,				sgndo_nmbre_ctznte,
					prmr_aplldo_ctznte,					sgndo_aplldo_ctznte,			cnsctvo_tpo_idntfccn_ctznte,
					nmro_idntfccn_ctznte,				nmro_unco_idntfccn_ctznte,		eml,
					inco_vgnca_cntrto,					fn_vgnca_cntrto
				)
		Select		b.prmr_aplldo,						b.sgndo_aplldo,					b.prmr_nmbre,
					b.sgndo_nmbre,						b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,
					b.fcha_ncmnto,						b.cnsctvo_cdgo_sxo,				'1',
					b.cnsctvo_cdgo_tpo_cntrto,			b.nmro_cntrto,					c.cnsctvo_cdgo_pln,
					b.nmro_unco_idntfccn_afldo,			v.inco_vgnca_estdo_bnfcro,		v.fn_vgnca_estdo_bnfcro,
					b.cnsctvo_cdgo_prntsco,				b.cnsctvo_cdgo_tpo_afldo,		c.cnsctvo_cdgo_rngo_slrl,
					b.smns_ctzds_antrr_eps,				b.smns_ctzds,					b.cdgo_intrno,
					b.cnsctvo_bnfcro,					c.cnsctvo_cdgo_afp,				b.inco_vgnca_bnfcro,
					b.fn_vgnca_bnfcro,					b.tlfno_rsdnca,					b.drccn_rsdnca,
					b.cnsctvo_cdgo_cdd_rsdnca,			c.prmr_aplldo,					c.sgndo_aplldo,
					c.prmr_nmbre,						c.sgndo_nmbre,					c.cnsctvo_cdgo_tpo_idntfccn,
					c.nmro_idntfccn,					c.nmro_unco_idntfccn_afldo,		isnull(b.eml,'') as eml,
					c.inco_vgnca_cntrto,				c.fn_vgnca_cntrto
		From		#tmpBeneficiariosValidador			b	With(NoLock)
		INNER JOIN	#tmpContratosValidador				c	With(NoLock)	On	b.nmro_cntrto					=	c.nmro_cntrto
																			And	b.cnsctvo_cdgo_tpo_cntrto		=	c.cnsctvo_cdgo_tpo_cntrto
		Inner Join	#tmpVigenciasBeneficiariosValidador	v	With(NoLock)	On	v.cnsctvo_cdgo_tpo_cntrto		=	b.cnsctvo_cdgo_tpo_cntrto
																			And	v.nmro_cntrto					=	b.nmro_cntrto
																			And	v.cnsctvo_bnfcro				=	b.cnsctvo_bnfcro
		Where		b.nmro_unco_idntfccn_afldo	= @Nui_Afldo
		And			c.cnsctvo_cdgo_pln			= @cnsctvo_cdgo_pln
		And			@fcha_vldccn Between v.inco_vgnca_estdo_bnfcro And v.fn_vgnca_estdo_bnfcro

		--Si existe un contrato vigente
		If exists	(	select	1
						from	@tb_tmpAfiliado
						Where	@fcha_vldccn Between inco_vgnca_cntrto And fn_vgnca_cntrto
						And		@fcha_vldccn Between inco_vgnca_bnfcro And fn_vgnca_bnfcro
					)
			Begin
				--si ademas le pertenece el tipo y numero de id del afiliado
				If Exists	(	select	1
								from	@tb_tmpAfiliado
								where	cnsctvo_cdgo_tpo_idntfccn	= @cnsctvo_cdgo_tpo_idntfccn
								And		nmro_idntfccn				= @nmro_idntfccn
								And		@fcha_vldccn Between inco_vgnca_cntrto And fn_vgnca_cntrto
								And		@fcha_vldccn Between inco_vgnca_bnfcro And fn_vgnca_bnfcro
							)
					Begin
						Insert into @tb_Contrato(cnsctvo_cdgo_tpo_cntrto, nmro_cntrto,cnsctvo_bnfcro)
						Select		cnsctvo_cdgo_tpo_cntrto, nmro_cntrto,cnsctvo_bnfcro
						from		@tb_tmpAfiliado
						where		cnsctvo_cdgo_tpo_idntfccn	=	@cnsctvo_cdgo_tpo_idntfccn
						And			nmro_idntfccn				=	@nmro_idntfccn
						And			@fcha_vldccn Between inco_vgnca_cntrto And fn_vgnca_cntrto
						And			@fcha_vldccn Between inco_vgnca_bnfcro And fn_vgnca_bnfcro
			
						--borra datos que no son del mismo contrato y del afiliado
						Delete		a
						From		@tb_tmpAfiliado a
						Left Join	@tb_Contrato	b	On	a.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
														and a.nmro_cntrto				= b.nmro_cntrto
						Where		cnsctvo_cdgo_tpo_idntfccn	= @cnsctvo_cdgo_tpo_idntfccn
						And			nmro_idntfccn				= @nmro_idntfccn
						And			b.cnsctvo_cdgo_tpo_cntrto is null

						Set @bd 	= '1'  -- Contratos
					End
				Else
					Delete from @tb_tmpAfiliado
			End
		Else
			Begin
				--busco el contrato con la fecha maxima de vigencia
				Insert into		@tb_Contrato(cnsctvo_cdgo_tpo_cntrto, nmro_cntrto, cnsctvo_bnfcro)
				Select top 1	cnsctvo_cdgo_tpo_cntrto, nmro_cntrto, cnsctvo_bnfcro  
				From			@tb_tmpAfiliado 
				Order By		fn_vgnca_bnfcro desc

				--borra datos si ese contrato no le pertenece al afiliado
				If not exists	(	Select		top 1 *
									From		@tb_tmpAfiliado a
									Inner join	@tb_Contrato	b	On	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
																	And a.nmro_cntrto				=	b.nmro_cntrto
																	And a.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro
									Where		a.cnsctvo_cdgo_tpo_idntfccn = @cnsctvo_cdgo_tpo_idntfccn
									And			a.nmro_idntfccn				= @nmro_idntfccn
								)
					Delete from @tb_tmpAfiliado
				Else
					Begin
						--borra datos que no son del mismo contrato y del afiliado
						Delete		a
						from		@tb_tmpAfiliado a
						left join	@tb_Contrato	b	On	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
														And a.nmro_cntrto				=	b.nmro_cntrto
														And a.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro				
						Where		cnsctvo_cdgo_tpo_idntfccn	= @cnsctvo_cdgo_tpo_idntfccn
						And			nmro_idntfccn				= @nmro_idntfccn
						And			b.cnsctvo_cdgo_tpo_cntrto is null

						Set @bd 	= '1'  -- Contratos
					End
			End
	End

If Isnull(@Bd,'') =' ' Or @bd = '3'
	Begin
		Insert Into @tb_tmpAfiliado
				(	prmr_aplldo, 							sgndo_aplldo, 							prmr_nmbre, 
					sgndo_nmbre, 							cnsctvo_cdgo_tpo_idntfccn,				nmro_idntfccn,
					fcha_ncmnto, 							cdgo_sxo,								cnsctvo_cdgo_sxo,
					cnsctvo_cdgo_prntsco,					cnsctvo_cdgo_pln,						cnsctvo_cdgo_tpo_afldo,
					cnsctvo_cdgo_rngo_slrl,					inco_vgnca_bnfcro,						fn_vgnca_bnfcro,
					smns_aflcn_eps_ps,						smns_ctzds_eps_ps,						smns_aflcn_eps_pc,
					smns_aflcn_ss_pc,						cnsctvo_cdgo_estdo_drcho,				cdgo_ips_prmra,
					cdgo_eapb,								cnsctvo_cdgo_tpo_cntrto,				nmro_cntrto,
					orgn,									fcha_dsde,								fcha_hsta,
					tlfno_rsdnca,							drccn_rsdnca
				)
		Select 		Ltrim(Rtrim(a.prmr_aplldo_bnfcro)), 	isnull(a.sgndo_aplldo_bnfcro,''),							Ltrim(Rtrim(a.prmr_nmbre_bnfcro)),
					Ltrim(Rtrim(a.sgndo_nmbre_bnfcro)),		a.cnsctvo_cdgo_tpo_idntfccn_bnfcro,							a.nmro_idntfccn_bnfcro,
					a.fcha_ncmnto, 							a.sxo,														a.cnsctvo_cdgo_sxo,
					a.cnsctvo_cdgo_prntscs,					a.cnsctvo_cdgo_pln,											a.cnsctvo_cdgo_tpo_afldo,
					a.cnsctvo_cdgo_rngo_slrl,				convert(char(10),a.inco_vgnca, 111),						convert(char(10),a.fn_vgnca, 111),
					0,										a.smns_ctzds,												0,
					0,										a.estdo,													a.ips,
					a.cdgo_eapb,							0,															0,
					'3',									convert(char(10),fcha_dsde, 111),							convert(char(10),fcha_hsta, 111),
					tlfno,									drccn
		From 		BDAfiliacionValidador.dbo.tbEapb					a	With(NoLock)
		Inner Join	BDAfiliacionValidador.dbo.tbDetalleeapb_Vigencias	b	With(NoLock)	On	b.cdgo_eapb		= a.cdgo_eapb
		Where 		a.nmro_idntfccn_bnfcro 				= @nmro_idntfccn
		And			a.cnsctvo_cdgo_tpo_idntfccn_bnfcro	= @cnsctvo_cdgo_tpo_idntfccn
		And			a.cnsctvo_cdgo_pln					= @cnsctvo_cdgo_pln 
		And			(@fcha_vldccn Between b.inco_vgnca and b.fn_vgnca)
		And			b.vsble_vlddr						= 'S'

		If Exists	(	Select 1
						From	@tb_tmpAfiliado
						Where	@fcha_vldccn Between inco_vgnca_bnfcro And fn_vgnca_bnfcro
						And	orgn	= '3'
					)

			Begin
				Delete	@tb_tmpAfiliado
				Where	inco_vgnca_bnfcro > @fcha_vldccn 
				Or		@fcha_vldccn > fn_vgnca_bnfcro
				--		Or	orgn	!= '3' --Se comentarea para analisis

				Set @bd 	= '3'  -- FAMISANAR
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
		Or		orgn		<> @bd

		Set @mnsje = Case @bd
				When '1' Then 'CONTRATOS'
				When '2' Then 'FORMULARIOS'
				When '3' Then 'FAMISANAR'
				End

		Select		@mnsje 		= Rtrim(Ltrim(dscrpcn_eapb))
		From		BDAfiliacionValidador.dbo.tbDetalleEapb_Vigencias	a	With(NoLock)
		Inner Join	@tb_tmpAfiliado										b	On	b.cdgo_eapb	= a.cdgo_eapb
		Where		orgn		= '3'
	End


/*******************************************************************************
***	Se actualizan los datos restantes
*******************************************************************************/
If  @bd = '1' -- Contratos
	Begin
		Insert into @tiempoAfiliacion
				(	smns_ctzds,						smns_aflcn,							smns_ctzds_antrr_eps,
					smns_aflcn_antrr_eps,			cnsctvo_cdgo_tpo_cntrto,			nmro_cntrto,
					inco_vgnca_bnfcro,				fn_vgnca_bnfcro,					nmro_unco_idntfccn_afldo
				)
		Select		b.smns_ctzds,					b.smns_aflcn,						b.smns_ctzds_antrr_eps,
					smns_aflcn_antrr_eps,			b.cnsctvo_cdgo_tpo_cntrto,			b.nmro_cntrto,
					c.inco_vgnca_estdo_bnfcro,		c.fn_vgnca_estdo_bnfcro,			b.nmro_unco_idntfccn_afldo
		From		@tb_tmpAfiliado						t
		Inner Join	#tmpBeneficiariosValidador			b	With(NoLock)	On	b.nmro_unco_idntfccn_afldo	=	t.nmro_unco_idntfccn_afldo
																			And b.cnsctvo_cdgo_tpo_cntrto	=	t.cnsctvo_cdgo_tpo_cntrto
																			And b.nmro_cntrto				=	t.nmro_cntrto
		Inner Join	#tmpVigenciasBeneficiariosValidador	c	With(NoLock)	On	c.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
																			And	c.nmro_cntrto				=	b.nmro_cntrto
																			And	c.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro

		If exists	(	select	1
						from	@tiempoAfiliacion
						where	cnsctvo_cdgo_tpo_cntrto = 1
					)
			Begin
				Insert into @tiempoAfiliacion
						(	smns_ctzds,					smns_aflcn,						smns_ctzds_antrr_eps,
							smns_aflcn_antrr_eps,		cnsctvo_cdgo_tpo_cntrto,		nmro_cntrto,
							inco_vgnca_bnfcro,			fn_vgnca_bnfcro,				nmro_unco_idntfccn_afldo
						)
				Select		b.smns_ctzds,				b.smns_aflcn,					b.smns_ctzds_antrr_eps,
							smns_aflcn_antrr_eps,		b.cnsctvo_cdgo_tpo_cntrto,		b.nmro_cntrto,
							c.inco_vgnca_estdo_bnfcro,	c.fn_vgnca_estdo_bnfcro,		b.nmro_unco_idntfccn_afldo
				From		@tb_tmpAfiliado						t
				Inner Join	#tmpBeneficiariosValidador			b	With(NoLock)	On	b.nmro_unco_idntfccn_afldo	=	t.nmro_unco_idntfccn_afldo
				Inner Join	#tmpVigenciasBeneficiariosValidador	c	With(NoLock)	On	c.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
																					And	c.nmro_cntrto				=	b.nmro_cntrto
																					And	c.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro
				Where		b.cnsctvo_cdgo_tpo_cntrto = 2
				And			@fcha_vldccn Between c.inco_vgnca_estdo_bnfcro And c.fn_vgnca_estdo_bnfcro
			End
		Else
			Begin 
				Insert into @tiempoAfiliacion
						(	smns_ctzds,					smns_aflcn,						smns_ctzds_antrr_eps,
							smns_aflcn_antrr_eps,		cnsctvo_cdgo_tpo_cntrto,		nmro_cntrto,
							inco_vgnca_bnfcro,			fn_vgnca_bnfcro,				nmro_unco_idntfccn_afldo
						)
				Select		b.smns_ctzds,				b.smns_aflcn,					b.smns_ctzds_antrr_eps,
							smns_aflcn_antrr_eps,		b.cnsctvo_cdgo_tpo_cntrto,		b.nmro_cntrto,
							c.inco_vgnca_estdo_bnfcro,	c.fn_vgnca_estdo_bnfcro,		b.nmro_unco_idntfccn_afldo
				From		@tb_tmpAfiliado						t
				Inner Join	#tmpBeneficiariosValidador			b	With(NoLock)	On	b.nmro_unco_idntfccn_afldo	=	t.nmro_unco_idntfccn_afldo
				Inner Join	#tmpVigenciasBeneficiariosValidador	c	With(NoLock)	On	c.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
																					And	c.nmro_cntrto				=	b.nmro_cntrto
																					And	c.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro
				where		b.cnsctvo_cdgo_tpo_cntrto = 1
				And			@fcha_vldccn Between c.inco_vgnca_estdo_bnfcro And c.fn_vgnca_estdo_bnfcro
			End

--select * from @tiempoAfiliacion
--select * from @tb_tmpAfiliado

		If Exists	(	Select	1
						FRom	@tb_tmpAfiliado
						Where	cnsctvo_cdgo_tpo_cntrto	= 1
					)
			Begin
				Update		@tb_tmpAfiliado
				Set			smns_ctzds_ss_ps		= b.smns_ctzds,
							smns_ctzds_eps_ps		= b.smns_ctzds_antrr_eps,
							smns_aflcn_eps_ps  		= b.smns_aflcn,
							smns_aflcn_ss_ps  		= b.smns_aflcn_antrr_eps,
							smns_ctzds_eps			= b.smns_ctzds
				From		@tb_tmpAfiliado		t
				Inner Join	@tiempoAfiliacion	b	On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
													And	b.nmro_cntrto				= t.nmro_cntrto
				Where		b.cnsctvo_cdgo_tpo_cntrto	= 1

				Update		@tb_tmpAfiliado
				Set			cnsctvo_cdgo_pln_pc	= c.cnsctvo_cdgo_pln,
							smns_ctzds_ss_pc	= b.smns_ctzds,
							smns_ctzds_eps_pc	= b.smns_ctzds_antrr_eps,
							smns_aflcn_ss_pc	= b.smns_aflcn_antrr_eps,
							smns_aflcn_eps_pc	= b.smns_aflcn
				From		@tb_tmpAfiliado			t
				inner join	@tiempoAfiliacion		b					On	b.nmro_unco_idntfccn_afldo	= t.nmro_unco_idntfccn_afldo
				Inner Join	#tmpContratosValidador	c	With(NoLock)	On	b.cnsctvo_cdgo_tpo_cntrto	= c.cnsctvo_cdgo_tpo_cntrto
																		And	b.nmro_cntrto				= c.nmro_cntrto
				Where		b.cnsctvo_cdgo_tpo_cntrto	= 2
			End

		If Exists	(	Select	1
						FRom	@tb_tmpAfiliado
						Where	cnsctvo_cdgo_tpo_cntrto	= 2
					)
			Begin
				Update		@tb_tmpAfiliado
				Set			cnsctvo_cdgo_pln_pc	= c.cnsctvo_cdgo_pln,
							smns_ctzds_ss_pc	= b.smns_ctzds,
							smns_ctzds_eps_pc	= b.smns_ctzds_antrr_eps,
							smns_aflcn_ss_pc	= b.smns_aflcn_antrr_eps,
							smns_aflcn_eps_pc	= b.smns_aflcn
				From		@tb_tmpAfiliado				t
				inner join	@tiempoAfiliacion			b					On	b.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																			And	b.nmro_cntrto				= t.nmro_cntrto
				Inner Join	#tmpContratosValidador		c	With(NoLock)	On	b.cnsctvo_cdgo_tpo_cntrto	= c.cnsctvo_cdgo_tpo_cntrto
																			And	b.nmro_cntrto				= c.nmro_cntrto
				Where		c.cnsctvo_cdgo_tpo_cntrto	= 2

				Update		@tb_tmpAfiliado
				Set			smns_ctzds_ss_ps		= b.smns_ctzds,
							smns_ctzds_eps_ps		= b.smns_ctzds_antrr_eps,
							smns_aflcn_eps_ps  		= b.smns_aflcn,
							smns_aflcn_ss_ps  		= b.smns_aflcn_antrr_eps,
							smns_ctzds_eps			= b.smns_ctzds
				From		@tb_tmpAfiliado		t
				Inner Join	@tiempoAfiliacion	b	On	b.nmro_unco_idntfccn_afldo	= t.nmro_unco_idntfccn_afldo
				Where		b.cnsctvo_cdgo_tpo_cntrto	= 1
			End

		Update		@tb_tmpAfiliado
		Set			cnsctvo_cdgo_estdo_drcho	= m.cnsctvo_cdgo_estdo_drcho,
					cnsctvo_cdgo_csa_drcho		= m.cnsctvo_cdgo_csa_drcho,
					dscrpcn_csa_drcho			= isnull(c.dscrpcn_csa_drcho,' ')
		From		@tb_tmpAfiliado					t
		INNER JOIN	BDAfiliacionValidador.dbo.TbMatrizDerechosValidador	m	With(index(IX_TbMatrizDerechosValidador_inco_fin_v))	on	m.cnsctvo_cdgo_tpo_cntrto							= t.cnsctvo_cdgo_tpo_cntrto
																																	And	m.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS	= t.nmro_cntrto --COLLATE SQL_Latin1_General_CP1_CI_AS              
																																	And	m.cnsctvo_bnfcro									= t.cnsctvo_bnfcro
		INNER JOIN	BDAfiliacionValidador.dbo.tbCausasDerechoValidador	c	With(NoLock)											On	m.cnsctvo_cdgo_estdo_drcho							= c.cnsctvo_cdgo_estdo_drcho
																																	And	m.cnsctvo_cdgo_csa_drcho							= c.cnsctvo_cdgo_csa_drcho
		Where		@fcha_vldccn Between Convert(char(10),m.inco_vgnca_estdo_drcho,111) And Convert(char(10),m.fn_vgnca_estdo_drcho,111)
	End

-- INICIO NUEVA VALIDACIÓN - 20150507 - SISCGM01 --
if @Bd = '5' --Marca No existe en el Sistema
	begin
		-- Se busca la maxima vigencia para el estado valido
		Select		@Nui_Afldo					=	b.nmro_unco_idntfccn_afldo,
					@maximafechabeneficiario	=	Max(v.fn_vgnca_estdo_bnfcro)  
		From		#tmpBeneficiariosValidador			b	With(NoLock)
		INNER JOIN	#tmpContratosValidador				c	With(NoLock)	On	b.nmro_cntrto				=	c.nmro_cntrto
																			And	b.cnsctvo_cdgo_tpo_cntrto	=	c.cnsctvo_cdgo_tpo_cntrto
		Inner Join	#tmpVigenciasBeneficiariosValidador	v	With(NoLock)	On	v.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
																			And	v.nmro_cntrto				=	b.nmro_cntrto
																			And	v.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro
		Where		b.cnsctvo_cdgo_tpo_idntfccn	= @cnsctvo_cdgo_tpo_idntfccn
		And			b.nmro_idntfccn				= @nmro_idntfccn 
		And			c.cnsctvo_cdgo_pln			= @cnsctvo_cdgo_pln
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
						Select	@Nui_Afldo=nmro_unco_idntfccn_afldo
						From	bdsisalud.dbo.tbactua	With(NoLock)
						Where	cnsctvo_cdgo_tpo_idntfccn	=	@cnsctvo_cdgo_tpo_idntfccn
						And		nmro_idntfccn				=	@nmro_idntfccn
					End

				Set		@maximafechabeneficiario = (	Select		max(v.fn_vgnca_estdo_bnfcro)  
														From		#tmpBeneficiariosValidador			b	With(NoLock)
														INNER JOIN	#tmpContratosValidador				c	With(NoLock)	On	b.nmro_cntrto				=	c.nmro_cntrto
																															And	b.cnsctvo_cdgo_tpo_cntrto	=	c.cnsctvo_cdgo_tpo_cntrto
														Inner Join	#tmpVigenciasBeneficiariosValidador	v	With(NoLock)	On	v.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
																															And	v.nmro_cntrto				=	b.nmro_cntrto
																															And	v.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro
														Where		b.nmro_unco_idntfccn_afldo	=	@Nui_Afldo
														And			b.nmro_idntfccn				=	@nmro_idntfccn
														And			b.cnsctvo_cdgo_tpo_idntfccn	=	@cnsctvo_cdgo_tpo_idntfccn
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
					nmro_unco_idntfccn_ctznte,		eml
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
					c.nmro_unco_idntfccn_afldo,		isnull(b.eml,'')
		From		#tmpBeneficiariosValidador			b	With(NoLock)
		Inner Join	#tmpContratosValidador				c	With(NoLock)	On	b.nmro_cntrto				=	c.nmro_cntrto
																			And	b.cnsctvo_cdgo_tpo_cntrto	=	c.cnsctvo_cdgo_tpo_cntrto
		Inner Join	#tmpVigenciasBeneficiariosValidador	v	With(NoLock)	On	v.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
																			And	v.nmro_cntrto				=	b.nmro_cntrto
																			And	v.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro
		Where		c.cnsctvo_cdgo_pln			=	@cnsctvo_cdgo_pln
		And			b.nmro_unco_idntfccn_afldo	=	@Nui_Afldo
		And			@maximafechabeneficiario Between v.inco_vgnca_estdo_bnfcro And v.fn_vgnca_estdo_bnfcro

		if (select count(1) from 	@tb_tmpAfiliado) >	0 
			begin
				set @mnsje 	= 'USUARIO RETIRADO'

				Update		@tb_tmpAfiliado
				Set			cnsctvo_cdgo_estdo_drcho	= m.cnsctvo_cdgo_estdo_drcho,
							cnsctvo_cdgo_csa_drcho		= m.cnsctvo_cdgo_csa_drcho,
							dscrpcn_csa_drcho			= isnull(c.dscrpcn_csa_drcho,' ')
				From		@tb_tmpAfiliado				t
				Inner Join	BDAfiliacionValidador.dbo.TbMatrizDerechosValidador	m	With(NoLock)	On	m.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																									And	m.nmro_cntrto				= t.nmro_cntrto --COLLATE SQL_Latin1_General_CP1_CI_AS              
																									And	m.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
				Inner Join	BDAfiliacionValidador.dbo.tbCausasDerechoValidador	c	With(NoLock)	On	m.cnsctvo_cdgo_estdo_drcho	= c.cnsctvo_cdgo_estdo_drcho
																									And	m.cnsctvo_cdgo_csa_drcho	= c.cnsctvo_cdgo_csa_drcho

				IF @@RowCount = 0
					Begin
						Update		@tb_tmpAfiliado
						Set			cnsctvo_cdgo_estdo_drcho	= m.cnsctvo_cdgo_estdo_drcho,
									cnsctvo_cdgo_csa_drcho		= m.cnsctvo_cdgo_csa_drcho,
									dscrpcn_csa_drcho			= isnull(c.dscrpcn_csa_drcho,' ')
						From		@tb_tmpAfiliado					t
						Inner Join	BDAfiliacionValidador.dbo.TbMatrizDerechosValidador_at	m	With(NoLock)	On	m.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																												And	m.nmro_cntrto				= t.nmro_cntrto --COLLATE SQL_Latin1_General_CP1_CI_AS              
																												And	m.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
						Inner Join	BDAfiliacionValidador.dbo.tbCausasDerechoValidador		c	With(NoLock)	On	m.cnsctvo_cdgo_estdo_drcho	= c.cnsctvo_cdgo_estdo_drcho
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
Update	@tb_tmpAfiliado
Set 	edd 		= isnull(dbo.fnCalcularTiempo(fcha_ncmnto,@fcha_vldccn,1,2),0),
 		edd_mss 	= isnull(dbo.fnCalcularTiempo(fcha_ncmnto,@fcha_vldccn,2,2),0),
		edd_ds 		= isnull(dbo.fnCalcularTiempo(fcha_ncmnto,@fcha_vldccn,3,2),0)

Update	@tb_tmpAfiliado
Set		cnsctvo_cdgo_tpo_undd	= 1
Where	edd_ds	> 0

Update	@tb_tmpAfiliado
Set		cnsctvo_cdgo_tpo_undd	= 3
Where	edd_mss	> 0

Update	@tb_tmpAfiliado
Set		cnsctvo_cdgo_tpo_undd	= 4
Where	edd	> 0

Update		@tb_tmpAfiliado
Set 		dscrpcn_prntsco = p.dscrpcn_prntsco,
			cdgo_tpo_prntsco= p.cdgo_prntscs
From		@tb_tmpAfiliado										t
INNER JOIN	BDAfiliacionValidador.dbo.tbParentescos_vigencias	p	With(NoLock)	On	t.cnsctvo_cdgo_prntsco = p.cnsctvo_cdgo_prntscs
Where		@fcha_vldccn Between p.inco_vgnca And p.fn_vgnca

Update		@tb_tmpAfiliado
Set 		dscrpcn_tpo_afldo = a.dscrpcn,
			cdgo_tpo_afldo	  = a.cdgo_tpo_afldo 
From		@tb_tmpAfiliado										t
INNER JOIN	BDAfiliacionValidador.dbo.tbTiposAfiliado_vigencias	a	With(NoLock)	On	t.cnsctvo_cdgo_tpo_afldo	= a.cnsctvo_cdgo_tpo_afldo
Where		@fcha_vldccn Between a.inco_vgnca And a.fn_vgnca

Update		@tb_tmpAfiliado
Set			cnsctvo_cdgo_rngo_slrl	= 4
Where		cnsctvo_cdgo_rngo_slrl	= 0
And			cnsctvo_cdgo_tpo_cntrto	!= 1

Update		@tb_tmpAfiliado
Set 		dscrpcn_rngo_slrl = r.dscrpcn_rngo_slrl,
			cdgo_rngo_slrl	  = r.cdgo_rngo_slrl 
From		@tb_tmpAfiliado											t
INNER JOIN	BDAfiliacionValidador.dbo.tbRangosSalariales_vigencias	r	With(NoLock)	On	t.cnsctvo_cdgo_rngo_slrl	= r.cnsctvo_cdgo_rngo_slrl
Where		@fcha_vldccn Between r.inco_vgnca And r.fn_vgnca

Update		@tb_tmpAfiliado
Set			dscrpcn_pln_pc = isnull(p.dscrpcn_pln,'') 
From		@tb_tmpAfiliado									t
INNER JOIN	BDAfiliacionValidador.dbo.tbPlanes_vigencias	p	With(NoLock)	On	t.cnsctvo_cdgo_pln_pc = p.cnsctvo_cdgo_pln

--Ajuste Calculo de Sede
Update		@tb_tmpAfiliado
Set			dscrpcn_ips_prmra = i.nmbre_scrsl,
			cnsctvo_cdgo_sde_ips = i.cnsctvo_cdgo_sde_ips --Adicion Campo sede 
From		@tb_tmpAfiliado										t
INNER JOIN	bdAfiliacionValidador.dbo.tbIpsPrimarias_vigencias	i	With(NoLock)	On	t.cdgo_ips_prmra	= i.cdgo_intrno --COLLATE SQL_Latin1_General_CP1_CI_AS

Update		@tb_tmpAfiliado
set			cnsctvo_cdgo_sde_ips  = c.cnsctvo_sde_inflnca
from		@tb_tmpAfiliado									t
INNER JOIN	BDAfiliacionValidador.dbo.tbCiudades_Vigencias	c	With(NoLock)	On t.cnsctvo_cdgo_cdd_rsdnca = c.cnsctvo_cdgo_cdd
Where		t.cnsctvo_cdgo_tpo_cntrto	=	2  --Solo Para Plan PAC

Update		@tb_tmpAfiliado
Set 		dscrpcn_estdo_drcho		= edv.dscrpcn_estdo_drcho,
			dscrpcn_drcho			= edv.dscrpcn_drcho,
			cnsctvo_cdgo_estdo_drcho	= edv.cnsctvo_cdgo_estdo_drcho,
			drcho = edv.drcho,
			cdgo_estdo_drcho			= edv.cdgo_estdo_drcho
From		BDAfiliacionValidador.dbo.tbEstadosDerechoValidador	edv	With(NoLock)
INNER JOIN	@tb_tmpAfiliado										a	On	a.cnsctvo_cdgo_estdo_drcho 	= edv.cnsctvo_cdgo_estdo_drcho

Update		@tb_tmpAfiliado
Set			cdgo_tpo_idntfccn	= i.cdgo_tpo_idntfccn
From		@tb_tmpAfiliado												t
INNER JOIN	BDAfiliacionValidador.dbo.tbTiposIdentificacion_vigencias	i	With(NoLock)	On	t.cnsctvo_cdgo_tpo_idntfccn	= i.cnsctvo_cdgo_tpo_idntfccn
Where		@fcha_vldccn Between i.inco_vgnca And i.fn_vgnca

Update		@tb_tmpAfiliado
Set			cdgo_tpo_idntfccn_ctznte	= i.cdgo_tpo_idntfccn
From		@tb_tmpAfiliado												t
INNER JOIN	BDAfiliacionValidador.dbo.tbTiposIdentificacion_vigencias	i	With(NoLock)	On	t.cnsctvo_tpo_idntfccn_ctznte	= i.cnsctvo_cdgo_tpo_idntfccn
Where		@fcha_vldccn Between i.inco_vgnca And i.fn_vgnca

Update		@tb_tmpAfiliado
Set			cdgo_sxo	= s.cdgo_sxo
From		@tb_tmpAfiliado								t
INNER JOIN	BDAfiliacionValidador.dbo.tbSexos_vigencias	s	With(NoLock)	On	t.cnsctvo_cdgo_sxo	= s.cnsctvo_cdgo_sxo
Where		@fcha_vldccn Between s.inco_vgnca And s.fn_vgnca

Update		@tb_tmpAfiliado
Set			dscrpcn_pln	= p.dscrpcn_pln
From		@tb_tmpAfiliado						t
INNER JOIN	BDAfiliacionValidador.dbo.tbPlanes	p	With(NoLock)	On	t.cnsctvo_cdgo_pln	= p.cnsctvo_cdgo_pln

--cnsctvo_cdgo_sde_ips
Update		@tb_tmpAfiliado
Set			cnsctvo_cdgo_sde_ips	= d.cnsctvo_cdgo_sde_ips
From		bdAfiliacionValidador.dbo.tbIpsPrimarias_vigencias	d	With(NoLock)
INNER JOIN	@tb_tmpAfiliado										t	On	d.cdgo_intrno	= t.cdgo_ips_prmra
Where		@fcha_vldccn Between d.inco_vgnca And d.fn_vgnca

Update		@tb_tmpAfiliado
set			cnsctvo_cdgo_sde_ips  = c.cnsctvo_sde_inflnca
from		@tb_tmpAfiliado									t
INNER JOIN	BDAfiliacionValidador.dbo.tbCiudades_Vigencias	c	With(NoLock)	On t.cnsctvo_cdgo_cdd_rsdnca = c.cnsctvo_cdgo_cdd
Where		t.cnsctvo_cdgo_tpo_cntrto	=	2  --Solo Para Plan PAC

Update		@tb_tmpAfiliado
Set			flg_enble_nmro_vldcn		= 'S'
Where		cnsctvo_cdgo_estdo_drcho	= 8--In (8) Suspendido
Or			cnsctvo_cdgo_estdo_drcho	= 7 --Retirado
Or			cnsctvo_cdgo_estdo_drcho	= 6 --en Proceso

Update		@tb_tmpAfiliado
Set			cnsctvo_tpo_vldcn_actva	=	2
Where		orgn					=	'2'	--Formularios

Update		@tb_tmpAfiliado
Set			cnsctvo_tpo_vldcn_actva		=	2
Where		orgn						=	'1'	--Contratos
And			cnsctvo_cdgo_estdo_drcho	in	(6,7,8)	-- 6 EN PROCESO 7 Retirado, 8 suspendido

Update		@tb_tmpAfiliado
Set			cnsctvo_tpo_vldcn_actva		=	1
Where		orgn						=	'1'	--Contratos
And			cnsctvo_cdgo_estdo_drcho	not in (6,7,8)	-- sea diferente de 6 EN PROCESO 7 Retirado, 8 suspendido

Update		@tb_tmpAfiliado
Set			cnsctvo_tpo_vldcn_actva	= 1
Where		orgn					= '3'	--Famisanar

Update		@tb_tmpAfiliado
Set			dscrpcn_cdd_rsdnca	= c.dscrpcn_cdd,
			cdgo_cdd			= c.cdgo_cdd
From		BDAfiliacionValidador.dbo.tbCiudades	c	With(NoLock)
INNER JOIN	@tb_tmpAfiliado							t	On	c.cnsctvo_cdgo_cdd	= t.cnsctvo_cdgo_cdd_rsdnca

Update		@tb_tmpAfiliado
Set			cdgo_afp	= cdgo_entdd
From		BDAfiliacionValidador.dbo.tbEntidades_Vigencias	e	With(NoLock)
INNER JOIN	@tb_tmpAfiliado									t	On	t.cnsctvo_cdgo_afp	= e.cnsctvo_cdgo_entdd
Where		@fcha_vldccn Between e.inco_vgnca And e.fn_vgnca

Update		@tb_tmpAfiliado
Set			cfcha_ncmnto	= convert(char(10),fcha_ncmnto,111)

Select		@lfFechaReferencia	= fn_vgnca_bnfcro
From		@tb_tmpAfiliado
Where		fn_vgnca_bnfcro	< @fcha_vldccn
And			orgn		= '1'	--Contratos

Select		@lfFechaReferencia	= fcha_hsta
From		@tb_tmpAfiliado
Where		fcha_hsta	< @fcha_vldccn
And			orgn		!= '1'	--Contratos

Select			prmr_aplldo,										sgndo_aplldo,											prmr_nmbre,
				sgndo_nmbre,										cnsctvo_cdgo_tpo_idntfccn,								nmro_idntfccn,
				fcha_ncmnto,										cnsctvo_cdgo_sxo,										cdgo_sxo,
				edd,												edd_mss,												edd_ds,
				cnsctvo_cdgo_tpo_undd,								orgn,													cnsctvo_cdgo_tpo_cntrto,
				nmro_cntrto,										cnsctvo_cdgo_pln,										nmro_unco_idntfccn_afldo,
				inco_vgnca_bnfcro,									fn_vgnca_bnfcro,										cnsctvo_cdgo_prntsco,
				dscrpcn_prntsco,									cnsctvo_cdgo_tpo_afldo,									dscrpcn_tpo_afldo,
				cnsctvo_cdgo_rngo_slrl,								dscrpcn_rngo_slrl,										cnsctvo_cdgo_pln_pc,
				dscrpcn_pln_pc,										smns_ctzds_ss_ps,										smns_ctzds_eps_ps,
				smns_ctzds_ss_pc,									smns_ctzds_eps_pc,										cdgo_ips_prmra,
				dscrpcn_ips_prmra,									cnsctvo_bnfcro,											cdgo_eapb,
				nmro_unco_idntfccn_ctznte,							cnsctvo_cdgo_tpo_cntrto_psc,							nmro_cntrto_psc,
				ds_ctzds,											cnsctvo_cdgo_sde_ips,									dscrpcn_tpo_cntrto,
				cnsctvo_cdgo_csa_drcho,								cnsctvo_cdgo_estdo_drcho,								dscrpcn_estdo_drcho,
				dscrpcn_csa_drcho,									dscrpcn_drcho,											dscrpcn_pln,
				dscrpcn_tpo_ctznte,									prmr_nmbre_ctznte,										sgndo_nmbre_ctznte,
				prmr_aplldo_ctznte,									sgndo_aplldo_ctznte,									drccn_rsdnca,
				tlfno_rsdnca,										cnsctvo_cdgo_cdd_rsdnca,								dscrpcn_cdd_rsdnca,
				cnsctvo_cdgo_estdo_cvl,								dscrpcn_estdo_cvl,										cnsctvo_cdgo_tpo_frmlro,
				nmro_frmlro,										cdgo_tpo_idntfccn,										cnsctvo_cdgo_afp,
				fcha_dsde,											fcha_hsta,												flg_enble_nmro_vldcn,
				drcho,												cdgo_afp,												cnsctvo_tpo_vldcn_actva,
				cfcha_ncmnto,										smns_aflcn_ss_ps,										smns_aflcn_eps_ps,
				smns_aflcn_ss_pc,									smns_aflcn_eps_pc,										smns_ctzds_eps,
				cdgo_tpo_prntsco,									cdgo_cdd,												cdgo_rngo_slrl,
				cdgo_tpo_afldo,										cdgo_tpo_idntfccn_ctznte,								nmro_idntfccn_ctznte,
				cnsctvo_tpo_idntfccn_ctznte,						@lfFechaReferencia as fcha_rfrnca,						@fcha_mxma_rprte as fcha_mxma_rprte,
				cnsctvo_dcmnto_gnrdo,								nmro_dcmnto,											cdgo_estdo_drcho,	eml --@mnsje as mensaje
From			@tb_tmpAfiliado

Drop Table		#tmpBeneficiariosValidador
Drop Table		#tmpVigenciasBeneficiariosValidador
Drop Table		#tmpContratosValidador

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDia] TO [300202 Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDia] TO [340010 Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDia] TO [cna_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDia] TO [vafss_role]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDia] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDia] TO [ServicioClientePortal]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDia] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDia] TO [outbts01]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDia] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDia] TO [portal_rol]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDia] TO [proceso3047_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDia] TO [at3047_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDia] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDia] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDia] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDia] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDia] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDia] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDia] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDia] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDia] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDia] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDia] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDia] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDia] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDia] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDia] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDia] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDia] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliado_AlDia] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

