CREATE  procedure [dbo].[spPmbuscavalidacionCajaPrueba]
@cnsctvo_cdgo_ofcna		udtConsecutivo	output,
@nmro_log				numeric(18)		output

as
Set nocount on

/*
set @cnsctvo_cdgo_ofcna		= 3
set @nmro_log				= 117660
*/

Begin
	Declare @tmpLog Table
			(	orgn							varchar(15),						cnsctvo_cdgo_tpo_idntfccn	int,
				nmro_idntfccn					varchar(20),						nmbre						varchar(150),
				dscrpcn_prntsco					varchar(150),						dscrpcn_pln					varchar(150),
				prmr_nmbre						varchar(20),						sgndo_nmbre					varchar(20),
				prmr_aplldo						varchar(50),						sgndo_aplldo				varchar(50),
				cnsctvo_cdgo_pln				int,								cnsctvo_cdgo_prntsco		int,
				orgn_bsqda						int,								fcha_ncmnto					datetime,
				cnsctvo_cdgo_sxo				int,								cnsctvo_cdgo_estdo_cvl		int,
				cnsctvo_cdgo_cdd_rsdnca			int,								drccn_rsdnca				char,
				tlfno_rsdnca					char,								eml							char,
				cdgo_sxo						char,								dscrpcn_estdo_cvl			char,
				cdgo_estdo_cvl					char,								dscrpcn_cdd					char,
				cdgo_cdd						char,								nmbre_lcldd					char,
				cnsctvo_cdgo_brro				char,								cnsctvo_cdgo_zna			char,
				cnsctvo_cdgo_dprtmnto			char,								dscrpcn_brro				char,
				dscrpcn_zna						char,								dscrpcn_dprtmnto			char,
				edd								int,								edd_mss						int,
				edd_ds							int,								cnsctvo_cdgo_tpo_undd		int,
				cdgo_dprtmnto					char,								cnsctvo_cdgo_tpo_cntrto		int,
				nmro_cntrto						varchar(15),						nmro_unco_idntfccn_afldo	int,
				cdgo_tpo_idntfccn				varchar(3),							inco_vgnca_bnfcro			Datetime,
				fn_vgnca_bnfcro					Datetime,							cnsctvo_cdgo_tpo_afldo		int,
				dscrpcn_tpo_afldo				varchar(150),						cnsctvo_cdgo_rngo_slrl		int,
				dscrpcn_rngo_slrl				varchar(150),						cnsctvo_cdgo_pln_pc			int,
				dscrpcn_pln_pc					varchar(150),						smns_aflcn_eps_ps			int,
				smns_aflcn_ss_ps				int,								smns_aflcn_eps_pc			int,
				smns_aflcn_ss_pc				int,								cdgo_ips_prmra				char(8),
				dscrpcn_ips_prmra				varchar(150),						cnsctvo_cdgo_afp			int,
				dscrpcn_afp						varchar(150),						cnsctvo_bnfcro				int,
				cdgo_eapb						char,								dscrpcn_tpo_undd			Varchar(150),
				ctza							char,								mltfldo						char,
				cnsctvo_cdgo_estdo_drcho		int,								inco_vgnca_estdo_drcho		datetime,
				fn_vgnca_estdo_drcho			datetime,							cdgo_estdo_drcho			char(5),
				dscrpcn_estdo_drcho				varchar(150),						dscrpcn_drcho				varchar(150),
				rzn_scl							varchar(200),						nmro_idntfccn_aprtnte		int,
				cnsctvo_tpo_idntfccn_aprtnte	int,								nmro_unco_idntfccn_aprtnte	int,
				prncpl							char,								cnsctvo_scrsl_ctznte		int,
				cnsctvo_cdgo_crgo_empldo		int,								cnsctvo_cdgo_clse_aprtnte	int,
				cnsctvo_cdgo_tpo_ctznte			int,								inco_vgnca_cbrnza			datetime,
				fn_vgnca_cbrnza					datetime,							cdgo_tpo_idntfccn_aprtnte	char(3),
				idntfccn_cmplta_empldr			varchar(50),						txto_cta					varchar(150),
				txto_cpgo						varchar(150),						fte_dto						char,
				ds_ctzds						int,								cnsctvo_cdgo_sde_ips		int,
				cnsctvo_cdgo_sde				int,								nmbrs						varchar(150),
				prmr_nmbre_ctznte				char,								sgndo_nmbre_ctznte			char,
				prmr_aplldo_ctznte				char,								sgndo_aplldo_ctznte			char,
				cnsctvo_cdgo_tpo_cbrnza			int,								drcho						varchar(150),
				cnsctvo_cdgo_csa_drcho			int,								cnsctvo_prdcto_scrsl		int,
				dscrpcn_csa_drcho				varchar(150),						slro_bsco					int,
				smns_aflcn_ps					int,								smns_aflcn_antrr_eps_ps		int,
				smns_aflcn_pc					int,								smns_aflcn_antrr_eps_pc		int,
				smns_ctzds						int,								cdgo_usro					varchar(30),
				obsrvcns						varchar(250),						cnsctvo_cdgo_mtvo			int,
				dscrpcn_mtvo_ordn_espcl			varchar(30),						fcha_vldcn					datetime,
				dscrpcn_tpo_ctznte				varchar(150),						cnsctvo_dcmnto_gnrdo		Int, --Este consecutivo informa si el log fue grabado con un Bono  
				cnsctvo_cdgo_arp				Int,								fcha_vldcn_hra				datetime,
				cnsctvo_cdgo_ofcna_usro			int,								dscrpcn_dprtmnto_rsdnca		varchar(150),
				cdgo_dprtmnto_rsdnca			varchar(30),						dscrpcn_cdd_rsdnca			varchar(150),
				cdgo_cdd_rsdnca					varchar(30)
			)
  
	Declare	@hst_nme   Varchar(50)
	Select	@hst_nme = Ltrim(Rtrim(Convert(Varchar(30), SERVERPROPERTY('machinename'))))

	If Exists	(	Select	1
					From	bdAfiliacionValidador.dbo.tbtablaParametros  With(NoLock)
					Where	vlr_prmtro	= @hst_nme
				)
		Begin
			Insert Into @tmpLog
						(	orgn,											cnsctvo_cdgo_tpo_idntfccn,  
							nmro_idntfccn,									nmbre,  
							dscrpcn_prntsco,								dscrpcn_pln,  
							prmr_nmbre,										sgndo_nmbre,  
							prmr_aplldo,									sgndo_aplldo,  
							cnsctvo_cdgo_pln,								cnsctvo_cdgo_prntsco,  
							orgn_bsqda,										fcha_ncmnto,  
							cnsctvo_cdgo_sxo,								cnsctvo_cdgo_estdo_cvl,  
							cnsctvo_cdgo_cdd_rsdnca,						cdgo_sxo,  
							edd,											edd_mss,  
							edd_ds,											cnsctvo_cdgo_tpo_undd,  
							cnsctvo_cdgo_tpo_cntrto,						nmro_cntrto,  
							nmro_unco_idntfccn_afldo,						cdgo_tpo_idntfccn,  
							inco_vgnca_bnfcro,								fn_vgnca_bnfcro,    
							cnsctvo_cdgo_tpo_afldo, 						dscrpcn_tpo_afldo,  
							cnsctvo_cdgo_rngo_slrl, 						dscrpcn_rngo_slrl,  
							cnsctvo_cdgo_pln_pc,							dscrpcn_pln_pc,  
							smns_aflcn_eps_ps,  --smns_ctzds_ss_ps  int,  
							smns_aflcn_ss_ps,  --smns_ctzds_eps_ps  int,  
							smns_aflcn_eps_pc, --smns_ctzds_ss_pc,   
							smns_aflcn_ss_pc, --smns_ctzds_eps_pc,  
							cdgo_ips_prmra,									dscrpcn_ips_prmra,   
							cnsctvo_cdgo_afp,								dscrpcn_afp,  
							cnsctvo_bnfcro,									cdgo_eapb,  
							dscrpcn_tpo_undd,								ctza,  
							mltfldo,										cnsctvo_cdgo_estdo_drcho,  
							inco_vgnca_estdo_drcho, 						fn_vgnca_estdo_drcho,  
							cdgo_estdo_drcho,								dscrpcn_estdo_drcho,  
							dscrpcn_drcho,									rzn_scl,  
							nmro_idntfccn_aprtnte,  						cnsctvo_tpo_idntfccn_aprtnte,  
							nmro_unco_idntfccn_aprtnte,  					prncpl,  
							cnsctvo_scrsl_ctznte,							cnsctvo_cdgo_crgo_empldo,  
							cnsctvo_cdgo_clse_aprtnte,						cnsctvo_cdgo_tpo_ctznte,  
							inco_vgnca_cbrnza,								fn_vgnca_cbrnza, 
							cdgo_tpo_idntfccn_aprtnte,						idntfccn_cmplta_empldr,  
							txto_cta,										txto_cpgo,  
							fte_dto,										ds_ctzds,  
							cnsctvo_cdgo_sde_ips,							cnsctvo_cdgo_sde,  
							nmbrs,											cnsctvo_cdgo_tpo_cbrnza,  
							drcho,											cnsctvo_cdgo_csa_drcho,  
							cnsctvo_prdcto_scrsl,							dscrpcn_csa_drcho,  
							slro_bsco,										smns_aflcn_ps,  
							smns_aflcn_antrr_eps_ps,						smns_aflcn_pc,  
							smns_aflcn_antrr_eps_pc,						smns_ctzds,  
							cdgo_usro,										obsrvcns,  
							cnsctvo_cdgo_mtvo,								dscrpcn_mtvo_ordn_espcl,  
							fcha_vldcn,										dscrpcn_tpo_ctznte,  
							cnsctvo_dcmnto_gnrdo,							cnsctvo_cdgo_arp,  
							fcha_vldcn_hra ,								cnsctvo_cdgo_ofcna_usro,
							dscrpcn_dprtmnto_rsdnca,						cdgo_dprtmnto_rsdnca,
							dscrpcn_cdd_rsdnca,								cdgo_cdd_rsdnca
						)
			select			CASE	orgn	WHEN 'I' THEN 'ESPECIAL'
											WHEN 'E' THEN 'FAMISANAR'
											ELSE 'CONTRATOS SOS'
							END,											cnsctvo_cdgo_tpo_idntfccn,
							nmro_idntfccn,									ltrim(rtrim(prmr_nmbre)) + ' ' + ltrim(rtrim(ISNULL(sgndo_nmbre,''))) + ' ' + ltrim(rtrim(prmr_aplldo)) + ' ' + ltrim(rtrim(ISNULL(sgndo_aplldo,''))),
							c.dscrpcn_prntsco,								b.dscrpcn_pln,  
							prmr_nmbre,										ISNULL(sgndo_nmbre,''),     
							prmr_aplldo,									ISNULL(sgndo_aplldo,''),  
							a.cnsctvo_cdgo_pln,								a.cnsctvo_cdgo_prntscs,  
							2,/* orgn_bsqda*/								a.fcha_ncmnto,   
							cnsctvo_cdgo_sxo,								0,-- cnsctvo_cdgo_estdo_cvl  
							0,/* cnsctvo_cdgo_cdd_rsdnca,*/					'',--cdgo_sxo ,  
							a.edd,											a.edd_mss,  
							a.edd_ds,										a.cnsctvo_cdgo_tpo_undd,  
							cnsctvo_cdgo_tpo_cntrto,						nmro_cntrto,  
							nmro_unco_idntfccn_afldo,						'',
							convert(char(10), inco_vgnca_bnfcro, 111),		convert(char(10), fn_vgnca_bnfcro, 111),
							cnsctvo_cdgo_tpo_afldo,							'',
							cnsctvo_cdgo_rngo_slrl,							'',
							cnsctvo_cdgo_pln_pc,							'',
							ds_ctzds as smns_aflcn_eps_ps,					0 as smns_aflcn_ss_ps,
							ds_ctzds_pc as smns_aflcn_eps_pc,				0 as smns_aflcn_ss_pc,
							cdgo_ips_prmra,									'',
							0,												'',
							cnsctvo_bnfcro,									'',
							'',												CASE	cnsctvo_cdgo_tpo_afldo	WHEN 1	THEN 'S'
																											WHEN 2	THEN 'S'
																											ELSE 'N'
																			END,  
							'N',											cnsctvo_cdgo_estdo_afldo,  
							inco_vgnca_bnfcro,								fn_vgnca_bnfcro,
							'',												'',
							'',												rzn_scl,  
							nmro_idntfccn_aprtnte,							cnsctvo_tpo_idntfccn_aprtnte,   
							nmro_unco_idntfccn_aprtnte,						'S',  
							1,												0,
							1,												0,
							inco_vgnca_bnfcro,								fn_vgnca_bnfcro,
							'',												'',
							txto_cta,										txto_cpgo,  
							orgn,											case	a.cnsctvo_cdgo_pln	when	1	then ds_ctzds
																										else ds_ctzds_pc
																			end,  
							0,												cnsctvo_cdgo_sde,
							ltrim(rtrim(prmr_nmbre)) + ' ' + ltrim(rtrim(isnull(sgndo_nmbre,''))) + ' ' + ltrim(rtrim(prmr_aplldo)) + ' ' + ltrim(rtrim(isnull(sgndo_aplldo, ''))),  
							1,												'',
							a.cnsctvo_cdgo_csa_drcho,						a.cnsctvo_prdcto_scrsl,  
							ISNULL( e.dscrpcn_csa_drcho,''),				0,
							a.smns_aflcn_ps,								a.smns_aflcn_antrr_eps_ps,  
							a.smns_aflcn_pc,								a.smns_aflcn_antrr_eps_pc,  
							a.smns_ctzds,									a.cdgo_usro,  
							a.obsrvcns,										a.cnsctvo_cdgo_mtvo,  
							null,											Convert(char(10),a.fcha_vldcn,111) as fcha_vldcn,  
							'',												0,
							0,												a.fcha_vldcn ,
							a.cnsctvo_cdgo_ofcna,							'',
							'',												'',
							''
			from			bdIPSIntegracion.dbo.tblog							a	With(NoLock)
			left outer join BDAfiliacionValidador.dbo.tbCausasDerechoValidador	e	With(NoLock)	On	e.cnsctvo_cdgo_csa_drcho	=	a.cnsctvo_cdgo_csa_drcho
			Inner join		BDAfiliacionValidador.dbo.tbPlanes					b	With(NoLock)	On	b.cnsctvo_cdgo_pln			=	a.cnsctvo_cdgo_pln
			Inner Join		BDAfiliacionValidador.dbo.tbParentescos				c	With(NoLock)	On	c.cnsctvo_cdgo_prntscs		=	a.cnsctvo_cdgo_prntscs
			where			a.cnsctvo_cdgo_ofcna	= @cnsctvo_cdgo_ofcna   
			and				a.nmro_vrfccn			= @nmro_log  
		End
	Else
		Begin
				Insert Into @tmpLog(  
				orgn,								cnsctvo_cdgo_tpo_idntfccn,  
				nmro_idntfccn,						nmbre,  
				dscrpcn_prntsco,					dscrpcn_pln,  
				prmr_nmbre,							sgndo_nmbre,  
				prmr_aplldo,						sgndo_aplldo,  
				cnsctvo_cdgo_pln,					cnsctvo_cdgo_prntsco,  
				orgn_bsqda,							fcha_ncmnto,  
				cnsctvo_cdgo_sxo,					cnsctvo_cdgo_estdo_cvl,  
				cnsctvo_cdgo_cdd_rsdnca,			cdgo_sxo,  
				edd,								edd_mss,  
				edd_ds,								cnsctvo_cdgo_tpo_undd,  
				cnsctvo_cdgo_tpo_cntrto,			nmro_cntrto,  
				nmro_unco_idntfccn_afldo,			cdgo_tpo_idntfccn,  
				inco_vgnca_bnfcro,					fn_vgnca_bnfcro,    
				cnsctvo_cdgo_tpo_afldo, 			dscrpcn_tpo_afldo,  
				cnsctvo_cdgo_rngo_slrl, 			dscrpcn_rngo_slrl,  
				cnsctvo_cdgo_pln_pc,				dscrpcn_pln_pc,  
				smns_aflcn_eps_ps,  --smns_ctzds_ss_ps  int,  
				smns_aflcn_ss_ps,  --smns_ctzds_eps_ps  int,  
				smns_aflcn_eps_pc, --smns_ctzds_ss_pc,   
				smns_aflcn_ss_pc, --smns_ctzds_eps_pc,  
				cdgo_ips_prmra,						dscrpcn_ips_prmra,   
				cnsctvo_cdgo_afp,					dscrpcn_afp,  
				cnsctvo_bnfcro,						cdgo_eapb,  
				dscrpcn_tpo_undd,					ctza,  
				mltfldo,							cnsctvo_cdgo_estdo_drcho,  
				inco_vgnca_estdo_drcho, 			fn_vgnca_estdo_drcho,  
				cdgo_estdo_drcho,					dscrpcn_estdo_drcho,  
				dscrpcn_drcho,						rzn_scl,  
				nmro_idntfccn_aprtnte,  			cnsctvo_tpo_idntfccn_aprtnte,  
				nmro_unco_idntfccn_aprtnte,  		prncpl,  
				cnsctvo_scrsl_ctznte,				cnsctvo_cdgo_crgo_empldo,  
				cnsctvo_cdgo_clse_aprtnte,			cnsctvo_cdgo_tpo_ctznte,  
				inco_vgnca_cbrnza,					fn_vgnca_cbrnza, 
				cdgo_tpo_idntfccn_aprtnte,			idntfccn_cmplta_empldr,  
				txto_cta,							txto_cpgo,  
				fte_dto,							ds_ctzds,  
				cnsctvo_cdgo_sde_ips,				cnsctvo_cdgo_sde,  
				nmbrs,								cnsctvo_cdgo_tpo_cbrnza,  
				drcho,								cnsctvo_cdgo_csa_drcho,  
				cnsctvo_prdcto_scrsl,				dscrpcn_csa_drcho,  
				slro_bsco,							smns_aflcn_ps,  
				smns_aflcn_antrr_eps_ps,			smns_aflcn_pc,  
				smns_aflcn_antrr_eps_pc,			smns_ctzds,  
				cdgo_usro,							obsrvcns,  
				cnsctvo_cdgo_mtvo,					dscrpcn_mtvo_ordn_espcl,  
				fcha_vldcn,							dscrpcn_tpo_ctznte,  
				cnsctvo_dcmnto_gnrdo,				cnsctvo_cdgo_arp,  
				fcha_vldcn_hra ,					cnsctvo_cdgo_ofcna_usro,
				dscrpcn_dprtmnto_rsdnca,			cdgo_dprtmnto_rsdnca,
				dscrpcn_cdd_rsdnca,					cdgo_cdd_rsdnca			)  
				Select  CASE orgn WHEN 'I' THEN 'ESPECIAL'  WHEN 'E' THEN 'FAMISANAR' ELSE 'CONTRATOS SOS' END,  
				 cnsctvo_cdgo_tpo_idntfccn,    
				 nmro_idntfccn,  
				 ltrim(rtrim(prmr_nmbre)) + ' ' + ltrim(rtrim(ISNULL(sgndo_nmbre,''))) + ' ' + ltrim(rtrim(prmr_aplldo)) + ' ' + ltrim(rtrim(ISNULL(sgndo_aplldo,''))),   
				 c.dscrpcn_prntsco,  
				 b.dscrpcn_pln,  
				 prmr_nmbre,  
				 ISNULL(sgndo_nmbre,''),     
				 prmr_aplldo,  
				 ISNULL(sgndo_aplldo,''),  
				 a.cnsctvo_cdgo_pln,  
				 a.cnsctvo_cdgo_prntscs,  
				 2,-- orgn_bsqda  
				 a.fcha_ncmnto,   
				 cnsctvo_cdgo_sxo,  
				 0,-- cnsctvo_cdgo_estdo_cvl  
				 0,  -- -- cnsctvo_cdgo_cdd_rsdnca, -- 0
				 '',--cdgo_sxo ,  
				 a.edd,  
				 a.edd_mss,  
				 a.edd_ds,  
				 a.cnsctvo_cdgo_tpo_undd,  
				 cnsctvo_cdgo_tpo_cntrto,  
				 nmro_cntrto,  
				 nmro_unco_idntfccn_afldo,  
				 '',--cdgo_tpo_idntfccn  
				 convert(char(10), inco_vgnca_bnfcro, 111),  
				 convert(char(10), fn_vgnca_bnfcro, 111),     
				 cnsctvo_cdgo_tpo_afldo,  
				 '', --dscrpcn_tpo_afldo,  
				 cnsctvo_cdgo_rngo_slrl,  
				 '', --dscrpcn_rngo_slrl,  
				 cnsctvo_cdgo_pln_pc,  
				 '', --dscrpcn_pln_pc,  
				 ds_ctzds as smns_aflcn_eps_ps, --smns_ctzds_ss_ps Semanas POS en SOS  
				 0 as smns_aflcn_ss_ps, --Semanas al Sistemas de Seguridad smns_ctzds_eps_ps  
				 ds_ctzds_pc as smns_aflcn_eps_pc, --Semanas pac en SOS --smns_ctzds_ss_pc  
				 0 as smns_aflcn_ss_pc, -- smns_ctzds_eps_pc  
				 cdgo_ips_prmra,  
				 '', --dscrpcn_ips_prmra  
				 0, --cnsctvo_cdgo_afp  
				 '', --dscrpcn_afp  
				 cnsctvo_bnfcro,  
				 '', --cdgo_eapb  
				 '', --dscrpcn_tpo_undd  
				 CASE cnsctvo_cdgo_tpo_afldo WHEN 1 THEN 'S' WHEN 2 THEN 'S' ELSE 'N' END,  
				 'N', --mltfldo  
				 cnsctvo_cdgo_estdo_afldo,  
				 inco_vgnca_bnfcro,   
				 fn_vgnca_bnfcro,   
				 '', -- cdgo_estdo_drcho,      
				 '', --dscrpcn_estdo_drcho,   
				 '', --dscrpcn_drcho,       
				 rzn_scl,  
				 nmro_idntfccn_aprtnte,  
				 cnsctvo_tpo_idntfccn_aprtnte,   
				 nmro_unco_idntfccn_aprtnte,  
				 'S',  
				 1, --cnsctvo_scrsl_ctznte  
				 0, --cnsctvo_cdgo_crgo_empldo,   
				 1, --cnsctvo_cdgo_clse_aprtnte,  
				 0, --cnsctvo_cdgo_tpo_ctznte,  
				 inco_vgnca_bnfcro,  
				 fn_vgnca_bnfcro,  '', --cdgo_tpo_idntfccn_aprtnte,  
				 '', --idntfccn_cmplta_empldr  
				 txto_cta,  
				 txto_cpgo,  
				 orgn,  
				 case a.cnsctvo_cdgo_pln when 1 then ds_ctzds  else ds_ctzds_pc end,  
				 0, --cnsctvo_cdgo_sde_ips  
				 cnsctvo_cdgo_sde,  
				 ltrim(rtrim(prmr_nmbre)) + ' ' + ltrim(rtrim(isnull(sgndo_nmbre,''))) + ' ' + ltrim(rtrim(prmr_aplldo)) + ' ' + ltrim(rtrim(isnull(sgndo_aplldo, ''))),  
				 1, --cnsctvo_cdgo_tpo_cbrnza  
				 '', --drcho  
				 a.cnsctvo_cdgo_csa_drcho,  
				 a.cnsctvo_prdcto_scrsl,  
				 ISNULL( e.dscrpcn_csa_drcho,''),  
				 0, --slro_bsco  
				 a.smns_aflcn_ps,  
				 a.smns_aflcn_antrr_eps_ps,  
				 a.smns_aflcn_pc,  
				 a.smns_aflcn_antrr_eps_pc,  
				 a.smns_ctzds,  
				 a.cdgo_usro,  
				 a.obsrvcns,  
				 a.cnsctvo_cdgo_mtvo,  
				 null, --dscrpcn_mtvo_ordn_espcl,  
				 Convert(char(10),a.fcha_vldcn,111) as fcha_vldcn,  
				 '', --dscrpcn_tpo_ctznte  
				 0, --cnsctvo_dcmnto_gnrdo  
				 0, --cnsctvo_cdgo_arp  
				 a.fcha_vldcn ,
				a.cnsctvo_cdgo_ofcna,
				'',
				'',
				'',
				''
				from			bdSisalud.dbo.tblog									a	With(NoLock)
				left outer join BDAfiliacionValidador.dbo.tbCausasDerechoValidador	e	With(NoLock)	On	a.cnsctvo_cdgo_csa_drcho	=	e.cnsctvo_cdgo_csa_drcho
				Inner join		BDAfiliacionValidador.dbo.tbPlanes					b	With(NoLock)	On	b.cnsctvo_cdgo_pln			=	a.cnsctvo_cdgo_pln
				Inner Join		BDAfiliacionValidador.dbo.tbParentescos				c	With(NoLock)	On	c.cnsctvo_cdgo_prntscs		=	a.cnsctvo_cdgo_prntscs
				where			a.cnsctvo_cdgo_ofcna	= @cnsctvo_cdgo_ofcna   
				and				a.nmro_vrfccn			= @nmro_log  
		End

	Update		@tmpLog
	Set			cnsctvo_cdgo_cdd_rsdnca	= m.cnsctvo_cdgo_cdd_rsdnca,
				cdgo_cdd_rsdnca			= yy.cdgo_cdd,
				dscrpcn_cdd_rsdnca		= yy.dscrpcn_cdd,
				dscrpcn_dprtmnto_rsdnca	= xx.dscrpcn_dprtmnto,
				cdgo_dprtmnto_rsdnca	= xx.cdgo_dprtmnto
	From		@tmpLog												t 
	inner Join	BDAfiliacionValidador.dbo.tboficinas_vigencias		m	With(Nolock)	On t.cnsctvo_cdgo_ofcna_usro  = m.cnsctvo_cdgo_ofcna  
	inner join	BDAfiliacionValidador.dbo.tbciudades_vigencias		yy	With(Nolock)	on m.cnsctvo_cdgo_cdd_rsdnca = yy.cnsctvo_cdgo_cdd
	inner join	BDAfiliacionValidador.dbo.tbdepartamentos_vigencias xx	With(Nolock)	on xx.cnsctvo_cdgo_dprtmnto = yy.cnsctvo_cdgo_dprtmnto

	Update		@tmpLog  
	Set			dscrpcn_mtvo_ordn_espcl = m.dscrpcn_mtvo_ordn_espcl  
	From		@tmpLog											t
	inner Join	BDAfiliacionValidador.dbo.tbMotivoOrdenEspecial m	With(Nolock)	On t.cnsctvo_cdgo_mtvo  = m.cnsctvo_cdgo_mtvo_ordn_espcl
	--And t.orgn    = 'E'  
  
	Update		@tmpLog  
	Set			dscrpcn_mtvo_ordn_espcl = m.dscrpcn_mtvo_ordn_espcl  
	From		BDAfiliacionValidador.dbo.tbMotivoOrdenEspecial m	With(Nolock)
	Left Join	@tmpLog											t	On t.cnsctvo_cdgo_mtvo  = m.cnsctvo_cdgo_mtvo_ordn_espcl
	Where		t.dscrpcn_mtvo_ordn_espcl is Null  
	And			m.cnsctvo_cdgo_mtvo_ordn_espcl = 0  
  
	update		@tmpLog
	set			cdgo_estdo_drcho = a.cdgo_estdo_drcho,  
				dscrpcn_estdo_drcho = ltrim(rtrim(a.dscrpcn_estdo_drcho)),  
				dscrpcn_drcho = ltrim(rtrim(a.dscrpcn_drcho)),  
				drcho = ltrim(rtrim(a.drcho))  
	from		@tmpLog												b
	Inner Join	BDAfiliacionValidador.dbo.tbEstadosDerechoValidador a	With(Nolock)	On	a.cnsctvo_cdgo_estdo_drcho = b.cnsctvo_cdgo_estdo_drcho
  
	update		@tmpLog
	set			dscrpcn_afp = rtrim(ltrim(a.dscrpcn_entdd))
	from		BDAfiliacionValidador.dbo.tbEntidades	a	With(Nolock)
	Inner Join	@tmpLog									b	On	b.cnsctvo_cdgo_afp = a.cnsctvo_cdgo_entdd
  
	update		@tmpLog
	set			dscrpcn_ips_prmra = a.nmbre_scrsl,
				cnsctvo_cdgo_sde_ips = a.cnsctvo_cdgo_sde_ips
	from		BDAfiliacionValidador.dbo.tbIPSPrimarias_vigencias  a	With(Nolock)
	Inner Join	@tmpLog												b	On	b.cdgo_ips_prmra  = a.cdgo_intrno COLLATE SQL_Latin1_General_CP1_CI_AS
  
	update		@tmpLog  
	set			dscrpcn_pln_pc = a.dscrpcn_pln  
	from		BDAfiliacionValidador.dbo.tbPlanes  a	With(Nolock)
	Inner Join	@tmpLog								b	On	b.cnsctvo_cdgo_pln_pc = a.cnsctvo_cdgo_pln
  
	update		@tmpLog  
	set			dscrpcn_tpo_undd = a.dscrpcn_tpo_undd  
	from		BDAfiliacionValidador.dbo.tbTiposUnidades	a	With(Nolock)
	Inner Join	@tmpLog										b	On	b.cnsctvo_cdgo_tpo_undd = a.cnsctvo_cdgo_tpo_undd  
  
	update		@tmpLog
	set			dscrpcn_tpo_afldo = a.dscrpcn
	from		BDAfiliacionValidador.dbo.tbTiposAfiliado	a	With(Nolock)
	Inner Join	@tmpLog										b	On	b.cnsctvo_cdgo_tpo_afldo = a.cnsctvo_cdgo_tpo_afldo  
  
	update		@tmpLog
	set			cdgo_sxo = a.cdgo_sxo
	from		BDAfiliacionValidador.dbo.tbSexos	a	With(Nolock)
	Inner Join	@tmpLog								b	On	b.cnsctvo_cdgo_sxo = a.cnsctvo_cdgo_sxo
  
	update		@tmpLog
	set			dscrpcn_rngo_slrl = a.dscrpcn_rngo_slrl
	from		BDAfiliacionValidador.dbo.tbRangosSalariales	a	With(Nolock)
	Inner Join	@tmpLog											b	On	b.cnsctvo_cdgo_rngo_slrl = a.cnsctvo_cdgo_rngo_slrl
  
	update		@tmpLog
	set			cdgo_tpo_idntfccn_aprtnte = a.cdgo_tpo_idntfccn
	from		BDAfiliacionValidador.dbo.tbTiposIdentificacion		a	With(Nolock)
	Inner Join	@tmpLog												b	On	b.cnsctvo_tpo_idntfccn_aprtnte  = a.cnsctvo_cdgo_tpo_idntfccn
  
	update		@tmpLog
	set			cdgo_tpo_idntfccn = a.cdgo_tpo_idntfccn
	from		BDAfiliacionValidador.dbo.tbTiposIdentificacion		a	With(Nolock)
	Inner Join	@tmpLog												b	On	b.cnsctvo_cdgo_tpo_idntfccn = a.cnsctvo_cdgo_tpo_idntfccn
  
	Select		orgn,							cnsctvo_cdgo_tpo_idntfccn,			nmro_idntfccn,				nmbre,						dscrpcn_prntsco,
				dscrpcn_pln,					prmr_nmbre,							sgndo_nmbre,				prmr_aplldo,				sgndo_aplldo,
				cnsctvo_cdgo_pln,				cnsctvo_cdgo_prntsco,				orgn_bsqda,					fcha_ncmnto,				cnsctvo_cdgo_sxo,
				cnsctvo_cdgo_estdo_cvl,			cnsctvo_cdgo_cdd_rsdnca,			drccn_rsdnca,				tlfno_rsdnca,				eml,
				cdgo_sxo,						dscrpcn_estdo_cvl,					cdgo_estdo_cvl,				dscrpcn_cdd,				cdgo_cdd,
				nmbre_lcldd,					cnsctvo_cdgo_brro,					cnsctvo_cdgo_zna,			cnsctvo_cdgo_dprtmnto,		dscrpcn_brro,
				dscrpcn_zna,					dscrpcn_dprtmnto,					edd,						edd_mss,					edd_ds,
				cnsctvo_cdgo_tpo_undd,			cdgo_dprtmnto,						cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,				nmro_unco_idntfccn_afldo,
				cdgo_tpo_idntfccn,				inco_vgnca_bnfcro,					fn_vgnca_bnfcro,			cnsctvo_cdgo_tpo_afldo,		dscrpcn_tpo_afldo,
				cnsctvo_cdgo_rngo_slrl,			dscrpcn_rngo_slrl,					cnsctvo_cdgo_pln_pc,		dscrpcn_pln_pc,				smns_aflcn_eps_ps,
				smns_aflcn_ss_ps,				smns_aflcn_eps_pc,					smns_aflcn_ss_pc,			cdgo_ips_prmra,				dscrpcn_ips_prmra,
				cnsctvo_cdgo_afp,				dscrpcn_afp,						cnsctvo_bnfcro,				cdgo_eapb,					dscrpcn_tpo_undd,
				ctza,							mltfldo,							cnsctvo_cdgo_estdo_drcho,	inco_vgnca_estdo_drcho,		fn_vgnca_estdo_drcho,
				cdgo_estdo_drcho,				dscrpcn_estdo_drcho,				dscrpcn_drcho,				rzn_scl,					nmro_idntfccn_aprtnte,
				cnsctvo_tpo_idntfccn_aprtnte,	nmro_unco_idntfccn_aprtnte,			prncpl,						cnsctvo_scrsl_ctznte,		cnsctvo_cdgo_crgo_empldo,
				cnsctvo_cdgo_clse_aprtnte,		cnsctvo_cdgo_tpo_ctznte,			inco_vgnca_cbrnza,			fn_vgnca_cbrnza,			cdgo_tpo_idntfccn_aprtnte,
				idntfccn_cmplta_empldr,			txto_cta,							txto_cpgo,					fte_dto,					ds_ctzds,
				cnsctvo_cdgo_sde_ips,			cnsctvo_cdgo_sde,					nmbrs,						prmr_nmbre_ctznte,			sgndo_nmbre_ctznte,
				prmr_aplldo_ctznte,				sgndo_aplldo_ctznte,				cnsctvo_cdgo_tpo_cbrnza,	drcho,						cnsctvo_cdgo_csa_drcho,
				cnsctvo_prdcto_scrsl,			dscrpcn_csa_drcho,					slro_bsco,					smns_aflcn_ps,				smns_aflcn_antrr_eps_ps,
				smns_aflcn_pc,					smns_aflcn_antrr_eps_pc,			smns_ctzds,					cdgo_usro,					obsrvcns,
				cnsctvo_cdgo_mtvo,				dscrpcn_mtvo_ordn_espcl,			fcha_vldcn,					dscrpcn_tpo_ctznte,			cnsctvo_dcmnto_gnrdo,
				cnsctvo_cdgo_arp,				fcha_vldcn_hra,						cnsctvo_cdgo_ofcna_usro,	dscrpcn_dprtmnto_rsdnca,	cdgo_dprtmnto_rsdnca,
				dscrpcn_cdd_rsdnca,				cdgo_cdd_rsdnca,					@cnsctvo_cdgo_ofcna as cnsctvo_cdgo_ofcna,				@nmro_log as nmro_log  
	From		@tmpLog
End


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmbuscavalidacionCajaPrueba] TO PUBLIC
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmbuscavalidacionCajaPrueba] TO [310010 Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmbuscavalidacionCajaPrueba] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmbuscavalidacionCajaPrueba] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmbuscavalidacionCajaPrueba] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmbuscavalidacionCajaPrueba] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmbuscavalidacionCajaPrueba] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmbuscavalidacionCajaPrueba] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmbuscavalidacionCajaPrueba] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmbuscavalidacionCajaPrueba] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmbuscavalidacionCajaPrueba] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmbuscavalidacionCajaPrueba] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

