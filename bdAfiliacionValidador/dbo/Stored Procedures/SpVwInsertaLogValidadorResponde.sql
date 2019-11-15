CREATE	procedure [dbo].[SpVwInsertaLogValidadorResponde]
@cnsctvo_cdgo_ofcna 		     UdtConsecutivo, 		--1
@nmro_vrfcn 	 		         numeric(20,0)  output,   --2
@ofcna_usro 			         varchar(100) output, --4
@cdgo_usro 			             UdtUsuario, --5
@cnsctvo_cdgo_pln 		         UdtConsecutivo, --6
@cdgo_ips 			             UdtCodigoIps	, --7
@cnsctvo_cdgo_tpo_idntfccn	     UdtConsecutivo, --8
@nmro_idntfccn			         UdtNumeroIdentificacion, --9
@nmro_unco_idntfccn_afldo	     UdtConsecutivo, --10
@prmr_aplldo			         UdtApellido, --11
@sgndo_aplldo			         UdtApellido, --12
@prmr_nmbre 			         UdtNombre, --13
@sgndo_nmbre 			         UdtNombre, --14
@fcha_ncmnto			         datetime, --15
@edd 				             int, --16
@edd_mss			             int, --17
@edd_ds			                 int, --18
@cnsctvo_cdgo_tpo_undd 	         UdtConsecutivo, --19
@cnsctvo_cdgo_sxo 		         UdtConsecutivo, --20
@cnsctvo_cdgo_prntscs 	         UdtConsecutivo, --21
@inco_vgnca_bnfcro		         datetime  , --22
@fn_vgna_bnfcro			         datetime, --23
@cnsctvo_cdgo_rngo_slrl          UdtConsecutivo, --24
@cnsctvo_cdgo_tpo_idntfccn_aprtnte	UdtConsecutivo, --25
@nmro_idntfccn_aprtnte		     UdtNumeroIdentificacion, --26
@nmro_unco_idntfccn_aprtnte      UdtConsecutivo, --27
@rzn_scl			             varchar(200), --28
@cnsctvo_cdgo_pln_pac	         UdtConsecutivo, --29
@cptdo				             Udtlogico, --30
@cdgo_ips_cptcn			         UdtCodigoIps, --31
@cnsctvo_cdgo_estdo_afldo	     UdtConsecutivo, --32
@smns_aflcn_ps			         numeric, --33
@smns_aflcn_antrr_eps_ps	     numeric, --34
@smns_aflcn_pc			         numeric, --35
@smns_aflcn_antrr_eps_pc	     numeric, --36
@smns_ctzds			             numeric, --37
@txto_cta			             varchar(50), --38
@txto_cpgo			             varchar(50), --39
@drcho	      			         udtDescripcion, --40
@cnsctvo_cdgo_tpo_afldo    	     UdtConsecutivo	, --41
@mdlo				             varchar(5), --42
@cnsctvo_cdgo_tpo_cntrto	     UdtConsecutivo	, --43
@nmro_cntrto			         UdtNumeroFormulario, --44
@cnsctvo_bnfcro			         UdtConsecutivo, --45
@obsrvcns			             UdtObservacion, --46
@fcha_trnsmsn 			         datetime, --47
@orgn 				             char(1), --48
@cnsctvo_cdgo_sde		         UdtConsecutivo, --49
@nmro_atrzcn_espcl		         UdtConsecutivo, --50
@cnsctvo_cdgo_csa_drcho	         UdtConsecutivo, --51
@cnsctvo_prdcto_scrsl		     UdtConsecutivo, --52
@cdgo_ofcna_lg 		             Varchar(5) output, --53
@cnsctvo_cdgo_mtvo		         int	= null, --54
@bno				             Int = null, --55
@nmro_dcmnto			         char(50) = null, --56
@CdoServBono			         Char(5) = null,  --57
@nmro_vrfcn_fnl		             Varchar(20) output,  		--Se crea nueva variable para la visualización de la oficina + el log --3 58
@cdgo_intrno_ips                 varchar(8),
@cnsctvo_ips_no_adscrta          int

