CREATE procedure  [dbo].[spPmValidaItemCapitados]
@nui						UdtConsecutivo,  
@cnsctvo_cdgo_tpo_cntrto	UdtConsecutivo,   
@fcha_vldccn				datetime  

AS
Set NoCount On

-- Declaración y definición de constantes  
-- Declaración de variables  
Declare			@cdgo_escnro		UdtCodigo,
				@cnsctvo_cndcn		int,  
				@abrr				char(10),  
				@nmbre_cmpo			char(30),  
				@tpo_oprdr			char(2),  
				@vlrs_cndcn			varchar(100),  
				@crr				char(10),  
				@cnctndr			char(3),  
				@cdgo_itm_cptcn		char(3),  
				@Condiciones		varchar(1000),  
				@Query				nvarchar(1000),  
				@cdgo_escnro_cptcn	UdtCodigo,
				@hst_nme            Varchar(50)
  
-- Programa  
Select		@hst_nme = Ltrim(Rtrim(Convert(Varchar(30), SERVERPROPERTY('machinename'))))

CREATE TABLE #tmpMatriz
	(	nmro_unco_idntfccn			int,
		cnsctvo_cdgo_tpo_cntrto		int,
		fcha_dsde					datetime,
		fcha_hsta					datetime,
		cdgo_tpo_idntfccn_empldr	char(3),
		nmro_idntfccn_empldr		varchar(23),
		cdgo_pln_cmplmntro			char(2),
		cdgo_sde					char(3),
		cdgo_cdd					char(8),
		estdo						char(2),
		cdgo_tpo_afldo				char(2),
		mdco						char(1),
		odntlgo						char(1),
		cdgo_tpo_cntrto				char(2),
		cdgo_ips					char(8),
		cdgo_brro					char(10),
		fcha_mdfccn					datetime
	)

Create Clustered Index [idx_actuario]
On	#tmpMatriz ([nmro_unco_idntfccn], [cnsctvo_cdgo_tpo_cntrto], [fcha_dsde])

Create Table	#tmpServiciosCapitados
(
	nmro_unco_idntfccn			int
)
  
insert into #tmpCondicion
		(	cdgo_tpo_escnro,		cdgo_itm_cptcn,			cndcn,				accion,		cdgo_cnvno
		)
Select		e.cdgo_tpo_escnro,		e.cdgo_itm_cptcn,		e.instrccn_whre,	'',			t.cdgo_cnvno  
From		bdAfiliacionValidador.dbo.tbEscenarios_procesoValidador	e	With(NoLock)
Inner Join	#tmpCapitacionContrato									t	With(NoLock)	On	t.cdgo_cnvno		=	e.cdgo_cnvno
																						And	t.cnsctvo_cdgo_cdd	=	e.cnsctvo_cdgo_cdd
where		@fcha_vldccn   between fcha_dsde and fcha_hsta  

If Exists	(	Select	1
				From	bdAfiliacionValidador.dbo.tbtablaParametros  With(NoLock)
				Where	vlr_prmtro	= @hst_nme
			)
	Begin
		update		#tmpCondicion   
		set			accion = 'Capitacion'   
		from		bdAfiliacionValidador.dbo.tbItemCapitacion_Vigencias	a	With(NoLock)
		Inner Join	#tmpCondicion											b	On	b.cdgo_itm_cptcn   = a.cdgo_itm_cptcn
		where		getdate() between inco_vgnca And fn_vgnca   
	End
Else
	Begin
		update		#tmpCondicion
		set			accion = 'Capitacion'
		from		bdSiSalud.dbo.tbItemCapitacion_Vigencias	a	With(NoLock)
		Inner Join	#tmpCondicion								b	On	b.cdgo_itm_cptcn   = a.cdgo_itm_cptcn
		Where		getdate() between inco_vgnca And fn_vgnca
	End  

Insert Into	#tmpMatriz
Select		nmro_unco_idntfccn,					cnsctvo_cdgo_tpo_cntrto,				fcha_dsde,				fcha_hsta,				cdgo_tpo_idntfccn_empldr,
			nmro_idntfccn_empldr,				cdgo_pln_cmplmntro,						cdgo_sde,				cdgo_cdd,				estdo,
			cdgo_tpo_afldo,						mdco,									odntlgo,				cdgo_tpo_cntrto,		cdgo_ips,
			cdgo_brro,							fcha_mdfccn
From		bdAfiliacionValidador.dbo.tbActuarioCapitacionValidador	With(NoLock)
Where		nmro_unco_idntfccn		= @nui
And			cnsctvo_cdgo_tpo_cntrto	= @cnsctvo_cdgo_tpo_cntrto
And			getdate() between fcha_dsde and fcha_hsta
  
DECLARE		crCapitados CURSOR FOR
SELECT		cdgo_tpo_escnro,	cdgo_itm_cptcn,	cndcn
FROM		#tmpCondicion	With(NoLock)
  
OPEN crCapitados
FETCH NEXT FROM crCapitados into @cdgo_escnro, @cdgo_itm_cptcn, @Condiciones
  
WHILE @@FETCH_STATUS = 0  
	begin  
		if ltrim(rtrim(@condiciones)) != ''  
			Begin    
				set @query = 'Insert Into #tmpServiciosCapitados Select nmro_unco_idntfccn From #tmpMatriz Where ' + ltrim(rtrim(@condiciones))
				exec sp_executesql @query
  
				if @@rowcount > 0
				   update	#tmpCondicion
				   set		accion			= 'Capitacion'
				   where	cdgo_itm_cptcn	=	@cdgo_itm_cptcn
				else
				   update	#tmpCondicion
				   set		accion			= 'Actividad'
				   where	cdgo_itm_cptcn	= @cdgo_itm_cptcn
			End
		Else
			Begin
				update	#tmpCondicion
				set		accion			= 'Capitacion'
				where	cdgo_itm_cptcn	= @cdgo_itm_cptcn
		   End
  
		FETCH NEXT FROM crCapitados into @cdgo_escnro, @cdgo_itm_cptcn, @Condiciones
	end
  
deallocate crCapitados

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaItemCapitados] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaItemCapitados] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaItemCapitados] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaItemCapitados] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaItemCapitados] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaItemCapitados] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaItemCapitados] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaItemCapitados] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaItemCapitados] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaItemCapitados] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaItemCapitados] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaItemCapitados] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaItemCapitados] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaItemCapitados] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaItemCapitados] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaItemCapitados] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaItemCapitados] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaItemCapitados] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaItemCapitados] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

