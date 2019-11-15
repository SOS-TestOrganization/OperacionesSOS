
/*---------------------------------------------------------------------------------------------------------------------------------------
* Procedimiento:		spPmConsultaAfiliadoCuentas_AlDia
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
* Modificado Por			: <\AM Ing. Cesar García																	AM\>
* Descripcion				:	Se ajusta procedimiento incluyendo la consulta de las vigencias de los beneficiarios
							: <\PM  																					PM\>
* Nuevas Variables			: <\VM  																					VM\>
* Fecha Modificación		: <\FM	2015-04-29																			FM\>
*-----------------------------------------------------------------------------------------------------------------------------------*/
--Exec spPmConsultaAfiliado_AlDia 1,'94400802',2,'','',''
--Exec spPmConsultaAfiliado_AlDia 1,'52891526',1,'','',''
CREATE procedure [dbo].[spPmConsultaAfiliadoCuentas_AlDia]
--Declare
@cnsctvo_cdgo_tpo_idntfccn 	udtConsecutivo, 
@nmro_idntfccn				Varchar(23), 	--udtNumeroIdentificacion,
@cnsctvo_cdgo_pln 			udtConsecutivo, 
@mnsje						varchar(80)  output,
--@Bd 						char(1) =null,
@origen						char(1),
@lfFechaReferencia			datetime output

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

-- Declaración de variables
Declare		@fcha_vldccn		datetime,
			@Nui_Afldo			UdtConsecutivo,
			@Bd 				char(1),
			@inco_vgnca_bnfcro	Datetime,
			@fcha_ultma_mdfccn	Datetime,	
			--@lfFechaReferencia	datetime,
			@dFcha_pvte			datetime,
			@Historico			char(1),
			@fcha_mxma_rprte	datetime

Set			@fcha_vldccn = Convert(char(10),getDate(),111)
Set			@lfFechaReferencia = @fcha_vldccn

-- Se crea función para calcular la fecha hasta para los reportes de validador de derechos, requerimiento segun gerencia, antes a la fecha del sistema se sumaba 5 días, ahora son 115
Select		@fcha_mxma_rprte = dbo.fnCalcularFechaReporteValidadorDerechos(@fcha_vldccn)

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
			nmro_idntfccn_ctznte 		char(20),		cnsctvo_tpo_idntfccn_ctznte	int,
			cnsctvo_dcmnto_gnrdo		int default 0,		nmro_dcmnto			Char(50) default ' ',
			eml varchar(50) 
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
			fn_vgnca_bnfcro			datetime
		)

set		@Bd = @origen	

