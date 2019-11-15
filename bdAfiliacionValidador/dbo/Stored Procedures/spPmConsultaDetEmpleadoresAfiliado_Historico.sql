CREATE	procedure [dbo].[spPmConsultaDetEmpleadoresAfiliado_Historico]
@cnsctvo_cdgo_tpo_cntrto	UdtConsecutivo			= NULL, 
@nmro_cntrto				UdtNumeroFormulario		= NULL,
@fcha_Vldcn					datetime,
@cnsctvo_cdgo_pln   		UdtConsecutivo			= NULL,	--Para buscar estados de Famisanar
@cnsctvo_tpo_idntfccn		UdtConsecutivo			= NULL,	--Para buscar estados de Famisanar
@nmro_idntfccn   			UdtNumeroIdentificacion	= NULL, --Para buscar estados de Famisanar
@cdgo_eapb					char(1)					= NULL,	--Para buscar estados de Famisanar
@cnsctvo_cdgo_tpo_frmlro	UdtConsecutivo			= NULL,	-- Para Buscar Estados de Formularios
@nmro_frmlro				UdtNumeroFormulario		= NULL	-- Para Buscar Estados de Formularios

AS
Set NoCount On

/*
declare
@cnsctvo_cdgo_tpo_cntrto	UdtConsecutivo , 
@nmro_cntrto			UdtNumeroFormulario,
@fcha_Vldcn			datetime,
@cnsctvo_cdgo_pln   		UdtConsecutivo,		--Para buscar estados de Famisanar
@cnsctvo_tpo_idntfccn       	UdtConsecutivo,		--Para buscar estados de Famisanar
@nmro_idntfccn   		UdtNumeroIdentificacion, --Para buscar estados de Famisanar
@cdgo_eapb			char(1), 		 --Para buscar estados de Famisanar
@cnsctvo_cdgo_tpo_frmlro	UdtConsecutivo,		-- Para Buscar Estados de Formularios
@nmro_frmlro			UdtNumeroFormulario	-- Para Buscar Estados de Formularios

Set	@cnsctvo_cdgo_tpo_cntrto	= 1
Set	@nmro_cntrto				= 181930
Set	@fcha_Vldcn					= '20040504'
Set	@cnsctvo_cdgo_pln			= 1
Set	@cnsctvo_tpo_idntfccn		= 1
Set	@nmro_idntfccn			= '94384956'--'29359367'
Set	@cdgo_eapb				= null
Set	@cnsctvo_cdgo_tpo_frmlro	= null --1
Set	@nmro_frmlro			= null --'0067115'        
*/


-- Declaración y definición de constantes

-- Declaración de variables


