/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spConsultaPagos
* Desarrollado por		: <\A Ing. ROLANDO SIMBAQUEVA LASSO								A\>
* Descripcion			: <\D Este procedimiento realiza la consulta de los pagos						  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P 													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/02 											FC\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		 : <\AM   Ing. Sandra Milena Ruiz Reyes 	AM\>
* Descripcion			 : <\DM   Aplicacion de tecnicas de optimizacionDM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM   06/09/2005				FM\>
*--------------------------------------------------------------------------------
* Modificado Por		 : <\AM   Ing. Fernnado Valencia E 	AM\>
* Descripcion			 : <\DM   Se adiciona el campo  fcha_intrfse DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM   29/06/2006			FM\>
*--------------------------------------------------------------------------------
* Modificado Por		 : <\AM   Jairo Valencia 	AM\>
* Descripcion			 : <\DM   Se adiciona el campo  fcha_intrfse DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM   10/07/2013			FM\>
*---------------------------------------------------------------------------------*/


CREATE   PROCEDURE [dbo].[spConsultaPagos] @lnEstadoPago	udtConsecutivo
As  			

declare
@Tipo_documento_pac	int

set nocount on				
set	@Tipo_documento_pac	=	2

Create table #TmpPagos(
	cnsctvo_cdgo_pgo		udtConsecutivo,
	nmro_dcmnto			udtNumeroFormulario,
	vlr_dcmnto			udtValorGrande,	
	nmro_unco_idntfccn_empldr	udtConsecutivo,
	cnsctvo_scrsl			udtConsecutivo,
	cnsctvo_cdgo_clse_aprtnte	udtConsecutivo,
	fcha_rcdo			datetime,
	fcha_aplcn			datetime,
	nmro_rmsa			int,
	nmro_lna			int,
	cnsctvo_cdgo_estdo_pgo	udtConsecutivo,
	cnsctvo_cdgo_tpo_pgo		udtConsecutivo,	
	usro_crcn			udtUsuario,
	sldo_pgo			udtValorGrande,
	dscrpcn_estdo_pgo		udtDescripcion,	
	dscrpcn_tpo_pgo		udtDescripcion,
	nmbre_scrsl			varchar(200),
	nmro_idntfccn			udtNumeroIdentificacion,
	cdgo_tpo_idntfccn		udtTipoIdentificacion,
	dscrpcn_clse_aprtnte		varchar(30),	
	rzn_scl				varchar(200),	
	cnsctvo_cdgo_tpo_idntfccn	int,
  	dgto_vrfccn			int,
	cnsctvo_prcso		int,
	fcha_fn_prcso		datetime,
	vlr_ants_iva        int,
	vlr_iva				int,
)

Insert into #TmpPagos
Select	a.cnsctvo_cdgo_pgo,		a.nmro_dcmnto, 		a.vlr_dcmnto,	
	a.nmro_unco_idntfccn_empldr,	a.cnsctvo_scrsl,	a.cnsctvo_cdgo_clse_aprtnte,
	a.fcha_rcdo, 			a.fcha_aplccn,	a.nmro_rmsa,		a.nmro_lna,
	a.cnsctvo_cdgo_estdo_pgo,  	a.cnsctvo_cdgo_tpo_pgo,	a.usro_crcn,
	a.sldo_pgo,			e.dscrpcn_estdo_pgo,	t.dscrpcn_tpo_pgo,
	r.rzn_scl nmbre_scrsl,		r.nmro_idntfccn,	r.tpo_idntfccn	cdgo_tpo_idntfccn,
	space(30)dscrpcn_clse_aprtnte,	SPACE(200) AS rzn_scl,	0 cnsctvo_cdgo_tpo_idntfccn,
        	0 dgto_vrfccn, a.cnsctvo_prcso,  space(10) as fcha_fn_prcso,0,0
FROM    bdCarteraPac.dbo.tbPagos a INNER JOIN
	bdAdmonRecaudo.dbo.tbRecaudoConciliado r ON a.cnsctvo_rcdo_cncldo = r.cnsctvo_rcdo_cncldo INNER JOIN
        bdCarteraPac.dbo.tbEstadosPago e ON a.cnsctvo_cdgo_estdo_pgo = e.cnsctvo_cdgo_estdo_pgo INNER JOIN
        bdCarteraPac.dbo.tbTiposPago T ON a.cnsctvo_cdgo_tpo_pgo = T.cnsctvo_cdgo_tpo_pgo
WHERE   (a.cnsctvo_cdgo_estdo_pgo  = @lnEstadoPago OR  a.cnsctvo_cdgo_estdo_pgo = 2) 
AND 	(r.cnsctvo_cdgo_tps_dcmnto = @Tipo_documento_pac)

--SELECT CONVERT(CHAR(10),fcha_fn_prcso,111) FROM TBPROCESOSCARTERAPAC
  
Update #TmpPagos
Set	nmbre_scrsl			=	b.nmbre_scrsl,
	cdgo_tpo_idntfccn		=	f.cdgo_tpo_idntfccn, 		
	nmro_idntfccn			=	d.nmro_idntfccn, 	
 	dscrpcn_clse_aprtnte		=	i.dscrpcn_clse_aprtnte,	
	cnsctvo_cdgo_tpo_idntfccn	=	d.cnsctvo_cdgo_tpo_idntfccn,
	dgto_vrfccn			=	d.dgto_vrfccn
