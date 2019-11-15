
/*-----------------------------------------------------------------------------------------------------------------------                   
 * Metodo o PRG   :	spConsultaDerechoAfiliadoAlDia               
 * Desarrollado por: <\A Ing. Darling Liliana Dorado            A\>    
 * Descripcion  :	 <\D Consulta del derecho del afiliado a la fecha actual  D\>                 
 * Observaciones :	 <\O										O\>                 
 * Parametros  :	 <\P										P\>                 
 * Variables  :		 <\V V\>                 
 * Fecha Creacion :  <\FC 20160305 FC\>                  
 *                   
 *------------------------------------------------------------------------------------------------------------------------                     
 * DATOS DE MODIFICACION                   
 *------------------------------------------------------------------------------------------------------------------------                   
 * Modificado Por		: <\AM	Maria Liliana Prieto Rincon																		AM\>
 * Descripcion			: <\DM	Cambio tabla tbactua a BDIpsTransaccional																		DM\>
 * Nuevos Parametros	: <\PM	    																	PM\>
 * Nuevas Variables		: <\VM																			VM\>
 * Fecha Modificacion   : <\FM	2017/11/08 																		FM\>
 *-----------------------------------------------------------------------------------------------------------------------*/  

--  Exec spConsultaDerechoAfiliadoAlDia 1, '38886736',1,''

CREATE procedure [dbo].[spConsultaDerechoAfiliadoAlDia]
--Declare
@cnsctvo_cdgo_tpo_idntfccn 	udtConsecutivo, --consecutivo del id del afiliado
@nmro_idntfccn				Varchar(23), 	--numero del id del afiliado
@cnsctvo_cdgo_pln 			udtConsecutivo, --consecutivo del plan con el cual se quiere consultar el derecho del afiliado
@mnsje						varchar(80) output -- mensaje que solo se genera si no se puede eobtener el derecho del afiliado


As
Set NoCount On


/*
Set	@cnsctvo_cdgo_tpo_idntfccn	= 1
Set	@nmro_idntfccn		= '38886736'
Set	@cnsctvo_cdgo_pln	= 1
Set	@mnsje				= ''
*/


-- Declaración de variables
Declare	@fcha_vldccn				datetime,
		@Nui_Afldo					UdtConsecutivo,
		@Bd 						char(1),
		@inco_vgnca_bnfcro			Datetime,
		@fcha_ultma_mdfccn			Datetime,	
		@lfFechaReferencia			datetime,
		@dFcha_pvte					datetime,
		@Historico					char(1),
		@maximafechabeneficiario	datetime,
		@nmbre_srvdr				VarChar(50),
		@hst_nme					VarChar(50),
		@origen						int

Set		@fcha_vldccn = Convert(char(10),getDate(),111)
Set		@lfFechaReferencia = @fcha_vldccn

---- TEMIS
Select		@nmbre_srvdr = Ltrim(Rtrim(vlr_prmtro))  
From		tbtablaParametros  With(NoLock)
Where		cnsctvo_prmtro = 5

Select		@hst_nme = Ltrim(Rtrim(Convert(Varchar(30), SERVERPROPERTY('machinename'))))



Declare @tb_Contrato Table
		(
			cnsctvo_cdgo_tpo_cntrto	int,
			nmro_cntrto				char(15),
			cnsctvo_bnfcro			int
		)

Declare	@tb_tmpAfiliado Table
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
			cdgo_estdo_drcho			char(2),		eml varchar(50),  inco_vgnca_cntrto datetime , fn_vgnca_cntrto datetime
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

--busco el numero unico del afiliado
/*Select @Nui_Afldo = nmro_unco_idntfccn_afldo From	dbo.tbBeneficiariosValidador
Where	cnsctvo_cdgo_tpo_idntfccn	= @cnsctvo_cdgo_tpo_idntfccn
And	nmro_idntfccn			= @nmro_idntfccn
--And @fcha_vldccn Between inco_vgnca_bnfcro And fn_vgnca_bnfcro -- Quick 2013-029-006915 Se estaba consultando NUI antiguos para el num de identificacion
*/

