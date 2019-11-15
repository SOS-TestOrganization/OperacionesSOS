CREATE PROCEDURE [dbo].[SpVwGenerarValidacionNormal]
@cnsctvo_cdgo_ofcna   UdtConsecutivo,   --1  
@nmro_vrfcn     NUMERIC(20,0)  OUTPUT,   --2  
@ofcna_usro    VARCHAR(100) OUTPUT, --4  
@cdgo_usro    UdtUsuario, --5  
@cnsctvo_cdgo_pln   UdtConsecutivo, --6  
@cdgo_ips    UdtCodigoIps , --7  
@cnsctvo_cdgo_tpo_idntfccn UdtConsecutivo, --8  
@nmro_idntfccn   UdtNumeroIdentificacion, --9  
@nmro_unco_idntfccn_afldo UdtConsecutivo, --10  
@prmr_aplldo   UdtApellido, --11  
@sgndo_aplldo   UdtApellido, --12  
@prmr_nmbre    UdtNombre, --13  
@sgndo_nmbre    UdtNombre, --14  
@fcha_ncmnto   DATETIME, --15  
@edd     INT, --16  
@edd_mss   INT, --17  
@edd_ds   INT, --18  
@cnsctvo_cdgo_tpo_undd  UdtConsecutivo, --19  
@cnsctvo_cdgo_sxo   UdtConsecutivo, --20  
@cnsctvo_cdgo_prntscs  UdtConsecutivo, --21  
@inco_vgnca_bnfcro  DATETIME  , --22  
@fn_vgna_bnfcro   DATETIME, --23  
@cnsctvo_cdgo_rngo_slrl UdtConsecutivo, --24  
@cnsctvo_cdgo_tpo_idntfccn_aprtnte UdtConsecutivo, --25  
@nmro_idntfccn_aprtnte  UdtNumeroIdentificacion, --26  
@nmro_unco_idntfccn_aprtnte UdtConsecutivo, --27  
@rzn_scl   VARCHAR(200), --28  
@cnsctvo_cdgo_pln_pac UdtConsecutivo, --29  
@cptdo    Udtlogico, --30  
@cdgo_ips_cptcn   UdtCodigoIps, --31  
@cnsctvo_cdgo_estdo_afldo UdtConsecutivo, --32  
@smns_aflcn_ps   NUMERIC, --33  
@smns_aflcn_antrr_eps_ps NUMERIC, --34  
@smns_aflcn_pc   NUMERIC, --35  
@smns_aflcn_antrr_eps_pc NUMERIC, --36  
@smns_ctzds   NUMERIC, --37  
@txto_cta   VARCHAR(50), --38  
@txto_cpgo   VARCHAR(50), --39  
@drcho          udtDescripcion, --40  
@cnsctvo_cdgo_tpo_afldo UdtConsecutivo , --41  
@mdlo    VARCHAR(5), --42  
@cnsctvo_cdgo_tpo_cntrto UdtConsecutivo , --43  
@nmro_cntrto   UdtNumeroFormulario, --44  
@cnsctvo_bnfcro   UdtConsecutivo, --45  
@obsrvcns   UdtObservacion, --46  
@fcha_trnsmsn    DATETIME, --47  
@orgn     CHAR(1), --48  
@cnsctvo_cdgo_sde  UdtConsecutivo, --49  
@nmro_atrzcn_espcl  UdtConsecutivo, --50  
@cnsctvo_cdgo_csa_drcho UdtConsecutivo, --51  
@cnsctvo_prdcto_scrsl  UdtConsecutivo, --52  
@cdgo_ofcna_lg   VARCHAR(5) OUTPUT, --53  
@cnsctvo_cdgo_mtvo  INT = NULL, --54  
@bno    INT = NULL, --55  
@nmro_dcmnto   CHAR(50) = NULL, --56  
@CdoServBono   CHAR(5) = NULL,  --57  
@nmro_vrfcn_fnl  VARCHAR(20) OUTPUT    --Se crea nueva variable para la visualización de la oficina + el log --3 58  
AS  

DECLARE  @fcha                       datetime,  
         @consecutivo                int,  
         @fcha_datos                 datetime,  
		 @parametro                  NVARCHAR(4000),  
		 @variables                  nvarchar(4000),   
		 @instruccion                nvarchar(4000),  
		 @hst_nme                    varchar(50),  
		 @mensaje                    varchar(2000),
		 @cdgo_intrno_ips            char(8),
		 @cnsctvo_cdgo_atrzcn_estdo  int
		  
  
  
