


/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spCr1EjecutaConsultaPagos
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
* Descripcion			 : <\DM   Criterio fecha de interface		DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM   25/08/2005				FM\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		 : <\AM   Ing. Fernando Valencia E 	AM\>
* Descripcion			 : <\DM   Fecha de Proceso		DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
																				
* Fecha Modificacion		 : <\FM   02/10/2006			FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[spCr1EjecutaConsultaPagos] --'20100101', '20100130'
@fechaInterface1		datetime,
@fechaInterface2		datetime

As

Set Nocount On


Create table #TmpPagos(
	cnsctvo_cdgo_pgo		udtConsecutivo,
	dscrpcn_estdo_pgo                varchar(30),
	dscrpcn_tpo_pgo		varchar(30),
	vlr_dcmnto			udtValorGrande,
	cdgo_tpo_idntfccn		varchar(3),
	nmro_idntfccn			varchar(15),
	dscrpcn_clse_aprtnte		varchar(200),
	nmbre_scrsl			varchar(200),
	rzn_scl				varchar(200),
	fcha_rcdo			datetime,
	fcha_intrfce			datetime,
	fcha_aplccn			datetime,
	nmro_rmsa			int,
	nmro_lna			int,
	nmro_dcmnto			udtNumeroFormulario,
	usro_crcn			udtUsuario,
	cnsctvo_cdgo_estdo_pgo	udtConsecutivo,
	cnsctvo_cdgo_tpo_pgo		udtConsecutivo,
	nmro_unco_idntfccn_empldr	udtConsecutivo,
	cnsctvo_scrsl			udtConsecutivo,
	cnsctvo_cdgo_clse_aprtnte	udtConsecutivo,
	dgto_vrfccn			int,
	sldo_pgo			udtValorGrande,
	cnsctvo_prcso			int,
    dscrpcn_sde_crtra VARCHAR(200)
)


--declare @fechaInterface1 datetime 
--declare @fechaInterface2 datetime

--set @fechaInterface1='20060608'
--set @fechaInterface2='20060708'

select @fechaInterface1=@fechaInterface1+'00:00:00'
select @fechaInterface2=@fechaInterface2+'23:59:59'


Insert into #TmpPagos Select		
		a.cnsctvo_cdgo_pgo,
		space(30),
		space(30),
		a.vlr_dcmnto,
		space(3),  
		space(15), 
		space(10), 
		space(10),
		space(10), 
		a.fcha_rcdo,
		b.fcha_fn_prcso,
		a.fcha_aplccn, 
		a.nmro_rmsa,
		a.nmro_lna,
		a.nmro_dcmnto,
		a.usro_crcn, 
		a.cnsctvo_cdgo_estdo_pgo,  
		a.cnsctvo_cdgo_tpo_pgo,     
		0,
		0,
		0, 
		0,
		a.sldo_pgo,
		a.cnsctvo_prcso,
        space(150) as dscrpcn_sde_crtra
From		bdCarteraPac.dbo.tbPagos a inner join tbprocesoscarterapac b 
On 		a.cnsctvo_prcso = b.cnsctvo_prcso
where 		b.fcha_fn_prcso BETWEEN @fechaInterface1 and @fechaInterface2

--/*
update a
set nmro_unco_idntfccn_empldr= b.nmro_unco_idntfccn
from tbcuentasmanuales a
inner join 			bdAfiliacion.dbo.tbVinculados b 
on nmro_idntfccn_rspnsble_pgo = nmro_idntfccn
inner join 	  		bdAfiliacion.dbo.tbtiposidentificacion c
on a.cnsctvo_cdgo_tpo_idntfccn=c.cnsctvo_cdgo_tpo_idntfccn
where nmro_unco_idntfccn_empldr=0

update a
set nmro_unco_idntfccn_empldr= b.nmro_unco_idntfccn
from tbcuentasmanuales a
inner join 			bdAfiliacion.dbo.tbVinculados b 
on nmro_idntfccn_rspnsble_pgo = nmro_idntfccn
inner join 	  		bdAfiliacion.dbo.tbtiposidentificacion c
on a.cnsctvo_cdgo_tpo_idntfccn=c.cnsctvo_cdgo_tpo_idntfccn
where nmro_unco_idntfccn_empldr=0

--*/





