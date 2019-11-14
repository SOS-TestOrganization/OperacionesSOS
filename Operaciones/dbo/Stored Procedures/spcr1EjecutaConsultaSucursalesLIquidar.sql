
/*---------------------------------------------------------------------------------
* Metodo o PRG 			: spcr1EjecutaConsultaSucursalesLIquidar
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso		A\>
* Descripcion			: <\D Este procedimiento arma y ejecuta la cadena donde se 
							tiene los criterios para seleccionar los promotores y 
							sus sucursales 	D\>
* Observaciones			: <\O  	O\>
* Parametros			: <\P	P\>
* Variables				: <\V  	V\>
* Fecha Creacion		: <\FC 2003/02/10	FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM  Ing. Rolando Simbaqueva Lasso AM\>
* Descripcion			: <\DM Aplicar tecnicas de optimizacion  DM\>
* Nuevos Parametros		: <\PM Empleador PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion	: <\FM  2005/08/24 FM\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM  Francisco E. Riaño L - Qvision S.A AM\>
* Descripcion			: <\DM se quita la validacion de contratos activos y se pasa 
							al momento de guardar la liquidacion  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion	: <\FM  2019-10-17 FM\>
*---------------------------------------------------------------------------------

*/
CREATE  PROCEDURE [dbo].[spcr1EjecutaConsultaSucursalesLIquidar] (
		@Nui	int
)
As
Begin
	Set Nocount On;

	create table  #tmpcobranzas
	(	
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20),
		cnsctvo_cbrnza				int,
		nmro_unco_idntfccn_aprtnte	int,
		cnsctvo_cdgo_clse_aprtnte	int
	)

	create table  #tmpContratosActivospac
	(
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20)
	)

	create table #tmpVigenciasCobranzas
	(
		cnsctvo_vgnca_cbrnza		int,
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					varchar(20),
		cnsctvo_cbrnza				int,
		cnsctvo_scrsl_ctznte		int
	)

	create table #TmpSucursalesContratosPac
	(
		nmro_unco_idntfccn_aprtnte	int,
		cnsctvo_scrsl_ctznte		int,
		cnsctvo_cdgo_clse_aprtnte	int
	 )


	insert into #tmpcobranzas
	Select		cnsctvo_cdgo_tpo_cntrto,
				nmro_cntrto,
				cnsctvo_cbrnza,
				nmro_unco_idntfccn_aprtnte,
				cnsctvo_cdgo_clse_aprtnte
	From		bdafiliacion.dbo.tbcobranzas a with(nolock)
	Where		a.cnsctvo_cdgo_tpo_cntrto	=	2
	And			nmro_unco_idntfccn_aprtnte	=	@Nui


	insert into #tmpContratosActivospac
	Select		a.cnsctvo_cdgo_tpo_cntrto,
				a.nmro_cntrto
	From   		bdafiliacion.dbo.tbcontratos  a with(nolock)
	inner join	#tmpcobranzas b
		on		(a.cnsctvo_cdgo_tpo_cntrto =  b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto		  =  b.nmro_cntrto)	
	where		a.cnsctvo_cdgo_tpo_cntrto = 	2
	--And			a.estdo_cntrto		  =	'A'

	insert into #tmpVigenciasCobranzas
	Select		a.cnsctvo_vgnca_cbrnza,
				a.cnsctvo_cdgo_tpo_cntrto,
				a.nmro_cntrto,
				a.cnsctvo_cbrnza,
				a.cnsctvo_scrsl_ctznte
	from 		bdafiliacion.dbo.tbVigenciasCobranzas a with(nolock)
	inner join  #tmpcobranzas b
		on		(a.cnsctvo_cdgo_tpo_cntrto =  b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto		  =  b.nmro_cntrto)
	where 		a.cnsctvo_cdgo_tpo_cntrto 	=	 2


	--Se traen las sucursales de planes complementearios  asociados a los contratos activos de pac
	insert into #TmpSucursalesContratosPac
	select		b.nmro_unco_idntfccn_aprtnte,      
				c.cnsctvo_scrsl_ctznte,	
				b.cnsctvo_cdgo_clse_aprtnte
	From 		#tmpContratosActivospac  a 
	inner join 	#tmpcobranzas  b
		on		(a.cnsctvo_cdgo_tpo_cntrto 	= b.cnsctvo_cdgo_tpo_cntrto
		And 	a.nmro_cntrto		  	= b.nmro_cntrto) 
	inner join 	#tmpVigenciasCobranzas c 
		on		(c.cnsctvo_cdgo_tpo_cntrto 	= b.cnsctvo_cdgo_tpo_cntrto
		And		c.nmro_cntrto		  	= b.nmro_cntrto
		And		c.cnsctvo_cbrnza	 	= b.cnsctvo_cbrnza)
	Where		a.cnsctvo_cdgo_tpo_cntrto 	=	2	
	Group by    b.nmro_unco_idntfccn_aprtnte,   c.cnsctvo_scrsl_ctznte,	b.cnsctvo_cdgo_clse_aprtnte

	--Se cruzan los contratos asociados a las sucursales y se traer las sucursales finales para liquidar

	-- se crea la tabla temporal con la infromacion de las sucursales que s epuedan liquidar
	SELECT		b.cnsctvo_scrsl,			 
				a.cdgo_tpo_idntfccn, 		
				d.nmro_idntfccn,		 
				c.dscrpcn_clse_aprtnte, 
				b.nmbre_scrsl, 			 
				' NO SELECCIONADO'  accn ,
				b.sde_crtra_pc	cnsctvo_cdgo_sde , 
				a.dscrpcn_tpo_idntfccn,		
				b.nmbre_scrsl AS rzn_scl, 
				d.cnsctvo_cdgo_tpo_idntfccn,		 
				b.nmro_unco_idntfccn_empldr, 
				b.cnsctvo_cdgo_clse_aprtnte
	From		bdAfiliacion.dbo.tbTiposIdentificacion a with(nolock)
	INNER JOIN  bdAfiliacion.dbo.tbVinculados d with(nolock)
		ON		a.cnsctvo_cdgo_tpo_idntfccn = d.cnsctvo_cdgo_tpo_idntfccn
	INNER JOIN  bdAfiliacion.dbo.tbSucursalesAportante b with(nolock)
		ON		d.nmro_unco_idntfccn = b.nmro_unco_idntfccn_empldr
	INNER JOIN	#TmpSucursalesContratosPac    e
		On		e.nmro_unco_idntfccn_aprtnte =	b.nmro_unco_idntfccn_empldr	
		And     e.cnsctvo_scrsl_ctznte	=  	b.cnsctvo_scrsl			
		And     e.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte		
	INNER JOIN  bdAfiliacion.dbo.tbClasesAportantes c with(nolock)
		ON		b.cnsctvo_cdgo_clse_aprtnte = c.cnsctvo_cdgo_clse_aprtnte
end