AS
DECLARE @fcha			           datetime,
		@consecutivo  		       int,
	    @fcha_datos 		       datetime,
		@parametro		           NVARCHAR(4000),
		@variables		           nvarchar(4000), 
		@instruccion		       nvarchar(4000),
		@hst_nme 		           varchar(50),
		@mensaje                   varchar(2000),
        @cnsctvo_cdgo_atrzcn_estdo int

set nocount on
set dateformat ymd

Select	@hst_nme	=	Ltrim(Rtrim(Convert(Varchar(30), SERVERPROPERTY('machinename'))))
select	@fcha		= getdate() --se adiciona este select ya que no se esta calculando para la función
set  @cnsctvo_cdgo_atrzcn_estdo = 1 -- validado

Declare @tmpCapitacionContrato table(
dscrpcn_cnvno		varchar(150) null,
cdgo_cnvno		numeric null,
estdo_cptcn		char not null,
usro	 		char(30),
fcha_crte		datetime null,
da_crte			int null,
fcha_dsde		datetime null,
fcha_hsta		datetime null,
cnsctvo_cdgo_mdlo_cptcn_extrccn	int null,
cnsctvo_cdgo_cdd		char(8) null,
cdgo_ips_cptcn 		char(8) null,
fcha_fd			datetime
)

Declare @tmpItem table(  
 cdgo_cnvno numeric,  
 cdgo_itm_cptcn char(3),  
 accn varchar(20))  
 
Declare  
@codigo_convenio numeric,  
@codigo_ciudad char(8)  
  
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
 cdgo_cnvno numeric )  

 Create Table	#tmpCapitacionContrato
			(
				cdgo_cnvno			Numeric,
				cnsctvo_cdgo_cdd	Int
			)

