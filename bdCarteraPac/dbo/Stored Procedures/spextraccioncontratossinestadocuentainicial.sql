
/*--------------------------------------------------------------------------------- 
* Metodo o PRG 			: spExtraccionContratosSinEstadoCuentaInicial
* Desarrollado por		: <\A Ing. Diana Lorena Gomez Betancourt					A\> 
* Descripcion			: <\D  permita generar un informe de los contratos de PAC que no tengan generado un estado de 
                       cuenta o nota debito para el período inicial o alguno de sus períodos D\> 
* Observaciones			: <\O  											O\> 
* Parametros			: <\P  Recibe la fecha a partir de la cual se va a consultar la vigencia de los contratos P\> 
*				: <\P 											P\> 
*				: <\P 							 				P\> 
* Variables			: <\V  											V\> 
* Fecha Creacion		: <\FC 2008/11/24									FC\> 
*--------------------------------------------------------------------------------- 
* DATOS DE MODIFICACION 
*--------------------------------------------------------------------------------- 
Sau	Analista		Descripción 
sisdgb01 14/07/2014 Se ajusta de acuerdo a requerimiento de Carlos Andres Velasquez, se debe mostrar los casos en los que alguno de los beneficiarios
					no tiene EC o ND del mes en el cual iniciaron vigencia en el plan, esto para detectar casos de inclusiones que estan presentando
					inconsistencia en la facturacion.
sisdgb01 23/01/2015 Se ajuste el condicional para traer las fechas sin restarle un mes al periodo inicial a comparar de esta manera no trae notas que no corresponden al periodo.
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[spextraccioncontratossinestadocuentainicial]
AS

SET NOCOUNT ON


DECLARE @ltfechacortedesde datetime,
	 @ltfechacortehasta datetime



	 create table #tmpPeriodosLiquidacion
	 (cnsctvo_cdgo_prdo_lqdcn int,
	  inco_vgnca datetime,
	  fn_vgnca datetime ,
	  inco_prdo int,
	  fn_prdo int )

CREATE TABLE #tmpcontratospac
   (
   nmro_cntrto char (15),
   cnsctvo_cdgo_tpo_cntrto int,
   nmro_unco_idntfccn_afldo int,
   prdo_lqdcn int,
     inco_vgnca_prdo datetime,
	  fn_vgnca_prdo datetime ,
   )
	 
	 
CREATE TABLE #tmpvigenciascontrato
   (
   nmro_cntrto udtNumeroFormulario,
   cnsctvo_cdgo_tpo_cntrto int,
   nmro_unco_idntfccn_afldo int,
   nmro_unco_idntfccn_empldr int,
   inco_vgnca_estdo_cntrto datetime,
   fn_vgnca_estdo_cntrto datetime,
   prdo_lqdcn int,
        inco_vgnca_prdo datetime,
	  fn_vgnca_prdo datetime ,
   prdo_inco int,
   inico2 datetime,
   fin2 datetime,
   mrca_estds_cnta char (1),
   cntdd_estds_cnta int,
   mrca_nts char (1),
   cntdd_nts char (1),
   dscrpcn varchar (200),
   obsrvcns varchar(500),
   cnsctvo_cdgo_tpo_frmlro int,
   nmro_frmlro varchar(20),
   fcha_trspso_frmlro datetime,
   dscrpcn_pln varchar(20)

      )


CREATE TABLE #tmpvigenciasbeneficiarios
   (
   nmro_cntrto udtNumeroFormulario,
   cnsctvo_cdgo_tpo_cntrto int,
   cnsctvo_bnfcro int,
   nmro_unco_idntfccn_bnfcro int,
   nmro_unco_idntfccn_empldr int,
   inco_vgnca_estdo_bnfcro datetime,
   fn_vgnca_estdo_bnfcro datetime,
      prdo_lqdcn int,
        inco_vgnca_prdo datetime,
	  fn_vgnca_prdo datetime ,
   prdo_inco int,
   inico2 datetime,
   fin2 datetime,
   mrca_estds_cnta char (1),
   cntdd_estds_cnta int,
   mrca_nts char (1),
   cntdd_nts char (1),
   dscrpcn varchar (200),
   cnsctvo_cdgo_tpo_frmlro int,
   nmro_frmlro varchar(20),
   fcha_trspso_frmlro datetime,
   dscrpcn_pln varchar(20)
      )





IF EXISTS (SELECT 1
             FROM #tbcriteriostmp
            WHERE cdgo_cmpo = 'fcha_crte')
   BEGIN
      SELECT @ltfechacortedesde = vlr
      FROM #tbcriteriostmp
      WHERE cdgo_cmpo = 'fcha_crte' AND oprdr = '>='
      SELECT @ltfechacortehasta = vlr
      FROM #tbcriteriostmp
      WHERE cdgo_cmpo = 'fcha_crte' AND oprdr = '<='
   END


 
     insert into #tmpPeriodosLiquidacion
      ( cnsctvo_cdgo_prdo_lqdcn  ,
	  inco_vgnca  ,
	  fn_vgnca   ,
	  inco_prdo  ,
	  fn_prdo   )
   	  select cnsctvo_cdgo_prdo_lqdcn, fcha_incl_prdo_lqdcn,
		fcha_fnl_prdo_lqdcn,
		convert(char(6),fcha_incl_prdo_lqdcn,112) , 
		convert(char(6),fcha_fnl_prdo_lqdcn,112) 
	from tbperiodosliquidacion_vigencias
	where fcha_incl_prdo_lqdcn between @ltfechacortedesde and @ltfechacortehasta

 
INSERT
  INTO #tmpcontratospac
  (nmro_cntrto, cnsctvo_cdgo_tpo_cntrto, nmro_unco_idntfccn_afldo,prdo_lqdcn,      inco_vgnca_prdo ,	  fn_vgnca_prdo )
  SELECT c.nmro_cntrto, c.cnsctvo_cdgo_tpo_cntrto, c.nmro_unco_idntfccn_afldo, inco_prdo, b.  inco_vgnca ,	  b.fn_vgnca  
    FROM bdafiliacion.dbo.tbcontratos c WITH (NOLOCK)  inner join #tmpPeriodosLiquidacion b
	on b.inco_vgnca between c.inco_vgnca_cntrto and c.fn_vgnca_cntrto
   WHERE c.cnsctvo_cdgo_tpo_cntrto = 2
     AND c.estdo_cntrto = 'A'
    order by nmro_cntrto

  
INSERT
  INTO #tmpvigenciascontrato
      (nmro_cntrto,
       cnsctvo_cdgo_tpo_cntrto,
       nmro_unco_idntfccn_afldo,
       inco_vgnca_estdo_cntrto,
       fn_vgnca_estdo_cntrto,
	      prdo_lqdcn ,
        inco_vgnca_prdo ,
	  fn_vgnca_prdo )
  SELECT c.nmro_cntrto,
         c.cnsctvo_cdgo_tpo_cntrto,
          c.nmro_unco_idntfccn_afldo,
         vc.inco_vgnca_estdo_cntrto,
         vc.fn_vgnca_estdo_cntrto,
		 c.prdo_lqdcn,
		 c.inco_vgnca_prdo,
		 c.fn_vgnca_prdo
    FROM    #tmpcontratospac c
         INNER JOIN
            bdafiliacion.dbo.tbvigenciascontrato vc WITH (NOLOCK)
         ON c.nmro_cntrto = vc.nmro_cntrto
        AND c.cnsctvo_cdgo_tpo_cntrto = vc.cnsctvo_cdgo_tpo_cntrto
   WHERE vc.estdo_rgstro = 'S'
   and c.inco_vgnca_prdo between  vc.inco_vgnca_estdo_cntrto  and vc.fn_vgnca_estdo_cntrto
--   and vc.inco_vgnca_estdo_cntrto between @ltfechacortedesde and @ltfechacortehasta
    
	--select * from #tmpvigenciascontrato

--	truncate table #tmpVigenciasbeneficiarios
	insert into #tmpVigenciasbeneficiarios
	(nmro_cntrto,
	cnsctvo_cdgo_tpo_cntrto,
	cnsctvo_bnfcro,
	nmro_unco_idntfccn_bnfcro,
	inco_vgnca_estdo_bnfcro,
	fn_vgnca_estdo_bnfcro,
	      prdo_lqdcn ,
        inco_vgnca_prdo ,
	  fn_vgnca_prdo  ) 
		 SELECT vc.nmro_cntrto,
         vc.cnsctvo_cdgo_tpo_cntrto,
		 vc.cnsctvo_bnfcro,
          b.nmro_unco_idntfccn_bnfcro,
         vc.inco_vgnca_estdo_bnfcro,
         vc.fn_vgnca_estdo_bnfcro,
		 prdo_lqdcn ,
        inco_vgnca_prdo ,
		fn_vgnca_prdo 
    FROM    #tmpcontratospac c
         INNER JOIN
            bdafiliacion.dbo.tbvigenciasbeneficiarios vc WITH (NOLOCK)
         ON c.nmro_cntrto = vc.nmro_cntrto
        AND c.cnsctvo_cdgo_tpo_cntrto = vc.cnsctvo_cdgo_tpo_cntrto
		inner join     bdafiliacion.dbo.tbbeneficiarios b 
		on vc.nmro_cntrto = b.nmro_cntrto
		and vc.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto
		and vc.cnsctvo_bnfcro = b.cnsctvo_bnfcro
   WHERE vc.estdo_rgstro = 'S'
 and c.inco_vgnca_prdo between  vc.inco_vgnca_estdo_bnfcro  and vc.fn_vgnca_estdo_bnfcro
--   and vc.inco_vgnca_estdo_bnfcro between @ltfechacortedesde and @ltfechacortehasta
    

  UPDATE #tmpvigenciascontrato
  SET prdo_inco =          substring (convert (char (10), inco_vgnca_estdo_cntrto, 103), 7, 4)        +  substring (convert (char (10), inco_vgnca_estdo_cntrto, 103), 4, 2)

UPDATE #tmpvigenciascontrato
 SET inico2 = bdrecaudos.dbo.fnconvierteperiodofecha (prdo_inco, 1)
	 
UPDATE #tmpvigenciascontrato
SET fin2 = dateadd(day, -1, dateadd(month, datediff(month, 0, bdrecaudos.dbo.fnconvierteperiodofecha(prdo_inco,1))+1, 0))

UPDATE #tmpVigenciasbeneficiarios
   SET prdo_inco =          substring (convert (char (10), inco_vgnca_estdo_bnfcro, 103), 7, 4)        +  substring (convert (char (10), inco_vgnca_estdo_bnfcro, 103), 4, 2)

UPDATE #tmpVigenciasbeneficiarios
   SET inico2 = bdrecaudos.dbo.fnconvierteperiodofecha (prdo_inco, 1)
	 
UPDATE #tmpVigenciasbeneficiarios
SET fin2 = dateadd(day, -1, dateadd(month, datediff(month, 0, bdrecaudos.dbo.fnconvierteperiodofecha(prdo_inco,1))+1, 0))
 

UPDATE vc
SET   vc.cnsctvo_cdgo_tpo_frmlro =  fc.cnsctvo_cdgo_tpo_frmlro,
   vc.nmro_frmlro  =fc.nmro_frmlro
FROM #tmpvigenciascontrato vc  inner join bdafiliacion.dbo.tbformulariosxcontrato fc
ON vc.nmro_cntrto = fc.nmro_cntrto
 AND vc.cnsctvo_cdgo_tpo_cntrto = fc.cnsctvo_cdgo_tpo_cntrto


 UPDATE vc
SET   vc.cnsctvo_cdgo_tpo_frmlro =  fc.cnsctvo_cdgo_tpo_frmlro,
   vc.nmro_frmlro  =fc.nmro_frmlro
FROM #tmpVigenciasbeneficiarios vc  inner join bdafiliacion.dbo.tbformulariosxcontrato fc
ON vc.nmro_cntrto = fc.nmro_cntrto
 AND vc.cnsctvo_cdgo_tpo_cntrto = fc.cnsctvo_cdgo_tpo_cntrto

UPDATE vc
SET vc.fcha_trspso_frmlro = f.fcha_cmbo_estdo
FROM #tmpvigenciascontrato vc inner join bdafiliacion.dbo.tbestadosxformularios f
on vc.cnsctvo_cdgo_tpo_frmlro = f.cnsctvo_cdgo_tpo_frmlro
and vc.nmro_frmlro = f.nmro_frmlro
where f.cnsctvo_cdgo_estdo_frmlro = 6


UPDATE vc
SET vc.fcha_trspso_frmlro = f.fcha_cmbo_estdo
FROM #tmpVigenciasbeneficiarios vc inner join bdafiliacion.dbo.tbestadosxformularios f
on vc.cnsctvo_cdgo_tpo_frmlro = f.cnsctvo_cdgo_tpo_frmlro
and vc.nmro_frmlro = f.nmro_frmlro
where f.cnsctvo_cdgo_estdo_frmlro = 6

UPDATE vc
SET vc.dscrpcn_pln = ltrim(rtrim(p.dscrpcn_pln))
FROM #tmpvigenciascontrato vc inner join bdafiliacion.dbo.tbcontratos c
ON vc.nmro_cntrto = c.nmro_cntrto
 AND vc.cnsctvo_cdgo_tpo_cntrto = c.cnsctvo_cdgo_tpo_cntrto
inner join bdplanbeneficios.dbo.tbplanes p
on c.cnsctvo_cdgo_pln = p.cnsctvo_cdgo_pln

 

UPDATE vc
SET vc.dscrpcn_pln = ltrim(rtrim(p.dscrpcn_pln))
FROM #tmpVigenciasbeneficiarios vc inner join bdafiliacion.dbo.tbcontratos c
ON vc.nmro_cntrto = c.nmro_cntrto
 AND vc.cnsctvo_cdgo_tpo_cntrto = c.cnsctvo_cdgo_tpo_cntrto
inner join bdplanbeneficios.dbo.tbplanes p
on c.cnsctvo_cdgo_pln = p.cnsctvo_cdgo_pln

update a
set a.nmro_unco_idntfccn_empldr = cb.nmro_unco_idntfccn_aprtnte
from  #tmpvigenciascontrato a
inner join bdafiliacion.dbo.tbvigenciascobranzas vc
on a.nmro_cntrto = vc.nmro_cntrto
and a.cnsctvo_cdgo_tpo_cntrto = vc.cnsctvo_cdgo_tpo_cntrto
inner join bdafiliacion.dbo.tbcobranzas cb
on vc.nmro_cntrto = cb.nmro_cntrto
and vc.cnsctvo_cdgo_tpo_cntrto = cb.cnsctvo_cdgo_tpo_cntrto
and vc.cnsctvo_cbrnza = cb.cnsctvo_cbrnza
where a.inco_vgnca_prdo between      vc.inco_vgnca_cbrnza  and vc.fn_vgnca_cbrnza
and vc.estdo_rgstro = 'S'
and cb.estdo  = 'A'

 
 

update a
set a.nmro_unco_idntfccn_empldr = cb.nmro_unco_idntfccn_aprtnte
from  #tmpVigenciasbeneficiarios a
inner join bdafiliacion.dbo.tbvigenciascobranzas vc
on a.nmro_cntrto = vc.nmro_cntrto
and a.cnsctvo_cdgo_tpo_cntrto = vc.cnsctvo_cdgo_tpo_cntrto
inner join bdafiliacion.dbo.tbcobranzas cb
on vc.nmro_cntrto = cb.nmro_cntrto
and vc.cnsctvo_cdgo_tpo_cntrto = cb.cnsctvo_cdgo_tpo_cntrto
and vc.cnsctvo_cbrnza = cb.cnsctvo_cbrnza
where  a.inco_vgnca_prdo between      vc.inco_vgnca_cbrnza  and vc.fn_vgnca_cbrnza
and vc.estdo_rgstro = 'S'
and cb.estdo  = 'A'


SELECT ecc.nmro_cntrto, prdo_lqdcn,count (ecc.cnsctvo_estdo_cnta_cntrto) cntdd_estds_cnta
  INTO #tmpcantidadestadoscuenta
  FROM   bdcarterapac.dbo.tbestadoscuenta ec
                INNER JOIN
                   bdcarterapac.dbo.tbestadoscuentacontratos ecc
                ON ec.cnsctvo_estdo_cnta = ecc.cnsctvo_estdo_cnta
             INNER JOIN
                bdcarterapac.dbo.tbliquidaciones lq
             ON ec.cnsctvo_cdgo_lqdcn = lq.cnsctvo_cdgo_lqdcn
          INNER JOIN
             bdcarterapac.dbo.tbperiodosliquidacion_vigencias plv
          ON lq.cnsctvo_cdgo_prdo_lqdcn = plv.cnsctvo_cdgo_prdo_lqdcn
       INNER JOIN
          (SELECT nmro_cntrto,prdo_lqdcn, inco_vgnca_prdo as inico2 , fn_vgnca_prdo as fin2
             FROM #tmpvigenciascontrato
            GROUP BY nmro_cntrto, prdo_lqdcn,inco_vgnca_prdo, fn_vgnca_prdo) det
       ON ecc.nmro_cntrto = det.nmro_cntrto
 WHERE plv.fcha_incl_prdo_lqdcn BETWEEN det.inico2 AND det.fin2
 GROUP BY ecc.nmro_cntrto, det.prdo_lqdcn

 


 SELECT ecc.nmro_cntrto,prdo_lqdcn, ctb.nmro_unco_idntfccn_bnfcro, count (ecc.cnsctvo_estdo_cnta_cntrto) cntdd_estds_cnta
  INTO #tmpcantidadestadoscuentaxbeneficiario
  FROM   bdcarterapac.dbo.tbestadoscuenta ec
                INNER JOIN
                   bdcarterapac.dbo.tbestadoscuentacontratos ecc
                ON ec.cnsctvo_estdo_cnta = ecc.cnsctvo_estdo_cnta
             INNER JOIN
                bdcarterapac.dbo.tbliquidaciones lq
             ON ec.cnsctvo_cdgo_lqdcn = lq.cnsctvo_cdgo_lqdcn
          INNER JOIN
             bdcarterapac.dbo.tbperiodosliquidacion_vigencias plv
          ON lq.cnsctvo_cdgo_prdo_lqdcn = plv.cnsctvo_cdgo_prdo_lqdcn
           INNER JOIN
          (SELECT nmro_cntrto, nmro_unco_idntfccn_bnfcro,cnsctvo_bnfcro,prdo_lqdcn, inco_vgnca_prdo as inico2 , fn_vgnca_prdo as fin2
             FROM #tmpVigenciasbeneficiarios
            GROUP BY nmro_cntrto,nmro_unco_idntfccn_bnfcro,cnsctvo_bnfcro, prdo_lqdcn,inco_vgnca_prdo, fn_vgnca_prdo) det
       ON ecc.nmro_cntrto = det.nmro_cntrto
	   inner join bdcarterapac.dbo.tbcuentascontratosbeneficiarios ctb
	   on ctb.cnsctvo_estdo_cnta_cntrto = ecc.cnsctvo_estdo_cnta_cntrto
	  WHERE plv.fcha_incl_prdo_lqdcn BETWEEN det.inico2 AND det.fin2
  and ctb.nmro_unco_idntfccn_bnfcro = det.nmro_unco_idntfccn_bnfcro
 GROUP BY ecc.nmro_cntrto,prdo_lqdcn, ctb.nmro_unco_idntfccn_bnfcro

 
UPDATE cp
SET cp.cntdd_estds_cnta = cec.cntdd_estds_cnta
FROM #tmpvigenciascontrato cp INNER JOIN #tmpcantidadestadoscuenta cec
ON cp.nmro_cntrto = cec.nmro_cntrto
		 and cp.prdo_lqdcn = cec.prdo_lqdcn

		 UPDATE cp
   SET cp.cntdd_estds_cnta = cec.cntdd_estds_cnta
 FROM #tmpVigenciasbeneficiarios cp INNER JOIN #tmpcantidadestadoscuentaxbeneficiario cec
         ON cp.nmro_cntrto = cec.nmro_cntrto
		   and cp.nmro_unco_idntfccn_bnfcro = cec.nmro_unco_idntfccn_bnfcro
		    and cp.prdo_lqdcn = cec.prdo_lqdcn


UPDATE #tmpvigenciascontrato
   SET mrca_estds_cnta = ' '

UPDATE cp
   SET cp.mrca_estds_cnta = 'N'
 FROM #tmpvigenciascontrato cp
 WHERE cp.cntdd_estds_cnta IS NULL

UPDATE cp
   SET cp.mrca_estds_cnta = 'S'
 FROM #tmpvigenciascontrato cp
 WHERE cp.cntdd_estds_cnta IS NOT NULL


UPDATE #tmpVigenciasbeneficiarios
   SET mrca_estds_cnta = ' '

UPDATE cp
   SET cp.mrca_estds_cnta = 'N'
 FROM #tmpVigenciasbeneficiarios cp
 WHERE cp.cntdd_estds_cnta IS NULL

UPDATE cp
   SET cp.mrca_estds_cnta = 'S'
 FROM #tmpVigenciasbeneficiarios cp
 WHERE cp.cntdd_estds_cnta IS NOT NULL


SELECT  ntc.nmro_cntrto,c.[nmro_unco_idntfccn_bnfcro], count(ntc.nmro_nta) cntdd_nts
INTO #tmpcantidadnotasbeneficiario
FROM   bdcarterapac.dbo.tbnotascontrato  ntc
inner join #tmpVigenciasbeneficiarios b
on ntc.nmro_cntrto = b.nmro_cntrto
 inner join bdcarterapac.dbo.tbNotasBeneficiariosContratos c
 on ntc. [cnsctvo_nta_cntrto] = c.[cnsctvo_nta_cntrto]
 where ntc.cnsctvo_cdgo_tpo_nta = 1
 and c.[nmro_unco_idntfccn_bnfcro] = b.[nmro_unco_idntfccn_bnfcro]
GROUP BY   ntc.nmro_cntrto,c.[nmro_unco_idntfccn_bnfcro]


SELECT  ntc.nmro_cntrto, count(ntc.nmro_nta) cntdd_nts
INTO #tmpcantidadnotascontrato
FROM   bdcarterapac.dbo.tbnotascontrato  ntc
WHERE  nmro_cntrto IN (SELECT nmro_cntrto FROM   #tmpvigenciascontrato
GROUP BY  nmro_cntrto  )
AND ntc.cnsctvo_cdgo_tpo_nta = 1
GROUP BY   ntc.nmro_cntrto

--drop table #tmpcantidadnotasbeneficiariofecha
SELECT  ntc.nmro_cntrto, det.prdo_lqdcn, c.[nmro_unco_idntfccn_bnfcro],count(ntc.nmro_nta) cntdd_nts
INTO #tmpcantidadnotasbeneficiariofecha
FROM bdcarterapac.dbo.tbnotaspac np
INNER JOIN bdcarterapac.dbo.tbnotascontrato  ntc
ON np.nmro_nta = ntc.nmro_nta
AND np.cnsctvo_cdgo_tpo_nta = ntc.cnsctvo_cdgo_tpo_nta
 inner join bdcarterapac.dbo.tbNotasBeneficiariosContratos c
 on ntc. [cnsctvo_nta_cntrto] = c.[cnsctvo_nta_cntrto]
INNER JOIN (SELECT nmro_cntrto,[nmro_unco_idntfccn_bnfcro],prdo_lqdcn, inco_vgnca_prdo as inico2 , fn_vgnca_prdo as fin2  FROM  #tmpVigenciasbeneficiarios
        GROUP BY  nmro_cntrto,[nmro_unco_idntfccn_bnfcro],prdo_lqdcn, inco_vgnca_prdo   , fn_vgnca_prdo  ) det
ON ntc.nmro_cntrto = det.nmro_cntrto
 --WHERE np.fcha_prdo_nta BETWEEN dateadd(mm,-1,det.inico2) AND det.fin2
  WHERE np.fcha_prdo_nta BETWEEN  det.inico2 AND det.fin2
and c.[nmro_unco_idntfccn_bnfcro] = det.[nmro_unco_idntfccn_bnfcro]
GROUP BY   ntc.nmro_cntrto, c.[nmro_unco_idntfccn_bnfcro], det.prdo_lqdcn
 
-- drop table #tmpcantidadnotascontratofecha
SELECT  ntc.nmro_cntrto, det.prdo_lqdcn, count(ntc.nmro_nta) cntdd_nts
INTO #tmpcantidadnotascontratofecha  
FROM bdcarterapac.dbo.tbnotaspac np
INNER JOIN bdcarterapac.dbo.tbnotascontrato  ntc
ON np.nmro_nta = ntc.nmro_nta
AND np.cnsctvo_cdgo_tpo_nta = ntc.cnsctvo_cdgo_tpo_nta
INNER JOIN (SELECT nmro_cntrto, prdo_lqdcn, inco_vgnca_prdo as inico2 , fn_vgnca_prdo as fin2 FROM  #tmpvigenciascontrato
        GROUP BY  nmro_cntrto, prdo_lqdcn,inco_vgnca_prdo, fn_vgnca_prdo ) det
ON ntc.nmro_cntrto = det.nmro_cntrto
--WHERE np.fcha_prdo_nta BETWEEN dateadd(mm,-1,det.inico2) AND det.fin2
  WHERE np.fcha_prdo_nta BETWEEN  det.inico2 AND det.fin2
GROUP BY   ntc.nmro_cntrto, det.prdo_lqdcn

--drop table #tmpcantidadnotascontratonoenfecha
 SELECT ntc.nmro_cntrto,prdo_lqdcn, count (ntc.nmro_nta) cntdd_nts
  INTO #tmpcantidadnotascontratonoenfecha
  FROM       bdcarterapac.dbo.tbnotaspac np
          INNER JOIN
             bdcarterapac.dbo.tbnotascontrato ntc
          ON np.nmro_nta = ntc.nmro_nta
         AND np.cnsctvo_cdgo_tpo_nta = ntc.cnsctvo_cdgo_tpo_nta
       INNER JOIN
          (SELECT nmro_cntrto,prdo_lqdcn, inco_vgnca_prdo as inico2 , fn_vgnca_prdo as fin2 
             FROM #tmpvigenciascontrato
            GROUP BY nmro_cntrto, prdo_lqdcn, inco_vgnca_prdo  , fn_vgnca_prdo  ) det
       ON ntc.nmro_cntrto = det.nmro_cntrto
 WHERE np.fcha_prdo_nta > dateadd (mm, 1, det.inico2)
 GROUP BY ntc.nmro_cntrto,prdo_lqdcn


 SELECT ntc.nmro_cntrto,prdo_lqdcn,c.[nmro_unco_idntfccn_bnfcro], count (ntc.nmro_nta) cntdd_nts
  INTO #tmpcantidadnotasbeneficiarionoenfecha
  FROM       bdcarterapac.dbo.tbnotaspac np
          INNER JOIN
             bdcarterapac.dbo.tbnotascontrato ntc
          ON np.nmro_nta = ntc.nmro_nta
         AND np.cnsctvo_cdgo_tpo_nta = ntc.cnsctvo_cdgo_tpo_nta
		  inner join bdcarterapac.dbo.tbNotasBeneficiariosContratos c
 on ntc. [cnsctvo_nta_cntrto] = c.[cnsctvo_nta_cntrto]
       INNER JOIN
          ( SELECT nmro_cntrto,[nmro_unco_idntfccn_bnfcro],prdo_lqdcn, inco_vgnca_prdo as inico2 , fn_vgnca_prdo as fin2   FROM  #tmpVigenciasbeneficiarios
        GROUP BY  nmro_cntrto,[nmro_unco_idntfccn_bnfcro],prdo_lqdcn, inco_vgnca_prdo  , fn_vgnca_prdo  ) det
       ON ntc.nmro_cntrto = det.nmro_cntrto
 WHERE np.fcha_prdo_nta > dateadd (mm, 1, det.inico2)
 GROUP BY ntc.nmro_cntrto, c.[nmro_unco_idntfccn_bnfcro],prdo_lqdcn


UPDATE #tmpvigenciascontrato
   SET cntdd_nts = NULL
	 
UPDATE #tmpvigenciascontrato
   SET mrca_nts = ' '
	 
UPDATE cp
   SET cp.cntdd_nts = nt.cntdd_nts
 FROM #tmpvigenciascontrato cp INNER JOIN #tmpcantidadnotascontratofecha nt
         ON cp.nmro_cntrto = nt.nmro_cntrto
		 And	cp.prdo_lqdcn = nt.prdo_lqdcn

---select * from #tmpvigenciascontrato

UPDATE #tmpVigenciasbeneficiarios
   SET cntdd_nts = NULL
	 
UPDATE #tmpVigenciasbeneficiarios
   SET mrca_nts = ' '
	 
UPDATE cp
   SET cp.cntdd_nts = nt.cntdd_nts
 FROM #tmpVigenciasbeneficiarios cp INNER JOIN #tmpcantidadnotasbeneficiariofecha nt
         ON cp.nmro_cntrto = nt.nmro_cntrto
		  And	cp.prdo_lqdcn = nt.prdo_lqdcn

UPDATE cp
   SET cp.mrca_nts = 'F'
 FROM #tmpvigenciascontrato cp
 WHERE cp.cntdd_nts IS NOT NULL


 UPDATE cp
   SET cp.mrca_nts = 'F'
 FROM #tmpVigenciasbeneficiarios cp
 WHERE cp.cntdd_nts IS NOT NULL


UPDATE cp
   SET cp.cntdd_nts = nt.cntdd_nts
 FROM #tmpvigenciascontrato cp INNER JOIN #tmpcantidadnotascontratonoenfecha nt
         ON cp.nmro_cntrto = nt.nmro_cntrto


		 UPDATE cp
   SET cp.cntdd_nts = nt.cntdd_nts
 FROM #tmpVigenciasbeneficiarios cp INNER JOIN #tmpcantidadnotasbeneficiarionoenfecha nt
         ON cp.nmro_cntrto = nt.nmro_cntrto


UPDATE cp
   SET cp.mrca_nts = 'D'
 FROM #tmpVigenciasbeneficiarios cp
 WHERE cp.cntdd_nts IS NOT NULL AND mrca_nts = ' '

UPDATE cp
   SET cp.mrca_nts = 'N'
 FROM #tmpVigenciasbeneficiarios cp
 WHERE cp.cntdd_nts IS NULL 
       AND mrca_nts = ' '
	   
	   UPDATE cp
   SET cp.mrca_nts = 'D'
 FROM #tmpvigenciascontrato cp
 WHERE cp.cntdd_nts IS NOT NULL AND mrca_nts = ' '

UPDATE cp
   SET cp.mrca_nts = 'N'
 FROM #tmpvigenciascontrato cp
 WHERE cp.cntdd_nts IS NULL 
       AND mrca_nts = ' '

update #tmpvigenciascontrato
set dscrpcn = null

--  select * from #tmpvigenciascontrato where mrca_estds_cnta != 'S'
UPDATE #tmpvigenciascontrato 
   SET dscrpcn = 'Contratos sin EC y sin ND'
 WHERE mrca_estds_cnta = 'N' AND mrca_nts = 'N'
 
 
UPDATE #tmpvigenciascontrato 
   SET dscrpcn = 'Contratos sin EC con ND al inicio de vigencia del contrato'
 WHERE mrca_estds_cnta = 'N' AND mrca_nts = 'F'
  and prdo_lqdcn = prdo_inco
  and dscrpcn is null
 
 UPDATE #tmpvigenciascontrato 
   SET dscrpcn = 'Contratos sin EC con ND para el periodo'
 WHERE mrca_estds_cnta = 'N' AND mrca_nts = 'F'
 and prdo_lqdcn != prdo_inco
   and dscrpcn is null
 
UPDATE #tmpvigenciascontrato 
 SET dscrpcn = 'Contratos sin EC con ND después del inicio de vigencia'
 WHERE mrca_estds_cnta = 'N' AND mrca_nts = 'D'
 and dscrpcn is null
 
 UPDATE #tmpVigenciasbeneficiarios 
   SET dscrpcn = 'Contratos sin EC y sin ND'
 WHERE mrca_estds_cnta = 'N' AND mrca_nts = 'N'
 
UPDATE #tmpVigenciasbeneficiarios 
   SET dscrpcn = 'Contratos sin EC con ND al inicio de vigencia'
 WHERE mrca_estds_cnta = 'N' AND mrca_nts = 'F'
  
UPDATE #tmpVigenciasbeneficiarios 
 SET dscrpcn = 'Contratos sin EC con ND después del inicio de vigencia'
 WHERE mrca_estds_cnta = 'N' AND mrca_nts = 'D'
  
 --alter table #tmpvigenciascontrato add obsrvcns varchar(500)
  
 update #tmpvigenciascontrato
 set   dscrpcn = 'Beneficiario sin EC y sin ND '  
 from #tmpvigenciascontrato a inner join  (select nmro_cntrto, prdo_lqdcn,count(*) cantidad from #tmpVigenciasbeneficiarios where mrca_estds_cnta = 'N' and mrca_nts = 'N'  and cnsctvo_bnfcro !=1  group by nmro_cntrto, prdo_lqdcn) b
 on a.nmro_cntrto = b.nmro_cntrto 
 and a.prdo_lqdcn = b.prdo_lqdcn
 and dscrpcn is null
 
 update #tmpvigenciascontrato
 set   dscrpcn = 'Beneficiario sin EC con ND al inicio de vigencia del contrato' --+ convert(char(3), b.cantidad)
 from #tmpvigenciascontrato a inner join (select nmro_cntrto, prdo_lqdcn,count(*) cantidad from #tmpVigenciasbeneficiarios    WHERE mrca_estds_cnta = 'N' AND mrca_nts = 'F'  and cnsctvo_bnfcro !=1 group by nmro_cntrto, prdo_lqdcn) b
 on a.nmro_cntrto = b.nmro_cntrto 
 and a.prdo_lqdcn = b.prdo_lqdcn
  and dscrpcn is null
 
 update #tmpvigenciascontrato
 set   dscrpcn = 'Beneficiario sin EC con ND después del inicio de vigencia' --+ convert(char(3), b.cantidad)
 from #tmpvigenciascontrato a inner join  (select nmro_cntrto, prdo_lqdcn,count(*) cantidad from #tmpVigenciasbeneficiarios where  mrca_estds_cnta = 'N' AND mrca_nts = 'D'  and cnsctvo_bnfcro !=1  group by nmro_cntrto, prdo_lqdcn) b
 on a.nmro_cntrto = b.nmro_cntrto 
 and a.prdo_lqdcn = b.prdo_lqdcn
  and dscrpcn is null
 
 
 

SELECT 
c.nmro_cntrto as Numero_Contrato,
c.dscrpcn_pln as [Plan],
ti.cdgo_tpo_idntfccn as Tipo_Identificacion,
v.nmro_idntfccn as Numero_Identificacion,
ltrim(rtrim(prmr_nmbre)) + ' ' + ltrim(rtrim(sgndo_nmbre)) + ' ' + ltrim(rtrim(prmr_aplldo)) + ' ' + ltrim(rtrim(sgndo_aplldo))  as [Nombre_Contratante],
ti2.cdgo_tpo_idntfccn as Tipo_Id_Responsable,
v2.nmro_idntfccn as Numero_Id_Responsable,
max(ltrim(rtrim(nmbre_scrsl))) as [Nombre_responsable],
convert(char(10),c.inco_vgnca_estdo_cntrto,103) as Inicio_Vigencia_Contrato,
convert(char(10),c.fn_vgnca_estdo_cntrto,103)  as  Fin_Vigencia_Contrato,
convert(char(10),c.fcha_trspso_frmlro,103) as Fecha_Traspaso_Formulario,
ltrim(rtrim(c.dscrpcn)) AS Descripcion, 
c.prdo_lqdcn as Periodo_Liquidacion,
convert(char(10),inco_vgnca_prdo,103) as Inicio_Vigencia_Periodo,
convert(char(10),fn_vgnca_prdo,103) as Fin_Vigencia_Periodo

into #TmpInforme  
FROM    #tmpvigenciascontrato c INNER JOIN bdafiliacion.dbo.tbvinculados v
ON c.nmro_unco_idntfccn_afldo = v.nmro_unco_idntfccn
and v.vldo = 'S'
INNER JOIN bdafiliacion.dbo.tbtiposidentificacion ti
ON v.cnsctvo_cdgo_tpo_idntfccn = ti.cnsctvo_cdgo_tpo_idntfccn
inner join bdafiliacion.dbo.tbvinculados v2
on c.nmro_unco_idntfccn_empldr = v2.nmro_unco_idntfccn
inner join        bdafiliacion.dbo.tbtiposidentificacion ti2
ON v2.cnsctvo_cdgo_tpo_idntfccn = ti2.cnsctvo_cdgo_tpo_idntfccn
inner join bdafiliacion.dbo.tbpersonas p
on c.nmro_unco_idntfccn_afldo = p.nmro_unco_idntfccn
left join bdafiliacion.dbo.tbsucursalesaportante sa
on c.nmro_unco_idntfccn_empldr = sa.nmro_unco_idntfccn_empldr
WHERE  dscrpcn  is not null
group by  c.prdo_lqdcn,
c.inco_vgnca_prdo ,
c.fn_vgnca_prdo,
c.nmro_cntrto ,
c.dscrpcn_pln  ,
ti.cdgo_tpo_idntfccn,
v.nmro_idntfccn  ,
ltrim(rtrim(prmr_nmbre)) + ' ' + ltrim(rtrim(sgndo_nmbre)) + ' ' + ltrim(rtrim(prmr_aplldo)) + ' ' + ltrim(rtrim(sgndo_aplldo)) ,
ti2.cdgo_tpo_idntfccn,
v2.nmro_idntfccn ,
c.inco_vgnca_estdo_cntrto,
c.fn_vgnca_estdo_cntrto ,
c.fcha_trspso_frmlro ,
ltrim(rtrim(c.dscrpcn)) 
ORDER BY   nmro_cntrto, prdo_lqdcn,	ltrim(rtrim(c.dscrpcn))

  /*

update  a
set Nombre_Contratante = ltrim(rtrim(prmr_nmbre)) + ' ' + ltrim(rtrim(sgndo_nmbre)) + ' ' + ltrim(rtrim(prmr_aplldo)) + ' ' + ltrim(rtrim(sgndo_aplldo)) 
from #TmpInforme a inner join bdafiliacion.dbo.tbpersonas b with(nolock)
on a.Nui_Afiliado = b.nmro_unco_idntfccn 

update  a
set Nombre_Responsable= ltrim(rtrim(nmbre_scrsl))
from #TmpInforme a inner join bdafiliacion.dbo.tbsucursalesaportante b with(nolock)
on a.Nui_Responsable = b.nmro_unco_idntfccn_empldr 
where b.prncpl = 'S'

*/


select Numero_Contrato,
         [Plan],
         Tipo_Identificacion,
		 Numero_Identificacion,
		 Nombre_Contratante,
		 Tipo_Id_Responsable,
		 Numero_Id_Responsable,
		 Nombre_responsable,
		 Inicio_Vigencia_Contrato,
		 Fin_Vigencia_Contrato,
		 Fecha_Traspaso_Formulario,
		 Descripcion ,
         Periodo_Liquidacion,
         Inicio_Vigencia_Periodo,
         Fin_Vigencia_Periodo
from #TmpInforme
Group by Numero_Contrato,
         [Plan],
         Tipo_Identificacion,
		 Numero_Identificacion,
		 Nombre_Contratante,
		 Tipo_Id_Responsable,
		 Numero_Id_Responsable,
		 Nombre_responsable,
		 Inicio_Vigencia_Contrato,
		 Fin_Vigencia_Contrato,
		 Fecha_Traspaso_Formulario,
		 Descripcion ,
         Periodo_Liquidacion,
         Inicio_Vigencia_Periodo,
         Fin_Vigencia_Periodo
order by Numero_Contrato,  Inicio_Vigencia_Contrato
 