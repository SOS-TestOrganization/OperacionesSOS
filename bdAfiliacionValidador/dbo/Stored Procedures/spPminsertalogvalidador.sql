CREATE	procedure [dbo].[spPminsertalogvalidador]
@cnsctvo_cdgo_ofcna 				UdtConsecutivo,
@nmro_vrfcn 	 					numeric(20,0)  output,
@ofcna_usro 						varchar(100) output,
@cdgo_usro 							UdtUsuario, 
@cnsctvo_cdgo_pln 					UdtConsecutivo, 
@cdgo_ips 							UdtCodigoIps	, 
@cnsctvo_cdgo_tpo_idntfccn			UdtConsecutivo, 
@nmro_idntfccn						UdtNumeroIdentificacion, 
@nmro_unco_idntfccn_afldo			UdtConsecutivo, 
@prmr_aplldo						UdtApellido, 
@sgndo_aplldo						UdtApellido,
@prmr_nmbre 						UdtNombre, 
@sgndo_nmbre 						UdtNombre, 
@fcha_ncmnto						datetime,
@edd 								int,
@edd_mss							int,
@edd_ds								int,
@cnsctvo_cdgo_tpo_undd 				UdtConsecutivo, 
@cnsctvo_cdgo_sxo 					UdtConsecutivo, 
@cnsctvo_cdgo_prntscs 				UdtConsecutivo, 
@inco_vgnca_bnfcro					datetime  ,
@fn_vgna_bnfcro						datetime,
@cnsctvo_cdgo_rngo_slrl				UdtConsecutivo, 
@cnsctvo_cdgo_tpo_idntfccn_aprtnte	UdtConsecutivo, 
@nmro_idntfccn_aprtnte				UdtNumeroIdentificacion, 
@nmro_unco_idntfccn_aprtnte			UdtConsecutivo, 
@rzn_scl							varchar(200), 
@cnsctvo_cdgo_pln_pac				UdtConsecutivo, 
@cptdo								Udtlogico,
@cdgo_ips_cptcn						UdtCodigoIps,
@cnsctvo_cdgo_estdo_afldo			UdtConsecutivo, 
@smns_aflcn_ps						numeric,
@smns_aflcn_antrr_eps_ps			numeric,
@smns_aflcn_pc						numeric,
@smns_aflcn_antrr_eps_pc			numeric,
@smns_ctzds							numeric,
@txto_cta							varchar(50), 		
@txto_cpgo							varchar(50),
@drcho	      						udtDescripcion,
@cnsctvo_cdgo_tpo_afldo				UdtConsecutivo	,
@mdlo								varchar(5),
@cnsctvo_cdgo_tpo_cntrto			UdtConsecutivo	,
@nmro_cntrto						UdtNumeroFormulario, 
@cnsctvo_bnfcro						UdtConsecutivo,	
@obsrvcns							UdtObservacion,
@fcha_trnsmsn 						datetime,
@orgn 								char(1),
@cnsctvo_cdgo_sde					UdtConsecutivo,
@nmro_atrzcn_espcl					UdtConsecutivo,
@cnsctvo_cdgo_csa_drcho				UdtConsecutivo,
@cnsctvo_prdcto_scrsl				UdtConsecutivo,
@cdgo_ofcna_lg 						char(5) output,
@cnsctvo_cdgo_mtvo					int	= null

As
Declare 	@fcha			datetime,
			@consecutivo  	int,
	     	@fcha_datos 	datetime,
			@parametro		NVARCHAR(4000),
			@variables		nvarchar(4000),
			@instruccion	nvarchar(4000),
			@hst_nme 		varchar(50),
			@vlr_prmtro     Varchar(30),
			@vlr_prmtro1    Varchar(30),
			@codigo_convenio numeric,  
			@codigo_ciudad char(8)  

set nocount on
set dateformat ymd

Select		@hst_nme	=	Ltrim(Rtrim(Convert(Varchar(30), SERVERPROPERTY('machinename'))))
select		@fcha		= getdate() --se adiciona este select ya que no se esta calculando para la función 

