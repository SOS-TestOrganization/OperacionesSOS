/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
* Metodo o PRG                 :  spPminsertalogvalidadorCaja  
* Desarrollado por  :  <\A    Ing. Nilson Mossos Vivas        A\>  
* Descripcion    :  <\D    Guarda  validacion de un afiliado con los convenios e items de capitacion   D\>  
* Observaciones                 :  <\O   O\>  
* Parametros   :  <\P  Oficina del usuario        P\>  
*     :  <\P  Numero de Validacion (calculado)       P\>  
*     :  <\P  Oficina del Usuario          P\>  
*     :  <\P  Codigo del Usuario        P\>  
*     :  <\P  Plan del Afiliado        P\>  
*     :  <\P  Ips Primaria del Afiliado       P\>  
*     :  <\P  Tipo de Identificacion del Afiliado      P\>  
*     :  <\P  Numero de Identificacion del Afiliado      P\>  
*     :  <\P  Numero Unico de Identificacion del Afiliado     P\>  
*     :  <\P  Primer Apellido del Afiliado       P\>  
*     :  <\P  Segundo Apellido del Afiliado       P\>  
*     :  <\P  Primer Nombre del Afiliado       P\>  
*     :  <\P  Segundo Nombre del Afiliado       P\>  
*     :  <\P  Edad del Afiliado         P\>  
*     :  <\P  Tipo de Unidad de la edad del Afiliado      P\>  
*     :  <\P  Sexo del Afiliado        P\>  
*     :  <\P  Parentesco con el cotizante del Afiliado      P\>  
*     :  <\P  Inicio de Vigencia del Afiliado       P\>  
*     :  <\P  Fin de Vigencia del Afiliado       P\>  
*     :  <\P  Rango Salarial del Afiliado       P\>  
*     :  <\P  Tipo de Identificacion del Empleador       P\>  
*     :  <\P  Numero de Identificacion del Empleador       P\>  
*     :  <\P  NUI del Empleador         P\>  
*     :  <\P  Razon Social del Empleador        P\>  
*     :  <\P  Plan PAC del afiliado si lo tiene       P\>  
*     :  <\P  capitado          P\>  
*     :  <\P  Ips de capitacion         P\>  
*     :  <\P  Estado del Afiliado         P\>  
*     :  <\P  Dias Cotizados  POS        P\>  
*     :  <\P  Dias Cotizados  PAC        P\>  
*     :  <\P  Texto Cuota Moderadora       P\>  
*     :  <\P  Texto Copago          P\>  
*     :  <\P  Derecho         P\>  
*     :  <\P  Tipo de Afiliado         P\>  
*     :  <\P  Codigo del Modulo         P\>  
*     :  <\P  Tipo de contrato del afiliado       P\>  
*     :  <\P  Numero de contrato del afiliado       P\>  
*     :  <\P  Consecutivo del benficiario del afiliado      P\>  
*     :  <\P  Nombre de la tabla temporal de convenios      P\>  
*     :  <\P  Nombre de la tabla temporal de items       P\>  
*     :  <\P  Observaciones de la validacion        P\>  
*     :  <\P  Observaciones de la validacion        P\>  
*     :  <\P  Fecha de la Transmision        P\>  
*     :  <\P  Origen de los datos (SOS, Famisanar o Especial)     P\>  
*     :  <\P  Sede de la ips para pos y sede de la ciudad de residencia para PAC  P\>  
* Fecha Creacion  :  <\FC  2003/09/01         FC\>  
*    
*---------------------------------------------------------------------------------  
* DATOS DE MODIFICACION     
*---------------------------------------------------------------------------------    
* Modificado Por   : <\AM   AM\>  
* Descripcion    : <\DM   DM\>  
* Nuevos Parametros    : <\PM   PM\>  
* Nuevas Variables   : <\VM   VM\>  
* Fecha Modificacion   : <\FM   FM\>  
*---------------------------------------------------------------------------------*/  
/*  
Declare  
@numero_verificacion numeric(20,0),  
@usuario_oficina varchar(100),  
@codigo_oficina  char(5)  
Exec spPminsertalogvalidadorCaja '01',    --@cnsctvo_cdgo_ofcna  
    @numero_verificacion output, --@nmro_vrfcn  
    @usuario_oficina output, --@ofcna_usro  
    'sisnmv01',  --@cdgo_usro  
    1,   --@cnsctvo_cdgo_pln  
    '5',   --@cdgo_ips  
    1,   --@cnsctvo_cdgo_tpo_idntfccn  
    '94400802',  --@nmro_idntfccn  
    31793816,  --@nmro_unco_idntfccn_afldo  
    'LOPEZ',  --@prmr_aplldo  
    'ARBOLEDA',  --@sgndo_aplldo  
    'ALEXANDER',  --@prmr_nmbre  
    '',   --@sgndo_nmbre       30,   --@edd  
    4,   --@cnsctvo_cdgo_tpo_undd  
    2,   --@cnsctvo_cdgo_sxo  
    1,   --@cnsctvo_cdgo_prntscs  
    '1996/05/01',  --@inco_vgnca_bnfcro  
    '9999/12/31',  --@fn_vgna_bnfcro  
    1,   --@cnsctvo_cdgo_rngo_slrl  
    9,   --@cnsctvo_cdgo_tpo_idntfccn_aprtnte  
    '805001157',  --@nmro_idntfccn_aprtnte  
    100003,   --@nmro_unco_idntfccn_aprtnte  
    'SERVICIO OCCIDENTAL DE SALUD S.A.',--@rzn_scl  
    8,   --@cnsctvo_cdgo_pln_pac  
    ' ',   --@cptdo  
    '',   --@cdgo_ips_cptcn  
    1,   --@cnsctvo_cdgo_estdo_afldo  
    607,   --@ds_ctzds  
    607,   --@ds_ctzds_pc  
    '',   --@txto_cta  
    '',   --@txto_cpgo  
    'DERECHO A TODOS LOS SERVICIOS',--@drcho  
    1,   --@cnsctvo_cdgo_tpo_afldo  
    3100,   --@mdlo  
    1,   --@cnsctvo_cdgo_tpo_cntrto  
    '574',   --@nmro_cntrto  
    1,   --@cnsctvo_bnfcro  
    'PRUEBAS',  --@obsrvcns  
    '2004/10/01',  --@fcha_trnsmsn  
    'S',   --@orgn  
    2,   --@cnsctvo_cdgo_sde  
    0,   --@nmro_atrzcn_espcl  
    1,   --@cnsctvo_cdgo_csa_drcho  
    1,   --@cnsctvo_prdcto_scrsl  
    @codigo_oficina output --@cdgo_ofcna_lg  
  
print @numero_verificacion  
print @usuario_oficina  
print @codigo_oficina  
*/  
CREATE procedure spPminsertalogvalidadorCajaPruebas  
@cnsctvo_cdgo_ofcna   UdtConsecutivo,  
@nmro_vrfcn     numeric(20,0)  output,  
@ofcna_usro    varchar(100) output,  
@cdgo_usro    UdtUsuario,   
@cnsctvo_cdgo_pln   UdtConsecutivo,   
@cdgo_ips    UdtCodigoIps ,   
@cnsctvo_cdgo_tpo_idntfccn UdtConsecutivo,   
@nmro_idntfccn  UdtNumeroIdentificacion,   
@nmro_unco_idntfccn_afldo UdtConsecutivo,   
@prmr_aplldo   UdtApellido,   
@sgndo_aplldo   UdtApellido,  
@prmr_nmbre    UdtNombre,   
@sgndo_nmbre    UdtNombre,   
@edd     int,  
@cnsctvo_cdgo_tpo_undd  UdtConsecutivo,   
@cnsctvo_cdgo_sxo   UdtConsecutivo,   
@cnsctvo_cdgo_prntscs   UdtConsecutivo,   
@inco_vgnca_bnfcro  datetime  ,  
@fn_vgna_bnfcro  datetime  ,  
@cnsctvo_cdgo_rngo_slrl UdtConsecutivo,   
@cnsctvo_cdgo_tpo_idntfccn_aprtnte UdtConsecutivo,   
@nmro_idntfccn_aprtnte  UdtNumeroIdentificacion,   
@nmro_unco_idntfccn_aprtnte UdtConsecutivo,   
@rzn_scl   varchar(200),   
@cnsctvo_cdgo_pln_pac UdtConsecutivo,   
@cptdo    Udtlogico,  
@cdgo_ips_cptcn  UdtCodigoIps,  
@cnsctvo_cdgo_estdo_afldo UdtConsecutivo,   
@ds_ctzds   numeric,   
@ds_ctzds_pc   numeric,  
@txto_cta   varchar(50),     
@txto_cpgo   varchar(50),  
@drcho          udtDescripcion,  
@cnsctvo_cdgo_tpo_afldo UdtConsecutivo ,  
@mdlo    varchar(5),  
@cnsctvo_cdgo_tpo_cntrto UdtConsecutivo ,  
@nmro_cntrto   UdtNumeroFormulario,   
@cnsctvo_bnfcro  UdtConsecutivo ,   
--@archivoconvenios   varchar(50),   
--@archivoitems    varchar(50),  
@obsrvcns   UdtObservacion,  
@fcha_trnsmsn    datetime,  
@orgn     char(1),  
@cnsctvo_cdgo_sde  UdtConsecutivo,  
@nmro_atrzcn_espcl  UdtConsecutivo,  
@cnsctvo_cdgo_csa_drcho UdtConsecutivo,  
@cnsctvo_prdcto_scrsl  UdtConsecutivo,  
@cdgo_ofcna_lg   char(5) output  
AS  
  