If Isnull(@Bd,'') =' ' Or @bd = '1'
	Begin
		Insert Into @tb_tmpAfiliado
		(			prmr_aplldo,				sgndo_aplldo,					prmr_nmbre,
					sgndo_nmbre,				cnsctvo_cdgo_tpo_idntfccn,		nmro_idntfccn,
					fcha_ncmnto,				cnsctvo_cdgo_sxo,				orgn,
					cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,					cnsctvo_cdgo_pln,
					nmro_unco_idntfccn_afldo,	inco_vgnca_bnfcro,				fn_vgnca_bnfcro,
					cnsctvo_cdgo_prntsco,		cnsctvo_cdgo_tpo_afldo,			cnsctvo_cdgo_rngo_slrl,
					smns_ctzds_ss_ps,			smns_ctzds_eps_ps,				cdgo_ips_prmra,
					cnsctvo_bnfcro,				cnsctvo_cdgo_afp,				fcha_dsde,
					fcha_hsta,					tlfno_rsdnca,					drccn_rsdnca,
					cnsctvo_cdgo_cdd_rsdnca,	prmr_nmbre_ctznte,				sgndo_nmbre_ctznte,
					prmr_aplldo_ctznte,			sgndo_aplldo_ctznte,			cnsctvo_tpo_idntfccn_ctznte,
					nmro_idntfccn_ctznte,		nmro_unco_idntfccn_ctznte,		eml
		)
		Select		b.prmr_aplldo,				b.sgndo_aplldo,					b.prmr_nmbre,
					b.sgndo_nmbre,				b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,
					b.fcha_ncmnto,				b.cnsctvo_cdgo_sxo,				'1',
					b.cnsctvo_cdgo_tpo_cntrto,	b.nmro_cntrto,					c.cnsctvo_cdgo_pln,
					b.nmro_unco_idntfccn_afldo,	v.inco_vgnca_estdo_bnfcro,		v.fn_vgnca_estdo_bnfcro,
					b.cnsctvo_cdgo_prntsco,		b.cnsctvo_cdgo_tpo_afldo,		c.cnsctvo_cdgo_rngo_slrl,
					b.smns_ctzds_antrr_eps,		b.smns_ctzds,					b.cdgo_intrno,
					b.cnsctvo_bnfcro,			c.cnsctvo_cdgo_afp,				v.inco_vgnca_estdo_bnfcro,
					v.fn_vgnca_estdo_bnfcro,	b.tlfno_rsdnca,					b.drccn_rsdnca,
					b.cnsctvo_cdgo_cdd_rsdnca,	c.prmr_aplldo,					c.sgndo_aplldo,
					c.prmr_nmbre,				c.sgndo_nmbre,					c.cnsctvo_cdgo_tpo_idntfccn,
					c.nmro_idntfccn,			c.nmro_unco_idntfccn_afldo,		isnull(b.eml,'') as eml --adicion de campo
		From		dbo.tbBeneficiariosValidador			b	With(NoLock)
		INNER JOIN	dbo.tbContratosValidador				c	With(NoLock)	On	b.nmro_cntrto					=	c.nmro_cntrto
																				And	b.cnsctvo_cdgo_tpo_cntrto		=	c.cnsctvo_cdgo_tpo_cntrto
		Inner Join	dbo.tbVigenciasBeneficiariosValidador	v	With(NoLock)	On	v.cnsctvo_cdgo_tpo_cntrto		=	b.cnsctvo_cdgo_tpo_cntrto
																				And	v.nmro_cntrto					=	b.nmro_cntrto
																				And	v.cnsctvo_bnfcro				=	b.cnsctvo_bnfcro
		Where		b.cnsctvo_cdgo_tpo_idntfccn	= @cnsctvo_cdgo_tpo_idntfccn
		And			b.nmro_idntfccn				= @nmro_idntfccn
		And			c.cnsctvo_cdgo_pln			= @cnsctvo_cdgo_pln
		And			@fcha_vldccn Between Convert(char(10),v.inco_vgnca_estdo_bnfcro,111) And Convert(char(10),v.fn_vgnca_estdo_bnfcro,111)

		if Exists	(	Select	1
						From	@tb_tmpAfiliado
						Where	@fcha_vldccn Between Convert(char(10),inco_vgnca_bnfcro,111) And Convert(char(10),fn_vgnca_bnfcro,111)
					)
			Begin
				Delete	@tb_tmpAfiliado
				Where	Convert(char(10),inco_vgnca_bnfcro,111) > @fcha_vldccn 
				Or		@fcha_vldccn > Convert(char(10),fn_vgnca_bnfcro,111)

				Set @bd 	= '1'  -- Contratos
			End
	End

--If not Exists(select 1 from @tb_tmpAfiliado)

--Begin