Update 	#TmpPagos
Set		dscrpcn_estdo_pgo=b.dscrpcn_estdo_pgo
From		#TmpPagos   a inner join  bdCarteraPac.dbo.tbestadospago  b
On		a.cnsctvo_cdgo_estdo_pgo 	= b.cnsctvo_cdgo_estdo_pgo



Update 	#TmpPagos
Set		dscrpcn_clse_aprtnte=b.dscrpcn_clse_aprtnte 
From		#TmpPagos   a inner join   bdAfiliacion.dbo.tbClasesAportantes  b
On		a.cnsctvo_cdgo_clse_aprtnte 	= b.cnsctvo_cdgo_clse_aprtnte


Update 	#TmpPagos
Set		dscrpcn_tpo_pgo=b.dscrpcn_tpo_pgo
From		#TmpPagos   a inner join  bdCarteraPac.dbo.tbTipospago  b
On		a.cnsctvo_cdgo_tpo_pgo	= b.cnsctvo_cdgo_tpo_pgo



---------
Update 	#TmpPagos 
Set		nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr,
		cnsctvo_scrsl			=	b.cnsctvo_scrsl,
		cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
From		#TmpPagos   a1 inner join   bdCarteraPac.dbo.TbEstadoscuenta  b
On		a1.nmro_dcmnto			=	b.nmro_estdo_cnta


Update 	#TmpPagos
Set		nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr,
		cnsctvo_scrsl			=	b.cnsctvo_scrsl,
		cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
From		#TmpPagos   a2 inner join  bdCarteraPac.dbo.tbcuentasmanuales  b
On		a2.nmro_dcmnto			=	b.nmro_estdo_cnta

Update 	#tmpPagos
Set	 	rzn_scl	 =  c.rzn_scl
From 		#tmpPagos a3 inner join bdAfiliacion.dbo.tbempleadores b
On 		a3.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn
And 		a3.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte 
		inner join bdAfiliacion.dbo.tbempresas c 
On		a3.nmro_unco_idntfccn_empldr	=	c.nmro_unco_idntfccn

Update		#tmpPagos
Set	 	rzn_scl	 =   ltrim(rtrim(isnull(c.prmr_aplldo,'')))  + ' ' + ltrim(rtrim(isnull(c.sgndo_aplldo,''))) + ' ' + ltrim(rtrim(isnull(c.prmr_nmbre,''))) + ' ' + ltrim(rtrim(isnull(c.sgndo_nmbre,'')))
From 		#tmpPagos a4 inner join bdAfiliacion.dbo.tbempleadores b
On		a4.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn
And		a4.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte 
		inner join bdAfiliacion.dbo.tbpersonas c
On		a4.nmro_unco_idntfccn_empldr	=	c.nmro_unco_idntfccn
And		a4.rzn_scl=''

Update 	#TmpPagos
set		cdgo_tpo_idntfccn	=c.cdgo_tpo_idntfccn,
		nmro_idntfccn		=b.nmro_idntfccn,
		dgto_vrfccn		=b.dgto_vrfccn
From		#TmpPagos   a    	
inner join bdAfiliacion.dbo.tbVinculados b 
ON 		a.nmro_unco_idntfccn_empldr 	= b.nmro_unco_idntfccn
inner join  bdAfiliacion.dbo.tbTiposIdentificacion  c
On 		c.cnsctvo_cdgo_tpo_idntfccn 	= b.cnsctvo_cdgo_tpo_idntfccn
			

update #tmpPagos
set nmbre_scrsl=b.nmbre_scrsl
from  bdAfiliacion.dbo.tbSucursalesAportante b inner join #tmpPagos a 
ON 	a.nmro_unco_idntfccn_empldr 	= b.nmro_unco_idntfccn_empldr 
AND 	a.cnsctvo_scrsl 		= b.cnsctvo_scrsl 
AND    	a.cnsctvo_cdgo_clse_aprtnte 	= b.cnsctvo_cdgo_clse_aprtnte
                  


