CREATE  procedure  [dbo].[spPmInformacionConvenioCaja]
@cnsctvo_cdgo_pln           Udtconsecutivo,
@cnsctvo_cdgo_rngo_slrl     Udtconsecutivo,
@cnsctvo_cdgo_tpo_afldo     Udtconsecutivo,
@cnsctvo_prdcto_scrsl		Udtconsecutivo,
@fcha_vldcn					datetime

AS
SET ANSI_NULLS ON   
SET ANSI_WARNINGS on  
SET NOCOUNT ON

/*
set @cnsctvo_cdgo_pln		=	1
set @cnsctvo_cdgo_rngo_slrl	=	1
set @cnsctvo_cdgo_tpo_afldo	=	1
set @cnsctvo_prdcto_scrsl	=	1
set @fcha_vldcn = '2017-05-11'
*/

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
		txto_adcnl						VarChar(150)
	)

Create Clustered Index [idx_mdlo_txto]
On #tmpFinalTexto ([cnsctvo_mdlo])

Insert Into #tmpProductoPlan  
select 		cnsctvo_mdlo,		cnsctvo_prdcto
from 		tbDetProductos	With(NoLock)
where 		cnsctvo_prdcto 			= 	@cnsctvo_prdcto_scrsl
and 		@fcha_vldcn 	 between 	inco_vgnca_asccn	and 	fn_vgnca_asccn
and 		cnsctvo_cdgo_clse_mdlo 	=	5	--modelo texto

if @@rowcount = 0	--Buscamos el convenio generico para el plan 
	Begin 
		select 		@cnsctvo_prdcto_scrsl = cnsctvo_prdcto 
		from 		tbProductos	With(NoLock)
		where 		cnsctvo_cdgo_estdo in ( 4, 2) 					--activo o aprobado
		and 		cnsctvo_cdgo_pln		= @cnsctvo_cdgo_pln		--plan	      
		and 		cnsctvo_cdgo_tpo_prdcto = 1						--generico
		and 		@fcha_vldcn				>= inco_vgnca_prdcto	--vigente a la fecha
		and 		@fcha_vldcn				<= fn_vgnca_prdcto		--vigente a la fecha 

		insert into	#tmpProductoPlan  
		select 		cnsctvo_mdlo, cnsctvo_prdcto
		from 		tbDetProductos	With(NoLock)
		where 		cnsctvo_prdcto 			= 	@cnsctvo_prdcto_scrsl
		and 		@fcha_vldcn 			>= 	inco_vgnca_asccn	
		and 		@fcha_vldcn 			<= 	fn_vgnca_asccn
		and 		cnsctvo_cdgo_clse_mdlo 	= 5	--modelo texto
	End

Insert Into		#tmpFinalTexto
select Distinct	ltrim(rtrim(dscrpcn_txto_cpgo)) + ' COPAGO - ' + ltrim(rtrim(dscrpcn_cdgo_txto_cta_mdrdra)) + ' CUOTA MODERADORA - ' + isnull(ltrim(rtrim(txto_adcnl)),''),
				ltrim(rtrim(dscrpcn_txto_cpgo)) + ' COPAGO ',		ltrim(rtrim(dscrpcn_cdgo_txto_cta_mdrdra)) + ' CUOTA MODERADORA',
				a.cnsctvo_mdlo,										dscrpcn_txto_cpgo,
				dscrpcn_cdgo_txto_cta_mdrdra,						cnsctvo_cdgo_rngo_slrl,
				cnsctvo_cdgo_tpo_afldo,								cnsctvo_cdgo_txto_cpgo,
				cnsctvo_cdgo_txto_cta_mdrdra,						ISNULL(LTRIM(rtrim(txto_adcnl)),'')
from 			tbdetmodelotextosvalidador	a	With(NoLock)
Inner Join		#tmpProductoPlan			b	With(NoLock)	On	a.cnsctvo_mdlo = b.cnsctvo_mdlo 
Where 			a.cnsctvo_cdgo_rngo_slrl = @cnsctvo_cdgo_rngo_slrl
and 			a.cnsctvo_cdgo_tpo_afldo = @cnsctvo_cdgo_tpo_afldo 

if 	@historico = 'S'
	Begin
		declare		@inco_vgnca			datetime

		Select		@inco_vgnca	=	MAX(a.inco_vgnca)
		From		tbHistoricodetmodelotextosvalidador a	with(nolock)
		Inner Join	#tmpFinalTexto						b	With(NoLock)	On	a.cnsctvo_mdlo = b.cnsctvo_mdlo 
		Where		@fcha_vldcn between inco_vgnca and fn_vgnca

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
					Where			a.inco_vgnca				>=	@inco_vgnca
					And 			c.cnsctvo_cdgo_rngo_slrl	=	@cnsctvo_cdgo_rngo_slrl
					And 			c.cnsctvo_cdgo_tpo_afldo	=	@cnsctvo_cdgo_tpo_afldo 
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

Select	txto_cpgo_cta_mdrdra,				txto_cpgo,					txto_cta_mdrdra,			cnsctvo_mdlo,				dscrpcn_txto_cpgo,
		dscrpcn_cdgo_txto_cta_mdrdra,		cnsctvo_cdgo_rngo_slrl,		cnsctvo_cdgo_tpo_afldo,		cnsctvo_cdgo_txto_cpgo,		cnsctvo_cdgo_txto_cta_mdrdra,
		txto_adcnl
From	#tmpFinalTexto	With(NoLock)

Drop Table	#tmpProductoPlan
Drop Table	#tmpFinalTexto
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmInformacionConvenioCaja] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmInformacionConvenioCaja] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmInformacionConvenioCaja] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmInformacionConvenioCaja] TO [autsalud_rol]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmInformacionConvenioCaja] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmInformacionConvenioCaja] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmInformacionConvenioCaja] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmInformacionConvenioCaja] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmInformacionConvenioCaja] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmInformacionConvenioCaja] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmInformacionConvenioCaja] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmInformacionConvenioCaja] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmInformacionConvenioCaja] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmInformacionConvenioCaja] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmInformacionConvenioCaja] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmInformacionConvenioCaja] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmInformacionConvenioCaja] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmInformacionConvenioCaja] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmInformacionConvenioCaja] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmInformacionConvenioCaja] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmInformacionConvenioCaja] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

