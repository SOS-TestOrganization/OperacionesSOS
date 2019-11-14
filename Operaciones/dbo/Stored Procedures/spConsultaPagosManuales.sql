


/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spConsultaPagosManuales
* Desarrollado por		: <\A Ing. ROLANDO SIMBAQUEVA LASSO								A\>
* Descripcion			: <\D Este procedimiento realiza la consulta de los pagos						  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P 													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/02 	
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM   Ing. Sandra Milena Ruiz Reyes 		AM\>
* Descripcion			: <\DM   Aplicacion de tecnicas de optimizacion	DM\>
* Nuevos Parametros	 	: <\PM   PM\>
* Nuevas Variables		: <\VM   VM\>
* Fecha Modificacion		: <\FM   12/09/2005					FM\>


* Modificado Por		: <\AM   Ing.Diana Lorena Gomez		AM\>
* Descripcion			: <\DM   Se cambia el criterio del estado del pago para que no traiga los estados mayores a Aplicado Total	DM\>
* Nuevos Parametros	 	: <\PM   PM\>
* Nuevas Variables		: <\VM   VM\>
* Fecha Modificacion		: <\FM   12/07/2009					FM\>
*---------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[spConsultaPagosManuales] @lnEstadoPago		udtConsecutivo
As  		

begin

declare
@Tipo_documento_pac	int	

set nocount on			

Create table #tmpPagos(
	tpo_dcmnto				varchar(50),
	cnsctvo_cdgo_pgo		int,
	nmro_dcmnto			udtNumeroFormulario,
	vlr_dcmnto			udtValorGrande,
	nmro_unco_idntfccn_empldr	int,
	cnsctvo_scrsl			int,
	cnsctvo_cdgo_clse_aprtnte	int,
	fcha_rcdo			datetime,	
	nmro_rmsa			int,
	nmro_lna			udtConsecutivo,
	cnsctvo_cdgo_estdo_pgo		int,
	cnsctvo_cdgo_tpo_pgo		int,	
	usro_crcn			udtUsuario,	
	sldo_pgo			udtValorGrande,
	dscrpcn_estdo_pgo		udtDescripcion,
	dscrpcn_tpo_pgo			udtDescripcion,
	nmbre_scrsl			varchar(200),
	nmro_idntfccn			udtNumeroIdentificacion,
	cdgo_tpo_idntfccn		udtTipoIdentificacion,
	dscrpcn_clse_aprtnte		varchar(30),
	rzn_scl				varchar(200),
	cnsctvo_cdgo_tpo_idntfccn	int,
	dgto_vrfccn			int,
	ACCN				VARCHAR(50),
	cnsctvo_cdgo_tpo_dcmnto int
)


Set	@Tipo_documento_pac	=2
	
Insert into #tmpPagos
Select		'PAGO',a.cnsctvo_cdgo_pgo,		a.nmro_dcmnto,		a.vlr_dcmnto,
		a.nmro_unco_idntfccn_empldr,	a.cnsctvo_scrsl,	a.cnsctvo_cdgo_clse_aprtnte,
		a.fcha_rcdo, 
		a.nmro_rmsa,
		a.nmro_lna,
		a.cnsctvo_cdgo_estdo_pgo,  
		a.cnsctvo_cdgo_tpo_pgo,
		a.usro_crcn,
		a.sldo_pgo,
		e.dscrpcn_estdo_pgo,
		t.dscrpcn_tpo_pgo,
		r.rzn_scl		nmbre_scrsl,
		r.nmro_idntfccn,
		r.tpo_idntfccn		cdgo_tpo_idntfccn,
		space(30)		dscrpcn_clse_aprtnte,
		SPACE(200) 		AS rzn_scl,
		0			cnsctvo_cdgo_tpo_idntfccn,
          	0			dgto_vrfccn,
		'SELECCIONADO',
		4 cnsctvo_cdgo_tpo_dcmnto
FROM	bdCarteraPac.dbo.tbPagos a with(nolock) INNER JOIN
	bdAdmonRecaudo.dbo.tbRecaudoConciliado r  with(nolock)
ON 	a.cnsctvo_rcdo_cncldo = r.cnsctvo_rcdo_cncldo INNER JOIN
        bdCarteraPac.dbo.tbestadospago e  with(nolock)
