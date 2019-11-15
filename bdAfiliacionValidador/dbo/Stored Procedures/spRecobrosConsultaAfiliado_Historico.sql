/*---------------------------------------------------------------------------------------------------------------------------------------  
* Procedimiento   : spPmConsultaAfiliado_Historico   
* Desarrollado por  : <\A Ing. Álvaro Zapaya      A\>  
* Descripción   : <\D      Cuando el afiliado no es encontrado en la fecha de consulta, se consulta con la ultima fecha del contrato   D\>  
* Observaciones   : <\O         O\>  
* Parámetros   : <\P           P\>  
* Variables   : <\V           V\>  
* Fecha Creación  : <\FC 2003/00/00         FC\>  
*  
*---------------------------------------------------------------------------------------------------------------------------------------  
* DATOS DE MODIFICACION   
*---------------------------------------------------------------------------------------------------------------------------------------  
* Modificado Por   : <\AM     *     AM\>  
* Descripción   : <\DM         DM\>  
*     : <\DM         DM\>  
* Nuevos Parámetros  : <\PM         >  
* Nuevas Variables  : <\VM           VM\>  
* Fecha Modificación  : <\FM         FM\>  
*-----------------------------------------------------------------------------------------------------------------------------------*/  
/*  
Declare  
@m varchar(80),  
@f datetime  
--Exec spPmConsultaAfiliado_Historico 1,'16686026',1,'2004/04/21',@m,@f  
Exec spPmConsultaAfiliado_Historico 1,'18506151',1,'2004/05/21',@m,@f  
print @m  
print @f  
*/  
CREATE procedure spRecobrosConsultaAfiliado_Historico
--Declare
@cnsctvo_cdgo_tpo_idntfccn  udtConsecutivo,   
@nmro_idntfccn   Varchar(23),  --udtNumeroIdentificacion,  
@cnsctvo_cdgo_pln   udtConsecutivo,   
@fcha_vldccn   datetime   = NULL,  
@mnsje    varchar(80)  output,  
@lfFechaReferencia  datetime output  
AS  

/*Set	@cnsctvo_cdgo_tpo_idntfccn	= 1 
Set	@nmro_idntfccn			= '79429148'
Set	@cnsctvo_cdgo_pln   		= 1
Set	@fcha_vldccn   			= '20070906'
Set	@mnsje    			= ''
Set	@lfFechaReferencia  		= ''
*/

Set NoCount On  
-- Declaración de variables  
Declare  
@Nui_Afldo  UdtConsecutivo,  
@Bd    char(1),  
@inco_vgnca_bnfcro Datetime,  
@fcha_ultma_mdfccn Datetime,   
--@lfFechaReferencia datetime,  
@dFcha_pvte  datetime,  
@Historico  char(1)  
  
Set @Bd = null  
  
  
IF @Bd Is Null  
If Exists (Select 1 from bdAfiliacionValidador.DBO.tbBeneficiariosValidador a, bdAfiliacionValidador.DBO.tbContratosValidador b  
  Where a.cnsctvo_cdgo_tpo_idntfccn = @cnsctvo_cdgo_tpo_idntfccn  
  And a.nmro_idntfccn   = @nmro_idntfccn  
  And b.cnsctvo_cdgo_pln  = @cnsctvo_cdgo_pln  
  And a.nmro_cntrto   = b.nmro_cntrto  
  And a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto  
--  And @fcha_vldccn Between a.inco_vgnca_bnfcro And a.fn_vgnca_bnfcro  
  )  
 Begin  
  Select @Bd  = '1'  -- Contratos  
  Select @mnsje  = 'CONTRATOS HISTORICOS'  
 End  
Else  
  
 If Exists (Select 1 From bdAfiliacionValidador.dbo.tbBeneficiariosFormularioValidador a   
     Where a.cnsctvo_tpo_idntfccn_bnfcro  = @cnsctvo_cdgo_tpo_idntfccn    
     And   a.nmro_idntfccn_bnfcro  = @nmro_idntfccn )  
   
   Begin  
    Select @bd  = '2'  --Formularios  
    set @mnsje = 'FORMULARIOS'  
   End  
 ELSE  
  
 If Exists (Select 1   
   From  bdSisalud.dbo.tbEapb a   
   Where  a.cnsctvo_cdgo_tpo_idntfccn_bnfcro = @cnsctvo_cdgo_tpo_idntfccn    
   And  a.nmro_idntfccn_bnfcro    = @nmro_idntfccn  
   And a.cnsctvo_cdgo_pln   = @cnsctvo_cdgo_pln   
   )  
   Begin  
    Select @Bd = '3'  -- Famisanar  
    Select @mnsje  = 'FAMISANAR'  
   End  
 Else  
 Begin  
  Select @Bd = '4'  -- Ninguna  
  Select @mnsje  = 'No existe en el Sistema'  
 End  
ELSE   
Begin  
Select @mnsje  = Case @bd   
   When '1' Then 'CONTRATOS'  
   When '2' Then 'FORMULARIOS'  
   When '3' Then 'FAMISANAR'  
   When '4' Then 'NO EXISTE EN EL SISTEMA'  
     End  