Declare  
@cdgo_ofcna char(5)  
  
Select @cdgo_ofcna = cdgo_ofcna  
From tbOficinas  
Where cnsctvo_cdgo_ofcna = @cnsctvo_cdgo_ofcna  
  
  
Exec [Olympus].[bdPrestaMedicas].[dbo].spinsertalogvalidadorCaja  
  @cdgo_ofcna,  
  @nmro_vrfcn output,  
  @ofcna_usro output,  
  @cdgo_usro,   
  @cnsctvo_cdgo_pln,   
  @cdgo_ips,   
  @cnsctvo_cdgo_tpo_idntfccn,   
  @nmro_idntfccn,  
  @nmro_unco_idntfccn_afldo,  
  @prmr_aplldo,  
  @sgndo_aplldo,  
  @prmr_nmbre,  
  @sgndo_nmbre,  
  @edd,  
  @cnsctvo_cdgo_tpo_undd,  
  @cnsctvo_cdgo_sxo,  
  @cnsctvo_cdgo_prntscs,   
  @inco_vgnca_bnfcro,  
  @fn_vgna_bnfcro,  
  @cnsctvo_cdgo_rngo_slrl,  
  @cnsctvo_cdgo_tpo_idntfccn_aprtnte,   
  @nmro_idntfccn_aprtnte,   
  @nmro_unco_idntfccn_aprtnte,   
  @rzn_scl,   
  @cnsctvo_cdgo_pln_pac,   
  @cptdo,  
  @cdgo_ips_cptcn,  
  @cnsctvo_cdgo_estdo_afldo,   
  @ds_ctzds,   
  @ds_ctzds_pc,  
  @txto_cta,  
  @txto_cpgo,  
  @drcho,  
  @cnsctvo_cdgo_tpo_afldo,  
  @mdlo,  
  @cnsctvo_cdgo_tpo_cntrto,  
  @nmro_cntrto,   
  @cnsctvo_bnfcro,  
  'archivoconvenio',  
  'archivoItem',  
  @obsrvcns,  
  @fcha_trnsmsn,  
  @orgn,  
  @cnsctvo_cdgo_sde,  
  @nmro_atrzcn_espcl,  
  @cnsctvo_cdgo_csa_drcho,  
  @cnsctvo_prdcto_scrsl,  
  @cdgo_ofcna_lg output   
  
  
  