-- Programa
IF @nmro_cntrto  IS NOT NULL
	Begin
		Declare	@empleadores table
			(
				cnsctvo_hstrco_estdo		int,
				idntfccn_cmplta_empldr		varchar(30),
				rzn_scl						varchar(200),
				nmro_idntfccn				varchar(23),
				cnsctvo_cdgo_tpo_idntfccn	int,
				nmro_unco_idntfccn_aprtnte	int,
				cdgo_tpo_idntfccn			varchar(3),
				prncpl 						char,
				cnsctvo_scrsl_ctznte		int,
				cnsctvo_cdgo_crgo_empldo	int,
				cnsctvo_cdgo_clse_aprtnte	int,
				cnsctvo_cdgo_tpo_ctznte		int,
				inco_vgnca_cbrnza			datetime,
				fn_vgnca_cbrnza				datetime,
				cnsctvo_cdgo_tpo_cbrnza		int,
				cnsctvo_cbrnza				int,
				slro_bsco					int,
				cnsctvo_cdgo_tpo_cntrto		int,
				nmro_cntrto					varchar(15),
				cnsctvo_prdcto_scrsl		int,
				cnsctvo_scrsl				int,
				cnsctvo_cdgo_actvdd_ecnmca	int,
				cnsctvo_cdgo_arp			int,
				drccn						varchar(80),
				tlfno						varchar(30),
				cdgo_actvdd_ecnmca			char(4),
				dscrpcn_actvdd_ecnmca		varchar(150),
				cdgo_crgo					char(4),
				dscrpcn_crgo				varchar(150),
				cdgo_entdd					char(8),
				dscrpcn_entdd				varchar(150),
				cdgo_tpo_ctznte				char(2),
				dscrpcn_tpo_ctznte			varchar(150),
				nmbre_cntcto				varchar(140),
				tlfno_cntcto				udtTelefono,
				eml_cntcto					udtEmail,
				cnsctvo_cdgo_cdd			udtconsecutivo,
				cdgo_cdd					char(8),
				dscrpcn_cdd					udtDescripcion,
				cnsctvo_cdgo_dprtmnto		udtConsecutivo,
				cdgo_dprtmnto				char(3),
				dscrpcn_dprtmnto			udtDescripcion,
				eml							udtEmail,
				cdgo_cnvno_cmrcl			char(2),
				dscrpcn_cnvno_cmrcl			varchar(150)
			)

		Create Table	#tmpHistoricoCobranzasValidador
			(	
				cnsctvo_hstrco_estdo	Int,
				cnsctvo_cdgo_tpo_cntrto	Int,
				nmro_cntrto				VarChar(15),
				cnsctvo_cbrnza			Int,
				dscrpcn_cmpo			Varchar(150),
				vlr_cmpo				Varchar(150),
				inco_vgnca				DateTime,
				fn_vgnca				DateTime
			)

		Create Table	#tmpHistoricoAportanteValidador
			(
				nmro_unco_idntfccn_aprtnte	Int,
				cnsctvo_cdgo_clse_aprtnte	Int,
				dscrpcn_cmpo				Varchar(150),
				vlr_cmpo					Varchar(150)
			)

		Declare	@cdna_vrble_hstrco_cbrnza	VarChar(250),
				@cdna_vrble_hstrco_aprtnte	VarChar(250)
		Set		@cdna_vrble_hstrco_cbrnza	=	char(39)+'prncpl'+char(39)+','+char(39)+'cnsctvo_cdgo_tpo_ctznte'+char(39)
		Set		@cdna_vrble_hstrco_aprtnte	=	char(39)+'rzn_scl'+char(39)+','+char(39)+'nmro_idntfccn_empldr'+char(39)+','+char(39)+'cnsctvo_cdgo_tpo_idntfccn_empldr'+char(39)

		Insert Into @empleadores
				(	nmro_unco_idntfccn_aprtnte,				prncpl,						cnsctvo_scrsl_ctznte,				cnsctvo_cdgo_crgo_empldo,
					cnsctvo_cdgo_tpo_ctznte,				inco_vgnca_cbrnza,			fn_vgnca_cbrnza,					cnsctvo_cdgo_tpo_cbrnza,
					cnsctvo_cbrnza,							slro_bsco,					cnsctvo_cdgo_tpo_cntrto,			nmro_cntrto,
					cnsctvo_prdcto_scrsl,					cnsctvo_cdgo_clse_aprtnte
				)
		select		a.nmro_unco_idntfccn_aprtnte,			a.prncpl,					a.cnsctvo_scrsl_ctznte,				a.cnsctvo_cdgo_crgo_empldo,
					a.cnsctvo_cdgo_tpo_ctznte,				a.inco_vgnca_cbrnza,		a.fn_vgnca_cbrnza,					a.cnsctvo_cdgo_tpo_cbrnza,
					a.cnsctvo_cbrnza,						a.ingrso_bse,				a.cnsctvo_cdgo_tpo_cntrto,			a.nmro_cntrto,
					a.cnsctvo_prdcto_scrsl,					a.cnsctvo_cdgo_clse_aprtnte
		from		tbcobranzasValidador a	With(NoLock)
		where		a.cnsctvo_cdgo_tpo_cntrto	=	@cnsctvo_cdgo_tpo_cntrto
		and			a.nmro_cntrto				=	@nmro_cntrto         
		and			a.cnsctvo_cdgo_tpo_cbrnza	<>	4 -- esta linea me controla la no inclusion de adic pues ellos no son empleadores modif 18-12-2003
		And			a.estdo						=	'S'  --Cobranza Valida

		Insert Into	#tmpHistoricoCobranzasValidador
		Select		cnsctvo_hstrco_estdo,	cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,		cnsctvo_cbrnza,		dscrpcn_cmpo,
					vlr_cmpo,				inco_vgnca,					fn_vgnca
		From		BDAfiliacionValidador.dbo.tbHistoricoCobranzasValidador	With(NoLock)
		where		cnsctvo_cdgo_tpo_cntrto	=	@cnsctvo_cdgo_tpo_cntrto
		and			nmro_cntrto				=	@nmro_cntrto
		And			@fcha_Vldcn between inco_vgnca and fn_vgnca
		And			dscrpcn_cmpo	In	(@cdna_vrble_hstrco_cbrnza)

		Insert Into	#tmpHistoricoAportanteValidador
		Select		h.nmro_unco_idntfccn_aprtnte,		h.cnsctvo_cdgo_clse_aprtnte,	h.dscrpcn_cmpo,		h.vlr_cmpo
		From		BDAfiliacionValidador.dbo.tbHistoricoAportanteValidador	h	With(NoLock)
		Inner Join	@empleadores											e	On	e.nmro_unco_idntfccn_aprtnte	=	h.nmro_unco_idntfccn_aprtnte
																				And	e.cnsctvo_cdgo_clse_aprtnte		=	h.cnsctvo_cdgo_clse_aprtnte
		Where		h.dscrpcn_cmpo	In	(@cdna_vrble_hstrco_aprtnte)

		Declare		@f	datetime,
					@f1 datetime

		if Exists	(	Select 1
						From	@empleadores
						Where	@fcha_Vldcn Between inco_vgnca_cbrnza And fn_vgnca_cbrnza
					)
			Begin
				Delete	@empleadores
				Where	fn_vgnca_cbrnza	< @fcha_Vldcn

				Delete	@empleadores
				Where	inco_vgnca_cbrnza > @fcha_Vldcn
			End
		Else if Exists	(	Select 1
							From	@empleadores
							Where	fn_vgnca_cbrnza < @fcha_Vldcn
						)
			Begin
				Select	@f = Max(fn_vgnca_cbrnza)
				from	@empleadores a
				Where	fn_vgnca_cbrnza < @fcha_Vldcn

				--verificar cobranzas futuras (sisatv01) definición dada por Alfonso Gironza 2011/01/07
				select	@f1 = max(fn_vgnca_cbrnza)
				from	@empleadores 

				if @f1 > @f --cobranza futura
					begin
						set @f = @f1
					end			
		
				Delete	@empleadores
				Where	fn_vgnca_cbrnza <> @f
			End
		Else 
			Begin
				Select	@f = Max(fn_vgnca_cbrnza)
				from	@empleadores a

				Delete	@empleadores
				Where	fn_vgnca_cbrnza <> @f
			End

		Update		@empleadores
		Set			prncpl		= rtrim(ltrim(h.vlr_cmpo))
		From		@empleadores					e
		Inner Join	#tmpHistoricoCobranzasValidador h	With(NoLock)	On	h.cnsctvo_hstrco_estdo		= e.cnsctvo_hstrco_estdo
																		And	h.cnsctvo_cdgo_tpo_cntrto	= e.cnsctvo_cdgo_tpo_cntrto
																		And	h.nmro_cntrto				= e.nmro_cntrto
																		And	h.cnsctvo_cbrnza			= e.cnsctvo_cbrnza
		Where		h.dscrpcn_cmpo			= 'prncpl'

		Update		@empleadores
		Set			cnsctvo_cdgo_tpo_ctznte		= rtrim(ltrim(h.vlr_cmpo))
		From		@empleadores e
		Inner Join	#tmpHistoricoCobranzasValidador h	With(NoLock)	On	h.cnsctvo_hstrco_estdo		= e.cnsctvo_hstrco_estdo
																		And	h.cnsctvo_cdgo_tpo_cntrto	= e.cnsctvo_cdgo_tpo_cntrto
																		And	h.nmro_cntrto				= e.nmro_cntrto
																		And	h.cnsctvo_cbrnza			= e.cnsctvo_cbrnza
		Where		h.dscrpcn_cmpo			= 'cnsctvo_cdgo_tpo_ctznte'

		Update		@empleadores
		Set			cnsctvo_cdgo_clse_aprtnte	= a.cnsctvo_cdgo_clse_aprtnte,
					rzn_scl						= a.rzn_scl,
					nmro_idntfccn				= a.nmro_idntfccn_empldr,
					cnsctvo_cdgo_tpo_idntfccn	= a.cnsctvo_cdgo_tpo_idntfccn_empldr
		From		@empleadores									e
		Inner Join	BDAfiliacionValidador.dbo.tbAportanteValidador	a	With(NoLock)	On	a.nmro_unco_idntfccn_aprtnte	=	e.nmro_unco_idntfccn_aprtnte
																						And	a.cnsctvo_cdgo_clse_aprtnte		=	e.cnsctvo_cdgo_clse_aprtnte

		Update		@empleadores
		Set			rzn_scl				= rtrim(ltrim(h.vlr_cmpo))
		From		@empleadores					e
		Inner Join	#tmpHistoricoAportanteValidador	h	With(NoLock)	On	h.nmro_unco_idntfccn_aprtnte	=	e.nmro_unco_idntfccn_aprtnte
																		And	h.cnsctvo_cdgo_clse_aprtnte		=	e.cnsctvo_cdgo_clse_aprtnte
		Where		h.dscrpcn_cmpo			= 'rzn_scl'

		Update		@empleadores
		Set			nmro_idntfccn			= rtrim(ltrim(h.vlr_cmpo))
		From		@empleadores					e
		Inner Join	#tmpHistoricoAportanteValidador	h	With(NoLock)	On	h.nmro_unco_idntfccn_aprtnte	=	e.nmro_unco_idntfccn_aprtnte
																		And	h.cnsctvo_cdgo_clse_aprtnte		=	e.cnsctvo_cdgo_clse_aprtnte
		Where		h.dscrpcn_cmpo			= 'nmro_idntfccn_empldr'

		Update		@empleadores
		Set			cnsctvo_cdgo_tpo_idntfccn	= rtrim(ltrim(h.vlr_cmpo))
		From		@empleadores					e
		Inner Join	#tmpHistoricoAportanteValidador	h	With(NoLock)	On	h.nmro_unco_idntfccn_aprtnte	=	e.nmro_unco_idntfccn_aprtnte
																		And	h.cnsctvo_cdgo_clse_aprtnte		=	e.cnsctvo_cdgo_clse_aprtnte
		Where		h.dscrpcn_cmpo			= 'cnsctvo_cdgo_tpo_idntfccn_empldr'

		--2011-029-026751 
		Update	@empleadores
		Set		cnsctvo_scrsl				= s.cnsctvo_scrsl,
				cnsctvo_cdgo_actvdd_ecnmca	= s.cnsctvo_cdgo_actvdd_ecnmca,
				cnsctvo_cdgo_arp			= s.cnsctvo_cdgo_arp,
				drccn						= s.drccn,
				tlfno						= s.tlfno,	
				cnsctvo_cdgo_cdd			= s.cnsctvo_cdgo_cdd,	
				eml							= s.eml,
				rzn_scl						=	Case	when	s.nmbre_scrsl is not null and ltrim(rtrim(s.nmbre_scrsl)) != ''	then ltrim(rtrim(s.nmbre_scrsl))
														Else	e.rzn_scl
												End
		From		@empleadores									e
		Inner Join	BDAfiliacionValidador.dbo.tbSucursalesAportante	s	With(NoLock)	On	e.cnsctvo_scrsl_ctznte			=  s.cnsctvo_scrsl
																						and	e.nmro_unco_idntfccn_aprtnte	=  s.nmro_unco_idntfccn_empldr
																						and	e.cnsctvo_cdgo_clse_aprtnte		=  s.cnsctvo_cdgo_clse_aprtnte

		update		@empleadores
		set			cdgo_cdd				= b.cdgo_cdd,
					dscrpcn_cdd				= b.dscrpcn_cdd,
					cnsctvo_cdgo_dprtmnto	= c.cnsctvo_cdgo_dprtmnto,
					cdgo_dprtmnto			= c.cdgo_dprtmnto,
					dscrpcn_dprtmnto		= c.dscrpcn_dprtmnto
		from		@empleadores									a
		inner join	BDAfiliacionValidador.dbo.tbCiudades_vigencias	b	With(NoLock)	on	a.cnsctvo_cdgo_cdd		=	b.cnsctvo_cdgo_cdd
		inner join	BDAfiliacionValidador.dbo.tbDepartamentos		c	With(NoLock)	on	b.cnsctvo_cdgo_dprtmnto =	c.cnsctvo_cdgo_dprtmnto

		Drop Table	#tmpHistoricoCobranzasValidador
		Drop Table	#tmpHistoricoAportanteValidador
	End