set nocount on  
set dateformat ymd  
set @cnsctvo_cdgo_atrzcn_estdo = 1 -- validado
  
Select	@hst_nme	=	Ltrim(Rtrim(Convert(Varchar(30), SERVERPROPERTY('machinename'))))
select	@fcha		=	getdate() --se adiciona este select ya que no se esta calculando para la función  
  
Declare @tmpCapitacionContrato table(  
dscrpcn_cnvno  varchar(150) null,  
cdgo_cnvno  numeric null,  
estdo_cptcn  char not null,  
usro    char(30),  
fcha_crte  datetime null,  
da_crte   int null,  
fcha_dsde  datetime null,  
fcha_hsta  datetime null,  
cnsctvo_cdgo_mdlo_cptcn_extrccn int null,  
cnsctvo_cdgo_cdd  char(8) null,  
cdgo_ips_cptcn   char(8) null,  
fcha_fd   datetime  
)  
  
Declare @tmpItem table(  
 cdgo_cnvno numeric,  
 cdgo_itm_cptcn char(3),  
 accn varchar(20))  
  
Delete From @tmpCapitacionContrato  
Where cdgo_cnvno is Null  
  
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
 cdgo_cnvno numeric
  )  

 Create Table	#tmpCapitacionContrato
			(
				cdgo_cnvno			Numeric,
				cnsctvo_cdgo_cdd	Int
			)

Insert Into		@tmpCapitacionContrato
Select			dscrpcn_cnvno,		cdgo_cnvno,				estdo_cptcn,			usro,								fcha_crte,
				da_crte,			fcha_dsde,				fcha_hsta,				cnsctvo_cdgo_mdlo_cptcn_extrccn,	cnsctvo_cdgo_cdd,
				cdgo_ips_cptcn,		fcha_fd
From			bdAfiliacionValidador.dbo.fnPmConsultaDetConveniosCapitacionAfiliadoValidacion(@cnsctvo_cdgo_tpo_cntrto, @nmro_unco_idntfccn_afldo, @fcha)
  
Update			@tmpCapitacionContrato  
Set				usro = @cdgo_usro  

Delete
From			@tmpCapitacionContrato  
Where			cdgo_cnvno Is Null  

Insert Into		#tmpCapitacionContrato
Select Distinct	cdgo_cnvno,	cnsctvo_cdgo_cdd
From			@tmpCapitacionContrato

Exec			bdAfiliacionValidador.dbo.spPmValidaItemCapitados	@nmro_unco_idntfccn_afldo,	@cnsctvo_cdgo_tpo_cntrto,	@fcha
  
--Declare crCapitacionContrato Cursor For  
--Select Distinct cdgo_cnvno,cnsctvo_cdgo_cdd  
--From @tmpCapitacionContrato  
  
--Open crCapitacionContrato  
--Fetch crCapitacionContrato into @codigo_convenio, @codigo_ciudad  
  
--While @@FETCH_STATUS = 0  
--Begin  
--	Exec spPmValidaItemCapitados @codigo_convenio,@codigo_ciudad,@cnsctvo_cdgo_tpo_cntrto,@nmro_unco_idntfccn_afldo,@fcha  
  
	Insert Into	@tmpItem
		(		cdgo_cnvno,		cdgo_itm_cptcn,	accn
		)
	Select		cdgo_cnvno,		cdgo_itm_cptcn,	accion
	From		#tmpCondicion	With(NoLock)
  
 --Insert into @tmpItem(  
 -- cdgo_cnvno,  
 -- cdgo_itm_cptcn,  
 -- accn  
 --)  
 --select @codigo_convenio,  
 -- cdgo_itm_cptcn,  
 -- accion  
 --from #tmpCondicion  
  
  
 --Delete From @tmpCondicion  
   
 --nueva forma 2009/01/07  
-- Fetch crCapitacionContrato into @codigo_convenio, @codigo_ciudad  
  
--End  
  
--Close crCapitacionContrato  
--Deallocate crCapitacionContrato  
  
select  @ofcna_usro		=	dscrpcn_ofcna,
		@cdgo_ofcna_lg	=	cdgo_ofcna
from	bdAfiliacionValidador.dbo.tbOficinas With(NoLock)  
where  cnsctvo_cdgo_ofcna = @cnsctvo_cdgo_ofcna  
  
Set		@nmro_vrfcn = 0  


