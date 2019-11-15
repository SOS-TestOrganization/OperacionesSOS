
/*---------------------------------------------------------------------------------
* Metodo o PRG 		:  SpConsultaSaldoContrato
* Desarrollado por		: <\A Ing. Rolando simbaqueva lasso									A\>
* Descripcion			: <\D Este procedimiento realiza una busqueda de loscontratos del responsable de un estado de cuenta donde ya existe el contrato			  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P  													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003/02/05 											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  Rolando Simbaqueva LassoAM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM 2003/03/25	 FM\>
*---------------------------------------------------------------------------------*/
CREATE  PROCEDURE SpConsultaSaldoContratoAnterior
	@lnnmro_unco_idntfccn_afldo			udtConsecutivo,
	@lnValorTotalCotizante				numeric(12,0) output
		
As	
Set Nocount On


select 	a.nmro_cntrto ,	inco_vgnca_cntrto ,

	fn_vgnca_cntrto ,
	convert(numeric(12,0),0)	valor_couta_cobranza,
	 dscrpcn_pln,
	space(30)	dscrpcn_frma_pgo,
	convert(numeric(12,0),0)	sldo_cntrto,
	space(3)	cdgo_tpo_idntfccn,
	space(15)	nmro_idntfccn,
	space(200)	nmbre_scrsl,
	0	nmro_unco_idntfccn_aprtnte ,
	0	cnsctvo_cdgo_clse_aprtnte,
	0	cnsctvo_scrsl_ctznte,
	a.cnsctvo_cdgo_tpo_cntrto,
	CASE WHEN getdate() between  inco_vgnca_cntrto  and fn_vgnca_cntrto  THEN 1  ELSE  0  end  vigente,
	0	cnsctvo_cbrnza
Into	#TmpContratosXResponsable
from	bdafiliacion..tbcontratos a,
	bdplanBeneficios..tbplanes b
Where 	nmro_unco_idntfccn_afldo	=	@lnnmro_unco_idntfccn_afldo
and	a.cnsctvo_cdgo_tpo_cntrto	=	2
and	a.cnsctvo_cdgo_pln		=	b.cnsctvo_cdgo_pln

	

Update #TmpContratosXResponsable
Set	nmro_unco_idntfccn_aprtnte	=	b.nmro_unco_idntfccn_aprtnte,
	cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte,
	cnsctvo_scrsl_ctznte		=	c.cnsctvo_scrsl_ctznte,
	dscrpcn_frma_pgo		=	d.dscrpcn_frma_pgo,
	valor_couta_cobranza		=	c.cta_mnsl,
	cnsctvo_cbrnza			=	c.cnsctvo_cbrnza
From	#TmpContratosXResponsable a,
	bdafiliacion..tbcobranzas b,
	bdafiliacion..tbvigenciasCobranzas c, 
	bdafiliacion..tbFormasPago	d
Where 	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto
And	b.cnsctvo_cdgo_tpo_cntrto	=	c.cnsctvo_cdgo_tpo_cntrto
And	b.nmro_cntrto			=	c.nmro_cntrto
And	b.cnsctvo_cbrnza		=	c.cnsctvo_cbrnza
And	b.cnsctvo_cdgo_frma_cbro	=	d.cnsctvo_cdgo_frma_pgo
And	 convert(varchar(10), getdate() ,111) 	
	between convert(varchar(10),inco_vgnca_cbrnza,111)       and
	convert(varchar(10),fn_vgnca_cbrnza,111) -- que sea el siguiente del periodo a evaluar


Update #TmpContratosXResponsable
Set	nmbre_scrsl	=	b.nmbre_scrsl
From	#TmpContratosXResponsable a , bdafiliacion..TbsucursalesAportante b
Where	a.nmro_unco_idntfccn_aprtnte	=	b.nmro_unco_idntfccn_empldr
And	a.cnsctvo_scrsl_ctznte		=	b.cnsctvo_scrsl
and	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte

Update #TmpContratosXResponsable
Set	nmro_idntfccn		=	b.nmro_idntfccn,
	cdgo_tpo_idntfccn	=	c.cdgo_tpo_idntfccn
From	#TmpContratosXResponsable a , bdafiliacion..TbVinculados b ,
	bdafiliacion..tbtiposidentificacion c
Where	a.nmro_unco_idntfccn_aprtnte	=	b.nmro_unco_idntfccn
And	b.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn

Update #TmpContratosXResponsable
Set	sldo_cntrto	=	a.vlr_sldo
From	bdcarterapac..tbacumuladosContrato a , #TmpContratosXResponsable b
Where	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto
And	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_aprtnte
And	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl_ctznte
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
And	a.ultma_oprcn			=	1
--And	a.brrdo				=	'N'
and	vigente				=	1

Set	@lnValorTotalCotizante	=	0

Select 	@lnValorTotalCotizante = isnull(sum(sldo_cntrto),0)
From	#TmpContratosXResponsable

Select  * from #TmpContratosXResponsable