Else
	IF @nmro_frmlro  IS NOT NULL
		Begin
			-- busco en Formularios
			insert	@empleadores
				(	nmro_unco_idntfccn_aprtnte,				prncpl,					cnsctvo_scrsl_ctznte,				cnsctvo_cdgo_crgo_empldo,
					cnsctvo_cdgo_tpo_ctznte,				inco_vgnca_cbrnza,		fn_vgnca_cbrnza,					cnsctvo_cdgo_tpo_cbrnza,
					cnsctvo_cbrnza,							slro_bsco,				cnsctvo_prdcto_scrsl,				cnsctvo_cdgo_clse_aprtnte,
					cnsctvo_cdgo_tpo_idntfccn,				nmro_idntfccn,			rzn_scl
				)
			select	nmro_unco_idntfccn_aprtnte,				'S',					1,									0,
					0,										inco_vgnca_bnfcro,		fn_vgnca_bnfcro,					0,
					0,										0,						0,									cnsctvo_cdgo_clse_aprtnte,
					cnsctvo_cdgo_tpo_idntfccn_aprtnte,		nmro_idntfccn_aprtnte,	rzn_scl
			from  	BDAfiliacionValidador.dbo.tbBeneficiariosFormularioValidador	a	With(NoLock)
			Where	a.cnsctvo_tpo_idntfccn_bnfcro 	=  @cnsctvo_tpo_idntfccn
			And		a.nmro_idntfccn_bnfcro   		=  @nmro_idntfccn
			And		a.cnsctvo_cdgo_pln   			=  @cnsctvo_cdgo_pln
			And		convert(char(10), @fcha_Vldcn ,111) between  convert(char(10), a.fcha_dsde  ,111) and  convert(char(10), a.fcha_hsta ,111)
			And		a.cnsctvo_cdgo_tpo_frmlro 		= @cnsctvo_cdgo_tpo_frmlro
			And		a.nmro_frmlro					= @nmro_frmlro
		End
	Else
		IF @cdgo_eapb  IS NOT NULL
			Begin
				insert	@empleadores
						(	nmro_unco_idntfccn_aprtnte,					prncpl,						cnsctvo_scrsl_ctznte,				cnsctvo_cdgo_crgo_empldo,
							cnsctvo_cdgo_tpo_ctznte,					inco_vgnca_cbrnza,			fn_vgnca_cbrnza,					cnsctvo_cdgo_tpo_cbrnza,
							cnsctvo_cbrnza,								slro_bsco,					cnsctvo_prdcto_scrsl,				cnsctvo_cdgo_clse_aprtnte,
							cnsctvo_cdgo_tpo_idntfccn,					nmro_idntfccn,				rzn_scl
						)
				select 		c.nmro_unco_idntfccn_aprtnte,				'S',						0,									0,
							0,											inco_vgnca,					fn_vgnca,							0,
							0,											0,							0,									0,
							cnsctvo_cdgo_tpo_idntfccn_emprsa,			nmro_idntfccn_emprsa,		emprsa
				from 		BDAfiliacionValidador.dbo.tbEapb				a	With(NoLock)
				Inner Join	BDAfiliacionValidador.dbo.tbAportanteValidador	c	With(NoLock)	On	a.cnsctvo_cdgo_tpo_idntfccn_emprsa		=	c.cnsctvo_cdgo_tpo_idntfccn_empldr
																								and ltrim(rtrim(a.nmro_idntfccn_emprsa))	=	c.nmro_idntfccn_empldr COLLATE SQL_Latin1_General_CP1_CI_AS
				Where 		a.cnsctvo_cdgo_tpo_idntfccn_bnfcro	= 	@cnsctvo_tpo_idntfccn
				and 		a.nmro_idntfccn_bnfcro				= 	@nmro_idntfccn
				and 		a.cdgo_eapb							= 	@cdgo_eapb
				and 		a.cnsctvo_cdgo_pln					= 	@cnsctvo_cdgo_pln
				and 		@fcha_Vldcn between a.fcha_dsde	and a.fcha_hsta
			End