update a
set a.dscrpcn_sde_crtra=s.dscrpcn_sde
from  bdAfiliacion.dbo.tbSucursalesAportante b inner join #tmpPagos a 
ON 	a.nmro_unco_idntfccn_empldr 	= b.nmro_unco_idntfccn_empldr 
AND 	a.cnsctvo_scrsl 		= b.cnsctvo_scrsl 
AND    	a.cnsctvo_cdgo_clse_aprtnte 	= b.cnsctvo_cdgo_clse_aprtnte
inner join bdafiliacion.dbo.tbsedes s
on b.sde_crtra_pc = s.cnsctvo_cdgo_sde



/*
Select  a.cnsctvo_cdgo_pgo,		e.dscrpcn_estdo_pgo,	t.dscrpcn_tpo_pgo , 		a.vlr_dcmnto,		
	f.cdgo_tpo_idntfccn, 		d.nmro_idntfccn, 	i.dscrpcn_clse_aprtnte,		b.nmbre_scrsl,			
	a.rzn_scl,		
	convert(char(20),replace(convert(char(20),a.fcha_rcdo,120), '-','/')) fcha_rcdo,
	convert(char(10),a.fcha_intrfce,111),
	a.nmro_rmsa,			a.nmro_lna,		a.nmro_dcmnto,			a.usro_crcn,
	a.cnsctvo_cdgo_estdo_pgo,	a.cnsctvo_cdgo_tpo_pgo, a.nmro_unco_idntfccn_empldr, 	a.cnsctvo_scrsl, 
	a.cnsctvo_cdgo_clse_aprtnte,  	d.dgto_vrfccn, 		a.sldo_pgo	
FROM    #TmpPagos a INNER JOIN
                    bdConsulta.dbo.tbSucursalesAportante b 	ON 	a.nmro_unco_idntfccn_empldr 	= b.nmro_unco_idntfccn_empldr AND a.cnsctvo_scrsl = b.cnsctvo_scrsl AND
                						    	a.cnsctvo_cdgo_clse_aprtnte 	= b.cnsctvo_cdgo_clse_aprtnte inner   JOIN
                     bdConsulta.dbo.tbVinculados d 	      	ON 	a.nmro_unco_idntfccn_empldr 	= d.nmro_unco_idntfccn inner JOIN
                      bdAfiliacion.dbo.tbTiposIdentificacion f 	ON 	d.cnsctvo_cdgo_tpo_idntfccn 	= f.cnsctvo_cdgo_tpo_idntfccn inner JOIN
                      bdAfiliacion.dbo.tbClasesAportantes i 		ON 	b.cnsctvo_cdgo_clse_aprtnte 	= i.cnsctvo_cdgo_clse_aprtnte inner JOIN
                      bdCarteraPac.dbo.tbestadospago e 		ON 	a.cnsctvo_cdgo_estdo_pgo 	= e.cnsctvo_cdgo_estdo_pgo  inner JOIN
	           bdCarteraPac.dbo.tbTipospago      T		ON	a.cnsctvo_cdgo_tpo_pgo	= t.cnsctvo_cdgo_tpo_pgo	
*/

select 	cnsctvo_cdgo_pgo,		
	dscrpcn_estdo_pgo,                
	dscrpcn_tpo_pgo,		
	vlr_dcmnto,			
	cdgo_tpo_idntfccn,		
	nmro_idntfccn,		
	dscrpcn_clse_aprtnte,		
	nmbre_scrsl,			
	rzn_scl,				
	convert(char(10),fcha_rcdo,111)  as  fcha_rcdo ,			
	convert(char(10),fcha_intrfce,111) as fcha_intrfce,	
	convert(char(10),fcha_aplccn,111) as  fcha_aplccn,		
	nmro_rmsa,			
	nmro_lna,			
	nmro_dcmnto,			
	usro_crcn,		
	cnsctvo_cdgo_estdo_pgo,	
	cnsctvo_cdgo_tpo_pgo,		
	nmro_unco_idntfccn_empldr,	
	cnsctvo_scrsl,			
	cnsctvo_cdgo_clse_aprtnte,	
	dgto_vrfccn,			
	sldo_pgo		,
    dscrpcn_sde_crtra	
	from 	#TmpPagos order by fcha_intrfce