If Isnull(@Bd,'') =' ' Or @bd = '2'
	Begin
		Insert Into @tb_tmpAfiliado
		(			prmr_aplldo,			sgndo_aplldo,			prmr_nmbre,
					sgndo_nmbre,			cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
					fcha_ncmnto,			cnsctvo_cdgo_sxo,		orgn,
					cnsctvo_cdgo_tpo_frmlro,	nmro_frmlro,			cnsctvo_cdgo_pln,
					inco_vgnca_bnfcro,		fn_vgnca_bnfcro,
					cnsctvo_cdgo_prntsco,		cnsctvo_cdgo_tpo_afldo,		cnsctvo_cdgo_rngo_slrl,
					smns_ctzds_eps_ps,
					cdgo_ips_prmra,
					cnsctvo_bnfcro,			cnsctvo_cdgo_estdo_drcho,	cnsctvo_cdgo_csa_drcho,
					fcha_dsde,			fcha_hsta,
					tlfno_rsdnca,			drccn_rsdnca
		)
		Select		prmr_aplldo,		sgndo_aplldo,			prmr_nmbre,
					sgndo_nmbre,			cnsctvo_tpo_idntfccn_bnfcro,	nmro_idntfccn_bnfcro,
					fcha_ncmnto,			cnsctvo_cdgo_sxo,		'2',
					cnsctvo_cdgo_tpo_frmlro,	nmro_frmlro,			cnsctvo_cdgo_pln,
					inco_vgnca_bnfcro,		fcha_hsta,--fn_vgnca_bnfcro,
					cnsctvo_cdgo_prntsco,		cnsctvo_cdgo_tpo_afldo,		rngo_slrl,
					smns_ctzds,
					cnsctvo_cdgo_ips,
					cnsctvo_bnfcro,
					case 
					When @fcha_vldccn Between Convert(char(10),fcha_dsde,111) And Convert(char(10),fcha_hsta,111) Then cnsctvo_cdgo_estdo_drcho
					Else 6	--En proceso
					End, 
					case 
					When @fcha_vldccn Between Convert(char(10),fcha_dsde,111) And Convert(char(10),fcha_hsta,111) Then cnsctvo_cdgo_csa_drcho
					Else 10	--En proceso
					End, 
					fcha_dsde,			fcha_hsta,
					tlfno_rsdnca,			drccn_rsdnca
		From		dbo.tbBeneficiariosFormularioValidador	With(NoLock)
		Where		cnsctvo_tpo_idntfccn_bnfcro	= @cnsctvo_cdgo_tpo_idntfccn
		And			nmro_idntfccn_bnfcro		= @nmro_idntfccn
		and			cnsctvo_cdgo_pln			= @cnsctvo_cdgo_pln
		And			cnsctvo_cdgo_estdo_frmlro	!= 6 --Traspasados
	
		If Exists	(	Select	1
						From	@tb_tmpAfiliado
						Where	@fcha_vldccn Between Convert(char(10),inco_vgnca_bnfcro,111) And Convert(char(10),fn_vgnca_bnfcro,111)
						And		orgn	= '2'
					)
			Begin
				Delete	@tb_tmpAfiliado
				Where	Convert(char(10),inco_vgnca_bnfcro,111) > @fcha_vldccn 
				Or		@fcha_vldccn > Convert(char(10),fn_vgnca_bnfcro,111)
		--		Or	orgn	!= '2' --Se comentarea para analisis
			
				Set @bd 	= '2'  -- Formulario
			End
	End
--End
--smns_aflcn_ss_ps Estas son las semanas de afiliación al sistema de seguridad