Declare @tmpCapitacionContrato table
		(
			dscrpcn_cnvno					varchar(150) null, 
			cdgo_cnvno						numeric null, 
			estdo_cptcn						char not null, 
			usro	 						char(30),
			fcha_crte						datetime null, 
			da_crte							int null, 
			fcha_dsde						datetime null, 
			fcha_hsta						datetime null, 
			cnsctvo_cdgo_mdlo_cptcn_extrccn	int null, 
			cnsctvo_cdgo_cdd				char(8) null,
			cdgo_ips_cptcn 					char(8) null,
			fcha_fd							datetime
)

Declare  @tmpCondicion table(  
 cdgo_tpo_escnro  char(3),  
 cdgo_itm_cptcn  char(3),  
 cndcn   varchar(1000),  
 accion    varchar(30) )  
  
  
Create   Table #tmpCondicion(  
 cdgo_tpo_escnro  char(3),  
 cdgo_itm_cptcn  char(3),  
 cndcn   varchar(1000),  
 accion    varchar(30),
 cdgo_cnvno	Numeric )  

Create Table	#tmpCapitacionContrato
		(
			cdgo_cnvno			Numeric,
			cnsctvo_cdgo_cdd	Int null
		)

------ FREYA 
--Select		@vlr_prmtro = Ltrim(Rtrim(vlr_prmtro))  
--From		tbtablaParametros  With(NoLock)
--Where		cnsctvo_prmtro = 4

------ TEMIS
--Select		@vlr_prmtro1 = Ltrim(Rtrim(vlr_prmtro))  
--From		tbtablaParametros  With(NoLock)
--Where		cnsctvo_prmtro = 5

Insert Into	@tmpCapitacionContrato
Select		dscrpcn_cnvno,		cdgo_cnvno,				estdo_cptcn,			usro,								fcha_crte,
			da_crte,			fcha_dsde,				fcha_hsta,				cnsctvo_cdgo_mdlo_cptcn_extrccn,	cnsctvo_cdgo_cdd,
			cdgo_ips_cptcn,		fcha_fd
From		bdAfiliacionValidador.dbo.fnPmConsultaDetConveniosCapitacionAfiliadoValidacion(@cnsctvo_cdgo_tpo_cntrto, @nmro_unco_idntfccn_afldo, @fcha)

Update		@tmpCapitacionContrato
Set			usro	=	@cdgo_usro

Declare		@tmpItem table
			(
				cdgo_cnvno		numeric, 
				cdgo_itm_cptcn	char(3),
				accn			varchar(20)
			)

Delete
From		@tmpCapitacionContrato
Where		cdgo_cnvno is Null

--Declare		crCapitacionContrato Cursor For
--Select		Distinct cdgo_cnvno,cnsctvo_cdgo_cdd
--From		@tmpCapitacionContrato
----Where	cdgo_cnvno is Not Null

--Declare		@codigo_convenio	numeric,
--			@codigo_ciudad		char(8)

--Open crCapitacionContrato

--Fetch Next From crCapitacionContrato
--Into @codigo_convenio, @codigo_ciudad

--Declare  @tmpCondicion	table
--		(
--			cdgo_tpo_escnro 	char(3), 
--			cdgo_itm_cptcn		char(3),
--			cndcn				varchar(1000), 
--			accion 				varchar(30)
--		)

--Create   Table #tmpCondicion
--				(
--					cdgo_tpo_escnro 	char(3), 
--					cdgo_itm_cptcn		char(3),
--					cndcn			varchar(1000), 
--					accion 			varchar(30)
--				)

--While @@FETCH_STATUS = 0
--Begin
--	Fetch Next From crCapitacionContrato
--	Into @codigo_convenio, @codigo_ciudad

--	delete From #tmpCondicion

--	Exec spPmValidaItemCapitados @codigo_convenio,@codigo_ciudad,@cnsctvo_cdgo_tpo_cntrto,@nmro_unco_idntfccn_afldo,@fcha

Insert Into		#tmpCapitacionContrato
Select Distinct	cdgo_cnvno,	cnsctvo_cdgo_cdd
From			@tmpCapitacionContrato