/*   
DECLARE  @fcha   datetime,  
  @consecutivo    int,  
       @fcha_datos   datetime,  
  @parametro  NVARCHAR(4000),  
  @variables  nvarchar(4000),  
  @instruccion  nvarchar(4000),  
  @hst_nme   varchar(50)  
  
set nocount on  
set dateformat ymd  
  
select @hst_nme = HOST_NAME ( )  
  
ALTER    table  #tmpCapitacionContrato (   
 dscrpcn_cnvno  UdtDescripcion null,   
 cdgo_cnvno  numeric null,   
-- estado   varchar(20) not null,   
 estdo_cptcn  UdtLogico not null,   
 usro    UdtUsuario,  
 fcha_crte  datetime null,   
 da_crte   int null,   
 fcha_dsde  datetime null,   
        fcha_hsta  datetime null,   
        cnsctvo_cdgo_mdlo_cptcn_extrccn UdtConsecutivo null,   
--        cdgo_mdlo_extrccn decimal null,   
      cdgo_cdd  char(8) null,  
        cdgo_ips_cptcn   char(8) null,  
--      dscrpcn_cdd  UdtDescripcion null,   
-- dscrpcn_ips  UdtDescripcion null,  
-- cnsctvo_cdgo_cdd UdtConsecutivo null,  
-- cnsctvo_cdgo_tpo_cntrto UdtConsecutivo,   
-- nmro_cntrto  UdtNumeroFormulario,   
-- cnsctvo_bnfcro  UdtConsecutivo,  
 fcha_fd   datetime  
 )  
  
  
Exec spPmConsultaDetConveniosCapitacionAfiliadoValidacion @cnsctvo_cdgo_tpo_cntrto,@nmro_unco_idntfccn_afldo,@fcha  
  
Update #tmpCapitacionContrato  
Set usro = @cdgo_usro  
  
  
ALTER  table #tmpItem  
( cdgo_cnvno numeric,   
 cdgo_itm_cptcn char(3),  
 accn varchar(20))  
  
  
Delete From #tmpCapitacionContrato  
Where cdgo_cnvno is Null  
  
Declare crCapitacionContrato Cursor For  
Select Distinct cdgo_cnvno,cdgo_cdd  
From #tmpCapitacionContrato  
--Where cdgo_cnvno is Not Null  
  
  
Declare  
@codigo_convenio numeric,  
@codigo_ciudad char(8)  
  
  
Open crCapitacionContrato  
  
Fetch Next From crCapitacionContrato  
Into @codigo_convenio, @codigo_ciudad  
  
create table #tmpCondicion  
( cdgo_tpo_escnro  UdtCodigo,   
 cdgo_itm_cptcn  char(3),  
 cndcn   varchar(1000),   
-- dscrpcn_itm_cptcn UdtDescripcion,  
 accion    varchar(30) )  
  
  
While @@FETCH_STATUS = 0  
Begin  
 Fetch Next From crCapitacionContrato  
 Into @codigo_convenio, @codigo_ciudad  
  
 Exec spPmValidaItemCapitados @codigo_convenio,@codigo_ciudad,@cnsctvo_cdgo_tpo_cntrto,@nmro_unco_idntfccn_afldo,@fcha  
  
 Insert into #tmpItem(  
  cdgo_cnvno,   
  cdgo_itm_cptcn,  
  accn    
 )  
 select @codigo_convenio,  
  cdgo_itm_cptcn,  
  accion  
 from #tmpCondicion  
  
 Delete From #tmpCondicion  
End  
  
Close crCapitacionContrato  
Deallocate crCapitacionContrato  
  
  
select   @ofcna_usro = dscrpcn_ofcna  , @cdgo_ofcna_lg = cdgo_ofcna  
from  tbOficinas   
where  cnsctvo_cdgo_ofcna = @cnsctvo_cdgo_ofcna  
  
SELECT @fcha  =  GETDATE()  
SELECT @nmro_vrfcn = 0  
  
--Ejecuto el procedimiento que selecciona el ultimo nuam  
exec bdSiSalud.dbo.spgeneraconsecutivoatencion @cnsctvo_cdgo_ofcna ,19, @nmro_vrfcn output  
  
if not exists( select * from bdSiSalud..tblog where  cnsctvo_cdgo_ofcna = @cnsctvo_cdgo_ofcna and nmro_vrfccn = @nmro_vrfcn )  
begin  
  
 BEGIN TRANSACTION  
  
-- select @fcha_datos=cast(SUBSTRING(rtrim(ltrim(@fcha_vldcn)),1,4)+SUBSTRING(rtrim(ltrim(@fcha_vldcn)),6,2) +SUBSTRING(rtrim(ltrim(@fcha_vldcn)),9,2) as datetime)  
  
 INSErt into BdSiSalud..tblog (  
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
 edd,  
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
 cnsctvo_prdcto_scrsl  
 )  
 values(  
 @cnsctvo_cdgo_ofcna   ,  
 @nmro_vrfcn     ,  
 @cdgo_usro    ,  
 @cnsctvo_cdgo_pln   ,  
 @fcha,  
 @cnsctvo_cdgo_tpo_cntrto ,  
 @nmro_cntrto   ,  
 @cnsctvo_bnfcro  ,  
 @nmro_unco_idntfccn_afldo ,  
 @cnsctvo_cdgo_tpo_idntfccn ,  
 @nmro_idntfccn  ,  
 @prmr_aplldo   ,  
 @sgndo_aplldo   ,  
 @prmr_nmbre    ,  
 @sgndo_nmbre    ,  
 @edd     ,  
 @cnsctvo_cdgo_tpo_undd  ,  
 @cnsctvo_cdgo_sxo   ,  
 @cnsctvo_cdgo_prntscs   ,  
 @inco_vgnca_bnfcro  ,  
 @fn_vgna_bnfcro  ,  
 @cnsctvo_cdgo_rngo_slrl ,  
 @cdgo_ips    ,  
 @nmro_unco_idntfccn_aprtnte ,  
 @cnsctvo_cdgo_tpo_idntfccn_aprtnte ,  
 @nmro_idntfccn_aprtnte ,  
 @rzn_scl   ,  
 @cnsctvo_cdgo_pln_pac ,  
 @cptdo    ,  
 @cdgo_ips_cptcn  ,   
 @nmro_atrzcn_espcl  ,  
 @cnsctvo_cdgo_estdo_afldo ,  
 @ds_ctzds  ,   
 @ds_ctzds_pc  ,   
 @txto_cta  ,   
 @txto_cpgo  ,   
 @drcho         ,   
 null,  
 @cnsctvo_cdgo_tpo_afldo ,  
 @fcha_trnsmsn ,  
 @obsrvcns,    
 @mdlo,  
 @hst_nme,  
 @fcha  ,  
 @orgn,  
 @cnsctvo_cdgo_sde,  
 @cnsctvo_cdgo_csa_drcho,  
 @cnsctvo_prdcto_scrsl  
 )  
  
 IF @@ERROR <> 0  
 Begin   
  ROLLBACK TRANSACTION  
  RETURN -1  
 End  
 ELSE  
     begin  
  --Actualizo Consecutivo  
  update  bdSiSalud..tbConsecutivosPorOficina  
  set  ultmo_vlr = @nmro_vrfcn + 1  
  where  cnsctvo_cdgo_cncpto = 19  
  and  cnsctvo_cdgo_ofcna = @cnsctvo_cdgo_ofcna  
  IF @@ERROR <> 0  
  Begin   
   ROLLBACK TRANSACTION  
   RETURN -1  
  End  
   
  --INSERTO LA TABLA TEMPORAL EN LA DEFINITIVA LOS CONVENIOS  
  set @variables=' @cnsctvo_cdgo_ofcna1 UdtConsecutivo,  @nmro_vrfcn1  numeric, @cdgo_usro1 UdtUsuario , @fcha1 datetime'  
  set @parametro='INSERT INTO BdSiSalud..tbConveniosLog  
                             select @cnsctvo_cdgo_ofcna1, @nmro_vrfcn1,  cdgo_cnvno, estdo_cptcn, fcha_crte, usro , @fcha1, cdgo_ips_cptcn  
    from #tmpCapitacionContrato'  
--    from ##tmp' + @archivoconvenios  
  
   exec sp_executesql @parametro, @variables, @cnsctvo_cdgo_ofcna1 = @cnsctvo_cdgo_ofcna,   @nmro_vrfcn1 =  @nmro_vrfcn, @cdgo_usro1 = @cdgo_usro, @fcha1 = @fcha  
  
  IF @@ERROR <> 0  
  Begin   
   ROLLBACK TRANSACTION  
   RETURN -1  
  End  
   
   set @instruccion='drop table #tmpCapitacionContrato'   
--   set @instruccion='drop table '+'##tmp'+@archivoconvenios   
  
   exec sp_executesql @instruccion  
   
  --INSERTO LA TABLA TEMPORAL EN LA DEFINITIVA LOS ITEMS DE CAPITACION POR CONVENIO  
  set @variables=' @cnsctvo_cdgo_ofcna1 UdtConsecutivo,  @nmro_vrfcn1  numeric, @fcha1 datetime'  
  set @parametro='INSERT INTO BdSiSalud..tbLogServicios  
                             select @cnsctvo_cdgo_ofcna1, @nmro_vrfcn1,  cdgo_itm_cptcn , accn , @fcha1 , cdgo_cnvno  
    from #tmpItem'  
--    from ##tmp' + @archivoitems  
  
   
   exec sp_executesql @parametro, @variables, @cnsctvo_cdgo_ofcna1 = @cnsctvo_cdgo_ofcna,   @nmro_vrfcn1 =  @nmro_vrfcn, @fcha1 = @fcha  
  IF @@ERROR <> 0  
  Begin   
   ROLLBACK TRANSACTION  
   RETURN -1  
  End  
  
   set @instruccion='drop table #tmpItem'  
--   set @instruccion='drop table '+'##tmp'+@archivoitems   
  
   exec sp_executesql @instruccion  
  
  IF @@ERROR <> 0  
   ROLLBACK TRANSACTION  
  ELSE  
   COMMIT TRANSACTION  
    end  
end  
  
*/  
Select @nmro_vrfcn as nmro_vrfcn,@ofcna_usro as ofcna_usro,@cdgo_ofcna_lg as cdgo_ofcna_lg  


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Auditor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Consultor Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Auditor Central Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Inteligencia]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Audiorespuesta]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Auxiliar de Glosas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Auxiliar Parametros Recobros PVS]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPminsertalogvalidadorCajaPruebas] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];