If Isnull(@Bd,'') =' ' Or @bd = '3'
	Begin
		Insert Into @tb_tmpAfiliado
		(			prmr_aplldo, 	sgndo_aplldo, 		prmr_nmbre, 
					sgndo_nmbre, 			cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
					fcha_ncmnto, 			cdgo_sxo,		cnsctvo_cdgo_sxo,
					cnsctvo_cdgo_prntsco,		cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_afldo,
					cnsctvo_cdgo_rngo_slrl,		inco_vgnca_bnfcro,	fn_vgnca_bnfcro,
					smns_aflcn_eps_ps,		smns_ctzds_eps_ps,	smns_aflcn_eps_pc,
					smns_aflcn_ss_pc,		cnsctvo_cdgo_estdo_drcho,cdgo_ips_prmra,
					cdgo_eapb,			cnsctvo_cdgo_tpo_cntrto, nmro_cntrto,
					orgn,				fcha_dsde,		fcha_hsta,
					tlfno_rsdnca,			drccn_rsdnca
		)
		Select 		a.prmr_aplldo_bnfcro, 		isnull(a.sgndo_aplldo_bnfcro,'') as sgndo_aplldo_bnfcro,	a.prmr_nmbre_bnfcro,
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
		Inner Join	bdSisalud.dbo.tbDetalleeapb_Vigencias	b	With(NoLock)	On	b.cdgo_eapb = a.cdgo_eapb
		Where 		a.nmro_idntfccn_bnfcro 				= @nmro_idntfccn
		And			a.cnsctvo_cdgo_tpo_idntfccn_bnfcro	= @cnsctvo_cdgo_tpo_idntfccn
		And			a.cnsctvo_cdgo_pln					= @cnsctvo_cdgo_pln 
		And			(@fcha_vldccn Between Convert(char(10),b.inco_vgnca,111) and Convert(char(10),b.fn_vgnca,111))
		And			b.vsble_vlddr						= 'S'

		If Exists	(	Select	1
						From	@tb_tmpAfiliado
						Where	@fcha_vldccn Between Convert(char(10),inco_vgnca_bnfcro,111) And Convert(char(10),fn_vgnca_bnfcro,111)
						And		orgn	= '3'
					)
			Begin
				Delete	@tb_tmpAfiliado
				Where	Convert(char(10),inco_vgnca_bnfcro,111) > @fcha_vldccn 
				Or		@fcha_vldccn > Convert(char(10),fn_vgnca_bnfcro,111)
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

		Select * From @tb_tmpAfiliado
		return
	End

/*******************************************************************************
***	Se escoge el ultimo registro actualizado
*******************************************************************************/
--Select	*
--from	@tb_tmpAfiliado
Set		@bd = null
Set		@dFcha_pvte = null

Select	@dFcha_pvte = Max(fcha_hsta)
From	@tb_tmpAfiliado
Where	@fcha_vldccn Between Convert(char(10),inco_vgnca_bnfcro,111) And Convert(char(10),fn_vgnca_bnfcro,111)
And		Convert(char(10),fn_vgnca_bnfcro,111)	<> '9999/12/31'
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

		Select * From @tb_tmpAfiliado
		return
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
		From		bdSisalud..tbDetalleEapb_Vigencias	a	With(NoLock)
		Inner Join	@tb_tmpAfiliado						b	On	b.cdgo_eapb	= a.cdgo_eapb
		And			orgn		= '3'


/*
	Select	@mnsje = 'FAMISANAR'
	From	@tb_tmpAfiliado
	Where	cdgo_eapb	= '1'
	And	orgn		= '3'

	Select	@mnsje = 'CAJANAL'

	From	@tb_tmpAfiliado
	Where	cdgo_eapb	= '2'
	And	orgn		= '3'

	Select	@mnsje = 'CAPRECOM'
	From	@tb_tmpAfiliado
	Where	cdgo_eapb	= '3'
	And	orgn		= '3'
*/
	End


