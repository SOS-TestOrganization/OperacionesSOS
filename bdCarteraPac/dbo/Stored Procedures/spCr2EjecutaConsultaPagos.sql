



/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spCr2EjecutaConsultaPagos
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento arma y ejecuta la cadena donde se tiene los criterios para seleccionar los pagos  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003/02/10											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		 : <\AM   Ing. Sandra Milena Ruiz Reyes 	AM\>
* Descripcion			 : <\DM   Criterio tipo de pago			DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM   25/08/2005				FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[spCr2EjecutaConsultaPagos]
@tipoPago		udtConsecutivo

As
Set Nocount On

Create table #TmpPagos(
	cnsctvo_cdgo_pgo		udtConsecutivo,
	nmro_dcmnto			udtNumeroFormulario,
	vlr_dcmnto			udtValorGrande,
	nmro_unco_idntfccn_empldr	udtConsecutivo,
	cnsctvo_scrsl			udtConsecutivo,
	cnsctvo_cdgo_clse_aprtnte	udtConsecutivo,
	fcha_rcdo			datetime,
	nmro_rmsa			int,
	nmro_lna			int,
	cnsctvo_cdgo_estdo_pgo		udtConsecutivo,
	cnsctvo_cdgo_tpo_pgo		udtConsecutivo,
	usro_crcn			udtUsuario,
	sldo_pgo			udtValorGrande,
	rzn_scl				varchar(200),
dscrpcn_sde_crtra varchar(200)
)


Insert into #TmpPagos
Select		cnsctvo_cdgo_pgo,
		nmro_dcmnto,
		vlr_dcmnto,
		0,
		0,
		0,
		fcha_rcdo,
		nmro_rmsa,
		nmro_lna,
		cnsctvo_cdgo_estdo_pgo,  
		cnsctvo_cdgo_tpo_pgo,
		usro_crcn,
		sldo_pgo,
		space(200)	,
       space(200)
From		bdCarteraPac.dbo.tbPagos  
Where		cnsctvo_cdgo_tpo_pgo=@tipoPago


Update 		#TmpPagos 
Set		nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr,
		cnsctvo_scrsl			=	b.cnsctvo_scrsl,
		cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
From		#TmpPagos   a1 inner join   bdCarteraPac.dbo.TbEstadoscuenta  b
On		a1.nmro_dcmnto			=	b.nmro_estdo_cnta


Update 		#TmpPagos
Set		nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr,
		cnsctvo_scrsl			=	b.cnsctvo_scrsl,
		cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
From		#TmpPagos   a2 inner join  bdCarteraPac.dbo.tbcuentasmanuales  b
On		a2.nmro_dcmnto			=	b.nmro_estdo_cnta

Update 		#tmpPagos
Set	 	rzn_scl	 =  c.rzn_scl
From 		#tmpPagos a3 inner join 
		bdAfiliacion.dbo.tbempleadores b
		
On 		a3.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn
And 		a3.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte 
		inner join bdAfiliacion.dbo.tbempresas c 
On		a3.nmro_unco_idntfccn_empldr	=	c.nmro_unco_idntfccn

Update		#tmpPagos
Set	 	rzn_scl	 =   ltrim(rtrim(isnull(c.prmr_aplldo,'')))  + ' ' + ltrim(rtrim(isnull(c.sgndo_aplldo,''))) + ' ' + ltrim(rtrim(isnull(c.prmr_nmbre,''))) + ' ' + ltrim(rtrim(isnull(c.sgndo_nmbre,'')))
From 		#tmpPagos a4 
		inner join bdAfiliacion.dbo.tbempleadores b		
On		a4.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn
And		a4.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte 
		inner join bdAfiliacion.dbo.tbpersonas c
On		a4.nmro_unco_idntfccn_empldr	=	c.nmro_unco_idntfccn
And		a4.rzn_scl=''

update a
set a.dscrpcn_sde_crtra=s.dscrpcn_sde
from  bdAfiliacion.dbo.tbSucursalesAportante b inner join #tmpPagos a 
ON 	a.nmro_unco_idntfccn_empldr 	= b.nmro_unco_idntfccn_empldr 
AND 	a.cnsctvo_scrsl 		= b.cnsctvo_scrsl 
AND    	a.cnsctvo_cdgo_clse_aprtnte 	= b.cnsctvo_cdgo_clse_aprtnte
inner join bdafiliacion.dbo.tbsedes s
on b.sde_crtra_pc = s.cnsctvo_cdgo_sde




Select  a.cnsctvo_cdgo_pgo,		e.dscrpcn_estdo_pgo,	t.dscrpcn_tpo_pgo , 		a.vlr_dcmnto,		
	f.cdgo_tpo_idntfccn, 		d.nmro_idntfccn, 	i.dscrpcn_clse_aprtnte,		b.nmbre_scrsl,			
	a.rzn_scl,			
	convert(char(20),replace(convert(char(20),a.fcha_rcdo,120), '-','/')) fcha_rcdo,
	a.nmro_rmsa,			a.nmro_lna,		a.nmro_dcmnto,			a.usro_crcn,
	a.cnsctvo_cdgo_estdo_pgo,	a.cnsctvo_cdgo_tpo_pgo, a.nmro_unco_idntfccn_empldr, 	a.cnsctvo_scrsl, 
	a.cnsctvo_cdgo_clse_aprtnte,  	d.dgto_vrfccn, 		a.sldo_pgo	, a.dscrpcn_sde_crtra
FROM    #TmpPagos a INNER JOIN
                      bdAfiliacion.dbo.tbSucursalesAportante b 	ON 	a.nmro_unco_idntfccn_empldr 	= b.nmro_unco_idntfccn_empldr AND a.cnsctvo_scrsl = b.cnsctvo_scrsl AND
		   						    	a.cnsctvo_cdgo_clse_aprtnte 	= b.cnsctvo_cdgo_clse_aprtnte INNER JOIN
		      bdAfiliacion.dbo.tbVinculados d 	      	ON 	a.nmro_unco_idntfccn_empldr 	= d.nmro_unco_idntfccn INNER JOIN
                      bdAfiliacion.dbo.tbTiposIdentificacion f 	ON 	d.cnsctvo_cdgo_tpo_idntfccn 	= f.cnsctvo_cdgo_tpo_idntfccn INNER JOIN
                      bdAfiliacion.dbo.tbClasesAportantes i 	ON 	b.cnsctvo_cdgo_clse_aprtnte 	= i.cnsctvo_cdgo_clse_aprtnte INNER JOIN
                      bdCarteraPac.dbo.tbestadospago e 		ON 	a.cnsctvo_cdgo_estdo_pgo 	= e.cnsctvo_cdgo_estdo_pgo  INNER JOIN
	              bdCarteraPac.dbo.tbTipospago      T	ON	a.cnsctvo_cdgo_tpo_pgo		= t.cnsctvo_cdgo_tpo_pgo	