Exec			bdAfiliacionValidador.dbo.spPmValidaItemCapitados	@nmro_unco_idntfccn_afldo,	@cnsctvo_cdgo_tpo_cntrto,	@fcha

--	Insert into @tmpItem(
--		cdgo_cnvno, 
--		cdgo_itm_cptcn,
--		accn		
--	)
--	select	@codigo_convenio,
--		cdgo_itm_cptcn,
--		accion
--	from #tmpCondicion


--	Delete From @tmpCondicion
--End

--Close crCapitacionContrato
--Deallocate crCapitacionContrato

Insert into @tmpItem(
		cdgo_cnvno, 
		cdgo_itm_cptcn,
		accn		
	)
	select	cdgo_cnvno,
		cdgo_itm_cptcn,
		accion
	from #tmpCondicion



select  @ofcna_usro			=	dscrpcn_ofcna,
		@cdgo_ofcna_lg		=	cdgo_ofcna
from 	tbOficinas 
where 	cnsctvo_cdgo_ofcna	=	@cnsctvo_cdgo_ofcna

--SELECT @fcha 	=	 GETDATE()

Set @nmro_vrfcn	= 0
--Ejecuto el procedimiento que selecciona el ultimo nuam
--exec bdSiSalud.dbo.spgeneraconsecutivoatencion @cnsctvo_cdgo_ofcna ,19, @nmro_vrfcn output