/*******************************************************************************
***	Se actualizan los datos restantes
*******************************************************************************/
If  @bd = '1' -- Contratos
	Begin
		Insert into @tiempoAfiliacion(
		smns_ctzds,
		smns_aflcn,
		smns_ctzds_antrr_eps,
		smns_aflcn_antrr_eps,
		cnsctvo_cdgo_tpo_cntrto,
		nmro_cntrto,
		inco_vgnca_bnfcro,
		fn_vgnca_bnfcro
		)
		Select		b.smns_ctzds,b.smns_aflcn,b.smns_ctzds_antrr_eps,smns_aflcn_antrr_eps,
					b.cnsctvo_cdgo_tpo_cntrto,b.nmro_cntrto,
					b.inco_vgnca_bnfcro,b.fn_vgnca_bnfcro
		From		@tb_tmpAfiliado					t
		Inner Join	dbo.tbBeneficiariosValidador	b	With(NoLock)	On	b.nmro_unco_idntfccn_afldo	= t.nmro_unco_idntfccn_afldo

		If Exists	(	Select	1
						FRom	@tiempoAfiliacion
						Where	cnsctvo_cdgo_tpo_cntrto	= 1
						And	@fcha_vldccn Between Convert(char(10),inco_vgnca_bnfcro,111) And Convert(char(10),fn_vgnca_bnfcro,111)
					)
			Begin
				Update	@tb_tmpAfiliado
				Set		smns_ctzds_ss_ps		= b.smns_ctzds,
						smns_ctzds_eps_ps		= b.smns_ctzds_antrr_eps,
						smns_aflcn_eps_ps  		= b.smns_aflcn,
						smns_aflcn_ss_ps  		= b.smns_aflcn_antrr_eps,
		 				smns_ctzds_eps			= b.smns_ctzds
				From	@tb_tmpAfiliado t,	@tiempoAfiliacion b
				Where	b.cnsctvo_cdgo_tpo_cntrto	= 1
				And		@fcha_vldccn Between Convert(char(10),b.inco_vgnca_bnfcro,111) And Convert(char(10),b.fn_vgnca_bnfcro,111)
			End
		Else
			Begin
				Update	@tb_tmpAfiliado
				Set		smns_ctzds_ss_ps		= b.smns_ctzds,
						smns_ctzds_eps_ps		= b.smns_ctzds_antrr_eps,
						smns_aflcn_eps_ps  		= b.smns_aflcn,
						smns_aflcn_ss_ps  		= b.smns_aflcn_antrr_eps,
		 				smns_ctzds_eps			= b.smns_ctzds
				From	@tb_tmpAfiliado t,	@tiempoAfiliacion b
				Where	b.cnsctvo_cdgo_tpo_cntrto	= 1
				And		t.fn_vgnca_bnfcro Between Convert(char(10),b.inco_vgnca_bnfcro,111) And Convert(char(10),b.fn_vgnca_bnfcro,111)
		
				if @@ROWCOUNT = 0
					Begin
						Update	@tb_tmpAfiliado
						Set		smns_ctzds_ss_ps		= b.smns_ctzds,
								smns_ctzds_eps_ps		= b.smns_ctzds_antrr_eps,
								smns_aflcn_eps_ps  		= b.smns_aflcn,
								smns_aflcn_ss_ps  		= b.smns_aflcn_antrr_eps,
			 					smns_ctzds_eps			= b.smns_ctzds
						From	@tb_tmpAfiliado t,	@tiempoAfiliacion b,
								(	Select	Max(fn_vgnca_bnfcro) as fn_vgnca_bnfcro
									From	@tiempoAfiliacion
									Where	cnsctvo_cdgo_tpo_cntrto	= 1
								) as g
						Where	b.cnsctvo_cdgo_tpo_cntrto	= 1
						And		b.fn_vgnca_bnfcro			= g.fn_vgnca_bnfcro
					End
			End

		If Exists	(	Select	1
						FRom	@tiempoAfiliacion
						Where	cnsctvo_cdgo_tpo_cntrto	= 2
						And		@fcha_vldccn Between Convert(char(10),inco_vgnca_bnfcro,111) And Convert(char(10),fn_vgnca_bnfcro,111)
					)
			Begin
				Update		@tb_tmpAfiliado
				Set			cnsctvo_cdgo_pln_pc	= c.cnsctvo_cdgo_pln,
							smns_ctzds_ss_pc	= b.smns_ctzds,
							smns_ctzds_eps_pc	= b.smns_ctzds_antrr_eps,
							smns_aflcn_ss_pc	= b.smns_aflcn_antrr_eps,
							smns_aflcn_eps_pc	= b.smns_aflcn
				From		@tb_tmpAfiliado t,	@tiempoAfiliacion	b
				Inner Join	dbo.tbContratosValidador				c	On	b.cnsctvo_cdgo_tpo_cntrto	= c.cnsctvo_cdgo_tpo_cntrto
																		And	b.nmro_cntrto			= c.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS
				Where		c.cnsctvo_cdgo_tpo_cntrto	= 2
				And			@fcha_vldccn Between Convert(char(10),b.inco_vgnca_bnfcro,111) And Convert(char(10),b.fn_vgnca_bnfcro,111)
			End
		Else
			Begin
				Update		@tb_tmpAfiliado
				Set			cnsctvo_cdgo_pln_pc	= c.cnsctvo_cdgo_pln,
							smns_ctzds_ss_pc	= b.smns_ctzds,
							smns_ctzds_eps_pc	= b.smns_ctzds_antrr_eps,
							smns_aflcn_ss_pc	= b.smns_aflcn_antrr_eps,
							smns_aflcn_eps_pc	= b.smns_aflcn
				From		@tb_tmpAfiliado t,	@tiempoAfiliacion	b
				Inner Join	dbo.tbContratosValidador				c	On	b.cnsctvo_cdgo_tpo_cntrto	= c.cnsctvo_cdgo_tpo_cntrto
																		And	b.nmro_cntrto			= c.nmro_cntrto
				Where		c.cnsctvo_cdgo_tpo_cntrto	= 2
				And			t.fn_vgnca_bnfcro Between Convert(char(10),b.inco_vgnca_bnfcro,111) And Convert(char(10),b.fn_vgnca_bnfcro,111)

				if @@ROWCOUNT = 0
					Begin
						Update		@tb_tmpAfiliado
						Set			cnsctvo_cdgo_pln_pc	= c.cnsctvo_cdgo_pln,
									smns_ctzds_ss_pc	= b.smns_ctzds,
									smns_ctzds_eps_pc	= b.smns_ctzds_antrr_eps,
									smns_aflcn_ss_pc	= b.smns_aflcn_antrr_eps,
									smns_aflcn_eps_pc	= b.smns_aflcn
						From		@tb_tmpAfiliado t,	@tiempoAfiliacion	b
						Inner Join	dbo.tbContratosValidador				c	On	b.cnsctvo_cdgo_tpo_cntrto	= c.cnsctvo_cdgo_tpo_cntrto
																				And	b.nmro_cntrto			= c.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS,
									(	Select	Max(fn_vgnca_bnfcro) as fn_vgnca_bnfcro
										From	@tiempoAfiliacion
										Where	cnsctvo_cdgo_tpo_cntrto	= 1
									) as									g
						Where		c.cnsctvo_cdgo_tpo_cntrto	= 2
						And			b.fn_vgnca_bnfcro		= g.fn_vgnca_bnfcro
					End
			End

		Update		@tb_tmpAfiliado
		Set			cnsctvo_cdgo_estdo_drcho	= m.cnsctvo_cdgo_estdo_drcho,
					cnsctvo_cdgo_csa_drcho		= m.cnsctvo_cdgo_csa_drcho,
					dscrpcn_csa_drcho		= isnull(c.dscrpcn_csa_drcho,' ')
		From		@tb_tmpAfiliado					t
		INNER JOIN	dbo.TbMatrizDerechosValidador	m	With(index(IX_TbMatrizDerechosValidador_inco_fin_v))	on	m.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																												And	m.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS = t.nmro_cntrto --COLLATE SQL_Latin1_General_CP1_CI_AS              
																												And	m.cnsctvo_bnfcro			= t.cnsctvo_bnfcro
		INNER JOIN dbo.tbCausasDerechoValidador		c	With(NoLock)											On	m.cnsctvo_cdgo_estdo_drcho	= c.cnsctvo_cdgo_estdo_drcho
																												And	m.cnsctvo_cdgo_csa_drcho	= c.cnsctvo_cdgo_csa_drcho
		Where		@fcha_vldccn Between Convert(char(10),m.inco_vgnca_estdo_drcho,111) And Convert(char(10),m.fn_vgnca_estdo_drcho,111)
	End

