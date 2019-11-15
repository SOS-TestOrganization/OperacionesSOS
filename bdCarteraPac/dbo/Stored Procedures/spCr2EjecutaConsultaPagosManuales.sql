



/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spCr2EjecutaConsultaPagosManuales
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
* Modificado Por		 : <\AM   Ing. Sandra Milena Ruiz Reyes 	    AM\>
* Descripcion			 : <\DM   Criterio numero del estado de cuenta 	    DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM   26/08/2005				    FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[spCr2EjecutaConsultaPagosManuales]
@cnsctvo_cdgo_estdo_pgo_desde int, @cnsctvo_cdgo_estdo_pgo_hasta int
As

Set Nocount On

Create table #tmp1(
	cnsctvo_cdgo_pgo		udtConsecutivo,
	dscrpcn_estdo_pgo		udtDescripcion,
	dscrpcn_tpo_pgo			udtDescripcion,
	cdgo_tpo_idntfccn		udtTipoIdentificacion,
	nmro_idntfccn			udtNumeroIdentificacion,
	dscrpcn_clse_aprtnte		udtDescripcion,
	nmbre_scrsl			varchar(200),
	vlr_dcmnto			udtValorGrande,
	fcha_rcdo			datetime,
	nmro_unco_idntfccn_empldr	udtConsecutivo,
	cnsctvo_scrsl			udtConsecutivo,
	cnsctvo_cdgo_clse_aprtnte	udtConsecutivo,
	dscrpcn_tpo_idntfccn		varchar(30),
	rzn_scl				varchar(200),
	cnsctvo_cdgo_tpo_idntfccn	udtConsecutivo, 
	cnsctvo_cdgo_estdo_pgo		udtConsecutivo,
	cnsctvo_cdgo_tpo_pgo		udtConsecutivo,
	dgto_vrfccn			int,
	nmro_rmsa			int,
	nmro_lna			int,
	nmro_dcmnto			udtNumeroFormulario,	
	usro_crcn			udtUsuario,
	sldo_pgo	  		udtValorGrande,
	accn				varchar(50)
)

Insert into #tmp1
SELECT		a.cnsctvo_cdgo_pgo,			e.dscrpcn_estdo_pgo,			t.dscrpcn_tpo_pgo,
		b.tpo_idntfccn  cdgo_tpo_idntfccn, 	b.nmro_idntfccn, 			space(30),
	        b.rzn_scl,				a.vlr_dcmnto,				a.fcha_rcdo,
		a.nmro_unco_idntfccn_empldr,		a.cnsctvo_scrsl,			a.cnsctvo_cdgo_clse_aprtnte,
		space(30),				b.rzn_scl,	 			0, 
		a.cnsctvo_cdgo_estdo_pgo,
		a.cnsctvo_cdgo_tpo_pgo,
		0,
		a.nmro_rmsa,
		a.nmro_lna,
		a.nmro_dcmnto,	
		a.usro_crcn,
		a.sldo_pgo	 ,
		'SELECCIONADO'
FROM		bdCarteraPac.dbo.tbpagos	 	a  	INNER JOIN  
                bdadmonrecaudo.dbo.tbrecaudoconciliado  b 	ON 	a.cnsctvo_rcdo_cncldo 	= b.cnsctvo_rcdo_cncldo  INNER JOIN
                bdCarteraPac.dbo.tbestadospago 		e 	ON 	a.cnsctvo_cdgo_estdo_pgo= e.cnsctvo_cdgo_estdo_pgo  INNER JOIN
	        bdCarteraPac.dbo.tbTipospago      	T	ON	a.cnsctvo_cdgo_tpo_pgo	= t.cnsctvo_cdgo_tpo_pgo	
where	 	a.cnsctvo_cdgo_estdo_pgo >= @cnsctvo_cdgo_estdo_pgo_desde
And 		a.cnsctvo_cdgo_estdo_pgo <= @cnsctvo_cdgo_estdo_pgo_hasta
And		b.cnsctvo_cdgo_tps_dcmnto	=	2