If Exists(	Select	1
			From	bdAfiliacionValidador.dbo.tbtablaParametros  With(NoLock)
			Where	vlr_prmtro	= @hst_nme
		)
	Begin
		--nueva forma calcular consecutivo
		Begin Transaction
			Select  @nmro_vrfcn=ultmo_vlr  
			From	bdIPSIntegracion.dbo.tbConsecutivosPorOficina  
			Where	cnsctvo_cdgo_cncpto	=	19  
			And		cnsctvo_cdgo_ofcna	=	@cnsctvo_cdgo_ofcna

			Update 	bdIPSIntegracion.dbo.tbConsecutivosPorOficina
			Set 	ultmo_vlr			=	@nmro_vrfcn + 1
			Where 	cnsctvo_cdgo_cncpto	=	19
			And 	cnsctvo_cdgo_ofcna	=	@cnsctvo_cdgo_ofcna

			IF @@ERROR <> 0
				Begin
					ROLLBACK Transaction
					RETURN -1
				End
			Else
				Commit Transaction

		If not exists(	select 1 from bdIPSIntegracion..tblog where  cnsctvo_cdgo_ofcna = @cnsctvo_cdgo_ofcna and nmro_vrfccn = @nmro_vrfcn )
			Begin
				Begin Transaction
					--	select @fcha_datos=cast(SUBSTRING(rtrim(ltrim(@fcha_vldcn)),1,4)+SUBSTRING(rtrim(ltrim(@fcha_vldcn)),6,2) +SUBSTRING(rtrim(ltrim(@fcha_vldcn)),9,2) as datetime)
					Insert into bdIPSIntegracion..tblog(
					cnsctvo_cdgo_ofcna,
					nmro_vrfccn,
					cdgo_usro,
					cnsctvo_cdgo_pln,
					fcha_vldcn,
					cnsctvo_cdgo_tpo_cntrto,
					nmro_cntrto,
					cnsctvo_bnfcro,
					nmro_unco_idntfccn_afldo,
					cnsctvo_cdgo_tpo_idntfccn,
					nmro_idntfccn,
					prmr_aplldo,
					sgndo_aplldo,
					prmr_nmbre,
					sgndo_nmbre,
					fcha_ncmnto,
					edd,
					edd_mss,
					edd_ds,
					cnsctvo_cdgo_tpo_undd,
					cnsctvo_cdgo_sxo,
					cnsctvo_cdgo_prntscs,
					inco_vgnca_bnfcro,
					fn_vgnca_bnfcro,
					cnsctvo_cdgo_rngo_slrl,
					cdgo_ips_prmra,
					nmro_unco_idntfccn_aprtnte,
					cnsctvo_tpo_idntfccn_aprtnte,
					nmro_idntfccn_aprtnte,
					rzn_scl,
					cnsctvo_cdgo_pln_pc,
					cptdo,
					cdgo_ips_cptcn,
					nmro_atrzcn_espcl,
					cnsctvo_cdgo_estdo_afldo,
					ds_ctzds,
					ds_ctzds_pc,
					txto_cta,
					txto_cpgo,
					drcho,
					cnslddo,
					cnsctvo_cdgo_tpo_afldo,
					fcha_trnsmsn, 
					obsrvcns,
					mdlo,
					mqna,
					fcha_ultma_mdfccn,
					orgn,
					cnsctvo_cdgo_sde,
					cnsctvo_cdgo_csa_drcho,
					cnsctvo_prdcto_scrsl,
					smns_aflcn_ps,
					smns_aflcn_antrr_eps_ps,
					smns_aflcn_pc,
					smns_aflcn_antrr_eps_pc,
					smns_ctzds,
					cnsctvo_cdgo_mtvo
					)
					values(
					@cnsctvo_cdgo_ofcna 		,
					@nmro_vrfcn 	 		,
					@cdgo_usro 			,
					@cnsctvo_cdgo_pln 		,
					@fcha,
					@cnsctvo_cdgo_tpo_cntrto	,
					@nmro_cntrto			,
					@cnsctvo_bnfcro		,
					@nmro_unco_idntfccn_afldo	,
					@cnsctvo_cdgo_tpo_idntfccn	,
					@nmro_idntfccn		,
					@prmr_aplldo			,
					@sgndo_aplldo			,
					@prmr_nmbre 			,
					@sgndo_nmbre 			,
					@fcha_ncmnto			,
					@edd				,
					@edd_mss			,
					@edd_ds				,
					@cnsctvo_cdgo_tpo_undd		,
					@cnsctvo_cdgo_sxo 		,
					@cnsctvo_cdgo_prntscs 		,
					@inco_vgnca_bnfcro		,
					@fn_vgna_bnfcro		,
					@cnsctvo_cdgo_rngo_slrl	,
					@cdgo_ips 			,
					@nmro_unco_idntfccn_aprtnte	,
					@cnsctvo_cdgo_tpo_idntfccn_aprtnte	,
					@nmro_idntfccn_aprtnte	,
					@rzn_scl			,
					@cnsctvo_cdgo_pln_pac	,
					@cptdo				,
					@cdgo_ips_cptcn		,
					@nmro_atrzcn_espcl		,
					@cnsctvo_cdgo_estdo_afldo	,
					0			, 
					0			,
					@txto_cta		,	
					@txto_cpgo		,	
					@drcho	      		,	
					null,
					@cnsctvo_cdgo_tpo_afldo	,
					@fcha_trnsmsn ,
					@obsrvcns,  
					@mdlo,
					@hst_nme,
					@fcha 	,
					@orgn,
					@cnsctvo_cdgo_sde,
					@cnsctvo_cdgo_csa_drcho,
					@cnsctvo_prdcto_scrsl,
					@smns_aflcn_ps,
					@smns_aflcn_antrr_eps_ps,
					@smns_aflcn_pc,
					@smns_aflcn_antrr_eps_pc,
					@smns_ctzds,
					@cnsctvo_cdgo_mtvo
					)

					IF @@ERROR <> 0
						Begin 
							ROLLBACK Transaction
							RETURN -1
						End
					Else
						Begin
							/*--Actualizo Consecutivo
							update 	bdSiSalud.dbo.tbConsecutivosPorOficina
							set 	ultmo_vlr	=	@nmro_vrfcn + 1
							where 	cnsctvo_cdgo_cncpto	=	19
							and 	cnsctvo_cdgo_ofcna = @cnsctvo_cdgo_ofcna
							IF @@ERROR <> 0
							Begin 
								ROLLBACK TRANSACTION
								RETURN -1
							End
							*/

	
							--INSERTO LA TABLA TEMPORAL EN LA DEFINITIVA LOS CONVENIOS
					--		set @variables=' @cnsctvo_cdgo_ofcna1 UdtConsecutivo,  @nmro_vrfcn1  numeric, @cdgo_usro1 UdtUsuario , @fcha1 datetime'
					--		set @parametro='INSERT INTO BdSiSalud..tbConveniosLog
					--	                          		select @cnsctvo_cdgo_ofcna1, @nmro_vrfcn1,  cdgo_cnvno, estdo_cptcn, fcha_crte, usro , @fcha1, cdgo_ips_cptcn
					--				from #tmpCapitacionContrato'
					--
					--		 exec sp_executesql @parametro, @variables, @cnsctvo_cdgo_ofcna1 = @cnsctvo_cdgo_ofcna,   @nmro_vrfcn1 =  @nmro_vrfcn, @cdgo_usro1 = @cdgo_usro, @fcha1 = @fcha

							Insert Into		bdIPSIntegracion.dbo.tbConveniosLog
							Select Distinct @cnsctvo_cdgo_ofcna, @nmro_vrfcn,  cdgo_cnvno, estdo_cptcn, fcha_crte, usro , @fcha, cdgo_ips_cptcn
							From			@tmpCapitacionContrato

							IF @@ERROR <> 0
								Begin 
									ROLLBACK Transaction
									RETURN -1
								End
	
							--		set @instruccion='drop table #tmpCapitacionContrato'	
							--		exec sp_executesql @instruccion

	
									--INSERTO LA TABLA TEMPORAL EN LA DEFINITIVA LOS ITEMS DE CAPITACION POR CONVENIO
							/*		set @variables=' @cnsctvo_cdgo_ofcna1 UdtConsecutivo,  @nmro_vrfcn1  numeric, @fcha1 datetime'
									set @parametro='INSERT INTO BdSiSalud..tbLogServicios
	                          									select @cnsctvo_cdgo_ofcna1, @nmro_vrfcn1,  cdgo_itm_cptcn , accn , @fcha1 , cdgo_cnvno
											from #tmpItem'
									 exec sp_executesql @parametro, @variables, @cnsctvo_cdgo_ofcna1 = @cnsctvo_cdgo_ofcna,   @nmro_vrfcn1 =  @nmro_vrfcn, @fcha1 = @fcha
							*/
							Insert Into bdIPSIntegracion.dbo.tbLogServicios
							Select	distinct @cnsctvo_cdgo_ofcna,@nmro_vrfcn,cdgo_itm_cptcn,accn,@fcha,cdgo_cnvno
							from @tmpItem

							IF @@ERROR <> 0
								Begin 
									ROLLBACK Transaction
									RETURN -1
								End

							/*		 set @instruccion='drop table @tmpItem'
									 exec sp_executesql @instruccion
							*/
						IF @@ERROR <> 0
							ROLLBACK Transaction
						ELSE
							COMMIT Transaction
						end
				end
	End