ON 	a.cnsctvo_cdgo_estdo_pgo = e.cnsctvo_cdgo_estdo_pgo INNER JOIN
        bdCarteraPac.dbo.tbTipospago T  with(nolock)
ON 	a.cnsctvo_cdgo_tpo_pgo = T.cnsctvo_cdgo_tpo_pgo
WHERE   (a.cnsctvo_cdgo_estdo_pgo < 3) 
AND 	(r.cnsctvo_cdgo_tps_dcmnto = @Tipo_documento_pac)



Insert into #tmpPagos
Select		t.dscrpcn_tpo_nta,a.nmro_nta,		a.nmro_nta,		a.vlr_nta,
		a.nmro_unco_idntfccn_empldr,	a.cnsctvo_scrsl,	a.cnsctvo_cdgo_clse_aprtnte,
		a.fcha_crcn_nta, 
		null ,
		null ,
		a.cnsctvo_cdgo_estdo_nta,  
		a.cnsctvo_cdgo_tpo_nta,
		a.usro_crcn,
		a.sldo_nta,
		e.dscrpcn_estdo_nta,
		t.dscrpcn_tpo_nta,
		null		nmbre_scrsl,
		null,
		null		cdgo_tpo_idntfccn,
		space(30)		dscrpcn_clse_aprtnte,
		SPACE(200) 		AS rzn_scl,
		0			cnsctvo_cdgo_tpo_idntfccn,
          	0			dgto_vrfccn,
		'SELECCIONADO' ,
		case when a.cnsctvo_cdgo_tpo_nta = 2 then 3 when a.cnsctvo_cdgo_tpo_nta = 7 then 7 end
FROM	bdCarteraPac.dbo.tbNotasPac a  with(nolock)
INNER JOIN bdCarteraPac.dbo.tbEstadosNota e  with(nolock)
ON 	a.cnsctvo_cdgo_estdo_nta = e.cnsctvo_cdgo_estdo_nta 
inner join BDCarteraPAC.dbo.tbTiposNotas t with(nolock) on a.cnsctvo_cdgo_tpo_nta = t.cnsctvo_cdgo_tpo_nta
WHERE   (a.cnsctvo_cdgo_estdo_nta = 1) 
and a.cnsctvo_cdgo_tpo_nta in (2,7)




/*
(a.cnsctvo_cdgo_estdo_pgo	=	@lnEstadoPago
or	a.cnsctvo_cdgo_estdo_pgo	=	2)
*/
/*
Update #TmpPagos
Set	nmbre_scrsl		=	b.nmbre_scrsl,
	cdgo_tpo_idntfccn	=	 f.cdgo_tpo_idntfccn, 		
	nmro_idntfccn		=	d.nmro_idntfccn, 	
 	dscrpcn_clse_aprtnte	=	i.dscrpcn_clse_aprtnte,	
	cnsctvo_cdgo_tpo_idntfccn =	d.cnsctvo_cdgo_tpo_idntfccn,
	dgto_vrfccn		     =	d.dgto_vrfccn

From	#TmpPagos a, bdconsulta.dbo.tbSucursalesAportante b ,
	 bdconsulta.dbo.tbVinculados d 	,     bdAfiliacion.dbo.tbClasesAportantes i 	,
	  bdAfiliacion.dbo.tbTiposIdentificacion f 	
where	a.nmro_unco_idntfccn_empldr 	= b.nmro_unco_idntfccn_empldr 
AND 	a.cnsctvo_scrsl = b.cnsctvo_scrsl 
and    	a.cnsctvo_cdgo_clse_aprtnte 	= b.cnsctvo_cdgo_clse_aprtnte 
And	a.nmro_unco_idntfccn_empldr 	= d.nmro_unco_idntfccn 
and	d.cnsctvo_cdgo_tpo_idntfccn 	= f.cnsctvo_cdgo_tpo_idntfccn 
and	b.cnsctvo_cdgo_clse_aprtnte 	= i.cnsctvo_cdgo_clse_aprtnte 
*/



UPDATE #TmpPagos
SET 	accn 	= 	'NO SELECCIONADO'
FROM  #TmpPagos a, bdafiliacion.dbo.tbvinculados b  with(nolock)
Where   ltrim(rtrim(a.nmro_idntfccn)) 	 =  ltrim(rtrim(b.nmro_idntfccn))