---Modificacion sisdgb01 17/05/2013
SET	@maximafechabeneficiario = (	Select		max(c.fn_vgnca_estdo_bnfcro) 
									From		dbo.tbBeneficiariosValidador			a	With(NoLock)
									Inner Join	dbo.tbVigenciasBeneficiariosValidador	c	With(NoLock)	On	c.cnsctvo_cdgo_tpo_cntrto	=	a.cnsctvo_cdgo_tpo_cntrto
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
								From			dbo.tbBeneficiariosValidador	With(NoLock)
								Where			cnsctvo_cdgo_tpo_idntfccn		= @cnsctvo_cdgo_tpo_idntfccn
								And				nmro_idntfccn					= @nmro_idntfccn
								And				estdo = 'A' and fn_vgnca_bnfcro = @maximafechabeneficiario
							)
  -- Quick 2013-029-006915 Se estaba consultando NUI antiguos para el num de identificacion
	End
Else 
	Begin
		Set	@maximafechabeneficiario	=	(	Select		max(c.fn_vgnca_estdo_bnfcro)
												From		dbo.tbBeneficiariosValidador			a	With(NoLock)
												Inner Join	dbo.tbVigenciasBeneficiariosValidador	c	With(NoLock)	On	c.cnsctvo_cdgo_tpo_cntrto	=	a.cnsctvo_cdgo_tpo_cntrto
																														And	c.nmro_cntrto				=	a.nmro_cntrto
																														And	c.cnsctvo_bnfcro			=	a.cnsctvo_bnfcro
												Where		a.cnsctvo_cdgo_tpo_idntfccn	= @cnsctvo_cdgo_tpo_idntfccn
												And			a.nmro_idntfccn				= @nmro_idntfccn
												And			a.estdo = 'I'
											)

		Set @Nui_Afldo	=	(	Select distinct nmro_unco_idntfccn_afldo
								From			dbo.tbBeneficiariosValidador	With(NoLock)
								Where			cnsctvo_cdgo_tpo_idntfccn	= @cnsctvo_cdgo_tpo_idntfccn
								And				nmro_idntfccn				= @nmro_idntfccn
								And				estdo						= 'I'
								And				fn_vgnca_bnfcro = @maximafechabeneficiario
							)
	End

Set	@Bd = @origen	