Update		@empleadores
Set			cdgo_tpo_idntfccn	= ti.cdgo_tpo_idntfccn,
			idntfccn_cmplta_empldr		= (rtrim(ltrim(ti.cdgo_tpo_idntfccn)) + ' - ' + ltrim(rtrim(e.nmro_idntfccn)))
From		@empleadores									e
Inner Join	BDAfiliacionValidador.dbo.tbTiposIdentificacion	ti	With(NoLock)	On	e.cnsctvo_cdgo_tpo_idntfccn	=  ti.cnsctvo_cdgo_tpo_idntfccn

Update		@empleadores
Set			cdgo_actvdd_ecnmca	= a.cdgo_actvdd_ecnmca,
			dscrpcn_actvdd_ecnmca	= a.dscrpcn_actvdd_ecnmca
From		@empleadores										e
Inner Join	BDAfiliacionValidador.dbo.tbActividadesEconomicas	a	With(NoLock)	On	e.cnsctvo_cdgo_actvdd_ecnmca  = a.cnsctvo_cdgo_actvdd_ecnmca

Update		@empleadores
Set			cdgo_crgo	= c.cdgo_crgo,
			dscrpcn_crgo	= c.dscrpcn_crgo
From		@empleadores						e
Inner Join	BDAfiliacionValidador.dbo.tbcargos	c	With(NoLock)	On	e.cnsctvo_cdgo_crgo_empldo  = c.cnsctvo_cdgo_crgo

