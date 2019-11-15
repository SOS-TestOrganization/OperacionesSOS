CREATE procedure [dbo].[spPminsertalogvalidadorSipres]
	@cnsctvo_cdgo_ofcna                udtConsecutivo         , --1  
	@nmro_vrfcn                        Numeric(20,0)  Output  , --2  
	@ofcna_usro                        Varchar(100)   Output  , --4  
	@cdgo_usro                         udtUsuario             , --5  
	@cnsctvo_cdgo_pln                  udtConsecutivo         , --6  
	@cdgo_ips                          udtCodigoIps           , --7  
	@cnsctvo_cdgo_tpo_idntfccn         udtConsecutivo         , --8  
	@nmro_idntfccn                     udtNumeroIdentificacion, --9  
	@nmro_unco_idntfccn_afldo          udtConsecutivo         , --10  
	@prmr_aplldo                       udtApellido            , --11  
	@sgndo_aplldo                      udtApellido            , --12  
	@prmr_nmbre                        udtNombre              , --13  
	@sgndo_nmbre                       udtNombre              , --14  
	@fcha_ncmnto                       Datetime               , --15  
	@edd                               Int                    , --16  
	@edd_mss                           Int                    , --17  
	@edd_ds                            Int                    , --18  
	@cnsctvo_cdgo_tpo_undd             udtConsecutivo         , --19  
	@cnsctvo_cdgo_sxo                  udtConsecutivo         , --20  
	@cnsctvo_cdgo_prntscs              udtConsecutivo         , --21  
	@inco_vgnca_bnfcro                 Datetime               , --22  
	@fn_vgna_bnfcro                    Datetime               , --23  
	@cnsctvo_cdgo_rngo_slrl            udtConsecutivo         , --24  
	@cnsctvo_cdgo_tpo_idntfccn_aprtnte udtConsecutivo         , --25  
	@nmro_idntfccn_aprtnte             udtNumeroIdentificacion, --26  
	@nmro_unco_idntfccn_aprtnte        udtConsecutivo         , --27  
	@rzn_scl                           Varchar(200)           , --28  
	@cnsctvo_cdgo_pln_pac              udtConsecutivo         , --29  
	@cptdo                             udtlogico              , --30  
	@cdgo_ips_cptcn                    udtCodigoIps           , --31  
	@cnsctvo_cdgo_estdo_afldo          udtConsecutivo         , --32  
	@smns_aflcn_ps                     Numeric                , --33  
	@smns_aflcn_antrr_eps_ps           Numeric                , --34  
	@smns_aflcn_pc                     Numeric                , --35  
	@smns_aflcn_antrr_eps_pc           Numeric                , --36  
	@smns_ctzds                        Numeric                , --37  
	@txto_cta                          Varchar(50)            , --38  
	@txto_cpgo                         Varchar(50)            , --39  
	@drcho                             udtDescripcion         , --40  
	@cnsctvo_cdgo_tpo_afldo            udtConsecutivo         , --41  
	@mdlo                              Varchar(5)             , --42  
	@cnsctvo_cdgo_tpo_cntrto           udtConsecutivo         , --43  
	@nmro_cntrto                       udtNumeroFormulario    , --44  
	@cnsctvo_bnfcro                    udtConsecutivo         , --45  
	@obsrvcns                          udtObservacion         , --46  
	@fcha_trnsmsn                      Datetime               , --47  
	@orgn                              Char(1)                , --48  
	@cnsctvo_cdgo_sde                  udtConsecutivo         , --49  
	@nmro_atrzcn_espcl                 udtConsecutivo         , --50  
	@cnsctvo_cdgo_csa_drcho            udtConsecutivo         , --51  
	@cnsctvo_prdcto_scrsl              udtConsecutivo         , --52  
	@cdgo_ofcna_lg                     Varchar(5)     Output  , --53  
	@cnsctvo_cdgo_mtvo                 Int      = Null        , --54  
	@bno                               Int      = Null        , --55  
	@nmro_dcmnto                       Char(50) = Null        , --56  
	@CdoServBono                       Char(5)  = Null        , --57  
	@nmro_vrfcn_fnl                    Varchar(20)    Output    --Se crea nueva variable para la visualización de la oficina + el log --3 58  
AS  

Set Nocount On  
Set Transaction Isolation Level Repeatable Read  