End  
  
  
Declare   
@tb_tmpAfiliado Table (  
 prmr_aplldo   char(50),  sgndo_aplldo   char(50),    
 prmr_nmbre   char(20),  sgndo_nmbre   char(20),    
 cnsctvo_cdgo_tpo_idntfccn int,   nmro_idntfccn   varchar(23),  
 fcha_ncmnto   datetime,  cnsctvo_cdgo_sxo  int,  
 cdgo_sxo   char(2),  edd     int,  
 edd_mss    int,   edd_ds     int,  
 cnsctvo_cdgo_tpo_undd  int,   orgn    char(1),  
 cnsctvo_cdgo_tpo_cntrto  int,  
 nmro_cntrto   char(15),  cnsctvo_cdgo_pln  int,  
 nmro_unco_idntfccn_afldo int,   inco_vgnca_bnfcro  datetime,    
 fn_vgnca_bnfcro   datetime,  
 cnsctvo_cdgo_prntsco  int,   dscrpcn_prntsco   varchar(150),  
 cnsctvo_cdgo_tpo_afldo   int,    dscrpcn_tpo_afldo  varchar(150),  
 cnsctvo_cdgo_rngo_slrl   int,   dscrpcn_rngo_slrl   varchar(150),    
 cnsctvo_cdgo_pln_pc  int,   dscrpcn_pln_pc   varchar(150),    
 smns_ctzds_ss_ps  int,   smns_ctzds_eps_ps  int,  
 smns_ctzds_ss_pc  int,   smns_ctzds_eps_pc  int,     
 cdgo_ips_prmra   char(8),  dscrpcn_ips_prmra  varchar(150),   
 cnsctvo_bnfcro   int,  
 cdgo_eapb   varchar(3) null, nmro_unco_idntfccn_ctznte  int,    
 cnsctvo_cdgo_tpo_cntrto_psc int,   nmro_cntrto_psc   char(15),  
 ds_ctzds   numeric,  cnsctvo_cdgo_sde_ips  int,    
 dscrpcn_tpo_cntrto  varchar(150),  
 cnsctvo_cdgo_csa_drcho  int,   cnsctvo_cdgo_estdo_drcho int,  
 dscrpcn_estdo_drcho  varchar(150),  dscrpcn_csa_drcho  varchar(150),  
 dscrpcn_drcho   varchar(150),  
 dscrpcn_pln   varchar(150),  dscrpcn_tpo_ctznte  varchar(150),  
 prmr_nmbre_ctznte  char(20),  sgndo_nmbre_ctznte  char(20),  
 prmr_aplldo_ctznte  char(50),  sgndo_aplldo_ctznte  char(50),  
 drccn_rsdnca   varchar(80),  tlfno_rsdnca   char(30),  
 cnsctvo_cdgo_cdd_rsdnca  int,   dscrpcn_cdd_rsdnca   varchar(150),  
 cnsctvo_cdgo_estdo_cvl   int,   dscrpcn_estdo_cvl   varchar(150),  
 cnsctvo_cdgo_tpo_frmlro  Int,   nmro_frmlro   Char(15),  
 cdgo_tpo_idntfccn  char(3),  cnsctvo_cdgo_afp  int,  
 fcha_dsde   datetime,  fcha_hsta   datetime,  
 flg_enble_nmro_vldcn  char default 'N', drcho    char,  
 cdgo_afp   char(8),  
 cnsctvo_tpo_vldcn_actva  int Default 3,  cfcha_ncmnto   char(10),  
 smns_aflcn_ss_ps  int DEFAULT 0,  smns_aflcn_eps_ps  int DEFAULT 0,  
 smns_aflcn_ss_pc  int DEFAULT 0,  smns_aflcn_eps_pc  int DEFAULT 0,  
 smns_ctzds_eps   int DEFAULT 0,  cdgo_tpo_prntsco    char(3),  
 cdgo_cdd    char(8) ,   cdgo_rngo_slrl    char(3),  
 cdgo_tpo_afldo    char(3) ,   cdgo_tpo_idntfccn_ctznte  char(3),  
 nmro_idntfccn_ctznte   char(15),  cnsctvo_tpo_idntfccn_ctznte int,  
 cnsctvo_dcmnto_gnrdo  int DEFAULT 0,  nmro_dcmnto   Char(50) DEFAULT '',  
 cdgo_estdo_drcho  char(2)   
 )  
  
  
  
Set @lfFechaReferencia = @fcha_vldccn  
  
--Set @bd = '1'  
--Set @mnsje = 'CONTRATOS'  
  
If  @Bd = '1' -- Contratos  
Begin  
  
 Insert Into @tb_tmpAfiliado(  
 prmr_aplldo,   sgndo_aplldo,   prmr_nmbre,  
 sgndo_nmbre,   cnsctvo_cdgo_tpo_idntfccn, nmro_idntfccn,  
 fcha_ncmnto,   cnsctvo_cdgo_sxo,  orgn,  
 cnsctvo_cdgo_tpo_cntrto, nmro_cntrto,   cnsctvo_cdgo_pln,  
 nmro_unco_idntfccn_afldo, inco_vgnca_bnfcro,  fn_vgnca_bnfcro,  
 cnsctvo_cdgo_prntsco,  cnsctvo_cdgo_tpo_afldo,  cnsctvo_cdgo_rngo_slrl,  
 smns_ctzds_ss_ps,  smns_ctzds_eps_ps,  cdgo_ips_prmra,  
 cnsctvo_bnfcro,   cnsctvo_cdgo_afp,  
 fcha_dsde,   fcha_hsta,  
 tlfno_rsdnca,   drccn_rsdnca,   cnsctvo_cdgo_cdd_rsdnca  
 )  
 Select 
	b.prmr_aplldo, b.sgndo_aplldo, b.prmr_nmbre,  
	b.sgndo_nmbre,   b.cnsctvo_cdgo_tpo_idntfccn, b.nmro_idntfccn,  
	b.fcha_ncmnto,   b.cnsctvo_cdgo_sxo,  '1',  
	b.cnsctvo_cdgo_tpo_cntrto, b.nmro_cntrto,   c.cnsctvo_cdgo_pln,  
	b.nmro_unco_idntfccn_afldo, b.inco_vgnca_bnfcro,  b.fn_vgnca_bnfcro,  
	b.cnsctvo_cdgo_prntsco,  b.cnsctvo_cdgo_tpo_afldo, c.cnsctvo_cdgo_rngo_slrl,  
	b.smns_ctzds,   b.smns_ctzds_antrr_eps,  b.cdgo_intrno,  
	b.cnsctvo_bnfcro,  c.cnsctvo_cdgo_afp,  
	b.inco_vgnca_bnfcro,  b.fn_vgnca_bnfcro,  
	b.tlfno_rsdnca,   b.drccn_rsdnca,   b.cnsctvo_cdgo_cdd_rsdnca  
