
CREATE  Procedure spValidaDerechosPac4

	@nmro_idntfccn 			Numeric(15),
	@cnsctvo_bnfcro			Int,
	@tpo_idntfccn_bnfcro			Int,
	@nmro_idntfccn_bnfcro		 	Numeric(15),
	@lnOrigen				Int  		--  1- AudioRespuesta   2- Sipres 

As

Set Nocount On

Declare @lcTipoIdentificacionCotizante			Int,
	@lcNumeroIdentificacionCotizante 		VarChar(20),
	@lcNumeroContrato 				Char(15),
	@lcCodigoPlan 					Int,
	@lnCausaRechazo				Int,
	@lnEstado					Int,
	@lnNumeroAutorizacion				Int,
	@lnDigitoVerificacion 				Int,
	@lnNumeroUnicoIdentificacionBeneficiario	Int,
	@lcNumeroIdentificacion				VarChar(20),
	@lcNumeroIdentificacionBeneficiario 		VarChar(20),
	@lnConsecutivoCodigoPlan			Int

Set 	@lnNumeroAutorizacion 				=  0
Set 	@lcNumeroIdentificacionCotizante 		= '0'
Set 	@lcCodigoPlan					= '0'

Set 	@lcNumeroIdentificacion 			= Convert(VarChar(20),@nmro_idntfccn)
Set 	@lcNumeroIdentificacionBeneficiario 		= Convert(VarChar(20),@nmro_idntfccn_bnfcro)

Declare @tmpContratosAfiliado Table (
	nmro_cntrto				Char(15), 
	tpo_idntfccn				Int,
	nmro_idntfccn				Char(20), 
	cnsctvo_bnfcro 				Int,
	inco_vgnca_cntrto			DateTime,
	fn_vgnca_cntrto				DateTime, 
	inco_vgnca_bnfcro			DateTime,
	fn_vgnca_bnfcro			DateTime,
	cnsctvo_cdgo_pln			Int,
	cdgo_tpo_cntrto				Int,
	nmro_unco_idntfccn_bnfcro 		Int,  
	cdgo_pln				Int )

If @nmro_idntfccn_bnfcro = 0
	Insert 	Into  @tmpContratosAfiliado
	Select  	a.nmro_cntrto, 			a.cnsctvo_cdgo_tpo_idntfccn,		a.nmro_idntfccn,
		b.cnsctvo_bnfcro,		a.inco_vgnca_cntrto ,			a.fn_vgnca_cntrto, 		
		b.inco_vgnca_bnfcro,		b.fn_vgnca_bnfcro,			a.cnsctvo_cdgo_pln,		
		a.cnsctvo_cdgo_tpo_cntrto,	b.nmro_unco_idntfccn_afldo,		0 as cdgo_pln
	From 	bdAfiliacionValidador..tbContratosValidador a, bdAfiliacionValidador..tbBeneficiariosValidador b
	Where 	b.nmro_idntfccn 			=  @lcNumeroIdentificacion 	
	And	b.cnsctvo_cdgo_tpo_cntrto	= 2 					
	And	b.cnsctvo_cdgo_tpo_cntrto	= a.cnsctvo_cdgo_tpo_cntrto 		
	And	b.nmro_cntrto 			= a.nmro_cntrto				
	And	Cast(b.cnsctvo_bnfcro as Int) 	= @cnsctvo_bnfcro 		
Else
	Insert 	Into  @tmpContratosAfiliado
	Select  	a.nmro_cntrto,			a.cnsctvo_cdgo_tpo_idntfccn,		a.nmro_idntfccn,
		b.cnsctvo_bnfcro,		a.inco_vgnca_cntrto,			a.fn_vgnca_cntrto,
		b.inco_vgnca_bnfcro,		b.fn_vgnca_bnfcro,			a.cnsctvo_cdgo_pln,
		a.cnsctvo_cdgo_tpo_cntrto,	b.nmro_unco_idntfccn_afldo,		0 as cdgo_pln
	From 	bdAfiliacionValidador..tbContratosValidador a, bdAfiliacionValidador..tbBeneficiariosValidador b
	Where 	a.nmro_idntfccn 			= @lcNumeroIdentificacion 	
	And	b.cnsctvo_cdgo_tpo_cntrto	= 2 			
	And	b.cnsctvo_cdgo_tpo_cntrto	= a.cnsctvo_cdgo_tpo_cntrto 	
	And	b.nmro_cntrto 			= a.nmro_cntrto		
	And	Cast(b.cnsctvo_bnfcro as Int) 	= @cnsctvo_bnfcro	
	And	b.nmro_idntfccn 			= @lcNumeroIdentificacionBeneficiario	