/*
If  @bd = '2' -- Formulario
Begin
	Update	@tb_tmpAfiliado
	Set	

End
*/

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

--Ajuste Calculo de Sede
Update		@tb_tmpAfiliado
Set			dscrpcn_ips_prmra = i.nmbre_scrsl,
			cnsctvo_cdgo_sde_ips = i.cnsctvo_cdgo_sde_ips --Adicion Campo sede 
From		@tb_tmpAfiliado							t
INNER JOIN	bdSISalud.dbo.tbIpsPrimarias_vigencias	i	With(NoLock)	On	t.cdgo_ips_prmra	= i.cdgo_intrno --COLLATE SQL_Latin1_General_CP1_CI_AS

Update		@tb_tmpAfiliado
set			cnsctvo_cdgo_sde_ips  = c.cnsctvo_sde_inflnca
from		@tb_tmpAfiliado									t
INNER JOIN	bdAfiliacionvalidador.dbo.tbCiudades_Vigencias	c	With(NoLock)	On t.cnsctvo_cdgo_cdd_rsdnca = c.cnsctvo_cdgo_cdd 
Where		t.cnsctvo_cdgo_tpo_cntrto=2  --Solo Para Plan PAC

Update		@tb_tmpAfiliado
Set 		dscrpcn_estdo_drcho		= edv.dscrpcn_estdo_drcho,
			dscrpcn_drcho			= edv.dscrpcn_drcho,
			cnsctvo_cdgo_estdo_drcho	= edv.cnsctvo_cdgo_estdo_drcho,
			drcho = edv.drcho
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