From 	tbBeneficiariosValidador b INNER JOIN tbContratosValidador c 
ON	b.nmro_cntrto   		= c.nmro_cntrto  
And	b.cnsctvo_cdgo_tpo_cntrto 	= c.cnsctvo_cdgo_tpo_cntrto  
Where 	c.cnsctvo_cdgo_pln  		= @cnsctvo_cdgo_pln  
And 	b.cnsctvo_cdgo_tpo_idntfccn 	= @cnsctvo_cdgo_tpo_idntfccn  
And 	b.nmro_idntfccn   		= @nmro_idntfccn  
And	(Select MAX(fn_vgnca_bnfcro)
	 From	bdAfiliacionValidador.DBO.tbBeneficiariosValidador
	 Where	cnsctvo_cdgo_pln  		= @cnsctvo_cdgo_pln
	 And	cnsctvo_cdgo_tpo_idntfccn 	= @cnsctvo_cdgo_tpo_idntfccn
	 And	nmro_idntfccn   		= @nmro_idntfccn	
	 And	cnsctvo_cdgo_tpo_cntrto 	= b.cnsctvo_cdgo_tpo_cntrto) between b.inco_vgnca_bnfcro and b.fn_vgnca_bnfcro

-- And @fcha_vldccn Between b.inco_vgnca_bnfcro And b.fn_vgnca_bnfcro  
   
 Update @tb_tmpAfiliado  
 Set cdgo_ips_prmra = rtrim(ltrim(b.vlr_cmpo))  
 From bdAfiliacionValidador..tbHistoricoBeneficiariosValidador b INNER JOIN @tb_tmpAfiliado t On  
  b.cnsctvo_cdgo_tpo_cntrto = t.cnsctvo_cdgo_tpo_cntrto  
 And b.nmro_cntrto   = t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS  
 And b.cnsctvo_bnfcro  = t.cnsctvo_bnfcro  
 Where b.dscrpcn_cmpo   = 'cdgo_intrno'  
 And @fcha_vldccn between b.inco_vgnca and b.fn_vgnca  
  
   
 Update @tb_tmpAfiliado  
 Set cnsctvo_cdgo_prntsco = rtrim(ltrim(b.vlr_cmpo))  
 From bdAfiliacionValidador..tbHistoricoBeneficiariosValidador b INNER JOIN @tb_tmpAfiliado t On  
  b.cnsctvo_cdgo_tpo_cntrto = t.cnsctvo_cdgo_tpo_cntrto  
 And b.nmro_cntrto   = t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS  
 And b.cnsctvo_bnfcro  = t.cnsctvo_bnfcro  
 Where b.dscrpcn_cmpo   = 'cnsctvo_cdgo_prntsco'  
 And @fcha_vldccn between b.inco_vgnca and b.fn_vgnca  
   
 Update @tb_tmpAfiliado  
 Set cnsctvo_cdgo_tpo_afldo = rtrim(ltrim(b.vlr_cmpo))  
 From bdAfiliacionValidador..tbHistoricoBeneficiariosValidador b INNER JOIN @tb_tmpAfiliado t On  
  b.cnsctvo_cdgo_tpo_cntrto = t.cnsctvo_cdgo_tpo_cntrto  
 And b.nmro_cntrto   = t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS  
 And b.cnsctvo_bnfcro  = t.cnsctvo_bnfcro  
 Where b.dscrpcn_cmpo   = 'cnsctvo_cdgo_tpo_afldo'  
 And @fcha_vldccn between b.inco_vgnca and b.fn_vgnca  
   
 Update @tb_tmpAfiliado  
 Set fcha_ncmnto = rtrim(ltrim(b.vlr_cmpo))  
 From bdAfiliacionValidador..tbHistoricoBeneficiariosValidador b INNER JOIN @tb_tmpAfiliado t On  
  b.cnsctvo_cdgo_tpo_cntrto = t.cnsctvo_cdgo_tpo_cntrto  
 And b.nmro_cntrto   = t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS  
 And b.cnsctvo_bnfcro  = t.cnsctvo_bnfcro  
 Where b.dscrpcn_cmpo   = 'fcha_ncmnto'  
 And @fcha_vldccn between b.inco_vgnca and b.fn_vgnca  
   
   
 Update @tb_tmpAfiliado  
 Set smns_ctzds_ss_ps = rtrim(ltrim(b.vlr_cmpo))  
 From bdAfiliacionValidador..tbHistoricoBeneficiariosValidador b INNER JOIN @tb_tmpAfiliado t On  
  b.cnsctvo_cdgo_tpo_cntrto = t.cnsctvo_cdgo_tpo_cntrto  
 And b.nmro_cntrto   = t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS  
 And b.cnsctvo_bnfcro  = t.cnsctvo_bnfcro  
 Where b.dscrpcn_cmpo   = 'smns_ctzds'  
 And @fcha_vldccn between b.inco_vgnca and b.fn_vgnca  
   
 Update @tb_tmpAfiliado  
 Set smns_ctzds_eps_ps = rtrim(ltrim(b.vlr_cmpo))  
 From bdAfiliacionValidador..tbHistoricoBeneficiariosValidador b INNER JOIN @tb_tmpAfiliado t On  
  b.cnsctvo_cdgo_tpo_cntrto = t.cnsctvo_cdgo_tpo_cntrto  
 And b.nmro_cntrto   = t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS  
 And b.cnsctvo_bnfcro  = t.cnsctvo_bnfcro  
 Where b.dscrpcn_cmpo   = 'smns_ctzds_antrr_eps'  
 And @fcha_vldccn between b.inco_vgnca and b.fn_vgnca  
   
 Update @tb_tmpAfiliado  
 Set cnsctvo_cdgo_rngo_slrl = rtrim(ltrim(c.vlr_cmpo))  
 From bdAfiliacionValidador..tbHistoricoContratosValidador c INNER JOIN @tb_tmpAfiliado t On  
  c.cnsctvo_cdgo_tpo_cntrto = t.cnsctvo_cdgo_tpo_cntrto  
 And c.nmro_cntrto   = t.nmro_cntrto COLLATE SQL_Latin1_General_CP1_CI_AS  
 Where c.dscrpcn_cmpo   = 'cnsctvo_cdgo_rngo_slrl'  
 And @fcha_vldccn between c.inco_vgnca and c.fn_vgnca  
   
   

 Update @tb_tmpAfiliado  
 Set cnsctvo_cdgo_estdo_drcho = m.cnsctvo_cdgo_estdo_drcho,  
  cnsctvo_cdgo_csa_drcho  = m.cnsctvo_cdgo_csa_drcho,  
  dscrpcn_csa_drcho  = isnull(c.dscrpcn_csa_drcho,' ')  
 From @tb_tmpAfiliado t INNER JOIN TbMatrizDerechosValidador m On   
  m.cnsctvo_cdgo_tpo_cntrto = t.cnsctvo_cdgo_tpo_cntrto  
 And m.nmro_cntrto   = t.nmro_cntrto --COLLATE SQL_Latin1_General_CP1_CI_AS                
 And m.cnsctvo_bnfcro  = t.cnsctvo_bnfcro  
    INNER JOIN tbCausasDerechoValidador c On  
  m.cnsctvo_cdgo_estdo_drcho = c.cnsctvo_cdgo_estdo_drcho  
 And m.cnsctvo_cdgo_csa_drcho = c.cnsctvo_cdgo_csa_drcho                
 Where @fcha_vldccn Between inco_vgnca_estdo_drcho And fn_vgnca_estdo_drcho  
   
   
  IF @@RowCount = 0  
  Begin  
    
   Update @tb_tmpAfiliado  
   Set cnsctvo_cdgo_estdo_drcho = m.cnsctvo_cdgo_estdo_drcho,  
    cnsctvo_cdgo_csa_drcho  = m.cnsctvo_cdgo_csa_drcho,  
    dscrpcn_csa_drcho  = isnull(c.dscrpcn_csa_drcho,' ')  
   From @tb_tmpAfiliado t INNER JOIN TbMatrizDerechosValidador_at m On   
    m.cnsctvo_cdgo_tpo_cntrto = t.cnsctvo_cdgo_tpo_cntrto  
   And m.nmro_cntrto   = t.nmro_cntrto --COLLATE SQL_Latin1_General_CP1_CI_AS                
   And m.cnsctvo_bnfcro  = t.cnsctvo_bnfcro  
      INNER JOIN tbCausasDerechoValidador c On  
    m.cnsctvo_cdgo_estdo_drcho = c.cnsctvo_cdgo_estdo_drcho  
   And m.cnsctvo_cdgo_csa_drcho = c.cnsctvo_cdgo_csa_drcho                
   Where @fcha_vldccn Between inco_vgnca_estdo_drcho And fn_vgnca_estdo_drcho  
    
  End  
   
 Update @tb_tmpAfiliado  
 Set prmr_nmbre_ctznte = b.prmr_aplldo,  
  sgndo_nmbre_ctznte = b.sgndo_aplldo,  
  prmr_aplldo_ctznte = b.prmr_nmbre,  
  sgndo_aplldo_ctznte = b.sgndo_nmbre,  
  cnsctvo_tpo_idntfccn_ctznte = b.cnsctvo_cdgo_tpo_idntfccn,  
  nmro_idntfccn_ctznte  = b.nmro_idntfccn  
 From @tb_tmpAfiliado a INNER JOIN tbBeneficiariosValidador b On  
  a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto  
 And a.nmro_cntrto   = b.nmro_cntrto  
 Where b.cnsctvo_bnfcro  = 1  
   
   
 Update @tb_tmpAfiliado  
 Set cnsctvo_cdgo_pln_pc = c.cnsctvo_cdgo_pln,  
  smns_ctzds_ss_pc = b.smns_ctzds,  
  smns_ctzds_eps_pc = b.smns_ctzds_antrr_eps  
 From tbContratosValidador c INNER JOIN tbBeneficiariosValidador b On  
  b.cnsctvo_cdgo_tpo_cntrto = c.cnsctvo_cdgo_tpo_cntrto  
 And b.nmro_cntrto   = c.nmro_cntrto  
     INNER JOIN @tb_tmpAfiliado t On  
  b.nmro_unco_idntfccn_afldo = t.nmro_unco_idntfccn_afldo  
 Where c.cnsctvo_cdgo_tpo_cntrto =  2--t.cnsctvo_cdgo_pln  
 And @fcha_vldccn Between b.inco_vgnca_bnfcro And b.fn_vgnca_bnfcro  
   
    --Calculamos  la edad y la unidad de la edad  
 Update @tb_tmpAfiliado  
 Set  edd   = isnull(dbo.fnCalcularTiempo(fcha_ncmnto,@fcha_vldccn,1,2),0),  
   edd_mss  = isnull(dbo.fnCalcularTiempo(fcha_ncmnto,@fcha_vldccn,2,2),0),  
  edd_ds   = isnull(dbo.fnCalcularTiempo(fcha_ncmnto,@fcha_vldccn,3,2),0)  
   
 Update @tb_tmpAfiliado  
 Set cnsctvo_cdgo_tpo_undd = 1  
 Where edd_ds > 0  
   
 Update @tb_tmpAfiliado  
 Set cnsctvo_cdgo_tpo_undd = 3  
 Where edd_mss > 0  
   
 Update @tb_tmpAfiliado  
 Set cnsctvo_cdgo_tpo_undd = 4  
 Where edd > 0  
   
   
 Update @tb_tmpAfiliado  
 Set  dscrpcn_prntsco = p.dscrpcn_prntsco,  
  cdgo_tpo_prntsco= p.cdgo_prntscs  
 From @tb_tmpAfiliado t INNER JOIN tbParentescos_vigencias p On  
  t.cnsctvo_cdgo_prntsco = p.cnsctvo_cdgo_prntscs  
 Where @fcha_vldccn Between p.inco_vgnca And p.fn_vgnca  
   
   
 Update @tb_tmpAfiliado  
 Set  dscrpcn_tpo_afldo = a.dscrpcn,  
  cdgo_tpo_afldo   = a.cdgo_tpo_afldo   
 From @tb_tmpAfiliado t INNER JOIN tbTiposAfiliado_vigencias a On  
  t.cnsctvo_cdgo_tpo_afldo = a.cnsctvo_cdgo_tpo_afldo  
 Where @fcha_vldccn Between inco_vgnca And fn_vgnca  
   
   
 Update @tb_tmpAfiliado  
 Set  dscrpcn_rngo_slrl = r.dscrpcn_rngo_slrl,  
  cdgo_rngo_slrl   = r.cdgo_rngo_slrl   
 From @tb_tmpAfiliado t INNER JOIN tbRangosSalariales_vigencias r On  
  t.cnsctvo_cdgo_rngo_slrl = r.cnsctvo_cdgo_rngo_slrl  
 Where @fcha_vldccn Between r.inco_vgnca And r.fn_vgnca  
   
   
 Update @tb_tmpAfiliado  
 Set dscrpcn_pln_pc = isnull(p.dscrpcn_pln,'')   
 From @tb_tmpAfiliado t INNER JOIN tbPlanes_vigencias p On  
  t.cnsctvo_cdgo_pln_pc = p.cnsctvo_cdgo_pln  
   
   
 Update @tb_tmpAfiliado  
 Set dscrpcn_ips_prmra = i.nmbre_scrsl  
 From @tb_tmpAfiliado t INNER JOIN bdSISalud..tbIpsPrimarias_vigencias i On  
  t.cdgo_ips_prmra = i.cdgo_intrno --COLLATE SQL_Latin1_General_CP1_CI_AS  
   
 Update @tb_tmpAfiliado  
 Set  dscrpcn_estdo_drcho  = edv.dscrpcn_estdo_drcho,  
  dscrpcn_drcho   = edv.dscrpcn_drcho,  
  cnsctvo_cdgo_estdo_drcho = edv.cnsctvo_cdgo_estdo_drcho,  
  cdgo_estdo_drcho  = edv.cdgo_estdo_drcho  
 From tbEstadosDerechoValidador edv INNER JOIN @tb_tmpAfiliado a On  
  a.cnsctvo_cdgo_estdo_drcho  = edv.cnsctvo_cdgo_estdo_drcho  
   
   
 Update @tb_tmpAfiliado  
 Set cdgo_tpo_idntfccn = i.cdgo_tpo_idntfccn  
 From @tb_tmpAfiliado t INNER JOIN tbTiposIdentificacion_vigencias i On  
  t.cnsctvo_cdgo_tpo_idntfccn = i.cnsctvo_cdgo_tpo_idntfccn  
 Where @fcha_vldccn Between i.inco_vgnca And i.fn_vgnca  
   
 Update @tb_tmpAfiliado  
 Set cdgo_tpo_idntfccn_ctznte = i.cdgo_tpo_idntfccn  
 From @tb_tmpAfiliado t INNER JOIN tbTiposIdentificacion_vigencias i On  
  t.cnsctvo_tpo_idntfccn_ctznte = i.cnsctvo_cdgo_tpo_idntfccn  
 Where @fcha_vldccn Between i.inco_vgnca And i.fn_vgnca  
   
   
 Update @tb_tmpAfiliado  
 Set cdgo_sxo = s.cdgo_sxo  
 From @tb_tmpAfiliado t INNER JOIN tbSexos_vigencias s On  
  t.cnsctvo_cdgo_sxo = s.cnsctvo_cdgo_sxo  
 Where @fcha_vldccn Between s.inco_vgnca And s.fn_vgnca  
   
   
 Update @tb_tmpAfiliado  
 Set dscrpcn_pln = p.dscrpcn_pln  
 From @tb_tmpAfiliado t INNER JOIN tbPlanes p On  
  t.cnsctvo_cdgo_pln = p.cnsctvo_cdgo_pln  
   
 --cnsctvo_cdgo_sde_ips  
 Update @tb_tmpAfiliado  
 Set cnsctvo_cdgo_sde_ips = d.cnsctvo_cdgo_sde  
 From bdSISalud..tbDireccionesPrestador d INNER JOIN @tb_tmpAfiliado t On  
  d.cdgo_intrno = t.cdgo_ips_prmra  
   
 Update @tb_tmpAfiliado  
 Set cdgo_afp = cdgo_entdd  
 From tbEntidades_Vigencias e INNER JOIN @tb_tmpAfiliado t On  
  t.cnsctvo_cdgo_afp = e.cnsctvo_cdgo_entdd   
 And @fcha_vldccn Between e.inco_vgnca And e.fn_vgnca  
   
 Update @tb_tmpAfiliado  
 Set cfcha_ncmnto = convert(char(10),fcha_ncmnto,111)  
   
 Select @lfFechaReferencia = fn_vgnca_bnfcro  
 From @tb_tmpAfiliado  
 Where fn_vgnca_bnfcro < @fcha_vldccn  
