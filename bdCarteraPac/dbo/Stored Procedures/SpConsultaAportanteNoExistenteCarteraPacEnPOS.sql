/*---------------------------------------------------------------------------------
* Metodo o PRG		:  SpConsultaAportanteNoExistenteCarteraPacEnPOS
* Desarrollado por	: <\A Andres Camelo (illustrato ltda)			A\>
* Descripcion		: <\D Este procedimiento se encarga de consultar los datos de un aportante que no existe en la bd cartera pac y
                          se consulta en la bd que contiene los tipos contratos POS  D\>
* Observaciones		: <\O  							O\>
* Parametros		: <\P							P\>
* Variables		: <\V  							V\>
* Fecha Creacion	: <\FC 	25/10/2013				FC\>
*---------------------------------------------------------------------------------*/


create  PROCEDURE [dbo].[SpConsultaAportanteNoExistenteCarteraPacEnPOS]
@nmro_idntfccn	        varchar(23),
@cdgo_tpo_idntfccn      char(3) 



As 

Set Nocount On

declare @fechaActual datetime

set @fechaActual = getdate()

Declare @tbAportantesPOS table (
prmr_aplldo              char(30),
sgndo_aplldo             char(30),
prmr_nmbre               char(30), 
sgndo_nmbre              char(30),
cnsctvo_cdgo_cdd_rsdnca  int,
cdgo_cdd                 varchar(8),
dscrpcn_cdd              varchar(150),
dscrpcn_dprtmnto         varchar(150),
drccn_rsdnca             varchar(80),
tlfno_rsdnca             char(30),
nmro_unco_idntfccn       int
)




      insert into @tbAportantesPOS(
	  prmr_aplldo,
	  sgndo_aplldo,
	  prmr_nmbre, 
	  sgndo_nmbre,
	  cnsctvo_cdgo_cdd_rsdnca,
	  drccn_rsdnca,
	  tlfno_rsdnca,
      nmro_unco_idntfccn)
	  select 
	  b.prmr_aplldo,
	  isnull(b.sgndo_aplldo,''),
	  b.prmr_nmbre, 
	  isnull(b.sgndo_nmbre,''),
	  b.cnsctvo_cdgo_cdd_rsdnca,
	  isnull(b.drccn_rsdnca,''),
	  isnull(b.tlfno_rsdnca,''),
      b.nmro_unco_idntfccn
	  from bdafiliacion.dbo.tbBeneficiarios a with (nolock)
	  inner join bdafiliacion.dbo.tbPersonas b with (nolock)
	  on  (b.nmro_unco_idntfccn = a.nmro_unco_idntfccn_bnfcro)
	  inner join bdAfiliacion.dbo.tbvinculados c with (nolock)
	  on   (c.nmro_unco_idntfccn = b.nmro_unco_idntfccn) 
	  inner join  bdAfiliacion.dbo.tbTiposIdentificacion_Vigencias  d with (nolock)
	  on   (c.cnsctvo_cdgo_tpo_idntfccn =  d.cnsctvo_cdgo_tpo_idntfccn)
	  where a.cnsctvo_cdgo_tpo_cntrto = 1
	  and   d.cdgo_tpo_idntfccn       = @cdgo_tpo_idntfccn
	  and   c.nmro_idntfccn           = @nmro_idntfccn
      and   d.inco_vgnca              < @fechaActual
      and   d.fn_vgnca                > @fechaActual
	  
     -- actualizamos los nombres de ciudad y departamento del aportante
     update a set a.dscrpcn_cdd       = isnull(b.dscrpcn_cdd,''),
                  a.dscrpcn_dprtmnto  = isnull(c.dscrpcn_dprtmnto,''),
                  a.cdgo_cdd          = isnull(b.cdgo_cdd,'') 
     from @tbAportantesPOS a
     inner join bdAfiliacion.dbo.tbCiudades_Vigencias b
     on (a.cnsctvo_cdgo_cdd_rsdnca = b.cnsctvo_cdgo_cdd)
     inner join bdAfiliacion.dbo.tbDepartamentos_Vigencias c
     on (c.cnsctvo_cdgo_dprtmnto = b.cnsctvo_cdgo_dprtmnto)
     where  b.inco_vgnca              < @fechaActual
      and   b.fn_vgnca                > @fechaActual
      and   c.inco_vgnca              < @fechaActual
      and   c.fn_vgnca                > @fechaActual

      select 	
      prmr_aplldo,
	  sgndo_aplldo,
	  prmr_nmbre, 
	  sgndo_nmbre,
	  cnsctvo_cdgo_cdd_rsdnca,
      cdgo_cdd,
      dscrpcn_cdd,
      dscrpcn_dprtmnto,
	  drccn_rsdnca,
	  tlfno_rsdnca,
      nmro_unco_idntfccn
      from @tbAportantesPOS
 