If Isnull(@Bd,'') =' ' Or @bd = '1'
	Begin
		Insert Into @tb_tmpAfiliado(
		prmr_aplldo,			sgndo_aplldo,			prmr_nmbre,
		sgndo_nmbre,			cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
		fcha_ncmnto,			cnsctvo_cdgo_sxo,		orgn,
		cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,			cnsctvo_cdgo_pln,
		nmro_unco_idntfccn_afldo,	inco_vgnca_bnfcro,		fn_vgnca_bnfcro,
		cnsctvo_cdgo_prntsco,		cnsctvo_cdgo_tpo_afldo,		cnsctvo_cdgo_rngo_slrl,
		smns_ctzds_ss_ps,		smns_ctzds_eps_ps,		cdgo_ips_prmra,
		cnsctvo_bnfcro,			cnsctvo_cdgo_afp,
		fcha_dsde,			fcha_hsta,
		tlfno_rsdnca,			drccn_rsdnca,			cnsctvo_cdgo_cdd_rsdnca,
		prmr_nmbre_ctznte,		sgndo_nmbre_ctznte,		prmr_aplldo_ctznte,
		sgndo_aplldo_ctznte,		cnsctvo_tpo_idntfccn_ctznte,	nmro_idntfccn_ctznte,
		nmro_unco_idntfccn_ctznte, eml, inco_vgnca_cntrto, fn_vgnca_cntrto
		)
		Select	b.prmr_aplldo,	b.sgndo_aplldo,	b.prmr_nmbre,
		b.sgndo_nmbre,			b.cnsctvo_cdgo_tpo_idntfccn,	b.nmro_idntfccn,
		b.fcha_ncmnto,			b.cnsctvo_cdgo_sxo,		'1',
		b.cnsctvo_cdgo_tpo_cntrto,	b.nmro_cntrto,			c.cnsctvo_cdgo_pln,
		b.nmro_unco_idntfccn_afldo,	v.inco_vgnca_estdo_bnfcro,		v.fn_vgnca_estdo_bnfcro,
		b.cnsctvo_cdgo_prntsco,		b.cnsctvo_cdgo_tpo_afldo,	c.cnsctvo_cdgo_rngo_slrl,
		b.smns_ctzds_antrr_eps,		b.smns_ctzds,			b.cdgo_intrno,
		b.cnsctvo_bnfcro,		c.cnsctvo_cdgo_afp,
		b.inco_vgnca_bnfcro,		b.fn_vgnca_bnfcro,
		b.tlfno_rsdnca,			b.drccn_rsdnca,			b.cnsctvo_cdgo_cdd_rsdnca,
		c.prmr_aplldo,			c.sgndo_aplldo,			c.prmr_nmbre,
		c.sgndo_nmbre,			c.cnsctvo_cdgo_tpo_idntfccn,	c.nmro_idntfccn,
		c.nmro_unco_idntfccn_afldo,
		isnull(b.eml,'') as eml, c.inco_vgnca_cntrto, c.fn_vgnca_cntrto
		From		dbo.tbBeneficiariosValidador			b	With(NoLock)
		INNER JOIN	dbo.tbContratosValidador				c	With(NoLock)	On	b.nmro_cntrto					= c.nmro_cntrto
																				And	b.cnsctvo_cdgo_tpo_cntrto		= c.cnsctvo_cdgo_tpo_cntrto
		Inner Join	dbo.tbVigenciasBeneficiariosValidador	v	With(NoLock)	On	v.cnsctvo_cdgo_tpo_cntrto		=	b.cnsctvo_cdgo_tpo_cntrto
																				And	v.nmro_cntrto					=	b.nmro_cntrto
																				And	v.cnsctvo_bnfcro				=	b.cnsctvo_bnfcro
		Where		b.nmro_unco_idntfccn_afldo	= @Nui_Afldo
		And			c.cnsctvo_cdgo_pln			= @cnsctvo_cdgo_pln
		And			@fcha_vldccn Between v.inco_vgnca_estdo_bnfcro And v.fn_vgnca_estdo_bnfcro

		--Si existe un contrato vigente
		If exists	(	select	1
						from	@tb_tmpAfiliado
						Where	@fcha_vldccn Between Convert(char(10),inco_vgnca_cntrto,111) And Convert(char(10),fn_vgnca_cntrto,111)
						And		@fcha_vldccn Between Convert(char(10),inco_vgnca_bnfcro,111) And Convert(char(10),fn_vgnca_bnfcro,111)
					)
			Begin
				--si ademas le pertenece el tipo y numero de id del afiliado
				If Exists	(	select	1
								from	@tb_tmpAfiliado
								where	cnsctvo_cdgo_tpo_idntfccn = @cnsctvo_cdgo_tpo_idntfccn
								And		nmro_idntfccn = @nmro_idntfccn
								And		@fcha_vldccn Between Convert(char(10),inco_vgnca_cntrto,111) And Convert(char(10),fn_vgnca_cntrto,111) 
								And		@fcha_vldccn Between Convert(char(10),inco_vgnca_bnfcro,111) And Convert(char(10),fn_vgnca_bnfcro,111)
							)
					Begin
						Insert into @tb_Contrato(cnsctvo_cdgo_tpo_cntrto, nmro_cntrto,cnsctvo_bnfcro)
						Select		cnsctvo_cdgo_tpo_cntrto, nmro_cntrto,cnsctvo_bnfcro
						from		@tb_tmpAfiliado
						where		cnsctvo_cdgo_tpo_idntfccn = @cnsctvo_cdgo_tpo_idntfccn
						And			nmro_idntfccn = @nmro_idntfccn
						And			@fcha_vldccn Between Convert(char(10),inco_vgnca_cntrto,111) And Convert(char(10),fn_vgnca_cntrto,111)
						And			@fcha_vldccn Between Convert(char(10),inco_vgnca_bnfcro,111) And Convert(char(10),fn_vgnca_bnfcro,111)
			
						--borra datos que no son del mismo contrato y del afiliado
						Delete		a
						From		@tb_tmpAfiliado a
						Left Join	@tb_Contrato	b	On	a.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto
														and a.nmro_cntrto				= b.nmro_cntrto
						Where		cnsctvo_cdgo_tpo_idntfccn = @cnsctvo_cdgo_tpo_idntfccn
						And			nmro_idntfccn = @nmro_idntfccn
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
									Inner join	@tb_Contrato	b	On	a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto
																	And a.nmro_cntrto = b.nmro_cntrto
																	And a.cnsctvo_bnfcro = b.cnsctvo_bnfcro
									Where		a.cnsctvo_cdgo_tpo_idntfccn = @cnsctvo_cdgo_tpo_idntfccn
									And			a.nmro_idntfccn = @nmro_idntfccn
								)
					Delete from @tb_tmpAfiliado
				Else
					Begin
						--borra datos que no son del mismo contrato y del afiliado
						Delete		a
						from		@tb_tmpAfiliado a
						left join	@tb_Contrato	b	On	a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto
														And a.nmro_cntrto = b.nmro_cntrto
														And a.cnsctvo_bnfcro = b.cnsctvo_bnfcro				
						Where		cnsctvo_cdgo_tpo_idntfccn = @cnsctvo_cdgo_tpo_idntfccn
						And			nmro_idntfccn = @nmro_idntfccn
						And			b.cnsctvo_cdgo_tpo_cntrto is null

						Set @bd 	= '1'  -- Contratos
					End
			End

	End