End  
  
--*******************************************************************************************************************************  
  
If  @bd = '2' --Formularios  
 Begin  
   
/*  
--Consulta el código del origen por el cual se realizo la consulta  
 Select  @cdgo_orgn = cdgo_orgn  
 From bdSiSalud.dbo.tbDetalleOrigenBaseDatos  
 where cnsctvo_orgn = @bd*/  
  
  INSERT INTO @tb_tmpAfiliado (  
  nmro_idntfccn,   
  prmr_aplldo,   
  sgndo_aplldo,   
  prmr_nmbre,   
  sgndo_nmbre,   
  cnsctvo_cdgo_tpo_idntfccn,   
  nmro_unco_idntfccn_afldo,   
  fcha_ncmnto,   
  cdgo_ips_prmra,   
--  cnsctvo_cdgo_brro,   
  cnsctvo_cdgo_tpo_afldo,   
  nmro_cntrto,   
  cnsctvo_bnfcro,   
  cnsctvo_cdgo_tpo_cntrto,   
  cnsctvo_cdgo_sxo,   
  cnsctvo_cdgo_cdd_rsdnca,   
  smns_ctzds_eps, --ds_ss,   
  smns_aflcn_ss_ps, --ds_sgsss,   
  orgn,   
  cnsctvo_cdgo_rngo_slrl,   
  cnsctvo_cdgo_pln,  
  cdgo_eapb,  
  inco_vgnca_bnfcro,  
  fn_vgnca_bnfcro,  
  cnsctvo_cdgo_prntsco)    
  
  SELECT a.nmro_idntfccn_bnfcro, -- AS nmro_idntfccn_afldo,   
  a.prmr_aplldo , --AS prmr_aplldo_afldo,   
  a.sgndo_aplldo , --AS sgndo_aplldo_afldo,   
  a.prmr_nmbre , --AS prmr_nmbre_afldo,   
  a.sgndo_nmbre , --AS sgndo_nmbre_afldo,   
  a.cnsctvo_tpo_idntfccn_bnfcro , --AS cnsctvo_cdgo_tpo_idntfccn,   
  0 , --AS nmro_unco_idntfccn_afldo,   
  a.fcha_ncmnto,   
  '0' , --AS cdgo_intrno,   