-- andres camelo (illustrato ltda)
-- 08/04/2014
-- consulta el codigo interno del prestador
	SELECT	@cdgo_intrno_ips = cdgo_intrno 
	FROM	bdSeguridad.dbo.tbUsuariosWeb  with (nolock)
	WHERE	lgn_usro = @cdgo_usro

	IF (@cdgo_intrno_ips IS NULL)
		BEGIN
			SET @mensaje = ' El "Codigo Interno de IPS" para el usuario '+rtrim(ltrim(@cdgo_usro))+' no se puede calcular'
			RAISERROR (@mensaje, 16, 2) WITH SETERROR
			RETURN
		END

--Ejecuto el procedimiento que selecciona el ultimo nuam  
--exec bdSiSalud.dbo.spgeneraconsecutivoatencion @cnsctvo_cdgo_ofcna ,19, @nmro_vrfcn output  
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ  
  
--If (Select ltrim(rtrim(vlr_prmtro))  
-- From dbo.tbtablaParametros  
-- Where cnsctvo_prmtro in (4)) = ltrim(rtrim(CONVERT(varchar(30), SERVERPROPERTY('machinename')))) -- atenea  
    
-- or  
  
-- (Select ltrim(rtrim(vlr_prmtro))  
-- From dbo.tbtablaParametros  
-- Where cnsctvo_prmtro in (5)) = ltrim(rtrim(CONVERT(varchar(30), SERVERPROPERTY('machinename')))) -- temis  
  