/*---------------------------------------------------------------------------------------------------------------------------------
   Causa de rechazo 
------------------------------------------------------------------------------------------------------------------------------------
	0- El beneficiario tiene derecho al servicio, esta al dia con pagos a tiempo
	1- No existe beneficiario
	2- El beneficiario no esta vigente
	3. El beneficiario esta moroso
	4. El beneficiario al dia con pago extemporaneo
------------------------------------------------------------------------------------------------------------------------------------*/

If @@RowCount  = 0

	Set @lnCausaRechazo = 1

Else
	Begin
		Update 	@tmpContratosAfiliado
		Set	cdgo_pln		= b.cdgo_pln
		From 	@tmpContratosAfiliado a, bdAfiliacionValidador..tbPlanes b
		Where	a.cnsctvo_cdgo_pln	= b.cnsctvo_cdgo_pln
	
		Select 	@lcTipoIdentificacionCotizante 			= a.tpo_idntfccn, 
			@lcNumeroIdentificacionCotizante 		= a.nmro_idntfccn,
			@lcNumeroContrato				= a.nmro_cntrto,
			@lcCodigoPlan 					= a.cdgo_pln,
			@lnNumeroUnicoIdentificacionBeneficiario  	= a.nmro_unco_idntfccn_bnfcro,
			@lnConsecutivoCodigoPlan			= a.cnsctvo_cdgo_pln
		From    @tmpContratosAfiliado a
		Where 	a.cnsctvo_bnfcro 				= @cnsctvo_bnfcro   		
		And      	Getdate() Between a.inco_vgnca_bnfcro And a.fn_vgnca_bnfcro
		And	Getdate() Between a.inco_vgnca_cntrto  And a.fn_vgnca_cntrto
	
		If @lcNumeroIdentificacionCotizante = 0
			Set @lnCausaRechazo = 2
		Else
			Select  	@lnEstado 		= Isnull(cnsctvo_cdgo_estdo_drcho,0) ,
				@lnCausaRechazo 	=Case cnsctvo_cdgo_estdo_drcho  
								When 1 		Then 0
								When 2 		Then 0
								When 3 		Then 0
								When 7 		Then 2
								When 8 		Then 3
								When 9	 		Then 3			
								When 10 		Then 4
								When 11 		Then 4
								When 12 		Then 4
								When 13 		Then 4	
							   	Else			          1
					 		     End
			From 	tbMatrizDerechosValidador	
			Where   cnsctvo_cdgo_tpo_cntrto 	= 2
			And	nmro_cntrto 			= @lcNumeroContrato 
			And	cnsctvo_bnfcro 			= @cnsctvo_bnfcro
			And	fn_vgnca_estdo_drcho 		= '99991231'
	

		If @lnCausaRechazo = 0 Or @lnCausaRechazo = 4
			Begin
				Select @lnNumeroAutorizacion 	= Cast(Substring(rtrim(ltrim(Cast(Max(nmro_atrzcn) as Char(10)))),1,len(rtrim(ltrim(Cast(Max(nmro_atrzcn) as Char(10)))))-1) as Int)+1
				From tbAutorizacionesPac
				
				Set @lnDigitoVerificacion	=  dbo.fnCalculaDigitoVerificacionModulo11(@lnNumeroAutorizacion)
				Set @lnNumeroAutorizacion 	=  Rtrim(Ltrim(Cast(@lnNumeroAutorizacion As Char(09)))) +Rtrim(Ltrim(Cast( @lnDigitoVerificacion As Char(1))))
				
				Insert Into  bdAfiliacionValidador..tbAutorizacionesPac(
						nmro_atrzcn,			nmro_idntfccn_usro,			cnsctvo_usro,
						fcha_atrzcn,			autrzcn_espcl,				cnsctvo_cdgo_pln,
						estdo,				nmro_unco_idntfccn_bnfcro)
				Values 	(	@lnNumeroAutorizacion, 	@nmro_idntfccn, 			@cnsctvo_bnfcro, 
						Getdate(),	 		'N',			 		@lnConsecutivoCodigoPlan,
						@lnEstado,			@lnNumeroUnicoIdentificacionBeneficiario)
			End
					
	End 

Select 	@lnCausaRechazo as csa, @lnNumeroAutorizacion as nmro_atrzcn, @lcCodigoPlan as cdgo_pln

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spValidaDerechosPac4] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spValidaDerechosPac4] TO [Consultor Servicio al Cliente]
    AS [dbo];