Update		@empleadores
Set			cdgo_entdd	= en.cdgo_entdd,
			dscrpcn_entdd	= en.dscrpcn_entdd
From		@empleadores							e
Inner Join	BDAfiliacionValidador.dbo.tbEntidades	en	With(NoLock)	On	e.cnsctvo_cdgo_arp  = en.cnsctvo_cdgo_entdd

Update		@empleadores
Set			cdgo_tpo_ctznte		= c.cdgo_tpo_ctznte,
			dscrpcn_tpo_ctznte	= c.dscrpcn_tpo_ctznte
From		@empleadores								e
Inner Join	BDAfiliacionValidador.dbo.tbTiposCotizante	c	With(NoLock)	On	e.cnsctvo_cdgo_tpo_ctznte = c.cnsctvo_cdgo_tpo_ctznte

update		@empleadores
set			nmbre_cntcto = ltrim(rtrim(b.prmr_aplldo))+' '+ltrim(rtrim(b.sgndo_aplldo))+' '+ltrim(rtrim(b.prmr_nmbre))+' '+ltrim(rtrim(b.sgndo_nmbre)),
			tlfno_cntcto = b.tlfno,
			eml_cntcto = b.eml
from		@empleadores				a
inner join	tbContactosEmpresariales	b	With(NoLock)	on	a.nmro_unco_idntfccn_aprtnte	=	b.nmro_unco_idntfccn_empldr
															and a.cnsctvo_scrsl_ctznte			=	b.cnsctvo_scrsl
															and a.cnsctvo_cdgo_clse_aprtnte		=	b.cnsctvo_cdgo_clse_aprtnte