--  0 , --AS cnsctvo_cdgo_brro,   
  a.cnsctvo_cdgo_tpo_afldo,   
  '000000000000000' , --AS nmro_cntrto,   
  0 , --as cnsctvo_bnfcro,   
  0 , --AS cnsctvo_cdgo_tpo_cntrto,   
  a.cnsctvo_cdgo_sxo,  
  a.cnsctvo_cdgo_cdd_rsdnca,   
  a.smns_ctzds , --AS ds_ss,   
  0  , --AS ds_sgsss,   
  '2', --@cdgo_orgn, --'F' AS orgn, --Formularios  
  a.rngo_slrl, --0 , --AS cnsctvo_cdgo_rngo_slrl,     
  a.cnsctvo_cdgo_pln,  
  0,  
  a.inco_vgnca_bnfcro,  
  a.fn_vgnca_bnfcro,  
  a.cnsctvo_cdgo_prntsco   
  FROM  bdAfiliacionValidador.dbo.tbBeneficiariosFormularioValidador a    
  WHERE  a.cnsctvo_tpo_idntfccn_bnfcro  = @cnsctvo_cdgo_tpo_idntfccn   
  AND  a.nmro_idntfccn_bnfcro   = @nmro_idntfccn  
  And a.cnsctvo_cdgo_pln  = @cnsctvo_cdgo_pln  
  And @fcha_vldccn   >= a.inco_vgnca_bnfcro  
  And @fcha_vldccn   <= a.fcha_hsta  
