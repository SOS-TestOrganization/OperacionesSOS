CREATE   Function [dbo].[fnPmConsultaDetConveniosCapitacionAfiliadoValidacion]
(
	@cnsctvo_cdgo_tpo_cntrto	UdtConsecutivo, 
	@nui_afldo					UdtConsecutivo,
	@fcha_vldcn					datetime
)
Returns  @tmpCapitacionContrato table
	(
		dscrpcn_cnvno					varchar(150)	null, 
		cdgo_cnvno						numeric			null, 
		estdo_cptcn						char			not null, 
		usro	 						char(30),
		fcha_crte						datetime		null, 
		da_crte							int				null, 
		fcha_dsde						datetime		null, 
		fcha_hsta						datetime		null, 
		cnsctvo_cdgo_mdlo_cptcn_extrccn	int				null, 
		cnsctvo_cdgo_cdd				char(8)			null,
		cdgo_ips_cptcn 					char(8)			null,
		fcha_fd							datetime
	)

As

Begin
	Declare	@mes		char(2),
			@ano		char(4),
			@fecha1		char(10),
			@hst_nme    Varchar(50) 

	Select	@hst_nme = Ltrim(Rtrim(Convert(Varchar(30), SERVERPROPERTY('machinename'))))
	SET		@MES=DATEPART(MONTH,@fcha_vldcn)

	IF (CONVERT(INT,@MES)<10)
  		  SET @MES='0'+SUBSTRING(@MES,1,1)

	SET @ANO=DATEPART(YEAR,@fcha_vldcn)

	insert into		@tmpCapitacionContrato
			(		cdgo_cnvno,			estdo_cptcn,	fcha_crte,		fcha_dsde,		fcha_hsta,			fcha_fd
			)
	select distinct	a.cdgo_cnvno,		'S',			@fcha_vldcn,	a.fcha_dsde,	a.fcha_hsta,		max(b.fcha_fd) as fcha_fd
	from 			bdAfiliacionValidador.dbo.tbMatrizCapitacionValidador	a	with(nolock)
	Inner Join		bdAfiliacionValidador.dbo.tbEscenarios_procesoValidador	b	with(nolock)	On a.cdgo_cnvno 		  = b.cdgo_cnvno
	where 			nmro_unco_idntfccn 		= @nui_afldo
	and 			cnsctvo_cdgo_tpo_cntrto = @cnsctvo_cdgo_tpo_cntrto
	and 			@fcha_vldcn between 	b.fcha_dsde 	and 	b.fcha_hsta
	and 			@fcha_vldcn between 	a.fcha_dsde 	and 	a.fcha_hsta
	group by		a.cdgo_cnvno,	a.fcha_dsde,	a.fcha_hsta

	update 		@tmpCapitacionContrato 
	set 		cdgo_ips_cptcn	= 	a.cdgo_ips
	from 		@tmpCapitacionContrato									c
	Inner Join	bdAfiliacionValidador.dbo.tbActuarioCapitacionValidador	a	with(nolock)	On	c.fcha_fd between a.fcha_dsde and a.fcha_hsta
	Where 		a.nmro_unco_idntfccn 		= 	 @nui_afldo
	and			a.cnsctvo_cdgo_tpo_cntrto 	= 	@cnsctvo_cdgo_tpo_cntrto

	If Exists	(	Select	1
					From	bdAfiliacionValidador.dbo.tbtablaParametros  With(NoLock)
					Where	vlr_prmtro	= @hst_nme
				)
		Begin
			UPDATE 		@tmpCapitacionContrato 
			SET 		cnsctvo_cdgo_cdd = b.cnsctvo_cdgo_cdd
			FROM 		@tmpCapitacionContrato			c
			Inner Join	bdAfiliacionValidador.dbo.tbIpsPrimarias_vigencias	a	with(nolock)	On	a.cdgo_intrno = c.cdgo_ips_cptcn
			Inner Join	bdAfiliacionValidador.dbo.tbCiudades				b	with(nolock)	On	a.cnsctvo_cdgo_cdd = b.cnsctvo_cdgo_cdd

			-----------ACTUALIZA LA DESCRIPCION DEL CONVENIO
			UPDATE		@tmpCapitacionContrato 	
			SET			dscrpcn_cnvno			= m.dscrpcn_mdlo_cnvno_cptcn,
						cnsctvo_cdgo_mdlo_cptcn_extrccn	= d.cnsctvo_cdgo_mdlo_cptcn_extrccn
			FROM		@tmpCapitacionContrato										t
			Inner Join	bdAfiliacionValidador.dbo.tbModeloConveniosCapitacion		m	with(nolock)	On	m.cdgo_mdlo_cnvno_cptcn			=	t.cdgo_cnvno
			Inner Join	bdAfiliacionValidador.dbo.tbDetModeloConveniosCapitacion	d	with(nolock)	On  m.cnsctvo_cdgo_mdlo_cnvno_cptcn	=	d.cnsctvo_cdgo_mdlo_cnvno_cptcn
			Where		@fcha_vldcn Between m.inco_vgnca And m.fn_vgnca
			And			@fcha_vldcn Between d.inco_vgnca And d.fn_vgnca
		End
	Else
		Begin
			UPDATE 		@tmpCapitacionContrato 
			SET 		cnsctvo_cdgo_cdd = b.cnsctvo_cdgo_cdd
			FROM 		@tmpCapitacionContrato					c 
			Inner Join	bdSisalud.dbo.tbIpsPrimarias_vigencias	a	with(nolock)	On  a.cdgo_intrno		= c.cdgo_ips_cptcn
			Inner Join	bdAfiliacionValidador.dbo.tbCiudades	b	with(nolock)	On	a.cnsctvo_cdgo_cdd	= b.cnsctvo_cdgo_cdd 		
		
			-----------ACTUALIZA LA DESCRIPCION DEL CONVENIO
			UPDATE		@tmpCapitacionContrato 	
			SET			dscrpcn_cnvno			= m.dscrpcn_mdlo_cnvno_cptcn,
						cnsctvo_cdgo_mdlo_cptcn_extrccn	= d.cnsctvo_cdgo_mdlo_cptcn_extrccn
			FROM		@tmpCapitacionContrato							t
			Inner Join	bdSisalud.dbo.tbModeloConveniosCapitacion		m	with(nolock)	On m.cdgo_mdlo_cnvno_cptcn			= t.cdgo_cnvno
			Inner Join	bdSisalud.dbo.tbDetModeloConveniosCapitacion	d	with(nolock)	On m.cnsctvo_cdgo_mdlo_cnvno_cptcn	= d.cnsctvo_cdgo_mdlo_cnvno_cptcn
			Where		@fcha_vldcn Between m.inco_vgnca And m.fn_vgnca
			And			@fcha_vldcn Between d.inco_vgnca And d.fn_vgnca
		end

	If (@@rowcount<>0)
		Begin
			If Exists	(	Select	1
							From	bdAfiliacionValidador.dbo.tbtablaParametros  With(NoLock)
							Where	vlr_prmtro	= @hst_nme
						)
				Begin
					-----------ACTUALIZA EL CORTE
					UPDATE 		@tmpCapitacionContrato 
					SET 		da_crte	=	A.da_crte
					FROM 		@tmpCapitacionContrato											c  
					Inner Join	bdAfiliacionValidador.dbo.tbModeloCapitacionExtraccionDetalle	A	with(nolock)	On  A.cnsctvo_cdgo_mdlo_cptcn_extrccn	= c.cnsctvo_cdgo_mdlo_cptcn_extrccn
					Where		@fcha_vldcn Between inco_vgnca And fn_vgnca
				End
			Else
				Begin
					-----------ACTUALIZA EL CORTE
					UPDATE 		@tmpCapitacionContrato 
					SET 		da_crte	=	A.da_crte
					FROM 		@tmpCapitacionContrato								c
					Inner Join	bdSisalud.dbo.tbModeloCapitacionExtraccionDetalle	A	with(nolock)	On    A.cnsctvo_cdgo_mdlo_cptcn_extrccn	= c.cnsctvo_cdgo_mdlo_cptcn_extrccn
					Where		@fcha_vldcn Between inco_vgnca And fn_vgnca
				End

			-----------ACTUALIZA FECHA DE CORTE
			UPDATE	@tmpCapitacionContrato
			SET		FCHA_CRTE=LTRIM(RTRIM(@ANO))+LTRIM(RTRIM(@MES))+ LTRIM(RTRIM('0'+SUBSTRING(STR(DA_CRTE),10,1)))
			WHERE	DA_CRTE<10 and da_crte>0
	
			--inconsistencia detectada al grabar la validacion de derechos 2009/02/03 (sisatv01)
			Update	@tmpCapitacionContrato
			set		da_crte= 28
			where	da_crte >=29 And ltrim(rtrim(@MES)) = '02'  --mes febrero 

			UPDATE	@tmpCapitacionContrato
			SET		FCHA_CRTE=LTRIM(RTRIM(@ANO))+LTRIM(RTRIM(@MES))+ LTRIM(RTRIM(SUBSTRING(STR(DA_CRTE),9,2)))
			WHERE	DA_CRTE>9 
		End
	Else
		Begin
			delete		@tmpCapitacionContrato
			insert into @tmpCapitacionContrato (  estdo_cptcn )
			values		( 'N')
		End
	Return
End