-- para optimizacion  de los pagos
Update	#TmpPagos
Set	nmbre_scrsl		=	b.nmbre_scrsl
FROM	#TmpPagos a INNER JOIN  bdAfiliacion.dbo.tbSucursalesAportante b  with(nolock)
ON 	a.nmro_unco_idntfccn_empldr	= b.nmro_unco_idntfccn_empldr 
AND 	a.cnsctvo_scrsl 		= b.cnsctvo_scrsl 
AND     a.cnsctvo_cdgo_clse_aprtnte	= b.cnsctvo_cdgo_clse_aprtnte


-- para optimizacion  de los pagos
Update #TmpPagos
Set	cdgo_tpo_idntfccn		=	f.cdgo_tpo_idntfccn, 		
	nmro_idntfccn			=	d.nmro_idntfccn, 	
 	dscrpcn_clse_aprtnte		=	i.dscrpcn_clse_aprtnte,	
	cnsctvo_cdgo_tpo_idntfccn 	=	d.cnsctvo_cdgo_tpo_idntfccn,
	dgto_vrfccn		     	=	d.dgto_vrfccn
FROM	#TmpPagos a INNER JOIN
        bdAfiliacion.dbo.tbVinculados d  with(nolock)
ON 	a.nmro_unco_idntfccn_empldr = d.nmro_unco_idntfccn INNER JOIN 
	bdAfiliacion.dbo.tbTiposIdentificacion f  with(nolock)
ON 	d.cnsctvo_cdgo_tpo_idntfccn = f.cnsctvo_cdgo_tpo_idntfccn INNER JOIN
        bdAfiliacion.dbo.tbClasesAportantes i  with(nolock)
ON	a.cnsctvo_cdgo_clse_aprtnte = i.cnsctvo_cdgo_clse_aprtnte
                      

Update 	#TmpPagos
Set	rzn_scl	 =  c.rzn_scl
FROM	#TmpPagos a INNER JOIN
        bdAfiliacion.dbo.tbEmpleadores b  with(nolock)
ON 	a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn 
AND     a.cnsctvo_cdgo_clse_aprtnte = b.cnsctvo_cdgo_clse_aprtnte INNER JOIN
        bdAfiliacion.dbo.tbEmpresas c  with(nolock)
ON 	a.nmro_unco_idntfccn_empldr = c.nmro_unco_idntfccn


Update 	#TmpPagos
Set	rzn_scl	 =   ltrim(rtrim(isnull(prmr_aplldo,'')))  + ' ' + ltrim(rtrim(isnull(sgndo_aplldo,''))) + ' ' + ltrim(rtrim(isnull(prmr_nmbre,''))) + ' ' + ltrim(rtrim(isnull(sgndo_nmbre,'')))
FROM	#TmpPagos a INNER JOIN
	bdAfiliacion.dbo.tbEmpleadores b  with(nolock)
ON 	a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn 
AND     a.cnsctvo_cdgo_clse_aprtnte = b.cnsctvo_cdgo_clse_aprtnte INNER JOIN
	bdAfiliacion.dbo.tbPersonas c  with(nolock)
ON 	a.nmro_unco_idntfccn_empldr = c.nmro_unco_idntfccn
WHERE	(a.rzn_scl = '')
 


Select  a.tpo_dcmnto, a.cnsctvo_cdgo_pgo,		a.cdgo_tpo_idntfccn, 		a.nmro_idntfccn, 
	a.dscrpcn_clse_aprtnte,		a.nmbre_scrsl, 				
	a.vlr_dcmnto,			convert(char(20),replace(convert(char(20),a.fcha_rcdo,120),'-','/')) fcha_rcdo,	
	a.nmro_dcmnto,			a.dscrpcn_estdo_pgo, accn,		tpo_dcmnto	Tipo_documento,
	a.usro_crcn,			a.dscrpcn_tpo_pgo, 		a.nmro_rmsa,
	a.nmro_lna,			a.cnsctvo_cdgo_estdo_pgo,	a.cnsctvo_cdgo_tpo_pgo,
	a.nmro_unco_idntfccn_empldr, 	a.cnsctvo_scrsl,		a.cnsctvo_cdgo_clse_aprtnte,
  	a.dgto_vrfccn,			a.sldo_pgo,			a.rzn_scl, a.cnsctvo_cdgo_tpo_dcmnto
From	 #TmpPagos a

end