--  And (@fcha_vldccn Between a.fcha_dsde and a.fcha_hsta)  
  
  
 End  
--*******************************************************************************************************************************  
  
if @Bd = '3' --Otras Eps (Famisanar)  
Begin  
  
 Insert Into @tb_tmpAfiliado (  
  prmr_aplldo,    sgndo_aplldo,    prmr_nmbre,   
  sgndo_nmbre,    cnsctvo_cdgo_tpo_idntfccn, nmro_idntfccn,  
  fcha_ncmnto,    cdgo_sxo,   cnsctvo_cdgo_sxo,  
  cnsctvo_cdgo_prntsco,  cnsctvo_cdgo_pln,  cnsctvo_cdgo_tpo_afldo,  
  cnsctvo_cdgo_rngo_slrl,  inco_vgnca_bnfcro,  fn_vgnca_bnfcro,  
  smns_aflcn_eps_ps,  smns_aflcn_ss_ps,  smns_aflcn_eps_pc,  
  smns_aflcn_ss_pc,  cnsctvo_cdgo_estdo_drcho, cdgo_ips_prmra,  
  cdgo_eapb,   cnsctvo_cdgo_tpo_cntrto,  nmro_cntrto,  
  orgn,    fcha_dsde,   fcha_hsta,  
  tlfno_rsdnca,   drccn_rsdnca  
  )  
 Select  a.prmr_aplldo_bnfcro,   isnull(a.sgndo_aplldo_bnfcro,'') as sgndo_aplldo_bnfcro, a.prmr_nmbre_bnfcro,  
  a.sgndo_nmbre_bnfcro,   a.cnsctvo_cdgo_tpo_idntfccn_bnfcro, a.nmro_idntfccn_bnfcro,  
  a.fcha_ncmnto,    a.sxo,    a.cnsctvo_cdgo_sxo,  
  a.cnsctvo_cdgo_prntscs,  a.cnsctvo_cdgo_pln,  a.cnsctvo_cdgo_tpo_afldo,  
  a.cnsctvo_cdgo_rngo_slrl, convert(char(10),a.inco_vgnca, 111) as inco_vgnca,  convert(char(10),a.fn_vgnca, 111) as fn_vgnca,  
  0,    a.smns_ctzds, 0,   0,  
  a.estdo as cnsctvo_cdgo_estdo_drcho,  a.ips,  
  a.cdgo_eapb,  0,  0,  
  '3',    fcha_dsde,   fcha_hsta,  
  tlfno,    drccn  
 From  bdSiSalud.dbo.tbEapb a, bdSisalud.dbo.tbDetalleeapb_Vigencias b  
 Where  a.nmro_idntfccn_bnfcro    = @nmro_idntfccn  
 And a.cnsctvo_cdgo_tpo_idntfccn_bnfcro = @cnsctvo_cdgo_tpo_idntfccn  
 And a.cnsctvo_cdgo_pln   = @cnsctvo_cdgo_pln   
 And a.cdgo_eapb    = b.cdgo_eapb  
 And (@fcha_vldccn Between Convert(char(10),b.inco_vgnca,111) and Convert(char(10),b.fn_vgnca,111))  
 And b.vsble_vlddr    = 'S'  
  
 If Exists(Select 1  
  From @tb_tmpAfiliado  
  Where @fcha_vldccn Between Convert(char(10),inco_vgnca_bnfcro,111) And Convert(char(10),fn_vgnca_bnfcro,111)  
  And @Bd = '2')  
  
 Begin  
  Delete @tb_tmpAfiliado  
  Where Convert(char(10),inco_vgnca_bnfcro,111) > @fcha_vldccn   
  Or @fcha_vldccn > Convert(char(10),fn_vgnca_bnfcro,111)  
--  Or orgn != '3' --Se comentarea para analisis  
  Set @Bd  = '2'  -- FAMISANAR  
 End  
  
End  
  