If Isnull(@Bd,'') =' ' Or @bd = '3'
	Begin
		Insert Into @tb_tmpAfiliado (prmr_aplldo, 	sgndo_aplldo, 		prmr_nmbre, 
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
		From 		dbo.tbEapb					a	With(NoLock)
		Inner Join	dbo.tbDetalleeapb_Vigencias b	With(NoLock)	On	b.cdgo_eapb		= a.cdgo_eapb
		Where 		a.nmro_idntfccn_bnfcro 				= @nmro_idntfccn
		And			a.cnsctvo_cdgo_tpo_idntfccn_bnfcro	= @cnsctvo_cdgo_tpo_idntfccn
		And			a.cnsctvo_cdgo_pln					= @cnsctvo_cdgo_pln 
		And			(@fcha_vldccn Between Convert(char(10),b.inco_vgnca,111) and Convert(char(10),b.fn_vgnca,111))
		And			b.vsble_vlddr						= 'S'

		If Exists	(	Select 1
						From	@tb_tmpAfiliado
						Where	@fcha_vldccn Between Convert(char(10),inco_vgnca_bnfcro,111) And Convert(char(10),fn_vgnca_bnfcro,111)
						And	orgn	= '3'
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

	End

/*******************************************************************************
***	Se escoge el ultimo registro actualizado
*******************************************************************************/
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
		From		tbDetalleEapb_Vigencias a	With(NoLock)
		Inner Join	@tb_tmpAfiliado			b	On	b.cdgo_eapb	= a.cdgo_eapb
		Where		orgn		= '3'
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
		fn_vgnca_bnfcro,
		nmro_unco_idntfccn_afldo
		)
		Select		b.smns_ctzds,b.smns_aflcn,b.smns_ctzds_antrr_eps,smns_aflcn_antrr_eps,
					b.cnsctvo_cdgo_tpo_cntrto,b.nmro_cntrto,
					c.inco_vgnca_estdo_bnfcro,c.fn_vgnca_estdo_bnfcro, b.nmro_unco_idntfccn_afldo
		From		@tb_tmpAfiliado							t
		Inner Join	dbo.tbBeneficiariosValidador			b	With(NoLock)	On	b.nmro_unco_idntfccn_afldo	=	t.nmro_unco_idntfccn_afldo
																				And b.cnsctvo_cdgo_tpo_cntrto	=	t.cnsctvo_cdgo_tpo_cntrto
																				And b.nmro_cntrto				=	t.nmro_cntrto
		Inner Join	dbo.tbVigenciasBeneficiariosValidador	c	With(NoLock)	On	c.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
																				And	c.nmro_cntrto				=	b.nmro_cntrto
																				And	c.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro

		If exists	(	select	1
						from	@tiempoAfiliacion
						where	cnsctvo_cdgo_tpo_cntrto = 1
					)
			Begin
				Insert into @tiempoAfiliacion(
				smns_ctzds,
				smns_aflcn,
				smns_ctzds_antrr_eps,
				smns_aflcn_antrr_eps,
				cnsctvo_cdgo_tpo_cntrto,
				nmro_cntrto,
				inco_vgnca_bnfcro,
				fn_vgnca_bnfcro,
				nmro_unco_idntfccn_afldo
				)
				Select		b.smns_ctzds,b.smns_aflcn,b.smns_ctzds_antrr_eps,smns_aflcn_antrr_eps,
							b.cnsctvo_cdgo_tpo_cntrto,b.nmro_cntrto,
							c.inco_vgnca_estdo_bnfcro,c.fn_vgnca_estdo_bnfcro, b.nmro_unco_idntfccn_afldo
				From		@tb_tmpAfiliado							t
				Inner Join	dbo.tbBeneficiariosValidador			b	With(NoLock)	On	b.nmro_unco_idntfccn_afldo	=	t.nmro_unco_idntfccn_afldo
				Inner Join	dbo.tbVigenciasBeneficiariosValidador	c	With(NoLock)	On	c.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
																						And	c.nmro_cntrto				=	b.nmro_cntrto
																						And	c.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro
				Where		b.cnsctvo_cdgo_tpo_cntrto = 2
				And			@fcha_vldccn Between Convert(char(10),c.inco_vgnca_estdo_bnfcro,111) And Convert(char(10),c.fn_vgnca_estdo_bnfcro,111)
			End
		Else
			Begin 
				Insert into @tiempoAfiliacion(
				smns_ctzds,
				smns_aflcn,
				smns_ctzds_antrr_eps,
				smns_aflcn_antrr_eps,
				cnsctvo_cdgo_tpo_cntrto,
				nmro_cntrto,
				inco_vgnca_bnfcro,
				fn_vgnca_bnfcro,
				nmro_unco_idntfccn_afldo
				)
				Select		b.smns_ctzds,b.smns_aflcn,b.smns_ctzds_antrr_eps,smns_aflcn_antrr_eps,
							b.cnsctvo_cdgo_tpo_cntrto,b.nmro_cntrto,
							c.inco_vgnca_estdo_bnfcro,c.fn_vgnca_estdo_bnfcro, b.nmro_unco_idntfccn_afldo
				From		@tb_tmpAfiliado							t
				Inner Join	dbo.tbBeneficiariosValidador			b	With(NoLock)	On	b.nmro_unco_idntfccn_afldo	=	t.nmro_unco_idntfccn_afldo
				Inner Join	dbo.tbVigenciasBeneficiariosValidador	c	With(NoLock)	On	c.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
																						And	c.nmro_cntrto				=	b.nmro_cntrto
																						And	c.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro
				where		b.cnsctvo_cdgo_tpo_cntrto = 1
				And			@fcha_vldccn Between Convert(char(10),c.inco_vgnca_estdo_bnfcro,111) And Convert(char(10),c.fn_vgnca_estdo_bnfcro,111)
			End


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
				Inner Join	@tiempoAfiliacion	b	On	b.cnsctvo_cdgo_tpo_cntrto = t.cnsctvo_cdgo_tpo_cntrto
													And	b.nmro_cntrto = t.nmro_cntrto
				Where		b.cnsctvo_cdgo_tpo_cntrto	= 1

				Update		@tb_tmpAfiliado
				Set			cnsctvo_cdgo_pln_pc	= c.cnsctvo_cdgo_pln,
							smns_ctzds_ss_pc	= b.smns_ctzds,
							smns_ctzds_eps_pc	= b.smns_ctzds_antrr_eps,
							smns_aflcn_ss_pc	= b.smns_aflcn_antrr_eps,
							smns_aflcn_eps_pc	= b.smns_aflcn
				From		@tb_tmpAfiliado				t
				inner join	@tiempoAfiliacion			b	On	b.nmro_unco_idntfccn_afldo	= t.nmro_unco_idntfccn_afldo
				Inner Join	dbo.tbContratosValidador	c	With(NoLock)	On	b.cnsctvo_cdgo_tpo_cntrto	= c.cnsctvo_cdgo_tpo_cntrto
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
				inner join	@tiempoAfiliacion			b	On	b.cnsctvo_cdgo_tpo_cntrto = t.cnsctvo_cdgo_tpo_cntrto
															And	b.nmro_cntrto = t.nmro_cntrto
				Inner Join	dbo.tbContratosValidador	c	With(NoLock)	On	b.cnsctvo_cdgo_tpo_cntrto	= c.cnsctvo_cdgo_tpo_cntrto
																			And	b.nmro_cntrto			= c.nmro_cntrto
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
					dscrpcn_csa_drcho		= isnull(c.dscrpcn_csa_drcho,' ')
		From		@tb_tmpAfiliado					t
		INNER JOIN	dbo.TbMatrizDerechosValidador	m	With(index(IX_TbMatrizDerechosValidador_inco_fin_v))	on	m.cnsctvo_cdgo_tpo_cntrto	= t.cnsctvo_cdgo_tpo_cntrto
																												And	m.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS = t.nmro_cntrto --COLLATE SQL_Latin1_General_CP1_CI_AS              
																												And	m.cnsctvo_bnfcro		= t.cnsctvo_bnfcro
		INNER JOIN dbo.tbCausasDerechoValidador		c	With(NoLock)											On	m.cnsctvo_cdgo_estdo_drcho	= c.cnsctvo_cdgo_estdo_drcho
																												And	m.cnsctvo_cdgo_csa_drcho	= c.cnsctvo_cdgo_csa_drcho
		Where		@fcha_vldccn Between Convert(char(10),m.inco_vgnca_estdo_drcho,111) And Convert(char(10),m.fn_vgnca_estdo_drcho,111)
	End



-- INICIO NUEVA VALIDACIÓN - 20150507 - SISCGM01 --
if @Bd = '5' --Marca No existe en el Sistema
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
				If @hst_nme = @nmbre_srvdr
					Begin
						Select	@Nui_Afldo=nmro_unco_idntfccn_afldo
						From	BDIpsTransaccional.dbo.tbactua	With(NoLock)
						Where	cnsctvo_cdgo_tpo_idntfccn=@cnsctvo_cdgo_tpo_idntfccn
						And		nmro_idntfccn=@nmro_idntfccn
					End
				Else
					Begin
						Select	@Nui_Afldo=nmro_unco_idntfccn_afldo
						From	bdsisalud..tbactua	With(NoLock)
						Where	cnsctvo_cdgo_tpo_idntfccn=@cnsctvo_cdgo_tpo_idntfccn
						And		nmro_idntfccn=@nmro_idntfccn
					End

				Set		@maximafechabeneficiario = (	Select		max(v.fn_vgnca_estdo_bnfcro)  
														From		dbo.tbBeneficiariosValidador			b	With(NoLock)
														INNER JOIN	tbContratosValidador					c	With(NoLock)	On	b.nmro_cntrto				=	c.nmro_cntrto
																																And	b.cnsctvo_cdgo_tpo_cntrto	=	c.cnsctvo_cdgo_tpo_cntrto
														Inner Join	dbo.tbVigenciasBeneficiariosValidador	v	With(NoLock)	On	v.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
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


Update		@tb_tmpAfiliado
Set 		dscrpcn_estdo_drcho		= edv.dscrpcn_estdo_drcho,
			dscrpcn_drcho			= edv.dscrpcn_drcho,
			cnsctvo_cdgo_estdo_drcho	= edv.cnsctvo_cdgo_estdo_drcho,
			drcho = edv.drcho,
			cdgo_estdo_drcho			= edv.cdgo_estdo_drcho
From		dbo.tbEstadosDerechoValidador	edv	With(NoLock)
INNER JOIN	@tb_tmpAfiliado					a	On	a.cnsctvo_cdgo_estdo_drcho 	= edv.cnsctvo_cdgo_estdo_drcho



Select			cnsctvo_cdgo_estdo_drcho,					dscrpcn_drcho,								
				dscrpcn_estdo_drcho,						drcho,										
				dscrpcn_csa_drcho,							cdgo_estdo_drcho
				cnsctvo_cdgo_csa_drcho										
			
From			@tb_tmpAfiliado

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaDerechoAfiliadoAlDia] TO [autsalud_rol]
    AS [dbo];

