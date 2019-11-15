CREATE  procedure  [dbo].[spWSInformacionConvenioCaja]
@cnsctvo_cdgo_pln           Udtconsecutivo,
@fcha_vldcn					datetime

AS

SET ANSI_NULLS ON   
SET ANSI_WARNINGS on  
SET NOCOUNT ON

/*
set @cnsctvo_cdgo_pln = 1
set @fcha_vldcn = '2017-05-01'

create table #tmpParametros
(
	cnsctvo_prdcto_scrsl	Int,
	cnsctvo_cdgo_rngo_slrl	Int,
	cnsctvo_cdgo_tpo_afldo	Int
)

Insert Into	#tmpParametros	Values (1,	2,	1)
Insert Into	#tmpParametros	Values (1,	2,	1)
Insert Into #tmpParametros	Values (1,	2,	1)
*/

Begin
	declare		@cnvno 	char(5)  ,
				@historico	char(1)

	IF @fcha_vldcn IS NULL 
		select @fcha_vldcn = getdate()

	--Primero validamos si la fecha es la actual o se debe buscar la informacion en los historicos
	if convert(char(10), @fcha_vldcn, 111)  = convert(char(10), getdate(), 111)
		select @historico = 'N'
	else
		select @historico = 'S'

	set @cnvno=''

	Create Table #tmpProductoPlan
		(
			cnsctvo_mdlo			Int,
			cnsctvo_prdcto_scrsl	Int
		)

	Create Clustered Index [idx_mdlo]
	On #tmpProductoPlan ([cnsctvo_mdlo])

	Create Table #tmpFinalTexto
		(
			txto_cpgo_cta_mdrdra			VarChar(150),
			txto_cpgo						VarChar(150),
			txto_cta_mdrdra					VarChar(150),
			cnsctvo_mdlo					Int,
			dscrpcn_txto_cpgo				VarChar(150),
			dscrpcn_cdgo_txto_cta_mdrdra	VarChar(150),
			cnsctvo_cdgo_rngo_slrl			Int,
			cnsctvo_cdgo_tpo_afldo			Int,
			cnsctvo_cdgo_txto_cpgo			Int,
			cnsctvo_cdgo_txto_cta_mdrdra	Int,
			txto_adcnl						VarChar(150),
			cnsctvo_prdcto_scrsl			Int,
			mxmo_inco_vgnca					DateTime
		)

	Create Clustered Index [idx_mdlo_txto]
	On #tmpFinalTexto ([cnsctvo_mdlo])

	Insert Into #tmpProductoPlan  
	select 		cnsctvo_mdlo,		cnsctvo_prdcto
	from 		tbDetProductos	d	With(NoLock)
	Inner Join	#tmpParametros	e	With(NoLock)	On	e.cnsctvo_prdcto_scrsl	=	d.cnsctvo_prdcto
	Where		@fcha_vldcn 	 between 	d.inco_vgnca_asccn	and 	d.fn_vgnca_asccn
	and 		d.cnsctvo_cdgo_clse_mdlo 	=	5	--modelo texto

	if @@rowcount = 0	--Buscamos el convenio generico para el plan 
		Begin 
			insert into	#tmpProductoPlan  
			select 		d.cnsctvo_mdlo,	p.cnsctvo_prdcto
			from 		tbDetProductos	d	With(NoLock)
			Inner Join	#tmpParametros	e	With(NoLock)	On	e.cnsctvo_prdcto_scrsl	=	d.cnsctvo_prdcto
			Inner Join	(	Select	cnsctvo_prdcto
							From	tbProductos	With(NoLock)
							where 	cnsctvo_cdgo_estdo in (4,2) 					--activo o aprobado
							and 	cnsctvo_cdgo_pln		= @cnsctvo_cdgo_pln		--plan	      
							and 	cnsctvo_cdgo_tpo_prdcto = 1						--generico
							and 	@fcha_vldcn				>= inco_vgnca_prdcto	--vigente a la fecha
							and 	@fcha_vldcn				<= fn_vgnca_prdcto		--vigente a la fecha 
						)	p	On	p.cnsctvo_prdcto	=	d.cnsctvo_prdcto
			where 		@fcha_vldcn 				>= 	d.inco_vgnca_asccn	
			and 		@fcha_vldcn 				<= 	d.fn_vgnca_asccn
			and 		d.cnsctvo_cdgo_clse_mdlo 	= 5	--modelo texto
		End

	Insert Into		#tmpFinalTexto
	select Distinct	ltrim(rtrim(dscrpcn_txto_cpgo)) + ' COPAGO - ' + ltrim(rtrim(dscrpcn_cdgo_txto_cta_mdrdra)) + ' CUOTA MODERADORA - ' + isnull(ltrim(rtrim(txto_adcnl)),''),
					ltrim(rtrim(dscrpcn_txto_cpgo)) + ' COPAGO ',		ltrim(rtrim(dscrpcn_cdgo_txto_cta_mdrdra)) + ' CUOTA MODERADORA',
					a.cnsctvo_mdlo,										dscrpcn_txto_cpgo,
					dscrpcn_cdgo_txto_cta_mdrdra,						a.cnsctvo_cdgo_rngo_slrl,
					a.cnsctvo_cdgo_tpo_afldo,							cnsctvo_cdgo_txto_cpgo,
					cnsctvo_cdgo_txto_cta_mdrdra,						ltrim(rtrim(txto_adcnl)),	b.cnsctvo_prdcto_scrsl,
					NULL
	from 			tbdetmodelotextosvalidador	a	With(NoLock)
	Inner Join		#tmpProductoPlan			b	With(NoLock)	On	a.cnsctvo_mdlo				=	b.cnsctvo_mdlo 
	Inner Join		#tmpParametros				c	With(NoLock)	On	c.cnsctvo_cdgo_rngo_slrl	=	a.cnsctvo_cdgo_rngo_slrl
																	and c.cnsctvo_cdgo_tpo_afldo	=	a.cnsctvo_cdgo_tpo_afldo

	if 	@historico = 'S'
		Begin
			--declare		@inco_vgnca			datetime
			--Select		@inco_vgnca	=	MAX(a.inco_vgnca)

			Update		#tmpFinalTexto
			Set			mxmo_inco_vgnca	=	h.inco_vgnca
			From		#tmpFinalTexto	b
			Inner Join	(	Select		MAX(a.inco_vgnca) inco_vgnca,	a.cnsctvo_mdlo
							From		tbHistoricodetmodelotextosvalidador a	with(nolock)
							Where		@fcha_vldcn between inco_vgnca and fn_vgnca
							Group By	a.cnsctvo_mdlo
						)	h	On	h.cnsctvo_mdlo = b.cnsctvo_mdlo 
			

			Create Table #tmpFuenteDatosPresupuestoIngresosPacUnpivot
			(
				cnsctvo_mdlo					Int,
				cnsctvo_cdgo_rngo_slrl			Int,
				cnsctvo_cdgo_tpo_afldo			Int,
				cnsctvo_cdgo_txto_cpgo			Int,
				cnsctvo_cdgo_txto_cta_mdrdra	Int,
				dscrpcn_txto_cpgo				VarChar(50)
			)
		
			Insert Into	#tmpFuenteDatosPresupuestoIngresosPacUnpivot
			Select		cnsctvo_mdlo,	[cnsctvo_cdgo_rngo_slrl], [cnsctvo_cdgo_tpo_afldo], [cnsctvo_cdgo_txto_cpgo], [cnsctvo_cdgo_txto_cta_mdrdra], [dscrpcn_txto_cpgo]
			From	(	Select Distinct	c.cnsctvo_mdlo, dscrpcn_cmpo,	vlr_cmpo
						From			tbHistoricodetmodelotextosvalidador	a	With(NoLock)
						Inner Join		tbdetmodelotextosvalidador			c	With(NoLock)	On	c.cnsctvo_mdlo				=	a.cnsctvo_mdlo
																								And	c.cnsctvo_dtlle_mdlo_txto	=	a.cnsctvo_dtlle_mdlo_txto
						Inner Join		#tmpFinalTexto						b	With(NoLock)	On	b.cnsctvo_mdlo				=	c.cnsctvo_mdlo 
																								And	b.cnsctvo_cdgo_rngo_slrl	=	c.cnsctvo_cdgo_rngo_slrl
																								And	b.cnsctvo_cdgo_tpo_afldo	=	c.cnsctvo_cdgo_tpo_afldo
						Where			a.inco_vgnca				>=	b.mxmo_inco_vgnca
					) srce
			Pivot	(	max(vlr_cmpo) FOR dscrpcn_cmpo In ([cnsctvo_cdgo_rngo_slrl], [cnsctvo_cdgo_tpo_afldo], [cnsctvo_cdgo_txto_cpgo], [cnsctvo_cdgo_txto_cta_mdrdra], [dscrpcn_txto_cpgo])) as pvt

			update		#tmpFinalTexto
			set			cnsctvo_cdgo_rngo_slrl			=	b.cnsctvo_cdgo_rngo_slrl,
						cnsctvo_cdgo_tpo_afldo			=	b.cnsctvo_cdgo_tpo_afldo,
						cnsctvo_cdgo_txto_cpgo			=	b.cnsctvo_cdgo_txto_cpgo,
						cnsctvo_cdgo_txto_cta_mdrdra	=	b.cnsctvo_cdgo_txto_cta_mdrdra,	
						dscrpcn_txto_cpgo				=	b.dscrpcn_txto_cpgo,
						txto_cpgo						=	ltrim(rtrim(a.dscrpcn_txto_cpgo)) + ' COPAGO ',
						txto_cta_mdrdra					=	ltrim(rtrim(a.dscrpcn_cdgo_txto_cta_mdrdra)) + ' CUOTA MODERADORA ',
						txto_cpgo_cta_mdrdra			=	ltrim(rtrim(a.dscrpcn_txto_cpgo)) + ' COPAGO - ' + ltrim(rtrim(a.dscrpcn_cdgo_txto_cta_mdrdra)) + ' CUOTA MODERADORA - ' + isnull(ltrim(rtrim(a.txto_adcnl)),'')
			From		#tmpFinalTexto									a	With(NoLock)
			Inner Join	#tmpFuenteDatosPresupuestoIngresosPacUnpivot	b	With(NoLock)	On	b.cnsctvo_mdlo = a.cnsctvo_mdlo
		
			Drop Table	#tmpFuenteDatosPresupuestoIngresosPacUnpivot
		End

	Select		txto_cpgo_cta_mdrdra,				txto_cpgo,					txto_cta_mdrdra,			cnsctvo_mdlo,				dscrpcn_txto_cpgo,
				dscrpcn_cdgo_txto_cta_mdrdra,		cnsctvo_cdgo_rngo_slrl,		cnsctvo_cdgo_tpo_afldo,		cnsctvo_cdgo_txto_cpgo,		cnsctvo_cdgo_txto_cta_mdrdra,
				txto_adcnl,							cnsctvo_prdcto_scrsl
	From		#tmpFinalTexto	With(NoLock)

	Drop Table	#tmpProductoPlan
	Drop Table	#tmpFinalTexto
End

--Grant Execute On [dbo].[spWSInformacionConvenioCaja] To [websos]