Begin
    Set Dateformat ymd  
	
	DECLARE  @fcha                      Datetime      ,  
			 @consecutivo               Int           ,  
			 @fcha_datos                Datetime      ,  
			 @parametro                 NVarchar(4000),  
			 @variables                 NVarchar(4000),   
			 @instruccion               NVarchar(4000),  
			 @hst_nme                   Varchar(50)   ,  
			 @mensaje                   Varchar(2000) ,
			 @cdgo_intrno_ips           Char(8)       ,
			 @cnsctvo_cdgo_atrzcn_estdo Int           ,
			 @codigo_convenio           Numeric       ,  
	         @codigo_ciudad             Char(8)       ,
			 @vlr_prmtro                Varchar(30)   ,
			 @vlr_prmtro1               Varchar(30)   ,
			 @vlr_prmtro2               Varchar(30)   ,
			 @name_server               Varchar(30)
		  
  	 
	Declare @tmpCapitacionContrato Table
			(	dscrpcn_cnvno                   Varchar(150),
				cdgo_cnvno                      Numeric,
				estdo_cptcn                     Char Not Null,
				usro                            Char(30),
				fcha_crte                       Datetime,
				da_crte                         Int,
				fcha_dsde                       Datetime,
				fcha_hsta                       Datetime,
				cnsctvo_cdgo_mdlo_cptcn_extrccn Int,
				cnsctvo_cdgo_cdd                Char(8),
				cdgo_ips_cptcn                  Char(8),
				fcha_fd                         Datetime
	        )

	Declare @tmpItem Table
			(	cdgo_cnvno     Numeric,
	            cdgo_itm_cptcn Char(3),
	            accn           Varchar(20)
			)

	Declare @tmpCondicion Table
			(	cdgo_tpo_escnro Char(3), --  20180125 - sisjhm01 se aumenta la logintud del campo para igualar al de la fisica bdAfiliacionValidador.dbo.tbEscenarios_procesoValidador
	            cdgo_itm_cptcn  Char(3),  
	            cndcn           Varchar(1000),
	            accion          Varchar(30)
			)
  
	Create Table #tmpCondicion
			(	
				cdgo_tpo_escnro Char(3),  --20180125 - sisjhm01 se aumenta la logintud del campo para igualar al de la fisica bdAfiliacionValidador.dbo.tbEscenarios_procesoValidador
	            cdgo_itm_cptcn  Char(3),
	            cndcn           Varchar(1000),
	            accion          Varchar(30),
				cdgo_cnvno		Numeric
			)
	Create Table	#tmpCapitacionContrato
			(
				cdgo_cnvno			Numeric,
				cnsctvo_cdgo_cdd	Int
			)
	
	Set			@cnsctvo_cdgo_atrzcn_estdo = 1 -- ingresado/validado
	Set			@nmro_vrfcn = 0
  
	Select		@hst_nme = Ltrim(Rtrim(Convert(Varchar(30), SERVERPROPERTY('machinename'))))
	Select		@fcha    = getDate() --se adiciona este select ya que no se esta calculando para la función    
  
	Insert Into @tmpCapitacionContrato
	Select		dscrpcn_cnvno,		cdgo_cnvno,				estdo_cptcn,			usro,								fcha_crte,
				da_crte,			fcha_dsde,				fcha_hsta,				cnsctvo_cdgo_mdlo_cptcn_extrccn,	cnsctvo_cdgo_cdd,
				cdgo_ips_cptcn,		fcha_fd
	From		bdAfiliacionValidador.dbo.fnPmConsultaDetConveniosCapitacionAfiliadoValidacion(@cnsctvo_cdgo_tpo_cntrto, @nmro_unco_idntfccn_afldo, @fcha)
	  
	Update		@tmpCapitacionContrato  
	Set			usro = @cdgo_usro
  
	Delete
	From			@tmpCapitacionContrato  
	Where			cdgo_cnvno Is Null  

	Insert Into		#tmpCapitacionContrato
	Select Distinct	cdgo_cnvno,	cnsctvo_cdgo_cdd
	From			@tmpCapitacionContrato

	Exec bdAfiliacionValidador.dbo.spPmValidaItemCapitados	@nmro_unco_idntfccn_afldo,	@cnsctvo_cdgo_tpo_cntrto,	@fcha

	Insert Into	@tmpItem
		(		cdgo_cnvno,			cdgo_itm_cptcn,	accn
		)
	Select		cdgo_cnvno,		cdgo_itm_cptcn,	accion
	From		#tmpCondicion	With(NoLock)
     
	--Declare crCapitacionContrato Cursor For  
	--Select Distinct cdgo_cnvno, cnsctvo_cdgo_cdd  
	--From   @tmpCapitacionContrato  
  
	--Open crCapitacionContrato  
	--Fetch crCapitacionContrato Into @codigo_convenio, @codigo_ciudad  
  
	--	While @@FETCH_STATUS = 0  
	--	  Begin  
	--		 Delete From #tmpCondicion  
  
	--		 Exec spPmValidaItemCapitados @codigo_convenio,@codigo_ciudad,@cnsctvo_cdgo_tpo_cntrto,@nmro_unco_idntfccn_afldo,@fcha  
  
	--		 Insert Into	@tmpItem
	--				(		cdgo_cnvno,			cdgo_itm_cptcn, accn
	--				)
	--		 Select			@codigo_convenio,	cdgo_itm_cptcn,	accion
	--		 From			#tmpCondicion
    
	--		 Delete From @tmpCondicion  
   
	--		 --nueva forma 2009/01/07  
	--		 Fetch crCapitacionContrato into @codigo_convenio, @codigo_ciudad  
	--	  End  
 -- 	Close crCapitacionContrato  
	--Deallocate crCapitacionContrato  
  
    Select	@ofcna_usro			=	dscrpcn_ofcna,
			@cdgo_ofcna_lg		=	cdgo_ofcna
	From	bdAfiliacionValidador.dbo.tbOficinas With(NoLock)
	Where	cnsctvo_cdgo_ofcna =	@cnsctvo_cdgo_ofcna
  
	-- andres camelo (illustrato ltda)
	-- 08/04/2014
	-- consulta el codigo interno del prestador
	
	Select @cdgo_intrno_ips = cdgo_intrno 
	From   bdSeguridad.dbo.tbUsuariosWeb  With(NoLock)
	Where  lgn_usro = @cdgo_usro

	--Ejecuto el procedimiento que selecciona el ultimo nuam  
	--exec bdSiSalud.dbo.spgeneraconsecutivoatencion @cnsctvo_cdgo_ofcna ,19, @nmro_vrfcn output  

	If Exists	(	Select	1
					From	bdAfiliacionValidador.dbo.tbtablaParametros  With(NoLock)
					Where	vlr_prmtro	= @hst_nme
				)
		Begin
			Select @nmro_vrfcn = ultmo_vlr    
			From   bdIPSIntegracion.dbo.tbConsecutivosPorOficina With(NoLock)   
			Where  cnsctvo_cdgo_cncpto = 19    
			And    cnsctvo_cdgo_ofcna  = @cnsctvo_cdgo_ofcna  
    
			If @nmro_vrfcn != 0  
				Begin  
					Update bdIPSIntegracion.dbo.tbConsecutivosPorOficina  
					Set    ultmo_vlr			= @nmro_vrfcn + 1  
					Where  cnsctvo_cdgo_cncpto	= 19  
					And    cnsctvo_cdgo_ofcna	= @cnsctvo_cdgo_ofcna  
				End  
			Else  
				Begin  
					Set   @mensaje = 'Error Calculo Numero Validacion '+ Cast(@nmro_vrfcn As Char(10)) + 'Consecutivo Oficina ' + Cast(@cnsctvo_cdgo_ofcna As Char(10))  
				End	  
	   	  
			-- 20120119 - sismfg01 se quita esta validacion porque hace que no se presente error de primary y esta no es la forma de controlar la concurrencia  
			-- If not exists( select 1 from bdIPSIntegracion.dbo.tblog where  cnsctvo_cdgo_ofcna = @cnsctvo_cdgo_ofcna and nmro_vrfccn = @nmro_vrfcn )  
			Begin Try
				Begin Transaction
					Insert Into	bdIPSIntegracion.dbo.tblog
							(	cnsctvo_cdgo_ofcna      , nmro_vrfccn              , cdgo_usro                 , cnsctvo_cdgo_pln,
								fcha_vldcn              , cnsctvo_cdgo_tpo_cntrto  , nmro_cntrto               , cnsctvo_bnfcro,
								nmro_unco_idntfccn_afldo, cnsctvo_cdgo_tpo_idntfccn, nmro_idntfccn             , prmr_aplldo,
								sgndo_aplldo            , prmr_nmbre               , sgndo_nmbre               , fcha_ncmnto,
								edd                     , edd_mss                  , edd_ds                    , cnsctvo_cdgo_tpo_undd,
								cnsctvo_cdgo_sxo        , cnsctvo_cdgo_prntscs     , inco_vgnca_bnfcro         , fn_vgnca_bnfcro,
								cnsctvo_cdgo_rngo_slrl  , cdgo_ips_prmra           , nmro_unco_idntfccn_aprtnte, cnsctvo_tpo_idntfccn_aprtnte,
								nmro_idntfccn_aprtnte   , rzn_scl                  , cnsctvo_cdgo_pln_pc       , cptdo,
								cdgo_ips_cptcn          , nmro_atrzcn_espcl        , cnsctvo_cdgo_estdo_afldo  , ds_ctzds,
								ds_ctzds_pc             , txto_cta                 , txto_cpgo                 , drcho,
								cnslddo                 , cnsctvo_cdgo_tpo_afldo   , fcha_trnsmsn              , obsrvcns,
								mdlo                    , mqna                     , fcha_ultma_mdfccn         , orgn,
								cnsctvo_cdgo_sde        , cnsctvo_cdgo_csa_drcho   , cnsctvo_prdcto_scrsl      , smns_aflcn_ps,
								smns_aflcn_antrr_eps_ps , smns_aflcn_pc            , smns_aflcn_antrr_eps_pc   , smns_ctzds,
								cnsctvo_cdgo_mtvo  
							)
					Values	(	@cnsctvo_cdgo_ofcna      , @nmro_vrfcn               , @cdgo_usro                 , @cnsctvo_cdgo_pln,
								@fcha                    , @cnsctvo_cdgo_tpo_cntrto  , @nmro_cntrto               , @cnsctvo_bnfcro,
								@nmro_unco_idntfccn_afldo, @cnsctvo_cdgo_tpo_idntfccn, @nmro_idntfccn             , @prmr_aplldo,
								@sgndo_aplldo            , @prmr_nmbre               , @sgndo_nmbre               , @fcha_ncmnto,
								@edd                     , @edd_mss                  , @edd_ds                    , @cnsctvo_cdgo_tpo_undd,
								@cnsctvo_cdgo_sxo        , @cnsctvo_cdgo_prntscs     , @inco_vgnca_bnfcro         , @fn_vgna_bnfcro,
								@cnsctvo_cdgo_rngo_slrl  , @cdgo_ips                 , @nmro_unco_idntfccn_aprtnte, @cnsctvo_cdgo_tpo_idntfccn_aprtnte,
								@nmro_idntfccn_aprtnte   , @rzn_scl                  , @cnsctvo_cdgo_pln_pac      , @cptdo,
								@cdgo_ips_cptcn          , @nmro_atrzcn_espcl        , @cnsctvo_cdgo_estdo_afldo  , 0,
								0                        , @txto_cta                 , @txto_cpgo                 , @drcho,
								Null                     , @cnsctvo_cdgo_tpo_afldo   , @fcha_trnsmsn              , @obsrvcns,
								@mdlo                    , @hst_nme                  , @fcha                      , @orgn,
								@cnsctvo_cdgo_sde        , @cnsctvo_cdgo_csa_drcho   , @cnsctvo_prdcto_scrsl      , @smns_aflcn_ps,
								@smns_aflcn_antrr_eps_ps , @smns_aflcn_pc            , @smns_aflcn_antrr_eps_pc   , @smns_ctzds,
								@cnsctvo_cdgo_mtvo  
							)  
	        
					-- andres camelo (illustrato ltda)
					-- 08/04/2014
					-- registra los datos adicionales del log
					Insert Into	bdIPSIntegracion.dbo.tbDatosAdicionalesLog
							(	cnsctvo_cdgo_ofcna,			nmro_vrfccn,
								cnsctvo_cdgo_atrzcn_estdo,	cdgo_intrno_prstdr
							)
					Values	(	@cnsctvo_cdgo_ofcna,		@nmro_vrfcn,
								@cnsctvo_cdgo_atrzcn_estdo, @cdgo_intrno_ips
							)

					Commit Transaction
			End Try    
        
			Begin Catch
				If @@TRANCOUNT > 0 
					Begin
						Rollback Transaction			
					End
				 Else
					Begin
					   Insert Into		bdIPSIntegracion.dbo.tbConveniosLog
					   Select Distinct	@cnsctvo_cdgo_ofcna,		@nmro_vrfcn,		cdgo_cnvno,
										estdo_cptcn,				fcha_crte,			usro,
										@fcha,						cdgo_ips_cptcn
					   From				@tmpCapitacionContrato

					   Insert Into		bdIPSIntegracion.dbo.tbLogServicios
					   Select Distinct	@cnsctvo_cdgo_ofcna,		@nmro_vrfcn,		cdgo_itm_cptcn,
										accn,						@fcha,				cdgo_cnvno
					   From				@tmpItem
					End
			End Catch
		End	  
	Else    
		Begin  
			Select @nmro_vrfcn = ultmo_vlr
			From   bdSisalud.dbo.tbConsecutivosPorOficina With(NoLock)
			Where  cnsctvo_cdgo_cncpto = 19
			And    cnsctvo_cdgo_ofcna  = @cnsctvo_cdgo_ofcna
         
			If @nmro_vrfcn != 0  
				Begin  
					Update bdSisalud.dbo.tbConsecutivosPorOficina
					Set    ultmo_vlr			= @nmro_vrfcn + 1
					Where  cnsctvo_cdgo_cncpto	= 19
					And    cnsctvo_cdgo_ofcna	= @cnsctvo_cdgo_ofcna
				End  
			Else  
			   Begin  
				 Set @mensaje='Error Calculo Numero Validacion '+cast(@nmro_vrfcn as char(10)) + 'Consecutivo Oficina ' +cast(@cnsctvo_cdgo_ofcna as char(10))  
			   End  		   
		
			-- 20120119 - sismfg01 se quita esta validacion porque hace que no se presente error de primary y esta no es la forma de controlar la concurrencia  
			-- If not exists( select 1 from bdSisalud.dbo.tblog where  cnsctvo_cdgo_ofcna = @cnsctvo_cdgo_ofcna and nmro_vrfccn = @nmro_vrfcn )  
			Begin Try
				Begin Transaction
					Insert Into	bdSisalud.dbo.tblog
							(	cnsctvo_cdgo_ofcna      , nmro_vrfccn              , cdgo_usro                 , cnsctvo_cdgo_pln,
			  					fcha_vldcn              , cnsctvo_cdgo_tpo_cntrto  , nmro_cntrto               , cnsctvo_bnfcro,
								nmro_unco_idntfccn_afldo, cnsctvo_cdgo_tpo_idntfccn, nmro_idntfccn             , prmr_aplldo,
								sgndo_aplldo            , prmr_nmbre               , sgndo_nmbre               , fcha_ncmnto,
								edd                     , edd_mss                  , edd_ds                    , cnsctvo_cdgo_tpo_undd,
								cnsctvo_cdgo_sxo        , cnsctvo_cdgo_prntscs     , inco_vgnca_bnfcro         , fn_vgnca_bnfcro,
								cnsctvo_cdgo_rngo_slrl  , cdgo_ips_prmra           , nmro_unco_idntfccn_aprtnte, cnsctvo_tpo_idntfccn_aprtnte,
								nmro_idntfccn_aprtnte   , rzn_scl                  , cnsctvo_cdgo_pln_pc       , cptdo,
								cdgo_ips_cptcn          , nmro_atrzcn_espcl        , cnsctvo_cdgo_estdo_afldo  , ds_ctzds,
								ds_ctzds_pc             , txto_cta                 , txto_cpgo                 , drcho,
								cnslddo                 , cnsctvo_cdgo_tpo_afldo   , fcha_trnsmsn              , obsrvcns,
								mdlo                    , mqna                     , fcha_ultma_mdfccn         , orgn,
								cnsctvo_cdgo_sde        , cnsctvo_cdgo_csa_drcho   , cnsctvo_prdcto_scrsl      , smns_aflcn_ps,
								smns_aflcn_antrr_eps_ps , smns_aflcn_pc            , smns_aflcn_antrr_eps_pc   , smns_ctzds,
								cnsctvo_cdgo_mtvo  
							)  
					Values	(	@cnsctvo_cdgo_ofcna      , @nmro_vrfcn               , @cdgo_usro                 , @cnsctvo_cdgo_pln,
								@fcha                    , @cnsctvo_cdgo_tpo_cntrto  , @nmro_cntrto               , @cnsctvo_bnfcro,
								@nmro_unco_idntfccn_afldo, @cnsctvo_cdgo_tpo_idntfccn, @nmro_idntfccn             , @prmr_aplldo,
								@sgndo_aplldo            , @prmr_nmbre               , @sgndo_nmbre               , @fcha_ncmnto,
								@edd                     , @edd_mss                  , @edd_ds                    , @cnsctvo_cdgo_tpo_undd,
								@cnsctvo_cdgo_sxo        , @cnsctvo_cdgo_prntscs     , @inco_vgnca_bnfcro         , @fn_vgna_bnfcro,
								@cnsctvo_cdgo_rngo_slrl  , @cdgo_ips                 , @nmro_unco_idntfccn_aprtnte, @cnsctvo_cdgo_tpo_idntfccn_aprtnte,
								@nmro_idntfccn_aprtnte   , @rzn_scl                  , @cnsctvo_cdgo_pln_pac      , @cptdo,
								@cdgo_ips_cptcn          , @nmro_atrzcn_espcl        , @cnsctvo_cdgo_estdo_afldo  , 0,
								0                        , @txto_cta                 , @txto_cpgo                 , @drcho,
								Null                     , @cnsctvo_cdgo_tpo_afldo   , @fcha_trnsmsn              , @obsrvcns,
								@mdlo                    , @hst_nme                  , @fcha                      , @orgn,
								@cnsctvo_cdgo_sde        , @cnsctvo_cdgo_csa_drcho   , @cnsctvo_prdcto_scrsl      , @smns_aflcn_ps,
								@smns_aflcn_antrr_eps_ps , @smns_aflcn_pc            , @smns_aflcn_antrr_eps_pc   , @smns_ctzds,
								@cnsctvo_cdgo_mtvo
							)		
					
					-- Omar Granados -- 06/05/2014
					-- registra los datos adicionales del log
			  
					Insert Into	bdSiSalud.dbo.tbDatosAdicionalesLog
							(	cnsctvo_cdgo_ofcna,			nmro_vrfccn,
								cnsctvo_cdgo_atrzcn_estdo,	cdgo_intrno_prstdr
							)
					Values	(	@cnsctvo_cdgo_ofcna,		@nmro_vrfcn,
								@cnsctvo_cdgo_atrzcn_estdo,	@cdgo_intrno_ips
							)
			  
				Commit Transaction    
			End Try    
         
			Begin Catch
				If @@TRANCOUNT > 0 
					Begin
					Rollback Transaction
					End
				Else
					Begin
						Insert Into		bdSisalud.dbo.tbConveniosLog
						Select Distinct @cnsctvo_cdgo_ofcna,	@nmro_vrfcn,		cdgo_cnvno,
										estdo_cptcn,			fcha_crte,			usro,
										@fcha,					cdgo_ips_cptcn
						From			@tmpCapitacionContrato

						Insert Into		bdSisalud.dbo.tbLogServicios  
						Select Distinct @cnsctvo_cdgo_ofcna,	@nmro_vrfcn,		cdgo_itm_cptcn,
										accn,					@fcha,cdgo_cnvno
						From			@tmpItem
					End
			 End Catch
		End
  
	Set		@nmro_vrfcn_fnl = Cast(@nmro_vrfcn as varchar(20)) + '-' + Ltrim(rtrim(@cdgo_ofcna_lg))
	Select	@nmro_vrfcn as nmro_vrfcn,@ofcna_usro as ofcna_usro,@cdgo_ofcna_lg as cdgo_ofcna_lg

	Drop Table	#tmpCapitacionContrato
	Drop Table	#tmpCondicion
End


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorSipres] TO [310014 Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorSipres] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorSipres] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorSipres] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorSipres] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorSipres] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorSipres] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorSipres] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorSipres] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorSipres] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorSipres] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorSipres] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorSipres] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorSipres] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorSipres] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorSipres] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorSipres] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorSipres] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorSipres] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorSipres] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