-- begin  
IF EXISTS(	SELECT	1
			FROM	bdAfiliacionValidador.dbo.tbtablaParametros  WITH(NOLOCK)
			WHERE	vlr_prmtro	= @hst_nme
		)
	BEGIN
		SELECT	@nmro_vrfcn=ultmo_vlr    
		FROM	bdIPSIntegracion.dbo.tbConsecutivosPorOficina	With(NoLock)
		where	cnsctvo_cdgo_cncpto=19    
		and		cnsctvo_cdgo_ofcna = @cnsctvo_cdgo_ofcna  
    
		if @nmro_vrfcn!=0  
			Begin  
				update  bdIPSIntegracion.dbo.tbConsecutivosPorOficina
				set		ultmo_vlr = @nmro_vrfcn + 1
				where	cnsctvo_cdgo_cncpto = 19
				and		cnsctvo_cdgo_ofcna = @cnsctvo_cdgo_ofcna
			End  
		ELSE  
			BEGIN  
				SET	@mensaje='Error Calculo Numero Validacion '+CAST(@nmro_vrfcn AS CHAR(10)) + 'Consecutivo Oficina ' +CAST(@cnsctvo_cdgo_ofcna AS CHAR(10))
			END  
  
		INSERT INTO bdIPSIntegracion.dbo.tblog(  
		cnsctvo_cdgo_ofcna,   nmro_vrfccn,  
		cdgo_usro,     cnsctvo_cdgo_pln,  
		fcha_vldcn,     cnsctvo_cdgo_tpo_cntrto,  
		nmro_cntrto,    cnsctvo_bnfcro,  
		nmro_unco_idntfccn_afldo, cnsctvo_cdgo_tpo_idntfccn,  
		nmro_idntfccn,    prmr_aplldo,  
		sgndo_aplldo,    prmr_nmbre,  
		sgndo_nmbre,    fcha_ncmnto,  
		edd,      edd_mss,  
		edd_ds,      cnsctvo_cdgo_tpo_undd,  
		cnsctvo_cdgo_sxo,   cnsctvo_cdgo_prntscs,  
		inco_vgnca_bnfcro,   fn_vgnca_bnfcro,  
		cnsctvo_cdgo_rngo_slrl,  cdgo_ips_prmra,  
		nmro_unco_idntfccn_aprtnte, cnsctvo_tpo_idntfccn_aprtnte,  
		nmro_idntfccn_aprtnte,  rzn_scl,  
		cnsctvo_cdgo_pln_pc,  cptdo,  
		cdgo_ips_cptcn,    nmro_atrzcn_espcl,  
		cnsctvo_cdgo_estdo_afldo, ds_ctzds,  
		ds_ctzds_pc,    txto_cta,  
		txto_cpgo,     drcho,  
		cnslddo,     cnsctvo_cdgo_tpo_afldo,  
		fcha_trnsmsn,    obsrvcns,  
		mdlo,      mqna,  
		fcha_ultma_mdfccn,   orgn,  
		cnsctvo_cdgo_sde,   cnsctvo_cdgo_csa_drcho,  
		cnsctvo_prdcto_scrsl,  smns_aflcn_ps,  
		smns_aflcn_antrr_eps_ps, smns_aflcn_pc,  
		smns_aflcn_antrr_eps_pc, smns_ctzds,  
		cnsctvo_cdgo_mtvo  )  
		VALUES(  
		@cnsctvo_cdgo_ofcna  , @nmro_vrfcn     ,      @cdgo_usro     , @cnsctvo_cdgo_pln   ,  
		@fcha     , @cnsctvo_cdgo_tpo_cntrto ,  
		@nmro_cntrto   , @cnsctvo_bnfcro  ,  
		@nmro_unco_idntfccn_afldo , @cnsctvo_cdgo_tpo_idntfccn ,  
		@nmro_idntfccn    , @prmr_aplldo   ,  
		@sgndo_aplldo    , @prmr_nmbre    ,  
		@sgndo_nmbre     , @fcha_ncmnto   ,  
		@edd      , @edd_mss   ,  
		@edd_ds      , @cnsctvo_cdgo_tpo_undd  ,  
		@cnsctvo_cdgo_sxo    , @cnsctvo_cdgo_prntscs   ,  
		@inco_vgnca_bnfcro   , @fn_vgna_bnfcro  ,  
		@cnsctvo_cdgo_rngo_slrl  , @cdgo_ips    ,  
		@nmro_unco_idntfccn_aprtnte , @cnsctvo_cdgo_tpo_idntfccn_aprtnte ,  
		@nmro_idntfccn_aprtnte  , @rzn_scl   ,  
		@cnsctvo_cdgo_pln_pac  , @cptdo    ,  
		@cdgo_ips_cptcn    , @nmro_atrzcn_espcl  ,  
		@cnsctvo_cdgo_estdo_afldo , 0   ,  
		0   ,     @txto_cta  ,  
		@txto_cpgo  ,    @drcho         ,  
		NULL,       @cnsctvo_cdgo_tpo_afldo ,  
		@fcha_trnsmsn ,     @obsrvcns,  
		@mdlo,       @hst_nme,  
		@fcha  ,      @orgn,  
		@cnsctvo_cdgo_sde,    @cnsctvo_cdgo_csa_drcho,  
		@cnsctvo_prdcto_scrsl,   @smns_aflcn_ps,  
		@smns_aflcn_antrr_eps_ps,  @smns_aflcn_pc,  
		@smns_aflcn_antrr_eps_pc,  @smns_ctzds,  
		@cnsctvo_cdgo_mtvo  )  
  
		INSERT INTO bdIPSIntegracion.dbo.tbConveniosLog  
		SELECT DISTINCT @cnsctvo_cdgo_ofcna, @nmro_vrfcn,  cdgo_cnvno, estdo_cptcn, fcha_crte, usro , @fcha, cdgo_ips_cptcn  
		FROM @tmpCapitacionContrato  
    
		INSERT INTO bdIPSIntegracion.dbo.tbLogServicios  
		SELECT DISTINCT @cnsctvo_cdgo_ofcna,@nmro_vrfcn,cdgo_itm_cptcn,accn,@fcha,cdgo_cnvno  
		FROM @tmpItem  
  
		-- andres camelo (illustrato ltda)
		-- 08/04/2014
		-- registra los datos adicionales del log
		INSERT INTO [bdIPSIntegracion].[dbo].[tbDatosAdicionalesLog]
		([cnsctvo_cdgo_ofcna]
		,[nmro_vrfccn]
		,[cnsctvo_cdgo_atrzcn_estdo]
		,[cdgo_intrno_prstdr])
		VALUES
		(@cnsctvo_cdgo_ofcna
		,@nmro_vrfcn
		,@cnsctvo_cdgo_atrzcn_estdo
		,@cdgo_intrno_ips
		)
	END  
  
SET		@nmro_vrfcn_fnl = CAST(@nmro_vrfcn AS VARCHAR(20)) + '-' + LTRIM(RTRIM(@cdgo_ofcna_lg))
SELECT	@nmro_vrfcn AS nmro_vrfcn,@ofcna_usro AS ofcna_usro,@cdgo_ofcna_lg AS cdgo_ofcna_lg


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpVwGenerarValidacionNormal] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpVwGenerarValidacionNormal] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpVwGenerarValidacionNormal] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpVwGenerarValidacionNormal] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[SpVwGenerarValidacionNormal] TO [webusr]
    AS [dbo];