Else
	Begin
		--nueva forma calcular consecutivo
		Begin Transaction

		SELECT  @nmro_vrfcn=ultmo_vlr  
		FROM	bdSiSalud.dbo.tbConsecutivosPorOficina  
		where	cnsctvo_cdgo_cncpto=19  
		and		cnsctvo_cdgo_ofcna = @cnsctvo_cdgo_ofcna

		update 	bdSiSalud.dbo.tbConsecutivosPorOficina
		set 	ultmo_vlr	=	@nmro_vrfcn + 1
		where 	cnsctvo_cdgo_cncpto	=	19
		and 	cnsctvo_cdgo_ofcna = @cnsctvo_cdgo_ofcna


		IF @@ERROR <> 0
			Begin
				ROLLBACK Transaction
				RETURN -1
			End
			ELSE
				Commit Transaction

		if not exists(	select 1 from bdSiSalud..tblog where  cnsctvo_cdgo_ofcna = @cnsctvo_cdgo_ofcna and nmro_vrfccn = @nmro_vrfcn )
		begin

			Begin Transaction

		--	select @fcha_datos=cast(SUBSTRING(rtrim(ltrim(@fcha_vldcn)),1,4)+SUBSTRING(rtrim(ltrim(@fcha_vldcn)),6,2) +SUBSTRING(rtrim(ltrim(@fcha_vldcn)),9,2) as datetime)

			INSErt into BdSiSalud..tblog(
			cnsctvo_cdgo_ofcna,
			nmro_vrfccn,
			cdgo_usro,
			cnsctvo_cdgo_pln,
			fcha_vldcn,
			cnsctvo_cdgo_tpo_cntrto,
			nmro_cntrto,
			cnsctvo_bnfcro,
			nmro_unco_idntfccn_afldo,
			cnsctvo_cdgo_tpo_idntfccn,
			nmro_idntfccn,
			prmr_aplldo,
			sgndo_aplldo,
			prmr_nmbre,
			sgndo_nmbre,
			fcha_ncmnto,
			edd,
			edd_mss,
			edd_ds,
			cnsctvo_cdgo_tpo_undd,
			cnsctvo_cdgo_sxo,
			cnsctvo_cdgo_prntscs,
			inco_vgnca_bnfcro,
			fn_vgnca_bnfcro,
			cnsctvo_cdgo_rngo_slrl,
			cdgo_ips_prmra,
			nmro_unco_idntfccn_aprtnte,
			cnsctvo_tpo_idntfccn_aprtnte,
			nmro_idntfccn_aprtnte,
			rzn_scl,
			cnsctvo_cdgo_pln_pc,
			cptdo,
			cdgo_ips_cptcn,
			nmro_atrzcn_espcl,
			cnsctvo_cdgo_estdo_afldo,
			ds_ctzds,
			ds_ctzds_pc,
			txto_cta,
			txto_cpgo,
			drcho,
			cnslddo,
			cnsctvo_cdgo_tpo_afldo,
			fcha_trnsmsn, 
			obsrvcns,
			mdlo,
			mqna,
			fcha_ultma_mdfccn,
			orgn,
			cnsctvo_cdgo_sde,
			cnsctvo_cdgo_csa_drcho,
			cnsctvo_prdcto_scrsl,
			smns_aflcn_ps,
			smns_aflcn_antrr_eps_ps,
			smns_aflcn_pc,
			smns_aflcn_antrr_eps_pc,
			smns_ctzds,
			cnsctvo_cdgo_mtvo
			)
			values(
			@cnsctvo_cdgo_ofcna 		,
			@nmro_vrfcn 	 		,
			@cdgo_usro 			,
			@cnsctvo_cdgo_pln 		,
			@fcha,
			@cnsctvo_cdgo_tpo_cntrto	,
			@nmro_cntrto			,
			@cnsctvo_bnfcro		,
			@nmro_unco_idntfccn_afldo	,
			@cnsctvo_cdgo_tpo_idntfccn	,
			@nmro_idntfccn		,
			@prmr_aplldo			,
			@sgndo_aplldo			,
			@prmr_nmbre 			,
			@sgndo_nmbre 			,
			@fcha_ncmnto			,
			@edd				,
			@edd_mss			,
			@edd_ds				,
			@cnsctvo_cdgo_tpo_undd		,
			@cnsctvo_cdgo_sxo 		,
			@cnsctvo_cdgo_prntscs 		,
			@inco_vgnca_bnfcro		,
			@fn_vgna_bnfcro		,
			@cnsctvo_cdgo_rngo_slrl	,
			@cdgo_ips 			,
			@nmro_unco_idntfccn_aprtnte	,
			@cnsctvo_cdgo_tpo_idntfccn_aprtnte	,
			@nmro_idntfccn_aprtnte	,
			@rzn_scl			,
			@cnsctvo_cdgo_pln_pac	,
			@cptdo				,
			@cdgo_ips_cptcn		,
			@nmro_atrzcn_espcl		,
			@cnsctvo_cdgo_estdo_afldo	,
			0			, 
			0			,
			@txto_cta		,	
			@txto_cpgo		,	
			@drcho	      		,	
			null,
			@cnsctvo_cdgo_tpo_afldo	,
			@fcha_trnsmsn ,
			@obsrvcns,  
			@mdlo,
			@hst_nme,
			@fcha 	,
			@orgn,
			@cnsctvo_cdgo_sde,
			@cnsctvo_cdgo_csa_drcho,
			@cnsctvo_prdcto_scrsl,
			@smns_aflcn_ps,
			@smns_aflcn_antrr_eps_ps,
			@smns_aflcn_pc,
			@smns_aflcn_antrr_eps_pc,
			@smns_ctzds,
			@cnsctvo_cdgo_mtvo
			)

			IF @@ERROR <> 0
			Begin 
				ROLLBACK Transaction
				RETURN -1
			End
			ELSE
				begin
				/*--Actualizo Consecutivo
				update 	bdSiSalud.dbo.tbConsecutivosPorOficina
				set 	ultmo_vlr	=	@nmro_vrfcn + 1
				where 	cnsctvo_cdgo_cncpto	=	19
				and 	cnsctvo_cdgo_ofcna = @cnsctvo_cdgo_ofcna
				IF @@ERROR <> 0
				Begin 
					ROLLBACK TRANSACTION
					RETURN -1
				End
				*/

	
				--INSERTO LA TABLA TEMPORAL EN LA DEFINITIVA LOS CONVENIOS
		--		set @variables=' @cnsctvo_cdgo_ofcna1 UdtConsecutivo,  @nmro_vrfcn1  numeric, @cdgo_usro1 UdtUsuario , @fcha1 datetime'
		--		set @parametro='INSERT INTO BdSiSalud..tbConveniosLog
		--	                          		select @cnsctvo_cdgo_ofcna1, @nmro_vrfcn1,  cdgo_cnvno, estdo_cptcn, fcha_crte, usro , @fcha1, cdgo_ips_cptcn
		--				from #tmpCapitacionContrato'
		--
		--		 exec sp_executesql @parametro, @variables, @cnsctvo_cdgo_ofcna1 = @cnsctvo_cdgo_ofcna,   @nmro_vrfcn1 =  @nmro_vrfcn, @cdgo_usro1 = @cdgo_usro, @fcha1 = @fcha


				INSERT INTO BdSiSalud.dbo.tbConveniosLog
					select distinct @cnsctvo_cdgo_ofcna, @nmro_vrfcn,  cdgo_cnvno, estdo_cptcn, fcha_crte, usro , @fcha, cdgo_ips_cptcn
				from @tmpCapitacionContrato


				IF @@ERROR <> 0
				Begin 
					ROLLBACK Transaction
					RETURN -1
				End
	
		--		set @instruccion='drop table #tmpCapitacionContrato'	
		--		exec sp_executesql @instruccion

	
				--INSERTO LA TABLA TEMPORAL EN LA DEFINITIVA LOS ITEMS DE CAPITACION POR CONVENIO
		/*		set @variables=' @cnsctvo_cdgo_ofcna1 UdtConsecutivo,  @nmro_vrfcn1  numeric, @fcha1 datetime'
				set @parametro='INSERT INTO BdSiSalud..tbLogServicios
	                          				select @cnsctvo_cdgo_ofcna1, @nmro_vrfcn1,  cdgo_itm_cptcn , accn , @fcha1 , cdgo_cnvno
						from #tmpItem'
				 exec sp_executesql @parametro, @variables, @cnsctvo_cdgo_ofcna1 = @cnsctvo_cdgo_ofcna,   @nmro_vrfcn1 =  @nmro_vrfcn, @fcha1 = @fcha
		*/
				Insert Into BdSiSalud.dbo.tbLogServicios
				Select	distinct @cnsctvo_cdgo_ofcna,@nmro_vrfcn,cdgo_itm_cptcn,accn,@fcha,cdgo_cnvno
				from @tmpItem

				IF @@ERROR <> 0
				Begin 
					ROLLBACK Transaction
					RETURN -1
				End

		/*		 set @instruccion='drop table @tmpItem'
				 exec sp_executesql @instruccion
		*/
				IF @@ERROR <> 0
					ROLLBACK Transaction
				ELSE
					COMMIT Transaction
			   end
		end
	End

Select	@nmro_vrfcn as nmro_vrfcn,@ofcna_usro as ofcna_usro,@cdgo_ofcna_lg as cdgo_ofcna_lg

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidador] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidador] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidador] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidador] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidador] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidador] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidador] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidador] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidador] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidador] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidador] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidador] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidador] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidador] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidador] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidador] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidador] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidador] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

