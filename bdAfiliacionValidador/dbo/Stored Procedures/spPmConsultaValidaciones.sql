CREATE  PROCEDURE [dbo].[spPmConsultaValidaciones]
@nmro_vldcn			numeric(9,0),
@ofcna				udtConsecutivo,
@usro_vlddr			udtUsuario,
@fcha_incl			Datetime,
@fcha_fnl			Datetime,
@tpo_idntfccn		udtConsecutivo,
@nmro_idntfccn		udtNumeroIdentificacion

/*
set @ofcna = 1
--@usro_vlddr		udtUsuario,
set @fcha_incl = '20090101'
set @fcha_fnl = '20090101'
set @tpo_idntfccn = 1
set @nmro_idntfccn = '66983290'
*/

AS
SET NOCOUNT ON

Begin
	Declare @fcha_vca	Char(1),
			@hst_nme		VarChar(50)

	Set		@fcha_vca = 'N'
	Select	@hst_nme = Ltrim(Rtrim(Convert(Varchar(30), SERVERPROPERTY('machinename'))))

	-- se modifica para sólo consultar lo de un año 20101001 sismfg01
	if 	@fcha_incl is null
		Begin
			--Set @fcha_incl 	= '1995/01/01' -- se quitó 20101001 sismfg01
			Set @fcha_incl 	=	convert(char(10),dateadd(yy,-1,getdate()),111)  -- se adicionó 20101001 sismfg01
			Set @fcha_fnl	=	'99991231'
			set @fcha_vca	=	'S'
		End 
	else
		begin
			if datediff(yy,@fcha_incl,@fcha_fnl) != 1
				set @fcha_incl = dateadd(yy,-1,@fcha_fnl) -- se adicionó 20101001 sismfg01

			Set @fcha_fnl	= @fcha_fnl + '23:59:59'
		end

	DECLARE @tbConsultaAfiliados  Table
		(
			cnsctvo_cdgo_ofcna			Int,
			dscrpcn_ofcna				Char(150),
			nmro_vrfccn					numeric,
			fcha_vldcn					Datetime,
			cnsctvo_cdgo_pln			Int,
			dscrpcn_pln					Char(150),
			cnsctvo_cdgo_tpo_idntfccn 	Int ,
			cdgo_tpo_idntfccn			Char(3),
			nmro_idntfccn				Char(20),
			prmr_aplldo					Char(150),
			sgndo_aplldo				Char(150),
			prmr_nmbre					Char(150),
			sgndo_nmbre					Char(150),
			mtvo_vldcn					Char(150),
			tpo_vldcn					Char(150),
			orgn						char(1)
		)

	If Exists	(	Select	1
					From	bdAfiliacionValidador.dbo.tbtablaParametros  With(NoLock)
					Where	vlr_prmtro	= @hst_nme
				)
		Begin
			if (@nmro_vldcn is not null) and (@ofcna is not null) and (@usro_vlddr is not null) and (@tpo_idntfccn is not null) 
				Begin 
					Insert into @tbConsultaAfiliados
							(	cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
								cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
								prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
								sgndo_nmbre,		orgn
							)
					Select 		cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
								cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
								prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
								sgndo_nmbre,		orgn
					From 		bdIPSIntegracion.dbo.tbLog	With(NoLock)
					Where 		nmro_vrfccn 				= @nmro_vldcn
					And			cnsctvo_cdgo_ofcna 			= @ofcna
					And			cdgo_usro 					= @usro_vlddr
					And			fcha_vldcn between @fcha_incl and @fcha_fnl
					And			cnsctvo_cdgo_tpo_idntfccn 	= @tpo_idntfccn
					And			nmro_idntfccn				= @nmro_idntfccn
				End 
			Else
				Begin  
					if  (@ofcna is not null) and (@usro_vlddr is not null) and (@tpo_idntfccn is not null) 
						Begin 
							Insert into @tbConsultaAfiliados
									(	cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
										cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
										prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
										sgndo_nmbre,		orgn
									)
							Select 		cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
										cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
										prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
										sgndo_nmbre,		orgn
							From 		bdIPSIntegracion.dbo.tbLog	With(NoLock)
							Where 		cnsctvo_cdgo_ofcna 			= @ofcna	
							And			cdgo_usro 					= @usro_vlddr 
							And			fcha_vldcn between @fcha_incl and @fcha_fnl 
							And			cnsctvo_cdgo_tpo_idntfccn 	= @tpo_idntfccn 
							And			nmro_idntfccn				= @nmro_idntfccn 
						end
					else
						Begin  
							if  (@usro_vlddr is not null) and (@tpo_idntfccn is not null) 
								Begin 
									Insert into @tbConsultaAfiliados
											(	cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
												cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
												prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
												sgndo_nmbre,		orgn
											)
									Select 		cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
												cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
												prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
												sgndo_nmbre,		orgn
									From 		bdIPSIntegracion.dbo.tbLog	With(NoLock)
									Where 		cdgo_usro 					= @usro_vlddr 
									And			fcha_vldcn between @fcha_incl and @fcha_fnl 
									And			cnsctvo_cdgo_tpo_idntfccn 	= @tpo_idntfccn 
									And			nmro_idntfccn				= @nmro_idntfccn 
								End
							Else  
								Begin
									if  (@tpo_idntfccn is not null) and (@nmro_idntfccn is not null) and @ofcna is not null
										Begin 
											Print('Por Afiliado y oficina')
											Insert into @tbConsultaAfiliados
													(	cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
														cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
														prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
														sgndo_nmbre,		orgn
													)
											Select 		cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
														cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
														prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
														sgndo_nmbre,		orgn
											From 		bdIPSIntegracion.dbo.tbLog	With(NoLock)
											Where 		fcha_vldcn between @fcha_incl and @fcha_fnl 
											And			cnsctvo_cdgo_tpo_idntfccn 	= @tpo_idntfccn 
											And			nmro_idntfccn				= @nmro_idntfccn 
											And			cnsctvo_cdgo_ofcna 			= @ofcna 
										End 
									else
										begin
											if  (@tpo_idntfccn is not null) and (@nmro_idntfccn is not null)
												Begin 
													Print('Por Afiliado')
													Insert into @tbConsultaAfiliados
															(	cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
																cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
																prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
																sgndo_nmbre,		orgn
															)
													Select 		cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
																cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
																prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
																sgndo_nmbre,		orgn
													From 		bdIPSIntegracion.dbo.tbLog 
													Where 		fcha_vldcn between @fcha_incl and @fcha_fnl 
													And			cnsctvo_cdgo_tpo_idntfccn 	= @tpo_idntfccn 
													And			nmro_idntfccn				= @nmro_idntfccn 
												End 
											Else
												Begin
													if   (@nmro_vldcn is not null and  @ofcna is not null) 
														begin 
															Insert into @tbConsultaAfiliados
																	(	cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
																		cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
																		prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
																		sgndo_nmbre,		orgn
																	)
															Select 		cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
																		cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
																		prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
																		sgndo_nmbre,		orgn
															From 		bdIPSIntegracion.dbo.tbLog	With(NoLock)
															Where 		fcha_vldcn between @fcha_incl and @fcha_fnl 
															And			nmro_vrfccn			=	@nmro_vldcn	
															And			cnsctvo_cdgo_ofcna 	=	@ofcna	
														End 
													Else 
														Begin 
															if   (@nmro_vldcn is not null) 
																Begin 
																	Insert into @tbConsultaAfiliados
																			(	cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
																				cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
																				prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
																				sgndo_nmbre,		orgn
																			)
																	Select 		cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
																				cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
																				prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
																				sgndo_nmbre,		orgn
																	From 		bdIPSIntegracion.dbo.tbLog	With(NoLock)
																	Where 		fcha_vldcn between @fcha_incl and @fcha_fnl
																	And			nmro_vrfccn		=	@nmro_vldcn
																End
															Else
																Begin
				 													if  (@ofcna is not null) 
																		Begin 
																			Insert into @tbConsultaAfiliados
																					(	cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
																						cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
																						prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
																						sgndo_nmbre,		orgn
																					)
																			Select 		cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
																						cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
																						prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
																						sgndo_nmbre,		orgn
																			From 		bdIPSIntegracion.dbo.tbLog	With(NoLock)
																			Where 		cnsctvo_cdgo_ofcna 		= @ofcna
																			And			fcha_vldcn between @fcha_incl and @fcha_fnl
																		End
																	Else 
																		Begin
																			if  (@usro_vlddr is not null) 
																				Begin 
																					Insert into @tbConsultaAfiliados
																							(	cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
																								cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
																								prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
																								sgndo_nmbre,		orgn
																							)
																					Select 		cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
																								cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
																								prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
																								sgndo_nmbre,		orgn
																					From 		bdIPSIntegracion.dbo.tbLog	With(NoLock)
																					Where 		cdgo_usro 			= @usro_vlddr
																					And			fcha_vldcn between @fcha_incl and @fcha_fnl
																				End
																		End
																End
														End
												End 
										end
								End
						End 
				End

			If	(	Select	Count(1)
					From	@tbConsultaAfiliados
				)	=	0
				Begin
					If  (@fcha_incl is not null) and (@fcha_fnl is not null) and @fcha_vca = 'N' And @nmro_idntfccn Is Null
						Begin 
							Insert into @tbConsultaAfiliados
									(	cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
										cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
										prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
										sgndo_nmbre,		orgn
									)
							Select 		cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
										cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
										prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
										sgndo_nmbre,		orgn
							From 		bdIPSIntegracion.dbo.tbLog	With(NoLock)
							Where 		fcha_vldcn between @fcha_incl and  @fcha_fnl
							And			cnsctvo_cdgo_ofcna = @ofcna
							Union
							Select 		cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
										cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
										prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
										sgndo_nmbre,		orgn
							From 		bdIPSIntegracion.dbo.tbLog	With(NoLock)
							Where 		fcha_vldcn between @fcha_incl and  @fcha_fnl
							And			@ofcna Is Null
						End
				End 

			--Actualizo las oficinas
			Update 		@tbConsultaAfiliados 
			Set			dscrpcn_ofcna = b.dscrpcn_ofcna 
			From 		@tbConsultaAfiliados					a
			Inner Join	BDAfiliacionValidador.dbo.tbOficinas	b	With(NoLock)	On	b.cnsctvo_cdgo_ofcna	=	a.cnsctvo_cdgo_ofcna

			--Actualizo los planes
			Update 		@tbConsultaAfiliados 
			Set			dscrpcn_pln = b.dscrpcn_pln 
			From 		@tbConsultaAfiliados				a
			Inner Join	BDAfiliacionValidador.dbo.tbPlanes	b	With(NoLock)	On	b.cnsctvo_cdgo_pln	=	a.cnsctvo_cdgo_pln

			Update 		@tbConsultaAfiliados 
			Set			cdgo_tpo_idntfccn = b.cdgo_tpo_idntfccn 
			From 		@tbConsultaAfiliados							a
			Inner Join	BDAfiliacionValidador.dbo.tbTiposIdentificacion b	With(NoLock)	On	b.cnsctvo_cdgo_tpo_idntfccn	=	a.cnsctvo_cdgo_tpo_idntfccn

			Update		@tbConsultaAfiliados
			Set			mtvo_vldcn			= b.dscrpcn_mtvo_ordn_espcl
			From		@tbConsultaAfiliados							a
			Inner Join	bdIPSIntegracion.dbo.tbInfAfiliadosEspeciales	c	With(NoLock)	On	c.cnsctvo_cdgo_tpo_idntfccn		=	a.cnsctvo_cdgo_tpo_idntfccn
																							And	c.nmro_idntfccn					=	a.nmro_idntfccn
			Inner Join	BDAfiliacionValidador.dbo.tbMotivoOrdenEspecial b	With(NoLock)	On	b.cnsctvo_cdgo_mtvo_ordn_espcl	=	c.cnsctvo_cdgo_mtvo
			Where		a.orgn 				= 'E'
		End
	Else
		Begin
			if (@nmro_vldcn is not null) and (@ofcna is not null) and (@usro_vlddr is not null) and (@tpo_idntfccn is not null) 
				Begin 
					Insert into @tbConsultaAfiliados
							(	cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
								cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
								prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
								sgndo_nmbre,		orgn
							)
					Select 		cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
								cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
								prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
								sgndo_nmbre,		orgn
					From 		bdSisalud.dbo.tbLog	With(NoLock)
					Where 		nmro_vrfccn 				= @nmro_vldcn
					And			cnsctvo_cdgo_ofcna 			= @ofcna
					And			cdgo_usro 					= @usro_vlddr
					And			fcha_vldcn between @fcha_incl and @fcha_fnl
					And			cnsctvo_cdgo_tpo_idntfccn 	= @tpo_idntfccn
					And			nmro_idntfccn				= @nmro_idntfccn
				End
			Else
				Begin  
					if  (@ofcna is not null) and (@usro_vlddr is not null) and (@tpo_idntfccn is not null)
						Begin 
							Insert into @tbConsultaAfiliados
									(	cnsctvo_cdgo_ofcna,	nmro_vrfccn, 			fcha_vldcn,
										cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
										prmr_aplldo, 		sgndo_aplldo,			prmr_nmbre,
										sgndo_nmbre,		orgn
									)
							Select 		cnsctvo_cdgo_ofcna,	nmro_vrfccn, 			fcha_vldcn,
										cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
										prmr_aplldo, 		sgndo_aplldo,			prmr_nmbre,
										sgndo_nmbre,		orgn
							From 		bdSisalud.dbo.tbLog	With(NoLock)
							Where 		cnsctvo_cdgo_ofcna 			= @ofcna
							And			cdgo_usro 					= @usro_vlddr
							And			fcha_vldcn between @fcha_incl and @fcha_fnl
							And			cnsctvo_cdgo_tpo_idntfccn 	= @tpo_idntfccn
							And			nmro_idntfccn				= @nmro_idntfccn
						end 
					else
						Begin  
							if  (@usro_vlddr is not null) and (@tpo_idntfccn is not null) 
								Begin 
									Insert into @tbConsultaAfiliados
											(	cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
												cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
												prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
												sgndo_nmbre,		orgn
											)
									Select 		cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
												cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
												prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
												sgndo_nmbre,		orgn
									From 		bdSisalud.dbo.tbLog	With(NoLock)
									Where 		cdgo_usro 					= @usro_vlddr 
									And			fcha_vldcn between @fcha_incl and @fcha_fnl 
									And			cnsctvo_cdgo_tpo_idntfccn 	= @tpo_idntfccn 
									And			nmro_idntfccn				= @nmro_idntfccn 
								End
							else  
								begin
									if  (@tpo_idntfccn is not null) and (@nmro_idntfccn is not null) and @ofcna is not null
										Begin 
											Insert into @tbConsultaAfiliados
													(	cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
														cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
														prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
														sgndo_nmbre,		orgn
													)
											Select 		cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
														cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
														prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
														sgndo_nmbre,		orgn
											From 		bdSisalud.dbo.tbLog	With(NoLock)
											Where 		fcha_vldcn between @fcha_incl and @fcha_fnl
											And			cnsctvo_cdgo_tpo_idntfccn 	= @tpo_idntfccn
											And			nmro_idntfccn				= @nmro_idntfccn
											And			cnsctvo_cdgo_ofcna 			= @ofcna
										End 
									else
										begin
											if  (@tpo_idntfccn is not null) and (@nmro_idntfccn is not null)
												Begin 
													Insert into @tbConsultaAfiliados
															(	cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
																cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
																prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
																sgndo_nmbre,		orgn
															)
													Select 		cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
																cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
																prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
																sgndo_nmbre,		orgn
													From 		bdSisalud.dbo.tbLog	With(NoLock)
													Where 		fcha_vldcn between @fcha_incl and @fcha_fnl
													And			cnsctvo_cdgo_tpo_idntfccn 	= @tpo_idntfccn
													And			nmro_idntfccn				= @nmro_idntfccn
												End 
											Else
												Begin
													if   (@nmro_vldcn is not null and  @ofcna is not null) 
														begin 
															Insert into @tbConsultaAfiliados
																	(	cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
																		cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
																		prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
																		sgndo_nmbre,		orgn
																	)
															Select 		cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
																		cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
																		prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
																		sgndo_nmbre,		orgn
															From 		bdSisalud.dbo.tbLog	With(NoLock)
															Where 		fcha_vldcn between @fcha_incl and @fcha_fnl
															And			nmro_vrfccn			=	@nmro_vldcn
															And			cnsctvo_cdgo_ofcna 	= @ofcna
														End 
												Else 
													Begin 
														if   (@nmro_vldcn is not null) 
															Begin 
																Insert into @tbConsultaAfiliados
																		(	cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
																			cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
																			prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
																			sgndo_nmbre,		orgn
																		)
																Select 		cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
																			cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
																			prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
																			sgndo_nmbre,		orgn
																From 		bdSisalud.dbo.tbLog	With(NoLock)
																Where 		fcha_vldcn between @fcha_incl and @fcha_fnl
																And			nmro_vrfccn		=	@nmro_vldcn
															End
														Else
															Begin
				 												if  (@ofcna is not null) 
																	Begin 
																		Insert into @tbConsultaAfiliados
																				(	cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
																					cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
																					prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
																					sgndo_nmbre,		orgn
																				)
																		Select 		cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
																					cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
																					prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
																					sgndo_nmbre,		orgn
																		From 		bdSisalud.dbo.tbLog	With(NoLock)
																		Where 		cnsctvo_cdgo_ofcna 	= @ofcna
																		And			fcha_vldcn between @fcha_incl and @fcha_fnl
																	End
																Else 
																	Begin
																		if  (@usro_vlddr is not null) 
																			Begin 
																				Insert into @tbConsultaAfiliados
																						(	cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
																							cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
																							prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
																							sgndo_nmbre,		orgn
																						)
																				Select 		cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
																							cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
																							prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
																							sgndo_nmbre,		orgn
																				From 		bdSisalud.dbo.tbLog	With(NoLock)
																				Where 		cdgo_usro 			= @usro_vlddr 
																				And			fcha_vldcn between @fcha_incl and @fcha_fnl 
																			End
																	End
															End 
												End
									End 
							end
						End
				End 
			End

			If	(	Select	Count(1)
					From @tbConsultaAfiliados
				)	=	0
				Begin
					if  (@fcha_incl is not null) and (@fcha_fnl is not null) and @fcha_vca = 'N' And @nmro_idntfccn Is Null
						Begin 
							Insert into @tbConsultaAfiliados
									(	cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
										cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
										prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
										sgndo_nmbre,		orgn
									)
							Select 		cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
										cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
										prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
										sgndo_nmbre,		orgn
							From 		bdSisalud.dbo.tbLog	With(NoLock)
							Where 		fcha_vldcn between @fcha_incl and  @fcha_fnl
							And			cnsctvo_cdgo_ofcna = @ofcna
							Union
							Select 		cnsctvo_cdgo_ofcna,	nmro_vrfccn, 				fcha_vldcn,
										cnsctvo_cdgo_pln,	cnsctvo_cdgo_tpo_idntfccn,	nmro_idntfccn,
										prmr_aplldo, 		sgndo_aplldo,				prmr_nmbre,
										sgndo_nmbre,		orgn
							From 		bdSisalud.dbo.tbLog	With(NoLock)
							Where 		fcha_vldcn between @fcha_incl and  @fcha_fnl
							And			@ofcna Is Null
						End
				End 

			--Actualizo las oficinas
			Update 		@tbConsultaAfiliados 
			Set			dscrpcn_ofcna = b.dscrpcn_ofcna 
			From 		@tbConsultaAfiliados					a
			Inner Join	BDAfiliacionValidador.dbo.tbOficinas	b	With(NoLock)	On	b.cnsctvo_cdgo_ofcna	=	a.cnsctvo_cdgo_ofcna

			--Actualizo los planes
			Update 		@tbConsultaAfiliados 
			Set			dscrpcn_pln = b.dscrpcn_pln 
			From 		@tbConsultaAfiliados				a
			Inner Join	BDAfiliacionValidador.dbo.tbPlanes	b	With(NoLock)	On	b.cnsctvo_cdgo_pln	=	a.cnsctvo_cdgo_pln

			Update 		@tbConsultaAfiliados 
			Set			cdgo_tpo_idntfccn = b.cdgo_tpo_idntfccn 
			From 		@tbConsultaAfiliados							a
			Inner Join	BDAfiliacionValidador.dbo.tbTiposIdentificacion b	With(NoLock)	On	b.cnsctvo_cdgo_tpo_idntfccn	=	a.cnsctvo_cdgo_tpo_idntfccn

			Update		@tbConsultaAfiliados
			Set			mtvo_vldcn			= b.dscrpcn_mtvo_ordn_espcl
			From		@tbConsultaAfiliados							a
			Inner Join	bdSisalud.dbo.tbInfAfiliadosEspeciales			c	With(NoLock)	On	c.cnsctvo_cdgo_tpo_idntfccn		=	a.cnsctvo_cdgo_tpo_idntfccn
																							And	c.nmro_idntfccn					=	a.nmro_idntfccn
			Inner Join	BDAfiliacionValidador.dbo.tbMotivoOrdenEspecial b	With(NoLock)	On	b.cnsctvo_cdgo_mtvo_ordn_espcl	=	c.cnsctvo_cdgo_mtvo
			Where		a.orgn 				= 'E'
		End

	Update	@tbConsultaAfiliados
	Set		tpo_vldcn			= 'NORMAL'
	Where   orgn <>	'E'

	Update	@tbConsultaAfiliados
	Set		tpo_vldcn			= 'ESPECIAL'
	Where   orgn = 	'E'

	Select	cnsctvo_cdgo_ofcna,			dscrpcn_ofcna,					nmro_vrfccn,				fcha_vldcn,					cnsctvo_cdgo_pln,
			dscrpcn_pln,				cnsctvo_cdgo_tpo_idntfccn,		cdgo_tpo_idntfccn,			nmro_idntfccn,				prmr_aplldo,
			sgndo_aplldo,				prmr_nmbre,						sgndo_nmbre,				mtvo_vldcn,					tpo_vldcn,
			orgn
	From	@tbConsultaAfiliados
End


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaValidaciones] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaValidaciones] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaValidaciones] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaValidaciones] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaValidaciones] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaValidaciones] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];