Update		@tb_tmpAfiliado
set			cnsctvo_cdgo_sde_ips  = c.cnsctvo_sde_inflnca
from		@tb_tmpAfiliado									t
INNER JOIN	bdAfiliacionvalidador.dbo.tbCiudades_Vigencias	c	With(NoLock)	On t.cnsctvo_cdgo_cdd_rsdnca = c.cnsctvo_cdgo_cdd
Where		t.cnsctvo_cdgo_tpo_cntrto=2  --Solo Para Plan PAC

Update		@tb_tmpAfiliado
Set			flg_enble_nmro_vldcn	= 'S'
Where		cnsctvo_cdgo_estdo_drcho	 = 8--In (8) Suspendido
Or			cnsctvo_cdgo_estdo_drcho	 = 7 --Retirado
Or			cnsctvo_cdgo_estdo_drcho	= 6 --en Proceso


/*
--El usuario no existe.
If Not Exists(Select	1
		From	@tb_tmpAfiliado	)
	Update	@tb_tmpAfiliado
	Set	cnsctvo_tpo_vldcn_actva	= 2
*/

Update		@tb_tmpAfiliado
Set			cnsctvo_tpo_vldcn_actva	= 2
Where		orgn		= '2'	--Formularios

Update		@tb_tmpAfiliado
Set			cnsctvo_tpo_vldcn_actva	= 2
Where		orgn				= '1'	--Contratos
And			cnsctvo_cdgo_estdo_drcho	in (7,8)	-- 7 Retirado, 8 suspendido

Update		@tb_tmpAfiliado
Set			cnsctvo_tpo_vldcn_actva	= 1
Where		orgn				= '1'	--Contratos
And			cnsctvo_cdgo_estdo_drcho	not in (7,8)	--Retirado

Update		@tb_tmpAfiliado
Set			cnsctvo_tpo_vldcn_actva	= 1
Where		orgn				= '3'	--Famisanar

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

Select		@lfFechaReferencia	= fn_vgnca_bnfcro
From		@tb_tmpAfiliado
Where		Convert(char(10),fn_vgnca_bnfcro,111)	< @fcha_vldccn
And			orgn		= '1'	--Contratos

Select		@lfFechaReferencia	= fcha_hsta
From		@tb_tmpAfiliado
Where		Convert(char(10),fcha_hsta,111)	< @fcha_vldccn
And			orgn		!= '1'	--Contratos

