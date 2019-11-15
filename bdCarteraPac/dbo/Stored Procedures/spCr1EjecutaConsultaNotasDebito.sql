


/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spCr1EjecutaConsultaNotasDebito
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento arma y ejecuta la cadena donde se tiene los criterios para seleccionar las notas debito 	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003/02/10											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		 : <\AM   Ing. Sandra Milena Ruiz Reyes 	AM\>
* Descripcion			 : <\DM   Criterio numero de nota		DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM   30/08/2005				FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[spCr1EjecutaConsultaNotasDebito]
@nmro_nta_desde varchar(15), @nmro_nta_hasta varchar(15)
As
Declare
@ldfechaSistema		datetime

Set Nocount On
Set	@ldfechaSistema	=	getdate()

Create table #tmpNotasDebito(
	nmro_nta			varchar(15),
	dscrpcn_estdo_nta		udtDescripcion,
	cdgo_tpo_idntfccn		udtTipoIdentificacion,
	nmro_idntfccn			varchar(23),
	dscrpcn_clse_aprtnte		udtDescripcion,
	nmbre_scrsl			varchar(150),
	vlr_nta				udtValorGrande,	
	fcha_incl_prdo_lqdcn		datetime,
	fcha_fnl_prdo_lqdcn		datetime,
	usro_crcn			udtUsuario,
	nmro_unco_idntfccn_empldr	udtConsecutivo,
	cnsctvo_scrsl			udtConsecutivo, 			
	cnsctvo_cdgo_clse_aprtnte	udtConsecutivo,
	vlr_iva				udtValorGrande,
	sldo_nta			udtValorGrande,	
	dscrpcn_tpo_idntfccn		udtDescripcion,			
	rzn_scl				varchar(200),	
	cnsctvo_cdgo_tpo_idntfccn	int,	
	cnsctvo_cdgo_tpo_nta		udtConsecutivo,	
	cnsctvo_cdgo_estdo_nta		udtConsecutivo,	
	fcha_crcn			datetime	
)

Insert into #tmpNotasDebito	
SELECT  a.nmro_nta,			e.dscrpcn_estdo_nta,		f.cdgo_tpo_idntfccn,
 	d.nmro_idntfccn, 		i.dscrpcn_clse_aprtnte,		b.nmbre_scrsl,			
	a.vlr_nta, 			h.fcha_incl_prdo_lqdcn,		h.fcha_fnl_prdo_lqdcn,
	a.usro_crcn,			a.nmro_unco_idntfccn_empldr, 	a.cnsctvo_scrsl, 
	a.cnsctvo_cdgo_clse_aprtnte, 	a.vlr_iva, 			a.sldo_nta,
	f.dscrpcn_tpo_idntfccn,		SPACE(200), 			d.cnsctvo_cdgo_tpo_idntfccn, 
	a.cnsctvo_cdgo_tpo_nta,		a.cnsctvo_cdgo_estdo_nta,	a.fcha_crcn_nta	fcha_crcn
FROM    bdCarteraPac.dbo.tbNotasPac a INNER JOIN
	bdAfiliacion.dbo.tbSucursalesAportante b 			ON 	a.nmro_unco_idntfccn_empldr 	= b.nmro_unco_idntfccn_empldr 
								AND 	a.cnsctvo_scrsl = b.cnsctvo_scrsl 
								AND 	a.cnsctvo_cdgo_clse_aprtnte 	= b.cnsctvo_cdgo_clse_aprtnte INNER JOIN
      	bdAfiliacion.dbo.tbVinculados d 	      			ON 	a.nmro_unco_idntfccn_empldr 	= d.nmro_unco_idntfccn INNER JOIN
      	bdAfiliacion.dbo.tbTiposIdentificacion f 		ON 	d.cnsctvo_cdgo_tpo_idntfccn 	= f.cnsctvo_cdgo_tpo_idntfccn INNER JOIN
      	bdCarteraPac.dbo.tbPeriodosliquidacion_Vigencias h 	ON 	a.cnsctvo_prdo 			= h.cnsctvo_cdgo_prdo_lqdcn INNER JOIN
      	bdAfiliacion.dbo.tbClasesAportantes i 			ON 	b.cnsctvo_cdgo_clse_aprtnte 	= i.cnsctvo_cdgo_clse_aprtnte INNER JOIN
      	bdCarteraPac.dbo.tbEstadosNota e 			ON 	a.cnsctvo_cdgo_estdo_nta 	= e.cnsctvo_cdgo_estdo_nta  
WHERE   @ldfechaSistema	between	h.inco_vgnca	and	h.fn_vgnca
And 	a.nmro_nta >= @nmro_nta_desde And a.nmro_nta <= @nmro_nta_hasta
and	a.cnsctvo_cdgo_tpo_nta		=	1   -- nota debito
And	a.usro_crcn 			!=	'Migracion01'



Update 	#tmpNotasDebito
Set	rzn_scl	 =  c.rzn_scl
From 	#tmpNotasDebito	 a,	bdAfiliacion.dbo.tbempleadores b,	bdAfiliacion.dbo.tbempresas c 
Where	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte 
And	a.nmro_unco_idntfccn_empldr	=	c.nmro_unco_idntfccn


Update 	#tmpNotasDebito
Set	 rzn_scl	 =   ltrim(rtrim(isnull(prmr_aplldo,'')))  + ' ' + ltrim(rtrim(isnull(sgndo_aplldo,''))) + ' ' + ltrim(rtrim(isnull(prmr_nmbre,''))) + ' ' + ltrim(rtrim(isnull(sgndo_nmbre,'')))
From 	#tmpNotasDebito	 a	, bdAfiliacion.dbo.tbempleadores b,	bdAfiliacion.dbo.tbpersonas c
Where	a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn
And	a.cnsctvo_cdgo_clse_aprtnte		=	b.cnsctvo_cdgo_clse_aprtnte 
And	a.nmro_unco_idntfccn_empldr		=	c.nmro_unco_idntfccn
And	rzn_scl=''



SELECT  nmro_nta,	 	dscrpcn_estdo_nta,		cdgo_tpo_idntfccn, 	nmro_idntfccn, 			
	dscrpcn_clse_aprtnte,	nmbre_scrsl, 			rzn_scl,		vlr_nta, 
        fcha_incl_prdo_lqdcn,	fcha_fnl_prdo_lqdcn, 		usro_crcn,		nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl, 		cnsctvo_cdgo_clse_aprtnte, 	vlr_iva, 	        sldo_nta,
	dscrpcn_tpo_idntfccn,   cnsctvo_cdgo_tpo_idntfccn,      cnsctvo_cdgo_tpo_nta,	cnsctvo_cdgo_estdo_nta, 
	fcha_crcn 
From   #tmpNotasDebito a

  