where		@fcha_Vldcn between inco_vgnca and fn_vgnca
and			b.cnsctvo_cdgo_tpo_cncto_emprsrl = 1

--print 'Ingreso por Historico'
Select distinct	cdgo_tpo_idntfccn,				nmro_idntfccn,				rzn_scl,				idntfccn_cmplta_empldr,				cnsctvo_cdgo_tpo_idntfccn,
				nmro_unco_idntfccn_aprtnte,		prncpl,						cnsctvo_scrsl_ctznte,	cnsctvo_cdgo_crgo_empldo,			cnsctvo_cdgo_clse_aprtnte,
				cnsctvo_cdgo_tpo_ctznte,		inco_vgnca_cbrnza,			fn_vgnca_cbrnza,		cnsctvo_cdgo_tpo_cbrnza,			cnsctvo_cbrnza,
				slro_bsco,						cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,			cnsctvo_prdcto_scrsl,				cnsctvo_scrsl,
				cnsctvo_cdgo_actvdd_ecnmca,		cnsctvo_cdgo_arp,			drccn,					tlfno,								cdgo_actvdd_ecnmca,
				dscrpcn_actvdd_ecnmca,			cdgo_crgo,					dscrpcn_crgo,			cdgo_entdd,							dscrpcn_entdd,
				cdgo_tpo_ctznte,				dscrpcn_tpo_ctznte,			nmbre_cntcto,			tlfno_cntcto,						eml_cntcto,
				cnsctvo_cdgo_cdd,				cdgo_cdd,					dscrpcn_cdd,			cnsctvo_cdgo_dprtmnto,				cdgo_dprtmnto,
				dscrpcn_dprtmnto,				eml,						space(2) as cdgo_cnvno_cmrcl,
				space(150) as dscrpcn_cnvno_cmrcl
From			@empleadores
order by		prncpl desc


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado_Historico] TO [340010 Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado_Historico] TO [vafss_role]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado_Historico] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado_Historico] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado_Historico] TO [outbts01]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado_Historico] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado_Historico] TO [proceso3047_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado_Historico] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado_Historico] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado_Historico] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado_Historico] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado_Historico] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado_Historico] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado_Historico] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado_Historico] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado_Historico] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado_Historico] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado_Historico] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado_Historico] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado_Historico] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado_Historico] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado_Historico] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado_Historico] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetEmpleadoresAfiliado_Historico] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