/*
-- Consulta si el afiliado tiene Bono Electronico
Update	@tb_tmpAfiliado
Set	cnsctvo_dcmnto_gnrdo 		=  dav.cnsctvo_dcmnto_gnrdo,
	nmro_dcmnto			= dav.nmro_dcmnto
From	bdAfiliacionValidador.dbo.tbDocumentosAfiliacionValidador dav, @tb_tmpAfiliado b
Where	dav.cnsctvo_cdgo_estdo_dcmnto	in(3,19)  --3: Impreso, 19:Bono Electronico
And	(Convert(char(10),getdate(),111) Between Convert(char(10),dav.inco_vgnca_dcmnto,111) And Convert(char(10),dav.fn_vgnca_dcmnto,111))
And	dav.nmro_unco_idntfccn		= b.nmro_unco_idntfccn_afldo
And	b.cnsctvo_cdgo_estdo_drcho	!= 7
And	dav.fcha_utlzcn_bno Is null
*/
--Select	Top 1
Select	
prmr_aplldo, 
sgndo_aplldo, 
prmr_nmbre, 
sgndo_nmbre, 
cnsctvo_cdgo_tpo_idntfccn, 
nmro_idntfccn, 
fcha_ncmnto, 
cnsctvo_cdgo_sxo, 
cdgo_sxo, 
edd, 
edd_mss, 
edd_ds,
cnsctvo_cdgo_tpo_undd, 
orgn, 
cnsctvo_cdgo_tpo_cntrto, 
nmro_cntrto, 
cnsctvo_cdgo_pln, 
nmro_unco_idntfccn_afldo, 
inco_vgnca_bnfcro, 
fn_vgnca_bnfcro, 
cnsctvo_cdgo_prntsco, 
dscrpcn_prntsco, 
cnsctvo_cdgo_tpo_afldo, 
dscrpcn_tpo_afldo, 
cnsctvo_cdgo_rngo_slrl, 
dscrpcn_rngo_slrl, 
cnsctvo_cdgo_pln_pc, 
dscrpcn_pln_pc, 
smns_ctzds_ss_ps, 
smns_ctzds_eps_ps, 
smns_ctzds_ss_pc, 
smns_ctzds_eps_pc, 
cdgo_ips_prmra, 
dscrpcn_ips_prmra, 
cnsctvo_bnfcro, 
cdgo_eapb, 
nmro_unco_idntfccn_ctznte, 
cnsctvo_cdgo_tpo_cntrto_psc, 
nmro_cntrto_psc, 
ds_ctzds, 
cnsctvo_cdgo_sde_ips, 
dscrpcn_tpo_cntrto, 
cnsctvo_cdgo_csa_drcho, 
cnsctvo_cdgo_estdo_drcho,
dscrpcn_estdo_drcho, 
dscrpcn_csa_drcho, 
dscrpcn_drcho, 
dscrpcn_pln, 
dscrpcn_tpo_ctznte, 
prmr_nmbre_ctznte, 
sgndo_nmbre_ctznte, 
prmr_aplldo_ctznte, 
sgndo_aplldo_ctznte, 
drccn_rsdnca, 
tlfno_rsdnca, 
cnsctvo_cdgo_cdd_rsdnca, 
dscrpcn_cdd_rsdnca, 
cnsctvo_cdgo_estdo_cvl,	
dscrpcn_estdo_cvl, 
cnsctvo_cdgo_tpo_frmlro,	
nmro_frmlro, 
cdgo_tpo_idntfccn, 
cnsctvo_cdgo_afp, 
fcha_dsde, 
fcha_hsta, 
flg_enble_nmro_vldcn, 
drcho, 
cdgo_afp, 
cnsctvo_tpo_vldcn_actva,	
cfcha_ncmnto, 
smns_aflcn_ss_ps, 
smns_aflcn_eps_ps, 
smns_aflcn_ss_pc, 
smns_aflcn_eps_pc, 
smns_ctzds_eps,	
cdgo_tpo_prntsco, 
cdgo_cdd, 
cdgo_rngo_slrl, 
cdgo_tpo_afldo, 
cdgo_tpo_idntfccn_ctznte, 
nmro_idntfccn_ctznte, 
cnsctvo_tpo_idntfccn_ctznte, 
@lfFechaReferencia as fcha_rfrnca, 
@fcha_mxma_rprte as fcha_mxma_rprte, 
cnsctvo_dcmnto_gnrdo, nmro_dcmnto, eml --@mnsje as mensaje
From @tb_tmpAfiliado



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas_AlDia] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas_AlDia] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas_AlDia] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas_AlDia] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas_AlDia] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas_AlDia] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas_AlDia] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas_AlDia] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas_AlDia] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas_AlDia] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas_AlDia] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas_AlDia] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas_AlDia] TO [Radicador Recobros]
    AS [dbo];