FROM    #TmpPagos a INNER JOIN  bdAfiliacion.dbo.tbSucursalesAportante b 
ON 	a.nmro_unco_idntfccn_empldr 	= b.nmro_unco_idntfccn_empldr 
AND 	a.cnsctvo_scrsl			= b.cnsctvo_scrsl 
AND     a.cnsctvo_cdgo_clse_aprtnte 	= b.cnsctvo_cdgo_clse_aprtnte 
	INNER JOIN bdAfiliacion.dbo.tbVinculados d 
ON 	a.nmro_unco_idntfccn_empldr 	= d.nmro_unco_idntfccn 
	INNER JOIN bdAfiliacion.dbo.tbTiposIdentificacion f 
ON 	d.cnsctvo_cdgo_tpo_idntfccn 	= f.cnsctvo_cdgo_tpo_idntfccn 
	INNER JOIN bdAfiliacion.dbo.tbClasesAportantes i 
ON 	b.cnsctvo_cdgo_clse_aprtnte 	= i.cnsctvo_cdgo_clse_aprtnte


Update 	#TmpPagos
Set	 rzn_scl	 		=  c.rzn_scl
FROM	#TmpPagos a INNER JOIN 	bdAfiliacion.dbo.tbEmpleadores b 
ON 	a.nmro_unco_idntfccn_empldr 	= b.nmro_unco_idntfccn 
AND     a.cnsctvo_cdgo_clse_aprtnte 	= b.cnsctvo_cdgo_clse_aprtnte INNER JOIN
        bdAfiliacion.dbo.tbEmpresas c 
ON 	a.nmro_unco_idntfccn_empldr 	= c.nmro_unco_idntfccn


Update 	#TmpPagos
Set	rzn_scl	 =   ltrim(rtrim(isnull(prmr_aplldo,'')))  + ' ' + ltrim(rtrim(isnull(sgndo_aplldo,''))) + ' ' + ltrim(rtrim(isnull(prmr_nmbre,''))) + ' ' + ltrim(rtrim(isnull(sgndo_nmbre,'')))
FROM	#TmpPagos a INNER JOIN
	bdAfiliacion.dbo.tbEmpleadores b ON a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn AND 
	a.cnsctvo_cdgo_clse_aprtnte = b.cnsctvo_cdgo_clse_aprtnte INNER JOIN
	bdAfiliacion.dbo.tbPersonas c ON a.nmro_unco_idntfccn_empldr = c.nmro_unco_idntfccn
WHERE	(rzn_scl = '')


update 	#TmpPagos
set   fcha_fn_prcso =  CONVERT(CHAR(10),b.fcha_fn_prcso,111) 
FROM  	#TmpPagos a  INNER JOIN tbProcesosCarteraPac b
On	a.cnsctvo_prcso=b.cnsctvo_prcso


-- Buasca el valor del IVA
SELECT cnsctvo_cdgo_pgo,sum(cuenta) cuenta,sum(iva) iva
into #ValorIva
FROM (
select a.cnsctvo_cdgo_pgo,sum(vlr_abno_cta) cuenta,sum(vlr_abno_iva) iva
from tbabonoscontrato a,#TmpPagos
where a.cnsctvo_cdgo_pgo = #TmpPagos.cnsctvo_cdgo_pgo
group by  a.cnsctvo_cdgo_pgo
union
select a.cnsctvo_cdgo_pgo,sum(vlr_nta_cta) cuenta,sum(vlr_nta_iva) iva
from dbo.TbAbonosNotasContrato a,#TmpPagos
where a.cnsctvo_cdgo_pgo = #TmpPagos.cnsctvo_cdgo_pgo
group by  a.cnsctvo_cdgo_pgo
) dato
group by  cnsctvo_cdgo_pgo  


update 	#TmpPagos
set   vlr_ants_iva = a.cuenta,
	  vlr_iva      = a.iva
FROM  #ValorIva a
WHERE a.cnsctvo_cdgo_pgo = #TmpPagos.cnsctvo_cdgo_pgo



Select  a.cnsctvo_cdgo_pgo,		a.dscrpcn_estdo_pgo,		a.dscrpcn_tpo_pgo,
	a.vlr_dcmnto,			a.cdgo_tpo_idntfccn, 		a.nmro_idntfccn,
	a.dscrpcn_clse_aprtnte,		a.nmbre_scrsl,			a.rzn_scl,
	convert(char(20),replace(convert(char(20),a.fcha_rcdo,120),'-','/'))	fcha_rcdo,  
	CONVERT(CHAR(10),a.fcha_fn_prcso,111)  fcha_intrfse,
	CONVERT(CHAR(10),a.fcha_aplcn,111)  fcha_aplcn,
	a.nmro_rmsa,			a.nmro_lna,			a.nmro_dcmnto,
	a.usro_crcn,			a.cnsctvo_cdgo_estdo_pgo,	a.cnsctvo_cdgo_tpo_pgo,
	a.nmro_unco_idntfccn_empldr,	a.cnsctvo_scrsl,		a.cnsctvo_cdgo_clse_aprtnte,
	a.dgto_vrfccn,vlr_ants_iva,vlr_iva
From	#TmpPagos a