begin try

	Insert Into		@tmpCapitacionContrato
	Select			dscrpcn_cnvno,		cdgo_cnvno,				estdo_cptcn,			usro,								fcha_crte,
					da_crte,			fcha_dsde,				fcha_hsta,				cnsctvo_cdgo_mdlo_cptcn_extrccn,	cnsctvo_cdgo_cdd,
					cdgo_ips_cptcn,		fcha_fd
	From			bdAfiliacionValidador.dbo.fnPmConsultaDetConveniosCapitacionAfiliadoValidacion(@cnsctvo_cdgo_tpo_cntrto, @nmro_unco_idntfccn_afldo, @fcha)

	Update	@tmpCapitacionContrato
	Set	usro	= @cdgo_usro

	--Declare @tmpItem table(
	--	cdgo_cnvno numeric,
	--	cdgo_itm_cptcn char(3),
	--	accn varchar(20))

	Delete	From	@tmpCapitacionContrato
	Where	cdgo_cnvno is Null

	Insert Into		#tmpCapitacionContrato
	Select Distinct	cdgo_cnvno,	cnsctvo_cdgo_cdd
	From			@tmpCapitacionContrato

	Exec			bdAfiliacionValidador.dbo.spPmValidaItemCapitados	@nmro_unco_idntfccn_afldo,	@cnsctvo_cdgo_tpo_cntrto,	@fcha

	--Declare
	--@codigo_convenio	numeric,
	--@codigo_ciudad	char(8)

	--Declare  @tmpCondicion table(
	--	cdgo_tpo_escnro 	char(3),
	--	cdgo_itm_cptcn		char(3),
	--	cndcn			varchar(1000),
	--	accion 			varchar(30)	)


	--Create   Table #tmpCondicion(
	--	cdgo_tpo_escnro 	char(3),
	--	cdgo_itm_cptcn		char(3),
	--	cndcn			varchar(1000),
	--	accion 			varchar(30)	)


	--Declare crCapitacionContrato Cursor For
	--Select	Distinct cdgo_cnvno,cnsctvo_cdgo_cdd
	--From	@tmpCapitacionContrato

	--Open crCapitacionContrato
	--Fetch crCapitacionContrato into @codigo_convenio, @codigo_ciudad

	--While @@FETCH_STATUS = 0
	--Begin

	--	delete From #tmpCondicion

	--	Exec spPmValidaItemCapitados @codigo_convenio,@codigo_ciudad,@cnsctvo_cdgo_tpo_cntrto,@nmro_unco_idntfccn_afldo,@fcha

	Insert Into	@tmpItem
		(		cdgo_cnvno,			cdgo_itm_cptcn,	accn
		)
	Select		cdgo_cnvno,	cdgo_itm_cptcn,	accion
	From		#tmpCondicion	With(NoLock)


	--	Delete From @tmpCondicion
		
	--	--nueva forma 2009/01/07
	--	Fetch crCapitacionContrato into @codigo_convenio, @codigo_ciudad


	--End

	--Close crCapitacionContrato
	--Deallocate crCapitacionContrato


	select  @ofcna_usro = dscrpcn_ofcna  , @cdgo_ofcna_lg = cdgo_ofcna
	from 	tbOficinas
	where 	cnsctvo_cdgo_ofcna = @cnsctvo_cdgo_ofcna

	Set @nmro_vrfcn	= 0

	begin tran


	--Ejecuto el procedimiento que selecciona el ultimo nuam
	--exec bdSiSalud.dbo.spgeneraconsecutivoatencion @cnsctvo_cdgo_ofcna ,19, @nmro_vrfcn output
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ

	If Exists(	Select	1
				From	bdAfiliacionValidador.dbo.tbtablaParametros  With(NoLock)
				Where	vlr_prmtro	= @hst_nme
		)
		Begin
			SELECT  @nmro_vrfcn=ultmo_vlr  
			FROM	bdIPSIntegracion.dbo.tbConsecutivosPorOficina	With(NoLock)
			where	cnsctvo_cdgo_cncpto=19  
			and		cnsctvo_cdgo_ofcna = @cnsctvo_cdgo_ofcna
			
			if @nmro_vrfcn!=0
				Begin
						update 	bdIPSIntegracion.dbo.tbConsecutivosPorOficina
						set 	ultmo_vlr	=	@nmro_vrfcn + 1
						where 	cnsctvo_cdgo_cncpto	=	19
						and 	cnsctvo_cdgo_ofcna = @cnsctvo_cdgo_ofcna

				End
			Else
				Begin
				set @mensaje='Error Calculo Numero Validacion '+cast(@nmro_vrfcn as char(10)) + 'Consecutivo Oficina ' +cast(@cnsctvo_cdgo_ofcna as char(10))
				End

						INSErt into bdIPSIntegracion.dbo.tblog(
						cnsctvo_cdgo_ofcna,			nmro_vrfccn,
						cdgo_usro,					cnsctvo_cdgo_pln,
						fcha_vldcn,					cnsctvo_cdgo_tpo_cntrto,
						nmro_cntrto,				cnsctvo_bnfcro,
						nmro_unco_idntfccn_afldo,	cnsctvo_cdgo_tpo_idntfccn,
						nmro_idntfccn,				prmr_aplldo,
						sgndo_aplldo,				prmr_nmbre,
						sgndo_nmbre,				fcha_ncmnto,
						edd,						edd_mss,
						edd_ds,						cnsctvo_cdgo_tpo_undd,
						cnsctvo_cdgo_sxo,			cnsctvo_cdgo_prntscs,
						inco_vgnca_bnfcro,			fn_vgnca_bnfcro,
						cnsctvo_cdgo_rngo_slrl,		cdgo_ips_prmra,
						nmro_unco_idntfccn_aprtnte,	cnsctvo_tpo_idntfccn_aprtnte,
						nmro_idntfccn_aprtnte,		rzn_scl,
						cnsctvo_cdgo_pln_pc,		cptdo,
						cdgo_ips_cptcn,				nmro_atrzcn_espcl,
						cnsctvo_cdgo_estdo_afldo,	ds_ctzds,
						ds_ctzds_pc,				txto_cta,
						txto_cpgo,					drcho,
						cnslddo,					cnsctvo_cdgo_tpo_afldo,
						fcha_trnsmsn,				obsrvcns,
						mdlo,						mqna,
						fcha_ultma_mdfccn,			orgn,
						cnsctvo_cdgo_sde,			cnsctvo_cdgo_csa_drcho,
						cnsctvo_prdcto_scrsl,		smns_aflcn_ps,
						smns_aflcn_antrr_eps_ps,	smns_aflcn_pc,
						smns_aflcn_antrr_eps_pc,	smns_ctzds,
						cnsctvo_cdgo_mtvo		)
						values(
						@cnsctvo_cdgo_ofcna 	,	@nmro_vrfcn 	 		,
						@cdgo_usro 				,	@cnsctvo_cdgo_pln 		,
						@fcha					,	@cnsctvo_cdgo_tpo_cntrto	,
						@nmro_cntrto			,	@cnsctvo_bnfcro		,
						@nmro_unco_idntfccn_afldo	,	@cnsctvo_cdgo_tpo_idntfccn	,
						@nmro_idntfccn				,	@prmr_aplldo			,
						@sgndo_aplldo				,	@prmr_nmbre 			,
						@sgndo_nmbre 				,	@fcha_ncmnto			,
						@edd						,	@edd_mss			,
						@edd_ds						,	@cnsctvo_cdgo_tpo_undd		,
						@cnsctvo_cdgo_sxo 			,	@cnsctvo_cdgo_prntscs 		,
						@inco_vgnca_bnfcro			,	@fn_vgna_bnfcro		,
						@cnsctvo_cdgo_rngo_slrl		,	@cdgo_ips 			,
						@nmro_unco_idntfccn_aprtnte	,	@cnsctvo_cdgo_tpo_idntfccn_aprtnte	,
						@nmro_idntfccn_aprtnte		,	@rzn_scl			,
						@cnsctvo_cdgo_pln_pac		,	@cptdo				,
						@cdgo_ips_cptcn				,	@nmro_atrzcn_espcl		,
						@cnsctvo_cdgo_estdo_afldo	,	0			,
						0			,					@txto_cta		,
						@txto_cpgo		,				@drcho	      		,
						null,							@cnsctvo_cdgo_tpo_afldo	,
						@fcha_trnsmsn ,					@obsrvcns,
						@mdlo,							@hst_nme,
						@fcha 	,						@orgn,
						@cnsctvo_cdgo_sde,				@cnsctvo_cdgo_csa_drcho,
						@cnsctvo_prdcto_scrsl,			@smns_aflcn_ps,
						@smns_aflcn_antrr_eps_ps,		@smns_aflcn_pc,
						@smns_aflcn_antrr_eps_pc,		@smns_ctzds,
						@cnsctvo_cdgo_mtvo		)



							INSERT INTO bdIPSIntegracion.dbo.tbConveniosLog
								select distinct @cnsctvo_cdgo_ofcna, @nmro_vrfcn,  cdgo_cnvno, estdo_cptcn, fcha_crte, usro , @fcha, cdgo_ips_cptcn
							from @tmpCapitacionContrato


							Insert Into bdIPSIntegracion.dbo.tbLogServicios
							Select	distinct @cnsctvo_cdgo_ofcna,@nmro_vrfcn,cdgo_itm_cptcn,accn,@fcha,cdgo_cnvno
							from @tmpItem


                       -- registra los datos adicionales del log
						INSERT INTO [bdIPSIntegracion].[dbo].[tbDatosAdicionalesLog]
								   ([cnsctvo_cdgo_ofcna]
								   ,[nmro_vrfccn]
								   ,[cnsctvo_cdgo_atrzcn_estdo]
								   ,[cdgo_intrno_prstdr]
								   ,[cnsctvo_ips_no_adscrta])
						 VALUES
								   (@cnsctvo_cdgo_ofcna
								   ,@nmro_vrfcn
								   ,@cnsctvo_cdgo_atrzcn_estdo
								   ,@cdgo_intrno_ips
								   ,@cnsctvo_ips_no_adscrta)


		end

	Set @nmro_vrfcn_fnl = Cast(@nmro_vrfcn as varchar(20)) + '-' + Ltrim(rtrim(@cdgo_ofcna_lg))

	Select	@nmro_vrfcn as nmro_vrfcn,@ofcna_usro as ofcna_usro,@cdgo_ofcna_lg as cdgo_ofcna_lg



	if @@error = 0
		commit tran


END TRY
BEGIN CATCH

 SET @mensaje = 'Error en insertando el log Responde ' + ERROR_MESSAGE()
 RAISERROR (@mensaje, 16, 2) WITH SETERROR
rollback tran
RETURN
END CATCH;

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpVwInsertaLogValidadorResponde] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpVwInsertaLogValidadorResponde] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpVwInsertaLogValidadorResponde] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];