Update @tb_tmpAfiliado  
Set  edd   = isnull(dbo.fnCalcularTiempo(fcha_ncmnto,@fcha_vldccn,1,2),0),  
  edd_mss  = isnull(dbo.fnCalcularTiempo(fcha_ncmnto,@fcha_vldccn,2,2),0),  
  
 edd_ds   = isnull(dbo.fnCalcularTiempo(fcha_ncmnto,@fcha_vldccn,3,2),0)  
  
Update @tb_tmpAfiliado  
Set cnsctvo_cdgo_tpo_undd = 1  
Where edd_ds > 0  
  
  
Update @tb_tmpAfiliado  
Set cnsctvo_cdgo_tpo_undd = 3  
Where edd_mss > 0  
  
Update @tb_tmpAfiliado  
Set cnsctvo_cdgo_tpo_undd = 4  
Where edd > 0  
  
Update @tb_tmpAfiliado  
Set  dscrpcn_prntsco = p.dscrpcn_prntsco,  
 cdgo_tpo_prntsco= p.cdgo_prntscs  
From @tb_tmpAfiliado t INNER JOIN dbo.tbParentescos_vigencias p On  
 t.cnsctvo_cdgo_prntsco = p.cnsctvo_cdgo_prntscs  
Where @fcha_vldccn Between Convert(char(10),p.inco_vgnca,111) And Convert(char(10),p.fn_vgnca,111)  
  
Update @tb_tmpAfiliado  
Set  dscrpcn_tpo_afldo = a.dscrpcn,  
 cdgo_tpo_afldo   = a.cdgo_tpo_afldo   
From @tb_tmpAfiliado t INNER JOIN dbo.tbTiposAfiliado_vigencias a On  
 t.cnsctvo_cdgo_tpo_afldo = a.cnsctvo_cdgo_tpo_afldo  
Where @fcha_vldccn Between Convert(char(10),a.inco_vgnca,111) And Convert(char(10),a.fn_vgnca,111)  
  
Update @tb_tmpAfiliado  
Set cnsctvo_cdgo_rngo_slrl = 4  
Where cnsctvo_cdgo_rngo_slrl = 0  
And cnsctvo_cdgo_tpo_cntrto != 1  
  
Update @tb_tmpAfiliado  
Set  dscrpcn_rngo_slrl = r.dscrpcn_rngo_slrl,  
 cdgo_rngo_slrl   = r.cdgo_rngo_slrl   
From @tb_tmpAfiliado t INNER JOIN dbo.tbRangosSalariales_vigencias r On  
 t.cnsctvo_cdgo_rngo_slrl = r.cnsctvo_cdgo_rngo_slrl  
Where @fcha_vldccn Between Convert(char(10),r.inco_vgnca,111) And Convert(char(10),r.fn_vgnca,111)  
  
Update @tb_tmpAfiliado  
Set dscrpcn_pln_pc = isnull(p.dscrpcn_pln,'')   
From @tb_tmpAfiliado t INNER JOIN dbo.tbPlanes_vigencias p On  
 t.cnsctvo_cdgo_pln_pc = p.cnsctvo_cdgo_pln  
  
Update @tb_tmpAfiliado  
Set dscrpcn_ips_prmra = i.nmbre_scrsl  
From @tb_tmpAfiliado t INNER JOIN bdSISalud.dbo.tbIpsPrimarias_vigencias i On  
 t.cdgo_ips_prmra = i.cdgo_intrno --COLLATE SQL_Latin1_General_CP1_CI_AS  
  
Update @tb_tmpAfiliado  
Set  dscrpcn_estdo_drcho  = edv.dscrpcn_estdo_drcho,  
 dscrpcn_drcho   = edv.dscrpcn_drcho,  
 cnsctvo_cdgo_estdo_drcho = edv.cnsctvo_cdgo_estdo_drcho,  
 drcho     = edv.drcho,  
 cdgo_estdo_drcho  = edv.cdgo_estdo_drcho  
From dbo.tbEstadosDerechoValidador edv INNER JOIN @tb_tmpAfiliado a On  
 a.cnsctvo_cdgo_estdo_drcho  = edv.cnsctvo_cdgo_estdo_drcho  
  
Update @tb_tmpAfiliado  
Set cdgo_tpo_idntfccn = i.cdgo_tpo_idntfccn  
From @tb_tmpAfiliado t INNER JOIN dbo.tbTiposIdentificacion_vigencias i On  
 t.cnsctvo_cdgo_tpo_idntfccn = i.cnsctvo_cdgo_tpo_idntfccn  
Where @fcha_vldccn Between Convert(char(10),i.inco_vgnca,111) And Convert(char(10),i.fn_vgnca,111)  
  
Update @tb_tmpAfiliado  
Set cdgo_tpo_idntfccn_ctznte = i.cdgo_tpo_idntfccn  
From @tb_tmpAfiliado t INNER JOIN dbo.tbTiposIdentificacion_vigencias i On  
 t.cnsctvo_tpo_idntfccn_ctznte = i.cnsctvo_cdgo_tpo_idntfccn  
Where @fcha_vldccn Between Convert(char(10),i.inco_vgnca,111) And Convert(char(10),i.fn_vgnca,111)  
  
Update @tb_tmpAfiliado  
Set cdgo_sxo = s.cdgo_sxo  
From @tb_tmpAfiliado t INNER JOIN dbo.tbSexos_vigencias s On  
 t.cnsctvo_cdgo_sxo = s.cnsctvo_cdgo_sxo  
Where @fcha_vldccn Between Convert(char(10),s.inco_vgnca,111) And Convert(char(10),s.fn_vgnca,111)  
  
/*  
Select *  
From tbPlanes  
*/  
Update @tb_tmpAfiliado  
Set dscrpcn_pln = p.dscrpcn_pln  
From @tb_tmpAfiliado t INNER JOIN dbo.tbPlanes p On  
 t.cnsctvo_cdgo_pln = p.cnsctvo_cdgo_pln  
  
  
--cnsctvo_cdgo_sde_ips  
Update @tb_tmpAfiliado  
Set cnsctvo_cdgo_sde_ips = d.cnsctvo_cdgo_sde  
From bdSISalud.dbo.tbDireccionesPrestador d INNER JOIN @tb_tmpAfiliado t On  
 d.cdgo_intrno = t.cdgo_ips_prmra  
  