UPDATE #tmp1
SET 	accn 	= 	'NO SELECCIONADO'
FROM  #tmp1 a, bdafiliacion.dbo.tbvinculados b 
Where   ltrim(rtrim(a.nmro_idntfccn)) 	 =  ltrim(rtrim(b.nmro_idntfccn))


update	#tmp1
Set	nmbre_scrsl			=	b.nmbre_scrsl
From	#tmp1 a		Inner join	
	bdAfiliacion.dbo.tbSucursalesAportante b	
On 	a.nmro_unco_idntfccn_empldr 	= 	b.nmro_unco_idntfccn_empldr 
AND	a.cnsctvo_scrsl 		= 	b.cnsctvo_scrsl 
AND	a.cnsctvo_cdgo_clse_aprtnte 	= 	b.cnsctvo_cdgo_clse_aprtnte

update  #tmp1
Set	cdgo_tpo_idntfccn		=	f.cdgo_tpo_idntfccn ,
	nmro_idntfccn			=	d.nmro_idntfccn,
	dscrpcn_clse_aprtnte		=	i.dscrpcn_clse_aprtnte,
	cnsctvo_cdgo_tpo_idntfccn	=	f.cnsctvo_cdgo_tpo_idntfccn	
FROM    #tmp1 a INNER JOIN
      	bdAfiliacion.dbo.tbVinculados d ON a.nmro_unco_idntfccn_empldr = d.nmro_unco_idntfccn INNER JOIN
      	bdAfiliacion.dbo.tbTiposIdentificacion f ON d.cnsctvo_cdgo_tpo_idntfccn = f.cnsctvo_cdgo_tpo_idntfccn INNER JOIN
      	bdAfiliacion.dbo.tbClasesAportantes i ON a.cnsctvo_cdgo_clse_aprtnte = i.cnsctvo_cdgo_clse_aprtnte

Update 	#tmp1
Set	rzn_scl	 =  c.rzn_scl
FROM    #tmp1 a INNER JOIN


        bdAfiliacion.dbo.tbEmpleadores b ON a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn AND 
     	a.cnsctvo_cdgo_clse_aprtnte = b.cnsctvo_cdgo_clse_aprtnte INNER JOIN
	bdAfiliacion.dbo.tbEmpresas c ON a.nmro_unco_idntfccn_empldr = c.nmro_unco_idntfccn


Update 	#tmp1
Set	rzn_scl	 =   ltrim(rtrim(isnull(prmr_aplldo,'')))  + ' ' + ltrim(rtrim(isnull(sgndo_aplldo,''))) + ' ' + ltrim(rtrim(isnull(prmr_nmbre,''))) + ' ' + ltrim(rtrim(isnull(sgndo_nmbre,'')))
FROM    #tmp1 a INNER JOIN
        bdAfiliacion.dbo.tbEmpleadores b ON a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn AND 
        a.cnsctvo_cdgo_clse_aprtnte = b.cnsctvo_cdgo_clse_aprtnte INNER JOIN
        bdAfiliacion.dbo.tbPersonas c ON a.nmro_unco_idntfccn_empldr = c.nmro_unco_idntfccn
WHERE   (rzn_scl = '')


Select  a.cnsctvo_cdgo_pgo,	 	a.cdgo_tpo_idntfccn, 		a.nmro_idntfccn, 
	a.dscrpcn_clse_aprtnte,		a.nmbre_scrsl,			vlr_dcmnto ,
	convert(char(20),replace(convert(char(20),a.fcha_rcdo,120), '-' , '/'  )) fcha_rcdo, 	
	a.nmro_dcmnto,			a.dscrpcn_estdo_pgo,	 a.accn,	' Pago '	Tipo_documento,	
	a.usro_crcn,			a.dscrpcn_tpo_pgo, 		a.nmro_rmsa,
	a.nmro_lna,			a.cnsctvo_cdgo_estdo_pgo,	a.cnsctvo_cdgo_tpo_pgo,
        a.nmro_unco_idntfccn_empldr, 	a.cnsctvo_scrsl, 		a.cnsctvo_cdgo_clse_aprtnte, 	  	dgto_vrfccn,
	a.sldo_pgo,			a.rzn_scl
	
From	#tmp1 a



