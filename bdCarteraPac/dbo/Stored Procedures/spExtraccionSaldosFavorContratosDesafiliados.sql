
/*------------------------------------------------------------------------------------------
* Método o PRG		:	dbo.[spExtraccionSaldosFavorContratosDesafiliados]
* Desarrollado por	: <\A	Ing. Diana Lorena Gomez	A\>	
* Descripción		: <\D Este informe se va a generar los primeros días del mes que se hace el cierre y 
debe mostrarme los contratos PAC que hayan sido desafiliados la último día del mes 
inmediatamente anterior, cuya sumatoria de pagos aplicados al última estado de cuenta 
generado sea mayor al valor que debía cancelar.		D\>	
* Observaciones		: <\O							O\>	
* Parámetros		: <\P							P\>	
* Variables		: <\V							V\>	
* Fecha Creación	: <\FC 2010/12/06					FC\>
*-------------------------------------------------------------------------------------------
* DATOS DE MODIFICACIÓN																		
*-------------------------------------------------------------------------------------------
* Modificado Por	: <\AM																AM\>
* Descripción		: <\DM																DM\>
* Nuevos Parámetros	: <\PM																PM\>
* Nuevas Variables	: <\VM																VM\>
* Fecha Modificación: <\FM																FM\>
*-----------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[spExtraccionSaldosFavorContratosDesafiliados]
AS

SET NOCOUNT ON

Declare @lnfechacortedesde datetime,
		@lnfechacortehasta datetime

CREATE TABLE #tmpcontratospac
   (
   nmro_cntrto char (15),
   cnsctvo_cdgo_tpo_cntrto int,
   cnsctvo_cdgo_pln int,
   nmro_unco_idntfccn_afldo int,
   inco_vgnca datetime,
   fn_vgnca datetime,
   cnsctvo_estdo_cnta_cntrto int,
   sldo_fvr int,
   mrca_estds_cnta char(1),
   ttl_fctrdo int,
   ttl_pgdo int,
   nmro_estdo_cnta int,
   nmro_unco_idntfccn_empldr int,
   cnsctvo_scrsl int,
   cnsctvo_cdgo_clse_aprtnte int
   )

IF EXISTS (SELECT 1
             FROM #tbcriteriostmp
            WHERE cdgo_cmpo = 'fcha_crte')
   BEGIN
      SELECT @lnfechacortedesde = vlr
      FROM #tbcriteriostmp
      WHERE cdgo_cmpo = 'fcha_crte' AND oprdr = '>='
      SELECT @lnfechacortehasta = vlr
      FROM #tbcriteriostmp
      WHERE cdgo_cmpo = 'fcha_crte' AND oprdr = '<='
   END


INSERT INTO #tmpcontratospac
(nmro_cntrto, cnsctvo_cdgo_tpo_cntrto, cnsctvo_cdgo_pln,nmro_unco_idntfccn_afldo, inco_vgnca, fn_vgnca )
  SELECT c.nmro_cntrto, c.cnsctvo_cdgo_tpo_cntrto, c.cnsctvo_cdgo_pln,c.nmro_unco_idntfccn_afldo, c.inco_vgnca_cntrto, c.fn_vgnca_cntrto
  FROM bdafiliacion.dbo.tbcontratos c WITH (NOLOCK)
  WHERE c.cnsctvo_cdgo_tpo_cntrto = 2
AND c.fn_vgnca_cntrto between   @lnfechacortedesde and @lnfechacortehasta
--   AND c.fn_vgnca_cntrto between   '20100101' and '20100131'
      


		update cc
		set cc.cnsctvo_estdo_cnta_cntrto = det.cnsctvo_estdo_cnta_cntrto
		from #tmpcontratospac cc 
	    inner  join  (select 		max(ecc.cnsctvo_estdo_cnta_cntrto) cnsctvo_estdo_cnta_cntrto, ecc.nmro_cntrto
		                                   		from #tmpcontratospac v
		                                      inner join bdcarterapac.dbo.tbEstadosCuentaContratos ecc 
		                                      on v.nmro_cntrto = ecc.nmro_cntrto
                                              --where v.nmro_cntrto = 1016130
 	                                        group by  ecc.nmro_cntrto) det
		on det.nmro_cntrto = cc.nmro_cntrto
		
		
		
		update e
		set e.sldo_fvr = isnull(ecc.sldo_fvr,0),
           e.ttl_fctrdo = ecc.vlr_cbrdo
		from #tmpcontratospac e inner join  bdcarterapac.dbo.tbEstadosCuentaContratos ecc 
		on e.cnsctvo_estdo_cnta_cntrto = ecc.cnsctvo_estdo_cnta_cntrto

        update e
		set e.nmro_estdo_cnta = ec.nmro_estdo_cnta,
			e.cnsctvo_scrsl = ec.cnsctvo_scrsl,
			e.cnsctvo_cdgo_clse_aprtnte = ec.cnsctvo_cdgo_clse_aprtnte,
			e.nmro_unco_idntfccn_empldr = ec.nmro_unco_idntfccn_empldr
from #tmpcontratospac e inner join  bdcarterapac.dbo.tbEstadosCuentaContratos ecc 
on e.cnsctvo_estdo_cnta_cntrto = ecc.cnsctvo_estdo_cnta_cntrto
inner join bdcarterapac.dbo.tbestadoscuenta ec
on ec.cnsctvo_estdo_cnta = ecc.cnsctvo_estdo_cnta
				
    
select sum(isnull(vlr_abno_cta,0) + isnull(vlr_abno_iva,0)) vlr_pgo    , b.cnsctvo_estdo_cnta_cntrto
into #tbPagos
from bdCarteraPac.dbo.tbAbonosContrato a inner join #tmpcontratospac b 
on a.cnsctvo_estdo_cnta_cntrto	= b.cnsctvo_estdo_cnta_cntrto
inner join  bdCarteraPac.dbo.tbPagos c 
on c.cnsctvo_cdgo_pgo			= a.cnsctvo_cdgo_pgo
group by b.cnsctvo_estdo_cnta_cntrto

--se actualiza el valor del pago 
update a  
set a.ttl_pgdo= b.vlr_pgo
from #tmpcontratospac a inner join #tbPagos b 
on a.cnsctvo_estdo_cnta_cntrto  = b.cnsctvo_estdo_cnta_cntrto

update e
set mrca_estds_cnta = 'S'
from #tmpcontratospac e 
where e.ttl_pgdo >  e.ttl_fctrdo

delete from #tmpcontratospac  where  mrca_estds_cnta is null

update  #tmpcontratospac 
set sldo_fvr = ttl_fctrdo - ttl_pgdo
 
select ti.cdgo_tpo_idntfccn as Tipo_Id_Contratante,
       v.nmro_idntfccn as Num_Id_Contratante,
       ti2.cdgo_tpo_idntfccn as Tipo_Id_ResponsablePago,
       v2.nmro_idntfccn as Num_Id_ResponsablePago,  
       a.nmro_cntrto as Contrato , 
       b.dscrpcn_pln as [Plan], 
       a.inco_vgnca as Inicio_Vigencia_Contrato,
       a.fn_vgnca as Fin_Vigencia_Contrato,
       a.nmro_estdo_cnta as Numero_Estado_Cuenta,
       a.ttl_fctrdo as Valor_Estado_Cuenta,
       a.ttl_pgdo as  Valor_Pagos,
       a.sldo_fvr as Saldo_Favor
from #tmpcontratospac a inner join bdplanbeneficios.dbo.tbplanes b
on a.cnsctvo_cdgo_pln = b.cnsctvo_cdgo_pln
inner join bdafiliacion.dbo.tbvinculados v
on a.nmro_unco_idntfccn_afldo = v.nmro_unco_idntfccn
inner join bdafiliacion.dbo.tbtiposidentificacion ti
on v.cnsctvo_cdgo_tpo_idntfccn = ti.cnsctvo_cdgo_tpo_idntfccn
inner join bdafiliacion.dbo.tbvinculados v2
on a.nmro_unco_idntfccn_empldr = v2.nmro_unco_idntfccn
inner join bdafiliacion.dbo.tbtiposidentificacion ti2
on v2.cnsctvo_cdgo_tpo_idntfccn = ti2.cnsctvo_cdgo_tpo_idntfccn