Update @tb_tmpAfiliado  
Set flg_enble_nmro_vldcn = 'S'  
Where cnsctvo_cdgo_estdo_drcho  = 8 --In (8) Suspendido  
Or cnsctvo_cdgo_estdo_drcho  = 7 --Retirado  
  
  
Update @tb_tmpAfiliado  
Set dscrpcn_cdd_rsdnca = c.dscrpcn_cdd,  
 cdgo_cdd  = c.cdgo_cdd  
From dbo.tbCiudades c INNER JOIN @tb_tmpAfiliado t On  
 c.cnsctvo_cdgo_cdd = t.cnsctvo_cdgo_cdd_rsdnca  
  
  
Update @tb_tmpAfiliado  
Set cdgo_afp = cdgo_entdd  
From dbo.tbEntidades_Vigencias e INNER JOIN @tb_tmpAfiliado t On  
 t.cnsctvo_cdgo_afp = e.cnsctvo_cdgo_entdd   
And @fcha_vldccn Between Convert(char(10),e.inco_vgnca,111) And Convert(char(10),e.fn_vgnca,111)  
  
Update @tb_tmpAfiliado  
Set cfcha_ncmnto = convert(char(10),fcha_ncmnto,111)  
  
  
Select --top 1  
 prmr_aplldo,  sgndo_aplldo,  
 prmr_nmbre,   sgndo_nmbre,    
 cnsctvo_cdgo_tpo_idntfccn, nmro_idntfccn,  
 fcha_ncmnto,   cnsctvo_cdgo_sxo,  
 cdgo_sxo,   edd,  
 edd_mss,   edd_ds,  
 cnsctvo_cdgo_tpo_undd,  orgn,  
 cnsctvo_cdgo_tpo_cntrto,  
 nmro_cntrto,   cnsctvo_cdgo_pln,  
 nmro_unco_idntfccn_afldo, inco_vgnca_bnfcro,    
 fn_vgnca_bnfcro,  
 cnsctvo_cdgo_prntsco,  dscrpcn_prntsco,  
 cnsctvo_cdgo_tpo_afldo,  dscrpcn_tpo_afldo,  
 cnsctvo_cdgo_rngo_slrl,  dscrpcn_rngo_slrl,    
 cnsctvo_cdgo_pln_pc,  dscrpcn_pln_pc,    
 smns_ctzds_ss_ps,  smns_ctzds_eps_ps,  
 smns_ctzds_ss_pc,  smns_ctzds_eps_pc,     
 cdgo_ips_prmra,   dscrpcn_ips_prmra,   
 cnsctvo_bnfcro,  
 cdgo_eapb,   nmro_unco_idntfccn_ctznte,  
 cnsctvo_cdgo_tpo_cntrto_psc, nmro_cntrto_psc,  
 ds_ctzds,   cnsctvo_cdgo_sde_ips,    
 dscrpcn_tpo_cntrto,  
 cnsctvo_cdgo_csa_drcho,  cnsctvo_cdgo_estdo_drcho,  
 dscrpcn_estdo_drcho,  dscrpcn_csa_drcho,  
 dscrpcn_drcho,  
 dscrpcn_pln,   dscrpcn_tpo_ctznte,  
 prmr_nmbre_ctznte,  sgndo_nmbre_ctznte,  
 prmr_aplldo_ctznte,  sgndo_aplldo_ctznte,  
 drccn_rsdnca,   tlfno_rsdnca,  
 cnsctvo_cdgo_cdd_rsdnca, dscrpcn_cdd_rsdnca,  
 cnsctvo_cdgo_estdo_cvl,  dscrpcn_estdo_cvl,  
 cnsctvo_cdgo_tpo_frmlro, nmro_frmlro,  
 cdgo_tpo_idntfccn,  cnsctvo_cdgo_afp,  
 fcha_dsde,   fcha_hsta,  
 flg_enble_nmro_vldcn,  drcho,  
 cdgo_afp,  
 cnsctvo_tpo_vldcn_actva, cfcha_ncmnto,  
 smns_aflcn_ss_ps,  smns_aflcn_eps_ps,  
 smns_aflcn_ss_pc,  smns_aflcn_eps_pc,  
 smns_ctzds_eps,   cdgo_tpo_prntsco,  
 cdgo_cdd,    cdgo_rngo_slrl,  
 cdgo_tpo_afldo,   cdgo_tpo_idntfccn_ctznte,  
 nmro_idntfccn_ctznte,  cnsctvo_tpo_idntfccn_ctznte,  
 @lfFechaReferencia as fcha_rfrnca,  
 cnsctvo_dcmnto_gnrdo,  nmro_dcmnto,  
 cdgo_estdo_drcho  
From @tb_tmpAfiliado
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spRecobrosConsultaAfiliado_Historico] TO [300202 Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spRecobrosConsultaAfiliado_Historico] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spRecobrosConsultaAfiliado_Historico] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spRecobrosConsultaAfiliado_Historico] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spRecobrosConsultaAfiliado_Historico] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spRecobrosConsultaAfiliado_Historico] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spRecobrosConsultaAfiliado_Historico] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spRecobrosConsultaAfiliado_Historico] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spRecobrosConsultaAfiliado_Historico] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spRecobrosConsultaAfiliado_Historico] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spRecobrosConsultaAfiliado_Historico] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spRecobrosConsultaAfiliado_Historico] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spRecobrosConsultaAfiliado_Historico] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spRecobrosConsultaAfiliado_Historico] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spRecobrosConsultaAfiliado_Historico] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spRecobrosConsultaAfiliado_Historico] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spRecobrosConsultaAfiliado_Historico] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spRecobrosConsultaAfiliado_Historico] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spRecobrosConsultaAfiliado_Historico] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spRecobrosConsultaAfiliado_Historico] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spRecobrosConsultaAfiliado_Historico] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spRecobrosConsultaAfiliado_Historico] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spRecobrosConsultaAfiliado_Historico] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spRecobrosConsultaAfiliado_Historico] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spRecobrosConsultaAfiliado_Historico] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spRecobrosConsultaAfiliado_Historico] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

