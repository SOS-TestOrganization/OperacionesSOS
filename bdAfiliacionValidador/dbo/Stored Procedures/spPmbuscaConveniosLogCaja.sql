CREATE PROCEDURE [dbo].[spPmbuscaConveniosLogCaja]
@cnsctvo_cdgo_ofcna UdtConsecutivo,
@nmro_vrfccn 		numeric

AS
set nocount on

Begin
	Create Table	#tmpCapitacionLog
			(	dscrpcn_cnvno			UdtDescripcion null, 
				cdgo_cnvno				numeric null, 
				estado					varchar(20) not null, 
				capitado				UdtLogico not null, 
				fcha_crte				datetime null, 
				da_crte					int null, 
				fcha_dsde				datetime null, 
   				fcha_hsta				datetime null, 
   				cdgo_mdlo_extrccn		decimal null, 
   				cdgo_cdd				char(8)  COLLATE SQL_Latin1_General_CP1_CI_AS null,
   				cnsctvo_cdgo_ips_cptcn	UdtConsecutivo  NULL , 
   				dscrpcn_cdd				UdtDescripcion null, 
				dscrpcn_ips				UdtDescripcion null,
				cnsctvo_cdgo_cdd		UdtConsecutivo null
			)

	Declare	@srvdr	Varchar(50)
	Set		@srvdr	=	ltrim(rtrim(CONVERT(varchar(30), SERVERPROPERTY('machinename'))))

	If Exists	(	Select 1
					From	BDAfiliacionValidador.dbo.tbtablaParametros	With(NoLock)
					Where	vlr_prmtro	=	@srvdr
				)

		Begin
			insert into	#tmpCapitacionLog
					(	dscrpcn_cnvno,							cdgo_cnvno,				estado,
						capitado,								cnsctvo_cdgo_ips_cptcn
					)
			Select 		ISNULL(b.dscrpcn_mdlo_cnvno_cptcn,''),	a.cnsctvo_cdgo_cnvno,	CASE	a.estdo_cptcn	WHEN 'S'	THEN 'CAPITA'
																															ELSE 'NO CAPITA'
																												END,
						a.estdo_cptcn,							IsNull(a.cnsctvo_cdgo_ips_cptcn,0)
			from 		bdIPSIntegracion.dbo.tbConveniosLog						a	With(NoLock)
			Inner Join	BDAfiliacionValidador.dbo.tbModeloConveniosCapitacion	b	With(NoLock)	On	b.cdgo_mdlo_cnvno_cptcn	=	a.cnsctvo_cdgo_cnvno
			Inner Join	bdIPSIntegracion.dbo.tbLog								c	With(NoLock)	On	c.cnsctvo_cdgo_ofcna	=	a.cnsctvo_cdgo_ofcna
																									And	c.nmro_vrfccn			=	a.nmro_vrfccn
			where 		a.cnsctvo_cdgo_ofcna	= @cnsctvo_cdgo_ofcna
			and			a.nmro_vrfccn			= @nmro_vrfccn

			IF @@ROWCOUNT = 0
				Begin 
					insert into #tmpCapitacionLog
							(	estado,		capitado,	dscrpcn_ips	)
					values	(  'NO CAPITA', 'N',		''			)
				End
			ELSE

			UPDATE 		#tmpCapitacionLog 
			SET 		cdgo_cdd			= b.cdgo_cdd,
						dscrpcn_cdd			= b.dscrpcn_cdd,
						dscrpcn_ips			= ISNULL(a.nmbre_scrsl,''),
						cnsctvo_cdgo_cdd	= b.cnsctvo_cdgo_cdd
			FROM 		#tmpCapitacionLog									c	With(NoLock)
			Inner Join	BDAfiliacionValidador.dbo.tbIPSPrimarias_vigencias	a	With(NoLock)	On	a.cdgo_intrno		=	c.cnsctvo_cdgo_ips_cptcn
			Inner Join	BDAfiliacionValidador.dbo.tbCiudades				b	With(NoLock)	On	b.cnsctvo_cdgo_cdd	=	a.cnsctvo_cdgo_cdd
		End
	Else
		Begin
			insert into #tmpCapitacionLog
					(	dscrpcn_cnvno,							cdgo_cnvno,				estado,
						capitado,								cnsctvo_cdgo_ips_cptcn
					)
			Select 		ISNULL(b.dscrpcn_mdlo_cnvno_cptcn,''),	a.cnsctvo_cdgo_cnvno,	CASE a.estdo_cptcn	WHEN 'S'	THEN 'CAPITA'
																											ELSE 'NO CAPITA'
																						END,
						a.estdo_cptcn,							IsNull(a.cnsctvo_cdgo_ips_cptcn,0)
			from 		bdSisalud.dbo.tbConveniosLog							a
			Inner Join	BDAfiliacionValidador.dbo.tbModeloConveniosCapitacion	b	On	b.cdgo_mdlo_cnvno_cptcn	=	a.cnsctvo_cdgo_cnvno
			Inner Join	bdSisalud.dbo.tbLog										c	On	c.cnsctvo_cdgo_ofcna	=	a.cnsctvo_cdgo_ofcna
																					And	c.nmro_vrfccn			=	a.nmro_vrfccn
			where 		a.cnsctvo_cdgo_ofcna	= @cnsctvo_cdgo_ofcna
			and			a.nmro_vrfccn			= @nmro_vrfccn


			IF @@ROWCOUNT = 0
				Begin 
					insert into #tmpCapitacionLog
							(	estado,		capitado,	dscrpcn_ips	)
					Values	(  'NO CAPITA', 'N',		''			)
				End
			ELSE
				UPDATE 		#tmpCapitacionLog 
				SET 		cdgo_cdd			= b.cdgo_cdd,
							dscrpcn_cdd			= b.dscrpcn_cdd,
							dscrpcn_ips			= ISNULL(a.nmbre_scrsl,''),
							cnsctvo_cdgo_cdd	= b.cnsctvo_cdgo_cdd
				FROM 		#tmpCapitacionLog									c
				Inner Join	BDAfiliacionValidador.dbo.tbIPSPrimarias_vigencias	a	On	a.cdgo_intrno		= c.cnsctvo_cdgo_ips_cptcn
				Inner Join	BDAfiliacionValidador.dbo.tbCiudades				b	On	a.cnsctvo_cdgo_cdd	= b.cnsctvo_cdgo_cdd
		End

	SELECT	dscrpcn_cnvno,			estado,				cdgo_cnvno,					capitado,				fcha_crte,
			cdgo_cdd,				dscrpcn_cdd,		cnsctvo_cdgo_ips_cptcn,		dscrpcn_ips,			cnsctvo_cdgo_cdd
	FROM	#tmpCapitacionLog With(NoLock)

	Drop Table	#tmpCapitacionLog
End


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmbuscaConveniosLogCaja] TO PUBLIC
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmbuscaConveniosLogCaja] TO [310010 Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmbuscaConveniosLogCaja] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmbuscaConveniosLogCaja] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmbuscaConveniosLogCaja] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmbuscaConveniosLogCaja] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmbuscaConveniosLogCaja] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmbuscaConveniosLogCaja] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmbuscaConveniosLogCaja] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmbuscaConveniosLogCaja] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmbuscaConveniosLogCaja] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmbuscaConveniosLogCaja] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

